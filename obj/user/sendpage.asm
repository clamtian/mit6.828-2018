
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 77 01 00 00       	call   8001a8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  80003d:	e8 eb 10 00 00       	call   80112d <fork>
  800042:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800045:	85 c0                	test   %eax,%eax
  800047:	0f 84 a5 00 00 00    	je     8000f2 <umain+0xbf>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
		return;
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80004d:	a1 08 40 80 00       	mov    0x804008,%eax
  800052:	8b 40 48             	mov    0x48(%eax),%eax
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 a0 00       	push   $0xa00000
  80005f:	50                   	push   %eax
  800060:	e8 94 0c 00 00       	call   800cf9 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800065:	83 c4 04             	add    $0x4,%esp
  800068:	ff 35 04 30 80 00    	pushl  0x803004
  80006e:	e8 01 08 00 00       	call   800874 <strlen>
  800073:	83 c4 0c             	add    $0xc,%esp
  800076:	83 c0 01             	add    $0x1,%eax
  800079:	50                   	push   %eax
  80007a:	ff 35 04 30 80 00    	pushl  0x803004
  800080:	68 00 00 a0 00       	push   $0xa00000
  800085:	e8 49 0a 00 00       	call   800ad3 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80008a:	6a 07                	push   $0x7
  80008c:	68 00 00 a0 00       	push   $0xa00000
  800091:	6a 00                	push   $0x0
  800093:	ff 75 f4             	pushl  -0xc(%ebp)
  800096:	e8 44 12 00 00       	call   8012df <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80009b:	83 c4 1c             	add    $0x1c,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	68 00 00 a0 00       	push   $0xa00000
  8000a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a8:	50                   	push   %eax
  8000a9:	e8 bd 11 00 00       	call   80126b <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8000ae:	83 c4 0c             	add    $0xc,%esp
  8000b1:	68 00 00 a0 00       	push   $0xa00000
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 20 29 80 00       	push   $0x802920
  8000be:	e8 ea 01 00 00       	call   8002ad <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8000c3:	83 c4 04             	add    $0x4,%esp
  8000c6:	ff 35 00 30 80 00    	pushl  0x803000
  8000cc:	e8 a3 07 00 00       	call   800874 <strlen>
  8000d1:	83 c4 0c             	add    $0xc,%esp
  8000d4:	50                   	push   %eax
  8000d5:	ff 35 00 30 80 00    	pushl  0x803000
  8000db:	68 00 00 a0 00       	push   $0xa00000
  8000e0:	e8 bb 08 00 00       	call   8009a0 <strncmp>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	0f 84 a3 00 00 00    	je     800193 <umain+0x160>
		cprintf("parent received correct message\n");
	return;
}
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	68 00 00 b0 00       	push   $0xb00000
  8000fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ff:	50                   	push   %eax
  800100:	e8 66 11 00 00       	call   80126b <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800105:	83 c4 0c             	add    $0xc,%esp
  800108:	68 00 00 b0 00       	push   $0xb00000
  80010d:	ff 75 f4             	pushl  -0xc(%ebp)
  800110:	68 20 29 80 00       	push   $0x802920
  800115:	e8 93 01 00 00       	call   8002ad <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80011a:	83 c4 04             	add    $0x4,%esp
  80011d:	ff 35 04 30 80 00    	pushl  0x803004
  800123:	e8 4c 07 00 00       	call   800874 <strlen>
  800128:	83 c4 0c             	add    $0xc,%esp
  80012b:	50                   	push   %eax
  80012c:	ff 35 04 30 80 00    	pushl  0x803004
  800132:	68 00 00 b0 00       	push   $0xb00000
  800137:	e8 64 08 00 00       	call   8009a0 <strncmp>
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 3e                	je     800181 <umain+0x14e>
		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	ff 35 00 30 80 00    	pushl  0x803000
  80014c:	e8 23 07 00 00       	call   800874 <strlen>
  800151:	83 c4 0c             	add    $0xc,%esp
  800154:	83 c0 01             	add    $0x1,%eax
  800157:	50                   	push   %eax
  800158:	ff 35 00 30 80 00    	pushl  0x803000
  80015e:	68 00 00 b0 00       	push   $0xb00000
  800163:	e8 6b 09 00 00       	call   800ad3 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  800168:	6a 07                	push   $0x7
  80016a:	68 00 00 b0 00       	push   $0xb00000
  80016f:	6a 00                	push   $0x0
  800171:	ff 75 f4             	pushl  -0xc(%ebp)
  800174:	e8 66 11 00 00       	call   8012df <ipc_send>
		return;
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	e9 6f ff ff ff       	jmp    8000f0 <umain+0xbd>
			cprintf("child received correct message\n");
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	68 34 29 80 00       	push   $0x802934
  800189:	e8 1f 01 00 00       	call   8002ad <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	eb b0                	jmp    800143 <umain+0x110>
		cprintf("parent received correct message\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 54 29 80 00       	push   $0x802954
  80019b:	e8 0d 01 00 00       	call   8002ad <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	e9 48 ff ff ff       	jmp    8000f0 <umain+0xbd>

008001a8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001a8:	f3 0f 1e fb          	endbr32 
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001b4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001b7:	e8 f7 0a 00 00       	call   800cb3 <sys_getenvid>
  8001bc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001c1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001c4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c9:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ce:	85 db                	test   %ebx,%ebx
  8001d0:	7e 07                	jle    8001d9 <libmain+0x31>
		binaryname = argv[0];
  8001d2:	8b 06                	mov    (%esi),%eax
  8001d4:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
  8001de:	e8 50 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001e3:	e8 0a 00 00 00       	call   8001f2 <exit>
}
  8001e8:	83 c4 10             	add    $0x10,%esp
  8001eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001fc:	e8 67 13 00 00       	call   801568 <close_all>
	sys_env_destroy(0);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	6a 00                	push   $0x0
  800206:	e8 63 0a 00 00       	call   800c6e <sys_env_destroy>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	53                   	push   %ebx
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80021e:	8b 13                	mov    (%ebx),%edx
  800220:	8d 42 01             	lea    0x1(%edx),%eax
  800223:	89 03                	mov    %eax,(%ebx)
  800225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800228:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80022c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800231:	74 09                	je     80023c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800233:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800237:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	68 ff 00 00 00       	push   $0xff
  800244:	8d 43 08             	lea    0x8(%ebx),%eax
  800247:	50                   	push   %eax
  800248:	e8 dc 09 00 00       	call   800c29 <sys_cputs>
		b->idx = 0;
  80024d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800253:	83 c4 10             	add    $0x10,%esp
  800256:	eb db                	jmp    800233 <putch+0x23>

00800258 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800258:	f3 0f 1e fb          	endbr32 
  80025c:	55                   	push   %ebp
  80025d:	89 e5                	mov    %esp,%ebp
  80025f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800265:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026c:	00 00 00 
	b.cnt = 0;
  80026f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800276:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800279:	ff 75 0c             	pushl  0xc(%ebp)
  80027c:	ff 75 08             	pushl  0x8(%ebp)
  80027f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	68 10 02 80 00       	push   $0x800210
  80028b:	e8 20 01 00 00       	call   8003b0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800290:	83 c4 08             	add    $0x8,%esp
  800293:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800299:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029f:	50                   	push   %eax
  8002a0:	e8 84 09 00 00       	call   800c29 <sys_cputs>

	return b.cnt;
}
  8002a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	e8 95 ff ff ff       	call   800258 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 1c             	sub    $0x1c,%esp
  8002ce:	89 c7                	mov    %eax,%edi
  8002d0:	89 d6                	mov    %edx,%esi
  8002d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d8:	89 d1                	mov    %edx,%ecx
  8002da:	89 c2                	mov    %eax,%edx
  8002dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002df:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002f2:	39 c2                	cmp    %eax,%edx
  8002f4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002f7:	72 3e                	jb     800337 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f9:	83 ec 0c             	sub    $0xc,%esp
  8002fc:	ff 75 18             	pushl  0x18(%ebp)
  8002ff:	83 eb 01             	sub    $0x1,%ebx
  800302:	53                   	push   %ebx
  800303:	50                   	push   %eax
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030a:	ff 75 e0             	pushl  -0x20(%ebp)
  80030d:	ff 75 dc             	pushl  -0x24(%ebp)
  800310:	ff 75 d8             	pushl  -0x28(%ebp)
  800313:	e8 98 23 00 00       	call   8026b0 <__udivdi3>
  800318:	83 c4 18             	add    $0x18,%esp
  80031b:	52                   	push   %edx
  80031c:	50                   	push   %eax
  80031d:	89 f2                	mov    %esi,%edx
  80031f:	89 f8                	mov    %edi,%eax
  800321:	e8 9f ff ff ff       	call   8002c5 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 13                	jmp    80033e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	56                   	push   %esi
  80032f:	ff 75 18             	pushl  0x18(%ebp)
  800332:	ff d7                	call   *%edi
  800334:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800337:	83 eb 01             	sub    $0x1,%ebx
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7f ed                	jg     80032b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	56                   	push   %esi
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 6a 24 00 00       	call   8027c0 <__umoddi3>
  800356:	83 c4 14             	add    $0x14,%esp
  800359:	0f be 80 cc 29 80 00 	movsbl 0x8029cc(%eax),%eax
  800360:	50                   	push   %eax
  800361:	ff d7                	call   *%edi
}
  800363:	83 c4 10             	add    $0x10,%esp
  800366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800369:	5b                   	pop    %ebx
  80036a:	5e                   	pop    %esi
  80036b:	5f                   	pop    %edi
  80036c:	5d                   	pop    %ebp
  80036d:	c3                   	ret    

0080036e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036e:	f3 0f 1e fb          	endbr32 
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800378:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037c:	8b 10                	mov    (%eax),%edx
  80037e:	3b 50 04             	cmp    0x4(%eax),%edx
  800381:	73 0a                	jae    80038d <sprintputch+0x1f>
		*b->buf++ = ch;
  800383:	8d 4a 01             	lea    0x1(%edx),%ecx
  800386:	89 08                	mov    %ecx,(%eax)
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	88 02                	mov    %al,(%edx)
}
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <printfmt>:
{
  80038f:	f3 0f 1e fb          	endbr32 
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800399:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039c:	50                   	push   %eax
  80039d:	ff 75 10             	pushl  0x10(%ebp)
  8003a0:	ff 75 0c             	pushl  0xc(%ebp)
  8003a3:	ff 75 08             	pushl  0x8(%ebp)
  8003a6:	e8 05 00 00 00       	call   8003b0 <vprintfmt>
}
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	c9                   	leave  
  8003af:	c3                   	ret    

