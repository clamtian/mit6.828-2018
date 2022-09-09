
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 0d 0a 00 00       	call   800a3e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 0c             	sub    $0xc,%esp
  800040:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800043:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int t;

	if (s == 0) {
  800046:	85 db                	test   %ebx,%ebx
  800048:	74 1a                	je     800064 <_gettoken+0x31>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  80004a:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800051:	7f 31                	jg     800084 <_gettoken+0x51>
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
  800053:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	*p2 = 0;
  800059:	8b 45 10             	mov    0x10(%ebp),%eax
  80005c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  800062:	eb 3a                	jmp    80009e <_gettoken+0x6b>
		return 0;
  800064:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  800069:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800070:	7e 59                	jle    8000cb <_gettoken+0x98>
			cprintf("GETTOKEN NULL\n");
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	68 00 3a 80 00       	push   $0x803a00
  80007a:	e8 0e 0b 00 00       	call   800b8d <cprintf>
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	eb 47                	jmp    8000cb <_gettoken+0x98>
		cprintf("GETTOKEN: %s\n", s);
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	53                   	push   %ebx
  800088:	68 0f 3a 80 00       	push   $0x803a0f
  80008d:	e8 fb 0a 00 00       	call   800b8d <cprintf>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	eb bc                	jmp    800053 <_gettoken+0x20>
		*s++ = 0;
  800097:	83 c3 01             	add    $0x1,%ebx
  80009a:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	0f be 03             	movsbl (%ebx),%eax
  8000a4:	50                   	push   %eax
  8000a5:	68 1d 3a 80 00       	push   $0x803a1d
  8000aa:	e8 01 13 00 00       	call   8013b0 <strchr>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	85 c0                	test   %eax,%eax
  8000b4:	75 e1                	jne    800097 <_gettoken+0x64>
	if (*s == 0) {
  8000b6:	0f b6 03             	movzbl (%ebx),%eax
  8000b9:	84 c0                	test   %al,%al
  8000bb:	75 2a                	jne    8000e7 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000bd:	be 00 00 00 00       	mov    $0x0,%esi
		if (debug > 1)
  8000c2:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000c9:	7f 0a                	jg     8000d5 <_gettoken+0xa2>
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000cb:	89 f0                	mov    %esi,%eax
  8000cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
			cprintf("EOL\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 22 3a 80 00       	push   $0x803a22
  8000dd:	e8 ab 0a 00 00       	call   800b8d <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb e4                	jmp    8000cb <_gettoken+0x98>
	if (strchr(SYMBOLS, *s)) {
  8000e7:	83 ec 08             	sub    $0x8,%esp
  8000ea:	0f be c0             	movsbl %al,%eax
  8000ed:	50                   	push   %eax
  8000ee:	68 33 3a 80 00       	push   $0x803a33
  8000f3:	e8 b8 12 00 00       	call   8013b0 <strchr>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	74 2c                	je     80012b <_gettoken+0xf8>
		t = *s;
  8000ff:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  800102:	89 1f                	mov    %ebx,(%edi)
		*s++ = 0;
  800104:	c6 03 00             	movb   $0x0,(%ebx)
  800107:	83 c3 01             	add    $0x1,%ebx
  80010a:	8b 45 10             	mov    0x10(%ebp),%eax
  80010d:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010f:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800116:	7e b3                	jle    8000cb <_gettoken+0x98>
			cprintf("TOK %c\n", t);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	68 27 3a 80 00       	push   $0x803a27
  800121:	e8 67 0a 00 00       	call   800b8d <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	eb a0                	jmp    8000cb <_gettoken+0x98>
	*p1 = s;
  80012b:	89 1f                	mov    %ebx,(%edi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012d:	eb 03                	jmp    800132 <_gettoken+0xff>
		s++;
  80012f:	83 c3 01             	add    $0x1,%ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800132:	0f b6 03             	movzbl (%ebx),%eax
  800135:	84 c0                	test   %al,%al
  800137:	74 18                	je     800151 <_gettoken+0x11e>
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	0f be c0             	movsbl %al,%eax
  80013f:	50                   	push   %eax
  800140:	68 2f 3a 80 00       	push   $0x803a2f
  800145:	e8 66 12 00 00       	call   8013b0 <strchr>
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	85 c0                	test   %eax,%eax
  80014f:	74 de                	je     80012f <_gettoken+0xfc>
	*p2 = s;
  800151:	8b 45 10             	mov    0x10(%ebp),%eax
  800154:	89 18                	mov    %ebx,(%eax)
	return 'w';
  800156:	be 77 00 00 00       	mov    $0x77,%esi
	if (debug > 1) {
  80015b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800162:	0f 8e 63 ff ff ff    	jle    8000cb <_gettoken+0x98>
		t = **p2;
  800168:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  80016b:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 37                	pushl  (%edi)
  800173:	68 3b 3a 80 00       	push   $0x803a3b
  800178:	e8 10 0a 00 00       	call   800b8d <cprintf>
		**p2 = t;
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	8b 00                	mov    (%eax),%eax
  800182:	89 f2                	mov    %esi,%edx
  800184:	88 10                	mov    %dl,(%eax)
  800186:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800189:	be 77 00 00 00       	mov    $0x77,%esi
  80018e:	e9 38 ff ff ff       	jmp    8000cb <_gettoken+0x98>

00800193 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a0:	85 c0                	test   %eax,%eax
  8001a2:	74 22                	je     8001c6 <gettoken+0x33>
		nc = _gettoken(s, &np1, &np2);
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 0c 60 80 00       	push   $0x80600c
  8001ac:	68 10 60 80 00       	push   $0x806010
  8001b1:	50                   	push   %eax
  8001b2:	e8 7c fe ff ff       	call   800033 <_gettoken>
  8001b7:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
	c = nc;
  8001c6:	a1 08 60 80 00       	mov    0x806008,%eax
  8001cb:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001d0:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 0c 60 80 00       	push   $0x80600c
  8001e3:	68 10 60 80 00       	push   $0x806010
  8001e8:	ff 35 0c 60 80 00    	pushl  0x80600c
  8001ee:	e8 40 fe ff ff       	call   800033 <_gettoken>
  8001f3:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  8001f8:	a1 04 60 80 00       	mov    0x806004,%eax
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	eb c2                	jmp    8001c4 <gettoken+0x31>

00800202 <runcmd>:
{
  800202:	f3 0f 1e fb          	endbr32 
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800212:	6a 00                	push   $0x0
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	e8 77 ff ff ff       	call   800193 <gettoken>
  80021c:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  80021f:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800222:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	56                   	push   %esi
  80022b:	6a 00                	push   $0x0
  80022d:	e8 61 ff ff ff       	call   800193 <gettoken>
  800232:	89 c3                	mov    %eax,%ebx
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	83 f8 3e             	cmp    $0x3e,%eax
  80023a:	0f 84 32 01 00 00    	je     800372 <runcmd+0x170>
  800240:	7f 49                	jg     80028b <runcmd+0x89>
  800242:	85 c0                	test   %eax,%eax
  800244:	0f 84 1c 02 00 00    	je     800466 <runcmd+0x264>
  80024a:	83 f8 3c             	cmp    $0x3c,%eax
  80024d:	0f 85 ef 02 00 00    	jne    800542 <runcmd+0x340>
		if (gettoken(0, &t) != 'w') {
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	6a 00                	push   $0x0
  800259:	e8 35 ff ff ff       	call   800193 <gettoken>
  80025e:	83 c4 10             	add    $0x10,%esp
  800261:	83 f8 77             	cmp    $0x77,%eax
  800264:	0f 85 ba 00 00 00    	jne    800324 <runcmd+0x122>
		if ((fd = open(t, O_RDONLY)) < 0) {
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	ff 75 a4             	pushl  -0x5c(%ebp)
  800272:	e8 c9 22 00 00       	call   802540 <open>
  800277:	89 c3                	mov    %eax,%ebx
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	85 c0                	test   %eax,%eax
  80027e:	0f 88 ba 00 00 00    	js     80033e <runcmd+0x13c>
		if (fd != 0) {
  800284:	74 a1                	je     800227 <runcmd+0x25>
  800286:	e9 cc 00 00 00       	jmp    800357 <runcmd+0x155>
		switch ((c = gettoken(0, &t))) {
  80028b:	83 f8 77             	cmp    $0x77,%eax
  80028e:	74 69                	je     8002f9 <runcmd+0xf7>
  800290:	83 f8 7c             	cmp    $0x7c,%eax
  800293:	0f 85 a9 02 00 00    	jne    800542 <runcmd+0x340>
			if ((r = pipe(p)) < 0) {
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	e8 30 31 00 00       	call   8033d8 <pipe>
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	85 c0                	test   %eax,%eax
  8002ad:	0f 88 41 01 00 00    	js     8003f4 <runcmd+0x1f2>
			if (debug)
  8002b3:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8002ba:	0f 85 4f 01 00 00    	jne    80040f <runcmd+0x20d>
			if ((r = fork()) < 0) {
  8002c0:	e8 3c 18 00 00       	call   801b01 <fork>
  8002c5:	89 c3                	mov    %eax,%ebx
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	0f 88 61 01 00 00    	js     800430 <runcmd+0x22e>
			if (r == 0) {
  8002cf:	0f 85 71 01 00 00    	jne    800446 <runcmd+0x244>
				if (p[0] != 0) {
  8002d5:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8002db:	85 c0                	test   %eax,%eax
  8002dd:	0f 85 1d 02 00 00    	jne    800500 <runcmd+0x2fe>
				close(p[1]);
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  8002ec:	e8 70 1c 00 00       	call   801f61 <close>
				goto again;
  8002f1:	83 c4 10             	add    $0x10,%esp
  8002f4:	e9 29 ff ff ff       	jmp    800222 <runcmd+0x20>
			if (argc == MAXARGS) {
  8002f9:	83 ff 10             	cmp    $0x10,%edi
  8002fc:	74 0f                	je     80030d <runcmd+0x10b>
			argv[argc++] = t;
  8002fe:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800301:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800305:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  800308:	e9 1a ff ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("too many arguments\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 45 3a 80 00       	push   $0x803a45
  800315:	e8 73 08 00 00       	call   800b8d <cprintf>
				exit();
  80031a:	e8 69 07 00 00       	call   800a88 <exit>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	eb da                	jmp    8002fe <runcmd+0xfc>
			cprintf("syntax error: < not followed by word\n");
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 98 3b 80 00       	push   $0x803b98
  80032c:	e8 5c 08 00 00       	call   800b8d <cprintf>
			exit();
  800331:	e8 52 07 00 00       	call   800a88 <exit>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	e9 2c ff ff ff       	jmp    80026a <runcmd+0x68>
			cprintf("open %s for read: %e", t, fd);
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	50                   	push   %eax
  800342:	ff 75 a4             	pushl  -0x5c(%ebp)
  800345:	68 59 3a 80 00       	push   $0x803a59
  80034a:	e8 3e 08 00 00       	call   800b8d <cprintf>
			exit();
  80034f:	e8 34 07 00 00       	call   800a88 <exit>
  800354:	83 c4 10             	add    $0x10,%esp
			dup(fd, 0); //应该是让文件描述符0也作为fd对应的那个open file的struct Fd页面
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	6a 00                	push   $0x0
  80035c:	53                   	push   %ebx
  80035d:	e8 59 1c 00 00       	call   801fbb <dup>
			close(fd);
  800362:	89 1c 24             	mov    %ebx,(%esp)
  800365:	e8 f7 1b 00 00       	call   801f61 <close>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	e9 b5 fe ff ff       	jmp    800227 <runcmd+0x25>
			if (gettoken(0, &t) != 'w') {
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	56                   	push   %esi
  800376:	6a 00                	push   $0x0
  800378:	e8 16 fe ff ff       	call   800193 <gettoken>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	83 f8 77             	cmp    $0x77,%eax
  800383:	75 24                	jne    8003a9 <runcmd+0x1a7>
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	68 01 03 00 00       	push   $0x301
  80038d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800390:	e8 ab 21 00 00       	call   802540 <open>
  800395:	89 c3                	mov    %eax,%ebx
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	85 c0                	test   %eax,%eax
  80039c:	78 22                	js     8003c0 <runcmd+0x1be>
			if (fd != 1) {
  80039e:	83 f8 01             	cmp    $0x1,%eax
  8003a1:	0f 84 80 fe ff ff    	je     800227 <runcmd+0x25>
  8003a7:	eb 30                	jmp    8003d9 <runcmd+0x1d7>
				cprintf("syntax error: > not followed by word\n");
  8003a9:	83 ec 0c             	sub    $0xc,%esp
  8003ac:	68 c0 3b 80 00       	push   $0x803bc0
  8003b1:	e8 d7 07 00 00       	call   800b8d <cprintf>
				exit();
  8003b6:	e8 cd 06 00 00       	call   800a88 <exit>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	eb c5                	jmp    800385 <runcmd+0x183>
				cprintf("open %s for write: %e", t, fd);
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	50                   	push   %eax
  8003c4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003c7:	68 6e 3a 80 00       	push   $0x803a6e
  8003cc:	e8 bc 07 00 00       	call   800b8d <cprintf>
				exit();
  8003d1:	e8 b2 06 00 00       	call   800a88 <exit>
  8003d6:	83 c4 10             	add    $0x10,%esp
				dup(fd, 1);
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	6a 01                	push   $0x1
  8003de:	53                   	push   %ebx
  8003df:	e8 d7 1b 00 00       	call   801fbb <dup>
				close(fd);
  8003e4:	89 1c 24             	mov    %ebx,(%esp)
  8003e7:	e8 75 1b 00 00       	call   801f61 <close>
  8003ec:	83 c4 10             	add    $0x10,%esp
  8003ef:	e9 33 fe ff ff       	jmp    800227 <runcmd+0x25>
				cprintf("pipe: %e", r);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	50                   	push   %eax
  8003f8:	68 84 3a 80 00       	push   $0x803a84
  8003fd:	e8 8b 07 00 00       	call   800b8d <cprintf>
				exit();
  800402:	e8 81 06 00 00       	call   800a88 <exit>
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	e9 a4 fe ff ff       	jmp    8002b3 <runcmd+0xb1>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800418:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041e:	68 8d 3a 80 00       	push   $0x803a8d
  800423:	e8 65 07 00 00       	call   800b8d <cprintf>
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	e9 90 fe ff ff       	jmp    8002c0 <runcmd+0xbe>
				cprintf("fork: %e", r);
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	50                   	push   %eax
  800434:	68 9a 3a 80 00       	push   $0x803a9a
  800439:	e8 4f 07 00 00       	call   800b8d <cprintf>
				exit();
  80043e:	e8 45 06 00 00       	call   800a88 <exit>
  800443:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800446:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044c:	83 f8 01             	cmp    $0x1,%eax
  80044f:	0f 85 cc 00 00 00    	jne    800521 <runcmd+0x31f>
				close(p[0]);
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80045e:	e8 fe 1a 00 00       	call   801f61 <close>
				goto runit;
  800463:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  800466:	85 ff                	test   %edi,%edi
  800468:	0f 84 e6 00 00 00    	je     800554 <runcmd+0x352>
	if (argv[0][0] != '/') {
  80046e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800471:	80 38 2f             	cmpb   $0x2f,(%eax)
  800474:	0f 85 f5 00 00 00    	jne    80056f <runcmd+0x36d>
	argv[argc] = 0;
  80047a:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  800481:	00 
	if (debug) {
  800482:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800489:	0f 85 08 01 00 00    	jne    800597 <runcmd+0x395>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800495:	50                   	push   %eax
  800496:	ff 75 a8             	pushl  -0x58(%ebp)
  800499:	e8 73 22 00 00       	call   802711 <spawn>
  80049e:	89 c6                	mov    %eax,%esi
  8004a0:	83 c4 10             	add    $0x10,%esp
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	0f 88 3a 01 00 00    	js     8005e5 <runcmd+0x3e3>
	close_all();
  8004ab:	e8 e2 1a 00 00       	call   801f92 <close_all>
		if (debug)
  8004b0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004b7:	0f 85 75 01 00 00    	jne    800632 <runcmd+0x430>
		wait(r);
  8004bd:	83 ec 0c             	sub    $0xc,%esp
  8004c0:	56                   	push   %esi
  8004c1:	e8 97 30 00 00       	call   80355d <wait>
		if (debug)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004d0:	0f 85 7b 01 00 00    	jne    800651 <runcmd+0x44f>
	if (pipe_child) {
  8004d6:	85 db                	test   %ebx,%ebx
  8004d8:	74 19                	je     8004f3 <runcmd+0x2f1>
		wait(pipe_child);
  8004da:	83 ec 0c             	sub    $0xc,%esp
  8004dd:	53                   	push   %ebx
  8004de:	e8 7a 30 00 00       	call   80355d <wait>
		if (debug)
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004ed:	0f 85 79 01 00 00    	jne    80066c <runcmd+0x46a>
	exit();
  8004f3:	e8 90 05 00 00       	call   800a88 <exit>
}
  8004f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004fb:	5b                   	pop    %ebx
  8004fc:	5e                   	pop    %esi
  8004fd:	5f                   	pop    %edi
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    
					dup(p[0], 0);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	50                   	push   %eax
  800506:	e8 b0 1a 00 00       	call   801fbb <dup>
					close(p[0]);
  80050b:	83 c4 04             	add    $0x4,%esp
  80050e:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800514:	e8 48 1a 00 00       	call   801f61 <close>
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	e9 c2 fd ff ff       	jmp    8002e3 <runcmd+0xe1>
					dup(p[1], 1);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	6a 01                	push   $0x1
  800526:	50                   	push   %eax
  800527:	e8 8f 1a 00 00       	call   801fbb <dup>
					close(p[1]);
  80052c:	83 c4 04             	add    $0x4,%esp
  80052f:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800535:	e8 27 1a 00 00       	call   801f61 <close>
  80053a:	83 c4 10             	add    $0x10,%esp
  80053d:	e9 13 ff ff ff       	jmp    800455 <runcmd+0x253>
			panic("bad return %d from gettoken", c);
  800542:	53                   	push   %ebx
  800543:	68 a3 3a 80 00       	push   $0x803aa3
  800548:	6a 71                	push   $0x71
  80054a:	68 bf 3a 80 00       	push   $0x803abf
  80054f:	e8 52 05 00 00       	call   800aa6 <_panic>
		if (debug)
  800554:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80055b:	74 9b                	je     8004f8 <runcmd+0x2f6>
			cprintf("EMPTY COMMAND\n");
  80055d:	83 ec 0c             	sub    $0xc,%esp
  800560:	68 c9 3a 80 00       	push   $0x803ac9
  800565:	e8 23 06 00 00       	call   800b8d <cprintf>
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	eb 89                	jmp    8004f8 <runcmd+0x2f6>
		argv0buf[0] = '/';
  80056f:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	50                   	push   %eax
  80057a:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  800580:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800586:	50                   	push   %eax
  800587:	e8 ff 0c 00 00       	call   80128b <strcpy>
		argv[0] = argv0buf;
  80058c:	89 75 a8             	mov    %esi,-0x58(%ebp)
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	e9 e3 fe ff ff       	jmp    80047a <runcmd+0x278>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800597:	a1 28 64 80 00       	mov    0x806428,%eax
  80059c:	8b 40 48             	mov    0x48(%eax),%eax
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	50                   	push   %eax
  8005a3:	68 d8 3a 80 00       	push   $0x803ad8
  8005a8:	e8 e0 05 00 00       	call   800b8d <cprintf>
  8005ad:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	eb 11                	jmp    8005c6 <runcmd+0x3c4>
			cprintf(" %s", argv[i]);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	50                   	push   %eax
  8005b9:	68 60 3b 80 00       	push   $0x803b60
  8005be:	e8 ca 05 00 00       	call   800b8d <cprintf>
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005c9:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005cc:	85 c0                	test   %eax,%eax
  8005ce:	75 e5                	jne    8005b5 <runcmd+0x3b3>
		cprintf("\n");
  8005d0:	83 ec 0c             	sub    $0xc,%esp
  8005d3:	68 20 3a 80 00       	push   $0x803a20
  8005d8:	e8 b0 05 00 00       	call   800b8d <cprintf>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	e9 aa fe ff ff       	jmp    80048f <runcmd+0x28d>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005e5:	83 ec 04             	sub    $0x4,%esp
  8005e8:	50                   	push   %eax
  8005e9:	ff 75 a8             	pushl  -0x58(%ebp)
  8005ec:	68 e6 3a 80 00       	push   $0x803ae6
  8005f1:	e8 97 05 00 00       	call   800b8d <cprintf>
	close_all();
  8005f6:	e8 97 19 00 00       	call   801f92 <close_all>
  8005fb:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  8005fe:	85 db                	test   %ebx,%ebx
  800600:	0f 84 ed fe ff ff    	je     8004f3 <runcmd+0x2f1>
		if (debug)
  800606:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80060d:	0f 84 c7 fe ff ff    	je     8004da <runcmd+0x2d8>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800613:	a1 28 64 80 00       	mov    0x806428,%eax
  800618:	8b 40 48             	mov    0x48(%eax),%eax
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	53                   	push   %ebx
  80061f:	50                   	push   %eax
  800620:	68 1f 3b 80 00       	push   $0x803b1f
  800625:	e8 63 05 00 00       	call   800b8d <cprintf>
  80062a:	83 c4 10             	add    $0x10,%esp
  80062d:	e9 a8 fe ff ff       	jmp    8004da <runcmd+0x2d8>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  800632:	a1 28 64 80 00       	mov    0x806428,%eax
  800637:	8b 40 48             	mov    0x48(%eax),%eax
  80063a:	56                   	push   %esi
  80063b:	ff 75 a8             	pushl  -0x58(%ebp)
  80063e:	50                   	push   %eax
  80063f:	68 f4 3a 80 00       	push   $0x803af4
  800644:	e8 44 05 00 00       	call   800b8d <cprintf>
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	e9 6c fe ff ff       	jmp    8004bd <runcmd+0x2bb>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800651:	a1 28 64 80 00       	mov    0x806428,%eax
  800656:	8b 40 48             	mov    0x48(%eax),%eax
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	50                   	push   %eax
  80065d:	68 09 3b 80 00       	push   $0x803b09
  800662:	e8 26 05 00 00       	call   800b8d <cprintf>
  800667:	83 c4 10             	add    $0x10,%esp
  80066a:	eb 92                	jmp    8005fe <runcmd+0x3fc>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80066c:	a1 28 64 80 00       	mov    0x806428,%eax
  800671:	8b 40 48             	mov    0x48(%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	50                   	push   %eax
  800678:	68 09 3b 80 00       	push   $0x803b09
  80067d:	e8 0b 05 00 00       	call   800b8d <cprintf>
  800682:	83 c4 10             	add    $0x10,%esp
  800685:	e9 69 fe ff ff       	jmp    8004f3 <runcmd+0x2f1>

0080068a <usage>:


void
usage(void)
{
  80068a:	f3 0f 1e fb          	endbr32 
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800694:	68 e8 3b 80 00       	push   $0x803be8
  800699:	e8 ef 04 00 00       	call   800b8d <cprintf>
	exit();
  80069e:	e8 e5 03 00 00       	call   800a88 <exit>
}
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <umain>:

void
umain(int argc, char **argv)
{
  8006a8:	f3 0f 1e fb          	endbr32 
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  8006b5:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	8d 45 08             	lea    0x8(%ebp),%eax
  8006bf:	50                   	push   %eax
  8006c0:	e8 7a 15 00 00       	call   801c3f <argstart>
	while ((r = argnext(&args)) >= 0)
  8006c5:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006cf:	bf 3f 00 00 00       	mov    $0x3f,%edi
	while ((r = argnext(&args)) >= 0)
  8006d4:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006d7:	be 01 00 00 00       	mov    $0x1,%esi
	while ((r = argnext(&args)) >= 0)
  8006dc:	eb 10                	jmp    8006ee <umain+0x46>
			debug++;
  8006de:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006e5:	eb 07                	jmp    8006ee <umain+0x46>
			interactive = 1;
  8006e7:	89 f7                	mov    %esi,%edi
  8006e9:	eb 03                	jmp    8006ee <umain+0x46>
		switch (r) {
  8006eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	e8 7c 15 00 00       	call   801c73 <argnext>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	78 16                	js     800714 <umain+0x6c>
		switch (r) {
  8006fe:	83 f8 69             	cmp    $0x69,%eax
  800701:	74 e4                	je     8006e7 <umain+0x3f>
  800703:	83 f8 78             	cmp    $0x78,%eax
  800706:	74 e3                	je     8006eb <umain+0x43>
  800708:	83 f8 64             	cmp    $0x64,%eax
  80070b:	74 d1                	je     8006de <umain+0x36>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  80070d:	e8 78 ff ff ff       	call   80068a <usage>
  800712:	eb da                	jmp    8006ee <umain+0x46>
		}

	if (argc > 2)
  800714:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800718:	7f 1f                	jg     800739 <umain+0x91>
		usage();
	if (argc == 2) {
  80071a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80071e:	74 20                	je     800740 <umain+0x98>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  800720:	83 ff 3f             	cmp    $0x3f,%edi
  800723:	74 75                	je     80079a <umain+0xf2>
  800725:	85 ff                	test   %edi,%edi
  800727:	bf 64 3b 80 00       	mov    $0x803b64,%edi
  80072c:	b8 00 00 00 00       	mov    $0x0,%eax
  800731:	0f 44 f8             	cmove  %eax,%edi
  800734:	e9 06 01 00 00       	jmp    80083f <umain+0x197>
		usage();
  800739:	e8 4c ff ff ff       	call   80068a <usage>
  80073e:	eb da                	jmp    80071a <umain+0x72>
		close(0);
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	6a 00                	push   $0x0
  800745:	e8 17 18 00 00       	call   801f61 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80074a:	83 c4 08             	add    $0x8,%esp
  80074d:	6a 00                	push   $0x0
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	ff 70 04             	pushl  0x4(%eax)
  800755:	e8 e6 1d 00 00       	call   802540 <open>
  80075a:	83 c4 10             	add    $0x10,%esp
  80075d:	85 c0                	test   %eax,%eax
  80075f:	78 1b                	js     80077c <umain+0xd4>
		assert(r == 0);
  800761:	74 bd                	je     800720 <umain+0x78>
  800763:	68 48 3b 80 00       	push   $0x803b48
  800768:	68 4f 3b 80 00       	push   $0x803b4f
  80076d:	68 22 01 00 00       	push   $0x122
  800772:	68 bf 3a 80 00       	push   $0x803abf
  800777:	e8 2a 03 00 00       	call   800aa6 <_panic>
			panic("open %s: %e", argv[1], r);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	50                   	push   %eax
  800780:	8b 45 0c             	mov    0xc(%ebp),%eax
  800783:	ff 70 04             	pushl  0x4(%eax)
  800786:	68 3c 3b 80 00       	push   $0x803b3c
  80078b:	68 21 01 00 00       	push   $0x121
  800790:	68 bf 3a 80 00       	push   $0x803abf
  800795:	e8 0c 03 00 00       	call   800aa6 <_panic>
		interactive = iscons(0);
  80079a:	83 ec 0c             	sub    $0xc,%esp
  80079d:	6a 00                	push   $0x0
  80079f:	e8 14 02 00 00       	call   8009b8 <iscons>
  8007a4:	89 c7                	mov    %eax,%edi
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	e9 77 ff ff ff       	jmp    800725 <umain+0x7d>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  8007ae:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007b5:	75 0a                	jne    8007c1 <umain+0x119>
				cprintf("EXITING\n");
			exit();	// end of file
  8007b7:	e8 cc 02 00 00       	call   800a88 <exit>
  8007bc:	e9 94 00 00 00       	jmp    800855 <umain+0x1ad>
				cprintf("EXITING\n");
  8007c1:	83 ec 0c             	sub    $0xc,%esp
  8007c4:	68 67 3b 80 00       	push   $0x803b67
  8007c9:	e8 bf 03 00 00       	call   800b8d <cprintf>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	eb e4                	jmp    8007b7 <umain+0x10f>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	68 70 3b 80 00       	push   $0x803b70
  8007dc:	e8 ac 03 00 00       	call   800b8d <cprintf>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	eb 7c                	jmp    800862 <umain+0x1ba>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	53                   	push   %ebx
  8007ea:	68 7a 3b 80 00       	push   $0x803b7a
  8007ef:	e8 03 1f 00 00       	call   8026f7 <printf>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	eb 78                	jmp    800871 <umain+0x1c9>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007f9:	83 ec 0c             	sub    $0xc,%esp
  8007fc:	68 80 3b 80 00       	push   $0x803b80
  800801:	e8 87 03 00 00       	call   800b8d <cprintf>
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	eb 73                	jmp    80087e <umain+0x1d6>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  80080b:	50                   	push   %eax
  80080c:	68 9a 3a 80 00       	push   $0x803a9a
  800811:	68 39 01 00 00       	push   $0x139
  800816:	68 bf 3a 80 00       	push   $0x803abf
  80081b:	e8 86 02 00 00       	call   800aa6 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	50                   	push   %eax
  800824:	68 8d 3b 80 00       	push   $0x803b8d
  800829:	e8 5f 03 00 00       	call   800b8d <cprintf>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	eb 5f                	jmp    800892 <umain+0x1ea>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800833:	83 ec 0c             	sub    $0xc,%esp
  800836:	56                   	push   %esi
  800837:	e8 21 2d 00 00       	call   80355d <wait>
  80083c:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80083f:	83 ec 0c             	sub    $0xc,%esp
  800842:	57                   	push   %edi
  800843:	e8 0c 09 00 00       	call   801154 <readline>
  800848:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	85 c0                	test   %eax,%eax
  80084f:	0f 84 59 ff ff ff    	je     8007ae <umain+0x106>
		if (debug)
  800855:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80085c:	0f 85 71 ff ff ff    	jne    8007d3 <umain+0x12b>
		if (buf[0] == '#')
  800862:	80 3b 23             	cmpb   $0x23,(%ebx)
  800865:	74 d8                	je     80083f <umain+0x197>
		if (echocmds)
  800867:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80086b:	0f 85 75 ff ff ff    	jne    8007e6 <umain+0x13e>
		if (debug)
  800871:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800878:	0f 85 7b ff ff ff    	jne    8007f9 <umain+0x151>
		if ((r = fork()) < 0)
  80087e:	e8 7e 12 00 00       	call   801b01 <fork>
  800883:	89 c6                	mov    %eax,%esi
  800885:	85 c0                	test   %eax,%eax
  800887:	78 82                	js     80080b <umain+0x163>
		if (debug)
  800889:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800890:	75 8e                	jne    800820 <umain+0x178>
		if (r == 0) {
  800892:	85 f6                	test   %esi,%esi
  800894:	75 9d                	jne    800833 <umain+0x18b>
			runcmd(buf);
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	53                   	push   %ebx
  80089a:	e8 63 f9 ff ff       	call   800202 <runcmd>
			exit();
  80089f:	e8 e4 01 00 00       	call   800a88 <exit>
  8008a4:	83 c4 10             	add    $0x10,%esp
  8008a7:	eb 96                	jmp    80083f <umain+0x197>

008008a9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008a9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b2:	c3                   	ret    

008008b3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008b3:	f3 0f 1e fb          	endbr32 
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8008bd:	68 09 3c 80 00       	push   $0x803c09
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	e8 c1 09 00 00       	call   80128b <strcpy>
	return 0;
}
  8008ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <devcons_write>:
{
  8008d1:	f3 0f 1e fb          	endbr32 
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	57                   	push   %edi
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008e1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8008ef:	73 31                	jae    800922 <devcons_write+0x51>
		m = n - tot;
  8008f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008f4:	29 f3                	sub    %esi,%ebx
  8008f6:	83 fb 7f             	cmp    $0x7f,%ebx
  8008f9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8008fe:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	53                   	push   %ebx
  800905:	89 f0                	mov    %esi,%eax
  800907:	03 45 0c             	add    0xc(%ebp),%eax
  80090a:	50                   	push   %eax
  80090b:	57                   	push   %edi
  80090c:	e8 30 0b 00 00       	call   801441 <memmove>
		sys_cputs(buf, m);
  800911:	83 c4 08             	add    $0x8,%esp
  800914:	53                   	push   %ebx
  800915:	57                   	push   %edi
  800916:	e8 e2 0c 00 00       	call   8015fd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80091b:	01 de                	add    %ebx,%esi
  80091d:	83 c4 10             	add    $0x10,%esp
  800920:	eb ca                	jmp    8008ec <devcons_write+0x1b>
}
  800922:	89 f0                	mov    %esi,%eax
  800924:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800927:	5b                   	pop    %ebx
  800928:	5e                   	pop    %esi
  800929:	5f                   	pop    %edi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <devcons_read>:
{
  80092c:	f3 0f 1e fb          	endbr32 
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80093b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80093f:	74 21                	je     800962 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  800941:	e8 d9 0c 00 00       	call   80161f <sys_cgetc>
  800946:	85 c0                	test   %eax,%eax
  800948:	75 07                	jne    800951 <devcons_read+0x25>
		sys_yield();
  80094a:	e8 5b 0d 00 00       	call   8016aa <sys_yield>
  80094f:	eb f0                	jmp    800941 <devcons_read+0x15>
	if (c < 0)
  800951:	78 0f                	js     800962 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  800953:	83 f8 04             	cmp    $0x4,%eax
  800956:	74 0c                	je     800964 <devcons_read+0x38>
	*(char*)vbuf = c;
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095b:	88 02                	mov    %al,(%edx)
	return 1;
  80095d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    
		return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
  800969:	eb f7                	jmp    800962 <devcons_read+0x36>

0080096b <cputchar>:
{
  80096b:	f3 0f 1e fb          	endbr32 
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80097b:	6a 01                	push   $0x1
  80097d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800980:	50                   	push   %eax
  800981:	e8 77 0c 00 00       	call   8015fd <sys_cputs>
}
  800986:	83 c4 10             	add    $0x10,%esp
  800989:	c9                   	leave  
  80098a:	c3                   	ret    

0080098b <getchar>:
{
  80098b:	f3 0f 1e fb          	endbr32 
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800995:	6a 01                	push   $0x1
  800997:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	6a 00                	push   $0x0
  80099d:	e8 09 17 00 00       	call   8020ab <read>
	if (r < 0)
  8009a2:	83 c4 10             	add    $0x10,%esp
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	78 06                	js     8009af <getchar+0x24>
	if (r < 1)
  8009a9:	74 06                	je     8009b1 <getchar+0x26>
	return c;
  8009ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    
		return -E_EOF;
  8009b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8009b6:	eb f7                	jmp    8009af <getchar+0x24>

008009b8 <iscons>:
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009c5:	50                   	push   %eax
  8009c6:	ff 75 08             	pushl  0x8(%ebp)
  8009c9:	e8 55 14 00 00       	call   801e23 <fd_lookup>
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	85 c0                	test   %eax,%eax
  8009d3:	78 11                	js     8009e6 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8009d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d8:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009de:	39 10                	cmp    %edx,(%eax)
  8009e0:	0f 94 c0             	sete   %al
  8009e3:	0f b6 c0             	movzbl %al,%eax
}
  8009e6:	c9                   	leave  
  8009e7:	c3                   	ret    

008009e8 <opencons>:
{
  8009e8:	f3 0f 1e fb          	endbr32 
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 d2 13 00 00       	call   801dcd <fd_alloc>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	85 c0                	test   %eax,%eax
  800a00:	78 3a                	js     800a3c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800a02:	83 ec 04             	sub    $0x4,%esp
  800a05:	68 07 04 00 00       	push   $0x407
  800a0a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0d:	6a 00                	push   $0x0
  800a0f:	e8 b9 0c 00 00       	call   8016cd <sys_page_alloc>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	85 c0                	test   %eax,%eax
  800a19:	78 21                	js     800a3c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  800a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1e:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a24:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a29:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a30:	83 ec 0c             	sub    $0xc,%esp
  800a33:	50                   	push   %eax
  800a34:	e8 65 13 00 00       	call   801d9e <fd2num>
  800a39:	83 c4 10             	add    $0x10,%esp
}
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a3e:	f3 0f 1e fb          	endbr32 
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	56                   	push   %esi
  800a46:	53                   	push   %ebx
  800a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a4a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a4d:	e8 35 0c 00 00       	call   801687 <sys_getenvid>
  800a52:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a57:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800a5a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a5f:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a64:	85 db                	test   %ebx,%ebx
  800a66:	7e 07                	jle    800a6f <libmain+0x31>
		binaryname = argv[0];
  800a68:	8b 06                	mov    (%esi),%eax
  800a6a:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	e8 2f fc ff ff       	call   8006a8 <umain>

	// exit gracefully
	exit();
  800a79:	e8 0a 00 00 00       	call   800a88 <exit>
}
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a88:	f3 0f 1e fb          	endbr32 
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a92:	e8 fb 14 00 00       	call   801f92 <close_all>
	sys_env_destroy(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 a1 0b 00 00       	call   801642 <sys_env_destroy>
}
  800aa1:	83 c4 10             	add    $0x10,%esp
  800aa4:	c9                   	leave  
  800aa5:	c3                   	ret    

00800aa6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800aa6:	f3 0f 1e fb          	endbr32 
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800aaf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ab2:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800ab8:	e8 ca 0b 00 00       	call   801687 <sys_getenvid>
  800abd:	83 ec 0c             	sub    $0xc,%esp
  800ac0:	ff 75 0c             	pushl  0xc(%ebp)
  800ac3:	ff 75 08             	pushl  0x8(%ebp)
  800ac6:	56                   	push   %esi
  800ac7:	50                   	push   %eax
  800ac8:	68 20 3c 80 00       	push   $0x803c20
  800acd:	e8 bb 00 00 00       	call   800b8d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ad2:	83 c4 18             	add    $0x18,%esp
  800ad5:	53                   	push   %ebx
  800ad6:	ff 75 10             	pushl  0x10(%ebp)
  800ad9:	e8 5a 00 00 00       	call   800b38 <vcprintf>
	cprintf("\n");
  800ade:	c7 04 24 20 3a 80 00 	movl   $0x803a20,(%esp)
  800ae5:	e8 a3 00 00 00       	call   800b8d <cprintf>
  800aea:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aed:	cc                   	int3   
  800aee:	eb fd                	jmp    800aed <_panic+0x47>

00800af0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800af0:	f3 0f 1e fb          	endbr32 
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	53                   	push   %ebx
  800af8:	83 ec 04             	sub    $0x4,%esp
  800afb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800afe:	8b 13                	mov    (%ebx),%edx
  800b00:	8d 42 01             	lea    0x1(%edx),%eax
  800b03:	89 03                	mov    %eax,(%ebx)
  800b05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b08:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b0c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b11:	74 09                	je     800b1c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b13:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	68 ff 00 00 00       	push   $0xff
  800b24:	8d 43 08             	lea    0x8(%ebx),%eax
  800b27:	50                   	push   %eax
  800b28:	e8 d0 0a 00 00       	call   8015fd <sys_cputs>
		b->idx = 0;
  800b2d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	eb db                	jmp    800b13 <putch+0x23>

00800b38 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b38:	f3 0f 1e fb          	endbr32 
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 f0 0a 80 00       	push   $0x800af0
  800b6b:	e8 20 01 00 00       	call   800c90 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b70:	83 c4 08             	add    $0x8,%esp
  800b73:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b79:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b7f:	50                   	push   %eax
  800b80:	e8 78 0a 00 00       	call   8015fd <sys_cputs>

	return b.cnt;
}
  800b85:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b8d:	f3 0f 1e fb          	endbr32 
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b97:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b9a:	50                   	push   %eax
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	e8 95 ff ff ff       	call   800b38 <vcprintf>
	va_end(ap);

	return cnt;
}
  800ba3:	c9                   	leave  
  800ba4:	c3                   	ret    

00800ba5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	83 ec 1c             	sub    $0x1c,%esp
  800bae:	89 c7                	mov    %eax,%edi
  800bb0:	89 d6                	mov    %edx,%esi
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	89 d1                	mov    %edx,%ecx
  800bba:	89 c2                	mov    %eax,%edx
  800bbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bbf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bcb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800bd2:	39 c2                	cmp    %eax,%edx
  800bd4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800bd7:	72 3e                	jb     800c17 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd9:	83 ec 0c             	sub    $0xc,%esp
  800bdc:	ff 75 18             	pushl  0x18(%ebp)
  800bdf:	83 eb 01             	sub    $0x1,%ebx
  800be2:	53                   	push   %ebx
  800be3:	50                   	push   %eax
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bea:	ff 75 e0             	pushl  -0x20(%ebp)
  800bed:	ff 75 dc             	pushl  -0x24(%ebp)
  800bf0:	ff 75 d8             	pushl  -0x28(%ebp)
  800bf3:	e8 a8 2b 00 00       	call   8037a0 <__udivdi3>
  800bf8:	83 c4 18             	add    $0x18,%esp
  800bfb:	52                   	push   %edx
  800bfc:	50                   	push   %eax
  800bfd:	89 f2                	mov    %esi,%edx
  800bff:	89 f8                	mov    %edi,%eax
  800c01:	e8 9f ff ff ff       	call   800ba5 <printnum>
  800c06:	83 c4 20             	add    $0x20,%esp
  800c09:	eb 13                	jmp    800c1e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	56                   	push   %esi
  800c0f:	ff 75 18             	pushl  0x18(%ebp)
  800c12:	ff d7                	call   *%edi
  800c14:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800c17:	83 eb 01             	sub    $0x1,%ebx
  800c1a:	85 db                	test   %ebx,%ebx
  800c1c:	7f ed                	jg     800c0b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c1e:	83 ec 08             	sub    $0x8,%esp
  800c21:	56                   	push   %esi
  800c22:	83 ec 04             	sub    $0x4,%esp
  800c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c28:	ff 75 e0             	pushl  -0x20(%ebp)
  800c2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800c2e:	ff 75 d8             	pushl  -0x28(%ebp)
  800c31:	e8 7a 2c 00 00       	call   8038b0 <__umoddi3>
  800c36:	83 c4 14             	add    $0x14,%esp
  800c39:	0f be 80 43 3c 80 00 	movsbl 0x803c43(%eax),%eax
  800c40:	50                   	push   %eax
  800c41:	ff d7                	call   *%edi
}
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c49:	5b                   	pop    %ebx
  800c4a:	5e                   	pop    %esi
  800c4b:	5f                   	pop    %edi
  800c4c:	5d                   	pop    %ebp
  800c4d:	c3                   	ret    

00800c4e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4e:	f3 0f 1e fb          	endbr32 
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c58:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5c:	8b 10                	mov    (%eax),%edx
  800c5e:	3b 50 04             	cmp    0x4(%eax),%edx
  800c61:	73 0a                	jae    800c6d <sprintputch+0x1f>
		*b->buf++ = ch;
  800c63:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c66:	89 08                	mov    %ecx,(%eax)
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	88 02                	mov    %al,(%edx)
}
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <printfmt>:
{
  800c6f:	f3 0f 1e fb          	endbr32 
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c79:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c7c:	50                   	push   %eax
  800c7d:	ff 75 10             	pushl  0x10(%ebp)
  800c80:	ff 75 0c             	pushl  0xc(%ebp)
  800c83:	ff 75 08             	pushl  0x8(%ebp)
  800c86:	e8 05 00 00 00       	call   800c90 <vprintfmt>
}
  800c8b:	83 c4 10             	add    $0x10,%esp
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <vprintfmt>:
{
  800c90:	f3 0f 1e fb          	endbr32 
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
  800c9a:	83 ec 3c             	sub    $0x3c,%esp
  800c9d:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca3:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ca6:	e9 8e 03 00 00       	jmp    801039 <vprintfmt+0x3a9>
		padc = ' ';
  800cab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800caf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800cb6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800cbd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800cc9:	8d 47 01             	lea    0x1(%edi),%eax
  800ccc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ccf:	0f b6 17             	movzbl (%edi),%edx
  800cd2:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cd5:	3c 55                	cmp    $0x55,%al
  800cd7:	0f 87 df 03 00 00    	ja     8010bc <vprintfmt+0x42c>
  800cdd:	0f b6 c0             	movzbl %al,%eax
  800ce0:	3e ff 24 85 80 3d 80 	notrack jmp *0x803d80(,%eax,4)
  800ce7:	00 
  800ce8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ceb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800cef:	eb d8                	jmp    800cc9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800cf4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800cf8:	eb cf                	jmp    800cc9 <vprintfmt+0x39>
  800cfa:	0f b6 d2             	movzbl %dl,%edx
  800cfd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800d00:	b8 00 00 00 00       	mov    $0x0,%eax
  800d05:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800d08:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d0b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800d0f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d12:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d15:	83 f9 09             	cmp    $0x9,%ecx
  800d18:	77 55                	ja     800d6f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800d1a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800d1d:	eb e9                	jmp    800d08 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d27:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2a:	8d 40 04             	lea    0x4(%eax),%eax
  800d2d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d37:	79 90                	jns    800cc9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d3f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800d46:	eb 81                	jmp    800cc9 <vprintfmt+0x39>
  800d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d52:	0f 49 d0             	cmovns %eax,%edx
  800d55:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d58:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d5b:	e9 69 ff ff ff       	jmp    800cc9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800d60:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d63:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800d6a:	e9 5a ff ff ff       	jmp    800cc9 <vprintfmt+0x39>
  800d6f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d72:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d75:	eb bc                	jmp    800d33 <vprintfmt+0xa3>
			lflag++;
  800d77:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d7d:	e9 47 ff ff ff       	jmp    800cc9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800d82:	8b 45 14             	mov    0x14(%ebp),%eax
  800d85:	8d 78 04             	lea    0x4(%eax),%edi
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	53                   	push   %ebx
  800d8c:	ff 30                	pushl  (%eax)
  800d8e:	ff d6                	call   *%esi
			break;
  800d90:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d93:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d96:	e9 9b 02 00 00       	jmp    801036 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800d9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9e:	8d 78 04             	lea    0x4(%eax),%edi
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	99                   	cltd   
  800da4:	31 d0                	xor    %edx,%eax
  800da6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da8:	83 f8 0f             	cmp    $0xf,%eax
  800dab:	7f 23                	jg     800dd0 <vprintfmt+0x140>
  800dad:	8b 14 85 e0 3e 80 00 	mov    0x803ee0(,%eax,4),%edx
  800db4:	85 d2                	test   %edx,%edx
  800db6:	74 18                	je     800dd0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800db8:	52                   	push   %edx
  800db9:	68 61 3b 80 00       	push   $0x803b61
  800dbe:	53                   	push   %ebx
  800dbf:	56                   	push   %esi
  800dc0:	e8 aa fe ff ff       	call   800c6f <printfmt>
  800dc5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc8:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dcb:	e9 66 02 00 00       	jmp    801036 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800dd0:	50                   	push   %eax
  800dd1:	68 5b 3c 80 00       	push   $0x803c5b
  800dd6:	53                   	push   %ebx
  800dd7:	56                   	push   %esi
  800dd8:	e8 92 fe ff ff       	call   800c6f <printfmt>
  800ddd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800de0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800de3:	e9 4e 02 00 00       	jmp    801036 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800de8:	8b 45 14             	mov    0x14(%ebp),%eax
  800deb:	83 c0 04             	add    $0x4,%eax
  800dee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800df1:	8b 45 14             	mov    0x14(%ebp),%eax
  800df4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800df6:	85 d2                	test   %edx,%edx
  800df8:	b8 54 3c 80 00       	mov    $0x803c54,%eax
  800dfd:	0f 45 c2             	cmovne %edx,%eax
  800e00:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800e03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e07:	7e 06                	jle    800e0f <vprintfmt+0x17f>
  800e09:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800e0d:	75 0d                	jne    800e1c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800e12:	89 c7                	mov    %eax,%edi
  800e14:	03 45 e0             	add    -0x20(%ebp),%eax
  800e17:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e1a:	eb 55                	jmp    800e71 <vprintfmt+0x1e1>
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 d8             	pushl  -0x28(%ebp)
  800e22:	ff 75 cc             	pushl  -0x34(%ebp)
  800e25:	e8 3a 04 00 00       	call   801264 <strnlen>
  800e2a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e2d:	29 c2                	sub    %eax,%edx
  800e2f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800e37:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800e3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800e3e:	85 ff                	test   %edi,%edi
  800e40:	7e 11                	jle    800e53 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	53                   	push   %ebx
  800e46:	ff 75 e0             	pushl  -0x20(%ebp)
  800e49:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e4b:	83 ef 01             	sub    $0x1,%edi
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	eb eb                	jmp    800e3e <vprintfmt+0x1ae>
  800e53:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800e56:	85 d2                	test   %edx,%edx
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5d:	0f 49 c2             	cmovns %edx,%eax
  800e60:	29 c2                	sub    %eax,%edx
  800e62:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800e65:	eb a8                	jmp    800e0f <vprintfmt+0x17f>
					putch(ch, putdat);
  800e67:	83 ec 08             	sub    $0x8,%esp
  800e6a:	53                   	push   %ebx
  800e6b:	52                   	push   %edx
  800e6c:	ff d6                	call   *%esi
  800e6e:	83 c4 10             	add    $0x10,%esp
  800e71:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e74:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e76:	83 c7 01             	add    $0x1,%edi
  800e79:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e7d:	0f be d0             	movsbl %al,%edx
  800e80:	85 d2                	test   %edx,%edx
  800e82:	74 4b                	je     800ecf <vprintfmt+0x23f>
  800e84:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e88:	78 06                	js     800e90 <vprintfmt+0x200>
  800e8a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800e8e:	78 1e                	js     800eae <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800e90:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800e94:	74 d1                	je     800e67 <vprintfmt+0x1d7>
  800e96:	0f be c0             	movsbl %al,%eax
  800e99:	83 e8 20             	sub    $0x20,%eax
  800e9c:	83 f8 5e             	cmp    $0x5e,%eax
  800e9f:	76 c6                	jbe    800e67 <vprintfmt+0x1d7>
					putch('?', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	53                   	push   %ebx
  800ea5:	6a 3f                	push   $0x3f
  800ea7:	ff d6                	call   *%esi
  800ea9:	83 c4 10             	add    $0x10,%esp
  800eac:	eb c3                	jmp    800e71 <vprintfmt+0x1e1>
  800eae:	89 cf                	mov    %ecx,%edi
  800eb0:	eb 0e                	jmp    800ec0 <vprintfmt+0x230>
				putch(' ', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	53                   	push   %ebx
  800eb6:	6a 20                	push   $0x20
  800eb8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800eba:	83 ef 01             	sub    $0x1,%edi
  800ebd:	83 c4 10             	add    $0x10,%esp
  800ec0:	85 ff                	test   %edi,%edi
  800ec2:	7f ee                	jg     800eb2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800ec4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ec7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eca:	e9 67 01 00 00       	jmp    801036 <vprintfmt+0x3a6>
  800ecf:	89 cf                	mov    %ecx,%edi
  800ed1:	eb ed                	jmp    800ec0 <vprintfmt+0x230>
	if (lflag >= 2)
  800ed3:	83 f9 01             	cmp    $0x1,%ecx
  800ed6:	7f 1b                	jg     800ef3 <vprintfmt+0x263>
	else if (lflag)
  800ed8:	85 c9                	test   %ecx,%ecx
  800eda:	74 63                	je     800f3f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800edc:	8b 45 14             	mov    0x14(%ebp),%eax
  800edf:	8b 00                	mov    (%eax),%eax
  800ee1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ee4:	99                   	cltd   
  800ee5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eeb:	8d 40 04             	lea    0x4(%eax),%eax
  800eee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef1:	eb 17                	jmp    800f0a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef6:	8b 50 04             	mov    0x4(%eax),%edx
  800ef9:	8b 00                	mov    (%eax),%eax
  800efb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800efe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f01:	8b 45 14             	mov    0x14(%ebp),%eax
  800f04:	8d 40 08             	lea    0x8(%eax),%eax
  800f07:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800f0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f0d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800f10:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800f15:	85 c9                	test   %ecx,%ecx
  800f17:	0f 89 ff 00 00 00    	jns    80101c <vprintfmt+0x38c>
				putch('-', putdat);
  800f1d:	83 ec 08             	sub    $0x8,%esp
  800f20:	53                   	push   %ebx
  800f21:	6a 2d                	push   $0x2d
  800f23:	ff d6                	call   *%esi
				num = -(long long) num;
  800f25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f28:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f2b:	f7 da                	neg    %edx
  800f2d:	83 d1 00             	adc    $0x0,%ecx
  800f30:	f7 d9                	neg    %ecx
  800f32:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3a:	e9 dd 00 00 00       	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	8b 00                	mov    (%eax),%eax
  800f44:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f47:	99                   	cltd   
  800f48:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4e:	8d 40 04             	lea    0x4(%eax),%eax
  800f51:	89 45 14             	mov    %eax,0x14(%ebp)
  800f54:	eb b4                	jmp    800f0a <vprintfmt+0x27a>
	if (lflag >= 2)
  800f56:	83 f9 01             	cmp    $0x1,%ecx
  800f59:	7f 1e                	jg     800f79 <vprintfmt+0x2e9>
	else if (lflag)
  800f5b:	85 c9                	test   %ecx,%ecx
  800f5d:	74 32                	je     800f91 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800f5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f69:	8d 40 04             	lea    0x4(%eax),%eax
  800f6c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f6f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800f74:	e9 a3 00 00 00       	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800f79:	8b 45 14             	mov    0x14(%ebp),%eax
  800f7c:	8b 10                	mov    (%eax),%edx
  800f7e:	8b 48 04             	mov    0x4(%eax),%ecx
  800f81:	8d 40 08             	lea    0x8(%eax),%eax
  800f84:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f87:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800f8c:	e9 8b 00 00 00       	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800f91:	8b 45 14             	mov    0x14(%ebp),%eax
  800f94:	8b 10                	mov    (%eax),%edx
  800f96:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9b:	8d 40 04             	lea    0x4(%eax),%eax
  800f9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fa1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800fa6:	eb 74                	jmp    80101c <vprintfmt+0x38c>
	if (lflag >= 2)
  800fa8:	83 f9 01             	cmp    $0x1,%ecx
  800fab:	7f 1b                	jg     800fc8 <vprintfmt+0x338>
	else if (lflag)
  800fad:	85 c9                	test   %ecx,%ecx
  800faf:	74 2c                	je     800fdd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800fb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb4:	8b 10                	mov    (%eax),%edx
  800fb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbb:	8d 40 04             	lea    0x4(%eax),%eax
  800fbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fc1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800fc6:	eb 54                	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	8b 10                	mov    (%eax),%edx
  800fcd:	8b 48 04             	mov    0x4(%eax),%ecx
  800fd0:	8d 40 08             	lea    0x8(%eax),%eax
  800fd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fd6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800fdb:	eb 3f                	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe0:	8b 10                	mov    (%eax),%edx
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	8d 40 04             	lea    0x4(%eax),%eax
  800fea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fed:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800ff2:	eb 28                	jmp    80101c <vprintfmt+0x38c>
			putch('0', putdat);
  800ff4:	83 ec 08             	sub    $0x8,%esp
  800ff7:	53                   	push   %ebx
  800ff8:	6a 30                	push   $0x30
  800ffa:	ff d6                	call   *%esi
			putch('x', putdat);
  800ffc:	83 c4 08             	add    $0x8,%esp
  800fff:	53                   	push   %ebx
  801000:	6a 78                	push   $0x78
  801002:	ff d6                	call   *%esi
			num = (unsigned long long)
  801004:	8b 45 14             	mov    0x14(%ebp),%eax
  801007:	8b 10                	mov    (%eax),%edx
  801009:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80100e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801011:	8d 40 04             	lea    0x4(%eax),%eax
  801014:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801017:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80101c:	83 ec 0c             	sub    $0xc,%esp
  80101f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801023:	57                   	push   %edi
  801024:	ff 75 e0             	pushl  -0x20(%ebp)
  801027:	50                   	push   %eax
  801028:	51                   	push   %ecx
  801029:	52                   	push   %edx
  80102a:	89 da                	mov    %ebx,%edx
  80102c:	89 f0                	mov    %esi,%eax
  80102e:	e8 72 fb ff ff       	call   800ba5 <printnum>
			break;
  801033:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801036:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801039:	83 c7 01             	add    $0x1,%edi
  80103c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801040:	83 f8 25             	cmp    $0x25,%eax
  801043:	0f 84 62 fc ff ff    	je     800cab <vprintfmt+0x1b>
			if (ch == '\0')
  801049:	85 c0                	test   %eax,%eax
  80104b:	0f 84 8b 00 00 00    	je     8010dc <vprintfmt+0x44c>
			putch(ch, putdat);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	53                   	push   %ebx
  801055:	50                   	push   %eax
  801056:	ff d6                	call   *%esi
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	eb dc                	jmp    801039 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80105d:	83 f9 01             	cmp    $0x1,%ecx
  801060:	7f 1b                	jg     80107d <vprintfmt+0x3ed>
	else if (lflag)
  801062:	85 c9                	test   %ecx,%ecx
  801064:	74 2c                	je     801092 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	8b 10                	mov    (%eax),%edx
  80106b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801070:	8d 40 04             	lea    0x4(%eax),%eax
  801073:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801076:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80107b:	eb 9f                	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80107d:	8b 45 14             	mov    0x14(%ebp),%eax
  801080:	8b 10                	mov    (%eax),%edx
  801082:	8b 48 04             	mov    0x4(%eax),%ecx
  801085:	8d 40 08             	lea    0x8(%eax),%eax
  801088:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80108b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801090:	eb 8a                	jmp    80101c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801092:	8b 45 14             	mov    0x14(%ebp),%eax
  801095:	8b 10                	mov    (%eax),%edx
  801097:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109c:	8d 40 04             	lea    0x4(%eax),%eax
  80109f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010a2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8010a7:	e9 70 ff ff ff       	jmp    80101c <vprintfmt+0x38c>
			putch(ch, putdat);
  8010ac:	83 ec 08             	sub    $0x8,%esp
  8010af:	53                   	push   %ebx
  8010b0:	6a 25                	push   $0x25
  8010b2:	ff d6                	call   *%esi
			break;
  8010b4:	83 c4 10             	add    $0x10,%esp
  8010b7:	e9 7a ff ff ff       	jmp    801036 <vprintfmt+0x3a6>
			putch('%', putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	53                   	push   %ebx
  8010c0:	6a 25                	push   $0x25
  8010c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	89 f8                	mov    %edi,%eax
  8010c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010cd:	74 05                	je     8010d4 <vprintfmt+0x444>
  8010cf:	83 e8 01             	sub    $0x1,%eax
  8010d2:	eb f5                	jmp    8010c9 <vprintfmt+0x439>
  8010d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010d7:	e9 5a ff ff ff       	jmp    801036 <vprintfmt+0x3a6>
}
  8010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010df:	5b                   	pop    %ebx
  8010e0:	5e                   	pop    %esi
  8010e1:	5f                   	pop    %edi
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010e4:	f3 0f 1e fb          	endbr32 
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 18             	sub    $0x18,%esp
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801105:	85 c0                	test   %eax,%eax
  801107:	74 26                	je     80112f <vsnprintf+0x4b>
  801109:	85 d2                	test   %edx,%edx
  80110b:	7e 22                	jle    80112f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110d:	ff 75 14             	pushl  0x14(%ebp)
  801110:	ff 75 10             	pushl  0x10(%ebp)
  801113:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	68 4e 0c 80 00       	push   $0x800c4e
  80111c:	e8 6f fb ff ff       	call   800c90 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801124:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112a:	83 c4 10             	add    $0x10,%esp
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    
		return -E_INVAL;
  80112f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801134:	eb f7                	jmp    80112d <vsnprintf+0x49>

00801136 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801136:	f3 0f 1e fb          	endbr32 
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801140:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801143:	50                   	push   %eax
  801144:	ff 75 10             	pushl  0x10(%ebp)
  801147:	ff 75 0c             	pushl  0xc(%ebp)
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	e8 92 ff ff ff       	call   8010e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801154:	f3 0f 1e fb          	endbr32 
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  801164:	85 c0                	test   %eax,%eax
  801166:	74 13                	je     80117b <readline+0x27>
		fprintf(1, "%s", prompt);
  801168:	83 ec 04             	sub    $0x4,%esp
  80116b:	50                   	push   %eax
  80116c:	68 61 3b 80 00       	push   $0x803b61
  801171:	6a 01                	push   $0x1
  801173:	e8 64 15 00 00       	call   8026dc <fprintf>
  801178:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	6a 00                	push   $0x0
  801180:	e8 33 f8 ff ff       	call   8009b8 <iscons>
  801185:	89 c7                	mov    %eax,%edi
  801187:	83 c4 10             	add    $0x10,%esp
	i = 0;
  80118a:	be 00 00 00 00       	mov    $0x0,%esi
  80118f:	eb 57                	jmp    8011e8 <readline+0x94>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
  801196:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801199:	75 08                	jne    8011a3 <readline+0x4f>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
  80119b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    
				cprintf("read error: %e\n", c);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	53                   	push   %ebx
  8011a7:	68 3f 3f 80 00       	push   $0x803f3f
  8011ac:	e8 dc f9 ff ff       	call   800b8d <cprintf>
  8011b1:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b9:	eb e0                	jmp    80119b <readline+0x47>
			if (echoing)
  8011bb:	85 ff                	test   %edi,%edi
  8011bd:	75 05                	jne    8011c4 <readline+0x70>
			i--;
  8011bf:	83 ee 01             	sub    $0x1,%esi
  8011c2:	eb 24                	jmp    8011e8 <readline+0x94>
				cputchar('\b');
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	6a 08                	push   $0x8
  8011c9:	e8 9d f7 ff ff       	call   80096b <cputchar>
  8011ce:	83 c4 10             	add    $0x10,%esp
  8011d1:	eb ec                	jmp    8011bf <readline+0x6b>
				cputchar(c);
  8011d3:	83 ec 0c             	sub    $0xc,%esp
  8011d6:	53                   	push   %ebx
  8011d7:	e8 8f f7 ff ff       	call   80096b <cputchar>
  8011dc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011df:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8011e5:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
  8011e8:	e8 9e f7 ff ff       	call   80098b <getchar>
  8011ed:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 9e                	js     801191 <readline+0x3d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011f3:	83 f8 08             	cmp    $0x8,%eax
  8011f6:	0f 94 c2             	sete   %dl
  8011f9:	83 f8 7f             	cmp    $0x7f,%eax
  8011fc:	0f 94 c0             	sete   %al
  8011ff:	08 c2                	or     %al,%dl
  801201:	74 04                	je     801207 <readline+0xb3>
  801203:	85 f6                	test   %esi,%esi
  801205:	7f b4                	jg     8011bb <readline+0x67>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801207:	83 fb 1f             	cmp    $0x1f,%ebx
  80120a:	7e 0e                	jle    80121a <readline+0xc6>
  80120c:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801212:	7f 06                	jg     80121a <readline+0xc6>
			if (echoing)
  801214:	85 ff                	test   %edi,%edi
  801216:	74 c7                	je     8011df <readline+0x8b>
  801218:	eb b9                	jmp    8011d3 <readline+0x7f>
		} else if (c == '\n' || c == '\r') {
  80121a:	83 fb 0a             	cmp    $0xa,%ebx
  80121d:	74 05                	je     801224 <readline+0xd0>
  80121f:	83 fb 0d             	cmp    $0xd,%ebx
  801222:	75 c4                	jne    8011e8 <readline+0x94>
			if (echoing)
  801224:	85 ff                	test   %edi,%edi
  801226:	75 11                	jne    801239 <readline+0xe5>
			buf[i] = 0;
  801228:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  80122f:	b8 20 60 80 00       	mov    $0x806020,%eax
  801234:	e9 62 ff ff ff       	jmp    80119b <readline+0x47>
				cputchar('\n');
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	6a 0a                	push   $0xa
  80123e:	e8 28 f7 ff ff       	call   80096b <cputchar>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	eb e0                	jmp    801228 <readline+0xd4>

00801248 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801248:	f3 0f 1e fb          	endbr32 
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
  801257:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80125b:	74 05                	je     801262 <strlen+0x1a>
		n++;
  80125d:	83 c0 01             	add    $0x1,%eax
  801260:	eb f5                	jmp    801257 <strlen+0xf>
	return n;
}
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    

00801264 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801264:	f3 0f 1e fb          	endbr32 
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801271:	b8 00 00 00 00       	mov    $0x0,%eax
  801276:	39 d0                	cmp    %edx,%eax
  801278:	74 0d                	je     801287 <strnlen+0x23>
  80127a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80127e:	74 05                	je     801285 <strnlen+0x21>
		n++;
  801280:	83 c0 01             	add    $0x1,%eax
  801283:	eb f1                	jmp    801276 <strnlen+0x12>
  801285:	89 c2                	mov    %eax,%edx
	return n;
}
  801287:	89 d0                	mov    %edx,%eax
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128b:	f3 0f 1e fb          	endbr32 
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	53                   	push   %ebx
  801293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801296:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8012a2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8012a5:	83 c0 01             	add    $0x1,%eax
  8012a8:	84 d2                	test   %dl,%dl
  8012aa:	75 f2                	jne    80129e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8012ac:	89 c8                	mov    %ecx,%eax
  8012ae:	5b                   	pop    %ebx
  8012af:	5d                   	pop    %ebp
  8012b0:	c3                   	ret    

008012b1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012b1:	f3 0f 1e fb          	endbr32 
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	53                   	push   %ebx
  8012b9:	83 ec 10             	sub    $0x10,%esp
  8012bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012bf:	53                   	push   %ebx
  8012c0:	e8 83 ff ff ff       	call   801248 <strlen>
  8012c5:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	01 d8                	add    %ebx,%eax
  8012cd:	50                   	push   %eax
  8012ce:	e8 b8 ff ff ff       	call   80128b <strcpy>
	return dst;
}
  8012d3:	89 d8                	mov    %ebx,%eax
  8012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012da:	f3 0f 1e fb          	endbr32 
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	56                   	push   %esi
  8012e2:	53                   	push   %ebx
  8012e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e9:	89 f3                	mov    %esi,%ebx
  8012eb:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ee:	89 f0                	mov    %esi,%eax
  8012f0:	39 d8                	cmp    %ebx,%eax
  8012f2:	74 11                	je     801305 <strncpy+0x2b>
		*dst++ = *src;
  8012f4:	83 c0 01             	add    $0x1,%eax
  8012f7:	0f b6 0a             	movzbl (%edx),%ecx
  8012fa:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012fd:	80 f9 01             	cmp    $0x1,%cl
  801300:	83 da ff             	sbb    $0xffffffff,%edx
  801303:	eb eb                	jmp    8012f0 <strncpy+0x16>
	}
	return ret;
}
  801305:	89 f0                	mov    %esi,%eax
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80130b:	f3 0f 1e fb          	endbr32 
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	56                   	push   %esi
  801313:	53                   	push   %ebx
  801314:	8b 75 08             	mov    0x8(%ebp),%esi
  801317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131a:	8b 55 10             	mov    0x10(%ebp),%edx
  80131d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80131f:	85 d2                	test   %edx,%edx
  801321:	74 21                	je     801344 <strlcpy+0x39>
  801323:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801327:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801329:	39 c2                	cmp    %eax,%edx
  80132b:	74 14                	je     801341 <strlcpy+0x36>
  80132d:	0f b6 19             	movzbl (%ecx),%ebx
  801330:	84 db                	test   %bl,%bl
  801332:	74 0b                	je     80133f <strlcpy+0x34>
			*dst++ = *src++;
  801334:	83 c1 01             	add    $0x1,%ecx
  801337:	83 c2 01             	add    $0x1,%edx
  80133a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80133d:	eb ea                	jmp    801329 <strlcpy+0x1e>
  80133f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801341:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801344:	29 f0                	sub    %esi,%eax
}
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134a:	f3 0f 1e fb          	endbr32 
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801354:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801357:	0f b6 01             	movzbl (%ecx),%eax
  80135a:	84 c0                	test   %al,%al
  80135c:	74 0c                	je     80136a <strcmp+0x20>
  80135e:	3a 02                	cmp    (%edx),%al
  801360:	75 08                	jne    80136a <strcmp+0x20>
		p++, q++;
  801362:	83 c1 01             	add    $0x1,%ecx
  801365:	83 c2 01             	add    $0x1,%edx
  801368:	eb ed                	jmp    801357 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80136a:	0f b6 c0             	movzbl %al,%eax
  80136d:	0f b6 12             	movzbl (%edx),%edx
  801370:	29 d0                	sub    %edx,%eax
}
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    

00801374 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801374:	f3 0f 1e fb          	endbr32 
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	53                   	push   %ebx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801382:	89 c3                	mov    %eax,%ebx
  801384:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801387:	eb 06                	jmp    80138f <strncmp+0x1b>
		n--, p++, q++;
  801389:	83 c0 01             	add    $0x1,%eax
  80138c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80138f:	39 d8                	cmp    %ebx,%eax
  801391:	74 16                	je     8013a9 <strncmp+0x35>
  801393:	0f b6 08             	movzbl (%eax),%ecx
  801396:	84 c9                	test   %cl,%cl
  801398:	74 04                	je     80139e <strncmp+0x2a>
  80139a:	3a 0a                	cmp    (%edx),%cl
  80139c:	74 eb                	je     801389 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80139e:	0f b6 00             	movzbl (%eax),%eax
  8013a1:	0f b6 12             	movzbl (%edx),%edx
  8013a4:	29 d0                	sub    %edx,%eax
}
  8013a6:	5b                   	pop    %ebx
  8013a7:	5d                   	pop    %ebp
  8013a8:	c3                   	ret    
		return 0;
  8013a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ae:	eb f6                	jmp    8013a6 <strncmp+0x32>

008013b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013b0:	f3 0f 1e fb          	endbr32 
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013be:	0f b6 10             	movzbl (%eax),%edx
  8013c1:	84 d2                	test   %dl,%dl
  8013c3:	74 09                	je     8013ce <strchr+0x1e>
		if (*s == c)
  8013c5:	38 ca                	cmp    %cl,%dl
  8013c7:	74 0a                	je     8013d3 <strchr+0x23>
	for (; *s; s++)
  8013c9:	83 c0 01             	add    $0x1,%eax
  8013cc:	eb f0                	jmp    8013be <strchr+0xe>
			return (char *) s;
	return 0;
  8013ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    

008013d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013d5:	f3 0f 1e fb          	endbr32 
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013e3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8013e6:	38 ca                	cmp    %cl,%dl
  8013e8:	74 09                	je     8013f3 <strfind+0x1e>
  8013ea:	84 d2                	test   %dl,%dl
  8013ec:	74 05                	je     8013f3 <strfind+0x1e>
	for (; *s; s++)
  8013ee:	83 c0 01             	add    $0x1,%eax
  8013f1:	eb f0                	jmp    8013e3 <strfind+0xe>
			break;
	return (char *) s;
}
  8013f3:	5d                   	pop    %ebp
  8013f4:	c3                   	ret    

008013f5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013f5:	f3 0f 1e fb          	endbr32 
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	57                   	push   %edi
  8013fd:	56                   	push   %esi
  8013fe:	53                   	push   %ebx
  8013ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801402:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801405:	85 c9                	test   %ecx,%ecx
  801407:	74 31                	je     80143a <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801409:	89 f8                	mov    %edi,%eax
  80140b:	09 c8                	or     %ecx,%eax
  80140d:	a8 03                	test   $0x3,%al
  80140f:	75 23                	jne    801434 <memset+0x3f>
		c &= 0xFF;
  801411:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801415:	89 d3                	mov    %edx,%ebx
  801417:	c1 e3 08             	shl    $0x8,%ebx
  80141a:	89 d0                	mov    %edx,%eax
  80141c:	c1 e0 18             	shl    $0x18,%eax
  80141f:	89 d6                	mov    %edx,%esi
  801421:	c1 e6 10             	shl    $0x10,%esi
  801424:	09 f0                	or     %esi,%eax
  801426:	09 c2                	or     %eax,%edx
  801428:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80142a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80142d:	89 d0                	mov    %edx,%eax
  80142f:	fc                   	cld    
  801430:	f3 ab                	rep stos %eax,%es:(%edi)
  801432:	eb 06                	jmp    80143a <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	fc                   	cld    
  801438:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80143a:	89 f8                	mov    %edi,%eax
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801441:	f3 0f 1e fb          	endbr32 
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	57                   	push   %edi
  801449:	56                   	push   %esi
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801450:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801453:	39 c6                	cmp    %eax,%esi
  801455:	73 32                	jae    801489 <memmove+0x48>
  801457:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80145a:	39 c2                	cmp    %eax,%edx
  80145c:	76 2b                	jbe    801489 <memmove+0x48>
		s += n;
		d += n;
  80145e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801461:	89 fe                	mov    %edi,%esi
  801463:	09 ce                	or     %ecx,%esi
  801465:	09 d6                	or     %edx,%esi
  801467:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80146d:	75 0e                	jne    80147d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80146f:	83 ef 04             	sub    $0x4,%edi
  801472:	8d 72 fc             	lea    -0x4(%edx),%esi
  801475:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801478:	fd                   	std    
  801479:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80147b:	eb 09                	jmp    801486 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80147d:	83 ef 01             	sub    $0x1,%edi
  801480:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801483:	fd                   	std    
  801484:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801486:	fc                   	cld    
  801487:	eb 1a                	jmp    8014a3 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801489:	89 c2                	mov    %eax,%edx
  80148b:	09 ca                	or     %ecx,%edx
  80148d:	09 f2                	or     %esi,%edx
  80148f:	f6 c2 03             	test   $0x3,%dl
  801492:	75 0a                	jne    80149e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801494:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801497:	89 c7                	mov    %eax,%edi
  801499:	fc                   	cld    
  80149a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80149c:	eb 05                	jmp    8014a3 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80149e:	89 c7                	mov    %eax,%edi
  8014a0:	fc                   	cld    
  8014a1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8014a7:	f3 0f 1e fb          	endbr32 
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8014b1:	ff 75 10             	pushl  0x10(%ebp)
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	e8 82 ff ff ff       	call   801441 <memmove>
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8014c1:	f3 0f 1e fb          	endbr32 
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	56                   	push   %esi
  8014c9:	53                   	push   %ebx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	89 c6                	mov    %eax,%esi
  8014d2:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014d5:	39 f0                	cmp    %esi,%eax
  8014d7:	74 1c                	je     8014f5 <memcmp+0x34>
		if (*s1 != *s2)
  8014d9:	0f b6 08             	movzbl (%eax),%ecx
  8014dc:	0f b6 1a             	movzbl (%edx),%ebx
  8014df:	38 d9                	cmp    %bl,%cl
  8014e1:	75 08                	jne    8014eb <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014e3:	83 c0 01             	add    $0x1,%eax
  8014e6:	83 c2 01             	add    $0x1,%edx
  8014e9:	eb ea                	jmp    8014d5 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8014eb:	0f b6 c1             	movzbl %cl,%eax
  8014ee:	0f b6 db             	movzbl %bl,%ebx
  8014f1:	29 d8                	sub    %ebx,%eax
  8014f3:	eb 05                	jmp    8014fa <memcmp+0x39>
	}

	return 0;
  8014f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fa:	5b                   	pop    %ebx
  8014fb:	5e                   	pop    %esi
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014fe:	f3 0f 1e fb          	endbr32 
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80150b:	89 c2                	mov    %eax,%edx
  80150d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801510:	39 d0                	cmp    %edx,%eax
  801512:	73 09                	jae    80151d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801514:	38 08                	cmp    %cl,(%eax)
  801516:	74 05                	je     80151d <memfind+0x1f>
	for (; s < ends; s++)
  801518:	83 c0 01             	add    $0x1,%eax
  80151b:	eb f3                	jmp    801510 <memfind+0x12>
			break;
	return (void *) s;
}
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    

0080151f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80151f:	f3 0f 1e fb          	endbr32 
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	57                   	push   %edi
  801527:	56                   	push   %esi
  801528:	53                   	push   %ebx
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80152f:	eb 03                	jmp    801534 <strtol+0x15>
		s++;
  801531:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801534:	0f b6 01             	movzbl (%ecx),%eax
  801537:	3c 20                	cmp    $0x20,%al
  801539:	74 f6                	je     801531 <strtol+0x12>
  80153b:	3c 09                	cmp    $0x9,%al
  80153d:	74 f2                	je     801531 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80153f:	3c 2b                	cmp    $0x2b,%al
  801541:	74 2a                	je     80156d <strtol+0x4e>
	int neg = 0;
  801543:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801548:	3c 2d                	cmp    $0x2d,%al
  80154a:	74 2b                	je     801577 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80154c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801552:	75 0f                	jne    801563 <strtol+0x44>
  801554:	80 39 30             	cmpb   $0x30,(%ecx)
  801557:	74 28                	je     801581 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801559:	85 db                	test   %ebx,%ebx
  80155b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801560:	0f 44 d8             	cmove  %eax,%ebx
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80156b:	eb 46                	jmp    8015b3 <strtol+0x94>
		s++;
  80156d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801570:	bf 00 00 00 00       	mov    $0x0,%edi
  801575:	eb d5                	jmp    80154c <strtol+0x2d>
		s++, neg = 1;
  801577:	83 c1 01             	add    $0x1,%ecx
  80157a:	bf 01 00 00 00       	mov    $0x1,%edi
  80157f:	eb cb                	jmp    80154c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801581:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801585:	74 0e                	je     801595 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801587:	85 db                	test   %ebx,%ebx
  801589:	75 d8                	jne    801563 <strtol+0x44>
		s++, base = 8;
  80158b:	83 c1 01             	add    $0x1,%ecx
  80158e:	bb 08 00 00 00       	mov    $0x8,%ebx
  801593:	eb ce                	jmp    801563 <strtol+0x44>
		s += 2, base = 16;
  801595:	83 c1 02             	add    $0x2,%ecx
  801598:	bb 10 00 00 00       	mov    $0x10,%ebx
  80159d:	eb c4                	jmp    801563 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80159f:	0f be d2             	movsbl %dl,%edx
  8015a2:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8015a5:	3b 55 10             	cmp    0x10(%ebp),%edx
  8015a8:	7d 3a                	jge    8015e4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8015aa:	83 c1 01             	add    $0x1,%ecx
  8015ad:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015b1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8015b3:	0f b6 11             	movzbl (%ecx),%edx
  8015b6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8015b9:	89 f3                	mov    %esi,%ebx
  8015bb:	80 fb 09             	cmp    $0x9,%bl
  8015be:	76 df                	jbe    80159f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8015c0:	8d 72 9f             	lea    -0x61(%edx),%esi
  8015c3:	89 f3                	mov    %esi,%ebx
  8015c5:	80 fb 19             	cmp    $0x19,%bl
  8015c8:	77 08                	ja     8015d2 <strtol+0xb3>
			dig = *s - 'a' + 10;
  8015ca:	0f be d2             	movsbl %dl,%edx
  8015cd:	83 ea 57             	sub    $0x57,%edx
  8015d0:	eb d3                	jmp    8015a5 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8015d2:	8d 72 bf             	lea    -0x41(%edx),%esi
  8015d5:	89 f3                	mov    %esi,%ebx
  8015d7:	80 fb 19             	cmp    $0x19,%bl
  8015da:	77 08                	ja     8015e4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8015dc:	0f be d2             	movsbl %dl,%edx
  8015df:	83 ea 37             	sub    $0x37,%edx
  8015e2:	eb c1                	jmp    8015a5 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e8:	74 05                	je     8015ef <strtol+0xd0>
		*endptr = (char *) s;
  8015ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015ed:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	f7 da                	neg    %edx
  8015f3:	85 ff                	test   %edi,%edi
  8015f5:	0f 45 c2             	cmovne %edx,%eax
}
  8015f8:	5b                   	pop    %ebx
  8015f9:	5e                   	pop    %esi
  8015fa:	5f                   	pop    %edi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015fd:	f3 0f 1e fb          	endbr32 
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	57                   	push   %edi
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
	asm volatile("int %1\n"
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
  80160c:	8b 55 08             	mov    0x8(%ebp),%edx
  80160f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801612:	89 c3                	mov    %eax,%ebx
  801614:	89 c7                	mov    %eax,%edi
  801616:	89 c6                	mov    %eax,%esi
  801618:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5f                   	pop    %edi
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    

0080161f <sys_cgetc>:

int
sys_cgetc(void)
{
  80161f:	f3 0f 1e fb          	endbr32 
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	57                   	push   %edi
  801627:	56                   	push   %esi
  801628:	53                   	push   %ebx
	asm volatile("int %1\n"
  801629:	ba 00 00 00 00       	mov    $0x0,%edx
  80162e:	b8 01 00 00 00       	mov    $0x1,%eax
  801633:	89 d1                	mov    %edx,%ecx
  801635:	89 d3                	mov    %edx,%ebx
  801637:	89 d7                	mov    %edx,%edi
  801639:	89 d6                	mov    %edx,%esi
  80163b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5f                   	pop    %edi
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    

00801642 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801642:	f3 0f 1e fb          	endbr32 
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	57                   	push   %edi
  80164a:	56                   	push   %esi
  80164b:	53                   	push   %ebx
  80164c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80164f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801654:	8b 55 08             	mov    0x8(%ebp),%edx
  801657:	b8 03 00 00 00       	mov    $0x3,%eax
  80165c:	89 cb                	mov    %ecx,%ebx
  80165e:	89 cf                	mov    %ecx,%edi
  801660:	89 ce                	mov    %ecx,%esi
  801662:	cd 30                	int    $0x30
	if(check && ret > 0)
  801664:	85 c0                	test   %eax,%eax
  801666:	7f 08                	jg     801670 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5f                   	pop    %edi
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	50                   	push   %eax
  801674:	6a 03                	push   $0x3
  801676:	68 4f 3f 80 00       	push   $0x803f4f
  80167b:	6a 23                	push   $0x23
  80167d:	68 6c 3f 80 00       	push   $0x803f6c
  801682:	e8 1f f4 ff ff       	call   800aa6 <_panic>

00801687 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801687:	f3 0f 1e fb          	endbr32 
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	57                   	push   %edi
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
	asm volatile("int %1\n"
  801691:	ba 00 00 00 00       	mov    $0x0,%edx
  801696:	b8 02 00 00 00       	mov    $0x2,%eax
  80169b:	89 d1                	mov    %edx,%ecx
  80169d:	89 d3                	mov    %edx,%ebx
  80169f:	89 d7                	mov    %edx,%edi
  8016a1:	89 d6                	mov    %edx,%esi
  8016a3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <sys_yield>:

void
sys_yield(void)
{
  8016aa:	f3 0f 1e fb          	endbr32 
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	57                   	push   %edi
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 0b 00 00 00       	mov    $0xb,%eax
  8016be:	89 d1                	mov    %edx,%ecx
  8016c0:	89 d3                	mov    %edx,%ebx
  8016c2:	89 d7                	mov    %edx,%edi
  8016c4:	89 d6                	mov    %edx,%esi
  8016c6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8016c8:	5b                   	pop    %ebx
  8016c9:	5e                   	pop    %esi
  8016ca:	5f                   	pop    %edi
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    

008016cd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8016cd:	f3 0f 1e fb          	endbr32 
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	57                   	push   %edi
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016da:	be 00 00 00 00       	mov    $0x0,%esi
  8016df:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e5:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ed:	89 f7                	mov    %esi,%edi
  8016ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	7f 08                	jg     8016fd <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f8:	5b                   	pop    %ebx
  8016f9:	5e                   	pop    %esi
  8016fa:	5f                   	pop    %edi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	50                   	push   %eax
  801701:	6a 04                	push   $0x4
  801703:	68 4f 3f 80 00       	push   $0x803f4f
  801708:	6a 23                	push   $0x23
  80170a:	68 6c 3f 80 00       	push   $0x803f6c
  80170f:	e8 92 f3 ff ff       	call   800aa6 <_panic>

00801714 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801714:	f3 0f 1e fb          	endbr32 
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	57                   	push   %edi
  80171c:	56                   	push   %esi
  80171d:	53                   	push   %ebx
  80171e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801721:	8b 55 08             	mov    0x8(%ebp),%edx
  801724:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801727:	b8 05 00 00 00       	mov    $0x5,%eax
  80172c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80172f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801732:	8b 75 18             	mov    0x18(%ebp),%esi
  801735:	cd 30                	int    $0x30
	if(check && ret > 0)
  801737:	85 c0                	test   %eax,%eax
  801739:	7f 08                	jg     801743 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80173b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173e:	5b                   	pop    %ebx
  80173f:	5e                   	pop    %esi
  801740:	5f                   	pop    %edi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	50                   	push   %eax
  801747:	6a 05                	push   $0x5
  801749:	68 4f 3f 80 00       	push   $0x803f4f
  80174e:	6a 23                	push   $0x23
  801750:	68 6c 3f 80 00       	push   $0x803f6c
  801755:	e8 4c f3 ff ff       	call   800aa6 <_panic>

0080175a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80175a:	f3 0f 1e fb          	endbr32 
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	57                   	push   %edi
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801767:	bb 00 00 00 00       	mov    $0x0,%ebx
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801772:	b8 06 00 00 00       	mov    $0x6,%eax
  801777:	89 df                	mov    %ebx,%edi
  801779:	89 de                	mov    %ebx,%esi
  80177b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80177d:	85 c0                	test   %eax,%eax
  80177f:	7f 08                	jg     801789 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801784:	5b                   	pop    %ebx
  801785:	5e                   	pop    %esi
  801786:	5f                   	pop    %edi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801789:	83 ec 0c             	sub    $0xc,%esp
  80178c:	50                   	push   %eax
  80178d:	6a 06                	push   $0x6
  80178f:	68 4f 3f 80 00       	push   $0x803f4f
  801794:	6a 23                	push   $0x23
  801796:	68 6c 3f 80 00       	push   $0x803f6c
  80179b:	e8 06 f3 ff ff       	call   800aa6 <_panic>

008017a0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	57                   	push   %edi
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017bd:	89 df                	mov    %ebx,%edi
  8017bf:	89 de                	mov    %ebx,%esi
  8017c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	7f 08                	jg     8017cf <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5e                   	pop    %esi
  8017cc:	5f                   	pop    %edi
  8017cd:	5d                   	pop    %ebp
  8017ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017cf:	83 ec 0c             	sub    $0xc,%esp
  8017d2:	50                   	push   %eax
  8017d3:	6a 08                	push   $0x8
  8017d5:	68 4f 3f 80 00       	push   $0x803f4f
  8017da:	6a 23                	push   $0x23
  8017dc:	68 6c 3f 80 00       	push   $0x803f6c
  8017e1:	e8 c0 f2 ff ff       	call   800aa6 <_panic>

008017e6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017e6:	f3 0f 1e fb          	endbr32 
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	57                   	push   %edi
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8017fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fe:	b8 09 00 00 00       	mov    $0x9,%eax
  801803:	89 df                	mov    %ebx,%edi
  801805:	89 de                	mov    %ebx,%esi
  801807:	cd 30                	int    $0x30
	if(check && ret > 0)
  801809:	85 c0                	test   %eax,%eax
  80180b:	7f 08                	jg     801815 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80180d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801810:	5b                   	pop    %ebx
  801811:	5e                   	pop    %esi
  801812:	5f                   	pop    %edi
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	50                   	push   %eax
  801819:	6a 09                	push   $0x9
  80181b:	68 4f 3f 80 00       	push   $0x803f4f
  801820:	6a 23                	push   $0x23
  801822:	68 6c 3f 80 00       	push   $0x803f6c
  801827:	e8 7a f2 ff ff       	call   800aa6 <_panic>

0080182c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80182c:	f3 0f 1e fb          	endbr32 
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	57                   	push   %edi
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
  801836:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80183e:	8b 55 08             	mov    0x8(%ebp),%edx
  801841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801844:	b8 0a 00 00 00       	mov    $0xa,%eax
  801849:	89 df                	mov    %ebx,%edi
  80184b:	89 de                	mov    %ebx,%esi
  80184d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80184f:	85 c0                	test   %eax,%eax
  801851:	7f 08                	jg     80185b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801853:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5f                   	pop    %edi
  801859:	5d                   	pop    %ebp
  80185a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80185b:	83 ec 0c             	sub    $0xc,%esp
  80185e:	50                   	push   %eax
  80185f:	6a 0a                	push   $0xa
  801861:	68 4f 3f 80 00       	push   $0x803f4f
  801866:	6a 23                	push   $0x23
  801868:	68 6c 3f 80 00       	push   $0x803f6c
  80186d:	e8 34 f2 ff ff       	call   800aa6 <_panic>

00801872 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801872:	f3 0f 1e fb          	endbr32 
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	57                   	push   %edi
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80187c:	8b 55 08             	mov    0x8(%ebp),%edx
  80187f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801882:	b8 0c 00 00 00       	mov    $0xc,%eax
  801887:	be 00 00 00 00       	mov    $0x0,%esi
  80188c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80188f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801892:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801894:	5b                   	pop    %ebx
  801895:	5e                   	pop    %esi
  801896:	5f                   	pop    %edi
  801897:	5d                   	pop    %ebp
  801898:	c3                   	ret    

00801899 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801899:	f3 0f 1e fb          	endbr32 
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	57                   	push   %edi
  8018a1:	56                   	push   %esi
  8018a2:	53                   	push   %ebx
  8018a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8018a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ae:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018b3:	89 cb                	mov    %ecx,%ebx
  8018b5:	89 cf                	mov    %ecx,%edi
  8018b7:	89 ce                	mov    %ecx,%esi
  8018b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	7f 08                	jg     8018c7 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5f                   	pop    %edi
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	50                   	push   %eax
  8018cb:	6a 0d                	push   $0xd
  8018cd:	68 4f 3f 80 00       	push   $0x803f4f
  8018d2:	6a 23                	push   $0x23
  8018d4:	68 6c 3f 80 00       	push   $0x803f6c
  8018d9:	e8 c8 f1 ff ff       	call   800aa6 <_panic>

008018de <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8018de:	f3 0f 1e fb          	endbr32 
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	57                   	push   %edi
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018f2:	89 d1                	mov    %edx,%ecx
  8018f4:	89 d3                	mov    %edx,%ebx
  8018f6:	89 d7                	mov    %edx,%edi
  8018f8:	89 d6                	mov    %edx,%esi
  8018fa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5f                   	pop    %edi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801901:	f3 0f 1e fb          	endbr32 
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	56                   	push   %esi
  801909:	53                   	push   %ebx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  80190d:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  80190f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801913:	75 11                	jne    801926 <pgfault+0x25>
  801915:	89 f0                	mov    %esi,%eax
  801917:	c1 e8 0c             	shr    $0xc,%eax
  80191a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801921:	f6 c4 08             	test   $0x8,%ah
  801924:	74 7d                	je     8019a3 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  801926:	e8 5c fd ff ff       	call   801687 <sys_getenvid>
  80192b:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	6a 07                	push   $0x7
  801932:	68 00 f0 7f 00       	push   $0x7ff000
  801937:	50                   	push   %eax
  801938:	e8 90 fd ff ff       	call   8016cd <sys_page_alloc>
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	85 c0                	test   %eax,%eax
  801942:	78 7a                	js     8019be <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  801944:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 00 10 00 00       	push   $0x1000
  801952:	56                   	push   %esi
  801953:	68 00 f0 7f 00       	push   $0x7ff000
  801958:	e8 e4 fa ff ff       	call   801441 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  80195d:	83 c4 08             	add    $0x8,%esp
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	e8 f3 fd ff ff       	call   80175a <sys_page_unmap>
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 62                	js     8019d0 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	6a 07                	push   $0x7
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	68 00 f0 7f 00       	push   $0x7ff000
  80197a:	53                   	push   %ebx
  80197b:	e8 94 fd ff ff       	call   801714 <sys_page_map>
  801980:	83 c4 20             	add    $0x20,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	78 5b                	js     8019e2 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	68 00 f0 7f 00       	push   $0x7ff000
  80198f:	53                   	push   %ebx
  801990:	e8 c5 fd ff ff       	call   80175a <sys_page_unmap>
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	85 c0                	test   %eax,%eax
  80199a:	78 58                	js     8019f4 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  80199c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  8019a3:	e8 df fc ff ff       	call   801687 <sys_getenvid>
  8019a8:	83 ec 0c             	sub    $0xc,%esp
  8019ab:	56                   	push   %esi
  8019ac:	50                   	push   %eax
  8019ad:	68 7c 3f 80 00       	push   $0x803f7c
  8019b2:	6a 16                	push   $0x16
  8019b4:	68 0a 40 80 00       	push   $0x80400a
  8019b9:	e8 e8 f0 ff ff       	call   800aa6 <_panic>
        panic("pgfault: page allocation failed %e", r);
  8019be:	50                   	push   %eax
  8019bf:	68 c4 3f 80 00       	push   $0x803fc4
  8019c4:	6a 1f                	push   $0x1f
  8019c6:	68 0a 40 80 00       	push   $0x80400a
  8019cb:	e8 d6 f0 ff ff       	call   800aa6 <_panic>
        panic("pgfault: page unmap failed %e", r);
  8019d0:	50                   	push   %eax
  8019d1:	68 15 40 80 00       	push   $0x804015
  8019d6:	6a 24                	push   $0x24
  8019d8:	68 0a 40 80 00       	push   $0x80400a
  8019dd:	e8 c4 f0 ff ff       	call   800aa6 <_panic>
        panic("pgfault: page map failed %e", r);
  8019e2:	50                   	push   %eax
  8019e3:	68 33 40 80 00       	push   $0x804033
  8019e8:	6a 26                	push   $0x26
  8019ea:	68 0a 40 80 00       	push   $0x80400a
  8019ef:	e8 b2 f0 ff ff       	call   800aa6 <_panic>
        panic("pgfault: page unmap failed %e", r);
  8019f4:	50                   	push   %eax
  8019f5:	68 15 40 80 00       	push   $0x804015
  8019fa:	6a 28                	push   $0x28
  8019fc:	68 0a 40 80 00       	push   $0x80400a
  801a01:	e8 a0 f0 ff ff       	call   800aa6 <_panic>

00801a06 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  801a0d:	89 d3                	mov    %edx,%ebx
  801a0f:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  801a12:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801a19:	f6 c6 04             	test   $0x4,%dh
  801a1c:	75 62                	jne    801a80 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  801a1e:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801a24:	0f 84 9d 00 00 00    	je     801ac7 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  801a2a:	8b 15 28 64 80 00    	mov    0x806428,%edx
  801a30:	8b 52 48             	mov    0x48(%edx),%edx
  801a33:	83 ec 0c             	sub    $0xc,%esp
  801a36:	68 05 08 00 00       	push   $0x805
  801a3b:	53                   	push   %ebx
  801a3c:	50                   	push   %eax
  801a3d:	53                   	push   %ebx
  801a3e:	52                   	push   %edx
  801a3f:	e8 d0 fc ff ff       	call   801714 <sys_page_map>
  801a44:	83 c4 20             	add    $0x20,%esp
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 6a                	js     801ab5 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  801a4b:	a1 28 64 80 00       	mov    0x806428,%eax
  801a50:	8b 50 48             	mov    0x48(%eax),%edx
  801a53:	8b 40 48             	mov    0x48(%eax),%eax
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	68 05 08 00 00       	push   $0x805
  801a5e:	53                   	push   %ebx
  801a5f:	52                   	push   %edx
  801a60:	53                   	push   %ebx
  801a61:	50                   	push   %eax
  801a62:	e8 ad fc ff ff       	call   801714 <sys_page_map>
  801a67:	83 c4 20             	add    $0x20,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	79 77                	jns    801ae5 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801a6e:	50                   	push   %eax
  801a6f:	68 e8 3f 80 00       	push   $0x803fe8
  801a74:	6a 49                	push   $0x49
  801a76:	68 0a 40 80 00       	push   $0x80400a
  801a7b:	e8 26 f0 ff ff       	call   800aa6 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801a80:	8b 0d 28 64 80 00    	mov    0x806428,%ecx
  801a86:	8b 49 48             	mov    0x48(%ecx),%ecx
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a92:	52                   	push   %edx
  801a93:	53                   	push   %ebx
  801a94:	50                   	push   %eax
  801a95:	53                   	push   %ebx
  801a96:	51                   	push   %ecx
  801a97:	e8 78 fc ff ff       	call   801714 <sys_page_map>
  801a9c:	83 c4 20             	add    $0x20,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	79 42                	jns    801ae5 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801aa3:	50                   	push   %eax
  801aa4:	68 e8 3f 80 00       	push   $0x803fe8
  801aa9:	6a 43                	push   $0x43
  801aab:	68 0a 40 80 00       	push   $0x80400a
  801ab0:	e8 f1 ef ff ff       	call   800aa6 <_panic>
            panic("duppage: page remapping failed %e", r);
  801ab5:	50                   	push   %eax
  801ab6:	68 e8 3f 80 00       	push   $0x803fe8
  801abb:	6a 47                	push   $0x47
  801abd:	68 0a 40 80 00       	push   $0x80400a
  801ac2:	e8 df ef ff ff       	call   800aa6 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801ac7:	8b 15 28 64 80 00    	mov    0x806428,%edx
  801acd:	8b 52 48             	mov    0x48(%edx),%edx
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	6a 05                	push   $0x5
  801ad5:	53                   	push   %ebx
  801ad6:	50                   	push   %eax
  801ad7:	53                   	push   %ebx
  801ad8:	52                   	push   %edx
  801ad9:	e8 36 fc ff ff       	call   801714 <sys_page_map>
  801ade:	83 c4 20             	add    $0x20,%esp
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 0a                	js     801aef <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801aef:	50                   	push   %eax
  801af0:	68 e8 3f 80 00       	push   $0x803fe8
  801af5:	6a 4c                	push   $0x4c
  801af7:	68 0a 40 80 00       	push   $0x80400a
  801afc:	e8 a5 ef ff ff       	call   800aa6 <_panic>

00801b01 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801b01:	f3 0f 1e fb          	endbr32 
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	56                   	push   %esi
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801b0d:	68 01 19 80 00       	push   $0x801901
  801b12:	e8 99 1a 00 00       	call   8035b0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801b17:	b8 07 00 00 00       	mov    $0x7,%eax
  801b1c:	cd 30                	int    $0x30
  801b1e:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 12                	js     801b39 <fork+0x38>
  801b27:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801b29:	74 20                	je     801b4b <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801b2b:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801b32:	ba 00 00 80 00       	mov    $0x800000,%edx
  801b37:	eb 42                	jmp    801b7b <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801b39:	50                   	push   %eax
  801b3a:	68 4f 40 80 00       	push   $0x80404f
  801b3f:	6a 6a                	push   $0x6a
  801b41:	68 0a 40 80 00       	push   $0x80400a
  801b46:	e8 5b ef ff ff       	call   800aa6 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801b4b:	e8 37 fb ff ff       	call   801687 <sys_getenvid>
  801b50:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b55:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b58:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b5d:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801b62:	e9 8a 00 00 00       	jmp    801bf1 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801b70:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801b73:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801b79:	77 32                	ja     801bad <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801b7b:	89 d0                	mov    %edx,%eax
  801b7d:	c1 e8 16             	shr    $0x16,%eax
  801b80:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b87:	a8 01                	test   $0x1,%al
  801b89:	74 dc                	je     801b67 <fork+0x66>
  801b8b:	c1 ea 0c             	shr    $0xc,%edx
  801b8e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b95:	a8 01                	test   $0x1,%al
  801b97:	74 ce                	je     801b67 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801b99:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ba0:	a8 04                	test   $0x4,%al
  801ba2:	74 c3                	je     801b67 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801ba4:	89 f0                	mov    %esi,%eax
  801ba6:	e8 5b fe ff ff       	call   801a06 <duppage>
  801bab:	eb ba                	jmp    801b67 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801bad:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bb0:	c1 ea 0c             	shr    $0xc,%edx
  801bb3:	89 d8                	mov    %ebx,%eax
  801bb5:	e8 4c fe ff ff       	call   801a06 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	6a 07                	push   $0x7
  801bbf:	68 00 f0 bf ee       	push   $0xeebff000
  801bc4:	53                   	push   %ebx
  801bc5:	e8 03 fb ff ff       	call   8016cd <sys_page_alloc>
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	75 29                	jne    801bfa <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	68 31 36 80 00       	push   $0x803631
  801bd9:	53                   	push   %ebx
  801bda:	e8 4d fc ff ff       	call   80182c <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801bdf:	83 c4 08             	add    $0x8,%esp
  801be2:	6a 02                	push   $0x2
  801be4:	53                   	push   %ebx
  801be5:	e8 b6 fb ff ff       	call   8017a0 <sys_env_set_status>
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	85 c0                	test   %eax,%eax
  801bef:	75 1b                	jne    801c0c <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801bf1:	89 d8                	mov    %ebx,%eax
  801bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5e                   	pop    %esi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801bfa:	50                   	push   %eax
  801bfb:	68 5e 40 80 00       	push   $0x80405e
  801c00:	6a 7b                	push   $0x7b
  801c02:	68 0a 40 80 00       	push   $0x80400a
  801c07:	e8 9a ee ff ff       	call   800aa6 <_panic>
		panic("sys_env_set_status:%e", r);
  801c0c:	50                   	push   %eax
  801c0d:	68 70 40 80 00       	push   $0x804070
  801c12:	68 81 00 00 00       	push   $0x81
  801c17:	68 0a 40 80 00       	push   $0x80400a
  801c1c:	e8 85 ee ff ff       	call   800aa6 <_panic>

00801c21 <sfork>:

// Challenge!
int
sfork(void)
{
  801c21:	f3 0f 1e fb          	endbr32 
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801c2b:	68 86 40 80 00       	push   $0x804086
  801c30:	68 8b 00 00 00       	push   $0x8b
  801c35:	68 0a 40 80 00       	push   $0x80400a
  801c3a:	e8 67 ee ff ff       	call   800aa6 <_panic>

00801c3f <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801c3f:	f3 0f 1e fb          	endbr32 
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	8b 55 08             	mov    0x8(%ebp),%edx
  801c49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c4c:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801c4f:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801c51:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801c54:	83 3a 01             	cmpl   $0x1,(%edx)
  801c57:	7e 09                	jle    801c62 <argstart+0x23>
  801c59:	ba 21 3a 80 00       	mov    $0x803a21,%edx
  801c5e:	85 c9                	test   %ecx,%ecx
  801c60:	75 05                	jne    801c67 <argstart+0x28>
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
  801c67:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801c6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    

00801c73 <argnext>:

int
argnext(struct Argstate *args)
{
  801c73:	f3 0f 1e fb          	endbr32 
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801c81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801c88:	8b 43 08             	mov    0x8(%ebx),%eax
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	74 74                	je     801d03 <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  801c8f:	80 38 00             	cmpb   $0x0,(%eax)
  801c92:	75 48                	jne    801cdc <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801c94:	8b 0b                	mov    (%ebx),%ecx
  801c96:	83 39 01             	cmpl   $0x1,(%ecx)
  801c99:	74 5a                	je     801cf5 <argnext+0x82>
		    || args->argv[1][0] != '-'
  801c9b:	8b 53 04             	mov    0x4(%ebx),%edx
  801c9e:	8b 42 04             	mov    0x4(%edx),%eax
  801ca1:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ca4:	75 4f                	jne    801cf5 <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801ca6:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801caa:	74 49                	je     801cf5 <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801cac:	83 c0 01             	add    $0x1,%eax
  801caf:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	8b 01                	mov    (%ecx),%eax
  801cb7:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801cbe:	50                   	push   %eax
  801cbf:	8d 42 08             	lea    0x8(%edx),%eax
  801cc2:	50                   	push   %eax
  801cc3:	83 c2 04             	add    $0x4,%edx
  801cc6:	52                   	push   %edx
  801cc7:	e8 75 f7 ff ff       	call   801441 <memmove>
		(*args->argc)--;
  801ccc:	8b 03                	mov    (%ebx),%eax
  801cce:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cd1:	8b 43 08             	mov    0x8(%ebx),%eax
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	80 38 2d             	cmpb   $0x2d,(%eax)
  801cda:	74 13                	je     801cef <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801cdc:	8b 43 08             	mov    0x8(%ebx),%eax
  801cdf:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  801ce2:	83 c0 01             	add    $0x1,%eax
  801ce5:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801ce8:	89 d0                	mov    %edx,%eax
  801cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801cef:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801cf3:	75 e7                	jne    801cdc <argnext+0x69>
	args->curarg = 0;
  801cf5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801cfc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d01:	eb e5                	jmp    801ce8 <argnext+0x75>
		return -1;
  801d03:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801d08:	eb de                	jmp    801ce8 <argnext+0x75>

00801d0a <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801d0a:	f3 0f 1e fb          	endbr32 
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801d18:	8b 43 08             	mov    0x8(%ebx),%eax
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	74 12                	je     801d31 <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801d1f:	80 38 00             	cmpb   $0x0,(%eax)
  801d22:	74 12                	je     801d36 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  801d24:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801d27:	c7 43 08 21 3a 80 00 	movl   $0x803a21,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801d2e:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    
	} else if (*args->argc > 1) {
  801d36:	8b 13                	mov    (%ebx),%edx
  801d38:	83 3a 01             	cmpl   $0x1,(%edx)
  801d3b:	7f 10                	jg     801d4d <argnextvalue+0x43>
		args->argvalue = 0;
  801d3d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801d44:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801d4b:	eb e1                	jmp    801d2e <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  801d4d:	8b 43 04             	mov    0x4(%ebx),%eax
  801d50:	8b 48 04             	mov    0x4(%eax),%ecx
  801d53:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	8b 12                	mov    (%edx),%edx
  801d5b:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801d62:	52                   	push   %edx
  801d63:	8d 50 08             	lea    0x8(%eax),%edx
  801d66:	52                   	push   %edx
  801d67:	83 c0 04             	add    $0x4,%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 d1 f6 ff ff       	call   801441 <memmove>
		(*args->argc)--;
  801d70:	8b 03                	mov    (%ebx),%eax
  801d72:	83 28 01             	subl   $0x1,(%eax)
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	eb b4                	jmp    801d2e <argnextvalue+0x24>

00801d7a <argvalue>:
{
  801d7a:	f3 0f 1e fb          	endbr32 
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
  801d84:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d87:	8b 42 0c             	mov    0xc(%edx),%eax
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	74 02                	je     801d90 <argvalue+0x16>
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	52                   	push   %edx
  801d94:	e8 71 ff ff ff       	call   801d0a <argnextvalue>
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	eb f0                	jmp    801d8e <argvalue+0x14>

00801d9e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d9e:	f3 0f 1e fb          	endbr32 
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	05 00 00 00 30       	add    $0x30000000,%eax
  801dad:	c1 e8 0c             	shr    $0xc,%eax
}
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801db2:	f3 0f 1e fb          	endbr32 
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801dc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dc6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    

00801dcd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dcd:	f3 0f 1e fb          	endbr32 
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dd9:	89 c2                	mov    %eax,%edx
  801ddb:	c1 ea 16             	shr    $0x16,%edx
  801dde:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801de5:	f6 c2 01             	test   $0x1,%dl
  801de8:	74 2d                	je     801e17 <fd_alloc+0x4a>
  801dea:	89 c2                	mov    %eax,%edx
  801dec:	c1 ea 0c             	shr    $0xc,%edx
  801def:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801df6:	f6 c2 01             	test   $0x1,%dl
  801df9:	74 1c                	je     801e17 <fd_alloc+0x4a>
  801dfb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801e00:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e05:	75 d2                	jne    801dd9 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e10:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801e15:	eb 0a                	jmp    801e21 <fd_alloc+0x54>
			*fd_store = fd;
  801e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e1a:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e23:	f3 0f 1e fb          	endbr32 
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e2d:	83 f8 1f             	cmp    $0x1f,%eax
  801e30:	77 30                	ja     801e62 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e32:	c1 e0 0c             	shl    $0xc,%eax
  801e35:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e3a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801e40:	f6 c2 01             	test   $0x1,%dl
  801e43:	74 24                	je     801e69 <fd_lookup+0x46>
  801e45:	89 c2                	mov    %eax,%edx
  801e47:	c1 ea 0c             	shr    $0xc,%edx
  801e4a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e51:	f6 c2 01             	test   $0x1,%dl
  801e54:	74 1a                	je     801e70 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e59:	89 02                	mov    %eax,(%edx)
	return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    
		return -E_INVAL;
  801e62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e67:	eb f7                	jmp    801e60 <fd_lookup+0x3d>
		return -E_INVAL;
  801e69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6e:	eb f0                	jmp    801e60 <fd_lookup+0x3d>
  801e70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e75:	eb e9                	jmp    801e60 <fd_lookup+0x3d>

00801e77 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e77:	f3 0f 1e fb          	endbr32 
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
  801e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801e84:	ba 00 00 00 00       	mov    $0x0,%edx
  801e89:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801e8e:	39 08                	cmp    %ecx,(%eax)
  801e90:	74 38                	je     801eca <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801e92:	83 c2 01             	add    $0x1,%edx
  801e95:	8b 04 95 18 41 80 00 	mov    0x804118(,%edx,4),%eax
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	75 ee                	jne    801e8e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ea0:	a1 28 64 80 00       	mov    0x806428,%eax
  801ea5:	8b 40 48             	mov    0x48(%eax),%eax
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	51                   	push   %ecx
  801eac:	50                   	push   %eax
  801ead:	68 9c 40 80 00       	push   $0x80409c
  801eb2:	e8 d6 ec ff ff       	call   800b8d <cprintf>
	*dev = 0;
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    
			*dev = devtab[i];
  801eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ecd:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	eb f2                	jmp    801ec8 <dev_lookup+0x51>

00801ed6 <fd_close>:
{
  801ed6:	f3 0f 1e fb          	endbr32 
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 24             	sub    $0x24,%esp
  801ee3:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ee9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801eec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ef3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ef6:	50                   	push   %eax
  801ef7:	e8 27 ff ff ff       	call   801e23 <fd_lookup>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 05                	js     801f0a <fd_close+0x34>
	    || fd != fd2)
  801f05:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801f08:	74 16                	je     801f20 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801f0a:	89 f8                	mov    %edi,%eax
  801f0c:	84 c0                	test   %al,%al
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f13:	0f 44 d8             	cmove  %eax,%ebx
}
  801f16:	89 d8                	mov    %ebx,%eax
  801f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f20:	83 ec 08             	sub    $0x8,%esp
  801f23:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801f26:	50                   	push   %eax
  801f27:	ff 36                	pushl  (%esi)
  801f29:	e8 49 ff ff ff       	call   801e77 <dev_lookup>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 1a                	js     801f51 <fd_close+0x7b>
		if (dev->dev_close)
  801f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801f42:	85 c0                	test   %eax,%eax
  801f44:	74 0b                	je     801f51 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	56                   	push   %esi
  801f4a:	ff d0                	call   *%eax
  801f4c:	89 c3                	mov    %eax,%ebx
  801f4e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801f51:	83 ec 08             	sub    $0x8,%esp
  801f54:	56                   	push   %esi
  801f55:	6a 00                	push   $0x0
  801f57:	e8 fe f7 ff ff       	call   80175a <sys_page_unmap>
	return r;
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	eb b5                	jmp    801f16 <fd_close+0x40>

00801f61 <close>:

int
close(int fdnum)
{
  801f61:	f3 0f 1e fb          	endbr32 
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f6e:	50                   	push   %eax
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	e8 ac fe ff ff       	call   801e23 <fd_lookup>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	79 02                	jns    801f80 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    
		return fd_close(fd, 1);
  801f80:	83 ec 08             	sub    $0x8,%esp
  801f83:	6a 01                	push   $0x1
  801f85:	ff 75 f4             	pushl  -0xc(%ebp)
  801f88:	e8 49 ff ff ff       	call   801ed6 <fd_close>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	eb ec                	jmp    801f7e <close+0x1d>

00801f92 <close_all>:

void
close_all(void)
{
  801f92:	f3 0f 1e fb          	endbr32 
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	53                   	push   %ebx
  801f9a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	53                   	push   %ebx
  801fa6:	e8 b6 ff ff ff       	call   801f61 <close>
	for (i = 0; i < MAXFD; i++)
  801fab:	83 c3 01             	add    $0x1,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	83 fb 20             	cmp    $0x20,%ebx
  801fb4:	75 ec                	jne    801fa2 <close_all+0x10>
}
  801fb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fbb:	f3 0f 1e fb          	endbr32 
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	57                   	push   %edi
  801fc3:	56                   	push   %esi
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fc8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fcb:	50                   	push   %eax
  801fcc:	ff 75 08             	pushl  0x8(%ebp)
  801fcf:	e8 4f fe ff ff       	call   801e23 <fd_lookup>
  801fd4:	89 c3                	mov    %eax,%ebx
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	0f 88 81 00 00 00    	js     802062 <dup+0xa7>
		return r;
	close(newfdnum);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	e8 75 ff ff ff       	call   801f61 <close>

	newfd = INDEX2FD(newfdnum);
  801fec:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fef:	c1 e6 0c             	shl    $0xc,%esi
  801ff2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801ff8:	83 c4 04             	add    $0x4,%esp
  801ffb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ffe:	e8 af fd ff ff       	call   801db2 <fd2data>
  802003:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802005:	89 34 24             	mov    %esi,(%esp)
  802008:	e8 a5 fd ff ff       	call   801db2 <fd2data>
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802012:	89 d8                	mov    %ebx,%eax
  802014:	c1 e8 16             	shr    $0x16,%eax
  802017:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80201e:	a8 01                	test   $0x1,%al
  802020:	74 11                	je     802033 <dup+0x78>
  802022:	89 d8                	mov    %ebx,%eax
  802024:	c1 e8 0c             	shr    $0xc,%eax
  802027:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80202e:	f6 c2 01             	test   $0x1,%dl
  802031:	75 39                	jne    80206c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802033:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802036:	89 d0                	mov    %edx,%eax
  802038:	c1 e8 0c             	shr    $0xc,%eax
  80203b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	25 07 0e 00 00       	and    $0xe07,%eax
  80204a:	50                   	push   %eax
  80204b:	56                   	push   %esi
  80204c:	6a 00                	push   $0x0
  80204e:	52                   	push   %edx
  80204f:	6a 00                	push   $0x0
  802051:	e8 be f6 ff ff       	call   801714 <sys_page_map>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 20             	add    $0x20,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	78 31                	js     802090 <dup+0xd5>
		goto err;

	return newfdnum;
  80205f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802062:	89 d8                	mov    %ebx,%eax
  802064:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80206c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	25 07 0e 00 00       	and    $0xe07,%eax
  80207b:	50                   	push   %eax
  80207c:	57                   	push   %edi
  80207d:	6a 00                	push   $0x0
  80207f:	53                   	push   %ebx
  802080:	6a 00                	push   $0x0
  802082:	e8 8d f6 ff ff       	call   801714 <sys_page_map>
  802087:	89 c3                	mov    %eax,%ebx
  802089:	83 c4 20             	add    $0x20,%esp
  80208c:	85 c0                	test   %eax,%eax
  80208e:	79 a3                	jns    802033 <dup+0x78>
	sys_page_unmap(0, newfd);
  802090:	83 ec 08             	sub    $0x8,%esp
  802093:	56                   	push   %esi
  802094:	6a 00                	push   $0x0
  802096:	e8 bf f6 ff ff       	call   80175a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80209b:	83 c4 08             	add    $0x8,%esp
  80209e:	57                   	push   %edi
  80209f:	6a 00                	push   $0x0
  8020a1:	e8 b4 f6 ff ff       	call   80175a <sys_page_unmap>
	return r;
  8020a6:	83 c4 10             	add    $0x10,%esp
  8020a9:	eb b7                	jmp    802062 <dup+0xa7>

008020ab <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020ab:	f3 0f 1e fb          	endbr32 
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 1c             	sub    $0x1c,%esp
  8020b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	53                   	push   %ebx
  8020be:	e8 60 fd ff ff       	call   801e23 <fd_lookup>
  8020c3:	83 c4 10             	add    $0x10,%esp
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 3f                	js     802109 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020ca:	83 ec 08             	sub    $0x8,%esp
  8020cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d0:	50                   	push   %eax
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d4:	ff 30                	pushl  (%eax)
  8020d6:	e8 9c fd ff ff       	call   801e77 <dev_lookup>
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 27                	js     802109 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e5:	8b 42 08             	mov    0x8(%edx),%eax
  8020e8:	83 e0 03             	and    $0x3,%eax
  8020eb:	83 f8 01             	cmp    $0x1,%eax
  8020ee:	74 1e                	je     80210e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 35                	je     80212f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	ff 75 10             	pushl  0x10(%ebp)
  802100:	ff 75 0c             	pushl  0xc(%ebp)
  802103:	52                   	push   %edx
  802104:	ff d0                	call   *%eax
  802106:	83 c4 10             	add    $0x10,%esp
}
  802109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80210e:	a1 28 64 80 00       	mov    0x806428,%eax
  802113:	8b 40 48             	mov    0x48(%eax),%eax
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	53                   	push   %ebx
  80211a:	50                   	push   %eax
  80211b:	68 dd 40 80 00       	push   $0x8040dd
  802120:	e8 68 ea ff ff       	call   800b8d <cprintf>
		return -E_INVAL;
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80212d:	eb da                	jmp    802109 <read+0x5e>
		return -E_NOT_SUPP;
  80212f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802134:	eb d3                	jmp    802109 <read+0x5e>

00802136 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802136:	f3 0f 1e fb          	endbr32 
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	57                   	push   %edi
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	83 ec 0c             	sub    $0xc,%esp
  802143:	8b 7d 08             	mov    0x8(%ebp),%edi
  802146:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802149:	bb 00 00 00 00       	mov    $0x0,%ebx
  80214e:	eb 02                	jmp    802152 <readn+0x1c>
  802150:	01 c3                	add    %eax,%ebx
  802152:	39 f3                	cmp    %esi,%ebx
  802154:	73 21                	jae    802177 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	89 f0                	mov    %esi,%eax
  80215b:	29 d8                	sub    %ebx,%eax
  80215d:	50                   	push   %eax
  80215e:	89 d8                	mov    %ebx,%eax
  802160:	03 45 0c             	add    0xc(%ebp),%eax
  802163:	50                   	push   %eax
  802164:	57                   	push   %edi
  802165:	e8 41 ff ff ff       	call   8020ab <read>
		if (m < 0)
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 04                	js     802175 <readn+0x3f>
			return m;
		if (m == 0)
  802171:	75 dd                	jne    802150 <readn+0x1a>
  802173:	eb 02                	jmp    802177 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802175:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802177:	89 d8                	mov    %ebx,%eax
  802179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802181:	f3 0f 1e fb          	endbr32 
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	53                   	push   %ebx
  802189:	83 ec 1c             	sub    $0x1c,%esp
  80218c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80218f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802192:	50                   	push   %eax
  802193:	53                   	push   %ebx
  802194:	e8 8a fc ff ff       	call   801e23 <fd_lookup>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 3a                	js     8021da <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021a0:	83 ec 08             	sub    $0x8,%esp
  8021a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a6:	50                   	push   %eax
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	ff 30                	pushl  (%eax)
  8021ac:	e8 c6 fc ff ff       	call   801e77 <dev_lookup>
  8021b1:	83 c4 10             	add    $0x10,%esp
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	78 22                	js     8021da <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021bf:	74 1e                	je     8021df <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c4:	8b 52 0c             	mov    0xc(%edx),%edx
  8021c7:	85 d2                	test   %edx,%edx
  8021c9:	74 35                	je     802200 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	ff 75 10             	pushl  0x10(%ebp)
  8021d1:	ff 75 0c             	pushl  0xc(%ebp)
  8021d4:	50                   	push   %eax
  8021d5:	ff d2                	call   *%edx
  8021d7:	83 c4 10             	add    $0x10,%esp
}
  8021da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021df:	a1 28 64 80 00       	mov    0x806428,%eax
  8021e4:	8b 40 48             	mov    0x48(%eax),%eax
  8021e7:	83 ec 04             	sub    $0x4,%esp
  8021ea:	53                   	push   %ebx
  8021eb:	50                   	push   %eax
  8021ec:	68 f9 40 80 00       	push   $0x8040f9
  8021f1:	e8 97 e9 ff ff       	call   800b8d <cprintf>
		return -E_INVAL;
  8021f6:	83 c4 10             	add    $0x10,%esp
  8021f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021fe:	eb da                	jmp    8021da <write+0x59>
		return -E_NOT_SUPP;
  802200:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802205:	eb d3                	jmp    8021da <write+0x59>

00802207 <seek>:

int
seek(int fdnum, off_t offset)
{
  802207:	f3 0f 1e fb          	endbr32 
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802211:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802214:	50                   	push   %eax
  802215:	ff 75 08             	pushl  0x8(%ebp)
  802218:	e8 06 fc ff ff       	call   801e23 <fd_lookup>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	85 c0                	test   %eax,%eax
  802222:	78 0e                	js     802232 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802224:	8b 55 0c             	mov    0xc(%ebp),%edx
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802234:	f3 0f 1e fb          	endbr32 
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	53                   	push   %ebx
  80223c:	83 ec 1c             	sub    $0x1c,%esp
  80223f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802242:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802245:	50                   	push   %eax
  802246:	53                   	push   %ebx
  802247:	e8 d7 fb ff ff       	call   801e23 <fd_lookup>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 37                	js     80228a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802253:	83 ec 08             	sub    $0x8,%esp
  802256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802259:	50                   	push   %eax
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	ff 30                	pushl  (%eax)
  80225f:	e8 13 fc ff ff       	call   801e77 <dev_lookup>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 1f                	js     80228a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80226b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802272:	74 1b                	je     80228f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802274:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802277:	8b 52 18             	mov    0x18(%edx),%edx
  80227a:	85 d2                	test   %edx,%edx
  80227c:	74 32                	je     8022b0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80227e:	83 ec 08             	sub    $0x8,%esp
  802281:	ff 75 0c             	pushl  0xc(%ebp)
  802284:	50                   	push   %eax
  802285:	ff d2                	call   *%edx
  802287:	83 c4 10             	add    $0x10,%esp
}
  80228a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80228f:	a1 28 64 80 00       	mov    0x806428,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802294:	8b 40 48             	mov    0x48(%eax),%eax
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	53                   	push   %ebx
  80229b:	50                   	push   %eax
  80229c:	68 bc 40 80 00       	push   $0x8040bc
  8022a1:	e8 e7 e8 ff ff       	call   800b8d <cprintf>
		return -E_INVAL;
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022ae:	eb da                	jmp    80228a <ftruncate+0x56>
		return -E_NOT_SUPP;
  8022b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022b5:	eb d3                	jmp    80228a <ftruncate+0x56>

008022b7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022b7:	f3 0f 1e fb          	endbr32 
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	53                   	push   %ebx
  8022bf:	83 ec 1c             	sub    $0x1c,%esp
  8022c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022c8:	50                   	push   %eax
  8022c9:	ff 75 08             	pushl  0x8(%ebp)
  8022cc:	e8 52 fb ff ff       	call   801e23 <fd_lookup>
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	78 4b                	js     802323 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d8:	83 ec 08             	sub    $0x8,%esp
  8022db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022de:	50                   	push   %eax
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	ff 30                	pushl  (%eax)
  8022e4:	e8 8e fb ff ff       	call   801e77 <dev_lookup>
  8022e9:	83 c4 10             	add    $0x10,%esp
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	78 33                	js     802323 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8022f7:	74 2f                	je     802328 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8022f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8022fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802303:	00 00 00 
	stat->st_isdir = 0;
  802306:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80230d:	00 00 00 
	stat->st_dev = dev;
  802310:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802316:	83 ec 08             	sub    $0x8,%esp
  802319:	53                   	push   %ebx
  80231a:	ff 75 f0             	pushl  -0x10(%ebp)
  80231d:	ff 50 14             	call   *0x14(%eax)
  802320:	83 c4 10             	add    $0x10,%esp
}
  802323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802326:	c9                   	leave  
  802327:	c3                   	ret    
		return -E_NOT_SUPP;
  802328:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80232d:	eb f4                	jmp    802323 <fstat+0x6c>

0080232f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80232f:	f3 0f 1e fb          	endbr32 
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802338:	83 ec 08             	sub    $0x8,%esp
  80233b:	6a 00                	push   $0x0
  80233d:	ff 75 08             	pushl  0x8(%ebp)
  802340:	e8 fb 01 00 00       	call   802540 <open>
  802345:	89 c3                	mov    %eax,%ebx
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	78 1b                	js     802369 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80234e:	83 ec 08             	sub    $0x8,%esp
  802351:	ff 75 0c             	pushl  0xc(%ebp)
  802354:	50                   	push   %eax
  802355:	e8 5d ff ff ff       	call   8022b7 <fstat>
  80235a:	89 c6                	mov    %eax,%esi
	close(fd);
  80235c:	89 1c 24             	mov    %ebx,(%esp)
  80235f:	e8 fd fb ff ff       	call   801f61 <close>
	return r;
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	89 f3                	mov    %esi,%ebx
}
  802369:	89 d8                	mov    %ebx,%eax
  80236b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80236e:	5b                   	pop    %ebx
  80236f:	5e                   	pop    %esi
  802370:	5d                   	pop    %ebp
  802371:	c3                   	ret    

00802372 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	56                   	push   %esi
  802376:	53                   	push   %ebx
  802377:	89 c6                	mov    %eax,%esi
  802379:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80237b:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802382:	74 27                	je     8023ab <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802384:	6a 07                	push   $0x7
  802386:	68 00 70 80 00       	push   $0x807000
  80238b:	56                   	push   %esi
  80238c:	ff 35 20 64 80 00    	pushl  0x806420
  802392:	e8 32 13 00 00       	call   8036c9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802397:	83 c4 0c             	add    $0xc,%esp
  80239a:	6a 00                	push   $0x0
  80239c:	53                   	push   %ebx
  80239d:	6a 00                	push   $0x0
  80239f:	e8 b1 12 00 00       	call   803655 <ipc_recv>
}
  8023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5d                   	pop    %ebp
  8023aa:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023ab:	83 ec 0c             	sub    $0xc,%esp
  8023ae:	6a 01                	push   $0x1
  8023b0:	e8 6c 13 00 00       	call   803721 <ipc_find_env>
  8023b5:	a3 20 64 80 00       	mov    %eax,0x806420
  8023ba:	83 c4 10             	add    $0x10,%esp
  8023bd:	eb c5                	jmp    802384 <fsipc+0x12>

008023bf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023bf:	f3 0f 1e fb          	endbr32 
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cf:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8023d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d7:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8023dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e1:	b8 02 00 00 00       	mov    $0x2,%eax
  8023e6:	e8 87 ff ff ff       	call   802372 <fsipc>
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <devfile_flush>:
{
  8023ed:	f3 0f 1e fb          	endbr32 
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fd:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802402:	ba 00 00 00 00       	mov    $0x0,%edx
  802407:	b8 06 00 00 00       	mov    $0x6,%eax
  80240c:	e8 61 ff ff ff       	call   802372 <fsipc>
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <devfile_stat>:
{
  802413:	f3 0f 1e fb          	endbr32 
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	53                   	push   %ebx
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 40 0c             	mov    0xc(%eax),%eax
  802427:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80242c:	ba 00 00 00 00       	mov    $0x0,%edx
  802431:	b8 05 00 00 00       	mov    $0x5,%eax
  802436:	e8 37 ff ff ff       	call   802372 <fsipc>
  80243b:	85 c0                	test   %eax,%eax
  80243d:	78 2c                	js     80246b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80243f:	83 ec 08             	sub    $0x8,%esp
  802442:	68 00 70 80 00       	push   $0x807000
  802447:	53                   	push   %ebx
  802448:	e8 3e ee ff ff       	call   80128b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80244d:	a1 80 70 80 00       	mov    0x807080,%eax
  802452:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802458:	a1 84 70 80 00       	mov    0x807084,%eax
  80245d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802463:	83 c4 10             	add    $0x10,%esp
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <devfile_write>:
{
  802470:	f3 0f 1e fb          	endbr32 
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 0c             	sub    $0xc,%esp
  80247a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80247d:	8b 55 08             	mov    0x8(%ebp),%edx
  802480:	8b 52 0c             	mov    0xc(%edx),%edx
  802483:	89 15 00 70 80 00    	mov    %edx,0x807000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  802489:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80248e:	ba 00 10 00 00       	mov    $0x1000,%edx
  802493:	0f 47 c2             	cmova  %edx,%eax
  802496:	a3 04 70 80 00       	mov    %eax,0x807004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80249b:	50                   	push   %eax
  80249c:	ff 75 0c             	pushl  0xc(%ebp)
  80249f:	68 08 70 80 00       	push   $0x807008
  8024a4:	e8 98 ef ff ff       	call   801441 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8024a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ae:	b8 04 00 00 00       	mov    $0x4,%eax
  8024b3:	e8 ba fe ff ff       	call   802372 <fsipc>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <devfile_read>:
{
  8024ba:	f3 0f 1e fb          	endbr32 
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	56                   	push   %esi
  8024c2:	53                   	push   %ebx
  8024c3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8024d1:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024dc:	b8 03 00 00 00       	mov    $0x3,%eax
  8024e1:	e8 8c fe ff ff       	call   802372 <fsipc>
  8024e6:	89 c3                	mov    %eax,%ebx
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	78 1f                	js     80250b <devfile_read+0x51>
	assert(r <= n);
  8024ec:	39 f0                	cmp    %esi,%eax
  8024ee:	77 24                	ja     802514 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8024f0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8024f5:	7f 33                	jg     80252a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	50                   	push   %eax
  8024fb:	68 00 70 80 00       	push   $0x807000
  802500:	ff 75 0c             	pushl  0xc(%ebp)
  802503:	e8 39 ef ff ff       	call   801441 <memmove>
	return r;
  802508:	83 c4 10             	add    $0x10,%esp
}
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
	assert(r <= n);
  802514:	68 2c 41 80 00       	push   $0x80412c
  802519:	68 4f 3b 80 00       	push   $0x803b4f
  80251e:	6a 7c                	push   $0x7c
  802520:	68 33 41 80 00       	push   $0x804133
  802525:	e8 7c e5 ff ff       	call   800aa6 <_panic>
	assert(r <= PGSIZE);
  80252a:	68 3e 41 80 00       	push   $0x80413e
  80252f:	68 4f 3b 80 00       	push   $0x803b4f
  802534:	6a 7d                	push   $0x7d
  802536:	68 33 41 80 00       	push   $0x804133
  80253b:	e8 66 e5 ff ff       	call   800aa6 <_panic>

00802540 <open>:
{
  802540:	f3 0f 1e fb          	endbr32 
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	56                   	push   %esi
  802548:	53                   	push   %ebx
  802549:	83 ec 1c             	sub    $0x1c,%esp
  80254c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80254f:	56                   	push   %esi
  802550:	e8 f3 ec ff ff       	call   801248 <strlen>
  802555:	83 c4 10             	add    $0x10,%esp
  802558:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80255d:	7f 6c                	jg     8025cb <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80255f:	83 ec 0c             	sub    $0xc,%esp
  802562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802565:	50                   	push   %eax
  802566:	e8 62 f8 ff ff       	call   801dcd <fd_alloc>
  80256b:	89 c3                	mov    %eax,%ebx
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	85 c0                	test   %eax,%eax
  802572:	78 3c                	js     8025b0 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  802574:	83 ec 08             	sub    $0x8,%esp
  802577:	56                   	push   %esi
  802578:	68 00 70 80 00       	push   $0x807000
  80257d:	e8 09 ed ff ff       	call   80128b <strcpy>
	fsipcbuf.open.req_omode = mode;
  802582:	8b 45 0c             	mov    0xc(%ebp),%eax
  802585:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	b8 01 00 00 00       	mov    $0x1,%eax
  802592:	e8 db fd ff ff       	call   802372 <fsipc>
  802597:	89 c3                	mov    %eax,%ebx
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	85 c0                	test   %eax,%eax
  80259e:	78 19                	js     8025b9 <open+0x79>
	return fd2num(fd);
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a6:	e8 f3 f7 ff ff       	call   801d9e <fd2num>
  8025ab:	89 c3                	mov    %eax,%ebx
  8025ad:	83 c4 10             	add    $0x10,%esp
}
  8025b0:	89 d8                	mov    %ebx,%eax
  8025b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025b5:	5b                   	pop    %ebx
  8025b6:	5e                   	pop    %esi
  8025b7:	5d                   	pop    %ebp
  8025b8:	c3                   	ret    
		fd_close(fd, 0);
  8025b9:	83 ec 08             	sub    $0x8,%esp
  8025bc:	6a 00                	push   $0x0
  8025be:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c1:	e8 10 f9 ff ff       	call   801ed6 <fd_close>
		return r;
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	eb e5                	jmp    8025b0 <open+0x70>
		return -E_BAD_PATH;
  8025cb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8025d0:	eb de                	jmp    8025b0 <open+0x70>

008025d2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8025d2:	f3 0f 1e fb          	endbr32 
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8025dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8025e6:	e8 87 fd ff ff       	call   802372 <fsipc>
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8025ed:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8025f1:	7f 01                	jg     8025f4 <writebuf+0x7>
  8025f3:	c3                   	ret    
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 08             	sub    $0x8,%esp
  8025fb:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8025fd:	ff 70 04             	pushl  0x4(%eax)
  802600:	8d 40 10             	lea    0x10(%eax),%eax
  802603:	50                   	push   %eax
  802604:	ff 33                	pushl  (%ebx)
  802606:	e8 76 fb ff ff       	call   802181 <write>
		if (result > 0)
  80260b:	83 c4 10             	add    $0x10,%esp
  80260e:	85 c0                	test   %eax,%eax
  802610:	7e 03                	jle    802615 <writebuf+0x28>
			b->result += result;
  802612:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802615:	39 43 04             	cmp    %eax,0x4(%ebx)
  802618:	74 0d                	je     802627 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80261a:	85 c0                	test   %eax,%eax
  80261c:	ba 00 00 00 00       	mov    $0x0,%edx
  802621:	0f 4f c2             	cmovg  %edx,%eax
  802624:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <putch>:

static void
putch(int ch, void *thunk)
{
  80262c:	f3 0f 1e fb          	endbr32 
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	53                   	push   %ebx
  802634:	83 ec 04             	sub    $0x4,%esp
  802637:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80263a:	8b 53 04             	mov    0x4(%ebx),%edx
  80263d:	8d 42 01             	lea    0x1(%edx),%eax
  802640:	89 43 04             	mov    %eax,0x4(%ebx)
  802643:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802646:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80264a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80264f:	74 06                	je     802657 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  802651:	83 c4 04             	add    $0x4,%esp
  802654:	5b                   	pop    %ebx
  802655:	5d                   	pop    %ebp
  802656:	c3                   	ret    
		writebuf(b);
  802657:	89 d8                	mov    %ebx,%eax
  802659:	e8 8f ff ff ff       	call   8025ed <writebuf>
		b->idx = 0;
  80265e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802665:	eb ea                	jmp    802651 <putch+0x25>

00802667 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802667:	f3 0f 1e fb          	endbr32 
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
  80266e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80267d:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802684:	00 00 00 
	b.result = 0;
  802687:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80268e:	00 00 00 
	b.error = 1;
  802691:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802698:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80269b:	ff 75 10             	pushl  0x10(%ebp)
  80269e:	ff 75 0c             	pushl  0xc(%ebp)
  8026a1:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026a7:	50                   	push   %eax
  8026a8:	68 2c 26 80 00       	push   $0x80262c
  8026ad:	e8 de e5 ff ff       	call   800c90 <vprintfmt>
	if (b.idx > 0)
  8026b2:	83 c4 10             	add    $0x10,%esp
  8026b5:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8026bc:	7f 11                	jg     8026cf <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8026be:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    
		writebuf(&b);
  8026cf:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8026d5:	e8 13 ff ff ff       	call   8025ed <writebuf>
  8026da:	eb e2                	jmp    8026be <vfprintf+0x57>

008026dc <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8026dc:	f3 0f 1e fb          	endbr32 
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8026e6:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8026e9:	50                   	push   %eax
  8026ea:	ff 75 0c             	pushl  0xc(%ebp)
  8026ed:	ff 75 08             	pushl  0x8(%ebp)
  8026f0:	e8 72 ff ff ff       	call   802667 <vfprintf>
	va_end(ap);

	return cnt;
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <printf>:

int
printf(const char *fmt, ...)
{
  8026f7:	f3 0f 1e fb          	endbr32 
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802701:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802704:	50                   	push   %eax
  802705:	ff 75 08             	pushl  0x8(%ebp)
  802708:	6a 01                	push   $0x1
  80270a:	e8 58 ff ff ff       	call   802667 <vfprintf>
	va_end(ap);

	return cnt;
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802711:	f3 0f 1e fb          	endbr32 
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	57                   	push   %edi
  802719:	56                   	push   %esi
  80271a:	53                   	push   %ebx
  80271b:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802721:	6a 00                	push   $0x0
  802723:	ff 75 08             	pushl  0x8(%ebp)
  802726:	e8 15 fe ff ff       	call   802540 <open>
  80272b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	85 c0                	test   %eax,%eax
  802736:	0f 88 07 05 00 00    	js     802c43 <spawn+0x532>
  80273c:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80273e:	83 ec 04             	sub    $0x4,%esp
  802741:	68 00 02 00 00       	push   $0x200
  802746:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80274c:	50                   	push   %eax
  80274d:	52                   	push   %edx
  80274e:	e8 e3 f9 ff ff       	call   802136 <readn>
  802753:	83 c4 10             	add    $0x10,%esp
  802756:	3d 00 02 00 00       	cmp    $0x200,%eax
  80275b:	0f 85 9d 00 00 00    	jne    8027fe <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  802761:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802768:	45 4c 46 
  80276b:	0f 85 8d 00 00 00    	jne    8027fe <spawn+0xed>
  802771:	b8 07 00 00 00       	mov    $0x7,%eax
  802776:	cd 30                	int    $0x30
  802778:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80277e:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802784:	85 c0                	test   %eax,%eax
  802786:	0f 88 ab 04 00 00    	js     802c37 <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80278c:	25 ff 03 00 00       	and    $0x3ff,%eax
  802791:	6b f0 7c             	imul   $0x7c,%eax,%esi
  802794:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80279a:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8027a0:	b9 11 00 00 00       	mov    $0x11,%ecx
  8027a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8027a7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8027ad:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	6a 04                	push   $0x4
  8027b8:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  8027be:	50                   	push   %eax
  8027bf:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  8027c5:	50                   	push   %eax
  8027c6:	e8 dc ec ff ff       	call   8014a7 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8027cb:	83 c4 10             	add    $0x10,%esp
  8027ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8027d3:	be 00 00 00 00       	mov    $0x0,%esi
  8027d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027db:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  8027e2:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	74 4d                	je     802836 <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  8027e9:	83 ec 0c             	sub    $0xc,%esp
  8027ec:	50                   	push   %eax
  8027ed:	e8 56 ea ff ff       	call   801248 <strlen>
  8027f2:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8027f6:	83 c3 01             	add    $0x1,%ebx
  8027f9:	83 c4 10             	add    $0x10,%esp
  8027fc:	eb dd                	jmp    8027db <spawn+0xca>
		close(fd);
  8027fe:	83 ec 0c             	sub    $0xc,%esp
  802801:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802807:	e8 55 f7 ff ff       	call   801f61 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80280c:	83 c4 0c             	add    $0xc,%esp
  80280f:	68 7f 45 4c 46       	push   $0x464c457f
  802814:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80281a:	68 4a 41 80 00       	push   $0x80414a
  80281f:	e8 69 e3 ff ff       	call   800b8d <cprintf>
		return -E_NOT_EXEC;
  802824:	83 c4 10             	add    $0x10,%esp
  802827:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  80282e:	ff ff ff 
  802831:	e9 0d 04 00 00       	jmp    802c43 <spawn+0x532>
  802836:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  80283c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802842:	bf 00 10 40 00       	mov    $0x401000,%edi
  802847:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802849:	89 fa                	mov    %edi,%edx
  80284b:	83 e2 fc             	and    $0xfffffffc,%edx
  80284e:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802855:	29 c2                	sub    %eax,%edx
  802857:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80285d:	8d 42 f8             	lea    -0x8(%edx),%eax
  802860:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802865:	0f 86 fb 03 00 00    	jbe    802c66 <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80286b:	83 ec 04             	sub    $0x4,%esp
  80286e:	6a 07                	push   $0x7
  802870:	68 00 00 40 00       	push   $0x400000
  802875:	6a 00                	push   $0x0
  802877:	e8 51 ee ff ff       	call   8016cd <sys_page_alloc>
  80287c:	83 c4 10             	add    $0x10,%esp
  80287f:	85 c0                	test   %eax,%eax
  802881:	0f 88 e4 03 00 00    	js     802c6b <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802887:	be 00 00 00 00       	mov    $0x0,%esi
  80288c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802892:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802895:	eb 30                	jmp    8028c7 <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  802897:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80289d:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8028a3:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8028a6:	83 ec 08             	sub    $0x8,%esp
  8028a9:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028ac:	57                   	push   %edi
  8028ad:	e8 d9 e9 ff ff       	call   80128b <strcpy>
		string_store += strlen(argv[i]) + 1;
  8028b2:	83 c4 04             	add    $0x4,%esp
  8028b5:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8028b8:	e8 8b e9 ff ff       	call   801248 <strlen>
  8028bd:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  8028c1:	83 c6 01             	add    $0x1,%esi
  8028c4:	83 c4 10             	add    $0x10,%esp
  8028c7:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  8028cd:	7f c8                	jg     802897 <spawn+0x186>
	}
	argv_store[argc] = 0;
  8028cf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028d5:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8028db:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8028e2:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8028e8:	0f 85 86 00 00 00    	jne    802974 <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8028ee:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8028f4:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  8028fa:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8028fd:	89 c8                	mov    %ecx,%eax
  8028ff:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  802905:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802908:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80290d:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802913:	83 ec 0c             	sub    $0xc,%esp
  802916:	6a 07                	push   $0x7
  802918:	68 00 d0 bf ee       	push   $0xeebfd000
  80291d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802923:	68 00 00 40 00       	push   $0x400000
  802928:	6a 00                	push   $0x0
  80292a:	e8 e5 ed ff ff       	call   801714 <sys_page_map>
  80292f:	89 c3                	mov    %eax,%ebx
  802931:	83 c4 20             	add    $0x20,%esp
  802934:	85 c0                	test   %eax,%eax
  802936:	0f 88 37 03 00 00    	js     802c73 <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80293c:	83 ec 08             	sub    $0x8,%esp
  80293f:	68 00 00 40 00       	push   $0x400000
  802944:	6a 00                	push   $0x0
  802946:	e8 0f ee ff ff       	call   80175a <sys_page_unmap>
  80294b:	89 c3                	mov    %eax,%ebx
  80294d:	83 c4 10             	add    $0x10,%esp
  802950:	85 c0                	test   %eax,%eax
  802952:	0f 88 1b 03 00 00    	js     802c73 <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802958:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80295e:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802965:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  80296c:	00 00 00 
  80296f:	e9 4f 01 00 00       	jmp    802ac3 <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  802974:	68 c0 41 80 00       	push   $0x8041c0
  802979:	68 4f 3b 80 00       	push   $0x803b4f
  80297e:	68 f6 00 00 00       	push   $0xf6
  802983:	68 64 41 80 00       	push   $0x804164
  802988:	e8 19 e1 ff ff       	call   800aa6 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	6a 07                	push   $0x7
  802992:	68 00 00 40 00       	push   $0x400000
  802997:	6a 00                	push   $0x0
  802999:	e8 2f ed ff ff       	call   8016cd <sys_page_alloc>
  80299e:	83 c4 10             	add    $0x10,%esp
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	0f 88 a8 02 00 00    	js     802c51 <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8029a9:	83 ec 08             	sub    $0x8,%esp
  8029ac:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8029b2:	01 f0                	add    %esi,%eax
  8029b4:	50                   	push   %eax
  8029b5:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029bb:	e8 47 f8 ff ff       	call   802207 <seek>
  8029c0:	83 c4 10             	add    $0x10,%esp
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 88 8d 02 00 00    	js     802c58 <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8029d4:	29 f0                	sub    %esi,%eax
  8029d6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8029db:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8029e0:	0f 47 c1             	cmova  %ecx,%eax
  8029e3:	50                   	push   %eax
  8029e4:	68 00 00 40 00       	push   $0x400000
  8029e9:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8029ef:	e8 42 f7 ff ff       	call   802136 <readn>
  8029f4:	83 c4 10             	add    $0x10,%esp
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	0f 88 60 02 00 00    	js     802c5f <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a08:	53                   	push   %ebx
  802a09:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a0f:	68 00 00 40 00       	push   $0x400000
  802a14:	6a 00                	push   $0x0
  802a16:	e8 f9 ec ff ff       	call   801714 <sys_page_map>
  802a1b:	83 c4 20             	add    $0x20,%esp
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	78 7c                	js     802a9e <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802a22:	83 ec 08             	sub    $0x8,%esp
  802a25:	68 00 00 40 00       	push   $0x400000
  802a2a:	6a 00                	push   $0x0
  802a2c:	e8 29 ed ff ff       	call   80175a <sys_page_unmap>
  802a31:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802a34:	81 c7 00 10 00 00    	add    $0x1000,%edi
  802a3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a40:	89 fe                	mov    %edi,%esi
  802a42:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  802a48:	76 69                	jbe    802ab3 <spawn+0x3a2>
		if (i >= filesz) {
  802a4a:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  802a50:	0f 87 37 ff ff ff    	ja     80298d <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a5f:	53                   	push   %ebx
  802a60:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802a66:	e8 62 ec ff ff       	call   8016cd <sys_page_alloc>
  802a6b:	83 c4 10             	add    $0x10,%esp
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	79 c2                	jns    802a34 <spawn+0x323>
  802a72:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802a7d:	e8 c0 eb ff ff       	call   801642 <sys_env_destroy>
	close(fd);
  802a82:	83 c4 04             	add    $0x4,%esp
  802a85:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802a8b:	e8 d1 f4 ff ff       	call   801f61 <close>
	return r;
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  802a99:	e9 a5 01 00 00       	jmp    802c43 <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  802a9e:	50                   	push   %eax
  802a9f:	68 70 41 80 00       	push   $0x804170
  802aa4:	68 29 01 00 00       	push   $0x129
  802aa9:	68 64 41 80 00       	push   $0x804164
  802aae:	e8 f3 df ff ff       	call   800aa6 <_panic>
  802ab3:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802ab9:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  802ac0:	83 c6 20             	add    $0x20,%esi
  802ac3:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802aca:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  802ad0:	7e 6d                	jle    802b3f <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  802ad2:	83 3e 01             	cmpl   $0x1,(%esi)
  802ad5:	75 e2                	jne    802ab9 <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802ad7:	8b 46 18             	mov    0x18(%esi),%eax
  802ada:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  802add:	83 f8 01             	cmp    $0x1,%eax
  802ae0:	19 c0                	sbb    %eax,%eax
  802ae2:	83 e0 fe             	and    $0xfffffffe,%eax
  802ae5:	83 c0 07             	add    $0x7,%eax
  802ae8:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802aee:	8b 4e 04             	mov    0x4(%esi),%ecx
  802af1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802af7:	8b 56 10             	mov    0x10(%esi),%edx
  802afa:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  802b00:	8b 7e 14             	mov    0x14(%esi),%edi
  802b03:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  802b09:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  802b0c:	89 d8                	mov    %ebx,%eax
  802b0e:	25 ff 0f 00 00       	and    $0xfff,%eax
  802b13:	74 1a                	je     802b2f <spawn+0x41e>
		va -= i;
  802b15:	29 c3                	sub    %eax,%ebx
		memsz += i;
  802b17:	01 c7                	add    %eax,%edi
  802b19:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  802b1f:	01 c2                	add    %eax,%edx
  802b21:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  802b27:	29 c1                	sub    %eax,%ecx
  802b29:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802b2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802b34:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  802b3a:	e9 01 ff ff ff       	jmp    802a40 <spawn+0x32f>
	close(fd);
  802b3f:	83 ec 0c             	sub    $0xc,%esp
  802b42:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  802b48:	e8 14 f4 ff ff       	call   801f61 <close>
  802b4d:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802b50:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b55:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  802b5b:	eb 2a                	jmp    802b87 <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  802b5d:	a1 28 64 80 00       	mov    0x806428,%eax
  802b62:	8b 40 48             	mov    0x48(%eax),%eax
  802b65:	83 ec 0c             	sub    $0xc,%esp
  802b68:	68 07 0e 00 00       	push   $0xe07
  802b6d:	53                   	push   %ebx
  802b6e:	56                   	push   %esi
  802b6f:	53                   	push   %ebx
  802b70:	50                   	push   %eax
  802b71:	e8 9e eb ff ff       	call   801714 <sys_page_map>
  802b76:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802b79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802b7f:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  802b85:	74 3b                	je     802bc2 <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  802b87:	89 d8                	mov    %ebx,%eax
  802b89:	c1 e8 16             	shr    $0x16,%eax
  802b8c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802b93:	a8 01                	test   $0x1,%al
  802b95:	74 e2                	je     802b79 <spawn+0x468>
  802b97:	89 d8                	mov    %ebx,%eax
  802b99:	c1 e8 0c             	shr    $0xc,%eax
  802b9c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802ba3:	f6 c2 01             	test   $0x1,%dl
  802ba6:	74 d1                	je     802b79 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  802ba8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  802baf:	f6 c2 04             	test   $0x4,%dl
  802bb2:	74 c5                	je     802b79 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  802bb4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802bbb:	f6 c4 04             	test   $0x4,%ah
  802bbe:	74 b9                	je     802b79 <spawn+0x468>
  802bc0:	eb 9b                	jmp    802b5d <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802bc2:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802bc9:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802bcc:	83 ec 08             	sub    $0x8,%esp
  802bcf:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802bd5:	50                   	push   %eax
  802bd6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bdc:	e8 05 ec ff ff       	call   8017e6 <sys_env_set_trapframe>
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	85 c0                	test   %eax,%eax
  802be6:	78 25                	js     802c0d <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802be8:	83 ec 08             	sub    $0x8,%esp
  802beb:	6a 02                	push   $0x2
  802bed:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802bf3:	e8 a8 eb ff ff       	call   8017a0 <sys_env_set_status>
  802bf8:	83 c4 10             	add    $0x10,%esp
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	78 23                	js     802c22 <spawn+0x511>
	return child;
  802bff:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c05:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c0b:	eb 36                	jmp    802c43 <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  802c0d:	50                   	push   %eax
  802c0e:	68 8d 41 80 00       	push   $0x80418d
  802c13:	68 8a 00 00 00       	push   $0x8a
  802c18:	68 64 41 80 00       	push   $0x804164
  802c1d:	e8 84 de ff ff       	call   800aa6 <_panic>
		panic("sys_env_set_status: %e", r);
  802c22:	50                   	push   %eax
  802c23:	68 a7 41 80 00       	push   $0x8041a7
  802c28:	68 8d 00 00 00       	push   $0x8d
  802c2d:	68 64 41 80 00       	push   $0x804164
  802c32:	e8 6f de ff ff       	call   800aa6 <_panic>
		return r;
  802c37:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802c3d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  802c43:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c4c:	5b                   	pop    %ebx
  802c4d:	5e                   	pop    %esi
  802c4e:	5f                   	pop    %edi
  802c4f:	5d                   	pop    %ebp
  802c50:	c3                   	ret    
  802c51:	89 c7                	mov    %eax,%edi
  802c53:	e9 1c fe ff ff       	jmp    802a74 <spawn+0x363>
  802c58:	89 c7                	mov    %eax,%edi
  802c5a:	e9 15 fe ff ff       	jmp    802a74 <spawn+0x363>
  802c5f:	89 c7                	mov    %eax,%edi
  802c61:	e9 0e fe ff ff       	jmp    802a74 <spawn+0x363>
		return -E_NO_MEM;
  802c66:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802c6b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802c71:	eb d0                	jmp    802c43 <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  802c73:	83 ec 08             	sub    $0x8,%esp
  802c76:	68 00 00 40 00       	push   $0x400000
  802c7b:	6a 00                	push   $0x0
  802c7d:	e8 d8 ea ff ff       	call   80175a <sys_page_unmap>
  802c82:	83 c4 10             	add    $0x10,%esp
  802c85:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802c8b:	eb b6                	jmp    802c43 <spawn+0x532>

00802c8d <spawnl>:
{
  802c8d:	f3 0f 1e fb          	endbr32 
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	57                   	push   %edi
  802c95:	56                   	push   %esi
  802c96:	53                   	push   %ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802c9a:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802ca2:	8d 4a 04             	lea    0x4(%edx),%ecx
  802ca5:	83 3a 00             	cmpl   $0x0,(%edx)
  802ca8:	74 07                	je     802cb1 <spawnl+0x24>
		argc++;
  802caa:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802cad:	89 ca                	mov    %ecx,%edx
  802caf:	eb f1                	jmp    802ca2 <spawnl+0x15>
	const char *argv[argc+2];
  802cb1:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  802cb8:	89 d1                	mov    %edx,%ecx
  802cba:	83 e1 f0             	and    $0xfffffff0,%ecx
  802cbd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802cc3:	89 e6                	mov    %esp,%esi
  802cc5:	29 d6                	sub    %edx,%esi
  802cc7:	89 f2                	mov    %esi,%edx
  802cc9:	39 d4                	cmp    %edx,%esp
  802ccb:	74 10                	je     802cdd <spawnl+0x50>
  802ccd:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  802cd3:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  802cda:	00 
  802cdb:	eb ec                	jmp    802cc9 <spawnl+0x3c>
  802cdd:	89 ca                	mov    %ecx,%edx
  802cdf:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802ce5:	29 d4                	sub    %edx,%esp
  802ce7:	85 d2                	test   %edx,%edx
  802ce9:	74 05                	je     802cf0 <spawnl+0x63>
  802ceb:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  802cf0:	8d 74 24 03          	lea    0x3(%esp),%esi
  802cf4:	89 f2                	mov    %esi,%edx
  802cf6:	c1 ea 02             	shr    $0x2,%edx
  802cf9:	83 e6 fc             	and    $0xfffffffc,%esi
  802cfc:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d01:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802d08:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802d0f:	00 
	va_start(vl, arg0);
  802d10:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802d13:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802d15:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1a:	eb 0b                	jmp    802d27 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802d1c:	83 c0 01             	add    $0x1,%eax
  802d1f:	8b 39                	mov    (%ecx),%edi
  802d21:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802d24:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802d27:	39 d0                	cmp    %edx,%eax
  802d29:	75 f1                	jne    802d1c <spawnl+0x8f>
	return spawn(prog, argv);
  802d2b:	83 ec 08             	sub    $0x8,%esp
  802d2e:	56                   	push   %esi
  802d2f:	ff 75 08             	pushl  0x8(%ebp)
  802d32:	e8 da f9 ff ff       	call   802711 <spawn>
}
  802d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d3a:	5b                   	pop    %ebx
  802d3b:	5e                   	pop    %esi
  802d3c:	5f                   	pop    %edi
  802d3d:	5d                   	pop    %ebp
  802d3e:	c3                   	ret    

00802d3f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802d3f:	f3 0f 1e fb          	endbr32 
  802d43:	55                   	push   %ebp
  802d44:	89 e5                	mov    %esp,%ebp
  802d46:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802d49:	68 e6 41 80 00       	push   $0x8041e6
  802d4e:	ff 75 0c             	pushl  0xc(%ebp)
  802d51:	e8 35 e5 ff ff       	call   80128b <strcpy>
	return 0;
}
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <devsock_close>:
{
  802d5d:	f3 0f 1e fb          	endbr32 
  802d61:	55                   	push   %ebp
  802d62:	89 e5                	mov    %esp,%ebp
  802d64:	53                   	push   %ebx
  802d65:	83 ec 10             	sub    $0x10,%esp
  802d68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802d6b:	53                   	push   %ebx
  802d6c:	e8 ed 09 00 00       	call   80375e <pageref>
  802d71:	89 c2                	mov    %eax,%edx
  802d73:	83 c4 10             	add    $0x10,%esp
		return 0;
  802d76:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802d7b:	83 fa 01             	cmp    $0x1,%edx
  802d7e:	74 05                	je     802d85 <devsock_close+0x28>
}
  802d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	ff 73 0c             	pushl  0xc(%ebx)
  802d8b:	e8 e3 02 00 00       	call   803073 <nsipc_close>
  802d90:	83 c4 10             	add    $0x10,%esp
  802d93:	eb eb                	jmp    802d80 <devsock_close+0x23>

00802d95 <devsock_write>:
{
  802d95:	f3 0f 1e fb          	endbr32 
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
  802d9c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802d9f:	6a 00                	push   $0x0
  802da1:	ff 75 10             	pushl  0x10(%ebp)
  802da4:	ff 75 0c             	pushl  0xc(%ebp)
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	ff 70 0c             	pushl  0xc(%eax)
  802dad:	e8 b5 03 00 00       	call   803167 <nsipc_send>
}
  802db2:	c9                   	leave  
  802db3:	c3                   	ret    

00802db4 <devsock_read>:
{
  802db4:	f3 0f 1e fb          	endbr32 
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
  802dbb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802dbe:	6a 00                	push   $0x0
  802dc0:	ff 75 10             	pushl  0x10(%ebp)
  802dc3:	ff 75 0c             	pushl  0xc(%ebp)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	ff 70 0c             	pushl  0xc(%eax)
  802dcc:	e8 1f 03 00 00       	call   8030f0 <nsipc_recv>
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <fd2sockid>:
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
  802dd6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802dd9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802ddc:	52                   	push   %edx
  802ddd:	50                   	push   %eax
  802dde:	e8 40 f0 ff ff       	call   801e23 <fd_lookup>
  802de3:	83 c4 10             	add    $0x10,%esp
  802de6:	85 c0                	test   %eax,%eax
  802de8:	78 10                	js     802dfa <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  802df3:	39 08                	cmp    %ecx,(%eax)
  802df5:	75 05                	jne    802dfc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802df7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802dfa:	c9                   	leave  
  802dfb:	c3                   	ret    
		return -E_NOT_SUPP;
  802dfc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e01:	eb f7                	jmp    802dfa <fd2sockid+0x27>

00802e03 <alloc_sockfd>:
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
  802e06:	56                   	push   %esi
  802e07:	53                   	push   %ebx
  802e08:	83 ec 1c             	sub    $0x1c,%esp
  802e0b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  802e0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e10:	50                   	push   %eax
  802e11:	e8 b7 ef ff ff       	call   801dcd <fd_alloc>
  802e16:	89 c3                	mov    %eax,%ebx
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	78 43                	js     802e62 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e1f:	83 ec 04             	sub    $0x4,%esp
  802e22:	68 07 04 00 00       	push   $0x407
  802e27:	ff 75 f4             	pushl  -0xc(%ebp)
  802e2a:	6a 00                	push   $0x0
  802e2c:	e8 9c e8 ff ff       	call   8016cd <sys_page_alloc>
  802e31:	89 c3                	mov    %eax,%ebx
  802e33:	83 c4 10             	add    $0x10,%esp
  802e36:	85 c0                	test   %eax,%eax
  802e38:	78 28                	js     802e62 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802e43:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802e4f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802e52:	83 ec 0c             	sub    $0xc,%esp
  802e55:	50                   	push   %eax
  802e56:	e8 43 ef ff ff       	call   801d9e <fd2num>
  802e5b:	89 c3                	mov    %eax,%ebx
  802e5d:	83 c4 10             	add    $0x10,%esp
  802e60:	eb 0c                	jmp    802e6e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802e62:	83 ec 0c             	sub    $0xc,%esp
  802e65:	56                   	push   %esi
  802e66:	e8 08 02 00 00       	call   803073 <nsipc_close>
		return r;
  802e6b:	83 c4 10             	add    $0x10,%esp
}
  802e6e:	89 d8                	mov    %ebx,%eax
  802e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802e73:	5b                   	pop    %ebx
  802e74:	5e                   	pop    %esi
  802e75:	5d                   	pop    %ebp
  802e76:	c3                   	ret    

00802e77 <accept>:
{
  802e77:	f3 0f 1e fb          	endbr32 
  802e7b:	55                   	push   %ebp
  802e7c:	89 e5                	mov    %esp,%ebp
  802e7e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	e8 4a ff ff ff       	call   802dd3 <fd2sockid>
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	78 1b                	js     802ea8 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802e8d:	83 ec 04             	sub    $0x4,%esp
  802e90:	ff 75 10             	pushl  0x10(%ebp)
  802e93:	ff 75 0c             	pushl  0xc(%ebp)
  802e96:	50                   	push   %eax
  802e97:	e8 22 01 00 00       	call   802fbe <nsipc_accept>
  802e9c:	83 c4 10             	add    $0x10,%esp
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	78 05                	js     802ea8 <accept+0x31>
	return alloc_sockfd(r);
  802ea3:	e8 5b ff ff ff       	call   802e03 <alloc_sockfd>
}
  802ea8:	c9                   	leave  
  802ea9:	c3                   	ret    

00802eaa <bind>:
{
  802eaa:	f3 0f 1e fb          	endbr32 
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
  802eb1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	e8 17 ff ff ff       	call   802dd3 <fd2sockid>
  802ebc:	85 c0                	test   %eax,%eax
  802ebe:	78 12                	js     802ed2 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  802ec0:	83 ec 04             	sub    $0x4,%esp
  802ec3:	ff 75 10             	pushl  0x10(%ebp)
  802ec6:	ff 75 0c             	pushl  0xc(%ebp)
  802ec9:	50                   	push   %eax
  802eca:	e8 45 01 00 00       	call   803014 <nsipc_bind>
  802ecf:	83 c4 10             	add    $0x10,%esp
}
  802ed2:	c9                   	leave  
  802ed3:	c3                   	ret    

00802ed4 <shutdown>:
{
  802ed4:	f3 0f 1e fb          	endbr32 
  802ed8:	55                   	push   %ebp
  802ed9:	89 e5                	mov    %esp,%ebp
  802edb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	e8 ed fe ff ff       	call   802dd3 <fd2sockid>
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	78 0f                	js     802ef9 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  802eea:	83 ec 08             	sub    $0x8,%esp
  802eed:	ff 75 0c             	pushl  0xc(%ebp)
  802ef0:	50                   	push   %eax
  802ef1:	e8 57 01 00 00       	call   80304d <nsipc_shutdown>
  802ef6:	83 c4 10             	add    $0x10,%esp
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <connect>:
{
  802efb:	f3 0f 1e fb          	endbr32 
  802eff:	55                   	push   %ebp
  802f00:	89 e5                	mov    %esp,%ebp
  802f02:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	e8 c6 fe ff ff       	call   802dd3 <fd2sockid>
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	78 12                	js     802f23 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  802f11:	83 ec 04             	sub    $0x4,%esp
  802f14:	ff 75 10             	pushl  0x10(%ebp)
  802f17:	ff 75 0c             	pushl  0xc(%ebp)
  802f1a:	50                   	push   %eax
  802f1b:	e8 71 01 00 00       	call   803091 <nsipc_connect>
  802f20:	83 c4 10             	add    $0x10,%esp
}
  802f23:	c9                   	leave  
  802f24:	c3                   	ret    

00802f25 <listen>:
{
  802f25:	f3 0f 1e fb          	endbr32 
  802f29:	55                   	push   %ebp
  802f2a:	89 e5                	mov    %esp,%ebp
  802f2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	e8 9c fe ff ff       	call   802dd3 <fd2sockid>
  802f37:	85 c0                	test   %eax,%eax
  802f39:	78 0f                	js     802f4a <listen+0x25>
	return nsipc_listen(r, backlog);
  802f3b:	83 ec 08             	sub    $0x8,%esp
  802f3e:	ff 75 0c             	pushl  0xc(%ebp)
  802f41:	50                   	push   %eax
  802f42:	e8 83 01 00 00       	call   8030ca <nsipc_listen>
  802f47:	83 c4 10             	add    $0x10,%esp
}
  802f4a:	c9                   	leave  
  802f4b:	c3                   	ret    

00802f4c <socket>:

int
socket(int domain, int type, int protocol)
{
  802f4c:	f3 0f 1e fb          	endbr32 
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
  802f53:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802f56:	ff 75 10             	pushl  0x10(%ebp)
  802f59:	ff 75 0c             	pushl  0xc(%ebp)
  802f5c:	ff 75 08             	pushl  0x8(%ebp)
  802f5f:	e8 65 02 00 00       	call   8031c9 <nsipc_socket>
  802f64:	83 c4 10             	add    $0x10,%esp
  802f67:	85 c0                	test   %eax,%eax
  802f69:	78 05                	js     802f70 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802f6b:	e8 93 fe ff ff       	call   802e03 <alloc_sockfd>
}
  802f70:	c9                   	leave  
  802f71:	c3                   	ret    

00802f72 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802f72:	55                   	push   %ebp
  802f73:	89 e5                	mov    %esp,%ebp
  802f75:	53                   	push   %ebx
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802f7b:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  802f82:	74 26                	je     802faa <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802f84:	6a 07                	push   $0x7
  802f86:	68 00 80 80 00       	push   $0x808000
  802f8b:	53                   	push   %ebx
  802f8c:	ff 35 24 64 80 00    	pushl  0x806424
  802f92:	e8 32 07 00 00       	call   8036c9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802f97:	83 c4 0c             	add    $0xc,%esp
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	e8 b0 06 00 00       	call   803655 <ipc_recv>
}
  802fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802faa:	83 ec 0c             	sub    $0xc,%esp
  802fad:	6a 02                	push   $0x2
  802faf:	e8 6d 07 00 00       	call   803721 <ipc_find_env>
  802fb4:	a3 24 64 80 00       	mov    %eax,0x806424
  802fb9:	83 c4 10             	add    $0x10,%esp
  802fbc:	eb c6                	jmp    802f84 <nsipc+0x12>

00802fbe <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802fbe:	f3 0f 1e fb          	endbr32 
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	56                   	push   %esi
  802fc6:	53                   	push   %ebx
  802fc7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802fd2:	8b 06                	mov    (%esi),%eax
  802fd4:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802fd9:	b8 01 00 00 00       	mov    $0x1,%eax
  802fde:	e8 8f ff ff ff       	call   802f72 <nsipc>
  802fe3:	89 c3                	mov    %eax,%ebx
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	79 09                	jns    802ff2 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802fe9:	89 d8                	mov    %ebx,%eax
  802feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fee:	5b                   	pop    %ebx
  802fef:	5e                   	pop    %esi
  802ff0:	5d                   	pop    %ebp
  802ff1:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	ff 35 10 80 80 00    	pushl  0x808010
  802ffb:	68 00 80 80 00       	push   $0x808000
  803000:	ff 75 0c             	pushl  0xc(%ebp)
  803003:	e8 39 e4 ff ff       	call   801441 <memmove>
		*addrlen = ret->ret_addrlen;
  803008:	a1 10 80 80 00       	mov    0x808010,%eax
  80300d:	89 06                	mov    %eax,(%esi)
  80300f:	83 c4 10             	add    $0x10,%esp
	return r;
  803012:	eb d5                	jmp    802fe9 <nsipc_accept+0x2b>

00803014 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803014:	f3 0f 1e fb          	endbr32 
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
  80301b:	53                   	push   %ebx
  80301c:	83 ec 08             	sub    $0x8,%esp
  80301f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80302a:	53                   	push   %ebx
  80302b:	ff 75 0c             	pushl  0xc(%ebp)
  80302e:	68 04 80 80 00       	push   $0x808004
  803033:	e8 09 e4 ff ff       	call   801441 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803038:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80303e:	b8 02 00 00 00       	mov    $0x2,%eax
  803043:	e8 2a ff ff ff       	call   802f72 <nsipc>
}
  803048:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80304d:	f3 0f 1e fb          	endbr32 
  803051:	55                   	push   %ebp
  803052:	89 e5                	mov    %esp,%ebp
  803054:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  80305f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803062:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803067:	b8 03 00 00 00       	mov    $0x3,%eax
  80306c:	e8 01 ff ff ff       	call   802f72 <nsipc>
}
  803071:	c9                   	leave  
  803072:	c3                   	ret    

00803073 <nsipc_close>:

int
nsipc_close(int s)
{
  803073:	f3 0f 1e fb          	endbr32 
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803085:	b8 04 00 00 00       	mov    $0x4,%eax
  80308a:	e8 e3 fe ff ff       	call   802f72 <nsipc>
}
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803091:	f3 0f 1e fb          	endbr32 
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
  803098:	53                   	push   %ebx
  803099:	83 ec 08             	sub    $0x8,%esp
  80309c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8030a7:	53                   	push   %ebx
  8030a8:	ff 75 0c             	pushl  0xc(%ebp)
  8030ab:	68 04 80 80 00       	push   $0x808004
  8030b0:	e8 8c e3 ff ff       	call   801441 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8030b5:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8030bb:	b8 05 00 00 00       	mov    $0x5,%eax
  8030c0:	e8 ad fe ff ff       	call   802f72 <nsipc>
}
  8030c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030c8:	c9                   	leave  
  8030c9:	c3                   	ret    

008030ca <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8030ca:	f3 0f 1e fb          	endbr32 
  8030ce:	55                   	push   %ebp
  8030cf:	89 e5                	mov    %esp,%ebp
  8030d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030df:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8030e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8030e9:	e8 84 fe ff ff       	call   802f72 <nsipc>
}
  8030ee:	c9                   	leave  
  8030ef:	c3                   	ret    

008030f0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8030f0:	f3 0f 1e fb          	endbr32 
  8030f4:	55                   	push   %ebp
  8030f5:	89 e5                	mov    %esp,%ebp
  8030f7:	56                   	push   %esi
  8030f8:	53                   	push   %ebx
  8030f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803104:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  80310a:	8b 45 14             	mov    0x14(%ebp),%eax
  80310d:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803112:	b8 07 00 00 00       	mov    $0x7,%eax
  803117:	e8 56 fe ff ff       	call   802f72 <nsipc>
  80311c:	89 c3                	mov    %eax,%ebx
  80311e:	85 c0                	test   %eax,%eax
  803120:	78 26                	js     803148 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  803122:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  803128:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80312d:	0f 4e c6             	cmovle %esi,%eax
  803130:	39 c3                	cmp    %eax,%ebx
  803132:	7f 1d                	jg     803151 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	53                   	push   %ebx
  803138:	68 00 80 80 00       	push   $0x808000
  80313d:	ff 75 0c             	pushl  0xc(%ebp)
  803140:	e8 fc e2 ff ff       	call   801441 <memmove>
  803145:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  803148:	89 d8                	mov    %ebx,%eax
  80314a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80314d:	5b                   	pop    %ebx
  80314e:	5e                   	pop    %esi
  80314f:	5d                   	pop    %ebp
  803150:	c3                   	ret    
		assert(r < 1600 && r <= len);
  803151:	68 f2 41 80 00       	push   $0x8041f2
  803156:	68 4f 3b 80 00       	push   $0x803b4f
  80315b:	6a 62                	push   $0x62
  80315d:	68 07 42 80 00       	push   $0x804207
  803162:	e8 3f d9 ff ff       	call   800aa6 <_panic>

00803167 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803167:	f3 0f 1e fb          	endbr32 
  80316b:	55                   	push   %ebp
  80316c:	89 e5                	mov    %esp,%ebp
  80316e:	53                   	push   %ebx
  80316f:	83 ec 04             	sub    $0x4,%esp
  803172:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  80317d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803183:	7f 2e                	jg     8031b3 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	53                   	push   %ebx
  803189:	ff 75 0c             	pushl  0xc(%ebp)
  80318c:	68 0c 80 80 00       	push   $0x80800c
  803191:	e8 ab e2 ff ff       	call   801441 <memmove>
	nsipcbuf.send.req_size = size;
  803196:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  80319c:	8b 45 14             	mov    0x14(%ebp),%eax
  80319f:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8031a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8031a9:	e8 c4 fd ff ff       	call   802f72 <nsipc>
}
  8031ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    
	assert(size < 1600);
  8031b3:	68 13 42 80 00       	push   $0x804213
  8031b8:	68 4f 3b 80 00       	push   $0x803b4f
  8031bd:	6a 6d                	push   $0x6d
  8031bf:	68 07 42 80 00       	push   $0x804207
  8031c4:	e8 dd d8 ff ff       	call   800aa6 <_panic>

008031c9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8031c9:	f3 0f 1e fb          	endbr32 
  8031cd:	55                   	push   %ebp
  8031ce:	89 e5                	mov    %esp,%ebp
  8031d0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  8031db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031de:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  8031e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e6:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  8031eb:	b8 09 00 00 00       	mov    $0x9,%eax
  8031f0:	e8 7d fd ff ff       	call   802f72 <nsipc>
}
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8031f7:	f3 0f 1e fb          	endbr32 
  8031fb:	55                   	push   %ebp
  8031fc:	89 e5                	mov    %esp,%ebp
  8031fe:	56                   	push   %esi
  8031ff:	53                   	push   %ebx
  803200:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803203:	83 ec 0c             	sub    $0xc,%esp
  803206:	ff 75 08             	pushl  0x8(%ebp)
  803209:	e8 a4 eb ff ff       	call   801db2 <fd2data>
  80320e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803210:	83 c4 08             	add    $0x8,%esp
  803213:	68 1f 42 80 00       	push   $0x80421f
  803218:	53                   	push   %ebx
  803219:	e8 6d e0 ff ff       	call   80128b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80321e:	8b 46 04             	mov    0x4(%esi),%eax
  803221:	2b 06                	sub    (%esi),%eax
  803223:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803229:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803230:	00 00 00 
	stat->st_dev = &devpipe;
  803233:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80323a:	50 80 00 
	return 0;
}
  80323d:	b8 00 00 00 00       	mov    $0x0,%eax
  803242:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803245:	5b                   	pop    %ebx
  803246:	5e                   	pop    %esi
  803247:	5d                   	pop    %ebp
  803248:	c3                   	ret    

00803249 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803249:	f3 0f 1e fb          	endbr32 
  80324d:	55                   	push   %ebp
  80324e:	89 e5                	mov    %esp,%ebp
  803250:	53                   	push   %ebx
  803251:	83 ec 0c             	sub    $0xc,%esp
  803254:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803257:	53                   	push   %ebx
  803258:	6a 00                	push   $0x0
  80325a:	e8 fb e4 ff ff       	call   80175a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80325f:	89 1c 24             	mov    %ebx,(%esp)
  803262:	e8 4b eb ff ff       	call   801db2 <fd2data>
  803267:	83 c4 08             	add    $0x8,%esp
  80326a:	50                   	push   %eax
  80326b:	6a 00                	push   $0x0
  80326d:	e8 e8 e4 ff ff       	call   80175a <sys_page_unmap>
}
  803272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803275:	c9                   	leave  
  803276:	c3                   	ret    

00803277 <_pipeisclosed>:
{
  803277:	55                   	push   %ebp
  803278:	89 e5                	mov    %esp,%ebp
  80327a:	57                   	push   %edi
  80327b:	56                   	push   %esi
  80327c:	53                   	push   %ebx
  80327d:	83 ec 1c             	sub    $0x1c,%esp
  803280:	89 c7                	mov    %eax,%edi
  803282:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  803284:	a1 28 64 80 00       	mov    0x806428,%eax
  803289:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80328c:	83 ec 0c             	sub    $0xc,%esp
  80328f:	57                   	push   %edi
  803290:	e8 c9 04 00 00       	call   80375e <pageref>
  803295:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803298:	89 34 24             	mov    %esi,(%esp)
  80329b:	e8 be 04 00 00       	call   80375e <pageref>
		nn = thisenv->env_runs;
  8032a0:	8b 15 28 64 80 00    	mov    0x806428,%edx
  8032a6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8032a9:	83 c4 10             	add    $0x10,%esp
  8032ac:	39 cb                	cmp    %ecx,%ebx
  8032ae:	74 1b                	je     8032cb <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8032b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032b3:	75 cf                	jne    803284 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8032b5:	8b 42 58             	mov    0x58(%edx),%eax
  8032b8:	6a 01                	push   $0x1
  8032ba:	50                   	push   %eax
  8032bb:	53                   	push   %ebx
  8032bc:	68 26 42 80 00       	push   $0x804226
  8032c1:	e8 c7 d8 ff ff       	call   800b8d <cprintf>
  8032c6:	83 c4 10             	add    $0x10,%esp
  8032c9:	eb b9                	jmp    803284 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8032cb:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8032ce:	0f 94 c0             	sete   %al
  8032d1:	0f b6 c0             	movzbl %al,%eax
}
  8032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8032d7:	5b                   	pop    %ebx
  8032d8:	5e                   	pop    %esi
  8032d9:	5f                   	pop    %edi
  8032da:	5d                   	pop    %ebp
  8032db:	c3                   	ret    

008032dc <devpipe_write>:
{
  8032dc:	f3 0f 1e fb          	endbr32 
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	57                   	push   %edi
  8032e4:	56                   	push   %esi
  8032e5:	53                   	push   %ebx
  8032e6:	83 ec 28             	sub    $0x28,%esp
  8032e9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8032ec:	56                   	push   %esi
  8032ed:	e8 c0 ea ff ff       	call   801db2 <fd2data>
  8032f2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8032f4:	83 c4 10             	add    $0x10,%esp
  8032f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8032fc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8032ff:	74 4f                	je     803350 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803301:	8b 43 04             	mov    0x4(%ebx),%eax
  803304:	8b 0b                	mov    (%ebx),%ecx
  803306:	8d 51 20             	lea    0x20(%ecx),%edx
  803309:	39 d0                	cmp    %edx,%eax
  80330b:	72 14                	jb     803321 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80330d:	89 da                	mov    %ebx,%edx
  80330f:	89 f0                	mov    %esi,%eax
  803311:	e8 61 ff ff ff       	call   803277 <_pipeisclosed>
  803316:	85 c0                	test   %eax,%eax
  803318:	75 3b                	jne    803355 <devpipe_write+0x79>
			sys_yield();
  80331a:	e8 8b e3 ff ff       	call   8016aa <sys_yield>
  80331f:	eb e0                	jmp    803301 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803324:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803328:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80332b:	89 c2                	mov    %eax,%edx
  80332d:	c1 fa 1f             	sar    $0x1f,%edx
  803330:	89 d1                	mov    %edx,%ecx
  803332:	c1 e9 1b             	shr    $0x1b,%ecx
  803335:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  803338:	83 e2 1f             	and    $0x1f,%edx
  80333b:	29 ca                	sub    %ecx,%edx
  80333d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803341:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803345:	83 c0 01             	add    $0x1,%eax
  803348:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80334b:	83 c7 01             	add    $0x1,%edi
  80334e:	eb ac                	jmp    8032fc <devpipe_write+0x20>
	return i;
  803350:	8b 45 10             	mov    0x10(%ebp),%eax
  803353:	eb 05                	jmp    80335a <devpipe_write+0x7e>
				return 0;
  803355:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80335a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80335d:	5b                   	pop    %ebx
  80335e:	5e                   	pop    %esi
  80335f:	5f                   	pop    %edi
  803360:	5d                   	pop    %ebp
  803361:	c3                   	ret    

00803362 <devpipe_read>:
{
  803362:	f3 0f 1e fb          	endbr32 
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
  803369:	57                   	push   %edi
  80336a:	56                   	push   %esi
  80336b:	53                   	push   %ebx
  80336c:	83 ec 18             	sub    $0x18,%esp
  80336f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803372:	57                   	push   %edi
  803373:	e8 3a ea ff ff       	call   801db2 <fd2data>
  803378:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80337a:	83 c4 10             	add    $0x10,%esp
  80337d:	be 00 00 00 00       	mov    $0x0,%esi
  803382:	3b 75 10             	cmp    0x10(%ebp),%esi
  803385:	75 14                	jne    80339b <devpipe_read+0x39>
	return i;
  803387:	8b 45 10             	mov    0x10(%ebp),%eax
  80338a:	eb 02                	jmp    80338e <devpipe_read+0x2c>
				return i;
  80338c:	89 f0                	mov    %esi,%eax
}
  80338e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803391:	5b                   	pop    %ebx
  803392:	5e                   	pop    %esi
  803393:	5f                   	pop    %edi
  803394:	5d                   	pop    %ebp
  803395:	c3                   	ret    
			sys_yield();
  803396:	e8 0f e3 ff ff       	call   8016aa <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80339b:	8b 03                	mov    (%ebx),%eax
  80339d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8033a0:	75 18                	jne    8033ba <devpipe_read+0x58>
			if (i > 0)
  8033a2:	85 f6                	test   %esi,%esi
  8033a4:	75 e6                	jne    80338c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8033a6:	89 da                	mov    %ebx,%edx
  8033a8:	89 f8                	mov    %edi,%eax
  8033aa:	e8 c8 fe ff ff       	call   803277 <_pipeisclosed>
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	74 e3                	je     803396 <devpipe_read+0x34>
				return 0;
  8033b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b8:	eb d4                	jmp    80338e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8033ba:	99                   	cltd   
  8033bb:	c1 ea 1b             	shr    $0x1b,%edx
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	83 e0 1f             	and    $0x1f,%eax
  8033c3:	29 d0                	sub    %edx,%eax
  8033c5:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8033ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8033cd:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8033d0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8033d3:	83 c6 01             	add    $0x1,%esi
  8033d6:	eb aa                	jmp    803382 <devpipe_read+0x20>

008033d8 <pipe>:
{
  8033d8:	f3 0f 1e fb          	endbr32 
  8033dc:	55                   	push   %ebp
  8033dd:	89 e5                	mov    %esp,%ebp
  8033df:	56                   	push   %esi
  8033e0:	53                   	push   %ebx
  8033e1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8033e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033e7:	50                   	push   %eax
  8033e8:	e8 e0 e9 ff ff       	call   801dcd <fd_alloc>
  8033ed:	89 c3                	mov    %eax,%ebx
  8033ef:	83 c4 10             	add    $0x10,%esp
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	0f 88 23 01 00 00    	js     80351d <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 07 04 00 00       	push   $0x407
  803402:	ff 75 f4             	pushl  -0xc(%ebp)
  803405:	6a 00                	push   $0x0
  803407:	e8 c1 e2 ff ff       	call   8016cd <sys_page_alloc>
  80340c:	89 c3                	mov    %eax,%ebx
  80340e:	83 c4 10             	add    $0x10,%esp
  803411:	85 c0                	test   %eax,%eax
  803413:	0f 88 04 01 00 00    	js     80351d <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803419:	83 ec 0c             	sub    $0xc,%esp
  80341c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80341f:	50                   	push   %eax
  803420:	e8 a8 e9 ff ff       	call   801dcd <fd_alloc>
  803425:	89 c3                	mov    %eax,%ebx
  803427:	83 c4 10             	add    $0x10,%esp
  80342a:	85 c0                	test   %eax,%eax
  80342c:	0f 88 db 00 00 00    	js     80350d <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	68 07 04 00 00       	push   $0x407
  80343a:	ff 75 f0             	pushl  -0x10(%ebp)
  80343d:	6a 00                	push   $0x0
  80343f:	e8 89 e2 ff ff       	call   8016cd <sys_page_alloc>
  803444:	89 c3                	mov    %eax,%ebx
  803446:	83 c4 10             	add    $0x10,%esp
  803449:	85 c0                	test   %eax,%eax
  80344b:	0f 88 bc 00 00 00    	js     80350d <pipe+0x135>
	va = fd2data(fd0);
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 f4             	pushl  -0xc(%ebp)
  803457:	e8 56 e9 ff ff       	call   801db2 <fd2data>
  80345c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80345e:	83 c4 0c             	add    $0xc,%esp
  803461:	68 07 04 00 00       	push   $0x407
  803466:	50                   	push   %eax
  803467:	6a 00                	push   $0x0
  803469:	e8 5f e2 ff ff       	call   8016cd <sys_page_alloc>
  80346e:	89 c3                	mov    %eax,%ebx
  803470:	83 c4 10             	add    $0x10,%esp
  803473:	85 c0                	test   %eax,%eax
  803475:	0f 88 82 00 00 00    	js     8034fd <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80347b:	83 ec 0c             	sub    $0xc,%esp
  80347e:	ff 75 f0             	pushl  -0x10(%ebp)
  803481:	e8 2c e9 ff ff       	call   801db2 <fd2data>
  803486:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80348d:	50                   	push   %eax
  80348e:	6a 00                	push   $0x0
  803490:	56                   	push   %esi
  803491:	6a 00                	push   $0x0
  803493:	e8 7c e2 ff ff       	call   801714 <sys_page_map>
  803498:	89 c3                	mov    %eax,%ebx
  80349a:	83 c4 20             	add    $0x20,%esp
  80349d:	85 c0                	test   %eax,%eax
  80349f:	78 4e                	js     8034ef <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8034a1:	a1 58 50 80 00       	mov    0x805058,%eax
  8034a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034a9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8034ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ae:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8034b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8034c4:	83 ec 0c             	sub    $0xc,%esp
  8034c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8034ca:	e8 cf e8 ff ff       	call   801d9e <fd2num>
  8034cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034d2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8034d4:	83 c4 04             	add    $0x4,%esp
  8034d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8034da:	e8 bf e8 ff ff       	call   801d9e <fd2num>
  8034df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8034e2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8034e5:	83 c4 10             	add    $0x10,%esp
  8034e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8034ed:	eb 2e                	jmp    80351d <pipe+0x145>
	sys_page_unmap(0, va);
  8034ef:	83 ec 08             	sub    $0x8,%esp
  8034f2:	56                   	push   %esi
  8034f3:	6a 00                	push   $0x0
  8034f5:	e8 60 e2 ff ff       	call   80175a <sys_page_unmap>
  8034fa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8034fd:	83 ec 08             	sub    $0x8,%esp
  803500:	ff 75 f0             	pushl  -0x10(%ebp)
  803503:	6a 00                	push   $0x0
  803505:	e8 50 e2 ff ff       	call   80175a <sys_page_unmap>
  80350a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80350d:	83 ec 08             	sub    $0x8,%esp
  803510:	ff 75 f4             	pushl  -0xc(%ebp)
  803513:	6a 00                	push   $0x0
  803515:	e8 40 e2 ff ff       	call   80175a <sys_page_unmap>
  80351a:	83 c4 10             	add    $0x10,%esp
}
  80351d:	89 d8                	mov    %ebx,%eax
  80351f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803522:	5b                   	pop    %ebx
  803523:	5e                   	pop    %esi
  803524:	5d                   	pop    %ebp
  803525:	c3                   	ret    

00803526 <pipeisclosed>:
{
  803526:	f3 0f 1e fb          	endbr32 
  80352a:	55                   	push   %ebp
  80352b:	89 e5                	mov    %esp,%ebp
  80352d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803530:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803533:	50                   	push   %eax
  803534:	ff 75 08             	pushl  0x8(%ebp)
  803537:	e8 e7 e8 ff ff       	call   801e23 <fd_lookup>
  80353c:	83 c4 10             	add    $0x10,%esp
  80353f:	85 c0                	test   %eax,%eax
  803541:	78 18                	js     80355b <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  803543:	83 ec 0c             	sub    $0xc,%esp
  803546:	ff 75 f4             	pushl  -0xc(%ebp)
  803549:	e8 64 e8 ff ff       	call   801db2 <fd2data>
  80354e:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	e8 1f fd ff ff       	call   803277 <_pipeisclosed>
  803558:	83 c4 10             	add    $0x10,%esp
}
  80355b:	c9                   	leave  
  80355c:	c3                   	ret    

0080355d <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80355d:	f3 0f 1e fb          	endbr32 
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
  803564:	56                   	push   %esi
  803565:	53                   	push   %ebx
  803566:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803569:	85 f6                	test   %esi,%esi
  80356b:	74 13                	je     803580 <wait+0x23>
	e = &envs[ENVX(envid)];
  80356d:	89 f3                	mov    %esi,%ebx
  80356f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803575:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803578:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80357e:	eb 1b                	jmp    80359b <wait+0x3e>
	assert(envid != 0);
  803580:	68 3e 42 80 00       	push   $0x80423e
  803585:	68 4f 3b 80 00       	push   $0x803b4f
  80358a:	6a 09                	push   $0x9
  80358c:	68 49 42 80 00       	push   $0x804249
  803591:	e8 10 d5 ff ff       	call   800aa6 <_panic>
		sys_yield();
  803596:	e8 0f e1 ff ff       	call   8016aa <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80359b:	8b 43 48             	mov    0x48(%ebx),%eax
  80359e:	39 f0                	cmp    %esi,%eax
  8035a0:	75 07                	jne    8035a9 <wait+0x4c>
  8035a2:	8b 43 54             	mov    0x54(%ebx),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	75 ed                	jne    803596 <wait+0x39>
}
  8035a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035ac:	5b                   	pop    %ebx
  8035ad:	5e                   	pop    %esi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    

008035b0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8035b0:	f3 0f 1e fb          	endbr32 
  8035b4:	55                   	push   %ebp
  8035b5:	89 e5                	mov    %esp,%ebp
  8035b7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8035ba:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8035c1:	74 0a                	je     8035cd <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	a3 00 90 80 00       	mov    %eax,0x809000
}
  8035cb:	c9                   	leave  
  8035cc:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  8035cd:	a1 28 64 80 00       	mov    0x806428,%eax
  8035d2:	8b 40 48             	mov    0x48(%eax),%eax
  8035d5:	83 ec 04             	sub    $0x4,%esp
  8035d8:	6a 07                	push   $0x7
  8035da:	68 00 f0 bf ee       	push   $0xeebff000
  8035df:	50                   	push   %eax
  8035e0:	e8 e8 e0 ff ff       	call   8016cd <sys_page_alloc>
  8035e5:	83 c4 10             	add    $0x10,%esp
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	75 31                	jne    80361d <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  8035ec:	a1 28 64 80 00       	mov    0x806428,%eax
  8035f1:	8b 40 48             	mov    0x48(%eax),%eax
  8035f4:	83 ec 08             	sub    $0x8,%esp
  8035f7:	68 31 36 80 00       	push   $0x803631
  8035fc:	50                   	push   %eax
  8035fd:	e8 2a e2 ff ff       	call   80182c <sys_env_set_pgfault_upcall>
  803602:	83 c4 10             	add    $0x10,%esp
  803605:	85 c0                	test   %eax,%eax
  803607:	74 ba                	je     8035c3 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  803609:	83 ec 04             	sub    $0x4,%esp
  80360c:	68 7c 42 80 00       	push   $0x80427c
  803611:	6a 24                	push   $0x24
  803613:	68 aa 42 80 00       	push   $0x8042aa
  803618:	e8 89 d4 ff ff       	call   800aa6 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  80361d:	83 ec 04             	sub    $0x4,%esp
  803620:	68 54 42 80 00       	push   $0x804254
  803625:	6a 21                	push   $0x21
  803627:	68 aa 42 80 00       	push   $0x8042aa
  80362c:	e8 75 d4 ff ff       	call   800aa6 <_panic>

00803631 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803631:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803632:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  803637:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803639:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  80363c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  803640:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  803645:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  803649:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  80364b:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  80364e:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  80364f:	83 c4 04             	add    $0x4,%esp
    popfl
  803652:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  803653:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  803654:	c3                   	ret    

00803655 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803655:	f3 0f 1e fb          	endbr32 
  803659:	55                   	push   %ebp
  80365a:	89 e5                	mov    %esp,%ebp
  80365c:	56                   	push   %esi
  80365d:	53                   	push   %ebx
  80365e:	8b 75 08             	mov    0x8(%ebp),%esi
  803661:	8b 45 0c             	mov    0xc(%ebp),%eax
  803664:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  803667:	83 e8 01             	sub    $0x1,%eax
  80366a:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80366f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  803674:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  803678:	83 ec 0c             	sub    $0xc,%esp
  80367b:	50                   	push   %eax
  80367c:	e8 18 e2 ff ff       	call   801899 <sys_ipc_recv>
	if (!t) {
  803681:	83 c4 10             	add    $0x10,%esp
  803684:	85 c0                	test   %eax,%eax
  803686:	75 2b                	jne    8036b3 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  803688:	85 f6                	test   %esi,%esi
  80368a:	74 0a                	je     803696 <ipc_recv+0x41>
  80368c:	a1 28 64 80 00       	mov    0x806428,%eax
  803691:	8b 40 74             	mov    0x74(%eax),%eax
  803694:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  803696:	85 db                	test   %ebx,%ebx
  803698:	74 0a                	je     8036a4 <ipc_recv+0x4f>
  80369a:	a1 28 64 80 00       	mov    0x806428,%eax
  80369f:	8b 40 78             	mov    0x78(%eax),%eax
  8036a2:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8036a4:	a1 28 64 80 00       	mov    0x806428,%eax
  8036a9:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8036ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5d                   	pop    %ebp
  8036b2:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8036b3:	85 f6                	test   %esi,%esi
  8036b5:	74 06                	je     8036bd <ipc_recv+0x68>
  8036b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8036bd:	85 db                	test   %ebx,%ebx
  8036bf:	74 eb                	je     8036ac <ipc_recv+0x57>
  8036c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8036c7:	eb e3                	jmp    8036ac <ipc_recv+0x57>

008036c9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8036c9:	f3 0f 1e fb          	endbr32 
  8036cd:	55                   	push   %ebp
  8036ce:	89 e5                	mov    %esp,%ebp
  8036d0:	57                   	push   %edi
  8036d1:	56                   	push   %esi
  8036d2:	53                   	push   %ebx
  8036d3:	83 ec 0c             	sub    $0xc,%esp
  8036d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8036d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8036dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8036df:	85 db                	test   %ebx,%ebx
  8036e1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8036e6:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8036e9:	ff 75 14             	pushl  0x14(%ebp)
  8036ec:	53                   	push   %ebx
  8036ed:	56                   	push   %esi
  8036ee:	57                   	push   %edi
  8036ef:	e8 7e e1 ff ff       	call   801872 <sys_ipc_try_send>
  8036f4:	83 c4 10             	add    $0x10,%esp
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	74 1e                	je     803719 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8036fb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8036fe:	75 07                	jne    803707 <ipc_send+0x3e>
		sys_yield();
  803700:	e8 a5 df ff ff       	call   8016aa <sys_yield>
  803705:	eb e2                	jmp    8036e9 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  803707:	50                   	push   %eax
  803708:	68 b8 42 80 00       	push   $0x8042b8
  80370d:	6a 39                	push   $0x39
  80370f:	68 ca 42 80 00       	push   $0x8042ca
  803714:	e8 8d d3 ff ff       	call   800aa6 <_panic>
	}
	//panic("ipc_send not implemented");
}
  803719:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80371c:	5b                   	pop    %ebx
  80371d:	5e                   	pop    %esi
  80371e:	5f                   	pop    %edi
  80371f:	5d                   	pop    %ebp
  803720:	c3                   	ret    

00803721 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803721:	f3 0f 1e fb          	endbr32 
  803725:	55                   	push   %ebp
  803726:	89 e5                	mov    %esp,%ebp
  803728:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80372b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803730:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803733:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803739:	8b 52 50             	mov    0x50(%edx),%edx
  80373c:	39 ca                	cmp    %ecx,%edx
  80373e:	74 11                	je     803751 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  803740:	83 c0 01             	add    $0x1,%eax
  803743:	3d 00 04 00 00       	cmp    $0x400,%eax
  803748:	75 e6                	jne    803730 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80374a:	b8 00 00 00 00       	mov    $0x0,%eax
  80374f:	eb 0b                	jmp    80375c <ipc_find_env+0x3b>
			return envs[i].env_id;
  803751:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803754:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  803759:	8b 40 48             	mov    0x48(%eax),%eax
}
  80375c:	5d                   	pop    %ebp
  80375d:	c3                   	ret    

0080375e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80375e:	f3 0f 1e fb          	endbr32 
  803762:	55                   	push   %ebp
  803763:	89 e5                	mov    %esp,%ebp
  803765:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803768:	89 c2                	mov    %eax,%edx
  80376a:	c1 ea 16             	shr    $0x16,%edx
  80376d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  803774:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  803779:	f6 c1 01             	test   $0x1,%cl
  80377c:	74 1c                	je     80379a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80377e:	c1 e8 0c             	shr    $0xc,%eax
  803781:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803788:	a8 01                	test   $0x1,%al
  80378a:	74 0e                	je     80379a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80378c:	c1 e8 0c             	shr    $0xc,%eax
  80378f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  803796:	ef 
  803797:	0f b7 d2             	movzwl %dx,%edx
}
  80379a:	89 d0                	mov    %edx,%eax
  80379c:	5d                   	pop    %ebp
  80379d:	c3                   	ret    
  80379e:	66 90                	xchg   %ax,%ax

008037a0 <__udivdi3>:
  8037a0:	f3 0f 1e fb          	endbr32 
  8037a4:	55                   	push   %ebp
  8037a5:	57                   	push   %edi
  8037a6:	56                   	push   %esi
  8037a7:	53                   	push   %ebx
  8037a8:	83 ec 1c             	sub    $0x1c,%esp
  8037ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8037af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8037b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8037bb:	85 d2                	test   %edx,%edx
  8037bd:	75 19                	jne    8037d8 <__udivdi3+0x38>
  8037bf:	39 f3                	cmp    %esi,%ebx
  8037c1:	76 4d                	jbe    803810 <__udivdi3+0x70>
  8037c3:	31 ff                	xor    %edi,%edi
  8037c5:	89 e8                	mov    %ebp,%eax
  8037c7:	89 f2                	mov    %esi,%edx
  8037c9:	f7 f3                	div    %ebx
  8037cb:	89 fa                	mov    %edi,%edx
  8037cd:	83 c4 1c             	add    $0x1c,%esp
  8037d0:	5b                   	pop    %ebx
  8037d1:	5e                   	pop    %esi
  8037d2:	5f                   	pop    %edi
  8037d3:	5d                   	pop    %ebp
  8037d4:	c3                   	ret    
  8037d5:	8d 76 00             	lea    0x0(%esi),%esi
  8037d8:	39 f2                	cmp    %esi,%edx
  8037da:	76 14                	jbe    8037f0 <__udivdi3+0x50>
  8037dc:	31 ff                	xor    %edi,%edi
  8037de:	31 c0                	xor    %eax,%eax
  8037e0:	89 fa                	mov    %edi,%edx
  8037e2:	83 c4 1c             	add    $0x1c,%esp
  8037e5:	5b                   	pop    %ebx
  8037e6:	5e                   	pop    %esi
  8037e7:	5f                   	pop    %edi
  8037e8:	5d                   	pop    %ebp
  8037e9:	c3                   	ret    
  8037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8037f0:	0f bd fa             	bsr    %edx,%edi
  8037f3:	83 f7 1f             	xor    $0x1f,%edi
  8037f6:	75 48                	jne    803840 <__udivdi3+0xa0>
  8037f8:	39 f2                	cmp    %esi,%edx
  8037fa:	72 06                	jb     803802 <__udivdi3+0x62>
  8037fc:	31 c0                	xor    %eax,%eax
  8037fe:	39 eb                	cmp    %ebp,%ebx
  803800:	77 de                	ja     8037e0 <__udivdi3+0x40>
  803802:	b8 01 00 00 00       	mov    $0x1,%eax
  803807:	eb d7                	jmp    8037e0 <__udivdi3+0x40>
  803809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803810:	89 d9                	mov    %ebx,%ecx
  803812:	85 db                	test   %ebx,%ebx
  803814:	75 0b                	jne    803821 <__udivdi3+0x81>
  803816:	b8 01 00 00 00       	mov    $0x1,%eax
  80381b:	31 d2                	xor    %edx,%edx
  80381d:	f7 f3                	div    %ebx
  80381f:	89 c1                	mov    %eax,%ecx
  803821:	31 d2                	xor    %edx,%edx
  803823:	89 f0                	mov    %esi,%eax
  803825:	f7 f1                	div    %ecx
  803827:	89 c6                	mov    %eax,%esi
  803829:	89 e8                	mov    %ebp,%eax
  80382b:	89 f7                	mov    %esi,%edi
  80382d:	f7 f1                	div    %ecx
  80382f:	89 fa                	mov    %edi,%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803840:	89 f9                	mov    %edi,%ecx
  803842:	b8 20 00 00 00       	mov    $0x20,%eax
  803847:	29 f8                	sub    %edi,%eax
  803849:	d3 e2                	shl    %cl,%edx
  80384b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80384f:	89 c1                	mov    %eax,%ecx
  803851:	89 da                	mov    %ebx,%edx
  803853:	d3 ea                	shr    %cl,%edx
  803855:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803859:	09 d1                	or     %edx,%ecx
  80385b:	89 f2                	mov    %esi,%edx
  80385d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803861:	89 f9                	mov    %edi,%ecx
  803863:	d3 e3                	shl    %cl,%ebx
  803865:	89 c1                	mov    %eax,%ecx
  803867:	d3 ea                	shr    %cl,%edx
  803869:	89 f9                	mov    %edi,%ecx
  80386b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80386f:	89 eb                	mov    %ebp,%ebx
  803871:	d3 e6                	shl    %cl,%esi
  803873:	89 c1                	mov    %eax,%ecx
  803875:	d3 eb                	shr    %cl,%ebx
  803877:	09 de                	or     %ebx,%esi
  803879:	89 f0                	mov    %esi,%eax
  80387b:	f7 74 24 08          	divl   0x8(%esp)
  80387f:	89 d6                	mov    %edx,%esi
  803881:	89 c3                	mov    %eax,%ebx
  803883:	f7 64 24 0c          	mull   0xc(%esp)
  803887:	39 d6                	cmp    %edx,%esi
  803889:	72 15                	jb     8038a0 <__udivdi3+0x100>
  80388b:	89 f9                	mov    %edi,%ecx
  80388d:	d3 e5                	shl    %cl,%ebp
  80388f:	39 c5                	cmp    %eax,%ebp
  803891:	73 04                	jae    803897 <__udivdi3+0xf7>
  803893:	39 d6                	cmp    %edx,%esi
  803895:	74 09                	je     8038a0 <__udivdi3+0x100>
  803897:	89 d8                	mov    %ebx,%eax
  803899:	31 ff                	xor    %edi,%edi
  80389b:	e9 40 ff ff ff       	jmp    8037e0 <__udivdi3+0x40>
  8038a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038a3:	31 ff                	xor    %edi,%edi
  8038a5:	e9 36 ff ff ff       	jmp    8037e0 <__udivdi3+0x40>
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	66 90                	xchg   %ax,%ax
  8038ae:	66 90                	xchg   %ax,%ax

008038b0 <__umoddi3>:
  8038b0:	f3 0f 1e fb          	endbr32 
  8038b4:	55                   	push   %ebp
  8038b5:	57                   	push   %edi
  8038b6:	56                   	push   %esi
  8038b7:	53                   	push   %ebx
  8038b8:	83 ec 1c             	sub    $0x1c,%esp
  8038bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8038c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8038c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	75 19                	jne    8038e8 <__umoddi3+0x38>
  8038cf:	39 df                	cmp    %ebx,%edi
  8038d1:	76 5d                	jbe    803930 <__umoddi3+0x80>
  8038d3:	89 f0                	mov    %esi,%eax
  8038d5:	89 da                	mov    %ebx,%edx
  8038d7:	f7 f7                	div    %edi
  8038d9:	89 d0                	mov    %edx,%eax
  8038db:	31 d2                	xor    %edx,%edx
  8038dd:	83 c4 1c             	add    $0x1c,%esp
  8038e0:	5b                   	pop    %ebx
  8038e1:	5e                   	pop    %esi
  8038e2:	5f                   	pop    %edi
  8038e3:	5d                   	pop    %ebp
  8038e4:	c3                   	ret    
  8038e5:	8d 76 00             	lea    0x0(%esi),%esi
  8038e8:	89 f2                	mov    %esi,%edx
  8038ea:	39 d8                	cmp    %ebx,%eax
  8038ec:	76 12                	jbe    803900 <__umoddi3+0x50>
  8038ee:	89 f0                	mov    %esi,%eax
  8038f0:	89 da                	mov    %ebx,%edx
  8038f2:	83 c4 1c             	add    $0x1c,%esp
  8038f5:	5b                   	pop    %ebx
  8038f6:	5e                   	pop    %esi
  8038f7:	5f                   	pop    %edi
  8038f8:	5d                   	pop    %ebp
  8038f9:	c3                   	ret    
  8038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803900:	0f bd e8             	bsr    %eax,%ebp
  803903:	83 f5 1f             	xor    $0x1f,%ebp
  803906:	75 50                	jne    803958 <__umoddi3+0xa8>
  803908:	39 d8                	cmp    %ebx,%eax
  80390a:	0f 82 e0 00 00 00    	jb     8039f0 <__umoddi3+0x140>
  803910:	89 d9                	mov    %ebx,%ecx
  803912:	39 f7                	cmp    %esi,%edi
  803914:	0f 86 d6 00 00 00    	jbe    8039f0 <__umoddi3+0x140>
  80391a:	89 d0                	mov    %edx,%eax
  80391c:	89 ca                	mov    %ecx,%edx
  80391e:	83 c4 1c             	add    $0x1c,%esp
  803921:	5b                   	pop    %ebx
  803922:	5e                   	pop    %esi
  803923:	5f                   	pop    %edi
  803924:	5d                   	pop    %ebp
  803925:	c3                   	ret    
  803926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80392d:	8d 76 00             	lea    0x0(%esi),%esi
  803930:	89 fd                	mov    %edi,%ebp
  803932:	85 ff                	test   %edi,%edi
  803934:	75 0b                	jne    803941 <__umoddi3+0x91>
  803936:	b8 01 00 00 00       	mov    $0x1,%eax
  80393b:	31 d2                	xor    %edx,%edx
  80393d:	f7 f7                	div    %edi
  80393f:	89 c5                	mov    %eax,%ebp
  803941:	89 d8                	mov    %ebx,%eax
  803943:	31 d2                	xor    %edx,%edx
  803945:	f7 f5                	div    %ebp
  803947:	89 f0                	mov    %esi,%eax
  803949:	f7 f5                	div    %ebp
  80394b:	89 d0                	mov    %edx,%eax
  80394d:	31 d2                	xor    %edx,%edx
  80394f:	eb 8c                	jmp    8038dd <__umoddi3+0x2d>
  803951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803958:	89 e9                	mov    %ebp,%ecx
  80395a:	ba 20 00 00 00       	mov    $0x20,%edx
  80395f:	29 ea                	sub    %ebp,%edx
  803961:	d3 e0                	shl    %cl,%eax
  803963:	89 44 24 08          	mov    %eax,0x8(%esp)
  803967:	89 d1                	mov    %edx,%ecx
  803969:	89 f8                	mov    %edi,%eax
  80396b:	d3 e8                	shr    %cl,%eax
  80396d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803971:	89 54 24 04          	mov    %edx,0x4(%esp)
  803975:	8b 54 24 04          	mov    0x4(%esp),%edx
  803979:	09 c1                	or     %eax,%ecx
  80397b:	89 d8                	mov    %ebx,%eax
  80397d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803981:	89 e9                	mov    %ebp,%ecx
  803983:	d3 e7                	shl    %cl,%edi
  803985:	89 d1                	mov    %edx,%ecx
  803987:	d3 e8                	shr    %cl,%eax
  803989:	89 e9                	mov    %ebp,%ecx
  80398b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80398f:	d3 e3                	shl    %cl,%ebx
  803991:	89 c7                	mov    %eax,%edi
  803993:	89 d1                	mov    %edx,%ecx
  803995:	89 f0                	mov    %esi,%eax
  803997:	d3 e8                	shr    %cl,%eax
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	89 fa                	mov    %edi,%edx
  80399d:	d3 e6                	shl    %cl,%esi
  80399f:	09 d8                	or     %ebx,%eax
  8039a1:	f7 74 24 08          	divl   0x8(%esp)
  8039a5:	89 d1                	mov    %edx,%ecx
  8039a7:	89 f3                	mov    %esi,%ebx
  8039a9:	f7 64 24 0c          	mull   0xc(%esp)
  8039ad:	89 c6                	mov    %eax,%esi
  8039af:	89 d7                	mov    %edx,%edi
  8039b1:	39 d1                	cmp    %edx,%ecx
  8039b3:	72 06                	jb     8039bb <__umoddi3+0x10b>
  8039b5:	75 10                	jne    8039c7 <__umoddi3+0x117>
  8039b7:	39 c3                	cmp    %eax,%ebx
  8039b9:	73 0c                	jae    8039c7 <__umoddi3+0x117>
  8039bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8039bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8039c3:	89 d7                	mov    %edx,%edi
  8039c5:	89 c6                	mov    %eax,%esi
  8039c7:	89 ca                	mov    %ecx,%edx
  8039c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8039ce:	29 f3                	sub    %esi,%ebx
  8039d0:	19 fa                	sbb    %edi,%edx
  8039d2:	89 d0                	mov    %edx,%eax
  8039d4:	d3 e0                	shl    %cl,%eax
  8039d6:	89 e9                	mov    %ebp,%ecx
  8039d8:	d3 eb                	shr    %cl,%ebx
  8039da:	d3 ea                	shr    %cl,%edx
  8039dc:	09 d8                	or     %ebx,%eax
  8039de:	83 c4 1c             	add    $0x1c,%esp
  8039e1:	5b                   	pop    %ebx
  8039e2:	5e                   	pop    %esi
  8039e3:	5f                   	pop    %edi
  8039e4:	5d                   	pop    %ebp
  8039e5:	c3                   	ret    
  8039e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8039ed:	8d 76 00             	lea    0x0(%esi),%esi
  8039f0:	29 fe                	sub    %edi,%esi
  8039f2:	19 c3                	sbb    %eax,%ebx
  8039f4:	89 f2                	mov    %esi,%edx
  8039f6:	89 d9                	mov    %ebx,%ecx
  8039f8:	e9 1d ff ff ff       	jmp    80391a <__umoddi3+0x6a>
