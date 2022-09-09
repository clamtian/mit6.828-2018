
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 08 02 00 00       	call   800239 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800043:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800046:	8d 7d d8             	lea    -0x28(%ebp),%edi
  800049:	eb 5e                	jmp    8000a9 <primeproc+0x76>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	85 c0                	test   %eax,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	0f 4e d0             	cmovle %eax,%edx
  800058:	52                   	push   %edx
  800059:	50                   	push   %eax
  80005a:	68 a0 29 80 00       	push   $0x8029a0
  80005f:	6a 15                	push   $0x15
  800061:	68 cf 29 80 00       	push   $0x8029cf
  800066:	e8 36 02 00 00       	call   8002a1 <_panic>
		panic("pipe: %e", i);
  80006b:	50                   	push   %eax
  80006c:	68 e5 29 80 00       	push   $0x8029e5
  800071:	6a 1b                	push   $0x1b
  800073:	68 cf 29 80 00       	push   $0x8029cf
  800078:	e8 24 02 00 00       	call   8002a1 <_panic>
	if ((id = fork()) < 0)
		panic("fork: %e", id);
  80007d:	50                   	push   %eax
  80007e:	68 ee 29 80 00       	push   $0x8029ee
  800083:	6a 1d                	push   $0x1d
  800085:	68 cf 29 80 00       	push   $0x8029cf
  80008a:	e8 12 02 00 00       	call   8002a1 <_panic>
	if (id == 0) {
		close(fd);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	53                   	push   %ebx
  800093:	e8 71 14 00 00       	call   801509 <close>
		close(pfd[1]);
  800098:	83 c4 04             	add    $0x4,%esp
  80009b:	ff 75 dc             	pushl  -0x24(%ebp)
  80009e:	e8 66 14 00 00       	call   801509 <close>
		fd = pfd[0];
  8000a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  8000a6:	83 c4 10             	add    $0x10,%esp
	if ((r = readn(fd, &p, 4)) != 4)
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 29 16 00 00       	call   8016de <readn>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	83 f8 04             	cmp    $0x4,%eax
  8000bb:	75 8e                	jne    80004b <primeproc+0x18>
	cprintf("%d\n", p);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c3:	68 e1 29 80 00       	push   $0x8029e1
  8000c8:	e8 bb 02 00 00       	call   800388 <cprintf>
	if ((i=pipe(pfd)) < 0)
  8000cd:	89 3c 24             	mov    %edi,(%esp)
  8000d0:	e8 59 21 00 00       	call   80222e <pipe>
  8000d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	78 8c                	js     80006b <primeproc+0x38>
	if ((id = fork()) < 0)
  8000df:	e8 24 11 00 00       	call   801208 <fork>
  8000e4:	85 c0                	test   %eax,%eax
  8000e6:	78 95                	js     80007d <primeproc+0x4a>
	if (id == 0) {
  8000e8:	74 a5                	je     80008f <primeproc+0x5c>
	}

	close(pfd[0]);
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	ff 75 d8             	pushl  -0x28(%ebp)
  8000f0:	e8 14 14 00 00       	call   801509 <close>
	wfd = pfd[1];
  8000f5:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8000f8:	83 c4 10             	add    $0x10,%esp

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8000fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	6a 04                	push   $0x4
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	e8 d4 15 00 00       	call   8016de <readn>
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	83 f8 04             	cmp    $0x4,%eax
  800110:	75 42                	jne    800154 <primeproc+0x121>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
		if (i%p)
  800112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800115:	99                   	cltd   
  800116:	f7 7d e0             	idivl  -0x20(%ebp)
  800119:	85 d2                	test   %edx,%edx
  80011b:	74 e1                	je     8000fe <primeproc+0xcb>
			if ((r=write(wfd, &i, 4)) != 4)
  80011d:	83 ec 04             	sub    $0x4,%esp
  800120:	6a 04                	push   $0x4
  800122:	56                   	push   %esi
  800123:	57                   	push   %edi
  800124:	e8 00 16 00 00       	call   801729 <write>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	83 f8 04             	cmp    $0x4,%eax
  80012f:	74 cd                	je     8000fe <primeproc+0xcb>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	85 c0                	test   %eax,%eax
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	0f 4e d0             	cmovle %eax,%edx
  80013e:	52                   	push   %edx
  80013f:	50                   	push   %eax
  800140:	ff 75 e0             	pushl  -0x20(%ebp)
  800143:	68 13 2a 80 00       	push   $0x802a13
  800148:	6a 2e                	push   $0x2e
  80014a:	68 cf 29 80 00       	push   $0x8029cf
  80014f:	e8 4d 01 00 00       	call   8002a1 <_panic>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	0f 4e d0             	cmovle %eax,%edx
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	53                   	push   %ebx
  800164:	ff 75 e0             	pushl  -0x20(%ebp)
  800167:	68 f7 29 80 00       	push   $0x8029f7
  80016c:	6a 2b                	push   $0x2b
  80016e:	68 cf 29 80 00       	push   $0x8029cf
  800173:	e8 29 01 00 00       	call   8002a1 <_panic>

00800178 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	53                   	push   %ebx
  800180:	83 ec 20             	sub    $0x20,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  800183:	c7 05 00 40 80 00 2d 	movl   $0x802a2d,0x804000
  80018a:	2a 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 98 20 00 00       	call   80222e <pipe>
  800196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	78 21                	js     8001c1 <umain+0x49>
		panic("pipe: %e", i);

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001a0:	e8 63 10 00 00       	call   801208 <fork>
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	78 2a                	js     8001d3 <umain+0x5b>
		panic("fork: %e", id);

	if (id == 0) {
  8001a9:	75 3a                	jne    8001e5 <umain+0x6d>
		close(p[1]);
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b1:	e8 53 13 00 00       	call   801509 <close>
		primeproc(p[0]);
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 72 fe ff ff       	call   800033 <primeproc>
		panic("pipe: %e", i);
  8001c1:	50                   	push   %eax
  8001c2:	68 e5 29 80 00       	push   $0x8029e5
  8001c7:	6a 3a                	push   $0x3a
  8001c9:	68 cf 29 80 00       	push   $0x8029cf
  8001ce:	e8 ce 00 00 00       	call   8002a1 <_panic>
		panic("fork: %e", id);
  8001d3:	50                   	push   %eax
  8001d4:	68 ee 29 80 00       	push   $0x8029ee
  8001d9:	6a 3e                	push   $0x3e
  8001db:	68 cf 29 80 00       	push   $0x8029cf
  8001e0:	e8 bc 00 00 00       	call   8002a1 <_panic>
	}

	close(p[0]);
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	ff 75 ec             	pushl  -0x14(%ebp)
  8001eb:	e8 19 13 00 00       	call   801509 <close>

	// feed all the integers through
	for (i=2;; i++)
  8001f0:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  8001f7:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001fa:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	6a 04                	push   $0x4
  800202:	53                   	push   %ebx
  800203:	ff 75 f0             	pushl  -0x10(%ebp)
  800206:	e8 1e 15 00 00       	call   801729 <write>
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	83 f8 04             	cmp    $0x4,%eax
  800211:	75 06                	jne    800219 <umain+0xa1>
	for (i=2;; i++)
  800213:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800217:	eb e4                	jmp    8001fd <umain+0x85>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	85 c0                	test   %eax,%eax
  80021e:	ba 00 00 00 00       	mov    $0x0,%edx
  800223:	0f 4e d0             	cmovle %eax,%edx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 38 2a 80 00       	push   $0x802a38
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 cf 29 80 00       	push   $0x8029cf
  800234:	e8 68 00 00 00       	call   8002a1 <_panic>

00800239 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	56                   	push   %esi
  800241:	53                   	push   %ebx
  800242:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800245:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800248:	e8 41 0b 00 00       	call   800d8e <sys_getenvid>
  80024d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800252:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800255:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025a:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 07                	jle    80026a <libmain+0x31>
		binaryname = argv[0];
  800263:	8b 06                	mov    (%esi),%eax
  800265:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	53                   	push   %ebx
  80026f:	e8 04 ff ff ff       	call   800178 <umain>

	// exit gracefully
	exit();
  800274:	e8 0a 00 00 00       	call   800283 <exit>
}
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028d:	e8 a8 12 00 00       	call   80153a <close_all>
	sys_env_destroy(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 ad 0a 00 00       	call   800d49 <sys_env_destroy>
}
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002a1:	f3 0f 1e fb          	endbr32 
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002aa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ad:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8002b3:	e8 d6 0a 00 00       	call   800d8e <sys_getenvid>
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	56                   	push   %esi
  8002c2:	50                   	push   %eax
  8002c3:	68 5c 2a 80 00       	push   $0x802a5c
  8002c8:	e8 bb 00 00 00       	call   800388 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002cd:	83 c4 18             	add    $0x18,%esp
  8002d0:	53                   	push   %ebx
  8002d1:	ff 75 10             	pushl  0x10(%ebp)
  8002d4:	e8 5a 00 00 00       	call   800333 <vcprintf>
	cprintf("\n");
  8002d9:	c7 04 24 e3 29 80 00 	movl   $0x8029e3,(%esp)
  8002e0:	e8 a3 00 00 00       	call   800388 <cprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002e8:	cc                   	int3   
  8002e9:	eb fd                	jmp    8002e8 <_panic+0x47>

008002eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002f9:	8b 13                	mov    (%ebx),%edx
  8002fb:	8d 42 01             	lea    0x1(%edx),%eax
  8002fe:	89 03                	mov    %eax,(%ebx)
  800300:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800303:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800307:	3d ff 00 00 00       	cmp    $0xff,%eax
  80030c:	74 09                	je     800317 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80030e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800315:	c9                   	leave  
  800316:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	68 ff 00 00 00       	push   $0xff
  80031f:	8d 43 08             	lea    0x8(%ebx),%eax
  800322:	50                   	push   %eax
  800323:	e8 dc 09 00 00       	call   800d04 <sys_cputs>
		b->idx = 0;
  800328:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb db                	jmp    80030e <putch+0x23>

00800333 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800333:	f3 0f 1e fb          	endbr32 
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800340:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800347:	00 00 00 
	b.cnt = 0;
  80034a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800351:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800354:	ff 75 0c             	pushl  0xc(%ebp)
  800357:	ff 75 08             	pushl  0x8(%ebp)
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	68 eb 02 80 00       	push   $0x8002eb
  800366:	e8 20 01 00 00       	call   80048b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036b:	83 c4 08             	add    $0x8,%esp
  80036e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800374:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	e8 84 09 00 00       	call   800d04 <sys_cputs>

	return b.cnt;
}
  800380:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800386:	c9                   	leave  
  800387:	c3                   	ret    

00800388 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 95 ff ff ff       	call   800333 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 1c             	sub    $0x1c,%esp
  8003a9:	89 c7                	mov    %eax,%edi
  8003ab:	89 d6                	mov    %edx,%esi
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b3:	89 d1                	mov    %edx,%ecx
  8003b5:	89 c2                	mov    %eax,%edx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8003d2:	72 3e                	jb     800412 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	ff 75 18             	pushl  0x18(%ebp)
  8003da:	83 eb 01             	sub    $0x1,%ebx
  8003dd:	53                   	push   %ebx
  8003de:	50                   	push   %eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ee:	e8 4d 23 00 00       	call   802740 <__udivdi3>
  8003f3:	83 c4 18             	add    $0x18,%esp
  8003f6:	52                   	push   %edx
  8003f7:	50                   	push   %eax
  8003f8:	89 f2                	mov    %esi,%edx
  8003fa:	89 f8                	mov    %edi,%eax
  8003fc:	e8 9f ff ff ff       	call   8003a0 <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 13                	jmp    800419 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	56                   	push   %esi
  80040a:	ff 75 18             	pushl  0x18(%ebp)
  80040d:	ff d7                	call   *%edi
  80040f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800412:	83 eb 01             	sub    $0x1,%ebx
  800415:	85 db                	test   %ebx,%ebx
  800417:	7f ed                	jg     800406 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	56                   	push   %esi
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	ff 75 e4             	pushl  -0x1c(%ebp)
  800423:	ff 75 e0             	pushl  -0x20(%ebp)
  800426:	ff 75 dc             	pushl  -0x24(%ebp)
  800429:	ff 75 d8             	pushl  -0x28(%ebp)
  80042c:	e8 1f 24 00 00       	call   802850 <__umoddi3>
  800431:	83 c4 14             	add    $0x14,%esp
  800434:	0f be 80 7f 2a 80 00 	movsbl 0x802a7f(%eax),%eax
  80043b:	50                   	push   %eax
  80043c:	ff d7                	call   *%edi
}
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800449:	f3 0f 1e fb          	endbr32 
  80044d:	55                   	push   %ebp
  80044e:	89 e5                	mov    %esp,%ebp
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800453:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800457:	8b 10                	mov    (%eax),%edx
  800459:	3b 50 04             	cmp    0x4(%eax),%edx
  80045c:	73 0a                	jae    800468 <sprintputch+0x1f>
		*b->buf++ = ch;
  80045e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800461:	89 08                	mov    %ecx,(%eax)
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	88 02                	mov    %al,(%edx)
}
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    

