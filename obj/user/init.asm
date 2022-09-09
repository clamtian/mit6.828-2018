
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 8f 03 00 00       	call   8003c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  800042:	b9 00 00 00 00       	mov    $0x0,%ecx
	for (i = 0; i < n; i++)
  800047:	b8 00 00 00 00       	mov    $0x0,%eax
  80004c:	39 d8                	cmp    %ebx,%eax
  80004e:	7d 0e                	jge    80005e <sum+0x2b>
		tot ^= i * s[i];
  800050:	0f be 14 06          	movsbl (%esi,%eax,1),%edx
  800054:	0f af d0             	imul   %eax,%edx
  800057:	31 d1                	xor    %edx,%ecx
	for (i = 0; i < n; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	eb ee                	jmp    80004c <sum+0x19>
	return tot;
}
  80005e:	89 c8                	mov    %ecx,%eax
  800060:	5b                   	pop    %ebx
  800061:	5e                   	pop    %esi
  800062:	5d                   	pop    %ebp
  800063:	c3                   	ret    

00800064 <umain>:

void
umain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	57                   	push   %edi
  80006c:	56                   	push   %esi
  80006d:	53                   	push   %ebx
  80006e:	81 ec 18 01 00 00    	sub    $0x118,%esp
  800074:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  800077:	68 40 2c 80 00       	push   $0x802c40
  80007c:	e8 8e 04 00 00       	call   80050f <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800081:	83 c4 08             	add    $0x8,%esp
  800084:	68 70 17 00 00       	push   $0x1770
  800089:	68 00 40 80 00       	push   $0x804000
  80008e:	e8 a0 ff ff ff       	call   800033 <sum>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009b:	0f 84 99 00 00 00    	je     80013a <umain+0xd6>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	68 9e 98 0f 00       	push   $0xf989e
  8000a9:	50                   	push   %eax
  8000aa:	68 08 2d 80 00       	push   $0x802d08
  8000af:	e8 5b 04 00 00       	call   80050f <cprintf>
  8000b4:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000b7:	83 ec 08             	sub    $0x8,%esp
  8000ba:	68 70 17 00 00       	push   $0x1770
  8000bf:	68 20 60 80 00       	push   $0x806020
  8000c4:	e8 6a ff ff ff       	call   800033 <sum>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	74 7f                	je     80014f <umain+0xeb>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	50                   	push   %eax
  8000d4:	68 44 2d 80 00       	push   $0x802d44
  8000d9:	e8 31 04 00 00       	call   80050f <cprintf>
  8000de:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	68 7c 2c 80 00       	push   $0x802c7c
  8000e9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000ef:	50                   	push   %eax
  8000f0:	e8 4a 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000fd:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  800103:	39 fb                	cmp    %edi,%ebx
  800105:	7d 5a                	jge    800161 <umain+0xfd>
		strcat(args, " '");
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	68 88 2c 80 00       	push   $0x802c88
  80010f:	56                   	push   %esi
  800110:	e8 2a 0a 00 00       	call   800b3f <strcat>
		strcat(args, argv[i]);
  800115:	83 c4 08             	add    $0x8,%esp
  800118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011b:	ff 34 98             	pushl  (%eax,%ebx,4)
  80011e:	56                   	push   %esi
  80011f:	e8 1b 0a 00 00       	call   800b3f <strcat>
		strcat(args, "'");
  800124:	83 c4 08             	add    $0x8,%esp
  800127:	68 89 2c 80 00       	push   $0x802c89
  80012c:	56                   	push   %esi
  80012d:	e8 0d 0a 00 00       	call   800b3f <strcat>
	for (i = 0; i < argc; i++) {
  800132:	83 c3 01             	add    $0x1,%ebx
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	eb c9                	jmp    800103 <umain+0x9f>
		cprintf("init: data seems okay\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 4f 2c 80 00       	push   $0x802c4f
  800142:	e8 c8 03 00 00       	call   80050f <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	e9 68 ff ff ff       	jmp    8000b7 <umain+0x53>
		cprintf("init: bss seems okay\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 66 2c 80 00       	push   $0x802c66
  800157:	e8 b3 03 00 00       	call   80050f <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	eb 80                	jmp    8000e1 <umain+0x7d>
	}
	cprintf("%s\n", args);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	68 8b 2c 80 00       	push   $0x802c8b
  800170:	e8 9a 03 00 00       	call   80050f <cprintf>

	cprintf("init: running sh\n");
  800175:	c7 04 24 8f 2c 80 00 	movl   $0x802c8f,(%esp)
  80017c:	e8 8e 03 00 00       	call   80050f <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800188:	e8 c5 11 00 00       	call   801352 <close>
	if ((r = opencons()) < 0)
  80018d:	e8 d8 01 00 00       	call   80036a <opencons>
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	85 c0                	test   %eax,%eax
  800197:	78 14                	js     8001ad <umain+0x149>
		panic("opencons: %e", r);
	if (r != 0)
  800199:	74 24                	je     8001bf <umain+0x15b>
		panic("first opencons used fd %d", r);
  80019b:	50                   	push   %eax
  80019c:	68 ba 2c 80 00       	push   $0x802cba
  8001a1:	6a 39                	push   $0x39
  8001a3:	68 ae 2c 80 00       	push   $0x802cae
  8001a8:	e8 7b 02 00 00       	call   800428 <_panic>
		panic("opencons: %e", r);
  8001ad:	50                   	push   %eax
  8001ae:	68 a1 2c 80 00       	push   $0x802ca1
  8001b3:	6a 37                	push   $0x37
  8001b5:	68 ae 2c 80 00       	push   $0x802cae
  8001ba:	e8 69 02 00 00       	call   800428 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	6a 01                	push   $0x1
  8001c4:	6a 00                	push   $0x0
  8001c6:	e8 e1 11 00 00       	call   8013ac <dup>
  8001cb:	83 c4 10             	add    $0x10,%esp
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	79 23                	jns    8001f5 <umain+0x191>
		panic("dup: %e", r);
  8001d2:	50                   	push   %eax
  8001d3:	68 d4 2c 80 00       	push   $0x802cd4
  8001d8:	6a 3b                	push   $0x3b
  8001da:	68 ae 2c 80 00       	push   $0x802cae
  8001df:	e8 44 02 00 00       	call   800428 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	50                   	push   %eax
  8001e8:	68 f3 2c 80 00       	push   $0x802cf3
  8001ed:	e8 1d 03 00 00       	call   80050f <cprintf>
			continue;
  8001f2:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 dc 2c 80 00       	push   $0x802cdc
  8001fd:	e8 0d 03 00 00       	call   80050f <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800202:	83 c4 0c             	add    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	68 f0 2c 80 00       	push   $0x802cf0
  80020c:	68 ef 2c 80 00       	push   $0x802cef
  800211:	e8 44 1d 00 00       	call   801f5a <spawnl>
		if (r < 0) {
  800216:	83 c4 10             	add    $0x10,%esp
  800219:	85 c0                	test   %eax,%eax
  80021b:	78 c7                	js     8001e4 <umain+0x180>
		}
		wait(r);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	50                   	push   %eax
  800221:	e8 04 26 00 00       	call   80282a <wait>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb ca                	jmp    8001f5 <umain+0x191>

0080022b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80022b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80022f:	b8 00 00 00 00       	mov    $0x0,%eax
  800234:	c3                   	ret    

00800235 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800235:	f3 0f 1e fb          	endbr32 
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80023f:	68 73 2d 80 00       	push   $0x802d73
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	e8 cd 08 00 00       	call   800b19 <strcpy>
	return 0;
}
  80024c:	b8 00 00 00 00       	mov    $0x0,%eax
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <devcons_write>:
{
  800253:	f3 0f 1e fb          	endbr32 
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800263:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800268:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80026e:	3b 75 10             	cmp    0x10(%ebp),%esi
  800271:	73 31                	jae    8002a4 <devcons_write+0x51>
		m = n - tot;
  800273:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800276:	29 f3                	sub    %esi,%ebx
  800278:	83 fb 7f             	cmp    $0x7f,%ebx
  80027b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  800280:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	53                   	push   %ebx
  800287:	89 f0                	mov    %esi,%eax
  800289:	03 45 0c             	add    0xc(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	57                   	push   %edi
  80028e:	e8 3c 0a 00 00       	call   800ccf <memmove>
		sys_cputs(buf, m);
  800293:	83 c4 08             	add    $0x8,%esp
  800296:	53                   	push   %ebx
  800297:	57                   	push   %edi
  800298:	e8 ee 0b 00 00       	call   800e8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80029d:	01 de                	add    %ebx,%esi
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	eb ca                	jmp    80026e <devcons_write+0x1b>
}
  8002a4:	89 f0                	mov    %esi,%eax
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    

008002ae <devcons_read>:
{
  8002ae:	f3 0f 1e fb          	endbr32 
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8002bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002c1:	74 21                	je     8002e4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8002c3:	e8 e5 0b 00 00       	call   800ead <sys_cgetc>
  8002c8:	85 c0                	test   %eax,%eax
  8002ca:	75 07                	jne    8002d3 <devcons_read+0x25>
		sys_yield();
  8002cc:	e8 67 0c 00 00       	call   800f38 <sys_yield>
  8002d1:	eb f0                	jmp    8002c3 <devcons_read+0x15>
	if (c < 0)
  8002d3:	78 0f                	js     8002e4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8002d5:	83 f8 04             	cmp    $0x4,%eax
  8002d8:	74 0c                	je     8002e6 <devcons_read+0x38>
	*(char*)vbuf = c;
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	88 02                	mov    %al,(%edx)
	return 1;
  8002df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    
		return 0;
  8002e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002eb:	eb f7                	jmp    8002e4 <devcons_read+0x36>

008002ed <cputchar>:
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002fd:	6a 01                	push   $0x1
  8002ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	e8 83 0b 00 00       	call   800e8b <sys_cputs>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <getchar>:
{
  80030d:	f3 0f 1e fb          	endbr32 
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800317:	6a 01                	push   $0x1
  800319:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80031c:	50                   	push   %eax
  80031d:	6a 00                	push   $0x0
  80031f:	e8 78 11 00 00       	call   80149c <read>
	if (r < 0)
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	85 c0                	test   %eax,%eax
  800329:	78 06                	js     800331 <getchar+0x24>
	if (r < 1)
  80032b:	74 06                	je     800333 <getchar+0x26>
	return c;
  80032d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    
		return -E_EOF;
  800333:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800338:	eb f7                	jmp    800331 <getchar+0x24>

0080033a <iscons>:
{
  80033a:	f3 0f 1e fb          	endbr32 
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800344:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800347:	50                   	push   %eax
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 c4 0e 00 00       	call   801214 <fd_lookup>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	78 11                	js     800368 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	8b 15 70 57 80 00    	mov    0x805770,%edx
  800360:	39 10                	cmp    %edx,(%eax)
  800362:	0f 94 c0             	sete   %al
  800365:	0f b6 c0             	movzbl %al,%eax
}
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <opencons>:
{
  80036a:	f3 0f 1e fb          	endbr32 
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800374:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800377:	50                   	push   %eax
  800378:	e8 41 0e 00 00       	call   8011be <fd_alloc>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	85 c0                	test   %eax,%eax
  800382:	78 3a                	js     8003be <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800384:	83 ec 04             	sub    $0x4,%esp
  800387:	68 07 04 00 00       	push   $0x407
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	6a 00                	push   $0x0
  800391:	e8 c5 0b 00 00       	call   800f5b <sys_page_alloc>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 21                	js     8003be <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80039d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003a0:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003b2:	83 ec 0c             	sub    $0xc,%esp
  8003b5:	50                   	push   %eax
  8003b6:	e8 d4 0d 00 00       	call   80118f <fd2num>
  8003bb:	83 c4 10             	add    $0x10,%esp
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003c0:	f3 0f 1e fb          	endbr32 
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
  8003c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003cf:	e8 41 0b 00 00       	call   800f15 <sys_getenvid>
  8003d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e1:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003e6:	85 db                	test   %ebx,%ebx
  8003e8:	7e 07                	jle    8003f1 <libmain+0x31>
		binaryname = argv[0];
  8003ea:	8b 06                	mov    (%esi),%eax
  8003ec:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
  8003f6:	e8 69 fc ff ff       	call   800064 <umain>

	// exit gracefully
	exit();
  8003fb:	e8 0a 00 00 00       	call   80040a <exit>
}
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80040a:	f3 0f 1e fb          	endbr32 
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800414:	e8 6a 0f 00 00       	call   801383 <close_all>
	sys_env_destroy(0);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	6a 00                	push   $0x0
  80041e:	e8 ad 0a 00 00       	call   800ed0 <sys_env_destroy>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800428:	f3 0f 1e fb          	endbr32 
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800431:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800434:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  80043a:	e8 d6 0a 00 00       	call   800f15 <sys_getenvid>
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	ff 75 0c             	pushl  0xc(%ebp)
  800445:	ff 75 08             	pushl  0x8(%ebp)
  800448:	56                   	push   %esi
  800449:	50                   	push   %eax
  80044a:	68 8c 2d 80 00       	push   $0x802d8c
  80044f:	e8 bb 00 00 00       	call   80050f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800454:	83 c4 18             	add    $0x18,%esp
  800457:	53                   	push   %ebx
  800458:	ff 75 10             	pushl  0x10(%ebp)
  80045b:	e8 5a 00 00 00       	call   8004ba <vcprintf>
	cprintf("\n");
  800460:	c7 04 24 9b 32 80 00 	movl   $0x80329b,(%esp)
  800467:	e8 a3 00 00 00       	call   80050f <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80046f:	cc                   	int3   
  800470:	eb fd                	jmp    80046f <_panic+0x47>

00800472 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800472:	f3 0f 1e fb          	endbr32 
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	53                   	push   %ebx
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800480:	8b 13                	mov    (%ebx),%edx
  800482:	8d 42 01             	lea    0x1(%edx),%eax
  800485:	89 03                	mov    %eax,(%ebx)
  800487:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80048a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80048e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800493:	74 09                	je     80049e <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800495:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	68 ff 00 00 00       	push   $0xff
  8004a6:	8d 43 08             	lea    0x8(%ebx),%eax
  8004a9:	50                   	push   %eax
  8004aa:	e8 dc 09 00 00       	call   800e8b <sys_cputs>
		b->idx = 0;
  8004af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb db                	jmp    800495 <putch+0x23>

008004ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004ba:	f3 0f 1e fb          	endbr32 
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ce:	00 00 00 
	b.cnt = 0;
  8004d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	ff 75 08             	pushl  0x8(%ebp)
  8004e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e7:	50                   	push   %eax
  8004e8:	68 72 04 80 00       	push   $0x800472
  8004ed:	e8 20 01 00 00       	call   800612 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004f2:	83 c4 08             	add    $0x8,%esp
  8004f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8004fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800501:	50                   	push   %eax
  800502:	e8 84 09 00 00       	call   800e8b <sys_cputs>

	return b.cnt;
}
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050f:	f3 0f 1e fb          	endbr32 
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800519:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80051c:	50                   	push   %eax
  80051d:	ff 75 08             	pushl  0x8(%ebp)
  800520:	e8 95 ff ff ff       	call   8004ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	57                   	push   %edi
  80052b:	56                   	push   %esi
  80052c:	53                   	push   %ebx
  80052d:	83 ec 1c             	sub    $0x1c,%esp
  800530:	89 c7                	mov    %eax,%edi
  800532:	89 d6                	mov    %edx,%esi
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053a:	89 d1                	mov    %edx,%ecx
  80053c:	89 c2                	mov    %eax,%edx
  80053e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	8b 45 10             	mov    0x10(%ebp),%eax
  800547:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80054a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800554:	39 c2                	cmp    %eax,%edx
  800556:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800559:	72 3e                	jb     800599 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	ff 75 18             	pushl  0x18(%ebp)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	53                   	push   %ebx
  800565:	50                   	push   %eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	ff 75 e0             	pushl  -0x20(%ebp)
  80056f:	ff 75 dc             	pushl  -0x24(%ebp)
  800572:	ff 75 d8             	pushl  -0x28(%ebp)
  800575:	e8 56 24 00 00       	call   8029d0 <__udivdi3>
  80057a:	83 c4 18             	add    $0x18,%esp
  80057d:	52                   	push   %edx
  80057e:	50                   	push   %eax
  80057f:	89 f2                	mov    %esi,%edx
  800581:	89 f8                	mov    %edi,%eax
  800583:	e8 9f ff ff ff       	call   800527 <printnum>
  800588:	83 c4 20             	add    $0x20,%esp
  80058b:	eb 13                	jmp    8005a0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	56                   	push   %esi
  800591:	ff 75 18             	pushl  0x18(%ebp)
  800594:	ff d7                	call   *%edi
  800596:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800599:	83 eb 01             	sub    $0x1,%ebx
  80059c:	85 db                	test   %ebx,%ebx
  80059e:	7f ed                	jg     80058d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	56                   	push   %esi
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8005b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b3:	e8 28 25 00 00       	call   802ae0 <__umoddi3>
  8005b8:	83 c4 14             	add    $0x14,%esp
  8005bb:	0f be 80 af 2d 80 00 	movsbl 0x802daf(%eax),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff d7                	call   *%edi
}
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005cb:	5b                   	pop    %ebx
  8005cc:	5e                   	pop    %esi
  8005cd:	5f                   	pop    %edi
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005d0:	f3 0f 1e fb          	endbr32 
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005de:	8b 10                	mov    (%eax),%edx
  8005e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e3:	73 0a                	jae    8005ef <sprintputch+0x1f>
		*b->buf++ = ch;
  8005e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005e8:	89 08                	mov    %ecx,(%eax)
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	88 02                	mov    %al,(%edx)
}
  8005ef:	5d                   	pop    %ebp
  8005f0:	c3                   	ret    

008005f1 <printfmt>:
{
  8005f1:	f3 0f 1e fb          	endbr32 
  8005f5:	55                   	push   %ebp
  8005f6:	89 e5                	mov    %esp,%ebp
  8005f8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005fe:	50                   	push   %eax
  8005ff:	ff 75 10             	pushl  0x10(%ebp)
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 05 00 00 00       	call   800612 <vprintfmt>
}
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <vprintfmt>:
{
  800612:	f3 0f 1e fb          	endbr32 
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	57                   	push   %edi
  80061a:	56                   	push   %esi
  80061b:	53                   	push   %ebx
  80061c:	83 ec 3c             	sub    $0x3c,%esp
  80061f:	8b 75 08             	mov    0x8(%ebp),%esi
  800622:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800625:	8b 7d 10             	mov    0x10(%ebp),%edi
  800628:	e9 8e 03 00 00       	jmp    8009bb <vprintfmt+0x3a9>
		padc = ' ';
  80062d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800631:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800638:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80063f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800646:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8d 47 01             	lea    0x1(%edi),%eax
  80064e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800651:	0f b6 17             	movzbl (%edi),%edx
  800654:	8d 42 dd             	lea    -0x23(%edx),%eax
  800657:	3c 55                	cmp    $0x55,%al
  800659:	0f 87 df 03 00 00    	ja     800a3e <vprintfmt+0x42c>
  80065f:	0f b6 c0             	movzbl %al,%eax
  800662:	3e ff 24 85 00 2f 80 	notrack jmp *0x802f00(,%eax,4)
  800669:	00 
  80066a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80066d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800671:	eb d8                	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800673:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800676:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80067a:	eb cf                	jmp    80064b <vprintfmt+0x39>
  80067c:	0f b6 d2             	movzbl %dl,%edx
  80067f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800682:	b8 00 00 00 00       	mov    $0x0,%eax
  800687:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80068a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80068d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800691:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800694:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800697:	83 f9 09             	cmp    $0x9,%ecx
  80069a:	77 55                	ja     8006f1 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80069c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80069f:	eb e9                	jmp    80068a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b9:	79 90                	jns    80064b <vprintfmt+0x39>
				width = precision, precision = -1;
  8006bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006c1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8006c8:	eb 81                	jmp    80064b <vprintfmt+0x39>
  8006ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	0f 49 d0             	cmovns %eax,%edx
  8006d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006dd:	e9 69 ff ff ff       	jmp    80064b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8006e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8006ec:	e9 5a ff ff ff       	jmp    80064b <vprintfmt+0x39>
  8006f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f7:	eb bc                	jmp    8006b5 <vprintfmt+0xa3>
			lflag++;
  8006f9:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006ff:	e9 47 ff ff ff       	jmp    80064b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 78 04             	lea    0x4(%eax),%edi
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	53                   	push   %ebx
  80070e:	ff 30                	pushl  (%eax)
  800710:	ff d6                	call   *%esi
			break;
  800712:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800715:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800718:	e9 9b 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 78 04             	lea    0x4(%eax),%edi
  800723:	8b 00                	mov    (%eax),%eax
  800725:	99                   	cltd   
  800726:	31 d0                	xor    %edx,%eax
  800728:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072a:	83 f8 0f             	cmp    $0xf,%eax
  80072d:	7f 23                	jg     800752 <vprintfmt+0x140>
  80072f:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  800736:	85 d2                	test   %edx,%edx
  800738:	74 18                	je     800752 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80073a:	52                   	push   %edx
  80073b:	68 95 31 80 00       	push   $0x803195
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 aa fe ff ff       	call   8005f1 <printfmt>
  800747:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80074a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80074d:	e9 66 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800752:	50                   	push   %eax
  800753:	68 c7 2d 80 00       	push   $0x802dc7
  800758:	53                   	push   %ebx
  800759:	56                   	push   %esi
  80075a:	e8 92 fe ff ff       	call   8005f1 <printfmt>
  80075f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800762:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800765:	e9 4e 02 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 c0 04             	add    $0x4,%eax
  800770:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800778:	85 d2                	test   %edx,%edx
  80077a:	b8 c0 2d 80 00       	mov    $0x802dc0,%eax
  80077f:	0f 45 c2             	cmovne %edx,%eax
  800782:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	7e 06                	jle    800791 <vprintfmt+0x17f>
  80078b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80078f:	75 0d                	jne    80079e <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800791:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800794:	89 c7                	mov    %eax,%edi
  800796:	03 45 e0             	add    -0x20(%ebp),%eax
  800799:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079c:	eb 55                	jmp    8007f3 <vprintfmt+0x1e1>
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a4:	ff 75 cc             	pushl  -0x34(%ebp)
  8007a7:	e8 46 03 00 00       	call   800af2 <strnlen>
  8007ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007af:	29 c2                	sub    %eax,%edx
  8007b1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8007b9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8007bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c0:	85 ff                	test   %edi,%edi
  8007c2:	7e 11                	jle    8007d5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	83 ef 01             	sub    $0x1,%edi
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb eb                	jmp    8007c0 <vprintfmt+0x1ae>
  8007d5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007d8:	85 d2                	test   %edx,%edx
  8007da:	b8 00 00 00 00       	mov    $0x0,%eax
  8007df:	0f 49 c2             	cmovns %edx,%eax
  8007e2:	29 c2                	sub    %eax,%edx
  8007e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007e7:	eb a8                	jmp    800791 <vprintfmt+0x17f>
					putch(ch, putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	53                   	push   %ebx
  8007ed:	52                   	push   %edx
  8007ee:	ff d6                	call   *%esi
  8007f0:	83 c4 10             	add    $0x10,%esp
  8007f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007f6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f8:	83 c7 01             	add    $0x1,%edi
  8007fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ff:	0f be d0             	movsbl %al,%edx
  800802:	85 d2                	test   %edx,%edx
  800804:	74 4b                	je     800851 <vprintfmt+0x23f>
  800806:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80080a:	78 06                	js     800812 <vprintfmt+0x200>
  80080c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800810:	78 1e                	js     800830 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800812:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800816:	74 d1                	je     8007e9 <vprintfmt+0x1d7>
  800818:	0f be c0             	movsbl %al,%eax
  80081b:	83 e8 20             	sub    $0x20,%eax
  80081e:	83 f8 5e             	cmp    $0x5e,%eax
  800821:	76 c6                	jbe    8007e9 <vprintfmt+0x1d7>
					putch('?', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	6a 3f                	push   $0x3f
  800829:	ff d6                	call   *%esi
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	eb c3                	jmp    8007f3 <vprintfmt+0x1e1>
  800830:	89 cf                	mov    %ecx,%edi
  800832:	eb 0e                	jmp    800842 <vprintfmt+0x230>
				putch(' ', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 20                	push   $0x20
  80083a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80083c:	83 ef 01             	sub    $0x1,%edi
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	85 ff                	test   %edi,%edi
  800844:	7f ee                	jg     800834 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800846:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	e9 67 01 00 00       	jmp    8009b8 <vprintfmt+0x3a6>
  800851:	89 cf                	mov    %ecx,%edi
  800853:	eb ed                	jmp    800842 <vprintfmt+0x230>
	if (lflag >= 2)
  800855:	83 f9 01             	cmp    $0x1,%ecx
  800858:	7f 1b                	jg     800875 <vprintfmt+0x263>
	else if (lflag)
  80085a:	85 c9                	test   %ecx,%ecx
  80085c:	74 63                	je     8008c1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800866:	99                   	cltd   
  800867:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8d 40 04             	lea    0x4(%eax),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	eb 17                	jmp    80088c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 50 04             	mov    0x4(%eax),%edx
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 08             	lea    0x8(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80088c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80088f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800892:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800897:	85 c9                	test   %ecx,%ecx
  800899:	0f 89 ff 00 00 00    	jns    80099e <vprintfmt+0x38c>
				putch('-', putdat);
  80089f:	83 ec 08             	sub    $0x8,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	6a 2d                	push   $0x2d
  8008a5:	ff d6                	call   *%esi
				num = -(long long) num;
  8008a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008ad:	f7 da                	neg    %edx
  8008af:	83 d1 00             	adc    $0x0,%ecx
  8008b2:	f7 d9                	neg    %ecx
  8008b4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bc:	e9 dd 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c9:	99                   	cltd   
  8008ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	8d 40 04             	lea    0x4(%eax),%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	eb b4                	jmp    80088c <vprintfmt+0x27a>
	if (lflag >= 2)
  8008d8:	83 f9 01             	cmp    $0x1,%ecx
  8008db:	7f 1e                	jg     8008fb <vprintfmt+0x2e9>
	else if (lflag)
  8008dd:	85 c9                	test   %ecx,%ecx
  8008df:	74 32                	je     800913 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8008e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e4:	8b 10                	mov    (%eax),%edx
  8008e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008eb:	8d 40 04             	lea    0x4(%eax),%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8008f1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8008f6:	e9 a3 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8008fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	8b 48 04             	mov    0x4(%eax),%ecx
  800903:	8d 40 08             	lea    0x8(%eax),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800909:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80090e:	e9 8b 00 00 00       	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	8b 10                	mov    (%eax),%edx
  800918:	b9 00 00 00 00       	mov    $0x0,%ecx
  80091d:	8d 40 04             	lea    0x4(%eax),%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800923:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800928:	eb 74                	jmp    80099e <vprintfmt+0x38c>
	if (lflag >= 2)
  80092a:	83 f9 01             	cmp    $0x1,%ecx
  80092d:	7f 1b                	jg     80094a <vprintfmt+0x338>
	else if (lflag)
  80092f:	85 c9                	test   %ecx,%ecx
  800931:	74 2c                	je     80095f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800933:	8b 45 14             	mov    0x14(%ebp),%eax
  800936:	8b 10                	mov    (%eax),%edx
  800938:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093d:	8d 40 04             	lea    0x4(%eax),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800943:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800948:	eb 54                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	8b 10                	mov    (%eax),%edx
  80094f:	8b 48 04             	mov    0x4(%eax),%ecx
  800952:	8d 40 08             	lea    0x8(%eax),%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800958:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80095d:	eb 3f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80095f:	8b 45 14             	mov    0x14(%ebp),%eax
  800962:	8b 10                	mov    (%eax),%edx
  800964:	b9 00 00 00 00       	mov    $0x0,%ecx
  800969:	8d 40 04             	lea    0x4(%eax),%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80096f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800974:	eb 28                	jmp    80099e <vprintfmt+0x38c>
			putch('0', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	53                   	push   %ebx
  80097a:	6a 30                	push   $0x30
  80097c:	ff d6                	call   *%esi
			putch('x', putdat);
  80097e:	83 c4 08             	add    $0x8,%esp
  800981:	53                   	push   %ebx
  800982:	6a 78                	push   $0x78
  800984:	ff d6                	call   *%esi
			num = (unsigned long long)
  800986:	8b 45 14             	mov    0x14(%ebp),%eax
  800989:	8b 10                	mov    (%eax),%edx
  80098b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800990:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800993:	8d 40 04             	lea    0x4(%eax),%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800999:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8009a5:	57                   	push   %edi
  8009a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009a9:	50                   	push   %eax
  8009aa:	51                   	push   %ecx
  8009ab:	52                   	push   %edx
  8009ac:	89 da                	mov    %ebx,%edx
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	e8 72 fb ff ff       	call   800527 <printnum>
			break;
  8009b5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8009b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bb:	83 c7 01             	add    $0x1,%edi
  8009be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009c2:	83 f8 25             	cmp    $0x25,%eax
  8009c5:	0f 84 62 fc ff ff    	je     80062d <vprintfmt+0x1b>
			if (ch == '\0')
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	0f 84 8b 00 00 00    	je     800a5e <vprintfmt+0x44c>
			putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	50                   	push   %eax
  8009d8:	ff d6                	call   *%esi
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb dc                	jmp    8009bb <vprintfmt+0x3a9>
	if (lflag >= 2)
  8009df:	83 f9 01             	cmp    $0x1,%ecx
  8009e2:	7f 1b                	jg     8009ff <vprintfmt+0x3ed>
	else if (lflag)
  8009e4:	85 c9                	test   %ecx,%ecx
  8009e6:	74 2c                	je     800a14 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8009e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009eb:	8b 10                	mov    (%eax),%edx
  8009ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f2:	8d 40 04             	lea    0x4(%eax),%eax
  8009f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009f8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8009fd:	eb 9f                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	8b 48 04             	mov    0x4(%eax),%ecx
  800a07:	8d 40 08             	lea    0x8(%eax),%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a0d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800a12:	eb 8a                	jmp    80099e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a14:	8b 45 14             	mov    0x14(%ebp),%eax
  800a17:	8b 10                	mov    (%eax),%edx
  800a19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a1e:	8d 40 04             	lea    0x4(%eax),%eax
  800a21:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a24:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800a29:	e9 70 ff ff ff       	jmp    80099e <vprintfmt+0x38c>
			putch(ch, putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	53                   	push   %ebx
  800a32:	6a 25                	push   $0x25
  800a34:	ff d6                	call   *%esi
			break;
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	e9 7a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
			putch('%', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	53                   	push   %ebx
  800a42:	6a 25                	push   $0x25
  800a44:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a46:	83 c4 10             	add    $0x10,%esp
  800a49:	89 f8                	mov    %edi,%eax
  800a4b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a4f:	74 05                	je     800a56 <vprintfmt+0x444>
  800a51:	83 e8 01             	sub    $0x1,%eax
  800a54:	eb f5                	jmp    800a4b <vprintfmt+0x439>
  800a56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a59:	e9 5a ff ff ff       	jmp    8009b8 <vprintfmt+0x3a6>
}
  800a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a61:	5b                   	pop    %ebx
  800a62:	5e                   	pop    %esi
  800a63:	5f                   	pop    %edi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a66:	f3 0f 1e fb          	endbr32 
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 18             	sub    $0x18,%esp
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a79:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a7d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a87:	85 c0                	test   %eax,%eax
  800a89:	74 26                	je     800ab1 <vsnprintf+0x4b>
  800a8b:	85 d2                	test   %edx,%edx
  800a8d:	7e 22                	jle    800ab1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8f:	ff 75 14             	pushl  0x14(%ebp)
  800a92:	ff 75 10             	pushl  0x10(%ebp)
  800a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 d0 05 80 00       	push   $0x8005d0
  800a9e:	e8 6f fb ff ff       	call   800612 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aac:	83 c4 10             	add    $0x10,%esp
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    
		return -E_INVAL;
  800ab1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ab6:	eb f7                	jmp    800aaf <vsnprintf+0x49>

00800ab8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab8:	f3 0f 1e fb          	endbr32 
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ac2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 10             	pushl  0x10(%ebp)
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	ff 75 08             	pushl  0x8(%ebp)
  800acf:	e8 92 ff ff ff       	call   800a66 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae5:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ae9:	74 05                	je     800af0 <strlen+0x1a>
		n++;
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	eb f5                	jmp    800ae5 <strlen+0xf>
	return n;
}
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800af2:	f3 0f 1e fb          	endbr32 
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aff:	b8 00 00 00 00       	mov    $0x0,%eax
  800b04:	39 d0                	cmp    %edx,%eax
  800b06:	74 0d                	je     800b15 <strnlen+0x23>
  800b08:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b0c:	74 05                	je     800b13 <strnlen+0x21>
		n++;
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	eb f1                	jmp    800b04 <strnlen+0x12>
  800b13:	89 c2                	mov    %eax,%edx
	return n;
}
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	5d                   	pop    %ebp
  800b18:	c3                   	ret    

00800b19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b19:	f3 0f 1e fb          	endbr32 
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800b30:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	84 d2                	test   %dl,%dl
  800b38:	75 f2                	jne    800b2c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800b3a:	89 c8                	mov    %ecx,%eax
  800b3c:	5b                   	pop    %ebx
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b3f:	f3 0f 1e fb          	endbr32 
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	53                   	push   %ebx
  800b47:	83 ec 10             	sub    $0x10,%esp
  800b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b4d:	53                   	push   %ebx
  800b4e:	e8 83 ff ff ff       	call   800ad6 <strlen>
  800b53:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	01 d8                	add    %ebx,%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 b8 ff ff ff       	call   800b19 <strcpy>
	return dst;
}
  800b61:	89 d8                	mov    %ebx,%eax
  800b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b66:	c9                   	leave  
  800b67:	c3                   	ret    

00800b68 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 75 08             	mov    0x8(%ebp),%esi
  800b74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b77:	89 f3                	mov    %esi,%ebx
  800b79:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	39 d8                	cmp    %ebx,%eax
  800b80:	74 11                	je     800b93 <strncpy+0x2b>
		*dst++ = *src;
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b8b:	80 f9 01             	cmp    $0x1,%cl
  800b8e:	83 da ff             	sbb    $0xffffffff,%edx
  800b91:	eb eb                	jmp    800b7e <strncpy+0x16>
	}
	return ret;
}
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b99:	f3 0f 1e fb          	endbr32 
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	8b 55 10             	mov    0x10(%ebp),%edx
  800bab:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bad:	85 d2                	test   %edx,%edx
  800baf:	74 21                	je     800bd2 <strlcpy+0x39>
  800bb1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800bb5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	74 14                	je     800bcf <strlcpy+0x36>
  800bbb:	0f b6 19             	movzbl (%ecx),%ebx
  800bbe:	84 db                	test   %bl,%bl
  800bc0:	74 0b                	je     800bcd <strlcpy+0x34>
			*dst++ = *src++;
  800bc2:	83 c1 01             	add    $0x1,%ecx
  800bc5:	83 c2 01             	add    $0x1,%edx
  800bc8:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bcb:	eb ea                	jmp    800bb7 <strlcpy+0x1e>
  800bcd:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800bcf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bd2:	29 f0                	sub    %esi,%eax
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd8:	f3 0f 1e fb          	endbr32 
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be5:	0f b6 01             	movzbl (%ecx),%eax
  800be8:	84 c0                	test   %al,%al
  800bea:	74 0c                	je     800bf8 <strcmp+0x20>
  800bec:	3a 02                	cmp    (%edx),%al
  800bee:	75 08                	jne    800bf8 <strcmp+0x20>
		p++, q++;
  800bf0:	83 c1 01             	add    $0x1,%ecx
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	eb ed                	jmp    800be5 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 c0             	movzbl %al,%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
}
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c02:	f3 0f 1e fb          	endbr32 
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	53                   	push   %ebx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	89 c3                	mov    %eax,%ebx
  800c12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c15:	eb 06                	jmp    800c1d <strncmp+0x1b>
		n--, p++, q++;
  800c17:	83 c0 01             	add    $0x1,%eax
  800c1a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800c1d:	39 d8                	cmp    %ebx,%eax
  800c1f:	74 16                	je     800c37 <strncmp+0x35>
  800c21:	0f b6 08             	movzbl (%eax),%ecx
  800c24:	84 c9                	test   %cl,%cl
  800c26:	74 04                	je     800c2c <strncmp+0x2a>
  800c28:	3a 0a                	cmp    (%edx),%cl
  800c2a:	74 eb                	je     800c17 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c2c:	0f b6 00             	movzbl (%eax),%eax
  800c2f:	0f b6 12             	movzbl (%edx),%edx
  800c32:	29 d0                	sub    %edx,%eax
}
  800c34:	5b                   	pop    %ebx
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    
		return 0;
  800c37:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3c:	eb f6                	jmp    800c34 <strncmp+0x32>

00800c3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c3e:	f3 0f 1e fb          	endbr32 
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c4c:	0f b6 10             	movzbl (%eax),%edx
  800c4f:	84 d2                	test   %dl,%dl
  800c51:	74 09                	je     800c5c <strchr+0x1e>
		if (*s == c)
  800c53:	38 ca                	cmp    %cl,%dl
  800c55:	74 0a                	je     800c61 <strchr+0x23>
	for (; *s; s++)
  800c57:	83 c0 01             	add    $0x1,%eax
  800c5a:	eb f0                	jmp    800c4c <strchr+0xe>
			return (char *) s;
	return 0;
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c71:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c74:	38 ca                	cmp    %cl,%dl
  800c76:	74 09                	je     800c81 <strfind+0x1e>
  800c78:	84 d2                	test   %dl,%dl
  800c7a:	74 05                	je     800c81 <strfind+0x1e>
	for (; *s; s++)
  800c7c:	83 c0 01             	add    $0x1,%eax
  800c7f:	eb f0                	jmp    800c71 <strfind+0xe>
			break;
	return (char *) s;
}
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c93:	85 c9                	test   %ecx,%ecx
  800c95:	74 31                	je     800cc8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c97:	89 f8                	mov    %edi,%eax
  800c99:	09 c8                	or     %ecx,%eax
  800c9b:	a8 03                	test   $0x3,%al
  800c9d:	75 23                	jne    800cc2 <memset+0x3f>
		c &= 0xFF;
  800c9f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	c1 e3 08             	shl    $0x8,%ebx
  800ca8:	89 d0                	mov    %edx,%eax
  800caa:	c1 e0 18             	shl    $0x18,%eax
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	c1 e6 10             	shl    $0x10,%esi
  800cb2:	09 f0                	or     %esi,%eax
  800cb4:	09 c2                	or     %eax,%edx
  800cb6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cb8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	fc                   	cld    
  800cbe:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc0:	eb 06                	jmp    800cc8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc5:	fc                   	cld    
  800cc6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cc8:	89 f8                	mov    %edi,%eax
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cde:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce1:	39 c6                	cmp    %eax,%esi
  800ce3:	73 32                	jae    800d17 <memmove+0x48>
  800ce5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce8:	39 c2                	cmp    %eax,%edx
  800cea:	76 2b                	jbe    800d17 <memmove+0x48>
		s += n;
		d += n;
  800cec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cef:	89 fe                	mov    %edi,%esi
  800cf1:	09 ce                	or     %ecx,%esi
  800cf3:	09 d6                	or     %edx,%esi
  800cf5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfb:	75 0e                	jne    800d0b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cfd:	83 ef 04             	sub    $0x4,%edi
  800d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800d06:	fd                   	std    
  800d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d09:	eb 09                	jmp    800d14 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0b:	83 ef 01             	sub    $0x1,%edi
  800d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800d11:	fd                   	std    
  800d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d14:	fc                   	cld    
  800d15:	eb 1a                	jmp    800d31 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d17:	89 c2                	mov    %eax,%edx
  800d19:	09 ca                	or     %ecx,%edx
  800d1b:	09 f2                	or     %esi,%edx
  800d1d:	f6 c2 03             	test   $0x3,%dl
  800d20:	75 0a                	jne    800d2c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	fc                   	cld    
  800d28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d2a:	eb 05                	jmp    800d31 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800d2c:	89 c7                	mov    %eax,%edi
  800d2e:	fc                   	cld    
  800d2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d3f:	ff 75 10             	pushl  0x10(%ebp)
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 82 ff ff ff       	call   800ccf <memmove>
}
  800d4d:	c9                   	leave  
  800d4e:	c3                   	ret    

