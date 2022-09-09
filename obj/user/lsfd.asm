
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e8 00 00 00       	call   800119 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  80003d:	68 20 27 80 00       	push   $0x802720
  800042:	e8 d7 01 00 00       	call   80021e <cprintf>
	exit();
  800047:	e8 17 01 00 00       	call   800163 <exit>
}
  80004c:	83 c4 10             	add    $0x10,%esp
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <umain>:

void
umain(int argc, char **argv)
{
  800051:	f3 0f 1e fb          	endbr32 
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	57                   	push   %edi
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800061:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	ff 75 0c             	pushl  0xc(%ebp)
  80006b:	8d 45 08             	lea    0x8(%ebp),%eax
  80006e:	50                   	push   %eax
  80006f:	e8 2a 0e 00 00       	call   800e9e <argstart>
	while ((i = argnext(&args)) >= 0)
  800074:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  800077:	be 00 00 00 00       	mov    $0x0,%esi
	while ((i = argnext(&args)) >= 0)
  80007c:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  800082:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((i = argnext(&args)) >= 0)
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	53                   	push   %ebx
  80008b:	e8 42 0e 00 00       	call   800ed2 <argnext>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	85 c0                	test   %eax,%eax
  800095:	78 10                	js     8000a7 <umain+0x56>
		if (i == '1')
  800097:	83 f8 31             	cmp    $0x31,%eax
  80009a:	75 04                	jne    8000a0 <umain+0x4f>
			usefprint = 1;
  80009c:	89 fe                	mov    %edi,%esi
  80009e:	eb e7                	jmp    800087 <umain+0x36>
		else
			usage();
  8000a0:	e8 8e ff ff ff       	call   800033 <usage>
  8000a5:	eb e0                	jmp    800087 <umain+0x36>

	for (i = 0; i < 32; i++)
  8000a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000ac:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000b2:	eb 26                	jmp    8000da <umain+0x89>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ba:	ff 70 04             	pushl  0x4(%eax)
  8000bd:	ff 75 dc             	pushl  -0x24(%ebp)
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	57                   	push   %edi
  8000c4:	53                   	push   %ebx
  8000c5:	68 34 27 80 00       	push   $0x802734
  8000ca:	e8 4f 01 00 00       	call   80021e <cprintf>
  8000cf:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000d2:	83 c3 01             	add    $0x1,%ebx
  8000d5:	83 fb 20             	cmp    $0x20,%ebx
  8000d8:	74 37                	je     800111 <umain+0xc0>
		if (fstat(i, &st) >= 0) {
  8000da:	83 ec 08             	sub    $0x8,%esp
  8000dd:	57                   	push   %edi
  8000de:	53                   	push   %ebx
  8000df:	e8 32 14 00 00       	call   801516 <fstat>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	85 c0                	test   %eax,%eax
  8000e9:	78 e7                	js     8000d2 <umain+0x81>
			if (usefprint)
  8000eb:	85 f6                	test   %esi,%esi
  8000ed:	74 c5                	je     8000b4 <umain+0x63>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	ff 70 04             	pushl  0x4(%eax)
  8000f8:	ff 75 dc             	pushl  -0x24(%ebp)
  8000fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fe:	57                   	push   %edi
  8000ff:	53                   	push   %ebx
  800100:	68 34 27 80 00       	push   $0x802734
  800105:	6a 01                	push   $0x1
  800107:	e8 2f 18 00 00       	call   80193b <fprintf>
  80010c:	83 c4 20             	add    $0x20,%esp
  80010f:	eb c1                	jmp    8000d2 <umain+0x81>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800119:	f3 0f 1e fb          	endbr32 
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	56                   	push   %esi
  800121:	53                   	push   %ebx
  800122:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800125:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800128:	e8 f7 0a 00 00       	call   800c24 <sys_getenvid>
  80012d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800132:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800135:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80013a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013f:	85 db                	test   %ebx,%ebx
  800141:	7e 07                	jle    80014a <libmain+0x31>
		binaryname = argv[0];
  800143:	8b 06                	mov    (%esi),%eax
  800145:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
  80014f:	e8 fd fe ff ff       	call   800051 <umain>

	// exit gracefully
	exit();
  800154:	e8 0a 00 00 00       	call   800163 <exit>
}
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80015f:	5b                   	pop    %ebx
  800160:	5e                   	pop    %esi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800163:	f3 0f 1e fb          	endbr32 
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80016d:	e8 7f 10 00 00       	call   8011f1 <close_all>
	sys_env_destroy(0);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	6a 00                	push   $0x0
  800177:	e8 63 0a 00 00       	call   800bdf <sys_env_destroy>
}
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800181:	f3 0f 1e fb          	endbr32 
  800185:	55                   	push   %ebp
  800186:	89 e5                	mov    %esp,%ebp
  800188:	53                   	push   %ebx
  800189:	83 ec 04             	sub    $0x4,%esp
  80018c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018f:	8b 13                	mov    (%ebx),%edx
  800191:	8d 42 01             	lea    0x1(%edx),%eax
  800194:	89 03                	mov    %eax,(%ebx)
  800196:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800199:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a2:	74 09                	je     8001ad <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ad:	83 ec 08             	sub    $0x8,%esp
  8001b0:	68 ff 00 00 00       	push   $0xff
  8001b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b8:	50                   	push   %eax
  8001b9:	e8 dc 09 00 00       	call   800b9a <sys_cputs>
		b->idx = 0;
  8001be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	eb db                	jmp    8001a4 <putch+0x23>

008001c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001dd:	00 00 00 
	b.cnt = 0;
  8001e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ea:	ff 75 0c             	pushl  0xc(%ebp)
  8001ed:	ff 75 08             	pushl  0x8(%ebp)
  8001f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f6:	50                   	push   %eax
  8001f7:	68 81 01 80 00       	push   $0x800181
  8001fc:	e8 20 01 00 00       	call   800321 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800201:	83 c4 08             	add    $0x8,%esp
  800204:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 84 09 00 00       	call   800b9a <sys_cputs>

	return b.cnt;
}
  800216:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021c:	c9                   	leave  
  80021d:	c3                   	ret    

0080021e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80021e:	f3 0f 1e fb          	endbr32 
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800228:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022b:	50                   	push   %eax
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	e8 95 ff ff ff       	call   8001c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	57                   	push   %edi
  80023a:	56                   	push   %esi
  80023b:	53                   	push   %ebx
  80023c:	83 ec 1c             	sub    $0x1c,%esp
  80023f:	89 c7                	mov    %eax,%edi
  800241:	89 d6                	mov    %edx,%esi
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	8b 55 0c             	mov    0xc(%ebp),%edx
  800249:	89 d1                	mov    %edx,%ecx
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800250:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800253:	8b 45 10             	mov    0x10(%ebp),%eax
  800256:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800263:	39 c2                	cmp    %eax,%edx
  800265:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800268:	72 3e                	jb     8002a8 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	ff 75 18             	pushl  0x18(%ebp)
  800270:	83 eb 01             	sub    $0x1,%ebx
  800273:	53                   	push   %ebx
  800274:	50                   	push   %eax
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027b:	ff 75 e0             	pushl  -0x20(%ebp)
  80027e:	ff 75 dc             	pushl  -0x24(%ebp)
  800281:	ff 75 d8             	pushl  -0x28(%ebp)
  800284:	e8 37 22 00 00       	call   8024c0 <__udivdi3>
  800289:	83 c4 18             	add    $0x18,%esp
  80028c:	52                   	push   %edx
  80028d:	50                   	push   %eax
  80028e:	89 f2                	mov    %esi,%edx
  800290:	89 f8                	mov    %edi,%eax
  800292:	e8 9f ff ff ff       	call   800236 <printnum>
  800297:	83 c4 20             	add    $0x20,%esp
  80029a:	eb 13                	jmp    8002af <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	56                   	push   %esi
  8002a0:	ff 75 18             	pushl  0x18(%ebp)
  8002a3:	ff d7                	call   *%edi
  8002a5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002a8:	83 eb 01             	sub    $0x1,%ebx
  8002ab:	85 db                	test   %ebx,%ebx
  8002ad:	7f ed                	jg     80029c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	56                   	push   %esi
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c2:	e8 09 23 00 00       	call   8025d0 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 66 27 80 00 	movsbl 0x802766(%eax),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff d7                	call   *%edi
}
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002df:	f3 0f 1e fb          	endbr32 
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f2:	73 0a                	jae    8002fe <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f7:	89 08                	mov    %ecx,(%eax)
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	88 02                	mov    %al,(%edx)
}
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    