0080046a <printfmt>:
{
  80046a:	f3 0f 1e fb          	endbr32 
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800474:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800477:	50                   	push   %eax
  800478:	ff 75 10             	pushl  0x10(%ebp)
  80047b:	ff 75 0c             	pushl  0xc(%ebp)
  80047e:	ff 75 08             	pushl  0x8(%ebp)
  800481:	e8 05 00 00 00       	call   80048b <vprintfmt>
}
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <vprintfmt>:
{
  80048b:	f3 0f 1e fb          	endbr32 
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	57                   	push   %edi
  800493:	56                   	push   %esi
  800494:	53                   	push   %ebx
  800495:	83 ec 3c             	sub    $0x3c,%esp
  800498:	8b 75 08             	mov    0x8(%ebp),%esi
  80049b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80049e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004a1:	e9 8e 03 00 00       	jmp    800834 <vprintfmt+0x3a9>
		padc = ' ';
  8004a6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004aa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004b1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c4:	8d 47 01             	lea    0x1(%edi),%eax
  8004c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ca:	0f b6 17             	movzbl (%edi),%edx
  8004cd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004d0:	3c 55                	cmp    $0x55,%al
  8004d2:	0f 87 df 03 00 00    	ja     8008b7 <vprintfmt+0x42c>
  8004d8:	0f b6 c0             	movzbl %al,%eax
  8004db:	3e ff 24 85 c0 2b 80 	notrack jmp *0x802bc0(,%eax,4)
  8004e2:	00 
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004e6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004ea:	eb d8                	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004f3:	eb cf                	jmp    8004c4 <vprintfmt+0x39>
  8004f5:	0f b6 d2             	movzbl %dl,%edx
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800500:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800503:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800506:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80050a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80050d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800510:	83 f9 09             	cmp    $0x9,%ecx
  800513:	77 55                	ja     80056a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800515:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800518:	eb e9                	jmp    800503 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 40 04             	lea    0x4(%eax),%eax
  800528:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80052e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800532:	79 90                	jns    8004c4 <vprintfmt+0x39>
				width = precision, precision = -1;
  800534:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800537:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800541:	eb 81                	jmp    8004c4 <vprintfmt+0x39>
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	85 c0                	test   %eax,%eax
  800548:	ba 00 00 00 00       	mov    $0x0,%edx
  80054d:	0f 49 d0             	cmovns %eax,%edx
  800550:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800556:	e9 69 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80055e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800565:	e9 5a ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
  80056a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80056d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800570:	eb bc                	jmp    80052e <vprintfmt+0xa3>
			lflag++;
  800572:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800575:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800578:	e9 47 ff ff ff       	jmp    8004c4 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 78 04             	lea    0x4(%eax),%edi
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	ff 30                	pushl  (%eax)
  800589:	ff d6                	call   *%esi
			break;
  80058b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80058e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800591:	e9 9b 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 78 04             	lea    0x4(%eax),%edi
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	99                   	cltd   
  80059f:	31 d0                	xor    %edx,%eax
  8005a1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005a3:	83 f8 0f             	cmp    $0xf,%eax
  8005a6:	7f 23                	jg     8005cb <vprintfmt+0x140>
  8005a8:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  8005af:	85 d2                	test   %edx,%edx
  8005b1:	74 18                	je     8005cb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005b3:	52                   	push   %edx
  8005b4:	68 75 2f 80 00       	push   $0x802f75
  8005b9:	53                   	push   %ebx
  8005ba:	56                   	push   %esi
  8005bb:	e8 aa fe ff ff       	call   80046a <printfmt>
  8005c0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005c3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005c6:	e9 66 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	50                   	push   %eax
  8005cc:	68 97 2a 80 00       	push   $0x802a97
  8005d1:	53                   	push   %ebx
  8005d2:	56                   	push   %esi
  8005d3:	e8 92 fe ff ff       	call   80046a <printfmt>
  8005d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005db:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005de:	e9 4e 02 00 00       	jmp    800831 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 c0 04             	add    $0x4,%eax
  8005e9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005f1:	85 d2                	test   %edx,%edx
  8005f3:	b8 90 2a 80 00       	mov    $0x802a90,%eax
  8005f8:	0f 45 c2             	cmovne %edx,%eax
  8005fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800602:	7e 06                	jle    80060a <vprintfmt+0x17f>
  800604:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800608:	75 0d                	jne    800617 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80060d:	89 c7                	mov    %eax,%edi
  80060f:	03 45 e0             	add    -0x20(%ebp),%eax
  800612:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800615:	eb 55                	jmp    80066c <vprintfmt+0x1e1>
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 d8             	pushl  -0x28(%ebp)
  80061d:	ff 75 cc             	pushl  -0x34(%ebp)
  800620:	e8 46 03 00 00       	call   80096b <strnlen>
  800625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800632:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800636:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800639:	85 ff                	test   %edi,%edi
  80063b:	7e 11                	jle    80064e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800646:	83 ef 01             	sub    $0x1,%edi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb eb                	jmp    800639 <vprintfmt+0x1ae>
  80064e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800651:	85 d2                	test   %edx,%edx
  800653:	b8 00 00 00 00       	mov    $0x0,%eax
  800658:	0f 49 c2             	cmovns %edx,%eax
  80065b:	29 c2                	sub    %eax,%edx
  80065d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800660:	eb a8                	jmp    80060a <vprintfmt+0x17f>
					putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	52                   	push   %edx
  800667:	ff d6                	call   *%esi
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80066f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800671:	83 c7 01             	add    $0x1,%edi
  800674:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800678:	0f be d0             	movsbl %al,%edx
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 4b                	je     8006ca <vprintfmt+0x23f>
  80067f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800683:	78 06                	js     80068b <vprintfmt+0x200>
  800685:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800689:	78 1e                	js     8006a9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80068b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80068f:	74 d1                	je     800662 <vprintfmt+0x1d7>
  800691:	0f be c0             	movsbl %al,%eax
  800694:	83 e8 20             	sub    $0x20,%eax
  800697:	83 f8 5e             	cmp    $0x5e,%eax
  80069a:	76 c6                	jbe    800662 <vprintfmt+0x1d7>
					putch('?', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 3f                	push   $0x3f
  8006a2:	ff d6                	call   *%esi
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	eb c3                	jmp    80066c <vprintfmt+0x1e1>
  8006a9:	89 cf                	mov    %ecx,%edi
  8006ab:	eb 0e                	jmp    8006bb <vprintfmt+0x230>
				putch(' ', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 20                	push   $0x20
  8006b3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	85 ff                	test   %edi,%edi
  8006bd:	7f ee                	jg     8006ad <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c5:	e9 67 01 00 00       	jmp    800831 <vprintfmt+0x3a6>
  8006ca:	89 cf                	mov    %ecx,%edi
  8006cc:	eb ed                	jmp    8006bb <vprintfmt+0x230>
	if (lflag >= 2)
  8006ce:	83 f9 01             	cmp    $0x1,%ecx
  8006d1:	7f 1b                	jg     8006ee <vprintfmt+0x263>
	else if (lflag)
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	74 63                	je     80073a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	99                   	cltd   
  8006e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	eb 17                	jmp    800705 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 50 04             	mov    0x4(%eax),%edx
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8d 40 08             	lea    0x8(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800705:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800708:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80070b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800710:	85 c9                	test   %ecx,%ecx
  800712:	0f 89 ff 00 00 00    	jns    800817 <vprintfmt+0x38c>
				putch('-', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 2d                	push   $0x2d
  80071e:	ff d6                	call   *%esi
				num = -(long long) num;
  800720:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800723:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800726:	f7 da                	neg    %edx
  800728:	83 d1 00             	adc    $0x0,%ecx
  80072b:	f7 d9                	neg    %ecx
  80072d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 dd 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800742:	99                   	cltd   
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 04             	lea    0x4(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
  80074f:	eb b4                	jmp    800705 <vprintfmt+0x27a>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7f 1e                	jg     800774 <vprintfmt+0x2e9>
	else if (lflag)
  800756:	85 c9                	test   %ecx,%ecx
  800758:	74 32                	je     80078c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80076f:	e9 a3 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800782:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800787:	e9 8b 00 00 00       	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80079c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	eb 74                	jmp    800817 <vprintfmt+0x38c>
	if (lflag >= 2)
  8007a3:	83 f9 01             	cmp    $0x1,%ecx
  8007a6:	7f 1b                	jg     8007c3 <vprintfmt+0x338>
	else if (lflag)
  8007a8:	85 c9                	test   %ecx,%ecx
  8007aa:	74 2c                	je     8007d8 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8b 10                	mov    (%eax),%edx
  8007b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b6:	8d 40 04             	lea    0x4(%eax),%eax
  8007b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bc:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8007c1:	eb 54                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 10                	mov    (%eax),%edx
  8007c8:	8b 48 04             	mov    0x4(%eax),%ecx
  8007cb:	8d 40 08             	lea    0x8(%eax),%eax
  8007ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8007d6:	eb 3f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007db:	8b 10                	mov    (%eax),%edx
  8007dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e2:	8d 40 04             	lea    0x4(%eax),%eax
  8007e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007ed:	eb 28                	jmp    800817 <vprintfmt+0x38c>
			putch('0', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	6a 30                	push   $0x30
  8007f5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f7:	83 c4 08             	add    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 78                	push   $0x78
  8007fd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800809:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80080c:	8d 40 04             	lea    0x4(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800812:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800817:	83 ec 0c             	sub    $0xc,%esp
  80081a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80081e:	57                   	push   %edi
  80081f:	ff 75 e0             	pushl  -0x20(%ebp)
  800822:	50                   	push   %eax
  800823:	51                   	push   %ecx
  800824:	52                   	push   %edx
  800825:	89 da                	mov    %ebx,%edx
  800827:	89 f0                	mov    %esi,%eax
  800829:	e8 72 fb ff ff       	call   8003a0 <printnum>
			break;
  80082e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800831:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800834:	83 c7 01             	add    $0x1,%edi
  800837:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80083b:	83 f8 25             	cmp    $0x25,%eax
  80083e:	0f 84 62 fc ff ff    	je     8004a6 <vprintfmt+0x1b>
			if (ch == '\0')
  800844:	85 c0                	test   %eax,%eax
  800846:	0f 84 8b 00 00 00    	je     8008d7 <vprintfmt+0x44c>
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	50                   	push   %eax
  800851:	ff d6                	call   *%esi
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	eb dc                	jmp    800834 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800858:	83 f9 01             	cmp    $0x1,%ecx
  80085b:	7f 1b                	jg     800878 <vprintfmt+0x3ed>
	else if (lflag)
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	74 2c                	je     80088d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
  800866:	b9 00 00 00 00       	mov    $0x0,%ecx
  80086b:	8d 40 04             	lea    0x4(%eax),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800871:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800876:	eb 9f                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8b 10                	mov    (%eax),%edx
  80087d:	8b 48 04             	mov    0x4(%eax),%ecx
  800880:	8d 40 08             	lea    0x8(%eax),%eax
  800883:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800886:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80088b:	eb 8a                	jmp    800817 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	8b 10                	mov    (%eax),%edx
  800892:	b9 00 00 00 00       	mov    $0x0,%ecx
  800897:	8d 40 04             	lea    0x4(%eax),%eax
  80089a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8008a2:	e9 70 ff ff ff       	jmp    800817 <vprintfmt+0x38c>
			putch(ch, putdat);
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	6a 25                	push   $0x25
  8008ad:	ff d6                	call   *%esi
			break;
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	e9 7a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
			putch('%', putdat);
  8008b7:	83 ec 08             	sub    $0x8,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	6a 25                	push   $0x25
  8008bd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	89 f8                	mov    %edi,%eax
  8008c4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008c8:	74 05                	je     8008cf <vprintfmt+0x444>
  8008ca:	83 e8 01             	sub    $0x1,%eax
  8008cd:	eb f5                	jmp    8008c4 <vprintfmt+0x439>
  8008cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d2:	e9 5a ff ff ff       	jmp    800831 <vprintfmt+0x3a6>
}
  8008d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008df:	f3 0f 1e fb          	endbr32 
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800900:	85 c0                	test   %eax,%eax
  800902:	74 26                	je     80092a <vsnprintf+0x4b>
  800904:	85 d2                	test   %edx,%edx
  800906:	7e 22                	jle    80092a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 49 04 80 00       	push   $0x800449
  800917:	e8 6f fb ff ff       	call   80048b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800925:	83 c4 10             	add    $0x10,%esp
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    
		return -E_INVAL;
  80092a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092f:	eb f7                	jmp    800928 <vsnprintf+0x49>

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	f3 0f 1e fb          	endbr32 
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093e:	50                   	push   %eax
  80093f:	ff 75 10             	pushl  0x10(%ebp)
  800942:	ff 75 0c             	pushl  0xc(%ebp)
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 92 ff ff ff       	call   8008df <vsnprintf>
	va_end(ap);

	return rc;
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800962:	74 05                	je     800969 <strlen+0x1a>
		n++;
  800964:	83 c0 01             	add    $0x1,%eax
  800967:	eb f5                	jmp    80095e <strlen+0xf>
	return n;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
  80097d:	39 d0                	cmp    %edx,%eax
  80097f:	74 0d                	je     80098e <strnlen+0x23>
  800981:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800985:	74 05                	je     80098c <strnlen+0x21>
		n++;
  800987:	83 c0 01             	add    $0x1,%eax
  80098a:	eb f1                	jmp    80097d <strnlen+0x12>
  80098c:	89 c2                	mov    %eax,%edx
	return n;
}
  80098e:	89 d0                	mov    %edx,%eax
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800992:	f3 0f 1e fb          	endbr32 
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	53                   	push   %ebx
  80099a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8009a9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8009ac:	83 c0 01             	add    $0x1,%eax
  8009af:	84 d2                	test   %dl,%dl
  8009b1:	75 f2                	jne    8009a5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8009b3:	89 c8                	mov    %ecx,%eax
  8009b5:	5b                   	pop    %ebx
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 10             	sub    $0x10,%esp
  8009c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c6:	53                   	push   %ebx
  8009c7:	e8 83 ff ff ff       	call   80094f <strlen>
  8009cc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	01 d8                	add    %ebx,%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 b8 ff ff ff       	call   800992 <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	56                   	push   %esi
  8009e9:	53                   	push   %ebx
  8009ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	89 f3                	mov    %esi,%ebx
  8009f2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f5:	89 f0                	mov    %esi,%eax
  8009f7:	39 d8                	cmp    %ebx,%eax
  8009f9:	74 11                	je     800a0c <strncpy+0x2b>
		*dst++ = *src;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	0f b6 0a             	movzbl (%edx),%ecx
  800a01:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a04:	80 f9 01             	cmp    $0x1,%cl
  800a07:	83 da ff             	sbb    $0xffffffff,%edx
  800a0a:	eb eb                	jmp    8009f7 <strncpy+0x16>
	}
	return ret;
}
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a12:	f3 0f 1e fb          	endbr32 
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	56                   	push   %esi
  800a1a:	53                   	push   %ebx
  800a1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a21:	8b 55 10             	mov    0x10(%ebp),%edx
  800a24:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a26:	85 d2                	test   %edx,%edx
  800a28:	74 21                	je     800a4b <strlcpy+0x39>
  800a2a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	74 14                	je     800a48 <strlcpy+0x36>
  800a34:	0f b6 19             	movzbl (%ecx),%ebx
  800a37:	84 db                	test   %bl,%bl
  800a39:	74 0b                	je     800a46 <strlcpy+0x34>
			*dst++ = *src++;
  800a3b:	83 c1 01             	add    $0x1,%ecx
  800a3e:	83 c2 01             	add    $0x1,%edx
  800a41:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a44:	eb ea                	jmp    800a30 <strlcpy+0x1e>
  800a46:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a4b:	29 f0                	sub    %esi,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a51:	f3 0f 1e fb          	endbr32 
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a5e:	0f b6 01             	movzbl (%ecx),%eax
  800a61:	84 c0                	test   %al,%al
  800a63:	74 0c                	je     800a71 <strcmp+0x20>
  800a65:	3a 02                	cmp    (%edx),%al
  800a67:	75 08                	jne    800a71 <strcmp+0x20>
		p++, q++;
  800a69:	83 c1 01             	add    $0x1,%ecx
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	eb ed                	jmp    800a5e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a71:	0f b6 c0             	movzbl %al,%eax
  800a74:	0f b6 12             	movzbl (%edx),%edx
  800a77:	29 d0                	sub    %edx,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7b:	f3 0f 1e fb          	endbr32 
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8e:	eb 06                	jmp    800a96 <strncmp+0x1b>
		n--, p++, q++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a96:	39 d8                	cmp    %ebx,%eax
  800a98:	74 16                	je     800ab0 <strncmp+0x35>
  800a9a:	0f b6 08             	movzbl (%eax),%ecx
  800a9d:	84 c9                	test   %cl,%cl
  800a9f:	74 04                	je     800aa5 <strncmp+0x2a>
  800aa1:	3a 0a                	cmp    (%edx),%cl
  800aa3:	74 eb                	je     800a90 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa5:	0f b6 00             	movzbl (%eax),%eax
  800aa8:	0f b6 12             	movzbl (%edx),%edx
  800aab:	29 d0                	sub    %edx,%eax
}
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    
		return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb f6                	jmp    800aad <strncmp+0x32>

00800ab7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab7:	f3 0f 1e fb          	endbr32 
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	0f b6 10             	movzbl (%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	74 09                	je     800ad5 <strchr+0x1e>
		if (*s == c)
  800acc:	38 ca                	cmp    %cl,%dl
  800ace:	74 0a                	je     800ada <strchr+0x23>
	for (; *s; s++)
  800ad0:	83 c0 01             	add    $0x1,%eax
  800ad3:	eb f0                	jmp    800ac5 <strchr+0xe>
			return (char *) s;
	return 0;
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adc:	f3 0f 1e fb          	endbr32 
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aea:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aed:	38 ca                	cmp    %cl,%dl
  800aef:	74 09                	je     800afa <strfind+0x1e>
  800af1:	84 d2                	test   %dl,%dl
  800af3:	74 05                	je     800afa <strfind+0x1e>
	for (; *s; s++)
  800af5:	83 c0 01             	add    $0x1,%eax
  800af8:	eb f0                	jmp    800aea <strfind+0xe>
			break;
	return (char *) s;
}
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800afc:	f3 0f 1e fb          	endbr32 
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	57                   	push   %edi
  800b04:	56                   	push   %esi
  800b05:	53                   	push   %ebx
  800b06:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b09:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b0c:	85 c9                	test   %ecx,%ecx
  800b0e:	74 31                	je     800b41 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b10:	89 f8                	mov    %edi,%eax
  800b12:	09 c8                	or     %ecx,%eax
  800b14:	a8 03                	test   $0x3,%al
  800b16:	75 23                	jne    800b3b <memset+0x3f>
		c &= 0xFF;
  800b18:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b1c:	89 d3                	mov    %edx,%ebx
  800b1e:	c1 e3 08             	shl    $0x8,%ebx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	c1 e0 18             	shl    $0x18,%eax
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	c1 e6 10             	shl    $0x10,%esi
  800b2b:	09 f0                	or     %esi,%eax
  800b2d:	09 c2                	or     %eax,%edx
  800b2f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b31:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b34:	89 d0                	mov    %edx,%eax
  800b36:	fc                   	cld    
  800b37:	f3 ab                	rep stos %eax,%es:(%edi)
  800b39:	eb 06                	jmp    800b41 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3e:	fc                   	cld    
  800b3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b41:	89 f8                	mov    %edi,%eax
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b57:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b5a:	39 c6                	cmp    %eax,%esi
  800b5c:	73 32                	jae    800b90 <memmove+0x48>
  800b5e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b61:	39 c2                	cmp    %eax,%edx
  800b63:	76 2b                	jbe    800b90 <memmove+0x48>
		s += n;
		d += n;
  800b65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	89 fe                	mov    %edi,%esi
  800b6a:	09 ce                	or     %ecx,%esi
  800b6c:	09 d6                	or     %edx,%esi
  800b6e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b74:	75 0e                	jne    800b84 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b76:	83 ef 04             	sub    $0x4,%edi
  800b79:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b7c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b7f:	fd                   	std    
  800b80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b82:	eb 09                	jmp    800b8d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b84:	83 ef 01             	sub    $0x1,%edi
  800b87:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b8a:	fd                   	std    
  800b8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b8d:	fc                   	cld    
  800b8e:	eb 1a                	jmp    800baa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	09 ca                	or     %ecx,%edx
  800b94:	09 f2                	or     %esi,%edx
  800b96:	f6 c2 03             	test   $0x3,%dl
  800b99:	75 0a                	jne    800ba5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	fc                   	cld    
  800ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba3:	eb 05                	jmp    800baa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ba5:	89 c7                	mov    %eax,%edi
  800ba7:	fc                   	cld    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bae:	f3 0f 1e fb          	endbr32 
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb8:	ff 75 10             	pushl  0x10(%ebp)
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 82 ff ff ff       	call   800b48 <memmove>
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc8:	f3 0f 1e fb          	endbr32 
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	89 c6                	mov    %eax,%esi
  800bd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdc:	39 f0                	cmp    %esi,%eax
  800bde:	74 1c                	je     800bfc <memcmp+0x34>
		if (*s1 != *s2)
  800be0:	0f b6 08             	movzbl (%eax),%ecx
  800be3:	0f b6 1a             	movzbl (%edx),%ebx
  800be6:	38 d9                	cmp    %bl,%cl
  800be8:	75 08                	jne    800bf2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	83 c2 01             	add    $0x1,%edx
  800bf0:	eb ea                	jmp    800bdc <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bf2:	0f b6 c1             	movzbl %cl,%eax
  800bf5:	0f b6 db             	movzbl %bl,%ebx
  800bf8:	29 d8                	sub    %ebx,%eax
  800bfa:	eb 05                	jmp    800c01 <memcmp+0x39>
	}

	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	f3 0f 1e fb          	endbr32 
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c17:	39 d0                	cmp    %edx,%eax
  800c19:	73 09                	jae    800c24 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1b:	38 08                	cmp    %cl,(%eax)
  800c1d:	74 05                	je     800c24 <memfind+0x1f>
	for (; s < ends; s++)
  800c1f:	83 c0 01             	add    $0x1,%eax
  800c22:	eb f3                	jmp    800c17 <memfind+0x12>
			break;
	return (void *) s;
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c26:	f3 0f 1e fb          	endbr32 
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c33:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c36:	eb 03                	jmp    800c3b <strtol+0x15>
		s++;
  800c38:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c3b:	0f b6 01             	movzbl (%ecx),%eax
  800c3e:	3c 20                	cmp    $0x20,%al
  800c40:	74 f6                	je     800c38 <strtol+0x12>
  800c42:	3c 09                	cmp    $0x9,%al
  800c44:	74 f2                	je     800c38 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800c46:	3c 2b                	cmp    $0x2b,%al
  800c48:	74 2a                	je     800c74 <strtol+0x4e>
	int neg = 0;
  800c4a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c4f:	3c 2d                	cmp    $0x2d,%al
  800c51:	74 2b                	je     800c7e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c53:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c59:	75 0f                	jne    800c6a <strtol+0x44>
  800c5b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c5e:	74 28                	je     800c88 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c67:	0f 44 d8             	cmove  %eax,%ebx
  800c6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c72:	eb 46                	jmp    800cba <strtol+0x94>
		s++;
  800c74:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c77:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7c:	eb d5                	jmp    800c53 <strtol+0x2d>
		s++, neg = 1;
  800c7e:	83 c1 01             	add    $0x1,%ecx
  800c81:	bf 01 00 00 00       	mov    $0x1,%edi
  800c86:	eb cb                	jmp    800c53 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c88:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c8c:	74 0e                	je     800c9c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c8e:	85 db                	test   %ebx,%ebx
  800c90:	75 d8                	jne    800c6a <strtol+0x44>
		s++, base = 8;
  800c92:	83 c1 01             	add    $0x1,%ecx
  800c95:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c9a:	eb ce                	jmp    800c6a <strtol+0x44>
		s += 2, base = 16;
  800c9c:	83 c1 02             	add    $0x2,%ecx
  800c9f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ca4:	eb c4                	jmp    800c6a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ca6:	0f be d2             	movsbl %dl,%edx
  800ca9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cac:	3b 55 10             	cmp    0x10(%ebp),%edx
  800caf:	7d 3a                	jge    800ceb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cb8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cba:	0f b6 11             	movzbl (%ecx),%edx
  800cbd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc0:	89 f3                	mov    %esi,%ebx
  800cc2:	80 fb 09             	cmp    $0x9,%bl
  800cc5:	76 df                	jbe    800ca6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800cc7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cca:	89 f3                	mov    %esi,%ebx
  800ccc:	80 fb 19             	cmp    $0x19,%bl
  800ccf:	77 08                	ja     800cd9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800cd1:	0f be d2             	movsbl %dl,%edx
  800cd4:	83 ea 57             	sub    $0x57,%edx
  800cd7:	eb d3                	jmp    800cac <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800cd9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cdc:	89 f3                	mov    %esi,%ebx
  800cde:	80 fb 19             	cmp    $0x19,%bl
  800ce1:	77 08                	ja     800ceb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ce3:	0f be d2             	movsbl %dl,%edx
  800ce6:	83 ea 37             	sub    $0x37,%edx
  800ce9:	eb c1                	jmp    800cac <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cef:	74 05                	je     800cf6 <strtol+0xd0>
		*endptr = (char *) s;
  800cf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cf4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cf6:	89 c2                	mov    %eax,%edx
  800cf8:	f7 da                	neg    %edx
  800cfa:	85 ff                	test   %edi,%edi
  800cfc:	0f 45 c2             	cmovne %edx,%eax
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d04:	f3 0f 1e fb          	endbr32 
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	89 c7                	mov    %eax,%edi
  800d1d:	89 c6                	mov    %eax,%esi
  800d1f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d30:	ba 00 00 00 00       	mov    $0x0,%edx
  800d35:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3a:	89 d1                	mov    %edx,%ecx
  800d3c:	89 d3                	mov    %edx,%ebx
  800d3e:	89 d7                	mov    %edx,%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d49:	f3 0f 1e fb          	endbr32 
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d63:	89 cb                	mov    %ecx,%ebx
  800d65:	89 cf                	mov    %ecx,%edi
  800d67:	89 ce                	mov    %ecx,%esi
  800d69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6b:	85 c0                	test   %eax,%eax
  800d6d:	7f 08                	jg     800d77 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	83 ec 0c             	sub    $0xc,%esp
  800d7a:	50                   	push   %eax
  800d7b:	6a 03                	push   $0x3
  800d7d:	68 7f 2d 80 00       	push   $0x802d7f
  800d82:	6a 23                	push   $0x23
  800d84:	68 9c 2d 80 00       	push   $0x802d9c
  800d89:	e8 13 f5 ff ff       	call   8002a1 <_panic>

00800d8e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8e:	f3 0f 1e fb          	endbr32 
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d98:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9d:	b8 02 00 00 00       	mov    $0x2,%eax
  800da2:	89 d1                	mov    %edx,%ecx
  800da4:	89 d3                	mov    %edx,%ebx
  800da6:	89 d7                	mov    %edx,%edi
  800da8:	89 d6                	mov    %edx,%esi
  800daa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <sys_yield>:

void
sys_yield(void)
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dec:	b8 04 00 00 00       	mov    $0x4,%eax
  800df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df4:	89 f7                	mov    %esi,%edi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 04                	push   $0x4
  800e0a:	68 7f 2d 80 00       	push   $0x802d7f
  800e0f:	6a 23                	push   $0x23
  800e11:	68 9c 2d 80 00       	push   $0x802d9c
  800e16:	e8 86 f4 ff ff       	call   8002a1 <_panic>

00800e1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2e:	b8 05 00 00 00       	mov    $0x5,%eax
  800e33:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e36:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e39:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 05                	push   $0x5
  800e50:	68 7f 2d 80 00       	push   $0x802d7f
  800e55:	6a 23                	push   $0x23
  800e57:	68 9c 2d 80 00       	push   $0x802d9c
  800e5c:	e8 40 f4 ff ff       	call   8002a1 <_panic>

00800e61 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e61:	f3 0f 1e fb          	endbr32 
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7e:	89 df                	mov    %ebx,%edi
  800e80:	89 de                	mov    %ebx,%esi
  800e82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7f 08                	jg     800e90 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	83 ec 0c             	sub    $0xc,%esp
  800e93:	50                   	push   %eax
  800e94:	6a 06                	push   $0x6
  800e96:	68 7f 2d 80 00       	push   $0x802d7f
  800e9b:	6a 23                	push   $0x23
  800e9d:	68 9c 2d 80 00       	push   $0x802d9c
  800ea2:	e8 fa f3 ff ff       	call   8002a1 <_panic>

00800ea7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea7:	f3 0f 1e fb          	endbr32 
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 08                	push   $0x8
  800edc:	68 7f 2d 80 00       	push   $0x802d7f
  800ee1:	6a 23                	push   $0x23
  800ee3:	68 9c 2d 80 00       	push   $0x802d9c
  800ee8:	e8 b4 f3 ff ff       	call   8002a1 <_panic>

00800eed <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eed:	f3 0f 1e fb          	endbr32 
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	b8 09 00 00 00       	mov    $0x9,%eax
  800f0a:	89 df                	mov    %ebx,%edi
  800f0c:	89 de                	mov    %ebx,%esi
  800f0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	7f 08                	jg     800f1c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1c:	83 ec 0c             	sub    $0xc,%esp
  800f1f:	50                   	push   %eax
  800f20:	6a 09                	push   $0x9
  800f22:	68 7f 2d 80 00       	push   $0x802d7f
  800f27:	6a 23                	push   $0x23
  800f29:	68 9c 2d 80 00       	push   $0x802d9c
  800f2e:	e8 6e f3 ff ff       	call   8002a1 <_panic>

00800f33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7f 08                	jg     800f62 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	83 ec 0c             	sub    $0xc,%esp
  800f65:	50                   	push   %eax
  800f66:	6a 0a                	push   $0xa
  800f68:	68 7f 2d 80 00       	push   $0x802d7f
  800f6d:	6a 23                	push   $0x23
  800f6f:	68 9c 2d 80 00       	push   $0x802d9c
  800f74:	e8 28 f3 ff ff       	call   8002a1 <_panic>

00800f79 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8e:	be 00 00 00 00       	mov    $0x0,%esi
  800f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa0:	f3 0f 1e fb          	endbr32 
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fba:	89 cb                	mov    %ecx,%ebx
  800fbc:	89 cf                	mov    %ecx,%edi
  800fbe:	89 ce                	mov    %ecx,%esi
  800fc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7f 08                	jg     800fce <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	83 ec 0c             	sub    $0xc,%esp
  800fd1:	50                   	push   %eax
  800fd2:	6a 0d                	push   $0xd
  800fd4:	68 7f 2d 80 00       	push   $0x802d7f
  800fd9:	6a 23                	push   $0x23
  800fdb:	68 9c 2d 80 00       	push   $0x802d9c
  800fe0:	e8 bc f2 ff ff       	call   8002a1 <_panic>

00800fe5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fe5:	f3 0f 1e fb          	endbr32 
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fef:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ff9:	89 d1                	mov    %edx,%ecx
  800ffb:	89 d3                	mov    %edx,%ebx
  800ffd:	89 d7                	mov    %edx,%edi
  800fff:	89 d6                	mov    %edx,%esi
  801001:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801008:	f3 0f 1e fb          	endbr32 
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  801014:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  801016:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80101a:	75 11                	jne    80102d <pgfault+0x25>
  80101c:	89 f0                	mov    %esi,%eax
  80101e:	c1 e8 0c             	shr    $0xc,%eax
  801021:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801028:	f6 c4 08             	test   $0x8,%ah
  80102b:	74 7d                	je     8010aa <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  80102d:	e8 5c fd ff ff       	call   800d8e <sys_getenvid>
  801032:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  801034:	83 ec 04             	sub    $0x4,%esp
  801037:	6a 07                	push   $0x7
  801039:	68 00 f0 7f 00       	push   $0x7ff000
  80103e:	50                   	push   %eax
  80103f:	e8 90 fd ff ff       	call   800dd4 <sys_page_alloc>
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 7a                	js     8010c5 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  80104b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	68 00 10 00 00       	push   $0x1000
  801059:	56                   	push   %esi
  80105a:	68 00 f0 7f 00       	push   $0x7ff000
  80105f:	e8 e4 fa ff ff       	call   800b48 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  801064:	83 c4 08             	add    $0x8,%esp
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	e8 f3 fd ff ff       	call   800e61 <sys_page_unmap>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	85 c0                	test   %eax,%eax
  801073:	78 62                	js     8010d7 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801075:	83 ec 0c             	sub    $0xc,%esp
  801078:	6a 07                	push   $0x7
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	68 00 f0 7f 00       	push   $0x7ff000
  801081:	53                   	push   %ebx
  801082:	e8 94 fd ff ff       	call   800e1b <sys_page_map>
  801087:	83 c4 20             	add    $0x20,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 5b                	js     8010e9 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	68 00 f0 7f 00       	push   $0x7ff000
  801096:	53                   	push   %ebx
  801097:	e8 c5 fd ff ff       	call   800e61 <sys_page_unmap>
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	78 58                	js     8010fb <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  8010a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  8010aa:	e8 df fc ff ff       	call   800d8e <sys_getenvid>
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	56                   	push   %esi
  8010b3:	50                   	push   %eax
  8010b4:	68 ac 2d 80 00       	push   $0x802dac
  8010b9:	6a 16                	push   $0x16
  8010bb:	68 3a 2e 80 00       	push   $0x802e3a
  8010c0:	e8 dc f1 ff ff       	call   8002a1 <_panic>
        panic("pgfault: page allocation failed %e", r);
  8010c5:	50                   	push   %eax
  8010c6:	68 f4 2d 80 00       	push   $0x802df4
  8010cb:	6a 1f                	push   $0x1f
  8010cd:	68 3a 2e 80 00       	push   $0x802e3a
  8010d2:	e8 ca f1 ff ff       	call   8002a1 <_panic>
        panic("pgfault: page unmap failed %e", r);
  8010d7:	50                   	push   %eax
  8010d8:	68 45 2e 80 00       	push   $0x802e45
  8010dd:	6a 24                	push   $0x24
  8010df:	68 3a 2e 80 00       	push   $0x802e3a
  8010e4:	e8 b8 f1 ff ff       	call   8002a1 <_panic>
        panic("pgfault: page map failed %e", r);
  8010e9:	50                   	push   %eax
  8010ea:	68 63 2e 80 00       	push   $0x802e63
  8010ef:	6a 26                	push   $0x26
  8010f1:	68 3a 2e 80 00       	push   $0x802e3a
  8010f6:	e8 a6 f1 ff ff       	call   8002a1 <_panic>
        panic("pgfault: page unmap failed %e", r);
  8010fb:	50                   	push   %eax
  8010fc:	68 45 2e 80 00       	push   $0x802e45
  801101:	6a 28                	push   $0x28
  801103:	68 3a 2e 80 00       	push   $0x802e3a
  801108:	e8 94 f1 ff ff       	call   8002a1 <_panic>

0080110d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	53                   	push   %ebx
  801111:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  801114:	89 d3                	mov    %edx,%ebx
  801116:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  801119:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801120:	f6 c6 04             	test   $0x4,%dh
  801123:	75 62                	jne    801187 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  801125:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80112b:	0f 84 9d 00 00 00    	je     8011ce <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  801131:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801137:	8b 52 48             	mov    0x48(%edx),%edx
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	68 05 08 00 00       	push   $0x805
  801142:	53                   	push   %ebx
  801143:	50                   	push   %eax
  801144:	53                   	push   %ebx
  801145:	52                   	push   %edx
  801146:	e8 d0 fc ff ff       	call   800e1b <sys_page_map>
  80114b:	83 c4 20             	add    $0x20,%esp
  80114e:	85 c0                	test   %eax,%eax
  801150:	78 6a                	js     8011bc <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  801152:	a1 08 50 80 00       	mov    0x805008,%eax
  801157:	8b 50 48             	mov    0x48(%eax),%edx
  80115a:	8b 40 48             	mov    0x48(%eax),%eax
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 05 08 00 00       	push   $0x805
  801165:	53                   	push   %ebx
  801166:	52                   	push   %edx
  801167:	53                   	push   %ebx
  801168:	50                   	push   %eax
  801169:	e8 ad fc ff ff       	call   800e1b <sys_page_map>
  80116e:	83 c4 20             	add    $0x20,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	79 77                	jns    8011ec <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801175:	50                   	push   %eax
  801176:	68 18 2e 80 00       	push   $0x802e18
  80117b:	6a 49                	push   $0x49
  80117d:	68 3a 2e 80 00       	push   $0x802e3a
  801182:	e8 1a f1 ff ff       	call   8002a1 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801187:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80118d:	8b 49 48             	mov    0x48(%ecx),%ecx
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801199:	52                   	push   %edx
  80119a:	53                   	push   %ebx
  80119b:	50                   	push   %eax
  80119c:	53                   	push   %ebx
  80119d:	51                   	push   %ecx
  80119e:	e8 78 fc ff ff       	call   800e1b <sys_page_map>
  8011a3:	83 c4 20             	add    $0x20,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	79 42                	jns    8011ec <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8011aa:	50                   	push   %eax
  8011ab:	68 18 2e 80 00       	push   $0x802e18
  8011b0:	6a 43                	push   $0x43
  8011b2:	68 3a 2e 80 00       	push   $0x802e3a
  8011b7:	e8 e5 f0 ff ff       	call   8002a1 <_panic>
            panic("duppage: page remapping failed %e", r);
  8011bc:	50                   	push   %eax
  8011bd:	68 18 2e 80 00       	push   $0x802e18
  8011c2:	6a 47                	push   $0x47
  8011c4:	68 3a 2e 80 00       	push   $0x802e3a
  8011c9:	e8 d3 f0 ff ff       	call   8002a1 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  8011ce:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8011d4:	8b 52 48             	mov    0x48(%edx),%edx
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	6a 05                	push   $0x5
  8011dc:	53                   	push   %ebx
  8011dd:	50                   	push   %eax
  8011de:	53                   	push   %ebx
  8011df:	52                   	push   %edx
  8011e0:	e8 36 fc ff ff       	call   800e1b <sys_page_map>
  8011e5:	83 c4 20             	add    $0x20,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	78 0a                	js     8011f6 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  8011ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  8011f6:	50                   	push   %eax
  8011f7:	68 18 2e 80 00       	push   $0x802e18
  8011fc:	6a 4c                	push   $0x4c
  8011fe:	68 3a 2e 80 00       	push   $0x802e3a
  801203:	e8 99 f0 ff ff       	call   8002a1 <_panic>

00801208 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801208:	f3 0f 1e fb          	endbr32 
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801214:	68 08 10 80 00       	push   $0x801008
  801219:	e8 2a 13 00 00       	call   802548 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80121e:	b8 07 00 00 00       	mov    $0x7,%eax
  801223:	cd 30                	int    $0x30
  801225:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 12                	js     801240 <fork+0x38>
  80122e:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801230:	74 20                	je     801252 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801232:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801239:	ba 00 00 80 00       	mov    $0x800000,%edx
  80123e:	eb 42                	jmp    801282 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801240:	50                   	push   %eax
  801241:	68 7f 2e 80 00       	push   $0x802e7f
  801246:	6a 6a                	push   $0x6a
  801248:	68 3a 2e 80 00       	push   $0x802e3a
  80124d:	e8 4f f0 ff ff       	call   8002a1 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801252:	e8 37 fb ff ff       	call   800d8e <sys_getenvid>
  801257:	25 ff 03 00 00       	and    $0x3ff,%eax
  80125c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80125f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801264:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801269:	e9 8a 00 00 00       	jmp    8012f8 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  80126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801271:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801277:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80127a:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801280:	77 32                	ja     8012b4 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801282:	89 d0                	mov    %edx,%eax
  801284:	c1 e8 16             	shr    $0x16,%eax
  801287:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128e:	a8 01                	test   $0x1,%al
  801290:	74 dc                	je     80126e <fork+0x66>
  801292:	c1 ea 0c             	shr    $0xc,%edx
  801295:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80129c:	a8 01                	test   $0x1,%al
  80129e:	74 ce                	je     80126e <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8012a0:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012a7:	a8 04                	test   $0x4,%al
  8012a9:	74 c3                	je     80126e <fork+0x66>
			duppage(envid, PGNUM(addr));
  8012ab:	89 f0                	mov    %esi,%eax
  8012ad:	e8 5b fe ff ff       	call   80110d <duppage>
  8012b2:	eb ba                	jmp    80126e <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  8012b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8012b7:	c1 ea 0c             	shr    $0xc,%edx
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	e8 4c fe ff ff       	call   80110d <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	6a 07                	push   $0x7
  8012c6:	68 00 f0 bf ee       	push   $0xeebff000
  8012cb:	53                   	push   %ebx
  8012cc:	e8 03 fb ff ff       	call   800dd4 <sys_page_alloc>
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	75 29                	jne    801301 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	68 c9 25 80 00       	push   $0x8025c9
  8012e0:	53                   	push   %ebx
  8012e1:	e8 4d fc ff ff       	call   800f33 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  8012e6:	83 c4 08             	add    $0x8,%esp
  8012e9:	6a 02                	push   $0x2
  8012eb:	53                   	push   %ebx
  8012ec:	e8 b6 fb ff ff       	call   800ea7 <sys_env_set_status>
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	75 1b                	jne    801313 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  8012f8:	89 d8                	mov    %ebx,%eax
  8012fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5e                   	pop    %esi
  8012ff:	5d                   	pop    %ebp
  801300:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801301:	50                   	push   %eax
  801302:	68 8e 2e 80 00       	push   $0x802e8e
  801307:	6a 7b                	push   $0x7b
  801309:	68 3a 2e 80 00       	push   $0x802e3a
  80130e:	e8 8e ef ff ff       	call   8002a1 <_panic>
		panic("sys_env_set_status:%e", r);
  801313:	50                   	push   %eax
  801314:	68 a0 2e 80 00       	push   $0x802ea0
  801319:	68 81 00 00 00       	push   $0x81
  80131e:	68 3a 2e 80 00       	push   $0x802e3a
  801323:	e8 79 ef ff ff       	call   8002a1 <_panic>

00801328 <sfork>:

// Challenge!
int
sfork(void)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801332:	68 b6 2e 80 00       	push   $0x802eb6
  801337:	68 8b 00 00 00       	push   $0x8b
  80133c:	68 3a 2e 80 00       	push   $0x802e3a
  801341:	e8 5b ef ff ff       	call   8002a1 <_panic>

00801346 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801346:	f3 0f 1e fb          	endbr32 
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	05 00 00 00 30       	add    $0x30000000,%eax
  801355:	c1 e8 0c             	shr    $0xc,%eax
}
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80135a:	f3 0f 1e fb          	endbr32 
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801369:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801375:	f3 0f 1e fb          	endbr32 
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801381:	89 c2                	mov    %eax,%edx
  801383:	c1 ea 16             	shr    $0x16,%edx
  801386:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138d:	f6 c2 01             	test   $0x1,%dl
  801390:	74 2d                	je     8013bf <fd_alloc+0x4a>
  801392:	89 c2                	mov    %eax,%edx
  801394:	c1 ea 0c             	shr    $0xc,%edx
  801397:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139e:	f6 c2 01             	test   $0x1,%dl
  8013a1:	74 1c                	je     8013bf <fd_alloc+0x4a>
  8013a3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013a8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013ad:	75 d2                	jne    801381 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013b8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8013bd:	eb 0a                	jmp    8013c9 <fd_alloc+0x54>
			*fd_store = fd;
  8013bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013d5:	83 f8 1f             	cmp    $0x1f,%eax
  8013d8:	77 30                	ja     80140a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013da:	c1 e0 0c             	shl    $0xc,%eax
  8013dd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013e2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013e8:	f6 c2 01             	test   $0x1,%dl
  8013eb:	74 24                	je     801411 <fd_lookup+0x46>
  8013ed:	89 c2                	mov    %eax,%edx
  8013ef:	c1 ea 0c             	shr    $0xc,%edx
  8013f2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f9:	f6 c2 01             	test   $0x1,%dl
  8013fc:	74 1a                	je     801418 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801401:	89 02                	mov    %eax,(%edx)
	return 0;
  801403:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    
		return -E_INVAL;
  80140a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140f:	eb f7                	jmp    801408 <fd_lookup+0x3d>
		return -E_INVAL;
  801411:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801416:	eb f0                	jmp    801408 <fd_lookup+0x3d>
  801418:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141d:	eb e9                	jmp    801408 <fd_lookup+0x3d>

0080141f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80141f:	f3 0f 1e fb          	endbr32 
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 08             	sub    $0x8,%esp
  801429:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80142c:	ba 00 00 00 00       	mov    $0x0,%edx
  801431:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801436:	39 08                	cmp    %ecx,(%eax)
  801438:	74 38                	je     801472 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80143a:	83 c2 01             	add    $0x1,%edx
  80143d:	8b 04 95 48 2f 80 00 	mov    0x802f48(,%edx,4),%eax
  801444:	85 c0                	test   %eax,%eax
  801446:	75 ee                	jne    801436 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801448:	a1 08 50 80 00       	mov    0x805008,%eax
  80144d:	8b 40 48             	mov    0x48(%eax),%eax
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	51                   	push   %ecx
  801454:	50                   	push   %eax
  801455:	68 cc 2e 80 00       	push   $0x802ecc
  80145a:	e8 29 ef ff ff       	call   800388 <cprintf>
	*dev = 0;
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    
			*dev = devtab[i];
  801472:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801475:	89 01                	mov    %eax,(%ecx)
			return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
  80147c:	eb f2                	jmp    801470 <dev_lookup+0x51>

0080147e <fd_close>:
{
  80147e:	f3 0f 1e fb          	endbr32 
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	57                   	push   %edi
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	83 ec 24             	sub    $0x24,%esp
  80148b:	8b 75 08             	mov    0x8(%ebp),%esi
  80148e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801491:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801494:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801495:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80149b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80149e:	50                   	push   %eax
  80149f:	e8 27 ff ff ff       	call   8013cb <fd_lookup>
  8014a4:	89 c3                	mov    %eax,%ebx
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 05                	js     8014b2 <fd_close+0x34>
	    || fd != fd2)
  8014ad:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014b0:	74 16                	je     8014c8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014b2:	89 f8                	mov    %edi,%eax
  8014b4:	84 c0                	test   %al,%al
  8014b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bb:	0f 44 d8             	cmove  %eax,%ebx
}
  8014be:	89 d8                	mov    %ebx,%eax
  8014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c3:	5b                   	pop    %ebx
  8014c4:	5e                   	pop    %esi
  8014c5:	5f                   	pop    %edi
  8014c6:	5d                   	pop    %ebp
  8014c7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014c8:	83 ec 08             	sub    $0x8,%esp
  8014cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8014ce:	50                   	push   %eax
  8014cf:	ff 36                	pushl  (%esi)
  8014d1:	e8 49 ff ff ff       	call   80141f <dev_lookup>
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 1a                	js     8014f9 <fd_close+0x7b>
		if (dev->dev_close)
  8014df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 0b                	je     8014f9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	56                   	push   %esi
  8014f2:	ff d0                	call   *%eax
  8014f4:	89 c3                	mov    %eax,%ebx
  8014f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	56                   	push   %esi
  8014fd:	6a 00                	push   $0x0
  8014ff:	e8 5d f9 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	eb b5                	jmp    8014be <fd_close+0x40>

