
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 a5 02 00 00       	call   8002d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 7c             	sub    $0x7c,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003f:	c7 05 04 40 80 00 a0 	movl   $0x802aa0,0x804004
  800046:	2a 80 00 

	if ((i = pipe(p)) < 0)
  800049:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80004c:	50                   	push   %eax
  80004d:	e8 79 22 00 00       	call   8022cb <pipe>
  800052:	89 c6                	mov    %eax,%esi
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 1b 01 00 00    	js     80017a <umain+0x147>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  80005f:	e8 41 12 00 00       	call   8012a5 <fork>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 88 1e 01 00 00    	js     80018c <umain+0x159>
		panic("fork: %e", i);

	if (pid == 0) {
  80006e:	0f 85 56 01 00 00    	jne    8001ca <umain+0x197>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  800074:	a1 08 50 80 00       	mov    0x805008,%eax
  800079:	8b 40 48             	mov    0x48(%eax),%eax
  80007c:	83 ec 04             	sub    $0x4,%esp
  80007f:	ff 75 90             	pushl  -0x70(%ebp)
  800082:	50                   	push   %eax
  800083:	68 ce 2a 80 00       	push   $0x802ace
  800088:	e8 98 03 00 00       	call   800425 <cprintf>
		close(p[1]);
  80008d:	83 c4 04             	add    $0x4,%esp
  800090:	ff 75 90             	pushl  -0x70(%ebp)
  800093:	e8 0e 15 00 00       	call   8015a6 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800098:	a1 08 50 80 00       	mov    0x805008,%eax
  80009d:	8b 40 48             	mov    0x48(%eax),%eax
  8000a0:	83 c4 0c             	add    $0xc,%esp
  8000a3:	ff 75 8c             	pushl  -0x74(%ebp)
  8000a6:	50                   	push   %eax
  8000a7:	68 eb 2a 80 00       	push   $0x802aeb
  8000ac:	e8 74 03 00 00       	call   800425 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	6a 63                	push   $0x63
  8000b6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000b9:	50                   	push   %eax
  8000ba:	ff 75 8c             	pushl  -0x74(%ebp)
  8000bd:	e8 b9 16 00 00       	call   80177b <readn>
  8000c2:	89 c6                	mov    %eax,%esi
		if (i < 0)
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 88 cf 00 00 00    	js     80019e <umain+0x16b>
			panic("read: %e", i);
		buf[i] = 0;
  8000cf:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  8000d4:	83 ec 08             	sub    $0x8,%esp
  8000d7:	ff 35 00 40 80 00    	pushl  0x804000
  8000dd:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 08 0a 00 00       	call   800aee <strcmp>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	85 c0                	test   %eax,%eax
  8000eb:	0f 85 bf 00 00 00    	jne    8001b0 <umain+0x17d>
			cprintf("\npipe read closed properly\n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 11 2b 80 00       	push   $0x802b11
  8000f9:	e8 27 03 00 00       	call   800425 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
		exit();
  800101:	e8 1a 02 00 00       	call   800320 <exit>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
			panic("write: %e", i);
		close(p[1]);
	}
	wait(pid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	53                   	push   %ebx
  80010a:	e8 41 23 00 00       	call   802450 <wait>

	binaryname = "pipewriteeof";
  80010f:	c7 05 04 40 80 00 67 	movl   $0x802b67,0x804004
  800116:	2b 80 00 
	if ((i = pipe(p)) < 0)
  800119:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80011c:	89 04 24             	mov    %eax,(%esp)
  80011f:	e8 a7 21 00 00       	call   8022cb <pipe>
  800124:	89 c6                	mov    %eax,%esi
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	85 c0                	test   %eax,%eax
  80012b:	0f 88 32 01 00 00    	js     800263 <umain+0x230>
		panic("pipe: %e", i);

	if ((pid = fork()) < 0)
  800131:	e8 6f 11 00 00       	call   8012a5 <fork>
  800136:	89 c3                	mov    %eax,%ebx
  800138:	85 c0                	test   %eax,%eax
  80013a:	0f 88 35 01 00 00    	js     800275 <umain+0x242>
		panic("fork: %e", i);

	if (pid == 0) {
  800140:	0f 84 41 01 00 00    	je     800287 <umain+0x254>
				break;
		}
		cprintf("\npipe write closed properly\n");
		exit();
	}
	close(p[0]);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 8c             	pushl  -0x74(%ebp)
  80014c:	e8 55 14 00 00       	call   8015a6 <close>
	close(p[1]);
  800151:	83 c4 04             	add    $0x4,%esp
  800154:	ff 75 90             	pushl  -0x70(%ebp)
  800157:	e8 4a 14 00 00       	call   8015a6 <close>
	wait(pid);
  80015c:	89 1c 24             	mov    %ebx,(%esp)
  80015f:	e8 ec 22 00 00       	call   802450 <wait>

	cprintf("pipe tests passed\n");
  800164:	c7 04 24 95 2b 80 00 	movl   $0x802b95,(%esp)
  80016b:	e8 b5 02 00 00       	call   800425 <cprintf>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    
		panic("pipe: %e", i);
  80017a:	50                   	push   %eax
  80017b:	68 ac 2a 80 00       	push   $0x802aac
  800180:	6a 0e                	push   $0xe
  800182:	68 b5 2a 80 00       	push   $0x802ab5
  800187:	e8 b2 01 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  80018c:	56                   	push   %esi
  80018d:	68 c5 2a 80 00       	push   $0x802ac5
  800192:	6a 11                	push   $0x11
  800194:	68 b5 2a 80 00       	push   $0x802ab5
  800199:	e8 a0 01 00 00       	call   80033e <_panic>
			panic("read: %e", i);
  80019e:	50                   	push   %eax
  80019f:	68 08 2b 80 00       	push   $0x802b08
  8001a4:	6a 19                	push   $0x19
  8001a6:	68 b5 2a 80 00       	push   $0x802ab5
  8001ab:	e8 8e 01 00 00       	call   80033e <_panic>
			cprintf("\ngot %d bytes: %s\n", i, buf);
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	56                   	push   %esi
  8001b8:	68 2d 2b 80 00       	push   $0x802b2d
  8001bd:	e8 63 02 00 00       	call   800425 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
  8001c5:	e9 37 ff ff ff       	jmp    800101 <umain+0xce>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  8001ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8001cf:	8b 40 48             	mov    0x48(%eax),%eax
  8001d2:	83 ec 04             	sub    $0x4,%esp
  8001d5:	ff 75 8c             	pushl  -0x74(%ebp)
  8001d8:	50                   	push   %eax
  8001d9:	68 ce 2a 80 00       	push   $0x802ace
  8001de:	e8 42 02 00 00       	call   800425 <cprintf>
		close(p[0]);
  8001e3:	83 c4 04             	add    $0x4,%esp
  8001e6:	ff 75 8c             	pushl  -0x74(%ebp)
  8001e9:	e8 b8 13 00 00       	call   8015a6 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001ee:	a1 08 50 80 00       	mov    0x805008,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 c4 0c             	add    $0xc,%esp
  8001f9:	ff 75 90             	pushl  -0x70(%ebp)
  8001fc:	50                   	push   %eax
  8001fd:	68 40 2b 80 00       	push   $0x802b40
  800202:	e8 1e 02 00 00       	call   800425 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 35 00 40 80 00    	pushl  0x804000
  800210:	e8 d7 07 00 00       	call   8009ec <strlen>
  800215:	83 c4 0c             	add    $0xc,%esp
  800218:	50                   	push   %eax
  800219:	ff 35 00 40 80 00    	pushl  0x804000
  80021f:	ff 75 90             	pushl  -0x70(%ebp)
  800222:	e8 9f 15 00 00       	call   8017c6 <write>
  800227:	89 c6                	mov    %eax,%esi
  800229:	83 c4 04             	add    $0x4,%esp
  80022c:	ff 35 00 40 80 00    	pushl  0x804000
  800232:	e8 b5 07 00 00       	call   8009ec <strlen>
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	39 f0                	cmp    %esi,%eax
  80023c:	75 13                	jne    800251 <umain+0x21e>
		close(p[1]);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 90             	pushl  -0x70(%ebp)
  800244:	e8 5d 13 00 00       	call   8015a6 <close>
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	e9 b5 fe ff ff       	jmp    800106 <umain+0xd3>
			panic("write: %e", i);
  800251:	56                   	push   %esi
  800252:	68 5d 2b 80 00       	push   $0x802b5d
  800257:	6a 25                	push   $0x25
  800259:	68 b5 2a 80 00       	push   $0x802ab5
  80025e:	e8 db 00 00 00       	call   80033e <_panic>
		panic("pipe: %e", i);
  800263:	50                   	push   %eax
  800264:	68 ac 2a 80 00       	push   $0x802aac
  800269:	6a 2c                	push   $0x2c
  80026b:	68 b5 2a 80 00       	push   $0x802ab5
  800270:	e8 c9 00 00 00       	call   80033e <_panic>
		panic("fork: %e", i);
  800275:	56                   	push   %esi
  800276:	68 c5 2a 80 00       	push   $0x802ac5
  80027b:	6a 2f                	push   $0x2f
  80027d:	68 b5 2a 80 00       	push   $0x802ab5
  800282:	e8 b7 00 00 00       	call   80033e <_panic>
		close(p[0]);
  800287:	83 ec 0c             	sub    $0xc,%esp
  80028a:	ff 75 8c             	pushl  -0x74(%ebp)
  80028d:	e8 14 13 00 00       	call   8015a6 <close>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf(".");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 74 2b 80 00       	push   $0x802b74
  80029d:	e8 83 01 00 00       	call   800425 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002a2:	83 c4 0c             	add    $0xc,%esp
  8002a5:	6a 01                	push   $0x1
  8002a7:	68 76 2b 80 00       	push   $0x802b76
  8002ac:	ff 75 90             	pushl  -0x70(%ebp)
  8002af:	e8 12 15 00 00       	call   8017c6 <write>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	83 f8 01             	cmp    $0x1,%eax
  8002ba:	74 d9                	je     800295 <umain+0x262>
		cprintf("\npipe write closed properly\n");
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 78 2b 80 00       	push   $0x802b78
  8002c4:	e8 5c 01 00 00       	call   800425 <cprintf>
		exit();
  8002c9:	e8 52 00 00 00       	call   800320 <exit>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	e9 70 fe ff ff       	jmp    800146 <umain+0x113>

008002d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e5:	e8 41 0b 00 00       	call   800e2b <sys_getenvid>
  8002ea:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fc:	85 db                	test   %ebx,%ebx
  8002fe:	7e 07                	jle    800307 <libmain+0x31>
		binaryname = argv[0];
  800300:	8b 06                	mov    (%esi),%eax
  800302:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	56                   	push   %esi
  80030b:	53                   	push   %ebx
  80030c:	e8 22 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800311:	e8 0a 00 00 00       	call   800320 <exit>
}
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80031c:	5b                   	pop    %ebx
  80031d:	5e                   	pop    %esi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	f3 0f 1e fb          	endbr32 
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032a:	e8 a8 12 00 00       	call   8015d7 <close_all>
	sys_env_destroy(0);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	6a 00                	push   $0x0
  800334:	e8 ad 0a 00 00       	call   800de6 <sys_env_destroy>
}
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800347:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034a:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800350:	e8 d6 0a 00 00       	call   800e2b <sys_getenvid>
  800355:	83 ec 0c             	sub    $0xc,%esp
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	56                   	push   %esi
  80035f:	50                   	push   %eax
  800360:	68 f8 2b 80 00       	push   $0x802bf8
  800365:	e8 bb 00 00 00       	call   800425 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036a:	83 c4 18             	add    $0x18,%esp
  80036d:	53                   	push   %ebx
  80036e:	ff 75 10             	pushl  0x10(%ebp)
  800371:	e8 5a 00 00 00       	call   8003d0 <vcprintf>
	cprintf("\n");
  800376:	c7 04 24 e9 2a 80 00 	movl   $0x802ae9,(%esp)
  80037d:	e8 a3 00 00 00       	call   800425 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800385:	cc                   	int3   
  800386:	eb fd                	jmp    800385 <_panic+0x47>

00800388 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800388:	f3 0f 1e fb          	endbr32 
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	53                   	push   %ebx
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800396:	8b 13                	mov    (%ebx),%edx
  800398:	8d 42 01             	lea    0x1(%edx),%eax
  80039b:	89 03                	mov    %eax,(%ebx)
  80039d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a9:	74 09                	je     8003b4 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b2:	c9                   	leave  
  8003b3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	68 ff 00 00 00       	push   $0xff
  8003bc:	8d 43 08             	lea    0x8(%ebx),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 dc 09 00 00       	call   800da1 <sys_cputs>
		b->idx = 0;
  8003c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb db                	jmp    8003ab <putch+0x23>

008003d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d0:	f3 0f 1e fb          	endbr32 
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e4:	00 00 00 
	b.cnt = 0;
  8003e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f1:	ff 75 0c             	pushl  0xc(%ebp)
  8003f4:	ff 75 08             	pushl  0x8(%ebp)
  8003f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	68 88 03 80 00       	push   $0x800388
  800403:	e8 20 01 00 00       	call   800528 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800408:	83 c4 08             	add    $0x8,%esp
  80040b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800411:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800417:	50                   	push   %eax
  800418:	e8 84 09 00 00       	call   800da1 <sys_cputs>

	return b.cnt;
}
  80041d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800425:	f3 0f 1e fb          	endbr32 
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80042f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800432:	50                   	push   %eax
  800433:	ff 75 08             	pushl  0x8(%ebp)
  800436:	e8 95 ff ff ff       	call   8003d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	57                   	push   %edi
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 1c             	sub    $0x1c,%esp
  800446:	89 c7                	mov    %eax,%edi
  800448:	89 d6                	mov    %edx,%esi
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	89 c2                	mov    %eax,%edx
  800454:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800457:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045a:	8b 45 10             	mov    0x10(%ebp),%eax
  80045d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800463:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046a:	39 c2                	cmp    %eax,%edx
  80046c:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80046f:	72 3e                	jb     8004af <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800471:	83 ec 0c             	sub    $0xc,%esp
  800474:	ff 75 18             	pushl  0x18(%ebp)
  800477:	83 eb 01             	sub    $0x1,%ebx
  80047a:	53                   	push   %ebx
  80047b:	50                   	push   %eax
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff 75 dc             	pushl  -0x24(%ebp)
  800488:	ff 75 d8             	pushl  -0x28(%ebp)
  80048b:	e8 a0 23 00 00       	call   802830 <__udivdi3>
  800490:	83 c4 18             	add    $0x18,%esp
  800493:	52                   	push   %edx
  800494:	50                   	push   %eax
  800495:	89 f2                	mov    %esi,%edx
  800497:	89 f8                	mov    %edi,%eax
  800499:	e8 9f ff ff ff       	call   80043d <printnum>
  80049e:	83 c4 20             	add    $0x20,%esp
  8004a1:	eb 13                	jmp    8004b6 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	56                   	push   %esi
  8004a7:	ff 75 18             	pushl  0x18(%ebp)
  8004aa:	ff d7                	call   *%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004af:	83 eb 01             	sub    $0x1,%ebx
  8004b2:	85 db                	test   %ebx,%ebx
  8004b4:	7f ed                	jg     8004a3 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	56                   	push   %esi
  8004ba:	83 ec 04             	sub    $0x4,%esp
  8004bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8004c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c9:	e8 72 24 00 00       	call   802940 <__umoddi3>
  8004ce:	83 c4 14             	add    $0x14,%esp
  8004d1:	0f be 80 1b 2c 80 00 	movsbl 0x802c1b(%eax),%eax
  8004d8:	50                   	push   %eax
  8004d9:	ff d7                	call   *%edi
}
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e6:	f3 0f 1e fb          	endbr32 
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f4:	8b 10                	mov    (%eax),%edx
  8004f6:	3b 50 04             	cmp    0x4(%eax),%edx
  8004f9:	73 0a                	jae    800505 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	88 02                	mov    %al,(%edx)
}
  800505:	5d                   	pop    %ebp
  800506:	c3                   	ret    