00800300 <printfmt>:
{
  800300:	f3 0f 1e fb          	endbr32 
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030d:	50                   	push   %eax
  80030e:	ff 75 10             	pushl  0x10(%ebp)
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	e8 05 00 00 00       	call   800321 <vprintfmt>
}
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <vprintfmt>:
{
  800321:	f3 0f 1e fb          	endbr32 
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	57                   	push   %edi
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
  80032b:	83 ec 3c             	sub    $0x3c,%esp
  80032e:	8b 75 08             	mov    0x8(%ebp),%esi
  800331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800334:	8b 7d 10             	mov    0x10(%ebp),%edi
  800337:	e9 8e 03 00 00       	jmp    8006ca <vprintfmt+0x3a9>
		padc = ' ';
  80033c:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800340:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800347:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800355:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 47 01             	lea    0x1(%edi),%eax
  80035d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800360:	0f b6 17             	movzbl (%edi),%edx
  800363:	8d 42 dd             	lea    -0x23(%edx),%eax
  800366:	3c 55                	cmp    $0x55,%al
  800368:	0f 87 df 03 00 00    	ja     80074d <vprintfmt+0x42c>
  80036e:	0f b6 c0             	movzbl %al,%eax
  800371:	3e ff 24 85 a0 28 80 	notrack jmp *0x8028a0(,%eax,4)
  800378:	00 
  800379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800380:	eb d8                	jmp    80035a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800385:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800389:	eb cf                	jmp    80035a <vprintfmt+0x39>
  80038b:	0f b6 d2             	movzbl %dl,%edx
  80038e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800391:	b8 00 00 00 00       	mov    $0x0,%eax
  800396:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800399:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a6:	83 f9 09             	cmp    $0x9,%ecx
  8003a9:	77 55                	ja     800400 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003ab:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ae:	eb e9                	jmp    800399 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 40 04             	lea    0x4(%eax),%eax
  8003be:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c8:	79 90                	jns    80035a <vprintfmt+0x39>
				width = precision, precision = -1;
  8003ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d7:	eb 81                	jmp    80035a <vprintfmt+0x39>
  8003d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e3:	0f 49 d0             	cmovns %eax,%edx
  8003e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ec:	e9 69 ff ff ff       	jmp    80035a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fb:	e9 5a ff ff ff       	jmp    80035a <vprintfmt+0x39>
  800400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800403:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800406:	eb bc                	jmp    8003c4 <vprintfmt+0xa3>
			lflag++;
  800408:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040e:	e9 47 ff ff ff       	jmp    80035a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8d 78 04             	lea    0x4(%eax),%edi
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 30                	pushl  (%eax)
  80041f:	ff d6                	call   *%esi
			break;
  800421:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800427:	e9 9b 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 78 04             	lea    0x4(%eax),%edi
  800432:	8b 00                	mov    (%eax),%eax
  800434:	99                   	cltd   
  800435:	31 d0                	xor    %edx,%eax
  800437:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800439:	83 f8 0f             	cmp    $0xf,%eax
  80043c:	7f 23                	jg     800461 <vprintfmt+0x140>
  80043e:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 18                	je     800461 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800449:	52                   	push   %edx
  80044a:	68 35 2b 80 00       	push   $0x802b35
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 aa fe ff ff       	call   800300 <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 66 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 7e 27 80 00       	push   $0x80277e
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 92 fe ff ff       	call   800300 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800474:	e9 4e 02 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	83 c0 04             	add    $0x4,%eax
  80047f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 77 27 80 00       	mov    $0x802777,%eax
  80048e:	0f 45 c2             	cmovne %edx,%eax
  800491:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800494:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800498:	7e 06                	jle    8004a0 <vprintfmt+0x17f>
  80049a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80049e:	75 0d                	jne    8004ad <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a3:	89 c7                	mov    %eax,%edi
  8004a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ab:	eb 55                	jmp    800502 <vprintfmt+0x1e1>
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b6:	e8 46 03 00 00       	call   800801 <strnlen>
  8004bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004be:	29 c2                	sub    %eax,%edx
  8004c0:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004c8:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	85 ff                	test   %edi,%edi
  8004d1:	7e 11                	jle    8004e4 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	83 ef 01             	sub    $0x1,%edi
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	eb eb                	jmp    8004cf <vprintfmt+0x1ae>
  8004e4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c2             	cmovns %edx,%eax
  8004f1:	29 c2                	sub    %eax,%edx
  8004f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f6:	eb a8                	jmp    8004a0 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	53                   	push   %ebx
  8004fc:	52                   	push   %edx
  8004fd:	ff d6                	call   *%esi
  8004ff:	83 c4 10             	add    $0x10,%esp
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 c7 01             	add    $0x1,%edi
  80050a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050e:	0f be d0             	movsbl %al,%edx
  800511:	85 d2                	test   %edx,%edx
  800513:	74 4b                	je     800560 <vprintfmt+0x23f>
  800515:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800519:	78 06                	js     800521 <vprintfmt+0x200>
  80051b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051f:	78 1e                	js     80053f <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800521:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800525:	74 d1                	je     8004f8 <vprintfmt+0x1d7>
  800527:	0f be c0             	movsbl %al,%eax
  80052a:	83 e8 20             	sub    $0x20,%eax
  80052d:	83 f8 5e             	cmp    $0x5e,%eax
  800530:	76 c6                	jbe    8004f8 <vprintfmt+0x1d7>
					putch('?', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 3f                	push   $0x3f
  800538:	ff d6                	call   *%esi
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	eb c3                	jmp    800502 <vprintfmt+0x1e1>
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	eb 0e                	jmp    800551 <vprintfmt+0x230>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 67 01 00 00       	jmp    8006c7 <vprintfmt+0x3a6>
  800560:	89 cf                	mov    %ecx,%edi
  800562:	eb ed                	jmp    800551 <vprintfmt+0x230>
	if (lflag >= 2)
  800564:	83 f9 01             	cmp    $0x1,%ecx
  800567:	7f 1b                	jg     800584 <vprintfmt+0x263>
	else if (lflag)
  800569:	85 c9                	test   %ecx,%ecx
  80056b:	74 63                	je     8005d0 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800575:	99                   	cltd   
  800576:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 40 04             	lea    0x4(%eax),%eax
  80057f:	89 45 14             	mov    %eax,0x14(%ebp)
  800582:	eb 17                	jmp    80059b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 50 04             	mov    0x4(%eax),%edx
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a6:	85 c9                	test   %ecx,%ecx
  8005a8:	0f 89 ff 00 00 00    	jns    8006ad <vprintfmt+0x38c>
				putch('-', putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	6a 2d                	push   $0x2d
  8005b4:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bc:	f7 da                	neg    %edx
  8005be:	83 d1 00             	adc    $0x0,%ecx
  8005c1:	f7 d9                	neg    %ecx
  8005c3:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cb:	e9 dd 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d8:	99                   	cltd   
  8005d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	eb b4                	jmp    80059b <vprintfmt+0x27a>
	if (lflag >= 2)
  8005e7:	83 f9 01             	cmp    $0x1,%ecx
  8005ea:	7f 1e                	jg     80060a <vprintfmt+0x2e9>
	else if (lflag)
  8005ec:	85 c9                	test   %ecx,%ecx
  8005ee:	74 32                	je     800622 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fa:	8d 40 04             	lea    0x4(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800600:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800605:	e9 a3 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 48 04             	mov    0x4(%eax),%ecx
  800612:	8d 40 08             	lea    0x8(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80061d:	e9 8b 00 00 00       	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062c:	8d 40 04             	lea    0x4(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800637:	eb 74                	jmp    8006ad <vprintfmt+0x38c>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 1b                	jg     800659 <vprintfmt+0x338>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 2c                	je     80066e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800652:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800657:	eb 54                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800667:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80066c:	eb 3f                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800683:	eb 28                	jmp    8006ad <vprintfmt+0x38c>
			putch('0', putdat);
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	53                   	push   %ebx
  800689:	6a 30                	push   $0x30
  80068b:	ff d6                	call   *%esi
			putch('x', putdat);
  80068d:	83 c4 08             	add    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 78                	push   $0x78
  800693:	ff d6                	call   *%esi
			num = (unsigned long long)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a2:	8d 40 04             	lea    0x4(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ad:	83 ec 0c             	sub    $0xc,%esp
  8006b0:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b4:	57                   	push   %edi
  8006b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b8:	50                   	push   %eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	89 da                	mov    %ebx,%edx
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	e8 72 fb ff ff       	call   800236 <printnum>
			break;
  8006c4:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ca:	83 c7 01             	add    $0x1,%edi
  8006cd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d1:	83 f8 25             	cmp    $0x25,%eax
  8006d4:	0f 84 62 fc ff ff    	je     80033c <vprintfmt+0x1b>
			if (ch == '\0')
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	0f 84 8b 00 00 00    	je     80076d <vprintfmt+0x44c>
			putch(ch, putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	53                   	push   %ebx
  8006e6:	50                   	push   %eax
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb dc                	jmp    8006ca <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006ee:	83 f9 01             	cmp    $0x1,%ecx
  8006f1:	7f 1b                	jg     80070e <vprintfmt+0x3ed>
	else if (lflag)
  8006f3:	85 c9                	test   %ecx,%ecx
  8006f5:	74 2c                	je     800723 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8b 10                	mov    (%eax),%edx
  8006fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800701:	8d 40 04             	lea    0x4(%eax),%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800707:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80070c:	eb 9f                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8b 10                	mov    (%eax),%edx
  800713:	8b 48 04             	mov    0x4(%eax),%ecx
  800716:	8d 40 08             	lea    0x8(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800721:	eb 8a                	jmp    8006ad <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 10                	mov    (%eax),%edx
  800728:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800733:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800738:	e9 70 ff ff ff       	jmp    8006ad <vprintfmt+0x38c>
			putch(ch, putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 25                	push   $0x25
  800743:	ff d6                	call   *%esi
			break;
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	e9 7a ff ff ff       	jmp    8006c7 <vprintfmt+0x3a6>
			putch('%', putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 25                	push   $0x25
  800753:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	89 f8                	mov    %edi,%eax
  80075a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075e:	74 05                	je     800765 <vprintfmt+0x444>
  800760:	83 e8 01             	sub    $0x1,%eax
  800763:	eb f5                	jmp    80075a <vprintfmt+0x439>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800768:	e9 5a ff ff ff       	jmp    8006c7 <vprintfmt+0x3a6>
}
  80076d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800770:	5b                   	pop    %ebx
  800771:	5e                   	pop    %esi
  800772:	5f                   	pop    %edi
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800775:	f3 0f 1e fb          	endbr32 
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 18             	sub    $0x18,%esp
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800785:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800788:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80078f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800796:	85 c0                	test   %eax,%eax
  800798:	74 26                	je     8007c0 <vsnprintf+0x4b>
  80079a:	85 d2                	test   %edx,%edx
  80079c:	7e 22                	jle    8007c0 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80079e:	ff 75 14             	pushl  0x14(%ebp)
  8007a1:	ff 75 10             	pushl  0x10(%ebp)
  8007a4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a7:	50                   	push   %eax
  8007a8:	68 df 02 80 00       	push   $0x8002df
  8007ad:	e8 6f fb ff ff       	call   800321 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    
		return -E_INVAL;
  8007c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c5:	eb f7                	jmp    8007be <vsnprintf+0x49>

008007c7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c7:	f3 0f 1e fb          	endbr32 
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d4:	50                   	push   %eax
  8007d5:	ff 75 10             	pushl  0x10(%ebp)
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	ff 75 08             	pushl  0x8(%ebp)
  8007de:	e8 92 ff ff ff       	call   800775 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e5:	f3 0f 1e fb          	endbr32 
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f8:	74 05                	je     8007ff <strlen+0x1a>
		n++;
  8007fa:	83 c0 01             	add    $0x1,%eax
  8007fd:	eb f5                	jmp    8007f4 <strlen+0xf>
	return n;
}
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800801:	f3 0f 1e fb          	endbr32 
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	39 d0                	cmp    %edx,%eax
  800815:	74 0d                	je     800824 <strnlen+0x23>
  800817:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081b:	74 05                	je     800822 <strnlen+0x21>
		n++;
  80081d:	83 c0 01             	add    $0x1,%eax
  800820:	eb f1                	jmp    800813 <strnlen+0x12>
  800822:	89 c2                	mov    %eax,%edx
	return n;
}
  800824:	89 d0                	mov    %edx,%eax
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800828:	f3 0f 1e fb          	endbr32 
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800833:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80083f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800842:	83 c0 01             	add    $0x1,%eax
  800845:	84 d2                	test   %dl,%dl
  800847:	75 f2                	jne    80083b <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800849:	89 c8                	mov    %ecx,%eax
  80084b:	5b                   	pop    %ebx
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	83 ec 10             	sub    $0x10,%esp
  800859:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085c:	53                   	push   %ebx
  80085d:	e8 83 ff ff ff       	call   8007e5 <strlen>
  800862:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	01 d8                	add    %ebx,%eax
  80086a:	50                   	push   %eax
  80086b:	e8 b8 ff ff ff       	call   800828 <strcpy>
	return dst;
}
  800870:	89 d8                	mov    %ebx,%eax
  800872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800875:	c9                   	leave  
  800876:	c3                   	ret    

00800877 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800877:	f3 0f 1e fb          	endbr32 
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	56                   	push   %esi
  80087f:	53                   	push   %ebx
  800880:	8b 75 08             	mov    0x8(%ebp),%esi
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
  800886:	89 f3                	mov    %esi,%ebx
  800888:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088b:	89 f0                	mov    %esi,%eax
  80088d:	39 d8                	cmp    %ebx,%eax
  80088f:	74 11                	je     8008a2 <strncpy+0x2b>
		*dst++ = *src;
  800891:	83 c0 01             	add    $0x1,%eax
  800894:	0f b6 0a             	movzbl (%edx),%ecx
  800897:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089a:	80 f9 01             	cmp    $0x1,%cl
  80089d:	83 da ff             	sbb    $0xffffffff,%edx
  8008a0:	eb eb                	jmp    80088d <strncpy+0x16>
	}
	return ret;
}
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	5b                   	pop    %ebx
  8008a5:	5e                   	pop    %esi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a8:	f3 0f 1e fb          	endbr32 
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
  8008b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b7:	8b 55 10             	mov    0x10(%ebp),%edx
  8008ba:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	74 21                	je     8008e1 <strlcpy+0x39>
  8008c0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c6:	39 c2                	cmp    %eax,%edx
  8008c8:	74 14                	je     8008de <strlcpy+0x36>
  8008ca:	0f b6 19             	movzbl (%ecx),%ebx
  8008cd:	84 db                	test   %bl,%bl
  8008cf:	74 0b                	je     8008dc <strlcpy+0x34>
			*dst++ = *src++;
  8008d1:	83 c1 01             	add    $0x1,%ecx
  8008d4:	83 c2 01             	add    $0x1,%edx
  8008d7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008da:	eb ea                	jmp    8008c6 <strlcpy+0x1e>
  8008dc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e1:	29 f0                	sub    %esi,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5e                   	pop    %esi
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f4:	0f b6 01             	movzbl (%ecx),%eax
  8008f7:	84 c0                	test   %al,%al
  8008f9:	74 0c                	je     800907 <strcmp+0x20>
  8008fb:	3a 02                	cmp    (%edx),%al
  8008fd:	75 08                	jne    800907 <strcmp+0x20>
		p++, q++;
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	83 c2 01             	add    $0x1,%edx
  800905:	eb ed                	jmp    8008f4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800907:	0f b6 c0             	movzbl %al,%eax
  80090a:	0f b6 12             	movzbl (%edx),%edx
  80090d:	29 d0                	sub    %edx,%eax
}
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	89 c3                	mov    %eax,%ebx
  800921:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800924:	eb 06                	jmp    80092c <strncmp+0x1b>
		n--, p++, q++;
  800926:	83 c0 01             	add    $0x1,%eax
  800929:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092c:	39 d8                	cmp    %ebx,%eax
  80092e:	74 16                	je     800946 <strncmp+0x35>
  800930:	0f b6 08             	movzbl (%eax),%ecx
  800933:	84 c9                	test   %cl,%cl
  800935:	74 04                	je     80093b <strncmp+0x2a>
  800937:	3a 0a                	cmp    (%edx),%cl
  800939:	74 eb                	je     800926 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093b:	0f b6 00             	movzbl (%eax),%eax
  80093e:	0f b6 12             	movzbl (%edx),%edx
  800941:	29 d0                	sub    %edx,%eax
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    
		return 0;
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb f6                	jmp    800943 <strncmp+0x32>

0080094d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095b:	0f b6 10             	movzbl (%eax),%edx
  80095e:	84 d2                	test   %dl,%dl
  800960:	74 09                	je     80096b <strchr+0x1e>
		if (*s == c)
  800962:	38 ca                	cmp    %cl,%dl
  800964:	74 0a                	je     800970 <strchr+0x23>
	for (; *s; s++)
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	eb f0                	jmp    80095b <strchr+0xe>
			return (char *) s;
	return 0;
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800972:	f3 0f 1e fb          	endbr32 
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800980:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800983:	38 ca                	cmp    %cl,%dl
  800985:	74 09                	je     800990 <strfind+0x1e>
  800987:	84 d2                	test   %dl,%dl
  800989:	74 05                	je     800990 <strfind+0x1e>
	for (; *s; s++)
  80098b:	83 c0 01             	add    $0x1,%eax
  80098e:	eb f0                	jmp    800980 <strfind+0xe>
			break;
	return (char *) s;
}
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800992:	f3 0f 1e fb          	endbr32 
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	57                   	push   %edi
  80099a:	56                   	push   %esi
  80099b:	53                   	push   %ebx
  80099c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a2:	85 c9                	test   %ecx,%ecx
  8009a4:	74 31                	je     8009d7 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a6:	89 f8                	mov    %edi,%eax
  8009a8:	09 c8                	or     %ecx,%eax
  8009aa:	a8 03                	test   $0x3,%al
  8009ac:	75 23                	jne    8009d1 <memset+0x3f>
		c &= 0xFF;
  8009ae:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b2:	89 d3                	mov    %edx,%ebx
  8009b4:	c1 e3 08             	shl    $0x8,%ebx
  8009b7:	89 d0                	mov    %edx,%eax
  8009b9:	c1 e0 18             	shl    $0x18,%eax
  8009bc:	89 d6                	mov    %edx,%esi
  8009be:	c1 e6 10             	shl    $0x10,%esi
  8009c1:	09 f0                	or     %esi,%eax
  8009c3:	09 c2                	or     %eax,%edx
  8009c5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009c7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ca:	89 d0                	mov    %edx,%eax
  8009cc:	fc                   	cld    
  8009cd:	f3 ab                	rep stos %eax,%es:(%edi)
  8009cf:	eb 06                	jmp    8009d7 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	fc                   	cld    
  8009d5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d7:	89 f8                	mov    %edi,%eax
  8009d9:	5b                   	pop    %ebx
  8009da:	5e                   	pop    %esi
  8009db:	5f                   	pop    %edi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f0:	39 c6                	cmp    %eax,%esi
  8009f2:	73 32                	jae    800a26 <memmove+0x48>
  8009f4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f7:	39 c2                	cmp    %eax,%edx
  8009f9:	76 2b                	jbe    800a26 <memmove+0x48>
		s += n;
		d += n;
  8009fb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	89 fe                	mov    %edi,%esi
  800a00:	09 ce                	or     %ecx,%esi
  800a02:	09 d6                	or     %edx,%esi
  800a04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0a:	75 0e                	jne    800a1a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0c:	83 ef 04             	sub    $0x4,%edi
  800a0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a15:	fd                   	std    
  800a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a18:	eb 09                	jmp    800a23 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1a:	83 ef 01             	sub    $0x1,%edi
  800a1d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a20:	fd                   	std    
  800a21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a23:	fc                   	cld    
  800a24:	eb 1a                	jmp    800a40 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a26:	89 c2                	mov    %eax,%edx
  800a28:	09 ca                	or     %ecx,%edx
  800a2a:	09 f2                	or     %esi,%edx
  800a2c:	f6 c2 03             	test   $0x3,%dl
  800a2f:	75 0a                	jne    800a3b <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a31:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a34:	89 c7                	mov    %eax,%edi
  800a36:	fc                   	cld    
  800a37:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a39:	eb 05                	jmp    800a40 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3b:	89 c7                	mov    %eax,%edi
  800a3d:	fc                   	cld    
  800a3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a4e:	ff 75 10             	pushl  0x10(%ebp)
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	ff 75 08             	pushl  0x8(%ebp)
  800a57:	e8 82 ff ff ff       	call   8009de <memmove>
}
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5e:	f3 0f 1e fb          	endbr32 
  800a62:	55                   	push   %ebp
  800a63:	89 e5                	mov    %esp,%ebp
  800a65:	56                   	push   %esi
  800a66:	53                   	push   %ebx
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6d:	89 c6                	mov    %eax,%esi
  800a6f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a72:	39 f0                	cmp    %esi,%eax
  800a74:	74 1c                	je     800a92 <memcmp+0x34>
		if (*s1 != *s2)
  800a76:	0f b6 08             	movzbl (%eax),%ecx
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	38 d9                	cmp    %bl,%cl
  800a7e:	75 08                	jne    800a88 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a80:	83 c0 01             	add    $0x1,%eax
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	eb ea                	jmp    800a72 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a88:	0f b6 c1             	movzbl %cl,%eax
  800a8b:	0f b6 db             	movzbl %bl,%ebx
  800a8e:	29 d8                	sub    %ebx,%eax
  800a90:	eb 05                	jmp    800a97 <memcmp+0x39>
	}

	return 0;
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a97:	5b                   	pop    %ebx
  800a98:	5e                   	pop    %esi
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9b:	f3 0f 1e fb          	endbr32 
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	73 09                	jae    800aba <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab1:	38 08                	cmp    %cl,(%eax)
  800ab3:	74 05                	je     800aba <memfind+0x1f>
	for (; s < ends; s++)
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	eb f3                	jmp    800aad <memfind+0x12>
			break;
	return (void *) s;
}
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abc:	f3 0f 1e fb          	endbr32 
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
  800ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acc:	eb 03                	jmp    800ad1 <strtol+0x15>
		s++;
  800ace:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad1:	0f b6 01             	movzbl (%ecx),%eax
  800ad4:	3c 20                	cmp    $0x20,%al
  800ad6:	74 f6                	je     800ace <strtol+0x12>
  800ad8:	3c 09                	cmp    $0x9,%al
  800ada:	74 f2                	je     800ace <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800adc:	3c 2b                	cmp    $0x2b,%al
  800ade:	74 2a                	je     800b0a <strtol+0x4e>
	int neg = 0;
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae5:	3c 2d                	cmp    $0x2d,%al
  800ae7:	74 2b                	je     800b14 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae9:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aef:	75 0f                	jne    800b00 <strtol+0x44>
  800af1:	80 39 30             	cmpb   $0x30,(%ecx)
  800af4:	74 28                	je     800b1e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af6:	85 db                	test   %ebx,%ebx
  800af8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800afd:	0f 44 d8             	cmove  %eax,%ebx
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
  800b05:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b08:	eb 46                	jmp    800b50 <strtol+0x94>
		s++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b12:	eb d5                	jmp    800ae9 <strtol+0x2d>
		s++, neg = 1;
  800b14:	83 c1 01             	add    $0x1,%ecx
  800b17:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1c:	eb cb                	jmp    800ae9 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b22:	74 0e                	je     800b32 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b24:	85 db                	test   %ebx,%ebx
  800b26:	75 d8                	jne    800b00 <strtol+0x44>
		s++, base = 8;
  800b28:	83 c1 01             	add    $0x1,%ecx
  800b2b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b30:	eb ce                	jmp    800b00 <strtol+0x44>
		s += 2, base = 16;
  800b32:	83 c1 02             	add    $0x2,%ecx
  800b35:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3a:	eb c4                	jmp    800b00 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3c:	0f be d2             	movsbl %dl,%edx
  800b3f:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b42:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b45:	7d 3a                	jge    800b81 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b47:	83 c1 01             	add    $0x1,%ecx
  800b4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b50:	0f b6 11             	movzbl (%ecx),%edx
  800b53:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b56:	89 f3                	mov    %esi,%ebx
  800b58:	80 fb 09             	cmp    $0x9,%bl
  800b5b:	76 df                	jbe    800b3c <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 57             	sub    $0x57,%edx
  800b6d:	eb d3                	jmp    800b42 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b6f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b72:	89 f3                	mov    %esi,%ebx
  800b74:	80 fb 19             	cmp    $0x19,%bl
  800b77:	77 08                	ja     800b81 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b79:	0f be d2             	movsbl %dl,%edx
  800b7c:	83 ea 37             	sub    $0x37,%edx
  800b7f:	eb c1                	jmp    800b42 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b85:	74 05                	je     800b8c <strtol+0xd0>
		*endptr = (char *) s;
  800b87:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8c:	89 c2                	mov    %eax,%edx
  800b8e:	f7 da                	neg    %edx
  800b90:	85 ff                	test   %edi,%edi
  800b92:	0f 45 c2             	cmovne %edx,%eax
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9a:	f3 0f 1e fb          	endbr32 
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baf:	89 c3                	mov    %eax,%ebx
  800bb1:	89 c7                	mov    %eax,%edi
  800bb3:	89 c6                	mov    %eax,%esi
  800bb5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_cgetc>:

int
sys_cgetc(void)
{
  800bbc:	f3 0f 1e fb          	endbr32 
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	57                   	push   %edi
  800bc4:	56                   	push   %esi
  800bc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd0:	89 d1                	mov    %edx,%ecx
  800bd2:	89 d3                	mov    %edx,%ebx
  800bd4:	89 d7                	mov    %edx,%edi
  800bd6:	89 d6                	mov    %edx,%esi
  800bd8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bda:	5b                   	pop    %ebx
  800bdb:	5e                   	pop    %esi
  800bdc:	5f                   	pop    %edi
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf9:	89 cb                	mov    %ecx,%ebx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	89 ce                	mov    %ecx,%esi
  800bff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7f 08                	jg     800c0d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5f                   	pop    %edi
  800c0b:	5d                   	pop    %ebp
  800c0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0d:	83 ec 0c             	sub    $0xc,%esp
  800c10:	50                   	push   %eax
  800c11:	6a 03                	push   $0x3
  800c13:	68 5f 2a 80 00       	push   $0x802a5f
  800c18:	6a 23                	push   $0x23
  800c1a:	68 7c 2a 80 00       	push   $0x802a7c
  800c1f:	e8 ff 16 00 00       	call   802323 <_panic>

00800c24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c24:	f3 0f 1e fb          	endbr32 
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 02 00 00 00       	mov    $0x2,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_yield>:

void
sys_yield(void)
{
  800c47:	f3 0f 1e fb          	endbr32 
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6a:	f3 0f 1e fb          	endbr32 
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	be 00 00 00 00       	mov    $0x0,%esi
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 04 00 00 00       	mov    $0x4,%eax
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8a:	89 f7                	mov    %esi,%edi
  800c8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	7f 08                	jg     800c9a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 04                	push   $0x4
  800ca0:	68 5f 2a 80 00       	push   $0x802a5f
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 7c 2a 80 00       	push   $0x802a7c
  800cac:	e8 72 16 00 00       	call   802323 <_panic>

00800cb1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7f 08                	jg     800ce0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce0:	83 ec 0c             	sub    $0xc,%esp
  800ce3:	50                   	push   %eax
  800ce4:	6a 05                	push   $0x5
  800ce6:	68 5f 2a 80 00       	push   $0x802a5f
  800ceb:	6a 23                	push   $0x23
  800ced:	68 7c 2a 80 00       	push   $0x802a7c
  800cf2:	e8 2c 16 00 00       	call   802323 <_panic>

00800cf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf7:	f3 0f 1e fb          	endbr32 
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d14:	89 df                	mov    %ebx,%edi
  800d16:	89 de                	mov    %ebx,%esi
  800d18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	7f 08                	jg     800d26 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d26:	83 ec 0c             	sub    $0xc,%esp
  800d29:	50                   	push   %eax
  800d2a:	6a 06                	push   $0x6
  800d2c:	68 5f 2a 80 00       	push   $0x802a5f
  800d31:	6a 23                	push   $0x23
  800d33:	68 7c 2a 80 00       	push   $0x802a7c
  800d38:	e8 e6 15 00 00       	call   802323 <_panic>

00800d3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3d:	f3 0f 1e fb          	endbr32 
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5a:	89 df                	mov    %ebx,%edi
  800d5c:	89 de                	mov    %ebx,%esi
  800d5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d60:	85 c0                	test   %eax,%eax
  800d62:	7f 08                	jg     800d6c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d67:	5b                   	pop    %ebx
  800d68:	5e                   	pop    %esi
  800d69:	5f                   	pop    %edi
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6c:	83 ec 0c             	sub    $0xc,%esp
  800d6f:	50                   	push   %eax
  800d70:	6a 08                	push   $0x8
  800d72:	68 5f 2a 80 00       	push   $0x802a5f
  800d77:	6a 23                	push   $0x23
  800d79:	68 7c 2a 80 00       	push   $0x802a7c
  800d7e:	e8 a0 15 00 00       	call   802323 <_panic>

00800d83 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d83:	f3 0f 1e fb          	endbr32 
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	b8 09 00 00 00       	mov    $0x9,%eax
  800da0:	89 df                	mov    %ebx,%edi
  800da2:	89 de                	mov    %ebx,%esi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 09                	push   $0x9
  800db8:	68 5f 2a 80 00       	push   $0x802a5f
  800dbd:	6a 23                	push   $0x23
  800dbf:	68 7c 2a 80 00       	push   $0x802a7c
  800dc4:	e8 5a 15 00 00       	call   802323 <_panic>

00800dc9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc9:	f3 0f 1e fb          	endbr32 
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	89 df                	mov    %ebx,%edi
  800de8:	89 de                	mov    %ebx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 0a                	push   $0xa
  800dfe:	68 5f 2a 80 00       	push   $0x802a5f
  800e03:	6a 23                	push   $0x23
  800e05:	68 7c 2a 80 00       	push   $0x802a7c
  800e0a:	e8 14 15 00 00       	call   802323 <_panic>

00800e0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0f:	f3 0f 1e fb          	endbr32 
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e24:	be 00 00 00 00       	mov    $0x0,%esi
  800e29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e36:	f3 0f 1e fb          	endbr32 
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e50:	89 cb                	mov    %ecx,%ebx
  800e52:	89 cf                	mov    %ecx,%edi
  800e54:	89 ce                	mov    %ecx,%esi
  800e56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	7f 08                	jg     800e64 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	50                   	push   %eax
  800e68:	6a 0d                	push   $0xd
  800e6a:	68 5f 2a 80 00       	push   $0x802a5f
  800e6f:	6a 23                	push   $0x23
  800e71:	68 7c 2a 80 00       	push   $0x802a7c
  800e76:	e8 a8 14 00 00       	call   802323 <_panic>

00800e7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7b:	f3 0f 1e fb          	endbr32 
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8f:	89 d1                	mov    %edx,%ecx
  800e91:	89 d3                	mov    %edx,%ebx
  800e93:	89 d7                	mov    %edx,%edi
  800e95:	89 d6                	mov    %edx,%esi
  800e97:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800eae:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800eb0:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800eb3:	83 3a 01             	cmpl   $0x1,(%edx)
  800eb6:	7e 09                	jle    800ec1 <argstart+0x23>
  800eb8:	ba 31 27 80 00       	mov    $0x802731,%edx
  800ebd:	85 c9                	test   %ecx,%ecx
  800ebf:	75 05                	jne    800ec6 <argstart+0x28>
  800ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec6:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ec9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800ed0:	5d                   	pop    %ebp
  800ed1:	c3                   	ret    

00800ed2 <argnext>:

int
argnext(struct Argstate *args)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ee0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ee7:	8b 43 08             	mov    0x8(%ebx),%eax
  800eea:	85 c0                	test   %eax,%eax
  800eec:	74 74                	je     800f62 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  800eee:	80 38 00             	cmpb   $0x0,(%eax)
  800ef1:	75 48                	jne    800f3b <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800ef3:	8b 0b                	mov    (%ebx),%ecx
  800ef5:	83 39 01             	cmpl   $0x1,(%ecx)
  800ef8:	74 5a                	je     800f54 <argnext+0x82>
		    || args->argv[1][0] != '-'
  800efa:	8b 53 04             	mov    0x4(%ebx),%edx
  800efd:	8b 42 04             	mov    0x4(%edx),%eax
  800f00:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f03:	75 4f                	jne    800f54 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  800f05:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f09:	74 49                	je     800f54 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f0b:	83 c0 01             	add    $0x1,%eax
  800f0e:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f11:	83 ec 04             	sub    $0x4,%esp
  800f14:	8b 01                	mov    (%ecx),%eax
  800f16:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800f1d:	50                   	push   %eax
  800f1e:	8d 42 08             	lea    0x8(%edx),%eax
  800f21:	50                   	push   %eax
  800f22:	83 c2 04             	add    $0x4,%edx
  800f25:	52                   	push   %edx
  800f26:	e8 b3 fa ff ff       	call   8009de <memmove>
		(*args->argc)--;
  800f2b:	8b 03                	mov    (%ebx),%eax
  800f2d:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f30:	8b 43 08             	mov    0x8(%ebx),%eax
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f39:	74 13                	je     800f4e <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f3b:	8b 43 08             	mov    0x8(%ebx),%eax
  800f3e:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  800f41:	83 c0 01             	add    $0x1,%eax
  800f44:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f47:	89 d0                	mov    %edx,%eax
  800f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f4e:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f52:	75 e7                	jne    800f3b <argnext+0x69>
	args->curarg = 0;
  800f54:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f5b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f60:	eb e5                	jmp    800f47 <argnext+0x75>
		return -1;
  800f62:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  800f67:	eb de                	jmp    800f47 <argnext+0x75>

00800f69 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f69:	f3 0f 1e fb          	endbr32 
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	53                   	push   %ebx
  800f71:	83 ec 04             	sub    $0x4,%esp
  800f74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800f77:	8b 43 08             	mov    0x8(%ebx),%eax
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	74 12                	je     800f90 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  800f7e:	80 38 00             	cmpb   $0x0,(%eax)
  800f81:	74 12                	je     800f95 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  800f83:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f86:	c7 43 08 31 27 80 00 	movl   $0x802731,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f8d:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f95:	8b 13                	mov    (%ebx),%edx
  800f97:	83 3a 01             	cmpl   $0x1,(%edx)
  800f9a:	7f 10                	jg     800fac <argnextvalue+0x43>
		args->argvalue = 0;
  800f9c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800fa3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800faa:	eb e1                	jmp    800f8d <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  800fac:	8b 43 04             	mov    0x4(%ebx),%eax
  800faf:	8b 48 04             	mov    0x4(%eax),%ecx
  800fb2:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800fb5:	83 ec 04             	sub    $0x4,%esp
  800fb8:	8b 12                	mov    (%edx),%edx
  800fba:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800fc1:	52                   	push   %edx
  800fc2:	8d 50 08             	lea    0x8(%eax),%edx
  800fc5:	52                   	push   %edx
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	50                   	push   %eax
  800fca:	e8 0f fa ff ff       	call   8009de <memmove>
		(*args->argc)--;
  800fcf:	8b 03                	mov    (%ebx),%eax
  800fd1:	83 28 01             	subl   $0x1,(%eax)
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	eb b4                	jmp    800f8d <argnextvalue+0x24>

00800fd9 <argvalue>:
{
  800fd9:	f3 0f 1e fb          	endbr32 
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fe6:	8b 42 0c             	mov    0xc(%edx),%eax
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	74 02                	je     800fef <argvalue+0x16>
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fef:	83 ec 0c             	sub    $0xc,%esp
  800ff2:	52                   	push   %edx
  800ff3:	e8 71 ff ff ff       	call   800f69 <argnextvalue>
  800ff8:	83 c4 10             	add    $0x10,%esp
  800ffb:	eb f0                	jmp    800fed <argvalue+0x14>

00800ffd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ffd:	f3 0f 1e fb          	endbr32 
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	05 00 00 00 30       	add    $0x30000000,%eax
  80100c:	c1 e8 0c             	shr    $0xc,%eax
}
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801011:	f3 0f 1e fb          	endbr32 
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801020:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801025:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80102c:	f3 0f 1e fb          	endbr32 
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801038:	89 c2                	mov    %eax,%edx
  80103a:	c1 ea 16             	shr    $0x16,%edx
  80103d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801044:	f6 c2 01             	test   $0x1,%dl
  801047:	74 2d                	je     801076 <fd_alloc+0x4a>
  801049:	89 c2                	mov    %eax,%edx
  80104b:	c1 ea 0c             	shr    $0xc,%edx
  80104e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801055:	f6 c2 01             	test   $0x1,%dl
  801058:	74 1c                	je     801076 <fd_alloc+0x4a>
  80105a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80105f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801064:	75 d2                	jne    801038 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80106f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801074:	eb 0a                	jmp    801080 <fd_alloc+0x54>
			*fd_store = fd;
  801076:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801079:	89 01                	mov    %eax,(%ecx)
			return 0;
  80107b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80108c:	83 f8 1f             	cmp    $0x1f,%eax
  80108f:	77 30                	ja     8010c1 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801091:	c1 e0 0c             	shl    $0xc,%eax
  801094:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801099:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	74 24                	je     8010c8 <fd_lookup+0x46>
  8010a4:	89 c2                	mov    %eax,%edx
  8010a6:	c1 ea 0c             	shr    $0xc,%edx
  8010a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b0:	f6 c2 01             	test   $0x1,%dl
  8010b3:	74 1a                	je     8010cf <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b8:	89 02                	mov    %eax,(%edx)
	return 0;
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    
		return -E_INVAL;
  8010c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c6:	eb f7                	jmp    8010bf <fd_lookup+0x3d>
		return -E_INVAL;
  8010c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cd:	eb f0                	jmp    8010bf <fd_lookup+0x3d>
  8010cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d4:	eb e9                	jmp    8010bf <fd_lookup+0x3d>

008010d6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 08             	sub    $0x8,%esp
  8010e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ed:	39 08                	cmp    %ecx,(%eax)
  8010ef:	74 38                	je     801129 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010f1:	83 c2 01             	add    $0x1,%edx
  8010f4:	8b 04 95 08 2b 80 00 	mov    0x802b08(,%edx,4),%eax
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	75 ee                	jne    8010ed <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ff:	a1 08 40 80 00       	mov    0x804008,%eax
  801104:	8b 40 48             	mov    0x48(%eax),%eax
  801107:	83 ec 04             	sub    $0x4,%esp
  80110a:	51                   	push   %ecx
  80110b:	50                   	push   %eax
  80110c:	68 8c 2a 80 00       	push   $0x802a8c
  801111:	e8 08 f1 ff ff       	call   80021e <cprintf>
	*dev = 0;
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801127:	c9                   	leave  
  801128:	c3                   	ret    
			*dev = devtab[i];
  801129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
  801133:	eb f2                	jmp    801127 <dev_lookup+0x51>

00801135 <fd_close>:
{
  801135:	f3 0f 1e fb          	endbr32 
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	57                   	push   %edi
  80113d:	56                   	push   %esi
  80113e:	53                   	push   %ebx
  80113f:	83 ec 24             	sub    $0x24,%esp
  801142:	8b 75 08             	mov    0x8(%ebp),%esi
  801145:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801148:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80114b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801152:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801155:	50                   	push   %eax
  801156:	e8 27 ff ff ff       	call   801082 <fd_lookup>
  80115b:	89 c3                	mov    %eax,%ebx
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	78 05                	js     801169 <fd_close+0x34>
	    || fd != fd2)
  801164:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801167:	74 16                	je     80117f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801169:	89 f8                	mov    %edi,%eax
  80116b:	84 c0                	test   %al,%al
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
  801172:	0f 44 d8             	cmove  %eax,%ebx
}
  801175:	89 d8                	mov    %ebx,%eax
  801177:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117a:	5b                   	pop    %ebx
  80117b:	5e                   	pop    %esi
  80117c:	5f                   	pop    %edi
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	ff 36                	pushl  (%esi)
  801188:	e8 49 ff ff ff       	call   8010d6 <dev_lookup>
  80118d:	89 c3                	mov    %eax,%ebx
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	78 1a                	js     8011b0 <fd_close+0x7b>
		if (dev->dev_close)
  801196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801199:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80119c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	74 0b                	je     8011b0 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8011a5:	83 ec 0c             	sub    $0xc,%esp
  8011a8:	56                   	push   %esi
  8011a9:	ff d0                	call   *%eax
  8011ab:	89 c3                	mov    %eax,%ebx
  8011ad:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011b0:	83 ec 08             	sub    $0x8,%esp
  8011b3:	56                   	push   %esi
  8011b4:	6a 00                	push   $0x0
  8011b6:	e8 3c fb ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	eb b5                	jmp    801175 <fd_close+0x40>

008011c0 <close>:

int
close(int fdnum)
{
  8011c0:	f3 0f 1e fb          	endbr32 
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011cd:	50                   	push   %eax
  8011ce:	ff 75 08             	pushl  0x8(%ebp)
  8011d1:	e8 ac fe ff ff       	call   801082 <fd_lookup>
  8011d6:	83 c4 10             	add    $0x10,%esp
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	79 02                	jns    8011df <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    
		return fd_close(fd, 1);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	6a 01                	push   $0x1
  8011e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e7:	e8 49 ff ff ff       	call   801135 <fd_close>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	eb ec                	jmp    8011dd <close+0x1d>

008011f1 <close_all>:

void
close_all(void)
{
  8011f1:	f3 0f 1e fb          	endbr32 
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801201:	83 ec 0c             	sub    $0xc,%esp
  801204:	53                   	push   %ebx
  801205:	e8 b6 ff ff ff       	call   8011c0 <close>
	for (i = 0; i < MAXFD; i++)
  80120a:	83 c3 01             	add    $0x1,%ebx
  80120d:	83 c4 10             	add    $0x10,%esp
  801210:	83 fb 20             	cmp    $0x20,%ebx
  801213:	75 ec                	jne    801201 <close_all+0x10>
}
  801215:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80121a:	f3 0f 1e fb          	endbr32 
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	57                   	push   %edi
  801222:	56                   	push   %esi
  801223:	53                   	push   %ebx
  801224:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801227:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122a:	50                   	push   %eax
  80122b:	ff 75 08             	pushl  0x8(%ebp)
  80122e:	e8 4f fe ff ff       	call   801082 <fd_lookup>
  801233:	89 c3                	mov    %eax,%ebx
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	0f 88 81 00 00 00    	js     8012c1 <dup+0xa7>
		return r;
	close(newfdnum);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	ff 75 0c             	pushl  0xc(%ebp)
  801246:	e8 75 ff ff ff       	call   8011c0 <close>

	newfd = INDEX2FD(newfdnum);
  80124b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80124e:	c1 e6 0c             	shl    $0xc,%esi
  801251:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801257:	83 c4 04             	add    $0x4,%esp
  80125a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80125d:	e8 af fd ff ff       	call   801011 <fd2data>
  801262:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801264:	89 34 24             	mov    %esi,(%esp)
  801267:	e8 a5 fd ff ff       	call   801011 <fd2data>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801271:	89 d8                	mov    %ebx,%eax
  801273:	c1 e8 16             	shr    $0x16,%eax
  801276:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80127d:	a8 01                	test   $0x1,%al
  80127f:	74 11                	je     801292 <dup+0x78>
  801281:	89 d8                	mov    %ebx,%eax
  801283:	c1 e8 0c             	shr    $0xc,%eax
  801286:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80128d:	f6 c2 01             	test   $0x1,%dl
  801290:	75 39                	jne    8012cb <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801292:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801295:	89 d0                	mov    %edx,%eax
  801297:	c1 e8 0c             	shr    $0xc,%eax
  80129a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a1:	83 ec 0c             	sub    $0xc,%esp
  8012a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a9:	50                   	push   %eax
  8012aa:	56                   	push   %esi
  8012ab:	6a 00                	push   $0x0
  8012ad:	52                   	push   %edx
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 fc f9 ff ff       	call   800cb1 <sys_page_map>
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	83 c4 20             	add    $0x20,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 31                	js     8012ef <dup+0xd5>
		goto err;

	return newfdnum;
  8012be:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c1:	89 d8                	mov    %ebx,%eax
  8012c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d2:	83 ec 0c             	sub    $0xc,%esp
  8012d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012da:	50                   	push   %eax
  8012db:	57                   	push   %edi
  8012dc:	6a 00                	push   $0x0
  8012de:	53                   	push   %ebx
  8012df:	6a 00                	push   $0x0
  8012e1:	e8 cb f9 ff ff       	call   800cb1 <sys_page_map>
  8012e6:	89 c3                	mov    %eax,%ebx
  8012e8:	83 c4 20             	add    $0x20,%esp
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	79 a3                	jns    801292 <dup+0x78>
	sys_page_unmap(0, newfd);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	56                   	push   %esi
  8012f3:	6a 00                	push   $0x0
  8012f5:	e8 fd f9 ff ff       	call   800cf7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012fa:	83 c4 08             	add    $0x8,%esp
  8012fd:	57                   	push   %edi
  8012fe:	6a 00                	push   $0x0
  801300:	e8 f2 f9 ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	eb b7                	jmp    8012c1 <dup+0xa7>

0080130a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130a:	f3 0f 1e fb          	endbr32 
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	53                   	push   %ebx
  801312:	83 ec 1c             	sub    $0x1c,%esp
  801315:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801318:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131b:	50                   	push   %eax
  80131c:	53                   	push   %ebx
  80131d:	e8 60 fd ff ff       	call   801082 <fd_lookup>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 3f                	js     801368 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132f:	50                   	push   %eax
  801330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801333:	ff 30                	pushl  (%eax)
  801335:	e8 9c fd ff ff       	call   8010d6 <dev_lookup>
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 27                	js     801368 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801341:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801344:	8b 42 08             	mov    0x8(%edx),%eax
  801347:	83 e0 03             	and    $0x3,%eax
  80134a:	83 f8 01             	cmp    $0x1,%eax
  80134d:	74 1e                	je     80136d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801352:	8b 40 08             	mov    0x8(%eax),%eax
  801355:	85 c0                	test   %eax,%eax
  801357:	74 35                	je     80138e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	ff 75 10             	pushl  0x10(%ebp)
  80135f:	ff 75 0c             	pushl  0xc(%ebp)
  801362:	52                   	push   %edx
  801363:	ff d0                	call   *%eax
  801365:	83 c4 10             	add    $0x10,%esp
}
  801368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80136d:	a1 08 40 80 00       	mov    0x804008,%eax
  801372:	8b 40 48             	mov    0x48(%eax),%eax
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	53                   	push   %ebx
  801379:	50                   	push   %eax
  80137a:	68 cd 2a 80 00       	push   $0x802acd
  80137f:	e8 9a ee ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138c:	eb da                	jmp    801368 <read+0x5e>
		return -E_NOT_SUPP;
  80138e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801393:	eb d3                	jmp    801368 <read+0x5e>

00801395 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801395:	f3 0f 1e fb          	endbr32 
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	57                   	push   %edi
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ad:	eb 02                	jmp    8013b1 <readn+0x1c>
  8013af:	01 c3                	add    %eax,%ebx
  8013b1:	39 f3                	cmp    %esi,%ebx
  8013b3:	73 21                	jae    8013d6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	89 f0                	mov    %esi,%eax
  8013ba:	29 d8                	sub    %ebx,%eax
  8013bc:	50                   	push   %eax
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	03 45 0c             	add    0xc(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	57                   	push   %edi
  8013c4:	e8 41 ff ff ff       	call   80130a <read>
		if (m < 0)
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 04                	js     8013d4 <readn+0x3f>
			return m;
		if (m == 0)
  8013d0:	75 dd                	jne    8013af <readn+0x1a>
  8013d2:	eb 02                	jmp    8013d6 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d6:	89 d8                	mov    %ebx,%eax
  8013d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5f                   	pop    %edi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	53                   	push   %ebx
  8013e8:	83 ec 1c             	sub    $0x1c,%esp
  8013eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	53                   	push   %ebx
  8013f3:	e8 8a fc ff ff       	call   801082 <fd_lookup>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 3a                	js     801439 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801405:	50                   	push   %eax
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	ff 30                	pushl  (%eax)
  80140b:	e8 c6 fc ff ff       	call   8010d6 <dev_lookup>
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	78 22                	js     801439 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141e:	74 1e                	je     80143e <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801423:	8b 52 0c             	mov    0xc(%edx),%edx
  801426:	85 d2                	test   %edx,%edx
  801428:	74 35                	je     80145f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	ff 75 10             	pushl  0x10(%ebp)
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	ff d2                	call   *%edx
  801436:	83 c4 10             	add    $0x10,%esp
}
  801439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80143e:	a1 08 40 80 00       	mov    0x804008,%eax
  801443:	8b 40 48             	mov    0x48(%eax),%eax
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	53                   	push   %ebx
  80144a:	50                   	push   %eax
  80144b:	68 e9 2a 80 00       	push   $0x802ae9
  801450:	e8 c9 ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb da                	jmp    801439 <write+0x59>
		return -E_NOT_SUPP;
  80145f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801464:	eb d3                	jmp    801439 <write+0x59>

00801466 <seek>:

int
seek(int fdnum, off_t offset)
{
  801466:	f3 0f 1e fb          	endbr32 
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	ff 75 08             	pushl  0x8(%ebp)
  801477:	e8 06 fc ff ff       	call   801082 <fd_lookup>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 0e                	js     801491 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801489:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801493:	f3 0f 1e fb          	endbr32 
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 1c             	sub    $0x1c,%esp
  80149e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	53                   	push   %ebx
  8014a6:	e8 d7 fb ff ff       	call   801082 <fd_lookup>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 37                	js     8014e9 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b2:	83 ec 08             	sub    $0x8,%esp
  8014b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	ff 30                	pushl  (%eax)
  8014be:	e8 13 fc ff ff       	call   8010d6 <dev_lookup>
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 1f                	js     8014e9 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d1:	74 1b                	je     8014ee <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d6:	8b 52 18             	mov    0x18(%edx),%edx
  8014d9:	85 d2                	test   %edx,%edx
  8014db:	74 32                	je     80150f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	50                   	push   %eax
  8014e4:	ff d2                	call   *%edx
  8014e6:	83 c4 10             	add    $0x10,%esp
}
  8014e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014ee:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f3:	8b 40 48             	mov    0x48(%eax),%eax
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	53                   	push   %ebx
  8014fa:	50                   	push   %eax
  8014fb:	68 ac 2a 80 00       	push   $0x802aac
  801500:	e8 19 ed ff ff       	call   80021e <cprintf>
		return -E_INVAL;
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150d:	eb da                	jmp    8014e9 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80150f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801514:	eb d3                	jmp    8014e9 <ftruncate+0x56>

00801516 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801516:	f3 0f 1e fb          	endbr32 
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 1c             	sub    $0x1c,%esp
  801521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801524:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	ff 75 08             	pushl  0x8(%ebp)
  80152b:	e8 52 fb ff ff       	call   801082 <fd_lookup>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 4b                	js     801582 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	ff 30                	pushl  (%eax)
  801543:	e8 8e fb ff ff       	call   8010d6 <dev_lookup>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 33                	js     801582 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801556:	74 2f                	je     801587 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801558:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80155b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801562:	00 00 00 
	stat->st_isdir = 0;
  801565:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80156c:	00 00 00 
	stat->st_dev = dev;
  80156f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801575:	83 ec 08             	sub    $0x8,%esp
  801578:	53                   	push   %ebx
  801579:	ff 75 f0             	pushl  -0x10(%ebp)
  80157c:	ff 50 14             	call   *0x14(%eax)
  80157f:	83 c4 10             	add    $0x10,%esp
}
  801582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801585:	c9                   	leave  
  801586:	c3                   	ret    
		return -E_NOT_SUPP;
  801587:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158c:	eb f4                	jmp    801582 <fstat+0x6c>

