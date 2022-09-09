
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 7d 04 00 00       	call   8004ae <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 84 00 00 00    	sub    $0x84,%esp
  800043:	8b 75 08             	mov    0x8(%ebp),%esi
  800046:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  80004c:	53                   	push   %ebx
  80004d:	56                   	push   %esi
  80004e:	e8 d1 19 00 00       	call   801a24 <seek>
	seek(kfd, off);
  800053:	83 c4 08             	add    $0x8,%esp
  800056:	53                   	push   %ebx
  800057:	57                   	push   %edi
  800058:	e8 c7 19 00 00       	call   801a24 <seek>

	cprintf("shell produced incorrect output.\n");
  80005d:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  800064:	e8 94 05 00 00       	call   8005fd <cprintf>
	cprintf("expected:\n===\n");
  800069:	c7 04 24 6b 31 80 00 	movl   $0x80316b,(%esp)
  800070:	e8 88 05 00 00       	call   8005fd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	6a 63                	push   $0x63
  800080:	53                   	push   %ebx
  800081:	57                   	push   %edi
  800082:	e8 41 18 00 00       	call   8018c8 <read>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	85 c0                	test   %eax,%eax
  80008c:	7e 0f                	jle    80009d <wrong+0x6a>
		sys_cputs(buf, n);
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	50                   	push   %eax
  800092:	53                   	push   %ebx
  800093:	e8 e1 0e 00 00       	call   800f79 <sys_cputs>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	eb de                	jmp    80007b <wrong+0x48>
	cprintf("===\ngot:\n===\n");
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 7a 31 80 00       	push   $0x80317a
  8000a5:	e8 53 05 00 00       	call   8005fd <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000aa:	83 c4 10             	add    $0x10,%esp
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0d                	jmp    8000bf <wrong+0x8c>
		sys_cputs(buf, n);
  8000b2:	83 ec 08             	sub    $0x8,%esp
  8000b5:	50                   	push   %eax
  8000b6:	53                   	push   %ebx
  8000b7:	e8 bd 0e 00 00       	call   800f79 <sys_cputs>
  8000bc:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bf:	83 ec 04             	sub    $0x4,%esp
  8000c2:	6a 63                	push   $0x63
  8000c4:	53                   	push   %ebx
  8000c5:	56                   	push   %esi
  8000c6:	e8 fd 17 00 00       	call   8018c8 <read>
  8000cb:	83 c4 10             	add    $0x10,%esp
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f e0                	jg     8000b2 <wrong+0x7f>
	cprintf("===\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 75 31 80 00       	push   $0x803175
  8000da:	e8 1e 05 00 00       	call   8005fd <cprintf>
	exit();
  8000df:	e8 14 04 00 00       	call   8004f8 <exit>
}
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <umain>:
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000fc:	6a 00                	push   $0x0
  8000fe:	e8 7b 16 00 00       	call   80177e <close>
	close(1);
  800103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010a:	e8 6f 16 00 00       	call   80177e <close>
	opencons();
  80010f:	e8 44 03 00 00       	call   800458 <opencons>
	opencons();
  800114:	e8 3f 03 00 00       	call   800458 <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800119:	83 c4 08             	add    $0x8,%esp
  80011c:	6a 00                	push   $0x0
  80011e:	68 88 31 80 00       	push   $0x803188
  800123:	e8 35 1c 00 00       	call   801d5d <open>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	85 c0                	test   %eax,%eax
  80012f:	0f 88 e7 00 00 00    	js     80021c <umain+0x12d>
	if ((wfd = pipe(pfds)) < 0)
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80013b:	50                   	push   %eax
  80013c:	e8 90 29 00 00       	call   802ad1 <pipe>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 88 e2 00 00 00    	js     80022e <umain+0x13f>
	wfd = pfds[1];
  80014c:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 24 31 80 00       	push   $0x803124
  800157:	e8 a1 04 00 00       	call   8005fd <cprintf>
	if ((r = fork()) < 0)
  80015c:	e8 1c 13 00 00       	call   80147d <fork>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	85 c0                	test   %eax,%eax
  800166:	0f 88 d4 00 00 00    	js     800240 <umain+0x151>
	if (r == 0) {
  80016c:	75 6f                	jne    8001dd <umain+0xee>
		dup(rfd, 0);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	6a 00                	push   $0x0
  800173:	53                   	push   %ebx
  800174:	e8 5f 16 00 00       	call   8017d8 <dup>
		dup(wfd, 1);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	6a 01                	push   $0x1
  80017e:	56                   	push   %esi
  80017f:	e8 54 16 00 00       	call   8017d8 <dup>
		close(rfd);
  800184:	89 1c 24             	mov    %ebx,(%esp)
  800187:	e8 f2 15 00 00       	call   80177e <close>
		close(wfd);
  80018c:	89 34 24             	mov    %esi,(%esp)
  80018f:	e8 ea 15 00 00       	call   80177e <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800194:	6a 00                	push   $0x0
  800196:	68 ce 31 80 00       	push   $0x8031ce
  80019b:	68 92 31 80 00       	push   $0x803192
  8001a0:	68 d1 31 80 00       	push   $0x8031d1
  8001a5:	e8 dc 21 00 00       	call   802386 <spawnl>
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	83 c4 20             	add    $0x20,%esp
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	0f 88 9b 00 00 00    	js     800252 <umain+0x163>
		close(0);
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	6a 00                	push   $0x0
  8001bc:	e8 bd 15 00 00       	call   80177e <close>
		close(1);
  8001c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c8:	e8 b1 15 00 00       	call   80177e <close>
		wait(r);
  8001cd:	89 3c 24             	mov    %edi,(%esp)
  8001d0:	e8 81 2a 00 00       	call   802c56 <wait>
		exit();
  8001d5:	e8 1e 03 00 00       	call   8004f8 <exit>
  8001da:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	53                   	push   %ebx
  8001e1:	e8 98 15 00 00       	call   80177e <close>
	close(wfd);
  8001e6:	89 34 24             	mov    %esi,(%esp)
  8001e9:	e8 90 15 00 00       	call   80177e <close>
	rfd = pfds[0];
  8001ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001f4:	83 c4 08             	add    $0x8,%esp
  8001f7:	6a 00                	push   $0x0
  8001f9:	68 df 31 80 00       	push   $0x8031df
  8001fe:	e8 5a 1b 00 00       	call   801d5d <open>
  800203:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	85 c0                	test   %eax,%eax
  80020b:	78 57                	js     800264 <umain+0x175>
  80020d:	be 01 00 00 00       	mov    $0x1,%esi
	nloff = 0;
  800212:	bf 00 00 00 00       	mov    $0x0,%edi
  800217:	e9 9a 00 00 00       	jmp    8002b6 <umain+0x1c7>
		panic("open testshell.sh: %e", rfd);
  80021c:	50                   	push   %eax
  80021d:	68 95 31 80 00       	push   $0x803195
  800222:	6a 13                	push   $0x13
  800224:	68 ab 31 80 00       	push   $0x8031ab
  800229:	e8 e8 02 00 00       	call   800516 <_panic>
		panic("pipe: %e", wfd);
  80022e:	50                   	push   %eax
  80022f:	68 bc 31 80 00       	push   $0x8031bc
  800234:	6a 15                	push   $0x15
  800236:	68 ab 31 80 00       	push   $0x8031ab
  80023b:	e8 d6 02 00 00       	call   800516 <_panic>
		panic("fork: %e", r);
  800240:	50                   	push   %eax
  800241:	68 c5 31 80 00       	push   $0x8031c5
  800246:	6a 1a                	push   $0x1a
  800248:	68 ab 31 80 00       	push   $0x8031ab
  80024d:	e8 c4 02 00 00       	call   800516 <_panic>
			panic("spawn: %e", r);
  800252:	50                   	push   %eax
  800253:	68 d5 31 80 00       	push   $0x8031d5
  800258:	6a 21                	push   $0x21
  80025a:	68 ab 31 80 00       	push   $0x8031ab
  80025f:	e8 b2 02 00 00       	call   800516 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  800264:	50                   	push   %eax
  800265:	68 48 31 80 00       	push   $0x803148
  80026a:	6a 2c                	push   $0x2c
  80026c:	68 ab 31 80 00       	push   $0x8031ab
  800271:	e8 a0 02 00 00       	call   800516 <_panic>
			panic("reading testshell.out: %e", n1);
  800276:	53                   	push   %ebx
  800277:	68 ed 31 80 00       	push   $0x8031ed
  80027c:	6a 33                	push   $0x33
  80027e:	68 ab 31 80 00       	push   $0x8031ab
  800283:	e8 8e 02 00 00       	call   800516 <_panic>
			panic("reading testshell.key: %e", n2);
  800288:	50                   	push   %eax
  800289:	68 07 32 80 00       	push   $0x803207
  80028e:	6a 35                	push   $0x35
  800290:	68 ab 31 80 00       	push   $0x8031ab
  800295:	e8 7c 02 00 00       	call   800516 <_panic>
			wrong(rfd, kfd, nloff);
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	57                   	push   %edi
  80029e:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a4:	e8 8a fd ff ff       	call   800033 <wrong>
  8002a9:	83 c4 10             	add    $0x10,%esp
			nloff = off+1;
  8002ac:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b0:	0f 44 fe             	cmove  %esi,%edi
  8002b3:	83 c6 01             	add    $0x1,%esi
		n1 = read(rfd, &c1, 1);
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	6a 01                	push   $0x1
  8002bb:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002be:	50                   	push   %eax
  8002bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8002c2:	e8 01 16 00 00       	call   8018c8 <read>
  8002c7:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c9:	83 c4 0c             	add    $0xc,%esp
  8002cc:	6a 01                	push   $0x1
  8002ce:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002d5:	e8 ee 15 00 00       	call   8018c8 <read>
		if (n1 < 0)
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	85 db                	test   %ebx,%ebx
  8002df:	78 95                	js     800276 <umain+0x187>
		if (n2 < 0)
  8002e1:	85 c0                	test   %eax,%eax
  8002e3:	78 a3                	js     800288 <umain+0x199>
		if (n1 == 0 && n2 == 0)
  8002e5:	89 da                	mov    %ebx,%edx
  8002e7:	09 c2                	or     %eax,%edx
  8002e9:	74 15                	je     800300 <umain+0x211>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  8002eb:	83 fb 01             	cmp    $0x1,%ebx
  8002ee:	75 aa                	jne    80029a <umain+0x1ab>
  8002f0:	83 f8 01             	cmp    $0x1,%eax
  8002f3:	75 a5                	jne    80029a <umain+0x1ab>
  8002f5:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  8002f9:	38 45 e7             	cmp    %al,-0x19(%ebp)
  8002fc:	75 9c                	jne    80029a <umain+0x1ab>
  8002fe:	eb ac                	jmp    8002ac <umain+0x1bd>
	cprintf("shell ran correctly\n");
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 21 32 80 00       	push   $0x803221
  800308:	e8 f0 02 00 00       	call   8005fd <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80030d:	cc                   	int3   
}
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5f                   	pop    %edi
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800319:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	c3                   	ret    

00800323 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80032d:	68 36 32 80 00       	push   $0x803236
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	e8 cd 08 00 00       	call   800c07 <strcpy>
	return 0;
}
  80033a:	b8 00 00 00 00       	mov    $0x0,%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <devcons_write>:
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800351:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800356:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80035c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80035f:	73 31                	jae    800392 <devcons_write+0x51>
		m = n - tot;
  800361:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800364:	29 f3                	sub    %esi,%ebx
  800366:	83 fb 7f             	cmp    $0x7f,%ebx
  800369:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80036e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	53                   	push   %ebx
  800375:	89 f0                	mov    %esi,%eax
  800377:	03 45 0c             	add    0xc(%ebp),%eax
  80037a:	50                   	push   %eax
  80037b:	57                   	push   %edi
  80037c:	e8 3c 0a 00 00       	call   800dbd <memmove>
		sys_cputs(buf, m);
  800381:	83 c4 08             	add    $0x8,%esp
  800384:	53                   	push   %ebx
  800385:	57                   	push   %edi
  800386:	e8 ee 0b 00 00       	call   800f79 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80038b:	01 de                	add    %ebx,%esi
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	eb ca                	jmp    80035c <devcons_write+0x1b>
}
  800392:	89 f0                	mov    %esi,%eax
  800394:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800397:	5b                   	pop    %ebx
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <devcons_read>:
{
  80039c:	f3 0f 1e fb          	endbr32 
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8003ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003af:	74 21                	je     8003d2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8003b1:	e8 e5 0b 00 00       	call   800f9b <sys_cgetc>
  8003b6:	85 c0                	test   %eax,%eax
  8003b8:	75 07                	jne    8003c1 <devcons_read+0x25>
		sys_yield();
  8003ba:	e8 67 0c 00 00       	call   801026 <sys_yield>
  8003bf:	eb f0                	jmp    8003b1 <devcons_read+0x15>
	if (c < 0)
  8003c1:	78 0f                	js     8003d2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8003c3:	83 f8 04             	cmp    $0x4,%eax
  8003c6:	74 0c                	je     8003d4 <devcons_read+0x38>
	*(char*)vbuf = c;
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	88 02                	mov    %al,(%edx)
	return 1;
  8003cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    
		return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d9:	eb f7                	jmp    8003d2 <devcons_read+0x36>

008003db <cputchar>:
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003eb:	6a 01                	push   $0x1
  8003ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003f0:	50                   	push   %eax
  8003f1:	e8 83 0b 00 00       	call   800f79 <sys_cputs>
}
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <getchar>:
{
  8003fb:	f3 0f 1e fb          	endbr32 
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800405:	6a 01                	push   $0x1
  800407:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80040a:	50                   	push   %eax
  80040b:	6a 00                	push   $0x0
  80040d:	e8 b6 14 00 00       	call   8018c8 <read>
	if (r < 0)
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	85 c0                	test   %eax,%eax
  800417:	78 06                	js     80041f <getchar+0x24>
	if (r < 1)
  800419:	74 06                	je     800421 <getchar+0x26>
	return c;
  80041b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80041f:	c9                   	leave  
  800420:	c3                   	ret    
		return -E_EOF;
  800421:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800426:	eb f7                	jmp    80041f <getchar+0x24>

00800428 <iscons>:
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800432:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800435:	50                   	push   %eax
  800436:	ff 75 08             	pushl  0x8(%ebp)
  800439:	e8 02 12 00 00       	call   801640 <fd_lookup>
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	85 c0                	test   %eax,%eax
  800443:	78 11                	js     800456 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800448:	8b 15 00 40 80 00    	mov    0x804000,%edx
  80044e:	39 10                	cmp    %edx,(%eax)
  800450:	0f 94 c0             	sete   %al
  800453:	0f b6 c0             	movzbl %al,%eax
}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <opencons>:
{
  800458:	f3 0f 1e fb          	endbr32 
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
  80045f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800465:	50                   	push   %eax
  800466:	e8 7f 11 00 00       	call   8015ea <fd_alloc>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	85 c0                	test   %eax,%eax
  800470:	78 3a                	js     8004ac <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 07 04 00 00       	push   $0x407
  80047a:	ff 75 f4             	pushl  -0xc(%ebp)
  80047d:	6a 00                	push   $0x0
  80047f:	e8 c5 0b 00 00       	call   801049 <sys_page_alloc>
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	85 c0                	test   %eax,%eax
  800489:	78 21                	js     8004ac <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80048b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800494:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800499:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8004a0:	83 ec 0c             	sub    $0xc,%esp
  8004a3:	50                   	push   %eax
  8004a4:	e8 12 11 00 00       	call   8015bb <fd2num>
  8004a9:	83 c4 10             	add    $0x10,%esp
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004ae:	f3 0f 1e fb          	endbr32 
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	56                   	push   %esi
  8004b6:	53                   	push   %ebx
  8004b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ba:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004bd:	e8 41 0b 00 00       	call   801003 <sys_getenvid>
  8004c2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004c7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004cf:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7e 07                	jle    8004df <libmain+0x31>
		binaryname = argv[0];
  8004d8:	8b 06                	mov    (%esi),%eax
  8004da:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004df:	83 ec 08             	sub    $0x8,%esp
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	e8 06 fc ff ff       	call   8000ef <umain>

	// exit gracefully
	exit();
  8004e9:	e8 0a 00 00 00       	call   8004f8 <exit>
}
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004f4:	5b                   	pop    %ebx
  8004f5:	5e                   	pop    %esi
  8004f6:	5d                   	pop    %ebp
  8004f7:	c3                   	ret    

008004f8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004f8:	f3 0f 1e fb          	endbr32 
  8004fc:	55                   	push   %ebp
  8004fd:	89 e5                	mov    %esp,%ebp
  8004ff:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800502:	e8 a8 12 00 00       	call   8017af <close_all>
	sys_env_destroy(0);
  800507:	83 ec 0c             	sub    $0xc,%esp
  80050a:	6a 00                	push   $0x0
  80050c:	e8 ad 0a 00 00       	call   800fbe <sys_env_destroy>
}
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	c9                   	leave  
  800515:	c3                   	ret    

00800516 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800516:	f3 0f 1e fb          	endbr32 
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	56                   	push   %esi
  80051e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80051f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800522:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  800528:	e8 d6 0a 00 00       	call   801003 <sys_getenvid>
  80052d:	83 ec 0c             	sub    $0xc,%esp
  800530:	ff 75 0c             	pushl  0xc(%ebp)
  800533:	ff 75 08             	pushl  0x8(%ebp)
  800536:	56                   	push   %esi
  800537:	50                   	push   %eax
  800538:	68 4c 32 80 00       	push   $0x80324c
  80053d:	e8 bb 00 00 00       	call   8005fd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800542:	83 c4 18             	add    $0x18,%esp
  800545:	53                   	push   %ebx
  800546:	ff 75 10             	pushl  0x10(%ebp)
  800549:	e8 5a 00 00 00       	call   8005a8 <vcprintf>
	cprintf("\n");
  80054e:	c7 04 24 78 31 80 00 	movl   $0x803178,(%esp)
  800555:	e8 a3 00 00 00       	call   8005fd <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80055d:	cc                   	int3   
  80055e:	eb fd                	jmp    80055d <_panic+0x47>

00800560 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800560:	f3 0f 1e fb          	endbr32 
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	53                   	push   %ebx
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80056e:	8b 13                	mov    (%ebx),%edx
  800570:	8d 42 01             	lea    0x1(%edx),%eax
  800573:	89 03                	mov    %eax,(%ebx)
  800575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800578:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80057c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800581:	74 09                	je     80058c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	68 ff 00 00 00       	push   $0xff
  800594:	8d 43 08             	lea    0x8(%ebx),%eax
  800597:	50                   	push   %eax
  800598:	e8 dc 09 00 00       	call   800f79 <sys_cputs>
		b->idx = 0;
  80059d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb db                	jmp    800583 <putch+0x23>

008005a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005a8:	f3 0f 1e fb          	endbr32 
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005bc:	00 00 00 
	b.cnt = 0;
  8005bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d5:	50                   	push   %eax
  8005d6:	68 60 05 80 00       	push   $0x800560
  8005db:	e8 20 01 00 00       	call   800700 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005e0:	83 c4 08             	add    $0x8,%esp
  8005e3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005ef:	50                   	push   %eax
  8005f0:	e8 84 09 00 00       	call   800f79 <sys_cputs>

	return b.cnt;
}
  8005f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005fd:	f3 0f 1e fb          	endbr32 
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800607:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80060a:	50                   	push   %eax
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 95 ff ff ff       	call   8005a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800613:	c9                   	leave  
  800614:	c3                   	ret    