00800d4f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d4f:	f3 0f 1e fb          	endbr32 
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5e:	89 c6                	mov    %eax,%esi
  800d60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d63:	39 f0                	cmp    %esi,%eax
  800d65:	74 1c                	je     800d83 <memcmp+0x34>
		if (*s1 != *s2)
  800d67:	0f b6 08             	movzbl (%eax),%ecx
  800d6a:	0f b6 1a             	movzbl (%edx),%ebx
  800d6d:	38 d9                	cmp    %bl,%cl
  800d6f:	75 08                	jne    800d79 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d71:	83 c0 01             	add    $0x1,%eax
  800d74:	83 c2 01             	add    $0x1,%edx
  800d77:	eb ea                	jmp    800d63 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800d79:	0f b6 c1             	movzbl %cl,%eax
  800d7c:	0f b6 db             	movzbl %bl,%ebx
  800d7f:	29 d8                	sub    %ebx,%eax
  800d81:	eb 05                	jmp    800d88 <memcmp+0x39>
	}

	return 0;
  800d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d8c:	f3 0f 1e fb          	endbr32 
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d99:	89 c2                	mov    %eax,%edx
  800d9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d9e:	39 d0                	cmp    %edx,%eax
  800da0:	73 09                	jae    800dab <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da2:	38 08                	cmp    %cl,(%eax)
  800da4:	74 05                	je     800dab <memfind+0x1f>
	for (; s < ends; s++)
  800da6:	83 c0 01             	add    $0x1,%eax
  800da9:	eb f3                	jmp    800d9e <memfind+0x12>
			break;
	return (void *) s;
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dad:	f3 0f 1e fb          	endbr32 
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dbd:	eb 03                	jmp    800dc2 <strtol+0x15>
		s++;
  800dbf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800dc2:	0f b6 01             	movzbl (%ecx),%eax
  800dc5:	3c 20                	cmp    $0x20,%al
  800dc7:	74 f6                	je     800dbf <strtol+0x12>
  800dc9:	3c 09                	cmp    $0x9,%al
  800dcb:	74 f2                	je     800dbf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800dcd:	3c 2b                	cmp    $0x2b,%al
  800dcf:	74 2a                	je     800dfb <strtol+0x4e>
	int neg = 0;
  800dd1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800dd6:	3c 2d                	cmp    $0x2d,%al
  800dd8:	74 2b                	je     800e05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dda:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800de0:	75 0f                	jne    800df1 <strtol+0x44>
  800de2:	80 39 30             	cmpb   $0x30,(%ecx)
  800de5:	74 28                	je     800e0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800de7:	85 db                	test   %ebx,%ebx
  800de9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dee:	0f 44 d8             	cmove  %eax,%ebx
  800df1:	b8 00 00 00 00       	mov    $0x0,%eax
  800df6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800df9:	eb 46                	jmp    800e41 <strtol+0x94>
		s++;
  800dfb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800dfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800e03:	eb d5                	jmp    800dda <strtol+0x2d>
		s++, neg = 1;
  800e05:	83 c1 01             	add    $0x1,%ecx
  800e08:	bf 01 00 00 00       	mov    $0x1,%edi
  800e0d:	eb cb                	jmp    800dda <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800e13:	74 0e                	je     800e23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800e15:	85 db                	test   %ebx,%ebx
  800e17:	75 d8                	jne    800df1 <strtol+0x44>
		s++, base = 8;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800e21:	eb ce                	jmp    800df1 <strtol+0x44>
		s += 2, base = 16;
  800e23:	83 c1 02             	add    $0x2,%ecx
  800e26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800e2b:	eb c4                	jmp    800df1 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800e2d:	0f be d2             	movsbl %dl,%edx
  800e30:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800e33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800e36:	7d 3a                	jge    800e72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800e38:	83 c1 01             	add    $0x1,%ecx
  800e3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800e41:	0f b6 11             	movzbl (%ecx),%edx
  800e44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800e47:	89 f3                	mov    %esi,%ebx
  800e49:	80 fb 09             	cmp    $0x9,%bl
  800e4c:	76 df                	jbe    800e2d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800e4e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e51:	89 f3                	mov    %esi,%ebx
  800e53:	80 fb 19             	cmp    $0x19,%bl
  800e56:	77 08                	ja     800e60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e58:	0f be d2             	movsbl %dl,%edx
  800e5b:	83 ea 57             	sub    $0x57,%edx
  800e5e:	eb d3                	jmp    800e33 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800e60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e63:	89 f3                	mov    %esi,%ebx
  800e65:	80 fb 19             	cmp    $0x19,%bl
  800e68:	77 08                	ja     800e72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e6a:	0f be d2             	movsbl %dl,%edx
  800e6d:	83 ea 37             	sub    $0x37,%edx
  800e70:	eb c1                	jmp    800e33 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e76:	74 05                	je     800e7d <strtol+0xd0>
		*endptr = (char *) s;
  800e78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e7d:	89 c2                	mov    %eax,%edx
  800e7f:	f7 da                	neg    %edx
  800e81:	85 ff                	test   %edi,%edi
  800e83:	0f 45 c2             	cmovne %edx,%eax
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e8b:	f3 0f 1e fb          	endbr32 
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e95:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	89 c3                	mov    %eax,%ebx
  800ea2:	89 c7                	mov    %eax,%edi
  800ea4:	89 c6                	mov    %eax,%esi
  800ea6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_cgetc>:

int
sys_cgetc(void)
{
  800ead:	f3 0f 1e fb          	endbr32 
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec1:	89 d1                	mov    %edx,%ecx
  800ec3:	89 d3                	mov    %edx,%ebx
  800ec5:	89 d7                	mov    %edx,%edi
  800ec7:	89 d6                	mov    %edx,%esi
  800ec9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ed0:	f3 0f 1e fb          	endbr32 
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	b8 03 00 00 00       	mov    $0x3,%eax
  800eea:	89 cb                	mov    %ecx,%ebx
  800eec:	89 cf                	mov    %ecx,%edi
  800eee:	89 ce                	mov    %ecx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 03                	push   $0x3
  800f04:	68 bf 30 80 00       	push   $0x8030bf
  800f09:	6a 23                	push   $0x23
  800f0b:	68 dc 30 80 00       	push   $0x8030dc
  800f10:	e8 13 f5 ff ff       	call   800428 <_panic>

00800f15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f15:	f3 0f 1e fb          	endbr32 
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f24:	b8 02 00 00 00       	mov    $0x2,%eax
  800f29:	89 d1                	mov    %edx,%ecx
  800f2b:	89 d3                	mov    %edx,%ebx
  800f2d:	89 d7                	mov    %edx,%edi
  800f2f:	89 d6                	mov    %edx,%esi
  800f31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f33:	5b                   	pop    %ebx
  800f34:	5e                   	pop    %esi
  800f35:	5f                   	pop    %edi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_yield>:

void
sys_yield(void)
{
  800f38:	f3 0f 1e fb          	endbr32 
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f4c:	89 d1                	mov    %edx,%ecx
  800f4e:	89 d3                	mov    %edx,%ebx
  800f50:	89 d7                	mov    %edx,%edi
  800f52:	89 d6                	mov    %edx,%esi
  800f54:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f68:	be 00 00 00 00       	mov    $0x0,%esi
  800f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	b8 04 00 00 00       	mov    $0x4,%eax
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7b:	89 f7                	mov    %esi,%edi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 04                	push   $0x4
  800f91:	68 bf 30 80 00       	push   $0x8030bf
  800f96:	6a 23                	push   $0x23
  800f98:	68 dc 30 80 00       	push   $0x8030dc
  800f9d:	e8 86 f4 ff ff       	call   800428 <_panic>

00800fa2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa2:	f3 0f 1e fb          	endbr32 
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	b8 05 00 00 00       	mov    $0x5,%eax
  800fba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc0:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	7f 08                	jg     800fd1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	50                   	push   %eax
  800fd5:	6a 05                	push   $0x5
  800fd7:	68 bf 30 80 00       	push   $0x8030bf
  800fdc:	6a 23                	push   $0x23
  800fde:	68 dc 30 80 00       	push   $0x8030dc
  800fe3:	e8 40 f4 ff ff       	call   800428 <_panic>

00800fe8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fe8:	f3 0f 1e fb          	endbr32 
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ff5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	b8 06 00 00 00       	mov    $0x6,%eax
  801005:	89 df                	mov    %ebx,%edi
  801007:	89 de                	mov    %ebx,%esi
  801009:	cd 30                	int    $0x30
	if(check && ret > 0)
  80100b:	85 c0                	test   %eax,%eax
  80100d:	7f 08                	jg     801017 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801012:	5b                   	pop    %ebx
  801013:	5e                   	pop    %esi
  801014:	5f                   	pop    %edi
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	50                   	push   %eax
  80101b:	6a 06                	push   $0x6
  80101d:	68 bf 30 80 00       	push   $0x8030bf
  801022:	6a 23                	push   $0x23
  801024:	68 dc 30 80 00       	push   $0x8030dc
  801029:	e8 fa f3 ff ff       	call   800428 <_panic>

0080102e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80102e:	f3 0f 1e fb          	endbr32 
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
  801038:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	b8 08 00 00 00       	mov    $0x8,%eax
  80104b:	89 df                	mov    %ebx,%edi
  80104d:	89 de                	mov    %ebx,%esi
  80104f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801051:	85 c0                	test   %eax,%eax
  801053:	7f 08                	jg     80105d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801055:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105d:	83 ec 0c             	sub    $0xc,%esp
  801060:	50                   	push   %eax
  801061:	6a 08                	push   $0x8
  801063:	68 bf 30 80 00       	push   $0x8030bf
  801068:	6a 23                	push   $0x23
  80106a:	68 dc 30 80 00       	push   $0x8030dc
  80106f:	e8 b4 f3 ff ff       	call   800428 <_panic>

00801074 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801074:	f3 0f 1e fb          	endbr32 
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108c:	b8 09 00 00 00       	mov    $0x9,%eax
  801091:	89 df                	mov    %ebx,%edi
  801093:	89 de                	mov    %ebx,%esi
  801095:	cd 30                	int    $0x30
	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7f 08                	jg     8010a3 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80109b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	50                   	push   %eax
  8010a7:	6a 09                	push   $0x9
  8010a9:	68 bf 30 80 00       	push   $0x8030bf
  8010ae:	6a 23                	push   $0x23
  8010b0:	68 dc 30 80 00       	push   $0x8030dc
  8010b5:	e8 6e f3 ff ff       	call   800428 <_panic>

008010ba <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010ba:	f3 0f 1e fb          	endbr32 
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010d7:	89 df                	mov    %ebx,%edi
  8010d9:	89 de                	mov    %ebx,%esi
  8010db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	7f 08                	jg     8010e9 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5f                   	pop    %edi
  8010e7:	5d                   	pop    %ebp
  8010e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	50                   	push   %eax
  8010ed:	6a 0a                	push   $0xa
  8010ef:	68 bf 30 80 00       	push   $0x8030bf
  8010f4:	6a 23                	push   $0x23
  8010f6:	68 dc 30 80 00       	push   $0x8030dc
  8010fb:	e8 28 f3 ff ff       	call   800428 <_panic>

00801100 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801100:	f3 0f 1e fb          	endbr32 
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	57                   	push   %edi
  801108:	56                   	push   %esi
  801109:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110a:	8b 55 08             	mov    0x8(%ebp),%edx
  80110d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801110:	b8 0c 00 00 00       	mov    $0xc,%eax
  801115:	be 00 00 00 00       	mov    $0x0,%esi
  80111a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111d:	8b 7d 14             	mov    0x14(%ebp),%edi
  801120:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801127:	f3 0f 1e fb          	endbr32 
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
  801131:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801134:	b9 00 00 00 00       	mov    $0x0,%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	b8 0d 00 00 00       	mov    $0xd,%eax
  801141:	89 cb                	mov    %ecx,%ebx
  801143:	89 cf                	mov    %ecx,%edi
  801145:	89 ce                	mov    %ecx,%esi
  801147:	cd 30                	int    $0x30
	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7f 08                	jg     801155 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80114d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801150:	5b                   	pop    %ebx
  801151:	5e                   	pop    %esi
  801152:	5f                   	pop    %edi
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	50                   	push   %eax
  801159:	6a 0d                	push   $0xd
  80115b:	68 bf 30 80 00       	push   $0x8030bf
  801160:	6a 23                	push   $0x23
  801162:	68 dc 30 80 00       	push   $0x8030dc
  801167:	e8 bc f2 ff ff       	call   800428 <_panic>

0080116c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80116c:	f3 0f 1e fb          	endbr32 
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
	asm volatile("int %1\n"
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
  80117b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801180:	89 d1                	mov    %edx,%ecx
  801182:	89 d3                	mov    %edx,%ebx
  801184:	89 d7                	mov    %edx,%edi
  801186:	89 d6                	mov    %edx,%esi
  801188:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80118a:	5b                   	pop    %ebx
  80118b:	5e                   	pop    %esi
  80118c:	5f                   	pop    %edi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118f:	f3 0f 1e fb          	endbr32 
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	05 00 00 00 30       	add    $0x30000000,%eax
  80119e:	c1 e8 0c             	shr    $0xc,%eax
}
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011be:	f3 0f 1e fb          	endbr32 
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 16             	shr    $0x16,%edx
  8011cf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 2d                	je     801208 <fd_alloc+0x4a>
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	c1 ea 0c             	shr    $0xc,%edx
  8011e0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e7:	f6 c2 01             	test   $0x1,%dl
  8011ea:	74 1c                	je     801208 <fd_alloc+0x4a>
  8011ec:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011f1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011f6:	75 d2                	jne    8011ca <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801201:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801206:	eb 0a                	jmp    801212 <fd_alloc+0x54>
			*fd_store = fd;
  801208:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    

00801214 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801214:	f3 0f 1e fb          	endbr32 
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80121e:	83 f8 1f             	cmp    $0x1f,%eax
  801221:	77 30                	ja     801253 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801223:	c1 e0 0c             	shl    $0xc,%eax
  801226:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80122b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801231:	f6 c2 01             	test   $0x1,%dl
  801234:	74 24                	je     80125a <fd_lookup+0x46>
  801236:	89 c2                	mov    %eax,%edx
  801238:	c1 ea 0c             	shr    $0xc,%edx
  80123b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801242:	f6 c2 01             	test   $0x1,%dl
  801245:	74 1a                	je     801261 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124a:	89 02                	mov    %eax,(%edx)
	return 0;
  80124c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    
		return -E_INVAL;
  801253:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801258:	eb f7                	jmp    801251 <fd_lookup+0x3d>
		return -E_INVAL;
  80125a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125f:	eb f0                	jmp    801251 <fd_lookup+0x3d>
  801261:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801266:	eb e9                	jmp    801251 <fd_lookup+0x3d>

00801268 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801275:	ba 00 00 00 00       	mov    $0x0,%edx
  80127a:	b8 90 57 80 00       	mov    $0x805790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80127f:	39 08                	cmp    %ecx,(%eax)
  801281:	74 38                	je     8012bb <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801283:	83 c2 01             	add    $0x1,%edx
  801286:	8b 04 95 68 31 80 00 	mov    0x803168(,%edx,4),%eax
  80128d:	85 c0                	test   %eax,%eax
  80128f:	75 ee                	jne    80127f <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801291:	a1 90 77 80 00       	mov    0x807790,%eax
  801296:	8b 40 48             	mov    0x48(%eax),%eax
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	51                   	push   %ecx
  80129d:	50                   	push   %eax
  80129e:	68 ec 30 80 00       	push   $0x8030ec
  8012a3:	e8 67 f2 ff ff       	call   80050f <cprintf>
	*dev = 0;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    
			*dev = devtab[i];
  8012bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012be:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c5:	eb f2                	jmp    8012b9 <dev_lookup+0x51>

008012c7 <fd_close>:
{
  8012c7:	f3 0f 1e fb          	endbr32 
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 24             	sub    $0x24,%esp
  8012d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012dd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012de:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e4:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e7:	50                   	push   %eax
  8012e8:	e8 27 ff ff ff       	call   801214 <fd_lookup>
  8012ed:	89 c3                	mov    %eax,%ebx
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	78 05                	js     8012fb <fd_close+0x34>
	    || fd != fd2)
  8012f6:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012f9:	74 16                	je     801311 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012fb:	89 f8                	mov    %edi,%eax
  8012fd:	84 c0                	test   %al,%al
  8012ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801304:	0f 44 d8             	cmove  %eax,%ebx
}
  801307:	89 d8                	mov    %ebx,%eax
  801309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130c:	5b                   	pop    %ebx
  80130d:	5e                   	pop    %esi
  80130e:	5f                   	pop    %edi
  80130f:	5d                   	pop    %ebp
  801310:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	ff 36                	pushl  (%esi)
  80131a:	e8 49 ff ff ff       	call   801268 <dev_lookup>
  80131f:	89 c3                	mov    %eax,%ebx
  801321:	83 c4 10             	add    $0x10,%esp
  801324:	85 c0                	test   %eax,%eax
  801326:	78 1a                	js     801342 <fd_close+0x7b>
		if (dev->dev_close)
  801328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80132e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801333:	85 c0                	test   %eax,%eax
  801335:	74 0b                	je     801342 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	56                   	push   %esi
  80133b:	ff d0                	call   *%eax
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801342:	83 ec 08             	sub    $0x8,%esp
  801345:	56                   	push   %esi
  801346:	6a 00                	push   $0x0
  801348:	e8 9b fc ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	eb b5                	jmp    801307 <fd_close+0x40>

00801352 <close>:

int
close(int fdnum)
{
  801352:	f3 0f 1e fb          	endbr32 
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135f:	50                   	push   %eax
  801360:	ff 75 08             	pushl  0x8(%ebp)
  801363:	e8 ac fe ff ff       	call   801214 <fd_lookup>
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	79 02                	jns    801371 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
		return fd_close(fd, 1);
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	6a 01                	push   $0x1
  801376:	ff 75 f4             	pushl  -0xc(%ebp)
  801379:	e8 49 ff ff ff       	call   8012c7 <fd_close>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	eb ec                	jmp    80136f <close+0x1d>

00801383 <close_all>:

void
close_all(void)
{
  801383:	f3 0f 1e fb          	endbr32 
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	53                   	push   %ebx
  80138b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80138e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	53                   	push   %ebx
  801397:	e8 b6 ff ff ff       	call   801352 <close>
	for (i = 0; i < MAXFD; i++)
  80139c:	83 c3 01             	add    $0x1,%ebx
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	83 fb 20             	cmp    $0x20,%ebx
  8013a5:	75 ec                	jne    801393 <close_all+0x10>
}
  8013a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013ac:	f3 0f 1e fb          	endbr32 
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	57                   	push   %edi
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	ff 75 08             	pushl  0x8(%ebp)
  8013c0:	e8 4f fe ff ff       	call   801214 <fd_lookup>
  8013c5:	89 c3                	mov    %eax,%ebx
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	0f 88 81 00 00 00    	js     801453 <dup+0xa7>
		return r;
	close(newfdnum);
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	e8 75 ff ff ff       	call   801352 <close>

	newfd = INDEX2FD(newfdnum);
  8013dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013e0:	c1 e6 0c             	shl    $0xc,%esi
  8013e3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013e9:	83 c4 04             	add    $0x4,%esp
  8013ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013ef:	e8 af fd ff ff       	call   8011a3 <fd2data>
  8013f4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013f6:	89 34 24             	mov    %esi,(%esp)
  8013f9:	e8 a5 fd ff ff       	call   8011a3 <fd2data>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801403:	89 d8                	mov    %ebx,%eax
  801405:	c1 e8 16             	shr    $0x16,%eax
  801408:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80140f:	a8 01                	test   $0x1,%al
  801411:	74 11                	je     801424 <dup+0x78>
  801413:	89 d8                	mov    %ebx,%eax
  801415:	c1 e8 0c             	shr    $0xc,%eax
  801418:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80141f:	f6 c2 01             	test   $0x1,%dl
  801422:	75 39                	jne    80145d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801424:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801427:	89 d0                	mov    %edx,%eax
  801429:	c1 e8 0c             	shr    $0xc,%eax
  80142c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	25 07 0e 00 00       	and    $0xe07,%eax
  80143b:	50                   	push   %eax
  80143c:	56                   	push   %esi
  80143d:	6a 00                	push   $0x0
  80143f:	52                   	push   %edx
  801440:	6a 00                	push   $0x0
  801442:	e8 5b fb ff ff       	call   800fa2 <sys_page_map>
  801447:	89 c3                	mov    %eax,%ebx
  801449:	83 c4 20             	add    $0x20,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 31                	js     801481 <dup+0xd5>
		goto err;

	return newfdnum;
  801450:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801453:	89 d8                	mov    %ebx,%eax
  801455:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801458:	5b                   	pop    %ebx
  801459:	5e                   	pop    %esi
  80145a:	5f                   	pop    %edi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80145d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801464:	83 ec 0c             	sub    $0xc,%esp
  801467:	25 07 0e 00 00       	and    $0xe07,%eax
  80146c:	50                   	push   %eax
  80146d:	57                   	push   %edi
  80146e:	6a 00                	push   $0x0
  801470:	53                   	push   %ebx
  801471:	6a 00                	push   $0x0
  801473:	e8 2a fb ff ff       	call   800fa2 <sys_page_map>
  801478:	89 c3                	mov    %eax,%ebx
  80147a:	83 c4 20             	add    $0x20,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	79 a3                	jns    801424 <dup+0x78>
	sys_page_unmap(0, newfd);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	56                   	push   %esi
  801485:	6a 00                	push   $0x0
  801487:	e8 5c fb ff ff       	call   800fe8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80148c:	83 c4 08             	add    $0x8,%esp
  80148f:	57                   	push   %edi
  801490:	6a 00                	push   $0x0
  801492:	e8 51 fb ff ff       	call   800fe8 <sys_page_unmap>
	return r;
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	eb b7                	jmp    801453 <dup+0xa7>

0080149c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80149c:	f3 0f 1e fb          	endbr32 
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 1c             	sub    $0x1c,%esp
  8014a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	53                   	push   %ebx
  8014af:	e8 60 fd ff ff       	call   801214 <fd_lookup>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 3f                	js     8014fa <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bb:	83 ec 08             	sub    $0x8,%esp
  8014be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c5:	ff 30                	pushl  (%eax)
  8014c7:	e8 9c fd ff ff       	call   801268 <dev_lookup>
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 27                	js     8014fa <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014d6:	8b 42 08             	mov    0x8(%edx),%eax
  8014d9:	83 e0 03             	and    $0x3,%eax
  8014dc:	83 f8 01             	cmp    $0x1,%eax
  8014df:	74 1e                	je     8014ff <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e4:	8b 40 08             	mov    0x8(%eax),%eax
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 35                	je     801520 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	ff 75 10             	pushl  0x10(%ebp)
  8014f1:	ff 75 0c             	pushl  0xc(%ebp)
  8014f4:	52                   	push   %edx
  8014f5:	ff d0                	call   *%eax
  8014f7:	83 c4 10             	add    $0x10,%esp
}
  8014fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ff:	a1 90 77 80 00       	mov    0x807790,%eax
  801504:	8b 40 48             	mov    0x48(%eax),%eax
  801507:	83 ec 04             	sub    $0x4,%esp
  80150a:	53                   	push   %ebx
  80150b:	50                   	push   %eax
  80150c:	68 2d 31 80 00       	push   $0x80312d
  801511:	e8 f9 ef ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80151e:	eb da                	jmp    8014fa <read+0x5e>
		return -E_NOT_SUPP;
  801520:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801525:	eb d3                	jmp    8014fa <read+0x5e>

00801527 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801527:	f3 0f 1e fb          	endbr32 
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	57                   	push   %edi
  80152f:	56                   	push   %esi
  801530:	53                   	push   %ebx
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	8b 7d 08             	mov    0x8(%ebp),%edi
  801537:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80153a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153f:	eb 02                	jmp    801543 <readn+0x1c>
  801541:	01 c3                	add    %eax,%ebx
  801543:	39 f3                	cmp    %esi,%ebx
  801545:	73 21                	jae    801568 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801547:	83 ec 04             	sub    $0x4,%esp
  80154a:	89 f0                	mov    %esi,%eax
  80154c:	29 d8                	sub    %ebx,%eax
  80154e:	50                   	push   %eax
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	03 45 0c             	add    0xc(%ebp),%eax
  801554:	50                   	push   %eax
  801555:	57                   	push   %edi
  801556:	e8 41 ff ff ff       	call   80149c <read>
		if (m < 0)
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 04                	js     801566 <readn+0x3f>
			return m;
		if (m == 0)
  801562:	75 dd                	jne    801541 <readn+0x1a>
  801564:	eb 02                	jmp    801568 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801566:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801568:	89 d8                	mov    %ebx,%eax
  80156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156d:	5b                   	pop    %ebx
  80156e:	5e                   	pop    %esi
  80156f:	5f                   	pop    %edi
  801570:	5d                   	pop    %ebp
  801571:	c3                   	ret    

00801572 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801572:	f3 0f 1e fb          	endbr32 
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 1c             	sub    $0x1c,%esp
  80157d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801583:	50                   	push   %eax
  801584:	53                   	push   %ebx
  801585:	e8 8a fc ff ff       	call   801214 <fd_lookup>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 3a                	js     8015cb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	ff 30                	pushl  (%eax)
  80159d:	e8 c6 fc ff ff       	call   801268 <dev_lookup>
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 22                	js     8015cb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b0:	74 1e                	je     8015d0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8015b8:	85 d2                	test   %edx,%edx
  8015ba:	74 35                	je     8015f1 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	ff d2                	call   *%edx
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d0:	a1 90 77 80 00       	mov    0x807790,%eax
  8015d5:	8b 40 48             	mov    0x48(%eax),%eax
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	53                   	push   %ebx
  8015dc:	50                   	push   %eax
  8015dd:	68 49 31 80 00       	push   $0x803149
  8015e2:	e8 28 ef ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ef:	eb da                	jmp    8015cb <write+0x59>
		return -E_NOT_SUPP;
  8015f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f6:	eb d3                	jmp    8015cb <write+0x59>

008015f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015f8:	f3 0f 1e fb          	endbr32 
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801605:	50                   	push   %eax
  801606:	ff 75 08             	pushl  0x8(%ebp)
  801609:	e8 06 fc ff ff       	call   801214 <fd_lookup>
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 0e                	js     801623 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801625:	f3 0f 1e fb          	endbr32 
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	53                   	push   %ebx
  80162d:	83 ec 1c             	sub    $0x1c,%esp
  801630:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801633:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801636:	50                   	push   %eax
  801637:	53                   	push   %ebx
  801638:	e8 d7 fb ff ff       	call   801214 <fd_lookup>
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	85 c0                	test   %eax,%eax
  801642:	78 37                	js     80167b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801644:	83 ec 08             	sub    $0x8,%esp
  801647:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164a:	50                   	push   %eax
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	ff 30                	pushl  (%eax)
  801650:	e8 13 fc ff ff       	call   801268 <dev_lookup>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 1f                	js     80167b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801663:	74 1b                	je     801680 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801668:	8b 52 18             	mov    0x18(%edx),%edx
  80166b:	85 d2                	test   %edx,%edx
  80166d:	74 32                	je     8016a1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	50                   	push   %eax
  801676:	ff d2                	call   *%edx
  801678:	83 c4 10             	add    $0x10,%esp
}
  80167b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    
			thisenv->env_id, fdnum);
  801680:	a1 90 77 80 00       	mov    0x807790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801685:	8b 40 48             	mov    0x48(%eax),%eax
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	53                   	push   %ebx
  80168c:	50                   	push   %eax
  80168d:	68 0c 31 80 00       	push   $0x80310c
  801692:	e8 78 ee ff ff       	call   80050f <cprintf>
		return -E_INVAL;
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80169f:	eb da                	jmp    80167b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a6:	eb d3                	jmp    80167b <ftruncate+0x56>

