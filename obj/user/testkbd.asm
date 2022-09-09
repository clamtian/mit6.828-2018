
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 4d 02 00 00       	call   80027e <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800043:	e8 a2 0e 00 00       	call   800eea <sys_yield>
	for (i = 0; i < 10; ++i)
  800048:	83 eb 01             	sub    $0x1,%ebx
  80004b:	75 f6                	jne    800043 <umain+0x10>

	close(0);
  80004d:	83 ec 0c             	sub    $0xc,%esp
  800050:	6a 00                	push   $0x0
  800052:	e8 ad 12 00 00       	call   801304 <close>
	if ((r = opencons()) < 0)
  800057:	e8 cc 01 00 00       	call   800228 <opencons>
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 14                	js     800077 <umain+0x44>
		panic("opencons: %e", r);
	if (r != 0)
  800063:	74 24                	je     800089 <umain+0x56>
		panic("first opencons used fd %d", r);
  800065:	50                   	push   %eax
  800066:	68 9c 26 80 00       	push   $0x80269c
  80006b:	6a 11                	push   $0x11
  80006d:	68 8d 26 80 00       	push   $0x80268d
  800072:	e8 6f 02 00 00       	call   8002e6 <_panic>
		panic("opencons: %e", r);
  800077:	50                   	push   %eax
  800078:	68 80 26 80 00       	push   $0x802680
  80007d:	6a 0f                	push   $0xf
  80007f:	68 8d 26 80 00       	push   $0x80268d
  800084:	e8 5d 02 00 00       	call   8002e6 <_panic>
	if ((r = dup(0, 1)) < 0)
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	6a 01                	push   $0x1
  80008e:	6a 00                	push   $0x0
  800090:	e8 c9 12 00 00       	call   80135e <dup>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 c0                	test   %eax,%eax
  80009a:	79 25                	jns    8000c1 <umain+0x8e>
		panic("dup: %e", r);
  80009c:	50                   	push   %eax
  80009d:	68 b6 26 80 00       	push   $0x8026b6
  8000a2:	6a 13                	push   $0x13
  8000a4:	68 8d 26 80 00       	push   $0x80268d
  8000a9:	e8 38 02 00 00       	call   8002e6 <_panic>
	for(;;){
		char *buf;

		buf = readline("Type a line: ");
		if (buf != NULL)
			fprintf(1, "%s\n", buf);
  8000ae:	83 ec 04             	sub    $0x4,%esp
  8000b1:	50                   	push   %eax
  8000b2:	68 cc 26 80 00       	push   $0x8026cc
  8000b7:	6a 01                	push   $0x1
  8000b9:	e8 c1 19 00 00       	call   801a7f <fprintf>
  8000be:	83 c4 10             	add    $0x10,%esp
		buf = readline("Type a line: ");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 be 26 80 00       	push   $0x8026be
  8000c9:	e8 c6 08 00 00       	call   800994 <readline>
		if (buf != NULL)
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	85 c0                	test   %eax,%eax
  8000d3:	75 d9                	jne    8000ae <umain+0x7b>
		else
			fprintf(1, "(end of file received)\n");
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	68 d0 26 80 00       	push   $0x8026d0
  8000dd:	6a 01                	push   $0x1
  8000df:	e8 9b 19 00 00       	call   801a7f <fprintf>
  8000e4:	83 c4 10             	add    $0x10,%esp
  8000e7:	eb d8                	jmp    8000c1 <umain+0x8e>

008000e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8000e9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	c3                   	ret    

008000f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8000fd:	68 e8 26 80 00       	push   $0x8026e8
  800102:	ff 75 0c             	pushl  0xc(%ebp)
  800105:	e8 c1 09 00 00       	call   800acb <strcpy>
	return 0;
}
  80010a:	b8 00 00 00 00       	mov    $0x0,%eax
  80010f:	c9                   	leave  
  800110:	c3                   	ret    

00800111 <devcons_write>:
{
  800111:	f3 0f 1e fb          	endbr32 
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	57                   	push   %edi
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800121:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800126:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80012c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80012f:	73 31                	jae    800162 <devcons_write+0x51>
		m = n - tot;
  800131:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800134:	29 f3                	sub    %esi,%ebx
  800136:	83 fb 7f             	cmp    $0x7f,%ebx
  800139:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80013e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800141:	83 ec 04             	sub    $0x4,%esp
  800144:	53                   	push   %ebx
  800145:	89 f0                	mov    %esi,%eax
  800147:	03 45 0c             	add    0xc(%ebp),%eax
  80014a:	50                   	push   %eax
  80014b:	57                   	push   %edi
  80014c:	e8 30 0b 00 00       	call   800c81 <memmove>
		sys_cputs(buf, m);
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	53                   	push   %ebx
  800155:	57                   	push   %edi
  800156:	e8 e2 0c 00 00       	call   800e3d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80015b:	01 de                	add    %ebx,%esi
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	eb ca                	jmp    80012c <devcons_write+0x1b>
}
  800162:	89 f0                	mov    %esi,%eax
  800164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <devcons_read>:
{
  80016c:	f3 0f 1e fb          	endbr32 
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80017b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80017f:	74 21                	je     8001a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800181:	e8 d9 0c 00 00       	call   800e5f <sys_cgetc>
  800186:	85 c0                	test   %eax,%eax
  800188:	75 07                	jne    800191 <devcons_read+0x25>
		sys_yield();
  80018a:	e8 5b 0d 00 00       	call   800eea <sys_yield>
  80018f:	eb f0                	jmp    800181 <devcons_read+0x15>
	if (c < 0)
  800191:	78 0f                	js     8001a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 0c                	je     8001a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  800198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019b:	88 02                	mov    %al,(%edx)
	return 1;
  80019d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001a2:	c9                   	leave  
  8001a3:	c3                   	ret    
		return 0;
  8001a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a9:	eb f7                	jmp    8001a2 <devcons_read+0x36>

008001ab <cputchar>:
{
  8001ab:	f3 0f 1e fb          	endbr32 
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8001b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8001bb:	6a 01                	push   $0x1
  8001bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	e8 77 0c 00 00       	call   800e3d <sys_cputs>
}
  8001c6:	83 c4 10             	add    $0x10,%esp
  8001c9:	c9                   	leave  
  8001ca:	c3                   	ret    

008001cb <getchar>:
{
  8001cb:	f3 0f 1e fb          	endbr32 
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8001d5:	6a 01                	push   $0x1
  8001d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001da:	50                   	push   %eax
  8001db:	6a 00                	push   $0x0
  8001dd:	e8 6c 12 00 00       	call   80144e <read>
	if (r < 0)
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	85 c0                	test   %eax,%eax
  8001e7:	78 06                	js     8001ef <getchar+0x24>
	if (r < 1)
  8001e9:	74 06                	je     8001f1 <getchar+0x26>
	return c;
  8001eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    
		return -E_EOF;
  8001f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8001f6:	eb f7                	jmp    8001ef <getchar+0x24>

008001f8 <iscons>:
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800205:	50                   	push   %eax
  800206:	ff 75 08             	pushl  0x8(%ebp)
  800209:	e8 b8 0f 00 00       	call   8011c6 <fd_lookup>
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	85 c0                	test   %eax,%eax
  800213:	78 11                	js     800226 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  800215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800218:	8b 15 00 30 80 00    	mov    0x803000,%edx
  80021e:	39 10                	cmp    %edx,(%eax)
  800220:	0f 94 c0             	sete   %al
  800223:	0f b6 c0             	movzbl %al,%eax
}
  800226:	c9                   	leave  
  800227:	c3                   	ret    

00800228 <opencons>:
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	e8 35 0f 00 00       	call   801170 <fd_alloc>
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 c0                	test   %eax,%eax
  800240:	78 3a                	js     80027c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 07 04 00 00       	push   $0x407
  80024a:	ff 75 f4             	pushl  -0xc(%ebp)
  80024d:	6a 00                	push   $0x0
  80024f:	e8 b9 0c 00 00       	call   800f0d <sys_page_alloc>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	85 c0                	test   %eax,%eax
  800259:	78 21                	js     80027c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80025b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025e:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800264:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800269:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	50                   	push   %eax
  800274:	e8 c8 0e 00 00       	call   801141 <fd2num>
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80027e:	f3 0f 1e fb          	endbr32 
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	56                   	push   %esi
  800286:	53                   	push   %ebx
  800287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80028a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80028d:	e8 35 0c 00 00       	call   800ec7 <sys_getenvid>
  800292:	25 ff 03 00 00       	and    $0x3ff,%eax
  800297:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80029a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80029f:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	85 db                	test   %ebx,%ebx
  8002a6:	7e 07                	jle    8002af <libmain+0x31>
		binaryname = argv[0];
  8002a8:	8b 06                	mov    (%esi),%eax
  8002aa:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	e8 7a fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8002b9:	e8 0a 00 00 00       	call   8002c8 <exit>
}
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002c4:	5b                   	pop    %ebx
  8002c5:	5e                   	pop    %esi
  8002c6:	5d                   	pop    %ebp
  8002c7:	c3                   	ret    

008002c8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8002d2:	e8 5e 10 00 00       	call   801335 <close_all>
	sys_env_destroy(0);
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	6a 00                	push   $0x0
  8002dc:	e8 a1 0b 00 00       	call   800e82 <sys_env_destroy>
}
  8002e1:	83 c4 10             	add    $0x10,%esp
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002e6:	f3 0f 1e fb          	endbr32 
  8002ea:	55                   	push   %ebp
  8002eb:	89 e5                	mov    %esp,%ebp
  8002ed:	56                   	push   %esi
  8002ee:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8002ef:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002f2:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  8002f8:	e8 ca 0b 00 00       	call   800ec7 <sys_getenvid>
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	ff 75 0c             	pushl  0xc(%ebp)
  800303:	ff 75 08             	pushl  0x8(%ebp)
  800306:	56                   	push   %esi
  800307:	50                   	push   %eax
  800308:	68 00 27 80 00       	push   $0x802700
  80030d:	e8 bb 00 00 00       	call   8003cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800312:	83 c4 18             	add    $0x18,%esp
  800315:	53                   	push   %ebx
  800316:	ff 75 10             	pushl  0x10(%ebp)
  800319:	e8 5a 00 00 00       	call   800378 <vcprintf>
	cprintf("\n");
  80031e:	c7 04 24 e6 26 80 00 	movl   $0x8026e6,(%esp)
  800325:	e8 a3 00 00 00       	call   8003cd <cprintf>
  80032a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80032d:	cc                   	int3   
  80032e:	eb fd                	jmp    80032d <_panic+0x47>

00800330 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800330:	f3 0f 1e fb          	endbr32 
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	53                   	push   %ebx
  800338:	83 ec 04             	sub    $0x4,%esp
  80033b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80033e:	8b 13                	mov    (%ebx),%edx
  800340:	8d 42 01             	lea    0x1(%edx),%eax
  800343:	89 03                	mov    %eax,(%ebx)
  800345:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800348:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80034c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800351:	74 09                	je     80035c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800353:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	68 ff 00 00 00       	push   $0xff
  800364:	8d 43 08             	lea    0x8(%ebx),%eax
  800367:	50                   	push   %eax
  800368:	e8 d0 0a 00 00       	call   800e3d <sys_cputs>
		b->idx = 0;
  80036d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	eb db                	jmp    800353 <putch+0x23>

00800378 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800378:	f3 0f 1e fb          	endbr32 
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800385:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80038c:	00 00 00 
	b.cnt = 0;
  80038f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800396:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	68 30 03 80 00       	push   $0x800330
  8003ab:	e8 20 01 00 00       	call   8004d0 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003b0:	83 c4 08             	add    $0x8,%esp
  8003b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8003b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003bf:	50                   	push   %eax
  8003c0:	e8 78 0a 00 00       	call   800e3d <sys_cputs>

	return b.cnt;
}
  8003c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003cd:	f3 0f 1e fb          	endbr32 
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003da:	50                   	push   %eax
  8003db:	ff 75 08             	pushl  0x8(%ebp)
  8003de:	e8 95 ff ff ff       	call   800378 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003e3:	c9                   	leave  
  8003e4:	c3                   	ret    

008003e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
  8003e8:	57                   	push   %edi
  8003e9:	56                   	push   %esi
  8003ea:	53                   	push   %ebx
  8003eb:	83 ec 1c             	sub    $0x1c,%esp
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	89 d6                	mov    %edx,%esi
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f8:	89 d1                	mov    %edx,%ecx
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800402:	8b 45 10             	mov    0x10(%ebp),%eax
  800405:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800408:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800412:	39 c2                	cmp    %eax,%edx
  800414:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800417:	72 3e                	jb     800457 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	ff 75 18             	pushl  0x18(%ebp)
  80041f:	83 eb 01             	sub    $0x1,%ebx
  800422:	53                   	push   %ebx
  800423:	50                   	push   %eax
  800424:	83 ec 08             	sub    $0x8,%esp
  800427:	ff 75 e4             	pushl  -0x1c(%ebp)
  80042a:	ff 75 e0             	pushl  -0x20(%ebp)
  80042d:	ff 75 dc             	pushl  -0x24(%ebp)
  800430:	ff 75 d8             	pushl  -0x28(%ebp)
  800433:	e8 e8 1f 00 00       	call   802420 <__udivdi3>
  800438:	83 c4 18             	add    $0x18,%esp
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	89 f2                	mov    %esi,%edx
  80043f:	89 f8                	mov    %edi,%eax
  800441:	e8 9f ff ff ff       	call   8003e5 <printnum>
  800446:	83 c4 20             	add    $0x20,%esp
  800449:	eb 13                	jmp    80045e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	56                   	push   %esi
  80044f:	ff 75 18             	pushl  0x18(%ebp)
  800452:	ff d7                	call   *%edi
  800454:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800457:	83 eb 01             	sub    $0x1,%ebx
  80045a:	85 db                	test   %ebx,%ebx
  80045c:	7f ed                	jg     80044b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	56                   	push   %esi
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	ff 75 e4             	pushl  -0x1c(%ebp)
  800468:	ff 75 e0             	pushl  -0x20(%ebp)
  80046b:	ff 75 dc             	pushl  -0x24(%ebp)
  80046e:	ff 75 d8             	pushl  -0x28(%ebp)
  800471:	e8 ba 20 00 00       	call   802530 <__umoddi3>
  800476:	83 c4 14             	add    $0x14,%esp
  800479:	0f be 80 23 27 80 00 	movsbl 0x802723(%eax),%eax
  800480:	50                   	push   %eax
  800481:	ff d7                	call   *%edi
}
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800489:	5b                   	pop    %ebx
  80048a:	5e                   	pop    %esi
  80048b:	5f                   	pop    %edi
  80048c:	5d                   	pop    %ebp
  80048d:	c3                   	ret    

0080048e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80048e:	f3 0f 1e fb          	endbr32 
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800498:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80049c:	8b 10                	mov    (%eax),%edx
  80049e:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a1:	73 0a                	jae    8004ad <sprintputch+0x1f>
		*b->buf++ = ch;
  8004a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004a6:	89 08                	mov    %ecx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	88 02                	mov    %al,(%edx)
}
  8004ad:	5d                   	pop    %ebp
  8004ae:	c3                   	ret    