00801509 <close>:

int
close(int fdnum)
{
  801509:	f3 0f 1e fb          	endbr32 
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	ff 75 08             	pushl  0x8(%ebp)
  80151a:	e8 ac fe ff ff       	call   8013cb <fd_lookup>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	79 02                	jns    801528 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    
		return fd_close(fd, 1);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	6a 01                	push   $0x1
  80152d:	ff 75 f4             	pushl  -0xc(%ebp)
  801530:	e8 49 ff ff ff       	call   80147e <fd_close>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	eb ec                	jmp    801526 <close+0x1d>

0080153a <close_all>:

void
close_all(void)
{
  80153a:	f3 0f 1e fb          	endbr32 
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	53                   	push   %ebx
  801542:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801545:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	53                   	push   %ebx
  80154e:	e8 b6 ff ff ff       	call   801509 <close>
	for (i = 0; i < MAXFD; i++)
  801553:	83 c3 01             	add    $0x1,%ebx
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	83 fb 20             	cmp    $0x20,%ebx
  80155c:	75 ec                	jne    80154a <close_all+0x10>
}
  80155e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801563:	f3 0f 1e fb          	endbr32 
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	57                   	push   %edi
  80156b:	56                   	push   %esi
  80156c:	53                   	push   %ebx
  80156d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801570:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 4f fe ff ff       	call   8013cb <fd_lookup>
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	0f 88 81 00 00 00    	js     80160a <dup+0xa7>
		return r;
	close(newfdnum);
  801589:	83 ec 0c             	sub    $0xc,%esp
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	e8 75 ff ff ff       	call   801509 <close>

	newfd = INDEX2FD(newfdnum);
  801594:	8b 75 0c             	mov    0xc(%ebp),%esi
  801597:	c1 e6 0c             	shl    $0xc,%esi
  80159a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015a0:	83 c4 04             	add    $0x4,%esp
  8015a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015a6:	e8 af fd ff ff       	call   80135a <fd2data>
  8015ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015ad:	89 34 24             	mov    %esi,(%esp)
  8015b0:	e8 a5 fd ff ff       	call   80135a <fd2data>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ba:	89 d8                	mov    %ebx,%eax
  8015bc:	c1 e8 16             	shr    $0x16,%eax
  8015bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015c6:	a8 01                	test   $0x1,%al
  8015c8:	74 11                	je     8015db <dup+0x78>
  8015ca:	89 d8                	mov    %ebx,%eax
  8015cc:	c1 e8 0c             	shr    $0xc,%eax
  8015cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015d6:	f6 c2 01             	test   $0x1,%dl
  8015d9:	75 39                	jne    801614 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	c1 e8 0c             	shr    $0xc,%eax
  8015e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015ea:	83 ec 0c             	sub    $0xc,%esp
  8015ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f2:	50                   	push   %eax
  8015f3:	56                   	push   %esi
  8015f4:	6a 00                	push   $0x0
  8015f6:	52                   	push   %edx
  8015f7:	6a 00                	push   $0x0
  8015f9:	e8 1d f8 ff ff       	call   800e1b <sys_page_map>
  8015fe:	89 c3                	mov    %eax,%ebx
  801600:	83 c4 20             	add    $0x20,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 31                	js     801638 <dup+0xd5>
		goto err;

	return newfdnum;
  801607:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80160a:	89 d8                	mov    %ebx,%eax
  80160c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5f                   	pop    %edi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801614:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	25 07 0e 00 00       	and    $0xe07,%eax
  801623:	50                   	push   %eax
  801624:	57                   	push   %edi
  801625:	6a 00                	push   $0x0
  801627:	53                   	push   %ebx
  801628:	6a 00                	push   $0x0
  80162a:	e8 ec f7 ff ff       	call   800e1b <sys_page_map>
  80162f:	89 c3                	mov    %eax,%ebx
  801631:	83 c4 20             	add    $0x20,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	79 a3                	jns    8015db <dup+0x78>
	sys_page_unmap(0, newfd);
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	56                   	push   %esi
  80163c:	6a 00                	push   $0x0
  80163e:	e8 1e f8 ff ff       	call   800e61 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801643:	83 c4 08             	add    $0x8,%esp
  801646:	57                   	push   %edi
  801647:	6a 00                	push   $0x0
  801649:	e8 13 f8 ff ff       	call   800e61 <sys_page_unmap>
	return r;
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	eb b7                	jmp    80160a <dup+0xa7>

00801653 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801653:	f3 0f 1e fb          	endbr32 
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	53                   	push   %ebx
  80165b:	83 ec 1c             	sub    $0x1c,%esp
  80165e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	53                   	push   %ebx
  801666:	e8 60 fd ff ff       	call   8013cb <fd_lookup>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3f                	js     8016b1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	ff 30                	pushl  (%eax)
  80167e:	e8 9c fd ff ff       	call   80141f <dev_lookup>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 27                	js     8016b1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	8b 42 08             	mov    0x8(%edx),%eax
  801690:	83 e0 03             	and    $0x3,%eax
  801693:	83 f8 01             	cmp    $0x1,%eax
  801696:	74 1e                	je     8016b6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	8b 40 08             	mov    0x8(%eax),%eax
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	74 35                	je     8016d7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	ff 75 10             	pushl  0x10(%ebp)
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	52                   	push   %edx
  8016ac:	ff d0                	call   *%eax
  8016ae:	83 c4 10             	add    $0x10,%esp
}
  8016b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b6:	a1 08 50 80 00       	mov    0x805008,%eax
  8016bb:	8b 40 48             	mov    0x48(%eax),%eax
  8016be:	83 ec 04             	sub    $0x4,%esp
  8016c1:	53                   	push   %ebx
  8016c2:	50                   	push   %eax
  8016c3:	68 0d 2f 80 00       	push   $0x802f0d
  8016c8:	e8 bb ec ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d5:	eb da                	jmp    8016b1 <read+0x5e>
		return -E_NOT_SUPP;
  8016d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016dc:	eb d3                	jmp    8016b1 <read+0x5e>