00800615 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800615:	55                   	push   %ebp
  800616:	89 e5                	mov    %esp,%ebp
  800618:	57                   	push   %edi
  800619:	56                   	push   %esi
  80061a:	53                   	push   %ebx
  80061b:	83 ec 1c             	sub    $0x1c,%esp
  80061e:	89 c7                	mov    %eax,%edi
  800620:	89 d6                	mov    %edx,%esi
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	8b 55 0c             	mov    0xc(%ebp),%edx
  800628:	89 d1                	mov    %edx,%ecx
  80062a:	89 c2                	mov    %eax,%edx
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800632:	8b 45 10             	mov    0x10(%ebp),%eax
  800635:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800642:	39 c2                	cmp    %eax,%edx
  800644:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800647:	72 3e                	jb     800687 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800649:	83 ec 0c             	sub    $0xc,%esp
  80064c:	ff 75 18             	pushl  0x18(%ebp)
  80064f:	83 eb 01             	sub    $0x1,%ebx
  800652:	53                   	push   %ebx
  800653:	50                   	push   %eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 e4             	pushl  -0x1c(%ebp)
  80065a:	ff 75 e0             	pushl  -0x20(%ebp)
  80065d:	ff 75 dc             	pushl  -0x24(%ebp)
  800660:	ff 75 d8             	pushl  -0x28(%ebp)
  800663:	e8 38 28 00 00       	call   802ea0 <__udivdi3>
  800668:	83 c4 18             	add    $0x18,%esp
  80066b:	52                   	push   %edx
  80066c:	50                   	push   %eax
  80066d:	89 f2                	mov    %esi,%edx
  80066f:	89 f8                	mov    %edi,%eax
  800671:	e8 9f ff ff ff       	call   800615 <printnum>
  800676:	83 c4 20             	add    $0x20,%esp
  800679:	eb 13                	jmp    80068e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	56                   	push   %esi
  80067f:	ff 75 18             	pushl  0x18(%ebp)
  800682:	ff d7                	call   *%edi
  800684:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800687:	83 eb 01             	sub    $0x1,%ebx
  80068a:	85 db                	test   %ebx,%ebx
  80068c:	7f ed                	jg     80067b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068e:	83 ec 08             	sub    $0x8,%esp
  800691:	56                   	push   %esi
  800692:	83 ec 04             	sub    $0x4,%esp
  800695:	ff 75 e4             	pushl  -0x1c(%ebp)
  800698:	ff 75 e0             	pushl  -0x20(%ebp)
  80069b:	ff 75 dc             	pushl  -0x24(%ebp)
  80069e:	ff 75 d8             	pushl  -0x28(%ebp)
  8006a1:	e8 0a 29 00 00       	call   802fb0 <__umoddi3>
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	0f be 80 6f 32 80 00 	movsbl 0x80326f(%eax),%eax
  8006b0:	50                   	push   %eax
  8006b1:	ff d7                	call   *%edi
}
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006be:	f3 0f 1e fb          	endbr32 
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006cc:	8b 10                	mov    (%eax),%edx
  8006ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8006d1:	73 0a                	jae    8006dd <sprintputch+0x1f>
		*b->buf++ = ch;
  8006d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006d6:	89 08                	mov    %ecx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	88 02                	mov    %al,(%edx)
}
  8006dd:	5d                   	pop    %ebp
  8006de:	c3                   	ret    

008006df <printfmt>:
{
  8006df:	f3 0f 1e fb          	endbr32 
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006e9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ec:	50                   	push   %eax
  8006ed:	ff 75 10             	pushl  0x10(%ebp)
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 05 00 00 00       	call   800700 <vprintfmt>
}
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	c9                   	leave  
  8006ff:	c3                   	ret    