008016a8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a8:	f3 0f 1e fb          	endbr32 
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 1c             	sub    $0x1c,%esp
  8016b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	e8 52 fb ff ff       	call   801214 <fd_lookup>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 4b                	js     801714 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ff 30                	pushl  (%eax)
  8016d5:	e8 8e fb ff ff       	call   801268 <dev_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 33                	js     801714 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e8:	74 2f                	je     801719 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f4:	00 00 00 
	stat->st_isdir = 0;
  8016f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fe:	00 00 00 
	stat->st_dev = dev;
  801701:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	53                   	push   %ebx
  80170b:	ff 75 f0             	pushl  -0x10(%ebp)
  80170e:	ff 50 14             	call   *0x14(%eax)
  801711:	83 c4 10             	add    $0x10,%esp
}
  801714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801717:	c9                   	leave  
  801718:	c3                   	ret    
		return -E_NOT_SUPP;
  801719:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171e:	eb f4                	jmp    801714 <fstat+0x6c>

00801720 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801720:	f3 0f 1e fb          	endbr32 
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	e8 fb 01 00 00       	call   801931 <open>
  801736:	89 c3                	mov    %eax,%ebx
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	85 c0                	test   %eax,%eax
  80173d:	78 1b                	js     80175a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	ff 75 0c             	pushl  0xc(%ebp)
  801745:	50                   	push   %eax
  801746:	e8 5d ff ff ff       	call   8016a8 <fstat>
  80174b:	89 c6                	mov    %eax,%esi
	close(fd);
  80174d:	89 1c 24             	mov    %ebx,(%esp)
  801750:	e8 fd fb ff ff       	call   801352 <close>
	return r;
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	89 f3                	mov    %esi,%ebx
}
  80175a:	89 d8                	mov    %ebx,%eax
  80175c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    