008016de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016de:	f3 0f 1e fb          	endbr32 
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	57                   	push   %edi
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 0c             	sub    $0xc,%esp
  8016eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f6:	eb 02                	jmp    8016fa <readn+0x1c>
  8016f8:	01 c3                	add    %eax,%ebx
  8016fa:	39 f3                	cmp    %esi,%ebx
  8016fc:	73 21                	jae    80171f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	89 f0                	mov    %esi,%eax
  801703:	29 d8                	sub    %ebx,%eax
  801705:	50                   	push   %eax
  801706:	89 d8                	mov    %ebx,%eax
  801708:	03 45 0c             	add    0xc(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	57                   	push   %edi
  80170d:	e8 41 ff ff ff       	call   801653 <read>
		if (m < 0)
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	85 c0                	test   %eax,%eax
  801717:	78 04                	js     80171d <readn+0x3f>
			return m;
		if (m == 0)
  801719:	75 dd                	jne    8016f8 <readn+0x1a>
  80171b:	eb 02                	jmp    80171f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80171d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80171f:	89 d8                	mov    %ebx,%eax
  801721:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801729:	f3 0f 1e fb          	endbr32 
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
  801731:	83 ec 1c             	sub    $0x1c,%esp
  801734:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801737:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	53                   	push   %ebx
  80173c:	e8 8a fc ff ff       	call   8013cb <fd_lookup>
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	85 c0                	test   %eax,%eax
  801746:	78 3a                	js     801782 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174e:	50                   	push   %eax
  80174f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801752:	ff 30                	pushl  (%eax)
  801754:	e8 c6 fc ff ff       	call   80141f <dev_lookup>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 22                	js     801782 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801767:	74 1e                	je     801787 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176c:	8b 52 0c             	mov    0xc(%edx),%edx
  80176f:	85 d2                	test   %edx,%edx
  801771:	74 35                	je     8017a8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	ff 75 10             	pushl  0x10(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	50                   	push   %eax
  80177d:	ff d2                	call   *%edx
  80177f:	83 c4 10             	add    $0x10,%esp
}
  801782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801785:	c9                   	leave  
  801786:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801787:	a1 08 50 80 00       	mov    0x805008,%eax
  80178c:	8b 40 48             	mov    0x48(%eax),%eax
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	53                   	push   %ebx
  801793:	50                   	push   %eax
  801794:	68 29 2f 80 00       	push   $0x802f29
  801799:	e8 ea eb ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a6:	eb da                	jmp    801782 <write+0x59>
		return -E_NOT_SUPP;
  8017a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ad:	eb d3                	jmp    801782 <write+0x59>

008017af <seek>:

int
seek(int fdnum, off_t offset)
{
  8017af:	f3 0f 1e fb          	endbr32 
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bc:	50                   	push   %eax
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	e8 06 fc ff ff       	call   8013cb <fd_lookup>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	78 0e                	js     8017da <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 1c             	sub    $0x1c,%esp
  8017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ed:	50                   	push   %eax
  8017ee:	53                   	push   %ebx
  8017ef:	e8 d7 fb ff ff       	call   8013cb <fd_lookup>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 37                	js     801832 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	ff 30                	pushl  (%eax)
  801807:	e8 13 fc ff ff       	call   80141f <dev_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 1f                	js     801832 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181a:	74 1b                	je     801837 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80181c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181f:	8b 52 18             	mov    0x18(%edx),%edx
  801822:	85 d2                	test   %edx,%edx
  801824:	74 32                	je     801858 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	50                   	push   %eax
  80182d:	ff d2                	call   *%edx
  80182f:	83 c4 10             	add    $0x10,%esp
}
  801832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801835:	c9                   	leave  
  801836:	c3                   	ret    
			thisenv->env_id, fdnum);
  801837:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80183c:	8b 40 48             	mov    0x48(%eax),%eax
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	53                   	push   %ebx
  801843:	50                   	push   %eax
  801844:	68 ec 2e 80 00       	push   $0x802eec
  801849:	e8 3a eb ff ff       	call   800388 <cprintf>
		return -E_INVAL;
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801856:	eb da                	jmp    801832 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801858:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80185d:	eb d3                	jmp    801832 <ftruncate+0x56>

