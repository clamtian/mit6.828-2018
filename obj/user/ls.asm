
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 a9 02 00 00       	call   8002da <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  800042:	83 3d d0 41 80 00 00 	cmpl   $0x0,0x8041d0
  800049:	74 20                	je     80006b <ls1+0x38>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  80004b:	89 f0                	mov    %esi,%eax
  80004d:	3c 01                	cmp    $0x1,%al
  80004f:	19 c0                	sbb    %eax,%eax
  800051:	83 e0 c9             	and    $0xffffffc9,%eax
  800054:	83 c0 64             	add    $0x64,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	ff 75 10             	pushl  0x10(%ebp)
  80005e:	68 e2 28 80 00       	push   $0x8028e2
  800063:	e8 f9 1a 00 00       	call   801b61 <printf>
  800068:	83 c4 10             	add    $0x10,%esp
	if(prefix) {
  80006b:	85 db                	test   %ebx,%ebx
  80006d:	74 1c                	je     80008b <ls1+0x58>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80006f:	b8 48 29 80 00       	mov    $0x802948,%eax
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800074:	80 3b 00             	cmpb   $0x0,(%ebx)
  800077:	75 4b                	jne    8000c4 <ls1+0x91>
		printf("%s%s", prefix, sep);
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 eb 28 80 00       	push   $0x8028eb
  800083:	e8 d9 1a 00 00       	call   801b61 <printf>
  800088:	83 c4 10             	add    $0x10,%esp
	}
	printf("%s", name);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	ff 75 14             	pushl  0x14(%ebp)
  800091:	68 75 2d 80 00       	push   $0x802d75
  800096:	e8 c6 1a 00 00       	call   801b61 <printf>
	if(flag['F'] && isdir)
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	83 3d 38 41 80 00 00 	cmpl   $0x0,0x804138
  8000a5:	74 06                	je     8000ad <ls1+0x7a>
  8000a7:	89 f0                	mov    %esi,%eax
  8000a9:	84 c0                	test   %al,%al
  8000ab:	75 37                	jne    8000e4 <ls1+0xb1>
		printf("/");
	printf("\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 47 29 80 00       	push   $0x802947
  8000b5:	e8 a7 1a 00 00       	call   801b61 <printf>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	53                   	push   %ebx
  8000c8:	e8 23 09 00 00       	call   8009f0 <strlen>
  8000cd:	83 c4 10             	add    $0x10,%esp
			sep = "";
  8000d0:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000d5:	b8 e0 28 80 00       	mov    $0x8028e0,%eax
  8000da:	ba 48 29 80 00       	mov    $0x802948,%edx
  8000df:	0f 44 c2             	cmove  %edx,%eax
  8000e2:	eb 95                	jmp    800079 <ls1+0x46>
		printf("/");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 e0 28 80 00       	push   $0x8028e0
  8000ec:	e8 70 1a 00 00       	call   801b61 <printf>
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	eb b7                	jmp    8000ad <ls1+0x7a>

008000f6 <lsdir>:
{
  8000f6:	f3 0f 1e fb          	endbr32 
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	57                   	push   %edi
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	81 ec 14 01 00 00    	sub    $0x114,%esp
  800106:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, O_RDONLY)) < 0)
  800109:	6a 00                	push   $0x0
  80010b:	57                   	push   %edi
  80010c:	e8 99 18 00 00       	call   8019aa <open>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	83 c4 10             	add    $0x10,%esp
  800116:	85 c0                	test   %eax,%eax
  800118:	78 4a                	js     800164 <lsdir+0x6e>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	68 00 01 00 00       	push   $0x100
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 71 14 00 00       	call   8015a0 <readn>
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	3d 00 01 00 00       	cmp    $0x100,%eax
  800137:	75 41                	jne    80017a <lsdir+0x84>
		if (f.f_name[0])
  800139:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  800140:	74 de                	je     800120 <lsdir+0x2a>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800142:	56                   	push   %esi
  800143:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800149:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800150:	0f 94 c0             	sete   %al
  800153:	0f b6 c0             	movzbl %al,%eax
  800156:	50                   	push   %eax
  800157:	ff 75 0c             	pushl  0xc(%ebp)
  80015a:	e8 d4 fe ff ff       	call   800033 <ls1>
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb bc                	jmp    800120 <lsdir+0x2a>
		panic("open %s: %e", path, fd);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	50                   	push   %eax
  800168:	57                   	push   %edi
  800169:	68 f0 28 80 00       	push   $0x8028f0
  80016e:	6a 1d                	push   $0x1d
  800170:	68 fc 28 80 00       	push   $0x8028fc
  800175:	e8 c8 01 00 00       	call   800342 <_panic>
	if (n > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7f 0a                	jg     800188 <lsdir+0x92>
	if (n < 0)
  80017e:	78 1a                	js     80019a <lsdir+0xa4>
}
  800180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    
		panic("short read in directory %s", path);
  800188:	57                   	push   %edi
  800189:	68 06 29 80 00       	push   $0x802906
  80018e:	6a 22                	push   $0x22
  800190:	68 fc 28 80 00       	push   $0x8028fc
  800195:	e8 a8 01 00 00       	call   800342 <_panic>
		panic("error reading directory %s: %e", path, n);
  80019a:	83 ec 0c             	sub    $0xc,%esp
  80019d:	50                   	push   %eax
  80019e:	57                   	push   %edi
  80019f:	68 4c 29 80 00       	push   $0x80294c
  8001a4:	6a 24                	push   $0x24
  8001a6:	68 fc 28 80 00       	push   $0x8028fc
  8001ab:	e8 92 01 00 00       	call   800342 <_panic>

008001b0 <ls>:
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((r = stat(path, &st)) < 0)
  8001c1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  8001c7:	50                   	push   %eax
  8001c8:	53                   	push   %ebx
  8001c9:	e8 cb 15 00 00       	call   801799 <stat>
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	85 c0                	test   %eax,%eax
  8001d3:	78 2c                	js     800201 <ls+0x51>
	if (st.st_isdir && !flag['d'])
  8001d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001d8:	85 c0                	test   %eax,%eax
  8001da:	74 09                	je     8001e5 <ls+0x35>
  8001dc:	83 3d b0 41 80 00 00 	cmpl   $0x0,0x8041b0
  8001e3:	74 32                	je     800217 <ls+0x67>
		ls1(0, st.st_isdir, st.st_size, path);
  8001e5:	53                   	push   %ebx
  8001e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	0f 95 c0             	setne  %al
  8001ee:	0f b6 c0             	movzbl %al,%eax
  8001f1:	50                   	push   %eax
  8001f2:	6a 00                	push   $0x0
  8001f4:	e8 3a fe ff ff       	call   800033 <ls1>
  8001f9:	83 c4 10             	add    $0x10,%esp
}
  8001fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    
		panic("stat %s: %e", path, r);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	50                   	push   %eax
  800205:	53                   	push   %ebx
  800206:	68 21 29 80 00       	push   $0x802921
  80020b:	6a 0f                	push   $0xf
  80020d:	68 fc 28 80 00       	push   $0x8028fc
  800212:	e8 2b 01 00 00       	call   800342 <_panic>
		lsdir(path, prefix);
  800217:	83 ec 08             	sub    $0x8,%esp
  80021a:	ff 75 0c             	pushl  0xc(%ebp)
  80021d:	53                   	push   %ebx
  80021e:	e8 d3 fe ff ff       	call   8000f6 <lsdir>
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb d4                	jmp    8001fc <ls+0x4c>

00800228 <usage>:

void
usage(void)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 14             	sub    $0x14,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800232:	68 2d 29 80 00       	push   $0x80292d
  800237:	e8 25 19 00 00       	call   801b61 <printf>
	exit();
  80023c:	e8 e3 00 00 00       	call   800324 <exit>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <umain>:

void
umain(int argc, char **argv)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 14             	sub    $0x14,%esp
  800252:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800255:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800258:	50                   	push   %eax
  800259:	56                   	push   %esi
  80025a:	8d 45 08             	lea    0x8(%ebp),%eax
  80025d:	50                   	push   %eax
  80025e:	e8 46 0e 00 00       	call   8010a9 <argstart>
	while ((i = argnext(&args)) >= 0)
  800263:	83 c4 10             	add    $0x10,%esp
  800266:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  800269:	eb 08                	jmp    800273 <umain+0x2d>
		switch (i) {
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  80026b:	83 04 85 20 40 80 00 	addl   $0x1,0x804020(,%eax,4)
  800272:	01 
	while ((i = argnext(&args)) >= 0)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	53                   	push   %ebx
  800277:	e8 61 0e 00 00       	call   8010dd <argnext>
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	85 c0                	test   %eax,%eax
  800281:	78 16                	js     800299 <umain+0x53>
		switch (i) {
  800283:	89 c2                	mov    %eax,%edx
  800285:	83 e2 f7             	and    $0xfffffff7,%edx
  800288:	83 fa 64             	cmp    $0x64,%edx
  80028b:	74 de                	je     80026b <umain+0x25>
  80028d:	83 f8 46             	cmp    $0x46,%eax
  800290:	74 d9                	je     80026b <umain+0x25>
			break;
		default:
			usage();
  800292:	e8 91 ff ff ff       	call   800228 <usage>
  800297:	eb da                	jmp    800273 <umain+0x2d>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  800299:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  80029e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002a2:	75 2a                	jne    8002ce <umain+0x88>
		ls("/", "");
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	68 48 29 80 00       	push   $0x802948
  8002ac:	68 e0 28 80 00       	push   $0x8028e0
  8002b1:	e8 fa fe ff ff       	call   8001b0 <ls>
  8002b6:	83 c4 10             	add    $0x10,%esp
  8002b9:	eb 18                	jmp    8002d3 <umain+0x8d>
			ls(argv[i], argv[i]);
  8002bb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	50                   	push   %eax
  8002c3:	e8 e8 fe ff ff       	call   8001b0 <ls>
		for (i = 1; i < argc; i++)
  8002c8:	83 c3 01             	add    $0x1,%ebx
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  8002d1:	7f e8                	jg     8002bb <umain+0x75>
	}
}
  8002d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8002d6:	5b                   	pop    %ebx
  8002d7:	5e                   	pop    %esi
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002da:	f3 0f 1e fb          	endbr32 
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002e6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002e9:	e8 41 0b 00 00       	call   800e2f <sys_getenvid>
  8002ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002fb:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	85 db                	test   %ebx,%ebx
  800302:	7e 07                	jle    80030b <libmain+0x31>
		binaryname = argv[0];
  800304:	8b 06                	mov    (%esi),%eax
  800306:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	e8 31 ff ff ff       	call   800246 <umain>

	// exit gracefully
	exit();
  800315:	e8 0a 00 00 00       	call   800324 <exit>
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800320:	5b                   	pop    %ebx
  800321:	5e                   	pop    %esi
  800322:	5d                   	pop    %ebp
  800323:	c3                   	ret    

00800324 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80032e:	e8 c9 10 00 00       	call   8013fc <close_all>
	sys_env_destroy(0);
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	6a 00                	push   $0x0
  800338:	e8 ad 0a 00 00       	call   800dea <sys_env_destroy>
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80034b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80034e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800354:	e8 d6 0a 00 00       	call   800e2f <sys_getenvid>
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	56                   	push   %esi
  800363:	50                   	push   %eax
  800364:	68 78 29 80 00       	push   $0x802978
  800369:	e8 bb 00 00 00       	call   800429 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80036e:	83 c4 18             	add    $0x18,%esp
  800371:	53                   	push   %ebx
  800372:	ff 75 10             	pushl  0x10(%ebp)
  800375:	e8 5a 00 00 00       	call   8003d4 <vcprintf>
	cprintf("\n");
  80037a:	c7 04 24 47 29 80 00 	movl   $0x802947,(%esp)
  800381:	e8 a3 00 00 00       	call   800429 <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800389:	cc                   	int3   
  80038a:	eb fd                	jmp    800389 <_panic+0x47>

0080038c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80038c:	f3 0f 1e fb          	endbr32 
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	53                   	push   %ebx
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80039a:	8b 13                	mov    (%ebx),%edx
  80039c:	8d 42 01             	lea    0x1(%edx),%eax
  80039f:	89 03                	mov    %eax,(%ebx)
  8003a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003a4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ad:	74 09                	je     8003b8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8003af:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b6:	c9                   	leave  
  8003b7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 ff 00 00 00       	push   $0xff
  8003c0:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c3:	50                   	push   %eax
  8003c4:	e8 dc 09 00 00       	call   800da5 <sys_cputs>
		b->idx = 0;
  8003c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8003cf:	83 c4 10             	add    $0x10,%esp
  8003d2:	eb db                	jmp    8003af <putch+0x23>

008003d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003d4:	f3 0f 1e fb          	endbr32 
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e8:	00 00 00 
	b.cnt = 0;
  8003eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800401:	50                   	push   %eax
  800402:	68 8c 03 80 00       	push   $0x80038c
  800407:	e8 20 01 00 00       	call   80052c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040c:	83 c4 08             	add    $0x8,%esp
  80040f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800415:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041b:	50                   	push   %eax
  80041c:	e8 84 09 00 00       	call   800da5 <sys_cputs>

	return b.cnt;
}
  800421:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800427:	c9                   	leave  
  800428:	c3                   	ret    

00800429 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800429:	f3 0f 1e fb          	endbr32 
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800433:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800436:	50                   	push   %eax
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 95 ff ff ff       	call   8003d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	57                   	push   %edi
  800445:	56                   	push   %esi
  800446:	53                   	push   %ebx
  800447:	83 ec 1c             	sub    $0x1c,%esp
  80044a:	89 c7                	mov    %eax,%edi
  80044c:	89 d6                	mov    %edx,%esi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 55 0c             	mov    0xc(%ebp),%edx
  800454:	89 d1                	mov    %edx,%ecx
  800456:	89 c2                	mov    %eax,%edx
  800458:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80045e:	8b 45 10             	mov    0x10(%ebp),%eax
  800461:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800473:	72 3e                	jb     8004b3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	ff 75 18             	pushl  0x18(%ebp)
  80047b:	83 eb 01             	sub    $0x1,%ebx
  80047e:	53                   	push   %ebx
  80047f:	50                   	push   %eax
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	ff 75 e4             	pushl  -0x1c(%ebp)
  800486:	ff 75 e0             	pushl  -0x20(%ebp)
  800489:	ff 75 dc             	pushl  -0x24(%ebp)
  80048c:	ff 75 d8             	pushl  -0x28(%ebp)
  80048f:	e8 ec 21 00 00       	call   802680 <__udivdi3>
  800494:	83 c4 18             	add    $0x18,%esp
  800497:	52                   	push   %edx
  800498:	50                   	push   %eax
  800499:	89 f2                	mov    %esi,%edx
  80049b:	89 f8                	mov    %edi,%eax
  80049d:	e8 9f ff ff ff       	call   800441 <printnum>
  8004a2:	83 c4 20             	add    $0x20,%esp
  8004a5:	eb 13                	jmp    8004ba <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a7:	83 ec 08             	sub    $0x8,%esp
  8004aa:	56                   	push   %esi
  8004ab:	ff 75 18             	pushl  0x18(%ebp)
  8004ae:	ff d7                	call   *%edi
  8004b0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8004b3:	83 eb 01             	sub    $0x1,%ebx
  8004b6:	85 db                	test   %ebx,%ebx
  8004b8:	7f ed                	jg     8004a7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ba:	83 ec 08             	sub    $0x8,%esp
  8004bd:	56                   	push   %esi
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8004c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8004ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cd:	e8 be 22 00 00       	call   802790 <__umoddi3>
  8004d2:	83 c4 14             	add    $0x14,%esp
  8004d5:	0f be 80 9b 29 80 00 	movsbl 0x80299b(%eax),%eax
  8004dc:	50                   	push   %eax
  8004dd:	ff d7                	call   *%edi
}
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004e5:	5b                   	pop    %ebx
  8004e6:	5e                   	pop    %esi
  8004e7:	5f                   	pop    %edi
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    