00800700 <vprintfmt>:
{
  800700:	f3 0f 1e fb          	endbr32 
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	57                   	push   %edi
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 3c             	sub    $0x3c,%esp
  80070d:	8b 75 08             	mov    0x8(%ebp),%esi
  800710:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800713:	8b 7d 10             	mov    0x10(%ebp),%edi
  800716:	e9 8e 03 00 00       	jmp    800aa9 <vprintfmt+0x3a9>
		padc = ' ';
  80071b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80071f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800726:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80072d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800734:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800739:	8d 47 01             	lea    0x1(%edi),%eax
  80073c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073f:	0f b6 17             	movzbl (%edi),%edx
  800742:	8d 42 dd             	lea    -0x23(%edx),%eax
  800745:	3c 55                	cmp    $0x55,%al
  800747:	0f 87 df 03 00 00    	ja     800b2c <vprintfmt+0x42c>
  80074d:	0f b6 c0             	movzbl %al,%eax
  800750:	3e ff 24 85 c0 33 80 	notrack jmp *0x8033c0(,%eax,4)
  800757:	00 
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80075b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80075f:	eb d8                	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800764:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800768:	eb cf                	jmp    800739 <vprintfmt+0x39>
  80076a:	0f b6 d2             	movzbl %dl,%edx
  80076d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800770:	b8 00 00 00 00       	mov    $0x0,%eax
  800775:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800778:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80077b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80077f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800782:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800785:	83 f9 09             	cmp    $0x9,%ecx
  800788:	77 55                	ja     8007df <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80078a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80078d:	eb e9                	jmp    800778 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 40 04             	lea    0x4(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a7:	79 90                	jns    800739 <vprintfmt+0x39>
				width = precision, precision = -1;
  8007a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007af:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007b6:	eb 81                	jmp    800739 <vprintfmt+0x39>
  8007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c2:	0f 49 d0             	cmovns %eax,%edx
  8007c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007cb:	e9 69 ff ff ff       	jmp    800739 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007d3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007da:	e9 5a ff ff ff       	jmp    800739 <vprintfmt+0x39>
  8007df:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e5:	eb bc                	jmp    8007a3 <vprintfmt+0xa3>
			lflag++;
  8007e7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007ed:	e9 47 ff ff ff       	jmp    800739 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	8d 78 04             	lea    0x4(%eax),%edi
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	53                   	push   %ebx
  8007fc:	ff 30                	pushl  (%eax)
  8007fe:	ff d6                	call   *%esi
			break;
  800800:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800803:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800806:	e9 9b 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 78 04             	lea    0x4(%eax),%edi
  800811:	8b 00                	mov    (%eax),%eax
  800813:	99                   	cltd   
  800814:	31 d0                	xor    %edx,%eax
  800816:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800818:	83 f8 0f             	cmp    $0xf,%eax
  80081b:	7f 23                	jg     800840 <vprintfmt+0x140>
  80081d:	8b 14 85 20 35 80 00 	mov    0x803520(,%eax,4),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 18                	je     800840 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800828:	52                   	push   %edx
  800829:	68 75 37 80 00       	push   $0x803775
  80082e:	53                   	push   %ebx
  80082f:	56                   	push   %esi
  800830:	e8 aa fe ff ff       	call   8006df <printfmt>
  800835:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800838:	89 7d 14             	mov    %edi,0x14(%ebp)
  80083b:	e9 66 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800840:	50                   	push   %eax
  800841:	68 87 32 80 00       	push   $0x803287
  800846:	53                   	push   %ebx
  800847:	56                   	push   %esi
  800848:	e8 92 fe ff ff       	call   8006df <printfmt>
  80084d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800850:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800853:	e9 4e 02 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800866:	85 d2                	test   %edx,%edx
  800868:	b8 80 32 80 00       	mov    $0x803280,%eax
  80086d:	0f 45 c2             	cmovne %edx,%eax
  800870:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800873:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800877:	7e 06                	jle    80087f <vprintfmt+0x17f>
  800879:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80087d:	75 0d                	jne    80088c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80087f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800882:	89 c7                	mov    %eax,%edi
  800884:	03 45 e0             	add    -0x20(%ebp),%eax
  800887:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80088a:	eb 55                	jmp    8008e1 <vprintfmt+0x1e1>
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 d8             	pushl  -0x28(%ebp)
  800892:	ff 75 cc             	pushl  -0x34(%ebp)
  800895:	e8 46 03 00 00       	call   800be0 <strnlen>
  80089a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089d:	29 c2                	sub    %eax,%edx
  80089f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8008a7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ae:	85 ff                	test   %edi,%edi
  8008b0:	7e 11                	jle    8008c3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	53                   	push   %ebx
  8008b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8008b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bb:	83 ef 01             	sub    $0x1,%edi
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	eb eb                	jmp    8008ae <vprintfmt+0x1ae>
  8008c3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008c6:	85 d2                	test   %edx,%edx
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	0f 49 c2             	cmovns %edx,%eax
  8008d0:	29 c2                	sub    %eax,%edx
  8008d2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008d5:	eb a8                	jmp    80087f <vprintfmt+0x17f>
					putch(ch, putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	53                   	push   %ebx
  8008db:	52                   	push   %edx
  8008dc:	ff d6                	call   *%esi
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e6:	83 c7 01             	add    $0x1,%edi
  8008e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008ed:	0f be d0             	movsbl %al,%edx
  8008f0:	85 d2                	test   %edx,%edx
  8008f2:	74 4b                	je     80093f <vprintfmt+0x23f>
  8008f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008f8:	78 06                	js     800900 <vprintfmt+0x200>
  8008fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008fe:	78 1e                	js     80091e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800900:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800904:	74 d1                	je     8008d7 <vprintfmt+0x1d7>
  800906:	0f be c0             	movsbl %al,%eax
  800909:	83 e8 20             	sub    $0x20,%eax
  80090c:	83 f8 5e             	cmp    $0x5e,%eax
  80090f:	76 c6                	jbe    8008d7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	6a 3f                	push   $0x3f
  800917:	ff d6                	call   *%esi
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	eb c3                	jmp    8008e1 <vprintfmt+0x1e1>
  80091e:	89 cf                	mov    %ecx,%edi
  800920:	eb 0e                	jmp    800930 <vprintfmt+0x230>
				putch(' ', putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	53                   	push   %ebx
  800926:	6a 20                	push   $0x20
  800928:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80092a:	83 ef 01             	sub    $0x1,%edi
  80092d:	83 c4 10             	add    $0x10,%esp
  800930:	85 ff                	test   %edi,%edi
  800932:	7f ee                	jg     800922 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800937:	89 45 14             	mov    %eax,0x14(%ebp)
  80093a:	e9 67 01 00 00       	jmp    800aa6 <vprintfmt+0x3a6>
  80093f:	89 cf                	mov    %ecx,%edi
  800941:	eb ed                	jmp    800930 <vprintfmt+0x230>
	if (lflag >= 2)
  800943:	83 f9 01             	cmp    $0x1,%ecx
  800946:	7f 1b                	jg     800963 <vprintfmt+0x263>
	else if (lflag)
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	74 63                	je     8009af <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800954:	99                   	cltd   
  800955:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	8d 40 04             	lea    0x4(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	eb 17                	jmp    80097a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800963:	8b 45 14             	mov    0x14(%ebp),%eax
  800966:	8b 50 04             	mov    0x4(%eax),%edx
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80096e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 40 08             	lea    0x8(%eax),%eax
  800977:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80097d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800980:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800985:	85 c9                	test   %ecx,%ecx
  800987:	0f 89 ff 00 00 00    	jns    800a8c <vprintfmt+0x38c>
				putch('-', putdat);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	53                   	push   %ebx
  800991:	6a 2d                	push   $0x2d
  800993:	ff d6                	call   *%esi
				num = -(long long) num;
  800995:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800998:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80099b:	f7 da                	neg    %edx
  80099d:	83 d1 00             	adc    $0x0,%ecx
  8009a0:	f7 d9                	neg    %ecx
  8009a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009aa:	e9 dd 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b7:	99                   	cltd   
  8009b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8d 40 04             	lea    0x4(%eax),%eax
  8009c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c4:	eb b4                	jmp    80097a <vprintfmt+0x27a>
	if (lflag >= 2)
  8009c6:	83 f9 01             	cmp    $0x1,%ecx
  8009c9:	7f 1e                	jg     8009e9 <vprintfmt+0x2e9>
	else if (lflag)
  8009cb:	85 c9                	test   %ecx,%ecx
  8009cd:	74 32                	je     800a01 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d2:	8b 10                	mov    (%eax),%edx
  8009d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009d9:	8d 40 04             	lea    0x4(%eax),%eax
  8009dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009df:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009e4:	e9 a3 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	8b 10                	mov    (%eax),%edx
  8009ee:	8b 48 04             	mov    0x4(%eax),%ecx
  8009f1:	8d 40 08             	lea    0x8(%eax),%eax
  8009f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009f7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8009fc:	e9 8b 00 00 00       	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a01:	8b 45 14             	mov    0x14(%ebp),%eax
  800a04:	8b 10                	mov    (%eax),%edx
  800a06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0b:	8d 40 04             	lea    0x4(%eax),%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a11:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a16:	eb 74                	jmp    800a8c <vprintfmt+0x38c>
	if (lflag >= 2)
  800a18:	83 f9 01             	cmp    $0x1,%ecx
  800a1b:	7f 1b                	jg     800a38 <vprintfmt+0x338>
	else if (lflag)
  800a1d:	85 c9                	test   %ecx,%ecx
  800a1f:	74 2c                	je     800a4d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	8b 10                	mov    (%eax),%edx
  800a26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a2b:	8d 40 04             	lea    0x4(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a36:	eb 54                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 10                	mov    (%eax),%edx
  800a3d:	8b 48 04             	mov    0x4(%eax),%ecx
  800a40:	8d 40 08             	lea    0x8(%eax),%eax
  800a43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a46:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a4b:	eb 3f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a50:	8b 10                	mov    (%eax),%edx
  800a52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a57:	8d 40 04             	lea    0x4(%eax),%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a5d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a62:	eb 28                	jmp    800a8c <vprintfmt+0x38c>
			putch('0', putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	53                   	push   %ebx
  800a68:	6a 30                	push   $0x30
  800a6a:	ff d6                	call   *%esi
			putch('x', putdat);
  800a6c:	83 c4 08             	add    $0x8,%esp
  800a6f:	53                   	push   %ebx
  800a70:	6a 78                	push   $0x78
  800a72:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	8b 10                	mov    (%eax),%edx
  800a79:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a7e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a81:	8d 40 04             	lea    0x4(%eax),%eax
  800a84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a87:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a8c:	83 ec 0c             	sub    $0xc,%esp
  800a8f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a93:	57                   	push   %edi
  800a94:	ff 75 e0             	pushl  -0x20(%ebp)
  800a97:	50                   	push   %eax
  800a98:	51                   	push   %ecx
  800a99:	52                   	push   %edx
  800a9a:	89 da                	mov    %ebx,%edx
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	e8 72 fb ff ff       	call   800615 <printnum>
			break;
  800aa3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa9:	83 c7 01             	add    $0x1,%edi
  800aac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab0:	83 f8 25             	cmp    $0x25,%eax
  800ab3:	0f 84 62 fc ff ff    	je     80071b <vprintfmt+0x1b>
			if (ch == '\0')
  800ab9:	85 c0                	test   %eax,%eax
  800abb:	0f 84 8b 00 00 00    	je     800b4c <vprintfmt+0x44c>
			putch(ch, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	53                   	push   %ebx
  800ac5:	50                   	push   %eax
  800ac6:	ff d6                	call   *%esi
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	eb dc                	jmp    800aa9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800acd:	83 f9 01             	cmp    $0x1,%ecx
  800ad0:	7f 1b                	jg     800aed <vprintfmt+0x3ed>
	else if (lflag)
  800ad2:	85 c9                	test   %ecx,%ecx
  800ad4:	74 2c                	je     800b02 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	8b 10                	mov    (%eax),%edx
  800adb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae0:	8d 40 04             	lea    0x4(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800aeb:	eb 9f                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8b 10                	mov    (%eax),%edx
  800af2:	8b 48 04             	mov    0x4(%eax),%ecx
  800af5:	8d 40 08             	lea    0x8(%eax),%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800afb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800b00:	eb 8a                	jmp    800a8c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0c:	8d 40 04             	lea    0x4(%eax),%eax
  800b0f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b12:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b17:	e9 70 ff ff ff       	jmp    800a8c <vprintfmt+0x38c>
			putch(ch, putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	53                   	push   %ebx
  800b20:	6a 25                	push   $0x25
  800b22:	ff d6                	call   *%esi
			break;
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	e9 7a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
			putch('%', putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	53                   	push   %ebx
  800b30:	6a 25                	push   $0x25
  800b32:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b34:	83 c4 10             	add    $0x10,%esp
  800b37:	89 f8                	mov    %edi,%eax
  800b39:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b3d:	74 05                	je     800b44 <vprintfmt+0x444>
  800b3f:	83 e8 01             	sub    $0x1,%eax
  800b42:	eb f5                	jmp    800b39 <vprintfmt+0x439>
  800b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b47:	e9 5a ff ff ff       	jmp    800aa6 <vprintfmt+0x3a6>
}
  800b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b54:	f3 0f 1e fb          	endbr32 
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b67:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b6b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b75:	85 c0                	test   %eax,%eax
  800b77:	74 26                	je     800b9f <vsnprintf+0x4b>
  800b79:	85 d2                	test   %edx,%edx
  800b7b:	7e 22                	jle    800b9f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b7d:	ff 75 14             	pushl  0x14(%ebp)
  800b80:	ff 75 10             	pushl  0x10(%ebp)
  800b83:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	68 be 06 80 00       	push   $0x8006be
  800b8c:	e8 6f fb ff ff       	call   800700 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b94:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b9a:	83 c4 10             	add    $0x10,%esp
}
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    
		return -E_INVAL;
  800b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ba4:	eb f7                	jmp    800b9d <vsnprintf+0x49>

00800ba6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ba6:	f3 0f 1e fb          	endbr32 
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bb3:	50                   	push   %eax
  800bb4:	ff 75 10             	pushl  0x10(%ebp)
  800bb7:	ff 75 0c             	pushl  0xc(%ebp)
  800bba:	ff 75 08             	pushl  0x8(%ebp)
  800bbd:	e8 92 ff ff ff       	call   800b54 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bd7:	74 05                	je     800bde <strlen+0x1a>
		n++;
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	eb f5                	jmp    800bd3 <strlen+0xf>
	return n;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be0:	f3 0f 1e fb          	endbr32 
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	39 d0                	cmp    %edx,%eax
  800bf4:	74 0d                	je     800c03 <strnlen+0x23>
  800bf6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800bfa:	74 05                	je     800c01 <strnlen+0x21>
		n++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	eb f1                	jmp    800bf2 <strnlen+0x12>
  800c01:	89 c2                	mov    %eax,%edx
	return n;
}
  800c03:	89 d0                	mov    %edx,%eax
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	f3 0f 1e fb          	endbr32 
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	53                   	push   %ebx
  800c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c15:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c1e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c21:	83 c0 01             	add    $0x1,%eax
  800c24:	84 d2                	test   %dl,%dl
  800c26:	75 f2                	jne    800c1a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c28:	89 c8                	mov    %ecx,%eax
  800c2a:	5b                   	pop    %ebx
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c2d:	f3 0f 1e fb          	endbr32 
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	53                   	push   %ebx
  800c35:	83 ec 10             	sub    $0x10,%esp
  800c38:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c3b:	53                   	push   %ebx
  800c3c:	e8 83 ff ff ff       	call   800bc4 <strlen>
  800c41:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	01 d8                	add    %ebx,%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 b8 ff ff ff       	call   800c07 <strcpy>
	return dst;
}
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c56:	f3 0f 1e fb          	endbr32 
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	8b 75 08             	mov    0x8(%ebp),%esi
  800c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6a:	89 f0                	mov    %esi,%eax
  800c6c:	39 d8                	cmp    %ebx,%eax
  800c6e:	74 11                	je     800c81 <strncpy+0x2b>
		*dst++ = *src;
  800c70:	83 c0 01             	add    $0x1,%eax
  800c73:	0f b6 0a             	movzbl (%edx),%ecx
  800c76:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c79:	80 f9 01             	cmp    $0x1,%cl
  800c7c:	83 da ff             	sbb    $0xffffffff,%edx
  800c7f:	eb eb                	jmp    800c6c <strncpy+0x16>
	}
	return ret;
}
  800c81:	89 f0                	mov    %esi,%eax
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	8b 75 08             	mov    0x8(%ebp),%esi
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	8b 55 10             	mov    0x10(%ebp),%edx
  800c99:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c9b:	85 d2                	test   %edx,%edx
  800c9d:	74 21                	je     800cc0 <strlcpy+0x39>
  800c9f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ca3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	74 14                	je     800cbd <strlcpy+0x36>
  800ca9:	0f b6 19             	movzbl (%ecx),%ebx
  800cac:	84 db                	test   %bl,%bl
  800cae:	74 0b                	je     800cbb <strlcpy+0x34>
			*dst++ = *src++;
  800cb0:	83 c1 01             	add    $0x1,%ecx
  800cb3:	83 c2 01             	add    $0x1,%edx
  800cb6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cb9:	eb ea                	jmp    800ca5 <strlcpy+0x1e>
  800cbb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cbd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc0:	29 f0                	sub    %esi,%eax
}
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc6:	f3 0f 1e fb          	endbr32 
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cd3:	0f b6 01             	movzbl (%ecx),%eax
  800cd6:	84 c0                	test   %al,%al
  800cd8:	74 0c                	je     800ce6 <strcmp+0x20>
  800cda:	3a 02                	cmp    (%edx),%al
  800cdc:	75 08                	jne    800ce6 <strcmp+0x20>
		p++, q++;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	83 c2 01             	add    $0x1,%edx
  800ce4:	eb ed                	jmp    800cd3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	0f b6 c0             	movzbl %al,%eax
  800ce9:	0f b6 12             	movzbl (%edx),%edx
  800cec:	29 d0                	sub    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	53                   	push   %ebx
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfe:	89 c3                	mov    %eax,%ebx
  800d00:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d03:	eb 06                	jmp    800d0b <strncmp+0x1b>
		n--, p++, q++;
  800d05:	83 c0 01             	add    $0x1,%eax
  800d08:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d0b:	39 d8                	cmp    %ebx,%eax
  800d0d:	74 16                	je     800d25 <strncmp+0x35>
  800d0f:	0f b6 08             	movzbl (%eax),%ecx
  800d12:	84 c9                	test   %cl,%cl
  800d14:	74 04                	je     800d1a <strncmp+0x2a>
  800d16:	3a 0a                	cmp    (%edx),%cl
  800d18:	74 eb                	je     800d05 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	0f b6 00             	movzbl (%eax),%eax
  800d1d:	0f b6 12             	movzbl (%edx),%edx
  800d20:	29 d0                	sub    %edx,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    
		return 0;
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	eb f6                	jmp    800d22 <strncmp+0x32>

00800d2c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d2c:	f3 0f 1e fb          	endbr32 
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d3a:	0f b6 10             	movzbl (%eax),%edx
  800d3d:	84 d2                	test   %dl,%dl
  800d3f:	74 09                	je     800d4a <strchr+0x1e>
		if (*s == c)
  800d41:	38 ca                	cmp    %cl,%dl
  800d43:	74 0a                	je     800d4f <strchr+0x23>
	for (; *s; s++)
  800d45:	83 c0 01             	add    $0x1,%eax
  800d48:	eb f0                	jmp    800d3a <strchr+0xe>
			return (char *) s;
	return 0;
  800d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    

00800d51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d51:	f3 0f 1e fb          	endbr32 
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d5f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d62:	38 ca                	cmp    %cl,%dl
  800d64:	74 09                	je     800d6f <strfind+0x1e>
  800d66:	84 d2                	test   %dl,%dl
  800d68:	74 05                	je     800d6f <strfind+0x1e>
	for (; *s; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	eb f0                	jmp    800d5f <strfind+0xe>
			break;
	return (char *) s;
}
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    

00800d71 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d81:	85 c9                	test   %ecx,%ecx
  800d83:	74 31                	je     800db6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d85:	89 f8                	mov    %edi,%eax
  800d87:	09 c8                	or     %ecx,%eax
  800d89:	a8 03                	test   $0x3,%al
  800d8b:	75 23                	jne    800db0 <memset+0x3f>
		c &= 0xFF;
  800d8d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d91:	89 d3                	mov    %edx,%ebx
  800d93:	c1 e3 08             	shl    $0x8,%ebx
  800d96:	89 d0                	mov    %edx,%eax
  800d98:	c1 e0 18             	shl    $0x18,%eax
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	c1 e6 10             	shl    $0x10,%esi
  800da0:	09 f0                	or     %esi,%eax
  800da2:	09 c2                	or     %eax,%edx
  800da4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800da6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800da9:	89 d0                	mov    %edx,%eax
  800dab:	fc                   	cld    
  800dac:	f3 ab                	rep stos %eax,%es:(%edi)
  800dae:	eb 06                	jmp    800db6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	fc                   	cld    
  800db4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db6:	89 f8                	mov    %edi,%eax
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dbd:	f3 0f 1e fb          	endbr32 
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dcf:	39 c6                	cmp    %eax,%esi
  800dd1:	73 32                	jae    800e05 <memmove+0x48>
  800dd3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	76 2b                	jbe    800e05 <memmove+0x48>
		s += n;
		d += n;
  800dda:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddd:	89 fe                	mov    %edi,%esi
  800ddf:	09 ce                	or     %ecx,%esi
  800de1:	09 d6                	or     %edx,%esi
  800de3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de9:	75 0e                	jne    800df9 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800deb:	83 ef 04             	sub    $0x4,%edi
  800dee:	8d 72 fc             	lea    -0x4(%edx),%esi
  800df1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800df4:	fd                   	std    
  800df5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df7:	eb 09                	jmp    800e02 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800df9:	83 ef 01             	sub    $0x1,%edi
  800dfc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dff:	fd                   	std    
  800e00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e02:	fc                   	cld    
  800e03:	eb 1a                	jmp    800e1f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	09 ca                	or     %ecx,%edx
  800e09:	09 f2                	or     %esi,%edx
  800e0b:	f6 c2 03             	test   $0x3,%dl
  800e0e:	75 0a                	jne    800e1a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e13:	89 c7                	mov    %eax,%edi
  800e15:	fc                   	cld    
  800e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e18:	eb 05                	jmp    800e1f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e1a:	89 c7                	mov    %eax,%edi
  800e1c:	fc                   	cld    
  800e1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e23:	f3 0f 1e fb          	endbr32 
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e2d:	ff 75 10             	pushl  0x10(%ebp)
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	e8 82 ff ff ff       	call   800dbd <memmove>
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e4c:	89 c6                	mov    %eax,%esi
  800e4e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e51:	39 f0                	cmp    %esi,%eax
  800e53:	74 1c                	je     800e71 <memcmp+0x34>
		if (*s1 != *s2)
  800e55:	0f b6 08             	movzbl (%eax),%ecx
  800e58:	0f b6 1a             	movzbl (%edx),%ebx
  800e5b:	38 d9                	cmp    %bl,%cl
  800e5d:	75 08                	jne    800e67 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e5f:	83 c0 01             	add    $0x1,%eax
  800e62:	83 c2 01             	add    $0x1,%edx
  800e65:	eb ea                	jmp    800e51 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e67:	0f b6 c1             	movzbl %cl,%eax
  800e6a:	0f b6 db             	movzbl %bl,%ebx
  800e6d:	29 d8                	sub    %ebx,%eax
  800e6f:	eb 05                	jmp    800e76 <memcmp+0x39>
	}

	return 0;
  800e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e7a:	f3 0f 1e fb          	endbr32 
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e87:	89 c2                	mov    %eax,%edx
  800e89:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e8c:	39 d0                	cmp    %edx,%eax
  800e8e:	73 09                	jae    800e99 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e90:	38 08                	cmp    %cl,(%eax)
  800e92:	74 05                	je     800e99 <memfind+0x1f>
	for (; s < ends; s++)
  800e94:	83 c0 01             	add    $0x1,%eax
  800e97:	eb f3                	jmp    800e8c <memfind+0x12>
			break;
	return (void *) s;
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9b:	f3 0f 1e fb          	endbr32 
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eab:	eb 03                	jmp    800eb0 <strtol+0x15>
		s++;
  800ead:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb0:	0f b6 01             	movzbl (%ecx),%eax
  800eb3:	3c 20                	cmp    $0x20,%al
  800eb5:	74 f6                	je     800ead <strtol+0x12>
  800eb7:	3c 09                	cmp    $0x9,%al
  800eb9:	74 f2                	je     800ead <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ebb:	3c 2b                	cmp    $0x2b,%al
  800ebd:	74 2a                	je     800ee9 <strtol+0x4e>
	int neg = 0;
  800ebf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ec4:	3c 2d                	cmp    $0x2d,%al
  800ec6:	74 2b                	je     800ef3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ece:	75 0f                	jne    800edf <strtol+0x44>
  800ed0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ed3:	74 28                	je     800efd <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ed5:	85 db                	test   %ebx,%ebx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	0f 44 d8             	cmove  %eax,%ebx
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ee7:	eb 46                	jmp    800f2f <strtol+0x94>
		s++;
  800ee9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800eec:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef1:	eb d5                	jmp    800ec8 <strtol+0x2d>
		s++, neg = 1;
  800ef3:	83 c1 01             	add    $0x1,%ecx
  800ef6:	bf 01 00 00 00       	mov    $0x1,%edi
  800efb:	eb cb                	jmp    800ec8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800efd:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f01:	74 0e                	je     800f11 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f03:	85 db                	test   %ebx,%ebx
  800f05:	75 d8                	jne    800edf <strtol+0x44>
		s++, base = 8;
  800f07:	83 c1 01             	add    $0x1,%ecx
  800f0a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f0f:	eb ce                	jmp    800edf <strtol+0x44>
		s += 2, base = 16;
  800f11:	83 c1 02             	add    $0x2,%ecx
  800f14:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f19:	eb c4                	jmp    800edf <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f1b:	0f be d2             	movsbl %dl,%edx
  800f1e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f24:	7d 3a                	jge    800f60 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f26:	83 c1 01             	add    $0x1,%ecx
  800f29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f2f:	0f b6 11             	movzbl (%ecx),%edx
  800f32:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f35:	89 f3                	mov    %esi,%ebx
  800f37:	80 fb 09             	cmp    $0x9,%bl
  800f3a:	76 df                	jbe    800f1b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f3c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f3f:	89 f3                	mov    %esi,%ebx
  800f41:	80 fb 19             	cmp    $0x19,%bl
  800f44:	77 08                	ja     800f4e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f46:	0f be d2             	movsbl %dl,%edx
  800f49:	83 ea 57             	sub    $0x57,%edx
  800f4c:	eb d3                	jmp    800f21 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f4e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f51:	89 f3                	mov    %esi,%ebx
  800f53:	80 fb 19             	cmp    $0x19,%bl
  800f56:	77 08                	ja     800f60 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f58:	0f be d2             	movsbl %dl,%edx
  800f5b:	83 ea 37             	sub    $0x37,%edx
  800f5e:	eb c1                	jmp    800f21 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f64:	74 05                	je     800f6b <strtol+0xd0>
		*endptr = (char *) s;
  800f66:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f69:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f6b:	89 c2                	mov    %eax,%edx
  800f6d:	f7 da                	neg    %edx
  800f6f:	85 ff                	test   %edi,%edi
  800f71:	0f 45 c2             	cmovne %edx,%eax
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f79:	f3 0f 1e fb          	endbr32 
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f83:	b8 00 00 00 00       	mov    $0x0,%eax
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	89 c7                	mov    %eax,%edi
  800f92:	89 c6                	mov    %eax,%esi
  800f94:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_cgetc>:

int
sys_cgetc(void)
{
  800f9b:	f3 0f 1e fb          	endbr32 
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  800faa:	b8 01 00 00 00       	mov    $0x1,%eax
  800faf:	89 d1                	mov    %edx,%ecx
  800fb1:	89 d3                	mov    %edx,%ebx
  800fb3:	89 d7                	mov    %edx,%edi
  800fb5:	89 d6                	mov    %edx,%esi
  800fb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	57                   	push   %edi
  800fc6:	56                   	push   %esi
  800fc7:	53                   	push   %ebx
  800fc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd8:	89 cb                	mov    %ecx,%ebx
  800fda:	89 cf                	mov    %ecx,%edi
  800fdc:	89 ce                	mov    %ecx,%esi
  800fde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	7f 08                	jg     800fec <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	83 ec 0c             	sub    $0xc,%esp
  800fef:	50                   	push   %eax
  800ff0:	6a 03                	push   $0x3
  800ff2:	68 7f 35 80 00       	push   $0x80357f
  800ff7:	6a 23                	push   $0x23
  800ff9:	68 9c 35 80 00       	push   $0x80359c
  800ffe:	e8 13 f5 ff ff       	call   800516 <_panic>

00801003 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801003:	f3 0f 1e fb          	endbr32 
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100d:	ba 00 00 00 00       	mov    $0x0,%edx
  801012:	b8 02 00 00 00       	mov    $0x2,%eax
  801017:	89 d1                	mov    %edx,%ecx
  801019:	89 d3                	mov    %edx,%ebx
  80101b:	89 d7                	mov    %edx,%edi
  80101d:	89 d6                	mov    %edx,%esi
  80101f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_yield>:

void
sys_yield(void)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	ba 00 00 00 00       	mov    $0x0,%edx
  801035:	b8 0b 00 00 00       	mov    $0xb,%eax
  80103a:	89 d1                	mov    %edx,%ecx
  80103c:	89 d3                	mov    %edx,%ebx
  80103e:	89 d7                	mov    %edx,%edi
  801040:	89 d6                	mov    %edx,%esi
  801042:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801049:	f3 0f 1e fb          	endbr32 
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801056:	be 00 00 00 00       	mov    $0x0,%esi
  80105b:	8b 55 08             	mov    0x8(%ebp),%edx
  80105e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801061:	b8 04 00 00 00       	mov    $0x4,%eax
  801066:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801069:	89 f7                	mov    %esi,%edi
  80106b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7f 08                	jg     801079 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801071:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	50                   	push   %eax
  80107d:	6a 04                	push   $0x4
  80107f:	68 7f 35 80 00       	push   $0x80357f
  801084:	6a 23                	push   $0x23
  801086:	68 9c 35 80 00       	push   $0x80359c
  80108b:	e8 86 f4 ff ff       	call   800516 <_panic>

00801090 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8010a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ab:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8010b1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	7f 08                	jg     8010bf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ba:	5b                   	pop    %ebx
  8010bb:	5e                   	pop    %esi
  8010bc:	5f                   	pop    %edi
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010bf:	83 ec 0c             	sub    $0xc,%esp
  8010c2:	50                   	push   %eax
  8010c3:	6a 05                	push   $0x5
  8010c5:	68 7f 35 80 00       	push   $0x80357f
  8010ca:	6a 23                	push   $0x23
  8010cc:	68 9c 35 80 00       	push   $0x80359c
  8010d1:	e8 40 f4 ff ff       	call   800516 <_panic>

008010d6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
  8010e0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ee:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f3:	89 df                	mov    %ebx,%edi
  8010f5:	89 de                	mov    %ebx,%esi
  8010f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	7f 08                	jg     801105 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801100:	5b                   	pop    %ebx
  801101:	5e                   	pop    %esi
  801102:	5f                   	pop    %edi
  801103:	5d                   	pop    %ebp
  801104:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	50                   	push   %eax
  801109:	6a 06                	push   $0x6
  80110b:	68 7f 35 80 00       	push   $0x80357f
  801110:	6a 23                	push   $0x23
  801112:	68 9c 35 80 00       	push   $0x80359c
  801117:	e8 fa f3 ff ff       	call   800516 <_panic>

0080111c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80111c:	f3 0f 1e fb          	endbr32 
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	57                   	push   %edi
  801124:	56                   	push   %esi
  801125:	53                   	push   %ebx
  801126:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801129:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112e:	8b 55 08             	mov    0x8(%ebp),%edx
  801131:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801134:	b8 08 00 00 00       	mov    $0x8,%eax
  801139:	89 df                	mov    %ebx,%edi
  80113b:	89 de                	mov    %ebx,%esi
  80113d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113f:	85 c0                	test   %eax,%eax
  801141:	7f 08                	jg     80114b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	83 ec 0c             	sub    $0xc,%esp
  80114e:	50                   	push   %eax
  80114f:	6a 08                	push   $0x8
  801151:	68 7f 35 80 00       	push   $0x80357f
  801156:	6a 23                	push   $0x23
  801158:	68 9c 35 80 00       	push   $0x80359c
  80115d:	e8 b4 f3 ff ff       	call   800516 <_panic>

00801162 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801162:	f3 0f 1e fb          	endbr32 
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801174:	8b 55 08             	mov    0x8(%ebp),%edx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	b8 09 00 00 00       	mov    $0x9,%eax
  80117f:	89 df                	mov    %ebx,%edi
  801181:	89 de                	mov    %ebx,%esi
  801183:	cd 30                	int    $0x30
	if(check && ret > 0)
  801185:	85 c0                	test   %eax,%eax
  801187:	7f 08                	jg     801191 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	50                   	push   %eax
  801195:	6a 09                	push   $0x9
  801197:	68 7f 35 80 00       	push   $0x80357f
  80119c:	6a 23                	push   $0x23
  80119e:	68 9c 35 80 00       	push   $0x80359c
  8011a3:	e8 6e f3 ff ff       	call   800516 <_panic>

008011a8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a8:	f3 0f 1e fb          	endbr32 
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011c5:	89 df                	mov    %ebx,%edi
  8011c7:	89 de                	mov    %ebx,%esi
  8011c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	7f 08                	jg     8011d7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	50                   	push   %eax
  8011db:	6a 0a                	push   $0xa
  8011dd:	68 7f 35 80 00       	push   $0x80357f
  8011e2:	6a 23                	push   $0x23
  8011e4:	68 9c 35 80 00       	push   $0x80359c
  8011e9:	e8 28 f3 ff ff       	call   800516 <_panic>

008011ee <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011ee:	f3 0f 1e fb          	endbr32 
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 0c 00 00 00       	mov    $0xc,%eax
  801203:	be 00 00 00 00       	mov    $0x0,%esi
  801208:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80120b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80120e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801215:	f3 0f 1e fb          	endbr32 
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	57                   	push   %edi
  80121d:	56                   	push   %esi
  80121e:	53                   	push   %ebx
  80121f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801222:	b9 00 00 00 00       	mov    $0x0,%ecx
  801227:	8b 55 08             	mov    0x8(%ebp),%edx
  80122a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80122f:	89 cb                	mov    %ecx,%ebx
  801231:	89 cf                	mov    %ecx,%edi
  801233:	89 ce                	mov    %ecx,%esi
  801235:	cd 30                	int    $0x30
	if(check && ret > 0)
  801237:	85 c0                	test   %eax,%eax
  801239:	7f 08                	jg     801243 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80123b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123e:	5b                   	pop    %ebx
  80123f:	5e                   	pop    %esi
  801240:	5f                   	pop    %edi
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801243:	83 ec 0c             	sub    $0xc,%esp
  801246:	50                   	push   %eax
  801247:	6a 0d                	push   $0xd
  801249:	68 7f 35 80 00       	push   $0x80357f
  80124e:	6a 23                	push   $0x23
  801250:	68 9c 35 80 00       	push   $0x80359c
  801255:	e8 bc f2 ff ff       	call   800516 <_panic>

0080125a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80125a:	f3 0f 1e fb          	endbr32 
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
	asm volatile("int %1\n"
  801264:	ba 00 00 00 00       	mov    $0x0,%edx
  801269:	b8 0e 00 00 00       	mov    $0xe,%eax
  80126e:	89 d1                	mov    %edx,%ecx
  801270:	89 d3                	mov    %edx,%ebx
  801272:	89 d7                	mov    %edx,%edi
  801274:	89 d6                	mov    %edx,%esi
  801276:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  801289:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  80128b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80128f:	75 11                	jne    8012a2 <pgfault+0x25>
  801291:	89 f0                	mov    %esi,%eax
  801293:	c1 e8 0c             	shr    $0xc,%eax
  801296:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80129d:	f6 c4 08             	test   $0x8,%ah
  8012a0:	74 7d                	je     80131f <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  8012a2:	e8 5c fd ff ff       	call   801003 <sys_getenvid>
  8012a7:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	6a 07                	push   $0x7
  8012ae:	68 00 f0 7f 00       	push   $0x7ff000
  8012b3:	50                   	push   %eax
  8012b4:	e8 90 fd ff ff       	call   801049 <sys_page_alloc>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 7a                	js     80133a <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  8012c0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	68 00 10 00 00       	push   $0x1000
  8012ce:	56                   	push   %esi
  8012cf:	68 00 f0 7f 00       	push   $0x7ff000
  8012d4:	e8 e4 fa ff ff       	call   800dbd <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  8012d9:	83 c4 08             	add    $0x8,%esp
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	e8 f3 fd ff ff       	call   8010d6 <sys_page_unmap>
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 62                	js     80134c <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  8012ea:	83 ec 0c             	sub    $0xc,%esp
  8012ed:	6a 07                	push   $0x7
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	68 00 f0 7f 00       	push   $0x7ff000
  8012f6:	53                   	push   %ebx
  8012f7:	e8 94 fd ff ff       	call   801090 <sys_page_map>
  8012fc:	83 c4 20             	add    $0x20,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 5b                	js     80135e <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	68 00 f0 7f 00       	push   $0x7ff000
  80130b:	53                   	push   %ebx
  80130c:	e8 c5 fd ff ff       	call   8010d6 <sys_page_unmap>
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	78 58                	js     801370 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  801318:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131b:	5b                   	pop    %ebx
  80131c:	5e                   	pop    %esi
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  80131f:	e8 df fc ff ff       	call   801003 <sys_getenvid>
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	56                   	push   %esi
  801328:	50                   	push   %eax
  801329:	68 ac 35 80 00       	push   $0x8035ac
  80132e:	6a 16                	push   $0x16
  801330:	68 3a 36 80 00       	push   $0x80363a
  801335:	e8 dc f1 ff ff       	call   800516 <_panic>
        panic("pgfault: page allocation failed %e", r);
  80133a:	50                   	push   %eax
  80133b:	68 f4 35 80 00       	push   $0x8035f4
  801340:	6a 1f                	push   $0x1f
  801342:	68 3a 36 80 00       	push   $0x80363a
  801347:	e8 ca f1 ff ff       	call   800516 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80134c:	50                   	push   %eax
  80134d:	68 45 36 80 00       	push   $0x803645
  801352:	6a 24                	push   $0x24
  801354:	68 3a 36 80 00       	push   $0x80363a
  801359:	e8 b8 f1 ff ff       	call   800516 <_panic>
        panic("pgfault: page map failed %e", r);
  80135e:	50                   	push   %eax
  80135f:	68 63 36 80 00       	push   $0x803663
  801364:	6a 26                	push   $0x26
  801366:	68 3a 36 80 00       	push   $0x80363a
  80136b:	e8 a6 f1 ff ff       	call   800516 <_panic>
        panic("pgfault: page unmap failed %e", r);
  801370:	50                   	push   %eax
  801371:	68 45 36 80 00       	push   $0x803645
  801376:	6a 28                	push   $0x28
  801378:	68 3a 36 80 00       	push   $0x80363a
  80137d:	e8 94 f1 ff ff       	call   800516 <_panic>

00801382 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  801389:	89 d3                	mov    %edx,%ebx
  80138b:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  80138e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801395:	f6 c6 04             	test   $0x4,%dh
  801398:	75 62                	jne    8013fc <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  80139a:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8013a0:	0f 84 9d 00 00 00    	je     801443 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8013a6:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8013ac:	8b 52 48             	mov    0x48(%edx),%edx
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	68 05 08 00 00       	push   $0x805
  8013b7:	53                   	push   %ebx
  8013b8:	50                   	push   %eax
  8013b9:	53                   	push   %ebx
  8013ba:	52                   	push   %edx
  8013bb:	e8 d0 fc ff ff       	call   801090 <sys_page_map>
  8013c0:	83 c4 20             	add    $0x20,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 6a                	js     801431 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8013c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8013cc:	8b 50 48             	mov    0x48(%eax),%edx
  8013cf:	8b 40 48             	mov    0x48(%eax),%eax
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	68 05 08 00 00       	push   $0x805
  8013da:	53                   	push   %ebx
  8013db:	52                   	push   %edx
  8013dc:	53                   	push   %ebx
  8013dd:	50                   	push   %eax
  8013de:	e8 ad fc ff ff       	call   801090 <sys_page_map>
  8013e3:	83 c4 20             	add    $0x20,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	79 77                	jns    801461 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8013ea:	50                   	push   %eax
  8013eb:	68 18 36 80 00       	push   $0x803618
  8013f0:	6a 49                	push   $0x49
  8013f2:	68 3a 36 80 00       	push   $0x80363a
  8013f7:	e8 1a f1 ff ff       	call   800516 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  8013fc:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  801402:	8b 49 48             	mov    0x48(%ecx),%ecx
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80140e:	52                   	push   %edx
  80140f:	53                   	push   %ebx
  801410:	50                   	push   %eax
  801411:	53                   	push   %ebx
  801412:	51                   	push   %ecx
  801413:	e8 78 fc ff ff       	call   801090 <sys_page_map>
  801418:	83 c4 20             	add    $0x20,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	79 42                	jns    801461 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80141f:	50                   	push   %eax
  801420:	68 18 36 80 00       	push   $0x803618
  801425:	6a 43                	push   $0x43
  801427:	68 3a 36 80 00       	push   $0x80363a
  80142c:	e8 e5 f0 ff ff       	call   800516 <_panic>
            panic("duppage: page remapping failed %e", r);
  801431:	50                   	push   %eax
  801432:	68 18 36 80 00       	push   $0x803618
  801437:	6a 47                	push   $0x47
  801439:	68 3a 36 80 00       	push   $0x80363a
  80143e:	e8 d3 f0 ff ff       	call   800516 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801443:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801449:	8b 52 48             	mov    0x48(%edx),%edx
  80144c:	83 ec 0c             	sub    $0xc,%esp
  80144f:	6a 05                	push   $0x5
  801451:	53                   	push   %ebx
  801452:	50                   	push   %eax
  801453:	53                   	push   %ebx
  801454:	52                   	push   %edx
  801455:	e8 36 fc ff ff       	call   801090 <sys_page_map>
  80145a:	83 c4 20             	add    $0x20,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 0a                	js     80146b <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801461:	b8 00 00 00 00       	mov    $0x0,%eax
  801466:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801469:	c9                   	leave  
  80146a:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80146b:	50                   	push   %eax
  80146c:	68 18 36 80 00       	push   $0x803618
  801471:	6a 4c                	push   $0x4c
  801473:	68 3a 36 80 00       	push   $0x80363a
  801478:	e8 99 f0 ff ff       	call   800516 <_panic>

0080147d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80147d:	f3 0f 1e fb          	endbr32 
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	56                   	push   %esi
  801485:	53                   	push   %ebx
  801486:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801489:	68 7d 12 80 00       	push   $0x80127d
  80148e:	e8 16 18 00 00       	call   802ca9 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801493:	b8 07 00 00 00       	mov    $0x7,%eax
  801498:	cd 30                	int    $0x30
  80149a:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 12                	js     8014b5 <fork+0x38>
  8014a3:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8014a5:	74 20                	je     8014c7 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8014a7:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8014ae:	ba 00 00 80 00       	mov    $0x800000,%edx
  8014b3:	eb 42                	jmp    8014f7 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8014b5:	50                   	push   %eax
  8014b6:	68 7f 36 80 00       	push   $0x80367f
  8014bb:	6a 6a                	push   $0x6a
  8014bd:	68 3a 36 80 00       	push   $0x80363a
  8014c2:	e8 4f f0 ff ff       	call   800516 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8014c7:	e8 37 fb ff ff       	call   801003 <sys_getenvid>
  8014cc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014d9:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8014de:	e9 8a 00 00 00       	jmp    80156d <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e6:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8014ef:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8014f5:	77 32                	ja     801529 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8014f7:	89 d0                	mov    %edx,%eax
  8014f9:	c1 e8 16             	shr    $0x16,%eax
  8014fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801503:	a8 01                	test   $0x1,%al
  801505:	74 dc                	je     8014e3 <fork+0x66>
  801507:	c1 ea 0c             	shr    $0xc,%edx
  80150a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801511:	a8 01                	test   $0x1,%al
  801513:	74 ce                	je     8014e3 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801515:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80151c:	a8 04                	test   $0x4,%al
  80151e:	74 c3                	je     8014e3 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801520:	89 f0                	mov    %esi,%eax
  801522:	e8 5b fe ff ff       	call   801382 <duppage>
  801527:	eb ba                	jmp    8014e3 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801529:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80152c:	c1 ea 0c             	shr    $0xc,%edx
  80152f:	89 d8                	mov    %ebx,%eax
  801531:	e8 4c fe ff ff       	call   801382 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	6a 07                	push   $0x7
  80153b:	68 00 f0 bf ee       	push   $0xeebff000
  801540:	53                   	push   %ebx
  801541:	e8 03 fb ff ff       	call   801049 <sys_page_alloc>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	75 29                	jne    801576 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	68 2a 2d 80 00       	push   $0x802d2a
  801555:	53                   	push   %ebx
  801556:	e8 4d fc ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80155b:	83 c4 08             	add    $0x8,%esp
  80155e:	6a 02                	push   $0x2
  801560:	53                   	push   %ebx
  801561:	e8 b6 fb ff ff       	call   80111c <sys_env_set_status>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	75 1b                	jne    801588 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80156d:	89 d8                	mov    %ebx,%eax
  80156f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801576:	50                   	push   %eax
  801577:	68 8e 36 80 00       	push   $0x80368e
  80157c:	6a 7b                	push   $0x7b
  80157e:	68 3a 36 80 00       	push   $0x80363a
  801583:	e8 8e ef ff ff       	call   800516 <_panic>
		panic("sys_env_set_status:%e", r);
  801588:	50                   	push   %eax
  801589:	68 a0 36 80 00       	push   $0x8036a0
  80158e:	68 81 00 00 00       	push   $0x81
  801593:	68 3a 36 80 00       	push   $0x80363a
  801598:	e8 79 ef ff ff       	call   800516 <_panic>

0080159d <sfork>:

// Challenge!
int
sfork(void)
{
  80159d:	f3 0f 1e fb          	endbr32 
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8015a7:	68 b6 36 80 00       	push   $0x8036b6
  8015ac:	68 8b 00 00 00       	push   $0x8b
  8015b1:	68 3a 36 80 00       	push   $0x80363a
  8015b6:	e8 5b ef ff ff       	call   800516 <_panic>

008015bb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015bb:	f3 0f 1e fb          	endbr32 
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	05 00 00 00 30       	add    $0x30000000,%eax
  8015ca:	c1 e8 0c             	shr    $0xc,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015cf:	f3 0f 1e fb          	endbr32 
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8015de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015ea:	f3 0f 1e fb          	endbr32 
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015f6:	89 c2                	mov    %eax,%edx
  8015f8:	c1 ea 16             	shr    $0x16,%edx
  8015fb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801602:	f6 c2 01             	test   $0x1,%dl
  801605:	74 2d                	je     801634 <fd_alloc+0x4a>
  801607:	89 c2                	mov    %eax,%edx
  801609:	c1 ea 0c             	shr    $0xc,%edx
  80160c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801613:	f6 c2 01             	test   $0x1,%dl
  801616:	74 1c                	je     801634 <fd_alloc+0x4a>
  801618:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80161d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801622:	75 d2                	jne    8015f6 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80162d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801632:	eb 0a                	jmp    80163e <fd_alloc+0x54>
			*fd_store = fd;
  801634:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801637:	89 01                	mov    %eax,(%ecx)
			return 0;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801640:	f3 0f 1e fb          	endbr32 
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80164a:	83 f8 1f             	cmp    $0x1f,%eax
  80164d:	77 30                	ja     80167f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80164f:	c1 e0 0c             	shl    $0xc,%eax
  801652:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801657:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80165d:	f6 c2 01             	test   $0x1,%dl
  801660:	74 24                	je     801686 <fd_lookup+0x46>
  801662:	89 c2                	mov    %eax,%edx
  801664:	c1 ea 0c             	shr    $0xc,%edx
  801667:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80166e:	f6 c2 01             	test   $0x1,%dl
  801671:	74 1a                	je     80168d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	89 02                	mov    %eax,(%edx)
	return 0;
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    
		return -E_INVAL;
  80167f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801684:	eb f7                	jmp    80167d <fd_lookup+0x3d>
		return -E_INVAL;
  801686:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168b:	eb f0                	jmp    80167d <fd_lookup+0x3d>
  80168d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801692:	eb e9                	jmp    80167d <fd_lookup+0x3d>

00801694 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801694:	f3 0f 1e fb          	endbr32 
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a6:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8016ab:	39 08                	cmp    %ecx,(%eax)
  8016ad:	74 38                	je     8016e7 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8016af:	83 c2 01             	add    $0x1,%edx
  8016b2:	8b 04 95 48 37 80 00 	mov    0x803748(,%edx,4),%eax
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	75 ee                	jne    8016ab <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016bd:	a1 08 50 80 00       	mov    0x805008,%eax
  8016c2:	8b 40 48             	mov    0x48(%eax),%eax
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	51                   	push   %ecx
  8016c9:	50                   	push   %eax
  8016ca:	68 cc 36 80 00       	push   $0x8036cc
  8016cf:	e8 29 ef ff ff       	call   8005fd <cprintf>
	*dev = 0;
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016dd:	83 c4 10             	add    $0x10,%esp
  8016e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    
			*dev = devtab[i];
  8016e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ea:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f1:	eb f2                	jmp    8016e5 <dev_lookup+0x51>

008016f3 <fd_close>:
{
  8016f3:	f3 0f 1e fb          	endbr32 
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	57                   	push   %edi
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 24             	sub    $0x24,%esp
  801700:	8b 75 08             	mov    0x8(%ebp),%esi
  801703:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801706:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801709:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80170a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801710:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801713:	50                   	push   %eax
  801714:	e8 27 ff ff ff       	call   801640 <fd_lookup>
  801719:	89 c3                	mov    %eax,%ebx
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 05                	js     801727 <fd_close+0x34>
	    || fd != fd2)
  801722:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801725:	74 16                	je     80173d <fd_close+0x4a>
		return (must_exist ? r : 0);
  801727:	89 f8                	mov    %edi,%eax
  801729:	84 c0                	test   %al,%al
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax
  801730:	0f 44 d8             	cmove  %eax,%ebx
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80173d:	83 ec 08             	sub    $0x8,%esp
  801740:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	ff 36                	pushl  (%esi)
  801746:	e8 49 ff ff ff       	call   801694 <dev_lookup>
  80174b:	89 c3                	mov    %eax,%ebx
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	85 c0                	test   %eax,%eax
  801752:	78 1a                	js     80176e <fd_close+0x7b>
		if (dev->dev_close)
  801754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801757:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80175a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80175f:	85 c0                	test   %eax,%eax
  801761:	74 0b                	je     80176e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	56                   	push   %esi
  801767:	ff d0                	call   *%eax
  801769:	89 c3                	mov    %eax,%ebx
  80176b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	56                   	push   %esi
  801772:	6a 00                	push   $0x0
  801774:	e8 5d f9 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	eb b5                	jmp    801733 <fd_close+0x40>

0080177e <close>:

int
close(int fdnum)
{
  80177e:	f3 0f 1e fb          	endbr32 
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801788:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178b:	50                   	push   %eax
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	e8 ac fe ff ff       	call   801640 <fd_lookup>
  801794:	83 c4 10             	add    $0x10,%esp
  801797:	85 c0                	test   %eax,%eax
  801799:	79 02                	jns    80179d <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    
		return fd_close(fd, 1);
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	6a 01                	push   $0x1
  8017a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a5:	e8 49 ff ff ff       	call   8016f3 <fd_close>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	eb ec                	jmp    80179b <close+0x1d>

008017af <close_all>:

void
close_all(void)
{
  8017af:	f3 0f 1e fb          	endbr32 
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	53                   	push   %ebx
  8017c3:	e8 b6 ff ff ff       	call   80177e <close>
	for (i = 0; i < MAXFD; i++)
  8017c8:	83 c3 01             	add    $0x1,%ebx
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	83 fb 20             	cmp    $0x20,%ebx
  8017d1:	75 ec                	jne    8017bf <close_all+0x10>
}
  8017d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017d8:	f3 0f 1e fb          	endbr32 
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	57                   	push   %edi
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e8:	50                   	push   %eax
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	e8 4f fe ff ff       	call   801640 <fd_lookup>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	0f 88 81 00 00 00    	js     80187f <dup+0xa7>
		return r;
	close(newfdnum);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	e8 75 ff ff ff       	call   80177e <close>

	newfd = INDEX2FD(newfdnum);
  801809:	8b 75 0c             	mov    0xc(%ebp),%esi
  80180c:	c1 e6 0c             	shl    $0xc,%esi
  80180f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801815:	83 c4 04             	add    $0x4,%esp
  801818:	ff 75 e4             	pushl  -0x1c(%ebp)
  80181b:	e8 af fd ff ff       	call   8015cf <fd2data>
  801820:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801822:	89 34 24             	mov    %esi,(%esp)
  801825:	e8 a5 fd ff ff       	call   8015cf <fd2data>
  80182a:	83 c4 10             	add    $0x10,%esp
  80182d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80182f:	89 d8                	mov    %ebx,%eax
  801831:	c1 e8 16             	shr    $0x16,%eax
  801834:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80183b:	a8 01                	test   $0x1,%al
  80183d:	74 11                	je     801850 <dup+0x78>
  80183f:	89 d8                	mov    %ebx,%eax
  801841:	c1 e8 0c             	shr    $0xc,%eax
  801844:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80184b:	f6 c2 01             	test   $0x1,%dl
  80184e:	75 39                	jne    801889 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801853:	89 d0                	mov    %edx,%eax
  801855:	c1 e8 0c             	shr    $0xc,%eax
  801858:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80185f:	83 ec 0c             	sub    $0xc,%esp
  801862:	25 07 0e 00 00       	and    $0xe07,%eax
  801867:	50                   	push   %eax
  801868:	56                   	push   %esi
  801869:	6a 00                	push   $0x0
  80186b:	52                   	push   %edx
  80186c:	6a 00                	push   $0x0
  80186e:	e8 1d f8 ff ff       	call   801090 <sys_page_map>
  801873:	89 c3                	mov    %eax,%ebx
  801875:	83 c4 20             	add    $0x20,%esp
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 31                	js     8018ad <dup+0xd5>
		goto err;

	return newfdnum;
  80187c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80187f:	89 d8                	mov    %ebx,%eax
  801881:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801884:	5b                   	pop    %ebx
  801885:	5e                   	pop    %esi
  801886:	5f                   	pop    %edi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801889:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801890:	83 ec 0c             	sub    $0xc,%esp
  801893:	25 07 0e 00 00       	and    $0xe07,%eax
  801898:	50                   	push   %eax
  801899:	57                   	push   %edi
  80189a:	6a 00                	push   $0x0
  80189c:	53                   	push   %ebx
  80189d:	6a 00                	push   $0x0
  80189f:	e8 ec f7 ff ff       	call   801090 <sys_page_map>
  8018a4:	89 c3                	mov    %eax,%ebx
  8018a6:	83 c4 20             	add    $0x20,%esp
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	79 a3                	jns    801850 <dup+0x78>
	sys_page_unmap(0, newfd);
  8018ad:	83 ec 08             	sub    $0x8,%esp
  8018b0:	56                   	push   %esi
  8018b1:	6a 00                	push   $0x0
  8018b3:	e8 1e f8 ff ff       	call   8010d6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018b8:	83 c4 08             	add    $0x8,%esp
  8018bb:	57                   	push   %edi
  8018bc:	6a 00                	push   $0x0
  8018be:	e8 13 f8 ff ff       	call   8010d6 <sys_page_unmap>
	return r;
  8018c3:	83 c4 10             	add    $0x10,%esp
  8018c6:	eb b7                	jmp    80187f <dup+0xa7>

008018c8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018c8:	f3 0f 1e fb          	endbr32 
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 1c             	sub    $0x1c,%esp
  8018d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d9:	50                   	push   %eax
  8018da:	53                   	push   %ebx
  8018db:	e8 60 fd ff ff       	call   801640 <fd_lookup>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	78 3f                	js     801926 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ed:	50                   	push   %eax
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	ff 30                	pushl  (%eax)
  8018f3:	e8 9c fd ff ff       	call   801694 <dev_lookup>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 27                	js     801926 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801902:	8b 42 08             	mov    0x8(%edx),%eax
  801905:	83 e0 03             	and    $0x3,%eax
  801908:	83 f8 01             	cmp    $0x1,%eax
  80190b:	74 1e                	je     80192b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801910:	8b 40 08             	mov    0x8(%eax),%eax
  801913:	85 c0                	test   %eax,%eax
  801915:	74 35                	je     80194c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	ff 75 10             	pushl  0x10(%ebp)
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	52                   	push   %edx
  801921:	ff d0                	call   *%eax
  801923:	83 c4 10             	add    $0x10,%esp
}
  801926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801929:	c9                   	leave  
  80192a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80192b:	a1 08 50 80 00       	mov    0x805008,%eax
  801930:	8b 40 48             	mov    0x48(%eax),%eax
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	53                   	push   %ebx
  801937:	50                   	push   %eax
  801938:	68 0d 37 80 00       	push   $0x80370d
  80193d:	e8 bb ec ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80194a:	eb da                	jmp    801926 <read+0x5e>
		return -E_NOT_SUPP;
  80194c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801951:	eb d3                	jmp    801926 <read+0x5e>

00801953 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801953:	f3 0f 1e fb          	endbr32 
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	57                   	push   %edi
  80195b:	56                   	push   %esi
  80195c:	53                   	push   %ebx
  80195d:	83 ec 0c             	sub    $0xc,%esp
  801960:	8b 7d 08             	mov    0x8(%ebp),%edi
  801963:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801966:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196b:	eb 02                	jmp    80196f <readn+0x1c>
  80196d:	01 c3                	add    %eax,%ebx
  80196f:	39 f3                	cmp    %esi,%ebx
  801971:	73 21                	jae    801994 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	89 f0                	mov    %esi,%eax
  801978:	29 d8                	sub    %ebx,%eax
  80197a:	50                   	push   %eax
  80197b:	89 d8                	mov    %ebx,%eax
  80197d:	03 45 0c             	add    0xc(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	57                   	push   %edi
  801982:	e8 41 ff ff ff       	call   8018c8 <read>
		if (m < 0)
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 04                	js     801992 <readn+0x3f>
			return m;
		if (m == 0)
  80198e:	75 dd                	jne    80196d <readn+0x1a>
  801990:	eb 02                	jmp    801994 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801992:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801994:	89 d8                	mov    %ebx,%eax
  801996:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80199e:	f3 0f 1e fb          	endbr32 
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	53                   	push   %ebx
  8019a6:	83 ec 1c             	sub    $0x1c,%esp
  8019a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019af:	50                   	push   %eax
  8019b0:	53                   	push   %ebx
  8019b1:	e8 8a fc ff ff       	call   801640 <fd_lookup>
  8019b6:	83 c4 10             	add    $0x10,%esp
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	78 3a                	js     8019f7 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c3:	50                   	push   %eax
  8019c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c7:	ff 30                	pushl  (%eax)
  8019c9:	e8 c6 fc ff ff       	call   801694 <dev_lookup>
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 22                	js     8019f7 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019dc:	74 1e                	je     8019fc <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e1:	8b 52 0c             	mov    0xc(%edx),%edx
  8019e4:	85 d2                	test   %edx,%edx
  8019e6:	74 35                	je     801a1d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	ff 75 10             	pushl  0x10(%ebp)
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	50                   	push   %eax
  8019f2:	ff d2                	call   *%edx
  8019f4:	83 c4 10             	add    $0x10,%esp
}
  8019f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019fc:	a1 08 50 80 00       	mov    0x805008,%eax
  801a01:	8b 40 48             	mov    0x48(%eax),%eax
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	53                   	push   %ebx
  801a08:	50                   	push   %eax
  801a09:	68 29 37 80 00       	push   $0x803729
  801a0e:	e8 ea eb ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a1b:	eb da                	jmp    8019f7 <write+0x59>
		return -E_NOT_SUPP;
  801a1d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a22:	eb d3                	jmp    8019f7 <write+0x59>

00801a24 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a24:	f3 0f 1e fb          	endbr32 
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	e8 06 fc ff ff       	call   801640 <fd_lookup>
  801a3a:	83 c4 10             	add    $0x10,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	78 0e                	js     801a4f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a51:	f3 0f 1e fb          	endbr32 
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 1c             	sub    $0x1c,%esp
  801a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	53                   	push   %ebx
  801a64:	e8 d7 fb ff ff       	call   801640 <fd_lookup>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 37                	js     801aa7 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a76:	50                   	push   %eax
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	ff 30                	pushl  (%eax)
  801a7c:	e8 13 fc ff ff       	call   801694 <dev_lookup>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 1f                	js     801aa7 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8f:	74 1b                	je     801aac <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a94:	8b 52 18             	mov    0x18(%edx),%edx
  801a97:	85 d2                	test   %edx,%edx
  801a99:	74 32                	je     801acd <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	ff d2                	call   *%edx
  801aa4:	83 c4 10             	add    $0x10,%esp
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
			thisenv->env_id, fdnum);
  801aac:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ab1:	8b 40 48             	mov    0x48(%eax),%eax
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	53                   	push   %ebx
  801ab8:	50                   	push   %eax
  801ab9:	68 ec 36 80 00       	push   $0x8036ec
  801abe:	e8 3a eb ff ff       	call   8005fd <cprintf>
		return -E_INVAL;
  801ac3:	83 c4 10             	add    $0x10,%esp
  801ac6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801acb:	eb da                	jmp    801aa7 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801acd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad2:	eb d3                	jmp    801aa7 <ftruncate+0x56>

00801ad4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ad4:	f3 0f 1e fb          	endbr32 
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	53                   	push   %ebx
  801adc:	83 ec 1c             	sub    $0x1c,%esp
  801adf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae5:	50                   	push   %eax
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	e8 52 fb ff ff       	call   801640 <fd_lookup>
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 4b                	js     801b40 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afb:	50                   	push   %eax
  801afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aff:	ff 30                	pushl  (%eax)
  801b01:	e8 8e fb ff ff       	call   801694 <dev_lookup>
  801b06:	83 c4 10             	add    $0x10,%esp
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	78 33                	js     801b40 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b10:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b14:	74 2f                	je     801b45 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b16:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b19:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b20:	00 00 00 
	stat->st_isdir = 0;
  801b23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b2a:	00 00 00 
	stat->st_dev = dev;
  801b2d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	53                   	push   %ebx
  801b37:	ff 75 f0             	pushl  -0x10(%ebp)
  801b3a:	ff 50 14             	call   *0x14(%eax)
  801b3d:	83 c4 10             	add    $0x10,%esp
}
  801b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    
		return -E_NOT_SUPP;
  801b45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4a:	eb f4                	jmp    801b40 <fstat+0x6c>

00801b4c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b4c:	f3 0f 1e fb          	endbr32 
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 fb 01 00 00       	call   801d5d <open>
  801b62:	89 c3                	mov    %eax,%ebx
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 1b                	js     801b86 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	e8 5d ff ff ff       	call   801ad4 <fstat>
  801b77:	89 c6                	mov    %eax,%esi
	close(fd);
  801b79:	89 1c 24             	mov    %ebx,(%esp)
  801b7c:	e8 fd fb ff ff       	call   80177e <close>
	return r;
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	89 f3                	mov    %esi,%ebx
}
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	89 c6                	mov    %eax,%esi
  801b96:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b98:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b9f:	74 27                	je     801bc8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba1:	6a 07                	push   $0x7
  801ba3:	68 00 60 80 00       	push   $0x806000
  801ba8:	56                   	push   %esi
  801ba9:	ff 35 00 50 80 00    	pushl  0x805000
  801baf:	e8 0e 12 00 00       	call   802dc2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bb4:	83 c4 0c             	add    $0xc,%esp
  801bb7:	6a 00                	push   $0x0
  801bb9:	53                   	push   %ebx
  801bba:	6a 00                	push   $0x0
  801bbc:	e8 8d 11 00 00       	call   802d4e <ipc_recv>
}
  801bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5d                   	pop    %ebp
  801bc7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bc8:	83 ec 0c             	sub    $0xc,%esp
  801bcb:	6a 01                	push   $0x1
  801bcd:	e8 48 12 00 00       	call   802e1a <ipc_find_env>
  801bd2:	a3 00 50 80 00       	mov    %eax,0x805000
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	eb c5                	jmp    801ba1 <fsipc+0x12>

00801bdc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bdc:	f3 0f 1e fb          	endbr32 
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bec:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfe:	b8 02 00 00 00       	mov    $0x2,%eax
  801c03:	e8 87 ff ff ff       	call   801b8f <fsipc>
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <devfile_flush>:
{
  801c0a:	f3 0f 1e fb          	endbr32 
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c24:	b8 06 00 00 00       	mov    $0x6,%eax
  801c29:	e8 61 ff ff ff       	call   801b8f <fsipc>
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <devfile_stat>:
{
  801c30:	f3 0f 1e fb          	endbr32 
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	8b 40 0c             	mov    0xc(%eax),%eax
  801c44:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c49:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4e:	b8 05 00 00 00       	mov    $0x5,%eax
  801c53:	e8 37 ff ff ff       	call   801b8f <fsipc>
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	78 2c                	js     801c88 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5c:	83 ec 08             	sub    $0x8,%esp
  801c5f:	68 00 60 80 00       	push   $0x806000
  801c64:	53                   	push   %ebx
  801c65:	e8 9d ef ff ff       	call   800c07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6a:	a1 80 60 80 00       	mov    0x806080,%eax
  801c6f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c75:	a1 84 60 80 00       	mov    0x806084,%eax
  801c7a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <devfile_write>:
{
  801c8d:	f3 0f 1e fb          	endbr32 
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9d:	8b 52 0c             	mov    0xc(%edx),%edx
  801ca0:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801ca6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cab:	ba 00 10 00 00       	mov    $0x1000,%edx
  801cb0:	0f 47 c2             	cmova  %edx,%eax
  801cb3:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801cb8:	50                   	push   %eax
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	68 08 60 80 00       	push   $0x806008
  801cc1:	e8 f7 f0 ff ff       	call   800dbd <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801cc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccb:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd0:	e8 ba fe ff ff       	call   801b8f <fsipc>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <devfile_read>:
{
  801cd7:	f3 0f 1e fb          	endbr32 
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cee:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  801cfe:	e8 8c fe ff ff       	call   801b8f <fsipc>
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 1f                	js     801d28 <devfile_read+0x51>
	assert(r <= n);
  801d09:	39 f0                	cmp    %esi,%eax
  801d0b:	77 24                	ja     801d31 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801d0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d12:	7f 33                	jg     801d47 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	50                   	push   %eax
  801d18:	68 00 60 80 00       	push   $0x806000
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	e8 98 f0 ff ff       	call   800dbd <memmove>
	return r;
  801d25:	83 c4 10             	add    $0x10,%esp
}
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    
	assert(r <= n);
  801d31:	68 5c 37 80 00       	push   $0x80375c
  801d36:	68 63 37 80 00       	push   $0x803763
  801d3b:	6a 7c                	push   $0x7c
  801d3d:	68 78 37 80 00       	push   $0x803778
  801d42:	e8 cf e7 ff ff       	call   800516 <_panic>
	assert(r <= PGSIZE);
  801d47:	68 83 37 80 00       	push   $0x803783
  801d4c:	68 63 37 80 00       	push   $0x803763
  801d51:	6a 7d                	push   $0x7d
  801d53:	68 78 37 80 00       	push   $0x803778
  801d58:	e8 b9 e7 ff ff       	call   800516 <_panic>

00801d5d <open>:
{
  801d5d:	f3 0f 1e fb          	endbr32 
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	83 ec 1c             	sub    $0x1c,%esp
  801d69:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d6c:	56                   	push   %esi
  801d6d:	e8 52 ee ff ff       	call   800bc4 <strlen>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d7a:	7f 6c                	jg     801de8 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d82:	50                   	push   %eax
  801d83:	e8 62 f8 ff ff       	call   8015ea <fd_alloc>
  801d88:	89 c3                	mov    %eax,%ebx
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 3c                	js     801dcd <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d91:	83 ec 08             	sub    $0x8,%esp
  801d94:	56                   	push   %esi
  801d95:	68 00 60 80 00       	push   $0x806000
  801d9a:	e8 68 ee ff ff       	call   800c07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	e8 db fd ff ff       	call   801b8f <fsipc>
  801db4:	89 c3                	mov    %eax,%ebx
  801db6:	83 c4 10             	add    $0x10,%esp
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	78 19                	js     801dd6 <open+0x79>
	return fd2num(fd);
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc3:	e8 f3 f7 ff ff       	call   8015bb <fd2num>
  801dc8:	89 c3                	mov    %eax,%ebx
  801dca:	83 c4 10             	add    $0x10,%esp
}
  801dcd:	89 d8                	mov    %ebx,%eax
  801dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
		fd_close(fd, 0);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	6a 00                	push   $0x0
  801ddb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dde:	e8 10 f9 ff ff       	call   8016f3 <fd_close>
		return r;
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	eb e5                	jmp    801dcd <open+0x70>
		return -E_BAD_PATH;
  801de8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ded:	eb de                	jmp    801dcd <open+0x70>

00801def <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801def:	f3 0f 1e fb          	endbr32 
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801df9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfe:	b8 08 00 00 00       	mov    $0x8,%eax
  801e03:	e8 87 fd ff ff       	call   801b8f <fsipc>
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801e0a:	f3 0f 1e fb          	endbr32 
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	57                   	push   %edi
  801e12:	56                   	push   %esi
  801e13:	53                   	push   %ebx
  801e14:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801e1a:	6a 00                	push   $0x0
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	e8 39 ff ff ff       	call   801d5d <open>
  801e24:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	0f 88 07 05 00 00    	js     80233c <spawn+0x532>
  801e35:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 00 02 00 00       	push   $0x200
  801e3f:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801e45:	50                   	push   %eax
  801e46:	52                   	push   %edx
  801e47:	e8 07 fb ff ff       	call   801953 <readn>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801e54:	0f 85 9d 00 00 00    	jne    801ef7 <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  801e5a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801e61:	45 4c 46 
  801e64:	0f 85 8d 00 00 00    	jne    801ef7 <spawn+0xed>
  801e6a:	b8 07 00 00 00       	mov    $0x7,%eax
  801e6f:	cd 30                	int    $0x30
  801e71:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801e77:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	0f 88 ab 04 00 00    	js     802330 <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e85:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e8a:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801e8d:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e93:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e99:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801ea0:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801ea6:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	6a 04                	push   $0x4
  801eb1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  801eb7:	50                   	push   %eax
  801eb8:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  801ebe:	50                   	push   %eax
  801ebf:	e8 5f ef ff ff       	call   800e23 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801ecc:	be 00 00 00 00       	mov    $0x0,%esi
  801ed1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ed4:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801edb:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	74 4d                	je     801f2f <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	50                   	push   %eax
  801ee6:	e8 d9 ec ff ff       	call   800bc4 <strlen>
  801eeb:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801eef:	83 c3 01             	add    $0x1,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	eb dd                	jmp    801ed4 <spawn+0xca>
		close(fd);
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f00:	e8 79 f8 ff ff       	call   80177e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f05:	83 c4 0c             	add    $0xc,%esp
  801f08:	68 7f 45 4c 46       	push   $0x464c457f
  801f0d:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801f13:	68 8f 37 80 00       	push   $0x80378f
  801f18:	e8 e0 e6 ff ff       	call   8005fd <cprintf>
		return -E_NOT_EXEC;
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801f27:	ff ff ff 
  801f2a:	e9 0d 04 00 00       	jmp    80233c <spawn+0x532>
  801f2f:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801f35:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801f3b:	bf 00 10 40 00       	mov    $0x401000,%edi
  801f40:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801f42:	89 fa                	mov    %edi,%edx
  801f44:	83 e2 fc             	and    $0xfffffffc,%edx
  801f47:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801f4e:	29 c2                	sub    %eax,%edx
  801f50:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801f56:	8d 42 f8             	lea    -0x8(%edx),%eax
  801f59:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801f5e:	0f 86 fb 03 00 00    	jbe    80235f <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	6a 07                	push   $0x7
  801f69:	68 00 00 40 00       	push   $0x400000
  801f6e:	6a 00                	push   $0x0
  801f70:	e8 d4 f0 ff ff       	call   801049 <sys_page_alloc>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	0f 88 e4 03 00 00    	js     802364 <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f80:	be 00 00 00 00       	mov    $0x0,%esi
  801f85:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801f8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f8e:	eb 30                	jmp    801fc0 <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  801f90:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f96:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801f9c:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801f9f:	83 ec 08             	sub    $0x8,%esp
  801fa2:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fa5:	57                   	push   %edi
  801fa6:	e8 5c ec ff ff       	call   800c07 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801fab:	83 c4 04             	add    $0x4,%esp
  801fae:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801fb1:	e8 0e ec ff ff       	call   800bc4 <strlen>
  801fb6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801fba:	83 c6 01             	add    $0x1,%esi
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801fc6:	7f c8                	jg     801f90 <spawn+0x186>
	}
	argv_store[argc] = 0;
  801fc8:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801fce:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801fd4:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fdb:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801fe1:	0f 85 86 00 00 00    	jne    80206d <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801fe7:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801fed:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801ff3:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ff6:	89 c8                	mov    %ecx,%eax
  801ff8:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ffe:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802001:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802006:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	6a 07                	push   $0x7
  802011:	68 00 d0 bf ee       	push   $0xeebfd000
  802016:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80201c:	68 00 00 40 00       	push   $0x400000
  802021:	6a 00                	push   $0x0
  802023:	e8 68 f0 ff ff       	call   801090 <sys_page_map>
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	83 c4 20             	add    $0x20,%esp
  80202d:	85 c0                	test   %eax,%eax
  80202f:	0f 88 37 03 00 00    	js     80236c <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	68 00 00 40 00       	push   $0x400000
  80203d:	6a 00                	push   $0x0
  80203f:	e8 92 f0 ff ff       	call   8010d6 <sys_page_unmap>
  802044:	89 c3                	mov    %eax,%ebx
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	85 c0                	test   %eax,%eax
  80204b:	0f 88 1b 03 00 00    	js     80236c <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802051:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802057:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80205e:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  802065:	00 00 00 
  802068:	e9 4f 01 00 00       	jmp    8021bc <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80206d:	68 04 38 80 00       	push   $0x803804
  802072:	68 63 37 80 00       	push   $0x803763
  802077:	68 f6 00 00 00       	push   $0xf6
  80207c:	68 a9 37 80 00       	push   $0x8037a9
  802081:	e8 90 e4 ff ff       	call   800516 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	6a 07                	push   $0x7
  80208b:	68 00 00 40 00       	push   $0x400000
  802090:	6a 00                	push   $0x0
  802092:	e8 b2 ef ff ff       	call   801049 <sys_page_alloc>
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	0f 88 a8 02 00 00    	js     80234a <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020a2:	83 ec 08             	sub    $0x8,%esp
  8020a5:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8020ab:	01 f0                	add    %esi,%eax
  8020ad:	50                   	push   %eax
  8020ae:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020b4:	e8 6b f9 ff ff       	call   801a24 <seek>
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	0f 88 8d 02 00 00    	js     802351 <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8020cd:	29 f0                	sub    %esi,%eax
  8020cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020d4:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8020d9:	0f 47 c1             	cmova  %ecx,%eax
  8020dc:	50                   	push   %eax
  8020dd:	68 00 00 40 00       	push   $0x400000
  8020e2:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8020e8:	e8 66 f8 ff ff       	call   801953 <readn>
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	0f 88 60 02 00 00    	js     802358 <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802101:	53                   	push   %ebx
  802102:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802108:	68 00 00 40 00       	push   $0x400000
  80210d:	6a 00                	push   $0x0
  80210f:	e8 7c ef ff ff       	call   801090 <sys_page_map>
  802114:	83 c4 20             	add    $0x20,%esp
  802117:	85 c0                	test   %eax,%eax
  802119:	78 7c                	js     802197 <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80211b:	83 ec 08             	sub    $0x8,%esp
  80211e:	68 00 00 40 00       	push   $0x400000
  802123:	6a 00                	push   $0x0
  802125:	e8 ac ef ff ff       	call   8010d6 <sys_page_unmap>
  80212a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80212d:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802133:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802139:	89 fe                	mov    %edi,%esi
  80213b:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802141:	76 69                	jbe    8021ac <spawn+0x3a2>
		if (i >= filesz) {
  802143:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802149:	0f 87 37 ff ff ff    	ja     802086 <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802158:	53                   	push   %ebx
  802159:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80215f:	e8 e5 ee ff ff       	call   801049 <sys_page_alloc>
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	79 c2                	jns    80212d <spawn+0x323>
  80216b:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802176:	e8 43 ee ff ff       	call   800fbe <sys_env_destroy>
	close(fd);
  80217b:	83 c4 04             	add    $0x4,%esp
  80217e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802184:	e8 f5 f5 ff ff       	call   80177e <close>
	return r;
  802189:	83 c4 10             	add    $0x10,%esp
  80218c:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802192:	e9 a5 01 00 00       	jmp    80233c <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  802197:	50                   	push   %eax
  802198:	68 b5 37 80 00       	push   $0x8037b5
  80219d:	68 29 01 00 00       	push   $0x129
  8021a2:	68 a9 37 80 00       	push   $0x8037a9
  8021a7:	e8 6a e3 ff ff       	call   800516 <_panic>
  8021ac:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021b2:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  8021b9:	83 c6 20             	add    $0x20,%esi
  8021bc:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021c3:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  8021c9:	7e 6d                	jle    802238 <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  8021cb:	83 3e 01             	cmpl   $0x1,(%esi)
  8021ce:	75 e2                	jne    8021b2 <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021d0:	8b 46 18             	mov    0x18(%esi),%eax
  8021d3:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8021d6:	83 f8 01             	cmp    $0x1,%eax
  8021d9:	19 c0                	sbb    %eax,%eax
  8021db:	83 e0 fe             	and    $0xfffffffe,%eax
  8021de:	83 c0 07             	add    $0x7,%eax
  8021e1:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8021e7:	8b 4e 04             	mov    0x4(%esi),%ecx
  8021ea:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8021f0:	8b 56 10             	mov    0x10(%esi),%edx
  8021f3:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  8021f9:	8b 7e 14             	mov    0x14(%esi),%edi
  8021fc:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802202:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802205:	89 d8                	mov    %ebx,%eax
  802207:	25 ff 0f 00 00       	and    $0xfff,%eax
  80220c:	74 1a                	je     802228 <spawn+0x41e>
		va -= i;
  80220e:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802210:	01 c7                	add    %eax,%edi
  802212:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802218:	01 c2                	add    %eax,%edx
  80221a:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802220:	29 c1                	sub    %eax,%ecx
  802222:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802228:	bf 00 00 00 00       	mov    $0x0,%edi
  80222d:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802233:	e9 01 ff ff ff       	jmp    802139 <spawn+0x32f>
	close(fd);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802241:	e8 38 f5 ff ff       	call   80177e <close>
  802246:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80224e:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802254:	eb 2a                	jmp    802280 <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  802256:	a1 08 50 80 00       	mov    0x805008,%eax
  80225b:	8b 40 48             	mov    0x48(%eax),%eax
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	68 07 0e 00 00       	push   $0xe07
  802266:	53                   	push   %ebx
  802267:	56                   	push   %esi
  802268:	53                   	push   %ebx
  802269:	50                   	push   %eax
  80226a:	e8 21 ee ff ff       	call   801090 <sys_page_map>
  80226f:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802272:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802278:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  80227e:	74 3b                	je     8022bb <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  802280:	89 d8                	mov    %ebx,%eax
  802282:	c1 e8 16             	shr    $0x16,%eax
  802285:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80228c:	a8 01                	test   $0x1,%al
  80228e:	74 e2                	je     802272 <spawn+0x468>
  802290:	89 d8                	mov    %ebx,%eax
  802292:	c1 e8 0c             	shr    $0xc,%eax
  802295:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80229c:	f6 c2 01             	test   $0x1,%dl
  80229f:	74 d1                	je     802272 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  8022a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  8022a8:	f6 c2 04             	test   $0x4,%dl
  8022ab:	74 c5                	je     802272 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  8022ad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8022b4:	f6 c4 04             	test   $0x4,%ah
  8022b7:	74 b9                	je     802272 <spawn+0x468>
  8022b9:	eb 9b                	jmp    802256 <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8022bb:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8022c2:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022c5:	83 ec 08             	sub    $0x8,%esp
  8022c8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022ce:	50                   	push   %eax
  8022cf:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8022d5:	e8 88 ee ff ff       	call   801162 <sys_env_set_trapframe>
  8022da:	83 c4 10             	add    $0x10,%esp
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	78 25                	js     802306 <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022e1:	83 ec 08             	sub    $0x8,%esp
  8022e4:	6a 02                	push   $0x2
  8022e6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8022ec:	e8 2b ee ff ff       	call   80111c <sys_env_set_status>
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	78 23                	js     80231b <spawn+0x511>
	return child;
  8022f8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8022fe:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802304:	eb 36                	jmp    80233c <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  802306:	50                   	push   %eax
  802307:	68 d2 37 80 00       	push   $0x8037d2
  80230c:	68 8a 00 00 00       	push   $0x8a
  802311:	68 a9 37 80 00       	push   $0x8037a9
  802316:	e8 fb e1 ff ff       	call   800516 <_panic>
		panic("sys_env_set_status: %e", r);
  80231b:	50                   	push   %eax
  80231c:	68 ec 37 80 00       	push   $0x8037ec
  802321:	68 8d 00 00 00       	push   $0x8d
  802326:	68 a9 37 80 00       	push   $0x8037a9
  80232b:	e8 e6 e1 ff ff       	call   800516 <_panic>
		return r;
  802330:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802336:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80233c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
  80234a:	89 c7                	mov    %eax,%edi
  80234c:	e9 1c fe ff ff       	jmp    80216d <spawn+0x363>
  802351:	89 c7                	mov    %eax,%edi
  802353:	e9 15 fe ff ff       	jmp    80216d <spawn+0x363>
  802358:	89 c7                	mov    %eax,%edi
  80235a:	e9 0e fe ff ff       	jmp    80216d <spawn+0x363>
		return -E_NO_MEM;
  80235f:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802364:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80236a:	eb d0                	jmp    80233c <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  80236c:	83 ec 08             	sub    $0x8,%esp
  80236f:	68 00 00 40 00       	push   $0x400000
  802374:	6a 00                	push   $0x0
  802376:	e8 5b ed ff ff       	call   8010d6 <sys_page_unmap>
  80237b:	83 c4 10             	add    $0x10,%esp
  80237e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802384:	eb b6                	jmp    80233c <spawn+0x532>

00802386 <spawnl>:
{
  802386:	f3 0f 1e fb          	endbr32 
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802393:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  80239b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80239e:	83 3a 00             	cmpl   $0x0,(%edx)
  8023a1:	74 07                	je     8023aa <spawnl+0x24>
		argc++;
  8023a3:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  8023a6:	89 ca                	mov    %ecx,%edx
  8023a8:	eb f1                	jmp    80239b <spawnl+0x15>
	const char *argv[argc+2];
  8023aa:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  8023b1:	89 d1                	mov    %edx,%ecx
  8023b3:	83 e1 f0             	and    $0xfffffff0,%ecx
  8023b6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8023bc:	89 e6                	mov    %esp,%esi
  8023be:	29 d6                	sub    %edx,%esi
  8023c0:	89 f2                	mov    %esi,%edx
  8023c2:	39 d4                	cmp    %edx,%esp
  8023c4:	74 10                	je     8023d6 <spawnl+0x50>
  8023c6:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8023cc:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8023d3:	00 
  8023d4:	eb ec                	jmp    8023c2 <spawnl+0x3c>
  8023d6:	89 ca                	mov    %ecx,%edx
  8023d8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8023de:	29 d4                	sub    %edx,%esp
  8023e0:	85 d2                	test   %edx,%edx
  8023e2:	74 05                	je     8023e9 <spawnl+0x63>
  8023e4:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8023e9:	8d 74 24 03          	lea    0x3(%esp),%esi
  8023ed:	89 f2                	mov    %esi,%edx
  8023ef:	c1 ea 02             	shr    $0x2,%edx
  8023f2:	83 e6 fc             	and    $0xfffffffc,%esi
  8023f5:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8023f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023fa:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802401:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802408:	00 
	va_start(vl, arg0);
  802409:	8d 4d 10             	lea    0x10(%ebp),%ecx
  80240c:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
  802413:	eb 0b                	jmp    802420 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802415:	83 c0 01             	add    $0x1,%eax
  802418:	8b 39                	mov    (%ecx),%edi
  80241a:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80241d:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802420:	39 d0                	cmp    %edx,%eax
  802422:	75 f1                	jne    802415 <spawnl+0x8f>
	return spawn(prog, argv);
  802424:	83 ec 08             	sub    $0x8,%esp
  802427:	56                   	push   %esi
  802428:	ff 75 08             	pushl  0x8(%ebp)
  80242b:	e8 da f9 ff ff       	call   801e0a <spawn>
}
  802430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802433:	5b                   	pop    %ebx
  802434:	5e                   	pop    %esi
  802435:	5f                   	pop    %edi
  802436:	5d                   	pop    %ebp
  802437:	c3                   	ret    

00802438 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802438:	f3 0f 1e fb          	endbr32 
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802442:	68 2a 38 80 00       	push   $0x80382a
  802447:	ff 75 0c             	pushl  0xc(%ebp)
  80244a:	e8 b8 e7 ff ff       	call   800c07 <strcpy>
	return 0;
}
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <devsock_close>:
{
  802456:	f3 0f 1e fb          	endbr32 
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	53                   	push   %ebx
  80245e:	83 ec 10             	sub    $0x10,%esp
  802461:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802464:	53                   	push   %ebx
  802465:	e8 ed 09 00 00       	call   802e57 <pageref>
  80246a:	89 c2                	mov    %eax,%edx
  80246c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802474:	83 fa 01             	cmp    $0x1,%edx
  802477:	74 05                	je     80247e <devsock_close+0x28>
}
  802479:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80247e:	83 ec 0c             	sub    $0xc,%esp
  802481:	ff 73 0c             	pushl  0xc(%ebx)
  802484:	e8 e3 02 00 00       	call   80276c <nsipc_close>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	eb eb                	jmp    802479 <devsock_close+0x23>

0080248e <devsock_write>:
{
  80248e:	f3 0f 1e fb          	endbr32 
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802498:	6a 00                	push   $0x0
  80249a:	ff 75 10             	pushl  0x10(%ebp)
  80249d:	ff 75 0c             	pushl  0xc(%ebp)
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	ff 70 0c             	pushl  0xc(%eax)
  8024a6:	e8 b5 03 00 00       	call   802860 <nsipc_send>
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <devsock_read>:
{
  8024ad:	f3 0f 1e fb          	endbr32 
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024b7:	6a 00                	push   $0x0
  8024b9:	ff 75 10             	pushl  0x10(%ebp)
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	ff 70 0c             	pushl  0xc(%eax)
  8024c5:	e8 1f 03 00 00       	call   8027e9 <nsipc_recv>
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <fd2sockid>:
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024d5:	52                   	push   %edx
  8024d6:	50                   	push   %eax
  8024d7:	e8 64 f1 ff ff       	call   801640 <fd_lookup>
  8024dc:	83 c4 10             	add    $0x10,%esp
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	78 10                	js     8024f3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  8024ec:	39 08                	cmp    %ecx,(%eax)
  8024ee:	75 05                	jne    8024f5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8024f0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    
		return -E_NOT_SUPP;
  8024f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8024fa:	eb f7                	jmp    8024f3 <fd2sockid+0x27>

008024fc <alloc_sockfd>:
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	56                   	push   %esi
  802500:	53                   	push   %ebx
  802501:	83 ec 1c             	sub    $0x1c,%esp
  802504:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802506:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802509:	50                   	push   %eax
  80250a:	e8 db f0 ff ff       	call   8015ea <fd_alloc>
  80250f:	89 c3                	mov    %eax,%ebx
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	85 c0                	test   %eax,%eax
  802516:	78 43                	js     80255b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	68 07 04 00 00       	push   $0x407
  802520:	ff 75 f4             	pushl  -0xc(%ebp)
  802523:	6a 00                	push   $0x0
  802525:	e8 1f eb ff ff       	call   801049 <sys_page_alloc>
  80252a:	89 c3                	mov    %eax,%ebx
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	85 c0                	test   %eax,%eax
  802531:	78 28                	js     80255b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80253c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802548:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	50                   	push   %eax
  80254f:	e8 67 f0 ff ff       	call   8015bb <fd2num>
  802554:	89 c3                	mov    %eax,%ebx
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	eb 0c                	jmp    802567 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	56                   	push   %esi
  80255f:	e8 08 02 00 00       	call   80276c <nsipc_close>
		return r;
  802564:	83 c4 10             	add    $0x10,%esp
}
  802567:	89 d8                	mov    %ebx,%eax
  802569:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80256c:	5b                   	pop    %ebx
  80256d:	5e                   	pop    %esi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    

00802570 <accept>:
{
  802570:	f3 0f 1e fb          	endbr32 
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	e8 4a ff ff ff       	call   8024cc <fd2sockid>
  802582:	85 c0                	test   %eax,%eax
  802584:	78 1b                	js     8025a1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	ff 75 10             	pushl  0x10(%ebp)
  80258c:	ff 75 0c             	pushl  0xc(%ebp)
  80258f:	50                   	push   %eax
  802590:	e8 22 01 00 00       	call   8026b7 <nsipc_accept>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	85 c0                	test   %eax,%eax
  80259a:	78 05                	js     8025a1 <accept+0x31>
	return alloc_sockfd(r);
  80259c:	e8 5b ff ff ff       	call   8024fc <alloc_sockfd>
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <bind>:
{
  8025a3:	f3 0f 1e fb          	endbr32 
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	e8 17 ff ff ff       	call   8024cc <fd2sockid>
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	78 12                	js     8025cb <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	ff 75 10             	pushl  0x10(%ebp)
  8025bf:	ff 75 0c             	pushl  0xc(%ebp)
  8025c2:	50                   	push   %eax
  8025c3:	e8 45 01 00 00       	call   80270d <nsipc_bind>
  8025c8:	83 c4 10             	add    $0x10,%esp
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <shutdown>:
{
  8025cd:	f3 0f 1e fb          	endbr32 
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	e8 ed fe ff ff       	call   8024cc <fd2sockid>
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 0f                	js     8025f2 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8025e3:	83 ec 08             	sub    $0x8,%esp
  8025e6:	ff 75 0c             	pushl  0xc(%ebp)
  8025e9:	50                   	push   %eax
  8025ea:	e8 57 01 00 00       	call   802746 <nsipc_shutdown>
  8025ef:	83 c4 10             	add    $0x10,%esp
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <connect>:
{
  8025f4:	f3 0f 1e fb          	endbr32 
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	e8 c6 fe ff ff       	call   8024cc <fd2sockid>
  802606:	85 c0                	test   %eax,%eax
  802608:	78 12                	js     80261c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	ff 75 10             	pushl  0x10(%ebp)
  802610:	ff 75 0c             	pushl  0xc(%ebp)
  802613:	50                   	push   %eax
  802614:	e8 71 01 00 00       	call   80278a <nsipc_connect>
  802619:	83 c4 10             	add    $0x10,%esp
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <listen>:
{
  80261e:	f3 0f 1e fb          	endbr32 
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	e8 9c fe ff ff       	call   8024cc <fd2sockid>
  802630:	85 c0                	test   %eax,%eax
  802632:	78 0f                	js     802643 <listen+0x25>
	return nsipc_listen(r, backlog);
  802634:	83 ec 08             	sub    $0x8,%esp
  802637:	ff 75 0c             	pushl  0xc(%ebp)
  80263a:	50                   	push   %eax
  80263b:	e8 83 01 00 00       	call   8027c3 <nsipc_listen>
  802640:	83 c4 10             	add    $0x10,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <socket>:

int
socket(int domain, int type, int protocol)
{
  802645:	f3 0f 1e fb          	endbr32 
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80264f:	ff 75 10             	pushl  0x10(%ebp)
  802652:	ff 75 0c             	pushl  0xc(%ebp)
  802655:	ff 75 08             	pushl  0x8(%ebp)
  802658:	e8 65 02 00 00       	call   8028c2 <nsipc_socket>
  80265d:	83 c4 10             	add    $0x10,%esp
  802660:	85 c0                	test   %eax,%eax
  802662:	78 05                	js     802669 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802664:	e8 93 fe ff ff       	call   8024fc <alloc_sockfd>
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	53                   	push   %ebx
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802674:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80267b:	74 26                	je     8026a3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80267d:	6a 07                	push   $0x7
  80267f:	68 00 70 80 00       	push   $0x807000
  802684:	53                   	push   %ebx
  802685:	ff 35 04 50 80 00    	pushl  0x805004
  80268b:	e8 32 07 00 00       	call   802dc2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802690:	83 c4 0c             	add    $0xc,%esp
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	e8 b0 06 00 00       	call   802d4e <ipc_recv>
}
  80269e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	6a 02                	push   $0x2
  8026a8:	e8 6d 07 00 00       	call   802e1a <ipc_find_env>
  8026ad:	a3 04 50 80 00       	mov    %eax,0x805004
  8026b2:	83 c4 10             	add    $0x10,%esp
  8026b5:	eb c6                	jmp    80267d <nsipc+0x12>

008026b7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8026b7:	f3 0f 1e fb          	endbr32 
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8026cb:	8b 06                	mov    (%esi),%eax
  8026cd:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8026d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d7:	e8 8f ff ff ff       	call   80266b <nsipc>
  8026dc:	89 c3                	mov    %eax,%ebx
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	79 09                	jns    8026eb <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8026e2:	89 d8                	mov    %ebx,%eax
  8026e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026e7:	5b                   	pop    %ebx
  8026e8:	5e                   	pop    %esi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	ff 35 10 70 80 00    	pushl  0x807010
  8026f4:	68 00 70 80 00       	push   $0x807000
  8026f9:	ff 75 0c             	pushl  0xc(%ebp)
  8026fc:	e8 bc e6 ff ff       	call   800dbd <memmove>
		*addrlen = ret->ret_addrlen;
  802701:	a1 10 70 80 00       	mov    0x807010,%eax
  802706:	89 06                	mov    %eax,(%esi)
  802708:	83 c4 10             	add    $0x10,%esp
	return r;
  80270b:	eb d5                	jmp    8026e2 <nsipc_accept+0x2b>

0080270d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80270d:	f3 0f 1e fb          	endbr32 
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	53                   	push   %ebx
  802715:	83 ec 08             	sub    $0x8,%esp
  802718:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802723:	53                   	push   %ebx
  802724:	ff 75 0c             	pushl  0xc(%ebp)
  802727:	68 04 70 80 00       	push   $0x807004
  80272c:	e8 8c e6 ff ff       	call   800dbd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802731:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802737:	b8 02 00 00 00       	mov    $0x2,%eax
  80273c:	e8 2a ff ff ff       	call   80266b <nsipc>
}
  802741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802744:	c9                   	leave  
  802745:	c3                   	ret    

00802746 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802746:	f3 0f 1e fb          	endbr32 
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802758:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275b:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802760:	b8 03 00 00 00       	mov    $0x3,%eax
  802765:	e8 01 ff ff ff       	call   80266b <nsipc>
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <nsipc_close>:

int
nsipc_close(int s)
{
  80276c:	f3 0f 1e fb          	endbr32 
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80277e:	b8 04 00 00 00       	mov    $0x4,%eax
  802783:	e8 e3 fe ff ff       	call   80266b <nsipc>
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80278a:	f3 0f 1e fb          	endbr32 
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	53                   	push   %ebx
  802792:	83 ec 08             	sub    $0x8,%esp
  802795:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027a0:	53                   	push   %ebx
  8027a1:	ff 75 0c             	pushl  0xc(%ebp)
  8027a4:	68 04 70 80 00       	push   $0x807004
  8027a9:	e8 0f e6 ff ff       	call   800dbd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027ae:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8027b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8027b9:	e8 ad fe ff ff       	call   80266b <nsipc>
}
  8027be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8027c3:	f3 0f 1e fb          	endbr32 
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8027d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d8:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8027dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8027e2:	e8 84 fe ff ff       	call   80266b <nsipc>
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8027e9:	f3 0f 1e fb          	endbr32 
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	56                   	push   %esi
  8027f1:	53                   	push   %ebx
  8027f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8027fd:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802803:	8b 45 14             	mov    0x14(%ebp),%eax
  802806:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80280b:	b8 07 00 00 00       	mov    $0x7,%eax
  802810:	e8 56 fe ff ff       	call   80266b <nsipc>
  802815:	89 c3                	mov    %eax,%ebx
  802817:	85 c0                	test   %eax,%eax
  802819:	78 26                	js     802841 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80281b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802821:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802826:	0f 4e c6             	cmovle %esi,%eax
  802829:	39 c3                	cmp    %eax,%ebx
  80282b:	7f 1d                	jg     80284a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	53                   	push   %ebx
  802831:	68 00 70 80 00       	push   $0x807000
  802836:	ff 75 0c             	pushl  0xc(%ebp)
  802839:	e8 7f e5 ff ff       	call   800dbd <memmove>
  80283e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802841:	89 d8                	mov    %ebx,%eax
  802843:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802846:	5b                   	pop    %ebx
  802847:	5e                   	pop    %esi
  802848:	5d                   	pop    %ebp
  802849:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80284a:	68 36 38 80 00       	push   $0x803836
  80284f:	68 63 37 80 00       	push   $0x803763
  802854:	6a 62                	push   $0x62
  802856:	68 4b 38 80 00       	push   $0x80384b
  80285b:	e8 b6 dc ff ff       	call   800516 <_panic>

00802860 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802860:	f3 0f 1e fb          	endbr32 
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	53                   	push   %ebx
  802868:	83 ec 04             	sub    $0x4,%esp
  80286b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802876:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80287c:	7f 2e                	jg     8028ac <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	53                   	push   %ebx
  802882:	ff 75 0c             	pushl  0xc(%ebp)
  802885:	68 0c 70 80 00       	push   $0x80700c
  80288a:	e8 2e e5 ff ff       	call   800dbd <memmove>
	nsipcbuf.send.req_size = size;
  80288f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802895:	8b 45 14             	mov    0x14(%ebp),%eax
  802898:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80289d:	b8 08 00 00 00       	mov    $0x8,%eax
  8028a2:	e8 c4 fd ff ff       	call   80266b <nsipc>
}
  8028a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    
	assert(size < 1600);
  8028ac:	68 57 38 80 00       	push   $0x803857
  8028b1:	68 63 37 80 00       	push   $0x803763
  8028b6:	6a 6d                	push   $0x6d
  8028b8:	68 4b 38 80 00       	push   $0x80384b
  8028bd:	e8 54 dc ff ff       	call   800516 <_panic>

008028c2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8028c2:	f3 0f 1e fb          	endbr32 
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8028d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d7:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8028dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8028df:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8028e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8028e9:	e8 7d fd ff ff       	call   80266b <nsipc>
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028f0:	f3 0f 1e fb          	endbr32 
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	56                   	push   %esi
  8028f8:	53                   	push   %ebx
  8028f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028fc:	83 ec 0c             	sub    $0xc,%esp
  8028ff:	ff 75 08             	pushl  0x8(%ebp)
  802902:	e8 c8 ec ff ff       	call   8015cf <fd2data>
  802907:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802909:	83 c4 08             	add    $0x8,%esp
  80290c:	68 63 38 80 00       	push   $0x803863
  802911:	53                   	push   %ebx
  802912:	e8 f0 e2 ff ff       	call   800c07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802917:	8b 46 04             	mov    0x4(%esi),%eax
  80291a:	2b 06                	sub    (%esi),%eax
  80291c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802922:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802929:	00 00 00 
	stat->st_dev = &devpipe;
  80292c:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802933:	40 80 00 
	return 0;
}
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
  80293b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80293e:	5b                   	pop    %ebx
  80293f:	5e                   	pop    %esi
  802940:	5d                   	pop    %ebp
  802941:	c3                   	ret    

00802942 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802942:	f3 0f 1e fb          	endbr32 
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	53                   	push   %ebx
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802950:	53                   	push   %ebx
  802951:	6a 00                	push   $0x0
  802953:	e8 7e e7 ff ff       	call   8010d6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802958:	89 1c 24             	mov    %ebx,(%esp)
  80295b:	e8 6f ec ff ff       	call   8015cf <fd2data>
  802960:	83 c4 08             	add    $0x8,%esp
  802963:	50                   	push   %eax
  802964:	6a 00                	push   $0x0
  802966:	e8 6b e7 ff ff       	call   8010d6 <sys_page_unmap>
}
  80296b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <_pipeisclosed>:
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	57                   	push   %edi
  802974:	56                   	push   %esi
  802975:	53                   	push   %ebx
  802976:	83 ec 1c             	sub    $0x1c,%esp
  802979:	89 c7                	mov    %eax,%edi
  80297b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80297d:	a1 08 50 80 00       	mov    0x805008,%eax
  802982:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802985:	83 ec 0c             	sub    $0xc,%esp
  802988:	57                   	push   %edi
  802989:	e8 c9 04 00 00       	call   802e57 <pageref>
  80298e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802991:	89 34 24             	mov    %esi,(%esp)
  802994:	e8 be 04 00 00       	call   802e57 <pageref>
		nn = thisenv->env_runs;
  802999:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80299f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	39 cb                	cmp    %ecx,%ebx
  8029a7:	74 1b                	je     8029c4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8029a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029ac:	75 cf                	jne    80297d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8029ae:	8b 42 58             	mov    0x58(%edx),%eax
  8029b1:	6a 01                	push   $0x1
  8029b3:	50                   	push   %eax
  8029b4:	53                   	push   %ebx
  8029b5:	68 6a 38 80 00       	push   $0x80386a
  8029ba:	e8 3e dc ff ff       	call   8005fd <cprintf>
  8029bf:	83 c4 10             	add    $0x10,%esp
  8029c2:	eb b9                	jmp    80297d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8029c4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8029c7:	0f 94 c0             	sete   %al
  8029ca:	0f b6 c0             	movzbl %al,%eax
}
  8029cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029d0:	5b                   	pop    %ebx
  8029d1:	5e                   	pop    %esi
  8029d2:	5f                   	pop    %edi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    

008029d5 <devpipe_write>:
{
  8029d5:	f3 0f 1e fb          	endbr32 
  8029d9:	55                   	push   %ebp
  8029da:	89 e5                	mov    %esp,%ebp
  8029dc:	57                   	push   %edi
  8029dd:	56                   	push   %esi
  8029de:	53                   	push   %ebx
  8029df:	83 ec 28             	sub    $0x28,%esp
  8029e2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8029e5:	56                   	push   %esi
  8029e6:	e8 e4 eb ff ff       	call   8015cf <fd2data>
  8029eb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8029ed:	83 c4 10             	add    $0x10,%esp
  8029f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8029f8:	74 4f                	je     802a49 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029fa:	8b 43 04             	mov    0x4(%ebx),%eax
  8029fd:	8b 0b                	mov    (%ebx),%ecx
  8029ff:	8d 51 20             	lea    0x20(%ecx),%edx
  802a02:	39 d0                	cmp    %edx,%eax
  802a04:	72 14                	jb     802a1a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802a06:	89 da                	mov    %ebx,%edx
  802a08:	89 f0                	mov    %esi,%eax
  802a0a:	e8 61 ff ff ff       	call   802970 <_pipeisclosed>
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 3b                	jne    802a4e <devpipe_write+0x79>
			sys_yield();
  802a13:	e8 0e e6 ff ff       	call   801026 <sys_yield>
  802a18:	eb e0                	jmp    8029fa <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a1d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802a21:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802a24:	89 c2                	mov    %eax,%edx
  802a26:	c1 fa 1f             	sar    $0x1f,%edx
  802a29:	89 d1                	mov    %edx,%ecx
  802a2b:	c1 e9 1b             	shr    $0x1b,%ecx
  802a2e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802a31:	83 e2 1f             	and    $0x1f,%edx
  802a34:	29 ca                	sub    %ecx,%edx
  802a36:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802a3a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a3e:	83 c0 01             	add    $0x1,%eax
  802a41:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802a44:	83 c7 01             	add    $0x1,%edi
  802a47:	eb ac                	jmp    8029f5 <devpipe_write+0x20>
	return i;
  802a49:	8b 45 10             	mov    0x10(%ebp),%eax
  802a4c:	eb 05                	jmp    802a53 <devpipe_write+0x7e>
				return 0;
  802a4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a56:	5b                   	pop    %ebx
  802a57:	5e                   	pop    %esi
  802a58:	5f                   	pop    %edi
  802a59:	5d                   	pop    %ebp
  802a5a:	c3                   	ret    

00802a5b <devpipe_read>:
{
  802a5b:	f3 0f 1e fb          	endbr32 
  802a5f:	55                   	push   %ebp
  802a60:	89 e5                	mov    %esp,%ebp
  802a62:	57                   	push   %edi
  802a63:	56                   	push   %esi
  802a64:	53                   	push   %ebx
  802a65:	83 ec 18             	sub    $0x18,%esp
  802a68:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802a6b:	57                   	push   %edi
  802a6c:	e8 5e eb ff ff       	call   8015cf <fd2data>
  802a71:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802a73:	83 c4 10             	add    $0x10,%esp
  802a76:	be 00 00 00 00       	mov    $0x0,%esi
  802a7b:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a7e:	75 14                	jne    802a94 <devpipe_read+0x39>
	return i;
  802a80:	8b 45 10             	mov    0x10(%ebp),%eax
  802a83:	eb 02                	jmp    802a87 <devpipe_read+0x2c>
				return i;
  802a85:	89 f0                	mov    %esi,%eax
}
  802a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a8a:	5b                   	pop    %ebx
  802a8b:	5e                   	pop    %esi
  802a8c:	5f                   	pop    %edi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
			sys_yield();
  802a8f:	e8 92 e5 ff ff       	call   801026 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802a94:	8b 03                	mov    (%ebx),%eax
  802a96:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a99:	75 18                	jne    802ab3 <devpipe_read+0x58>
			if (i > 0)
  802a9b:	85 f6                	test   %esi,%esi
  802a9d:	75 e6                	jne    802a85 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802a9f:	89 da                	mov    %ebx,%edx
  802aa1:	89 f8                	mov    %edi,%eax
  802aa3:	e8 c8 fe ff ff       	call   802970 <_pipeisclosed>
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	74 e3                	je     802a8f <devpipe_read+0x34>
				return 0;
  802aac:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab1:	eb d4                	jmp    802a87 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802ab3:	99                   	cltd   
  802ab4:	c1 ea 1b             	shr    $0x1b,%edx
  802ab7:	01 d0                	add    %edx,%eax
  802ab9:	83 e0 1f             	and    $0x1f,%eax
  802abc:	29 d0                	sub    %edx,%eax
  802abe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ac3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ac6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ac9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802acc:	83 c6 01             	add    $0x1,%esi
  802acf:	eb aa                	jmp    802a7b <devpipe_read+0x20>

00802ad1 <pipe>:
{
  802ad1:	f3 0f 1e fb          	endbr32 
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	56                   	push   %esi
  802ad9:	53                   	push   %ebx
  802ada:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802add:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae0:	50                   	push   %eax
  802ae1:	e8 04 eb ff ff       	call   8015ea <fd_alloc>
  802ae6:	89 c3                	mov    %eax,%ebx
  802ae8:	83 c4 10             	add    $0x10,%esp
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	0f 88 23 01 00 00    	js     802c16 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 07 04 00 00       	push   $0x407
  802afb:	ff 75 f4             	pushl  -0xc(%ebp)
  802afe:	6a 00                	push   $0x0
  802b00:	e8 44 e5 ff ff       	call   801049 <sys_page_alloc>
  802b05:	89 c3                	mov    %eax,%ebx
  802b07:	83 c4 10             	add    $0x10,%esp
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	0f 88 04 01 00 00    	js     802c16 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802b12:	83 ec 0c             	sub    $0xc,%esp
  802b15:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b18:	50                   	push   %eax
  802b19:	e8 cc ea ff ff       	call   8015ea <fd_alloc>
  802b1e:	89 c3                	mov    %eax,%ebx
  802b20:	83 c4 10             	add    $0x10,%esp
  802b23:	85 c0                	test   %eax,%eax
  802b25:	0f 88 db 00 00 00    	js     802c06 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 07 04 00 00       	push   $0x407
  802b33:	ff 75 f0             	pushl  -0x10(%ebp)
  802b36:	6a 00                	push   $0x0
  802b38:	e8 0c e5 ff ff       	call   801049 <sys_page_alloc>
  802b3d:	89 c3                	mov    %eax,%ebx
  802b3f:	83 c4 10             	add    $0x10,%esp
  802b42:	85 c0                	test   %eax,%eax
  802b44:	0f 88 bc 00 00 00    	js     802c06 <pipe+0x135>
	va = fd2data(fd0);
  802b4a:	83 ec 0c             	sub    $0xc,%esp
  802b4d:	ff 75 f4             	pushl  -0xc(%ebp)
  802b50:	e8 7a ea ff ff       	call   8015cf <fd2data>
  802b55:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b57:	83 c4 0c             	add    $0xc,%esp
  802b5a:	68 07 04 00 00       	push   $0x407
  802b5f:	50                   	push   %eax
  802b60:	6a 00                	push   $0x0
  802b62:	e8 e2 e4 ff ff       	call   801049 <sys_page_alloc>
  802b67:	89 c3                	mov    %eax,%ebx
  802b69:	83 c4 10             	add    $0x10,%esp
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	0f 88 82 00 00 00    	js     802bf6 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b74:	83 ec 0c             	sub    $0xc,%esp
  802b77:	ff 75 f0             	pushl  -0x10(%ebp)
  802b7a:	e8 50 ea ff ff       	call   8015cf <fd2data>
  802b7f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802b86:	50                   	push   %eax
  802b87:	6a 00                	push   $0x0
  802b89:	56                   	push   %esi
  802b8a:	6a 00                	push   $0x0
  802b8c:	e8 ff e4 ff ff       	call   801090 <sys_page_map>
  802b91:	89 c3                	mov    %eax,%ebx
  802b93:	83 c4 20             	add    $0x20,%esp
  802b96:	85 c0                	test   %eax,%eax
  802b98:	78 4e                	js     802be8 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802b9a:	a1 58 40 80 00       	mov    0x804058,%eax
  802b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802bae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  802bc3:	e8 f3 e9 ff ff       	call   8015bb <fd2num>
  802bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bcb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802bcd:	83 c4 04             	add    $0x4,%esp
  802bd0:	ff 75 f0             	pushl  -0x10(%ebp)
  802bd3:	e8 e3 e9 ff ff       	call   8015bb <fd2num>
  802bd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bdb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802bde:	83 c4 10             	add    $0x10,%esp
  802be1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be6:	eb 2e                	jmp    802c16 <pipe+0x145>
	sys_page_unmap(0, va);
  802be8:	83 ec 08             	sub    $0x8,%esp
  802beb:	56                   	push   %esi
  802bec:	6a 00                	push   $0x0
  802bee:	e8 e3 e4 ff ff       	call   8010d6 <sys_page_unmap>
  802bf3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802bf6:	83 ec 08             	sub    $0x8,%esp
  802bf9:	ff 75 f0             	pushl  -0x10(%ebp)
  802bfc:	6a 00                	push   $0x0
  802bfe:	e8 d3 e4 ff ff       	call   8010d6 <sys_page_unmap>
  802c03:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802c06:	83 ec 08             	sub    $0x8,%esp
  802c09:	ff 75 f4             	pushl  -0xc(%ebp)
  802c0c:	6a 00                	push   $0x0
  802c0e:	e8 c3 e4 ff ff       	call   8010d6 <sys_page_unmap>
  802c13:	83 c4 10             	add    $0x10,%esp
}
  802c16:	89 d8                	mov    %ebx,%eax
  802c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c1b:	5b                   	pop    %ebx
  802c1c:	5e                   	pop    %esi
  802c1d:	5d                   	pop    %ebp
  802c1e:	c3                   	ret    

00802c1f <pipeisclosed>:
{
  802c1f:	f3 0f 1e fb          	endbr32 
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c2c:	50                   	push   %eax
  802c2d:	ff 75 08             	pushl  0x8(%ebp)
  802c30:	e8 0b ea ff ff       	call   801640 <fd_lookup>
  802c35:	83 c4 10             	add    $0x10,%esp
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	78 18                	js     802c54 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802c3c:	83 ec 0c             	sub    $0xc,%esp
  802c3f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c42:	e8 88 e9 ff ff       	call   8015cf <fd2data>
  802c47:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	e8 1f fd ff ff       	call   802970 <_pipeisclosed>
  802c51:	83 c4 10             	add    $0x10,%esp
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c56:	f3 0f 1e fb          	endbr32 
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	56                   	push   %esi
  802c5e:	53                   	push   %ebx
  802c5f:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802c62:	85 f6                	test   %esi,%esi
  802c64:	74 13                	je     802c79 <wait+0x23>
	e = &envs[ENVX(envid)];
  802c66:	89 f3                	mov    %esi,%ebx
  802c68:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c6e:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802c71:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802c77:	eb 1b                	jmp    802c94 <wait+0x3e>
	assert(envid != 0);
  802c79:	68 82 38 80 00       	push   $0x803882
  802c7e:	68 63 37 80 00       	push   $0x803763
  802c83:	6a 09                	push   $0x9
  802c85:	68 8d 38 80 00       	push   $0x80388d
  802c8a:	e8 87 d8 ff ff       	call   800516 <_panic>
		sys_yield();
  802c8f:	e8 92 e3 ff ff       	call   801026 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802c94:	8b 43 48             	mov    0x48(%ebx),%eax
  802c97:	39 f0                	cmp    %esi,%eax
  802c99:	75 07                	jne    802ca2 <wait+0x4c>
  802c9b:	8b 43 54             	mov    0x54(%ebx),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	75 ed                	jne    802c8f <wait+0x39>
}
  802ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ca5:	5b                   	pop    %ebx
  802ca6:	5e                   	pop    %esi
  802ca7:	5d                   	pop    %ebp
  802ca8:	c3                   	ret    

00802ca9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ca9:	f3 0f 1e fb          	endbr32 
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
  802cb0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802cb3:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802cba:	74 0a                	je     802cc6 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802cc4:	c9                   	leave  
  802cc5:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802cc6:	a1 08 50 80 00       	mov    0x805008,%eax
  802ccb:	8b 40 48             	mov    0x48(%eax),%eax
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	6a 07                	push   $0x7
  802cd3:	68 00 f0 bf ee       	push   $0xeebff000
  802cd8:	50                   	push   %eax
  802cd9:	e8 6b e3 ff ff       	call   801049 <sys_page_alloc>
  802cde:	83 c4 10             	add    $0x10,%esp
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	75 31                	jne    802d16 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802ce5:	a1 08 50 80 00       	mov    0x805008,%eax
  802cea:	8b 40 48             	mov    0x48(%eax),%eax
  802ced:	83 ec 08             	sub    $0x8,%esp
  802cf0:	68 2a 2d 80 00       	push   $0x802d2a
  802cf5:	50                   	push   %eax
  802cf6:	e8 ad e4 ff ff       	call   8011a8 <sys_env_set_pgfault_upcall>
  802cfb:	83 c4 10             	add    $0x10,%esp
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 ba                	je     802cbc <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 c0 38 80 00       	push   $0x8038c0
  802d0a:	6a 24                	push   $0x24
  802d0c:	68 ee 38 80 00       	push   $0x8038ee
  802d11:	e8 00 d8 ff ff       	call   800516 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 98 38 80 00       	push   $0x803898
  802d1e:	6a 21                	push   $0x21
  802d20:	68 ee 38 80 00       	push   $0x8038ee
  802d25:	e8 ec d7 ff ff       	call   800516 <_panic>

00802d2a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d2a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d2b:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802d30:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d32:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802d35:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802d39:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802d3e:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802d42:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802d44:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802d47:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802d48:	83 c4 04             	add    $0x4,%esp
    popfl
  802d4b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802d4c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802d4d:	c3                   	ret    

00802d4e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d4e:	f3 0f 1e fb          	endbr32 
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	56                   	push   %esi
  802d56:	53                   	push   %ebx
  802d57:	8b 75 08             	mov    0x8(%ebp),%esi
  802d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802d60:	83 e8 01             	sub    $0x1,%eax
  802d63:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802d68:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802d6d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802d71:	83 ec 0c             	sub    $0xc,%esp
  802d74:	50                   	push   %eax
  802d75:	e8 9b e4 ff ff       	call   801215 <sys_ipc_recv>
	if (!t) {
  802d7a:	83 c4 10             	add    $0x10,%esp
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	75 2b                	jne    802dac <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802d81:	85 f6                	test   %esi,%esi
  802d83:	74 0a                	je     802d8f <ipc_recv+0x41>
  802d85:	a1 08 50 80 00       	mov    0x805008,%eax
  802d8a:	8b 40 74             	mov    0x74(%eax),%eax
  802d8d:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802d8f:	85 db                	test   %ebx,%ebx
  802d91:	74 0a                	je     802d9d <ipc_recv+0x4f>
  802d93:	a1 08 50 80 00       	mov    0x805008,%eax
  802d98:	8b 40 78             	mov    0x78(%eax),%eax
  802d9b:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802d9d:	a1 08 50 80 00       	mov    0x805008,%eax
  802da2:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802da8:	5b                   	pop    %ebx
  802da9:	5e                   	pop    %esi
  802daa:	5d                   	pop    %ebp
  802dab:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802dac:	85 f6                	test   %esi,%esi
  802dae:	74 06                	je     802db6 <ipc_recv+0x68>
  802db0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802db6:	85 db                	test   %ebx,%ebx
  802db8:	74 eb                	je     802da5 <ipc_recv+0x57>
  802dba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802dc0:	eb e3                	jmp    802da5 <ipc_recv+0x57>

00802dc2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802dc2:	f3 0f 1e fb          	endbr32 
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	57                   	push   %edi
  802dca:	56                   	push   %esi
  802dcb:	53                   	push   %ebx
  802dcc:	83 ec 0c             	sub    $0xc,%esp
  802dcf:	8b 7d 08             	mov    0x8(%ebp),%edi
  802dd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  802dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802dd8:	85 db                	test   %ebx,%ebx
  802dda:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ddf:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802de2:	ff 75 14             	pushl  0x14(%ebp)
  802de5:	53                   	push   %ebx
  802de6:	56                   	push   %esi
  802de7:	57                   	push   %edi
  802de8:	e8 01 e4 ff ff       	call   8011ee <sys_ipc_try_send>
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 1e                	je     802e12 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802df4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802df7:	75 07                	jne    802e00 <ipc_send+0x3e>
		sys_yield();
  802df9:	e8 28 e2 ff ff       	call   801026 <sys_yield>
  802dfe:	eb e2                	jmp    802de2 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802e00:	50                   	push   %eax
  802e01:	68 fc 38 80 00       	push   $0x8038fc
  802e06:	6a 39                	push   $0x39
  802e08:	68 0e 39 80 00       	push   $0x80390e
  802e0d:	e8 04 d7 ff ff       	call   800516 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802e15:	5b                   	pop    %ebx
  802e16:	5e                   	pop    %esi
  802e17:	5f                   	pop    %edi
  802e18:	5d                   	pop    %ebp
  802e19:	c3                   	ret    

00802e1a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e1a:	f3 0f 1e fb          	endbr32 
  802e1e:	55                   	push   %ebp
  802e1f:	89 e5                	mov    %esp,%ebp
  802e21:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e29:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802e2c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e32:	8b 52 50             	mov    0x50(%edx),%edx
  802e35:	39 ca                	cmp    %ecx,%edx
  802e37:	74 11                	je     802e4a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802e39:	83 c0 01             	add    $0x1,%eax
  802e3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e41:	75 e6                	jne    802e29 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802e43:	b8 00 00 00 00       	mov    $0x0,%eax
  802e48:	eb 0b                	jmp    802e55 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802e4a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802e4d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802e52:	8b 40 48             	mov    0x48(%eax),%eax
}
  802e55:	5d                   	pop    %ebp
  802e56:	c3                   	ret    

00802e57 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e57:	f3 0f 1e fb          	endbr32 
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e61:	89 c2                	mov    %eax,%edx
  802e63:	c1 ea 16             	shr    $0x16,%edx
  802e66:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802e6d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802e72:	f6 c1 01             	test   $0x1,%cl
  802e75:	74 1c                	je     802e93 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802e77:	c1 e8 0c             	shr    $0xc,%eax
  802e7a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802e81:	a8 01                	test   $0x1,%al
  802e83:	74 0e                	je     802e93 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802e85:	c1 e8 0c             	shr    $0xc,%eax
  802e88:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802e8f:	ef 
  802e90:	0f b7 d2             	movzwl %dx,%edx
}
  802e93:	89 d0                	mov    %edx,%eax
  802e95:	5d                   	pop    %ebp
  802e96:	c3                   	ret    
  802e97:	66 90                	xchg   %ax,%ax
  802e99:	66 90                	xchg   %ax,%ax
  802e9b:	66 90                	xchg   %ax,%ax
  802e9d:	66 90                	xchg   %ax,%ax
  802e9f:	90                   	nop

00802ea0 <__udivdi3>:
  802ea0:	f3 0f 1e fb          	endbr32 
  802ea4:	55                   	push   %ebp
  802ea5:	57                   	push   %edi
  802ea6:	56                   	push   %esi
  802ea7:	53                   	push   %ebx
  802ea8:	83 ec 1c             	sub    $0x1c,%esp
  802eab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802eaf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802eb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  802eb7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ebb:	85 d2                	test   %edx,%edx
  802ebd:	75 19                	jne    802ed8 <__udivdi3+0x38>
  802ebf:	39 f3                	cmp    %esi,%ebx
  802ec1:	76 4d                	jbe    802f10 <__udivdi3+0x70>
  802ec3:	31 ff                	xor    %edi,%edi
  802ec5:	89 e8                	mov    %ebp,%eax
  802ec7:	89 f2                	mov    %esi,%edx
  802ec9:	f7 f3                	div    %ebx
  802ecb:	89 fa                	mov    %edi,%edx
  802ecd:	83 c4 1c             	add    $0x1c,%esp
  802ed0:	5b                   	pop    %ebx
  802ed1:	5e                   	pop    %esi
  802ed2:	5f                   	pop    %edi
  802ed3:	5d                   	pop    %ebp
  802ed4:	c3                   	ret    
  802ed5:	8d 76 00             	lea    0x0(%esi),%esi
  802ed8:	39 f2                	cmp    %esi,%edx
  802eda:	76 14                	jbe    802ef0 <__udivdi3+0x50>
  802edc:	31 ff                	xor    %edi,%edi
  802ede:	31 c0                	xor    %eax,%eax
  802ee0:	89 fa                	mov    %edi,%edx
  802ee2:	83 c4 1c             	add    $0x1c,%esp
  802ee5:	5b                   	pop    %ebx
  802ee6:	5e                   	pop    %esi
  802ee7:	5f                   	pop    %edi
  802ee8:	5d                   	pop    %ebp
  802ee9:	c3                   	ret    
  802eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ef0:	0f bd fa             	bsr    %edx,%edi
  802ef3:	83 f7 1f             	xor    $0x1f,%edi
  802ef6:	75 48                	jne    802f40 <__udivdi3+0xa0>
  802ef8:	39 f2                	cmp    %esi,%edx
  802efa:	72 06                	jb     802f02 <__udivdi3+0x62>
  802efc:	31 c0                	xor    %eax,%eax
  802efe:	39 eb                	cmp    %ebp,%ebx
  802f00:	77 de                	ja     802ee0 <__udivdi3+0x40>
  802f02:	b8 01 00 00 00       	mov    $0x1,%eax
  802f07:	eb d7                	jmp    802ee0 <__udivdi3+0x40>
  802f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f10:	89 d9                	mov    %ebx,%ecx
  802f12:	85 db                	test   %ebx,%ebx
  802f14:	75 0b                	jne    802f21 <__udivdi3+0x81>
  802f16:	b8 01 00 00 00       	mov    $0x1,%eax
  802f1b:	31 d2                	xor    %edx,%edx
  802f1d:	f7 f3                	div    %ebx
  802f1f:	89 c1                	mov    %eax,%ecx
  802f21:	31 d2                	xor    %edx,%edx
  802f23:	89 f0                	mov    %esi,%eax
  802f25:	f7 f1                	div    %ecx
  802f27:	89 c6                	mov    %eax,%esi
  802f29:	89 e8                	mov    %ebp,%eax
  802f2b:	89 f7                	mov    %esi,%edi
  802f2d:	f7 f1                	div    %ecx
  802f2f:	89 fa                	mov    %edi,%edx
  802f31:	83 c4 1c             	add    $0x1c,%esp
  802f34:	5b                   	pop    %ebx
  802f35:	5e                   	pop    %esi
  802f36:	5f                   	pop    %edi
  802f37:	5d                   	pop    %ebp
  802f38:	c3                   	ret    
  802f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f40:	89 f9                	mov    %edi,%ecx
  802f42:	b8 20 00 00 00       	mov    $0x20,%eax
  802f47:	29 f8                	sub    %edi,%eax
  802f49:	d3 e2                	shl    %cl,%edx
  802f4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802f4f:	89 c1                	mov    %eax,%ecx
  802f51:	89 da                	mov    %ebx,%edx
  802f53:	d3 ea                	shr    %cl,%edx
  802f55:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802f59:	09 d1                	or     %edx,%ecx
  802f5b:	89 f2                	mov    %esi,%edx
  802f5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f61:	89 f9                	mov    %edi,%ecx
  802f63:	d3 e3                	shl    %cl,%ebx
  802f65:	89 c1                	mov    %eax,%ecx
  802f67:	d3 ea                	shr    %cl,%edx
  802f69:	89 f9                	mov    %edi,%ecx
  802f6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802f6f:	89 eb                	mov    %ebp,%ebx
  802f71:	d3 e6                	shl    %cl,%esi
  802f73:	89 c1                	mov    %eax,%ecx
  802f75:	d3 eb                	shr    %cl,%ebx
  802f77:	09 de                	or     %ebx,%esi
  802f79:	89 f0                	mov    %esi,%eax
  802f7b:	f7 74 24 08          	divl   0x8(%esp)
  802f7f:	89 d6                	mov    %edx,%esi
  802f81:	89 c3                	mov    %eax,%ebx
  802f83:	f7 64 24 0c          	mull   0xc(%esp)
  802f87:	39 d6                	cmp    %edx,%esi
  802f89:	72 15                	jb     802fa0 <__udivdi3+0x100>
  802f8b:	89 f9                	mov    %edi,%ecx
  802f8d:	d3 e5                	shl    %cl,%ebp
  802f8f:	39 c5                	cmp    %eax,%ebp
  802f91:	73 04                	jae    802f97 <__udivdi3+0xf7>
  802f93:	39 d6                	cmp    %edx,%esi
  802f95:	74 09                	je     802fa0 <__udivdi3+0x100>
  802f97:	89 d8                	mov    %ebx,%eax
  802f99:	31 ff                	xor    %edi,%edi
  802f9b:	e9 40 ff ff ff       	jmp    802ee0 <__udivdi3+0x40>
  802fa0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802fa3:	31 ff                	xor    %edi,%edi
  802fa5:	e9 36 ff ff ff       	jmp    802ee0 <__udivdi3+0x40>
  802faa:	66 90                	xchg   %ax,%ax
  802fac:	66 90                	xchg   %ax,%ax
  802fae:	66 90                	xchg   %ax,%ax

00802fb0 <__umoddi3>:
  802fb0:	f3 0f 1e fb          	endbr32 
  802fb4:	55                   	push   %ebp
  802fb5:	57                   	push   %edi
  802fb6:	56                   	push   %esi
  802fb7:	53                   	push   %ebx
  802fb8:	83 ec 1c             	sub    $0x1c,%esp
  802fbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802fbf:	8b 74 24 30          	mov    0x30(%esp),%esi
  802fc3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802fc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	75 19                	jne    802fe8 <__umoddi3+0x38>
  802fcf:	39 df                	cmp    %ebx,%edi
  802fd1:	76 5d                	jbe    803030 <__umoddi3+0x80>
  802fd3:	89 f0                	mov    %esi,%eax
  802fd5:	89 da                	mov    %ebx,%edx
  802fd7:	f7 f7                	div    %edi
  802fd9:	89 d0                	mov    %edx,%eax
  802fdb:	31 d2                	xor    %edx,%edx
  802fdd:	83 c4 1c             	add    $0x1c,%esp
  802fe0:	5b                   	pop    %ebx
  802fe1:	5e                   	pop    %esi
  802fe2:	5f                   	pop    %edi
  802fe3:	5d                   	pop    %ebp
  802fe4:	c3                   	ret    
  802fe5:	8d 76 00             	lea    0x0(%esi),%esi
  802fe8:	89 f2                	mov    %esi,%edx
  802fea:	39 d8                	cmp    %ebx,%eax
  802fec:	76 12                	jbe    803000 <__umoddi3+0x50>
  802fee:	89 f0                	mov    %esi,%eax
  802ff0:	89 da                	mov    %ebx,%edx
  802ff2:	83 c4 1c             	add    $0x1c,%esp
  802ff5:	5b                   	pop    %ebx
  802ff6:	5e                   	pop    %esi
  802ff7:	5f                   	pop    %edi
  802ff8:	5d                   	pop    %ebp
  802ff9:	c3                   	ret    
  802ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803000:	0f bd e8             	bsr    %eax,%ebp
  803003:	83 f5 1f             	xor    $0x1f,%ebp
  803006:	75 50                	jne    803058 <__umoddi3+0xa8>
  803008:	39 d8                	cmp    %ebx,%eax
  80300a:	0f 82 e0 00 00 00    	jb     8030f0 <__umoddi3+0x140>
  803010:	89 d9                	mov    %ebx,%ecx
  803012:	39 f7                	cmp    %esi,%edi
  803014:	0f 86 d6 00 00 00    	jbe    8030f0 <__umoddi3+0x140>
  80301a:	89 d0                	mov    %edx,%eax
  80301c:	89 ca                	mov    %ecx,%edx
  80301e:	83 c4 1c             	add    $0x1c,%esp
  803021:	5b                   	pop    %ebx
  803022:	5e                   	pop    %esi
  803023:	5f                   	pop    %edi
  803024:	5d                   	pop    %ebp
  803025:	c3                   	ret    
  803026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80302d:	8d 76 00             	lea    0x0(%esi),%esi
  803030:	89 fd                	mov    %edi,%ebp
  803032:	85 ff                	test   %edi,%edi
  803034:	75 0b                	jne    803041 <__umoddi3+0x91>
  803036:	b8 01 00 00 00       	mov    $0x1,%eax
  80303b:	31 d2                	xor    %edx,%edx
  80303d:	f7 f7                	div    %edi
  80303f:	89 c5                	mov    %eax,%ebp
  803041:	89 d8                	mov    %ebx,%eax
  803043:	31 d2                	xor    %edx,%edx
  803045:	f7 f5                	div    %ebp
  803047:	89 f0                	mov    %esi,%eax
  803049:	f7 f5                	div    %ebp
  80304b:	89 d0                	mov    %edx,%eax
  80304d:	31 d2                	xor    %edx,%edx
  80304f:	eb 8c                	jmp    802fdd <__umoddi3+0x2d>
  803051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803058:	89 e9                	mov    %ebp,%ecx
  80305a:	ba 20 00 00 00       	mov    $0x20,%edx
  80305f:	29 ea                	sub    %ebp,%edx
  803061:	d3 e0                	shl    %cl,%eax
  803063:	89 44 24 08          	mov    %eax,0x8(%esp)
  803067:	89 d1                	mov    %edx,%ecx
  803069:	89 f8                	mov    %edi,%eax
  80306b:	d3 e8                	shr    %cl,%eax
  80306d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803071:	89 54 24 04          	mov    %edx,0x4(%esp)
  803075:	8b 54 24 04          	mov    0x4(%esp),%edx
  803079:	09 c1                	or     %eax,%ecx
  80307b:	89 d8                	mov    %ebx,%eax
  80307d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803081:	89 e9                	mov    %ebp,%ecx
  803083:	d3 e7                	shl    %cl,%edi
  803085:	89 d1                	mov    %edx,%ecx
  803087:	d3 e8                	shr    %cl,%eax
  803089:	89 e9                	mov    %ebp,%ecx
  80308b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80308f:	d3 e3                	shl    %cl,%ebx
  803091:	89 c7                	mov    %eax,%edi
  803093:	89 d1                	mov    %edx,%ecx
  803095:	89 f0                	mov    %esi,%eax
  803097:	d3 e8                	shr    %cl,%eax
  803099:	89 e9                	mov    %ebp,%ecx
  80309b:	89 fa                	mov    %edi,%edx
  80309d:	d3 e6                	shl    %cl,%esi
  80309f:	09 d8                	or     %ebx,%eax
  8030a1:	f7 74 24 08          	divl   0x8(%esp)
  8030a5:	89 d1                	mov    %edx,%ecx
  8030a7:	89 f3                	mov    %esi,%ebx
  8030a9:	f7 64 24 0c          	mull   0xc(%esp)
  8030ad:	89 c6                	mov    %eax,%esi
  8030af:	89 d7                	mov    %edx,%edi
  8030b1:	39 d1                	cmp    %edx,%ecx
  8030b3:	72 06                	jb     8030bb <__umoddi3+0x10b>
  8030b5:	75 10                	jne    8030c7 <__umoddi3+0x117>
  8030b7:	39 c3                	cmp    %eax,%ebx
  8030b9:	73 0c                	jae    8030c7 <__umoddi3+0x117>
  8030bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8030bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8030c3:	89 d7                	mov    %edx,%edi
  8030c5:	89 c6                	mov    %eax,%esi
  8030c7:	89 ca                	mov    %ecx,%edx
  8030c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8030ce:	29 f3                	sub    %esi,%ebx
  8030d0:	19 fa                	sbb    %edi,%edx
  8030d2:	89 d0                	mov    %edx,%eax
  8030d4:	d3 e0                	shl    %cl,%eax
  8030d6:	89 e9                	mov    %ebp,%ecx
  8030d8:	d3 eb                	shr    %cl,%ebx
  8030da:	d3 ea                	shr    %cl,%edx
  8030dc:	09 d8                	or     %ebx,%eax
  8030de:	83 c4 1c             	add    $0x1c,%esp
  8030e1:	5b                   	pop    %ebx
  8030e2:	5e                   	pop    %esi
  8030e3:	5f                   	pop    %edi
  8030e4:	5d                   	pop    %ebp
  8030e5:	c3                   	ret    
  8030e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030ed:	8d 76 00             	lea    0x0(%esi),%esi
  8030f0:	29 fe                	sub    %edi,%esi
  8030f2:	19 c3                	sbb    %eax,%ebx
  8030f4:	89 f2                	mov    %esi,%edx
  8030f6:	89 d9                	mov    %ebx,%ecx
  8030f8:	e9 1d ff ff ff       	jmp    80301a <__umoddi3+0x6a>