0080185f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80185f:	f3 0f 1e fb          	endbr32 
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 1c             	sub    $0x1c,%esp
  80186a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801870:	50                   	push   %eax
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 52 fb ff ff       	call   8013cb <fd_lookup>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 4b                	js     8018cb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801880:	83 ec 08             	sub    $0x8,%esp
  801883:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801886:	50                   	push   %eax
  801887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188a:	ff 30                	pushl  (%eax)
  80188c:	e8 8e fb ff ff       	call   80141f <dev_lookup>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 33                	js     8018cb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80189f:	74 2f                	je     8018d0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018a1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ab:	00 00 00 
	stat->st_isdir = 0;
  8018ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018b5:	00 00 00 
	stat->st_dev = dev;
  8018b8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018be:	83 ec 08             	sub    $0x8,%esp
  8018c1:	53                   	push   %ebx
  8018c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018c5:	ff 50 14             	call   *0x14(%eax)
  8018c8:	83 c4 10             	add    $0x10,%esp
}
  8018cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d5:	eb f4                	jmp    8018cb <fstat+0x6c>

008018d7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018d7:	f3 0f 1e fb          	endbr32 
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	56                   	push   %esi
  8018df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018e0:	83 ec 08             	sub    $0x8,%esp
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	e8 fb 01 00 00       	call   801ae8 <open>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	78 1b                	js     801911 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	50                   	push   %eax
  8018fd:	e8 5d ff ff ff       	call   80185f <fstat>
  801902:	89 c6                	mov    %eax,%esi
	close(fd);
  801904:	89 1c 24             	mov    %ebx,(%esp)
  801907:	e8 fd fb ff ff       	call   801509 <close>
	return r;
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	89 f3                	mov    %esi,%ebx
}
  801911:	89 d8                	mov    %ebx,%eax
  801913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	56                   	push   %esi
  80191e:	53                   	push   %ebx
  80191f:	89 c6                	mov    %eax,%esi
  801921:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801923:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80192a:	74 27                	je     801953 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80192c:	6a 07                	push   $0x7
  80192e:	68 00 60 80 00       	push   $0x806000
  801933:	56                   	push   %esi
  801934:	ff 35 00 50 80 00    	pushl  0x805000
  80193a:	e8 22 0d 00 00       	call   802661 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80193f:	83 c4 0c             	add    $0xc,%esp
  801942:	6a 00                	push   $0x0
  801944:	53                   	push   %ebx
  801945:	6a 00                	push   $0x0
  801947:	e8 a1 0c 00 00       	call   8025ed <ipc_recv>
}
  80194c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194f:	5b                   	pop    %ebx
  801950:	5e                   	pop    %esi
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	6a 01                	push   $0x1
  801958:	e8 5c 0d 00 00       	call   8026b9 <ipc_find_env>
  80195d:	a3 00 50 80 00       	mov    %eax,0x805000
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	eb c5                	jmp    80192c <fsipc+0x12>