008003b0 <vprintfmt>:
{
  8003b0:	f3 0f 1e fb          	endbr32 
  8003b4:	55                   	push   %ebp
  8003b5:	89 e5                	mov    %esp,%ebp
  8003b7:	57                   	push   %edi
  8003b8:	56                   	push   %esi
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 3c             	sub    $0x3c,%esp
  8003bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c6:	e9 8e 03 00 00       	jmp    800759 <vprintfmt+0x3a9>
		padc = ' ';
  8003cb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8d 47 01             	lea    0x1(%edi),%eax
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ef:	0f b6 17             	movzbl (%edi),%edx
  8003f2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f5:	3c 55                	cmp    $0x55,%al
  8003f7:	0f 87 df 03 00 00    	ja     8007dc <vprintfmt+0x42c>
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	3e ff 24 85 00 2b 80 	notrack jmp *0x802b00(,%eax,4)
  800407:	00 
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80040f:	eb d8                	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800414:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800418:	eb cf                	jmp    8003e9 <vprintfmt+0x39>
  80041a:	0f b6 d2             	movzbl %dl,%edx
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800428:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80042f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800432:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800435:	83 f9 09             	cmp    $0x9,%ecx
  800438:	77 55                	ja     80048f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80043a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043d:	eb e9                	jmp    800428 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80043f:	8b 45 14             	mov    0x14(%ebp),%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 40 04             	lea    0x4(%eax),%eax
  80044d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800453:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800457:	79 90                	jns    8003e9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800466:	eb 81                	jmp    8003e9 <vprintfmt+0x39>
  800468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	ba 00 00 00 00       	mov    $0x0,%edx
  800472:	0f 49 d0             	cmovns %eax,%edx
  800475:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80047b:	e9 69 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800483:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80048a:	e9 5a ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
  80048f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	eb bc                	jmp    800453 <vprintfmt+0xa3>
			lflag++;
  800497:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049d:	e9 47 ff ff ff       	jmp    8003e9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 78 04             	lea    0x4(%eax),%edi
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	ff 30                	pushl  (%eax)
  8004ae:	ff d6                	call   *%esi
			break;
  8004b0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b6:	e9 9b 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
  8004c4:	31 d0                	xor    %edx,%eax
  8004c6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c8:	83 f8 0f             	cmp    $0xf,%eax
  8004cb:	7f 23                	jg     8004f0 <vprintfmt+0x140>
  8004cd:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  8004d4:	85 d2                	test   %edx,%edx
  8004d6:	74 18                	je     8004f0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004d8:	52                   	push   %edx
  8004d9:	68 d1 2e 80 00       	push   $0x802ed1
  8004de:	53                   	push   %ebx
  8004df:	56                   	push   %esi
  8004e0:	e8 aa fe ff ff       	call   80038f <printfmt>
  8004e5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004eb:	e9 66 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 e4 29 80 00       	push   $0x8029e4
  8004f6:	53                   	push   %ebx
  8004f7:	56                   	push   %esi
  8004f8:	e8 92 fe ff ff       	call   80038f <printfmt>
  8004fd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800500:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800503:	e9 4e 02 00 00       	jmp    800756 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 dd 29 80 00       	mov    $0x8029dd,%eax
  80051d:	0f 45 c2             	cmovne %edx,%eax
  800520:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800523:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800527:	7e 06                	jle    80052f <vprintfmt+0x17f>
  800529:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80052d:	75 0d                	jne    80053c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800532:	89 c7                	mov    %eax,%edi
  800534:	03 45 e0             	add    -0x20(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	eb 55                	jmp    800591 <vprintfmt+0x1e1>
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 d8             	pushl  -0x28(%ebp)
  800542:	ff 75 cc             	pushl  -0x34(%ebp)
  800545:	e8 46 03 00 00       	call   800890 <strnlen>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800557:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80055b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055e:	85 ff                	test   %edi,%edi
  800560:	7e 11                	jle    800573 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	53                   	push   %ebx
  800566:	ff 75 e0             	pushl  -0x20(%ebp)
  800569:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056b:	83 ef 01             	sub    $0x1,%edi
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	eb eb                	jmp    80055e <vprintfmt+0x1ae>
  800573:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800576:	85 d2                	test   %edx,%edx
  800578:	b8 00 00 00 00       	mov    $0x0,%eax
  80057d:	0f 49 c2             	cmovns %edx,%eax
  800580:	29 c2                	sub    %eax,%edx
  800582:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800585:	eb a8                	jmp    80052f <vprintfmt+0x17f>
					putch(ch, putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	52                   	push   %edx
  80058c:	ff d6                	call   *%esi
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800594:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800596:	83 c7 01             	add    $0x1,%edi
  800599:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059d:	0f be d0             	movsbl %al,%edx
  8005a0:	85 d2                	test   %edx,%edx
  8005a2:	74 4b                	je     8005ef <vprintfmt+0x23f>
  8005a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a8:	78 06                	js     8005b0 <vprintfmt+0x200>
  8005aa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ae:	78 1e                	js     8005ce <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b4:	74 d1                	je     800587 <vprintfmt+0x1d7>
  8005b6:	0f be c0             	movsbl %al,%eax
  8005b9:	83 e8 20             	sub    $0x20,%eax
  8005bc:	83 f8 5e             	cmp    $0x5e,%eax
  8005bf:	76 c6                	jbe    800587 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 3f                	push   $0x3f
  8005c7:	ff d6                	call   *%esi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	eb c3                	jmp    800591 <vprintfmt+0x1e1>
  8005ce:	89 cf                	mov    %ecx,%edi
  8005d0:	eb 0e                	jmp    8005e0 <vprintfmt+0x230>
				putch(' ', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 20                	push   $0x20
  8005d8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005da:	83 ef 01             	sub    $0x1,%edi
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	85 ff                	test   %edi,%edi
  8005e2:	7f ee                	jg     8005d2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ea:	e9 67 01 00 00       	jmp    800756 <vprintfmt+0x3a6>
  8005ef:	89 cf                	mov    %ecx,%edi
  8005f1:	eb ed                	jmp    8005e0 <vprintfmt+0x230>
	if (lflag >= 2)
  8005f3:	83 f9 01             	cmp    $0x1,%ecx
  8005f6:	7f 1b                	jg     800613 <vprintfmt+0x263>
	else if (lflag)
  8005f8:	85 c9                	test   %ecx,%ecx
  8005fa:	74 63                	je     80065f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800604:	99                   	cltd   
  800605:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	eb 17                	jmp    80062a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80062a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80062d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800635:	85 c9                	test   %ecx,%ecx
  800637:	0f 89 ff 00 00 00    	jns    80073c <vprintfmt+0x38c>
				putch('-', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 2d                	push   $0x2d
  800643:	ff d6                	call   *%esi
				num = -(long long) num;
  800645:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800648:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80064b:	f7 da                	neg    %edx
  80064d:	83 d1 00             	adc    $0x0,%ecx
  800650:	f7 d9                	neg    %ecx
  800652:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800655:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065a:	e9 dd 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8b 00                	mov    (%eax),%eax
  800664:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800667:	99                   	cltd   
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb b4                	jmp    80062a <vprintfmt+0x27a>
	if (lflag >= 2)
  800676:	83 f9 01             	cmp    $0x1,%ecx
  800679:	7f 1e                	jg     800699 <vprintfmt+0x2e9>
	else if (lflag)
  80067b:	85 c9                	test   %ecx,%ecx
  80067d:	74 32                	je     8006b1 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800694:	e9 a3 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 10                	mov    (%eax),%edx
  80069e:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ac:	e9 8b 00 00 00       	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 10                	mov    (%eax),%edx
  8006b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bb:	8d 40 04             	lea    0x4(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006c6:	eb 74                	jmp    80073c <vprintfmt+0x38c>
	if (lflag >= 2)
  8006c8:	83 f9 01             	cmp    $0x1,%ecx
  8006cb:	7f 1b                	jg     8006e8 <vprintfmt+0x338>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	74 2c                	je     8006fd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006e6:	eb 54                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f0:	8d 40 08             	lea    0x8(%eax),%eax
  8006f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006fb:	eb 3f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 10                	mov    (%eax),%edx
  800702:	b9 00 00 00 00       	mov    $0x0,%ecx
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800712:	eb 28                	jmp    80073c <vprintfmt+0x38c>
			putch('0', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 30                	push   $0x30
  80071a:	ff d6                	call   *%esi
			putch('x', putdat);
  80071c:	83 c4 08             	add    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 78                	push   $0x78
  800722:	ff d6                	call   *%esi
			num = (unsigned long long)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80072e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800737:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80073c:	83 ec 0c             	sub    $0xc,%esp
  80073f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800743:	57                   	push   %edi
  800744:	ff 75 e0             	pushl  -0x20(%ebp)
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	52                   	push   %edx
  80074a:	89 da                	mov    %ebx,%edx
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	e8 72 fb ff ff       	call   8002c5 <printnum>
			break;
  800753:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800756:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800759:	83 c7 01             	add    $0x1,%edi
  80075c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800760:	83 f8 25             	cmp    $0x25,%eax
  800763:	0f 84 62 fc ff ff    	je     8003cb <vprintfmt+0x1b>
			if (ch == '\0')
  800769:	85 c0                	test   %eax,%eax
  80076b:	0f 84 8b 00 00 00    	je     8007fc <vprintfmt+0x44c>
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	50                   	push   %eax
  800776:	ff d6                	call   *%esi
  800778:	83 c4 10             	add    $0x10,%esp
  80077b:	eb dc                	jmp    800759 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80077d:	83 f9 01             	cmp    $0x1,%ecx
  800780:	7f 1b                	jg     80079d <vprintfmt+0x3ed>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	74 2c                	je     8007b2 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80079b:	eb 9f                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8007a5:	8d 40 08             	lea    0x8(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007b0:	eb 8a                	jmp    80073c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007c7:	e9 70 ff ff ff       	jmp    80073c <vprintfmt+0x38c>
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 25                	push   $0x25
  8007d2:	ff d6                	call   *%esi
			break;
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	e9 7a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 25                	push   $0x25
  8007e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	89 f8                	mov    %edi,%eax
  8007e9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007ed:	74 05                	je     8007f4 <vprintfmt+0x444>
  8007ef:	83 e8 01             	sub    $0x1,%eax
  8007f2:	eb f5                	jmp    8007e9 <vprintfmt+0x439>
  8007f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f7:	e9 5a ff ff ff       	jmp    800756 <vprintfmt+0x3a6>
}
  8007fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5f                   	pop    %edi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 18             	sub    $0x18,%esp
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800814:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800817:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80081b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80081e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800825:	85 c0                	test   %eax,%eax
  800827:	74 26                	je     80084f <vsnprintf+0x4b>
  800829:	85 d2                	test   %edx,%edx
  80082b:	7e 22                	jle    80084f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80082d:	ff 75 14             	pushl  0x14(%ebp)
  800830:	ff 75 10             	pushl  0x10(%ebp)
  800833:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	68 6e 03 80 00       	push   $0x80036e
  80083c:	e8 6f fb ff ff       	call   8003b0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084a:	83 c4 10             	add    $0x10,%esp
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    
		return -E_INVAL;
  80084f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800854:	eb f7                	jmp    80084d <vsnprintf+0x49>

00800856 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800863:	50                   	push   %eax
  800864:	ff 75 10             	pushl  0x10(%ebp)
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 92 ff ff ff       	call   800804 <vsnprintf>
	va_end(ap);

	return rc;
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80087e:	b8 00 00 00 00       	mov    $0x0,%eax
  800883:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800887:	74 05                	je     80088e <strlen+0x1a>
		n++;
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	eb f5                	jmp    800883 <strlen+0xf>
	return n;
}
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800890:	f3 0f 1e fb          	endbr32 
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	39 d0                	cmp    %edx,%eax
  8008a4:	74 0d                	je     8008b3 <strnlen+0x23>
  8008a6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008aa:	74 05                	je     8008b1 <strnlen+0x21>
		n++;
  8008ac:	83 c0 01             	add    $0x1,%eax
  8008af:	eb f1                	jmp    8008a2 <strnlen+0x12>
  8008b1:	89 c2                	mov    %eax,%edx
	return n;
}
  8008b3:	89 d0                	mov    %edx,%eax
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ca:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008ce:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	84 d2                	test   %dl,%dl
  8008d6:	75 f2                	jne    8008ca <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008d8:	89 c8                	mov    %ecx,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 10             	sub    $0x10,%esp
  8008e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008eb:	53                   	push   %ebx
  8008ec:	e8 83 ff ff ff       	call   800874 <strlen>
  8008f1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	01 d8                	add    %ebx,%eax
  8008f9:	50                   	push   %eax
  8008fa:	e8 b8 ff ff ff       	call   8008b7 <strcpy>
	return dst;
}
  8008ff:	89 d8                	mov    %ebx,%eax
  800901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	56                   	push   %esi
  80090e:	53                   	push   %ebx
  80090f:	8b 75 08             	mov    0x8(%ebp),%esi
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	89 f3                	mov    %esi,%ebx
  800917:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091a:	89 f0                	mov    %esi,%eax
  80091c:	39 d8                	cmp    %ebx,%eax
  80091e:	74 11                	je     800931 <strncpy+0x2b>
		*dst++ = *src;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	0f b6 0a             	movzbl (%edx),%ecx
  800926:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800929:	80 f9 01             	cmp    $0x1,%cl
  80092c:	83 da ff             	sbb    $0xffffffff,%edx
  80092f:	eb eb                	jmp    80091c <strncpy+0x16>
	}
	return ret;
}
  800931:	89 f0                	mov    %esi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
  800940:	8b 75 08             	mov    0x8(%ebp),%esi
  800943:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800946:	8b 55 10             	mov    0x10(%ebp),%edx
  800949:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80094b:	85 d2                	test   %edx,%edx
  80094d:	74 21                	je     800970 <strlcpy+0x39>
  80094f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800953:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 14                	je     80096d <strlcpy+0x36>
  800959:	0f b6 19             	movzbl (%ecx),%ebx
  80095c:	84 db                	test   %bl,%bl
  80095e:	74 0b                	je     80096b <strlcpy+0x34>
			*dst++ = *src++;
  800960:	83 c1 01             	add    $0x1,%ecx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	88 5a ff             	mov    %bl,-0x1(%edx)
  800969:	eb ea                	jmp    800955 <strlcpy+0x1e>
  80096b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80096d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800970:	29 f0                	sub    %esi,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800980:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 0c                	je     800996 <strcmp+0x20>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	75 08                	jne    800996 <strcmp+0x20>
		p++, q++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
  800994:	eb ed                	jmp    800983 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800996:	0f b6 c0             	movzbl %al,%eax
  800999:	0f b6 12             	movzbl (%edx),%edx
  80099c:	29 d0                	sub    %edx,%eax
}
  80099e:	5d                   	pop    %ebp
  80099f:	c3                   	ret    

008009a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a0:	f3 0f 1e fb          	endbr32 
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 c3                	mov    %eax,%ebx
  8009b0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b3:	eb 06                	jmp    8009bb <strncmp+0x1b>
		n--, p++, q++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009bb:	39 d8                	cmp    %ebx,%eax
  8009bd:	74 16                	je     8009d5 <strncmp+0x35>
  8009bf:	0f b6 08             	movzbl (%eax),%ecx
  8009c2:	84 c9                	test   %cl,%cl
  8009c4:	74 04                	je     8009ca <strncmp+0x2a>
  8009c6:	3a 0a                	cmp    (%edx),%cl
  8009c8:	74 eb                	je     8009b5 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ca:	0f b6 00             	movzbl (%eax),%eax
  8009cd:	0f b6 12             	movzbl (%edx),%edx
  8009d0:	29 d0                	sub    %edx,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    
		return 0;
  8009d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009da:	eb f6                	jmp    8009d2 <strncmp+0x32>

008009dc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009dc:	f3 0f 1e fb          	endbr32 
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ea:	0f b6 10             	movzbl (%eax),%edx
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 09                	je     8009fa <strchr+0x1e>
		if (*s == c)
  8009f1:	38 ca                	cmp    %cl,%dl
  8009f3:	74 0a                	je     8009ff <strchr+0x23>
	for (; *s; s++)
  8009f5:	83 c0 01             	add    $0x1,%eax
  8009f8:	eb f0                	jmp    8009ea <strchr+0xe>
			return (char *) s;
	return 0;
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a01:	f3 0f 1e fb          	endbr32 
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a12:	38 ca                	cmp    %cl,%dl
  800a14:	74 09                	je     800a1f <strfind+0x1e>
  800a16:	84 d2                	test   %dl,%dl
  800a18:	74 05                	je     800a1f <strfind+0x1e>
	for (; *s; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	eb f0                	jmp    800a0f <strfind+0xe>
			break;
	return (char *) s;
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a21:	f3 0f 1e fb          	endbr32 
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	57                   	push   %edi
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a31:	85 c9                	test   %ecx,%ecx
  800a33:	74 31                	je     800a66 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a35:	89 f8                	mov    %edi,%eax
  800a37:	09 c8                	or     %ecx,%eax
  800a39:	a8 03                	test   $0x3,%al
  800a3b:	75 23                	jne    800a60 <memset+0x3f>
		c &= 0xFF;
  800a3d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a41:	89 d3                	mov    %edx,%ebx
  800a43:	c1 e3 08             	shl    $0x8,%ebx
  800a46:	89 d0                	mov    %edx,%eax
  800a48:	c1 e0 18             	shl    $0x18,%eax
  800a4b:	89 d6                	mov    %edx,%esi
  800a4d:	c1 e6 10             	shl    $0x10,%esi
  800a50:	09 f0                	or     %esi,%eax
  800a52:	09 c2                	or     %eax,%edx
  800a54:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a56:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a59:	89 d0                	mov    %edx,%eax
  800a5b:	fc                   	cld    
  800a5c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a5e:	eb 06                	jmp    800a66 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	fc                   	cld    
  800a64:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a66:	89 f8                	mov    %edi,%eax
  800a68:	5b                   	pop    %ebx
  800a69:	5e                   	pop    %esi
  800a6a:	5f                   	pop    %edi
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6d:	f3 0f 1e fb          	endbr32 
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	57                   	push   %edi
  800a75:	56                   	push   %esi
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a7f:	39 c6                	cmp    %eax,%esi
  800a81:	73 32                	jae    800ab5 <memmove+0x48>
  800a83:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	76 2b                	jbe    800ab5 <memmove+0x48>
		s += n;
		d += n;
  800a8a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8d:	89 fe                	mov    %edi,%esi
  800a8f:	09 ce                	or     %ecx,%esi
  800a91:	09 d6                	or     %edx,%esi
  800a93:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a99:	75 0e                	jne    800aa9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9b:	83 ef 04             	sub    $0x4,%edi
  800a9e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa4:	fd                   	std    
  800aa5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa7:	eb 09                	jmp    800ab2 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa9:	83 ef 01             	sub    $0x1,%edi
  800aac:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aaf:	fd                   	std    
  800ab0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab2:	fc                   	cld    
  800ab3:	eb 1a                	jmp    800acf <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab5:	89 c2                	mov    %eax,%edx
  800ab7:	09 ca                	or     %ecx,%edx
  800ab9:	09 f2                	or     %esi,%edx
  800abb:	f6 c2 03             	test   $0x3,%dl
  800abe:	75 0a                	jne    800aca <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac8:	eb 05                	jmp    800acf <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aca:	89 c7                	mov    %eax,%edi
  800acc:	fc                   	cld    
  800acd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800add:	ff 75 10             	pushl  0x10(%ebp)
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 82 ff ff ff       	call   800a6d <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	56                   	push   %esi
  800af5:	53                   	push   %ebx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b01:	39 f0                	cmp    %esi,%eax
  800b03:	74 1c                	je     800b21 <memcmp+0x34>
		if (*s1 != *s2)
  800b05:	0f b6 08             	movzbl (%eax),%ecx
  800b08:	0f b6 1a             	movzbl (%edx),%ebx
  800b0b:	38 d9                	cmp    %bl,%cl
  800b0d:	75 08                	jne    800b17 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0f:	83 c0 01             	add    $0x1,%eax
  800b12:	83 c2 01             	add    $0x1,%edx
  800b15:	eb ea                	jmp    800b01 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b17:	0f b6 c1             	movzbl %cl,%eax
  800b1a:	0f b6 db             	movzbl %bl,%ebx
  800b1d:	29 d8                	sub    %ebx,%eax
  800b1f:	eb 05                	jmp    800b26 <memcmp+0x39>
	}

	return 0;
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b2a:	f3 0f 1e fb          	endbr32 
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b3c:	39 d0                	cmp    %edx,%eax
  800b3e:	73 09                	jae    800b49 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b40:	38 08                	cmp    %cl,(%eax)
  800b42:	74 05                	je     800b49 <memfind+0x1f>
	for (; s < ends; s++)
  800b44:	83 c0 01             	add    $0x1,%eax
  800b47:	eb f3                	jmp    800b3c <memfind+0x12>
			break;
	return (void *) s;
}
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5b:	eb 03                	jmp    800b60 <strtol+0x15>
		s++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b60:	0f b6 01             	movzbl (%ecx),%eax
  800b63:	3c 20                	cmp    $0x20,%al
  800b65:	74 f6                	je     800b5d <strtol+0x12>
  800b67:	3c 09                	cmp    $0x9,%al
  800b69:	74 f2                	je     800b5d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b6b:	3c 2b                	cmp    $0x2b,%al
  800b6d:	74 2a                	je     800b99 <strtol+0x4e>
	int neg = 0;
  800b6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b74:	3c 2d                	cmp    $0x2d,%al
  800b76:	74 2b                	je     800ba3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7e:	75 0f                	jne    800b8f <strtol+0x44>
  800b80:	80 39 30             	cmpb   $0x30,(%ecx)
  800b83:	74 28                	je     800bad <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8c:	0f 44 d8             	cmove  %eax,%ebx
  800b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b94:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b97:	eb 46                	jmp    800bdf <strtol+0x94>
		s++;
  800b99:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba1:	eb d5                	jmp    800b78 <strtol+0x2d>
		s++, neg = 1;
  800ba3:	83 c1 01             	add    $0x1,%ecx
  800ba6:	bf 01 00 00 00       	mov    $0x1,%edi
  800bab:	eb cb                	jmp    800b78 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bad:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb1:	74 0e                	je     800bc1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb3:	85 db                	test   %ebx,%ebx
  800bb5:	75 d8                	jne    800b8f <strtol+0x44>
		s++, base = 8;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bbf:	eb ce                	jmp    800b8f <strtol+0x44>
		s += 2, base = 16;
  800bc1:	83 c1 02             	add    $0x2,%ecx
  800bc4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bc9:	eb c4                	jmp    800b8f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bcb:	0f be d2             	movsbl %dl,%edx
  800bce:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bd1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd4:	7d 3a                	jge    800c10 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bd6:	83 c1 01             	add    $0x1,%ecx
  800bd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bdd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdf:	0f b6 11             	movzbl (%ecx),%edx
  800be2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 09             	cmp    $0x9,%bl
  800bea:	76 df                	jbe    800bcb <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bef:	89 f3                	mov    %esi,%ebx
  800bf1:	80 fb 19             	cmp    $0x19,%bl
  800bf4:	77 08                	ja     800bfe <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 57             	sub    $0x57,%edx
  800bfc:	eb d3                	jmp    800bd1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bfe:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 08                	ja     800c10 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 37             	sub    $0x37,%edx
  800c0e:	eb c1                	jmp    800bd1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 05                	je     800c1b <strtol+0xd0>
		*endptr = (char *) s;
  800c16:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c19:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	f7 da                	neg    %edx
  800c1f:	85 ff                	test   %edi,%edi
  800c21:	0f 45 c2             	cmovne %edx,%eax
}
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c29:	f3 0f 1e fb          	endbr32 
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c55:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5f:	89 d1                	mov    %edx,%ecx
  800c61:	89 d3                	mov    %edx,%ebx
  800c63:	89 d7                	mov    %edx,%edi
  800c65:	89 d6                	mov    %edx,%esi
  800c67:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	b8 03 00 00 00       	mov    $0x3,%eax
  800c88:	89 cb                	mov    %ecx,%ebx
  800c8a:	89 cf                	mov    %ecx,%edi
  800c8c:	89 ce                	mov    %ecx,%esi
  800c8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c90:	85 c0                	test   %eax,%eax
  800c92:	7f 08                	jg     800c9c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 03                	push   $0x3
  800ca2:	68 bf 2c 80 00       	push   $0x802cbf
  800ca7:	6a 23                	push   $0x23
  800ca9:	68 dc 2c 80 00       	push   $0x802cdc
  800cae:	e8 c3 18 00 00       	call   802576 <_panic>