0080158e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80158e:	f3 0f 1e fb          	endbr32 
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	56                   	push   %esi
  801596:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801597:	83 ec 08             	sub    $0x8,%esp
  80159a:	6a 00                	push   $0x0
  80159c:	ff 75 08             	pushl  0x8(%ebp)
  80159f:	e8 fb 01 00 00       	call   80179f <open>
  8015a4:	89 c3                	mov    %eax,%ebx
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 1b                	js     8015c8 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	ff 75 0c             	pushl  0xc(%ebp)
  8015b3:	50                   	push   %eax
  8015b4:	e8 5d ff ff ff       	call   801516 <fstat>
  8015b9:	89 c6                	mov    %eax,%esi
	close(fd);
  8015bb:	89 1c 24             	mov    %ebx,(%esp)
  8015be:	e8 fd fb ff ff       	call   8011c0 <close>
	return r;
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	89 f3                	mov    %esi,%ebx
}
  8015c8:	89 d8                	mov    %ebx,%eax
  8015ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5d                   	pop    %ebp
  8015d0:	c3                   	ret    

008015d1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	56                   	push   %esi
  8015d5:	53                   	push   %ebx
  8015d6:	89 c6                	mov    %eax,%esi
  8015d8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015da:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015e1:	74 27                	je     80160a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015e3:	6a 07                	push   $0x7
  8015e5:	68 00 50 80 00       	push   $0x805000
  8015ea:	56                   	push   %esi
  8015eb:	ff 35 00 40 80 00    	pushl  0x804000
  8015f1:	e8 eb 0d 00 00       	call   8023e1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015f6:	83 c4 0c             	add    $0xc,%esp
  8015f9:	6a 00                	push   $0x0
  8015fb:	53                   	push   %ebx
  8015fc:	6a 00                	push   $0x0
  8015fe:	e8 6a 0d 00 00       	call   80236d <ipc_recv>
}
  801603:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801606:	5b                   	pop    %ebx
  801607:	5e                   	pop    %esi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	6a 01                	push   $0x1
  80160f:	e8 25 0e 00 00       	call   802439 <ipc_find_env>
  801614:	a3 00 40 80 00       	mov    %eax,0x804000
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	eb c5                	jmp    8015e3 <fsipc+0x12>