00801967 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	8b 40 0c             	mov    0xc(%eax),%eax
  801977:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801984:	ba 00 00 00 00       	mov    $0x0,%edx
  801989:	b8 02 00 00 00       	mov    $0x2,%eax
  80198e:	e8 87 ff ff ff       	call   80191a <fsipc>
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <devfile_flush>:
{
  801995:	f3 0f 1e fb          	endbr32 
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019af:	b8 06 00 00 00       	mov    $0x6,%eax
  8019b4:	e8 61 ff ff ff       	call   80191a <fsipc>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <devfile_stat>:
{
  8019bb:	f3 0f 1e fb          	endbr32 
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	53                   	push   %ebx
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cf:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8019de:	e8 37 ff ff ff       	call   80191a <fsipc>
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 2c                	js     801a13 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019e7:	83 ec 08             	sub    $0x8,%esp
  8019ea:	68 00 60 80 00       	push   $0x806000
  8019ef:	53                   	push   %ebx
  8019f0:	e8 9d ef ff ff       	call   800992 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019f5:	a1 80 60 80 00       	mov    0x806080,%eax
  8019fa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a00:	a1 84 60 80 00       	mov    0x806084,%eax
  801a05:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <devfile_write>:
{
  801a18:	f3 0f 1e fb          	endbr32 
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 0c             	sub    $0xc,%esp
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a25:	8b 55 08             	mov    0x8(%ebp),%edx
  801a28:	8b 52 0c             	mov    0xc(%edx),%edx
  801a2b:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801a31:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a36:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a3b:	0f 47 c2             	cmova  %edx,%eax
  801a3e:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a43:	50                   	push   %eax
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	68 08 60 80 00       	push   $0x806008
  801a4c:	e8 f7 f0 ff ff       	call   800b48 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	b8 04 00 00 00       	mov    $0x4,%eax
  801a5b:	e8 ba fe ff ff       	call   80191a <fsipc>
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <devfile_read>:
{
  801a62:	f3 0f 1e fb          	endbr32 
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	56                   	push   %esi
  801a6a:	53                   	push   %ebx
  801a6b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8b 40 0c             	mov    0xc(%eax),%eax
  801a74:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a79:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a84:	b8 03 00 00 00       	mov    $0x3,%eax
  801a89:	e8 8c fe ff ff       	call   80191a <fsipc>
  801a8e:	89 c3                	mov    %eax,%ebx
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 1f                	js     801ab3 <devfile_read+0x51>
	assert(r <= n);
  801a94:	39 f0                	cmp    %esi,%eax
  801a96:	77 24                	ja     801abc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a98:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a9d:	7f 33                	jg     801ad2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	50                   	push   %eax
  801aa3:	68 00 60 80 00       	push   $0x806000
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	e8 98 f0 ff ff       	call   800b48 <memmove>
	return r;
  801ab0:	83 c4 10             	add    $0x10,%esp
}
  801ab3:	89 d8                	mov    %ebx,%eax
  801ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab8:	5b                   	pop    %ebx
  801ab9:	5e                   	pop    %esi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
	assert(r <= n);
  801abc:	68 5c 2f 80 00       	push   $0x802f5c
  801ac1:	68 63 2f 80 00       	push   $0x802f63
  801ac6:	6a 7c                	push   $0x7c
  801ac8:	68 78 2f 80 00       	push   $0x802f78
  801acd:	e8 cf e7 ff ff       	call   8002a1 <_panic>
	assert(r <= PGSIZE);
  801ad2:	68 83 2f 80 00       	push   $0x802f83
  801ad7:	68 63 2f 80 00       	push   $0x802f63
  801adc:	6a 7d                	push   $0x7d
  801ade:	68 78 2f 80 00       	push   $0x802f78
  801ae3:	e8 b9 e7 ff ff       	call   8002a1 <_panic>

00801ae8 <open>:
{
  801ae8:	f3 0f 1e fb          	endbr32 
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	83 ec 1c             	sub    $0x1c,%esp
  801af4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801af7:	56                   	push   %esi
  801af8:	e8 52 ee ff ff       	call   80094f <strlen>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b05:	7f 6c                	jg     801b73 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0d:	50                   	push   %eax
  801b0e:	e8 62 f8 ff ff       	call   801375 <fd_alloc>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 3c                	js     801b58 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	56                   	push   %esi
  801b20:	68 00 60 80 00       	push   $0x806000
  801b25:	e8 68 ee ff ff       	call   800992 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b35:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3a:	e8 db fd ff ff       	call   80191a <fsipc>
  801b3f:	89 c3                	mov    %eax,%ebx
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 19                	js     801b61 <open+0x79>
	return fd2num(fd);
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4e:	e8 f3 f7 ff ff       	call   801346 <fd2num>
  801b53:	89 c3                	mov    %eax,%ebx
  801b55:	83 c4 10             	add    $0x10,%esp
}
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
		fd_close(fd, 0);
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	6a 00                	push   $0x0
  801b66:	ff 75 f4             	pushl  -0xc(%ebp)
  801b69:	e8 10 f9 ff ff       	call   80147e <fd_close>
		return r;
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	eb e5                	jmp    801b58 <open+0x70>
		return -E_BAD_PATH;
  801b73:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b78:	eb de                	jmp    801b58 <open+0x70>

00801b7a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b7a:	f3 0f 1e fb          	endbr32 
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	b8 08 00 00 00       	mov    $0x8,%eax
  801b8e:	e8 87 fd ff ff       	call   80191a <fsipc>
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b95:	f3 0f 1e fb          	endbr32 
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b9f:	68 8f 2f 80 00       	push   $0x802f8f
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	e8 e6 ed ff ff       	call   800992 <strcpy>
	return 0;
}
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <devsock_close>:
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	53                   	push   %ebx
  801bbb:	83 ec 10             	sub    $0x10,%esp
  801bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bc1:	53                   	push   %ebx
  801bc2:	e8 2f 0b 00 00       	call   8026f6 <pageref>
  801bc7:	89 c2                	mov    %eax,%edx
  801bc9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bd1:	83 fa 01             	cmp    $0x1,%edx
  801bd4:	74 05                	je     801bdb <devsock_close+0x28>
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bdb:	83 ec 0c             	sub    $0xc,%esp
  801bde:	ff 73 0c             	pushl  0xc(%ebx)
  801be1:	e8 e3 02 00 00       	call   801ec9 <nsipc_close>
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	eb eb                	jmp    801bd6 <devsock_close+0x23>

00801beb <devsock_write>:
{
  801beb:	f3 0f 1e fb          	endbr32 
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	ff 75 10             	pushl  0x10(%ebp)
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	ff 70 0c             	pushl  0xc(%eax)
  801c03:	e8 b5 03 00 00       	call   801fbd <nsipc_send>
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <devsock_read>:
{
  801c0a:	f3 0f 1e fb          	endbr32 
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 10             	pushl  0x10(%ebp)
  801c19:	ff 75 0c             	pushl  0xc(%ebp)
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	ff 70 0c             	pushl  0xc(%eax)
  801c22:	e8 1f 03 00 00       	call   801f46 <nsipc_recv>
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <fd2sockid>:
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c32:	52                   	push   %edx
  801c33:	50                   	push   %eax
  801c34:	e8 92 f7 ff ff       	call   8013cb <fd_lookup>
  801c39:	83 c4 10             	add    $0x10,%esp
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 10                	js     801c50 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801c49:	39 08                	cmp    %ecx,(%eax)
  801c4b:	75 05                	jne    801c52 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c4d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    
		return -E_NOT_SUPP;
  801c52:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c57:	eb f7                	jmp    801c50 <fd2sockid+0x27>

00801c59 <alloc_sockfd>:
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	56                   	push   %esi
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 1c             	sub    $0x1c,%esp
  801c61:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c66:	50                   	push   %eax
  801c67:	e8 09 f7 ff ff       	call   801375 <fd_alloc>
  801c6c:	89 c3                	mov    %eax,%ebx
  801c6e:	83 c4 10             	add    $0x10,%esp
  801c71:	85 c0                	test   %eax,%eax
  801c73:	78 43                	js     801cb8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	68 07 04 00 00       	push   $0x407
  801c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c80:	6a 00                	push   $0x0
  801c82:	e8 4d f1 ff ff       	call   800dd4 <sys_page_alloc>
  801c87:	89 c3                	mov    %eax,%ebx
  801c89:	83 c4 10             	add    $0x10,%esp
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	78 28                	js     801cb8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c93:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c99:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ca5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	50                   	push   %eax
  801cac:	e8 95 f6 ff ff       	call   801346 <fd2num>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	eb 0c                	jmp    801cc4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	56                   	push   %esi
  801cbc:	e8 08 02 00 00       	call   801ec9 <nsipc_close>
		return r;
  801cc1:	83 c4 10             	add    $0x10,%esp
}
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    

00801ccd <accept>:
{
  801ccd:	f3 0f 1e fb          	endbr32 
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	e8 4a ff ff ff       	call   801c29 <fd2sockid>
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 1b                	js     801cfe <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	50                   	push   %eax
  801ced:	e8 22 01 00 00       	call   801e14 <nsipc_accept>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 05                	js     801cfe <accept+0x31>
	return alloc_sockfd(r);
  801cf9:	e8 5b ff ff ff       	call   801c59 <alloc_sockfd>
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <bind>:
{
  801d00:	f3 0f 1e fb          	endbr32 
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	e8 17 ff ff ff       	call   801c29 <fd2sockid>
  801d12:	85 c0                	test   %eax,%eax
  801d14:	78 12                	js     801d28 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	ff 75 10             	pushl  0x10(%ebp)
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	50                   	push   %eax
  801d20:	e8 45 01 00 00       	call   801e6a <nsipc_bind>
  801d25:	83 c4 10             	add    $0x10,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <shutdown>:
{
  801d2a:	f3 0f 1e fb          	endbr32 
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	e8 ed fe ff ff       	call   801c29 <fd2sockid>
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 0f                	js     801d4f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	50                   	push   %eax
  801d47:	e8 57 01 00 00       	call   801ea3 <nsipc_shutdown>
  801d4c:	83 c4 10             	add    $0x10,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <connect>:
{
  801d51:	f3 0f 1e fb          	endbr32 
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	e8 c6 fe ff ff       	call   801c29 <fd2sockid>
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 12                	js     801d79 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	ff 75 10             	pushl  0x10(%ebp)
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	50                   	push   %eax
  801d71:	e8 71 01 00 00       	call   801ee7 <nsipc_connect>
  801d76:	83 c4 10             	add    $0x10,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <listen>:
{
  801d7b:	f3 0f 1e fb          	endbr32 
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	e8 9c fe ff ff       	call   801c29 <fd2sockid>
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 0f                	js     801da0 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d91:	83 ec 08             	sub    $0x8,%esp
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	50                   	push   %eax
  801d98:	e8 83 01 00 00       	call   801f20 <nsipc_listen>
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801da2:	f3 0f 1e fb          	endbr32 
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	e8 65 02 00 00       	call   80201f <nsipc_socket>
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 05                	js     801dc6 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801dc1:	e8 93 fe ff ff       	call   801c59 <alloc_sockfd>
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	53                   	push   %ebx
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dd1:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801dd8:	74 26                	je     801e00 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dda:	6a 07                	push   $0x7
  801ddc:	68 00 70 80 00       	push   $0x807000
  801de1:	53                   	push   %ebx
  801de2:	ff 35 04 50 80 00    	pushl  0x805004
  801de8:	e8 74 08 00 00       	call   802661 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ded:	83 c4 0c             	add    $0xc,%esp
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	e8 f2 07 00 00       	call   8025ed <ipc_recv>
}
  801dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	6a 02                	push   $0x2
  801e05:	e8 af 08 00 00       	call   8026b9 <ipc_find_env>
  801e0a:	a3 04 50 80 00       	mov    %eax,0x805004
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	eb c6                	jmp    801dda <nsipc+0x12>

00801e14 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e14:	f3 0f 1e fb          	endbr32 
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e28:	8b 06                	mov    (%esi),%eax
  801e2a:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e34:	e8 8f ff ff ff       	call   801dc8 <nsipc>
  801e39:	89 c3                	mov    %eax,%ebx
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	79 09                	jns    801e48 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e3f:	89 d8                	mov    %ebx,%eax
  801e41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e44:	5b                   	pop    %ebx
  801e45:	5e                   	pop    %esi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	ff 35 10 70 80 00    	pushl  0x807010
  801e51:	68 00 70 80 00       	push   $0x807000
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	e8 ea ec ff ff       	call   800b48 <memmove>
		*addrlen = ret->ret_addrlen;
  801e5e:	a1 10 70 80 00       	mov    0x807010,%eax
  801e63:	89 06                	mov    %eax,(%esi)
  801e65:	83 c4 10             	add    $0x10,%esp
	return r;
  801e68:	eb d5                	jmp    801e3f <nsipc_accept+0x2b>

00801e6a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e6a:	f3 0f 1e fb          	endbr32 
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	53                   	push   %ebx
  801e72:	83 ec 08             	sub    $0x8,%esp
  801e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e80:	53                   	push   %ebx
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	68 04 70 80 00       	push   $0x807004
  801e89:	e8 ba ec ff ff       	call   800b48 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e8e:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e94:	b8 02 00 00 00       	mov    $0x2,%eax
  801e99:	e8 2a ff ff ff       	call   801dc8 <nsipc>
}
  801e9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ea3:	f3 0f 1e fb          	endbr32 
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801ebd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec2:	e8 01 ff ff ff       	call   801dc8 <nsipc>
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <nsipc_close>:

int
nsipc_close(int s)
{
  801ec9:	f3 0f 1e fb          	endbr32 
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801edb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ee0:	e8 e3 fe ff ff       	call   801dc8 <nsipc>
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ee7:	f3 0f 1e fb          	endbr32 
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	53                   	push   %ebx
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801efd:	53                   	push   %ebx
  801efe:	ff 75 0c             	pushl  0xc(%ebp)
  801f01:	68 04 70 80 00       	push   $0x807004
  801f06:	e8 3d ec ff ff       	call   800b48 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f0b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f11:	b8 05 00 00 00       	mov    $0x5,%eax
  801f16:	e8 ad fe ff ff       	call   801dc8 <nsipc>
}
  801f1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f20:	f3 0f 1e fb          	endbr32 
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f35:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f3a:	b8 06 00 00 00       	mov    $0x6,%eax
  801f3f:	e8 84 fe ff ff       	call   801dc8 <nsipc>
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f46:	f3 0f 1e fb          	endbr32 
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
  801f4f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801f5a:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801f60:	8b 45 14             	mov    0x14(%ebp),%eax
  801f63:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f68:	b8 07 00 00 00       	mov    $0x7,%eax
  801f6d:	e8 56 fe ff ff       	call   801dc8 <nsipc>
  801f72:	89 c3                	mov    %eax,%ebx
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 26                	js     801f9e <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f78:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f7e:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f83:	0f 4e c6             	cmovle %esi,%eax
  801f86:	39 c3                	cmp    %eax,%ebx
  801f88:	7f 1d                	jg     801fa7 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f8a:	83 ec 04             	sub    $0x4,%esp
  801f8d:	53                   	push   %ebx
  801f8e:	68 00 70 80 00       	push   $0x807000
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	e8 ad eb ff ff       	call   800b48 <memmove>
  801f9b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f9e:	89 d8                	mov    %ebx,%eax
  801fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa3:	5b                   	pop    %ebx
  801fa4:	5e                   	pop    %esi
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fa7:	68 9b 2f 80 00       	push   $0x802f9b
  801fac:	68 63 2f 80 00       	push   $0x802f63
  801fb1:	6a 62                	push   $0x62
  801fb3:	68 b0 2f 80 00       	push   $0x802fb0
  801fb8:	e8 e4 e2 ff ff       	call   8002a1 <_panic>

00801fbd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801fd3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fd9:	7f 2e                	jg     802009 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	53                   	push   %ebx
  801fdf:	ff 75 0c             	pushl  0xc(%ebp)
  801fe2:	68 0c 70 80 00       	push   $0x80700c
  801fe7:	e8 5c eb ff ff       	call   800b48 <memmove>
	nsipcbuf.send.req_size = size;
  801fec:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff5:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801ffa:	b8 08 00 00 00       	mov    $0x8,%eax
  801fff:	e8 c4 fd ff ff       	call   801dc8 <nsipc>
}
  802004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802007:	c9                   	leave  
  802008:	c3                   	ret    
	assert(size < 1600);
  802009:	68 bc 2f 80 00       	push   $0x802fbc
  80200e:	68 63 2f 80 00       	push   $0x802f63
  802013:	6a 6d                	push   $0x6d
  802015:	68 b0 2f 80 00       	push   $0x802fb0
  80201a:	e8 82 e2 ff ff       	call   8002a1 <_panic>

0080201f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80201f:	f3 0f 1e fb          	endbr32 
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802039:	8b 45 10             	mov    0x10(%ebp),%eax
  80203c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802041:	b8 09 00 00 00       	mov    $0x9,%eax
  802046:	e8 7d fd ff ff       	call   801dc8 <nsipc>
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80204d:	f3 0f 1e fb          	endbr32 
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	56                   	push   %esi
  802055:	53                   	push   %ebx
  802056:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802059:	83 ec 0c             	sub    $0xc,%esp
  80205c:	ff 75 08             	pushl  0x8(%ebp)
  80205f:	e8 f6 f2 ff ff       	call   80135a <fd2data>
  802064:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802066:	83 c4 08             	add    $0x8,%esp
  802069:	68 c8 2f 80 00       	push   $0x802fc8
  80206e:	53                   	push   %ebx
  80206f:	e8 1e e9 ff ff       	call   800992 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802074:	8b 46 04             	mov    0x4(%esi),%eax
  802077:	2b 06                	sub    (%esi),%eax
  802079:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80207f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802086:	00 00 00 
	stat->st_dev = &devpipe;
  802089:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802090:	40 80 00 
	return 0;
}
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
  802098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5e                   	pop    %esi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    

0080209f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80209f:	f3 0f 1e fb          	endbr32 
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	53                   	push   %ebx
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020ad:	53                   	push   %ebx
  8020ae:	6a 00                	push   $0x0
  8020b0:	e8 ac ed ff ff       	call   800e61 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020b5:	89 1c 24             	mov    %ebx,(%esp)
  8020b8:	e8 9d f2 ff ff       	call   80135a <fd2data>
  8020bd:	83 c4 08             	add    $0x8,%esp
  8020c0:	50                   	push   %eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 99 ed ff ff       	call   800e61 <sys_page_unmap>
}
  8020c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <_pipeisclosed>:
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	57                   	push   %edi
  8020d1:	56                   	push   %esi
  8020d2:	53                   	push   %ebx
  8020d3:	83 ec 1c             	sub    $0x1c,%esp
  8020d6:	89 c7                	mov    %eax,%edi
  8020d8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020da:	a1 08 50 80 00       	mov    0x805008,%eax
  8020df:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020e2:	83 ec 0c             	sub    $0xc,%esp
  8020e5:	57                   	push   %edi
  8020e6:	e8 0b 06 00 00       	call   8026f6 <pageref>
  8020eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020ee:	89 34 24             	mov    %esi,(%esp)
  8020f1:	e8 00 06 00 00       	call   8026f6 <pageref>
		nn = thisenv->env_runs;
  8020f6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8020fc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020ff:	83 c4 10             	add    $0x10,%esp
  802102:	39 cb                	cmp    %ecx,%ebx
  802104:	74 1b                	je     802121 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802106:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802109:	75 cf                	jne    8020da <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80210b:	8b 42 58             	mov    0x58(%edx),%eax
  80210e:	6a 01                	push   $0x1
  802110:	50                   	push   %eax
  802111:	53                   	push   %ebx
  802112:	68 cf 2f 80 00       	push   $0x802fcf
  802117:	e8 6c e2 ff ff       	call   800388 <cprintf>
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	eb b9                	jmp    8020da <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802121:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802124:	0f 94 c0             	sete   %al
  802127:	0f b6 c0             	movzbl %al,%eax
}
  80212a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80212d:	5b                   	pop    %ebx
  80212e:	5e                   	pop    %esi
  80212f:	5f                   	pop    %edi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    

00802132 <devpipe_write>:
{
  802132:	f3 0f 1e fb          	endbr32 
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	57                   	push   %edi
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	83 ec 28             	sub    $0x28,%esp
  80213f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802142:	56                   	push   %esi
  802143:	e8 12 f2 ff ff       	call   80135a <fd2data>
  802148:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	bf 00 00 00 00       	mov    $0x0,%edi
  802152:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802155:	74 4f                	je     8021a6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802157:	8b 43 04             	mov    0x4(%ebx),%eax
  80215a:	8b 0b                	mov    (%ebx),%ecx
  80215c:	8d 51 20             	lea    0x20(%ecx),%edx
  80215f:	39 d0                	cmp    %edx,%eax
  802161:	72 14                	jb     802177 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802163:	89 da                	mov    %ebx,%edx
  802165:	89 f0                	mov    %esi,%eax
  802167:	e8 61 ff ff ff       	call   8020cd <_pipeisclosed>
  80216c:	85 c0                	test   %eax,%eax
  80216e:	75 3b                	jne    8021ab <devpipe_write+0x79>
			sys_yield();
  802170:	e8 3c ec ff ff       	call   800db1 <sys_yield>
  802175:	eb e0                	jmp    802157 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80217a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80217e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802181:	89 c2                	mov    %eax,%edx
  802183:	c1 fa 1f             	sar    $0x1f,%edx
  802186:	89 d1                	mov    %edx,%ecx
  802188:	c1 e9 1b             	shr    $0x1b,%ecx
  80218b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80218e:	83 e2 1f             	and    $0x1f,%edx
  802191:	29 ca                	sub    %ecx,%edx
  802193:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802197:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80219b:	83 c0 01             	add    $0x1,%eax
  80219e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8021a1:	83 c7 01             	add    $0x1,%edi
  8021a4:	eb ac                	jmp    802152 <devpipe_write+0x20>
	return i;
  8021a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a9:	eb 05                	jmp    8021b0 <devpipe_write+0x7e>
				return 0;
  8021ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5f                   	pop    %edi
  8021b6:	5d                   	pop    %ebp
  8021b7:	c3                   	ret    

008021b8 <devpipe_read>:
{
  8021b8:	f3 0f 1e fb          	endbr32 
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	57                   	push   %edi
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 18             	sub    $0x18,%esp
  8021c5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021c8:	57                   	push   %edi
  8021c9:	e8 8c f1 ff ff       	call   80135a <fd2data>
  8021ce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	be 00 00 00 00       	mov    $0x0,%esi
  8021d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021db:	75 14                	jne    8021f1 <devpipe_read+0x39>
	return i;
  8021dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e0:	eb 02                	jmp    8021e4 <devpipe_read+0x2c>
				return i;
  8021e2:	89 f0                	mov    %esi,%eax
}
  8021e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e7:	5b                   	pop    %ebx
  8021e8:	5e                   	pop    %esi
  8021e9:	5f                   	pop    %edi
  8021ea:	5d                   	pop    %ebp
  8021eb:	c3                   	ret    
			sys_yield();
  8021ec:	e8 c0 eb ff ff       	call   800db1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021f1:	8b 03                	mov    (%ebx),%eax
  8021f3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021f6:	75 18                	jne    802210 <devpipe_read+0x58>
			if (i > 0)
  8021f8:	85 f6                	test   %esi,%esi
  8021fa:	75 e6                	jne    8021e2 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021fc:	89 da                	mov    %ebx,%edx
  8021fe:	89 f8                	mov    %edi,%eax
  802200:	e8 c8 fe ff ff       	call   8020cd <_pipeisclosed>
  802205:	85 c0                	test   %eax,%eax
  802207:	74 e3                	je     8021ec <devpipe_read+0x34>
				return 0;
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	eb d4                	jmp    8021e4 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802210:	99                   	cltd   
  802211:	c1 ea 1b             	shr    $0x1b,%edx
  802214:	01 d0                	add    %edx,%eax
  802216:	83 e0 1f             	and    $0x1f,%eax
  802219:	29 d0                	sub    %edx,%eax
  80221b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802220:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802223:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802226:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802229:	83 c6 01             	add    $0x1,%esi
  80222c:	eb aa                	jmp    8021d8 <devpipe_read+0x20>

0080222e <pipe>:
{
  80222e:	f3 0f 1e fb          	endbr32 
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	56                   	push   %esi
  802236:	53                   	push   %ebx
  802237:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80223a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223d:	50                   	push   %eax
  80223e:	e8 32 f1 ff ff       	call   801375 <fd_alloc>
  802243:	89 c3                	mov    %eax,%ebx
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	0f 88 23 01 00 00    	js     802373 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	68 07 04 00 00       	push   $0x407
  802258:	ff 75 f4             	pushl  -0xc(%ebp)
  80225b:	6a 00                	push   $0x0
  80225d:	e8 72 eb ff ff       	call   800dd4 <sys_page_alloc>
  802262:	89 c3                	mov    %eax,%ebx
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	0f 88 04 01 00 00    	js     802373 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802275:	50                   	push   %eax
  802276:	e8 fa f0 ff ff       	call   801375 <fd_alloc>
  80227b:	89 c3                	mov    %eax,%ebx
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	0f 88 db 00 00 00    	js     802363 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	68 07 04 00 00       	push   $0x407
  802290:	ff 75 f0             	pushl  -0x10(%ebp)
  802293:	6a 00                	push   $0x0
  802295:	e8 3a eb ff ff       	call   800dd4 <sys_page_alloc>
  80229a:	89 c3                	mov    %eax,%ebx
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	0f 88 bc 00 00 00    	js     802363 <pipe+0x135>
	va = fd2data(fd0);
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ad:	e8 a8 f0 ff ff       	call   80135a <fd2data>
  8022b2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b4:	83 c4 0c             	add    $0xc,%esp
  8022b7:	68 07 04 00 00       	push   $0x407
  8022bc:	50                   	push   %eax
  8022bd:	6a 00                	push   $0x0
  8022bf:	e8 10 eb ff ff       	call   800dd4 <sys_page_alloc>
  8022c4:	89 c3                	mov    %eax,%ebx
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	0f 88 82 00 00 00    	js     802353 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022d1:	83 ec 0c             	sub    $0xc,%esp
  8022d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8022d7:	e8 7e f0 ff ff       	call   80135a <fd2data>
  8022dc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022e3:	50                   	push   %eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	56                   	push   %esi
  8022e7:	6a 00                	push   $0x0
  8022e9:	e8 2d eb ff ff       	call   800e1b <sys_page_map>
  8022ee:	89 c3                	mov    %eax,%ebx
  8022f0:	83 c4 20             	add    $0x20,%esp
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	78 4e                	js     802345 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022f7:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802304:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80230b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802313:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80231a:	83 ec 0c             	sub    $0xc,%esp
  80231d:	ff 75 f4             	pushl  -0xc(%ebp)
  802320:	e8 21 f0 ff ff       	call   801346 <fd2num>
  802325:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802328:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80232a:	83 c4 04             	add    $0x4,%esp
  80232d:	ff 75 f0             	pushl  -0x10(%ebp)
  802330:	e8 11 f0 ff ff       	call   801346 <fd2num>
  802335:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802338:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80233b:	83 c4 10             	add    $0x10,%esp
  80233e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802343:	eb 2e                	jmp    802373 <pipe+0x145>
	sys_page_unmap(0, va);
  802345:	83 ec 08             	sub    $0x8,%esp
  802348:	56                   	push   %esi
  802349:	6a 00                	push   $0x0
  80234b:	e8 11 eb ff ff       	call   800e61 <sys_page_unmap>
  802350:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802353:	83 ec 08             	sub    $0x8,%esp
  802356:	ff 75 f0             	pushl  -0x10(%ebp)
  802359:	6a 00                	push   $0x0
  80235b:	e8 01 eb ff ff       	call   800e61 <sys_page_unmap>
  802360:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802363:	83 ec 08             	sub    $0x8,%esp
  802366:	ff 75 f4             	pushl  -0xc(%ebp)
  802369:	6a 00                	push   $0x0
  80236b:	e8 f1 ea ff ff       	call   800e61 <sys_page_unmap>
  802370:	83 c4 10             	add    $0x10,%esp
}
  802373:	89 d8                	mov    %ebx,%eax
  802375:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802378:	5b                   	pop    %ebx
  802379:	5e                   	pop    %esi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <pipeisclosed>:
{
  80237c:	f3 0f 1e fb          	endbr32 
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802389:	50                   	push   %eax
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	e8 39 f0 ff ff       	call   8013cb <fd_lookup>
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	85 c0                	test   %eax,%eax
  802397:	78 18                	js     8023b1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802399:	83 ec 0c             	sub    $0xc,%esp
  80239c:	ff 75 f4             	pushl  -0xc(%ebp)
  80239f:	e8 b6 ef ff ff       	call   80135a <fd2data>
  8023a4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	e8 1f fd ff ff       	call   8020cd <_pipeisclosed>
  8023ae:	83 c4 10             	add    $0x10,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023b3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bc:	c3                   	ret    

008023bd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023bd:	f3 0f 1e fb          	endbr32 
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023c7:	68 e2 2f 80 00       	push   $0x802fe2
  8023cc:	ff 75 0c             	pushl  0xc(%ebp)
  8023cf:	e8 be e5 ff ff       	call   800992 <strcpy>
	return 0;
}
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <devcons_write>:
{
  8023db:	f3 0f 1e fb          	endbr32 
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	57                   	push   %edi
  8023e3:	56                   	push   %esi
  8023e4:	53                   	push   %ebx
  8023e5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023eb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023f0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023f6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f9:	73 31                	jae    80242c <devcons_write+0x51>
		m = n - tot;
  8023fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023fe:	29 f3                	sub    %esi,%ebx
  802400:	83 fb 7f             	cmp    $0x7f,%ebx
  802403:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802408:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	53                   	push   %ebx
  80240f:	89 f0                	mov    %esi,%eax
  802411:	03 45 0c             	add    0xc(%ebp),%eax
  802414:	50                   	push   %eax
  802415:	57                   	push   %edi
  802416:	e8 2d e7 ff ff       	call   800b48 <memmove>
		sys_cputs(buf, m);
  80241b:	83 c4 08             	add    $0x8,%esp
  80241e:	53                   	push   %ebx
  80241f:	57                   	push   %edi
  802420:	e8 df e8 ff ff       	call   800d04 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802425:	01 de                	add    %ebx,%esi
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	eb ca                	jmp    8023f6 <devcons_write+0x1b>
}
  80242c:	89 f0                	mov    %esi,%eax
  80242e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <devcons_read>:
{
  802436:	f3 0f 1e fb          	endbr32 
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 08             	sub    $0x8,%esp
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802445:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802449:	74 21                	je     80246c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80244b:	e8 d6 e8 ff ff       	call   800d26 <sys_cgetc>
  802450:	85 c0                	test   %eax,%eax
  802452:	75 07                	jne    80245b <devcons_read+0x25>
		sys_yield();
  802454:	e8 58 e9 ff ff       	call   800db1 <sys_yield>
  802459:	eb f0                	jmp    80244b <devcons_read+0x15>
	if (c < 0)
  80245b:	78 0f                	js     80246c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80245d:	83 f8 04             	cmp    $0x4,%eax
  802460:	74 0c                	je     80246e <devcons_read+0x38>
	*(char*)vbuf = c;
  802462:	8b 55 0c             	mov    0xc(%ebp),%edx
  802465:	88 02                	mov    %al,(%edx)
	return 1;
  802467:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80246c:	c9                   	leave  
  80246d:	c3                   	ret    
		return 0;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	eb f7                	jmp    80246c <devcons_read+0x36>

00802475 <cputchar>:
{
  802475:	f3 0f 1e fb          	endbr32 
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802485:	6a 01                	push   $0x1
  802487:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80248a:	50                   	push   %eax
  80248b:	e8 74 e8 ff ff       	call   800d04 <sys_cputs>
}
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <getchar>:
{
  802495:	f3 0f 1e fb          	endbr32 
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80249f:	6a 01                	push   $0x1
  8024a1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024a4:	50                   	push   %eax
  8024a5:	6a 00                	push   $0x0
  8024a7:	e8 a7 f1 ff ff       	call   801653 <read>
	if (r < 0)
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	78 06                	js     8024b9 <getchar+0x24>
	if (r < 1)
  8024b3:	74 06                	je     8024bb <getchar+0x26>
	return c;
  8024b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024b9:	c9                   	leave  
  8024ba:	c3                   	ret    
		return -E_EOF;
  8024bb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024c0:	eb f7                	jmp    8024b9 <getchar+0x24>

008024c2 <iscons>:
{
  8024c2:	f3 0f 1e fb          	endbr32 
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cf:	50                   	push   %eax
  8024d0:	ff 75 08             	pushl  0x8(%ebp)
  8024d3:	e8 f3 ee ff ff       	call   8013cb <fd_lookup>
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	78 11                	js     8024f0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8024e8:	39 10                	cmp    %edx,(%eax)
  8024ea:	0f 94 c0             	sete   %al
  8024ed:	0f b6 c0             	movzbl %al,%eax
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <opencons>:
{
  8024f2:	f3 0f 1e fb          	endbr32 
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ff:	50                   	push   %eax
  802500:	e8 70 ee ff ff       	call   801375 <fd_alloc>
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	85 c0                	test   %eax,%eax
  80250a:	78 3a                	js     802546 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80250c:	83 ec 04             	sub    $0x4,%esp
  80250f:	68 07 04 00 00       	push   $0x407
  802514:	ff 75 f4             	pushl  -0xc(%ebp)
  802517:	6a 00                	push   $0x0
  802519:	e8 b6 e8 ff ff       	call   800dd4 <sys_page_alloc>
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	85 c0                	test   %eax,%eax
  802523:	78 21                	js     802546 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80252e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80253a:	83 ec 0c             	sub    $0xc,%esp
  80253d:	50                   	push   %eax
  80253e:	e8 03 ee ff ff       	call   801346 <fd2num>
  802543:	83 c4 10             	add    $0x10,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802548:	f3 0f 1e fb          	endbr32 
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802552:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802559:	74 0a                	je     802565 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802565:	a1 08 50 80 00       	mov    0x805008,%eax
  80256a:	8b 40 48             	mov    0x48(%eax),%eax
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	6a 07                	push   $0x7
  802572:	68 00 f0 bf ee       	push   $0xeebff000
  802577:	50                   	push   %eax
  802578:	e8 57 e8 ff ff       	call   800dd4 <sys_page_alloc>
  80257d:	83 c4 10             	add    $0x10,%esp
  802580:	85 c0                	test   %eax,%eax
  802582:	75 31                	jne    8025b5 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802584:	a1 08 50 80 00       	mov    0x805008,%eax
  802589:	8b 40 48             	mov    0x48(%eax),%eax
  80258c:	83 ec 08             	sub    $0x8,%esp
  80258f:	68 c9 25 80 00       	push   $0x8025c9
  802594:	50                   	push   %eax
  802595:	e8 99 e9 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
  80259a:	83 c4 10             	add    $0x10,%esp
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 ba                	je     80255b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	68 18 30 80 00       	push   $0x803018
  8025a9:	6a 24                	push   $0x24
  8025ab:	68 46 30 80 00       	push   $0x803046
  8025b0:	e8 ec dc ff ff       	call   8002a1 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  8025b5:	83 ec 04             	sub    $0x4,%esp
  8025b8:	68 f0 2f 80 00       	push   $0x802ff0
  8025bd:	6a 21                	push   $0x21
  8025bf:	68 46 30 80 00       	push   $0x803046
  8025c4:	e8 d8 dc ff ff       	call   8002a1 <_panic>

008025c9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025c9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025ca:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8025cf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025d1:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8025d4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8025d8:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8025dd:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8025e1:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8025e3:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8025e6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8025e7:	83 c4 04             	add    $0x4,%esp
    popfl
  8025ea:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8025eb:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8025ec:	c3                   	ret    

008025ed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025ed:	f3 0f 1e fb          	endbr32 
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	56                   	push   %esi
  8025f5:	53                   	push   %ebx
  8025f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8025f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8025ff:	83 e8 01             	sub    $0x1,%eax
  802602:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802607:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80260c:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	50                   	push   %eax
  802614:	e8 87 e9 ff ff       	call   800fa0 <sys_ipc_recv>
	if (!t) {
  802619:	83 c4 10             	add    $0x10,%esp
  80261c:	85 c0                	test   %eax,%eax
  80261e:	75 2b                	jne    80264b <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802620:	85 f6                	test   %esi,%esi
  802622:	74 0a                	je     80262e <ipc_recv+0x41>
  802624:	a1 08 50 80 00       	mov    0x805008,%eax
  802629:	8b 40 74             	mov    0x74(%eax),%eax
  80262c:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80262e:	85 db                	test   %ebx,%ebx
  802630:	74 0a                	je     80263c <ipc_recv+0x4f>
  802632:	a1 08 50 80 00       	mov    0x805008,%eax
  802637:	8b 40 78             	mov    0x78(%eax),%eax
  80263a:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80263c:	a1 08 50 80 00       	mov    0x805008,%eax
  802641:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802644:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802647:	5b                   	pop    %ebx
  802648:	5e                   	pop    %esi
  802649:	5d                   	pop    %ebp
  80264a:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80264b:	85 f6                	test   %esi,%esi
  80264d:	74 06                	je     802655 <ipc_recv+0x68>
  80264f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802655:	85 db                	test   %ebx,%ebx
  802657:	74 eb                	je     802644 <ipc_recv+0x57>
  802659:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80265f:	eb e3                	jmp    802644 <ipc_recv+0x57>

00802661 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802661:	f3 0f 1e fb          	endbr32 
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	57                   	push   %edi
  802669:	56                   	push   %esi
  80266a:	53                   	push   %ebx
  80266b:	83 ec 0c             	sub    $0xc,%esp
  80266e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802671:	8b 75 0c             	mov    0xc(%ebp),%esi
  802674:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802677:	85 db                	test   %ebx,%ebx
  802679:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80267e:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802681:	ff 75 14             	pushl  0x14(%ebp)
  802684:	53                   	push   %ebx
  802685:	56                   	push   %esi
  802686:	57                   	push   %edi
  802687:	e8 ed e8 ff ff       	call   800f79 <sys_ipc_try_send>
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	85 c0                	test   %eax,%eax
  802691:	74 1e                	je     8026b1 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802693:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802696:	75 07                	jne    80269f <ipc_send+0x3e>
		sys_yield();
  802698:	e8 14 e7 ff ff       	call   800db1 <sys_yield>
  80269d:	eb e2                	jmp    802681 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80269f:	50                   	push   %eax
  8026a0:	68 54 30 80 00       	push   $0x803054
  8026a5:	6a 39                	push   $0x39
  8026a7:	68 66 30 80 00       	push   $0x803066
  8026ac:	e8 f0 db ff ff       	call   8002a1 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8026b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5f                   	pop    %edi
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    

008026b9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026b9:	f3 0f 1e fb          	endbr32 
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026c8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026cb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026d1:	8b 52 50             	mov    0x50(%edx),%edx
  8026d4:	39 ca                	cmp    %ecx,%edx
  8026d6:	74 11                	je     8026e9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8026d8:	83 c0 01             	add    $0x1,%eax
  8026db:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026e0:	75 e6                	jne    8026c8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8026e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e7:	eb 0b                	jmp    8026f4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8026e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026f1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026f4:	5d                   	pop    %ebp
  8026f5:	c3                   	ret    

008026f6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026f6:	f3 0f 1e fb          	endbr32 
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802700:	89 c2                	mov    %eax,%edx
  802702:	c1 ea 16             	shr    $0x16,%edx
  802705:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802711:	f6 c1 01             	test   $0x1,%cl
  802714:	74 1c                	je     802732 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802716:	c1 e8 0c             	shr    $0xc,%eax
  802719:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802720:	a8 01                	test   $0x1,%al
  802722:	74 0e                	je     802732 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802724:	c1 e8 0c             	shr    $0xc,%eax
  802727:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80272e:	ef 
  80272f:	0f b7 d2             	movzwl %dx,%edx
}
  802732:	89 d0                	mov    %edx,%eax
  802734:	5d                   	pop    %ebp
  802735:	c3                   	ret    
  802736:	66 90                	xchg   %ax,%ax
  802738:	66 90                	xchg   %ax,%ax
  80273a:	66 90                	xchg   %ax,%ax
  80273c:	66 90                	xchg   %ax,%ax
  80273e:	66 90                	xchg   %ax,%ax

00802740 <__udivdi3>:
  802740:	f3 0f 1e fb          	endbr32 
  802744:	55                   	push   %ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 1c             	sub    $0x1c,%esp
  80274b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80274f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802753:	8b 74 24 34          	mov    0x34(%esp),%esi
  802757:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80275b:	85 d2                	test   %edx,%edx
  80275d:	75 19                	jne    802778 <__udivdi3+0x38>
  80275f:	39 f3                	cmp    %esi,%ebx
  802761:	76 4d                	jbe    8027b0 <__udivdi3+0x70>
  802763:	31 ff                	xor    %edi,%edi
  802765:	89 e8                	mov    %ebp,%eax
  802767:	89 f2                	mov    %esi,%edx
  802769:	f7 f3                	div    %ebx
  80276b:	89 fa                	mov    %edi,%edx
  80276d:	83 c4 1c             	add    $0x1c,%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    
  802775:	8d 76 00             	lea    0x0(%esi),%esi
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	76 14                	jbe    802790 <__udivdi3+0x50>
  80277c:	31 ff                	xor    %edi,%edi
  80277e:	31 c0                	xor    %eax,%eax
  802780:	89 fa                	mov    %edi,%edx
  802782:	83 c4 1c             	add    $0x1c,%esp
  802785:	5b                   	pop    %ebx
  802786:	5e                   	pop    %esi
  802787:	5f                   	pop    %edi
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    
  80278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802790:	0f bd fa             	bsr    %edx,%edi
  802793:	83 f7 1f             	xor    $0x1f,%edi
  802796:	75 48                	jne    8027e0 <__udivdi3+0xa0>
  802798:	39 f2                	cmp    %esi,%edx
  80279a:	72 06                	jb     8027a2 <__udivdi3+0x62>
  80279c:	31 c0                	xor    %eax,%eax
  80279e:	39 eb                	cmp    %ebp,%ebx
  8027a0:	77 de                	ja     802780 <__udivdi3+0x40>
  8027a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a7:	eb d7                	jmp    802780 <__udivdi3+0x40>
  8027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027b0:	89 d9                	mov    %ebx,%ecx
  8027b2:	85 db                	test   %ebx,%ebx
  8027b4:	75 0b                	jne    8027c1 <__udivdi3+0x81>
  8027b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	f7 f3                	div    %ebx
  8027bf:	89 c1                	mov    %eax,%ecx
  8027c1:	31 d2                	xor    %edx,%edx
  8027c3:	89 f0                	mov    %esi,%eax
  8027c5:	f7 f1                	div    %ecx
  8027c7:	89 c6                	mov    %eax,%esi
  8027c9:	89 e8                	mov    %ebp,%eax
  8027cb:	89 f7                	mov    %esi,%edi
  8027cd:	f7 f1                	div    %ecx
  8027cf:	89 fa                	mov    %edi,%edx
  8027d1:	83 c4 1c             	add    $0x1c,%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5f                   	pop    %edi
  8027d7:	5d                   	pop    %ebp
  8027d8:	c3                   	ret    
  8027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027e0:	89 f9                	mov    %edi,%ecx
  8027e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027e7:	29 f8                	sub    %edi,%eax
  8027e9:	d3 e2                	shl    %cl,%edx
  8027eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027ef:	89 c1                	mov    %eax,%ecx
  8027f1:	89 da                	mov    %ebx,%edx
  8027f3:	d3 ea                	shr    %cl,%edx
  8027f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f9:	09 d1                	or     %edx,%ecx
  8027fb:	89 f2                	mov    %esi,%edx
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 f9                	mov    %edi,%ecx
  802803:	d3 e3                	shl    %cl,%ebx
  802805:	89 c1                	mov    %eax,%ecx
  802807:	d3 ea                	shr    %cl,%edx
  802809:	89 f9                	mov    %edi,%ecx
  80280b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80280f:	89 eb                	mov    %ebp,%ebx
  802811:	d3 e6                	shl    %cl,%esi
  802813:	89 c1                	mov    %eax,%ecx
  802815:	d3 eb                	shr    %cl,%ebx
  802817:	09 de                	or     %ebx,%esi
  802819:	89 f0                	mov    %esi,%eax
  80281b:	f7 74 24 08          	divl   0x8(%esp)
  80281f:	89 d6                	mov    %edx,%esi
  802821:	89 c3                	mov    %eax,%ebx
  802823:	f7 64 24 0c          	mull   0xc(%esp)
  802827:	39 d6                	cmp    %edx,%esi
  802829:	72 15                	jb     802840 <__udivdi3+0x100>
  80282b:	89 f9                	mov    %edi,%ecx
  80282d:	d3 e5                	shl    %cl,%ebp
  80282f:	39 c5                	cmp    %eax,%ebp
  802831:	73 04                	jae    802837 <__udivdi3+0xf7>
  802833:	39 d6                	cmp    %edx,%esi
  802835:	74 09                	je     802840 <__udivdi3+0x100>
  802837:	89 d8                	mov    %ebx,%eax
  802839:	31 ff                	xor    %edi,%edi
  80283b:	e9 40 ff ff ff       	jmp    802780 <__udivdi3+0x40>
  802840:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802843:	31 ff                	xor    %edi,%edi
  802845:	e9 36 ff ff ff       	jmp    802780 <__udivdi3+0x40>
  80284a:	66 90                	xchg   %ax,%ax
  80284c:	66 90                	xchg   %ax,%ax
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__umoddi3>:
  802850:	f3 0f 1e fb          	endbr32 
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80285f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802863:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80286b:	85 c0                	test   %eax,%eax
  80286d:	75 19                	jne    802888 <__umoddi3+0x38>
  80286f:	39 df                	cmp    %ebx,%edi
  802871:	76 5d                	jbe    8028d0 <__umoddi3+0x80>
  802873:	89 f0                	mov    %esi,%eax
  802875:	89 da                	mov    %ebx,%edx
  802877:	f7 f7                	div    %edi
  802879:	89 d0                	mov    %edx,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	83 c4 1c             	add    $0x1c,%esp
  802880:	5b                   	pop    %ebx
  802881:	5e                   	pop    %esi
  802882:	5f                   	pop    %edi
  802883:	5d                   	pop    %ebp
  802884:	c3                   	ret    
  802885:	8d 76 00             	lea    0x0(%esi),%esi
  802888:	89 f2                	mov    %esi,%edx
  80288a:	39 d8                	cmp    %ebx,%eax
  80288c:	76 12                	jbe    8028a0 <__umoddi3+0x50>
  80288e:	89 f0                	mov    %esi,%eax
  802890:	89 da                	mov    %ebx,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028a0:	0f bd e8             	bsr    %eax,%ebp
  8028a3:	83 f5 1f             	xor    $0x1f,%ebp
  8028a6:	75 50                	jne    8028f8 <__umoddi3+0xa8>
  8028a8:	39 d8                	cmp    %ebx,%eax
  8028aa:	0f 82 e0 00 00 00    	jb     802990 <__umoddi3+0x140>
  8028b0:	89 d9                	mov    %ebx,%ecx
  8028b2:	39 f7                	cmp    %esi,%edi
  8028b4:	0f 86 d6 00 00 00    	jbe    802990 <__umoddi3+0x140>
  8028ba:	89 d0                	mov    %edx,%eax
  8028bc:	89 ca                	mov    %ecx,%edx
  8028be:	83 c4 1c             	add    $0x1c,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5f                   	pop    %edi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
  8028c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	89 fd                	mov    %edi,%ebp
  8028d2:	85 ff                	test   %edi,%edi
  8028d4:	75 0b                	jne    8028e1 <__umoddi3+0x91>
  8028d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028db:	31 d2                	xor    %edx,%edx
  8028dd:	f7 f7                	div    %edi
  8028df:	89 c5                	mov    %eax,%ebp
  8028e1:	89 d8                	mov    %ebx,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f5                	div    %ebp
  8028e7:	89 f0                	mov    %esi,%eax
  8028e9:	f7 f5                	div    %ebp
  8028eb:	89 d0                	mov    %edx,%eax
  8028ed:	31 d2                	xor    %edx,%edx
  8028ef:	eb 8c                	jmp    80287d <__umoddi3+0x2d>
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	89 e9                	mov    %ebp,%ecx
  8028fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8028ff:	29 ea                	sub    %ebp,%edx
  802901:	d3 e0                	shl    %cl,%eax
  802903:	89 44 24 08          	mov    %eax,0x8(%esp)
  802907:	89 d1                	mov    %edx,%ecx
  802909:	89 f8                	mov    %edi,%eax
  80290b:	d3 e8                	shr    %cl,%eax
  80290d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802911:	89 54 24 04          	mov    %edx,0x4(%esp)
  802915:	8b 54 24 04          	mov    0x4(%esp),%edx
  802919:	09 c1                	or     %eax,%ecx
  80291b:	89 d8                	mov    %ebx,%eax
  80291d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802921:	89 e9                	mov    %ebp,%ecx
  802923:	d3 e7                	shl    %cl,%edi
  802925:	89 d1                	mov    %edx,%ecx
  802927:	d3 e8                	shr    %cl,%eax
  802929:	89 e9                	mov    %ebp,%ecx
  80292b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80292f:	d3 e3                	shl    %cl,%ebx
  802931:	89 c7                	mov    %eax,%edi
  802933:	89 d1                	mov    %edx,%ecx
  802935:	89 f0                	mov    %esi,%eax
  802937:	d3 e8                	shr    %cl,%eax
  802939:	89 e9                	mov    %ebp,%ecx
  80293b:	89 fa                	mov    %edi,%edx
  80293d:	d3 e6                	shl    %cl,%esi
  80293f:	09 d8                	or     %ebx,%eax
  802941:	f7 74 24 08          	divl   0x8(%esp)
  802945:	89 d1                	mov    %edx,%ecx
  802947:	89 f3                	mov    %esi,%ebx
  802949:	f7 64 24 0c          	mull   0xc(%esp)
  80294d:	89 c6                	mov    %eax,%esi
  80294f:	89 d7                	mov    %edx,%edi
  802951:	39 d1                	cmp    %edx,%ecx
  802953:	72 06                	jb     80295b <__umoddi3+0x10b>
  802955:	75 10                	jne    802967 <__umoddi3+0x117>
  802957:	39 c3                	cmp    %eax,%ebx
  802959:	73 0c                	jae    802967 <__umoddi3+0x117>
  80295b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80295f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802963:	89 d7                	mov    %edx,%edi
  802965:	89 c6                	mov    %eax,%esi
  802967:	89 ca                	mov    %ecx,%edx
  802969:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80296e:	29 f3                	sub    %esi,%ebx
  802970:	19 fa                	sbb    %edi,%edx
  802972:	89 d0                	mov    %edx,%eax
  802974:	d3 e0                	shl    %cl,%eax
  802976:	89 e9                	mov    %ebp,%ecx
  802978:	d3 eb                	shr    %cl,%ebx
  80297a:	d3 ea                	shr    %cl,%edx
  80297c:	09 d8                	or     %ebx,%eax
  80297e:	83 c4 1c             	add    $0x1c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	29 fe                	sub    %edi,%esi
  802992:	19 c3                	sbb    %eax,%ebx
  802994:	89 f2                	mov    %esi,%edx
  802996:	89 d9                	mov    %ebx,%ecx
  802998:	e9 1d ff ff ff       	jmp    8028ba <__umoddi3+0x6a>