008004ea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004ea:	f3 0f 1e fb          	endbr32 
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004f8:	8b 10                	mov    (%eax),%edx
  8004fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8004fd:	73 0a                	jae    800509 <sprintputch+0x1f>
		*b->buf++ = ch;
  8004ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800502:	89 08                	mov    %ecx,(%eax)
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	88 02                	mov    %al,(%edx)
}
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <printfmt>:
{
  80050b:	f3 0f 1e fb          	endbr32 
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800515:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800518:	50                   	push   %eax
  800519:	ff 75 10             	pushl  0x10(%ebp)
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	e8 05 00 00 00       	call   80052c <vprintfmt>
}
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <vprintfmt>:
{
  80052c:	f3 0f 1e fb          	endbr32 
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 3c             	sub    $0x3c,%esp
  800539:	8b 75 08             	mov    0x8(%ebp),%esi
  80053c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800542:	e9 8e 03 00 00       	jmp    8008d5 <vprintfmt+0x3a9>
		padc = ' ';
  800547:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80054b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800552:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800559:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800565:	8d 47 01             	lea    0x1(%edi),%eax
  800568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80056b:	0f b6 17             	movzbl (%edi),%edx
  80056e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800571:	3c 55                	cmp    $0x55,%al
  800573:	0f 87 df 03 00 00    	ja     800958 <vprintfmt+0x42c>
  800579:	0f b6 c0             	movzbl %al,%eax
  80057c:	3e ff 24 85 e0 2a 80 	notrack jmp *0x802ae0(,%eax,4)
  800583:	00 
  800584:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800587:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80058b:	eb d8                	jmp    800565 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80058d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800590:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800594:	eb cf                	jmp    800565 <vprintfmt+0x39>
  800596:	0f b6 d2             	movzbl %dl,%edx
  800599:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80059c:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8005a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005a7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8005ab:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8005ae:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8005b1:	83 f9 09             	cmp    $0x9,%ecx
  8005b4:	77 55                	ja     80060b <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8005b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8005b9:	eb e9                	jmp    8005a4 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d3:	79 90                	jns    800565 <vprintfmt+0x39>
				width = precision, precision = -1;
  8005d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005db:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8005e2:	eb 81                	jmp    800565 <vprintfmt+0x39>
  8005e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e7:	85 c0                	test   %eax,%eax
  8005e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ee:	0f 49 d0             	cmovns %eax,%edx
  8005f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8005f7:	e9 69 ff ff ff       	jmp    800565 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8005ff:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800606:	e9 5a ff ff ff       	jmp    800565 <vprintfmt+0x39>
  80060b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80060e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800611:	eb bc                	jmp    8005cf <vprintfmt+0xa3>
			lflag++;
  800613:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800619:	e9 47 ff ff ff       	jmp    800565 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8d 78 04             	lea    0x4(%eax),%edi
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	ff 30                	pushl  (%eax)
  80062a:	ff d6                	call   *%esi
			break;
  80062c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80062f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800632:	e9 9b 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 78 04             	lea    0x4(%eax),%edi
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	31 d0                	xor    %edx,%eax
  800642:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800644:	83 f8 0f             	cmp    $0xf,%eax
  800647:	7f 23                	jg     80066c <vprintfmt+0x140>
  800649:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  800650:	85 d2                	test   %edx,%edx
  800652:	74 18                	je     80066c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800654:	52                   	push   %edx
  800655:	68 75 2d 80 00       	push   $0x802d75
  80065a:	53                   	push   %ebx
  80065b:	56                   	push   %esi
  80065c:	e8 aa fe ff ff       	call   80050b <printfmt>
  800661:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800664:	89 7d 14             	mov    %edi,0x14(%ebp)
  800667:	e9 66 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80066c:	50                   	push   %eax
  80066d:	68 b3 29 80 00       	push   $0x8029b3
  800672:	53                   	push   %ebx
  800673:	56                   	push   %esi
  800674:	e8 92 fe ff ff       	call   80050b <printfmt>
  800679:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80067c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80067f:	e9 4e 02 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	83 c0 04             	add    $0x4,%eax
  80068a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800692:	85 d2                	test   %edx,%edx
  800694:	b8 ac 29 80 00       	mov    $0x8029ac,%eax
  800699:	0f 45 c2             	cmovne %edx,%eax
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80069f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a3:	7e 06                	jle    8006ab <vprintfmt+0x17f>
  8006a5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8006a9:	75 0d                	jne    8006b8 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006ae:	89 c7                	mov    %eax,%edi
  8006b0:	03 45 e0             	add    -0x20(%ebp),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	eb 55                	jmp    80070d <vprintfmt+0x1e1>
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006be:	ff 75 cc             	pushl  -0x34(%ebp)
  8006c1:	e8 46 03 00 00       	call   800a0c <strnlen>
  8006c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c9:	29 c2                	sub    %eax,%edx
  8006cb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8006d3:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8006d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8006da:	85 ff                	test   %edi,%edi
  8006dc:	7e 11                	jle    8006ef <vprintfmt+0x1c3>
					putch(padc, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e7:	83 ef 01             	sub    $0x1,%edi
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	eb eb                	jmp    8006da <vprintfmt+0x1ae>
  8006ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f9:	0f 49 c2             	cmovns %edx,%eax
  8006fc:	29 c2                	sub    %eax,%edx
  8006fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800701:	eb a8                	jmp    8006ab <vprintfmt+0x17f>
					putch(ch, putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	52                   	push   %edx
  800708:	ff d6                	call   *%esi
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800710:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800712:	83 c7 01             	add    $0x1,%edi
  800715:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800719:	0f be d0             	movsbl %al,%edx
  80071c:	85 d2                	test   %edx,%edx
  80071e:	74 4b                	je     80076b <vprintfmt+0x23f>
  800720:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800724:	78 06                	js     80072c <vprintfmt+0x200>
  800726:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80072a:	78 1e                	js     80074a <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80072c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800730:	74 d1                	je     800703 <vprintfmt+0x1d7>
  800732:	0f be c0             	movsbl %al,%eax
  800735:	83 e8 20             	sub    $0x20,%eax
  800738:	83 f8 5e             	cmp    $0x5e,%eax
  80073b:	76 c6                	jbe    800703 <vprintfmt+0x1d7>
					putch('?', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 3f                	push   $0x3f
  800743:	ff d6                	call   *%esi
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	eb c3                	jmp    80070d <vprintfmt+0x1e1>
  80074a:	89 cf                	mov    %ecx,%edi
  80074c:	eb 0e                	jmp    80075c <vprintfmt+0x230>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 20                	push   $0x20
  800754:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800756:	83 ef 01             	sub    $0x1,%edi
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	85 ff                	test   %edi,%edi
  80075e:	7f ee                	jg     80074e <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800760:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
  800766:	e9 67 01 00 00       	jmp    8008d2 <vprintfmt+0x3a6>
  80076b:	89 cf                	mov    %ecx,%edi
  80076d:	eb ed                	jmp    80075c <vprintfmt+0x230>
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7f 1b                	jg     80078f <vprintfmt+0x263>
	else if (lflag)
  800774:	85 c9                	test   %ecx,%ecx
  800776:	74 63                	je     8007db <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800778:	8b 45 14             	mov    0x14(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	99                   	cltd   
  800781:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
  80078d:	eb 17                	jmp    8007a6 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 50 04             	mov    0x4(%eax),%edx
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8d 40 08             	lea    0x8(%eax),%eax
  8007a3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8007a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b1:	85 c9                	test   %ecx,%ecx
  8007b3:	0f 89 ff 00 00 00    	jns    8008b8 <vprintfmt+0x38c>
				putch('-', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	53                   	push   %ebx
  8007bd:	6a 2d                	push   $0x2d
  8007bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8007c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007c7:	f7 da                	neg    %edx
  8007c9:	83 d1 00             	adc    $0x0,%ecx
  8007cc:	f7 d9                	neg    %ecx
  8007ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8007d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d6:	e9 dd 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e3:	99                   	cltd   
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f0:	eb b4                	jmp    8007a6 <vprintfmt+0x27a>
	if (lflag >= 2)
  8007f2:	83 f9 01             	cmp    $0x1,%ecx
  8007f5:	7f 1e                	jg     800815 <vprintfmt+0x2e9>
	else if (lflag)
  8007f7:	85 c9                	test   %ecx,%ecx
  8007f9:	74 32                	je     80082d <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8b 10                	mov    (%eax),%edx
  800800:	b9 00 00 00 00       	mov    $0x0,%ecx
  800805:	8d 40 04             	lea    0x4(%eax),%eax
  800808:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80080b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800810:	e9 a3 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	8b 48 04             	mov    0x4(%eax),%ecx
  80081d:	8d 40 08             	lea    0x8(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800823:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800828:	e9 8b 00 00 00       	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 10                	mov    (%eax),%edx
  800832:	b9 00 00 00 00       	mov    $0x0,%ecx
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80083d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800842:	eb 74                	jmp    8008b8 <vprintfmt+0x38c>
	if (lflag >= 2)
  800844:	83 f9 01             	cmp    $0x1,%ecx
  800847:	7f 1b                	jg     800864 <vprintfmt+0x338>
	else if (lflag)
  800849:	85 c9                	test   %ecx,%ecx
  80084b:	74 2c                	je     800879 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8b 10                	mov    (%eax),%edx
  800852:	b9 00 00 00 00       	mov    $0x0,%ecx
  800857:	8d 40 04             	lea    0x4(%eax),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80085d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800862:	eb 54                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8b 10                	mov    (%eax),%edx
  800869:	8b 48 04             	mov    0x4(%eax),%ecx
  80086c:	8d 40 08             	lea    0x8(%eax),%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800872:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800877:	eb 3f                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8b 10                	mov    (%eax),%edx
  80087e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800883:	8d 40 04             	lea    0x4(%eax),%eax
  800886:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800889:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80088e:	eb 28                	jmp    8008b8 <vprintfmt+0x38c>
			putch('0', putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	53                   	push   %ebx
  800894:	6a 30                	push   $0x30
  800896:	ff d6                	call   *%esi
			putch('x', putdat);
  800898:	83 c4 08             	add    $0x8,%esp
  80089b:	53                   	push   %ebx
  80089c:	6a 78                	push   $0x78
  80089e:	ff d6                	call   *%esi
			num = (unsigned long long)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	8b 10                	mov    (%eax),%edx
  8008a5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8008aa:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	83 ec 0c             	sub    $0xc,%esp
  8008bb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8008bf:	57                   	push   %edi
  8008c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	51                   	push   %ecx
  8008c5:	52                   	push   %edx
  8008c6:	89 da                	mov    %ebx,%edx
  8008c8:	89 f0                	mov    %esi,%eax
  8008ca:	e8 72 fb ff ff       	call   800441 <printnum>
			break;
  8008cf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8008d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d5:	83 c7 01             	add    $0x1,%edi
  8008d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008dc:	83 f8 25             	cmp    $0x25,%eax
  8008df:	0f 84 62 fc ff ff    	je     800547 <vprintfmt+0x1b>
			if (ch == '\0')
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	0f 84 8b 00 00 00    	je     800978 <vprintfmt+0x44c>
			putch(ch, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	50                   	push   %eax
  8008f2:	ff d6                	call   *%esi
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb dc                	jmp    8008d5 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8008f9:	83 f9 01             	cmp    $0x1,%ecx
  8008fc:	7f 1b                	jg     800919 <vprintfmt+0x3ed>
	else if (lflag)
  8008fe:	85 c9                	test   %ecx,%ecx
  800900:	74 2c                	je     80092e <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8b 10                	mov    (%eax),%edx
  800907:	b9 00 00 00 00       	mov    $0x0,%ecx
  80090c:	8d 40 04             	lea    0x4(%eax),%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800912:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800917:	eb 9f                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 10                	mov    (%eax),%edx
  80091e:	8b 48 04             	mov    0x4(%eax),%ecx
  800921:	8d 40 08             	lea    0x8(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800927:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80092c:	eb 8a                	jmp    8008b8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80092e:	8b 45 14             	mov    0x14(%ebp),%eax
  800931:	8b 10                	mov    (%eax),%edx
  800933:	b9 00 00 00 00       	mov    $0x0,%ecx
  800938:	8d 40 04             	lea    0x4(%eax),%eax
  80093b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80093e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800943:	e9 70 ff ff ff       	jmp    8008b8 <vprintfmt+0x38c>
			putch(ch, putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	53                   	push   %ebx
  80094c:	6a 25                	push   $0x25
  80094e:	ff d6                	call   *%esi
			break;
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	e9 7a ff ff ff       	jmp    8008d2 <vprintfmt+0x3a6>
			putch('%', putdat);
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	53                   	push   %ebx
  80095c:	6a 25                	push   $0x25
  80095e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	89 f8                	mov    %edi,%eax
  800965:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800969:	74 05                	je     800970 <vprintfmt+0x444>
  80096b:	83 e8 01             	sub    $0x1,%eax
  80096e:	eb f5                	jmp    800965 <vprintfmt+0x439>
  800970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800973:	e9 5a ff ff ff       	jmp    8008d2 <vprintfmt+0x3a6>
}
  800978:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5f                   	pop    %edi
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	83 ec 18             	sub    $0x18,%esp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800990:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800993:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800997:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80099a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a1:	85 c0                	test   %eax,%eax
  8009a3:	74 26                	je     8009cb <vsnprintf+0x4b>
  8009a5:	85 d2                	test   %edx,%edx
  8009a7:	7e 22                	jle    8009cb <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a9:	ff 75 14             	pushl  0x14(%ebp)
  8009ac:	ff 75 10             	pushl  0x10(%ebp)
  8009af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b2:	50                   	push   %eax
  8009b3:	68 ea 04 80 00       	push   $0x8004ea
  8009b8:	e8 6f fb ff ff       	call   80052c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    
		return -E_INVAL;
  8009cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d0:	eb f7                	jmp    8009c9 <vsnprintf+0x49>

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	f3 0f 1e fb          	endbr32 
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009df:	50                   	push   %eax
  8009e0:	ff 75 10             	pushl  0x10(%ebp)
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	ff 75 08             	pushl  0x8(%ebp)
  8009e9:	e8 92 ff ff ff       	call   800980 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f0:	f3 0f 1e fb          	endbr32 
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a03:	74 05                	je     800a0a <strlen+0x1a>
		n++;
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	eb f5                	jmp    8009ff <strlen+0xf>
	return n;
}
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0c:	f3 0f 1e fb          	endbr32 
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a19:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1e:	39 d0                	cmp    %edx,%eax
  800a20:	74 0d                	je     800a2f <strnlen+0x23>
  800a22:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a26:	74 05                	je     800a2d <strnlen+0x21>
		n++;
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f1                	jmp    800a1e <strnlen+0x12>
  800a2d:	89 c2                	mov    %eax,%edx
	return n;
}
  800a2f:	89 d0                	mov    %edx,%eax
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a41:	b8 00 00 00 00       	mov    $0x0,%eax
  800a46:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800a4a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800a4d:	83 c0 01             	add    $0x1,%eax
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800a54:	89 c8                	mov    %ecx,%eax
  800a56:	5b                   	pop    %ebx
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a59:	f3 0f 1e fb          	endbr32 
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	83 ec 10             	sub    $0x10,%esp
  800a64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a67:	53                   	push   %ebx
  800a68:	e8 83 ff ff ff       	call   8009f0 <strlen>
  800a6d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	01 d8                	add    %ebx,%eax
  800a75:	50                   	push   %eax
  800a76:	e8 b8 ff ff ff       	call   800a33 <strcpy>
	return dst;
}
  800a7b:	89 d8                	mov    %ebx,%eax
  800a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a82:	f3 0f 1e fb          	endbr32 
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	56                   	push   %esi
  800a8a:	53                   	push   %ebx
  800a8b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a91:	89 f3                	mov    %esi,%ebx
  800a93:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a96:	89 f0                	mov    %esi,%eax
  800a98:	39 d8                	cmp    %ebx,%eax
  800a9a:	74 11                	je     800aad <strncpy+0x2b>
		*dst++ = *src;
  800a9c:	83 c0 01             	add    $0x1,%eax
  800a9f:	0f b6 0a             	movzbl (%edx),%ecx
  800aa2:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa5:	80 f9 01             	cmp    $0x1,%cl
  800aa8:	83 da ff             	sbb    $0xffffffff,%edx
  800aab:	eb eb                	jmp    800a98 <strncpy+0x16>
	}
	return ret;
}
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	8b 75 08             	mov    0x8(%ebp),%esi
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac7:	85 d2                	test   %edx,%edx
  800ac9:	74 21                	je     800aec <strlcpy+0x39>
  800acb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800acf:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ad1:	39 c2                	cmp    %eax,%edx
  800ad3:	74 14                	je     800ae9 <strlcpy+0x36>
  800ad5:	0f b6 19             	movzbl (%ecx),%ebx
  800ad8:	84 db                	test   %bl,%bl
  800ada:	74 0b                	je     800ae7 <strlcpy+0x34>
			*dst++ = *src++;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	83 c2 01             	add    $0x1,%edx
  800ae2:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae5:	eb ea                	jmp    800ad1 <strlcpy+0x1e>
  800ae7:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aec:	29 f0                	sub    %esi,%eax
}
  800aee:	5b                   	pop    %ebx
  800aef:	5e                   	pop    %esi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af2:	f3 0f 1e fb          	endbr32 
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aff:	0f b6 01             	movzbl (%ecx),%eax
  800b02:	84 c0                	test   %al,%al
  800b04:	74 0c                	je     800b12 <strcmp+0x20>
  800b06:	3a 02                	cmp    (%edx),%al
  800b08:	75 08                	jne    800b12 <strcmp+0x20>
		p++, q++;
  800b0a:	83 c1 01             	add    $0x1,%ecx
  800b0d:	83 c2 01             	add    $0x1,%edx
  800b10:	eb ed                	jmp    800aff <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b12:	0f b6 c0             	movzbl %al,%eax
  800b15:	0f b6 12             	movzbl (%edx),%edx
  800b18:	29 d0                	sub    %edx,%eax
}
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b1c:	f3 0f 1e fb          	endbr32 
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	53                   	push   %ebx
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	89 c3                	mov    %eax,%ebx
  800b2c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b2f:	eb 06                	jmp    800b37 <strncmp+0x1b>
		n--, p++, q++;
  800b31:	83 c0 01             	add    $0x1,%eax
  800b34:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b37:	39 d8                	cmp    %ebx,%eax
  800b39:	74 16                	je     800b51 <strncmp+0x35>
  800b3b:	0f b6 08             	movzbl (%eax),%ecx
  800b3e:	84 c9                	test   %cl,%cl
  800b40:	74 04                	je     800b46 <strncmp+0x2a>
  800b42:	3a 0a                	cmp    (%edx),%cl
  800b44:	74 eb                	je     800b31 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	0f b6 00             	movzbl (%eax),%eax
  800b49:	0f b6 12             	movzbl (%edx),%edx
  800b4c:	29 d0                	sub    %edx,%eax
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5d                   	pop    %ebp
  800b50:	c3                   	ret    
		return 0;
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	eb f6                	jmp    800b4e <strncmp+0x32>

00800b58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b58:	f3 0f 1e fb          	endbr32 
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b66:	0f b6 10             	movzbl (%eax),%edx
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	74 09                	je     800b76 <strchr+0x1e>
		if (*s == c)
  800b6d:	38 ca                	cmp    %cl,%dl
  800b6f:	74 0a                	je     800b7b <strchr+0x23>
	for (; *s; s++)
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	eb f0                	jmp    800b66 <strchr+0xe>
			return (char *) s;
	return 0;
  800b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7d:	f3 0f 1e fb          	endbr32 
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b8b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b8e:	38 ca                	cmp    %cl,%dl
  800b90:	74 09                	je     800b9b <strfind+0x1e>
  800b92:	84 d2                	test   %dl,%dl
  800b94:	74 05                	je     800b9b <strfind+0x1e>
	for (; *s; s++)
  800b96:	83 c0 01             	add    $0x1,%eax
  800b99:	eb f0                	jmp    800b8b <strfind+0xe>
			break;
	return (char *) s;
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b9d:	f3 0f 1e fb          	endbr32 
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
  800ba7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800baa:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bad:	85 c9                	test   %ecx,%ecx
  800baf:	74 31                	je     800be2 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb1:	89 f8                	mov    %edi,%eax
  800bb3:	09 c8                	or     %ecx,%eax
  800bb5:	a8 03                	test   $0x3,%al
  800bb7:	75 23                	jne    800bdc <memset+0x3f>
		c &= 0xFF;
  800bb9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bbd:	89 d3                	mov    %edx,%ebx
  800bbf:	c1 e3 08             	shl    $0x8,%ebx
  800bc2:	89 d0                	mov    %edx,%eax
  800bc4:	c1 e0 18             	shl    $0x18,%eax
  800bc7:	89 d6                	mov    %edx,%esi
  800bc9:	c1 e6 10             	shl    $0x10,%esi
  800bcc:	09 f0                	or     %esi,%eax
  800bce:	09 c2                	or     %eax,%edx
  800bd0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bd5:	89 d0                	mov    %edx,%eax
  800bd7:	fc                   	cld    
  800bd8:	f3 ab                	rep stos %eax,%es:(%edi)
  800bda:	eb 06                	jmp    800be2 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	fc                   	cld    
  800be0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be2:	89 f8                	mov    %edi,%eax
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfb:	39 c6                	cmp    %eax,%esi
  800bfd:	73 32                	jae    800c31 <memmove+0x48>
  800bff:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c02:	39 c2                	cmp    %eax,%edx
  800c04:	76 2b                	jbe    800c31 <memmove+0x48>
		s += n;
		d += n;
  800c06:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c09:	89 fe                	mov    %edi,%esi
  800c0b:	09 ce                	or     %ecx,%esi
  800c0d:	09 d6                	or     %edx,%esi
  800c0f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c15:	75 0e                	jne    800c25 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c17:	83 ef 04             	sub    $0x4,%edi
  800c1a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c1d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c20:	fd                   	std    
  800c21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c23:	eb 09                	jmp    800c2e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c25:	83 ef 01             	sub    $0x1,%edi
  800c28:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c2b:	fd                   	std    
  800c2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c2e:	fc                   	cld    
  800c2f:	eb 1a                	jmp    800c4b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c31:	89 c2                	mov    %eax,%edx
  800c33:	09 ca                	or     %ecx,%edx
  800c35:	09 f2                	or     %esi,%edx
  800c37:	f6 c2 03             	test   $0x3,%dl
  800c3a:	75 0a                	jne    800c46 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c3c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c3f:	89 c7                	mov    %eax,%edi
  800c41:	fc                   	cld    
  800c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c44:	eb 05                	jmp    800c4b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800c46:	89 c7                	mov    %eax,%edi
  800c48:	fc                   	cld    
  800c49:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4f:	f3 0f 1e fb          	endbr32 
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	ff 75 08             	pushl  0x8(%ebp)
  800c62:	e8 82 ff ff ff       	call   800be9 <memmove>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	39 f0                	cmp    %esi,%eax
  800c7f:	74 1c                	je     800c9d <memcmp+0x34>
		if (*s1 != *s2)
  800c81:	0f b6 08             	movzbl (%eax),%ecx
  800c84:	0f b6 1a             	movzbl (%edx),%ebx
  800c87:	38 d9                	cmp    %bl,%cl
  800c89:	75 08                	jne    800c93 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	eb ea                	jmp    800c7d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800c93:	0f b6 c1             	movzbl %cl,%eax
  800c96:	0f b6 db             	movzbl %bl,%ebx
  800c99:	29 d8                	sub    %ebx,%eax
  800c9b:	eb 05                	jmp    800ca2 <memcmp+0x39>
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	f3 0f 1e fb          	endbr32 
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cb3:	89 c2                	mov    %eax,%edx
  800cb5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb8:	39 d0                	cmp    %edx,%eax
  800cba:	73 09                	jae    800cc5 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cbc:	38 08                	cmp    %cl,(%eax)
  800cbe:	74 05                	je     800cc5 <memfind+0x1f>
	for (; s < ends; s++)
  800cc0:	83 c0 01             	add    $0x1,%eax
  800cc3:	eb f3                	jmp    800cb8 <memfind+0x12>
			break;
	return (void *) s;
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc7:	f3 0f 1e fb          	endbr32 
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd7:	eb 03                	jmp    800cdc <strtol+0x15>
		s++;
  800cd9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	3c 20                	cmp    $0x20,%al
  800ce1:	74 f6                	je     800cd9 <strtol+0x12>
  800ce3:	3c 09                	cmp    $0x9,%al
  800ce5:	74 f2                	je     800cd9 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ce7:	3c 2b                	cmp    $0x2b,%al
  800ce9:	74 2a                	je     800d15 <strtol+0x4e>
	int neg = 0;
  800ceb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cf0:	3c 2d                	cmp    $0x2d,%al
  800cf2:	74 2b                	je     800d1f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cfa:	75 0f                	jne    800d0b <strtol+0x44>
  800cfc:	80 39 30             	cmpb   $0x30,(%ecx)
  800cff:	74 28                	je     800d29 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d01:	85 db                	test   %ebx,%ebx
  800d03:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d08:	0f 44 d8             	cmove  %eax,%ebx
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d13:	eb 46                	jmp    800d5b <strtol+0x94>
		s++;
  800d15:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d18:	bf 00 00 00 00       	mov    $0x0,%edi
  800d1d:	eb d5                	jmp    800cf4 <strtol+0x2d>
		s++, neg = 1;
  800d1f:	83 c1 01             	add    $0x1,%ecx
  800d22:	bf 01 00 00 00       	mov    $0x1,%edi
  800d27:	eb cb                	jmp    800cf4 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d29:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d2d:	74 0e                	je     800d3d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800d2f:	85 db                	test   %ebx,%ebx
  800d31:	75 d8                	jne    800d0b <strtol+0x44>
		s++, base = 8;
  800d33:	83 c1 01             	add    $0x1,%ecx
  800d36:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d3b:	eb ce                	jmp    800d0b <strtol+0x44>
		s += 2, base = 16;
  800d3d:	83 c1 02             	add    $0x2,%ecx
  800d40:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d45:	eb c4                	jmp    800d0b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800d47:	0f be d2             	movsbl %dl,%edx
  800d4a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d50:	7d 3a                	jge    800d8c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800d52:	83 c1 01             	add    $0x1,%ecx
  800d55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5b:	0f b6 11             	movzbl (%ecx),%edx
  800d5e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d61:	89 f3                	mov    %esi,%ebx
  800d63:	80 fb 09             	cmp    $0x9,%bl
  800d66:	76 df                	jbe    800d47 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800d68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d6b:	89 f3                	mov    %esi,%ebx
  800d6d:	80 fb 19             	cmp    $0x19,%bl
  800d70:	77 08                	ja     800d7a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800d72:	0f be d2             	movsbl %dl,%edx
  800d75:	83 ea 57             	sub    $0x57,%edx
  800d78:	eb d3                	jmp    800d4d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800d7a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d7d:	89 f3                	mov    %esi,%ebx
  800d7f:	80 fb 19             	cmp    $0x19,%bl
  800d82:	77 08                	ja     800d8c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800d84:	0f be d2             	movsbl %dl,%edx
  800d87:	83 ea 37             	sub    $0x37,%edx
  800d8a:	eb c1                	jmp    800d4d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d90:	74 05                	je     800d97 <strtol+0xd0>
		*endptr = (char *) s;
  800d92:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d95:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d97:	89 c2                	mov    %eax,%edx
  800d99:	f7 da                	neg    %edx
  800d9b:	85 ff                	test   %edi,%edi
  800d9d:	0f 45 c2             	cmovne %edx,%eax
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da5:	f3 0f 1e fb          	endbr32 
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	89 c3                	mov    %eax,%ebx
  800dbc:	89 c7                	mov    %eax,%edi
  800dbe:	89 c6                	mov    %eax,%esi
  800dc0:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_cgetc>:

int
sys_cgetc(void)
{
  800dc7:	f3 0f 1e fb          	endbr32 
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  800ddb:	89 d1                	mov    %edx,%ecx
  800ddd:	89 d3                	mov    %edx,%ebx
  800ddf:	89 d7                	mov    %edx,%edi
  800de1:	89 d6                	mov    %edx,%esi
  800de3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	b8 03 00 00 00       	mov    $0x3,%eax
  800e04:	89 cb                	mov    %ecx,%ebx
  800e06:	89 cf                	mov    %ecx,%edi
  800e08:	89 ce                	mov    %ecx,%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 03                	push   $0x3
  800e1e:	68 9f 2c 80 00       	push   $0x802c9f
  800e23:	6a 23                	push   $0x23
  800e25:	68 bc 2c 80 00       	push   $0x802cbc
  800e2a:	e8 13 f5 ff ff       	call   800342 <_panic>

00800e2f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e39:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3e:	b8 02 00 00 00       	mov    $0x2,%eax
  800e43:	89 d1                	mov    %edx,%ecx
  800e45:	89 d3                	mov    %edx,%ebx
  800e47:	89 d7                	mov    %edx,%edi
  800e49:	89 d6                	mov    %edx,%esi
  800e4b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <sys_yield>:

void
sys_yield(void)
{
  800e52:	f3 0f 1e fb          	endbr32 
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	57                   	push   %edi
  800e5a:	56                   	push   %esi
  800e5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e61:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e66:	89 d1                	mov    %edx,%ecx
  800e68:	89 d3                	mov    %edx,%ebx
  800e6a:	89 d7                	mov    %edx,%edi
  800e6c:	89 d6                	mov    %edx,%esi
  800e6e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e75:	f3 0f 1e fb          	endbr32 
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	be 00 00 00 00       	mov    $0x0,%esi
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	89 f7                	mov    %esi,%edi
  800e97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7f 08                	jg     800ea5 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	50                   	push   %eax
  800ea9:	6a 04                	push   $0x4
  800eab:	68 9f 2c 80 00       	push   $0x802c9f
  800eb0:	6a 23                	push   $0x23
  800eb2:	68 bc 2c 80 00       	push   $0x802cbc
  800eb7:	e8 86 f4 ff ff       	call   800342 <_panic>

00800ebc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ebc:	f3 0f 1e fb          	endbr32 
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ed4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eda:	8b 75 18             	mov    0x18(%ebp),%esi
  800edd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7f 08                	jg     800eeb <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	83 ec 0c             	sub    $0xc,%esp
  800eee:	50                   	push   %eax
  800eef:	6a 05                	push   $0x5
  800ef1:	68 9f 2c 80 00       	push   $0x802c9f
  800ef6:	6a 23                	push   $0x23
  800ef8:	68 bc 2c 80 00       	push   $0x802cbc
  800efd:	e8 40 f4 ff ff       	call   800342 <_panic>

00800f02 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f02:	f3 0f 1e fb          	endbr32 
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1f:	89 df                	mov    %ebx,%edi
  800f21:	89 de                	mov    %ebx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800f35:	6a 06                	push   $0x6
  800f37:	68 9f 2c 80 00       	push   $0x802c9f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 bc 2c 80 00       	push   $0x802cbc
  800f43:	e8 fa f3 ff ff       	call   800342 <_panic>

00800f48 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
  800f52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	b8 08 00 00 00       	mov    $0x8,%eax
  800f65:	89 df                	mov    %ebx,%edi
  800f67:	89 de                	mov    %ebx,%esi
  800f69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	7f 08                	jg     800f77 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	50                   	push   %eax
  800f7b:	6a 08                	push   $0x8
  800f7d:	68 9f 2c 80 00       	push   $0x802c9f
  800f82:	6a 23                	push   $0x23
  800f84:	68 bc 2c 80 00       	push   $0x802cbc
  800f89:	e8 b4 f3 ff ff       	call   800342 <_panic>

00800f8e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8e:	f3 0f 1e fb          	endbr32 
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
  800f98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa6:	b8 09 00 00 00       	mov    $0x9,%eax
  800fab:	89 df                	mov    %ebx,%edi
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	7f 08                	jg     800fbd <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	83 ec 0c             	sub    $0xc,%esp
  800fc0:	50                   	push   %eax
  800fc1:	6a 09                	push   $0x9
  800fc3:	68 9f 2c 80 00       	push   $0x802c9f
  800fc8:	6a 23                	push   $0x23
  800fca:	68 bc 2c 80 00       	push   $0x802cbc
  800fcf:	e8 6e f3 ff ff       	call   800342 <_panic>

00800fd4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd4:	f3 0f 1e fb          	endbr32 
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
  800fdb:	57                   	push   %edi
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ff1:	89 df                	mov    %ebx,%edi
  800ff3:	89 de                	mov    %ebx,%esi
  800ff5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7f 08                	jg     801003 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	50                   	push   %eax
  801007:	6a 0a                	push   $0xa
  801009:	68 9f 2c 80 00       	push   $0x802c9f
  80100e:	6a 23                	push   $0x23
  801010:	68 bc 2c 80 00       	push   $0x802cbc
  801015:	e8 28 f3 ff ff       	call   800342 <_panic>

0080101a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80101a:	f3 0f 1e fb          	endbr32 
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80102f:	be 00 00 00 00       	mov    $0x0,%esi
  801034:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801037:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801041:	f3 0f 1e fb          	endbr32 
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80104e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	b8 0d 00 00 00       	mov    $0xd,%eax
  80105b:	89 cb                	mov    %ecx,%ebx
  80105d:	89 cf                	mov    %ecx,%edi
  80105f:	89 ce                	mov    %ecx,%esi
  801061:	cd 30                	int    $0x30
	if(check && ret > 0)
  801063:	85 c0                	test   %eax,%eax
  801065:	7f 08                	jg     80106f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801067:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	50                   	push   %eax
  801073:	6a 0d                	push   $0xd
  801075:	68 9f 2c 80 00       	push   $0x802c9f
  80107a:	6a 23                	push   $0x23
  80107c:	68 bc 2c 80 00       	push   $0x802cbc
  801081:	e8 bc f2 ff ff       	call   800342 <_panic>

00801086 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801090:	ba 00 00 00 00       	mov    $0x0,%edx
  801095:	b8 0e 00 00 00       	mov    $0xe,%eax
  80109a:	89 d1                	mov    %edx,%ecx
  80109c:	89 d3                	mov    %edx,%ebx
  80109e:	89 d7                	mov    %edx,%edi
  8010a0:	89 d6                	mov    %edx,%esi
  8010a2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a4:	5b                   	pop    %ebx
  8010a5:	5e                   	pop    %esi
  8010a6:	5f                   	pop    %edi
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8010a9:	f3 0f 1e fb          	endbr32 
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  8010b9:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  8010bb:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8010be:	83 3a 01             	cmpl   $0x1,(%edx)
  8010c1:	7e 09                	jle    8010cc <argstart+0x23>
  8010c3:	ba 48 29 80 00       	mov    $0x802948,%edx
  8010c8:	85 c9                	test   %ecx,%ecx
  8010ca:	75 05                	jne    8010d1 <argstart+0x28>
  8010cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d1:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  8010d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <argnext>:

int
argnext(struct Argstate *args)
{
  8010dd:	f3 0f 1e fb          	endbr32 
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	53                   	push   %ebx
  8010e5:	83 ec 04             	sub    $0x4,%esp
  8010e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  8010eb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  8010f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	74 74                	je     80116d <argnext+0x90>
		return -1;

	if (!*args->curarg) {
  8010f9:	80 38 00             	cmpb   $0x0,(%eax)
  8010fc:	75 48                	jne    801146 <argnext+0x69>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  8010fe:	8b 0b                	mov    (%ebx),%ecx
  801100:	83 39 01             	cmpl   $0x1,(%ecx)
  801103:	74 5a                	je     80115f <argnext+0x82>
		    || args->argv[1][0] != '-'
  801105:	8b 53 04             	mov    0x4(%ebx),%edx
  801108:	8b 42 04             	mov    0x4(%edx),%eax
  80110b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80110e:	75 4f                	jne    80115f <argnext+0x82>
		    || args->argv[1][1] == '\0')
  801110:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801114:	74 49                	je     80115f <argnext+0x82>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801116:	83 c0 01             	add    $0x1,%eax
  801119:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	8b 01                	mov    (%ecx),%eax
  801121:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801128:	50                   	push   %eax
  801129:	8d 42 08             	lea    0x8(%edx),%eax
  80112c:	50                   	push   %eax
  80112d:	83 c2 04             	add    $0x4,%edx
  801130:	52                   	push   %edx
  801131:	e8 b3 fa ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  801136:	8b 03                	mov    (%ebx),%eax
  801138:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80113b:	8b 43 08             	mov    0x8(%ebx),%eax
  80113e:	83 c4 10             	add    $0x10,%esp
  801141:	80 38 2d             	cmpb   $0x2d,(%eax)
  801144:	74 13                	je     801159 <argnext+0x7c>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801146:	8b 43 08             	mov    0x8(%ebx),%eax
  801149:	0f b6 10             	movzbl (%eax),%edx
	args->curarg++;
  80114c:	83 c0 01             	add    $0x1,%eax
  80114f:	89 43 08             	mov    %eax,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801152:	89 d0                	mov    %edx,%eax
  801154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801157:	c9                   	leave  
  801158:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801159:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80115d:	75 e7                	jne    801146 <argnext+0x69>
	args->curarg = 0;
  80115f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801166:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80116b:	eb e5                	jmp    801152 <argnext+0x75>
		return -1;
  80116d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801172:	eb de                	jmp    801152 <argnext+0x75>

00801174 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801174:	f3 0f 1e fb          	endbr32 
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	53                   	push   %ebx
  80117c:	83 ec 04             	sub    $0x4,%esp
  80117f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801182:	8b 43 08             	mov    0x8(%ebx),%eax
  801185:	85 c0                	test   %eax,%eax
  801187:	74 12                	je     80119b <argnextvalue+0x27>
		return 0;
	if (*args->curarg) {
  801189:	80 38 00             	cmpb   $0x0,(%eax)
  80118c:	74 12                	je     8011a0 <argnextvalue+0x2c>
		args->argvalue = args->curarg;
  80118e:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801191:	c7 43 08 48 29 80 00 	movl   $0x802948,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801198:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  80119b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    
	} else if (*args->argc > 1) {
  8011a0:	8b 13                	mov    (%ebx),%edx
  8011a2:	83 3a 01             	cmpl   $0x1,(%edx)
  8011a5:	7f 10                	jg     8011b7 <argnextvalue+0x43>
		args->argvalue = 0;
  8011a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8011ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  8011b5:	eb e1                	jmp    801198 <argnextvalue+0x24>
		args->argvalue = args->argv[1];
  8011b7:	8b 43 04             	mov    0x4(%ebx),%eax
  8011ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8011bd:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8011c0:	83 ec 04             	sub    $0x4,%esp
  8011c3:	8b 12                	mov    (%edx),%edx
  8011c5:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  8011cc:	52                   	push   %edx
  8011cd:	8d 50 08             	lea    0x8(%eax),%edx
  8011d0:	52                   	push   %edx
  8011d1:	83 c0 04             	add    $0x4,%eax
  8011d4:	50                   	push   %eax
  8011d5:	e8 0f fa ff ff       	call   800be9 <memmove>
		(*args->argc)--;
  8011da:	8b 03                	mov    (%ebx),%eax
  8011dc:	83 28 01             	subl   $0x1,(%eax)
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	eb b4                	jmp    801198 <argnextvalue+0x24>

008011e4 <argvalue>:
{
  8011e4:	f3 0f 1e fb          	endbr32 
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011f1:	8b 42 0c             	mov    0xc(%edx),%eax
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	74 02                	je     8011fa <argvalue+0x16>
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	52                   	push   %edx
  8011fe:	e8 71 ff ff ff       	call   801174 <argnextvalue>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	eb f0                	jmp    8011f8 <argvalue+0x14>

00801208 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801208:	f3 0f 1e fb          	endbr32 
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	05 00 00 00 30       	add    $0x30000000,%eax
  801217:	c1 e8 0c             	shr    $0xc,%eax
}
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80121c:	f3 0f 1e fb          	endbr32 
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80122b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801230:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801237:	f3 0f 1e fb          	endbr32 
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801243:	89 c2                	mov    %eax,%edx
  801245:	c1 ea 16             	shr    $0x16,%edx
  801248:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80124f:	f6 c2 01             	test   $0x1,%dl
  801252:	74 2d                	je     801281 <fd_alloc+0x4a>
  801254:	89 c2                	mov    %eax,%edx
  801256:	c1 ea 0c             	shr    $0xc,%edx
  801259:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801260:	f6 c2 01             	test   $0x1,%dl
  801263:	74 1c                	je     801281 <fd_alloc+0x4a>
  801265:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80126a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80126f:	75 d2                	jne    801243 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80127a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80127f:	eb 0a                	jmp    80128b <fd_alloc+0x54>
			*fd_store = fd;
  801281:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801284:	89 01                	mov    %eax,(%ecx)
			return 0;
  801286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80128d:	f3 0f 1e fb          	endbr32 
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801297:	83 f8 1f             	cmp    $0x1f,%eax
  80129a:	77 30                	ja     8012cc <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80129c:	c1 e0 0c             	shl    $0xc,%eax
  80129f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012a4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8012aa:	f6 c2 01             	test   $0x1,%dl
  8012ad:	74 24                	je     8012d3 <fd_lookup+0x46>
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	c1 ea 0c             	shr    $0xc,%edx
  8012b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 1a                	je     8012da <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c3:	89 02                	mov    %eax,(%edx)
	return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		return -E_INVAL;
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb f7                	jmp    8012ca <fd_lookup+0x3d>
		return -E_INVAL;
  8012d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d8:	eb f0                	jmp    8012ca <fd_lookup+0x3d>
  8012da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012df:	eb e9                	jmp    8012ca <fd_lookup+0x3d>

008012e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012f8:	39 08                	cmp    %ecx,(%eax)
  8012fa:	74 38                	je     801334 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8012fc:	83 c2 01             	add    $0x1,%edx
  8012ff:	8b 04 95 48 2d 80 00 	mov    0x802d48(,%edx,4),%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	75 ee                	jne    8012f8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80130a:	a1 20 44 80 00       	mov    0x804420,%eax
  80130f:	8b 40 48             	mov    0x48(%eax),%eax
  801312:	83 ec 04             	sub    $0x4,%esp
  801315:	51                   	push   %ecx
  801316:	50                   	push   %eax
  801317:	68 cc 2c 80 00       	push   $0x802ccc
  80131c:	e8 08 f1 ff ff       	call   800429 <cprintf>
	*dev = 0;
  801321:	8b 45 0c             	mov    0xc(%ebp),%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    
			*dev = devtab[i];
  801334:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801337:	89 01                	mov    %eax,(%ecx)
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb f2                	jmp    801332 <dev_lookup+0x51>

00801340 <fd_close>:
{
  801340:	f3 0f 1e fb          	endbr32 
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	57                   	push   %edi
  801348:	56                   	push   %esi
  801349:	53                   	push   %ebx
  80134a:	83 ec 24             	sub    $0x24,%esp
  80134d:	8b 75 08             	mov    0x8(%ebp),%esi
  801350:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801353:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801356:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801357:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80135d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801360:	50                   	push   %eax
  801361:	e8 27 ff ff ff       	call   80128d <fd_lookup>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 05                	js     801374 <fd_close+0x34>
	    || fd != fd2)
  80136f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801372:	74 16                	je     80138a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801374:	89 f8                	mov    %edi,%eax
  801376:	84 c0                	test   %al,%al
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
  80137d:	0f 44 d8             	cmove  %eax,%ebx
}
  801380:	89 d8                	mov    %ebx,%eax
  801382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801390:	50                   	push   %eax
  801391:	ff 36                	pushl  (%esi)
  801393:	e8 49 ff ff ff       	call   8012e1 <dev_lookup>
  801398:	89 c3                	mov    %eax,%ebx
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 1a                	js     8013bb <fd_close+0x7b>
		if (dev->dev_close)
  8013a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8013a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	74 0b                	je     8013bb <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	56                   	push   %esi
  8013b4:	ff d0                	call   *%eax
  8013b6:	89 c3                	mov    %eax,%ebx
  8013b8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	56                   	push   %esi
  8013bf:	6a 00                	push   $0x0
  8013c1:	e8 3c fb ff ff       	call   800f02 <sys_page_unmap>
	return r;
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	eb b5                	jmp    801380 <fd_close+0x40>

008013cb <close>:

int
close(int fdnum)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	ff 75 08             	pushl  0x8(%ebp)
  8013dc:	e8 ac fe ff ff       	call   80128d <fd_lookup>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	79 02                	jns    8013ea <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    
		return fd_close(fd, 1);
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	6a 01                	push   $0x1
  8013ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f2:	e8 49 ff ff ff       	call   801340 <fd_close>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	eb ec                	jmp    8013e8 <close+0x1d>

008013fc <close_all>:

void
close_all(void)
{
  8013fc:	f3 0f 1e fb          	endbr32 
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	53                   	push   %ebx
  801404:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801407:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80140c:	83 ec 0c             	sub    $0xc,%esp
  80140f:	53                   	push   %ebx
  801410:	e8 b6 ff ff ff       	call   8013cb <close>
	for (i = 0; i < MAXFD; i++)
  801415:	83 c3 01             	add    $0x1,%ebx
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	83 fb 20             	cmp    $0x20,%ebx
  80141e:	75 ec                	jne    80140c <close_all+0x10>
}
  801420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801425:	f3 0f 1e fb          	endbr32 
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	57                   	push   %edi
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
  80142f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801432:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801435:	50                   	push   %eax
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	e8 4f fe ff ff       	call   80128d <fd_lookup>
  80143e:	89 c3                	mov    %eax,%ebx
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	0f 88 81 00 00 00    	js     8014cc <dup+0xa7>
		return r;
	close(newfdnum);
  80144b:	83 ec 0c             	sub    $0xc,%esp
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	e8 75 ff ff ff       	call   8013cb <close>

	newfd = INDEX2FD(newfdnum);
  801456:	8b 75 0c             	mov    0xc(%ebp),%esi
  801459:	c1 e6 0c             	shl    $0xc,%esi
  80145c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801462:	83 c4 04             	add    $0x4,%esp
  801465:	ff 75 e4             	pushl  -0x1c(%ebp)
  801468:	e8 af fd ff ff       	call   80121c <fd2data>
  80146d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80146f:	89 34 24             	mov    %esi,(%esp)
  801472:	e8 a5 fd ff ff       	call   80121c <fd2data>
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80147c:	89 d8                	mov    %ebx,%eax
  80147e:	c1 e8 16             	shr    $0x16,%eax
  801481:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801488:	a8 01                	test   $0x1,%al
  80148a:	74 11                	je     80149d <dup+0x78>
  80148c:	89 d8                	mov    %ebx,%eax
  80148e:	c1 e8 0c             	shr    $0xc,%eax
  801491:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801498:	f6 c2 01             	test   $0x1,%dl
  80149b:	75 39                	jne    8014d6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80149d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a0:	89 d0                	mov    %edx,%eax
  8014a2:	c1 e8 0c             	shr    $0xc,%eax
  8014a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014ac:	83 ec 0c             	sub    $0xc,%esp
  8014af:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b4:	50                   	push   %eax
  8014b5:	56                   	push   %esi
  8014b6:	6a 00                	push   $0x0
  8014b8:	52                   	push   %edx
  8014b9:	6a 00                	push   $0x0
  8014bb:	e8 fc f9 ff ff       	call   800ebc <sys_page_map>
  8014c0:	89 c3                	mov    %eax,%ebx
  8014c2:	83 c4 20             	add    $0x20,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 31                	js     8014fa <dup+0xd5>
		goto err;

	return newfdnum;
  8014c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014cc:	89 d8                	mov    %ebx,%eax
  8014ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d1:	5b                   	pop    %ebx
  8014d2:	5e                   	pop    %esi
  8014d3:	5f                   	pop    %edi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014dd:	83 ec 0c             	sub    $0xc,%esp
  8014e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8014e5:	50                   	push   %eax
  8014e6:	57                   	push   %edi
  8014e7:	6a 00                	push   $0x0
  8014e9:	53                   	push   %ebx
  8014ea:	6a 00                	push   $0x0
  8014ec:	e8 cb f9 ff ff       	call   800ebc <sys_page_map>
  8014f1:	89 c3                	mov    %eax,%ebx
  8014f3:	83 c4 20             	add    $0x20,%esp
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	79 a3                	jns    80149d <dup+0x78>
	sys_page_unmap(0, newfd);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	56                   	push   %esi
  8014fe:	6a 00                	push   $0x0
  801500:	e8 fd f9 ff ff       	call   800f02 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	57                   	push   %edi
  801509:	6a 00                	push   $0x0
  80150b:	e8 f2 f9 ff ff       	call   800f02 <sys_page_unmap>
	return r;
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	eb b7                	jmp    8014cc <dup+0xa7>

00801515 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801515:	f3 0f 1e fb          	endbr32 
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	53                   	push   %ebx
  80151d:	83 ec 1c             	sub    $0x1c,%esp
  801520:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801523:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	53                   	push   %ebx
  801528:	e8 60 fd ff ff       	call   80128d <fd_lookup>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	78 3f                	js     801573 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	ff 30                	pushl  (%eax)
  801540:	e8 9c fd ff ff       	call   8012e1 <dev_lookup>
  801545:	83 c4 10             	add    $0x10,%esp
  801548:	85 c0                	test   %eax,%eax
  80154a:	78 27                	js     801573 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80154c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154f:	8b 42 08             	mov    0x8(%edx),%eax
  801552:	83 e0 03             	and    $0x3,%eax
  801555:	83 f8 01             	cmp    $0x1,%eax
  801558:	74 1e                	je     801578 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155d:	8b 40 08             	mov    0x8(%eax),%eax
  801560:	85 c0                	test   %eax,%eax
  801562:	74 35                	je     801599 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	ff 75 10             	pushl  0x10(%ebp)
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	52                   	push   %edx
  80156e:	ff d0                	call   *%eax
  801570:	83 c4 10             	add    $0x10,%esp
}
  801573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801576:	c9                   	leave  
  801577:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801578:	a1 20 44 80 00       	mov    0x804420,%eax
  80157d:	8b 40 48             	mov    0x48(%eax),%eax
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	53                   	push   %ebx
  801584:	50                   	push   %eax
  801585:	68 0d 2d 80 00       	push   $0x802d0d
  80158a:	e8 9a ee ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801597:	eb da                	jmp    801573 <read+0x5e>
		return -E_NOT_SUPP;
  801599:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159e:	eb d3                	jmp    801573 <read+0x5e>

008015a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a0:	f3 0f 1e fb          	endbr32 
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	57                   	push   %edi
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b8:	eb 02                	jmp    8015bc <readn+0x1c>
  8015ba:	01 c3                	add    %eax,%ebx
  8015bc:	39 f3                	cmp    %esi,%ebx
  8015be:	73 21                	jae    8015e1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	89 f0                	mov    %esi,%eax
  8015c5:	29 d8                	sub    %ebx,%eax
  8015c7:	50                   	push   %eax
  8015c8:	89 d8                	mov    %ebx,%eax
  8015ca:	03 45 0c             	add    0xc(%ebp),%eax
  8015cd:	50                   	push   %eax
  8015ce:	57                   	push   %edi
  8015cf:	e8 41 ff ff ff       	call   801515 <read>
		if (m < 0)
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 04                	js     8015df <readn+0x3f>
			return m;
		if (m == 0)
  8015db:	75 dd                	jne    8015ba <readn+0x1a>
  8015dd:	eb 02                	jmp    8015e1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015df:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015e1:	89 d8                	mov    %ebx,%eax
  8015e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5f                   	pop    %edi
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015eb:	f3 0f 1e fb          	endbr32 
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	53                   	push   %ebx
  8015f3:	83 ec 1c             	sub    $0x1c,%esp
  8015f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	53                   	push   %ebx
  8015fe:	e8 8a fc ff ff       	call   80128d <fd_lookup>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	85 c0                	test   %eax,%eax
  801608:	78 3a                	js     801644 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	ff 30                	pushl  (%eax)
  801616:	e8 c6 fc ff ff       	call   8012e1 <dev_lookup>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 22                	js     801644 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801629:	74 1e                	je     801649 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80162b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162e:	8b 52 0c             	mov    0xc(%edx),%edx
  801631:	85 d2                	test   %edx,%edx
  801633:	74 35                	je     80166a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	ff 75 10             	pushl  0x10(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	50                   	push   %eax
  80163f:	ff d2                	call   *%edx
  801641:	83 c4 10             	add    $0x10,%esp
}
  801644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801647:	c9                   	leave  
  801648:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801649:	a1 20 44 80 00       	mov    0x804420,%eax
  80164e:	8b 40 48             	mov    0x48(%eax),%eax
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	53                   	push   %ebx
  801655:	50                   	push   %eax
  801656:	68 29 2d 80 00       	push   $0x802d29
  80165b:	e8 c9 ed ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801668:	eb da                	jmp    801644 <write+0x59>
		return -E_NOT_SUPP;
  80166a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166f:	eb d3                	jmp    801644 <write+0x59>

00801671 <seek>:

int
seek(int fdnum, off_t offset)
{
  801671:	f3 0f 1e fb          	endbr32 
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167e:	50                   	push   %eax
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	e8 06 fc ff ff       	call   80128d <fd_lookup>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 0e                	js     80169c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801694:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80169e:	f3 0f 1e fb          	endbr32 
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 1c             	sub    $0x1c,%esp
  8016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016af:	50                   	push   %eax
  8016b0:	53                   	push   %ebx
  8016b1:	e8 d7 fb ff ff       	call   80128d <fd_lookup>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 37                	js     8016f4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c3:	50                   	push   %eax
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c7:	ff 30                	pushl  (%eax)
  8016c9:	e8 13 fc ff ff       	call   8012e1 <dev_lookup>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 1f                	js     8016f4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016dc:	74 1b                	je     8016f9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e1:	8b 52 18             	mov    0x18(%edx),%edx
  8016e4:	85 d2                	test   %edx,%edx
  8016e6:	74 32                	je     80171a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	50                   	push   %eax
  8016ef:	ff d2                	call   *%edx
  8016f1:	83 c4 10             	add    $0x10,%esp
}
  8016f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016f9:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016fe:	8b 40 48             	mov    0x48(%eax),%eax
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	53                   	push   %ebx
  801705:	50                   	push   %eax
  801706:	68 ec 2c 80 00       	push   $0x802cec
  80170b:	e8 19 ed ff ff       	call   800429 <cprintf>
		return -E_INVAL;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801718:	eb da                	jmp    8016f4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80171a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171f:	eb d3                	jmp    8016f4 <ftruncate+0x56>

00801721 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801721:	f3 0f 1e fb          	endbr32 
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	53                   	push   %ebx
  801729:	83 ec 1c             	sub    $0x1c,%esp
  80172c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801732:	50                   	push   %eax
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 52 fb ff ff       	call   80128d <fd_lookup>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 4b                	js     80178d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801742:	83 ec 08             	sub    $0x8,%esp
  801745:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801748:	50                   	push   %eax
  801749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174c:	ff 30                	pushl  (%eax)
  80174e:	e8 8e fb ff ff       	call   8012e1 <dev_lookup>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 33                	js     80178d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801761:	74 2f                	je     801792 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801763:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801766:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80176d:	00 00 00 
	stat->st_isdir = 0;
  801770:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801777:	00 00 00 
	stat->st_dev = dev;
  80177a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	53                   	push   %ebx
  801784:	ff 75 f0             	pushl  -0x10(%ebp)
  801787:	ff 50 14             	call   *0x14(%eax)
  80178a:	83 c4 10             	add    $0x10,%esp
}
  80178d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801790:	c9                   	leave  
  801791:	c3                   	ret    
		return -E_NOT_SUPP;
  801792:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801797:	eb f4                	jmp    80178d <fstat+0x6c>

00801799 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801799:	f3 0f 1e fb          	endbr32 
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017a2:	83 ec 08             	sub    $0x8,%esp
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	e8 fb 01 00 00       	call   8019aa <open>
  8017af:	89 c3                	mov    %eax,%ebx
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 1b                	js     8017d3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017b8:	83 ec 08             	sub    $0x8,%esp
  8017bb:	ff 75 0c             	pushl  0xc(%ebp)
  8017be:	50                   	push   %eax
  8017bf:	e8 5d ff ff ff       	call   801721 <fstat>
  8017c4:	89 c6                	mov    %eax,%esi
	close(fd);
  8017c6:	89 1c 24             	mov    %ebx,(%esp)
  8017c9:	e8 fd fb ff ff       	call   8013cb <close>
	return r;
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	89 f3                	mov    %esi,%ebx
}
  8017d3:	89 d8                	mov    %ebx,%eax
  8017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	89 c6                	mov    %eax,%esi
  8017e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017e5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017ec:	74 27                	je     801815 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017ee:	6a 07                	push   $0x7
  8017f0:	68 00 50 80 00       	push   $0x805000
  8017f5:	56                   	push   %esi
  8017f6:	ff 35 00 40 80 00    	pushl  0x804000
  8017fc:	e8 a1 0d 00 00       	call   8025a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801801:	83 c4 0c             	add    $0xc,%esp
  801804:	6a 00                	push   $0x0
  801806:	53                   	push   %ebx
  801807:	6a 00                	push   $0x0
  801809:	e8 20 0d 00 00       	call   80252e <ipc_recv>
}
  80180e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	6a 01                	push   $0x1
  80181a:	e8 db 0d 00 00       	call   8025fa <ipc_find_env>
  80181f:	a3 00 40 80 00       	mov    %eax,0x804000
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	eb c5                	jmp    8017ee <fsipc+0x12>

00801829 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801829:	f3 0f 1e fb          	endbr32 
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8b 40 0c             	mov    0xc(%eax),%eax
  801839:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	b8 02 00 00 00       	mov    $0x2,%eax
  801850:	e8 87 ff ff ff       	call   8017dc <fsipc>
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devfile_flush>:
{
  801857:	f3 0f 1e fb          	endbr32 
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 40 0c             	mov    0xc(%eax),%eax
  801867:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
  801871:	b8 06 00 00 00       	mov    $0x6,%eax
  801876:	e8 61 ff ff ff       	call   8017dc <fsipc>
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <devfile_stat>:
{
  80187d:	f3 0f 1e fb          	endbr32 
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	53                   	push   %ebx
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	8b 40 0c             	mov    0xc(%eax),%eax
  801891:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801896:	ba 00 00 00 00       	mov    $0x0,%edx
  80189b:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a0:	e8 37 ff ff ff       	call   8017dc <fsipc>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 2c                	js     8018d5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	68 00 50 80 00       	push   $0x805000
  8018b1:	53                   	push   %ebx
  8018b2:	e8 7c f1 ff ff       	call   800a33 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018b7:	a1 80 50 80 00       	mov    0x805080,%eax
  8018bc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018c2:	a1 84 50 80 00       	mov    0x805084,%eax
  8018c7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <devfile_write>:
{
  8018da:	f3 0f 1e fb          	endbr32 
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 0c             	sub    $0xc,%esp
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ed:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8018f3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018f8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018fd:	0f 47 c2             	cmova  %edx,%eax
  801900:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801905:	50                   	push   %eax
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	68 08 50 80 00       	push   $0x805008
  80190e:	e8 d6 f2 ff ff       	call   800be9 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801913:	ba 00 00 00 00       	mov    $0x0,%edx
  801918:	b8 04 00 00 00       	mov    $0x4,%eax
  80191d:	e8 ba fe ff ff       	call   8017dc <fsipc>
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <devfile_read>:
{
  801924:	f3 0f 1e fb          	endbr32 
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	56                   	push   %esi
  80192c:	53                   	push   %ebx
  80192d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8b 40 0c             	mov    0xc(%eax),%eax
  801936:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80193b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	b8 03 00 00 00       	mov    $0x3,%eax
  80194b:	e8 8c fe ff ff       	call   8017dc <fsipc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	85 c0                	test   %eax,%eax
  801954:	78 1f                	js     801975 <devfile_read+0x51>
	assert(r <= n);
  801956:	39 f0                	cmp    %esi,%eax
  801958:	77 24                	ja     80197e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80195a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80195f:	7f 33                	jg     801994 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	50                   	push   %eax
  801965:	68 00 50 80 00       	push   $0x805000
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	e8 77 f2 ff ff       	call   800be9 <memmove>
	return r;
  801972:	83 c4 10             	add    $0x10,%esp
}
  801975:	89 d8                	mov    %ebx,%eax
  801977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    
	assert(r <= n);
  80197e:	68 5c 2d 80 00       	push   $0x802d5c
  801983:	68 63 2d 80 00       	push   $0x802d63
  801988:	6a 7c                	push   $0x7c
  80198a:	68 78 2d 80 00       	push   $0x802d78
  80198f:	e8 ae e9 ff ff       	call   800342 <_panic>
	assert(r <= PGSIZE);
  801994:	68 83 2d 80 00       	push   $0x802d83
  801999:	68 63 2d 80 00       	push   $0x802d63
  80199e:	6a 7d                	push   $0x7d
  8019a0:	68 78 2d 80 00       	push   $0x802d78
  8019a5:	e8 98 e9 ff ff       	call   800342 <_panic>

008019aa <open>:
{
  8019aa:	f3 0f 1e fb          	endbr32 
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	56                   	push   %esi
  8019b2:	53                   	push   %ebx
  8019b3:	83 ec 1c             	sub    $0x1c,%esp
  8019b6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019b9:	56                   	push   %esi
  8019ba:	e8 31 f0 ff ff       	call   8009f0 <strlen>
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019c7:	7f 6c                	jg     801a35 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cf:	50                   	push   %eax
  8019d0:	e8 62 f8 ff ff       	call   801237 <fd_alloc>
  8019d5:	89 c3                	mov    %eax,%ebx
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 3c                	js     801a1a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	56                   	push   %esi
  8019e2:	68 00 50 80 00       	push   $0x805000
  8019e7:	e8 47 f0 ff ff       	call   800a33 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ef:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fc:	e8 db fd ff ff       	call   8017dc <fsipc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 19                	js     801a23 <open+0x79>
	return fd2num(fd);
  801a0a:	83 ec 0c             	sub    $0xc,%esp
  801a0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a10:	e8 f3 f7 ff ff       	call   801208 <fd2num>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	83 c4 10             	add    $0x10,%esp
}
  801a1a:	89 d8                	mov    %ebx,%eax
  801a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    
		fd_close(fd, 0);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	6a 00                	push   $0x0
  801a28:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2b:	e8 10 f9 ff ff       	call   801340 <fd_close>
		return r;
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	eb e5                	jmp    801a1a <open+0x70>
		return -E_BAD_PATH;
  801a35:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a3a:	eb de                	jmp    801a1a <open+0x70>

00801a3c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a3c:	f3 0f 1e fb          	endbr32 
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a46:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a50:	e8 87 fd ff ff       	call   8017dc <fsipc>
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801a57:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801a5b:	7f 01                	jg     801a5e <writebuf+0x7>
  801a5d:	c3                   	ret    
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	53                   	push   %ebx
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801a67:	ff 70 04             	pushl  0x4(%eax)
  801a6a:	8d 40 10             	lea    0x10(%eax),%eax
  801a6d:	50                   	push   %eax
  801a6e:	ff 33                	pushl  (%ebx)
  801a70:	e8 76 fb ff ff       	call   8015eb <write>
		if (result > 0)
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	7e 03                	jle    801a7f <writebuf+0x28>
			b->result += result;
  801a7c:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a7f:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a82:	74 0d                	je     801a91 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801a84:	85 c0                	test   %eax,%eax
  801a86:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8b:	0f 4f c2             	cmovg  %edx,%eax
  801a8e:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <putch>:

static void
putch(int ch, void *thunk)
{
  801a96:	f3 0f 1e fb          	endbr32 
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 04             	sub    $0x4,%esp
  801aa1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801aa4:	8b 53 04             	mov    0x4(%ebx),%edx
  801aa7:	8d 42 01             	lea    0x1(%edx),%eax
  801aaa:	89 43 04             	mov    %eax,0x4(%ebx)
  801aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab0:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801ab4:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ab9:	74 06                	je     801ac1 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  801abb:	83 c4 04             	add    $0x4,%esp
  801abe:	5b                   	pop    %ebx
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    
		writebuf(b);
  801ac1:	89 d8                	mov    %ebx,%eax
  801ac3:	e8 8f ff ff ff       	call   801a57 <writebuf>
		b->idx = 0;
  801ac8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801acf:	eb ea                	jmp    801abb <putch+0x25>

00801ad1 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ad1:	f3 0f 1e fb          	endbr32 
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801ae7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801aee:	00 00 00 
	b.result = 0;
  801af1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801af8:	00 00 00 
	b.error = 1;
  801afb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b02:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b05:	ff 75 10             	pushl  0x10(%ebp)
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b11:	50                   	push   %eax
  801b12:	68 96 1a 80 00       	push   $0x801a96
  801b17:	e8 10 ea ff ff       	call   80052c <vprintfmt>
	if (b.idx > 0)
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801b26:	7f 11                	jg     801b39 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801b28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    
		writebuf(&b);
  801b39:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b3f:	e8 13 ff ff ff       	call   801a57 <writebuf>
  801b44:	eb e2                	jmp    801b28 <vfprintf+0x57>

00801b46 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b46:	f3 0f 1e fb          	endbr32 
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b50:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b53:	50                   	push   %eax
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	e8 72 ff ff ff       	call   801ad1 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <printf>:

int
printf(const char *fmt, ...)
{
  801b61:	f3 0f 1e fb          	endbr32 
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b6b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b6e:	50                   	push   %eax
  801b6f:	ff 75 08             	pushl  0x8(%ebp)
  801b72:	6a 01                	push   $0x1
  801b74:	e8 58 ff ff ff       	call   801ad1 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b7b:	f3 0f 1e fb          	endbr32 
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b85:	68 8f 2d 80 00       	push   $0x802d8f
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	e8 a1 ee ff ff       	call   800a33 <strcpy>
	return 0;
}
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <devsock_close>:
{
  801b99:	f3 0f 1e fb          	endbr32 
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	53                   	push   %ebx
  801ba1:	83 ec 10             	sub    $0x10,%esp
  801ba4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ba7:	53                   	push   %ebx
  801ba8:	e8 8a 0a 00 00       	call   802637 <pageref>
  801bad:	89 c2                	mov    %eax,%edx
  801baf:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801bb7:	83 fa 01             	cmp    $0x1,%edx
  801bba:	74 05                	je     801bc1 <devsock_close+0x28>
}
  801bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	ff 73 0c             	pushl  0xc(%ebx)
  801bc7:	e8 e3 02 00 00       	call   801eaf <nsipc_close>
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	eb eb                	jmp    801bbc <devsock_close+0x23>

00801bd1 <devsock_write>:
{
  801bd1:	f3 0f 1e fb          	endbr32 
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	ff 75 10             	pushl  0x10(%ebp)
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	ff 70 0c             	pushl  0xc(%eax)
  801be9:	e8 b5 03 00 00       	call   801fa3 <nsipc_send>
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <devsock_read>:
{
  801bf0:	f3 0f 1e fb          	endbr32 
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	ff 70 0c             	pushl  0xc(%eax)
  801c08:	e8 1f 03 00 00       	call   801f2c <nsipc_recv>
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <fd2sockid>:
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c15:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c18:	52                   	push   %edx
  801c19:	50                   	push   %eax
  801c1a:	e8 6e f6 ff ff       	call   80128d <fd_lookup>
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 10                	js     801c36 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c2f:	39 08                	cmp    %ecx,(%eax)
  801c31:	75 05                	jne    801c38 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c33:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    
		return -E_NOT_SUPP;
  801c38:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c3d:	eb f7                	jmp    801c36 <fd2sockid+0x27>

00801c3f <alloc_sockfd>:
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4c:	50                   	push   %eax
  801c4d:	e8 e5 f5 ff ff       	call   801237 <fd_alloc>
  801c52:	89 c3                	mov    %eax,%ebx
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	85 c0                	test   %eax,%eax
  801c59:	78 43                	js     801c9e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	68 07 04 00 00       	push   $0x407
  801c63:	ff 75 f4             	pushl  -0xc(%ebp)
  801c66:	6a 00                	push   $0x0
  801c68:	e8 08 f2 ff ff       	call   800e75 <sys_page_alloc>
  801c6d:	89 c3                	mov    %eax,%ebx
  801c6f:	83 c4 10             	add    $0x10,%esp
  801c72:	85 c0                	test   %eax,%eax
  801c74:	78 28                	js     801c9e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c79:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c7f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c8b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c8e:	83 ec 0c             	sub    $0xc,%esp
  801c91:	50                   	push   %eax
  801c92:	e8 71 f5 ff ff       	call   801208 <fd2num>
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	83 c4 10             	add    $0x10,%esp
  801c9c:	eb 0c                	jmp    801caa <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c9e:	83 ec 0c             	sub    $0xc,%esp
  801ca1:	56                   	push   %esi
  801ca2:	e8 08 02 00 00       	call   801eaf <nsipc_close>
		return r;
  801ca7:	83 c4 10             	add    $0x10,%esp
}
  801caa:	89 d8                	mov    %ebx,%eax
  801cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    

00801cb3 <accept>:
{
  801cb3:	f3 0f 1e fb          	endbr32 
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	e8 4a ff ff ff       	call   801c0f <fd2sockid>
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	78 1b                	js     801ce4 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	50                   	push   %eax
  801cd3:	e8 22 01 00 00       	call   801dfa <nsipc_accept>
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	78 05                	js     801ce4 <accept+0x31>
	return alloc_sockfd(r);
  801cdf:	e8 5b ff ff ff       	call   801c3f <alloc_sockfd>
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <bind>:
{
  801ce6:	f3 0f 1e fb          	endbr32 
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	e8 17 ff ff ff       	call   801c0f <fd2sockid>
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 12                	js     801d0e <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	ff 75 10             	pushl  0x10(%ebp)
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	e8 45 01 00 00       	call   801e50 <nsipc_bind>
  801d0b:	83 c4 10             	add    $0x10,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <shutdown>:
{
  801d10:	f3 0f 1e fb          	endbr32 
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	e8 ed fe ff ff       	call   801c0f <fd2sockid>
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 0f                	js     801d35 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	50                   	push   %eax
  801d2d:	e8 57 01 00 00       	call   801e89 <nsipc_shutdown>
  801d32:	83 c4 10             	add    $0x10,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <connect>:
{
  801d37:	f3 0f 1e fb          	endbr32 
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	e8 c6 fe ff ff       	call   801c0f <fd2sockid>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 12                	js     801d5f <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	ff 75 10             	pushl  0x10(%ebp)
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	50                   	push   %eax
  801d57:	e8 71 01 00 00       	call   801ecd <nsipc_connect>
  801d5c:	83 c4 10             	add    $0x10,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <listen>:
{
  801d61:	f3 0f 1e fb          	endbr32 
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	e8 9c fe ff ff       	call   801c0f <fd2sockid>
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 0f                	js     801d86 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d77:	83 ec 08             	sub    $0x8,%esp
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	50                   	push   %eax
  801d7e:	e8 83 01 00 00       	call   801f06 <nsipc_listen>
  801d83:	83 c4 10             	add    $0x10,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d88:	f3 0f 1e fb          	endbr32 
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d92:	ff 75 10             	pushl  0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 65 02 00 00       	call   802005 <nsipc_socket>
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 05                	js     801dac <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801da7:	e8 93 fe ff ff       	call   801c3f <alloc_sockfd>
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	53                   	push   %ebx
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801db7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801dbe:	74 26                	je     801de6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dc0:	6a 07                	push   $0x7
  801dc2:	68 00 60 80 00       	push   $0x806000
  801dc7:	53                   	push   %ebx
  801dc8:	ff 35 04 40 80 00    	pushl  0x804004
  801dce:	e8 cf 07 00 00       	call   8025a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dd3:	83 c4 0c             	add    $0xc,%esp
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	e8 4d 07 00 00       	call   80252e <ipc_recv>
}
  801de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	6a 02                	push   $0x2
  801deb:	e8 0a 08 00 00       	call   8025fa <ipc_find_env>
  801df0:	a3 04 40 80 00       	mov    %eax,0x804004
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	eb c6                	jmp    801dc0 <nsipc+0x12>

00801dfa <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dfa:	f3 0f 1e fb          	endbr32 
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	56                   	push   %esi
  801e02:	53                   	push   %ebx
  801e03:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e0e:	8b 06                	mov    (%esi),%eax
  801e10:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e15:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1a:	e8 8f ff ff ff       	call   801dae <nsipc>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	85 c0                	test   %eax,%eax
  801e23:	79 09                	jns    801e2e <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e25:	89 d8                	mov    %ebx,%eax
  801e27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	ff 35 10 60 80 00    	pushl  0x806010
  801e37:	68 00 60 80 00       	push   $0x806000
  801e3c:	ff 75 0c             	pushl  0xc(%ebp)
  801e3f:	e8 a5 ed ff ff       	call   800be9 <memmove>
		*addrlen = ret->ret_addrlen;
  801e44:	a1 10 60 80 00       	mov    0x806010,%eax
  801e49:	89 06                	mov    %eax,(%esi)
  801e4b:	83 c4 10             	add    $0x10,%esp
	return r;
  801e4e:	eb d5                	jmp    801e25 <nsipc_accept+0x2b>

00801e50 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e50:	f3 0f 1e fb          	endbr32 
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	53                   	push   %ebx
  801e58:	83 ec 08             	sub    $0x8,%esp
  801e5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e66:	53                   	push   %ebx
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	68 04 60 80 00       	push   $0x806004
  801e6f:	e8 75 ed ff ff       	call   800be9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e74:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e7a:	b8 02 00 00 00       	mov    $0x2,%eax
  801e7f:	e8 2a ff ff ff       	call   801dae <nsipc>
}
  801e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e89:	f3 0f 1e fb          	endbr32 
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ea3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ea8:	e8 01 ff ff ff       	call   801dae <nsipc>
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <nsipc_close>:

int
nsipc_close(int s)
{
  801eaf:	f3 0f 1e fb          	endbr32 
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ec1:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec6:	e8 e3 fe ff ff       	call   801dae <nsipc>
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ecd:	f3 0f 1e fb          	endbr32 
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 08             	sub    $0x8,%esp
  801ed8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ee3:	53                   	push   %ebx
  801ee4:	ff 75 0c             	pushl  0xc(%ebp)
  801ee7:	68 04 60 80 00       	push   $0x806004
  801eec:	e8 f8 ec ff ff       	call   800be9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ef1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ef7:	b8 05 00 00 00       	mov    $0x5,%eax
  801efc:	e8 ad fe ff ff       	call   801dae <nsipc>
}
  801f01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f06:	f3 0f 1e fb          	endbr32 
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f20:	b8 06 00 00 00       	mov    $0x6,%eax
  801f25:	e8 84 fe ff ff       	call   801dae <nsipc>
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f2c:	f3 0f 1e fb          	endbr32 
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	56                   	push   %esi
  801f34:	53                   	push   %ebx
  801f35:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f40:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f46:	8b 45 14             	mov    0x14(%ebp),%eax
  801f49:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f4e:	b8 07 00 00 00       	mov    $0x7,%eax
  801f53:	e8 56 fe ff ff       	call   801dae <nsipc>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 26                	js     801f84 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f5e:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f64:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f69:	0f 4e c6             	cmovle %esi,%eax
  801f6c:	39 c3                	cmp    %eax,%ebx
  801f6e:	7f 1d                	jg     801f8d <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	53                   	push   %ebx
  801f74:	68 00 60 80 00       	push   $0x806000
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	e8 68 ec ff ff       	call   800be9 <memmove>
  801f81:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f8d:	68 9b 2d 80 00       	push   $0x802d9b
  801f92:	68 63 2d 80 00       	push   $0x802d63
  801f97:	6a 62                	push   $0x62
  801f99:	68 b0 2d 80 00       	push   $0x802db0
  801f9e:	e8 9f e3 ff ff       	call   800342 <_panic>

00801fa3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fa3:	f3 0f 1e fb          	endbr32 
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	53                   	push   %ebx
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fb9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fbf:	7f 2e                	jg     801fef <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	53                   	push   %ebx
  801fc5:	ff 75 0c             	pushl  0xc(%ebp)
  801fc8:	68 0c 60 80 00       	push   $0x80600c
  801fcd:	e8 17 ec ff ff       	call   800be9 <memmove>
	nsipcbuf.send.req_size = size;
  801fd2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  801fdb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fe0:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe5:	e8 c4 fd ff ff       	call   801dae <nsipc>
}
  801fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    
	assert(size < 1600);
  801fef:	68 bc 2d 80 00       	push   $0x802dbc
  801ff4:	68 63 2d 80 00       	push   $0x802d63
  801ff9:	6a 6d                	push   $0x6d
  801ffb:	68 b0 2d 80 00       	push   $0x802db0
  802000:	e8 3d e3 ff ff       	call   800342 <_panic>

00802005 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802005:	f3 0f 1e fb          	endbr32 
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80201f:	8b 45 10             	mov    0x10(%ebp),%eax
  802022:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802027:	b8 09 00 00 00       	mov    $0x9,%eax
  80202c:	e8 7d fd ff ff       	call   801dae <nsipc>
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802033:	f3 0f 1e fb          	endbr32 
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	e8 d2 f1 ff ff       	call   80121c <fd2data>
  80204a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80204c:	83 c4 08             	add    $0x8,%esp
  80204f:	68 c8 2d 80 00       	push   $0x802dc8
  802054:	53                   	push   %ebx
  802055:	e8 d9 e9 ff ff       	call   800a33 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80205a:	8b 46 04             	mov    0x4(%esi),%eax
  80205d:	2b 06                	sub    (%esi),%eax
  80205f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802065:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80206c:	00 00 00 
	stat->st_dev = &devpipe;
  80206f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802076:	30 80 00 
	return 0;
}
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802081:	5b                   	pop    %ebx
  802082:	5e                   	pop    %esi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802085:	f3 0f 1e fb          	endbr32 
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	53                   	push   %ebx
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802093:	53                   	push   %ebx
  802094:	6a 00                	push   $0x0
  802096:	e8 67 ee ff ff       	call   800f02 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80209b:	89 1c 24             	mov    %ebx,(%esp)
  80209e:	e8 79 f1 ff ff       	call   80121c <fd2data>
  8020a3:	83 c4 08             	add    $0x8,%esp
  8020a6:	50                   	push   %eax
  8020a7:	6a 00                	push   $0x0
  8020a9:	e8 54 ee ff ff       	call   800f02 <sys_page_unmap>
}
  8020ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <_pipeisclosed>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	57                   	push   %edi
  8020b7:	56                   	push   %esi
  8020b8:	53                   	push   %ebx
  8020b9:	83 ec 1c             	sub    $0x1c,%esp
  8020bc:	89 c7                	mov    %eax,%edi
  8020be:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020c0:	a1 20 44 80 00       	mov    0x804420,%eax
  8020c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020c8:	83 ec 0c             	sub    $0xc,%esp
  8020cb:	57                   	push   %edi
  8020cc:	e8 66 05 00 00       	call   802637 <pageref>
  8020d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020d4:	89 34 24             	mov    %esi,(%esp)
  8020d7:	e8 5b 05 00 00       	call   802637 <pageref>
		nn = thisenv->env_runs;
  8020dc:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8020e2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	39 cb                	cmp    %ecx,%ebx
  8020ea:	74 1b                	je     802107 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020ec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020ef:	75 cf                	jne    8020c0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020f1:	8b 42 58             	mov    0x58(%edx),%eax
  8020f4:	6a 01                	push   $0x1
  8020f6:	50                   	push   %eax
  8020f7:	53                   	push   %ebx
  8020f8:	68 cf 2d 80 00       	push   $0x802dcf
  8020fd:	e8 27 e3 ff ff       	call   800429 <cprintf>
  802102:	83 c4 10             	add    $0x10,%esp
  802105:	eb b9                	jmp    8020c0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802107:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80210a:	0f 94 c0             	sete   %al
  80210d:	0f b6 c0             	movzbl %al,%eax
}
  802110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5f                   	pop    %edi
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    

00802118 <devpipe_write>:
{
  802118:	f3 0f 1e fb          	endbr32 
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	57                   	push   %edi
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 28             	sub    $0x28,%esp
  802125:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802128:	56                   	push   %esi
  802129:	e8 ee f0 ff ff       	call   80121c <fd2data>
  80212e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	bf 00 00 00 00       	mov    $0x0,%edi
  802138:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80213b:	74 4f                	je     80218c <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80213d:	8b 43 04             	mov    0x4(%ebx),%eax
  802140:	8b 0b                	mov    (%ebx),%ecx
  802142:	8d 51 20             	lea    0x20(%ecx),%edx
  802145:	39 d0                	cmp    %edx,%eax
  802147:	72 14                	jb     80215d <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802149:	89 da                	mov    %ebx,%edx
  80214b:	89 f0                	mov    %esi,%eax
  80214d:	e8 61 ff ff ff       	call   8020b3 <_pipeisclosed>
  802152:	85 c0                	test   %eax,%eax
  802154:	75 3b                	jne    802191 <devpipe_write+0x79>
			sys_yield();
  802156:	e8 f7 ec ff ff       	call   800e52 <sys_yield>
  80215b:	eb e0                	jmp    80213d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80215d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802160:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802164:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802167:	89 c2                	mov    %eax,%edx
  802169:	c1 fa 1f             	sar    $0x1f,%edx
  80216c:	89 d1                	mov    %edx,%ecx
  80216e:	c1 e9 1b             	shr    $0x1b,%ecx
  802171:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802174:	83 e2 1f             	and    $0x1f,%edx
  802177:	29 ca                	sub    %ecx,%edx
  802179:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80217d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802181:	83 c0 01             	add    $0x1,%eax
  802184:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802187:	83 c7 01             	add    $0x1,%edi
  80218a:	eb ac                	jmp    802138 <devpipe_write+0x20>
	return i;
  80218c:	8b 45 10             	mov    0x10(%ebp),%eax
  80218f:	eb 05                	jmp    802196 <devpipe_write+0x7e>
				return 0;
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802196:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802199:	5b                   	pop    %ebx
  80219a:	5e                   	pop    %esi
  80219b:	5f                   	pop    %edi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <devpipe_read>:
{
  80219e:	f3 0f 1e fb          	endbr32 
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	57                   	push   %edi
  8021a6:	56                   	push   %esi
  8021a7:	53                   	push   %ebx
  8021a8:	83 ec 18             	sub    $0x18,%esp
  8021ab:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8021ae:	57                   	push   %edi
  8021af:	e8 68 f0 ff ff       	call   80121c <fd2data>
  8021b4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	be 00 00 00 00       	mov    $0x0,%esi
  8021be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c1:	75 14                	jne    8021d7 <devpipe_read+0x39>
	return i;
  8021c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c6:	eb 02                	jmp    8021ca <devpipe_read+0x2c>
				return i;
  8021c8:	89 f0                	mov    %esi,%eax
}
  8021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021cd:	5b                   	pop    %ebx
  8021ce:	5e                   	pop    %esi
  8021cf:	5f                   	pop    %edi
  8021d0:	5d                   	pop    %ebp
  8021d1:	c3                   	ret    
			sys_yield();
  8021d2:	e8 7b ec ff ff       	call   800e52 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021d7:	8b 03                	mov    (%ebx),%eax
  8021d9:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021dc:	75 18                	jne    8021f6 <devpipe_read+0x58>
			if (i > 0)
  8021de:	85 f6                	test   %esi,%esi
  8021e0:	75 e6                	jne    8021c8 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021e2:	89 da                	mov    %ebx,%edx
  8021e4:	89 f8                	mov    %edi,%eax
  8021e6:	e8 c8 fe ff ff       	call   8020b3 <_pipeisclosed>
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	74 e3                	je     8021d2 <devpipe_read+0x34>
				return 0;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	eb d4                	jmp    8021ca <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021f6:	99                   	cltd   
  8021f7:	c1 ea 1b             	shr    $0x1b,%edx
  8021fa:	01 d0                	add    %edx,%eax
  8021fc:	83 e0 1f             	and    $0x1f,%eax
  8021ff:	29 d0                	sub    %edx,%eax
  802201:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802209:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80220c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80220f:	83 c6 01             	add    $0x1,%esi
  802212:	eb aa                	jmp    8021be <devpipe_read+0x20>

00802214 <pipe>:
{
  802214:	f3 0f 1e fb          	endbr32 
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	56                   	push   %esi
  80221c:	53                   	push   %ebx
  80221d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802220:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802223:	50                   	push   %eax
  802224:	e8 0e f0 ff ff       	call   801237 <fd_alloc>
  802229:	89 c3                	mov    %eax,%ebx
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	85 c0                	test   %eax,%eax
  802230:	0f 88 23 01 00 00    	js     802359 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	68 07 04 00 00       	push   $0x407
  80223e:	ff 75 f4             	pushl  -0xc(%ebp)
  802241:	6a 00                	push   $0x0
  802243:	e8 2d ec ff ff       	call   800e75 <sys_page_alloc>
  802248:	89 c3                	mov    %eax,%ebx
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	0f 88 04 01 00 00    	js     802359 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80225b:	50                   	push   %eax
  80225c:	e8 d6 ef ff ff       	call   801237 <fd_alloc>
  802261:	89 c3                	mov    %eax,%ebx
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	0f 88 db 00 00 00    	js     802349 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 07 04 00 00       	push   $0x407
  802276:	ff 75 f0             	pushl  -0x10(%ebp)
  802279:	6a 00                	push   $0x0
  80227b:	e8 f5 eb ff ff       	call   800e75 <sys_page_alloc>
  802280:	89 c3                	mov    %eax,%ebx
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	85 c0                	test   %eax,%eax
  802287:	0f 88 bc 00 00 00    	js     802349 <pipe+0x135>
	va = fd2data(fd0);
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	ff 75 f4             	pushl  -0xc(%ebp)
  802293:	e8 84 ef ff ff       	call   80121c <fd2data>
  802298:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229a:	83 c4 0c             	add    $0xc,%esp
  80229d:	68 07 04 00 00       	push   $0x407
  8022a2:	50                   	push   %eax
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 cb eb ff ff       	call   800e75 <sys_page_alloc>
  8022aa:	89 c3                	mov    %eax,%ebx
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	0f 88 82 00 00 00    	js     802339 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8022bd:	e8 5a ef ff ff       	call   80121c <fd2data>
  8022c2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022c9:	50                   	push   %eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	56                   	push   %esi
  8022cd:	6a 00                	push   $0x0
  8022cf:	e8 e8 eb ff ff       	call   800ebc <sys_page_map>
  8022d4:	89 c3                	mov    %eax,%ebx
  8022d6:	83 c4 20             	add    $0x20,%esp
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	78 4e                	js     80232b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022dd:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8022e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ea:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802300:	83 ec 0c             	sub    $0xc,%esp
  802303:	ff 75 f4             	pushl  -0xc(%ebp)
  802306:	e8 fd ee ff ff       	call   801208 <fd2num>
  80230b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802310:	83 c4 04             	add    $0x4,%esp
  802313:	ff 75 f0             	pushl  -0x10(%ebp)
  802316:	e8 ed ee ff ff       	call   801208 <fd2num>
  80231b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	bb 00 00 00 00       	mov    $0x0,%ebx
  802329:	eb 2e                	jmp    802359 <pipe+0x145>
	sys_page_unmap(0, va);
  80232b:	83 ec 08             	sub    $0x8,%esp
  80232e:	56                   	push   %esi
  80232f:	6a 00                	push   $0x0
  802331:	e8 cc eb ff ff       	call   800f02 <sys_page_unmap>
  802336:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802339:	83 ec 08             	sub    $0x8,%esp
  80233c:	ff 75 f0             	pushl  -0x10(%ebp)
  80233f:	6a 00                	push   $0x0
  802341:	e8 bc eb ff ff       	call   800f02 <sys_page_unmap>
  802346:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802349:	83 ec 08             	sub    $0x8,%esp
  80234c:	ff 75 f4             	pushl  -0xc(%ebp)
  80234f:	6a 00                	push   $0x0
  802351:	e8 ac eb ff ff       	call   800f02 <sys_page_unmap>
  802356:	83 c4 10             	add    $0x10,%esp
}
  802359:	89 d8                	mov    %ebx,%eax
  80235b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235e:	5b                   	pop    %ebx
  80235f:	5e                   	pop    %esi
  802360:	5d                   	pop    %ebp
  802361:	c3                   	ret    

00802362 <pipeisclosed>:
{
  802362:	f3 0f 1e fb          	endbr32 
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80236c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236f:	50                   	push   %eax
  802370:	ff 75 08             	pushl  0x8(%ebp)
  802373:	e8 15 ef ff ff       	call   80128d <fd_lookup>
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	85 c0                	test   %eax,%eax
  80237d:	78 18                	js     802397 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	ff 75 f4             	pushl  -0xc(%ebp)
  802385:	e8 92 ee ff ff       	call   80121c <fd2data>
  80238a:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	e8 1f fd ff ff       	call   8020b3 <_pipeisclosed>
  802394:	83 c4 10             	add    $0x10,%esp
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802399:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	c3                   	ret    

008023a3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023a3:	f3 0f 1e fb          	endbr32 
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023ad:	68 e7 2d 80 00       	push   $0x802de7
  8023b2:	ff 75 0c             	pushl  0xc(%ebp)
  8023b5:	e8 79 e6 ff ff       	call   800a33 <strcpy>
	return 0;
}
  8023ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <devcons_write>:
{
  8023c1:	f3 0f 1e fb          	endbr32 
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	57                   	push   %edi
  8023c9:	56                   	push   %esi
  8023ca:	53                   	push   %ebx
  8023cb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023d1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023dc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023df:	73 31                	jae    802412 <devcons_write+0x51>
		m = n - tot;
  8023e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023e4:	29 f3                	sub    %esi,%ebx
  8023e6:	83 fb 7f             	cmp    $0x7f,%ebx
  8023e9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023ee:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	53                   	push   %ebx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	03 45 0c             	add    0xc(%ebp),%eax
  8023fa:	50                   	push   %eax
  8023fb:	57                   	push   %edi
  8023fc:	e8 e8 e7 ff ff       	call   800be9 <memmove>
		sys_cputs(buf, m);
  802401:	83 c4 08             	add    $0x8,%esp
  802404:	53                   	push   %ebx
  802405:	57                   	push   %edi
  802406:	e8 9a e9 ff ff       	call   800da5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80240b:	01 de                	add    %ebx,%esi
  80240d:	83 c4 10             	add    $0x10,%esp
  802410:	eb ca                	jmp    8023dc <devcons_write+0x1b>
}
  802412:	89 f0                	mov    %esi,%eax
  802414:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    

0080241c <devcons_read>:
{
  80241c:	f3 0f 1e fb          	endbr32 
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 08             	sub    $0x8,%esp
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80242b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80242f:	74 21                	je     802452 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802431:	e8 91 e9 ff ff       	call   800dc7 <sys_cgetc>
  802436:	85 c0                	test   %eax,%eax
  802438:	75 07                	jne    802441 <devcons_read+0x25>
		sys_yield();
  80243a:	e8 13 ea ff ff       	call   800e52 <sys_yield>
  80243f:	eb f0                	jmp    802431 <devcons_read+0x15>
	if (c < 0)
  802441:	78 0f                	js     802452 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802443:	83 f8 04             	cmp    $0x4,%eax
  802446:	74 0c                	je     802454 <devcons_read+0x38>
	*(char*)vbuf = c;
  802448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244b:	88 02                	mov    %al,(%edx)
	return 1;
  80244d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    
		return 0;
  802454:	b8 00 00 00 00       	mov    $0x0,%eax
  802459:	eb f7                	jmp    802452 <devcons_read+0x36>

0080245b <cputchar>:
{
  80245b:	f3 0f 1e fb          	endbr32 
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80246b:	6a 01                	push   $0x1
  80246d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802470:	50                   	push   %eax
  802471:	e8 2f e9 ff ff       	call   800da5 <sys_cputs>
}
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <getchar>:
{
  80247b:	f3 0f 1e fb          	endbr32 
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802485:	6a 01                	push   $0x1
  802487:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80248a:	50                   	push   %eax
  80248b:	6a 00                	push   $0x0
  80248d:	e8 83 f0 ff ff       	call   801515 <read>
	if (r < 0)
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	85 c0                	test   %eax,%eax
  802497:	78 06                	js     80249f <getchar+0x24>
	if (r < 1)
  802499:	74 06                	je     8024a1 <getchar+0x26>
	return c;
  80249b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    
		return -E_EOF;
  8024a1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024a6:	eb f7                	jmp    80249f <getchar+0x24>

008024a8 <iscons>:
{
  8024a8:	f3 0f 1e fb          	endbr32 
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b5:	50                   	push   %eax
  8024b6:	ff 75 08             	pushl  0x8(%ebp)
  8024b9:	e8 cf ed ff ff       	call   80128d <fd_lookup>
  8024be:	83 c4 10             	add    $0x10,%esp
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	78 11                	js     8024d6 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024ce:	39 10                	cmp    %edx,(%eax)
  8024d0:	0f 94 c0             	sete   %al
  8024d3:	0f b6 c0             	movzbl %al,%eax
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <opencons>:
{
  8024d8:	f3 0f 1e fb          	endbr32 
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e5:	50                   	push   %eax
  8024e6:	e8 4c ed ff ff       	call   801237 <fd_alloc>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 3a                	js     80252c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f2:	83 ec 04             	sub    $0x4,%esp
  8024f5:	68 07 04 00 00       	push   $0x407
  8024fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8024fd:	6a 00                	push   $0x0
  8024ff:	e8 71 e9 ff ff       	call   800e75 <sys_page_alloc>
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	85 c0                	test   %eax,%eax
  802509:	78 21                	js     80252c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802514:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	50                   	push   %eax
  802524:	e8 df ec ff ff       	call   801208 <fd2num>
  802529:	83 c4 10             	add    $0x10,%esp
}
  80252c:	c9                   	leave  
  80252d:	c3                   	ret    

0080252e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80252e:	f3 0f 1e fb          	endbr32 
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	56                   	push   %esi
  802536:	53                   	push   %ebx
  802537:	8b 75 08             	mov    0x8(%ebp),%esi
  80253a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802540:	83 e8 01             	sub    $0x1,%eax
  802543:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802548:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80254d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802551:	83 ec 0c             	sub    $0xc,%esp
  802554:	50                   	push   %eax
  802555:	e8 e7 ea ff ff       	call   801041 <sys_ipc_recv>
	if (!t) {
  80255a:	83 c4 10             	add    $0x10,%esp
  80255d:	85 c0                	test   %eax,%eax
  80255f:	75 2b                	jne    80258c <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802561:	85 f6                	test   %esi,%esi
  802563:	74 0a                	je     80256f <ipc_recv+0x41>
  802565:	a1 20 44 80 00       	mov    0x804420,%eax
  80256a:	8b 40 74             	mov    0x74(%eax),%eax
  80256d:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80256f:	85 db                	test   %ebx,%ebx
  802571:	74 0a                	je     80257d <ipc_recv+0x4f>
  802573:	a1 20 44 80 00       	mov    0x804420,%eax
  802578:	8b 40 78             	mov    0x78(%eax),%eax
  80257b:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80257d:	a1 20 44 80 00       	mov    0x804420,%eax
  802582:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802585:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802588:	5b                   	pop    %ebx
  802589:	5e                   	pop    %esi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80258c:	85 f6                	test   %esi,%esi
  80258e:	74 06                	je     802596 <ipc_recv+0x68>
  802590:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802596:	85 db                	test   %ebx,%ebx
  802598:	74 eb                	je     802585 <ipc_recv+0x57>
  80259a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8025a0:	eb e3                	jmp    802585 <ipc_recv+0x57>

008025a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025a2:	f3 0f 1e fb          	endbr32 
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	57                   	push   %edi
  8025aa:	56                   	push   %esi
  8025ab:	53                   	push   %ebx
  8025ac:	83 ec 0c             	sub    $0xc,%esp
  8025af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8025b8:	85 db                	test   %ebx,%ebx
  8025ba:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025bf:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8025c2:	ff 75 14             	pushl  0x14(%ebp)
  8025c5:	53                   	push   %ebx
  8025c6:	56                   	push   %esi
  8025c7:	57                   	push   %edi
  8025c8:	e8 4d ea ff ff       	call   80101a <sys_ipc_try_send>
  8025cd:	83 c4 10             	add    $0x10,%esp
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	74 1e                	je     8025f2 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8025d4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025d7:	75 07                	jne    8025e0 <ipc_send+0x3e>
		sys_yield();
  8025d9:	e8 74 e8 ff ff       	call   800e52 <sys_yield>
  8025de:	eb e2                	jmp    8025c2 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8025e0:	50                   	push   %eax
  8025e1:	68 f3 2d 80 00       	push   $0x802df3
  8025e6:	6a 39                	push   $0x39
  8025e8:	68 05 2e 80 00       	push   $0x802e05
  8025ed:	e8 50 dd ff ff       	call   800342 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8025f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f5:	5b                   	pop    %ebx
  8025f6:	5e                   	pop    %esi
  8025f7:	5f                   	pop    %edi
  8025f8:	5d                   	pop    %ebp
  8025f9:	c3                   	ret    

008025fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025fa:	f3 0f 1e fb          	endbr32 
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802604:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802609:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80260c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802612:	8b 52 50             	mov    0x50(%edx),%edx
  802615:	39 ca                	cmp    %ecx,%edx
  802617:	74 11                	je     80262a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802619:	83 c0 01             	add    $0x1,%eax
  80261c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802621:	75 e6                	jne    802609 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	eb 0b                	jmp    802635 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80262a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80262d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802632:	8b 40 48             	mov    0x48(%eax),%eax
}
  802635:	5d                   	pop    %ebp
  802636:	c3                   	ret    

00802637 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802637:	f3 0f 1e fb          	endbr32 
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802641:	89 c2                	mov    %eax,%edx
  802643:	c1 ea 16             	shr    $0x16,%edx
  802646:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80264d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802652:	f6 c1 01             	test   $0x1,%cl
  802655:	74 1c                	je     802673 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802657:	c1 e8 0c             	shr    $0xc,%eax
  80265a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802661:	a8 01                	test   $0x1,%al
  802663:	74 0e                	je     802673 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802665:	c1 e8 0c             	shr    $0xc,%eax
  802668:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80266f:	ef 
  802670:	0f b7 d2             	movzwl %dx,%edx
}
  802673:	89 d0                	mov    %edx,%eax
  802675:	5d                   	pop    %ebp
  802676:	c3                   	ret    
  802677:	66 90                	xchg   %ax,%ax
  802679:	66 90                	xchg   %ax,%ax
  80267b:	66 90                	xchg   %ax,%ax
  80267d:	66 90                	xchg   %ax,%ax
  80267f:	90                   	nop

00802680 <__udivdi3>:
  802680:	f3 0f 1e fb          	endbr32 
  802684:	55                   	push   %ebp
  802685:	57                   	push   %edi
  802686:	56                   	push   %esi
  802687:	53                   	push   %ebx
  802688:	83 ec 1c             	sub    $0x1c,%esp
  80268b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80268f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802693:	8b 74 24 34          	mov    0x34(%esp),%esi
  802697:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80269b:	85 d2                	test   %edx,%edx
  80269d:	75 19                	jne    8026b8 <__udivdi3+0x38>
  80269f:	39 f3                	cmp    %esi,%ebx
  8026a1:	76 4d                	jbe    8026f0 <__udivdi3+0x70>
  8026a3:	31 ff                	xor    %edi,%edi
  8026a5:	89 e8                	mov    %ebp,%eax
  8026a7:	89 f2                	mov    %esi,%edx
  8026a9:	f7 f3                	div    %ebx
  8026ab:	89 fa                	mov    %edi,%edx
  8026ad:	83 c4 1c             	add    $0x1c,%esp
  8026b0:	5b                   	pop    %ebx
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    
  8026b5:	8d 76 00             	lea    0x0(%esi),%esi
  8026b8:	39 f2                	cmp    %esi,%edx
  8026ba:	76 14                	jbe    8026d0 <__udivdi3+0x50>
  8026bc:	31 ff                	xor    %edi,%edi
  8026be:	31 c0                	xor    %eax,%eax
  8026c0:	89 fa                	mov    %edi,%edx
  8026c2:	83 c4 1c             	add    $0x1c,%esp
  8026c5:	5b                   	pop    %ebx
  8026c6:	5e                   	pop    %esi
  8026c7:	5f                   	pop    %edi
  8026c8:	5d                   	pop    %ebp
  8026c9:	c3                   	ret    
  8026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026d0:	0f bd fa             	bsr    %edx,%edi
  8026d3:	83 f7 1f             	xor    $0x1f,%edi
  8026d6:	75 48                	jne    802720 <__udivdi3+0xa0>
  8026d8:	39 f2                	cmp    %esi,%edx
  8026da:	72 06                	jb     8026e2 <__udivdi3+0x62>
  8026dc:	31 c0                	xor    %eax,%eax
  8026de:	39 eb                	cmp    %ebp,%ebx
  8026e0:	77 de                	ja     8026c0 <__udivdi3+0x40>
  8026e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e7:	eb d7                	jmp    8026c0 <__udivdi3+0x40>
  8026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	89 d9                	mov    %ebx,%ecx
  8026f2:	85 db                	test   %ebx,%ebx
  8026f4:	75 0b                	jne    802701 <__udivdi3+0x81>
  8026f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	f7 f3                	div    %ebx
  8026ff:	89 c1                	mov    %eax,%ecx
  802701:	31 d2                	xor    %edx,%edx
  802703:	89 f0                	mov    %esi,%eax
  802705:	f7 f1                	div    %ecx
  802707:	89 c6                	mov    %eax,%esi
  802709:	89 e8                	mov    %ebp,%eax
  80270b:	89 f7                	mov    %esi,%edi
  80270d:	f7 f1                	div    %ecx
  80270f:	89 fa                	mov    %edi,%edx
  802711:	83 c4 1c             	add    $0x1c,%esp
  802714:	5b                   	pop    %ebx
  802715:	5e                   	pop    %esi
  802716:	5f                   	pop    %edi
  802717:	5d                   	pop    %ebp
  802718:	c3                   	ret    
  802719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802720:	89 f9                	mov    %edi,%ecx
  802722:	b8 20 00 00 00       	mov    $0x20,%eax
  802727:	29 f8                	sub    %edi,%eax
  802729:	d3 e2                	shl    %cl,%edx
  80272b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80272f:	89 c1                	mov    %eax,%ecx
  802731:	89 da                	mov    %ebx,%edx
  802733:	d3 ea                	shr    %cl,%edx
  802735:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802739:	09 d1                	or     %edx,%ecx
  80273b:	89 f2                	mov    %esi,%edx
  80273d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802741:	89 f9                	mov    %edi,%ecx
  802743:	d3 e3                	shl    %cl,%ebx
  802745:	89 c1                	mov    %eax,%ecx
  802747:	d3 ea                	shr    %cl,%edx
  802749:	89 f9                	mov    %edi,%ecx
  80274b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80274f:	89 eb                	mov    %ebp,%ebx
  802751:	d3 e6                	shl    %cl,%esi
  802753:	89 c1                	mov    %eax,%ecx
  802755:	d3 eb                	shr    %cl,%ebx
  802757:	09 de                	or     %ebx,%esi
  802759:	89 f0                	mov    %esi,%eax
  80275b:	f7 74 24 08          	divl   0x8(%esp)
  80275f:	89 d6                	mov    %edx,%esi
  802761:	89 c3                	mov    %eax,%ebx
  802763:	f7 64 24 0c          	mull   0xc(%esp)
  802767:	39 d6                	cmp    %edx,%esi
  802769:	72 15                	jb     802780 <__udivdi3+0x100>
  80276b:	89 f9                	mov    %edi,%ecx
  80276d:	d3 e5                	shl    %cl,%ebp
  80276f:	39 c5                	cmp    %eax,%ebp
  802771:	73 04                	jae    802777 <__udivdi3+0xf7>
  802773:	39 d6                	cmp    %edx,%esi
  802775:	74 09                	je     802780 <__udivdi3+0x100>
  802777:	89 d8                	mov    %ebx,%eax
  802779:	31 ff                	xor    %edi,%edi
  80277b:	e9 40 ff ff ff       	jmp    8026c0 <__udivdi3+0x40>
  802780:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802783:	31 ff                	xor    %edi,%edi
  802785:	e9 36 ff ff ff       	jmp    8026c0 <__udivdi3+0x40>
  80278a:	66 90                	xchg   %ax,%ax
  80278c:	66 90                	xchg   %ax,%ax
  80278e:	66 90                	xchg   %ax,%ax

00802790 <__umoddi3>:
  802790:	f3 0f 1e fb          	endbr32 
  802794:	55                   	push   %ebp
  802795:	57                   	push   %edi
  802796:	56                   	push   %esi
  802797:	53                   	push   %ebx
  802798:	83 ec 1c             	sub    $0x1c,%esp
  80279b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80279f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8027a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8027a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	75 19                	jne    8027c8 <__umoddi3+0x38>
  8027af:	39 df                	cmp    %ebx,%edi
  8027b1:	76 5d                	jbe    802810 <__umoddi3+0x80>
  8027b3:	89 f0                	mov    %esi,%eax
  8027b5:	89 da                	mov    %ebx,%edx
  8027b7:	f7 f7                	div    %edi
  8027b9:	89 d0                	mov    %edx,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	83 c4 1c             	add    $0x1c,%esp
  8027c0:	5b                   	pop    %ebx
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	89 f2                	mov    %esi,%edx
  8027ca:	39 d8                	cmp    %ebx,%eax
  8027cc:	76 12                	jbe    8027e0 <__umoddi3+0x50>
  8027ce:	89 f0                	mov    %esi,%eax
  8027d0:	89 da                	mov    %ebx,%edx
  8027d2:	83 c4 1c             	add    $0x1c,%esp
  8027d5:	5b                   	pop    %ebx
  8027d6:	5e                   	pop    %esi
  8027d7:	5f                   	pop    %edi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    
  8027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027e0:	0f bd e8             	bsr    %eax,%ebp
  8027e3:	83 f5 1f             	xor    $0x1f,%ebp
  8027e6:	75 50                	jne    802838 <__umoddi3+0xa8>
  8027e8:	39 d8                	cmp    %ebx,%eax
  8027ea:	0f 82 e0 00 00 00    	jb     8028d0 <__umoddi3+0x140>
  8027f0:	89 d9                	mov    %ebx,%ecx
  8027f2:	39 f7                	cmp    %esi,%edi
  8027f4:	0f 86 d6 00 00 00    	jbe    8028d0 <__umoddi3+0x140>
  8027fa:	89 d0                	mov    %edx,%eax
  8027fc:	89 ca                	mov    %ecx,%edx
  8027fe:	83 c4 1c             	add    $0x1c,%esp
  802801:	5b                   	pop    %ebx
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    
  802806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80280d:	8d 76 00             	lea    0x0(%esi),%esi
  802810:	89 fd                	mov    %edi,%ebp
  802812:	85 ff                	test   %edi,%edi
  802814:	75 0b                	jne    802821 <__umoddi3+0x91>
  802816:	b8 01 00 00 00       	mov    $0x1,%eax
  80281b:	31 d2                	xor    %edx,%edx
  80281d:	f7 f7                	div    %edi
  80281f:	89 c5                	mov    %eax,%ebp
  802821:	89 d8                	mov    %ebx,%eax
  802823:	31 d2                	xor    %edx,%edx
  802825:	f7 f5                	div    %ebp
  802827:	89 f0                	mov    %esi,%eax
  802829:	f7 f5                	div    %ebp
  80282b:	89 d0                	mov    %edx,%eax
  80282d:	31 d2                	xor    %edx,%edx
  80282f:	eb 8c                	jmp    8027bd <__umoddi3+0x2d>
  802831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802838:	89 e9                	mov    %ebp,%ecx
  80283a:	ba 20 00 00 00       	mov    $0x20,%edx
  80283f:	29 ea                	sub    %ebp,%edx
  802841:	d3 e0                	shl    %cl,%eax
  802843:	89 44 24 08          	mov    %eax,0x8(%esp)
  802847:	89 d1                	mov    %edx,%ecx
  802849:	89 f8                	mov    %edi,%eax
  80284b:	d3 e8                	shr    %cl,%eax
  80284d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802851:	89 54 24 04          	mov    %edx,0x4(%esp)
  802855:	8b 54 24 04          	mov    0x4(%esp),%edx
  802859:	09 c1                	or     %eax,%ecx
  80285b:	89 d8                	mov    %ebx,%eax
  80285d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802861:	89 e9                	mov    %ebp,%ecx
  802863:	d3 e7                	shl    %cl,%edi
  802865:	89 d1                	mov    %edx,%ecx
  802867:	d3 e8                	shr    %cl,%eax
  802869:	89 e9                	mov    %ebp,%ecx
  80286b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80286f:	d3 e3                	shl    %cl,%ebx
  802871:	89 c7                	mov    %eax,%edi
  802873:	89 d1                	mov    %edx,%ecx
  802875:	89 f0                	mov    %esi,%eax
  802877:	d3 e8                	shr    %cl,%eax
  802879:	89 e9                	mov    %ebp,%ecx
  80287b:	89 fa                	mov    %edi,%edx
  80287d:	d3 e6                	shl    %cl,%esi
  80287f:	09 d8                	or     %ebx,%eax
  802881:	f7 74 24 08          	divl   0x8(%esp)
  802885:	89 d1                	mov    %edx,%ecx
  802887:	89 f3                	mov    %esi,%ebx
  802889:	f7 64 24 0c          	mull   0xc(%esp)
  80288d:	89 c6                	mov    %eax,%esi
  80288f:	89 d7                	mov    %edx,%edi
  802891:	39 d1                	cmp    %edx,%ecx
  802893:	72 06                	jb     80289b <__umoddi3+0x10b>
  802895:	75 10                	jne    8028a7 <__umoddi3+0x117>
  802897:	39 c3                	cmp    %eax,%ebx
  802899:	73 0c                	jae    8028a7 <__umoddi3+0x117>
  80289b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80289f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8028a3:	89 d7                	mov    %edx,%edi
  8028a5:	89 c6                	mov    %eax,%esi
  8028a7:	89 ca                	mov    %ecx,%edx
  8028a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8028ae:	29 f3                	sub    %esi,%ebx
  8028b0:	19 fa                	sbb    %edi,%edx
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	d3 e0                	shl    %cl,%eax
  8028b6:	89 e9                	mov    %ebp,%ecx
  8028b8:	d3 eb                	shr    %cl,%ebx
  8028ba:	d3 ea                	shr    %cl,%edx
  8028bc:	09 d8                	or     %ebx,%eax
  8028be:	83 c4 1c             	add    $0x1c,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5f                   	pop    %edi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    
  8028c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	29 fe                	sub    %edi,%esi
  8028d2:	19 c3                	sbb    %eax,%ebx
  8028d4:	89 f2                	mov    %esi,%edx
  8028d6:	89 d9                	mov    %ebx,%ecx
  8028d8:	e9 1d ff ff ff       	jmp    8027fa <__umoddi3+0x6a>