0080161e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80161e:	f3 0f 1e fb          	endbr32 
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	8b 40 0c             	mov    0xc(%eax),%eax
  80162e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801633:	8b 45 0c             	mov    0xc(%ebp),%eax
  801636:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	b8 02 00 00 00       	mov    $0x2,%eax
  801645:	e8 87 ff ff ff       	call   8015d1 <fsipc>
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <devfile_flush>:
{
  80164c:	f3 0f 1e fb          	endbr32 
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8b 40 0c             	mov    0xc(%eax),%eax
  80165c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801661:	ba 00 00 00 00       	mov    $0x0,%edx
  801666:	b8 06 00 00 00       	mov    $0x6,%eax
  80166b:	e8 61 ff ff ff       	call   8015d1 <fsipc>
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <devfile_stat>:
{
  801672:	f3 0f 1e fb          	endbr32 
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 40 0c             	mov    0xc(%eax),%eax
  801686:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	b8 05 00 00 00       	mov    $0x5,%eax
  801695:	e8 37 ff ff ff       	call   8015d1 <fsipc>
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 2c                	js     8016ca <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	68 00 50 80 00       	push   $0x805000
  8016a6:	53                   	push   %ebx
  8016a7:	e8 7c f1 ff ff       	call   800828 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ac:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b7:	a1 84 50 80 00       	mov    0x805084,%eax
  8016bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <devfile_write>:
{
  8016cf:	f3 0f 1e fb          	endbr32 
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 0c             	sub    $0xc,%esp
  8016d9:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016df:	8b 52 0c             	mov    0xc(%edx),%edx
  8016e2:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8016e8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ed:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016f2:	0f 47 c2             	cmova  %edx,%eax
  8016f5:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8016fa:	50                   	push   %eax
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	68 08 50 80 00       	push   $0x805008
  801703:	e8 d6 f2 ff ff       	call   8009de <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	b8 04 00 00 00       	mov    $0x4,%eax
  801712:	e8 ba fe ff ff       	call   8015d1 <fsipc>
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <devfile_read>:
{
  801719:	f3 0f 1e fb          	endbr32 
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	8b 40 0c             	mov    0xc(%eax),%eax
  80172b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801730:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801736:	ba 00 00 00 00       	mov    $0x0,%edx
  80173b:	b8 03 00 00 00       	mov    $0x3,%eax
  801740:	e8 8c fe ff ff       	call   8015d1 <fsipc>
  801745:	89 c3                	mov    %eax,%ebx
  801747:	85 c0                	test   %eax,%eax
  801749:	78 1f                	js     80176a <devfile_read+0x51>
	assert(r <= n);
  80174b:	39 f0                	cmp    %esi,%eax
  80174d:	77 24                	ja     801773 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80174f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801754:	7f 33                	jg     801789 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	50                   	push   %eax
  80175a:	68 00 50 80 00       	push   $0x805000
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	e8 77 f2 ff ff       	call   8009de <memmove>
	return r;
  801767:	83 c4 10             	add    $0x10,%esp
}
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
	assert(r <= n);
  801773:	68 1c 2b 80 00       	push   $0x802b1c
  801778:	68 23 2b 80 00       	push   $0x802b23
  80177d:	6a 7c                	push   $0x7c
  80177f:	68 38 2b 80 00       	push   $0x802b38
  801784:	e8 9a 0b 00 00       	call   802323 <_panic>
	assert(r <= PGSIZE);
  801789:	68 43 2b 80 00       	push   $0x802b43
  80178e:	68 23 2b 80 00       	push   $0x802b23
  801793:	6a 7d                	push   $0x7d
  801795:	68 38 2b 80 00       	push   $0x802b38
  80179a:	e8 84 0b 00 00       	call   802323 <_panic>

0080179f <open>:
{
  80179f:	f3 0f 1e fb          	endbr32 
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	56                   	push   %esi
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 1c             	sub    $0x1c,%esp
  8017ab:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ae:	56                   	push   %esi
  8017af:	e8 31 f0 ff ff       	call   8007e5 <strlen>
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017bc:	7f 6c                	jg     80182a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c4:	50                   	push   %eax
  8017c5:	e8 62 f8 ff ff       	call   80102c <fd_alloc>
  8017ca:	89 c3                	mov    %eax,%ebx
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 3c                	js     80180f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	56                   	push   %esi
  8017d7:	68 00 50 80 00       	push   $0x805000
  8017dc:	e8 47 f0 ff ff       	call   800828 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f1:	e8 db fd ff ff       	call   8015d1 <fsipc>
  8017f6:	89 c3                	mov    %eax,%ebx
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 19                	js     801818 <open+0x79>
	return fd2num(fd);
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	ff 75 f4             	pushl  -0xc(%ebp)
  801805:	e8 f3 f7 ff ff       	call   800ffd <fd2num>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	83 c4 10             	add    $0x10,%esp
}
  80180f:	89 d8                	mov    %ebx,%eax
  801811:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801814:	5b                   	pop    %ebx
  801815:	5e                   	pop    %esi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
		fd_close(fd, 0);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 f4             	pushl  -0xc(%ebp)
  801820:	e8 10 f9 ff ff       	call   801135 <fd_close>
		return r;
  801825:	83 c4 10             	add    $0x10,%esp
  801828:	eb e5                	jmp    80180f <open+0x70>
		return -E_BAD_PATH;
  80182a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80182f:	eb de                	jmp    80180f <open+0x70>

00801831 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801831:	f3 0f 1e fb          	endbr32 
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	b8 08 00 00 00       	mov    $0x8,%eax
  801845:	e8 87 fd ff ff       	call   8015d1 <fsipc>
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80184c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801850:	7f 01                	jg     801853 <writebuf+0x7>
  801852:	c3                   	ret    
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	53                   	push   %ebx
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80185c:	ff 70 04             	pushl  0x4(%eax)
  80185f:	8d 40 10             	lea    0x10(%eax),%eax
  801862:	50                   	push   %eax
  801863:	ff 33                	pushl  (%ebx)
  801865:	e8 76 fb ff ff       	call   8013e0 <write>
		if (result > 0)
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	85 c0                	test   %eax,%eax
  80186f:	7e 03                	jle    801874 <writebuf+0x28>
			b->result += result;
  801871:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801874:	39 43 04             	cmp    %eax,0x4(%ebx)
  801877:	74 0d                	je     801886 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801879:	85 c0                	test   %eax,%eax
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	0f 4f c2             	cmovg  %edx,%eax
  801883:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <putch>:

static void
putch(int ch, void *thunk)
{
  80188b:	f3 0f 1e fb          	endbr32 
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	53                   	push   %ebx
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801899:	8b 53 04             	mov    0x4(%ebx),%edx
  80189c:	8d 42 01             	lea    0x1(%edx),%eax
  80189f:	89 43 04             	mov    %eax,0x4(%ebx)
  8018a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a5:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8018a9:	3d 00 01 00 00       	cmp    $0x100,%eax
  8018ae:	74 06                	je     8018b6 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8018b0:	83 c4 04             	add    $0x4,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		writebuf(b);
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	e8 8f ff ff ff       	call   80184c <writebuf>
		b->idx = 0;
  8018bd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018c4:	eb ea                	jmp    8018b0 <putch+0x25>

008018c6 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018c6:	f3 0f 1e fb          	endbr32 
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018dc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018e3:	00 00 00 
	b.result = 0;
  8018e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ed:	00 00 00 
	b.error = 1;
  8018f0:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018f7:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018fa:	ff 75 10             	pushl  0x10(%ebp)
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801906:	50                   	push   %eax
  801907:	68 8b 18 80 00       	push   $0x80188b
  80190c:	e8 10 ea ff ff       	call   800321 <vprintfmt>
	if (b.idx > 0)
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80191b:	7f 11                	jg     80192e <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80191d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801923:	85 c0                	test   %eax,%eax
  801925:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    
		writebuf(&b);
  80192e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801934:	e8 13 ff ff ff       	call   80184c <writebuf>
  801939:	eb e2                	jmp    80191d <vfprintf+0x57>

0080193b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80193b:	f3 0f 1e fb          	endbr32 
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801945:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801948:	50                   	push   %eax
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	e8 72 ff ff ff       	call   8018c6 <vfprintf>
	va_end(ap);

	return cnt;
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <printf>:

int
printf(const char *fmt, ...)
{
  801956:	f3 0f 1e fb          	endbr32 
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801960:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801963:	50                   	push   %eax
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 01                	push   $0x1
  801969:	e8 58 ff ff ff       	call   8018c6 <vfprintf>
	va_end(ap);

	return cnt;
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801970:	f3 0f 1e fb          	endbr32 
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80197a:	68 4f 2b 80 00       	push   $0x802b4f
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	e8 a1 ee ff ff       	call   800828 <strcpy>
	return 0;
}
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <devsock_close>:
{
  80198e:	f3 0f 1e fb          	endbr32 
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	53                   	push   %ebx
  801996:	83 ec 10             	sub    $0x10,%esp
  801999:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80199c:	53                   	push   %ebx
  80199d:	e8 d4 0a 00 00       	call   802476 <pageref>
  8019a2:	89 c2                	mov    %eax,%edx
  8019a4:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8019ac:	83 fa 01             	cmp    $0x1,%edx
  8019af:	74 05                	je     8019b6 <devsock_close+0x28>
}
  8019b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 73 0c             	pushl  0xc(%ebx)
  8019bc:	e8 e3 02 00 00       	call   801ca4 <nsipc_close>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	eb eb                	jmp    8019b1 <devsock_close+0x23>

008019c6 <devsock_write>:
{
  8019c6:	f3 0f 1e fb          	endbr32 
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 10             	pushl  0x10(%ebp)
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	ff 70 0c             	pushl  0xc(%eax)
  8019de:	e8 b5 03 00 00       	call   801d98 <nsipc_send>
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <devsock_read>:
{
  8019e5:	f3 0f 1e fb          	endbr32 
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 10             	pushl  0x10(%ebp)
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	ff 70 0c             	pushl  0xc(%eax)
  8019fd:	e8 1f 03 00 00       	call   801d21 <nsipc_recv>
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <fd2sockid>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a0a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	e8 6e f6 ff ff       	call   801082 <fd_lookup>
  801a14:	83 c4 10             	add    $0x10,%esp
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 10                	js     801a2b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a24:	39 08                	cmp    %ecx,(%eax)
  801a26:	75 05                	jne    801a2d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a28:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
		return -E_NOT_SUPP;
  801a2d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a32:	eb f7                	jmp    801a2b <fd2sockid+0x27>

00801a34 <alloc_sockfd>:
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	83 ec 1c             	sub    $0x1c,%esp
  801a3c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a41:	50                   	push   %eax
  801a42:	e8 e5 f5 ff ff       	call   80102c <fd_alloc>
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 43                	js     801a93 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	68 07 04 00 00       	push   $0x407
  801a58:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 08 f2 ff ff       	call   800c6a <sys_page_alloc>
  801a62:	89 c3                	mov    %eax,%ebx
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 28                	js     801a93 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a74:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a79:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a80:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	50                   	push   %eax
  801a87:	e8 71 f5 ff ff       	call   800ffd <fd2num>
  801a8c:	89 c3                	mov    %eax,%ebx
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	eb 0c                	jmp    801a9f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	56                   	push   %esi
  801a97:	e8 08 02 00 00       	call   801ca4 <nsipc_close>
		return r;
  801a9c:	83 c4 10             	add    $0x10,%esp
}
  801a9f:	89 d8                	mov    %ebx,%eax
  801aa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa4:	5b                   	pop    %ebx
  801aa5:	5e                   	pop    %esi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    

00801aa8 <accept>:
{
  801aa8:	f3 0f 1e fb          	endbr32 
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	e8 4a ff ff ff       	call   801a04 <fd2sockid>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 1b                	js     801ad9 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	ff 75 10             	pushl  0x10(%ebp)
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	50                   	push   %eax
  801ac8:	e8 22 01 00 00       	call   801bef <nsipc_accept>
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 05                	js     801ad9 <accept+0x31>
	return alloc_sockfd(r);
  801ad4:	e8 5b ff ff ff       	call   801a34 <alloc_sockfd>
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <bind>:
{
  801adb:	f3 0f 1e fb          	endbr32 
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	e8 17 ff ff ff       	call   801a04 <fd2sockid>
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 12                	js     801b03 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	ff 75 10             	pushl  0x10(%ebp)
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	e8 45 01 00 00       	call   801c45 <nsipc_bind>
  801b00:	83 c4 10             	add    $0x10,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <shutdown>:
{
  801b05:	f3 0f 1e fb          	endbr32 
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	e8 ed fe ff ff       	call   801a04 <fd2sockid>
  801b17:	85 c0                	test   %eax,%eax
  801b19:	78 0f                	js     801b2a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801b1b:	83 ec 08             	sub    $0x8,%esp
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	50                   	push   %eax
  801b22:	e8 57 01 00 00       	call   801c7e <nsipc_shutdown>
  801b27:	83 c4 10             	add    $0x10,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <connect>:
{
  801b2c:	f3 0f 1e fb          	endbr32 
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	e8 c6 fe ff ff       	call   801a04 <fd2sockid>
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 12                	js     801b54 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	ff 75 10             	pushl  0x10(%ebp)
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	e8 71 01 00 00       	call   801cc2 <nsipc_connect>
  801b51:	83 c4 10             	add    $0x10,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <listen>:
{
  801b56:	f3 0f 1e fb          	endbr32 
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	e8 9c fe ff ff       	call   801a04 <fd2sockid>
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 0f                	js     801b7b <listen+0x25>
	return nsipc_listen(r, backlog);
  801b6c:	83 ec 08             	sub    $0x8,%esp
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	50                   	push   %eax
  801b73:	e8 83 01 00 00       	call   801cfb <nsipc_listen>
  801b78:	83 c4 10             	add    $0x10,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <socket>:

int
socket(int domain, int type, int protocol)
{
  801b7d:	f3 0f 1e fb          	endbr32 
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b87:	ff 75 10             	pushl  0x10(%ebp)
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	e8 65 02 00 00       	call   801dfa <nsipc_socket>
  801b95:	83 c4 10             	add    $0x10,%esp
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	78 05                	js     801ba1 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801b9c:	e8 93 fe ff ff       	call   801a34 <alloc_sockfd>
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 04             	sub    $0x4,%esp
  801baa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bb3:	74 26                	je     801bdb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bb5:	6a 07                	push   $0x7
  801bb7:	68 00 60 80 00       	push   $0x806000
  801bbc:	53                   	push   %ebx
  801bbd:	ff 35 04 40 80 00    	pushl  0x804004
  801bc3:	e8 19 08 00 00       	call   8023e1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bc8:	83 c4 0c             	add    $0xc,%esp
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	e8 97 07 00 00       	call   80236d <ipc_recv>
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bdb:	83 ec 0c             	sub    $0xc,%esp
  801bde:	6a 02                	push   $0x2
  801be0:	e8 54 08 00 00       	call   802439 <ipc_find_env>
  801be5:	a3 04 40 80 00       	mov    %eax,0x804004
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	eb c6                	jmp    801bb5 <nsipc+0x12>

00801bef <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
  801bf8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c03:	8b 06                	mov    (%esi),%eax
  801c05:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	e8 8f ff ff ff       	call   801ba3 <nsipc>
  801c14:	89 c3                	mov    %eax,%ebx
  801c16:	85 c0                	test   %eax,%eax
  801c18:	79 09                	jns    801c23 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c1a:	89 d8                	mov    %ebx,%eax
  801c1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	ff 35 10 60 80 00    	pushl  0x806010
  801c2c:	68 00 60 80 00       	push   $0x806000
  801c31:	ff 75 0c             	pushl  0xc(%ebp)
  801c34:	e8 a5 ed ff ff       	call   8009de <memmove>
		*addrlen = ret->ret_addrlen;
  801c39:	a1 10 60 80 00       	mov    0x806010,%eax
  801c3e:	89 06                	mov    %eax,(%esi)
  801c40:	83 c4 10             	add    $0x10,%esp
	return r;
  801c43:	eb d5                	jmp    801c1a <nsipc_accept+0x2b>

00801c45 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c45:	f3 0f 1e fb          	endbr32 
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	53                   	push   %ebx
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c5b:	53                   	push   %ebx
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	68 04 60 80 00       	push   $0x806004
  801c64:	e8 75 ed ff ff       	call   8009de <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c69:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c6f:	b8 02 00 00 00       	mov    $0x2,%eax
  801c74:	e8 2a ff ff ff       	call   801ba3 <nsipc>
}
  801c79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c7e:	f3 0f 1e fb          	endbr32 
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c98:	b8 03 00 00 00       	mov    $0x3,%eax
  801c9d:	e8 01 ff ff ff       	call   801ba3 <nsipc>
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <nsipc_close>:

int
nsipc_close(int s)
{
  801ca4:	f3 0f 1e fb          	endbr32 
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cb6:	b8 04 00 00 00       	mov    $0x4,%eax
  801cbb:	e8 e3 fe ff ff       	call   801ba3 <nsipc>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cc2:	f3 0f 1e fb          	endbr32 
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	53                   	push   %ebx
  801cca:	83 ec 08             	sub    $0x8,%esp
  801ccd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cd8:	53                   	push   %ebx
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	68 04 60 80 00       	push   $0x806004
  801ce1:	e8 f8 ec ff ff       	call   8009de <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ce6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cec:	b8 05 00 00 00       	mov    $0x5,%eax
  801cf1:	e8 ad fe ff ff       	call   801ba3 <nsipc>
}
  801cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cfb:	f3 0f 1e fb          	endbr32 
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d15:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1a:	e8 84 fe ff ff       	call   801ba3 <nsipc>
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	56                   	push   %esi
  801d29:	53                   	push   %ebx
  801d2a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d35:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d43:	b8 07 00 00 00       	mov    $0x7,%eax
  801d48:	e8 56 fe ff ff       	call   801ba3 <nsipc>
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	78 26                	js     801d79 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801d53:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801d59:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801d5e:	0f 4e c6             	cmovle %esi,%eax
  801d61:	39 c3                	cmp    %eax,%ebx
  801d63:	7f 1d                	jg     801d82 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	53                   	push   %ebx
  801d69:	68 00 60 80 00       	push   $0x806000
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	e8 68 ec ff ff       	call   8009de <memmove>
  801d76:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d79:	89 d8                	mov    %ebx,%eax
  801d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d82:	68 5b 2b 80 00       	push   $0x802b5b
  801d87:	68 23 2b 80 00       	push   $0x802b23
  801d8c:	6a 62                	push   $0x62
  801d8e:	68 70 2b 80 00       	push   $0x802b70
  801d93:	e8 8b 05 00 00       	call   802323 <_panic>

00801d98 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d98:	f3 0f 1e fb          	endbr32 
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dae:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801db4:	7f 2e                	jg     801de4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db6:	83 ec 04             	sub    $0x4,%esp
  801db9:	53                   	push   %ebx
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	68 0c 60 80 00       	push   $0x80600c
  801dc2:	e8 17 ec ff ff       	call   8009de <memmove>
	nsipcbuf.send.req_size = size;
  801dc7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dd5:	b8 08 00 00 00       	mov    $0x8,%eax
  801dda:	e8 c4 fd ff ff       	call   801ba3 <nsipc>
}
  801ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    
	assert(size < 1600);
  801de4:	68 7c 2b 80 00       	push   $0x802b7c
  801de9:	68 23 2b 80 00       	push   $0x802b23
  801dee:	6a 6d                	push   $0x6d
  801df0:	68 70 2b 80 00       	push   $0x802b70
  801df5:	e8 29 05 00 00       	call   802323 <_panic>

00801dfa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dfa:	f3 0f 1e fb          	endbr32 
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e14:	8b 45 10             	mov    0x10(%ebp),%eax
  801e17:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e1c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e21:	e8 7d fd ff ff       	call   801ba3 <nsipc>
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e28:	f3 0f 1e fb          	endbr32 
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	56                   	push   %esi
  801e30:	53                   	push   %ebx
  801e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	ff 75 08             	pushl  0x8(%ebp)
  801e3a:	e8 d2 f1 ff ff       	call   801011 <fd2data>
  801e3f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e41:	83 c4 08             	add    $0x8,%esp
  801e44:	68 88 2b 80 00       	push   $0x802b88
  801e49:	53                   	push   %ebx
  801e4a:	e8 d9 e9 ff ff       	call   800828 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e4f:	8b 46 04             	mov    0x4(%esi),%eax
  801e52:	2b 06                	sub    (%esi),%eax
  801e54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e5a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e61:	00 00 00 
	stat->st_dev = &devpipe;
  801e64:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e6b:	30 80 00 
	return 0;
}
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5e                   	pop    %esi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e7a:	f3 0f 1e fb          	endbr32 
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	53                   	push   %ebx
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e88:	53                   	push   %ebx
  801e89:	6a 00                	push   $0x0
  801e8b:	e8 67 ee ff ff       	call   800cf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e90:	89 1c 24             	mov    %ebx,(%esp)
  801e93:	e8 79 f1 ff ff       	call   801011 <fd2data>
  801e98:	83 c4 08             	add    $0x8,%esp
  801e9b:	50                   	push   %eax
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 54 ee ff ff       	call   800cf7 <sys_page_unmap>
}
  801ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <_pipeisclosed>:
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	57                   	push   %edi
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 1c             	sub    $0x1c,%esp
  801eb1:	89 c7                	mov    %eax,%edi
  801eb3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801eb5:	a1 08 40 80 00       	mov    0x804008,%eax
  801eba:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ebd:	83 ec 0c             	sub    $0xc,%esp
  801ec0:	57                   	push   %edi
  801ec1:	e8 b0 05 00 00       	call   802476 <pageref>
  801ec6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ec9:	89 34 24             	mov    %esi,(%esp)
  801ecc:	e8 a5 05 00 00       	call   802476 <pageref>
		nn = thisenv->env_runs;
  801ed1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ed7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	39 cb                	cmp    %ecx,%ebx
  801edf:	74 1b                	je     801efc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ee1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ee4:	75 cf                	jne    801eb5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ee6:	8b 42 58             	mov    0x58(%edx),%eax
  801ee9:	6a 01                	push   $0x1
  801eeb:	50                   	push   %eax
  801eec:	53                   	push   %ebx
  801eed:	68 8f 2b 80 00       	push   $0x802b8f
  801ef2:	e8 27 e3 ff ff       	call   80021e <cprintf>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	eb b9                	jmp    801eb5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801efc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eff:	0f 94 c0             	sete   %al
  801f02:	0f b6 c0             	movzbl %al,%eax
}
  801f05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5f                   	pop    %edi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    

00801f0d <devpipe_write>:
{
  801f0d:	f3 0f 1e fb          	endbr32 
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	57                   	push   %edi
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	83 ec 28             	sub    $0x28,%esp
  801f1a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f1d:	56                   	push   %esi
  801f1e:	e8 ee f0 ff ff       	call   801011 <fd2data>
  801f23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f25:	83 c4 10             	add    $0x10,%esp
  801f28:	bf 00 00 00 00       	mov    $0x0,%edi
  801f2d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f30:	74 4f                	je     801f81 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f32:	8b 43 04             	mov    0x4(%ebx),%eax
  801f35:	8b 0b                	mov    (%ebx),%ecx
  801f37:	8d 51 20             	lea    0x20(%ecx),%edx
  801f3a:	39 d0                	cmp    %edx,%eax
  801f3c:	72 14                	jb     801f52 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801f3e:	89 da                	mov    %ebx,%edx
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	e8 61 ff ff ff       	call   801ea8 <_pipeisclosed>
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 3b                	jne    801f86 <devpipe_write+0x79>
			sys_yield();
  801f4b:	e8 f7 ec ff ff       	call   800c47 <sys_yield>
  801f50:	eb e0                	jmp    801f32 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f55:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f59:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f5c:	89 c2                	mov    %eax,%edx
  801f5e:	c1 fa 1f             	sar    $0x1f,%edx
  801f61:	89 d1                	mov    %edx,%ecx
  801f63:	c1 e9 1b             	shr    $0x1b,%ecx
  801f66:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f69:	83 e2 1f             	and    $0x1f,%edx
  801f6c:	29 ca                	sub    %ecx,%edx
  801f6e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f72:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f76:	83 c0 01             	add    $0x1,%eax
  801f79:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f7c:	83 c7 01             	add    $0x1,%edi
  801f7f:	eb ac                	jmp    801f2d <devpipe_write+0x20>
	return i;
  801f81:	8b 45 10             	mov    0x10(%ebp),%eax
  801f84:	eb 05                	jmp    801f8b <devpipe_write+0x7e>
				return 0;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8e:	5b                   	pop    %ebx
  801f8f:	5e                   	pop    %esi
  801f90:	5f                   	pop    %edi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <devpipe_read>:
{
  801f93:	f3 0f 1e fb          	endbr32 
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	57                   	push   %edi
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	83 ec 18             	sub    $0x18,%esp
  801fa0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fa3:	57                   	push   %edi
  801fa4:	e8 68 f0 ff ff       	call   801011 <fd2data>
  801fa9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	be 00 00 00 00       	mov    $0x0,%esi
  801fb3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb6:	75 14                	jne    801fcc <devpipe_read+0x39>
	return i;
  801fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbb:	eb 02                	jmp    801fbf <devpipe_read+0x2c>
				return i;
  801fbd:	89 f0                	mov    %esi,%eax
}
  801fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5f                   	pop    %edi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    
			sys_yield();
  801fc7:	e8 7b ec ff ff       	call   800c47 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fcc:	8b 03                	mov    (%ebx),%eax
  801fce:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fd1:	75 18                	jne    801feb <devpipe_read+0x58>
			if (i > 0)
  801fd3:	85 f6                	test   %esi,%esi
  801fd5:	75 e6                	jne    801fbd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801fd7:	89 da                	mov    %ebx,%edx
  801fd9:	89 f8                	mov    %edi,%eax
  801fdb:	e8 c8 fe ff ff       	call   801ea8 <_pipeisclosed>
  801fe0:	85 c0                	test   %eax,%eax
  801fe2:	74 e3                	je     801fc7 <devpipe_read+0x34>
				return 0;
  801fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe9:	eb d4                	jmp    801fbf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801feb:	99                   	cltd   
  801fec:	c1 ea 1b             	shr    $0x1b,%edx
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	83 e0 1f             	and    $0x1f,%eax
  801ff4:	29 d0                	sub    %edx,%eax
  801ff6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffe:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802001:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802004:	83 c6 01             	add    $0x1,%esi
  802007:	eb aa                	jmp    801fb3 <devpipe_read+0x20>

00802009 <pipe>:
{
  802009:	f3 0f 1e fb          	endbr32 
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	56                   	push   %esi
  802011:	53                   	push   %ebx
  802012:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802015:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802018:	50                   	push   %eax
  802019:	e8 0e f0 ff ff       	call   80102c <fd_alloc>
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	0f 88 23 01 00 00    	js     80214e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202b:	83 ec 04             	sub    $0x4,%esp
  80202e:	68 07 04 00 00       	push   $0x407
  802033:	ff 75 f4             	pushl  -0xc(%ebp)
  802036:	6a 00                	push   $0x0
  802038:	e8 2d ec ff ff       	call   800c6a <sys_page_alloc>
  80203d:	89 c3                	mov    %eax,%ebx
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	85 c0                	test   %eax,%eax
  802044:	0f 88 04 01 00 00    	js     80214e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80204a:	83 ec 0c             	sub    $0xc,%esp
  80204d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	e8 d6 ef ff ff       	call   80102c <fd_alloc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	0f 88 db 00 00 00    	js     80213e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	68 07 04 00 00       	push   $0x407
  80206b:	ff 75 f0             	pushl  -0x10(%ebp)
  80206e:	6a 00                	push   $0x0
  802070:	e8 f5 eb ff ff       	call   800c6a <sys_page_alloc>
  802075:	89 c3                	mov    %eax,%ebx
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	0f 88 bc 00 00 00    	js     80213e <pipe+0x135>
	va = fd2data(fd0);
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	ff 75 f4             	pushl  -0xc(%ebp)
  802088:	e8 84 ef ff ff       	call   801011 <fd2data>
  80208d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208f:	83 c4 0c             	add    $0xc,%esp
  802092:	68 07 04 00 00       	push   $0x407
  802097:	50                   	push   %eax
  802098:	6a 00                	push   $0x0
  80209a:	e8 cb eb ff ff       	call   800c6a <sys_page_alloc>
  80209f:	89 c3                	mov    %eax,%ebx
  8020a1:	83 c4 10             	add    $0x10,%esp
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	0f 88 82 00 00 00    	js     80212e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ac:	83 ec 0c             	sub    $0xc,%esp
  8020af:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b2:	e8 5a ef ff ff       	call   801011 <fd2data>
  8020b7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020be:	50                   	push   %eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	56                   	push   %esi
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 e8 eb ff ff       	call   800cb1 <sys_page_map>
  8020c9:	89 c3                	mov    %eax,%ebx
  8020cb:	83 c4 20             	add    $0x20,%esp
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	78 4e                	js     802120 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8020d2:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020da:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020df:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fb:	e8 fd ee ff ff       	call   800ffd <fd2num>
  802100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802103:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802105:	83 c4 04             	add    $0x4,%esp
  802108:	ff 75 f0             	pushl  -0x10(%ebp)
  80210b:	e8 ed ee ff ff       	call   800ffd <fd2num>
  802110:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802113:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211e:	eb 2e                	jmp    80214e <pipe+0x145>
	sys_page_unmap(0, va);
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	56                   	push   %esi
  802124:	6a 00                	push   $0x0
  802126:	e8 cc eb ff ff       	call   800cf7 <sys_page_unmap>
  80212b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	ff 75 f0             	pushl  -0x10(%ebp)
  802134:	6a 00                	push   $0x0
  802136:	e8 bc eb ff ff       	call   800cf7 <sys_page_unmap>
  80213b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80213e:	83 ec 08             	sub    $0x8,%esp
  802141:	ff 75 f4             	pushl  -0xc(%ebp)
  802144:	6a 00                	push   $0x0
  802146:	e8 ac eb ff ff       	call   800cf7 <sys_page_unmap>
  80214b:	83 c4 10             	add    $0x10,%esp
}
  80214e:	89 d8                	mov    %ebx,%eax
  802150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5d                   	pop    %ebp
  802156:	c3                   	ret    

00802157 <pipeisclosed>:
{
  802157:	f3 0f 1e fb          	endbr32 
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802161:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802164:	50                   	push   %eax
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	e8 15 ef ff ff       	call   801082 <fd_lookup>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 18                	js     80218c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	ff 75 f4             	pushl  -0xc(%ebp)
  80217a:	e8 92 ee ff ff       	call   801011 <fd2data>
  80217f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	e8 1f fd ff ff       	call   801ea8 <_pipeisclosed>
  802189:	83 c4 10             	add    $0x10,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80218e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
  802197:	c3                   	ret    

00802198 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802198:	f3 0f 1e fb          	endbr32 
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021a2:	68 a7 2b 80 00       	push   $0x802ba7
  8021a7:	ff 75 0c             	pushl  0xc(%ebp)
  8021aa:	e8 79 e6 ff ff       	call   800828 <strcpy>
	return 0;
}
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <devcons_write>:
{
  8021b6:	f3 0f 1e fb          	endbr32 
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	57                   	push   %edi
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
  8021c0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021c6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021d1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021d4:	73 31                	jae    802207 <devcons_write+0x51>
		m = n - tot;
  8021d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021d9:	29 f3                	sub    %esi,%ebx
  8021db:	83 fb 7f             	cmp    $0x7f,%ebx
  8021de:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021e3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	53                   	push   %ebx
  8021ea:	89 f0                	mov    %esi,%eax
  8021ec:	03 45 0c             	add    0xc(%ebp),%eax
  8021ef:	50                   	push   %eax
  8021f0:	57                   	push   %edi
  8021f1:	e8 e8 e7 ff ff       	call   8009de <memmove>
		sys_cputs(buf, m);
  8021f6:	83 c4 08             	add    $0x8,%esp
  8021f9:	53                   	push   %ebx
  8021fa:	57                   	push   %edi
  8021fb:	e8 9a e9 ff ff       	call   800b9a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802200:	01 de                	add    %ebx,%esi
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	eb ca                	jmp    8021d1 <devcons_write+0x1b>
}
  802207:	89 f0                	mov    %esi,%eax
  802209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80220c:	5b                   	pop    %ebx
  80220d:	5e                   	pop    %esi
  80220e:	5f                   	pop    %edi
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    

00802211 <devcons_read>:
{
  802211:	f3 0f 1e fb          	endbr32 
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 08             	sub    $0x8,%esp
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802220:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802224:	74 21                	je     802247 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802226:	e8 91 e9 ff ff       	call   800bbc <sys_cgetc>
  80222b:	85 c0                	test   %eax,%eax
  80222d:	75 07                	jne    802236 <devcons_read+0x25>
		sys_yield();
  80222f:	e8 13 ea ff ff       	call   800c47 <sys_yield>
  802234:	eb f0                	jmp    802226 <devcons_read+0x15>
	if (c < 0)
  802236:	78 0f                	js     802247 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802238:	83 f8 04             	cmp    $0x4,%eax
  80223b:	74 0c                	je     802249 <devcons_read+0x38>
	*(char*)vbuf = c;
  80223d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802240:	88 02                	mov    %al,(%edx)
	return 1;
  802242:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    
		return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	eb f7                	jmp    802247 <devcons_read+0x36>

00802250 <cputchar>:
{
  802250:	f3 0f 1e fb          	endbr32 
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802260:	6a 01                	push   $0x1
  802262:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802265:	50                   	push   %eax
  802266:	e8 2f e9 ff ff       	call   800b9a <sys_cputs>
}
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <getchar>:
{
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80227a:	6a 01                	push   $0x1
  80227c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80227f:	50                   	push   %eax
  802280:	6a 00                	push   $0x0
  802282:	e8 83 f0 ff ff       	call   80130a <read>
	if (r < 0)
  802287:	83 c4 10             	add    $0x10,%esp
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 06                	js     802294 <getchar+0x24>
	if (r < 1)
  80228e:	74 06                	je     802296 <getchar+0x26>
	return c;
  802290:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    
		return -E_EOF;
  802296:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80229b:	eb f7                	jmp    802294 <getchar+0x24>

0080229d <iscons>:
{
  80229d:	f3 0f 1e fb          	endbr32 
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022aa:	50                   	push   %eax
  8022ab:	ff 75 08             	pushl  0x8(%ebp)
  8022ae:	e8 cf ed ff ff       	call   801082 <fd_lookup>
  8022b3:	83 c4 10             	add    $0x10,%esp
  8022b6:	85 c0                	test   %eax,%eax
  8022b8:	78 11                	js     8022cb <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c3:	39 10                	cmp    %edx,(%eax)
  8022c5:	0f 94 c0             	sete   %al
  8022c8:	0f b6 c0             	movzbl %al,%eax
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <opencons>:
{
  8022cd:	f3 0f 1e fb          	endbr32 
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022da:	50                   	push   %eax
  8022db:	e8 4c ed ff ff       	call   80102c <fd_alloc>
  8022e0:	83 c4 10             	add    $0x10,%esp
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 3a                	js     802321 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	68 07 04 00 00       	push   $0x407
  8022ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f2:	6a 00                	push   $0x0
  8022f4:	e8 71 e9 ff ff       	call   800c6a <sys_page_alloc>
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	78 21                	js     802321 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802309:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	50                   	push   %eax
  802319:	e8 df ec ff ff       	call   800ffd <fd2num>
  80231e:	83 c4 10             	add    $0x10,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802323:	f3 0f 1e fb          	endbr32 
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80232c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80232f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802335:	e8 ea e8 ff ff       	call   800c24 <sys_getenvid>
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	ff 75 0c             	pushl  0xc(%ebp)
  802340:	ff 75 08             	pushl  0x8(%ebp)
  802343:	56                   	push   %esi
  802344:	50                   	push   %eax
  802345:	68 b4 2b 80 00       	push   $0x802bb4
  80234a:	e8 cf de ff ff       	call   80021e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80234f:	83 c4 18             	add    $0x18,%esp
  802352:	53                   	push   %ebx
  802353:	ff 75 10             	pushl  0x10(%ebp)
  802356:	e8 6e de ff ff       	call   8001c9 <vcprintf>
	cprintf("\n");
  80235b:	c7 04 24 30 27 80 00 	movl   $0x802730,(%esp)
  802362:	e8 b7 de ff ff       	call   80021e <cprintf>
  802367:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80236a:	cc                   	int3   
  80236b:	eb fd                	jmp    80236a <_panic+0x47>

0080236d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80236d:	f3 0f 1e fb          	endbr32 
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	56                   	push   %esi
  802375:	53                   	push   %ebx
  802376:	8b 75 08             	mov    0x8(%ebp),%esi
  802379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80237f:	83 e8 01             	sub    $0x1,%eax
  802382:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802387:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80238c:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802390:	83 ec 0c             	sub    $0xc,%esp
  802393:	50                   	push   %eax
  802394:	e8 9d ea ff ff       	call   800e36 <sys_ipc_recv>
	if (!t) {
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 2b                	jne    8023cb <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8023a0:	85 f6                	test   %esi,%esi
  8023a2:	74 0a                	je     8023ae <ipc_recv+0x41>
  8023a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8023a9:	8b 40 74             	mov    0x74(%eax),%eax
  8023ac:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8023ae:	85 db                	test   %ebx,%ebx
  8023b0:	74 0a                	je     8023bc <ipc_recv+0x4f>
  8023b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8023b7:	8b 40 78             	mov    0x78(%eax),%eax
  8023ba:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8023bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8023c1:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8023c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023c7:	5b                   	pop    %ebx
  8023c8:	5e                   	pop    %esi
  8023c9:	5d                   	pop    %ebp
  8023ca:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8023cb:	85 f6                	test   %esi,%esi
  8023cd:	74 06                	je     8023d5 <ipc_recv+0x68>
  8023cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8023d5:	85 db                	test   %ebx,%ebx
  8023d7:	74 eb                	je     8023c4 <ipc_recv+0x57>
  8023d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023df:	eb e3                	jmp    8023c4 <ipc_recv+0x57>

008023e1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023e1:	f3 0f 1e fb          	endbr32 
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	57                   	push   %edi
  8023e9:	56                   	push   %esi
  8023ea:	53                   	push   %ebx
  8023eb:	83 ec 0c             	sub    $0xc,%esp
  8023ee:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8023f7:	85 db                	test   %ebx,%ebx
  8023f9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023fe:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802401:	ff 75 14             	pushl  0x14(%ebp)
  802404:	53                   	push   %ebx
  802405:	56                   	push   %esi
  802406:	57                   	push   %edi
  802407:	e8 03 ea ff ff       	call   800e0f <sys_ipc_try_send>
  80240c:	83 c4 10             	add    $0x10,%esp
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 1e                	je     802431 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802413:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802416:	75 07                	jne    80241f <ipc_send+0x3e>
		sys_yield();
  802418:	e8 2a e8 ff ff       	call   800c47 <sys_yield>
  80241d:	eb e2                	jmp    802401 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80241f:	50                   	push   %eax
  802420:	68 d7 2b 80 00       	push   $0x802bd7
  802425:	6a 39                	push   $0x39
  802427:	68 e9 2b 80 00       	push   $0x802be9
  80242c:	e8 f2 fe ff ff       	call   802323 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5f                   	pop    %edi
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802439:	f3 0f 1e fb          	endbr32 
  80243d:	55                   	push   %ebp
  80243e:	89 e5                	mov    %esp,%ebp
  802440:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802448:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80244b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802451:	8b 52 50             	mov    0x50(%edx),%edx
  802454:	39 ca                	cmp    %ecx,%edx
  802456:	74 11                	je     802469 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802458:	83 c0 01             	add    $0x1,%eax
  80245b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802460:	75 e6                	jne    802448 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	eb 0b                	jmp    802474 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802469:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80246c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802471:	8b 40 48             	mov    0x48(%eax),%eax
}
  802474:	5d                   	pop    %ebp
  802475:	c3                   	ret    

00802476 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802476:	f3 0f 1e fb          	endbr32 
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802480:	89 c2                	mov    %eax,%edx
  802482:	c1 ea 16             	shr    $0x16,%edx
  802485:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80248c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802491:	f6 c1 01             	test   $0x1,%cl
  802494:	74 1c                	je     8024b2 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802496:	c1 e8 0c             	shr    $0xc,%eax
  802499:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8024a0:	a8 01                	test   $0x1,%al
  8024a2:	74 0e                	je     8024b2 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024a4:	c1 e8 0c             	shr    $0xc,%eax
  8024a7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8024ae:	ef 
  8024af:	0f b7 d2             	movzwl %dx,%edx
}
  8024b2:	89 d0                	mov    %edx,%eax
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	66 90                	xchg   %ax,%ax
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__udivdi3>:
  8024c0:	f3 0f 1e fb          	endbr32 
  8024c4:	55                   	push   %ebp
  8024c5:	57                   	push   %edi
  8024c6:	56                   	push   %esi
  8024c7:	53                   	push   %ebx
  8024c8:	83 ec 1c             	sub    $0x1c,%esp
  8024cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024db:	85 d2                	test   %edx,%edx
  8024dd:	75 19                	jne    8024f8 <__udivdi3+0x38>
  8024df:	39 f3                	cmp    %esi,%ebx
  8024e1:	76 4d                	jbe    802530 <__udivdi3+0x70>
  8024e3:	31 ff                	xor    %edi,%edi
  8024e5:	89 e8                	mov    %ebp,%eax
  8024e7:	89 f2                	mov    %esi,%edx
  8024e9:	f7 f3                	div    %ebx
  8024eb:	89 fa                	mov    %edi,%edx
  8024ed:	83 c4 1c             	add    $0x1c,%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    
  8024f5:	8d 76 00             	lea    0x0(%esi),%esi
  8024f8:	39 f2                	cmp    %esi,%edx
  8024fa:	76 14                	jbe    802510 <__udivdi3+0x50>
  8024fc:	31 ff                	xor    %edi,%edi
  8024fe:	31 c0                	xor    %eax,%eax
  802500:	89 fa                	mov    %edi,%edx
  802502:	83 c4 1c             	add    $0x1c,%esp
  802505:	5b                   	pop    %ebx
  802506:	5e                   	pop    %esi
  802507:	5f                   	pop    %edi
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    
  80250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802510:	0f bd fa             	bsr    %edx,%edi
  802513:	83 f7 1f             	xor    $0x1f,%edi
  802516:	75 48                	jne    802560 <__udivdi3+0xa0>
  802518:	39 f2                	cmp    %esi,%edx
  80251a:	72 06                	jb     802522 <__udivdi3+0x62>
  80251c:	31 c0                	xor    %eax,%eax
  80251e:	39 eb                	cmp    %ebp,%ebx
  802520:	77 de                	ja     802500 <__udivdi3+0x40>
  802522:	b8 01 00 00 00       	mov    $0x1,%eax
  802527:	eb d7                	jmp    802500 <__udivdi3+0x40>
  802529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802530:	89 d9                	mov    %ebx,%ecx
  802532:	85 db                	test   %ebx,%ebx
  802534:	75 0b                	jne    802541 <__udivdi3+0x81>
  802536:	b8 01 00 00 00       	mov    $0x1,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f3                	div    %ebx
  80253f:	89 c1                	mov    %eax,%ecx
  802541:	31 d2                	xor    %edx,%edx
  802543:	89 f0                	mov    %esi,%eax
  802545:	f7 f1                	div    %ecx
  802547:	89 c6                	mov    %eax,%esi
  802549:	89 e8                	mov    %ebp,%eax
  80254b:	89 f7                	mov    %esi,%edi
  80254d:	f7 f1                	div    %ecx
  80254f:	89 fa                	mov    %edi,%edx
  802551:	83 c4 1c             	add    $0x1c,%esp
  802554:	5b                   	pop    %ebx
  802555:	5e                   	pop    %esi
  802556:	5f                   	pop    %edi
  802557:	5d                   	pop    %ebp
  802558:	c3                   	ret    
  802559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802560:	89 f9                	mov    %edi,%ecx
  802562:	b8 20 00 00 00       	mov    $0x20,%eax
  802567:	29 f8                	sub    %edi,%eax
  802569:	d3 e2                	shl    %cl,%edx
  80256b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80256f:	89 c1                	mov    %eax,%ecx
  802571:	89 da                	mov    %ebx,%edx
  802573:	d3 ea                	shr    %cl,%edx
  802575:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802579:	09 d1                	or     %edx,%ecx
  80257b:	89 f2                	mov    %esi,%edx
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 f9                	mov    %edi,%ecx
  802583:	d3 e3                	shl    %cl,%ebx
  802585:	89 c1                	mov    %eax,%ecx
  802587:	d3 ea                	shr    %cl,%edx
  802589:	89 f9                	mov    %edi,%ecx
  80258b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80258f:	89 eb                	mov    %ebp,%ebx
  802591:	d3 e6                	shl    %cl,%esi
  802593:	89 c1                	mov    %eax,%ecx
  802595:	d3 eb                	shr    %cl,%ebx
  802597:	09 de                	or     %ebx,%esi
  802599:	89 f0                	mov    %esi,%eax
  80259b:	f7 74 24 08          	divl   0x8(%esp)
  80259f:	89 d6                	mov    %edx,%esi
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	f7 64 24 0c          	mull   0xc(%esp)
  8025a7:	39 d6                	cmp    %edx,%esi
  8025a9:	72 15                	jb     8025c0 <__udivdi3+0x100>
  8025ab:	89 f9                	mov    %edi,%ecx
  8025ad:	d3 e5                	shl    %cl,%ebp
  8025af:	39 c5                	cmp    %eax,%ebp
  8025b1:	73 04                	jae    8025b7 <__udivdi3+0xf7>
  8025b3:	39 d6                	cmp    %edx,%esi
  8025b5:	74 09                	je     8025c0 <__udivdi3+0x100>
  8025b7:	89 d8                	mov    %ebx,%eax
  8025b9:	31 ff                	xor    %edi,%edi
  8025bb:	e9 40 ff ff ff       	jmp    802500 <__udivdi3+0x40>
  8025c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025c3:	31 ff                	xor    %edi,%edi
  8025c5:	e9 36 ff ff ff       	jmp    802500 <__udivdi3+0x40>
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__umoddi3>:
  8025d0:	f3 0f 1e fb          	endbr32 
  8025d4:	55                   	push   %ebp
  8025d5:	57                   	push   %edi
  8025d6:	56                   	push   %esi
  8025d7:	53                   	push   %ebx
  8025d8:	83 ec 1c             	sub    $0x1c,%esp
  8025db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	75 19                	jne    802608 <__umoddi3+0x38>
  8025ef:	39 df                	cmp    %ebx,%edi
  8025f1:	76 5d                	jbe    802650 <__umoddi3+0x80>
  8025f3:	89 f0                	mov    %esi,%eax
  8025f5:	89 da                	mov    %ebx,%edx
  8025f7:	f7 f7                	div    %edi
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	83 c4 1c             	add    $0x1c,%esp
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	89 f2                	mov    %esi,%edx
  80260a:	39 d8                	cmp    %ebx,%eax
  80260c:	76 12                	jbe    802620 <__umoddi3+0x50>
  80260e:	89 f0                	mov    %esi,%eax
  802610:	89 da                	mov    %ebx,%edx
  802612:	83 c4 1c             	add    $0x1c,%esp
  802615:	5b                   	pop    %ebx
  802616:	5e                   	pop    %esi
  802617:	5f                   	pop    %edi
  802618:	5d                   	pop    %ebp
  802619:	c3                   	ret    
  80261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802620:	0f bd e8             	bsr    %eax,%ebp
  802623:	83 f5 1f             	xor    $0x1f,%ebp
  802626:	75 50                	jne    802678 <__umoddi3+0xa8>
  802628:	39 d8                	cmp    %ebx,%eax
  80262a:	0f 82 e0 00 00 00    	jb     802710 <__umoddi3+0x140>
  802630:	89 d9                	mov    %ebx,%ecx
  802632:	39 f7                	cmp    %esi,%edi
  802634:	0f 86 d6 00 00 00    	jbe    802710 <__umoddi3+0x140>
  80263a:	89 d0                	mov    %edx,%eax
  80263c:	89 ca                	mov    %ecx,%edx
  80263e:	83 c4 1c             	add    $0x1c,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    
  802646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80264d:	8d 76 00             	lea    0x0(%esi),%esi
  802650:	89 fd                	mov    %edi,%ebp
  802652:	85 ff                	test   %edi,%edi
  802654:	75 0b                	jne    802661 <__umoddi3+0x91>
  802656:	b8 01 00 00 00       	mov    $0x1,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f7                	div    %edi
  80265f:	89 c5                	mov    %eax,%ebp
  802661:	89 d8                	mov    %ebx,%eax
  802663:	31 d2                	xor    %edx,%edx
  802665:	f7 f5                	div    %ebp
  802667:	89 f0                	mov    %esi,%eax
  802669:	f7 f5                	div    %ebp
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	31 d2                	xor    %edx,%edx
  80266f:	eb 8c                	jmp    8025fd <__umoddi3+0x2d>
  802671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	ba 20 00 00 00       	mov    $0x20,%edx
  80267f:	29 ea                	sub    %ebp,%edx
  802681:	d3 e0                	shl    %cl,%eax
  802683:	89 44 24 08          	mov    %eax,0x8(%esp)
  802687:	89 d1                	mov    %edx,%ecx
  802689:	89 f8                	mov    %edi,%eax
  80268b:	d3 e8                	shr    %cl,%eax
  80268d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802691:	89 54 24 04          	mov    %edx,0x4(%esp)
  802695:	8b 54 24 04          	mov    0x4(%esp),%edx
  802699:	09 c1                	or     %eax,%ecx
  80269b:	89 d8                	mov    %ebx,%eax
  80269d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026a1:	89 e9                	mov    %ebp,%ecx
  8026a3:	d3 e7                	shl    %cl,%edi
  8026a5:	89 d1                	mov    %edx,%ecx
  8026a7:	d3 e8                	shr    %cl,%eax
  8026a9:	89 e9                	mov    %ebp,%ecx
  8026ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026af:	d3 e3                	shl    %cl,%ebx
  8026b1:	89 c7                	mov    %eax,%edi
  8026b3:	89 d1                	mov    %edx,%ecx
  8026b5:	89 f0                	mov    %esi,%eax
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	89 e9                	mov    %ebp,%ecx
  8026bb:	89 fa                	mov    %edi,%edx
  8026bd:	d3 e6                	shl    %cl,%esi
  8026bf:	09 d8                	or     %ebx,%eax
  8026c1:	f7 74 24 08          	divl   0x8(%esp)
  8026c5:	89 d1                	mov    %edx,%ecx
  8026c7:	89 f3                	mov    %esi,%ebx
  8026c9:	f7 64 24 0c          	mull   0xc(%esp)
  8026cd:	89 c6                	mov    %eax,%esi
  8026cf:	89 d7                	mov    %edx,%edi
  8026d1:	39 d1                	cmp    %edx,%ecx
  8026d3:	72 06                	jb     8026db <__umoddi3+0x10b>
  8026d5:	75 10                	jne    8026e7 <__umoddi3+0x117>
  8026d7:	39 c3                	cmp    %eax,%ebx
  8026d9:	73 0c                	jae    8026e7 <__umoddi3+0x117>
  8026db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8026df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026e3:	89 d7                	mov    %edx,%edi
  8026e5:	89 c6                	mov    %eax,%esi
  8026e7:	89 ca                	mov    %ecx,%edx
  8026e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ee:	29 f3                	sub    %esi,%ebx
  8026f0:	19 fa                	sbb    %edi,%edx
  8026f2:	89 d0                	mov    %edx,%eax
  8026f4:	d3 e0                	shl    %cl,%eax
  8026f6:	89 e9                	mov    %ebp,%ecx
  8026f8:	d3 eb                	shr    %cl,%ebx
  8026fa:	d3 ea                	shr    %cl,%edx
  8026fc:	09 d8                	or     %ebx,%eax
  8026fe:	83 c4 1c             	add    $0x1c,%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    
  802706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80270d:	8d 76 00             	lea    0x0(%esi),%esi
  802710:	29 fe                	sub    %edi,%esi
  802712:	19 c3                	sbb    %eax,%ebx
  802714:	89 f2                	mov    %esi,%edx
  802716:	89 d9                	mov    %ebx,%ecx
  802718:	e9 1d ff ff ff       	jmp    80263a <__umoddi3+0x6a>