008004af <printfmt>:
{
  8004af:	f3 0f 1e fb          	endbr32 
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8004b9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004bc:	50                   	push   %eax
  8004bd:	ff 75 10             	pushl  0x10(%ebp)
  8004c0:	ff 75 0c             	pushl  0xc(%ebp)
  8004c3:	ff 75 08             	pushl  0x8(%ebp)
  8004c6:	e8 05 00 00 00       	call   8004d0 <vprintfmt>
}
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <vprintfmt>:
{
  8004d0:	f3 0f 1e fb          	endbr32 
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
  8004d7:	57                   	push   %edi
  8004d8:	56                   	push   %esi
  8004d9:	53                   	push   %ebx
  8004da:	83 ec 3c             	sub    $0x3c,%esp
  8004dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004e3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8004e6:	e9 8e 03 00 00       	jmp    800879 <vprintfmt+0x3a9>
		padc = ' ';
  8004eb:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8004ef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8004f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8004fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800504:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8d 47 01             	lea    0x1(%edi),%eax
  80050c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80050f:	0f b6 17             	movzbl (%edi),%edx
  800512:	8d 42 dd             	lea    -0x23(%edx),%eax
  800515:	3c 55                	cmp    $0x55,%al
  800517:	0f 87 df 03 00 00    	ja     8008fc <vprintfmt+0x42c>
  80051d:	0f b6 c0             	movzbl %al,%eax
  800520:	3e ff 24 85 60 28 80 	notrack jmp *0x802860(,%eax,4)
  800527:	00 
  800528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80052b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80052f:	eb d8                	jmp    800509 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800531:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800534:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800538:	eb cf                	jmp    800509 <vprintfmt+0x39>
  80053a:	0f b6 d2             	movzbl %dl,%edx
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800548:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80054b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80054f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800552:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800555:	83 f9 09             	cmp    $0x9,%ecx
  800558:	77 55                	ja     8005af <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80055a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80055d:	eb e9                	jmp    800548 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 00                	mov    (%eax),%eax
  800564:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800570:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800573:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800577:	79 90                	jns    800509 <vprintfmt+0x39>
				width = precision, precision = -1;
  800579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80057f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800586:	eb 81                	jmp    800509 <vprintfmt+0x39>
  800588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058b:	85 c0                	test   %eax,%eax
  80058d:	ba 00 00 00 00       	mov    $0x0,%edx
  800592:	0f 49 d0             	cmovns %eax,%edx
  800595:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80059b:	e9 69 ff ff ff       	jmp    800509 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005a3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8005aa:	e9 5a ff ff ff       	jmp    800509 <vprintfmt+0x39>
  8005af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	eb bc                	jmp    800573 <vprintfmt+0xa3>
			lflag++;
  8005b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005bd:	e9 47 ff ff ff       	jmp    800509 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 78 04             	lea    0x4(%eax),%edi
  8005c8:	83 ec 08             	sub    $0x8,%esp
  8005cb:	53                   	push   %ebx
  8005cc:	ff 30                	pushl  (%eax)
  8005ce:	ff d6                	call   *%esi
			break;
  8005d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8005d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8005d6:	e9 9b 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 78 04             	lea    0x4(%eax),%edi
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	99                   	cltd   
  8005e4:	31 d0                	xor    %edx,%eax
  8005e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005e8:	83 f8 0f             	cmp    $0xf,%eax
  8005eb:	7f 23                	jg     800610 <vprintfmt+0x140>
  8005ed:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8005f4:	85 d2                	test   %edx,%edx
  8005f6:	74 18                	je     800610 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8005f8:	52                   	push   %edx
  8005f9:	68 05 2b 80 00       	push   $0x802b05
  8005fe:	53                   	push   %ebx
  8005ff:	56                   	push   %esi
  800600:	e8 aa fe ff ff       	call   8004af <printfmt>
  800605:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800608:	89 7d 14             	mov    %edi,0x14(%ebp)
  80060b:	e9 66 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800610:	50                   	push   %eax
  800611:	68 3b 27 80 00       	push   $0x80273b
  800616:	53                   	push   %ebx
  800617:	56                   	push   %esi
  800618:	e8 92 fe ff ff       	call   8004af <printfmt>
  80061d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800620:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800623:	e9 4e 02 00 00       	jmp    800876 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	83 c0 04             	add    $0x4,%eax
  80062e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800636:	85 d2                	test   %edx,%edx
  800638:	b8 34 27 80 00       	mov    $0x802734,%eax
  80063d:	0f 45 c2             	cmovne %edx,%eax
  800640:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800643:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800647:	7e 06                	jle    80064f <vprintfmt+0x17f>
  800649:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80064d:	75 0d                	jne    80065c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800652:	89 c7                	mov    %eax,%edi
  800654:	03 45 e0             	add    -0x20(%ebp),%eax
  800657:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065a:	eb 55                	jmp    8006b1 <vprintfmt+0x1e1>
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 d8             	pushl  -0x28(%ebp)
  800662:	ff 75 cc             	pushl  -0x34(%ebp)
  800665:	e8 3a 04 00 00       	call   800aa4 <strnlen>
  80066a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066d:	29 c2                	sub    %eax,%edx
  80066f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
  800675:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800677:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80067e:	85 ff                	test   %edi,%edi
  800680:	7e 11                	jle    800693 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	ff 75 e0             	pushl  -0x20(%ebp)
  800689:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80068b:	83 ef 01             	sub    $0x1,%edi
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb eb                	jmp    80067e <vprintfmt+0x1ae>
  800693:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800696:	85 d2                	test   %edx,%edx
  800698:	b8 00 00 00 00       	mov    $0x0,%eax
  80069d:	0f 49 c2             	cmovns %edx,%eax
  8006a0:	29 c2                	sub    %eax,%edx
  8006a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8006a5:	eb a8                	jmp    80064f <vprintfmt+0x17f>
					putch(ch, putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	52                   	push   %edx
  8006ac:	ff d6                	call   *%esi
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b6:	83 c7 01             	add    $0x1,%edi
  8006b9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bd:	0f be d0             	movsbl %al,%edx
  8006c0:	85 d2                	test   %edx,%edx
  8006c2:	74 4b                	je     80070f <vprintfmt+0x23f>
  8006c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006c8:	78 06                	js     8006d0 <vprintfmt+0x200>
  8006ca:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8006ce:	78 1e                	js     8006ee <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8006d0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d4:	74 d1                	je     8006a7 <vprintfmt+0x1d7>
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 e8 20             	sub    $0x20,%eax
  8006dc:	83 f8 5e             	cmp    $0x5e,%eax
  8006df:	76 c6                	jbe    8006a7 <vprintfmt+0x1d7>
					putch('?', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 3f                	push   $0x3f
  8006e7:	ff d6                	call   *%esi
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb c3                	jmp    8006b1 <vprintfmt+0x1e1>
  8006ee:	89 cf                	mov    %ecx,%edi
  8006f0:	eb 0e                	jmp    800700 <vprintfmt+0x230>
				putch(' ', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 20                	push   $0x20
  8006f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006fa:	83 ef 01             	sub    $0x1,%edi
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	85 ff                	test   %edi,%edi
  800702:	7f ee                	jg     8006f2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800704:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
  80070a:	e9 67 01 00 00       	jmp    800876 <vprintfmt+0x3a6>
  80070f:	89 cf                	mov    %ecx,%edi
  800711:	eb ed                	jmp    800700 <vprintfmt+0x230>
	if (lflag >= 2)
  800713:	83 f9 01             	cmp    $0x1,%ecx
  800716:	7f 1b                	jg     800733 <vprintfmt+0x263>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	74 63                	je     80077f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	99                   	cltd   
  800725:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	eb 17                	jmp    80074a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8d 40 08             	lea    0x8(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80074a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80074d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800750:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800755:	85 c9                	test   %ecx,%ecx
  800757:	0f 89 ff 00 00 00    	jns    80085c <vprintfmt+0x38c>
				putch('-', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	53                   	push   %ebx
  800761:	6a 2d                	push   $0x2d
  800763:	ff d6                	call   *%esi
				num = -(long long) num;
  800765:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800768:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076b:	f7 da                	neg    %edx
  80076d:	83 d1 00             	adc    $0x0,%ecx
  800770:	f7 d9                	neg    %ecx
  800772:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800775:	b8 0a 00 00 00       	mov    $0xa,%eax
  80077a:	e9 dd 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	99                   	cltd   
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
  800794:	eb b4                	jmp    80074a <vprintfmt+0x27a>
	if (lflag >= 2)
  800796:	83 f9 01             	cmp    $0x1,%ecx
  800799:	7f 1e                	jg     8007b9 <vprintfmt+0x2e9>
	else if (lflag)
  80079b:	85 c9                	test   %ecx,%ecx
  80079d:	74 32                	je     8007d1 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007af:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8007b4:	e9 a3 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 10                	mov    (%eax),%edx
  8007be:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c1:	8d 40 08             	lea    0x8(%eax),%eax
  8007c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007c7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8007cc:	e9 8b 00 00 00       	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 10                	mov    (%eax),%edx
  8007d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007db:	8d 40 04             	lea    0x4(%eax),%eax
  8007de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007e1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8007e6:	eb 74                	jmp    80085c <vprintfmt+0x38c>
	if (lflag >= 2)
  8007e8:	83 f9 01             	cmp    $0x1,%ecx
  8007eb:	7f 1b                	jg     800808 <vprintfmt+0x338>
	else if (lflag)
  8007ed:	85 c9                	test   %ecx,%ecx
  8007ef:	74 2c                	je     80081d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8b 10                	mov    (%eax),%edx
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fb:	8d 40 04             	lea    0x4(%eax),%eax
  8007fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800801:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800806:	eb 54                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800808:	8b 45 14             	mov    0x14(%ebp),%eax
  80080b:	8b 10                	mov    (%eax),%edx
  80080d:	8b 48 04             	mov    0x4(%eax),%ecx
  800810:	8d 40 08             	lea    0x8(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800816:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80081b:	eb 3f                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 10                	mov    (%eax),%edx
  800822:	b9 00 00 00 00       	mov    $0x0,%ecx
  800827:	8d 40 04             	lea    0x4(%eax),%eax
  80082a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80082d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800832:	eb 28                	jmp    80085c <vprintfmt+0x38c>
			putch('0', putdat);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 30                	push   $0x30
  80083a:	ff d6                	call   *%esi
			putch('x', putdat);
  80083c:	83 c4 08             	add    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 78                	push   $0x78
  800842:	ff d6                	call   *%esi
			num = (unsigned long long)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 10                	mov    (%eax),%edx
  800849:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80084e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800851:	8d 40 04             	lea    0x4(%eax),%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800857:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800863:	57                   	push   %edi
  800864:	ff 75 e0             	pushl  -0x20(%ebp)
  800867:	50                   	push   %eax
  800868:	51                   	push   %ecx
  800869:	52                   	push   %edx
  80086a:	89 da                	mov    %ebx,%edx
  80086c:	89 f0                	mov    %esi,%eax
  80086e:	e8 72 fb ff ff       	call   8003e5 <printnum>
			break;
  800873:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800879:	83 c7 01             	add    $0x1,%edi
  80087c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800880:	83 f8 25             	cmp    $0x25,%eax
  800883:	0f 84 62 fc ff ff    	je     8004eb <vprintfmt+0x1b>
			if (ch == '\0')
  800889:	85 c0                	test   %eax,%eax
  80088b:	0f 84 8b 00 00 00    	je     80091c <vprintfmt+0x44c>
			putch(ch, putdat);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	53                   	push   %ebx
  800895:	50                   	push   %eax
  800896:	ff d6                	call   *%esi
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	eb dc                	jmp    800879 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80089d:	83 f9 01             	cmp    $0x1,%ecx
  8008a0:	7f 1b                	jg     8008bd <vprintfmt+0x3ed>
	else if (lflag)
  8008a2:	85 c9                	test   %ecx,%ecx
  8008a4:	74 2c                	je     8008d2 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	8b 10                	mov    (%eax),%edx
  8008ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008b0:	8d 40 04             	lea    0x4(%eax),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8008bb:	eb 9f                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	8b 10                	mov    (%eax),%edx
  8008c2:	8b 48 04             	mov    0x4(%eax),%ecx
  8008c5:	8d 40 08             	lea    0x8(%eax),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8008d0:	eb 8a                	jmp    80085c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8b 10                	mov    (%eax),%edx
  8008d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008dc:	8d 40 04             	lea    0x4(%eax),%eax
  8008df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8008e7:	e9 70 ff ff ff       	jmp    80085c <vprintfmt+0x38c>
			putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	6a 25                	push   $0x25
  8008f2:	ff d6                	call   *%esi
			break;
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	e9 7a ff ff ff       	jmp    800876 <vprintfmt+0x3a6>
			putch('%', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 25                	push   $0x25
  800902:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	89 f8                	mov    %edi,%eax
  800909:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80090d:	74 05                	je     800914 <vprintfmt+0x444>
  80090f:	83 e8 01             	sub    $0x1,%eax
  800912:	eb f5                	jmp    800909 <vprintfmt+0x439>
  800914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800917:	e9 5a ff ff ff       	jmp    800876 <vprintfmt+0x3a6>
}
  80091c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800924:	f3 0f 1e fb          	endbr32 
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	83 ec 18             	sub    $0x18,%esp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800937:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80093b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800945:	85 c0                	test   %eax,%eax
  800947:	74 26                	je     80096f <vsnprintf+0x4b>
  800949:	85 d2                	test   %edx,%edx
  80094b:	7e 22                	jle    80096f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094d:	ff 75 14             	pushl  0x14(%ebp)
  800950:	ff 75 10             	pushl  0x10(%ebp)
  800953:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800956:	50                   	push   %eax
  800957:	68 8e 04 80 00       	push   $0x80048e
  80095c:	e8 6f fb ff ff       	call   8004d0 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800964:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80096a:	83 c4 10             	add    $0x10,%esp
}
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    
		return -E_INVAL;
  80096f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800974:	eb f7                	jmp    80096d <vsnprintf+0x49>

00800976 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800983:	50                   	push   %eax
  800984:	ff 75 10             	pushl  0x10(%ebp)
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	ff 75 08             	pushl  0x8(%ebp)
  80098d:	e8 92 ff ff ff       	call   800924 <vsnprintf>
	va_end(ap);

	return rc;
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800994:	f3 0f 1e fb          	endbr32 
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	57                   	push   %edi
  80099c:	56                   	push   %esi
  80099d:	53                   	push   %ebx
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8009a4:	85 c0                	test   %eax,%eax
  8009a6:	74 13                	je     8009bb <readline+0x27>
		fprintf(1, "%s", prompt);
  8009a8:	83 ec 04             	sub    $0x4,%esp
  8009ab:	50                   	push   %eax
  8009ac:	68 05 2b 80 00       	push   $0x802b05
  8009b1:	6a 01                	push   $0x1
  8009b3:	e8 c7 10 00 00       	call   801a7f <fprintf>
  8009b8:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  8009bb:	83 ec 0c             	sub    $0xc,%esp
  8009be:	6a 00                	push   $0x0
  8009c0:	e8 33 f8 ff ff       	call   8001f8 <iscons>
  8009c5:	89 c7                	mov    %eax,%edi
  8009c7:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8009ca:	be 00 00 00 00       	mov    $0x0,%esi
  8009cf:	eb 57                	jmp    800a28 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  8009d6:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8009d9:	75 08                	jne    8009e3 <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  8009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5f                   	pop    %edi
  8009e1:	5d                   	pop    %ebp
  8009e2:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	53                   	push   %ebx
  8009e7:	68 1f 2a 80 00       	push   $0x802a1f
  8009ec:	e8 dc f9 ff ff       	call   8003cd <cprintf>
  8009f1:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f9:	eb e0                	jmp    8009db <readline+0x47>
			if (echoing)
  8009fb:	85 ff                	test   %edi,%edi
  8009fd:	75 05                	jne    800a04 <readline+0x70>
			i--;
  8009ff:	83 ee 01             	sub    $0x1,%esi
  800a02:	eb 24                	jmp    800a28 <readline+0x94>
				cputchar('\b');
  800a04:	83 ec 0c             	sub    $0xc,%esp
  800a07:	6a 08                	push   $0x8
  800a09:	e8 9d f7 ff ff       	call   8001ab <cputchar>
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb ec                	jmp    8009ff <readline+0x6b>
				cputchar(c);
  800a13:	83 ec 0c             	sub    $0xc,%esp
  800a16:	53                   	push   %ebx
  800a17:	e8 8f f7 ff ff       	call   8001ab <cputchar>
  800a1c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a1f:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800a25:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  800a28:	e8 9e f7 ff ff       	call   8001cb <getchar>
  800a2d:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a2f:	85 c0                	test   %eax,%eax
  800a31:	78 9e                	js     8009d1 <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a33:	83 f8 08             	cmp    $0x8,%eax
  800a36:	0f 94 c2             	sete   %dl
  800a39:	83 f8 7f             	cmp    $0x7f,%eax
  800a3c:	0f 94 c0             	sete   %al
  800a3f:	08 c2                	or     %al,%dl
  800a41:	74 04                	je     800a47 <readline+0xb3>
  800a43:	85 f6                	test   %esi,%esi
  800a45:	7f b4                	jg     8009fb <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a47:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4a:	7e 0e                	jle    800a5a <readline+0xc6>
  800a4c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800a52:	7f 06                	jg     800a5a <readline+0xc6>
			if (echoing)
  800a54:	85 ff                	test   %edi,%edi
  800a56:	74 c7                	je     800a1f <readline+0x8b>
  800a58:	eb b9                	jmp    800a13 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  800a5a:	83 fb 0a             	cmp    $0xa,%ebx
  800a5d:	74 05                	je     800a64 <readline+0xd0>
  800a5f:	83 fb 0d             	cmp    $0xd,%ebx
  800a62:	75 c4                	jne    800a28 <readline+0x94>
			if (echoing)
  800a64:	85 ff                	test   %edi,%edi
  800a66:	75 11                	jne    800a79 <readline+0xe5>
			buf[i] = 0;
  800a68:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800a6f:	b8 00 40 80 00       	mov    $0x804000,%eax
  800a74:	e9 62 ff ff ff       	jmp    8009db <readline+0x47>
				cputchar('\n');
  800a79:	83 ec 0c             	sub    $0xc,%esp
  800a7c:	6a 0a                	push   $0xa
  800a7e:	e8 28 f7 ff ff       	call   8001ab <cputchar>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	eb e0                	jmp    800a68 <readline+0xd4>

00800a88 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a88:	f3 0f 1e fb          	endbr32 
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a92:	b8 00 00 00 00       	mov    $0x0,%eax
  800a97:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a9b:	74 05                	je     800aa2 <strlen+0x1a>
		n++;
  800a9d:	83 c0 01             	add    $0x1,%eax
  800aa0:	eb f5                	jmp    800a97 <strlen+0xf>
	return n;
}
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa4:	f3 0f 1e fb          	endbr32 
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	39 d0                	cmp    %edx,%eax
  800ab8:	74 0d                	je     800ac7 <strnlen+0x23>
  800aba:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800abe:	74 05                	je     800ac5 <strnlen+0x21>
		n++;
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	eb f1                	jmp    800ab6 <strnlen+0x12>
  800ac5:	89 c2                	mov    %eax,%edx
	return n;
}
  800ac7:	89 d0                	mov    %edx,%eax
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800acb:	f3 0f 1e fb          	endbr32 
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	53                   	push   %ebx
  800ad3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800ae2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800ae5:	83 c0 01             	add    $0x1,%eax
  800ae8:	84 d2                	test   %dl,%dl
  800aea:	75 f2                	jne    800ade <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800aec:	89 c8                	mov    %ecx,%eax
  800aee:	5b                   	pop    %ebx
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800af1:	f3 0f 1e fb          	endbr32 
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	53                   	push   %ebx
  800af9:	83 ec 10             	sub    $0x10,%esp
  800afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800aff:	53                   	push   %ebx
  800b00:	e8 83 ff ff ff       	call   800a88 <strlen>
  800b05:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	01 d8                	add    %ebx,%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 b8 ff ff ff       	call   800acb <strcpy>
	return dst;
}
  800b13:	89 d8                	mov    %ebx,%eax
  800b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b1a:	f3 0f 1e fb          	endbr32 
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
  800b23:	8b 75 08             	mov    0x8(%ebp),%esi
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 f3                	mov    %esi,%ebx
  800b2b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b2e:	89 f0                	mov    %esi,%eax
  800b30:	39 d8                	cmp    %ebx,%eax
  800b32:	74 11                	je     800b45 <strncpy+0x2b>
		*dst++ = *src;
  800b34:	83 c0 01             	add    $0x1,%eax
  800b37:	0f b6 0a             	movzbl (%edx),%ecx
  800b3a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b3d:	80 f9 01             	cmp    $0x1,%cl
  800b40:	83 da ff             	sbb    $0xffffffff,%edx
  800b43:	eb eb                	jmp    800b30 <strncpy+0x16>
	}
	return ret;
}
  800b45:	89 f0                	mov    %esi,%eax
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    

00800b4b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b4b:	f3 0f 1e fb          	endbr32 
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	8b 75 08             	mov    0x8(%ebp),%esi
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	8b 55 10             	mov    0x10(%ebp),%edx
  800b5d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b5f:	85 d2                	test   %edx,%edx
  800b61:	74 21                	je     800b84 <strlcpy+0x39>
  800b63:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800b67:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	74 14                	je     800b81 <strlcpy+0x36>
  800b6d:	0f b6 19             	movzbl (%ecx),%ebx
  800b70:	84 db                	test   %bl,%bl
  800b72:	74 0b                	je     800b7f <strlcpy+0x34>
			*dst++ = *src++;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	83 c2 01             	add    $0x1,%edx
  800b7a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b7d:	eb ea                	jmp    800b69 <strlcpy+0x1e>
  800b7f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b81:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b84:	29 f0                	sub    %esi,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b97:	0f b6 01             	movzbl (%ecx),%eax
  800b9a:	84 c0                	test   %al,%al
  800b9c:	74 0c                	je     800baa <strcmp+0x20>
  800b9e:	3a 02                	cmp    (%edx),%al
  800ba0:	75 08                	jne    800baa <strcmp+0x20>
		p++, q++;
  800ba2:	83 c1 01             	add    $0x1,%ecx
  800ba5:	83 c2 01             	add    $0x1,%edx
  800ba8:	eb ed                	jmp    800b97 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800baa:	0f b6 c0             	movzbl %al,%eax
  800bad:	0f b6 12             	movzbl (%edx),%edx
  800bb0:	29 d0                	sub    %edx,%eax
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bb4:	f3 0f 1e fb          	endbr32 
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	53                   	push   %ebx
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc2:	89 c3                	mov    %eax,%ebx
  800bc4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bc7:	eb 06                	jmp    800bcf <strncmp+0x1b>
		n--, p++, q++;
  800bc9:	83 c0 01             	add    $0x1,%eax
  800bcc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800bcf:	39 d8                	cmp    %ebx,%eax
  800bd1:	74 16                	je     800be9 <strncmp+0x35>
  800bd3:	0f b6 08             	movzbl (%eax),%ecx
  800bd6:	84 c9                	test   %cl,%cl
  800bd8:	74 04                	je     800bde <strncmp+0x2a>
  800bda:	3a 0a                	cmp    (%edx),%cl
  800bdc:	74 eb                	je     800bc9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bde:	0f b6 00             	movzbl (%eax),%eax
  800be1:	0f b6 12             	movzbl (%edx),%edx
  800be4:	29 d0                	sub    %edx,%eax
}
  800be6:	5b                   	pop    %ebx
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    
		return 0;
  800be9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bee:	eb f6                	jmp    800be6 <strncmp+0x32>