00800cb3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb3:	f3 0f 1e fb          	endbr32 
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_yield>:

void
sys_yield(void)
{
  800cd6:	f3 0f 1e fb          	endbr32 
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf9:	f3 0f 1e fb          	endbr32 
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	be 00 00 00 00       	mov    $0x0,%esi
  800d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	89 f7                	mov    %esi,%edi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d2d:	6a 04                	push   $0x4
  800d2f:	68 bf 2c 80 00       	push   $0x802cbf
  800d34:	6a 23                	push   $0x23
  800d36:	68 dc 2c 80 00       	push   $0x802cdc
  800d3b:	e8 36 18 00 00       	call   802576 <_panic>

00800d40 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	b8 05 00 00 00       	mov    $0x5,%eax
  800d58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5e:	8b 75 18             	mov    0x18(%ebp),%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d73:	6a 05                	push   $0x5
  800d75:	68 bf 2c 80 00       	push   $0x802cbf
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 dc 2c 80 00       	push   $0x802cdc
  800d81:	e8 f0 17 00 00       	call   802576 <_panic>

00800d86 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800db9:	6a 06                	push   $0x6
  800dbb:	68 bf 2c 80 00       	push   $0x802cbf
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 dc 2c 80 00       	push   $0x802cdc
  800dc7:	e8 aa 17 00 00       	call   802576 <_panic>

00800dcc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800de4:	b8 08 00 00 00       	mov    $0x8,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800dff:	6a 08                	push   $0x8
  800e01:	68 bf 2c 80 00       	push   $0x802cbf
  800e06:	6a 23                	push   $0x23
  800e08:	68 dc 2c 80 00       	push   $0x802cdc
  800e0d:	e8 64 17 00 00       	call   802576 <_panic>

00800e12 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
  800e1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2f:	89 df                	mov    %ebx,%edi
  800e31:	89 de                	mov    %ebx,%esi
  800e33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e35:	85 c0                	test   %eax,%eax
  800e37:	7f 08                	jg     800e41 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5f                   	pop    %edi
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	50                   	push   %eax
  800e45:	6a 09                	push   $0x9
  800e47:	68 bf 2c 80 00       	push   $0x802cbf
  800e4c:	6a 23                	push   $0x23
  800e4e:	68 dc 2c 80 00       	push   $0x802cdc
  800e53:	e8 1e 17 00 00       	call   802576 <_panic>

00800e58 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e58:	f3 0f 1e fb          	endbr32 
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 0a                	push   $0xa
  800e8d:	68 bf 2c 80 00       	push   $0x802cbf
  800e92:	6a 23                	push   $0x23
  800e94:	68 dc 2c 80 00       	push   $0x802cdc
  800e99:	e8 d8 16 00 00       	call   802576 <_panic>

00800e9e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb3:	be 00 00 00 00       	mov    $0x0,%esi
  800eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebe:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec5:	f3 0f 1e fb          	endbr32 
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7f 08                	jg     800ef3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	83 ec 0c             	sub    $0xc,%esp
  800ef6:	50                   	push   %eax
  800ef7:	6a 0d                	push   $0xd
  800ef9:	68 bf 2c 80 00       	push   $0x802cbf
  800efe:	6a 23                	push   $0x23
  800f00:	68 dc 2c 80 00       	push   $0x802cdc
  800f05:	e8 6c 16 00 00       	call   802576 <_panic>

00800f0a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0a:	f3 0f 1e fb          	endbr32 
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
  800f19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1e:	89 d1                	mov    %edx,%ecx
  800f20:	89 d3                	mov    %edx,%ebx
  800f22:	89 d7                	mov    %edx,%edi
  800f24:	89 d6                	mov    %edx,%esi
  800f26:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f2d:	f3 0f 1e fb          	endbr32 
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800f39:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800f3b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f3f:	75 11                	jne    800f52 <pgfault+0x25>
  800f41:	89 f0                	mov    %esi,%eax
  800f43:	c1 e8 0c             	shr    $0xc,%eax
  800f46:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f4d:	f6 c4 08             	test   $0x8,%ah
  800f50:	74 7d                	je     800fcf <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800f52:	e8 5c fd ff ff       	call   800cb3 <sys_getenvid>
  800f57:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f59:	83 ec 04             	sub    $0x4,%esp
  800f5c:	6a 07                	push   $0x7
  800f5e:	68 00 f0 7f 00       	push   $0x7ff000
  800f63:	50                   	push   %eax
  800f64:	e8 90 fd ff ff       	call   800cf9 <sys_page_alloc>
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 7a                	js     800fea <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800f70:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800f76:	83 ec 04             	sub    $0x4,%esp
  800f79:	68 00 10 00 00       	push   $0x1000
  800f7e:	56                   	push   %esi
  800f7f:	68 00 f0 7f 00       	push   $0x7ff000
  800f84:	e8 e4 fa ff ff       	call   800a6d <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800f89:	83 c4 08             	add    $0x8,%esp
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	e8 f3 fd ff ff       	call   800d86 <sys_page_unmap>
  800f93:	83 c4 10             	add    $0x10,%esp
  800f96:	85 c0                	test   %eax,%eax
  800f98:	78 62                	js     800ffc <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	6a 07                	push   $0x7
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
  800fa1:	68 00 f0 7f 00       	push   $0x7ff000
  800fa6:	53                   	push   %ebx
  800fa7:	e8 94 fd ff ff       	call   800d40 <sys_page_map>
  800fac:	83 c4 20             	add    $0x20,%esp
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	78 5b                	js     80100e <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fb3:	83 ec 08             	sub    $0x8,%esp
  800fb6:	68 00 f0 7f 00       	push   $0x7ff000
  800fbb:	53                   	push   %ebx
  800fbc:	e8 c5 fd ff ff       	call   800d86 <sys_page_unmap>
  800fc1:	83 c4 10             	add    $0x10,%esp
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	78 58                	js     801020 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800fcf:	e8 df fc ff ff       	call   800cb3 <sys_getenvid>
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	56                   	push   %esi
  800fd8:	50                   	push   %eax
  800fd9:	68 ec 2c 80 00       	push   $0x802cec
  800fde:	6a 16                	push   $0x16
  800fe0:	68 7a 2d 80 00       	push   $0x802d7a
  800fe5:	e8 8c 15 00 00       	call   802576 <_panic>
        panic("pgfault: page allocation failed %e", r);
  800fea:	50                   	push   %eax
  800feb:	68 34 2d 80 00       	push   $0x802d34
  800ff0:	6a 1f                	push   $0x1f
  800ff2:	68 7a 2d 80 00       	push   $0x802d7a
  800ff7:	e8 7a 15 00 00       	call   802576 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800ffc:	50                   	push   %eax
  800ffd:	68 85 2d 80 00       	push   $0x802d85
  801002:	6a 24                	push   $0x24
  801004:	68 7a 2d 80 00       	push   $0x802d7a
  801009:	e8 68 15 00 00       	call   802576 <_panic>
        panic("pgfault: page map failed %e", r);
  80100e:	50                   	push   %eax
  80100f:	68 a3 2d 80 00       	push   $0x802da3
  801014:	6a 26                	push   $0x26
  801016:	68 7a 2d 80 00       	push   $0x802d7a
  80101b:	e8 56 15 00 00       	call   802576 <_panic>
        panic("pgfault: page unmap failed %e", r);
  801020:	50                   	push   %eax
  801021:	68 85 2d 80 00       	push   $0x802d85
  801026:	6a 28                	push   $0x28
  801028:	68 7a 2d 80 00       	push   $0x802d7a
  80102d:	e8 44 15 00 00       	call   802576 <_panic>

00801032 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	53                   	push   %ebx
  801036:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  801039:	89 d3                	mov    %edx,%ebx
  80103b:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  80103e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801045:	f6 c6 04             	test   $0x4,%dh
  801048:	75 62                	jne    8010ac <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  80104a:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801050:	0f 84 9d 00 00 00    	je     8010f3 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  801056:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80105c:	8b 52 48             	mov    0x48(%edx),%edx
  80105f:	83 ec 0c             	sub    $0xc,%esp
  801062:	68 05 08 00 00       	push   $0x805
  801067:	53                   	push   %ebx
  801068:	50                   	push   %eax
  801069:	53                   	push   %ebx
  80106a:	52                   	push   %edx
  80106b:	e8 d0 fc ff ff       	call   800d40 <sys_page_map>
  801070:	83 c4 20             	add    $0x20,%esp
  801073:	85 c0                	test   %eax,%eax
  801075:	78 6a                	js     8010e1 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  801077:	a1 08 40 80 00       	mov    0x804008,%eax
  80107c:	8b 50 48             	mov    0x48(%eax),%edx
  80107f:	8b 40 48             	mov    0x48(%eax),%eax
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	68 05 08 00 00       	push   $0x805
  80108a:	53                   	push   %ebx
  80108b:	52                   	push   %edx
  80108c:	53                   	push   %ebx
  80108d:	50                   	push   %eax
  80108e:	e8 ad fc ff ff       	call   800d40 <sys_page_map>
  801093:	83 c4 20             	add    $0x20,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	79 77                	jns    801111 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80109a:	50                   	push   %eax
  80109b:	68 58 2d 80 00       	push   $0x802d58
  8010a0:	6a 49                	push   $0x49
  8010a2:	68 7a 2d 80 00       	push   $0x802d7a
  8010a7:	e8 ca 14 00 00       	call   802576 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  8010ac:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8010b2:	8b 49 48             	mov    0x48(%ecx),%ecx
  8010b5:	83 ec 0c             	sub    $0xc,%esp
  8010b8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010be:	52                   	push   %edx
  8010bf:	53                   	push   %ebx
  8010c0:	50                   	push   %eax
  8010c1:	53                   	push   %ebx
  8010c2:	51                   	push   %ecx
  8010c3:	e8 78 fc ff ff       	call   800d40 <sys_page_map>
  8010c8:	83 c4 20             	add    $0x20,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	79 42                	jns    801111 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8010cf:	50                   	push   %eax
  8010d0:	68 58 2d 80 00       	push   $0x802d58
  8010d5:	6a 43                	push   $0x43
  8010d7:	68 7a 2d 80 00       	push   $0x802d7a
  8010dc:	e8 95 14 00 00       	call   802576 <_panic>
            panic("duppage: page remapping failed %e", r);
  8010e1:	50                   	push   %eax
  8010e2:	68 58 2d 80 00       	push   $0x802d58
  8010e7:	6a 47                	push   $0x47
  8010e9:	68 7a 2d 80 00       	push   $0x802d7a
  8010ee:	e8 83 14 00 00       	call   802576 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8010f3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8010f9:	8b 52 48             	mov    0x48(%edx),%edx
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	6a 05                	push   $0x5
  801101:	53                   	push   %ebx
  801102:	50                   	push   %eax
  801103:	53                   	push   %ebx
  801104:	52                   	push   %edx
  801105:	e8 36 fc ff ff       	call   800d40 <sys_page_map>
  80110a:	83 c4 20             	add    $0x20,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	78 0a                	js     80111b <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
  801116:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801119:	c9                   	leave  
  80111a:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80111b:	50                   	push   %eax
  80111c:	68 58 2d 80 00       	push   $0x802d58
  801121:	6a 4c                	push   $0x4c
  801123:	68 7a 2d 80 00       	push   $0x802d7a
  801128:	e8 49 14 00 00       	call   802576 <_panic>

0080112d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80112d:	f3 0f 1e fb          	endbr32 
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
  801136:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801139:	68 2d 0f 80 00       	push   $0x800f2d
  80113e:	e8 7d 14 00 00       	call   8025c0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801143:	b8 07 00 00 00       	mov    $0x7,%eax
  801148:	cd 30                	int    $0x30
  80114a:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 12                	js     801165 <fork+0x38>
  801153:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801155:	74 20                	je     801177 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801157:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  80115e:	ba 00 00 80 00       	mov    $0x800000,%edx
  801163:	eb 42                	jmp    8011a7 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801165:	50                   	push   %eax
  801166:	68 bf 2d 80 00       	push   $0x802dbf
  80116b:	6a 6a                	push   $0x6a
  80116d:	68 7a 2d 80 00       	push   $0x802d7a
  801172:	e8 ff 13 00 00       	call   802576 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801177:	e8 37 fb ff ff       	call   800cb3 <sys_getenvid>
  80117c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801181:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801184:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801189:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80118e:	e9 8a 00 00 00       	jmp    80121d <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801196:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  80119c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80119f:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8011a5:	77 32                	ja     8011d9 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8011a7:	89 d0                	mov    %edx,%eax
  8011a9:	c1 e8 16             	shr    $0x16,%eax
  8011ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b3:	a8 01                	test   $0x1,%al
  8011b5:	74 dc                	je     801193 <fork+0x66>
  8011b7:	c1 ea 0c             	shr    $0xc,%edx
  8011ba:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011c1:	a8 01                	test   $0x1,%al
  8011c3:	74 ce                	je     801193 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8011c5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011cc:	a8 04                	test   $0x4,%al
  8011ce:	74 c3                	je     801193 <fork+0x66>
			duppage(envid, PGNUM(addr));
  8011d0:	89 f0                	mov    %esi,%eax
  8011d2:	e8 5b fe ff ff       	call   801032 <duppage>
  8011d7:	eb ba                	jmp    801193 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  8011d9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8011dc:	c1 ea 0c             	shr    $0xc,%edx
  8011df:	89 d8                	mov    %ebx,%eax
  8011e1:	e8 4c fe ff ff       	call   801032 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  8011e6:	83 ec 04             	sub    $0x4,%esp
  8011e9:	6a 07                	push   $0x7
  8011eb:	68 00 f0 bf ee       	push   $0xeebff000
  8011f0:	53                   	push   %ebx
  8011f1:	e8 03 fb ff ff       	call   800cf9 <sys_page_alloc>
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 29                	jne    801226 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	68 41 26 80 00       	push   $0x802641
  801205:	53                   	push   %ebx
  801206:	e8 4d fc ff ff       	call   800e58 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80120b:	83 c4 08             	add    $0x8,%esp
  80120e:	6a 02                	push   $0x2
  801210:	53                   	push   %ebx
  801211:	e8 b6 fb ff ff       	call   800dcc <sys_env_set_status>
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	75 1b                	jne    801238 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801222:	5b                   	pop    %ebx
  801223:	5e                   	pop    %esi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801226:	50                   	push   %eax
  801227:	68 ce 2d 80 00       	push   $0x802dce
  80122c:	6a 7b                	push   $0x7b
  80122e:	68 7a 2d 80 00       	push   $0x802d7a
  801233:	e8 3e 13 00 00       	call   802576 <_panic>
		panic("sys_env_set_status:%e", r);
  801238:	50                   	push   %eax
  801239:	68 e0 2d 80 00       	push   $0x802de0
  80123e:	68 81 00 00 00       	push   $0x81
  801243:	68 7a 2d 80 00       	push   $0x802d7a
  801248:	e8 29 13 00 00       	call   802576 <_panic>

0080124d <sfork>:

// Challenge!
int
sfork(void)
{
  80124d:	f3 0f 1e fb          	endbr32 
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801257:	68 f6 2d 80 00       	push   $0x802df6
  80125c:	68 8b 00 00 00       	push   $0x8b
  801261:	68 7a 2d 80 00       	push   $0x802d7a
  801266:	e8 0b 13 00 00       	call   802576 <_panic>

0080126b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	8b 75 08             	mov    0x8(%ebp),%esi
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80127d:	83 e8 01             	sub    $0x1,%eax
  801280:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801285:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80128a:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80128e:	83 ec 0c             	sub    $0xc,%esp
  801291:	50                   	push   %eax
  801292:	e8 2e fc ff ff       	call   800ec5 <sys_ipc_recv>
	if (!t) {
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	75 2b                	jne    8012c9 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80129e:	85 f6                	test   %esi,%esi
  8012a0:	74 0a                	je     8012ac <ipc_recv+0x41>
  8012a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a7:	8b 40 74             	mov    0x74(%eax),%eax
  8012aa:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8012ac:	85 db                	test   %ebx,%ebx
  8012ae:	74 0a                	je     8012ba <ipc_recv+0x4f>
  8012b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b5:	8b 40 78             	mov    0x78(%eax),%eax
  8012b8:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8012ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8012bf:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8012c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8012c9:	85 f6                	test   %esi,%esi
  8012cb:	74 06                	je     8012d3 <ipc_recv+0x68>
  8012cd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8012d3:	85 db                	test   %ebx,%ebx
  8012d5:	74 eb                	je     8012c2 <ipc_recv+0x57>
  8012d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012dd:	eb e3                	jmp    8012c2 <ipc_recv+0x57>

008012df <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8012df:	f3 0f 1e fb          	endbr32 
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8012fc:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8012ff:	ff 75 14             	pushl  0x14(%ebp)
  801302:	53                   	push   %ebx
  801303:	56                   	push   %esi
  801304:	57                   	push   %edi
  801305:	e8 94 fb ff ff       	call   800e9e <sys_ipc_try_send>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	74 1e                	je     80132f <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  801311:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801314:	75 07                	jne    80131d <ipc_send+0x3e>
		sys_yield();
  801316:	e8 bb f9 ff ff       	call   800cd6 <sys_yield>
  80131b:	eb e2                	jmp    8012ff <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80131d:	50                   	push   %eax
  80131e:	68 0c 2e 80 00       	push   $0x802e0c
  801323:	6a 39                	push   $0x39
  801325:	68 1e 2e 80 00       	push   $0x802e1e
  80132a:	e8 47 12 00 00       	call   802576 <_panic>
	}
	//panic("ipc_send not implemented");
}
  80132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801337:	f3 0f 1e fb          	endbr32 
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801346:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801349:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80134f:	8b 52 50             	mov    0x50(%edx),%edx
  801352:	39 ca                	cmp    %ecx,%edx
  801354:	74 11                	je     801367 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801356:	83 c0 01             	add    $0x1,%eax
  801359:	3d 00 04 00 00       	cmp    $0x400,%eax
  80135e:	75 e6                	jne    801346 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801360:	b8 00 00 00 00       	mov    $0x0,%eax
  801365:	eb 0b                	jmp    801372 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801367:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80136a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80136f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    

00801374 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801374:	f3 0f 1e fb          	endbr32 
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	05 00 00 00 30       	add    $0x30000000,%eax
  801383:	c1 e8 0c             	shr    $0xc,%eax
}
  801386:	5d                   	pop    %ebp
  801387:	c3                   	ret    