00801763 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	56                   	push   %esi
  801767:	53                   	push   %ebx
  801768:	89 c6                	mov    %eax,%esi
  80176a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176c:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801773:	74 27                	je     80179c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801775:	6a 07                	push   $0x7
  801777:	68 00 80 80 00       	push   $0x808000
  80177c:	56                   	push   %esi
  80177d:	ff 35 00 60 80 00    	pushl  0x806000
  801783:	e8 69 11 00 00       	call   8028f1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801788:	83 c4 0c             	add    $0xc,%esp
  80178b:	6a 00                	push   $0x0
  80178d:	53                   	push   %ebx
  80178e:	6a 00                	push   $0x0
  801790:	e8 e8 10 00 00       	call   80287d <ipc_recv>
}
  801795:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801798:	5b                   	pop    %ebx
  801799:	5e                   	pop    %esi
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	6a 01                	push   $0x1
  8017a1:	e8 a3 11 00 00       	call   802949 <ipc_find_env>
  8017a6:	a3 00 60 80 00       	mov    %eax,0x806000
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	eb c5                	jmp    801775 <fsipc+0x12>

008017b0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b0:	f3 0f 1e fb          	endbr32 
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c0:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  8017c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c8:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d7:	e8 87 ff ff ff       	call   801763 <fsipc>
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <devfile_flush>:
{
  8017de:	f3 0f 1e fb          	endbr32 
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ee:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  8017f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8017fd:	e8 61 ff ff ff       	call   801763 <fsipc>
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <devfile_stat>:
{
  801804:	f3 0f 1e fb          	endbr32 
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	53                   	push   %ebx
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 40 0c             	mov    0xc(%eax),%eax
  801818:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	b8 05 00 00 00       	mov    $0x5,%eax
  801827:	e8 37 ff ff ff       	call   801763 <fsipc>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 2c                	js     80185c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	68 00 80 80 00       	push   $0x808000
  801838:	53                   	push   %ebx
  801839:	e8 db f2 ff ff       	call   800b19 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80183e:	a1 80 80 80 00       	mov    0x808080,%eax
  801843:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801849:	a1 84 80 80 00       	mov    0x808084,%eax
  80184e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devfile_write>:
{
  801861:	f3 0f 1e fb          	endbr32 
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80186e:	8b 55 08             	mov    0x8(%ebp),%edx
  801871:	8b 52 0c             	mov    0xc(%edx),%edx
  801874:	89 15 00 80 80 00    	mov    %edx,0x808000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80187a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187f:	ba 00 10 00 00       	mov    $0x1000,%edx
  801884:	0f 47 c2             	cmova  %edx,%eax
  801887:	a3 04 80 80 00       	mov    %eax,0x808004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80188c:	50                   	push   %eax
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	68 08 80 80 00       	push   $0x808008
  801895:	e8 35 f4 ff ff       	call   800ccf <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	b8 04 00 00 00       	mov    $0x4,%eax
  8018a4:	e8 ba fe ff ff       	call   801763 <fsipc>
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <devfile_read>:
{
  8018ab:	f3 0f 1e fb          	endbr32 
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  8018c2:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d2:	e8 8c fe ff ff       	call   801763 <fsipc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1f                	js     8018fc <devfile_read+0x51>
	assert(r <= n);
  8018dd:	39 f0                	cmp    %esi,%eax
  8018df:	77 24                	ja     801905 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e6:	7f 33                	jg     80191b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	50                   	push   %eax
  8018ec:	68 00 80 80 00       	push   $0x808000
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	e8 d6 f3 ff ff       	call   800ccf <memmove>
	return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
}
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
	assert(r <= n);
  801905:	68 7c 31 80 00       	push   $0x80317c
  80190a:	68 83 31 80 00       	push   $0x803183
  80190f:	6a 7c                	push   $0x7c
  801911:	68 98 31 80 00       	push   $0x803198
  801916:	e8 0d eb ff ff       	call   800428 <_panic>
	assert(r <= PGSIZE);
  80191b:	68 a3 31 80 00       	push   $0x8031a3
  801920:	68 83 31 80 00       	push   $0x803183
  801925:	6a 7d                	push   $0x7d
  801927:	68 98 31 80 00       	push   $0x803198
  80192c:	e8 f7 ea ff ff       	call   800428 <_panic>

00801931 <open>:
{
  801931:	f3 0f 1e fb          	endbr32 
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	56                   	push   %esi
  801939:	53                   	push   %ebx
  80193a:	83 ec 1c             	sub    $0x1c,%esp
  80193d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801940:	56                   	push   %esi
  801941:	e8 90 f1 ff ff       	call   800ad6 <strlen>
  801946:	83 c4 10             	add    $0x10,%esp
  801949:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194e:	7f 6c                	jg     8019bc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801956:	50                   	push   %eax
  801957:	e8 62 f8 ff ff       	call   8011be <fd_alloc>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	83 c4 10             	add    $0x10,%esp
  801961:	85 c0                	test   %eax,%eax
  801963:	78 3c                	js     8019a1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801965:	83 ec 08             	sub    $0x8,%esp
  801968:	56                   	push   %esi
  801969:	68 00 80 80 00       	push   $0x808000
  80196e:	e8 a6 f1 ff ff       	call   800b19 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	a3 00 84 80 00       	mov    %eax,0x808400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80197b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
  801983:	e8 db fd ff ff       	call   801763 <fsipc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 19                	js     8019aa <open+0x79>
	return fd2num(fd);
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	ff 75 f4             	pushl  -0xc(%ebp)
  801997:	e8 f3 f7 ff ff       	call   80118f <fd2num>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
}
  8019a1:	89 d8                	mov    %ebx,%eax
  8019a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a6:	5b                   	pop    %ebx
  8019a7:	5e                   	pop    %esi
  8019a8:	5d                   	pop    %ebp
  8019a9:	c3                   	ret    
		fd_close(fd, 0);
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b2:	e8 10 f9 ff ff       	call   8012c7 <fd_close>
		return r;
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	eb e5                	jmp    8019a1 <open+0x70>
		return -E_BAD_PATH;
  8019bc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c1:	eb de                	jmp    8019a1 <open+0x70>

008019c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019c3:	f3 0f 1e fb          	endbr32 
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d7:	e8 87 fd ff ff       	call   801763 <fsipc>
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019de:	f3 0f 1e fb          	endbr32 
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	57                   	push   %edi
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 08             	pushl  0x8(%ebp)
  8019f3:	e8 39 ff ff ff       	call   801931 <open>
  8019f8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8019fe:	83 c4 10             	add    $0x10,%esp
  801a01:	85 c0                	test   %eax,%eax
  801a03:	0f 88 07 05 00 00    	js     801f10 <spawn+0x532>
  801a09:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 00 02 00 00       	push   $0x200
  801a13:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801a19:	50                   	push   %eax
  801a1a:	52                   	push   %edx
  801a1b:	e8 07 fb ff ff       	call   801527 <readn>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a28:	0f 85 9d 00 00 00    	jne    801acb <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  801a2e:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a35:	45 4c 46 
  801a38:	0f 85 8d 00 00 00    	jne    801acb <spawn+0xed>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a3e:	b8 07 00 00 00       	mov    $0x7,%eax
  801a43:	cd 30                	int    $0x30
  801a45:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a4b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a51:	85 c0                	test   %eax,%eax
  801a53:	0f 88 ab 04 00 00    	js     801f04 <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a59:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a5e:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801a61:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a67:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a6d:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a74:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a7a:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	6a 04                	push   $0x4
  801a85:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  801a92:	50                   	push   %eax
  801a93:	e8 9d f2 ff ff       	call   800d35 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801aa0:	be 00 00 00 00       	mov    $0x0,%esi
  801aa5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801aa8:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801aaf:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801ab2:	85 c0                	test   %eax,%eax
  801ab4:	74 4d                	je     801b03 <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	50                   	push   %eax
  801aba:	e8 17 f0 ff ff       	call   800ad6 <strlen>
  801abf:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801ac3:	83 c3 01             	add    $0x1,%ebx
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	eb dd                	jmp    801aa8 <spawn+0xca>
		close(fd);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ad4:	e8 79 f8 ff ff       	call   801352 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ad9:	83 c4 0c             	add    $0xc,%esp
  801adc:	68 7f 45 4c 46       	push   $0x464c457f
  801ae1:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801ae7:	68 af 31 80 00       	push   $0x8031af
  801aec:	e8 1e ea ff ff       	call   80050f <cprintf>
		return -E_NOT_EXEC;
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801afb:	ff ff ff 
  801afe:	e9 0d 04 00 00       	jmp    801f10 <spawn+0x532>
  801b03:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801b09:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b0f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b14:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b16:	89 fa                	mov    %edi,%edx
  801b18:	83 e2 fc             	and    $0xfffffffc,%edx
  801b1b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b22:	29 c2                	sub    %eax,%edx
  801b24:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b2a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b2d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b32:	0f 86 fb 03 00 00    	jbe    801f33 <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	6a 07                	push   $0x7
  801b3d:	68 00 00 40 00       	push   $0x400000
  801b42:	6a 00                	push   $0x0
  801b44:	e8 12 f4 ff ff       	call   800f5b <sys_page_alloc>
  801b49:	83 c4 10             	add    $0x10,%esp
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	0f 88 e4 03 00 00    	js     801f38 <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b54:	be 00 00 00 00       	mov    $0x0,%esi
  801b59:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801b5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b62:	eb 30                	jmp    801b94 <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b64:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b6a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801b70:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b73:	83 ec 08             	sub    $0x8,%esp
  801b76:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b79:	57                   	push   %edi
  801b7a:	e8 9a ef ff ff       	call   800b19 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b7f:	83 c4 04             	add    $0x4,%esp
  801b82:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b85:	e8 4c ef ff ff       	call   800ad6 <strlen>
  801b8a:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801b8e:	83 c6 01             	add    $0x1,%esi
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b9a:	7f c8                	jg     801b64 <spawn+0x186>
	}
	argv_store[argc] = 0;
  801b9c:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ba2:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801ba8:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801baf:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801bb5:	0f 85 86 00 00 00    	jne    801c41 <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801bbb:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801bc1:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801bc7:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801bca:	89 c8                	mov    %ecx,%eax
  801bcc:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801bd2:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801bd5:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801bda:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	6a 07                	push   $0x7
  801be5:	68 00 d0 bf ee       	push   $0xeebfd000
  801bea:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bf0:	68 00 00 40 00       	push   $0x400000
  801bf5:	6a 00                	push   $0x0
  801bf7:	e8 a6 f3 ff ff       	call   800fa2 <sys_page_map>
  801bfc:	89 c3                	mov    %eax,%ebx
  801bfe:	83 c4 20             	add    $0x20,%esp
  801c01:	85 c0                	test   %eax,%eax
  801c03:	0f 88 37 03 00 00    	js     801f40 <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	68 00 00 40 00       	push   $0x400000
  801c11:	6a 00                	push   $0x0
  801c13:	e8 d0 f3 ff ff       	call   800fe8 <sys_page_unmap>
  801c18:	89 c3                	mov    %eax,%ebx
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	85 c0                	test   %eax,%eax
  801c1f:	0f 88 1b 03 00 00    	js     801f40 <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c25:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c2b:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c32:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801c39:	00 00 00 
  801c3c:	e9 4f 01 00 00       	jmp    801d90 <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c41:	68 24 32 80 00       	push   $0x803224
  801c46:	68 83 31 80 00       	push   $0x803183
  801c4b:	68 f6 00 00 00       	push   $0xf6
  801c50:	68 c9 31 80 00       	push   $0x8031c9
  801c55:	e8 ce e7 ff ff       	call   800428 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	6a 07                	push   $0x7
  801c5f:	68 00 00 40 00       	push   $0x400000
  801c64:	6a 00                	push   $0x0
  801c66:	e8 f0 f2 ff ff       	call   800f5b <sys_page_alloc>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 88 a8 02 00 00    	js     801f1e <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c76:	83 ec 08             	sub    $0x8,%esp
  801c79:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c7f:	01 f0                	add    %esi,%eax
  801c81:	50                   	push   %eax
  801c82:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c88:	e8 6b f9 ff ff       	call   8015f8 <seek>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	0f 88 8d 02 00 00    	js     801f25 <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ca1:	29 f0                	sub    %esi,%eax
  801ca3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ca8:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801cad:	0f 47 c1             	cmova  %ecx,%eax
  801cb0:	50                   	push   %eax
  801cb1:	68 00 00 40 00       	push   $0x400000
  801cb6:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801cbc:	e8 66 f8 ff ff       	call   801527 <readn>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	0f 88 60 02 00 00    	js     801f2c <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801cd5:	53                   	push   %ebx
  801cd6:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801cdc:	68 00 00 40 00       	push   $0x400000
  801ce1:	6a 00                	push   $0x0
  801ce3:	e8 ba f2 ff ff       	call   800fa2 <sys_page_map>
  801ce8:	83 c4 20             	add    $0x20,%esp
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	78 7c                	js     801d6b <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	68 00 00 40 00       	push   $0x400000
  801cf7:	6a 00                	push   $0x0
  801cf9:	e8 ea f2 ff ff       	call   800fe8 <sys_page_unmap>
  801cfe:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801d01:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801d07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d0d:	89 fe                	mov    %edi,%esi
  801d0f:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801d15:	76 69                	jbe    801d80 <spawn+0x3a2>
		if (i >= filesz) {
  801d17:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801d1d:	0f 87 37 ff ff ff    	ja     801c5a <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d2c:	53                   	push   %ebx
  801d2d:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d33:	e8 23 f2 ff ff       	call   800f5b <sys_page_alloc>
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	79 c2                	jns    801d01 <spawn+0x323>
  801d3f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d4a:	e8 81 f1 ff ff       	call   800ed0 <sys_env_destroy>
	close(fd);
  801d4f:	83 c4 04             	add    $0x4,%esp
  801d52:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d58:	e8 f5 f5 ff ff       	call   801352 <close>
	return r;
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801d66:	e9 a5 01 00 00       	jmp    801f10 <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  801d6b:	50                   	push   %eax
  801d6c:	68 d5 31 80 00       	push   $0x8031d5
  801d71:	68 29 01 00 00       	push   $0x129
  801d76:	68 c9 31 80 00       	push   $0x8031c9
  801d7b:	e8 a8 e6 ff ff       	call   800428 <_panic>
  801d80:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d86:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801d8d:	83 c6 20             	add    $0x20,%esi
  801d90:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d97:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801d9d:	7e 6d                	jle    801e0c <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  801d9f:	83 3e 01             	cmpl   $0x1,(%esi)
  801da2:	75 e2                	jne    801d86 <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801da4:	8b 46 18             	mov    0x18(%esi),%eax
  801da7:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801daa:	83 f8 01             	cmp    $0x1,%eax
  801dad:	19 c0                	sbb    %eax,%eax
  801daf:	83 e0 fe             	and    $0xfffffffe,%eax
  801db2:	83 c0 07             	add    $0x7,%eax
  801db5:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801dbb:	8b 4e 04             	mov    0x4(%esi),%ecx
  801dbe:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801dc4:	8b 56 10             	mov    0x10(%esi),%edx
  801dc7:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801dcd:	8b 7e 14             	mov    0x14(%esi),%edi
  801dd0:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801dd6:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801dd9:	89 d8                	mov    %ebx,%eax
  801ddb:	25 ff 0f 00 00       	and    $0xfff,%eax
  801de0:	74 1a                	je     801dfc <spawn+0x41e>
		va -= i;
  801de2:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801de4:	01 c7                	add    %eax,%edi
  801de6:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801dec:	01 c2                	add    %eax,%edx
  801dee:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801df4:	29 c1                	sub    %eax,%ecx
  801df6:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801dfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801e01:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801e07:	e9 01 ff ff ff       	jmp    801d0d <spawn+0x32f>
	close(fd);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e15:	e8 38 f5 ff ff       	call   801352 <close>
  801e1a:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e22:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801e28:	eb 2a                	jmp    801e54 <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  801e2a:	a1 90 77 80 00       	mov    0x807790,%eax
  801e2f:	8b 40 48             	mov    0x48(%eax),%eax
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	68 07 0e 00 00       	push   $0xe07
  801e3a:	53                   	push   %ebx
  801e3b:	56                   	push   %esi
  801e3c:	53                   	push   %ebx
  801e3d:	50                   	push   %eax
  801e3e:	e8 5f f1 ff ff       	call   800fa2 <sys_page_map>
  801e43:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801e46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e4c:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801e52:	74 3b                	je     801e8f <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801e54:	89 d8                	mov    %ebx,%eax
  801e56:	c1 e8 16             	shr    $0x16,%eax
  801e59:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e60:	a8 01                	test   $0x1,%al
  801e62:	74 e2                	je     801e46 <spawn+0x468>
  801e64:	89 d8                	mov    %ebx,%eax
  801e66:	c1 e8 0c             	shr    $0xc,%eax
  801e69:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e70:	f6 c2 01             	test   $0x1,%dl
  801e73:	74 d1                	je     801e46 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801e75:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801e7c:	f6 c2 04             	test   $0x4,%dl
  801e7f:	74 c5                	je     801e46 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801e81:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e88:	f6 c4 04             	test   $0x4,%ah
  801e8b:	74 b9                	je     801e46 <spawn+0x468>
  801e8d:	eb 9b                	jmp    801e2a <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e8f:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e96:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e99:	83 ec 08             	sub    $0x8,%esp
  801e9c:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ea9:	e8 c6 f1 ff ff       	call   801074 <sys_env_set_trapframe>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	78 25                	js     801eda <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801eb5:	83 ec 08             	sub    $0x8,%esp
  801eb8:	6a 02                	push   $0x2
  801eba:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ec0:	e8 69 f1 ff ff       	call   80102e <sys_env_set_status>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 23                	js     801eef <spawn+0x511>
	return child;
  801ecc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ed2:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ed8:	eb 36                	jmp    801f10 <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  801eda:	50                   	push   %eax
  801edb:	68 f2 31 80 00       	push   $0x8031f2
  801ee0:	68 8a 00 00 00       	push   $0x8a
  801ee5:	68 c9 31 80 00       	push   $0x8031c9
  801eea:	e8 39 e5 ff ff       	call   800428 <_panic>
		panic("sys_env_set_status: %e", r);
  801eef:	50                   	push   %eax
  801ef0:	68 0c 32 80 00       	push   $0x80320c
  801ef5:	68 8d 00 00 00       	push   $0x8d
  801efa:	68 c9 31 80 00       	push   $0x8031c9
  801eff:	e8 24 e5 ff ff       	call   800428 <_panic>
		return r;
  801f04:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801f0a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801f10:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f19:	5b                   	pop    %ebx
  801f1a:	5e                   	pop    %esi
  801f1b:	5f                   	pop    %edi
  801f1c:	5d                   	pop    %ebp
  801f1d:	c3                   	ret    
  801f1e:	89 c7                	mov    %eax,%edi
  801f20:	e9 1c fe ff ff       	jmp    801d41 <spawn+0x363>
  801f25:	89 c7                	mov    %eax,%edi
  801f27:	e9 15 fe ff ff       	jmp    801d41 <spawn+0x363>
  801f2c:	89 c7                	mov    %eax,%edi
  801f2e:	e9 0e fe ff ff       	jmp    801d41 <spawn+0x363>
		return -E_NO_MEM;
  801f33:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801f38:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801f3e:	eb d0                	jmp    801f10 <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	68 00 00 40 00       	push   $0x400000
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 99 f0 ff ff       	call   800fe8 <sys_page_unmap>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801f58:	eb b6                	jmp    801f10 <spawn+0x532>

00801f5a <spawnl>:
{
  801f5a:	f3 0f 1e fb          	endbr32 
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f67:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f6f:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f72:	83 3a 00             	cmpl   $0x0,(%edx)
  801f75:	74 07                	je     801f7e <spawnl+0x24>
		argc++;
  801f77:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801f7a:	89 ca                	mov    %ecx,%edx
  801f7c:	eb f1                	jmp    801f6f <spawnl+0x15>
	const char *argv[argc+2];
  801f7e:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801f85:	89 d1                	mov    %edx,%ecx
  801f87:	83 e1 f0             	and    $0xfffffff0,%ecx
  801f8a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f90:	89 e6                	mov    %esp,%esi
  801f92:	29 d6                	sub    %edx,%esi
  801f94:	89 f2                	mov    %esi,%edx
  801f96:	39 d4                	cmp    %edx,%esp
  801f98:	74 10                	je     801faa <spawnl+0x50>
  801f9a:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801fa0:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801fa7:	00 
  801fa8:	eb ec                	jmp    801f96 <spawnl+0x3c>
  801faa:	89 ca                	mov    %ecx,%edx
  801fac:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801fb2:	29 d4                	sub    %edx,%esp
  801fb4:	85 d2                	test   %edx,%edx
  801fb6:	74 05                	je     801fbd <spawnl+0x63>
  801fb8:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801fbd:	8d 74 24 03          	lea    0x3(%esp),%esi
  801fc1:	89 f2                	mov    %esi,%edx
  801fc3:	c1 ea 02             	shr    $0x2,%edx
  801fc6:	83 e6 fc             	and    $0xfffffffc,%esi
  801fc9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fce:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801fd5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801fdc:	00 
	va_start(vl, arg0);
  801fdd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801fe0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	eb 0b                	jmp    801ff4 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801fe9:	83 c0 01             	add    $0x1,%eax
  801fec:	8b 39                	mov    (%ecx),%edi
  801fee:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ff1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ff4:	39 d0                	cmp    %edx,%eax
  801ff6:	75 f1                	jne    801fe9 <spawnl+0x8f>
	return spawn(prog, argv);
  801ff8:	83 ec 08             	sub    $0x8,%esp
  801ffb:	56                   	push   %esi
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	e8 da f9 ff ff       	call   8019de <spawn>
}
  802004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802007:	5b                   	pop    %ebx
  802008:	5e                   	pop    %esi
  802009:	5f                   	pop    %edi
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80200c:	f3 0f 1e fb          	endbr32 
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802016:	68 4a 32 80 00       	push   $0x80324a
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	e8 f6 ea ff ff       	call   800b19 <strcpy>
	return 0;
}
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <devsock_close>:
{
  80202a:	f3 0f 1e fb          	endbr32 
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	53                   	push   %ebx
  802032:	83 ec 10             	sub    $0x10,%esp
  802035:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802038:	53                   	push   %ebx
  802039:	e8 48 09 00 00       	call   802986 <pageref>
  80203e:	89 c2                	mov    %eax,%edx
  802040:	83 c4 10             	add    $0x10,%esp
		return 0;
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802048:	83 fa 01             	cmp    $0x1,%edx
  80204b:	74 05                	je     802052 <devsock_close+0x28>
}
  80204d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802050:	c9                   	leave  
  802051:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 73 0c             	pushl  0xc(%ebx)
  802058:	e8 e3 02 00 00       	call   802340 <nsipc_close>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	eb eb                	jmp    80204d <devsock_close+0x23>

00802062 <devsock_write>:
{
  802062:	f3 0f 1e fb          	endbr32 
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	ff 70 0c             	pushl  0xc(%eax)
  80207a:	e8 b5 03 00 00       	call   802434 <nsipc_send>
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <devsock_read>:
{
  802081:	f3 0f 1e fb          	endbr32 
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	ff 70 0c             	pushl  0xc(%eax)
  802099:	e8 1f 03 00 00       	call   8023bd <nsipc_recv>
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <fd2sockid>:
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	e8 64 f1 ff ff       	call   801214 <fd_lookup>
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 10                	js     8020c7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  8020c0:	39 08                	cmp    %ecx,(%eax)
  8020c2:	75 05                	jne    8020c9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8020c4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    
		return -E_NOT_SUPP;
  8020c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020ce:	eb f7                	jmp    8020c7 <fd2sockid+0x27>

008020d0 <alloc_sockfd>:
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	56                   	push   %esi
  8020d4:	53                   	push   %ebx
  8020d5:	83 ec 1c             	sub    $0x1c,%esp
  8020d8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8020da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dd:	50                   	push   %eax
  8020de:	e8 db f0 ff ff       	call   8011be <fd_alloc>
  8020e3:	89 c3                	mov    %eax,%ebx
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 43                	js     80212f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 07 04 00 00       	push   $0x407
  8020f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f7:	6a 00                	push   $0x0
  8020f9:	e8 5d ee ff ff       	call   800f5b <sys_page_alloc>
  8020fe:	89 c3                	mov    %eax,%ebx
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	85 c0                	test   %eax,%eax
  802105:	78 28                	js     80212f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  802110:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80211c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	50                   	push   %eax
  802123:	e8 67 f0 ff ff       	call   80118f <fd2num>
  802128:	89 c3                	mov    %eax,%ebx
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	eb 0c                	jmp    80213b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	56                   	push   %esi
  802133:	e8 08 02 00 00       	call   802340 <nsipc_close>
		return r;
  802138:	83 c4 10             	add    $0x10,%esp
}
  80213b:	89 d8                	mov    %ebx,%eax
  80213d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <accept>:
{
  802144:	f3 0f 1e fb          	endbr32 
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	e8 4a ff ff ff       	call   8020a0 <fd2sockid>
  802156:	85 c0                	test   %eax,%eax
  802158:	78 1b                	js     802175 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	50                   	push   %eax
  802164:	e8 22 01 00 00       	call   80228b <nsipc_accept>
  802169:	83 c4 10             	add    $0x10,%esp
  80216c:	85 c0                	test   %eax,%eax
  80216e:	78 05                	js     802175 <accept+0x31>
	return alloc_sockfd(r);
  802170:	e8 5b ff ff ff       	call   8020d0 <alloc_sockfd>
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <bind>:
{
  802177:	f3 0f 1e fb          	endbr32 
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	e8 17 ff ff ff       	call   8020a0 <fd2sockid>
  802189:	85 c0                	test   %eax,%eax
  80218b:	78 12                	js     80219f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80218d:	83 ec 04             	sub    $0x4,%esp
  802190:	ff 75 10             	pushl  0x10(%ebp)
  802193:	ff 75 0c             	pushl  0xc(%ebp)
  802196:	50                   	push   %eax
  802197:	e8 45 01 00 00       	call   8022e1 <nsipc_bind>
  80219c:	83 c4 10             	add    $0x10,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <shutdown>:
{
  8021a1:	f3 0f 1e fb          	endbr32 
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	e8 ed fe ff ff       	call   8020a0 <fd2sockid>
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	78 0f                	js     8021c6 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8021b7:	83 ec 08             	sub    $0x8,%esp
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	50                   	push   %eax
  8021be:	e8 57 01 00 00       	call   80231a <nsipc_shutdown>
  8021c3:	83 c4 10             	add    $0x10,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <connect>:
{
  8021c8:	f3 0f 1e fb          	endbr32 
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	e8 c6 fe ff ff       	call   8020a0 <fd2sockid>
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 12                	js     8021f0 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	ff 75 10             	pushl  0x10(%ebp)
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	50                   	push   %eax
  8021e8:	e8 71 01 00 00       	call   80235e <nsipc_connect>
  8021ed:	83 c4 10             	add    $0x10,%esp
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <listen>:
{
  8021f2:	f3 0f 1e fb          	endbr32 
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	e8 9c fe ff ff       	call   8020a0 <fd2sockid>
  802204:	85 c0                	test   %eax,%eax
  802206:	78 0f                	js     802217 <listen+0x25>
	return nsipc_listen(r, backlog);
  802208:	83 ec 08             	sub    $0x8,%esp
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	50                   	push   %eax
  80220f:	e8 83 01 00 00       	call   802397 <nsipc_listen>
  802214:	83 c4 10             	add    $0x10,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <socket>:

int
socket(int domain, int type, int protocol)
{
  802219:	f3 0f 1e fb          	endbr32 
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802223:	ff 75 10             	pushl  0x10(%ebp)
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	ff 75 08             	pushl  0x8(%ebp)
  80222c:	e8 65 02 00 00       	call   802496 <nsipc_socket>
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	78 05                	js     80223d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802238:	e8 93 fe ff ff       	call   8020d0 <alloc_sockfd>
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	53                   	push   %ebx
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802248:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  80224f:	74 26                	je     802277 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802251:	6a 07                	push   $0x7
  802253:	68 00 90 80 00       	push   $0x809000
  802258:	53                   	push   %ebx
  802259:	ff 35 04 60 80 00    	pushl  0x806004
  80225f:	e8 8d 06 00 00       	call   8028f1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802264:	83 c4 0c             	add    $0xc,%esp
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	e8 0b 06 00 00       	call   80287d <ipc_recv>
}
  802272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802275:	c9                   	leave  
  802276:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	6a 02                	push   $0x2
  80227c:	e8 c8 06 00 00       	call   802949 <ipc_find_env>
  802281:	a3 04 60 80 00       	mov    %eax,0x806004
  802286:	83 c4 10             	add    $0x10,%esp
  802289:	eb c6                	jmp    802251 <nsipc+0x12>

0080228b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80228b:	f3 0f 1e fb          	endbr32 
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80229f:	8b 06                	mov    (%esi),%eax
  8022a1:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	e8 8f ff ff ff       	call   80223f <nsipc>
  8022b0:	89 c3                	mov    %eax,%ebx
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	79 09                	jns    8022bf <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8022b6:	89 d8                	mov    %ebx,%eax
  8022b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022bf:	83 ec 04             	sub    $0x4,%esp
  8022c2:	ff 35 10 90 80 00    	pushl  0x809010
  8022c8:	68 00 90 80 00       	push   $0x809000
  8022cd:	ff 75 0c             	pushl  0xc(%ebp)
  8022d0:	e8 fa e9 ff ff       	call   800ccf <memmove>
		*addrlen = ret->ret_addrlen;
  8022d5:	a1 10 90 80 00       	mov    0x809010,%eax
  8022da:	89 06                	mov    %eax,(%esi)
  8022dc:	83 c4 10             	add    $0x10,%esp
	return r;
  8022df:	eb d5                	jmp    8022b6 <nsipc_accept+0x2b>

008022e1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022e1:	f3 0f 1e fb          	endbr32 
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	53                   	push   %ebx
  8022e9:	83 ec 08             	sub    $0x8,%esp
  8022ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022f7:	53                   	push   %ebx
  8022f8:	ff 75 0c             	pushl  0xc(%ebp)
  8022fb:	68 04 90 80 00       	push   $0x809004
  802300:	e8 ca e9 ff ff       	call   800ccf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802305:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  80230b:	b8 02 00 00 00       	mov    $0x2,%eax
  802310:	e8 2a ff ff ff       	call   80223f <nsipc>
}
  802315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80231a:	f3 0f 1e fb          	endbr32 
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802334:	b8 03 00 00 00       	mov    $0x3,%eax
  802339:	e8 01 ff ff ff       	call   80223f <nsipc>
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <nsipc_close>:

int
nsipc_close(int s)
{
  802340:	f3 0f 1e fb          	endbr32 
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802352:	b8 04 00 00 00       	mov    $0x4,%eax
  802357:	e8 e3 fe ff ff       	call   80223f <nsipc>
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80235e:	f3 0f 1e fb          	endbr32 
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	53                   	push   %ebx
  802366:	83 ec 08             	sub    $0x8,%esp
  802369:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802374:	53                   	push   %ebx
  802375:	ff 75 0c             	pushl  0xc(%ebp)
  802378:	68 04 90 80 00       	push   $0x809004
  80237d:	e8 4d e9 ff ff       	call   800ccf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802382:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802388:	b8 05 00 00 00       	mov    $0x5,%eax
  80238d:	e8 ad fe ff ff       	call   80223f <nsipc>
}
  802392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802397:	f3 0f 1e fb          	endbr32 
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  8023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ac:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  8023b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8023b6:	e8 84 fe ff ff       	call   80223f <nsipc>
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023bd:	f3 0f 1e fb          	endbr32 
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	56                   	push   %esi
  8023c5:	53                   	push   %ebx
  8023c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  8023d1:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  8023d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023da:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023df:	b8 07 00 00 00       	mov    $0x7,%eax
  8023e4:	e8 56 fe ff ff       	call   80223f <nsipc>
  8023e9:	89 c3                	mov    %eax,%ebx
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	78 26                	js     802415 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8023ef:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8023f5:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8023fa:	0f 4e c6             	cmovle %esi,%eax
  8023fd:	39 c3                	cmp    %eax,%ebx
  8023ff:	7f 1d                	jg     80241e <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	53                   	push   %ebx
  802405:	68 00 90 80 00       	push   $0x809000
  80240a:	ff 75 0c             	pushl  0xc(%ebp)
  80240d:	e8 bd e8 ff ff       	call   800ccf <memmove>
  802412:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802415:	89 d8                	mov    %ebx,%eax
  802417:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80241a:	5b                   	pop    %ebx
  80241b:	5e                   	pop    %esi
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80241e:	68 56 32 80 00       	push   $0x803256
  802423:	68 83 31 80 00       	push   $0x803183
  802428:	6a 62                	push   $0x62
  80242a:	68 6b 32 80 00       	push   $0x80326b
  80242f:	e8 f4 df ff ff       	call   800428 <_panic>

00802434 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802434:	f3 0f 1e fb          	endbr32 
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	53                   	push   %ebx
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  80244a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802450:	7f 2e                	jg     802480 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	53                   	push   %ebx
  802456:	ff 75 0c             	pushl  0xc(%ebp)
  802459:	68 0c 90 80 00       	push   $0x80900c
  80245e:	e8 6c e8 ff ff       	call   800ccf <memmove>
	nsipcbuf.send.req_size = size;
  802463:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802469:	8b 45 14             	mov    0x14(%ebp),%eax
  80246c:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  802471:	b8 08 00 00 00       	mov    $0x8,%eax
  802476:	e8 c4 fd ff ff       	call   80223f <nsipc>
}
  80247b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    
	assert(size < 1600);
  802480:	68 77 32 80 00       	push   $0x803277
  802485:	68 83 31 80 00       	push   $0x803183
  80248a:	6a 6d                	push   $0x6d
  80248c:	68 6b 32 80 00       	push   $0x80326b
  802491:	e8 92 df ff ff       	call   800428 <_panic>

00802496 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802496:	f3 0f 1e fb          	endbr32 
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  8024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ab:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  8024b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b3:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  8024b8:	b8 09 00 00 00       	mov    $0x9,%eax
  8024bd:	e8 7d fd ff ff       	call   80223f <nsipc>
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024c4:	f3 0f 1e fb          	endbr32 
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	56                   	push   %esi
  8024cc:	53                   	push   %ebx
  8024cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	ff 75 08             	pushl  0x8(%ebp)
  8024d6:	e8 c8 ec ff ff       	call   8011a3 <fd2data>
  8024db:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024dd:	83 c4 08             	add    $0x8,%esp
  8024e0:	68 83 32 80 00       	push   $0x803283
  8024e5:	53                   	push   %ebx
  8024e6:	e8 2e e6 ff ff       	call   800b19 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024eb:	8b 46 04             	mov    0x4(%esi),%eax
  8024ee:	2b 06                	sub    (%esi),%eax
  8024f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024fd:	00 00 00 
	stat->st_dev = &devpipe;
  802500:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  802507:	57 80 00 
	return 0;
}
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802512:	5b                   	pop    %ebx
  802513:	5e                   	pop    %esi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    

00802516 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802516:	f3 0f 1e fb          	endbr32 
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	53                   	push   %ebx
  80251e:	83 ec 0c             	sub    $0xc,%esp
  802521:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802524:	53                   	push   %ebx
  802525:	6a 00                	push   $0x0
  802527:	e8 bc ea ff ff       	call   800fe8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80252c:	89 1c 24             	mov    %ebx,(%esp)
  80252f:	e8 6f ec ff ff       	call   8011a3 <fd2data>
  802534:	83 c4 08             	add    $0x8,%esp
  802537:	50                   	push   %eax
  802538:	6a 00                	push   $0x0
  80253a:	e8 a9 ea ff ff       	call   800fe8 <sys_page_unmap>
}
  80253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <_pipeisclosed>:
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	57                   	push   %edi
  802548:	56                   	push   %esi
  802549:	53                   	push   %ebx
  80254a:	83 ec 1c             	sub    $0x1c,%esp
  80254d:	89 c7                	mov    %eax,%edi
  80254f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802551:	a1 90 77 80 00       	mov    0x807790,%eax
  802556:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	57                   	push   %edi
  80255d:	e8 24 04 00 00       	call   802986 <pageref>
  802562:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802565:	89 34 24             	mov    %esi,(%esp)
  802568:	e8 19 04 00 00       	call   802986 <pageref>
		nn = thisenv->env_runs;
  80256d:	8b 15 90 77 80 00    	mov    0x807790,%edx
  802573:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	39 cb                	cmp    %ecx,%ebx
  80257b:	74 1b                	je     802598 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80257d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802580:	75 cf                	jne    802551 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802582:	8b 42 58             	mov    0x58(%edx),%eax
  802585:	6a 01                	push   $0x1
  802587:	50                   	push   %eax
  802588:	53                   	push   %ebx
  802589:	68 8a 32 80 00       	push   $0x80328a
  80258e:	e8 7c df ff ff       	call   80050f <cprintf>
  802593:	83 c4 10             	add    $0x10,%esp
  802596:	eb b9                	jmp    802551 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802598:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80259b:	0f 94 c0             	sete   %al
  80259e:	0f b6 c0             	movzbl %al,%eax
}
  8025a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025a4:	5b                   	pop    %ebx
  8025a5:	5e                   	pop    %esi
  8025a6:	5f                   	pop    %edi
  8025a7:	5d                   	pop    %ebp
  8025a8:	c3                   	ret    

008025a9 <devpipe_write>:
{
  8025a9:	f3 0f 1e fb          	endbr32 
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	57                   	push   %edi
  8025b1:	56                   	push   %esi
  8025b2:	53                   	push   %ebx
  8025b3:	83 ec 28             	sub    $0x28,%esp
  8025b6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8025b9:	56                   	push   %esi
  8025ba:	e8 e4 eb ff ff       	call   8011a3 <fd2data>
  8025bf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8025c1:	83 c4 10             	add    $0x10,%esp
  8025c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025cc:	74 4f                	je     80261d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025ce:	8b 43 04             	mov    0x4(%ebx),%eax
  8025d1:	8b 0b                	mov    (%ebx),%ecx
  8025d3:	8d 51 20             	lea    0x20(%ecx),%edx
  8025d6:	39 d0                	cmp    %edx,%eax
  8025d8:	72 14                	jb     8025ee <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8025da:	89 da                	mov    %ebx,%edx
  8025dc:	89 f0                	mov    %esi,%eax
  8025de:	e8 61 ff ff ff       	call   802544 <_pipeisclosed>
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	75 3b                	jne    802622 <devpipe_write+0x79>
			sys_yield();
  8025e7:	e8 4c e9 ff ff       	call   800f38 <sys_yield>
  8025ec:	eb e0                	jmp    8025ce <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025f1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025f5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025f8:	89 c2                	mov    %eax,%edx
  8025fa:	c1 fa 1f             	sar    $0x1f,%edx
  8025fd:	89 d1                	mov    %edx,%ecx
  8025ff:	c1 e9 1b             	shr    $0x1b,%ecx
  802602:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802605:	83 e2 1f             	and    $0x1f,%edx
  802608:	29 ca                	sub    %ecx,%edx
  80260a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80260e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802612:	83 c0 01             	add    $0x1,%eax
  802615:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802618:	83 c7 01             	add    $0x1,%edi
  80261b:	eb ac                	jmp    8025c9 <devpipe_write+0x20>
	return i;
  80261d:	8b 45 10             	mov    0x10(%ebp),%eax
  802620:	eb 05                	jmp    802627 <devpipe_write+0x7e>
				return 0;
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802627:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80262a:	5b                   	pop    %ebx
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    

0080262f <devpipe_read>:
{
  80262f:	f3 0f 1e fb          	endbr32 
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	57                   	push   %edi
  802637:	56                   	push   %esi
  802638:	53                   	push   %ebx
  802639:	83 ec 18             	sub    $0x18,%esp
  80263c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80263f:	57                   	push   %edi
  802640:	e8 5e eb ff ff       	call   8011a3 <fd2data>
  802645:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802647:	83 c4 10             	add    $0x10,%esp
  80264a:	be 00 00 00 00       	mov    $0x0,%esi
  80264f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802652:	75 14                	jne    802668 <devpipe_read+0x39>
	return i;
  802654:	8b 45 10             	mov    0x10(%ebp),%eax
  802657:	eb 02                	jmp    80265b <devpipe_read+0x2c>
				return i;
  802659:	89 f0                	mov    %esi,%eax
}
  80265b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80265e:	5b                   	pop    %ebx
  80265f:	5e                   	pop    %esi
  802660:	5f                   	pop    %edi
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    
			sys_yield();
  802663:	e8 d0 e8 ff ff       	call   800f38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802668:	8b 03                	mov    (%ebx),%eax
  80266a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80266d:	75 18                	jne    802687 <devpipe_read+0x58>
			if (i > 0)
  80266f:	85 f6                	test   %esi,%esi
  802671:	75 e6                	jne    802659 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802673:	89 da                	mov    %ebx,%edx
  802675:	89 f8                	mov    %edi,%eax
  802677:	e8 c8 fe ff ff       	call   802544 <_pipeisclosed>
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 e3                	je     802663 <devpipe_read+0x34>
				return 0;
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	eb d4                	jmp    80265b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802687:	99                   	cltd   
  802688:	c1 ea 1b             	shr    $0x1b,%edx
  80268b:	01 d0                	add    %edx,%eax
  80268d:	83 e0 1f             	and    $0x1f,%eax
  802690:	29 d0                	sub    %edx,%eax
  802692:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802697:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80269a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80269d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8026a0:	83 c6 01             	add    $0x1,%esi
  8026a3:	eb aa                	jmp    80264f <devpipe_read+0x20>

008026a5 <pipe>:
{
  8026a5:	f3 0f 1e fb          	endbr32 
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	56                   	push   %esi
  8026ad:	53                   	push   %ebx
  8026ae:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8026b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b4:	50                   	push   %eax
  8026b5:	e8 04 eb ff ff       	call   8011be <fd_alloc>
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	83 c4 10             	add    $0x10,%esp
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	0f 88 23 01 00 00    	js     8027ea <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 07 04 00 00       	push   $0x407
  8026cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8026d2:	6a 00                	push   $0x0
  8026d4:	e8 82 e8 ff ff       	call   800f5b <sys_page_alloc>
  8026d9:	89 c3                	mov    %eax,%ebx
  8026db:	83 c4 10             	add    $0x10,%esp
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	0f 88 04 01 00 00    	js     8027ea <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026ec:	50                   	push   %eax
  8026ed:	e8 cc ea ff ff       	call   8011be <fd_alloc>
  8026f2:	89 c3                	mov    %eax,%ebx
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	0f 88 db 00 00 00    	js     8027da <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	68 07 04 00 00       	push   $0x407
  802707:	ff 75 f0             	pushl  -0x10(%ebp)
  80270a:	6a 00                	push   $0x0
  80270c:	e8 4a e8 ff ff       	call   800f5b <sys_page_alloc>
  802711:	89 c3                	mov    %eax,%ebx
  802713:	83 c4 10             	add    $0x10,%esp
  802716:	85 c0                	test   %eax,%eax
  802718:	0f 88 bc 00 00 00    	js     8027da <pipe+0x135>
	va = fd2data(fd0);
  80271e:	83 ec 0c             	sub    $0xc,%esp
  802721:	ff 75 f4             	pushl  -0xc(%ebp)
  802724:	e8 7a ea ff ff       	call   8011a3 <fd2data>
  802729:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272b:	83 c4 0c             	add    $0xc,%esp
  80272e:	68 07 04 00 00       	push   $0x407
  802733:	50                   	push   %eax
  802734:	6a 00                	push   $0x0
  802736:	e8 20 e8 ff ff       	call   800f5b <sys_page_alloc>
  80273b:	89 c3                	mov    %eax,%ebx
  80273d:	83 c4 10             	add    $0x10,%esp
  802740:	85 c0                	test   %eax,%eax
  802742:	0f 88 82 00 00 00    	js     8027ca <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802748:	83 ec 0c             	sub    $0xc,%esp
  80274b:	ff 75 f0             	pushl  -0x10(%ebp)
  80274e:	e8 50 ea ff ff       	call   8011a3 <fd2data>
  802753:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80275a:	50                   	push   %eax
  80275b:	6a 00                	push   $0x0
  80275d:	56                   	push   %esi
  80275e:	6a 00                	push   $0x0
  802760:	e8 3d e8 ff ff       	call   800fa2 <sys_page_map>
  802765:	89 c3                	mov    %eax,%ebx
  802767:	83 c4 20             	add    $0x20,%esp
  80276a:	85 c0                	test   %eax,%eax
  80276c:	78 4e                	js     8027bc <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80276e:	a1 c8 57 80 00       	mov    0x8057c8,%eax
  802773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802776:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802785:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	ff 75 f4             	pushl  -0xc(%ebp)
  802797:	e8 f3 e9 ff ff       	call   80118f <fd2num>
  80279c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027a1:	83 c4 04             	add    $0x4,%esp
  8027a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8027a7:	e8 e3 e9 ff ff       	call   80118f <fd2num>
  8027ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027af:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027b2:	83 c4 10             	add    $0x10,%esp
  8027b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027ba:	eb 2e                	jmp    8027ea <pipe+0x145>
	sys_page_unmap(0, va);
  8027bc:	83 ec 08             	sub    $0x8,%esp
  8027bf:	56                   	push   %esi
  8027c0:	6a 00                	push   $0x0
  8027c2:	e8 21 e8 ff ff       	call   800fe8 <sys_page_unmap>
  8027c7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8027ca:	83 ec 08             	sub    $0x8,%esp
  8027cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8027d0:	6a 00                	push   $0x0
  8027d2:	e8 11 e8 ff ff       	call   800fe8 <sys_page_unmap>
  8027d7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8027da:	83 ec 08             	sub    $0x8,%esp
  8027dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e0:	6a 00                	push   $0x0
  8027e2:	e8 01 e8 ff ff       	call   800fe8 <sys_page_unmap>
  8027e7:	83 c4 10             	add    $0x10,%esp
}
  8027ea:	89 d8                	mov    %ebx,%eax
  8027ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    

008027f3 <pipeisclosed>:
{
  8027f3:	f3 0f 1e fb          	endbr32 
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802800:	50                   	push   %eax
  802801:	ff 75 08             	pushl  0x8(%ebp)
  802804:	e8 0b ea ff ff       	call   801214 <fd_lookup>
  802809:	83 c4 10             	add    $0x10,%esp
  80280c:	85 c0                	test   %eax,%eax
  80280e:	78 18                	js     802828 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802810:	83 ec 0c             	sub    $0xc,%esp
  802813:	ff 75 f4             	pushl  -0xc(%ebp)
  802816:	e8 88 e9 ff ff       	call   8011a3 <fd2data>
  80281b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	e8 1f fd ff ff       	call   802544 <_pipeisclosed>
  802825:	83 c4 10             	add    $0x10,%esp
}
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80282a:	f3 0f 1e fb          	endbr32 
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	56                   	push   %esi
  802832:	53                   	push   %ebx
  802833:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802836:	85 f6                	test   %esi,%esi
  802838:	74 13                	je     80284d <wait+0x23>
	e = &envs[ENVX(envid)];
  80283a:	89 f3                	mov    %esi,%ebx
  80283c:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802842:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802845:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80284b:	eb 1b                	jmp    802868 <wait+0x3e>
	assert(envid != 0);
  80284d:	68 a2 32 80 00       	push   $0x8032a2
  802852:	68 83 31 80 00       	push   $0x803183
  802857:	6a 09                	push   $0x9
  802859:	68 ad 32 80 00       	push   $0x8032ad
  80285e:	e8 c5 db ff ff       	call   800428 <_panic>
		sys_yield();
  802863:	e8 d0 e6 ff ff       	call   800f38 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802868:	8b 43 48             	mov    0x48(%ebx),%eax
  80286b:	39 f0                	cmp    %esi,%eax
  80286d:	75 07                	jne    802876 <wait+0x4c>
  80286f:	8b 43 54             	mov    0x54(%ebx),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	75 ed                	jne    802863 <wait+0x39>
}
  802876:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802879:	5b                   	pop    %ebx
  80287a:	5e                   	pop    %esi
  80287b:	5d                   	pop    %ebp
  80287c:	c3                   	ret    

0080287d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80287d:	f3 0f 1e fb          	endbr32 
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
  802884:	56                   	push   %esi
  802885:	53                   	push   %ebx
  802886:	8b 75 08             	mov    0x8(%ebp),%esi
  802889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80288f:	83 e8 01             	sub    $0x1,%eax
  802892:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802897:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80289c:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8028a0:	83 ec 0c             	sub    $0xc,%esp
  8028a3:	50                   	push   %eax
  8028a4:	e8 7e e8 ff ff       	call   801127 <sys_ipc_recv>
	if (!t) {
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	75 2b                	jne    8028db <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8028b0:	85 f6                	test   %esi,%esi
  8028b2:	74 0a                	je     8028be <ipc_recv+0x41>
  8028b4:	a1 90 77 80 00       	mov    0x807790,%eax
  8028b9:	8b 40 74             	mov    0x74(%eax),%eax
  8028bc:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8028be:	85 db                	test   %ebx,%ebx
  8028c0:	74 0a                	je     8028cc <ipc_recv+0x4f>
  8028c2:	a1 90 77 80 00       	mov    0x807790,%eax
  8028c7:	8b 40 78             	mov    0x78(%eax),%eax
  8028ca:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8028cc:	a1 90 77 80 00       	mov    0x807790,%eax
  8028d1:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8028d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028d7:	5b                   	pop    %ebx
  8028d8:	5e                   	pop    %esi
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8028db:	85 f6                	test   %esi,%esi
  8028dd:	74 06                	je     8028e5 <ipc_recv+0x68>
  8028df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8028e5:	85 db                	test   %ebx,%ebx
  8028e7:	74 eb                	je     8028d4 <ipc_recv+0x57>
  8028e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028ef:	eb e3                	jmp    8028d4 <ipc_recv+0x57>

008028f1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028f1:	f3 0f 1e fb          	endbr32 
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	57                   	push   %edi
  8028f9:	56                   	push   %esi
  8028fa:	53                   	push   %ebx
  8028fb:	83 ec 0c             	sub    $0xc,%esp
  8028fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  802901:	8b 75 0c             	mov    0xc(%ebp),%esi
  802904:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802907:	85 db                	test   %ebx,%ebx
  802909:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80290e:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802911:	ff 75 14             	pushl  0x14(%ebp)
  802914:	53                   	push   %ebx
  802915:	56                   	push   %esi
  802916:	57                   	push   %edi
  802917:	e8 e4 e7 ff ff       	call   801100 <sys_ipc_try_send>
  80291c:	83 c4 10             	add    $0x10,%esp
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 1e                	je     802941 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802923:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802926:	75 07                	jne    80292f <ipc_send+0x3e>
		sys_yield();
  802928:	e8 0b e6 ff ff       	call   800f38 <sys_yield>
  80292d:	eb e2                	jmp    802911 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80292f:	50                   	push   %eax
  802930:	68 b8 32 80 00       	push   $0x8032b8
  802935:	6a 39                	push   $0x39
  802937:	68 ca 32 80 00       	push   $0x8032ca
  80293c:	e8 e7 da ff ff       	call   800428 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802941:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802944:	5b                   	pop    %ebx
  802945:	5e                   	pop    %esi
  802946:	5f                   	pop    %edi
  802947:	5d                   	pop    %ebp
  802948:	c3                   	ret    

00802949 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802949:	f3 0f 1e fb          	endbr32 
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802958:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80295b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802961:	8b 52 50             	mov    0x50(%edx),%edx
  802964:	39 ca                	cmp    %ecx,%edx
  802966:	74 11                	je     802979 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802968:	83 c0 01             	add    $0x1,%eax
  80296b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802970:	75 e6                	jne    802958 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	eb 0b                	jmp    802984 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802979:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80297c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802981:	8b 40 48             	mov    0x48(%eax),%eax
}
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    

00802986 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802986:	f3 0f 1e fb          	endbr32 
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802990:	89 c2                	mov    %eax,%edx
  802992:	c1 ea 16             	shr    $0x16,%edx
  802995:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80299c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8029a1:	f6 c1 01             	test   $0x1,%cl
  8029a4:	74 1c                	je     8029c2 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8029a6:	c1 e8 0c             	shr    $0xc,%eax
  8029a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029b0:	a8 01                	test   $0x1,%al
  8029b2:	74 0e                	je     8029c2 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029b4:	c1 e8 0c             	shr    $0xc,%eax
  8029b7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8029be:	ef 
  8029bf:	0f b7 d2             	movzwl %dx,%edx
}
  8029c2:	89 d0                	mov    %edx,%eax
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	66 90                	xchg   %ax,%ax
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__udivdi3>:
  8029d0:	f3 0f 1e fb          	endbr32 
  8029d4:	55                   	push   %ebp
  8029d5:	57                   	push   %edi
  8029d6:	56                   	push   %esi
  8029d7:	53                   	push   %ebx
  8029d8:	83 ec 1c             	sub    $0x1c,%esp
  8029db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8029df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8029e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8029eb:	85 d2                	test   %edx,%edx
  8029ed:	75 19                	jne    802a08 <__udivdi3+0x38>
  8029ef:	39 f3                	cmp    %esi,%ebx
  8029f1:	76 4d                	jbe    802a40 <__udivdi3+0x70>
  8029f3:	31 ff                	xor    %edi,%edi
  8029f5:	89 e8                	mov    %ebp,%eax
  8029f7:	89 f2                	mov    %esi,%edx
  8029f9:	f7 f3                	div    %ebx
  8029fb:	89 fa                	mov    %edi,%edx
  8029fd:	83 c4 1c             	add    $0x1c,%esp
  802a00:	5b                   	pop    %ebx
  802a01:	5e                   	pop    %esi
  802a02:	5f                   	pop    %edi
  802a03:	5d                   	pop    %ebp
  802a04:	c3                   	ret    
  802a05:	8d 76 00             	lea    0x0(%esi),%esi
  802a08:	39 f2                	cmp    %esi,%edx
  802a0a:	76 14                	jbe    802a20 <__udivdi3+0x50>
  802a0c:	31 ff                	xor    %edi,%edi
  802a0e:	31 c0                	xor    %eax,%eax
  802a10:	89 fa                	mov    %edi,%edx
  802a12:	83 c4 1c             	add    $0x1c,%esp
  802a15:	5b                   	pop    %ebx
  802a16:	5e                   	pop    %esi
  802a17:	5f                   	pop    %edi
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    
  802a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a20:	0f bd fa             	bsr    %edx,%edi
  802a23:	83 f7 1f             	xor    $0x1f,%edi
  802a26:	75 48                	jne    802a70 <__udivdi3+0xa0>
  802a28:	39 f2                	cmp    %esi,%edx
  802a2a:	72 06                	jb     802a32 <__udivdi3+0x62>
  802a2c:	31 c0                	xor    %eax,%eax
  802a2e:	39 eb                	cmp    %ebp,%ebx
  802a30:	77 de                	ja     802a10 <__udivdi3+0x40>
  802a32:	b8 01 00 00 00       	mov    $0x1,%eax
  802a37:	eb d7                	jmp    802a10 <__udivdi3+0x40>
  802a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a40:	89 d9                	mov    %ebx,%ecx
  802a42:	85 db                	test   %ebx,%ebx
  802a44:	75 0b                	jne    802a51 <__udivdi3+0x81>
  802a46:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f3                	div    %ebx
  802a4f:	89 c1                	mov    %eax,%ecx
  802a51:	31 d2                	xor    %edx,%edx
  802a53:	89 f0                	mov    %esi,%eax
  802a55:	f7 f1                	div    %ecx
  802a57:	89 c6                	mov    %eax,%esi
  802a59:	89 e8                	mov    %ebp,%eax
  802a5b:	89 f7                	mov    %esi,%edi
  802a5d:	f7 f1                	div    %ecx
  802a5f:	89 fa                	mov    %edi,%edx
  802a61:	83 c4 1c             	add    $0x1c,%esp
  802a64:	5b                   	pop    %ebx
  802a65:	5e                   	pop    %esi
  802a66:	5f                   	pop    %edi
  802a67:	5d                   	pop    %ebp
  802a68:	c3                   	ret    
  802a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	b8 20 00 00 00       	mov    $0x20,%eax
  802a77:	29 f8                	sub    %edi,%eax
  802a79:	d3 e2                	shl    %cl,%edx
  802a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	89 da                	mov    %ebx,%edx
  802a83:	d3 ea                	shr    %cl,%edx
  802a85:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a89:	09 d1                	or     %edx,%ecx
  802a8b:	89 f2                	mov    %esi,%edx
  802a8d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a91:	89 f9                	mov    %edi,%ecx
  802a93:	d3 e3                	shl    %cl,%ebx
  802a95:	89 c1                	mov    %eax,%ecx
  802a97:	d3 ea                	shr    %cl,%edx
  802a99:	89 f9                	mov    %edi,%ecx
  802a9b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a9f:	89 eb                	mov    %ebp,%ebx
  802aa1:	d3 e6                	shl    %cl,%esi
  802aa3:	89 c1                	mov    %eax,%ecx
  802aa5:	d3 eb                	shr    %cl,%ebx
  802aa7:	09 de                	or     %ebx,%esi
  802aa9:	89 f0                	mov    %esi,%eax
  802aab:	f7 74 24 08          	divl   0x8(%esp)
  802aaf:	89 d6                	mov    %edx,%esi
  802ab1:	89 c3                	mov    %eax,%ebx
  802ab3:	f7 64 24 0c          	mull   0xc(%esp)
  802ab7:	39 d6                	cmp    %edx,%esi
  802ab9:	72 15                	jb     802ad0 <__udivdi3+0x100>
  802abb:	89 f9                	mov    %edi,%ecx
  802abd:	d3 e5                	shl    %cl,%ebp
  802abf:	39 c5                	cmp    %eax,%ebp
  802ac1:	73 04                	jae    802ac7 <__udivdi3+0xf7>
  802ac3:	39 d6                	cmp    %edx,%esi
  802ac5:	74 09                	je     802ad0 <__udivdi3+0x100>
  802ac7:	89 d8                	mov    %ebx,%eax
  802ac9:	31 ff                	xor    %edi,%edi
  802acb:	e9 40 ff ff ff       	jmp    802a10 <__udivdi3+0x40>
  802ad0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802ad3:	31 ff                	xor    %edi,%edi
  802ad5:	e9 36 ff ff ff       	jmp    802a10 <__udivdi3+0x40>
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	f3 0f 1e fb          	endbr32 
  802ae4:	55                   	push   %ebp
  802ae5:	57                   	push   %edi
  802ae6:	56                   	push   %esi
  802ae7:	53                   	push   %ebx
  802ae8:	83 ec 1c             	sub    $0x1c,%esp
  802aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802aef:	8b 74 24 30          	mov    0x30(%esp),%esi
  802af3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802afb:	85 c0                	test   %eax,%eax
  802afd:	75 19                	jne    802b18 <__umoddi3+0x38>
  802aff:	39 df                	cmp    %ebx,%edi
  802b01:	76 5d                	jbe    802b60 <__umoddi3+0x80>
  802b03:	89 f0                	mov    %esi,%eax
  802b05:	89 da                	mov    %ebx,%edx
  802b07:	f7 f7                	div    %edi
  802b09:	89 d0                	mov    %edx,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	83 c4 1c             	add    $0x1c,%esp
  802b10:	5b                   	pop    %ebx
  802b11:	5e                   	pop    %esi
  802b12:	5f                   	pop    %edi
  802b13:	5d                   	pop    %ebp
  802b14:	c3                   	ret    
  802b15:	8d 76 00             	lea    0x0(%esi),%esi
  802b18:	89 f2                	mov    %esi,%edx
  802b1a:	39 d8                	cmp    %ebx,%eax
  802b1c:	76 12                	jbe    802b30 <__umoddi3+0x50>
  802b1e:	89 f0                	mov    %esi,%eax
  802b20:	89 da                	mov    %ebx,%edx
  802b22:	83 c4 1c             	add    $0x1c,%esp
  802b25:	5b                   	pop    %ebx
  802b26:	5e                   	pop    %esi
  802b27:	5f                   	pop    %edi
  802b28:	5d                   	pop    %ebp
  802b29:	c3                   	ret    
  802b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b30:	0f bd e8             	bsr    %eax,%ebp
  802b33:	83 f5 1f             	xor    $0x1f,%ebp
  802b36:	75 50                	jne    802b88 <__umoddi3+0xa8>
  802b38:	39 d8                	cmp    %ebx,%eax
  802b3a:	0f 82 e0 00 00 00    	jb     802c20 <__umoddi3+0x140>
  802b40:	89 d9                	mov    %ebx,%ecx
  802b42:	39 f7                	cmp    %esi,%edi
  802b44:	0f 86 d6 00 00 00    	jbe    802c20 <__umoddi3+0x140>
  802b4a:	89 d0                	mov    %edx,%eax
  802b4c:	89 ca                	mov    %ecx,%edx
  802b4e:	83 c4 1c             	add    $0x1c,%esp
  802b51:	5b                   	pop    %ebx
  802b52:	5e                   	pop    %esi
  802b53:	5f                   	pop    %edi
  802b54:	5d                   	pop    %ebp
  802b55:	c3                   	ret    
  802b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	89 fd                	mov    %edi,%ebp
  802b62:	85 ff                	test   %edi,%edi
  802b64:	75 0b                	jne    802b71 <__umoddi3+0x91>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f7                	div    %edi
  802b6f:	89 c5                	mov    %eax,%ebp
  802b71:	89 d8                	mov    %ebx,%eax
  802b73:	31 d2                	xor    %edx,%edx
  802b75:	f7 f5                	div    %ebp
  802b77:	89 f0                	mov    %esi,%eax
  802b79:	f7 f5                	div    %ebp
  802b7b:	89 d0                	mov    %edx,%eax
  802b7d:	31 d2                	xor    %edx,%edx
  802b7f:	eb 8c                	jmp    802b0d <__umoddi3+0x2d>
  802b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 e9                	mov    %ebp,%ecx
  802b8a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b8f:	29 ea                	sub    %ebp,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b97:	89 d1                	mov    %edx,%ecx
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	d3 e8                	shr    %cl,%eax
  802b9d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ba5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ba9:	09 c1                	or     %eax,%ecx
  802bab:	89 d8                	mov    %ebx,%eax
  802bad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bb1:	89 e9                	mov    %ebp,%ecx
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 d1                	mov    %edx,%ecx
  802bb7:	d3 e8                	shr    %cl,%eax
  802bb9:	89 e9                	mov    %ebp,%ecx
  802bbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bbf:	d3 e3                	shl    %cl,%ebx
  802bc1:	89 c7                	mov    %eax,%edi
  802bc3:	89 d1                	mov    %edx,%ecx
  802bc5:	89 f0                	mov    %esi,%eax
  802bc7:	d3 e8                	shr    %cl,%eax
  802bc9:	89 e9                	mov    %ebp,%ecx
  802bcb:	89 fa                	mov    %edi,%edx
  802bcd:	d3 e6                	shl    %cl,%esi
  802bcf:	09 d8                	or     %ebx,%eax
  802bd1:	f7 74 24 08          	divl   0x8(%esp)
  802bd5:	89 d1                	mov    %edx,%ecx
  802bd7:	89 f3                	mov    %esi,%ebx
  802bd9:	f7 64 24 0c          	mull   0xc(%esp)
  802bdd:	89 c6                	mov    %eax,%esi
  802bdf:	89 d7                	mov    %edx,%edi
  802be1:	39 d1                	cmp    %edx,%ecx
  802be3:	72 06                	jb     802beb <__umoddi3+0x10b>
  802be5:	75 10                	jne    802bf7 <__umoddi3+0x117>
  802be7:	39 c3                	cmp    %eax,%ebx
  802be9:	73 0c                	jae    802bf7 <__umoddi3+0x117>
  802beb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802bef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802bf3:	89 d7                	mov    %edx,%edi
  802bf5:	89 c6                	mov    %eax,%esi
  802bf7:	89 ca                	mov    %ecx,%edx
  802bf9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bfe:	29 f3                	sub    %esi,%ebx
  802c00:	19 fa                	sbb    %edi,%edx
  802c02:	89 d0                	mov    %edx,%eax
  802c04:	d3 e0                	shl    %cl,%eax
  802c06:	89 e9                	mov    %ebp,%ecx
  802c08:	d3 eb                	shr    %cl,%ebx
  802c0a:	d3 ea                	shr    %cl,%edx
  802c0c:	09 d8                	or     %ebx,%eax
  802c0e:	83 c4 1c             	add    $0x1c,%esp
  802c11:	5b                   	pop    %ebx
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c1d:	8d 76 00             	lea    0x0(%esi),%esi
  802c20:	29 fe                	sub    %edi,%esi
  802c22:	19 c3                	sbb    %eax,%ebx
  802c24:	89 f2                	mov    %esi,%edx
  802c26:	89 d9                	mov    %ebx,%ecx
  802c28:	e9 1d ff ff ff       	jmp    802b4a <__umoddi3+0x6a>