00800bf0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	84 d2                	test   %dl,%dl
  800c03:	74 09                	je     800c0e <strchr+0x1e>
		if (*s == c)
  800c05:	38 ca                	cmp    %cl,%dl
  800c07:	74 0a                	je     800c13 <strchr+0x23>
	for (; *s; s++)
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	eb f0                	jmp    800bfe <strchr+0xe>
			return (char *) s;
	return 0;
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c23:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800c26:	38 ca                	cmp    %cl,%dl
  800c28:	74 09                	je     800c33 <strfind+0x1e>
  800c2a:	84 d2                	test   %dl,%dl
  800c2c:	74 05                	je     800c33 <strfind+0x1e>
	for (; *s; s++)
  800c2e:	83 c0 01             	add    $0x1,%eax
  800c31:	eb f0                	jmp    800c23 <strfind+0xe>
			break;
	return (char *) s;
}
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c42:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c45:	85 c9                	test   %ecx,%ecx
  800c47:	74 31                	je     800c7a <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c49:	89 f8                	mov    %edi,%eax
  800c4b:	09 c8                	or     %ecx,%eax
  800c4d:	a8 03                	test   $0x3,%al
  800c4f:	75 23                	jne    800c74 <memset+0x3f>
		c &= 0xFF;
  800c51:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c55:	89 d3                	mov    %edx,%ebx
  800c57:	c1 e3 08             	shl    $0x8,%ebx
  800c5a:	89 d0                	mov    %edx,%eax
  800c5c:	c1 e0 18             	shl    $0x18,%eax
  800c5f:	89 d6                	mov    %edx,%esi
  800c61:	c1 e6 10             	shl    $0x10,%esi
  800c64:	09 f0                	or     %esi,%eax
  800c66:	09 c2                	or     %eax,%edx
  800c68:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c6a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c6d:	89 d0                	mov    %edx,%eax
  800c6f:	fc                   	cld    
  800c70:	f3 ab                	rep stos %eax,%es:(%edi)
  800c72:	eb 06                	jmp    800c7a <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	fc                   	cld    
  800c78:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c7a:	89 f8                	mov    %edi,%eax
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c81:	f3 0f 1e fb          	endbr32 
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c93:	39 c6                	cmp    %eax,%esi
  800c95:	73 32                	jae    800cc9 <memmove+0x48>
  800c97:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c9a:	39 c2                	cmp    %eax,%edx
  800c9c:	76 2b                	jbe    800cc9 <memmove+0x48>
		s += n;
		d += n;
  800c9e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ca1:	89 fe                	mov    %edi,%esi
  800ca3:	09 ce                	or     %ecx,%esi
  800ca5:	09 d6                	or     %edx,%esi
  800ca7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cad:	75 0e                	jne    800cbd <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800caf:	83 ef 04             	sub    $0x4,%edi
  800cb2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800cb8:	fd                   	std    
  800cb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cbb:	eb 09                	jmp    800cc6 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cbd:	83 ef 01             	sub    $0x1,%edi
  800cc0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cc3:	fd                   	std    
  800cc4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc6:	fc                   	cld    
  800cc7:	eb 1a                	jmp    800ce3 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	09 ca                	or     %ecx,%edx
  800ccd:	09 f2                	or     %esi,%edx
  800ccf:	f6 c2 03             	test   $0x3,%dl
  800cd2:	75 0a                	jne    800cde <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cd4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cd7:	89 c7                	mov    %eax,%edi
  800cd9:	fc                   	cld    
  800cda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cdc:	eb 05                	jmp    800ce3 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800cde:	89 c7                	mov    %eax,%edi
  800ce0:	fc                   	cld    
  800ce1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ce7:	f3 0f 1e fb          	endbr32 
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf1:	ff 75 10             	pushl  0x10(%ebp)
  800cf4:	ff 75 0c             	pushl  0xc(%ebp)
  800cf7:	ff 75 08             	pushl  0x8(%ebp)
  800cfa:	e8 82 ff ff ff       	call   800c81 <memmove>
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	89 c6                	mov    %eax,%esi
  800d12:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d15:	39 f0                	cmp    %esi,%eax
  800d17:	74 1c                	je     800d35 <memcmp+0x34>
		if (*s1 != *s2)
  800d19:	0f b6 08             	movzbl (%eax),%ecx
  800d1c:	0f b6 1a             	movzbl (%edx),%ebx
  800d1f:	38 d9                	cmp    %bl,%cl
  800d21:	75 08                	jne    800d2b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d23:	83 c0 01             	add    $0x1,%eax
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	eb ea                	jmp    800d15 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800d2b:	0f b6 c1             	movzbl %cl,%eax
  800d2e:	0f b6 db             	movzbl %bl,%ebx
  800d31:	29 d8                	sub    %ebx,%eax
  800d33:	eb 05                	jmp    800d3a <memcmp+0x39>
	}

	return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d3e:	f3 0f 1e fb          	endbr32 
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d4b:	89 c2                	mov    %eax,%edx
  800d4d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d50:	39 d0                	cmp    %edx,%eax
  800d52:	73 09                	jae    800d5d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d54:	38 08                	cmp    %cl,(%eax)
  800d56:	74 05                	je     800d5d <memfind+0x1f>
	for (; s < ends; s++)
  800d58:	83 c0 01             	add    $0x1,%eax
  800d5b:	eb f3                	jmp    800d50 <memfind+0x12>
			break;
	return (void *) s;
}
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5f:	f3 0f 1e fb          	endbr32 
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d6f:	eb 03                	jmp    800d74 <strtol+0x15>
		s++;
  800d71:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800d74:	0f b6 01             	movzbl (%ecx),%eax
  800d77:	3c 20                	cmp    $0x20,%al
  800d79:	74 f6                	je     800d71 <strtol+0x12>
  800d7b:	3c 09                	cmp    $0x9,%al
  800d7d:	74 f2                	je     800d71 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800d7f:	3c 2b                	cmp    $0x2b,%al
  800d81:	74 2a                	je     800dad <strtol+0x4e>
	int neg = 0;
  800d83:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800d88:	3c 2d                	cmp    $0x2d,%al
  800d8a:	74 2b                	je     800db7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800d92:	75 0f                	jne    800da3 <strtol+0x44>
  800d94:	80 39 30             	cmpb   $0x30,(%ecx)
  800d97:	74 28                	je     800dc1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da0:	0f 44 d8             	cmove  %eax,%ebx
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dab:	eb 46                	jmp    800df3 <strtol+0x94>
		s++;
  800dad:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800db0:	bf 00 00 00 00       	mov    $0x0,%edi
  800db5:	eb d5                	jmp    800d8c <strtol+0x2d>
		s++, neg = 1;
  800db7:	83 c1 01             	add    $0x1,%ecx
  800dba:	bf 01 00 00 00       	mov    $0x1,%edi
  800dbf:	eb cb                	jmp    800d8c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dc1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800dc5:	74 0e                	je     800dd5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800dc7:	85 db                	test   %ebx,%ebx
  800dc9:	75 d8                	jne    800da3 <strtol+0x44>
		s++, base = 8;
  800dcb:	83 c1 01             	add    $0x1,%ecx
  800dce:	bb 08 00 00 00       	mov    $0x8,%ebx
  800dd3:	eb ce                	jmp    800da3 <strtol+0x44>
		s += 2, base = 16;
  800dd5:	83 c1 02             	add    $0x2,%ecx
  800dd8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ddd:	eb c4                	jmp    800da3 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ddf:	0f be d2             	movsbl %dl,%edx
  800de2:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de8:	7d 3a                	jge    800e24 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800dea:	83 c1 01             	add    $0x1,%ecx
  800ded:	0f af 45 10          	imul   0x10(%ebp),%eax
  800df1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800df3:	0f b6 11             	movzbl (%ecx),%edx
  800df6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800df9:	89 f3                	mov    %esi,%ebx
  800dfb:	80 fb 09             	cmp    $0x9,%bl
  800dfe:	76 df                	jbe    800ddf <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800e00:	8d 72 9f             	lea    -0x61(%edx),%esi
  800e03:	89 f3                	mov    %esi,%ebx
  800e05:	80 fb 19             	cmp    $0x19,%bl
  800e08:	77 08                	ja     800e12 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800e0a:	0f be d2             	movsbl %dl,%edx
  800e0d:	83 ea 57             	sub    $0x57,%edx
  800e10:	eb d3                	jmp    800de5 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800e12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e15:	89 f3                	mov    %esi,%ebx
  800e17:	80 fb 19             	cmp    $0x19,%bl
  800e1a:	77 08                	ja     800e24 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800e1c:	0f be d2             	movsbl %dl,%edx
  800e1f:	83 ea 37             	sub    $0x37,%edx
  800e22:	eb c1                	jmp    800de5 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e28:	74 05                	je     800e2f <strtol+0xd0>
		*endptr = (char *) s;
  800e2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e2f:	89 c2                	mov    %eax,%edx
  800e31:	f7 da                	neg    %edx
  800e33:	85 ff                	test   %edi,%edi
  800e35:	0f 45 c2             	cmovne %edx,%eax
}
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e47:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	89 c3                	mov    %eax,%ebx
  800e54:	89 c7                	mov    %eax,%edi
  800e56:	89 c6                	mov    %eax,%esi
  800e58:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    