00801388 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801388:	f3 0f 1e fb          	endbr32 
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801397:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013a1:	5d                   	pop    %ebp
  8013a2:	c3                   	ret    

008013a3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013a3:	f3 0f 1e fb          	endbr32 
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013af:	89 c2                	mov    %eax,%edx
  8013b1:	c1 ea 16             	shr    $0x16,%edx
  8013b4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013bb:	f6 c2 01             	test   $0x1,%dl
  8013be:	74 2d                	je     8013ed <fd_alloc+0x4a>
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	c1 ea 0c             	shr    $0xc,%edx
  8013c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013cc:	f6 c2 01             	test   $0x1,%dl
  8013cf:	74 1c                	je     8013ed <fd_alloc+0x4a>
  8013d1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013d6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013db:	75 d2                	jne    8013af <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013e6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013eb:	eb 0a                	jmp    8013f7 <fd_alloc+0x54>
			*fd_store = fd;
  8013ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013f0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    

008013f9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013f9:	f3 0f 1e fb          	endbr32 
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801403:	83 f8 1f             	cmp    $0x1f,%eax
  801406:	77 30                	ja     801438 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801408:	c1 e0 0c             	shl    $0xc,%eax
  80140b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801410:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801416:	f6 c2 01             	test   $0x1,%dl
  801419:	74 24                	je     80143f <fd_lookup+0x46>
  80141b:	89 c2                	mov    %eax,%edx
  80141d:	c1 ea 0c             	shr    $0xc,%edx
  801420:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801427:	f6 c2 01             	test   $0x1,%dl
  80142a:	74 1a                	je     801446 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	89 02                	mov    %eax,(%edx)
	return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801436:	5d                   	pop    %ebp
  801437:	c3                   	ret    
		return -E_INVAL;
  801438:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80143d:	eb f7                	jmp    801436 <fd_lookup+0x3d>
		return -E_INVAL;
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb f0                	jmp    801436 <fd_lookup+0x3d>
  801446:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144b:	eb e9                	jmp    801436 <fd_lookup+0x3d>

0080144d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80144d:	f3 0f 1e fb          	endbr32 
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80145a:	ba 00 00 00 00       	mov    $0x0,%edx
  80145f:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801464:	39 08                	cmp    %ecx,(%eax)
  801466:	74 38                	je     8014a0 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801468:	83 c2 01             	add    $0x1,%edx
  80146b:	8b 04 95 a4 2e 80 00 	mov    0x802ea4(,%edx,4),%eax
  801472:	85 c0                	test   %eax,%eax
  801474:	75 ee                	jne    801464 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801476:	a1 08 40 80 00       	mov    0x804008,%eax
  80147b:	8b 40 48             	mov    0x48(%eax),%eax
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	51                   	push   %ecx
  801482:	50                   	push   %eax
  801483:	68 28 2e 80 00       	push   $0x802e28
  801488:	e8 20 ee ff ff       	call   8002ad <cprintf>
	*dev = 0;
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    
			*dev = devtab[i];
  8014a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb f2                	jmp    80149e <dev_lookup+0x51>

008014ac <fd_close>:
{
  8014ac:	f3 0f 1e fb          	endbr32 
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	57                   	push   %edi
  8014b4:	56                   	push   %esi
  8014b5:	53                   	push   %ebx
  8014b6:	83 ec 24             	sub    $0x24,%esp
  8014b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8014bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014c2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014c3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014c9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014cc:	50                   	push   %eax
  8014cd:	e8 27 ff ff ff       	call   8013f9 <fd_lookup>
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	83 c4 10             	add    $0x10,%esp
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	78 05                	js     8014e0 <fd_close+0x34>
	    || fd != fd2)
  8014db:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014de:	74 16                	je     8014f6 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014e0:	89 f8                	mov    %edi,%eax
  8014e2:	84 c0                	test   %al,%al
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e9:	0f 44 d8             	cmove  %eax,%ebx
}
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 36                	pushl  (%esi)
  8014ff:	e8 49 ff ff ff       	call   80144d <dev_lookup>
  801504:	89 c3                	mov    %eax,%ebx
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 1a                	js     801527 <fd_close+0x7b>
		if (dev->dev_close)
  80150d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801510:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801513:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801518:	85 c0                	test   %eax,%eax
  80151a:	74 0b                	je     801527 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	56                   	push   %esi
  801520:	ff d0                	call   *%eax
  801522:	89 c3                	mov    %eax,%ebx
  801524:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	56                   	push   %esi
  80152b:	6a 00                	push   $0x0
  80152d:	e8 54 f8 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	eb b5                	jmp    8014ec <fd_close+0x40>

00801537 <close>:

int
close(int fdnum)
{
  801537:	f3 0f 1e fb          	endbr32 
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	e8 ac fe ff ff       	call   8013f9 <fd_lookup>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	79 02                	jns    801556 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    
		return fd_close(fd, 1);
  801556:	83 ec 08             	sub    $0x8,%esp
  801559:	6a 01                	push   $0x1
  80155b:	ff 75 f4             	pushl  -0xc(%ebp)
  80155e:	e8 49 ff ff ff       	call   8014ac <fd_close>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	eb ec                	jmp    801554 <close+0x1d>

00801568 <close_all>:

void
close_all(void)
{
  801568:	f3 0f 1e fb          	endbr32 
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	53                   	push   %ebx
  801570:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801573:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	53                   	push   %ebx
  80157c:	e8 b6 ff ff ff       	call   801537 <close>
	for (i = 0; i < MAXFD; i++)
  801581:	83 c3 01             	add    $0x1,%ebx
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	83 fb 20             	cmp    $0x20,%ebx
  80158a:	75 ec                	jne    801578 <close_all+0x10>
}
  80158c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801591:	f3 0f 1e fb          	endbr32 
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	57                   	push   %edi
  801599:	56                   	push   %esi
  80159a:	53                   	push   %ebx
  80159b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80159e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	e8 4f fe ff ff       	call   8013f9 <fd_lookup>
  8015aa:	89 c3                	mov    %eax,%ebx
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	0f 88 81 00 00 00    	js     801638 <dup+0xa7>
		return r;
	close(newfdnum);
  8015b7:	83 ec 0c             	sub    $0xc,%esp
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 75 ff ff ff       	call   801537 <close>

	newfd = INDEX2FD(newfdnum);
  8015c2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c5:	c1 e6 0c             	shl    $0xc,%esi
  8015c8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015ce:	83 c4 04             	add    $0x4,%esp
  8015d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d4:	e8 af fd ff ff       	call   801388 <fd2data>
  8015d9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015db:	89 34 24             	mov    %esi,(%esp)
  8015de:	e8 a5 fd ff ff       	call   801388 <fd2data>
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015e8:	89 d8                	mov    %ebx,%eax
  8015ea:	c1 e8 16             	shr    $0x16,%eax
  8015ed:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015f4:	a8 01                	test   $0x1,%al
  8015f6:	74 11                	je     801609 <dup+0x78>
  8015f8:	89 d8                	mov    %ebx,%eax
  8015fa:	c1 e8 0c             	shr    $0xc,%eax
  8015fd:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801604:	f6 c2 01             	test   $0x1,%dl
  801607:	75 39                	jne    801642 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160c:	89 d0                	mov    %edx,%eax
  80160e:	c1 e8 0c             	shr    $0xc,%eax
  801611:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	25 07 0e 00 00       	and    $0xe07,%eax
  801620:	50                   	push   %eax
  801621:	56                   	push   %esi
  801622:	6a 00                	push   $0x0
  801624:	52                   	push   %edx
  801625:	6a 00                	push   $0x0
  801627:	e8 14 f7 ff ff       	call   800d40 <sys_page_map>
  80162c:	89 c3                	mov    %eax,%ebx
  80162e:	83 c4 20             	add    $0x20,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 31                	js     801666 <dup+0xd5>
		goto err;

	return newfdnum;
  801635:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5f                   	pop    %edi
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801642:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	25 07 0e 00 00       	and    $0xe07,%eax
  801651:	50                   	push   %eax
  801652:	57                   	push   %edi
  801653:	6a 00                	push   $0x0
  801655:	53                   	push   %ebx
  801656:	6a 00                	push   $0x0
  801658:	e8 e3 f6 ff ff       	call   800d40 <sys_page_map>
  80165d:	89 c3                	mov    %eax,%ebx
  80165f:	83 c4 20             	add    $0x20,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	79 a3                	jns    801609 <dup+0x78>
	sys_page_unmap(0, newfd);
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	56                   	push   %esi
  80166a:	6a 00                	push   $0x0
  80166c:	e8 15 f7 ff ff       	call   800d86 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	57                   	push   %edi
  801675:	6a 00                	push   $0x0
  801677:	e8 0a f7 ff ff       	call   800d86 <sys_page_unmap>
	return r;
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	eb b7                	jmp    801638 <dup+0xa7>

00801681 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801681:	f3 0f 1e fb          	endbr32 
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	53                   	push   %ebx
  801689:	83 ec 1c             	sub    $0x1c,%esp
  80168c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	53                   	push   %ebx
  801694:	e8 60 fd ff ff       	call   8013f9 <fd_lookup>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 3f                	js     8016df <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a0:	83 ec 08             	sub    $0x8,%esp
  8016a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016aa:	ff 30                	pushl  (%eax)
  8016ac:	e8 9c fd ff ff       	call   80144d <dev_lookup>
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	78 27                	js     8016df <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bb:	8b 42 08             	mov    0x8(%edx),%eax
  8016be:	83 e0 03             	and    $0x3,%eax
  8016c1:	83 f8 01             	cmp    $0x1,%eax
  8016c4:	74 1e                	je     8016e4 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	8b 40 08             	mov    0x8(%eax),%eax
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	74 35                	je     801705 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	ff 75 10             	pushl  0x10(%ebp)
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	52                   	push   %edx
  8016da:	ff d0                	call   *%eax
  8016dc:	83 c4 10             	add    $0x10,%esp
}
  8016df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8016e9:	8b 40 48             	mov    0x48(%eax),%eax
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	53                   	push   %ebx
  8016f0:	50                   	push   %eax
  8016f1:	68 69 2e 80 00       	push   $0x802e69
  8016f6:	e8 b2 eb ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801703:	eb da                	jmp    8016df <read+0x5e>
		return -E_NOT_SUPP;
  801705:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170a:	eb d3                	jmp    8016df <read+0x5e>