00800507 <printfmt>:
{
  800507:	f3 0f 1e fb          	endbr32 
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800511:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800514:	50                   	push   %eax
  800515:	ff 75 10             	pushl  0x10(%ebp)
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	e8 05 00 00 00       	call   800528 <vprintfmt>
}
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <vprintfmt>:
{
  800528:	f3 0f 1e fb          	endbr32 
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	57                   	push   %edi
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 3c             	sub    $0x3c,%esp
  800535:	8b 75 08             	mov    0x8(%ebp),%esi
  800538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80053e:	e9 8e 03 00 00       	jmp    8008d1 <vprintfmt+0x3a9>
		padc = ' ';
  800543:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800547:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80054e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800555:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800561:	8d 47 01             	lea    0x1(%edi),%eax
  800564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800567:	0f b6 17             	movzbl (%edi),%edx
  80056a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80056d:	3c 55                	cmp    $0x55,%al
  80056f:	0f 87 df 03 00 00    	ja     800954 <vprintfmt+0x42c>
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	3e ff 24 85 60 2d 80 	notrack jmp *0x802d60(,%eax,4)
  80057f:	00 
  800580:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800583:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800587:	eb d8                	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800589:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80058c:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800590:	eb cf                	jmp    800561 <vprintfmt+0x39>
  800592:	0f b6 d2             	movzbl %dl,%edx
  800595:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800598:	b8 00 00 00 00       	mov    $0x0,%eax
  80059d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005a7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005aa:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005ad:	83 f9 09             	cmp    $0x9,%ecx
  8005b0:	77 55                	ja     800607 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b5:	eb e9                	jmp    8005a0 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 04             	lea    0x4(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005cf:	79 90                	jns    800561 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005de:	eb 81                	jmp    800561 <vprintfmt+0x39>
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	85 c0                	test   %eax,%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	0f 49 d0             	cmovns %eax,%edx
  8005ed:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f3:	e9 69 ff ff ff       	jmp    800561 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005fb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800602:	e9 5a ff ff ff       	jmp    800561 <vprintfmt+0x39>
  800607:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80060a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060d:	eb bc                	jmp    8005cb <vprintfmt+0xa3>
			lflag++;
  80060f:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800615:	e9 47 ff ff ff       	jmp    800561 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 78 04             	lea    0x4(%eax),%edi
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	53                   	push   %ebx
  800624:	ff 30                	pushl  (%eax)
  800626:	ff d6                	call   *%esi
			break;
  800628:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80062e:	e9 9b 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 78 04             	lea    0x4(%eax),%edi
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	99                   	cltd   
  80063c:	31 d0                	xor    %edx,%eax
  80063e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800640:	83 f8 0f             	cmp    $0xf,%eax
  800643:	7f 23                	jg     800668 <vprintfmt+0x140>
  800645:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  80064c:	85 d2                	test   %edx,%edx
  80064e:	74 18                	je     800668 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800650:	52                   	push   %edx
  800651:	68 15 31 80 00       	push   $0x803115
  800656:	53                   	push   %ebx
  800657:	56                   	push   %esi
  800658:	e8 aa fe ff ff       	call   800507 <printfmt>
  80065d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800660:	89 7d 14             	mov    %edi,0x14(%ebp)
  800663:	e9 66 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800668:	50                   	push   %eax
  800669:	68 33 2c 80 00       	push   $0x802c33
  80066e:	53                   	push   %ebx
  80066f:	56                   	push   %esi
  800670:	e8 92 fe ff ff       	call   800507 <printfmt>
  800675:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800678:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067b:	e9 4e 02 00 00       	jmp    8008ce <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	83 c0 04             	add    $0x4,%eax
  800686:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 2c 2c 80 00       	mov    $0x802c2c,%eax
  800695:	0f 45 c2             	cmovne %edx,%eax
  800698:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80069f:	7e 06                	jle    8006a7 <vprintfmt+0x17f>
  8006a1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a5:	75 0d                	jne    8006b4 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006aa:	89 c7                	mov    %eax,%edi
  8006ac:	03 45 e0             	add    -0x20(%ebp),%eax
  8006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b2:	eb 55                	jmp    800709 <vprintfmt+0x1e1>
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ba:	ff 75 cc             	pushl  -0x34(%ebp)
  8006bd:	e8 46 03 00 00       	call   800a08 <strnlen>
  8006c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c5:	29 c2                	sub    %eax,%edx
  8006c7:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006cf:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d6:	85 ff                	test   %edi,%edi
  8006d8:	7e 11                	jle    8006eb <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e3:	83 ef 01             	sub    $0x1,%edi
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	eb eb                	jmp    8006d6 <vprintfmt+0x1ae>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006fd:	eb a8                	jmp    8006a7 <vprintfmt+0x17f>
					putch(ch, putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	52                   	push   %edx
  800704:	ff d6                	call   *%esi
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80070c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070e:	83 c7 01             	add    $0x1,%edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	0f be d0             	movsbl %al,%edx
  800718:	85 d2                	test   %edx,%edx
  80071a:	74 4b                	je     800767 <vprintfmt+0x23f>
  80071c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800720:	78 06                	js     800728 <vprintfmt+0x200>
  800722:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800726:	78 1e                	js     800746 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800728:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80072c:	74 d1                	je     8006ff <vprintfmt+0x1d7>
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 e8 20             	sub    $0x20,%eax
  800734:	83 f8 5e             	cmp    $0x5e,%eax
  800737:	76 c6                	jbe    8006ff <vprintfmt+0x1d7>
					putch('?', putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	6a 3f                	push   $0x3f
  80073f:	ff d6                	call   *%esi
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	eb c3                	jmp    800709 <vprintfmt+0x1e1>
  800746:	89 cf                	mov    %ecx,%edi
  800748:	eb 0e                	jmp    800758 <vprintfmt+0x230>
				putch(' ', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	53                   	push   %ebx
  80074e:	6a 20                	push   $0x20
  800750:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800752:	83 ef 01             	sub    $0x1,%edi
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	85 ff                	test   %edi,%edi
  80075a:	7f ee                	jg     80074a <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	e9 67 01 00 00       	jmp    8008ce <vprintfmt+0x3a6>
  800767:	89 cf                	mov    %ecx,%edi
  800769:	eb ed                	jmp    800758 <vprintfmt+0x230>
	if (lflag >= 2)
  80076b:	83 f9 01             	cmp    $0x1,%ecx
  80076e:	7f 1b                	jg     80078b <vprintfmt+0x263>
	else if (lflag)
  800770:	85 c9                	test   %ecx,%ecx
  800772:	74 63                	je     8007d7 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	99                   	cltd   
  80077d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8d 40 04             	lea    0x4(%eax),%eax
  800786:	89 45 14             	mov    %eax,0x14(%ebp)
  800789:	eb 17                	jmp    8007a2 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8b 50 04             	mov    0x4(%eax),%edx
  800791:	8b 00                	mov    (%eax),%eax
  800793:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800796:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 40 08             	lea    0x8(%eax),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007a8:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	0f 89 ff 00 00 00    	jns    8008b4 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 2d                	push   $0x2d
  8007bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8007bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c3:	f7 da                	neg    %edx
  8007c5:	83 d1 00             	adc    $0x0,%ecx
  8007c8:	f7 d9                	neg    %ecx
  8007ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d2:	e9 dd 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007df:	99                   	cltd   
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ec:	eb b4                	jmp    8007a2 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007ee:	83 f9 01             	cmp    $0x1,%ecx
  8007f1:	7f 1e                	jg     800811 <vprintfmt+0x2e9>
	else if (lflag)
  8007f3:	85 c9                	test   %ecx,%ecx
  8007f5:	74 32                	je     800829 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	8b 10                	mov    (%eax),%edx
  8007fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800801:	8d 40 04             	lea    0x4(%eax),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80080c:	e9 a3 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8b 10                	mov    (%eax),%edx
  800816:	8b 48 04             	mov    0x4(%eax),%ecx
  800819:	8d 40 08             	lea    0x8(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80081f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800824:	e9 8b 00 00 00       	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 10                	mov    (%eax),%edx
  80082e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800833:	8d 40 04             	lea    0x4(%eax),%eax
  800836:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80083e:	eb 74                	jmp    8008b4 <vprintfmt+0x38c>
	if (lflag >= 2)
  800840:	83 f9 01             	cmp    $0x1,%ecx
  800843:	7f 1b                	jg     800860 <vprintfmt+0x338>
	else if (lflag)
  800845:	85 c9                	test   %ecx,%ecx
  800847:	74 2c                	je     800875 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	8b 10                	mov    (%eax),%edx
  80084e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800853:	8d 40 04             	lea    0x4(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800859:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80085e:	eb 54                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 10                	mov    (%eax),%edx
  800865:	8b 48 04             	mov    0x4(%eax),%ecx
  800868:	8d 40 08             	lea    0x8(%eax),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80086e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800873:	eb 3f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 10                	mov    (%eax),%edx
  80087a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800885:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80088a:	eb 28                	jmp    8008b4 <vprintfmt+0x38c>
			putch('0', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 30                	push   $0x30
  800892:	ff d6                	call   *%esi
			putch('x', putdat);
  800894:	83 c4 08             	add    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	6a 78                	push   $0x78
  80089a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 10                	mov    (%eax),%edx
  8008a1:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008a6:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008a9:	8d 40 04             	lea    0x4(%eax),%eax
  8008ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008af:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b4:	83 ec 0c             	sub    $0xc,%esp
  8008b7:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008bb:	57                   	push   %edi
  8008bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	51                   	push   %ecx
  8008c1:	52                   	push   %edx
  8008c2:	89 da                	mov    %ebx,%edx
  8008c4:	89 f0                	mov    %esi,%eax
  8008c6:	e8 72 fb ff ff       	call   80043d <printnum>
			break;
  8008cb:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d8:	83 f8 25             	cmp    $0x25,%eax
  8008db:	0f 84 62 fc ff ff    	je     800543 <vprintfmt+0x1b>
			if (ch == '\0')
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	0f 84 8b 00 00 00    	je     800974 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	53                   	push   %ebx
  8008ed:	50                   	push   %eax
  8008ee:	ff d6                	call   *%esi
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb dc                	jmp    8008d1 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f5:	83 f9 01             	cmp    $0x1,%ecx
  8008f8:	7f 1b                	jg     800915 <vprintfmt+0x3ed>
	else if (lflag)
  8008fa:	85 c9                	test   %ecx,%ecx
  8008fc:	74 2c                	je     80092a <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8b 10                	mov    (%eax),%edx
  800903:	b9 00 00 00 00       	mov    $0x0,%ecx
  800908:	8d 40 04             	lea    0x4(%eax),%eax
  80090b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80090e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800913:	eb 9f                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800915:	8b 45 14             	mov    0x14(%ebp),%eax
  800918:	8b 10                	mov    (%eax),%edx
  80091a:	8b 48 04             	mov    0x4(%eax),%ecx
  80091d:	8d 40 08             	lea    0x8(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800923:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800928:	eb 8a                	jmp    8008b4 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80092a:	8b 45 14             	mov    0x14(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800934:	8d 40 04             	lea    0x4(%eax),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80093f:	e9 70 ff ff ff       	jmp    8008b4 <vprintfmt+0x38c>
			putch(ch, putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	53                   	push   %ebx
  800948:	6a 25                	push   $0x25
  80094a:	ff d6                	call   *%esi
			break;
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	e9 7a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
			putch('%', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	53                   	push   %ebx
  800958:	6a 25                	push   $0x25
  80095a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095c:	83 c4 10             	add    $0x10,%esp
  80095f:	89 f8                	mov    %edi,%eax
  800961:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800965:	74 05                	je     80096c <vprintfmt+0x444>
  800967:	83 e8 01             	sub    $0x1,%eax
  80096a:	eb f5                	jmp    800961 <vprintfmt+0x439>
  80096c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80096f:	e9 5a ff ff ff       	jmp    8008ce <vprintfmt+0x3a6>
}
  800974:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800977:	5b                   	pop    %ebx
  800978:	5e                   	pop    %esi
  800979:	5f                   	pop    %edi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	83 ec 18             	sub    $0x18,%esp
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80098f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800993:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	85 c0                	test   %eax,%eax
  80099f:	74 26                	je     8009c7 <vsnprintf+0x4b>
  8009a1:	85 d2                	test   %edx,%edx
  8009a3:	7e 22                	jle    8009c7 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a5:	ff 75 14             	pushl  0x14(%ebp)
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	68 e6 04 80 00       	push   $0x8004e6
  8009b4:	e8 6f fb ff ff       	call   800528 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009bc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
}
  8009c5:	c9                   	leave  
  8009c6:	c3                   	ret    
		return -E_INVAL;
  8009c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009cc:	eb f7                	jmp    8009c5 <vsnprintf+0x49>

008009ce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ce:	f3 0f 1e fb          	endbr32 
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009db:	50                   	push   %eax
  8009dc:	ff 75 10             	pushl  0x10(%ebp)
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	ff 75 08             	pushl  0x8(%ebp)
  8009e5:	e8 92 ff ff ff       	call   80097c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ff:	74 05                	je     800a06 <strlen+0x1a>
		n++;
  800a01:	83 c0 01             	add    $0x1,%eax
  800a04:	eb f5                	jmp    8009fb <strlen+0xf>
	return n;
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a08:	f3 0f 1e fb          	endbr32 
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	39 d0                	cmp    %edx,%eax
  800a1c:	74 0d                	je     800a2b <strnlen+0x23>
  800a1e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a22:	74 05                	je     800a29 <strnlen+0x21>
		n++;
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f1                	jmp    800a1a <strnlen+0x12>
  800a29:	89 c2                	mov    %eax,%edx
	return n;
}
  800a2b:	89 d0                	mov    %edx,%eax
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2f:	f3 0f 1e fb          	endbr32 
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a42:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a46:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	84 d2                	test   %dl,%dl
  800a4e:	75 f2                	jne    800a42 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a50:	89 c8                	mov    %ecx,%eax
  800a52:	5b                   	pop    %ebx
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	83 ec 10             	sub    $0x10,%esp
  800a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a63:	53                   	push   %ebx
  800a64:	e8 83 ff ff ff       	call   8009ec <strlen>
  800a69:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	01 d8                	add    %ebx,%eax
  800a71:	50                   	push   %eax
  800a72:	e8 b8 ff ff ff       	call   800a2f <strcpy>
	return dst;
}
  800a77:	89 d8                	mov    %ebx,%eax
  800a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a7e:	f3 0f 1e fb          	endbr32 
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	89 f3                	mov    %esi,%ebx
  800a8f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a92:	89 f0                	mov    %esi,%eax
  800a94:	39 d8                	cmp    %ebx,%eax
  800a96:	74 11                	je     800aa9 <strncpy+0x2b>
		*dst++ = *src;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	0f b6 0a             	movzbl (%edx),%ecx
  800a9e:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa1:	80 f9 01             	cmp    $0x1,%cl
  800aa4:	83 da ff             	sbb    $0xffffffff,%edx
  800aa7:	eb eb                	jmp    800a94 <strncpy+0x16>
	}
	return ret;
}
  800aa9:	89 f0                	mov    %esi,%eax
  800aab:	5b                   	pop    %ebx
  800aac:	5e                   	pop    %esi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aaf:	f3 0f 1e fb          	endbr32 
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  800abb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abe:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac3:	85 d2                	test   %edx,%edx
  800ac5:	74 21                	je     800ae8 <strlcpy+0x39>
  800ac7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 14                	je     800ae5 <strlcpy+0x36>
  800ad1:	0f b6 19             	movzbl (%ecx),%ebx
  800ad4:	84 db                	test   %bl,%bl
  800ad6:	74 0b                	je     800ae3 <strlcpy+0x34>
			*dst++ = *src++;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae1:	eb ea                	jmp    800acd <strlcpy+0x1e>
  800ae3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae8:	29 f0                	sub    %esi,%eax
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aee:	f3 0f 1e fb          	endbr32 
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800afb:	0f b6 01             	movzbl (%ecx),%eax
  800afe:	84 c0                	test   %al,%al
  800b00:	74 0c                	je     800b0e <strcmp+0x20>
  800b02:	3a 02                	cmp    (%edx),%al
  800b04:	75 08                	jne    800b0e <strcmp+0x20>
		p++, q++;
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	eb ed                	jmp    800afb <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0e:	0f b6 c0             	movzbl %al,%eax
  800b11:	0f b6 12             	movzbl (%edx),%edx
  800b14:	29 d0                	sub    %edx,%eax
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	53                   	push   %ebx
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b26:	89 c3                	mov    %eax,%ebx
  800b28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2b:	eb 06                	jmp    800b33 <strncmp+0x1b>
		n--, p++, q++;
  800b2d:	83 c0 01             	add    $0x1,%eax
  800b30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b33:	39 d8                	cmp    %ebx,%eax
  800b35:	74 16                	je     800b4d <strncmp+0x35>
  800b37:	0f b6 08             	movzbl (%eax),%ecx
  800b3a:	84 c9                	test   %cl,%cl
  800b3c:	74 04                	je     800b42 <strncmp+0x2a>
  800b3e:	3a 0a                	cmp    (%edx),%cl
  800b40:	74 eb                	je     800b2d <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b42:	0f b6 00             	movzbl (%eax),%eax
  800b45:	0f b6 12             	movzbl (%edx),%edx
  800b48:	29 d0                	sub    %edx,%eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
		return 0;
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b52:	eb f6                	jmp    800b4a <strncmp+0x32>

00800b54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b62:	0f b6 10             	movzbl (%eax),%edx
  800b65:	84 d2                	test   %dl,%dl
  800b67:	74 09                	je     800b72 <strchr+0x1e>
		if (*s == c)
  800b69:	38 ca                	cmp    %cl,%dl
  800b6b:	74 0a                	je     800b77 <strchr+0x23>
	for (; *s; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f0                	jmp    800b62 <strchr+0xe>
			return (char *) s;
	return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    

00800b79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b79:	f3 0f 1e fb          	endbr32 
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b87:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8a:	38 ca                	cmp    %cl,%dl
  800b8c:	74 09                	je     800b97 <strfind+0x1e>
  800b8e:	84 d2                	test   %dl,%dl
  800b90:	74 05                	je     800b97 <strfind+0x1e>
	for (; *s; s++)
  800b92:	83 c0 01             	add    $0x1,%eax
  800b95:	eb f0                	jmp    800b87 <strfind+0xe>
			break;
	return (char *) s;
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
  800ba3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba9:	85 c9                	test   %ecx,%ecx
  800bab:	74 31                	je     800bde <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bad:	89 f8                	mov    %edi,%eax
  800baf:	09 c8                	or     %ecx,%eax
  800bb1:	a8 03                	test   $0x3,%al
  800bb3:	75 23                	jne    800bd8 <memset+0x3f>
		c &= 0xFF;
  800bb5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	c1 e3 08             	shl    $0x8,%ebx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	c1 e0 18             	shl    $0x18,%eax
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	c1 e6 10             	shl    $0x10,%esi
  800bc8:	09 f0                	or     %esi,%eax
  800bca:	09 c2                	or     %eax,%edx
  800bcc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bce:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd1:	89 d0                	mov    %edx,%eax
  800bd3:	fc                   	cld    
  800bd4:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd6:	eb 06                	jmp    800bde <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdb:	fc                   	cld    
  800bdc:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bde:	89 f8                	mov    %edi,%eax
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be5:	f3 0f 1e fb          	endbr32 
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf7:	39 c6                	cmp    %eax,%esi
  800bf9:	73 32                	jae    800c2d <memmove+0x48>
  800bfb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 2b                	jbe    800c2d <memmove+0x48>
		s += n;
		d += n;
  800c02:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c05:	89 fe                	mov    %edi,%esi
  800c07:	09 ce                	or     %ecx,%esi
  800c09:	09 d6                	or     %edx,%esi
  800c0b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c11:	75 0e                	jne    800c21 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c13:	83 ef 04             	sub    $0x4,%edi
  800c16:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c1c:	fd                   	std    
  800c1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1f:	eb 09                	jmp    800c2a <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c21:	83 ef 01             	sub    $0x1,%edi
  800c24:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c27:	fd                   	std    
  800c28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2a:	fc                   	cld    
  800c2b:	eb 1a                	jmp    800c47 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	09 ca                	or     %ecx,%edx
  800c31:	09 f2                	or     %esi,%edx
  800c33:	f6 c2 03             	test   $0x3,%dl
  800c36:	75 0a                	jne    800c42 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3b:	89 c7                	mov    %eax,%edi
  800c3d:	fc                   	cld    
  800c3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c40:	eb 05                	jmp    800c47 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c42:	89 c7                	mov    %eax,%edi
  800c44:	fc                   	cld    
  800c45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 82 ff ff ff       	call   800be5 <memmove>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c65:	f3 0f 1e fb          	endbr32 
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c74:	89 c6                	mov    %eax,%esi
  800c76:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c79:	39 f0                	cmp    %esi,%eax
  800c7b:	74 1c                	je     800c99 <memcmp+0x34>
		if (*s1 != *s2)
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	0f b6 1a             	movzbl (%edx),%ebx
  800c83:	38 d9                	cmp    %bl,%cl
  800c85:	75 08                	jne    800c8f <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c87:	83 c0 01             	add    $0x1,%eax
  800c8a:	83 c2 01             	add    $0x1,%edx
  800c8d:	eb ea                	jmp    800c79 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c8f:	0f b6 c1             	movzbl %cl,%eax
  800c92:	0f b6 db             	movzbl %bl,%ebx
  800c95:	29 d8                	sub    %ebx,%eax
  800c97:	eb 05                	jmp    800c9e <memcmp+0x39>
	}

	return 0;
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 09                	jae    800cc1 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	74 05                	je     800cc1 <memfind+0x1f>
	for (; s < ends; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	eb f3                	jmp    800cb4 <memfind+0x12>
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	f3 0f 1e fb          	endbr32 
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd3:	eb 03                	jmp    800cd8 <strtol+0x15>
		s++;
  800cd5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd8:	0f b6 01             	movzbl (%ecx),%eax
  800cdb:	3c 20                	cmp    $0x20,%al
  800cdd:	74 f6                	je     800cd5 <strtol+0x12>
  800cdf:	3c 09                	cmp    $0x9,%al
  800ce1:	74 f2                	je     800cd5 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce3:	3c 2b                	cmp    $0x2b,%al
  800ce5:	74 2a                	je     800d11 <strtol+0x4e>
	int neg = 0;
  800ce7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cec:	3c 2d                	cmp    $0x2d,%al
  800cee:	74 2b                	je     800d1b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf6:	75 0f                	jne    800d07 <strtol+0x44>
  800cf8:	80 39 30             	cmpb   $0x30,(%ecx)
  800cfb:	74 28                	je     800d25 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cfd:	85 db                	test   %ebx,%ebx
  800cff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d04:	0f 44 d8             	cmove  %eax,%ebx
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0f:	eb 46                	jmp    800d57 <strtol+0x94>
		s++;
  800d11:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d14:	bf 00 00 00 00       	mov    $0x0,%edi
  800d19:	eb d5                	jmp    800cf0 <strtol+0x2d>
		s++, neg = 1;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	bf 01 00 00 00       	mov    $0x1,%edi
  800d23:	eb cb                	jmp    800cf0 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d25:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d29:	74 0e                	je     800d39 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	75 d8                	jne    800d07 <strtol+0x44>
		s++, base = 8;
  800d2f:	83 c1 01             	add    $0x1,%ecx
  800d32:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d37:	eb ce                	jmp    800d07 <strtol+0x44>
		s += 2, base = 16;
  800d39:	83 c1 02             	add    $0x2,%ecx
  800d3c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d41:	eb c4                	jmp    800d07 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d49:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d4c:	7d 3a                	jge    800d88 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d4e:	83 c1 01             	add    $0x1,%ecx
  800d51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d55:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d57:	0f b6 11             	movzbl (%ecx),%edx
  800d5a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d5d:	89 f3                	mov    %esi,%ebx
  800d5f:	80 fb 09             	cmp    $0x9,%bl
  800d62:	76 df                	jbe    800d43 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d64:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d67:	89 f3                	mov    %esi,%ebx
  800d69:	80 fb 19             	cmp    $0x19,%bl
  800d6c:	77 08                	ja     800d76 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d6e:	0f be d2             	movsbl %dl,%edx
  800d71:	83 ea 57             	sub    $0x57,%edx
  800d74:	eb d3                	jmp    800d49 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d76:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d79:	89 f3                	mov    %esi,%ebx
  800d7b:	80 fb 19             	cmp    $0x19,%bl
  800d7e:	77 08                	ja     800d88 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d80:	0f be d2             	movsbl %dl,%edx
  800d83:	83 ea 37             	sub    $0x37,%edx
  800d86:	eb c1                	jmp    800d49 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8c:	74 05                	je     800d93 <strtol+0xd0>
		*endptr = (char *) s;
  800d8e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d91:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d93:	89 c2                	mov    %eax,%edx
  800d95:	f7 da                	neg    %edx
  800d97:	85 ff                	test   %edi,%edi
  800d99:	0f 45 c2             	cmovne %edx,%eax
}
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da1:	f3 0f 1e fb          	endbr32 
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	89 c3                	mov    %eax,%ebx
  800db8:	89 c7                	mov    %eax,%edi
  800dba:	89 c6                	mov    %eax,%esi
  800dbc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc3:	f3 0f 1e fb          	endbr32 
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	b8 03 00 00 00       	mov    $0x3,%eax
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 03                	push   $0x3
  800e1a:	68 1f 2f 80 00       	push   $0x802f1f
  800e1f:	6a 23                	push   $0x23
  800e21:	68 3c 2f 80 00       	push   $0x802f3c
  800e26:	e8 13 f5 ff ff       	call   80033e <_panic>

00800e2b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_yield>:

void
sys_yield(void)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e58:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	89 d3                	mov    %edx,%ebx
  800e66:	89 d7                	mov    %edx,%edi
  800e68:	89 d6                	mov    %edx,%esi
  800e6a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    

00800e71 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e71:	f3 0f 1e fb          	endbr32 
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	b8 04 00 00 00       	mov    $0x4,%eax
  800e8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e91:	89 f7                	mov    %esi,%edi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 04                	push   $0x4
  800ea7:	68 1f 2f 80 00       	push   $0x802f1f
  800eac:	6a 23                	push   $0x23
  800eae:	68 3c 2f 80 00       	push   $0x802f3c
  800eb3:	e8 86 f4 ff ff       	call   80033e <_panic>

00800eb8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb8:	f3 0f 1e fb          	endbr32 
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed6:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edb:	85 c0                	test   %eax,%eax
  800edd:	7f 08                	jg     800ee7 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	83 ec 0c             	sub    $0xc,%esp
  800eea:	50                   	push   %eax
  800eeb:	6a 05                	push   $0x5
  800eed:	68 1f 2f 80 00       	push   $0x802f1f
  800ef2:	6a 23                	push   $0x23
  800ef4:	68 3c 2f 80 00       	push   $0x802f3c
  800ef9:	e8 40 f4 ff ff       	call   80033e <_panic>

00800efe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800efe:	f3 0f 1e fb          	endbr32 
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	57                   	push   %edi
  800f06:	56                   	push   %esi
  800f07:	53                   	push   %ebx
  800f08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f10:	8b 55 08             	mov    0x8(%ebp),%edx
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1b:	89 df                	mov    %ebx,%edi
  800f1d:	89 de                	mov    %ebx,%esi
  800f1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	7f 08                	jg     800f2d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	50                   	push   %eax
  800f31:	6a 06                	push   $0x6
  800f33:	68 1f 2f 80 00       	push   $0x802f1f
  800f38:	6a 23                	push   $0x23
  800f3a:	68 3c 2f 80 00       	push   $0x802f3c
  800f3f:	e8 fa f3 ff ff       	call   80033e <_panic>

00800f44 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f44:	f3 0f 1e fb          	endbr32 
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	57                   	push   %edi
  800f4c:	56                   	push   %esi
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800f61:	89 df                	mov    %ebx,%edi
  800f63:	89 de                	mov    %ebx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	6a 08                	push   $0x8
  800f79:	68 1f 2f 80 00       	push   $0x802f1f
  800f7e:	6a 23                	push   $0x23
  800f80:	68 3c 2f 80 00       	push   $0x802f3c
  800f85:	e8 b4 f3 ff ff       	call   80033e <_panic>

00800f8a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	89 de                	mov    %ebx,%esi
  800fab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7f 08                	jg     800fb9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	50                   	push   %eax
  800fbd:	6a 09                	push   $0x9
  800fbf:	68 1f 2f 80 00       	push   $0x802f1f
  800fc4:	6a 23                	push   $0x23
  800fc6:	68 3c 2f 80 00       	push   $0x802f3c
  800fcb:	e8 6e f3 ff ff       	call   80033e <_panic>

00800fd0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd0:	f3 0f 1e fb          	endbr32 
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fed:	89 df                	mov    %ebx,%edi
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	7f 08                	jg     800fff <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	6a 0a                	push   $0xa
  801005:	68 1f 2f 80 00       	push   $0x802f1f
  80100a:	6a 23                	push   $0x23
  80100c:	68 3c 2f 80 00       	push   $0x802f3c
  801011:	e8 28 f3 ff ff       	call   80033e <_panic>

00801016 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801016:	f3 0f 1e fb          	endbr32 
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102b:	be 00 00 00 00       	mov    $0x0,%esi
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801033:	8b 7d 14             	mov    0x14(%ebp),%edi
  801036:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	b8 0d 00 00 00       	mov    $0xd,%eax
  801057:	89 cb                	mov    %ecx,%ebx
  801059:	89 cf                	mov    %ecx,%edi
  80105b:	89 ce                	mov    %ecx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	50                   	push   %eax
  80106f:	6a 0d                	push   $0xd
  801071:	68 1f 2f 80 00       	push   $0x802f1f
  801076:	6a 23                	push   $0x23
  801078:	68 3c 2f 80 00       	push   $0x802f3c
  80107d:	e8 bc f2 ff ff       	call   80033e <_panic>

00801082 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801082:	f3 0f 1e fb          	endbr32 
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	57                   	push   %edi
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108c:	ba 00 00 00 00       	mov    $0x0,%edx
  801091:	b8 0e 00 00 00       	mov    $0xe,%eax
  801096:	89 d1                	mov    %edx,%ecx
  801098:	89 d3                	mov    %edx,%ebx
  80109a:	89 d7                	mov    %edx,%edi
  80109c:	89 d6                	mov    %edx,%esi
  80109e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010a5:	f3 0f 1e fb          	endbr32 
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	56                   	push   %esi
  8010ad:	53                   	push   %ebx
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  8010b1:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  8010b3:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010b7:	75 11                	jne    8010ca <pgfault+0x25>
  8010b9:	89 f0                	mov    %esi,%eax
  8010bb:	c1 e8 0c             	shr    $0xc,%eax
  8010be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c5:	f6 c4 08             	test   $0x8,%ah
  8010c8:	74 7d                	je     801147 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  8010ca:	e8 5c fd ff ff       	call   800e2b <sys_getenvid>
  8010cf:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	6a 07                	push   $0x7
  8010d6:	68 00 f0 7f 00       	push   $0x7ff000
  8010db:	50                   	push   %eax
  8010dc:	e8 90 fd ff ff       	call   800e71 <sys_page_alloc>
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	78 7a                	js     801162 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  8010e8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  8010ee:	83 ec 04             	sub    $0x4,%esp
  8010f1:	68 00 10 00 00       	push   $0x1000
  8010f6:	56                   	push   %esi
  8010f7:	68 00 f0 7f 00       	push   $0x7ff000
  8010fc:	e8 e4 fa ff ff       	call   800be5 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  801101:	83 c4 08             	add    $0x8,%esp
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	e8 f3 fd ff ff       	call   800efe <sys_page_unmap>
  80110b:	83 c4 10             	add    $0x10,%esp
  80110e:	85 c0                	test   %eax,%eax
  801110:	78 62                	js     801174 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801112:	83 ec 0c             	sub    $0xc,%esp
  801115:	6a 07                	push   $0x7
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
  801119:	68 00 f0 7f 00       	push   $0x7ff000
  80111e:	53                   	push   %ebx
  80111f:	e8 94 fd ff ff       	call   800eb8 <sys_page_map>
  801124:	83 c4 20             	add    $0x20,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 5b                	js     801186 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	68 00 f0 7f 00       	push   $0x7ff000
  801133:	53                   	push   %ebx
  801134:	e8 c5 fd ff ff       	call   800efe <sys_page_unmap>
  801139:	83 c4 10             	add    $0x10,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	78 58                	js     801198 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  801140:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801143:	5b                   	pop    %ebx
  801144:	5e                   	pop    %esi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  801147:	e8 df fc ff ff       	call   800e2b <sys_getenvid>
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	56                   	push   %esi
  801150:	50                   	push   %eax
  801151:	68 4c 2f 80 00       	push   $0x802f4c
  801156:	6a 16                	push   $0x16
  801158:	68 da 2f 80 00       	push   $0x802fda
  80115d:	e8 dc f1 ff ff       	call   80033e <_panic>
        panic("pgfault: page allocation failed %e", r);
  801162:	50                   	push   %eax
  801163:	68 94 2f 80 00       	push   $0x802f94
  801168:	6a 1f                	push   $0x1f
  80116a:	68 da 2f 80 00       	push   $0x802fda
  80116f:	e8 ca f1 ff ff       	call   80033e <_panic>
        panic("pgfault: page unmap failed %e", r);
  801174:	50                   	push   %eax
  801175:	68 e5 2f 80 00       	push   $0x802fe5
  80117a:	6a 24                	push   $0x24
  80117c:	68 da 2f 80 00       	push   $0x802fda
  801181:	e8 b8 f1 ff ff       	call   80033e <_panic>
        panic("pgfault: page map failed %e", r);
  801186:	50                   	push   %eax
  801187:	68 03 30 80 00       	push   $0x803003
  80118c:	6a 26                	push   $0x26
  80118e:	68 da 2f 80 00       	push   $0x802fda
  801193:	e8 a6 f1 ff ff       	call   80033e <_panic>
        panic("pgfault: page unmap failed %e", r);
  801198:	50                   	push   %eax
  801199:	68 e5 2f 80 00       	push   $0x802fe5
  80119e:	6a 28                	push   $0x28
  8011a0:	68 da 2f 80 00       	push   $0x802fda
  8011a5:	e8 94 f1 ff ff       	call   80033e <_panic>

008011aa <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	53                   	push   %ebx
  8011ae:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  8011b1:	89 d3                	mov    %edx,%ebx
  8011b3:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  8011b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  8011bd:	f6 c6 04             	test   $0x4,%dh
  8011c0:	75 62                	jne    801224 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  8011c2:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8011c8:	0f 84 9d 00 00 00    	je     80126b <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8011ce:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8011d4:	8b 52 48             	mov    0x48(%edx),%edx
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	68 05 08 00 00       	push   $0x805
  8011df:	53                   	push   %ebx
  8011e0:	50                   	push   %eax
  8011e1:	53                   	push   %ebx
  8011e2:	52                   	push   %edx
  8011e3:	e8 d0 fc ff ff       	call   800eb8 <sys_page_map>
  8011e8:	83 c4 20             	add    $0x20,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	78 6a                	js     801259 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8011ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8011f4:	8b 50 48             	mov    0x48(%eax),%edx
  8011f7:	8b 40 48             	mov    0x48(%eax),%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	68 05 08 00 00       	push   $0x805
  801202:	53                   	push   %ebx
  801203:	52                   	push   %edx
  801204:	53                   	push   %ebx
  801205:	50                   	push   %eax
  801206:	e8 ad fc ff ff       	call   800eb8 <sys_page_map>
  80120b:	83 c4 20             	add    $0x20,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	79 77                	jns    801289 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801212:	50                   	push   %eax
  801213:	68 b8 2f 80 00       	push   $0x802fb8
  801218:	6a 49                	push   $0x49
  80121a:	68 da 2f 80 00       	push   $0x802fda
  80121f:	e8 1a f1 ff ff       	call   80033e <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801224:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80122a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801236:	52                   	push   %edx
  801237:	53                   	push   %ebx
  801238:	50                   	push   %eax
  801239:	53                   	push   %ebx
  80123a:	51                   	push   %ecx
  80123b:	e8 78 fc ff ff       	call   800eb8 <sys_page_map>
  801240:	83 c4 20             	add    $0x20,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	79 42                	jns    801289 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801247:	50                   	push   %eax
  801248:	68 b8 2f 80 00       	push   $0x802fb8
  80124d:	6a 43                	push   $0x43
  80124f:	68 da 2f 80 00       	push   $0x802fda
  801254:	e8 e5 f0 ff ff       	call   80033e <_panic>
            panic("duppage: page remapping failed %e", r);
  801259:	50                   	push   %eax
  80125a:	68 b8 2f 80 00       	push   $0x802fb8
  80125f:	6a 47                	push   $0x47
  801261:	68 da 2f 80 00       	push   $0x802fda
  801266:	e8 d3 f0 ff ff       	call   80033e <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  80126b:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801271:	8b 52 48             	mov    0x48(%edx),%edx
  801274:	83 ec 0c             	sub    $0xc,%esp
  801277:	6a 05                	push   $0x5
  801279:	53                   	push   %ebx
  80127a:	50                   	push   %eax
  80127b:	53                   	push   %ebx
  80127c:	52                   	push   %edx
  80127d:	e8 36 fc ff ff       	call   800eb8 <sys_page_map>
  801282:	83 c4 20             	add    $0x20,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	78 0a                	js     801293 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801289:	b8 00 00 00 00       	mov    $0x0,%eax
  80128e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801291:	c9                   	leave  
  801292:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801293:	50                   	push   %eax
  801294:	68 b8 2f 80 00       	push   $0x802fb8
  801299:	6a 4c                	push   $0x4c
  80129b:	68 da 2f 80 00       	push   $0x802fda
  8012a0:	e8 99 f0 ff ff       	call   80033e <_panic>

008012a5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012a5:	f3 0f 1e fb          	endbr32 
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8012b1:	68 a5 10 80 00       	push   $0x8010a5
  8012b6:	e8 7d 13 00 00       	call   802638 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012bb:	b8 07 00 00 00       	mov    $0x7,%eax
  8012c0:	cd 30                	int    $0x30
  8012c2:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 12                	js     8012dd <fork+0x38>
  8012cb:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8012cd:	74 20                	je     8012ef <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8012cf:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8012d6:	ba 00 00 80 00       	mov    $0x800000,%edx
  8012db:	eb 42                	jmp    80131f <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8012dd:	50                   	push   %eax
  8012de:	68 1f 30 80 00       	push   $0x80301f
  8012e3:	6a 6a                	push   $0x6a
  8012e5:	68 da 2f 80 00       	push   $0x802fda
  8012ea:	e8 4f f0 ff ff       	call   80033e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8012ef:	e8 37 fb ff ff       	call   800e2b <sys_getenvid>
  8012f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801301:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801306:	e9 8a 00 00 00       	jmp    801395 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  80130b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130e:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801314:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801317:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  80131d:	77 32                	ja     801351 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  80131f:	89 d0                	mov    %edx,%eax
  801321:	c1 e8 16             	shr    $0x16,%eax
  801324:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132b:	a8 01                	test   $0x1,%al
  80132d:	74 dc                	je     80130b <fork+0x66>
  80132f:	c1 ea 0c             	shr    $0xc,%edx
  801332:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801339:	a8 01                	test   $0x1,%al
  80133b:	74 ce                	je     80130b <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80133d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801344:	a8 04                	test   $0x4,%al
  801346:	74 c3                	je     80130b <fork+0x66>
			duppage(envid, PGNUM(addr));
  801348:	89 f0                	mov    %esi,%eax
  80134a:	e8 5b fe ff ff       	call   8011aa <duppage>
  80134f:	eb ba                	jmp    80130b <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801351:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801354:	c1 ea 0c             	shr    $0xc,%edx
  801357:	89 d8                	mov    %ebx,%eax
  801359:	e8 4c fe ff ff       	call   8011aa <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	6a 07                	push   $0x7
  801363:	68 00 f0 bf ee       	push   $0xeebff000
  801368:	53                   	push   %ebx
  801369:	e8 03 fb ff ff       	call   800e71 <sys_page_alloc>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	75 29                	jne    80139e <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801375:	83 ec 08             	sub    $0x8,%esp
  801378:	68 b9 26 80 00       	push   $0x8026b9
  80137d:	53                   	push   %ebx
  80137e:	e8 4d fc ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801383:	83 c4 08             	add    $0x8,%esp
  801386:	6a 02                	push   $0x2
  801388:	53                   	push   %ebx
  801389:	e8 b6 fb ff ff       	call   800f44 <sys_env_set_status>
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	75 1b                	jne    8013b0 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801395:	89 d8                	mov    %ebx,%eax
  801397:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80139a:	5b                   	pop    %ebx
  80139b:	5e                   	pop    %esi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  80139e:	50                   	push   %eax
  80139f:	68 2e 30 80 00       	push   $0x80302e
  8013a4:	6a 7b                	push   $0x7b
  8013a6:	68 da 2f 80 00       	push   $0x802fda
  8013ab:	e8 8e ef ff ff       	call   80033e <_panic>
		panic("sys_env_set_status:%e", r);
  8013b0:	50                   	push   %eax
  8013b1:	68 40 30 80 00       	push   $0x803040
  8013b6:	68 81 00 00 00       	push   $0x81
  8013bb:	68 da 2f 80 00       	push   $0x802fda
  8013c0:	e8 79 ef ff ff       	call   80033e <_panic>

008013c5 <sfork>:

// Challenge!
int
sfork(void)
{
  8013c5:	f3 0f 1e fb          	endbr32 
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013cf:	68 56 30 80 00       	push   $0x803056
  8013d4:	68 8b 00 00 00       	push   $0x8b
  8013d9:	68 da 2f 80 00       	push   $0x802fda
  8013de:	e8 5b ef ff ff       	call   80033e <_panic>

008013e3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013e3:	f3 0f 1e fb          	endbr32 
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	05 00 00 00 30       	add    $0x30000000,%eax
  8013f2:	c1 e8 0c             	shr    $0xc,%eax
}
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013f7:	f3 0f 1e fb          	endbr32 
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80140b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801412:	f3 0f 1e fb          	endbr32 
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80141e:	89 c2                	mov    %eax,%edx
  801420:	c1 ea 16             	shr    $0x16,%edx
  801423:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80142a:	f6 c2 01             	test   $0x1,%dl
  80142d:	74 2d                	je     80145c <fd_alloc+0x4a>
  80142f:	89 c2                	mov    %eax,%edx
  801431:	c1 ea 0c             	shr    $0xc,%edx
  801434:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80143b:	f6 c2 01             	test   $0x1,%dl
  80143e:	74 1c                	je     80145c <fd_alloc+0x4a>
  801440:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801445:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80144a:	75 d2                	jne    80141e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801455:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80145a:	eb 0a                	jmp    801466 <fd_alloc+0x54>
			*fd_store = fd;
  80145c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801468:	f3 0f 1e fb          	endbr32 
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801472:	83 f8 1f             	cmp    $0x1f,%eax
  801475:	77 30                	ja     8014a7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801477:	c1 e0 0c             	shl    $0xc,%eax
  80147a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80147f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801485:	f6 c2 01             	test   $0x1,%dl
  801488:	74 24                	je     8014ae <fd_lookup+0x46>
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	c1 ea 0c             	shr    $0xc,%edx
  80148f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801496:	f6 c2 01             	test   $0x1,%dl
  801499:	74 1a                	je     8014b5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	89 02                	mov    %eax,(%edx)
	return 0;
  8014a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    
		return -E_INVAL;
  8014a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ac:	eb f7                	jmp    8014a5 <fd_lookup+0x3d>
		return -E_INVAL;
  8014ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b3:	eb f0                	jmp    8014a5 <fd_lookup+0x3d>
  8014b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ba:	eb e9                	jmp    8014a5 <fd_lookup+0x3d>

008014bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014bc:	f3 0f 1e fb          	endbr32 
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ce:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014d3:	39 08                	cmp    %ecx,(%eax)
  8014d5:	74 38                	je     80150f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8014d7:	83 c2 01             	add    $0x1,%edx
  8014da:	8b 04 95 e8 30 80 00 	mov    0x8030e8(,%edx,4),%eax
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 ee                	jne    8014d3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014e5:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ea:	8b 40 48             	mov    0x48(%eax),%eax
  8014ed:	83 ec 04             	sub    $0x4,%esp
  8014f0:	51                   	push   %ecx
  8014f1:	50                   	push   %eax
  8014f2:	68 6c 30 80 00       	push   $0x80306c
  8014f7:	e8 29 ef ff ff       	call   800425 <cprintf>
	*dev = 0;
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    
			*dev = devtab[i];
  80150f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801512:	89 01                	mov    %eax,(%ecx)
			return 0;
  801514:	b8 00 00 00 00       	mov    $0x0,%eax
  801519:	eb f2                	jmp    80150d <dev_lookup+0x51>

0080151b <fd_close>:
{
  80151b:	f3 0f 1e fb          	endbr32 
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	57                   	push   %edi
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	83 ec 24             	sub    $0x24,%esp
  801528:	8b 75 08             	mov    0x8(%ebp),%esi
  80152b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80152e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801531:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801532:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801538:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80153b:	50                   	push   %eax
  80153c:	e8 27 ff ff ff       	call   801468 <fd_lookup>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 05                	js     80154f <fd_close+0x34>
	    || fd != fd2)
  80154a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80154d:	74 16                	je     801565 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80154f:	89 f8                	mov    %edi,%eax
  801551:	84 c0                	test   %al,%al
  801553:	b8 00 00 00 00       	mov    $0x0,%eax
  801558:	0f 44 d8             	cmove  %eax,%ebx
}
  80155b:	89 d8                	mov    %ebx,%eax
  80155d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5f                   	pop    %edi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801565:	83 ec 08             	sub    $0x8,%esp
  801568:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80156b:	50                   	push   %eax
  80156c:	ff 36                	pushl  (%esi)
  80156e:	e8 49 ff ff ff       	call   8014bc <dev_lookup>
  801573:	89 c3                	mov    %eax,%ebx
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	78 1a                	js     801596 <fd_close+0x7b>
		if (dev->dev_close)
  80157c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801582:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801587:	85 c0                	test   %eax,%eax
  801589:	74 0b                	je     801596 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	56                   	push   %esi
  80158f:	ff d0                	call   *%eax
  801591:	89 c3                	mov    %eax,%ebx
  801593:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801596:	83 ec 08             	sub    $0x8,%esp
  801599:	56                   	push   %esi
  80159a:	6a 00                	push   $0x0
  80159c:	e8 5d f9 ff ff       	call   800efe <sys_page_unmap>
	return r;
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	eb b5                	jmp    80155b <fd_close+0x40>

008015a6 <close>:

int
close(int fdnum)
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b3:	50                   	push   %eax
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	e8 ac fe ff ff       	call   801468 <fd_lookup>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	79 02                	jns    8015c5 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    
		return fd_close(fd, 1);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	6a 01                	push   $0x1
  8015ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cd:	e8 49 ff ff ff       	call   80151b <fd_close>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	eb ec                	jmp    8015c3 <close+0x1d>

008015d7 <close_all>:

void
close_all(void)
{
  8015d7:	f3 0f 1e fb          	endbr32 
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	53                   	push   %ebx
  8015eb:	e8 b6 ff ff ff       	call   8015a6 <close>
	for (i = 0; i < MAXFD; i++)
  8015f0:	83 c3 01             	add    $0x1,%ebx
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	83 fb 20             	cmp    $0x20,%ebx
  8015f9:	75 ec                	jne    8015e7 <close_all+0x10>
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801600:	f3 0f 1e fb          	endbr32 
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	57                   	push   %edi
  801608:	56                   	push   %esi
  801609:	53                   	push   %ebx
  80160a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80160d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	e8 4f fe ff ff       	call   801468 <fd_lookup>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	0f 88 81 00 00 00    	js     8016a7 <dup+0xa7>
		return r;
	close(newfdnum);
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	e8 75 ff ff ff       	call   8015a6 <close>

	newfd = INDEX2FD(newfdnum);
  801631:	8b 75 0c             	mov    0xc(%ebp),%esi
  801634:	c1 e6 0c             	shl    $0xc,%esi
  801637:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80163d:	83 c4 04             	add    $0x4,%esp
  801640:	ff 75 e4             	pushl  -0x1c(%ebp)
  801643:	e8 af fd ff ff       	call   8013f7 <fd2data>
  801648:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80164a:	89 34 24             	mov    %esi,(%esp)
  80164d:	e8 a5 fd ff ff       	call   8013f7 <fd2data>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801657:	89 d8                	mov    %ebx,%eax
  801659:	c1 e8 16             	shr    $0x16,%eax
  80165c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801663:	a8 01                	test   $0x1,%al
  801665:	74 11                	je     801678 <dup+0x78>
  801667:	89 d8                	mov    %ebx,%eax
  801669:	c1 e8 0c             	shr    $0xc,%eax
  80166c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801673:	f6 c2 01             	test   $0x1,%dl
  801676:	75 39                	jne    8016b1 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80167b:	89 d0                	mov    %edx,%eax
  80167d:	c1 e8 0c             	shr    $0xc,%eax
  801680:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801687:	83 ec 0c             	sub    $0xc,%esp
  80168a:	25 07 0e 00 00       	and    $0xe07,%eax
  80168f:	50                   	push   %eax
  801690:	56                   	push   %esi
  801691:	6a 00                	push   $0x0
  801693:	52                   	push   %edx
  801694:	6a 00                	push   $0x0
  801696:	e8 1d f8 ff ff       	call   800eb8 <sys_page_map>
  80169b:	89 c3                	mov    %eax,%ebx
  80169d:	83 c4 20             	add    $0x20,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 31                	js     8016d5 <dup+0xd5>
		goto err;

	return newfdnum;
  8016a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016a7:	89 d8                	mov    %ebx,%eax
  8016a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ac:	5b                   	pop    %ebx
  8016ad:	5e                   	pop    %esi
  8016ae:	5f                   	pop    %edi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8016c0:	50                   	push   %eax
  8016c1:	57                   	push   %edi
  8016c2:	6a 00                	push   $0x0
  8016c4:	53                   	push   %ebx
  8016c5:	6a 00                	push   $0x0
  8016c7:	e8 ec f7 ff ff       	call   800eb8 <sys_page_map>
  8016cc:	89 c3                	mov    %eax,%ebx
  8016ce:	83 c4 20             	add    $0x20,%esp
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	79 a3                	jns    801678 <dup+0x78>
	sys_page_unmap(0, newfd);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	56                   	push   %esi
  8016d9:	6a 00                	push   $0x0
  8016db:	e8 1e f8 ff ff       	call   800efe <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016e0:	83 c4 08             	add    $0x8,%esp
  8016e3:	57                   	push   %edi
  8016e4:	6a 00                	push   $0x0
  8016e6:	e8 13 f8 ff ff       	call   800efe <sys_page_unmap>
	return r;
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	eb b7                	jmp    8016a7 <dup+0xa7>

008016f0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016f0:	f3 0f 1e fb          	endbr32 
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 1c             	sub    $0x1c,%esp
  8016fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801701:	50                   	push   %eax
  801702:	53                   	push   %ebx
  801703:	e8 60 fd ff ff       	call   801468 <fd_lookup>
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 3f                	js     80174e <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80170f:	83 ec 08             	sub    $0x8,%esp
  801712:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801715:	50                   	push   %eax
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	ff 30                	pushl  (%eax)
  80171b:	e8 9c fd ff ff       	call   8014bc <dev_lookup>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 27                	js     80174e <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801727:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80172a:	8b 42 08             	mov    0x8(%edx),%eax
  80172d:	83 e0 03             	and    $0x3,%eax
  801730:	83 f8 01             	cmp    $0x1,%eax
  801733:	74 1e                	je     801753 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801738:	8b 40 08             	mov    0x8(%eax),%eax
  80173b:	85 c0                	test   %eax,%eax
  80173d:	74 35                	je     801774 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	ff 75 10             	pushl  0x10(%ebp)
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	52                   	push   %edx
  801749:	ff d0                	call   *%eax
  80174b:	83 c4 10             	add    $0x10,%esp
}
  80174e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801751:	c9                   	leave  
  801752:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801753:	a1 08 50 80 00       	mov    0x805008,%eax
  801758:	8b 40 48             	mov    0x48(%eax),%eax
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	53                   	push   %ebx
  80175f:	50                   	push   %eax
  801760:	68 ad 30 80 00       	push   $0x8030ad
  801765:	e8 bb ec ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801772:	eb da                	jmp    80174e <read+0x5e>
		return -E_NOT_SUPP;
  801774:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801779:	eb d3                	jmp    80174e <read+0x5e>

0080177b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80177b:	f3 0f 1e fb          	endbr32 
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	57                   	push   %edi
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	8b 7d 08             	mov    0x8(%ebp),%edi
  80178b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80178e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801793:	eb 02                	jmp    801797 <readn+0x1c>
  801795:	01 c3                	add    %eax,%ebx
  801797:	39 f3                	cmp    %esi,%ebx
  801799:	73 21                	jae    8017bc <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	89 f0                	mov    %esi,%eax
  8017a0:	29 d8                	sub    %ebx,%eax
  8017a2:	50                   	push   %eax
  8017a3:	89 d8                	mov    %ebx,%eax
  8017a5:	03 45 0c             	add    0xc(%ebp),%eax
  8017a8:	50                   	push   %eax
  8017a9:	57                   	push   %edi
  8017aa:	e8 41 ff ff ff       	call   8016f0 <read>
		if (m < 0)
  8017af:	83 c4 10             	add    $0x10,%esp
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	78 04                	js     8017ba <readn+0x3f>
			return m;
		if (m == 0)
  8017b6:	75 dd                	jne    801795 <readn+0x1a>
  8017b8:	eb 02                	jmp    8017bc <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017ba:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5f                   	pop    %edi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c6:	f3 0f 1e fb          	endbr32 
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 1c             	sub    $0x1c,%esp
  8017d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	53                   	push   %ebx
  8017d9:	e8 8a fc ff ff       	call   801468 <fd_lookup>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 3a                	js     80181f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e5:	83 ec 08             	sub    $0x8,%esp
  8017e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ef:	ff 30                	pushl  (%eax)
  8017f1:	e8 c6 fc ff ff       	call   8014bc <dev_lookup>
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 22                	js     80181f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801800:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801804:	74 1e                	je     801824 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801809:	8b 52 0c             	mov    0xc(%edx),%edx
  80180c:	85 d2                	test   %edx,%edx
  80180e:	74 35                	je     801845 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	ff 75 10             	pushl  0x10(%ebp)
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	50                   	push   %eax
  80181a:	ff d2                	call   *%edx
  80181c:	83 c4 10             	add    $0x10,%esp
}
  80181f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801822:	c9                   	leave  
  801823:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801824:	a1 08 50 80 00       	mov    0x805008,%eax
  801829:	8b 40 48             	mov    0x48(%eax),%eax
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	53                   	push   %ebx
  801830:	50                   	push   %eax
  801831:	68 c9 30 80 00       	push   $0x8030c9
  801836:	e8 ea eb ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801843:	eb da                	jmp    80181f <write+0x59>
		return -E_NOT_SUPP;
  801845:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184a:	eb d3                	jmp    80181f <write+0x59>

0080184c <seek>:

int
seek(int fdnum, off_t offset)
{
  80184c:	f3 0f 1e fb          	endbr32 
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	e8 06 fc ff ff       	call   801468 <fd_lookup>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	85 c0                	test   %eax,%eax
  801867:	78 0e                	js     801877 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801879:	f3 0f 1e fb          	endbr32 
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	53                   	push   %ebx
  801881:	83 ec 1c             	sub    $0x1c,%esp
  801884:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801887:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188a:	50                   	push   %eax
  80188b:	53                   	push   %ebx
  80188c:	e8 d7 fb ff ff       	call   801468 <fd_lookup>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	78 37                	js     8018cf <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189e:	50                   	push   %eax
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	ff 30                	pushl  (%eax)
  8018a4:	e8 13 fc ff ff       	call   8014bc <dev_lookup>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 1f                	js     8018cf <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018b7:	74 1b                	je     8018d4 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bc:	8b 52 18             	mov    0x18(%edx),%edx
  8018bf:	85 d2                	test   %edx,%edx
  8018c1:	74 32                	je     8018f5 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	50                   	push   %eax
  8018ca:	ff d2                	call   *%edx
  8018cc:	83 c4 10             	add    $0x10,%esp
}
  8018cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018d4:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018d9:	8b 40 48             	mov    0x48(%eax),%eax
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	53                   	push   %ebx
  8018e0:	50                   	push   %eax
  8018e1:	68 8c 30 80 00       	push   $0x80308c
  8018e6:	e8 3a eb ff ff       	call   800425 <cprintf>
		return -E_INVAL;
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f3:	eb da                	jmp    8018cf <ftruncate+0x56>
		return -E_NOT_SUPP;
  8018f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018fa:	eb d3                	jmp    8018cf <ftruncate+0x56>

008018fc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018fc:	f3 0f 1e fb          	endbr32 
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
  801904:	83 ec 1c             	sub    $0x1c,%esp
  801907:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80190d:	50                   	push   %eax
  80190e:	ff 75 08             	pushl  0x8(%ebp)
  801911:	e8 52 fb ff ff       	call   801468 <fd_lookup>
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	78 4b                	js     801968 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801923:	50                   	push   %eax
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	ff 30                	pushl  (%eax)
  801929:	e8 8e fb ff ff       	call   8014bc <dev_lookup>
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	85 c0                	test   %eax,%eax
  801933:	78 33                	js     801968 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801938:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80193c:	74 2f                	je     80196d <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80193e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801941:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801948:	00 00 00 
	stat->st_isdir = 0;
  80194b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801952:	00 00 00 
	stat->st_dev = dev;
  801955:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80195b:	83 ec 08             	sub    $0x8,%esp
  80195e:	53                   	push   %ebx
  80195f:	ff 75 f0             	pushl  -0x10(%ebp)
  801962:	ff 50 14             	call   *0x14(%eax)
  801965:	83 c4 10             	add    $0x10,%esp
}
  801968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    
		return -E_NOT_SUPP;
  80196d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801972:	eb f4                	jmp    801968 <fstat+0x6c>

00801974 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801974:	f3 0f 1e fb          	endbr32 
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	6a 00                	push   $0x0
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	e8 fb 01 00 00       	call   801b85 <open>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 1b                	js     8019ae <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801993:	83 ec 08             	sub    $0x8,%esp
  801996:	ff 75 0c             	pushl  0xc(%ebp)
  801999:	50                   	push   %eax
  80199a:	e8 5d ff ff ff       	call   8018fc <fstat>
  80199f:	89 c6                	mov    %eax,%esi
	close(fd);
  8019a1:	89 1c 24             	mov    %ebx,(%esp)
  8019a4:	e8 fd fb ff ff       	call   8015a6 <close>
	return r;
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	89 f3                	mov    %esi,%ebx
}
  8019ae:	89 d8                	mov    %ebx,%eax
  8019b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5d                   	pop    %ebp
  8019b6:	c3                   	ret    

008019b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	89 c6                	mov    %eax,%esi
  8019be:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019c0:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019c7:	74 27                	je     8019f0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019c9:	6a 07                	push   $0x7
  8019cb:	68 00 60 80 00       	push   $0x806000
  8019d0:	56                   	push   %esi
  8019d1:	ff 35 00 50 80 00    	pushl  0x805000
  8019d7:	e8 75 0d 00 00       	call   802751 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019dc:	83 c4 0c             	add    $0xc,%esp
  8019df:	6a 00                	push   $0x0
  8019e1:	53                   	push   %ebx
  8019e2:	6a 00                	push   $0x0
  8019e4:	e8 f4 0c 00 00       	call   8026dd <ipc_recv>
}
  8019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ec:	5b                   	pop    %ebx
  8019ed:	5e                   	pop    %esi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019f0:	83 ec 0c             	sub    $0xc,%esp
  8019f3:	6a 01                	push   $0x1
  8019f5:	e8 af 0d 00 00       	call   8027a9 <ipc_find_env>
  8019fa:	a3 00 50 80 00       	mov    %eax,0x805000
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	eb c5                	jmp    8019c9 <fsipc+0x12>

00801a04 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a04:	f3 0f 1e fb          	endbr32 
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8b 40 0c             	mov    0xc(%eax),%eax
  801a14:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a21:	ba 00 00 00 00       	mov    $0x0,%edx
  801a26:	b8 02 00 00 00       	mov    $0x2,%eax
  801a2b:	e8 87 ff ff ff       	call   8019b7 <fsipc>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <devfile_flush>:
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a42:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a47:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4c:	b8 06 00 00 00       	mov    $0x6,%eax
  801a51:	e8 61 ff ff ff       	call   8019b7 <fsipc>
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <devfile_stat>:
{
  801a58:	f3 0f 1e fb          	endbr32 
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 04             	sub    $0x4,%esp
  801a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a71:	ba 00 00 00 00       	mov    $0x0,%edx
  801a76:	b8 05 00 00 00       	mov    $0x5,%eax
  801a7b:	e8 37 ff ff ff       	call   8019b7 <fsipc>
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 2c                	js     801ab0 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	68 00 60 80 00       	push   $0x806000
  801a8c:	53                   	push   %ebx
  801a8d:	e8 9d ef ff ff       	call   800a2f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a92:	a1 80 60 80 00       	mov    0x806080,%eax
  801a97:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a9d:	a1 84 60 80 00       	mov    0x806084,%eax
  801aa2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <devfile_write>:
{
  801ab5:	f3 0f 1e fb          	endbr32 
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ac5:	8b 52 0c             	mov    0xc(%edx),%edx
  801ac8:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801ace:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad3:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ad8:	0f 47 c2             	cmova  %edx,%eax
  801adb:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ae0:	50                   	push   %eax
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	68 08 60 80 00       	push   $0x806008
  801ae9:	e8 f7 f0 ff ff       	call   800be5 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801aee:	ba 00 00 00 00       	mov    $0x0,%edx
  801af3:	b8 04 00 00 00       	mov    $0x4,%eax
  801af8:	e8 ba fe ff ff       	call   8019b7 <fsipc>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <devfile_read>:
{
  801aff:	f3 0f 1e fb          	endbr32 
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b11:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b16:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b21:	b8 03 00 00 00       	mov    $0x3,%eax
  801b26:	e8 8c fe ff ff       	call   8019b7 <fsipc>
  801b2b:	89 c3                	mov    %eax,%ebx
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 1f                	js     801b50 <devfile_read+0x51>
	assert(r <= n);
  801b31:	39 f0                	cmp    %esi,%eax
  801b33:	77 24                	ja     801b59 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b35:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b3a:	7f 33                	jg     801b6f <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b3c:	83 ec 04             	sub    $0x4,%esp
  801b3f:	50                   	push   %eax
  801b40:	68 00 60 80 00       	push   $0x806000
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	e8 98 f0 ff ff       	call   800be5 <memmove>
	return r;
  801b4d:	83 c4 10             	add    $0x10,%esp
}
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
	assert(r <= n);
  801b59:	68 fc 30 80 00       	push   $0x8030fc
  801b5e:	68 03 31 80 00       	push   $0x803103
  801b63:	6a 7c                	push   $0x7c
  801b65:	68 18 31 80 00       	push   $0x803118
  801b6a:	e8 cf e7 ff ff       	call   80033e <_panic>
	assert(r <= PGSIZE);
  801b6f:	68 23 31 80 00       	push   $0x803123
  801b74:	68 03 31 80 00       	push   $0x803103
  801b79:	6a 7d                	push   $0x7d
  801b7b:	68 18 31 80 00       	push   $0x803118
  801b80:	e8 b9 e7 ff ff       	call   80033e <_panic>

00801b85 <open>:
{
  801b85:	f3 0f 1e fb          	endbr32 
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	56                   	push   %esi
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 1c             	sub    $0x1c,%esp
  801b91:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b94:	56                   	push   %esi
  801b95:	e8 52 ee ff ff       	call   8009ec <strlen>
  801b9a:	83 c4 10             	add    $0x10,%esp
  801b9d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ba2:	7f 6c                	jg     801c10 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801baa:	50                   	push   %eax
  801bab:	e8 62 f8 ff ff       	call   801412 <fd_alloc>
  801bb0:	89 c3                	mov    %eax,%ebx
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 3c                	js     801bf5 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	56                   	push   %esi
  801bbd:	68 00 60 80 00       	push   $0x806000
  801bc2:	e8 68 ee ff ff       	call   800a2f <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	e8 db fd ff ff       	call   8019b7 <fsipc>
  801bdc:	89 c3                	mov    %eax,%ebx
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	85 c0                	test   %eax,%eax
  801be3:	78 19                	js     801bfe <open+0x79>
	return fd2num(fd);
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	ff 75 f4             	pushl  -0xc(%ebp)
  801beb:	e8 f3 f7 ff ff       	call   8013e3 <fd2num>
  801bf0:	89 c3                	mov    %eax,%ebx
  801bf2:	83 c4 10             	add    $0x10,%esp
}
  801bf5:	89 d8                	mov    %ebx,%eax
  801bf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    
		fd_close(fd, 0);
  801bfe:	83 ec 08             	sub    $0x8,%esp
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 f4             	pushl  -0xc(%ebp)
  801c06:	e8 10 f9 ff ff       	call   80151b <fd_close>
		return r;
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	eb e5                	jmp    801bf5 <open+0x70>
		return -E_BAD_PATH;
  801c10:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c15:	eb de                	jmp    801bf5 <open+0x70>

00801c17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c17:	f3 0f 1e fb          	endbr32 
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c21:	ba 00 00 00 00       	mov    $0x0,%edx
  801c26:	b8 08 00 00 00       	mov    $0x8,%eax
  801c2b:	e8 87 fd ff ff       	call   8019b7 <fsipc>
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c32:	f3 0f 1e fb          	endbr32 
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c3c:	68 2f 31 80 00       	push   $0x80312f
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	e8 e6 ed ff ff       	call   800a2f <strcpy>
	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <devsock_close>:
{
  801c50:	f3 0f 1e fb          	endbr32 
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	53                   	push   %ebx
  801c58:	83 ec 10             	sub    $0x10,%esp
  801c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c5e:	53                   	push   %ebx
  801c5f:	e8 82 0b 00 00       	call   8027e6 <pageref>
  801c64:	89 c2                	mov    %eax,%edx
  801c66:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c6e:	83 fa 01             	cmp    $0x1,%edx
  801c71:	74 05                	je     801c78 <devsock_close+0x28>
}
  801c73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	ff 73 0c             	pushl  0xc(%ebx)
  801c7e:	e8 e3 02 00 00       	call   801f66 <nsipc_close>
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	eb eb                	jmp    801c73 <devsock_close+0x23>

00801c88 <devsock_write>:
{
  801c88:	f3 0f 1e fb          	endbr32 
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	ff 75 10             	pushl  0x10(%ebp)
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	ff 70 0c             	pushl  0xc(%eax)
  801ca0:	e8 b5 03 00 00       	call   80205a <nsipc_send>
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <devsock_read>:
{
  801ca7:	f3 0f 1e fb          	endbr32 
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	ff 75 10             	pushl  0x10(%ebp)
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	ff 70 0c             	pushl  0xc(%eax)
  801cbf:	e8 1f 03 00 00       	call   801fe3 <nsipc_recv>
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <fd2sockid>:
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ccc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	e8 92 f7 ff ff       	call   801468 <fd_lookup>
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	78 10                	js     801ced <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801ce6:	39 08                	cmp    %ecx,(%eax)
  801ce8:	75 05                	jne    801cef <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801cea:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    
		return -E_NOT_SUPP;
  801cef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cf4:	eb f7                	jmp    801ced <fd2sockid+0x27>

00801cf6 <alloc_sockfd>:
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 1c             	sub    $0x1c,%esp
  801cfe:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d03:	50                   	push   %eax
  801d04:	e8 09 f7 ff ff       	call   801412 <fd_alloc>
  801d09:	89 c3                	mov    %eax,%ebx
  801d0b:	83 c4 10             	add    $0x10,%esp
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 43                	js     801d55 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	68 07 04 00 00       	push   $0x407
  801d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1d:	6a 00                	push   $0x0
  801d1f:	e8 4d f1 ff ff       	call   800e71 <sys_page_alloc>
  801d24:	89 c3                	mov    %eax,%ebx
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	85 c0                	test   %eax,%eax
  801d2b:	78 28                	js     801d55 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d30:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801d36:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d42:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	50                   	push   %eax
  801d49:	e8 95 f6 ff ff       	call   8013e3 <fd2num>
  801d4e:	89 c3                	mov    %eax,%ebx
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	eb 0c                	jmp    801d61 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d55:	83 ec 0c             	sub    $0xc,%esp
  801d58:	56                   	push   %esi
  801d59:	e8 08 02 00 00       	call   801f66 <nsipc_close>
		return r;
  801d5e:	83 c4 10             	add    $0x10,%esp
}
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <accept>:
{
  801d6a:	f3 0f 1e fb          	endbr32 
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	e8 4a ff ff ff       	call   801cc6 <fd2sockid>
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	78 1b                	js     801d9b <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d80:	83 ec 04             	sub    $0x4,%esp
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	ff 75 0c             	pushl  0xc(%ebp)
  801d89:	50                   	push   %eax
  801d8a:	e8 22 01 00 00       	call   801eb1 <nsipc_accept>
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 05                	js     801d9b <accept+0x31>
	return alloc_sockfd(r);
  801d96:	e8 5b ff ff ff       	call   801cf6 <alloc_sockfd>
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <bind>:
{
  801d9d:	f3 0f 1e fb          	endbr32 
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	e8 17 ff ff ff       	call   801cc6 <fd2sockid>
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 12                	js     801dc5 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801db3:	83 ec 04             	sub    $0x4,%esp
  801db6:	ff 75 10             	pushl  0x10(%ebp)
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	50                   	push   %eax
  801dbd:	e8 45 01 00 00       	call   801f07 <nsipc_bind>
  801dc2:	83 c4 10             	add    $0x10,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <shutdown>:
{
  801dc7:	f3 0f 1e fb          	endbr32 
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	e8 ed fe ff ff       	call   801cc6 <fd2sockid>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	78 0f                	js     801dec <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ddd:	83 ec 08             	sub    $0x8,%esp
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	50                   	push   %eax
  801de4:	e8 57 01 00 00       	call   801f40 <nsipc_shutdown>
  801de9:	83 c4 10             	add    $0x10,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <connect>:
{
  801dee:	f3 0f 1e fb          	endbr32 
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	e8 c6 fe ff ff       	call   801cc6 <fd2sockid>
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 12                	js     801e16 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	ff 75 10             	pushl  0x10(%ebp)
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	50                   	push   %eax
  801e0e:	e8 71 01 00 00       	call   801f84 <nsipc_connect>
  801e13:	83 c4 10             	add    $0x10,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <listen>:
{
  801e18:	f3 0f 1e fb          	endbr32 
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	e8 9c fe ff ff       	call   801cc6 <fd2sockid>
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 0f                	js     801e3d <listen+0x25>
	return nsipc_listen(r, backlog);
  801e2e:	83 ec 08             	sub    $0x8,%esp
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	50                   	push   %eax
  801e35:	e8 83 01 00 00       	call   801fbd <nsipc_listen>
  801e3a:	83 c4 10             	add    $0x10,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <socket>:

int
socket(int domain, int type, int protocol)
{
  801e3f:	f3 0f 1e fb          	endbr32 
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e49:	ff 75 10             	pushl  0x10(%ebp)
  801e4c:	ff 75 0c             	pushl  0xc(%ebp)
  801e4f:	ff 75 08             	pushl  0x8(%ebp)
  801e52:	e8 65 02 00 00       	call   8020bc <nsipc_socket>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 05                	js     801e63 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e5e:	e8 93 fe ff ff       	call   801cf6 <alloc_sockfd>
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	53                   	push   %ebx
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e6e:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e75:	74 26                	je     801e9d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e77:	6a 07                	push   $0x7
  801e79:	68 00 70 80 00       	push   $0x807000
  801e7e:	53                   	push   %ebx
  801e7f:	ff 35 04 50 80 00    	pushl  0x805004
  801e85:	e8 c7 08 00 00       	call   802751 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e8a:	83 c4 0c             	add    $0xc,%esp
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	e8 45 08 00 00       	call   8026dd <ipc_recv>
}
  801e98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	6a 02                	push   $0x2
  801ea2:	e8 02 09 00 00       	call   8027a9 <ipc_find_env>
  801ea7:	a3 04 50 80 00       	mov    %eax,0x805004
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	eb c6                	jmp    801e77 <nsipc+0x12>

00801eb1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eb1:	f3 0f 1e fb          	endbr32 
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	56                   	push   %esi
  801eb9:	53                   	push   %ebx
  801eba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ec5:	8b 06                	mov    (%esi),%eax
  801ec7:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ecc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed1:	e8 8f ff ff ff       	call   801e65 <nsipc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	79 09                	jns    801ee5 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	ff 35 10 70 80 00    	pushl  0x807010
  801eee:	68 00 70 80 00       	push   $0x807000
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	e8 ea ec ff ff       	call   800be5 <memmove>
		*addrlen = ret->ret_addrlen;
  801efb:	a1 10 70 80 00       	mov    0x807010,%eax
  801f00:	89 06                	mov    %eax,(%esi)
  801f02:	83 c4 10             	add    $0x10,%esp
	return r;
  801f05:	eb d5                	jmp    801edc <nsipc_accept+0x2b>

00801f07 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f07:	f3 0f 1e fb          	endbr32 
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 08             	sub    $0x8,%esp
  801f12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f1d:	53                   	push   %ebx
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	68 04 70 80 00       	push   $0x807004
  801f26:	e8 ba ec ff ff       	call   800be5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f2b:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f31:	b8 02 00 00 00       	mov    $0x2,%eax
  801f36:	e8 2a ff ff ff       	call   801e65 <nsipc>
}
  801f3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f55:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f5a:	b8 03 00 00 00       	mov    $0x3,%eax
  801f5f:	e8 01 ff ff ff       	call   801e65 <nsipc>
}
  801f64:	c9                   	leave  
  801f65:	c3                   	ret    

00801f66 <nsipc_close>:

int
nsipc_close(int s)
{
  801f66:	f3 0f 1e fb          	endbr32 
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f78:	b8 04 00 00 00       	mov    $0x4,%eax
  801f7d:	e8 e3 fe ff ff       	call   801e65 <nsipc>
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f84:	f3 0f 1e fb          	endbr32 
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 08             	sub    $0x8,%esp
  801f8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f9a:	53                   	push   %ebx
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	68 04 70 80 00       	push   $0x807004
  801fa3:	e8 3d ec ff ff       	call   800be5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fa8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fae:	b8 05 00 00 00       	mov    $0x5,%eax
  801fb3:	e8 ad fe ff ff       	call   801e65 <nsipc>
}
  801fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd2:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801fd7:	b8 06 00 00 00       	mov    $0x6,%eax
  801fdc:	e8 84 fe ff ff       	call   801e65 <nsipc>
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fe3:	f3 0f 1e fb          	endbr32 
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	56                   	push   %esi
  801feb:	53                   	push   %ebx
  801fec:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801ff7:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  802000:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802005:	b8 07 00 00 00       	mov    $0x7,%eax
  80200a:	e8 56 fe ff ff       	call   801e65 <nsipc>
  80200f:	89 c3                	mov    %eax,%ebx
  802011:	85 c0                	test   %eax,%eax
  802013:	78 26                	js     80203b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802015:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80201b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802020:	0f 4e c6             	cmovle %esi,%eax
  802023:	39 c3                	cmp    %eax,%ebx
  802025:	7f 1d                	jg     802044 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	53                   	push   %ebx
  80202b:	68 00 70 80 00       	push   $0x807000
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	e8 ad eb ff ff       	call   800be5 <memmove>
  802038:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80203b:	89 d8                	mov    %ebx,%eax
  80203d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802044:	68 3b 31 80 00       	push   $0x80313b
  802049:	68 03 31 80 00       	push   $0x803103
  80204e:	6a 62                	push   $0x62
  802050:	68 50 31 80 00       	push   $0x803150
  802055:	e8 e4 e2 ff ff       	call   80033e <_panic>

0080205a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80205a:	f3 0f 1e fb          	endbr32 
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	53                   	push   %ebx
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802070:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802076:	7f 2e                	jg     8020a6 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	53                   	push   %ebx
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	68 0c 70 80 00       	push   $0x80700c
  802084:	e8 5c eb ff ff       	call   800be5 <memmove>
	nsipcbuf.send.req_size = size;
  802089:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80208f:	8b 45 14             	mov    0x14(%ebp),%eax
  802092:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802097:	b8 08 00 00 00       	mov    $0x8,%eax
  80209c:	e8 c4 fd ff ff       	call   801e65 <nsipc>
}
  8020a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    
	assert(size < 1600);
  8020a6:	68 5c 31 80 00       	push   $0x80315c
  8020ab:	68 03 31 80 00       	push   $0x803103
  8020b0:	6a 6d                	push   $0x6d
  8020b2:	68 50 31 80 00       	push   $0x803150
  8020b7:	e8 82 e2 ff ff       	call   80033e <_panic>

008020bc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020bc:	f3 0f 1e fb          	endbr32 
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d1:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8020d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8020de:	b8 09 00 00 00       	mov    $0x9,%eax
  8020e3:	e8 7d fd ff ff       	call   801e65 <nsipc>
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020ea:	f3 0f 1e fb          	endbr32 
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	56                   	push   %esi
  8020f2:	53                   	push   %ebx
  8020f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	e8 f6 f2 ff ff       	call   8013f7 <fd2data>
  802101:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802103:	83 c4 08             	add    $0x8,%esp
  802106:	68 68 31 80 00       	push   $0x803168
  80210b:	53                   	push   %ebx
  80210c:	e8 1e e9 ff ff       	call   800a2f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802111:	8b 46 04             	mov    0x4(%esi),%eax
  802114:	2b 06                	sub    (%esi),%eax
  802116:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80211c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802123:	00 00 00 
	stat->st_dev = &devpipe;
  802126:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80212d:	40 80 00 
	return 0;
}
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
  802135:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802138:	5b                   	pop    %ebx
  802139:	5e                   	pop    %esi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80213c:	f3 0f 1e fb          	endbr32 
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	53                   	push   %ebx
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80214a:	53                   	push   %ebx
  80214b:	6a 00                	push   $0x0
  80214d:	e8 ac ed ff ff       	call   800efe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802152:	89 1c 24             	mov    %ebx,(%esp)
  802155:	e8 9d f2 ff ff       	call   8013f7 <fd2data>
  80215a:	83 c4 08             	add    $0x8,%esp
  80215d:	50                   	push   %eax
  80215e:	6a 00                	push   $0x0
  802160:	e8 99 ed ff ff       	call   800efe <sys_page_unmap>
}
  802165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <_pipeisclosed>:
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 1c             	sub    $0x1c,%esp
  802173:	89 c7                	mov    %eax,%edi
  802175:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802177:	a1 08 50 80 00       	mov    0x805008,%eax
  80217c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	57                   	push   %edi
  802183:	e8 5e 06 00 00       	call   8027e6 <pageref>
  802188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80218b:	89 34 24             	mov    %esi,(%esp)
  80218e:	e8 53 06 00 00       	call   8027e6 <pageref>
		nn = thisenv->env_runs;
  802193:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802199:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80219c:	83 c4 10             	add    $0x10,%esp
  80219f:	39 cb                	cmp    %ecx,%ebx
  8021a1:	74 1b                	je     8021be <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021a3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021a6:	75 cf                	jne    802177 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021a8:	8b 42 58             	mov    0x58(%edx),%eax
  8021ab:	6a 01                	push   $0x1
  8021ad:	50                   	push   %eax
  8021ae:	53                   	push   %ebx
  8021af:	68 6f 31 80 00       	push   $0x80316f
  8021b4:	e8 6c e2 ff ff       	call   800425 <cprintf>
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	eb b9                	jmp    802177 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021be:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021c1:	0f 94 c0             	sete   %al
  8021c4:	0f b6 c0             	movzbl %al,%eax
}
  8021c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ca:	5b                   	pop    %ebx
  8021cb:	5e                   	pop    %esi
  8021cc:	5f                   	pop    %edi
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    

008021cf <devpipe_write>:
{
  8021cf:	f3 0f 1e fb          	endbr32 
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	57                   	push   %edi
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	83 ec 28             	sub    $0x28,%esp
  8021dc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021df:	56                   	push   %esi
  8021e0:	e8 12 f2 ff ff       	call   8013f7 <fd2data>
  8021e5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ef:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021f2:	74 4f                	je     802243 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021f4:	8b 43 04             	mov    0x4(%ebx),%eax
  8021f7:	8b 0b                	mov    (%ebx),%ecx
  8021f9:	8d 51 20             	lea    0x20(%ecx),%edx
  8021fc:	39 d0                	cmp    %edx,%eax
  8021fe:	72 14                	jb     802214 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802200:	89 da                	mov    %ebx,%edx
  802202:	89 f0                	mov    %esi,%eax
  802204:	e8 61 ff ff ff       	call   80216a <_pipeisclosed>
  802209:	85 c0                	test   %eax,%eax
  80220b:	75 3b                	jne    802248 <devpipe_write+0x79>
			sys_yield();
  80220d:	e8 3c ec ff ff       	call   800e4e <sys_yield>
  802212:	eb e0                	jmp    8021f4 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802217:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80221b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80221e:	89 c2                	mov    %eax,%edx
  802220:	c1 fa 1f             	sar    $0x1f,%edx
  802223:	89 d1                	mov    %edx,%ecx
  802225:	c1 e9 1b             	shr    $0x1b,%ecx
  802228:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80222b:	83 e2 1f             	and    $0x1f,%edx
  80222e:	29 ca                	sub    %ecx,%edx
  802230:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802234:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802238:	83 c0 01             	add    $0x1,%eax
  80223b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80223e:	83 c7 01             	add    $0x1,%edi
  802241:	eb ac                	jmp    8021ef <devpipe_write+0x20>
	return i;
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	eb 05                	jmp    80224d <devpipe_write+0x7e>
				return 0;
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <devpipe_read>:
{
  802255:	f3 0f 1e fb          	endbr32 
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	57                   	push   %edi
  80225d:	56                   	push   %esi
  80225e:	53                   	push   %ebx
  80225f:	83 ec 18             	sub    $0x18,%esp
  802262:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802265:	57                   	push   %edi
  802266:	e8 8c f1 ff ff       	call   8013f7 <fd2data>
  80226b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80226d:	83 c4 10             	add    $0x10,%esp
  802270:	be 00 00 00 00       	mov    $0x0,%esi
  802275:	3b 75 10             	cmp    0x10(%ebp),%esi
  802278:	75 14                	jne    80228e <devpipe_read+0x39>
	return i;
  80227a:	8b 45 10             	mov    0x10(%ebp),%eax
  80227d:	eb 02                	jmp    802281 <devpipe_read+0x2c>
				return i;
  80227f:	89 f0                	mov    %esi,%eax
}
  802281:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5f                   	pop    %edi
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    
			sys_yield();
  802289:	e8 c0 eb ff ff       	call   800e4e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80228e:	8b 03                	mov    (%ebx),%eax
  802290:	3b 43 04             	cmp    0x4(%ebx),%eax
  802293:	75 18                	jne    8022ad <devpipe_read+0x58>
			if (i > 0)
  802295:	85 f6                	test   %esi,%esi
  802297:	75 e6                	jne    80227f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802299:	89 da                	mov    %ebx,%edx
  80229b:	89 f8                	mov    %edi,%eax
  80229d:	e8 c8 fe ff ff       	call   80216a <_pipeisclosed>
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 e3                	je     802289 <devpipe_read+0x34>
				return 0;
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ab:	eb d4                	jmp    802281 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022ad:	99                   	cltd   
  8022ae:	c1 ea 1b             	shr    $0x1b,%edx
  8022b1:	01 d0                	add    %edx,%eax
  8022b3:	83 e0 1f             	and    $0x1f,%eax
  8022b6:	29 d0                	sub    %edx,%eax
  8022b8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022c0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022c3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022c6:	83 c6 01             	add    $0x1,%esi
  8022c9:	eb aa                	jmp    802275 <devpipe_read+0x20>

008022cb <pipe>:
{
  8022cb:	f3 0f 1e fb          	endbr32 
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022da:	50                   	push   %eax
  8022db:	e8 32 f1 ff ff       	call   801412 <fd_alloc>
  8022e0:	89 c3                	mov    %eax,%ebx
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	0f 88 23 01 00 00    	js     802410 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 07 04 00 00       	push   $0x407
  8022f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f8:	6a 00                	push   $0x0
  8022fa:	e8 72 eb ff ff       	call   800e71 <sys_page_alloc>
  8022ff:	89 c3                	mov    %eax,%ebx
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	85 c0                	test   %eax,%eax
  802306:	0f 88 04 01 00 00    	js     802410 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802312:	50                   	push   %eax
  802313:	e8 fa f0 ff ff       	call   801412 <fd_alloc>
  802318:	89 c3                	mov    %eax,%ebx
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	85 c0                	test   %eax,%eax
  80231f:	0f 88 db 00 00 00    	js     802400 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	68 07 04 00 00       	push   $0x407
  80232d:	ff 75 f0             	pushl  -0x10(%ebp)
  802330:	6a 00                	push   $0x0
  802332:	e8 3a eb ff ff       	call   800e71 <sys_page_alloc>
  802337:	89 c3                	mov    %eax,%ebx
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	85 c0                	test   %eax,%eax
  80233e:	0f 88 bc 00 00 00    	js     802400 <pipe+0x135>
	va = fd2data(fd0);
  802344:	83 ec 0c             	sub    $0xc,%esp
  802347:	ff 75 f4             	pushl  -0xc(%ebp)
  80234a:	e8 a8 f0 ff ff       	call   8013f7 <fd2data>
  80234f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802351:	83 c4 0c             	add    $0xc,%esp
  802354:	68 07 04 00 00       	push   $0x407
  802359:	50                   	push   %eax
  80235a:	6a 00                	push   $0x0
  80235c:	e8 10 eb ff ff       	call   800e71 <sys_page_alloc>
  802361:	89 c3                	mov    %eax,%ebx
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	85 c0                	test   %eax,%eax
  802368:	0f 88 82 00 00 00    	js     8023f0 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	ff 75 f0             	pushl  -0x10(%ebp)
  802374:	e8 7e f0 ff ff       	call   8013f7 <fd2data>
  802379:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802380:	50                   	push   %eax
  802381:	6a 00                	push   $0x0
  802383:	56                   	push   %esi
  802384:	6a 00                	push   $0x0
  802386:	e8 2d eb ff ff       	call   800eb8 <sys_page_map>
  80238b:	89 c3                	mov    %eax,%ebx
  80238d:	83 c4 20             	add    $0x20,%esp
  802390:	85 c0                	test   %eax,%eax
  802392:	78 4e                	js     8023e2 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802394:	a1 40 40 80 00       	mov    0x804040,%eax
  802399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ab:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023b7:	83 ec 0c             	sub    $0xc,%esp
  8023ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8023bd:	e8 21 f0 ff ff       	call   8013e3 <fd2num>
  8023c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023c7:	83 c4 04             	add    $0x4,%esp
  8023ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8023cd:	e8 11 f0 ff ff       	call   8013e3 <fd2num>
  8023d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023d8:	83 c4 10             	add    $0x10,%esp
  8023db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023e0:	eb 2e                	jmp    802410 <pipe+0x145>
	sys_page_unmap(0, va);
  8023e2:	83 ec 08             	sub    $0x8,%esp
  8023e5:	56                   	push   %esi
  8023e6:	6a 00                	push   $0x0
  8023e8:	e8 11 eb ff ff       	call   800efe <sys_page_unmap>
  8023ed:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023f0:	83 ec 08             	sub    $0x8,%esp
  8023f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8023f6:	6a 00                	push   $0x0
  8023f8:	e8 01 eb ff ff       	call   800efe <sys_page_unmap>
  8023fd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802400:	83 ec 08             	sub    $0x8,%esp
  802403:	ff 75 f4             	pushl  -0xc(%ebp)
  802406:	6a 00                	push   $0x0
  802408:	e8 f1 ea ff ff       	call   800efe <sys_page_unmap>
  80240d:	83 c4 10             	add    $0x10,%esp
}
  802410:	89 d8                	mov    %ebx,%eax
  802412:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802415:	5b                   	pop    %ebx
  802416:	5e                   	pop    %esi
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    

00802419 <pipeisclosed>:
{
  802419:	f3 0f 1e fb          	endbr32 
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802423:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802426:	50                   	push   %eax
  802427:	ff 75 08             	pushl  0x8(%ebp)
  80242a:	e8 39 f0 ff ff       	call   801468 <fd_lookup>
  80242f:	83 c4 10             	add    $0x10,%esp
  802432:	85 c0                	test   %eax,%eax
  802434:	78 18                	js     80244e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	ff 75 f4             	pushl  -0xc(%ebp)
  80243c:	e8 b6 ef ff ff       	call   8013f7 <fd2data>
  802441:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	e8 1f fd ff ff       	call   80216a <_pipeisclosed>
  80244b:	83 c4 10             	add    $0x10,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802450:	f3 0f 1e fb          	endbr32 
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	56                   	push   %esi
  802458:	53                   	push   %ebx
  802459:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  80245c:	85 f6                	test   %esi,%esi
  80245e:	74 13                	je     802473 <wait+0x23>
	e = &envs[ENVX(envid)];
  802460:	89 f3                	mov    %esi,%ebx
  802462:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802468:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80246b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802471:	eb 1b                	jmp    80248e <wait+0x3e>
	assert(envid != 0);
  802473:	68 87 31 80 00       	push   $0x803187
  802478:	68 03 31 80 00       	push   $0x803103
  80247d:	6a 09                	push   $0x9
  80247f:	68 92 31 80 00       	push   $0x803192
  802484:	e8 b5 de ff ff       	call   80033e <_panic>
		sys_yield();
  802489:	e8 c0 e9 ff ff       	call   800e4e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80248e:	8b 43 48             	mov    0x48(%ebx),%eax
  802491:	39 f0                	cmp    %esi,%eax
  802493:	75 07                	jne    80249c <wait+0x4c>
  802495:	8b 43 54             	mov    0x54(%ebx),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	75 ed                	jne    802489 <wait+0x39>
}
  80249c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80249f:	5b                   	pop    %ebx
  8024a0:	5e                   	pop    %esi
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024a3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	c3                   	ret    

008024ad <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024ad:	f3 0f 1e fb          	endbr32 
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024b7:	68 9d 31 80 00       	push   $0x80319d
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	e8 6b e5 ff ff       	call   800a2f <strcpy>
	return 0;
}
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <devcons_write>:
{
  8024cb:	f3 0f 1e fb          	endbr32 
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	57                   	push   %edi
  8024d3:	56                   	push   %esi
  8024d4:	53                   	push   %ebx
  8024d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024e9:	73 31                	jae    80251c <devcons_write+0x51>
		m = n - tot;
  8024eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8024f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	53                   	push   %ebx
  8024ff:	89 f0                	mov    %esi,%eax
  802501:	03 45 0c             	add    0xc(%ebp),%eax
  802504:	50                   	push   %eax
  802505:	57                   	push   %edi
  802506:	e8 da e6 ff ff       	call   800be5 <memmove>
		sys_cputs(buf, m);
  80250b:	83 c4 08             	add    $0x8,%esp
  80250e:	53                   	push   %ebx
  80250f:	57                   	push   %edi
  802510:	e8 8c e8 ff ff       	call   800da1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802515:	01 de                	add    %ebx,%esi
  802517:	83 c4 10             	add    $0x10,%esp
  80251a:	eb ca                	jmp    8024e6 <devcons_write+0x1b>
}
  80251c:	89 f0                	mov    %esi,%eax
  80251e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    

00802526 <devcons_read>:
{
  802526:	f3 0f 1e fb          	endbr32 
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 08             	sub    $0x8,%esp
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802535:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802539:	74 21                	je     80255c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80253b:	e8 83 e8 ff ff       	call   800dc3 <sys_cgetc>
  802540:	85 c0                	test   %eax,%eax
  802542:	75 07                	jne    80254b <devcons_read+0x25>
		sys_yield();
  802544:	e8 05 e9 ff ff       	call   800e4e <sys_yield>
  802549:	eb f0                	jmp    80253b <devcons_read+0x15>
	if (c < 0)
  80254b:	78 0f                	js     80255c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80254d:	83 f8 04             	cmp    $0x4,%eax
  802550:	74 0c                	je     80255e <devcons_read+0x38>
	*(char*)vbuf = c;
  802552:	8b 55 0c             	mov    0xc(%ebp),%edx
  802555:	88 02                	mov    %al,(%edx)
	return 1;
  802557:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    
		return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb f7                	jmp    80255c <devcons_read+0x36>

00802565 <cputchar>:
{
  802565:	f3 0f 1e fb          	endbr32 
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802575:	6a 01                	push   $0x1
  802577:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80257a:	50                   	push   %eax
  80257b:	e8 21 e8 ff ff       	call   800da1 <sys_cputs>
}
  802580:	83 c4 10             	add    $0x10,%esp
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <getchar>:
{
  802585:	f3 0f 1e fb          	endbr32 
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80258f:	6a 01                	push   $0x1
  802591:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802594:	50                   	push   %eax
  802595:	6a 00                	push   $0x0
  802597:	e8 54 f1 ff ff       	call   8016f0 <read>
	if (r < 0)
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	78 06                	js     8025a9 <getchar+0x24>
	if (r < 1)
  8025a3:	74 06                	je     8025ab <getchar+0x26>
	return c;
  8025a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    
		return -E_EOF;
  8025ab:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025b0:	eb f7                	jmp    8025a9 <getchar+0x24>

008025b2 <iscons>:
{
  8025b2:	f3 0f 1e fb          	endbr32 
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025bf:	50                   	push   %eax
  8025c0:	ff 75 08             	pushl  0x8(%ebp)
  8025c3:	e8 a0 ee ff ff       	call   801468 <fd_lookup>
  8025c8:	83 c4 10             	add    $0x10,%esp
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	78 11                	js     8025e0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  8025d8:	39 10                	cmp    %edx,(%eax)
  8025da:	0f 94 c0             	sete   %al
  8025dd:	0f b6 c0             	movzbl %al,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <opencons>:
{
  8025e2:	f3 0f 1e fb          	endbr32 
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ef:	50                   	push   %eax
  8025f0:	e8 1d ee ff ff       	call   801412 <fd_alloc>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	78 3a                	js     802636 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025fc:	83 ec 04             	sub    $0x4,%esp
  8025ff:	68 07 04 00 00       	push   $0x407
  802604:	ff 75 f4             	pushl  -0xc(%ebp)
  802607:	6a 00                	push   $0x0
  802609:	e8 63 e8 ff ff       	call   800e71 <sys_page_alloc>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	78 21                	js     802636 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  80261e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	50                   	push   %eax
  80262e:	e8 b0 ed ff ff       	call   8013e3 <fd2num>
  802633:	83 c4 10             	add    $0x10,%esp
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802638:	f3 0f 1e fb          	endbr32 
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802642:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802649:	74 0a                	je     802655 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802655:	a1 08 50 80 00       	mov    0x805008,%eax
  80265a:	8b 40 48             	mov    0x48(%eax),%eax
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	6a 07                	push   $0x7
  802662:	68 00 f0 bf ee       	push   $0xeebff000
  802667:	50                   	push   %eax
  802668:	e8 04 e8 ff ff       	call   800e71 <sys_page_alloc>
  80266d:	83 c4 10             	add    $0x10,%esp
  802670:	85 c0                	test   %eax,%eax
  802672:	75 31                	jne    8026a5 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802674:	a1 08 50 80 00       	mov    0x805008,%eax
  802679:	8b 40 48             	mov    0x48(%eax),%eax
  80267c:	83 ec 08             	sub    $0x8,%esp
  80267f:	68 b9 26 80 00       	push   $0x8026b9
  802684:	50                   	push   %eax
  802685:	e8 46 e9 ff ff       	call   800fd0 <sys_env_set_pgfault_upcall>
  80268a:	83 c4 10             	add    $0x10,%esp
  80268d:	85 c0                	test   %eax,%eax
  80268f:	74 ba                	je     80264b <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	68 d4 31 80 00       	push   $0x8031d4
  802699:	6a 24                	push   $0x24
  80269b:	68 02 32 80 00       	push   $0x803202
  8026a0:	e8 99 dc ff ff       	call   80033e <_panic>
			panic("set_pgfault_handler page_alloc failed");
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 ac 31 80 00       	push   $0x8031ac
  8026ad:	6a 21                	push   $0x21
  8026af:	68 02 32 80 00       	push   $0x803202
  8026b4:	e8 85 dc ff ff       	call   80033e <_panic>

008026b9 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8026b9:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8026ba:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8026bf:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8026c1:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8026c4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8026c8:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8026cd:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8026d1:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8026d3:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8026d6:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8026d7:	83 c4 04             	add    $0x4,%esp
    popfl
  8026da:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8026db:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8026dc:	c3                   	ret    

008026dd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026dd:	f3 0f 1e fb          	endbr32 
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	56                   	push   %esi
  8026e5:	53                   	push   %ebx
  8026e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8026e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8026ef:	83 e8 01             	sub    $0x1,%eax
  8026f2:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8026f7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026fc:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	50                   	push   %eax
  802704:	e8 34 e9 ff ff       	call   80103d <sys_ipc_recv>
	if (!t) {
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	85 c0                	test   %eax,%eax
  80270e:	75 2b                	jne    80273b <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802710:	85 f6                	test   %esi,%esi
  802712:	74 0a                	je     80271e <ipc_recv+0x41>
  802714:	a1 08 50 80 00       	mov    0x805008,%eax
  802719:	8b 40 74             	mov    0x74(%eax),%eax
  80271c:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80271e:	85 db                	test   %ebx,%ebx
  802720:	74 0a                	je     80272c <ipc_recv+0x4f>
  802722:	a1 08 50 80 00       	mov    0x805008,%eax
  802727:	8b 40 78             	mov    0x78(%eax),%eax
  80272a:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80272c:	a1 08 50 80 00       	mov    0x805008,%eax
  802731:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5d                   	pop    %ebp
  80273a:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80273b:	85 f6                	test   %esi,%esi
  80273d:	74 06                	je     802745 <ipc_recv+0x68>
  80273f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802745:	85 db                	test   %ebx,%ebx
  802747:	74 eb                	je     802734 <ipc_recv+0x57>
  802749:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80274f:	eb e3                	jmp    802734 <ipc_recv+0x57>

00802751 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802751:	f3 0f 1e fb          	endbr32 
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	57                   	push   %edi
  802759:	56                   	push   %esi
  80275a:	53                   	push   %ebx
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802761:	8b 75 0c             	mov    0xc(%ebp),%esi
  802764:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802767:	85 db                	test   %ebx,%ebx
  802769:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80276e:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802771:	ff 75 14             	pushl  0x14(%ebp)
  802774:	53                   	push   %ebx
  802775:	56                   	push   %esi
  802776:	57                   	push   %edi
  802777:	e8 9a e8 ff ff       	call   801016 <sys_ipc_try_send>
  80277c:	83 c4 10             	add    $0x10,%esp
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 1e                	je     8027a1 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802783:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802786:	75 07                	jne    80278f <ipc_send+0x3e>
		sys_yield();
  802788:	e8 c1 e6 ff ff       	call   800e4e <sys_yield>
  80278d:	eb e2                	jmp    802771 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80278f:	50                   	push   %eax
  802790:	68 10 32 80 00       	push   $0x803210
  802795:	6a 39                	push   $0x39
  802797:	68 22 32 80 00       	push   $0x803222
  80279c:	e8 9d db ff ff       	call   80033e <_panic>
	}
	//panic("ipc_send not implemented");
}
  8027a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a4:	5b                   	pop    %ebx
  8027a5:	5e                   	pop    %esi
  8027a6:	5f                   	pop    %edi
  8027a7:	5d                   	pop    %ebp
  8027a8:	c3                   	ret    

008027a9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8027a9:	f3 0f 1e fb          	endbr32 
  8027ad:	55                   	push   %ebp
  8027ae:	89 e5                	mov    %esp,%ebp
  8027b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8027b8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8027bb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8027c1:	8b 52 50             	mov    0x50(%edx),%edx
  8027c4:	39 ca                	cmp    %ecx,%edx
  8027c6:	74 11                	je     8027d9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8027c8:	83 c0 01             	add    $0x1,%eax
  8027cb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027d0:	75 e6                	jne    8027b8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8027d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d7:	eb 0b                	jmp    8027e4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8027d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8027e1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8027e4:	5d                   	pop    %ebp
  8027e5:	c3                   	ret    

008027e6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027e6:	f3 0f 1e fb          	endbr32 
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027f0:	89 c2                	mov    %eax,%edx
  8027f2:	c1 ea 16             	shr    $0x16,%edx
  8027f5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8027fc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802801:	f6 c1 01             	test   $0x1,%cl
  802804:	74 1c                	je     802822 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802806:	c1 e8 0c             	shr    $0xc,%eax
  802809:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802810:	a8 01                	test   $0x1,%al
  802812:	74 0e                	je     802822 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802814:	c1 e8 0c             	shr    $0xc,%eax
  802817:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80281e:	ef 
  80281f:	0f b7 d2             	movzwl %dx,%edx
}
  802822:	89 d0                	mov    %edx,%eax
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    
  802826:	66 90                	xchg   %ax,%ax
  802828:	66 90                	xchg   %ax,%ax
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__udivdi3>:
  802830:	f3 0f 1e fb          	endbr32 
  802834:	55                   	push   %ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	83 ec 1c             	sub    $0x1c,%esp
  80283b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80283f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802843:	8b 74 24 34          	mov    0x34(%esp),%esi
  802847:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80284b:	85 d2                	test   %edx,%edx
  80284d:	75 19                	jne    802868 <__udivdi3+0x38>
  80284f:	39 f3                	cmp    %esi,%ebx
  802851:	76 4d                	jbe    8028a0 <__udivdi3+0x70>
  802853:	31 ff                	xor    %edi,%edi
  802855:	89 e8                	mov    %ebp,%eax
  802857:	89 f2                	mov    %esi,%edx
  802859:	f7 f3                	div    %ebx
  80285b:	89 fa                	mov    %edi,%edx
  80285d:	83 c4 1c             	add    $0x1c,%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	39 f2                	cmp    %esi,%edx
  80286a:	76 14                	jbe    802880 <__udivdi3+0x50>
  80286c:	31 ff                	xor    %edi,%edi
  80286e:	31 c0                	xor    %eax,%eax
  802870:	89 fa                	mov    %edi,%edx
  802872:	83 c4 1c             	add    $0x1c,%esp
  802875:	5b                   	pop    %ebx
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802880:	0f bd fa             	bsr    %edx,%edi
  802883:	83 f7 1f             	xor    $0x1f,%edi
  802886:	75 48                	jne    8028d0 <__udivdi3+0xa0>
  802888:	39 f2                	cmp    %esi,%edx
  80288a:	72 06                	jb     802892 <__udivdi3+0x62>
  80288c:	31 c0                	xor    %eax,%eax
  80288e:	39 eb                	cmp    %ebp,%ebx
  802890:	77 de                	ja     802870 <__udivdi3+0x40>
  802892:	b8 01 00 00 00       	mov    $0x1,%eax
  802897:	eb d7                	jmp    802870 <__udivdi3+0x40>
  802899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	89 d9                	mov    %ebx,%ecx
  8028a2:	85 db                	test   %ebx,%ebx
  8028a4:	75 0b                	jne    8028b1 <__udivdi3+0x81>
  8028a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	f7 f3                	div    %ebx
  8028af:	89 c1                	mov    %eax,%ecx
  8028b1:	31 d2                	xor    %edx,%edx
  8028b3:	89 f0                	mov    %esi,%eax
  8028b5:	f7 f1                	div    %ecx
  8028b7:	89 c6                	mov    %eax,%esi
  8028b9:	89 e8                	mov    %ebp,%eax
  8028bb:	89 f7                	mov    %esi,%edi
  8028bd:	f7 f1                	div    %ecx
  8028bf:	89 fa                	mov    %edi,%edx
  8028c1:	83 c4 1c             	add    $0x1c,%esp
  8028c4:	5b                   	pop    %ebx
  8028c5:	5e                   	pop    %esi
  8028c6:	5f                   	pop    %edi
  8028c7:	5d                   	pop    %ebp
  8028c8:	c3                   	ret    
  8028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d0:	89 f9                	mov    %edi,%ecx
  8028d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8028d7:	29 f8                	sub    %edi,%eax
  8028d9:	d3 e2                	shl    %cl,%edx
  8028db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028df:	89 c1                	mov    %eax,%ecx
  8028e1:	89 da                	mov    %ebx,%edx
  8028e3:	d3 ea                	shr    %cl,%edx
  8028e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028e9:	09 d1                	or     %edx,%ecx
  8028eb:	89 f2                	mov    %esi,%edx
  8028ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028f1:	89 f9                	mov    %edi,%ecx
  8028f3:	d3 e3                	shl    %cl,%ebx
  8028f5:	89 c1                	mov    %eax,%ecx
  8028f7:	d3 ea                	shr    %cl,%edx
  8028f9:	89 f9                	mov    %edi,%ecx
  8028fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8028ff:	89 eb                	mov    %ebp,%ebx
  802901:	d3 e6                	shl    %cl,%esi
  802903:	89 c1                	mov    %eax,%ecx
  802905:	d3 eb                	shr    %cl,%ebx
  802907:	09 de                	or     %ebx,%esi
  802909:	89 f0                	mov    %esi,%eax
  80290b:	f7 74 24 08          	divl   0x8(%esp)
  80290f:	89 d6                	mov    %edx,%esi
  802911:	89 c3                	mov    %eax,%ebx
  802913:	f7 64 24 0c          	mull   0xc(%esp)
  802917:	39 d6                	cmp    %edx,%esi
  802919:	72 15                	jb     802930 <__udivdi3+0x100>
  80291b:	89 f9                	mov    %edi,%ecx
  80291d:	d3 e5                	shl    %cl,%ebp
  80291f:	39 c5                	cmp    %eax,%ebp
  802921:	73 04                	jae    802927 <__udivdi3+0xf7>
  802923:	39 d6                	cmp    %edx,%esi
  802925:	74 09                	je     802930 <__udivdi3+0x100>
  802927:	89 d8                	mov    %ebx,%eax
  802929:	31 ff                	xor    %edi,%edi
  80292b:	e9 40 ff ff ff       	jmp    802870 <__udivdi3+0x40>
  802930:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802933:	31 ff                	xor    %edi,%edi
  802935:	e9 36 ff ff ff       	jmp    802870 <__udivdi3+0x40>
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	66 90                	xchg   %ax,%ax
  80293e:	66 90                	xchg   %ax,%ax

00802940 <__umoddi3>:
  802940:	f3 0f 1e fb          	endbr32 
  802944:	55                   	push   %ebp
  802945:	57                   	push   %edi
  802946:	56                   	push   %esi
  802947:	53                   	push   %ebx
  802948:	83 ec 1c             	sub    $0x1c,%esp
  80294b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80294f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802953:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80295b:	85 c0                	test   %eax,%eax
  80295d:	75 19                	jne    802978 <__umoddi3+0x38>
  80295f:	39 df                	cmp    %ebx,%edi
  802961:	76 5d                	jbe    8029c0 <__umoddi3+0x80>
  802963:	89 f0                	mov    %esi,%eax
  802965:	89 da                	mov    %ebx,%edx
  802967:	f7 f7                	div    %edi
  802969:	89 d0                	mov    %edx,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	83 c4 1c             	add    $0x1c,%esp
  802970:	5b                   	pop    %ebx
  802971:	5e                   	pop    %esi
  802972:	5f                   	pop    %edi
  802973:	5d                   	pop    %ebp
  802974:	c3                   	ret    
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	89 f2                	mov    %esi,%edx
  80297a:	39 d8                	cmp    %ebx,%eax
  80297c:	76 12                	jbe    802990 <__umoddi3+0x50>
  80297e:	89 f0                	mov    %esi,%eax
  802980:	89 da                	mov    %ebx,%edx
  802982:	83 c4 1c             	add    $0x1c,%esp
  802985:	5b                   	pop    %ebx
  802986:	5e                   	pop    %esi
  802987:	5f                   	pop    %edi
  802988:	5d                   	pop    %ebp
  802989:	c3                   	ret    
  80298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802990:	0f bd e8             	bsr    %eax,%ebp
  802993:	83 f5 1f             	xor    $0x1f,%ebp
  802996:	75 50                	jne    8029e8 <__umoddi3+0xa8>
  802998:	39 d8                	cmp    %ebx,%eax
  80299a:	0f 82 e0 00 00 00    	jb     802a80 <__umoddi3+0x140>
  8029a0:	89 d9                	mov    %ebx,%ecx
  8029a2:	39 f7                	cmp    %esi,%edi
  8029a4:	0f 86 d6 00 00 00    	jbe    802a80 <__umoddi3+0x140>
  8029aa:	89 d0                	mov    %edx,%eax
  8029ac:	89 ca                	mov    %ecx,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029bd:	8d 76 00             	lea    0x0(%esi),%esi
  8029c0:	89 fd                	mov    %edi,%ebp
  8029c2:	85 ff                	test   %edi,%edi
  8029c4:	75 0b                	jne    8029d1 <__umoddi3+0x91>
  8029c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029cb:	31 d2                	xor    %edx,%edx
  8029cd:	f7 f7                	div    %edi
  8029cf:	89 c5                	mov    %eax,%ebp
  8029d1:	89 d8                	mov    %ebx,%eax
  8029d3:	31 d2                	xor    %edx,%edx
  8029d5:	f7 f5                	div    %ebp
  8029d7:	89 f0                	mov    %esi,%eax
  8029d9:	f7 f5                	div    %ebp
  8029db:	89 d0                	mov    %edx,%eax
  8029dd:	31 d2                	xor    %edx,%edx
  8029df:	eb 8c                	jmp    80296d <__umoddi3+0x2d>
  8029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 e9                	mov    %ebp,%ecx
  8029ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8029ef:	29 ea                	sub    %ebp,%edx
  8029f1:	d3 e0                	shl    %cl,%eax
  8029f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029f7:	89 d1                	mov    %edx,%ecx
  8029f9:	89 f8                	mov    %edi,%eax
  8029fb:	d3 e8                	shr    %cl,%eax
  8029fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a01:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a05:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a09:	09 c1                	or     %eax,%ecx
  802a0b:	89 d8                	mov    %ebx,%eax
  802a0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a11:	89 e9                	mov    %ebp,%ecx
  802a13:	d3 e7                	shl    %cl,%edi
  802a15:	89 d1                	mov    %edx,%ecx
  802a17:	d3 e8                	shr    %cl,%eax
  802a19:	89 e9                	mov    %ebp,%ecx
  802a1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a1f:	d3 e3                	shl    %cl,%ebx
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	89 d1                	mov    %edx,%ecx
  802a25:	89 f0                	mov    %esi,%eax
  802a27:	d3 e8                	shr    %cl,%eax
  802a29:	89 e9                	mov    %ebp,%ecx
  802a2b:	89 fa                	mov    %edi,%edx
  802a2d:	d3 e6                	shl    %cl,%esi
  802a2f:	09 d8                	or     %ebx,%eax
  802a31:	f7 74 24 08          	divl   0x8(%esp)
  802a35:	89 d1                	mov    %edx,%ecx
  802a37:	89 f3                	mov    %esi,%ebx
  802a39:	f7 64 24 0c          	mull   0xc(%esp)
  802a3d:	89 c6                	mov    %eax,%esi
  802a3f:	89 d7                	mov    %edx,%edi
  802a41:	39 d1                	cmp    %edx,%ecx
  802a43:	72 06                	jb     802a4b <__umoddi3+0x10b>
  802a45:	75 10                	jne    802a57 <__umoddi3+0x117>
  802a47:	39 c3                	cmp    %eax,%ebx
  802a49:	73 0c                	jae    802a57 <__umoddi3+0x117>
  802a4b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a4f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802a53:	89 d7                	mov    %edx,%edi
  802a55:	89 c6                	mov    %eax,%esi
  802a57:	89 ca                	mov    %ecx,%edx
  802a59:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802a5e:	29 f3                	sub    %esi,%ebx
  802a60:	19 fa                	sbb    %edi,%edx
  802a62:	89 d0                	mov    %edx,%eax
  802a64:	d3 e0                	shl    %cl,%eax
  802a66:	89 e9                	mov    %ebp,%ecx
  802a68:	d3 eb                	shr    %cl,%ebx
  802a6a:	d3 ea                	shr    %cl,%edx
  802a6c:	09 d8                	or     %ebx,%eax
  802a6e:	83 c4 1c             	add    $0x1c,%esp
  802a71:	5b                   	pop    %ebx
  802a72:	5e                   	pop    %esi
  802a73:	5f                   	pop    %edi
  802a74:	5d                   	pop    %ebp
  802a75:	c3                   	ret    
  802a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a7d:	8d 76 00             	lea    0x0(%esi),%esi
  802a80:	29 fe                	sub    %edi,%esi
  802a82:	19 c3                	sbb    %eax,%ebx
  802a84:	89 f2                	mov    %esi,%edx
  802a86:	89 d9                	mov    %ebx,%ecx
  802a88:	e9 1d ff ff ff       	jmp    8029aa <__umoddi3+0x6a>