00800e5f <sys_cgetc>:

int
sys_cgetc(void)
{
  800e5f:	f3 0f 1e fb          	endbr32 
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e69:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e73:	89 d1                	mov    %edx,%ecx
  800e75:	89 d3                	mov    %edx,%ebx
  800e77:	89 d7                	mov    %edx,%edi
  800e79:	89 d6                	mov    %edx,%esi
  800e7b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e7d:	5b                   	pop    %ebx
  800e7e:	5e                   	pop    %esi
  800e7f:	5f                   	pop    %edi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e82:	f3 0f 1e fb          	endbr32 
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	b8 03 00 00 00       	mov    $0x3,%eax
  800e9c:	89 cb                	mov    %ecx,%ebx
  800e9e:	89 cf                	mov    %ecx,%edi
  800ea0:	89 ce                	mov    %ecx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 03                	push   $0x3
  800eb6:	68 2f 2a 80 00       	push   $0x802a2f
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 4c 2a 80 00       	push   $0x802a4c
  800ec2:	e8 1f f4 ff ff       	call   8002e6 <_panic>

00800ec7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ec7:	f3 0f 1e fb          	endbr32 
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	57                   	push   %edi
  800ecf:	56                   	push   %esi
  800ed0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed6:	b8 02 00 00 00       	mov    $0x2,%eax
  800edb:	89 d1                	mov    %edx,%ecx
  800edd:	89 d3                	mov    %edx,%ebx
  800edf:	89 d7                	mov    %edx,%edi
  800ee1:	89 d6                	mov    %edx,%esi
  800ee3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_yield>:

void
sys_yield(void)
{
  800eea:	f3 0f 1e fb          	endbr32 
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	57                   	push   %edi
  800ef2:	56                   	push   %esi
  800ef3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800efe:	89 d1                	mov    %edx,%ecx
  800f00:	89 d3                	mov    %edx,%ebx
  800f02:	89 d7                	mov    %edx,%edi
  800f04:	89 d6                	mov    %edx,%esi
  800f06:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f0d:	f3 0f 1e fb          	endbr32 
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	57                   	push   %edi
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
  800f17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1a:	be 00 00 00 00       	mov    $0x0,%esi
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	b8 04 00 00 00       	mov    $0x4,%eax
  800f2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2d:	89 f7                	mov    %esi,%edi
  800f2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7f 08                	jg     800f3d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	83 ec 0c             	sub    $0xc,%esp
  800f40:	50                   	push   %eax
  800f41:	6a 04                	push   $0x4
  800f43:	68 2f 2a 80 00       	push   $0x802a2f
  800f48:	6a 23                	push   $0x23
  800f4a:	68 4c 2a 80 00       	push   $0x802a4c
  800f4f:	e8 92 f3 ff ff       	call   8002e6 <_panic>

00800f54 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f54:	f3 0f 1e fb          	endbr32 
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f67:	b8 05 00 00 00       	mov    $0x5,%eax
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f72:	8b 75 18             	mov    0x18(%ebp),%esi
  800f75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7f 08                	jg     800f83 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7e:	5b                   	pop    %ebx
  800f7f:	5e                   	pop    %esi
  800f80:	5f                   	pop    %edi
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 05                	push   $0x5
  800f89:	68 2f 2a 80 00       	push   $0x802a2f
  800f8e:	6a 23                	push   $0x23
  800f90:	68 4c 2a 80 00       	push   $0x802a4c
  800f95:	e8 4c f3 ff ff       	call   8002e6 <_panic>

00800f9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f9a:	f3 0f 1e fb          	endbr32 
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb7:	89 df                	mov    %ebx,%edi
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7f 08                	jg     800fc9 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	50                   	push   %eax
  800fcd:	6a 06                	push   $0x6
  800fcf:	68 2f 2a 80 00       	push   $0x802a2f
  800fd4:	6a 23                	push   $0x23
  800fd6:	68 4c 2a 80 00       	push   $0x802a4c
  800fdb:	e8 06 f3 ff ff       	call   8002e6 <_panic>

00800fe0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7f 08                	jg     80100f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801007:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100a:	5b                   	pop    %ebx
  80100b:	5e                   	pop    %esi
  80100c:	5f                   	pop    %edi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	50                   	push   %eax
  801013:	6a 08                	push   $0x8
  801015:	68 2f 2a 80 00       	push   $0x802a2f
  80101a:	6a 23                	push   $0x23
  80101c:	68 4c 2a 80 00       	push   $0x802a4c
  801021:	e8 c0 f2 ff ff       	call   8002e6 <_panic>

00801026 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801026:	f3 0f 1e fb          	endbr32 
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103e:	b8 09 00 00 00       	mov    $0x9,%eax
  801043:	89 df                	mov    %ebx,%edi
  801045:	89 de                	mov    %ebx,%esi
  801047:	cd 30                	int    $0x30
	if(check && ret > 0)
  801049:	85 c0                	test   %eax,%eax
  80104b:	7f 08                	jg     801055 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	50                   	push   %eax
  801059:	6a 09                	push   $0x9
  80105b:	68 2f 2a 80 00       	push   $0x802a2f
  801060:	6a 23                	push   $0x23
  801062:	68 4c 2a 80 00       	push   $0x802a4c
  801067:	e8 7a f2 ff ff       	call   8002e6 <_panic>

0080106c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80106c:	f3 0f 1e fb          	endbr32 
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	57                   	push   %edi
  801074:	56                   	push   %esi
  801075:	53                   	push   %ebx
  801076:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	8b 55 08             	mov    0x8(%ebp),%edx
  801081:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801084:	b8 0a 00 00 00       	mov    $0xa,%eax
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	7f 08                	jg     80109b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	50                   	push   %eax
  80109f:	6a 0a                	push   $0xa
  8010a1:	68 2f 2a 80 00       	push   $0x802a2f
  8010a6:	6a 23                	push   $0x23
  8010a8:	68 4c 2a 80 00       	push   $0x802a4c
  8010ad:	e8 34 f2 ff ff       	call   8002e6 <_panic>

008010b2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b2:	f3 0f 1e fb          	endbr32 
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c2:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c7:	be 00 00 00 00       	mov    $0x0,%esi
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d2:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d9:	f3 0f 1e fb          	endbr32 
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010f3:	89 cb                	mov    %ecx,%ebx
  8010f5:	89 cf                	mov    %ecx,%edi
  8010f7:	89 ce                	mov    %ecx,%esi
  8010f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	7f 08                	jg     801107 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801102:	5b                   	pop    %ebx
  801103:	5e                   	pop    %esi
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	50                   	push   %eax
  80110b:	6a 0d                	push   $0xd
  80110d:	68 2f 2a 80 00       	push   $0x802a2f
  801112:	6a 23                	push   $0x23
  801114:	68 4c 2a 80 00       	push   $0x802a4c
  801119:	e8 c8 f1 ff ff       	call   8002e6 <_panic>

0080111e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111e:	f3 0f 1e fb          	endbr32 
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	57                   	push   %edi
  801126:	56                   	push   %esi
  801127:	53                   	push   %ebx
	asm volatile("int %1\n"
  801128:	ba 00 00 00 00       	mov    $0x0,%edx
  80112d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801132:	89 d1                	mov    %edx,%ecx
  801134:	89 d3                	mov    %edx,%ebx
  801136:	89 d7                	mov    %edx,%edi
  801138:	89 d6                	mov    %edx,%esi
  80113a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801141:	f3 0f 1e fb          	endbr32 
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	05 00 00 00 30       	add    $0x30000000,%eax
  801150:	c1 e8 0c             	shr    $0xc,%eax
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    

00801155 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801155:	f3 0f 1e fb          	endbr32 
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801164:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801169:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	c1 ea 16             	shr    $0x16,%edx
  801181:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801188:	f6 c2 01             	test   $0x1,%dl
  80118b:	74 2d                	je     8011ba <fd_alloc+0x4a>
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	c1 ea 0c             	shr    $0xc,%edx
  801192:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801199:	f6 c2 01             	test   $0x1,%dl
  80119c:	74 1c                	je     8011ba <fd_alloc+0x4a>
  80119e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011a3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011a8:	75 d2                	jne    80117c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011b3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011b8:	eb 0a                	jmp    8011c4 <fd_alloc+0x54>
			*fd_store = fd;
  8011ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011c6:	f3 0f 1e fb          	endbr32 
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d0:	83 f8 1f             	cmp    $0x1f,%eax
  8011d3:	77 30                	ja     801205 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d5:	c1 e0 0c             	shl    $0xc,%eax
  8011d8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011dd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011e3:	f6 c2 01             	test   $0x1,%dl
  8011e6:	74 24                	je     80120c <fd_lookup+0x46>
  8011e8:	89 c2                	mov    %eax,%edx
  8011ea:	c1 ea 0c             	shr    $0xc,%edx
  8011ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f4:	f6 c2 01             	test   $0x1,%dl
  8011f7:	74 1a                	je     801213 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fc:	89 02                	mov    %eax,(%edx)
	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    
		return -E_INVAL;
  801205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120a:	eb f7                	jmp    801203 <fd_lookup+0x3d>
		return -E_INVAL;
  80120c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801211:	eb f0                	jmp    801203 <fd_lookup+0x3d>
  801213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801218:	eb e9                	jmp    801203 <fd_lookup+0x3d>

0080121a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80121a:	f3 0f 1e fb          	endbr32 
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801227:	ba 00 00 00 00       	mov    $0x0,%edx
  80122c:	b8 20 30 80 00       	mov    $0x803020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801231:	39 08                	cmp    %ecx,(%eax)
  801233:	74 38                	je     80126d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801235:	83 c2 01             	add    $0x1,%edx
  801238:	8b 04 95 d8 2a 80 00 	mov    0x802ad8(,%edx,4),%eax
  80123f:	85 c0                	test   %eax,%eax
  801241:	75 ee                	jne    801231 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801243:	a1 08 44 80 00       	mov    0x804408,%eax
  801248:	8b 40 48             	mov    0x48(%eax),%eax
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	51                   	push   %ecx
  80124f:	50                   	push   %eax
  801250:	68 5c 2a 80 00       	push   $0x802a5c
  801255:	e8 73 f1 ff ff       	call   8003cd <cprintf>
	*dev = 0;
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
			*dev = devtab[i];
  80126d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801270:	89 01                	mov    %eax,(%ecx)
			return 0;
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
  801277:	eb f2                	jmp    80126b <dev_lookup+0x51>

00801279 <fd_close>:
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 24             	sub    $0x24,%esp
  801286:	8b 75 08             	mov    0x8(%ebp),%esi
  801289:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80128c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80128f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801290:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801296:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801299:	50                   	push   %eax
  80129a:	e8 27 ff ff ff       	call   8011c6 <fd_lookup>
  80129f:	89 c3                	mov    %eax,%ebx
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 05                	js     8012ad <fd_close+0x34>
	    || fd != fd2)
  8012a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012ab:	74 16                	je     8012c3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012ad:	89 f8                	mov    %edi,%eax
  8012af:	84 c0                	test   %al,%al
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b6:	0f 44 d8             	cmove  %eax,%ebx
}
  8012b9:	89 d8                	mov    %ebx,%eax
  8012bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012be:	5b                   	pop    %ebx
  8012bf:	5e                   	pop    %esi
  8012c0:	5f                   	pop    %edi
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 36                	pushl  (%esi)
  8012cc:	e8 49 ff ff ff       	call   80121a <dev_lookup>
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 1a                	js     8012f4 <fd_close+0x7b>
		if (dev->dev_close)
  8012da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012dd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	74 0b                	je     8012f4 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	56                   	push   %esi
  8012ed:	ff d0                	call   *%eax
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	56                   	push   %esi
  8012f8:	6a 00                	push   $0x0
  8012fa:	e8 9b fc ff ff       	call   800f9a <sys_page_unmap>
	return r;
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	eb b5                	jmp    8012b9 <fd_close+0x40>

00801304 <close>:

int
close(int fdnum)
{
  801304:	f3 0f 1e fb          	endbr32 
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80130e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	ff 75 08             	pushl  0x8(%ebp)
  801315:	e8 ac fe ff ff       	call   8011c6 <fd_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	79 02                	jns    801323 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    
		return fd_close(fd, 1);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	6a 01                	push   $0x1
  801328:	ff 75 f4             	pushl  -0xc(%ebp)
  80132b:	e8 49 ff ff ff       	call   801279 <fd_close>
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	eb ec                	jmp    801321 <close+0x1d>

00801335 <close_all>:

void
close_all(void)
{
  801335:	f3 0f 1e fb          	endbr32 
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	53                   	push   %ebx
  80133d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801340:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801345:	83 ec 0c             	sub    $0xc,%esp
  801348:	53                   	push   %ebx
  801349:	e8 b6 ff ff ff       	call   801304 <close>
	for (i = 0; i < MAXFD; i++)
  80134e:	83 c3 01             	add    $0x1,%ebx
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	83 fb 20             	cmp    $0x20,%ebx
  801357:	75 ec                	jne    801345 <close_all+0x10>
}
  801359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80135e:	f3 0f 1e fb          	endbr32 
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	57                   	push   %edi
  801366:	56                   	push   %esi
  801367:	53                   	push   %ebx
  801368:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80136b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	ff 75 08             	pushl  0x8(%ebp)
  801372:	e8 4f fe ff ff       	call   8011c6 <fd_lookup>
  801377:	89 c3                	mov    %eax,%ebx
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	0f 88 81 00 00 00    	js     801405 <dup+0xa7>
		return r;
	close(newfdnum);
  801384:	83 ec 0c             	sub    $0xc,%esp
  801387:	ff 75 0c             	pushl  0xc(%ebp)
  80138a:	e8 75 ff ff ff       	call   801304 <close>

	newfd = INDEX2FD(newfdnum);
  80138f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801392:	c1 e6 0c             	shl    $0xc,%esi
  801395:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80139b:	83 c4 04             	add    $0x4,%esp
  80139e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013a1:	e8 af fd ff ff       	call   801155 <fd2data>
  8013a6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013a8:	89 34 24             	mov    %esi,(%esp)
  8013ab:	e8 a5 fd ff ff       	call   801155 <fd2data>
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013b5:	89 d8                	mov    %ebx,%eax
  8013b7:	c1 e8 16             	shr    $0x16,%eax
  8013ba:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c1:	a8 01                	test   $0x1,%al
  8013c3:	74 11                	je     8013d6 <dup+0x78>
  8013c5:	89 d8                	mov    %ebx,%eax
  8013c7:	c1 e8 0c             	shr    $0xc,%eax
  8013ca:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d1:	f6 c2 01             	test   $0x1,%dl
  8013d4:	75 39                	jne    80140f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013d9:	89 d0                	mov    %edx,%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
  8013de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ed:	50                   	push   %eax
  8013ee:	56                   	push   %esi
  8013ef:	6a 00                	push   $0x0
  8013f1:	52                   	push   %edx
  8013f2:	6a 00                	push   $0x0
  8013f4:	e8 5b fb ff ff       	call   800f54 <sys_page_map>
  8013f9:	89 c3                	mov    %eax,%ebx
  8013fb:	83 c4 20             	add    $0x20,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 31                	js     801433 <dup+0xd5>
		goto err;

	return newfdnum;
  801402:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801405:	89 d8                	mov    %ebx,%eax
  801407:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140a:	5b                   	pop    %ebx
  80140b:	5e                   	pop    %esi
  80140c:	5f                   	pop    %edi
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80140f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	25 07 0e 00 00       	and    $0xe07,%eax
  80141e:	50                   	push   %eax
  80141f:	57                   	push   %edi
  801420:	6a 00                	push   $0x0
  801422:	53                   	push   %ebx
  801423:	6a 00                	push   $0x0
  801425:	e8 2a fb ff ff       	call   800f54 <sys_page_map>
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	83 c4 20             	add    $0x20,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	79 a3                	jns    8013d6 <dup+0x78>
	sys_page_unmap(0, newfd);
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	56                   	push   %esi
  801437:	6a 00                	push   $0x0
  801439:	e8 5c fb ff ff       	call   800f9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	57                   	push   %edi
  801442:	6a 00                	push   $0x0
  801444:	e8 51 fb ff ff       	call   800f9a <sys_page_unmap>
	return r;
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	eb b7                	jmp    801405 <dup+0xa7>

0080144e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80144e:	f3 0f 1e fb          	endbr32 
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	53                   	push   %ebx
  801456:	83 ec 1c             	sub    $0x1c,%esp
  801459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	53                   	push   %ebx
  801461:	e8 60 fd ff ff       	call   8011c6 <fd_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 3f                	js     8014ac <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	ff 30                	pushl  (%eax)
  801479:	e8 9c fd ff ff       	call   80121a <dev_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 27                	js     8014ac <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801485:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801488:	8b 42 08             	mov    0x8(%edx),%eax
  80148b:	83 e0 03             	and    $0x3,%eax
  80148e:	83 f8 01             	cmp    $0x1,%eax
  801491:	74 1e                	je     8014b1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801496:	8b 40 08             	mov    0x8(%eax),%eax
  801499:	85 c0                	test   %eax,%eax
  80149b:	74 35                	je     8014d2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	ff 75 10             	pushl  0x10(%ebp)
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	52                   	push   %edx
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b1:	a1 08 44 80 00       	mov    0x804408,%eax
  8014b6:	8b 40 48             	mov    0x48(%eax),%eax
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	53                   	push   %ebx
  8014bd:	50                   	push   %eax
  8014be:	68 9d 2a 80 00       	push   $0x802a9d
  8014c3:	e8 05 ef ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d0:	eb da                	jmp    8014ac <read+0x5e>
		return -E_NOT_SUPP;
  8014d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d7:	eb d3                	jmp    8014ac <read+0x5e>

008014d9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014d9:	f3 0f 1e fb          	endbr32 
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	57                   	push   %edi
  8014e1:	56                   	push   %esi
  8014e2:	53                   	push   %ebx
  8014e3:	83 ec 0c             	sub    $0xc,%esp
  8014e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f1:	eb 02                	jmp    8014f5 <readn+0x1c>
  8014f3:	01 c3                	add    %eax,%ebx
  8014f5:	39 f3                	cmp    %esi,%ebx
  8014f7:	73 21                	jae    80151a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f9:	83 ec 04             	sub    $0x4,%esp
  8014fc:	89 f0                	mov    %esi,%eax
  8014fe:	29 d8                	sub    %ebx,%eax
  801500:	50                   	push   %eax
  801501:	89 d8                	mov    %ebx,%eax
  801503:	03 45 0c             	add    0xc(%ebp),%eax
  801506:	50                   	push   %eax
  801507:	57                   	push   %edi
  801508:	e8 41 ff ff ff       	call   80144e <read>
		if (m < 0)
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 04                	js     801518 <readn+0x3f>
			return m;
		if (m == 0)
  801514:	75 dd                	jne    8014f3 <readn+0x1a>
  801516:	eb 02                	jmp    80151a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801518:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80151a:	89 d8                	mov    %ebx,%eax
  80151c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5f                   	pop    %edi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	53                   	push   %ebx
  80152c:	83 ec 1c             	sub    $0x1c,%esp
  80152f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801532:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	53                   	push   %ebx
  801537:	e8 8a fc ff ff       	call   8011c6 <fd_lookup>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 3a                	js     80157d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801549:	50                   	push   %eax
  80154a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154d:	ff 30                	pushl  (%eax)
  80154f:	e8 c6 fc ff ff       	call   80121a <dev_lookup>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	78 22                	js     80157d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801562:	74 1e                	je     801582 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801567:	8b 52 0c             	mov    0xc(%edx),%edx
  80156a:	85 d2                	test   %edx,%edx
  80156c:	74 35                	je     8015a3 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	ff 75 10             	pushl  0x10(%ebp)
  801574:	ff 75 0c             	pushl  0xc(%ebp)
  801577:	50                   	push   %eax
  801578:	ff d2                	call   *%edx
  80157a:	83 c4 10             	add    $0x10,%esp
}
  80157d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801580:	c9                   	leave  
  801581:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801582:	a1 08 44 80 00       	mov    0x804408,%eax
  801587:	8b 40 48             	mov    0x48(%eax),%eax
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	53                   	push   %ebx
  80158e:	50                   	push   %eax
  80158f:	68 b9 2a 80 00       	push   $0x802ab9
  801594:	e8 34 ee ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a1:	eb da                	jmp    80157d <write+0x59>
		return -E_NOT_SUPP;
  8015a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a8:	eb d3                	jmp    80157d <write+0x59>

008015aa <seek>:

int
seek(int fdnum, off_t offset)
{
  8015aa:	f3 0f 1e fb          	endbr32 
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	e8 06 fc ff ff       	call   8011c6 <fd_lookup>
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 0e                	js     8015d5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8015c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d7:	f3 0f 1e fb          	endbr32 
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 1c             	sub    $0x1c,%esp
  8015e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	53                   	push   %ebx
  8015ea:	e8 d7 fb ff ff       	call   8011c6 <fd_lookup>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 37                	js     80162d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801600:	ff 30                	pushl  (%eax)
  801602:	e8 13 fc ff ff       	call   80121a <dev_lookup>
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 1f                	js     80162d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801615:	74 1b                	je     801632 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161a:	8b 52 18             	mov    0x18(%edx),%edx
  80161d:	85 d2                	test   %edx,%edx
  80161f:	74 32                	je     801653 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	50                   	push   %eax
  801628:	ff d2                	call   *%edx
  80162a:	83 c4 10             	add    $0x10,%esp
}
  80162d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801630:	c9                   	leave  
  801631:	c3                   	ret    
			thisenv->env_id, fdnum);
  801632:	a1 08 44 80 00       	mov    0x804408,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801637:	8b 40 48             	mov    0x48(%eax),%eax
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	53                   	push   %ebx
  80163e:	50                   	push   %eax
  80163f:	68 7c 2a 80 00       	push   $0x802a7c
  801644:	e8 84 ed ff ff       	call   8003cd <cprintf>
		return -E_INVAL;
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801651:	eb da                	jmp    80162d <ftruncate+0x56>
		return -E_NOT_SUPP;
  801653:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801658:	eb d3                	jmp    80162d <ftruncate+0x56>