0080170c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80170c:	f3 0f 1e fb          	endbr32 
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	57                   	push   %edi
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80171f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801724:	eb 02                	jmp    801728 <readn+0x1c>
  801726:	01 c3                	add    %eax,%ebx
  801728:	39 f3                	cmp    %esi,%ebx
  80172a:	73 21                	jae    80174d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	89 f0                	mov    %esi,%eax
  801731:	29 d8                	sub    %ebx,%eax
  801733:	50                   	push   %eax
  801734:	89 d8                	mov    %ebx,%eax
  801736:	03 45 0c             	add    0xc(%ebp),%eax
  801739:	50                   	push   %eax
  80173a:	57                   	push   %edi
  80173b:	e8 41 ff ff ff       	call   801681 <read>
		if (m < 0)
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 04                	js     80174b <readn+0x3f>
			return m;
		if (m == 0)
  801747:	75 dd                	jne    801726 <readn+0x1a>
  801749:	eb 02                	jmp    80174d <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80174b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5f                   	pop    %edi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801757:	f3 0f 1e fb          	endbr32 
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	53                   	push   %ebx
  80175f:	83 ec 1c             	sub    $0x1c,%esp
  801762:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801765:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801768:	50                   	push   %eax
  801769:	53                   	push   %ebx
  80176a:	e8 8a fc ff ff       	call   8013f9 <fd_lookup>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 3a                	js     8017b0 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801776:	83 ec 08             	sub    $0x8,%esp
  801779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177c:	50                   	push   %eax
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	ff 30                	pushl  (%eax)
  801782:	e8 c6 fc ff ff       	call   80144d <dev_lookup>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 22                	js     8017b0 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801795:	74 1e                	je     8017b5 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179a:	8b 52 0c             	mov    0xc(%edx),%edx
  80179d:	85 d2                	test   %edx,%edx
  80179f:	74 35                	je     8017d6 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	ff 75 10             	pushl  0x10(%ebp)
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	ff d2                	call   *%edx
  8017ad:	83 c4 10             	add    $0x10,%esp
}
  8017b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8017ba:	8b 40 48             	mov    0x48(%eax),%eax
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	53                   	push   %ebx
  8017c1:	50                   	push   %eax
  8017c2:	68 85 2e 80 00       	push   $0x802e85
  8017c7:	e8 e1 ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d4:	eb da                	jmp    8017b0 <write+0x59>
		return -E_NOT_SUPP;
  8017d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017db:	eb d3                	jmp    8017b0 <write+0x59>

008017dd <seek>:

int
seek(int fdnum, off_t offset)
{
  8017dd:	f3 0f 1e fb          	endbr32 
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ea:	50                   	push   %eax
  8017eb:	ff 75 08             	pushl  0x8(%ebp)
  8017ee:	e8 06 fc ff ff       	call   8013f9 <fd_lookup>
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 0e                	js     801808 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801800:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80180a:	f3 0f 1e fb          	endbr32 
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	53                   	push   %ebx
  801812:	83 ec 1c             	sub    $0x1c,%esp
  801815:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801818:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80181b:	50                   	push   %eax
  80181c:	53                   	push   %ebx
  80181d:	e8 d7 fb ff ff       	call   8013f9 <fd_lookup>
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	85 c0                	test   %eax,%eax
  801827:	78 37                	js     801860 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182f:	50                   	push   %eax
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801833:	ff 30                	pushl  (%eax)
  801835:	e8 13 fc ff ff       	call   80144d <dev_lookup>
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 1f                	js     801860 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801848:	74 1b                	je     801865 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80184a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184d:	8b 52 18             	mov    0x18(%edx),%edx
  801850:	85 d2                	test   %edx,%edx
  801852:	74 32                	je     801886 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801854:	83 ec 08             	sub    $0x8,%esp
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	50                   	push   %eax
  80185b:	ff d2                	call   *%edx
  80185d:	83 c4 10             	add    $0x10,%esp
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    
			thisenv->env_id, fdnum);
  801865:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80186a:	8b 40 48             	mov    0x48(%eax),%eax
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	53                   	push   %ebx
  801871:	50                   	push   %eax
  801872:	68 48 2e 80 00       	push   $0x802e48
  801877:	e8 31 ea ff ff       	call   8002ad <cprintf>
		return -E_INVAL;
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801884:	eb da                	jmp    801860 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801886:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188b:	eb d3                	jmp    801860 <ftruncate+0x56>

0080188d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80188d:	f3 0f 1e fb          	endbr32 
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	53                   	push   %ebx
  801895:	83 ec 1c             	sub    $0x1c,%esp
  801898:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189e:	50                   	push   %eax
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 52 fb ff ff       	call   8013f9 <fd_lookup>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	78 4b                	js     8018f9 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b4:	50                   	push   %eax
  8018b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b8:	ff 30                	pushl  (%eax)
  8018ba:	e8 8e fb ff ff       	call   80144d <dev_lookup>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 33                	js     8018f9 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018cd:	74 2f                	je     8018fe <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018cf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018d2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018d9:	00 00 00 
	stat->st_isdir = 0;
  8018dc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018e3:	00 00 00 
	stat->st_dev = dev;
  8018e6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	53                   	push   %ebx
  8018f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f3:	ff 50 14             	call   *0x14(%eax)
  8018f6:	83 c4 10             	add    $0x10,%esp
}
  8018f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    
		return -E_NOT_SUPP;
  8018fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801903:	eb f4                	jmp    8018f9 <fstat+0x6c>

00801905 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801905:	f3 0f 1e fb          	endbr32 
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	56                   	push   %esi
  80190d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80190e:	83 ec 08             	sub    $0x8,%esp
  801911:	6a 00                	push   $0x0
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	e8 fb 01 00 00       	call   801b16 <open>
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 1b                	js     80193f <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	50                   	push   %eax
  80192b:	e8 5d ff ff ff       	call   80188d <fstat>
  801930:	89 c6                	mov    %eax,%esi
	close(fd);
  801932:	89 1c 24             	mov    %ebx,(%esp)
  801935:	e8 fd fb ff ff       	call   801537 <close>
	return r;
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	89 f3                	mov    %esi,%ebx
}
  80193f:	89 d8                	mov    %ebx,%eax
  801941:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5d                   	pop    %ebp
  801947:	c3                   	ret    

00801948 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	89 c6                	mov    %eax,%esi
  80194f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801951:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801958:	74 27                	je     801981 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80195a:	6a 07                	push   $0x7
  80195c:	68 00 50 80 00       	push   $0x805000
  801961:	56                   	push   %esi
  801962:	ff 35 00 40 80 00    	pushl  0x804000
  801968:	e8 72 f9 ff ff       	call   8012df <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80196d:	83 c4 0c             	add    $0xc,%esp
  801970:	6a 00                	push   $0x0
  801972:	53                   	push   %ebx
  801973:	6a 00                	push   $0x0
  801975:	e8 f1 f8 ff ff       	call   80126b <ipc_recv>
}
  80197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801981:	83 ec 0c             	sub    $0xc,%esp
  801984:	6a 01                	push   $0x1
  801986:	e8 ac f9 ff ff       	call   801337 <ipc_find_env>
  80198b:	a3 00 40 80 00       	mov    %eax,0x804000
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	eb c5                	jmp    80195a <fsipc+0x12>