0080165a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80165a:	f3 0f 1e fb          	endbr32 
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	53                   	push   %ebx
  801662:	83 ec 1c             	sub    $0x1c,%esp
  801665:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801668:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	e8 52 fb ff ff       	call   8011c6 <fd_lookup>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	85 c0                	test   %eax,%eax
  801679:	78 4b                	js     8016c6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	ff 30                	pushl  (%eax)
  801687:	e8 8e fb ff ff       	call   80121a <dev_lookup>
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 33                	js     8016c6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801696:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80169a:	74 2f                	je     8016cb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80169c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a6:	00 00 00 
	stat->st_isdir = 0;
  8016a9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b0:	00 00 00 
	stat->st_dev = dev;
  8016b3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	53                   	push   %ebx
  8016bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c0:	ff 50 14             	call   *0x14(%eax)
  8016c3:	83 c4 10             	add    $0x10,%esp
}
  8016c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    
		return -E_NOT_SUPP;
  8016cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d0:	eb f4                	jmp    8016c6 <fstat+0x6c>

008016d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d2:	f3 0f 1e fb          	endbr32 
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	56                   	push   %esi
  8016da:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	6a 00                	push   $0x0
  8016e0:	ff 75 08             	pushl  0x8(%ebp)
  8016e3:	e8 fb 01 00 00       	call   8018e3 <open>
  8016e8:	89 c3                	mov    %eax,%ebx
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 1b                	js     80170c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	50                   	push   %eax
  8016f8:	e8 5d ff ff ff       	call   80165a <fstat>
  8016fd:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ff:	89 1c 24             	mov    %ebx,(%esp)
  801702:	e8 fd fb ff ff       	call   801304 <close>
	return r;
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	89 f3                	mov    %esi,%ebx
}
  80170c:	89 d8                	mov    %ebx,%eax
  80170e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801711:	5b                   	pop    %ebx
  801712:	5e                   	pop    %esi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	56                   	push   %esi
  801719:	53                   	push   %ebx
  80171a:	89 c6                	mov    %eax,%esi
  80171c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171e:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801725:	74 27                	je     80174e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801727:	6a 07                	push   $0x7
  801729:	68 00 50 80 00       	push   $0x805000
  80172e:	56                   	push   %esi
  80172f:	ff 35 00 44 80 00    	pushl  0x804400
  801735:	e8 0c 0c 00 00       	call   802346 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173a:	83 c4 0c             	add    $0xc,%esp
  80173d:	6a 00                	push   $0x0
  80173f:	53                   	push   %ebx
  801740:	6a 00                	push   $0x0
  801742:	e8 8b 0b 00 00       	call   8022d2 <ipc_recv>
}
  801747:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80174e:	83 ec 0c             	sub    $0xc,%esp
  801751:	6a 01                	push   $0x1
  801753:	e8 46 0c 00 00       	call   80239e <ipc_find_env>
  801758:	a3 00 44 80 00       	mov    %eax,0x804400
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	eb c5                	jmp    801727 <fsipc+0x12>

00801762 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801762:	f3 0f 1e fb          	endbr32 
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8b 40 0c             	mov    0xc(%eax),%eax
  801772:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	b8 02 00 00 00       	mov    $0x2,%eax
  801789:	e8 87 ff ff ff       	call   801715 <fsipc>
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <devfile_flush>:
{
  801790:	f3 0f 1e fb          	endbr32 
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	b8 06 00 00 00       	mov    $0x6,%eax
  8017af:	e8 61 ff ff ff       	call   801715 <fsipc>
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <devfile_stat>:
{
  8017b6:	f3 0f 1e fb          	endbr32 
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	53                   	push   %ebx
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ca:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d9:	e8 37 ff ff ff       	call   801715 <fsipc>
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 2c                	js     80180e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017e2:	83 ec 08             	sub    $0x8,%esp
  8017e5:	68 00 50 80 00       	push   $0x805000
  8017ea:	53                   	push   %ebx
  8017eb:	e8 db f2 ff ff       	call   800acb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017f0:	a1 80 50 80 00       	mov    0x805080,%eax
  8017f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017fb:	a1 84 50 80 00       	mov    0x805084,%eax
  801800:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <devfile_write>:
{
  801813:	f3 0f 1e fb          	endbr32 
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 0c             	sub    $0xc,%esp
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801820:	8b 55 08             	mov    0x8(%ebp),%edx
  801823:	8b 52 0c             	mov    0xc(%edx),%edx
  801826:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80182c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801831:	ba 00 10 00 00       	mov    $0x1000,%edx
  801836:	0f 47 c2             	cmova  %edx,%eax
  801839:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80183e:	50                   	push   %eax
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	68 08 50 80 00       	push   $0x805008
  801847:	e8 35 f4 ff ff       	call   800c81 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80184c:	ba 00 00 00 00       	mov    $0x0,%edx
  801851:	b8 04 00 00 00       	mov    $0x4,%eax
  801856:	e8 ba fe ff ff       	call   801715 <fsipc>
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <devfile_read>:
{
  80185d:	f3 0f 1e fb          	endbr32 
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8b 40 0c             	mov    0xc(%eax),%eax
  80186f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801874:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	b8 03 00 00 00       	mov    $0x3,%eax
  801884:	e8 8c fe ff ff       	call   801715 <fsipc>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 1f                	js     8018ae <devfile_read+0x51>
	assert(r <= n);
  80188f:	39 f0                	cmp    %esi,%eax
  801891:	77 24                	ja     8018b7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801893:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801898:	7f 33                	jg     8018cd <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	50                   	push   %eax
  80189e:	68 00 50 80 00       	push   $0x805000
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	e8 d6 f3 ff ff       	call   800c81 <memmove>
	return r;
  8018ab:	83 c4 10             	add    $0x10,%esp
}
  8018ae:	89 d8                	mov    %ebx,%eax
  8018b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    
	assert(r <= n);
  8018b7:	68 ec 2a 80 00       	push   $0x802aec
  8018bc:	68 f3 2a 80 00       	push   $0x802af3
  8018c1:	6a 7c                	push   $0x7c
  8018c3:	68 08 2b 80 00       	push   $0x802b08
  8018c8:	e8 19 ea ff ff       	call   8002e6 <_panic>
	assert(r <= PGSIZE);
  8018cd:	68 13 2b 80 00       	push   $0x802b13
  8018d2:	68 f3 2a 80 00       	push   $0x802af3
  8018d7:	6a 7d                	push   $0x7d
  8018d9:	68 08 2b 80 00       	push   $0x802b08
  8018de:	e8 03 ea ff ff       	call   8002e6 <_panic>

008018e3 <open>:
{
  8018e3:	f3 0f 1e fb          	endbr32 
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 1c             	sub    $0x1c,%esp
  8018ef:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018f2:	56                   	push   %esi
  8018f3:	e8 90 f1 ff ff       	call   800a88 <strlen>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801900:	7f 6c                	jg     80196e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801908:	50                   	push   %eax
  801909:	e8 62 f8 ff ff       	call   801170 <fd_alloc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	78 3c                	js     801953 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801917:	83 ec 08             	sub    $0x8,%esp
  80191a:	56                   	push   %esi
  80191b:	68 00 50 80 00       	push   $0x805000
  801920:	e8 a6 f1 ff ff       	call   800acb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801925:	8b 45 0c             	mov    0xc(%ebp),%eax
  801928:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	b8 01 00 00 00       	mov    $0x1,%eax
  801935:	e8 db fd ff ff       	call   801715 <fsipc>
  80193a:	89 c3                	mov    %eax,%ebx
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 19                	js     80195c <open+0x79>
	return fd2num(fd);
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	ff 75 f4             	pushl  -0xc(%ebp)
  801949:	e8 f3 f7 ff ff       	call   801141 <fd2num>
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	83 c4 10             	add    $0x10,%esp
}
  801953:	89 d8                	mov    %ebx,%eax
  801955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    
		fd_close(fd, 0);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 f4             	pushl  -0xc(%ebp)
  801964:	e8 10 f9 ff ff       	call   801279 <fd_close>
		return r;
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	eb e5                	jmp    801953 <open+0x70>
		return -E_BAD_PATH;
  80196e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801973:	eb de                	jmp    801953 <open+0x70>

00801975 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801975:	f3 0f 1e fb          	endbr32 
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80197f:	ba 00 00 00 00       	mov    $0x0,%edx
  801984:	b8 08 00 00 00       	mov    $0x8,%eax
  801989:	e8 87 fd ff ff       	call   801715 <fsipc>
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801990:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801994:	7f 01                	jg     801997 <writebuf+0x7>
  801996:	c3                   	ret    
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 08             	sub    $0x8,%esp
  80199e:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019a0:	ff 70 04             	pushl  0x4(%eax)
  8019a3:	8d 40 10             	lea    0x10(%eax),%eax
  8019a6:	50                   	push   %eax
  8019a7:	ff 33                	pushl  (%ebx)
  8019a9:	e8 76 fb ff ff       	call   801524 <write>
		if (result > 0)
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	7e 03                	jle    8019b8 <writebuf+0x28>
			b->result += result;
  8019b5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019b8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019bb:	74 0d                	je     8019ca <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c4:	0f 4f c2             	cmovg  %edx,%eax
  8019c7:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <putch>:

static void
putch(int ch, void *thunk)
{
  8019cf:	f3 0f 1e fb          	endbr32 
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019dd:	8b 53 04             	mov    0x4(%ebx),%edx
  8019e0:	8d 42 01             	lea    0x1(%edx),%eax
  8019e3:	89 43 04             	mov    %eax,0x4(%ebx)
  8019e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019e9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ed:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019f2:	74 06                	je     8019fa <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8019f4:	83 c4 04             	add    $0x4,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    
		writebuf(b);
  8019fa:	89 d8                	mov    %ebx,%eax
  8019fc:	e8 8f ff ff ff       	call   801990 <writebuf>
		b->idx = 0;
  801a01:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801a08:	eb ea                	jmp    8019f4 <putch+0x25>

00801a0a <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a0a:	f3 0f 1e fb          	endbr32 
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a20:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a27:	00 00 00 
	b.result = 0;
  801a2a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a31:	00 00 00 
	b.error = 1;
  801a34:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a3b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a3e:	ff 75 10             	pushl  0x10(%ebp)
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a4a:	50                   	push   %eax
  801a4b:	68 cf 19 80 00       	push   $0x8019cf
  801a50:	e8 7b ea ff ff       	call   8004d0 <vprintfmt>
	if (b.idx > 0)
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a5f:	7f 11                	jg     801a72 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801a61:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    
		writebuf(&b);
  801a72:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a78:	e8 13 ff ff ff       	call   801990 <writebuf>
  801a7d:	eb e2                	jmp    801a61 <vfprintf+0x57>

00801a7f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a7f:	f3 0f 1e fb          	endbr32 
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a89:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a8c:	50                   	push   %eax
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	e8 72 ff ff ff       	call   801a0a <vfprintf>
	va_end(ap);

	return cnt;
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <printf>:

int
printf(const char *fmt, ...)
{
  801a9a:	f3 0f 1e fb          	endbr32 
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aa4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aa7:	50                   	push   %eax
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	6a 01                	push   $0x1
  801aad:	e8 58 ff ff ff       	call   801a0a <vfprintf>
	va_end(ap);

	return cnt;
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab4:	f3 0f 1e fb          	endbr32 
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801abe:	68 1f 2b 80 00       	push   $0x802b1f
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	e8 00 f0 ff ff       	call   800acb <strcpy>
	return 0;
}
  801acb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <devsock_close>:
{
  801ad2:	f3 0f 1e fb          	endbr32 
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 10             	sub    $0x10,%esp
  801add:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ae0:	53                   	push   %ebx
  801ae1:	e8 f5 08 00 00       	call   8023db <pageref>
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801aeb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801af0:	83 fa 01             	cmp    $0x1,%edx
  801af3:	74 05                	je     801afa <devsock_close+0x28>
}
  801af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801afa:	83 ec 0c             	sub    $0xc,%esp
  801afd:	ff 73 0c             	pushl  0xc(%ebx)
  801b00:	e8 e3 02 00 00       	call   801de8 <nsipc_close>
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	eb eb                	jmp    801af5 <devsock_close+0x23>

00801b0a <devsock_write>:
{
  801b0a:	f3 0f 1e fb          	endbr32 
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	ff 70 0c             	pushl  0xc(%eax)
  801b22:	e8 b5 03 00 00       	call   801edc <nsipc_send>
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <devsock_read>:
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	ff 75 10             	pushl  0x10(%ebp)
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	ff 70 0c             	pushl  0xc(%eax)
  801b41:	e8 1f 03 00 00       	call   801e65 <nsipc_recv>
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <fd2sockid>:
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b4e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	e8 6e f6 ff ff       	call   8011c6 <fd_lookup>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 10                	js     801b6f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801b68:	39 08                	cmp    %ecx,(%eax)
  801b6a:	75 05                	jne    801b71 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    
		return -E_NOT_SUPP;
  801b71:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b76:	eb f7                	jmp    801b6f <fd2sockid+0x27>

00801b78 <alloc_sockfd>:
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	56                   	push   %esi
  801b7c:	53                   	push   %ebx
  801b7d:	83 ec 1c             	sub    $0x1c,%esp
  801b80:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b85:	50                   	push   %eax
  801b86:	e8 e5 f5 ff ff       	call   801170 <fd_alloc>
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	85 c0                	test   %eax,%eax
  801b92:	78 43                	js     801bd7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	68 07 04 00 00       	push   $0x407
  801b9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b9f:	6a 00                	push   $0x0
  801ba1:	e8 67 f3 ff ff       	call   800f0d <sys_page_alloc>
  801ba6:	89 c3                	mov    %eax,%ebx
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	85 c0                	test   %eax,%eax
  801bad:	78 28                	js     801bd7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801bb8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bc4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	50                   	push   %eax
  801bcb:	e8 71 f5 ff ff       	call   801141 <fd2num>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	eb 0c                	jmp    801be3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	56                   	push   %esi
  801bdb:	e8 08 02 00 00       	call   801de8 <nsipc_close>
		return r;
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    

00801bec <accept>:
{
  801bec:	f3 0f 1e fb          	endbr32 
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	e8 4a ff ff ff       	call   801b48 <fd2sockid>
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 1b                	js     801c1d <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	ff 75 10             	pushl  0x10(%ebp)
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	50                   	push   %eax
  801c0c:	e8 22 01 00 00       	call   801d33 <nsipc_accept>
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 05                	js     801c1d <accept+0x31>
	return alloc_sockfd(r);
  801c18:	e8 5b ff ff ff       	call   801b78 <alloc_sockfd>
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <bind>:
{
  801c1f:	f3 0f 1e fb          	endbr32 
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	e8 17 ff ff ff       	call   801b48 <fd2sockid>
  801c31:	85 c0                	test   %eax,%eax
  801c33:	78 12                	js     801c47 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801c35:	83 ec 04             	sub    $0x4,%esp
  801c38:	ff 75 10             	pushl  0x10(%ebp)
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	50                   	push   %eax
  801c3f:	e8 45 01 00 00       	call   801d89 <nsipc_bind>
  801c44:	83 c4 10             	add    $0x10,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <shutdown>:
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	e8 ed fe ff ff       	call   801b48 <fd2sockid>
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 0f                	js     801c6e <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	e8 57 01 00 00       	call   801dc2 <nsipc_shutdown>
  801c6b:	83 c4 10             	add    $0x10,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <connect>:
{
  801c70:	f3 0f 1e fb          	endbr32 
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	e8 c6 fe ff ff       	call   801b48 <fd2sockid>
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 12                	js     801c98 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	ff 75 10             	pushl  0x10(%ebp)
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	50                   	push   %eax
  801c90:	e8 71 01 00 00       	call   801e06 <nsipc_connect>
  801c95:	83 c4 10             	add    $0x10,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <listen>:
{
  801c9a:	f3 0f 1e fb          	endbr32 
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	e8 9c fe ff ff       	call   801b48 <fd2sockid>
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 0f                	js     801cbf <listen+0x25>
	return nsipc_listen(r, backlog);
  801cb0:	83 ec 08             	sub    $0x8,%esp
  801cb3:	ff 75 0c             	pushl  0xc(%ebp)
  801cb6:	50                   	push   %eax
  801cb7:	e8 83 01 00 00       	call   801e3f <nsipc_listen>
  801cbc:	83 c4 10             	add    $0x10,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cc1:	f3 0f 1e fb          	endbr32 
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	e8 65 02 00 00       	call   801f3e <nsipc_socket>
  801cd9:	83 c4 10             	add    $0x10,%esp
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 05                	js     801ce5 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ce0:	e8 93 fe ff ff       	call   801b78 <alloc_sockfd>
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	53                   	push   %ebx
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cf0:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801cf7:	74 26                	je     801d1f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cf9:	6a 07                	push   $0x7
  801cfb:	68 00 60 80 00       	push   $0x806000
  801d00:	53                   	push   %ebx
  801d01:	ff 35 04 44 80 00    	pushl  0x804404
  801d07:	e8 3a 06 00 00       	call   802346 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d0c:	83 c4 0c             	add    $0xc,%esp
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	e8 b8 05 00 00       	call   8022d2 <ipc_recv>
}
  801d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	6a 02                	push   $0x2
  801d24:	e8 75 06 00 00       	call   80239e <ipc_find_env>
  801d29:	a3 04 44 80 00       	mov    %eax,0x804404
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	eb c6                	jmp    801cf9 <nsipc+0x12>

00801d33 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d33:	f3 0f 1e fb          	endbr32 
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d47:	8b 06                	mov    (%esi),%eax
  801d49:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	e8 8f ff ff ff       	call   801ce7 <nsipc>
  801d58:	89 c3                	mov    %eax,%ebx
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	79 09                	jns    801d67 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d5e:	89 d8                	mov    %ebx,%eax
  801d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	ff 35 10 60 80 00    	pushl  0x806010
  801d70:	68 00 60 80 00       	push   $0x806000
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	e8 04 ef ff ff       	call   800c81 <memmove>
		*addrlen = ret->ret_addrlen;
  801d7d:	a1 10 60 80 00       	mov    0x806010,%eax
  801d82:	89 06                	mov    %eax,(%esi)
  801d84:	83 c4 10             	add    $0x10,%esp
	return r;
  801d87:	eb d5                	jmp    801d5e <nsipc_accept+0x2b>

00801d89 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d89:	f3 0f 1e fb          	endbr32 
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	53                   	push   %ebx
  801d91:	83 ec 08             	sub    $0x8,%esp
  801d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d9f:	53                   	push   %ebx
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	68 04 60 80 00       	push   $0x806004
  801da8:	e8 d4 ee ff ff       	call   800c81 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dad:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801db3:	b8 02 00 00 00       	mov    $0x2,%eax
  801db8:	e8 2a ff ff ff       	call   801ce7 <nsipc>
}
  801dbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dc2:	f3 0f 1e fb          	endbr32 
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ddc:	b8 03 00 00 00       	mov    $0x3,%eax
  801de1:	e8 01 ff ff ff       	call   801ce7 <nsipc>
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <nsipc_close>:

int
nsipc_close(int s)
{
  801de8:	f3 0f 1e fb          	endbr32 
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dfa:	b8 04 00 00 00       	mov    $0x4,%eax
  801dff:	e8 e3 fe ff ff       	call   801ce7 <nsipc>
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e06:	f3 0f 1e fb          	endbr32 
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e1c:	53                   	push   %ebx
  801e1d:	ff 75 0c             	pushl  0xc(%ebp)
  801e20:	68 04 60 80 00       	push   $0x806004
  801e25:	e8 57 ee ff ff       	call   800c81 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e2a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e30:	b8 05 00 00 00       	mov    $0x5,%eax
  801e35:	e8 ad fe ff ff       	call   801ce7 <nsipc>
}
  801e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e3f:	f3 0f 1e fb          	endbr32 
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e54:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e59:	b8 06 00 00 00       	mov    $0x6,%eax
  801e5e:	e8 84 fe ff ff       	call   801ce7 <nsipc>
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e65:	f3 0f 1e fb          	endbr32 
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e79:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e82:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e87:	b8 07 00 00 00       	mov    $0x7,%eax
  801e8c:	e8 56 fe ff ff       	call   801ce7 <nsipc>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	85 c0                	test   %eax,%eax
  801e95:	78 26                	js     801ebd <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801e97:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801e9d:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ea2:	0f 4e c6             	cmovle %esi,%eax
  801ea5:	39 c3                	cmp    %eax,%ebx
  801ea7:	7f 1d                	jg     801ec6 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	53                   	push   %ebx
  801ead:	68 00 60 80 00       	push   $0x806000
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	e8 c7 ed ff ff       	call   800c81 <memmove>
  801eba:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ebd:	89 d8                	mov    %ebx,%eax
  801ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ec6:	68 2b 2b 80 00       	push   $0x802b2b
  801ecb:	68 f3 2a 80 00       	push   $0x802af3
  801ed0:	6a 62                	push   $0x62
  801ed2:	68 40 2b 80 00       	push   $0x802b40
  801ed7:	e8 0a e4 ff ff       	call   8002e6 <_panic>

00801edc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801edc:	f3 0f 1e fb          	endbr32 
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ef2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ef8:	7f 2e                	jg     801f28 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	53                   	push   %ebx
  801efe:	ff 75 0c             	pushl  0xc(%ebp)
  801f01:	68 0c 60 80 00       	push   $0x80600c
  801f06:	e8 76 ed ff ff       	call   800c81 <memmove>
	nsipcbuf.send.req_size = size;
  801f0b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f11:	8b 45 14             	mov    0x14(%ebp),%eax
  801f14:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f19:	b8 08 00 00 00       	mov    $0x8,%eax
  801f1e:	e8 c4 fd ff ff       	call   801ce7 <nsipc>
}
  801f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    
	assert(size < 1600);
  801f28:	68 4c 2b 80 00       	push   $0x802b4c
  801f2d:	68 f3 2a 80 00       	push   $0x802af3
  801f32:	6a 6d                	push   $0x6d
  801f34:	68 40 2b 80 00       	push   $0x802b40
  801f39:	e8 a8 e3 ff ff       	call   8002e6 <_panic>

00801f3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f3e:	f3 0f 1e fb          	endbr32 
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f53:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f58:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f60:	b8 09 00 00 00       	mov    $0x9,%eax
  801f65:	e8 7d fd ff ff       	call   801ce7 <nsipc>
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	56                   	push   %esi
  801f74:	53                   	push   %ebx
  801f75:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	e8 d2 f1 ff ff       	call   801155 <fd2data>
  801f83:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f85:	83 c4 08             	add    $0x8,%esp
  801f88:	68 58 2b 80 00       	push   $0x802b58
  801f8d:	53                   	push   %ebx
  801f8e:	e8 38 eb ff ff       	call   800acb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f93:	8b 46 04             	mov    0x4(%esi),%eax
  801f96:	2b 06                	sub    (%esi),%eax
  801f98:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f9e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fa5:	00 00 00 
	stat->st_dev = &devpipe;
  801fa8:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  801faf:	30 80 00 
	return 0;
}
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5e                   	pop    %esi
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fbe:	f3 0f 1e fb          	endbr32 
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	53                   	push   %ebx
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fcc:	53                   	push   %ebx
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 c6 ef ff ff       	call   800f9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd4:	89 1c 24             	mov    %ebx,(%esp)
  801fd7:	e8 79 f1 ff ff       	call   801155 <fd2data>
  801fdc:	83 c4 08             	add    $0x8,%esp
  801fdf:	50                   	push   %eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	e8 b3 ef ff ff       	call   800f9a <sys_page_unmap>
}
  801fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <_pipeisclosed>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	57                   	push   %edi
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
  801ff2:	83 ec 1c             	sub    $0x1c,%esp
  801ff5:	89 c7                	mov    %eax,%edi
  801ff7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ff9:	a1 08 44 80 00       	mov    0x804408,%eax
  801ffe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	57                   	push   %edi
  802005:	e8 d1 03 00 00       	call   8023db <pageref>
  80200a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80200d:	89 34 24             	mov    %esi,(%esp)
  802010:	e8 c6 03 00 00       	call   8023db <pageref>
		nn = thisenv->env_runs;
  802015:	8b 15 08 44 80 00    	mov    0x804408,%edx
  80201b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	39 cb                	cmp    %ecx,%ebx
  802023:	74 1b                	je     802040 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802025:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802028:	75 cf                	jne    801ff9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80202a:	8b 42 58             	mov    0x58(%edx),%eax
  80202d:	6a 01                	push   $0x1
  80202f:	50                   	push   %eax
  802030:	53                   	push   %ebx
  802031:	68 5f 2b 80 00       	push   $0x802b5f
  802036:	e8 92 e3 ff ff       	call   8003cd <cprintf>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	eb b9                	jmp    801ff9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802040:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802043:	0f 94 c0             	sete   %al
  802046:	0f b6 c0             	movzbl %al,%eax
}
  802049:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5f                   	pop    %edi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <devpipe_write>:
{
  802051:	f3 0f 1e fb          	endbr32 
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	57                   	push   %edi
  802059:	56                   	push   %esi
  80205a:	53                   	push   %ebx
  80205b:	83 ec 28             	sub    $0x28,%esp
  80205e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802061:	56                   	push   %esi
  802062:	e8 ee f0 ff ff       	call   801155 <fd2data>
  802067:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	bf 00 00 00 00       	mov    $0x0,%edi
  802071:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802074:	74 4f                	je     8020c5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802076:	8b 43 04             	mov    0x4(%ebx),%eax
  802079:	8b 0b                	mov    (%ebx),%ecx
  80207b:	8d 51 20             	lea    0x20(%ecx),%edx
  80207e:	39 d0                	cmp    %edx,%eax
  802080:	72 14                	jb     802096 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802082:	89 da                	mov    %ebx,%edx
  802084:	89 f0                	mov    %esi,%eax
  802086:	e8 61 ff ff ff       	call   801fec <_pipeisclosed>
  80208b:	85 c0                	test   %eax,%eax
  80208d:	75 3b                	jne    8020ca <devpipe_write+0x79>
			sys_yield();
  80208f:	e8 56 ee ff ff       	call   800eea <sys_yield>
  802094:	eb e0                	jmp    802076 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802099:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80209d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	c1 fa 1f             	sar    $0x1f,%edx
  8020a5:	89 d1                	mov    %edx,%ecx
  8020a7:	c1 e9 1b             	shr    $0x1b,%ecx
  8020aa:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020ad:	83 e2 1f             	and    $0x1f,%edx
  8020b0:	29 ca                	sub    %ecx,%edx
  8020b2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020b6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020ba:	83 c0 01             	add    $0x1,%eax
  8020bd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020c0:	83 c7 01             	add    $0x1,%edi
  8020c3:	eb ac                	jmp    802071 <devpipe_write+0x20>
	return i;
  8020c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c8:	eb 05                	jmp    8020cf <devpipe_write+0x7e>
				return 0;
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5f                   	pop    %edi
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <devpipe_read>:
{
  8020d7:	f3 0f 1e fb          	endbr32 
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	57                   	push   %edi
  8020df:	56                   	push   %esi
  8020e0:	53                   	push   %ebx
  8020e1:	83 ec 18             	sub    $0x18,%esp
  8020e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020e7:	57                   	push   %edi
  8020e8:	e8 68 f0 ff ff       	call   801155 <fd2data>
  8020ed:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	be 00 00 00 00       	mov    $0x0,%esi
  8020f7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020fa:	75 14                	jne    802110 <devpipe_read+0x39>
	return i;
  8020fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ff:	eb 02                	jmp    802103 <devpipe_read+0x2c>
				return i;
  802101:	89 f0                	mov    %esi,%eax
}
  802103:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5f                   	pop    %edi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    
			sys_yield();
  80210b:	e8 da ed ff ff       	call   800eea <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802110:	8b 03                	mov    (%ebx),%eax
  802112:	3b 43 04             	cmp    0x4(%ebx),%eax
  802115:	75 18                	jne    80212f <devpipe_read+0x58>
			if (i > 0)
  802117:	85 f6                	test   %esi,%esi
  802119:	75 e6                	jne    802101 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80211b:	89 da                	mov    %ebx,%edx
  80211d:	89 f8                	mov    %edi,%eax
  80211f:	e8 c8 fe ff ff       	call   801fec <_pipeisclosed>
  802124:	85 c0                	test   %eax,%eax
  802126:	74 e3                	je     80210b <devpipe_read+0x34>
				return 0;
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
  80212d:	eb d4                	jmp    802103 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80212f:	99                   	cltd   
  802130:	c1 ea 1b             	shr    $0x1b,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	83 e0 1f             	and    $0x1f,%eax
  802138:	29 d0                	sub    %edx,%eax
  80213a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80213f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802142:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802145:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802148:	83 c6 01             	add    $0x1,%esi
  80214b:	eb aa                	jmp    8020f7 <devpipe_read+0x20>

0080214d <pipe>:
{
  80214d:	f3 0f 1e fb          	endbr32 
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	56                   	push   %esi
  802155:	53                   	push   %ebx
  802156:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802159:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215c:	50                   	push   %eax
  80215d:	e8 0e f0 ff ff       	call   801170 <fd_alloc>
  802162:	89 c3                	mov    %eax,%ebx
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	85 c0                	test   %eax,%eax
  802169:	0f 88 23 01 00 00    	js     802292 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216f:	83 ec 04             	sub    $0x4,%esp
  802172:	68 07 04 00 00       	push   $0x407
  802177:	ff 75 f4             	pushl  -0xc(%ebp)
  80217a:	6a 00                	push   $0x0
  80217c:	e8 8c ed ff ff       	call   800f0d <sys_page_alloc>
  802181:	89 c3                	mov    %eax,%ebx
  802183:	83 c4 10             	add    $0x10,%esp
  802186:	85 c0                	test   %eax,%eax
  802188:	0f 88 04 01 00 00    	js     802292 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80218e:	83 ec 0c             	sub    $0xc,%esp
  802191:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802194:	50                   	push   %eax
  802195:	e8 d6 ef ff ff       	call   801170 <fd_alloc>
  80219a:	89 c3                	mov    %eax,%ebx
  80219c:	83 c4 10             	add    $0x10,%esp
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	0f 88 db 00 00 00    	js     802282 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	68 07 04 00 00       	push   $0x407
  8021af:	ff 75 f0             	pushl  -0x10(%ebp)
  8021b2:	6a 00                	push   $0x0
  8021b4:	e8 54 ed ff ff       	call   800f0d <sys_page_alloc>
  8021b9:	89 c3                	mov    %eax,%ebx
  8021bb:	83 c4 10             	add    $0x10,%esp
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	0f 88 bc 00 00 00    	js     802282 <pipe+0x135>
	va = fd2data(fd0);
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021cc:	e8 84 ef ff ff       	call   801155 <fd2data>
  8021d1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d3:	83 c4 0c             	add    $0xc,%esp
  8021d6:	68 07 04 00 00       	push   $0x407
  8021db:	50                   	push   %eax
  8021dc:	6a 00                	push   $0x0
  8021de:	e8 2a ed ff ff       	call   800f0d <sys_page_alloc>
  8021e3:	89 c3                	mov    %eax,%ebx
  8021e5:	83 c4 10             	add    $0x10,%esp
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	0f 88 82 00 00 00    	js     802272 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f0:	83 ec 0c             	sub    $0xc,%esp
  8021f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f6:	e8 5a ef ff ff       	call   801155 <fd2data>
  8021fb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802202:	50                   	push   %eax
  802203:	6a 00                	push   $0x0
  802205:	56                   	push   %esi
  802206:	6a 00                	push   $0x0
  802208:	e8 47 ed ff ff       	call   800f54 <sys_page_map>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	83 c4 20             	add    $0x20,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	78 4e                	js     802264 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802216:	a1 58 30 80 00       	mov    0x803058,%eax
  80221b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802220:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802223:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80222a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80222d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80222f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802232:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	ff 75 f4             	pushl  -0xc(%ebp)
  80223f:	e8 fd ee ff ff       	call   801141 <fd2num>
  802244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802247:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802249:	83 c4 04             	add    $0x4,%esp
  80224c:	ff 75 f0             	pushl  -0x10(%ebp)
  80224f:	e8 ed ee ff ff       	call   801141 <fd2num>
  802254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802257:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802262:	eb 2e                	jmp    802292 <pipe+0x145>
	sys_page_unmap(0, va);
  802264:	83 ec 08             	sub    $0x8,%esp
  802267:	56                   	push   %esi
  802268:	6a 00                	push   $0x0
  80226a:	e8 2b ed ff ff       	call   800f9a <sys_page_unmap>
  80226f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802272:	83 ec 08             	sub    $0x8,%esp
  802275:	ff 75 f0             	pushl  -0x10(%ebp)
  802278:	6a 00                	push   $0x0
  80227a:	e8 1b ed ff ff       	call   800f9a <sys_page_unmap>
  80227f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802282:	83 ec 08             	sub    $0x8,%esp
  802285:	ff 75 f4             	pushl  -0xc(%ebp)
  802288:	6a 00                	push   $0x0
  80228a:	e8 0b ed ff ff       	call   800f9a <sys_page_unmap>
  80228f:	83 c4 10             	add    $0x10,%esp
}
  802292:	89 d8                	mov    %ebx,%eax
  802294:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    

0080229b <pipeisclosed>:
{
  80229b:	f3 0f 1e fb          	endbr32 
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a8:	50                   	push   %eax
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	e8 15 ef ff ff       	call   8011c6 <fd_lookup>
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	78 18                	js     8022d0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022be:	e8 92 ee ff ff       	call   801155 <fd2data>
  8022c3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	e8 1f fd ff ff       	call   801fec <_pipeisclosed>
  8022cd:	83 c4 10             	add    $0x10,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022d2:	f3 0f 1e fb          	endbr32 
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
  8022db:	8b 75 08             	mov    0x8(%ebp),%esi
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8022e4:	83 e8 01             	sub    $0x1,%eax
  8022e7:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8022ec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022f1:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8022f5:	83 ec 0c             	sub    $0xc,%esp
  8022f8:	50                   	push   %eax
  8022f9:	e8 db ed ff ff       	call   8010d9 <sys_ipc_recv>
	if (!t) {
  8022fe:	83 c4 10             	add    $0x10,%esp
  802301:	85 c0                	test   %eax,%eax
  802303:	75 2b                	jne    802330 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802305:	85 f6                	test   %esi,%esi
  802307:	74 0a                	je     802313 <ipc_recv+0x41>
  802309:	a1 08 44 80 00       	mov    0x804408,%eax
  80230e:	8b 40 74             	mov    0x74(%eax),%eax
  802311:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802313:	85 db                	test   %ebx,%ebx
  802315:	74 0a                	je     802321 <ipc_recv+0x4f>
  802317:	a1 08 44 80 00       	mov    0x804408,%eax
  80231c:	8b 40 78             	mov    0x78(%eax),%eax
  80231f:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802321:	a1 08 44 80 00       	mov    0x804408,%eax
  802326:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802329:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5d                   	pop    %ebp
  80232f:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802330:	85 f6                	test   %esi,%esi
  802332:	74 06                	je     80233a <ipc_recv+0x68>
  802334:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80233a:	85 db                	test   %ebx,%ebx
  80233c:	74 eb                	je     802329 <ipc_recv+0x57>
  80233e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802344:	eb e3                	jmp    802329 <ipc_recv+0x57>

00802346 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802346:	f3 0f 1e fb          	endbr32 
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	57                   	push   %edi
  80234e:	56                   	push   %esi
  80234f:	53                   	push   %ebx
  802350:	83 ec 0c             	sub    $0xc,%esp
  802353:	8b 7d 08             	mov    0x8(%ebp),%edi
  802356:	8b 75 0c             	mov    0xc(%ebp),%esi
  802359:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80235c:	85 db                	test   %ebx,%ebx
  80235e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802363:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802366:	ff 75 14             	pushl  0x14(%ebp)
  802369:	53                   	push   %ebx
  80236a:	56                   	push   %esi
  80236b:	57                   	push   %edi
  80236c:	e8 41 ed ff ff       	call   8010b2 <sys_ipc_try_send>
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	74 1e                	je     802396 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802378:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80237b:	75 07                	jne    802384 <ipc_send+0x3e>
		sys_yield();
  80237d:	e8 68 eb ff ff       	call   800eea <sys_yield>
  802382:	eb e2                	jmp    802366 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802384:	50                   	push   %eax
  802385:	68 77 2b 80 00       	push   $0x802b77
  80238a:	6a 39                	push   $0x39
  80238c:	68 89 2b 80 00       	push   $0x802b89
  802391:	e8 50 df ff ff       	call   8002e6 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802396:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802399:	5b                   	pop    %ebx
  80239a:	5e                   	pop    %esi
  80239b:	5f                   	pop    %edi
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80239e:	f3 0f 1e fb          	endbr32 
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023b6:	8b 52 50             	mov    0x50(%edx),%edx
  8023b9:	39 ca                	cmp    %ecx,%edx
  8023bb:	74 11                	je     8023ce <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8023bd:	83 c0 01             	add    $0x1,%eax
  8023c0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023c5:	75 e6                	jne    8023ad <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cc:	eb 0b                	jmp    8023d9 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8023ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023db:	f3 0f 1e fb          	endbr32 
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e5:	89 c2                	mov    %eax,%edx
  8023e7:	c1 ea 16             	shr    $0x16,%edx
  8023ea:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8023f1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8023f6:	f6 c1 01             	test   $0x1,%cl
  8023f9:	74 1c                	je     802417 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8023fb:	c1 e8 0c             	shr    $0xc,%eax
  8023fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802405:	a8 01                	test   $0x1,%al
  802407:	74 0e                	je     802417 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802409:	c1 e8 0c             	shr    $0xc,%eax
  80240c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802413:	ef 
  802414:	0f b7 d2             	movzwl %dx,%edx
}
  802417:	89 d0                	mov    %edx,%eax
  802419:	5d                   	pop    %ebp
  80241a:	c3                   	ret    
  80241b:	66 90                	xchg   %ax,%ax
  80241d:	66 90                	xchg   %ax,%ax
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	f3 0f 1e fb          	endbr32 
  802424:	55                   	push   %ebp
  802425:	57                   	push   %edi
  802426:	56                   	push   %esi
  802427:	53                   	push   %ebx
  802428:	83 ec 1c             	sub    $0x1c,%esp
  80242b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80242f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802433:	8b 74 24 34          	mov    0x34(%esp),%esi
  802437:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80243b:	85 d2                	test   %edx,%edx
  80243d:	75 19                	jne    802458 <__udivdi3+0x38>
  80243f:	39 f3                	cmp    %esi,%ebx
  802441:	76 4d                	jbe    802490 <__udivdi3+0x70>
  802443:	31 ff                	xor    %edi,%edi
  802445:	89 e8                	mov    %ebp,%eax
  802447:	89 f2                	mov    %esi,%edx
  802449:	f7 f3                	div    %ebx
  80244b:	89 fa                	mov    %edi,%edx
  80244d:	83 c4 1c             	add    $0x1c,%esp
  802450:	5b                   	pop    %ebx
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	39 f2                	cmp    %esi,%edx
  80245a:	76 14                	jbe    802470 <__udivdi3+0x50>
  80245c:	31 ff                	xor    %edi,%edi
  80245e:	31 c0                	xor    %eax,%eax
  802460:	89 fa                	mov    %edi,%edx
  802462:	83 c4 1c             	add    $0x1c,%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5f                   	pop    %edi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
  80246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802470:	0f bd fa             	bsr    %edx,%edi
  802473:	83 f7 1f             	xor    $0x1f,%edi
  802476:	75 48                	jne    8024c0 <__udivdi3+0xa0>
  802478:	39 f2                	cmp    %esi,%edx
  80247a:	72 06                	jb     802482 <__udivdi3+0x62>
  80247c:	31 c0                	xor    %eax,%eax
  80247e:	39 eb                	cmp    %ebp,%ebx
  802480:	77 de                	ja     802460 <__udivdi3+0x40>
  802482:	b8 01 00 00 00       	mov    $0x1,%eax
  802487:	eb d7                	jmp    802460 <__udivdi3+0x40>
  802489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802490:	89 d9                	mov    %ebx,%ecx
  802492:	85 db                	test   %ebx,%ebx
  802494:	75 0b                	jne    8024a1 <__udivdi3+0x81>
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f3                	div    %ebx
  80249f:	89 c1                	mov    %eax,%ecx
  8024a1:	31 d2                	xor    %edx,%edx
  8024a3:	89 f0                	mov    %esi,%eax
  8024a5:	f7 f1                	div    %ecx
  8024a7:	89 c6                	mov    %eax,%esi
  8024a9:	89 e8                	mov    %ebp,%eax
  8024ab:	89 f7                	mov    %esi,%edi
  8024ad:	f7 f1                	div    %ecx
  8024af:	89 fa                	mov    %edi,%edx
  8024b1:	83 c4 1c             	add    $0x1c,%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5f                   	pop    %edi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    
  8024b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c0:	89 f9                	mov    %edi,%ecx
  8024c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c7:	29 f8                	sub    %edi,%eax
  8024c9:	d3 e2                	shl    %cl,%edx
  8024cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024cf:	89 c1                	mov    %eax,%ecx
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	d3 ea                	shr    %cl,%edx
  8024d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d9:	09 d1                	or     %edx,%ecx
  8024db:	89 f2                	mov    %esi,%edx
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 f9                	mov    %edi,%ecx
  8024e3:	d3 e3                	shl    %cl,%ebx
  8024e5:	89 c1                	mov    %eax,%ecx
  8024e7:	d3 ea                	shr    %cl,%edx
  8024e9:	89 f9                	mov    %edi,%ecx
  8024eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ef:	89 eb                	mov    %ebp,%ebx
  8024f1:	d3 e6                	shl    %cl,%esi
  8024f3:	89 c1                	mov    %eax,%ecx
  8024f5:	d3 eb                	shr    %cl,%ebx
  8024f7:	09 de                	or     %ebx,%esi
  8024f9:	89 f0                	mov    %esi,%eax
  8024fb:	f7 74 24 08          	divl   0x8(%esp)
  8024ff:	89 d6                	mov    %edx,%esi
  802501:	89 c3                	mov    %eax,%ebx
  802503:	f7 64 24 0c          	mull   0xc(%esp)
  802507:	39 d6                	cmp    %edx,%esi
  802509:	72 15                	jb     802520 <__udivdi3+0x100>
  80250b:	89 f9                	mov    %edi,%ecx
  80250d:	d3 e5                	shl    %cl,%ebp
  80250f:	39 c5                	cmp    %eax,%ebp
  802511:	73 04                	jae    802517 <__udivdi3+0xf7>
  802513:	39 d6                	cmp    %edx,%esi
  802515:	74 09                	je     802520 <__udivdi3+0x100>
  802517:	89 d8                	mov    %ebx,%eax
  802519:	31 ff                	xor    %edi,%edi
  80251b:	e9 40 ff ff ff       	jmp    802460 <__udivdi3+0x40>
  802520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802523:	31 ff                	xor    %edi,%edi
  802525:	e9 36 ff ff ff       	jmp    802460 <__udivdi3+0x40>
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	f3 0f 1e fb          	endbr32 
  802534:	55                   	push   %ebp
  802535:	57                   	push   %edi
  802536:	56                   	push   %esi
  802537:	53                   	push   %ebx
  802538:	83 ec 1c             	sub    $0x1c,%esp
  80253b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80253f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802543:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802547:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 19                	jne    802568 <__umoddi3+0x38>
  80254f:	39 df                	cmp    %ebx,%edi
  802551:	76 5d                	jbe    8025b0 <__umoddi3+0x80>
  802553:	89 f0                	mov    %esi,%eax
  802555:	89 da                	mov    %ebx,%edx
  802557:	f7 f7                	div    %edi
  802559:	89 d0                	mov    %edx,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	83 c4 1c             	add    $0x1c,%esp
  802560:	5b                   	pop    %ebx
  802561:	5e                   	pop    %esi
  802562:	5f                   	pop    %edi
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    
  802565:	8d 76 00             	lea    0x0(%esi),%esi
  802568:	89 f2                	mov    %esi,%edx
  80256a:	39 d8                	cmp    %ebx,%eax
  80256c:	76 12                	jbe    802580 <__umoddi3+0x50>
  80256e:	89 f0                	mov    %esi,%eax
  802570:	89 da                	mov    %ebx,%edx
  802572:	83 c4 1c             	add    $0x1c,%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5f                   	pop    %edi
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    
  80257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802580:	0f bd e8             	bsr    %eax,%ebp
  802583:	83 f5 1f             	xor    $0x1f,%ebp
  802586:	75 50                	jne    8025d8 <__umoddi3+0xa8>
  802588:	39 d8                	cmp    %ebx,%eax
  80258a:	0f 82 e0 00 00 00    	jb     802670 <__umoddi3+0x140>
  802590:	89 d9                	mov    %ebx,%ecx
  802592:	39 f7                	cmp    %esi,%edi
  802594:	0f 86 d6 00 00 00    	jbe    802670 <__umoddi3+0x140>
  80259a:	89 d0                	mov    %edx,%eax
  80259c:	89 ca                	mov    %ecx,%edx
  80259e:	83 c4 1c             	add    $0x1c,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ad:	8d 76 00             	lea    0x0(%esi),%esi
  8025b0:	89 fd                	mov    %edi,%ebp
  8025b2:	85 ff                	test   %edi,%edi
  8025b4:	75 0b                	jne    8025c1 <__umoddi3+0x91>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f7                	div    %edi
  8025bf:	89 c5                	mov    %eax,%ebp
  8025c1:	89 d8                	mov    %ebx,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f5                	div    %ebp
  8025c7:	89 f0                	mov    %esi,%eax
  8025c9:	f7 f5                	div    %ebp
  8025cb:	89 d0                	mov    %edx,%eax
  8025cd:	31 d2                	xor    %edx,%edx
  8025cf:	eb 8c                	jmp    80255d <__umoddi3+0x2d>
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	ba 20 00 00 00       	mov    $0x20,%edx
  8025df:	29 ea                	sub    %ebp,%edx
  8025e1:	d3 e0                	shl    %cl,%eax
  8025e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025e7:	89 d1                	mov    %edx,%ecx
  8025e9:	89 f8                	mov    %edi,%eax
  8025eb:	d3 e8                	shr    %cl,%eax
  8025ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025f9:	09 c1                	or     %eax,%ecx
  8025fb:	89 d8                	mov    %ebx,%eax
  8025fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802601:	89 e9                	mov    %ebp,%ecx
  802603:	d3 e7                	shl    %cl,%edi
  802605:	89 d1                	mov    %edx,%ecx
  802607:	d3 e8                	shr    %cl,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80260f:	d3 e3                	shl    %cl,%ebx
  802611:	89 c7                	mov    %eax,%edi
  802613:	89 d1                	mov    %edx,%ecx
  802615:	89 f0                	mov    %esi,%eax
  802617:	d3 e8                	shr    %cl,%eax
  802619:	89 e9                	mov    %ebp,%ecx
  80261b:	89 fa                	mov    %edi,%edx
  80261d:	d3 e6                	shl    %cl,%esi
  80261f:	09 d8                	or     %ebx,%eax
  802621:	f7 74 24 08          	divl   0x8(%esp)
  802625:	89 d1                	mov    %edx,%ecx
  802627:	89 f3                	mov    %esi,%ebx
  802629:	f7 64 24 0c          	mull   0xc(%esp)
  80262d:	89 c6                	mov    %eax,%esi
  80262f:	89 d7                	mov    %edx,%edi
  802631:	39 d1                	cmp    %edx,%ecx
  802633:	72 06                	jb     80263b <__umoddi3+0x10b>
  802635:	75 10                	jne    802647 <__umoddi3+0x117>
  802637:	39 c3                	cmp    %eax,%ebx
  802639:	73 0c                	jae    802647 <__umoddi3+0x117>
  80263b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80263f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802643:	89 d7                	mov    %edx,%edi
  802645:	89 c6                	mov    %eax,%esi
  802647:	89 ca                	mov    %ecx,%edx
  802649:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80264e:	29 f3                	sub    %esi,%ebx
  802650:	19 fa                	sbb    %edi,%edx
  802652:	89 d0                	mov    %edx,%eax
  802654:	d3 e0                	shl    %cl,%eax
  802656:	89 e9                	mov    %ebp,%ecx
  802658:	d3 eb                	shr    %cl,%ebx
  80265a:	d3 ea                	shr    %cl,%edx
  80265c:	09 d8                	or     %ebx,%eax
  80265e:	83 c4 1c             	add    $0x1c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    
  802666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	29 fe                	sub    %edi,%esi
  802672:	19 c3                	sbb    %eax,%ebx
  802674:	89 f2                	mov    %esi,%edx
  802676:	89 d9                	mov    %ebx,%ecx
  802678:	e9 1d ff ff ff       	jmp    80259a <__umoddi3+0x6a>