00801995 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801995:	f3 0f 1e fb          	endbr32 
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019bc:	e8 87 ff ff ff       	call   801948 <fsipc>
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <devfile_flush>:
{
  8019c3:	f3 0f 1e fb          	endbr32 
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e2:	e8 61 ff ff ff       	call   801948 <fsipc>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <devfile_stat>:
{
  8019e9:	f3 0f 1e fb          	endbr32 
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a02:	ba 00 00 00 00       	mov    $0x0,%edx
  801a07:	b8 05 00 00 00       	mov    $0x5,%eax
  801a0c:	e8 37 ff ff ff       	call   801948 <fsipc>
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 2c                	js     801a41 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a15:	83 ec 08             	sub    $0x8,%esp
  801a18:	68 00 50 80 00       	push   $0x805000
  801a1d:	53                   	push   %ebx
  801a1e:	e8 94 ee ff ff       	call   8008b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a23:	a1 80 50 80 00       	mov    0x805080,%eax
  801a28:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a2e:	a1 84 50 80 00       	mov    0x805084,%eax
  801a33:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <devfile_write>:
{
  801a46:	f3 0f 1e fb          	endbr32 
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a53:	8b 55 08             	mov    0x8(%ebp),%edx
  801a56:	8b 52 0c             	mov    0xc(%edx),%edx
  801a59:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801a5f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a64:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a69:	0f 47 c2             	cmova  %edx,%eax
  801a6c:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a71:	50                   	push   %eax
  801a72:	ff 75 0c             	pushl  0xc(%ebp)
  801a75:	68 08 50 80 00       	push   $0x805008
  801a7a:	e8 ee ef ff ff       	call   800a6d <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a84:	b8 04 00 00 00       	mov    $0x4,%eax
  801a89:	e8 ba fe ff ff       	call   801948 <fsipc>
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <devfile_read>:
{
  801a90:	f3 0f 1e fb          	endbr32 
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801aa7:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aad:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab7:	e8 8c fe ff ff       	call   801948 <fsipc>
  801abc:	89 c3                	mov    %eax,%ebx
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 1f                	js     801ae1 <devfile_read+0x51>
	assert(r <= n);
  801ac2:	39 f0                	cmp    %esi,%eax
  801ac4:	77 24                	ja     801aea <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801ac6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801acb:	7f 33                	jg     801b00 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801acd:	83 ec 04             	sub    $0x4,%esp
  801ad0:	50                   	push   %eax
  801ad1:	68 00 50 80 00       	push   $0x805000
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	e8 8f ef ff ff       	call   800a6d <memmove>
	return r;
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	89 d8                	mov    %ebx,%eax
  801ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5e                   	pop    %esi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
	assert(r <= n);
  801aea:	68 b8 2e 80 00       	push   $0x802eb8
  801aef:	68 bf 2e 80 00       	push   $0x802ebf
  801af4:	6a 7c                	push   $0x7c
  801af6:	68 d4 2e 80 00       	push   $0x802ed4
  801afb:	e8 76 0a 00 00       	call   802576 <_panic>
	assert(r <= PGSIZE);
  801b00:	68 df 2e 80 00       	push   $0x802edf
  801b05:	68 bf 2e 80 00       	push   $0x802ebf
  801b0a:	6a 7d                	push   $0x7d
  801b0c:	68 d4 2e 80 00       	push   $0x802ed4
  801b11:	e8 60 0a 00 00       	call   802576 <_panic>

00801b16 <open>:
{
  801b16:	f3 0f 1e fb          	endbr32 
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 1c             	sub    $0x1c,%esp
  801b22:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b25:	56                   	push   %esi
  801b26:	e8 49 ed ff ff       	call   800874 <strlen>
  801b2b:	83 c4 10             	add    $0x10,%esp
  801b2e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b33:	7f 6c                	jg     801ba1 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3b:	50                   	push   %eax
  801b3c:	e8 62 f8 ff ff       	call   8013a3 <fd_alloc>
  801b41:	89 c3                	mov    %eax,%ebx
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 3c                	js     801b86 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	56                   	push   %esi
  801b4e:	68 00 50 80 00       	push   $0x805000
  801b53:	e8 5f ed ff ff       	call   8008b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b63:	b8 01 00 00 00       	mov    $0x1,%eax
  801b68:	e8 db fd ff ff       	call   801948 <fsipc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 19                	js     801b8f <open+0x79>
	return fd2num(fd);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7c:	e8 f3 f7 ff ff       	call   801374 <fd2num>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	83 c4 10             	add    $0x10,%esp
}
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    
		fd_close(fd, 0);
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	6a 00                	push   $0x0
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	e8 10 f9 ff ff       	call   8014ac <fd_close>
		return r;
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	eb e5                	jmp    801b86 <open+0x70>
		return -E_BAD_PATH;
  801ba1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ba6:	eb de                	jmp    801b86 <open+0x70>

00801ba8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ba8:	f3 0f 1e fb          	endbr32 
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb7:	b8 08 00 00 00       	mov    $0x8,%eax
  801bbc:	e8 87 fd ff ff       	call   801948 <fsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bc3:	f3 0f 1e fb          	endbr32 
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bcd:	68 eb 2e 80 00       	push   $0x802eeb
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	e8 dd ec ff ff       	call   8008b7 <strcpy>
	return 0;
}
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <devsock_close>:
{
  801be1:	f3 0f 1e fb          	endbr32 
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 10             	sub    $0x10,%esp
  801bec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bef:	53                   	push   %ebx
  801bf0:	e8 70 0a 00 00       	call   802665 <pageref>
  801bf5:	89 c2                	mov    %eax,%edx
  801bf7:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bfa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bff:	83 fa 01             	cmp    $0x1,%edx
  801c02:	74 05                	je     801c09 <devsock_close+0x28>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	ff 73 0c             	pushl  0xc(%ebx)
  801c0f:	e8 e3 02 00 00       	call   801ef7 <nsipc_close>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	eb eb                	jmp    801c04 <devsock_close+0x23>

00801c19 <devsock_write>:
{
  801c19:	f3 0f 1e fb          	endbr32 
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	ff 75 10             	pushl  0x10(%ebp)
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	ff 70 0c             	pushl  0xc(%eax)
  801c31:	e8 b5 03 00 00       	call   801feb <nsipc_send>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <devsock_read>:
{
  801c38:	f3 0f 1e fb          	endbr32 
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	ff 70 0c             	pushl  0xc(%eax)
  801c50:	e8 1f 03 00 00       	call   801f74 <nsipc_recv>
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <fd2sockid>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c5d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c60:	52                   	push   %edx
  801c61:	50                   	push   %eax
  801c62:	e8 92 f7 ff ff       	call   8013f9 <fd_lookup>
  801c67:	83 c4 10             	add    $0x10,%esp
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	78 10                	js     801c7e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c71:	8b 0d 28 30 80 00    	mov    0x803028,%ecx
  801c77:	39 08                	cmp    %ecx,(%eax)
  801c79:	75 05                	jne    801c80 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c7b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    
		return -E_NOT_SUPP;
  801c80:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c85:	eb f7                	jmp    801c7e <fd2sockid+0x27>

00801c87 <alloc_sockfd>:
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 1c             	sub    $0x1c,%esp
  801c8f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	e8 09 f7 ff ff       	call   8013a3 <fd_alloc>
  801c9a:	89 c3                	mov    %eax,%ebx
  801c9c:	83 c4 10             	add    $0x10,%esp
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 43                	js     801ce6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	68 07 04 00 00       	push   $0x407
  801cab:	ff 75 f4             	pushl  -0xc(%ebp)
  801cae:	6a 00                	push   $0x0
  801cb0:	e8 44 f0 ff ff       	call   800cf9 <sys_page_alloc>
  801cb5:	89 c3                	mov    %eax,%ebx
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	78 28                	js     801ce6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801cc7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cd3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	50                   	push   %eax
  801cda:	e8 95 f6 ff ff       	call   801374 <fd2num>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	eb 0c                	jmp    801cf2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	56                   	push   %esi
  801cea:	e8 08 02 00 00       	call   801ef7 <nsipc_close>
		return r;
  801cef:	83 c4 10             	add    $0x10,%esp
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <accept>:
{
  801cfb:	f3 0f 1e fb          	endbr32 
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	e8 4a ff ff ff       	call   801c57 <fd2sockid>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	78 1b                	js     801d2c <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d11:	83 ec 04             	sub    $0x4,%esp
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	50                   	push   %eax
  801d1b:	e8 22 01 00 00       	call   801e42 <nsipc_accept>
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	85 c0                	test   %eax,%eax
  801d25:	78 05                	js     801d2c <accept+0x31>
	return alloc_sockfd(r);
  801d27:	e8 5b ff ff ff       	call   801c87 <alloc_sockfd>
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <bind>:
{
  801d2e:	f3 0f 1e fb          	endbr32 
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	e8 17 ff ff ff       	call   801c57 <fd2sockid>
  801d40:	85 c0                	test   %eax,%eax
  801d42:	78 12                	js     801d56 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d44:	83 ec 04             	sub    $0x4,%esp
  801d47:	ff 75 10             	pushl  0x10(%ebp)
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	50                   	push   %eax
  801d4e:	e8 45 01 00 00       	call   801e98 <nsipc_bind>
  801d53:	83 c4 10             	add    $0x10,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <shutdown>:
{
  801d58:	f3 0f 1e fb          	endbr32 
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	e8 ed fe ff ff       	call   801c57 <fd2sockid>
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	78 0f                	js     801d7d <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d6e:	83 ec 08             	sub    $0x8,%esp
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	50                   	push   %eax
  801d75:	e8 57 01 00 00       	call   801ed1 <nsipc_shutdown>
  801d7a:	83 c4 10             	add    $0x10,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <connect>:
{
  801d7f:	f3 0f 1e fb          	endbr32 
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	e8 c6 fe ff ff       	call   801c57 <fd2sockid>
  801d91:	85 c0                	test   %eax,%eax
  801d93:	78 12                	js     801da7 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	ff 75 10             	pushl  0x10(%ebp)
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	50                   	push   %eax
  801d9f:	e8 71 01 00 00       	call   801f15 <nsipc_connect>
  801da4:	83 c4 10             	add    $0x10,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <listen>:
{
  801da9:	f3 0f 1e fb          	endbr32 
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	e8 9c fe ff ff       	call   801c57 <fd2sockid>
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	78 0f                	js     801dce <listen+0x25>
	return nsipc_listen(r, backlog);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	50                   	push   %eax
  801dc6:	e8 83 01 00 00       	call   801f4e <nsipc_listen>
  801dcb:	83 c4 10             	add    $0x10,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <socket>:

int
socket(int domain, int type, int protocol)
{
  801dd0:	f3 0f 1e fb          	endbr32 
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dda:	ff 75 10             	pushl  0x10(%ebp)
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	e8 65 02 00 00       	call   80204d <nsipc_socket>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 05                	js     801df4 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801def:	e8 93 fe ff ff       	call   801c87 <alloc_sockfd>
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dff:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e06:	74 26                	je     801e2e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e08:	6a 07                	push   $0x7
  801e0a:	68 00 60 80 00       	push   $0x806000
  801e0f:	53                   	push   %ebx
  801e10:	ff 35 04 40 80 00    	pushl  0x804004
  801e16:	e8 c4 f4 ff ff       	call   8012df <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e1b:	83 c4 0c             	add    $0xc,%esp
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	e8 42 f4 ff ff       	call   80126b <ipc_recv>
}
  801e29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	6a 02                	push   $0x2
  801e33:	e8 ff f4 ff ff       	call   801337 <ipc_find_env>
  801e38:	a3 04 40 80 00       	mov    %eax,0x804004
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	eb c6                	jmp    801e08 <nsipc+0x12>

00801e42 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e42:	f3 0f 1e fb          	endbr32 
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	56                   	push   %esi
  801e4a:	53                   	push   %ebx
  801e4b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e56:	8b 06                	mov    (%esi),%eax
  801e58:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e62:	e8 8f ff ff ff       	call   801df6 <nsipc>
  801e67:	89 c3                	mov    %eax,%ebx
  801e69:	85 c0                	test   %eax,%eax
  801e6b:	79 09                	jns    801e76 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e6d:	89 d8                	mov    %ebx,%eax
  801e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	ff 35 10 60 80 00    	pushl  0x806010
  801e7f:	68 00 60 80 00       	push   $0x806000
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	e8 e1 eb ff ff       	call   800a6d <memmove>
		*addrlen = ret->ret_addrlen;
  801e8c:	a1 10 60 80 00       	mov    0x806010,%eax
  801e91:	89 06                	mov    %eax,(%esi)
  801e93:	83 c4 10             	add    $0x10,%esp
	return r;
  801e96:	eb d5                	jmp    801e6d <nsipc_accept+0x2b>

00801e98 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e98:	f3 0f 1e fb          	endbr32 
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	53                   	push   %ebx
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801eae:	53                   	push   %ebx
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	68 04 60 80 00       	push   $0x806004
  801eb7:	e8 b1 eb ff ff       	call   800a6d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ebc:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ec2:	b8 02 00 00 00       	mov    $0x2,%eax
  801ec7:	e8 2a ff ff ff       	call   801df6 <nsipc>
}
  801ecc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ed1:	f3 0f 1e fb          	endbr32 
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801eeb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ef0:	e8 01 ff ff ff       	call   801df6 <nsipc>
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <nsipc_close>:

int
nsipc_close(int s)
{
  801ef7:	f3 0f 1e fb          	endbr32 
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f09:	b8 04 00 00 00       	mov    $0x4,%eax
  801f0e:	e8 e3 fe ff ff       	call   801df6 <nsipc>
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f15:	f3 0f 1e fb          	endbr32 
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f2b:	53                   	push   %ebx
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	68 04 60 80 00       	push   $0x806004
  801f34:	e8 34 eb ff ff       	call   800a6d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f39:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801f44:	e8 ad fe ff ff       	call   801df6 <nsipc>
}
  801f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f4e:	f3 0f 1e fb          	endbr32 
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f68:	b8 06 00 00 00       	mov    $0x6,%eax
  801f6d:	e8 84 fe ff ff       	call   801df6 <nsipc>
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f74:	f3 0f 1e fb          	endbr32 
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f88:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f91:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f96:	b8 07 00 00 00       	mov    $0x7,%eax
  801f9b:	e8 56 fe ff ff       	call   801df6 <nsipc>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	78 26                	js     801fcc <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801fa6:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801fac:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801fb1:	0f 4e c6             	cmovle %esi,%eax
  801fb4:	39 c3                	cmp    %eax,%ebx
  801fb6:	7f 1d                	jg     801fd5 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	53                   	push   %ebx
  801fbc:	68 00 60 80 00       	push   $0x806000
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	e8 a4 ea ff ff       	call   800a6d <memmove>
  801fc9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801fcc:	89 d8                	mov    %ebx,%eax
  801fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd1:	5b                   	pop    %ebx
  801fd2:	5e                   	pop    %esi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fd5:	68 f7 2e 80 00       	push   $0x802ef7
  801fda:	68 bf 2e 80 00       	push   $0x802ebf
  801fdf:	6a 62                	push   $0x62
  801fe1:	68 0c 2f 80 00       	push   $0x802f0c
  801fe6:	e8 8b 05 00 00       	call   802576 <_panic>

00801feb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801feb:	f3 0f 1e fb          	endbr32 
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802001:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802007:	7f 2e                	jg     802037 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	53                   	push   %ebx
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	68 0c 60 80 00       	push   $0x80600c
  802015:	e8 53 ea ff ff       	call   800a6d <memmove>
	nsipcbuf.send.req_size = size;
  80201a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802020:	8b 45 14             	mov    0x14(%ebp),%eax
  802023:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802028:	b8 08 00 00 00       	mov    $0x8,%eax
  80202d:	e8 c4 fd ff ff       	call   801df6 <nsipc>
}
  802032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802035:	c9                   	leave  
  802036:	c3                   	ret    
	assert(size < 1600);
  802037:	68 18 2f 80 00       	push   $0x802f18
  80203c:	68 bf 2e 80 00       	push   $0x802ebf
  802041:	6a 6d                	push   $0x6d
  802043:	68 0c 2f 80 00       	push   $0x802f0c
  802048:	e8 29 05 00 00       	call   802576 <_panic>

0080204d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80204d:	f3 0f 1e fb          	endbr32 
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80205f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802062:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802067:	8b 45 10             	mov    0x10(%ebp),%eax
  80206a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80206f:	b8 09 00 00 00       	mov    $0x9,%eax
  802074:	e8 7d fd ff ff       	call   801df6 <nsipc>
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80207b:	f3 0f 1e fb          	endbr32 
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	56                   	push   %esi
  802083:	53                   	push   %ebx
  802084:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	e8 f6 f2 ff ff       	call   801388 <fd2data>
  802092:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802094:	83 c4 08             	add    $0x8,%esp
  802097:	68 24 2f 80 00       	push   $0x802f24
  80209c:	53                   	push   %ebx
  80209d:	e8 15 e8 ff ff       	call   8008b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020a2:	8b 46 04             	mov    0x4(%esi),%eax
  8020a5:	2b 06                	sub    (%esi),%eax
  8020a7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8020b4:	00 00 00 
	stat->st_dev = &devpipe;
  8020b7:	c7 83 88 00 00 00 44 	movl   $0x803044,0x88(%ebx)
  8020be:	30 80 00 
	return 0;
}
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c9:	5b                   	pop    %ebx
  8020ca:	5e                   	pop    %esi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    

008020cd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020cd:	f3 0f 1e fb          	endbr32 
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	53                   	push   %ebx
  8020d5:	83 ec 0c             	sub    $0xc,%esp
  8020d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020db:	53                   	push   %ebx
  8020dc:	6a 00                	push   $0x0
  8020de:	e8 a3 ec ff ff       	call   800d86 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020e3:	89 1c 24             	mov    %ebx,(%esp)
  8020e6:	e8 9d f2 ff ff       	call   801388 <fd2data>
  8020eb:	83 c4 08             	add    $0x8,%esp
  8020ee:	50                   	push   %eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	e8 90 ec ff ff       	call   800d86 <sys_page_unmap>
}
  8020f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <_pipeisclosed>:
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	57                   	push   %edi
  8020ff:	56                   	push   %esi
  802100:	53                   	push   %ebx
  802101:	83 ec 1c             	sub    $0x1c,%esp
  802104:	89 c7                	mov    %eax,%edi
  802106:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802108:	a1 08 40 80 00       	mov    0x804008,%eax
  80210d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802110:	83 ec 0c             	sub    $0xc,%esp
  802113:	57                   	push   %edi
  802114:	e8 4c 05 00 00       	call   802665 <pageref>
  802119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80211c:	89 34 24             	mov    %esi,(%esp)
  80211f:	e8 41 05 00 00       	call   802665 <pageref>
		nn = thisenv->env_runs;
  802124:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80212a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	39 cb                	cmp    %ecx,%ebx
  802132:	74 1b                	je     80214f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802134:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802137:	75 cf                	jne    802108 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802139:	8b 42 58             	mov    0x58(%edx),%eax
  80213c:	6a 01                	push   $0x1
  80213e:	50                   	push   %eax
  80213f:	53                   	push   %ebx
  802140:	68 2b 2f 80 00       	push   $0x802f2b
  802145:	e8 63 e1 ff ff       	call   8002ad <cprintf>
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	eb b9                	jmp    802108 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80214f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802152:	0f 94 c0             	sete   %al
  802155:	0f b6 c0             	movzbl %al,%eax
}
  802158:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5e                   	pop    %esi
  80215d:	5f                   	pop    %edi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    

00802160 <devpipe_write>:
{
  802160:	f3 0f 1e fb          	endbr32 
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	57                   	push   %edi
  802168:	56                   	push   %esi
  802169:	53                   	push   %ebx
  80216a:	83 ec 28             	sub    $0x28,%esp
  80216d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802170:	56                   	push   %esi
  802171:	e8 12 f2 ff ff       	call   801388 <fd2data>
  802176:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	bf 00 00 00 00       	mov    $0x0,%edi
  802180:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802183:	74 4f                	je     8021d4 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802185:	8b 43 04             	mov    0x4(%ebx),%eax
  802188:	8b 0b                	mov    (%ebx),%ecx
  80218a:	8d 51 20             	lea    0x20(%ecx),%edx
  80218d:	39 d0                	cmp    %edx,%eax
  80218f:	72 14                	jb     8021a5 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802191:	89 da                	mov    %ebx,%edx
  802193:	89 f0                	mov    %esi,%eax
  802195:	e8 61 ff ff ff       	call   8020fb <_pipeisclosed>
  80219a:	85 c0                	test   %eax,%eax
  80219c:	75 3b                	jne    8021d9 <devpipe_write+0x79>
			sys_yield();
  80219e:	e8 33 eb ff ff       	call   800cd6 <sys_yield>
  8021a3:	eb e0                	jmp    802185 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021a8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021ac:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8021af:	89 c2                	mov    %eax,%edx
  8021b1:	c1 fa 1f             	sar    $0x1f,%edx
  8021b4:	89 d1                	mov    %edx,%ecx
  8021b6:	c1 e9 1b             	shr    $0x1b,%ecx
  8021b9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8021bc:	83 e2 1f             	and    $0x1f,%edx
  8021bf:	29 ca                	sub    %ecx,%edx
  8021c1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8021c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021c9:	83 c0 01             	add    $0x1,%eax
  8021cc:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021cf:	83 c7 01             	add    $0x1,%edi
  8021d2:	eb ac                	jmp    802180 <devpipe_write+0x20>
	return i;
  8021d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d7:	eb 05                	jmp    8021de <devpipe_write+0x7e>
				return 0;
  8021d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <devpipe_read>:
{
  8021e6:	f3 0f 1e fb          	endbr32 
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 18             	sub    $0x18,%esp
  8021f3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021f6:	57                   	push   %edi
  8021f7:	e8 8c f1 ff ff       	call   801388 <fd2data>
  8021fc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	be 00 00 00 00       	mov    $0x0,%esi
  802206:	3b 75 10             	cmp    0x10(%ebp),%esi
  802209:	75 14                	jne    80221f <devpipe_read+0x39>
	return i;
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	eb 02                	jmp    802212 <devpipe_read+0x2c>
				return i;
  802210:	89 f0                	mov    %esi,%eax
}
  802212:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802215:	5b                   	pop    %ebx
  802216:	5e                   	pop    %esi
  802217:	5f                   	pop    %edi
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    
			sys_yield();
  80221a:	e8 b7 ea ff ff       	call   800cd6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80221f:	8b 03                	mov    (%ebx),%eax
  802221:	3b 43 04             	cmp    0x4(%ebx),%eax
  802224:	75 18                	jne    80223e <devpipe_read+0x58>
			if (i > 0)
  802226:	85 f6                	test   %esi,%esi
  802228:	75 e6                	jne    802210 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80222a:	89 da                	mov    %ebx,%edx
  80222c:	89 f8                	mov    %edi,%eax
  80222e:	e8 c8 fe ff ff       	call   8020fb <_pipeisclosed>
  802233:	85 c0                	test   %eax,%eax
  802235:	74 e3                	je     80221a <devpipe_read+0x34>
				return 0;
  802237:	b8 00 00 00 00       	mov    $0x0,%eax
  80223c:	eb d4                	jmp    802212 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80223e:	99                   	cltd   
  80223f:	c1 ea 1b             	shr    $0x1b,%edx
  802242:	01 d0                	add    %edx,%eax
  802244:	83 e0 1f             	and    $0x1f,%eax
  802247:	29 d0                	sub    %edx,%eax
  802249:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80224e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802251:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802254:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802257:	83 c6 01             	add    $0x1,%esi
  80225a:	eb aa                	jmp    802206 <devpipe_read+0x20>

0080225c <pipe>:
{
  80225c:	f3 0f 1e fb          	endbr32 
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
  802265:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802268:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226b:	50                   	push   %eax
  80226c:	e8 32 f1 ff ff       	call   8013a3 <fd_alloc>
  802271:	89 c3                	mov    %eax,%ebx
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	85 c0                	test   %eax,%eax
  802278:	0f 88 23 01 00 00    	js     8023a1 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80227e:	83 ec 04             	sub    $0x4,%esp
  802281:	68 07 04 00 00       	push   $0x407
  802286:	ff 75 f4             	pushl  -0xc(%ebp)
  802289:	6a 00                	push   $0x0
  80228b:	e8 69 ea ff ff       	call   800cf9 <sys_page_alloc>
  802290:	89 c3                	mov    %eax,%ebx
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	0f 88 04 01 00 00    	js     8023a1 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022a3:	50                   	push   %eax
  8022a4:	e8 fa f0 ff ff       	call   8013a3 <fd_alloc>
  8022a9:	89 c3                	mov    %eax,%ebx
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	0f 88 db 00 00 00    	js     802391 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b6:	83 ec 04             	sub    $0x4,%esp
  8022b9:	68 07 04 00 00       	push   $0x407
  8022be:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c1:	6a 00                	push   $0x0
  8022c3:	e8 31 ea ff ff       	call   800cf9 <sys_page_alloc>
  8022c8:	89 c3                	mov    %eax,%ebx
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 88 bc 00 00 00    	js     802391 <pipe+0x135>
	va = fd2data(fd0);
  8022d5:	83 ec 0c             	sub    $0xc,%esp
  8022d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022db:	e8 a8 f0 ff ff       	call   801388 <fd2data>
  8022e0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022e2:	83 c4 0c             	add    $0xc,%esp
  8022e5:	68 07 04 00 00       	push   $0x407
  8022ea:	50                   	push   %eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	e8 07 ea ff ff       	call   800cf9 <sys_page_alloc>
  8022f2:	89 c3                	mov    %eax,%ebx
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	0f 88 82 00 00 00    	js     802381 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	ff 75 f0             	pushl  -0x10(%ebp)
  802305:	e8 7e f0 ff ff       	call   801388 <fd2data>
  80230a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802311:	50                   	push   %eax
  802312:	6a 00                	push   $0x0
  802314:	56                   	push   %esi
  802315:	6a 00                	push   $0x0
  802317:	e8 24 ea ff ff       	call   800d40 <sys_page_map>
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	83 c4 20             	add    $0x20,%esp
  802321:	85 c0                	test   %eax,%eax
  802323:	78 4e                	js     802373 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802325:	a1 44 30 80 00       	mov    0x803044,%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80232f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802332:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802348:	83 ec 0c             	sub    $0xc,%esp
  80234b:	ff 75 f4             	pushl  -0xc(%ebp)
  80234e:	e8 21 f0 ff ff       	call   801374 <fd2num>
  802353:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802356:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802358:	83 c4 04             	add    $0x4,%esp
  80235b:	ff 75 f0             	pushl  -0x10(%ebp)
  80235e:	e8 11 f0 ff ff       	call   801374 <fd2num>
  802363:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802366:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802371:	eb 2e                	jmp    8023a1 <pipe+0x145>
	sys_page_unmap(0, va);
  802373:	83 ec 08             	sub    $0x8,%esp
  802376:	56                   	push   %esi
  802377:	6a 00                	push   $0x0
  802379:	e8 08 ea ff ff       	call   800d86 <sys_page_unmap>
  80237e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802381:	83 ec 08             	sub    $0x8,%esp
  802384:	ff 75 f0             	pushl  -0x10(%ebp)
  802387:	6a 00                	push   $0x0
  802389:	e8 f8 e9 ff ff       	call   800d86 <sys_page_unmap>
  80238e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802391:	83 ec 08             	sub    $0x8,%esp
  802394:	ff 75 f4             	pushl  -0xc(%ebp)
  802397:	6a 00                	push   $0x0
  802399:	e8 e8 e9 ff ff       	call   800d86 <sys_page_unmap>
  80239e:	83 c4 10             	add    $0x10,%esp
}
  8023a1:	89 d8                	mov    %ebx,%eax
  8023a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023a6:	5b                   	pop    %ebx
  8023a7:	5e                   	pop    %esi
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    

008023aa <pipeisclosed>:
{
  8023aa:	f3 0f 1e fb          	endbr32 
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b7:	50                   	push   %eax
  8023b8:	ff 75 08             	pushl  0x8(%ebp)
  8023bb:	e8 39 f0 ff ff       	call   8013f9 <fd_lookup>
  8023c0:	83 c4 10             	add    $0x10,%esp
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	78 18                	js     8023df <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8023c7:	83 ec 0c             	sub    $0xc,%esp
  8023ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cd:	e8 b6 ef ff ff       	call   801388 <fd2data>
  8023d2:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	e8 1f fd ff ff       	call   8020fb <_pipeisclosed>
  8023dc:	83 c4 10             	add    $0x10,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023e1:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	c3                   	ret    

008023eb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023eb:	f3 0f 1e fb          	endbr32 
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023f5:	68 43 2f 80 00       	push   $0x802f43
  8023fa:	ff 75 0c             	pushl  0xc(%ebp)
  8023fd:	e8 b5 e4 ff ff       	call   8008b7 <strcpy>
	return 0;
}
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <devcons_write>:
{
  802409:	f3 0f 1e fb          	endbr32 
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
  802410:	57                   	push   %edi
  802411:	56                   	push   %esi
  802412:	53                   	push   %ebx
  802413:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802419:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80241e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802424:	3b 75 10             	cmp    0x10(%ebp),%esi
  802427:	73 31                	jae    80245a <devcons_write+0x51>
		m = n - tot;
  802429:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80242c:	29 f3                	sub    %esi,%ebx
  80242e:	83 fb 7f             	cmp    $0x7f,%ebx
  802431:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802436:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802439:	83 ec 04             	sub    $0x4,%esp
  80243c:	53                   	push   %ebx
  80243d:	89 f0                	mov    %esi,%eax
  80243f:	03 45 0c             	add    0xc(%ebp),%eax
  802442:	50                   	push   %eax
  802443:	57                   	push   %edi
  802444:	e8 24 e6 ff ff       	call   800a6d <memmove>
		sys_cputs(buf, m);
  802449:	83 c4 08             	add    $0x8,%esp
  80244c:	53                   	push   %ebx
  80244d:	57                   	push   %edi
  80244e:	e8 d6 e7 ff ff       	call   800c29 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802453:	01 de                	add    %ebx,%esi
  802455:	83 c4 10             	add    $0x10,%esp
  802458:	eb ca                	jmp    802424 <devcons_write+0x1b>
}
  80245a:	89 f0                	mov    %esi,%eax
  80245c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <devcons_read>:
{
  802464:	f3 0f 1e fb          	endbr32 
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 08             	sub    $0x8,%esp
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802473:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802477:	74 21                	je     80249a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802479:	e8 cd e7 ff ff       	call   800c4b <sys_cgetc>
  80247e:	85 c0                	test   %eax,%eax
  802480:	75 07                	jne    802489 <devcons_read+0x25>
		sys_yield();
  802482:	e8 4f e8 ff ff       	call   800cd6 <sys_yield>
  802487:	eb f0                	jmp    802479 <devcons_read+0x15>
	if (c < 0)
  802489:	78 0f                	js     80249a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80248b:	83 f8 04             	cmp    $0x4,%eax
  80248e:	74 0c                	je     80249c <devcons_read+0x38>
	*(char*)vbuf = c;
  802490:	8b 55 0c             	mov    0xc(%ebp),%edx
  802493:	88 02                	mov    %al,(%edx)
	return 1;
  802495:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    
		return 0;
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	eb f7                	jmp    80249a <devcons_read+0x36>

008024a3 <cputchar>:
{
  8024a3:	f3 0f 1e fb          	endbr32 
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024b3:	6a 01                	push   $0x1
  8024b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b8:	50                   	push   %eax
  8024b9:	e8 6b e7 ff ff       	call   800c29 <sys_cputs>
}
  8024be:	83 c4 10             	add    $0x10,%esp
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <getchar>:
{
  8024c3:	f3 0f 1e fb          	endbr32 
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8024cd:	6a 01                	push   $0x1
  8024cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d2:	50                   	push   %eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	e8 a7 f1 ff ff       	call   801681 <read>
	if (r < 0)
  8024da:	83 c4 10             	add    $0x10,%esp
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	78 06                	js     8024e7 <getchar+0x24>
	if (r < 1)
  8024e1:	74 06                	je     8024e9 <getchar+0x26>
	return c;
  8024e3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    
		return -E_EOF;
  8024e9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024ee:	eb f7                	jmp    8024e7 <getchar+0x24>

008024f0 <iscons>:
{
  8024f0:	f3 0f 1e fb          	endbr32 
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fd:	50                   	push   %eax
  8024fe:	ff 75 08             	pushl  0x8(%ebp)
  802501:	e8 f3 ee ff ff       	call   8013f9 <fd_lookup>
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	85 c0                	test   %eax,%eax
  80250b:	78 11                	js     80251e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 15 60 30 80 00    	mov    0x803060,%edx
  802516:	39 10                	cmp    %edx,(%eax)
  802518:	0f 94 c0             	sete   %al
  80251b:	0f b6 c0             	movzbl %al,%eax
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <opencons>:
{
  802520:	f3 0f 1e fb          	endbr32 
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80252a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252d:	50                   	push   %eax
  80252e:	e8 70 ee ff ff       	call   8013a3 <fd_alloc>
  802533:	83 c4 10             	add    $0x10,%esp
  802536:	85 c0                	test   %eax,%eax
  802538:	78 3a                	js     802574 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80253a:	83 ec 04             	sub    $0x4,%esp
  80253d:	68 07 04 00 00       	push   $0x407
  802542:	ff 75 f4             	pushl  -0xc(%ebp)
  802545:	6a 00                	push   $0x0
  802547:	e8 ad e7 ff ff       	call   800cf9 <sys_page_alloc>
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	85 c0                	test   %eax,%eax
  802551:	78 21                	js     802574 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 15 60 30 80 00    	mov    0x803060,%edx
  80255c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	50                   	push   %eax
  80256c:	e8 03 ee ff ff       	call   801374 <fd2num>
  802571:	83 c4 10             	add    $0x10,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802576:	f3 0f 1e fb          	endbr32 
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	56                   	push   %esi
  80257e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80257f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802582:	8b 35 08 30 80 00    	mov    0x803008,%esi
  802588:	e8 26 e7 ff ff       	call   800cb3 <sys_getenvid>
  80258d:	83 ec 0c             	sub    $0xc,%esp
  802590:	ff 75 0c             	pushl  0xc(%ebp)
  802593:	ff 75 08             	pushl  0x8(%ebp)
  802596:	56                   	push   %esi
  802597:	50                   	push   %eax
  802598:	68 50 2f 80 00       	push   $0x802f50
  80259d:	e8 0b dd ff ff       	call   8002ad <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025a2:	83 c4 18             	add    $0x18,%esp
  8025a5:	53                   	push   %ebx
  8025a6:	ff 75 10             	pushl  0x10(%ebp)
  8025a9:	e8 aa dc ff ff       	call   800258 <vcprintf>
	cprintf("\n");
  8025ae:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8025b5:	e8 f3 dc ff ff       	call   8002ad <cprintf>
  8025ba:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025bd:	cc                   	int3   
  8025be:	eb fd                	jmp    8025bd <_panic+0x47>

008025c0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025c0:	f3 0f 1e fb          	endbr32 
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025ca:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8025d1:	74 0a                	je     8025dd <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  8025dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8025e2:	8b 40 48             	mov    0x48(%eax),%eax
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	6a 07                	push   $0x7
  8025ea:	68 00 f0 bf ee       	push   $0xeebff000
  8025ef:	50                   	push   %eax
  8025f0:	e8 04 e7 ff ff       	call   800cf9 <sys_page_alloc>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	75 31                	jne    80262d <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  8025fc:	a1 08 40 80 00       	mov    0x804008,%eax
  802601:	8b 40 48             	mov    0x48(%eax),%eax
  802604:	83 ec 08             	sub    $0x8,%esp
  802607:	68 41 26 80 00       	push   $0x802641
  80260c:	50                   	push   %eax
  80260d:	e8 46 e8 ff ff       	call   800e58 <sys_env_set_pgfault_upcall>
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	85 c0                	test   %eax,%eax
  802617:	74 ba                	je     8025d3 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 9c 2f 80 00       	push   $0x802f9c
  802621:	6a 24                	push   $0x24
  802623:	68 ca 2f 80 00       	push   $0x802fca
  802628:	e8 49 ff ff ff       	call   802576 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 74 2f 80 00       	push   $0x802f74
  802635:	6a 21                	push   $0x21
  802637:	68 ca 2f 80 00       	push   $0x802fca
  80263c:	e8 35 ff ff ff       	call   802576 <_panic>

00802641 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802641:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802642:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802647:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802649:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  80264c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802650:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802655:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802659:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  80265b:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  80265e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  80265f:	83 c4 04             	add    $0x4,%esp
    popfl
  802662:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802663:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802664:	c3                   	ret    

00802665 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802665:	f3 0f 1e fb          	endbr32 
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80266f:	89 c2                	mov    %eax,%edx
  802671:	c1 ea 16             	shr    $0x16,%edx
  802674:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80267b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802680:	f6 c1 01             	test   $0x1,%cl
  802683:	74 1c                	je     8026a1 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802685:	c1 e8 0c             	shr    $0xc,%eax
  802688:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80268f:	a8 01                	test   $0x1,%al
  802691:	74 0e                	je     8026a1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802693:	c1 e8 0c             	shr    $0xc,%eax
  802696:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80269d:	ef 
  80269e:	0f b7 d2             	movzwl %dx,%edx
}
  8026a1:	89 d0                	mov    %edx,%eax
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    
  8026a5:	66 90                	xchg   %ax,%ax
  8026a7:	66 90                	xchg   %ax,%ax
  8026a9:	66 90                	xchg   %ax,%ax
  8026ab:	66 90                	xchg   %ax,%ax
  8026ad:	66 90                	xchg   %ax,%ax
  8026af:	90                   	nop

008026b0 <__udivdi3>:
  8026b0:	f3 0f 1e fb          	endbr32 
  8026b4:	55                   	push   %ebp
  8026b5:	57                   	push   %edi
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	83 ec 1c             	sub    $0x1c,%esp
  8026bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026cb:	85 d2                	test   %edx,%edx
  8026cd:	75 19                	jne    8026e8 <__udivdi3+0x38>
  8026cf:	39 f3                	cmp    %esi,%ebx
  8026d1:	76 4d                	jbe    802720 <__udivdi3+0x70>
  8026d3:	31 ff                	xor    %edi,%edi
  8026d5:	89 e8                	mov    %ebp,%eax
  8026d7:	89 f2                	mov    %esi,%edx
  8026d9:	f7 f3                	div    %ebx
  8026db:	89 fa                	mov    %edi,%edx
  8026dd:	83 c4 1c             	add    $0x1c,%esp
  8026e0:	5b                   	pop    %ebx
  8026e1:	5e                   	pop    %esi
  8026e2:	5f                   	pop    %edi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    
  8026e5:	8d 76 00             	lea    0x0(%esi),%esi
  8026e8:	39 f2                	cmp    %esi,%edx
  8026ea:	76 14                	jbe    802700 <__udivdi3+0x50>
  8026ec:	31 ff                	xor    %edi,%edi
  8026ee:	31 c0                	xor    %eax,%eax
  8026f0:	89 fa                	mov    %edi,%edx
  8026f2:	83 c4 1c             	add    $0x1c,%esp
  8026f5:	5b                   	pop    %ebx
  8026f6:	5e                   	pop    %esi
  8026f7:	5f                   	pop    %edi
  8026f8:	5d                   	pop    %ebp
  8026f9:	c3                   	ret    
  8026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802700:	0f bd fa             	bsr    %edx,%edi
  802703:	83 f7 1f             	xor    $0x1f,%edi
  802706:	75 48                	jne    802750 <__udivdi3+0xa0>
  802708:	39 f2                	cmp    %esi,%edx
  80270a:	72 06                	jb     802712 <__udivdi3+0x62>
  80270c:	31 c0                	xor    %eax,%eax
  80270e:	39 eb                	cmp    %ebp,%ebx
  802710:	77 de                	ja     8026f0 <__udivdi3+0x40>
  802712:	b8 01 00 00 00       	mov    $0x1,%eax
  802717:	eb d7                	jmp    8026f0 <__udivdi3+0x40>
  802719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802720:	89 d9                	mov    %ebx,%ecx
  802722:	85 db                	test   %ebx,%ebx
  802724:	75 0b                	jne    802731 <__udivdi3+0x81>
  802726:	b8 01 00 00 00       	mov    $0x1,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	f7 f3                	div    %ebx
  80272f:	89 c1                	mov    %eax,%ecx
  802731:	31 d2                	xor    %edx,%edx
  802733:	89 f0                	mov    %esi,%eax
  802735:	f7 f1                	div    %ecx
  802737:	89 c6                	mov    %eax,%esi
  802739:	89 e8                	mov    %ebp,%eax
  80273b:	89 f7                	mov    %esi,%edi
  80273d:	f7 f1                	div    %ecx
  80273f:	89 fa                	mov    %edi,%edx
  802741:	83 c4 1c             	add    $0x1c,%esp
  802744:	5b                   	pop    %ebx
  802745:	5e                   	pop    %esi
  802746:	5f                   	pop    %edi
  802747:	5d                   	pop    %ebp
  802748:	c3                   	ret    
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	89 f9                	mov    %edi,%ecx
  802752:	b8 20 00 00 00       	mov    $0x20,%eax
  802757:	29 f8                	sub    %edi,%eax
  802759:	d3 e2                	shl    %cl,%edx
  80275b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80275f:	89 c1                	mov    %eax,%ecx
  802761:	89 da                	mov    %ebx,%edx
  802763:	d3 ea                	shr    %cl,%edx
  802765:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802769:	09 d1                	or     %edx,%ecx
  80276b:	89 f2                	mov    %esi,%edx
  80276d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802771:	89 f9                	mov    %edi,%ecx
  802773:	d3 e3                	shl    %cl,%ebx
  802775:	89 c1                	mov    %eax,%ecx
  802777:	d3 ea                	shr    %cl,%edx
  802779:	89 f9                	mov    %edi,%ecx
  80277b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80277f:	89 eb                	mov    %ebp,%ebx
  802781:	d3 e6                	shl    %cl,%esi
  802783:	89 c1                	mov    %eax,%ecx
  802785:	d3 eb                	shr    %cl,%ebx
  802787:	09 de                	or     %ebx,%esi
  802789:	89 f0                	mov    %esi,%eax
  80278b:	f7 74 24 08          	divl   0x8(%esp)
  80278f:	89 d6                	mov    %edx,%esi
  802791:	89 c3                	mov    %eax,%ebx
  802793:	f7 64 24 0c          	mull   0xc(%esp)
  802797:	39 d6                	cmp    %edx,%esi
  802799:	72 15                	jb     8027b0 <__udivdi3+0x100>
  80279b:	89 f9                	mov    %edi,%ecx
  80279d:	d3 e5                	shl    %cl,%ebp
  80279f:	39 c5                	cmp    %eax,%ebp
  8027a1:	73 04                	jae    8027a7 <__udivdi3+0xf7>
  8027a3:	39 d6                	cmp    %edx,%esi
  8027a5:	74 09                	je     8027b0 <__udivdi3+0x100>
  8027a7:	89 d8                	mov    %ebx,%eax
  8027a9:	31 ff                	xor    %edi,%edi
  8027ab:	e9 40 ff ff ff       	jmp    8026f0 <__udivdi3+0x40>
  8027b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027b3:	31 ff                	xor    %edi,%edi
  8027b5:	e9 36 ff ff ff       	jmp    8026f0 <__udivdi3+0x40>
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	66 90                	xchg   %ax,%ax
  8027be:	66 90                	xchg   %ax,%ax

008027c0 <__umoddi3>:
  8027c0:	f3 0f 1e fb          	endbr32 
  8027c4:	55                   	push   %ebp
  8027c5:	57                   	push   %edi
  8027c6:	56                   	push   %esi
  8027c7:	53                   	push   %ebx
  8027c8:	83 ec 1c             	sub    $0x1c,%esp
  8027cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	75 19                	jne    8027f8 <__umoddi3+0x38>
  8027df:	39 df                	cmp    %ebx,%edi
  8027e1:	76 5d                	jbe    802840 <__umoddi3+0x80>
  8027e3:	89 f0                	mov    %esi,%eax
  8027e5:	89 da                	mov    %ebx,%edx
  8027e7:	f7 f7                	div    %edi
  8027e9:	89 d0                	mov    %edx,%eax
  8027eb:	31 d2                	xor    %edx,%edx
  8027ed:	83 c4 1c             	add    $0x1c,%esp
  8027f0:	5b                   	pop    %ebx
  8027f1:	5e                   	pop    %esi
  8027f2:	5f                   	pop    %edi
  8027f3:	5d                   	pop    %ebp
  8027f4:	c3                   	ret    
  8027f5:	8d 76 00             	lea    0x0(%esi),%esi
  8027f8:	89 f2                	mov    %esi,%edx
  8027fa:	39 d8                	cmp    %ebx,%eax
  8027fc:	76 12                	jbe    802810 <__umoddi3+0x50>
  8027fe:	89 f0                	mov    %esi,%eax
  802800:	89 da                	mov    %ebx,%edx
  802802:	83 c4 1c             	add    $0x1c,%esp
  802805:	5b                   	pop    %ebx
  802806:	5e                   	pop    %esi
  802807:	5f                   	pop    %edi
  802808:	5d                   	pop    %ebp
  802809:	c3                   	ret    
  80280a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802810:	0f bd e8             	bsr    %eax,%ebp
  802813:	83 f5 1f             	xor    $0x1f,%ebp
  802816:	75 50                	jne    802868 <__umoddi3+0xa8>
  802818:	39 d8                	cmp    %ebx,%eax
  80281a:	0f 82 e0 00 00 00    	jb     802900 <__umoddi3+0x140>
  802820:	89 d9                	mov    %ebx,%ecx
  802822:	39 f7                	cmp    %esi,%edi
  802824:	0f 86 d6 00 00 00    	jbe    802900 <__umoddi3+0x140>
  80282a:	89 d0                	mov    %edx,%eax
  80282c:	89 ca                	mov    %ecx,%edx
  80282e:	83 c4 1c             	add    $0x1c,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80283d:	8d 76 00             	lea    0x0(%esi),%esi
  802840:	89 fd                	mov    %edi,%ebp
  802842:	85 ff                	test   %edi,%edi
  802844:	75 0b                	jne    802851 <__umoddi3+0x91>
  802846:	b8 01 00 00 00       	mov    $0x1,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	f7 f7                	div    %edi
  80284f:	89 c5                	mov    %eax,%ebp
  802851:	89 d8                	mov    %ebx,%eax
  802853:	31 d2                	xor    %edx,%edx
  802855:	f7 f5                	div    %ebp
  802857:	89 f0                	mov    %esi,%eax
  802859:	f7 f5                	div    %ebp
  80285b:	89 d0                	mov    %edx,%eax
  80285d:	31 d2                	xor    %edx,%edx
  80285f:	eb 8c                	jmp    8027ed <__umoddi3+0x2d>
  802861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802868:	89 e9                	mov    %ebp,%ecx
  80286a:	ba 20 00 00 00       	mov    $0x20,%edx
  80286f:	29 ea                	sub    %ebp,%edx
  802871:	d3 e0                	shl    %cl,%eax
  802873:	89 44 24 08          	mov    %eax,0x8(%esp)
  802877:	89 d1                	mov    %edx,%ecx
  802879:	89 f8                	mov    %edi,%eax
  80287b:	d3 e8                	shr    %cl,%eax
  80287d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802881:	89 54 24 04          	mov    %edx,0x4(%esp)
  802885:	8b 54 24 04          	mov    0x4(%esp),%edx
  802889:	09 c1                	or     %eax,%ecx
  80288b:	89 d8                	mov    %ebx,%eax
  80288d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802891:	89 e9                	mov    %ebp,%ecx
  802893:	d3 e7                	shl    %cl,%edi
  802895:	89 d1                	mov    %edx,%ecx
  802897:	d3 e8                	shr    %cl,%eax
  802899:	89 e9                	mov    %ebp,%ecx
  80289b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80289f:	d3 e3                	shl    %cl,%ebx
  8028a1:	89 c7                	mov    %eax,%edi
  8028a3:	89 d1                	mov    %edx,%ecx
  8028a5:	89 f0                	mov    %esi,%eax
  8028a7:	d3 e8                	shr    %cl,%eax
  8028a9:	89 e9                	mov    %ebp,%ecx
  8028ab:	89 fa                	mov    %edi,%edx
  8028ad:	d3 e6                	shl    %cl,%esi
  8028af:	09 d8                	or     %ebx,%eax
  8028b1:	f7 74 24 08          	divl   0x8(%esp)
  8028b5:	89 d1                	mov    %edx,%ecx
  8028b7:	89 f3                	mov    %esi,%ebx
  8028b9:	f7 64 24 0c          	mull   0xc(%esp)
  8028bd:	89 c6                	mov    %eax,%esi
  8028bf:	89 d7                	mov    %edx,%edi
  8028c1:	39 d1                	cmp    %edx,%ecx
  8028c3:	72 06                	jb     8028cb <__umoddi3+0x10b>
  8028c5:	75 10                	jne    8028d7 <__umoddi3+0x117>
  8028c7:	39 c3                	cmp    %eax,%ebx
  8028c9:	73 0c                	jae    8028d7 <__umoddi3+0x117>
  8028cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8028cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8028d3:	89 d7                	mov    %edx,%edi
  8028d5:	89 c6                	mov    %eax,%esi
  8028d7:	89 ca                	mov    %ecx,%edx
  8028d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028de:	29 f3                	sub    %esi,%ebx
  8028e0:	19 fa                	sbb    %edi,%edx
  8028e2:	89 d0                	mov    %edx,%eax
  8028e4:	d3 e0                	shl    %cl,%eax
  8028e6:	89 e9                	mov    %ebp,%ecx
  8028e8:	d3 eb                	shr    %cl,%ebx
  8028ea:	d3 ea                	shr    %cl,%edx
  8028ec:	09 d8                	or     %ebx,%eax
  8028ee:	83 c4 1c             	add    $0x1c,%esp
  8028f1:	5b                   	pop    %ebx
  8028f2:	5e                   	pop    %esi
  8028f3:	5f                   	pop    %edi
  8028f4:	5d                   	pop    %ebp
  8028f5:	c3                   	ret    
  8028f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028fd:	8d 76 00             	lea    0x0(%esi),%esi
  802900:	29 fe                	sub    %edi,%esi
  802902:	19 c3                	sbb    %eax,%ebx
  802904:	89 f2                	mov    %esi,%edx
  802906:	89 d9                	mov    %ebx,%ecx
  802908:	e9 1d ff ff ff       	jmp    80282a <__umoddi3+0x6a>
