
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 ad 01 00 00       	call   8001de <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	6a 07                	push   $0x7
  800047:	53                   	push   %ebx
  800048:	56                   	push   %esi
  800049:	e8 2b 0d 00 00       	call   800d79 <sys_page_alloc>
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	78 4a                	js     80009f <duppage+0x6c>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800055:	83 ec 0c             	sub    $0xc,%esp
  800058:	6a 07                	push   $0x7
  80005a:	68 00 00 40 00       	push   $0x400000
  80005f:	6a 00                	push   $0x0
  800061:	53                   	push   %ebx
  800062:	56                   	push   %esi
  800063:	e8 58 0d 00 00       	call   800dc0 <sys_page_map>
  800068:	83 c4 20             	add    $0x20,%esp
  80006b:	85 c0                	test   %eax,%eax
  80006d:	78 42                	js     8000b1 <duppage+0x7e>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	68 00 10 00 00       	push   $0x1000
  800077:	53                   	push   %ebx
  800078:	68 00 00 40 00       	push   $0x400000
  80007d:	e8 6b 0a 00 00       	call   800aed <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  800082:	83 c4 08             	add    $0x8,%esp
  800085:	68 00 00 40 00       	push   $0x400000
  80008a:	6a 00                	push   $0x0
  80008c:	e8 75 0d 00 00       	call   800e06 <sys_page_unmap>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	78 2b                	js     8000c3 <duppage+0x90>
		panic("sys_page_unmap: %e", r);
}
  800098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5e                   	pop    %esi
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009f:	50                   	push   %eax
  8000a0:	68 60 25 80 00       	push   $0x802560
  8000a5:	6a 20                	push   $0x20
  8000a7:	68 73 25 80 00       	push   $0x802573
  8000ac:	e8 95 01 00 00       	call   800246 <_panic>
		panic("sys_page_map: %e", r);
  8000b1:	50                   	push   %eax
  8000b2:	68 83 25 80 00       	push   $0x802583
  8000b7:	6a 22                	push   $0x22
  8000b9:	68 73 25 80 00       	push   $0x802573
  8000be:	e8 83 01 00 00       	call   800246 <_panic>
		panic("sys_page_unmap: %e", r);
  8000c3:	50                   	push   %eax
  8000c4:	68 94 25 80 00       	push   $0x802594
  8000c9:	6a 25                	push   $0x25
  8000cb:	68 73 25 80 00       	push   $0x802573
  8000d0:	e8 71 01 00 00       	call   800246 <_panic>

008000d5 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d5:	f3 0f 1e fb          	endbr32 
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	56                   	push   %esi
  8000dd:	53                   	push   %ebx
  8000de:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000e1:	b8 07 00 00 00       	mov    $0x7,%eax
  8000e6:	cd 30                	int    $0x30
  8000e8:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	78 0d                	js     8000fb <dumbfork+0x26>
  8000ee:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000f0:	74 1b                	je     80010d <dumbfork+0x38>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000f2:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f9:	eb 3f                	jmp    80013a <dumbfork+0x65>
		panic("sys_exofork: %e", envid);
  8000fb:	50                   	push   %eax
  8000fc:	68 a7 25 80 00       	push   $0x8025a7
  800101:	6a 37                	push   $0x37
  800103:	68 73 25 80 00       	push   $0x802573
  800108:	e8 39 01 00 00       	call   800246 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 21 0c 00 00       	call   800d33 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800124:	eb 43                	jmp    800169 <dumbfork+0x94>
		duppage(envid, addr);
  800126:	83 ec 08             	sub    $0x8,%esp
  800129:	52                   	push   %edx
  80012a:	56                   	push   %esi
  80012b:	e8 03 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800130:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80013d:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  800143:	72 e1                	jb     800126 <dumbfork+0x51>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80014b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800150:	50                   	push   %eax
  800151:	53                   	push   %ebx
  800152:	e8 dc fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800157:	83 c4 08             	add    $0x8,%esp
  80015a:	6a 02                	push   $0x2
  80015c:	53                   	push   %ebx
  80015d:	e8 ea 0c 00 00       	call   800e4c <sys_env_set_status>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	78 09                	js     800172 <dumbfork+0x9d>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800169:	89 d8                	mov    %ebx,%eax
  80016b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80016e:	5b                   	pop    %ebx
  80016f:	5e                   	pop    %esi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  800172:	50                   	push   %eax
  800173:	68 b7 25 80 00       	push   $0x8025b7
  800178:	6a 4c                	push   $0x4c
  80017a:	68 73 25 80 00       	push   $0x802573
  80017f:	e8 c2 00 00 00       	call   800246 <_panic>

00800184 <umain>:
{
  800184:	f3 0f 1e fb          	endbr32 
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	57                   	push   %edi
  80018c:	56                   	push   %esi
  80018d:	53                   	push   %ebx
  80018e:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800191:	e8 3f ff ff ff       	call   8000d5 <dumbfork>
  800196:	89 c6                	mov    %eax,%esi
  800198:	85 c0                	test   %eax,%eax
  80019a:	bf ce 25 80 00       	mov    $0x8025ce,%edi
  80019f:	b8 d5 25 80 00       	mov    $0x8025d5,%eax
  8001a4:	0f 44 f8             	cmove  %eax,%edi
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ac:	eb 1f                	jmp    8001cd <umain+0x49>
  8001ae:	83 fb 13             	cmp    $0x13,%ebx
  8001b1:	7f 23                	jg     8001d6 <umain+0x52>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	57                   	push   %edi
  8001b7:	53                   	push   %ebx
  8001b8:	68 db 25 80 00       	push   $0x8025db
  8001bd:	e8 6b 01 00 00       	call   80032d <cprintf>
		sys_yield();
  8001c2:	e8 8f 0b 00 00       	call   800d56 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001c7:	83 c3 01             	add    $0x1,%ebx
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	85 f6                	test   %esi,%esi
  8001cf:	74 dd                	je     8001ae <umain+0x2a>
  8001d1:	83 fb 09             	cmp    $0x9,%ebx
  8001d4:	7e dd                	jle    8001b3 <umain+0x2f>
}
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    

008001de <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001de:	f3 0f 1e fb          	endbr32 
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ea:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ed:	e8 41 0b 00 00       	call   800d33 <sys_getenvid>
  8001f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ff:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800204:	85 db                	test   %ebx,%ebx
  800206:	7e 07                	jle    80020f <libmain+0x31>
		binaryname = argv[0];
  800208:	8b 06                	mov    (%esi),%eax
  80020a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	56                   	push   %esi
  800213:	53                   	push   %ebx
  800214:	e8 6b ff ff ff       	call   800184 <umain>

	// exit gracefully
	exit();
  800219:	e8 0a 00 00 00       	call   800228 <exit>
}
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800232:	e8 6a 0f 00 00       	call   8011a1 <close_all>
	sys_env_destroy(0);
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	6a 00                	push   $0x0
  80023c:	e8 ad 0a 00 00       	call   800cee <sys_env_destroy>
}
  800241:	83 c4 10             	add    $0x10,%esp
  800244:	c9                   	leave  
  800245:	c3                   	ret    

00800246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800246:	f3 0f 1e fb          	endbr32 
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800252:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800258:	e8 d6 0a 00 00       	call   800d33 <sys_getenvid>
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	56                   	push   %esi
  800267:	50                   	push   %eax
  800268:	68 f8 25 80 00       	push   $0x8025f8
  80026d:	e8 bb 00 00 00       	call   80032d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800272:	83 c4 18             	add    $0x18,%esp
  800275:	53                   	push   %ebx
  800276:	ff 75 10             	pushl  0x10(%ebp)
  800279:	e8 5a 00 00 00       	call   8002d8 <vcprintf>
	cprintf("\n");
  80027e:	c7 04 24 eb 25 80 00 	movl   $0x8025eb,(%esp)
  800285:	e8 a3 00 00 00       	call   80032d <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028d:	cc                   	int3   
  80028e:	eb fd                	jmp    80028d <_panic+0x47>

00800290 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800290:	f3 0f 1e fb          	endbr32 
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	53                   	push   %ebx
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029e:	8b 13                	mov    (%ebx),%edx
  8002a0:	8d 42 01             	lea    0x1(%edx),%eax
  8002a3:	89 03                	mov    %eax,(%ebx)
  8002a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ac:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b1:	74 09                	je     8002bc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	68 ff 00 00 00       	push   $0xff
  8002c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c7:	50                   	push   %eax
  8002c8:	e8 dc 09 00 00       	call   800ca9 <sys_cputs>
		b->idx = 0;
  8002cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	eb db                	jmp    8002b3 <putch+0x23>

008002d8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d8:	f3 0f 1e fb          	endbr32 
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ec:	00 00 00 
	b.cnt = 0;
  8002ef:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f9:	ff 75 0c             	pushl  0xc(%ebp)
  8002fc:	ff 75 08             	pushl  0x8(%ebp)
  8002ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800305:	50                   	push   %eax
  800306:	68 90 02 80 00       	push   $0x800290
  80030b:	e8 20 01 00 00       	call   800430 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800310:	83 c4 08             	add    $0x8,%esp
  800313:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800319:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031f:	50                   	push   %eax
  800320:	e8 84 09 00 00       	call   800ca9 <sys_cputs>

	return b.cnt;
}
  800325:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032d:	f3 0f 1e fb          	endbr32 
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800337:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80033a:	50                   	push   %eax
  80033b:	ff 75 08             	pushl  0x8(%ebp)
  80033e:	e8 95 ff ff ff       	call   8002d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	57                   	push   %edi
  800349:	56                   	push   %esi
  80034a:	53                   	push   %ebx
  80034b:	83 ec 1c             	sub    $0x1c,%esp
  80034e:	89 c7                	mov    %eax,%edi
  800350:	89 d6                	mov    %edx,%esi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	8b 55 0c             	mov    0xc(%ebp),%edx
  800358:	89 d1                	mov    %edx,%ecx
  80035a:	89 c2                	mov    %eax,%edx
  80035c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800362:	8b 45 10             	mov    0x10(%ebp),%eax
  800365:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800368:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80036b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800372:	39 c2                	cmp    %eax,%edx
  800374:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800377:	72 3e                	jb     8003b7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	83 eb 01             	sub    $0x1,%ebx
  800382:	53                   	push   %ebx
  800383:	50                   	push   %eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038a:	ff 75 e0             	pushl  -0x20(%ebp)
  80038d:	ff 75 dc             	pushl  -0x24(%ebp)
  800390:	ff 75 d8             	pushl  -0x28(%ebp)
  800393:	e8 68 1f 00 00       	call   802300 <__udivdi3>
  800398:	83 c4 18             	add    $0x18,%esp
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	89 f2                	mov    %esi,%edx
  80039f:	89 f8                	mov    %edi,%eax
  8003a1:	e8 9f ff ff ff       	call   800345 <printnum>
  8003a6:	83 c4 20             	add    $0x20,%esp
  8003a9:	eb 13                	jmp    8003be <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	56                   	push   %esi
  8003af:	ff 75 18             	pushl  0x18(%ebp)
  8003b2:	ff d7                	call   *%edi
  8003b4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b7:	83 eb 01             	sub    $0x1,%ebx
  8003ba:	85 db                	test   %ebx,%ebx
  8003bc:	7f ed                	jg     8003ab <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	56                   	push   %esi
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003cb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	e8 3a 20 00 00       	call   802410 <__umoddi3>
  8003d6:	83 c4 14             	add    $0x14,%esp
  8003d9:	0f be 80 1b 26 80 00 	movsbl 0x80261b(%eax),%eax
  8003e0:	50                   	push   %eax
  8003e1:	ff d7                	call   *%edi
}
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5f                   	pop    %edi
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	f3 0f 1e fb          	endbr32 
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003fc:	8b 10                	mov    (%eax),%edx
  8003fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800401:	73 0a                	jae    80040d <sprintputch+0x1f>
		*b->buf++ = ch;
  800403:	8d 4a 01             	lea    0x1(%edx),%ecx
  800406:	89 08                	mov    %ecx,(%eax)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	88 02                	mov    %al,(%edx)
}
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <printfmt>:
{
  80040f:	f3 0f 1e fb          	endbr32 
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800419:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041c:	50                   	push   %eax
  80041d:	ff 75 10             	pushl  0x10(%ebp)
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 08             	pushl  0x8(%ebp)
  800426:	e8 05 00 00 00       	call   800430 <vprintfmt>
}
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <vprintfmt>:
{
  800430:	f3 0f 1e fb          	endbr32 
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	57                   	push   %edi
  800438:	56                   	push   %esi
  800439:	53                   	push   %ebx
  80043a:	83 ec 3c             	sub    $0x3c,%esp
  80043d:	8b 75 08             	mov    0x8(%ebp),%esi
  800440:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800443:	8b 7d 10             	mov    0x10(%ebp),%edi
  800446:	e9 8e 03 00 00       	jmp    8007d9 <vprintfmt+0x3a9>
		padc = ' ';
  80044b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80044f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800456:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80045d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800464:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8d 47 01             	lea    0x1(%edi),%eax
  80046c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046f:	0f b6 17             	movzbl (%edi),%edx
  800472:	8d 42 dd             	lea    -0x23(%edx),%eax
  800475:	3c 55                	cmp    $0x55,%al
  800477:	0f 87 df 03 00 00    	ja     80085c <vprintfmt+0x42c>
  80047d:	0f b6 c0             	movzbl %al,%eax
  800480:	3e ff 24 85 60 27 80 	notrack jmp *0x802760(,%eax,4)
  800487:	00 
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80048b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80048f:	eb d8                	jmp    800469 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800494:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800498:	eb cf                	jmp    800469 <vprintfmt+0x39>
  80049a:	0f b6 d2             	movzbl %dl,%edx
  80049d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ab:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004af:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004b5:	83 f9 09             	cmp    $0x9,%ecx
  8004b8:	77 55                	ja     80050f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004ba:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004bd:	eb e9                	jmp    8004a8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 40 04             	lea    0x4(%eax),%eax
  8004cd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d7:	79 90                	jns    800469 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e6:	eb 81                	jmp    800469 <vprintfmt+0x39>
  8004e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f2:	0f 49 d0             	cmovns %eax,%edx
  8004f5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004fb:	e9 69 ff ff ff       	jmp    800469 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800503:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80050a:	e9 5a ff ff ff       	jmp    800469 <vprintfmt+0x39>
  80050f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	eb bc                	jmp    8004d3 <vprintfmt+0xa3>
			lflag++;
  800517:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051d:	e9 47 ff ff ff       	jmp    800469 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800522:	8b 45 14             	mov    0x14(%ebp),%eax
  800525:	8d 78 04             	lea    0x4(%eax),%edi
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	ff 30                	pushl  (%eax)
  80052e:	ff d6                	call   *%esi
			break;
  800530:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800533:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800536:	e9 9b 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 78 04             	lea    0x4(%eax),%edi
  800541:	8b 00                	mov    (%eax),%eax
  800543:	99                   	cltd   
  800544:	31 d0                	xor    %edx,%eax
  800546:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800548:	83 f8 0f             	cmp    $0xf,%eax
  80054b:	7f 23                	jg     800570 <vprintfmt+0x140>
  80054d:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  800554:	85 d2                	test   %edx,%edx
  800556:	74 18                	je     800570 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800558:	52                   	push   %edx
  800559:	68 f5 29 80 00       	push   $0x8029f5
  80055e:	53                   	push   %ebx
  80055f:	56                   	push   %esi
  800560:	e8 aa fe ff ff       	call   80040f <printfmt>
  800565:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800568:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056b:	e9 66 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800570:	50                   	push   %eax
  800571:	68 33 26 80 00       	push   $0x802633
  800576:	53                   	push   %ebx
  800577:	56                   	push   %esi
  800578:	e8 92 fe ff ff       	call   80040f <printfmt>
  80057d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800580:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800583:	e9 4e 02 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	83 c0 04             	add    $0x4,%eax
  80058e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800596:	85 d2                	test   %edx,%edx
  800598:	b8 2c 26 80 00       	mov    $0x80262c,%eax
  80059d:	0f 45 c2             	cmovne %edx,%eax
  8005a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a7:	7e 06                	jle    8005af <vprintfmt+0x17f>
  8005a9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005ad:	75 0d                	jne    8005bc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005b2:	89 c7                	mov    %eax,%edi
  8005b4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ba:	eb 55                	jmp    800611 <vprintfmt+0x1e1>
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c2:	ff 75 cc             	pushl  -0x34(%ebp)
  8005c5:	e8 46 03 00 00       	call   800910 <strnlen>
  8005ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005cd:	29 c2                	sub    %eax,%edx
  8005cf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005d7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005de:	85 ff                	test   %edi,%edi
  8005e0:	7e 11                	jle    8005f3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005eb:	83 ef 01             	sub    $0x1,%edi
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	eb eb                	jmp    8005de <vprintfmt+0x1ae>
  8005f3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fd:	0f 49 c2             	cmovns %edx,%eax
  800600:	29 c2                	sub    %eax,%edx
  800602:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800605:	eb a8                	jmp    8005af <vprintfmt+0x17f>
					putch(ch, putdat);
  800607:	83 ec 08             	sub    $0x8,%esp
  80060a:	53                   	push   %ebx
  80060b:	52                   	push   %edx
  80060c:	ff d6                	call   *%esi
  80060e:	83 c4 10             	add    $0x10,%esp
  800611:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800614:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800616:	83 c7 01             	add    $0x1,%edi
  800619:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061d:	0f be d0             	movsbl %al,%edx
  800620:	85 d2                	test   %edx,%edx
  800622:	74 4b                	je     80066f <vprintfmt+0x23f>
  800624:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800628:	78 06                	js     800630 <vprintfmt+0x200>
  80062a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062e:	78 1e                	js     80064e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800630:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800634:	74 d1                	je     800607 <vprintfmt+0x1d7>
  800636:	0f be c0             	movsbl %al,%eax
  800639:	83 e8 20             	sub    $0x20,%eax
  80063c:	83 f8 5e             	cmp    $0x5e,%eax
  80063f:	76 c6                	jbe    800607 <vprintfmt+0x1d7>
					putch('?', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 3f                	push   $0x3f
  800647:	ff d6                	call   *%esi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb c3                	jmp    800611 <vprintfmt+0x1e1>
  80064e:	89 cf                	mov    %ecx,%edi
  800650:	eb 0e                	jmp    800660 <vprintfmt+0x230>
				putch(' ', putdat);
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	53                   	push   %ebx
  800656:	6a 20                	push   $0x20
  800658:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80065a:	83 ef 01             	sub    $0x1,%edi
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	85 ff                	test   %edi,%edi
  800662:	7f ee                	jg     800652 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800664:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
  80066a:	e9 67 01 00 00       	jmp    8007d6 <vprintfmt+0x3a6>
  80066f:	89 cf                	mov    %ecx,%edi
  800671:	eb ed                	jmp    800660 <vprintfmt+0x230>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1b                	jg     800693 <vprintfmt+0x263>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	74 63                	je     8006df <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800684:	99                   	cltd   
  800685:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	eb 17                	jmp    8006aa <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 50 04             	mov    0x4(%eax),%edx
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 40 08             	lea    0x8(%eax),%eax
  8006a7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ad:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006b0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006b5:	85 c9                	test   %ecx,%ecx
  8006b7:	0f 89 ff 00 00 00    	jns    8007bc <vprintfmt+0x38c>
				putch('-', putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 2d                	push   $0x2d
  8006c3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006cb:	f7 da                	neg    %edx
  8006cd:	83 d1 00             	adc    $0x0,%ecx
  8006d0:	f7 d9                	neg    %ecx
  8006d2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006da:	e9 dd 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	99                   	cltd   
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	eb b4                	jmp    8006aa <vprintfmt+0x27a>
	if (lflag >= 2)
  8006f6:	83 f9 01             	cmp    $0x1,%ecx
  8006f9:	7f 1e                	jg     800719 <vprintfmt+0x2e9>
	else if (lflag)
  8006fb:	85 c9                	test   %ecx,%ecx
  8006fd:	74 32                	je     800731 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	b9 00 00 00 00       	mov    $0x0,%ecx
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800714:	e9 a3 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8b 10                	mov    (%eax),%edx
  80071e:	8b 48 04             	mov    0x4(%eax),%ecx
  800721:	8d 40 08             	lea    0x8(%eax),%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800727:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80072c:	e9 8b 00 00 00       	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 10                	mov    (%eax),%edx
  800736:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073b:	8d 40 04             	lea    0x4(%eax),%eax
  80073e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800741:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800746:	eb 74                	jmp    8007bc <vprintfmt+0x38c>
	if (lflag >= 2)
  800748:	83 f9 01             	cmp    $0x1,%ecx
  80074b:	7f 1b                	jg     800768 <vprintfmt+0x338>
	else if (lflag)
  80074d:	85 c9                	test   %ecx,%ecx
  80074f:	74 2c                	je     80077d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 10                	mov    (%eax),%edx
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800761:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800766:	eb 54                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	8b 48 04             	mov    0x4(%eax),%ecx
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80077b:	eb 3f                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 10                	mov    (%eax),%edx
  800782:	b9 00 00 00 00       	mov    $0x0,%ecx
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800792:	eb 28                	jmp    8007bc <vprintfmt+0x38c>
			putch('0', putdat);
  800794:	83 ec 08             	sub    $0x8,%esp
  800797:	53                   	push   %ebx
  800798:	6a 30                	push   $0x30
  80079a:	ff d6                	call   *%esi
			putch('x', putdat);
  80079c:	83 c4 08             	add    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	6a 78                	push   $0x78
  8007a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
  8007a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007ae:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bc:	83 ec 0c             	sub    $0xc,%esp
  8007bf:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007c3:	57                   	push   %edi
  8007c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	51                   	push   %ecx
  8007c9:	52                   	push   %edx
  8007ca:	89 da                	mov    %ebx,%edx
  8007cc:	89 f0                	mov    %esi,%eax
  8007ce:	e8 72 fb ff ff       	call   800345 <printnum>
			break;
  8007d3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d9:	83 c7 01             	add    $0x1,%edi
  8007dc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e0:	83 f8 25             	cmp    $0x25,%eax
  8007e3:	0f 84 62 fc ff ff    	je     80044b <vprintfmt+0x1b>
			if (ch == '\0')
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	0f 84 8b 00 00 00    	je     80087c <vprintfmt+0x44c>
			putch(ch, putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	50                   	push   %eax
  8007f6:	ff d6                	call   *%esi
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	eb dc                	jmp    8007d9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007fd:	83 f9 01             	cmp    $0x1,%ecx
  800800:	7f 1b                	jg     80081d <vprintfmt+0x3ed>
	else if (lflag)
  800802:	85 c9                	test   %ecx,%ecx
  800804:	74 2c                	je     800832 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	8b 10                	mov    (%eax),%edx
  80080b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800810:	8d 40 04             	lea    0x4(%eax),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800816:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80081b:	eb 9f                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8b 10                	mov    (%eax),%edx
  800822:	8b 48 04             	mov    0x4(%eax),%ecx
  800825:	8d 40 08             	lea    0x8(%eax),%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800830:	eb 8a                	jmp    8007bc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8b 10                	mov    (%eax),%edx
  800837:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083c:	8d 40 04             	lea    0x4(%eax),%eax
  80083f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800842:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800847:	e9 70 ff ff ff       	jmp    8007bc <vprintfmt+0x38c>
			putch(ch, putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			break;
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	e9 7a ff ff ff       	jmp    8007d6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	6a 25                	push   $0x25
  800862:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	89 f8                	mov    %edi,%eax
  800869:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80086d:	74 05                	je     800874 <vprintfmt+0x444>
  80086f:	83 e8 01             	sub    $0x1,%eax
  800872:	eb f5                	jmp    800869 <vprintfmt+0x439>
  800874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800877:	e9 5a ff ff ff       	jmp    8007d6 <vprintfmt+0x3a6>
}
  80087c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087f:	5b                   	pop    %ebx
  800880:	5e                   	pop    %esi
  800881:	5f                   	pop    %edi
  800882:	5d                   	pop    %ebp
  800883:	c3                   	ret    

00800884 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800884:	f3 0f 1e fb          	endbr32 
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 18             	sub    $0x18,%esp
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800897:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 26                	je     8008cf <vsnprintf+0x4b>
  8008a9:	85 d2                	test   %edx,%edx
  8008ab:	7e 22                	jle    8008cf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ad:	ff 75 14             	pushl  0x14(%ebp)
  8008b0:	ff 75 10             	pushl  0x10(%ebp)
  8008b3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b6:	50                   	push   %eax
  8008b7:	68 ee 03 80 00       	push   $0x8003ee
  8008bc:	e8 6f fb ff ff       	call   800430 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
}
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    
		return -E_INVAL;
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d4:	eb f7                	jmp    8008cd <vsnprintf+0x49>

008008d6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d6:	f3 0f 1e fb          	endbr32 
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e3:	50                   	push   %eax
  8008e4:	ff 75 10             	pushl  0x10(%ebp)
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	ff 75 08             	pushl  0x8(%ebp)
  8008ed:	e8 92 ff ff ff       	call   800884 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f4:	f3 0f 1e fb          	endbr32 
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	74 05                	je     80090e <strlen+0x1a>
		n++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	eb f5                	jmp    800903 <strlen+0xf>
	return n;
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800910:	f3 0f 1e fb          	endbr32 
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
  800922:	39 d0                	cmp    %edx,%eax
  800924:	74 0d                	je     800933 <strnlen+0x23>
  800926:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092a:	74 05                	je     800931 <strnlen+0x21>
		n++;
  80092c:	83 c0 01             	add    $0x1,%eax
  80092f:	eb f1                	jmp    800922 <strnlen+0x12>
  800931:	89 c2                	mov    %eax,%edx
	return n;
}
  800933:	89 d0                	mov    %edx,%eax
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80094e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800951:	83 c0 01             	add    $0x1,%eax
  800954:	84 d2                	test   %dl,%dl
  800956:	75 f2                	jne    80094a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800958:	89 c8                	mov    %ecx,%eax
  80095a:	5b                   	pop    %ebx
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095d:	f3 0f 1e fb          	endbr32 
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	53                   	push   %ebx
  800965:	83 ec 10             	sub    $0x10,%esp
  800968:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096b:	53                   	push   %ebx
  80096c:	e8 83 ff ff ff       	call   8008f4 <strlen>
  800971:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	01 d8                	add    %ebx,%eax
  800979:	50                   	push   %eax
  80097a:	e8 b8 ff ff ff       	call   800937 <strcpy>
	return dst;
}
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800984:	c9                   	leave  
  800985:	c3                   	ret    

00800986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800986:	f3 0f 1e fb          	endbr32 
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 75 08             	mov    0x8(%ebp),%esi
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	89 f3                	mov    %esi,%ebx
  800997:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099a:	89 f0                	mov    %esi,%eax
  80099c:	39 d8                	cmp    %ebx,%eax
  80099e:	74 11                	je     8009b1 <strncpy+0x2b>
		*dst++ = *src;
  8009a0:	83 c0 01             	add    $0x1,%eax
  8009a3:	0f b6 0a             	movzbl (%edx),%ecx
  8009a6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a9:	80 f9 01             	cmp    $0x1,%cl
  8009ac:	83 da ff             	sbb    $0xffffffff,%edx
  8009af:	eb eb                	jmp    80099c <strncpy+0x16>
	}
	return ret;
}
  8009b1:	89 f0                	mov    %esi,%eax
  8009b3:	5b                   	pop    %ebx
  8009b4:	5e                   	pop    %esi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b7:	f3 0f 1e fb          	endbr32 
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	74 21                	je     8009f0 <strlcpy+0x39>
  8009cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <strlcpy+0x36>
  8009d9:	0f b6 19             	movzbl (%ecx),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 0b                	je     8009eb <strlcpy+0x34>
			*dst++ = *src++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e9:	eb ea                	jmp    8009d5 <strlcpy+0x1e>
  8009eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	29 f0                	sub    %esi,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a03:	0f b6 01             	movzbl (%ecx),%eax
  800a06:	84 c0                	test   %al,%al
  800a08:	74 0c                	je     800a16 <strcmp+0x20>
  800a0a:	3a 02                	cmp    (%edx),%al
  800a0c:	75 08                	jne    800a16 <strcmp+0x20>
		p++, q++;
  800a0e:	83 c1 01             	add    $0x1,%ecx
  800a11:	83 c2 01             	add    $0x1,%edx
  800a14:	eb ed                	jmp    800a03 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	0f b6 12             	movzbl (%edx),%edx
  800a1c:	29 d0                	sub    %edx,%eax
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a20:	f3 0f 1e fb          	endbr32 
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	53                   	push   %ebx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2e:	89 c3                	mov    %eax,%ebx
  800a30:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a33:	eb 06                	jmp    800a3b <strncmp+0x1b>
		n--, p++, q++;
  800a35:	83 c0 01             	add    $0x1,%eax
  800a38:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3b:	39 d8                	cmp    %ebx,%eax
  800a3d:	74 16                	je     800a55 <strncmp+0x35>
  800a3f:	0f b6 08             	movzbl (%eax),%ecx
  800a42:	84 c9                	test   %cl,%cl
  800a44:	74 04                	je     800a4a <strncmp+0x2a>
  800a46:	3a 0a                	cmp    (%edx),%cl
  800a48:	74 eb                	je     800a35 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4a:	0f b6 00             	movzbl (%eax),%eax
  800a4d:	0f b6 12             	movzbl (%edx),%edx
  800a50:	29 d0                	sub    %edx,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    
		return 0;
  800a55:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5a:	eb f6                	jmp    800a52 <strncmp+0x32>

00800a5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6a:	0f b6 10             	movzbl (%eax),%edx
  800a6d:	84 d2                	test   %dl,%dl
  800a6f:	74 09                	je     800a7a <strchr+0x1e>
		if (*s == c)
  800a71:	38 ca                	cmp    %cl,%dl
  800a73:	74 0a                	je     800a7f <strchr+0x23>
	for (; *s; s++)
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	eb f0                	jmp    800a6a <strchr+0xe>
			return (char *) s;
	return 0;
  800a7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a81:	f3 0f 1e fb          	endbr32 
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	74 09                	je     800a9f <strfind+0x1e>
  800a96:	84 d2                	test   %dl,%dl
  800a98:	74 05                	je     800a9f <strfind+0x1e>
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	eb f0                	jmp    800a8f <strfind+0xe>
			break;
	return (char *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa1:	f3 0f 1e fb          	endbr32 
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	57                   	push   %edi
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab1:	85 c9                	test   %ecx,%ecx
  800ab3:	74 31                	je     800ae6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab5:	89 f8                	mov    %edi,%eax
  800ab7:	09 c8                	or     %ecx,%eax
  800ab9:	a8 03                	test   $0x3,%al
  800abb:	75 23                	jne    800ae0 <memset+0x3f>
		c &= 0xFF;
  800abd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac1:	89 d3                	mov    %edx,%ebx
  800ac3:	c1 e3 08             	shl    $0x8,%ebx
  800ac6:	89 d0                	mov    %edx,%eax
  800ac8:	c1 e0 18             	shl    $0x18,%eax
  800acb:	89 d6                	mov    %edx,%esi
  800acd:	c1 e6 10             	shl    $0x10,%esi
  800ad0:	09 f0                	or     %esi,%eax
  800ad2:	09 c2                	or     %eax,%edx
  800ad4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad9:	89 d0                	mov    %edx,%eax
  800adb:	fc                   	cld    
  800adc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ade:	eb 06                	jmp    800ae6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	fc                   	cld    
  800ae4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae6:	89 f8                	mov    %edi,%eax
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aed:	f3 0f 1e fb          	endbr32 
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	57                   	push   %edi
  800af5:	56                   	push   %esi
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aff:	39 c6                	cmp    %eax,%esi
  800b01:	73 32                	jae    800b35 <memmove+0x48>
  800b03:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b06:	39 c2                	cmp    %eax,%edx
  800b08:	76 2b                	jbe    800b35 <memmove+0x48>
		s += n;
		d += n;
  800b0a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	89 fe                	mov    %edi,%esi
  800b0f:	09 ce                	or     %ecx,%esi
  800b11:	09 d6                	or     %edx,%esi
  800b13:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b19:	75 0e                	jne    800b29 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b1b:	83 ef 04             	sub    $0x4,%edi
  800b1e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b21:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b24:	fd                   	std    
  800b25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b27:	eb 09                	jmp    800b32 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b29:	83 ef 01             	sub    $0x1,%edi
  800b2c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2f:	fd                   	std    
  800b30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b32:	fc                   	cld    
  800b33:	eb 1a                	jmp    800b4f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b35:	89 c2                	mov    %eax,%edx
  800b37:	09 ca                	or     %ecx,%edx
  800b39:	09 f2                	or     %esi,%edx
  800b3b:	f6 c2 03             	test   $0x3,%dl
  800b3e:	75 0a                	jne    800b4a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b40:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b48:	eb 05                	jmp    800b4f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b4a:	89 c7                	mov    %eax,%edi
  800b4c:	fc                   	cld    
  800b4d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b53:	f3 0f 1e fb          	endbr32 
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5d:	ff 75 10             	pushl  0x10(%ebp)
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	ff 75 08             	pushl  0x8(%ebp)
  800b66:	e8 82 ff ff ff       	call   800aed <memmove>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6d:	f3 0f 1e fb          	endbr32 
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c6                	mov    %eax,%esi
  800b7e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b81:	39 f0                	cmp    %esi,%eax
  800b83:	74 1c                	je     800ba1 <memcmp+0x34>
		if (*s1 != *s2)
  800b85:	0f b6 08             	movzbl (%eax),%ecx
  800b88:	0f b6 1a             	movzbl (%edx),%ebx
  800b8b:	38 d9                	cmp    %bl,%cl
  800b8d:	75 08                	jne    800b97 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8f:	83 c0 01             	add    $0x1,%eax
  800b92:	83 c2 01             	add    $0x1,%edx
  800b95:	eb ea                	jmp    800b81 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b97:	0f b6 c1             	movzbl %cl,%eax
  800b9a:	0f b6 db             	movzbl %bl,%ebx
  800b9d:	29 d8                	sub    %ebx,%eax
  800b9f:	eb 05                	jmp    800ba6 <memcmp+0x39>
	}

	return 0;
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb7:	89 c2                	mov    %eax,%edx
  800bb9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bbc:	39 d0                	cmp    %edx,%eax
  800bbe:	73 09                	jae    800bc9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc0:	38 08                	cmp    %cl,(%eax)
  800bc2:	74 05                	je     800bc9 <memfind+0x1f>
	for (; s < ends; s++)
  800bc4:	83 c0 01             	add    $0x1,%eax
  800bc7:	eb f3                	jmp    800bbc <memfind+0x12>
			break;
	return (void *) s;
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	57                   	push   %edi
  800bd3:	56                   	push   %esi
  800bd4:	53                   	push   %ebx
  800bd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdb:	eb 03                	jmp    800be0 <strtol+0x15>
		s++;
  800bdd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800be0:	0f b6 01             	movzbl (%ecx),%eax
  800be3:	3c 20                	cmp    $0x20,%al
  800be5:	74 f6                	je     800bdd <strtol+0x12>
  800be7:	3c 09                	cmp    $0x9,%al
  800be9:	74 f2                	je     800bdd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800beb:	3c 2b                	cmp    $0x2b,%al
  800bed:	74 2a                	je     800c19 <strtol+0x4e>
	int neg = 0;
  800bef:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf4:	3c 2d                	cmp    $0x2d,%al
  800bf6:	74 2b                	je     800c23 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfe:	75 0f                	jne    800c0f <strtol+0x44>
  800c00:	80 39 30             	cmpb   $0x30,(%ecx)
  800c03:	74 28                	je     800c2d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c05:	85 db                	test   %ebx,%ebx
  800c07:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c0c:	0f 44 d8             	cmove  %eax,%ebx
  800c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c14:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c17:	eb 46                	jmp    800c5f <strtol+0x94>
		s++;
  800c19:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c1c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c21:	eb d5                	jmp    800bf8 <strtol+0x2d>
		s++, neg = 1;
  800c23:	83 c1 01             	add    $0x1,%ecx
  800c26:	bf 01 00 00 00       	mov    $0x1,%edi
  800c2b:	eb cb                	jmp    800bf8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c31:	74 0e                	je     800c41 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	75 d8                	jne    800c0f <strtol+0x44>
		s++, base = 8;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3f:	eb ce                	jmp    800c0f <strtol+0x44>
		s += 2, base = 16;
  800c41:	83 c1 02             	add    $0x2,%ecx
  800c44:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c49:	eb c4                	jmp    800c0f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c51:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c54:	7d 3a                	jge    800c90 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c56:	83 c1 01             	add    $0x1,%ecx
  800c59:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5f:	0f b6 11             	movzbl (%ecx),%edx
  800c62:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 09             	cmp    $0x9,%bl
  800c6a:	76 df                	jbe    800c4b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6f:	89 f3                	mov    %esi,%ebx
  800c71:	80 fb 19             	cmp    $0x19,%bl
  800c74:	77 08                	ja     800c7e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c76:	0f be d2             	movsbl %dl,%edx
  800c79:	83 ea 57             	sub    $0x57,%edx
  800c7c:	eb d3                	jmp    800c51 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c7e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c81:	89 f3                	mov    %esi,%ebx
  800c83:	80 fb 19             	cmp    $0x19,%bl
  800c86:	77 08                	ja     800c90 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c88:	0f be d2             	movsbl %dl,%edx
  800c8b:	83 ea 37             	sub    $0x37,%edx
  800c8e:	eb c1                	jmp    800c51 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c94:	74 05                	je     800c9b <strtol+0xd0>
		*endptr = (char *) s;
  800c96:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c99:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c9b:	89 c2                	mov    %eax,%edx
  800c9d:	f7 da                	neg    %edx
  800c9f:	85 ff                	test   %edi,%edi
  800ca1:	0f 45 c2             	cmovne %edx,%eax
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca9:	f3 0f 1e fb          	endbr32 
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbe:	89 c3                	mov    %eax,%ebx
  800cc0:	89 c7                	mov    %eax,%edi
  800cc2:	89 c6                	mov    %eax,%esi
  800cc4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <sys_cgetc>:

int
sys_cgetc(void)
{
  800ccb:	f3 0f 1e fb          	endbr32 
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cda:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdf:	89 d1                	mov    %edx,%ecx
  800ce1:	89 d3                	mov    %edx,%ebx
  800ce3:	89 d7                	mov    %edx,%edi
  800ce5:	89 d6                	mov    %edx,%esi
  800ce7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cee:	f3 0f 1e fb          	endbr32 
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	b8 03 00 00 00       	mov    $0x3,%eax
  800d08:	89 cb                	mov    %ecx,%ebx
  800d0a:	89 cf                	mov    %ecx,%edi
  800d0c:	89 ce                	mov    %ecx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 03                	push   $0x3
  800d22:	68 1f 29 80 00       	push   $0x80291f
  800d27:	6a 23                	push   $0x23
  800d29:	68 3c 29 80 00       	push   $0x80293c
  800d2e:	e8 13 f5 ff ff       	call   800246 <_panic>

00800d33 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d33:	f3 0f 1e fb          	endbr32 
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d42:	b8 02 00 00 00       	mov    $0x2,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <sys_yield>:

void
sys_yield(void)
{
  800d56:	f3 0f 1e fb          	endbr32 
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	ba 00 00 00 00       	mov    $0x0,%edx
  800d65:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d6a:	89 d1                	mov    %edx,%ecx
  800d6c:	89 d3                	mov    %edx,%ebx
  800d6e:	89 d7                	mov    %edx,%edi
  800d70:	89 d6                	mov    %edx,%esi
  800d72:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    

00800d79 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	be 00 00 00 00       	mov    $0x0,%esi
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 04 00 00 00       	mov    $0x4,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	89 f7                	mov    %esi,%edi
  800d9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	7f 08                	jg     800da9 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da9:	83 ec 0c             	sub    $0xc,%esp
  800dac:	50                   	push   %eax
  800dad:	6a 04                	push   $0x4
  800daf:	68 1f 29 80 00       	push   $0x80291f
  800db4:	6a 23                	push   $0x23
  800db6:	68 3c 29 80 00       	push   $0x80293c
  800dbb:	e8 86 f4 ff ff       	call   800246 <_panic>

00800dc0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc0:	f3 0f 1e fb          	endbr32 
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dde:	8b 75 18             	mov    0x18(%ebp),%esi
  800de1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7f 08                	jg     800def <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	5d                   	pop    %ebp
  800dee:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	50                   	push   %eax
  800df3:	6a 05                	push   $0x5
  800df5:	68 1f 29 80 00       	push   $0x80291f
  800dfa:	6a 23                	push   $0x23
  800dfc:	68 3c 29 80 00       	push   $0x80293c
  800e01:	e8 40 f4 ff ff       	call   800246 <_panic>

00800e06 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e06:	f3 0f 1e fb          	endbr32 
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 06                	push   $0x6
  800e3b:	68 1f 29 80 00       	push   $0x80291f
  800e40:	6a 23                	push   $0x23
  800e42:	68 3c 29 80 00       	push   $0x80293c
  800e47:	e8 fa f3 ff ff       	call   800246 <_panic>

00800e4c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4c:	f3 0f 1e fb          	endbr32 
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	b8 08 00 00 00       	mov    $0x8,%eax
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 08                	push   $0x8
  800e81:	68 1f 29 80 00       	push   $0x80291f
  800e86:	6a 23                	push   $0x23
  800e88:	68 3c 29 80 00       	push   $0x80293c
  800e8d:	e8 b4 f3 ff ff       	call   800246 <_panic>

00800e92 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e92:	f3 0f 1e fb          	endbr32 
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 09 00 00 00       	mov    $0x9,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 09                	push   $0x9
  800ec7:	68 1f 29 80 00       	push   $0x80291f
  800ecc:	6a 23                	push   $0x23
  800ece:	68 3c 29 80 00       	push   $0x80293c
  800ed3:	e8 6e f3 ff ff       	call   800246 <_panic>

00800ed8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed8:	f3 0f 1e fb          	endbr32 
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 0a                	push   $0xa
  800f0d:	68 1f 29 80 00       	push   $0x80291f
  800f12:	6a 23                	push   $0x23
  800f14:	68 3c 29 80 00       	push   $0x80293c
  800f19:	e8 28 f3 ff ff       	call   800246 <_panic>

00800f1e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1e:	f3 0f 1e fb          	endbr32 
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f33:	be 00 00 00 00       	mov    $0x0,%esi
  800f38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f45:	f3 0f 1e fb          	endbr32 
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	57                   	push   %edi
  800f4d:	56                   	push   %esi
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5f:	89 cb                	mov    %ecx,%ebx
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f67:	85 c0                	test   %eax,%eax
  800f69:	7f 08                	jg     800f73 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800f77:	6a 0d                	push   $0xd
  800f79:	68 1f 29 80 00       	push   $0x80291f
  800f7e:	6a 23                	push   $0x23
  800f80:	68 3c 29 80 00       	push   $0x80293c
  800f85:	e8 bc f2 ff ff       	call   800246 <_panic>

00800f8a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	ba 00 00 00 00       	mov    $0x0,%edx
  800f99:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9e:	89 d1                	mov    %edx,%ecx
  800fa0:	89 d3                	mov    %edx,%ebx
  800fa2:	89 d7                	mov    %edx,%edi
  800fa4:	89 d6                	mov    %edx,%esi
  800fa6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fad:	f3 0f 1e fb          	endbr32 
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbc:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc1:	f3 0f 1e fb          	endbr32 
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fdc:	f3 0f 1e fb          	endbr32 
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe8:	89 c2                	mov    %eax,%edx
  800fea:	c1 ea 16             	shr    $0x16,%edx
  800fed:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff4:	f6 c2 01             	test   $0x1,%dl
  800ff7:	74 2d                	je     801026 <fd_alloc+0x4a>
  800ff9:	89 c2                	mov    %eax,%edx
  800ffb:	c1 ea 0c             	shr    $0xc,%edx
  800ffe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801005:	f6 c2 01             	test   $0x1,%dl
  801008:	74 1c                	je     801026 <fd_alloc+0x4a>
  80100a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80100f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801014:	75 d2                	jne    800fe8 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80101f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801024:	eb 0a                	jmp    801030 <fd_alloc+0x54>
			*fd_store = fd;
  801026:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801029:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801032:	f3 0f 1e fb          	endbr32 
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103c:	83 f8 1f             	cmp    $0x1f,%eax
  80103f:	77 30                	ja     801071 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801041:	c1 e0 0c             	shl    $0xc,%eax
  801044:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801049:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	74 24                	je     801078 <fd_lookup+0x46>
  801054:	89 c2                	mov    %eax,%edx
  801056:	c1 ea 0c             	shr    $0xc,%edx
  801059:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801060:	f6 c2 01             	test   $0x1,%dl
  801063:	74 1a                	je     80107f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801065:	8b 55 0c             	mov    0xc(%ebp),%edx
  801068:	89 02                	mov    %eax,(%edx)
	return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		return -E_INVAL;
  801071:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801076:	eb f7                	jmp    80106f <fd_lookup+0x3d>
		return -E_INVAL;
  801078:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107d:	eb f0                	jmp    80106f <fd_lookup+0x3d>
  80107f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801084:	eb e9                	jmp    80106f <fd_lookup+0x3d>

00801086 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801086:	f3 0f 1e fb          	endbr32 
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801093:	ba 00 00 00 00       	mov    $0x0,%edx
  801098:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80109d:	39 08                	cmp    %ecx,(%eax)
  80109f:	74 38                	je     8010d9 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8010a1:	83 c2 01             	add    $0x1,%edx
  8010a4:	8b 04 95 c8 29 80 00 	mov    0x8029c8(,%edx,4),%eax
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	75 ee                	jne    80109d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010af:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b4:	8b 40 48             	mov    0x48(%eax),%eax
  8010b7:	83 ec 04             	sub    $0x4,%esp
  8010ba:	51                   	push   %ecx
  8010bb:	50                   	push   %eax
  8010bc:	68 4c 29 80 00       	push   $0x80294c
  8010c1:	e8 67 f2 ff ff       	call   80032d <cprintf>
	*dev = 0;
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010cf:	83 c4 10             	add    $0x10,%esp
  8010d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    
			*dev = devtab[i];
  8010d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e3:	eb f2                	jmp    8010d7 <dev_lookup+0x51>

008010e5 <fd_close>:
{
  8010e5:	f3 0f 1e fb          	endbr32 
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 24             	sub    $0x24,%esp
  8010f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010fb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801102:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801105:	50                   	push   %eax
  801106:	e8 27 ff ff ff       	call   801032 <fd_lookup>
  80110b:	89 c3                	mov    %eax,%ebx
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	78 05                	js     801119 <fd_close+0x34>
	    || fd != fd2)
  801114:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801117:	74 16                	je     80112f <fd_close+0x4a>
		return (must_exist ? r : 0);
  801119:	89 f8                	mov    %edi,%eax
  80111b:	84 c0                	test   %al,%al
  80111d:	b8 00 00 00 00       	mov    $0x0,%eax
  801122:	0f 44 d8             	cmove  %eax,%ebx
}
  801125:	89 d8                	mov    %ebx,%eax
  801127:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5f                   	pop    %edi
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80112f:	83 ec 08             	sub    $0x8,%esp
  801132:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801135:	50                   	push   %eax
  801136:	ff 36                	pushl  (%esi)
  801138:	e8 49 ff ff ff       	call   801086 <dev_lookup>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 1a                	js     801160 <fd_close+0x7b>
		if (dev->dev_close)
  801146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801149:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801151:	85 c0                	test   %eax,%eax
  801153:	74 0b                	je     801160 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801155:	83 ec 0c             	sub    $0xc,%esp
  801158:	56                   	push   %esi
  801159:	ff d0                	call   *%eax
  80115b:	89 c3                	mov    %eax,%ebx
  80115d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801160:	83 ec 08             	sub    $0x8,%esp
  801163:	56                   	push   %esi
  801164:	6a 00                	push   $0x0
  801166:	e8 9b fc ff ff       	call   800e06 <sys_page_unmap>
	return r;
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	eb b5                	jmp    801125 <fd_close+0x40>

00801170 <close>:

int
close(int fdnum)
{
  801170:	f3 0f 1e fb          	endbr32 
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80117a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	ff 75 08             	pushl  0x8(%ebp)
  801181:	e8 ac fe ff ff       	call   801032 <fd_lookup>
  801186:	83 c4 10             	add    $0x10,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	79 02                	jns    80118f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    
		return fd_close(fd, 1);
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	6a 01                	push   $0x1
  801194:	ff 75 f4             	pushl  -0xc(%ebp)
  801197:	e8 49 ff ff ff       	call   8010e5 <fd_close>
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	eb ec                	jmp    80118d <close+0x1d>

008011a1 <close_all>:

void
close_all(void)
{
  8011a1:	f3 0f 1e fb          	endbr32 
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	53                   	push   %ebx
  8011a9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	53                   	push   %ebx
  8011b5:	e8 b6 ff ff ff       	call   801170 <close>
	for (i = 0; i < MAXFD; i++)
  8011ba:	83 c3 01             	add    $0x1,%ebx
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	83 fb 20             	cmp    $0x20,%ebx
  8011c3:	75 ec                	jne    8011b1 <close_all+0x10>
}
  8011c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	57                   	push   %edi
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	ff 75 08             	pushl  0x8(%ebp)
  8011de:	e8 4f fe ff ff       	call   801032 <fd_lookup>
  8011e3:	89 c3                	mov    %eax,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	0f 88 81 00 00 00    	js     801271 <dup+0xa7>
		return r;
	close(newfdnum);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	ff 75 0c             	pushl  0xc(%ebp)
  8011f6:	e8 75 ff ff ff       	call   801170 <close>

	newfd = INDEX2FD(newfdnum);
  8011fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fe:	c1 e6 0c             	shl    $0xc,%esi
  801201:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801207:	83 c4 04             	add    $0x4,%esp
  80120a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80120d:	e8 af fd ff ff       	call   800fc1 <fd2data>
  801212:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801214:	89 34 24             	mov    %esi,(%esp)
  801217:	e8 a5 fd ff ff       	call   800fc1 <fd2data>
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801221:	89 d8                	mov    %ebx,%eax
  801223:	c1 e8 16             	shr    $0x16,%eax
  801226:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80122d:	a8 01                	test   $0x1,%al
  80122f:	74 11                	je     801242 <dup+0x78>
  801231:	89 d8                	mov    %ebx,%eax
  801233:	c1 e8 0c             	shr    $0xc,%eax
  801236:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	75 39                	jne    80127b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801245:	89 d0                	mov    %edx,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
  80124a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	25 07 0e 00 00       	and    $0xe07,%eax
  801259:	50                   	push   %eax
  80125a:	56                   	push   %esi
  80125b:	6a 00                	push   $0x0
  80125d:	52                   	push   %edx
  80125e:	6a 00                	push   $0x0
  801260:	e8 5b fb ff ff       	call   800dc0 <sys_page_map>
  801265:	89 c3                	mov    %eax,%ebx
  801267:	83 c4 20             	add    $0x20,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	78 31                	js     80129f <dup+0xd5>
		goto err;

	return newfdnum;
  80126e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801271:	89 d8                	mov    %ebx,%eax
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80127b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	25 07 0e 00 00       	and    $0xe07,%eax
  80128a:	50                   	push   %eax
  80128b:	57                   	push   %edi
  80128c:	6a 00                	push   $0x0
  80128e:	53                   	push   %ebx
  80128f:	6a 00                	push   $0x0
  801291:	e8 2a fb ff ff       	call   800dc0 <sys_page_map>
  801296:	89 c3                	mov    %eax,%ebx
  801298:	83 c4 20             	add    $0x20,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	79 a3                	jns    801242 <dup+0x78>
	sys_page_unmap(0, newfd);
  80129f:	83 ec 08             	sub    $0x8,%esp
  8012a2:	56                   	push   %esi
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 5c fb ff ff       	call   800e06 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012aa:	83 c4 08             	add    $0x8,%esp
  8012ad:	57                   	push   %edi
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 51 fb ff ff       	call   800e06 <sys_page_unmap>
	return r;
  8012b5:	83 c4 10             	add    $0x10,%esp
  8012b8:	eb b7                	jmp    801271 <dup+0xa7>

008012ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ba:	f3 0f 1e fb          	endbr32 
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 1c             	sub    $0x1c,%esp
  8012c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012cb:	50                   	push   %eax
  8012cc:	53                   	push   %ebx
  8012cd:	e8 60 fd ff ff       	call   801032 <fd_lookup>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 3f                	js     801318 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e3:	ff 30                	pushl  (%eax)
  8012e5:	e8 9c fd ff ff       	call   801086 <dev_lookup>
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 27                	js     801318 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f4:	8b 42 08             	mov    0x8(%edx),%eax
  8012f7:	83 e0 03             	and    $0x3,%eax
  8012fa:	83 f8 01             	cmp    $0x1,%eax
  8012fd:	74 1e                	je     80131d <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801302:	8b 40 08             	mov    0x8(%eax),%eax
  801305:	85 c0                	test   %eax,%eax
  801307:	74 35                	je     80133e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	ff 75 10             	pushl  0x10(%ebp)
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	52                   	push   %edx
  801313:	ff d0                	call   *%eax
  801315:	83 c4 10             	add    $0x10,%esp
}
  801318:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80131d:	a1 08 40 80 00       	mov    0x804008,%eax
  801322:	8b 40 48             	mov    0x48(%eax),%eax
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	53                   	push   %ebx
  801329:	50                   	push   %eax
  80132a:	68 8d 29 80 00       	push   $0x80298d
  80132f:	e8 f9 ef ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133c:	eb da                	jmp    801318 <read+0x5e>
		return -E_NOT_SUPP;
  80133e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801343:	eb d3                	jmp    801318 <read+0x5e>

00801345 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801345:	f3 0f 1e fb          	endbr32 
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 0c             	sub    $0xc,%esp
  801352:	8b 7d 08             	mov    0x8(%ebp),%edi
  801355:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801358:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135d:	eb 02                	jmp    801361 <readn+0x1c>
  80135f:	01 c3                	add    %eax,%ebx
  801361:	39 f3                	cmp    %esi,%ebx
  801363:	73 21                	jae    801386 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801365:	83 ec 04             	sub    $0x4,%esp
  801368:	89 f0                	mov    %esi,%eax
  80136a:	29 d8                	sub    %ebx,%eax
  80136c:	50                   	push   %eax
  80136d:	89 d8                	mov    %ebx,%eax
  80136f:	03 45 0c             	add    0xc(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	57                   	push   %edi
  801374:	e8 41 ff ff ff       	call   8012ba <read>
		if (m < 0)
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 04                	js     801384 <readn+0x3f>
			return m;
		if (m == 0)
  801380:	75 dd                	jne    80135f <readn+0x1a>
  801382:	eb 02                	jmp    801386 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801384:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801386:	89 d8                	mov    %ebx,%eax
  801388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801390:	f3 0f 1e fb          	endbr32 
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	53                   	push   %ebx
  801398:	83 ec 1c             	sub    $0x1c,%esp
  80139b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a1:	50                   	push   %eax
  8013a2:	53                   	push   %ebx
  8013a3:	e8 8a fc ff ff       	call   801032 <fd_lookup>
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	78 3a                	js     8013e9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b5:	50                   	push   %eax
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	ff 30                	pushl  (%eax)
  8013bb:	e8 c6 fc ff ff       	call   801086 <dev_lookup>
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 22                	js     8013e9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ce:	74 1e                	je     8013ee <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8013d6:	85 d2                	test   %edx,%edx
  8013d8:	74 35                	je     80140f <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	ff 75 10             	pushl  0x10(%ebp)
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	ff d2                	call   *%edx
  8013e6:	83 c4 10             	add    $0x10,%esp
}
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	50                   	push   %eax
  8013fb:	68 a9 29 80 00       	push   $0x8029a9
  801400:	e8 28 ef ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb da                	jmp    8013e9 <write+0x59>
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb d3                	jmp    8013e9 <write+0x59>

00801416 <seek>:

int
seek(int fdnum, off_t offset)
{
  801416:	f3 0f 1e fb          	endbr32 
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801420:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 06 fc ff ff       	call   801032 <fd_lookup>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 0e                	js     801441 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801439:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801443:	f3 0f 1e fb          	endbr32 
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	53                   	push   %ebx
  80144b:	83 ec 1c             	sub    $0x1c,%esp
  80144e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801451:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801454:	50                   	push   %eax
  801455:	53                   	push   %ebx
  801456:	e8 d7 fb ff ff       	call   801032 <fd_lookup>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 37                	js     801499 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801468:	50                   	push   %eax
  801469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146c:	ff 30                	pushl  (%eax)
  80146e:	e8 13 fc ff ff       	call   801086 <dev_lookup>
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 1f                	js     801499 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801481:	74 1b                	je     80149e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801486:	8b 52 18             	mov    0x18(%edx),%edx
  801489:	85 d2                	test   %edx,%edx
  80148b:	74 32                	je     8014bf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	50                   	push   %eax
  801494:	ff d2                	call   *%edx
  801496:	83 c4 10             	add    $0x10,%esp
}
  801499:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80149e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014a3:	8b 40 48             	mov    0x48(%eax),%eax
  8014a6:	83 ec 04             	sub    $0x4,%esp
  8014a9:	53                   	push   %ebx
  8014aa:	50                   	push   %eax
  8014ab:	68 6c 29 80 00       	push   $0x80296c
  8014b0:	e8 78 ee ff ff       	call   80032d <cprintf>
		return -E_INVAL;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bd:	eb da                	jmp    801499 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8014bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c4:	eb d3                	jmp    801499 <ftruncate+0x56>

008014c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014c6:	f3 0f 1e fb          	endbr32 
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 1c             	sub    $0x1c,%esp
  8014d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d7:	50                   	push   %eax
  8014d8:	ff 75 08             	pushl  0x8(%ebp)
  8014db:	e8 52 fb ff ff       	call   801032 <fd_lookup>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 4b                	js     801532 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ed:	50                   	push   %eax
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	ff 30                	pushl  (%eax)
  8014f3:	e8 8e fb ff ff       	call   801086 <dev_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 33                	js     801532 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801502:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801506:	74 2f                	je     801537 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801508:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80150b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801512:	00 00 00 
	stat->st_isdir = 0;
  801515:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80151c:	00 00 00 
	stat->st_dev = dev;
  80151f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	53                   	push   %ebx
  801529:	ff 75 f0             	pushl  -0x10(%ebp)
  80152c:	ff 50 14             	call   *0x14(%eax)
  80152f:	83 c4 10             	add    $0x10,%esp
}
  801532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801535:	c9                   	leave  
  801536:	c3                   	ret    
		return -E_NOT_SUPP;
  801537:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153c:	eb f4                	jmp    801532 <fstat+0x6c>

0080153e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80153e:	f3 0f 1e fb          	endbr32 
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	56                   	push   %esi
  801546:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	e8 fb 01 00 00       	call   80174f <open>
  801554:	89 c3                	mov    %eax,%ebx
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 c0                	test   %eax,%eax
  80155b:	78 1b                	js     801578 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	e8 5d ff ff ff       	call   8014c6 <fstat>
  801569:	89 c6                	mov    %eax,%esi
	close(fd);
  80156b:	89 1c 24             	mov    %ebx,(%esp)
  80156e:	e8 fd fb ff ff       	call   801170 <close>
	return r;
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 f3                	mov    %esi,%ebx
}
  801578:	89 d8                	mov    %ebx,%eax
  80157a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	89 c6                	mov    %eax,%esi
  801588:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801591:	74 27                	je     8015ba <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801593:	6a 07                	push   $0x7
  801595:	68 00 50 80 00       	push   $0x805000
  80159a:	56                   	push   %esi
  80159b:	ff 35 00 40 80 00    	pushl  0x804000
  8015a1:	e8 7d 0c 00 00       	call   802223 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015a6:	83 c4 0c             	add    $0xc,%esp
  8015a9:	6a 00                	push   $0x0
  8015ab:	53                   	push   %ebx
  8015ac:	6a 00                	push   $0x0
  8015ae:	e8 fc 0b 00 00       	call   8021af <ipc_recv>
}
  8015b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b6:	5b                   	pop    %ebx
  8015b7:	5e                   	pop    %esi
  8015b8:	5d                   	pop    %ebp
  8015b9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015ba:	83 ec 0c             	sub    $0xc,%esp
  8015bd:	6a 01                	push   $0x1
  8015bf:	e8 b7 0c 00 00       	call   80227b <ipc_find_env>
  8015c4:	a3 00 40 80 00       	mov    %eax,0x804000
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	eb c5                	jmp    801593 <fsipc+0x12>

008015ce <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015ce:	f3 0f 1e fb          	endbr32 
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	8b 40 0c             	mov    0xc(%eax),%eax
  8015de:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f0:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f5:	e8 87 ff ff ff       	call   801581 <fsipc>
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <devfile_flush>:
{
  8015fc:	f3 0f 1e fb          	endbr32 
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	8b 40 0c             	mov    0xc(%eax),%eax
  80160c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801611:	ba 00 00 00 00       	mov    $0x0,%edx
  801616:	b8 06 00 00 00       	mov    $0x6,%eax
  80161b:	e8 61 ff ff ff       	call   801581 <fsipc>
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <devfile_stat>:
{
  801622:	f3 0f 1e fb          	endbr32 
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	53                   	push   %ebx
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 40 0c             	mov    0xc(%eax),%eax
  801636:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	b8 05 00 00 00       	mov    $0x5,%eax
  801645:	e8 37 ff ff ff       	call   801581 <fsipc>
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 2c                	js     80167a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	68 00 50 80 00       	push   $0x805000
  801656:	53                   	push   %ebx
  801657:	e8 db f2 ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165c:	a1 80 50 80 00       	mov    0x805080,%eax
  801661:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801667:	a1 84 50 80 00       	mov    0x805084,%eax
  80166c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <devfile_write>:
{
  80167f:	f3 0f 1e fb          	endbr32 
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80168c:	8b 55 08             	mov    0x8(%ebp),%edx
  80168f:	8b 52 0c             	mov    0xc(%edx),%edx
  801692:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801698:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169d:	ba 00 10 00 00       	mov    $0x1000,%edx
  8016a2:	0f 47 c2             	cmova  %edx,%eax
  8016a5:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8016aa:	50                   	push   %eax
  8016ab:	ff 75 0c             	pushl  0xc(%ebp)
  8016ae:	68 08 50 80 00       	push   $0x805008
  8016b3:	e8 35 f4 ff ff       	call   800aed <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	b8 04 00 00 00       	mov    $0x4,%eax
  8016c2:	e8 ba fe ff ff       	call   801581 <fsipc>
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <devfile_read>:
{
  8016c9:	f3 0f 1e fb          	endbr32 
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016e0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8016f0:	e8 8c fe ff ff       	call   801581 <fsipc>
  8016f5:	89 c3                	mov    %eax,%ebx
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 1f                	js     80171a <devfile_read+0x51>
	assert(r <= n);
  8016fb:	39 f0                	cmp    %esi,%eax
  8016fd:	77 24                	ja     801723 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801704:	7f 33                	jg     801739 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	50                   	push   %eax
  80170a:	68 00 50 80 00       	push   $0x805000
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	e8 d6 f3 ff ff       	call   800aed <memmove>
	return r;
  801717:	83 c4 10             	add    $0x10,%esp
}
  80171a:	89 d8                	mov    %ebx,%eax
  80171c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    
	assert(r <= n);
  801723:	68 dc 29 80 00       	push   $0x8029dc
  801728:	68 e3 29 80 00       	push   $0x8029e3
  80172d:	6a 7c                	push   $0x7c
  80172f:	68 f8 29 80 00       	push   $0x8029f8
  801734:	e8 0d eb ff ff       	call   800246 <_panic>
	assert(r <= PGSIZE);
  801739:	68 03 2a 80 00       	push   $0x802a03
  80173e:	68 e3 29 80 00       	push   $0x8029e3
  801743:	6a 7d                	push   $0x7d
  801745:	68 f8 29 80 00       	push   $0x8029f8
  80174a:	e8 f7 ea ff ff       	call   800246 <_panic>

0080174f <open>:
{
  80174f:	f3 0f 1e fb          	endbr32 
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	83 ec 1c             	sub    $0x1c,%esp
  80175b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80175e:	56                   	push   %esi
  80175f:	e8 90 f1 ff ff       	call   8008f4 <strlen>
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80176c:	7f 6c                	jg     8017da <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80176e:	83 ec 0c             	sub    $0xc,%esp
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	50                   	push   %eax
  801775:	e8 62 f8 ff ff       	call   800fdc <fd_alloc>
  80177a:	89 c3                	mov    %eax,%ebx
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 3c                	js     8017bf <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	56                   	push   %esi
  801787:	68 00 50 80 00       	push   $0x805000
  80178c:	e8 a6 f1 ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801791:	8b 45 0c             	mov    0xc(%ebp),%eax
  801794:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179c:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a1:	e8 db fd ff ff       	call   801581 <fsipc>
  8017a6:	89 c3                	mov    %eax,%ebx
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 19                	js     8017c8 <open+0x79>
	return fd2num(fd);
  8017af:	83 ec 0c             	sub    $0xc,%esp
  8017b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b5:	e8 f3 f7 ff ff       	call   800fad <fd2num>
  8017ba:	89 c3                	mov    %eax,%ebx
  8017bc:	83 c4 10             	add    $0x10,%esp
}
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    
		fd_close(fd, 0);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d0:	e8 10 f9 ff ff       	call   8010e5 <fd_close>
		return r;
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	eb e5                	jmp    8017bf <open+0x70>
		return -E_BAD_PATH;
  8017da:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017df:	eb de                	jmp    8017bf <open+0x70>

008017e1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017e1:	f3 0f 1e fb          	endbr32 
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
  8017e8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f0:	b8 08 00 00 00       	mov    $0x8,%eax
  8017f5:	e8 87 fd ff ff       	call   801581 <fsipc>
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017fc:	f3 0f 1e fb          	endbr32 
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801806:	68 0f 2a 80 00       	push   $0x802a0f
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 24 f1 ff ff       	call   800937 <strcpy>
	return 0;
}
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <devsock_close>:
{
  80181a:	f3 0f 1e fb          	endbr32 
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	53                   	push   %ebx
  801822:	83 ec 10             	sub    $0x10,%esp
  801825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801828:	53                   	push   %ebx
  801829:	e8 8a 0a 00 00       	call   8022b8 <pageref>
  80182e:	89 c2                	mov    %eax,%edx
  801830:	83 c4 10             	add    $0x10,%esp
		return 0;
  801833:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801838:	83 fa 01             	cmp    $0x1,%edx
  80183b:	74 05                	je     801842 <devsock_close+0x28>
}
  80183d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801840:	c9                   	leave  
  801841:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801842:	83 ec 0c             	sub    $0xc,%esp
  801845:	ff 73 0c             	pushl  0xc(%ebx)
  801848:	e8 e3 02 00 00       	call   801b30 <nsipc_close>
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	eb eb                	jmp    80183d <devsock_close+0x23>

00801852 <devsock_write>:
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	ff 75 10             	pushl  0x10(%ebp)
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	ff 70 0c             	pushl  0xc(%eax)
  80186a:	e8 b5 03 00 00       	call   801c24 <nsipc_send>
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <devsock_read>:
{
  801871:	f3 0f 1e fb          	endbr32 
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 10             	pushl  0x10(%ebp)
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	ff 70 0c             	pushl  0xc(%eax)
  801889:	e8 1f 03 00 00       	call   801bad <nsipc_recv>
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <fd2sockid>:
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801896:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801899:	52                   	push   %edx
  80189a:	50                   	push   %eax
  80189b:	e8 92 f7 ff ff       	call   801032 <fd_lookup>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 10                	js     8018b7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018aa:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018b0:	39 08                	cmp    %ecx,(%eax)
  8018b2:	75 05                	jne    8018b9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018b4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018be:	eb f7                	jmp    8018b7 <fd2sockid+0x27>

008018c0 <alloc_sockfd>:
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	56                   	push   %esi
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 1c             	sub    $0x1c,%esp
  8018c8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	e8 09 f7 ff ff       	call   800fdc <fd_alloc>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 43                	js     80191f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	68 07 04 00 00       	push   $0x407
  8018e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e7:	6a 00                	push   $0x0
  8018e9:	e8 8b f4 ff ff       	call   800d79 <sys_page_alloc>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 28                	js     80191f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801900:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801905:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80190c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80190f:	83 ec 0c             	sub    $0xc,%esp
  801912:	50                   	push   %eax
  801913:	e8 95 f6 ff ff       	call   800fad <fd2num>
  801918:	89 c3                	mov    %eax,%ebx
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	eb 0c                	jmp    80192b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80191f:	83 ec 0c             	sub    $0xc,%esp
  801922:	56                   	push   %esi
  801923:	e8 08 02 00 00       	call   801b30 <nsipc_close>
		return r;
  801928:	83 c4 10             	add    $0x10,%esp
}
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801930:	5b                   	pop    %ebx
  801931:	5e                   	pop    %esi
  801932:	5d                   	pop    %ebp
  801933:	c3                   	ret    

00801934 <accept>:
{
  801934:	f3 0f 1e fb          	endbr32 
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	e8 4a ff ff ff       	call   801890 <fd2sockid>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 1b                	js     801965 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	ff 75 10             	pushl  0x10(%ebp)
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	50                   	push   %eax
  801954:	e8 22 01 00 00       	call   801a7b <nsipc_accept>
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 05                	js     801965 <accept+0x31>
	return alloc_sockfd(r);
  801960:	e8 5b ff ff ff       	call   8018c0 <alloc_sockfd>
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <bind>:
{
  801967:	f3 0f 1e fb          	endbr32 
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	e8 17 ff ff ff       	call   801890 <fd2sockid>
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 12                	js     80198f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	ff 75 10             	pushl  0x10(%ebp)
  801983:	ff 75 0c             	pushl  0xc(%ebp)
  801986:	50                   	push   %eax
  801987:	e8 45 01 00 00       	call   801ad1 <nsipc_bind>
  80198c:	83 c4 10             	add    $0x10,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <shutdown>:
{
  801991:	f3 0f 1e fb          	endbr32 
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	e8 ed fe ff ff       	call   801890 <fd2sockid>
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 0f                	js     8019b6 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8019a7:	83 ec 08             	sub    $0x8,%esp
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	50                   	push   %eax
  8019ae:	e8 57 01 00 00       	call   801b0a <nsipc_shutdown>
  8019b3:	83 c4 10             	add    $0x10,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <connect>:
{
  8019b8:	f3 0f 1e fb          	endbr32 
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	e8 c6 fe ff ff       	call   801890 <fd2sockid>
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 12                	js     8019e0 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	ff 75 10             	pushl  0x10(%ebp)
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	50                   	push   %eax
  8019d8:	e8 71 01 00 00       	call   801b4e <nsipc_connect>
  8019dd:	83 c4 10             	add    $0x10,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <listen>:
{
  8019e2:	f3 0f 1e fb          	endbr32 
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	e8 9c fe ff ff       	call   801890 <fd2sockid>
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 0f                	js     801a07 <listen+0x25>
	return nsipc_listen(r, backlog);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	50                   	push   %eax
  8019ff:	e8 83 01 00 00       	call   801b87 <nsipc_listen>
  801a04:	83 c4 10             	add    $0x10,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a09:	f3 0f 1e fb          	endbr32 
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a13:	ff 75 10             	pushl  0x10(%ebp)
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	e8 65 02 00 00       	call   801c86 <nsipc_socket>
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	85 c0                	test   %eax,%eax
  801a26:	78 05                	js     801a2d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801a28:	e8 93 fe ff ff       	call   8018c0 <alloc_sockfd>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	53                   	push   %ebx
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a38:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a3f:	74 26                	je     801a67 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a41:	6a 07                	push   $0x7
  801a43:	68 00 60 80 00       	push   $0x806000
  801a48:	53                   	push   %ebx
  801a49:	ff 35 04 40 80 00    	pushl  0x804004
  801a4f:	e8 cf 07 00 00       	call   802223 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a54:	83 c4 0c             	add    $0xc,%esp
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	e8 4d 07 00 00       	call   8021af <ipc_recv>
}
  801a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	6a 02                	push   $0x2
  801a6c:	e8 0a 08 00 00       	call   80227b <ipc_find_env>
  801a71:	a3 04 40 80 00       	mov    %eax,0x804004
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	eb c6                	jmp    801a41 <nsipc+0x12>

00801a7b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a7b:	f3 0f 1e fb          	endbr32 
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a8f:	8b 06                	mov    (%esi),%eax
  801a91:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	e8 8f ff ff ff       	call   801a2f <nsipc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	79 09                	jns    801aaf <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aa6:	89 d8                	mov    %ebx,%eax
  801aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	ff 35 10 60 80 00    	pushl  0x806010
  801ab8:	68 00 60 80 00       	push   $0x806000
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	e8 28 f0 ff ff       	call   800aed <memmove>
		*addrlen = ret->ret_addrlen;
  801ac5:	a1 10 60 80 00       	mov    0x806010,%eax
  801aca:	89 06                	mov    %eax,(%esi)
  801acc:	83 c4 10             	add    $0x10,%esp
	return r;
  801acf:	eb d5                	jmp    801aa6 <nsipc_accept+0x2b>

00801ad1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad1:	f3 0f 1e fb          	endbr32 
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ae7:	53                   	push   %ebx
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	68 04 60 80 00       	push   $0x806004
  801af0:	e8 f8 ef ff ff       	call   800aed <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801afb:	b8 02 00 00 00       	mov    $0x2,%eax
  801b00:	e8 2a ff ff ff       	call   801a2f <nsipc>
}
  801b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b0a:	f3 0f 1e fb          	endbr32 
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b24:	b8 03 00 00 00       	mov    $0x3,%eax
  801b29:	e8 01 ff ff ff       	call   801a2f <nsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <nsipc_close>:

int
nsipc_close(int s)
{
  801b30:	f3 0f 1e fb          	endbr32 
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b42:	b8 04 00 00 00       	mov    $0x4,%eax
  801b47:	e8 e3 fe ff ff       	call   801a2f <nsipc>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b4e:	f3 0f 1e fb          	endbr32 
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
  801b56:	83 ec 08             	sub    $0x8,%esp
  801b59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b64:	53                   	push   %ebx
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	68 04 60 80 00       	push   $0x806004
  801b6d:	e8 7b ef ff ff       	call   800aed <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b72:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b78:	b8 05 00 00 00       	mov    $0x5,%eax
  801b7d:	e8 ad fe ff ff       	call   801a2f <nsipc>
}
  801b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b87:	f3 0f 1e fb          	endbr32 
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba1:	b8 06 00 00 00       	mov    $0x6,%eax
  801ba6:	e8 84 fe ff ff       	call   801a2f <nsipc>
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bad:	f3 0f 1e fb          	endbr32 
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	56                   	push   %esi
  801bb5:	53                   	push   %ebx
  801bb6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bca:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bcf:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd4:	e8 56 fe ff ff       	call   801a2f <nsipc>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 26                	js     801c05 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801bdf:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801be5:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801bea:	0f 4e c6             	cmovle %esi,%eax
  801bed:	39 c3                	cmp    %eax,%ebx
  801bef:	7f 1d                	jg     801c0e <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	53                   	push   %ebx
  801bf5:	68 00 60 80 00       	push   $0x806000
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	e8 eb ee ff ff       	call   800aed <memmove>
  801c02:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c05:	89 d8                	mov    %ebx,%eax
  801c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c0e:	68 1b 2a 80 00       	push   $0x802a1b
  801c13:	68 e3 29 80 00       	push   $0x8029e3
  801c18:	6a 62                	push   $0x62
  801c1a:	68 30 2a 80 00       	push   $0x802a30
  801c1f:	e8 22 e6 ff ff       	call   800246 <_panic>

00801c24 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c24:	f3 0f 1e fb          	endbr32 
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c40:	7f 2e                	jg     801c70 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	53                   	push   %ebx
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	68 0c 60 80 00       	push   $0x80600c
  801c4e:	e8 9a ee ff ff       	call   800aed <memmove>
	nsipcbuf.send.req_size = size;
  801c53:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c59:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c61:	b8 08 00 00 00       	mov    $0x8,%eax
  801c66:	e8 c4 fd ff ff       	call   801a2f <nsipc>
}
  801c6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    
	assert(size < 1600);
  801c70:	68 3c 2a 80 00       	push   $0x802a3c
  801c75:	68 e3 29 80 00       	push   $0x8029e3
  801c7a:	6a 6d                	push   $0x6d
  801c7c:	68 30 2a 80 00       	push   $0x802a30
  801c81:	e8 c0 e5 ff ff       	call   800246 <_panic>

00801c86 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c86:	f3 0f 1e fb          	endbr32 
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ca8:	b8 09 00 00 00       	mov    $0x9,%eax
  801cad:	e8 7d fd ff ff       	call   801a2f <nsipc>
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	56                   	push   %esi
  801cbc:	53                   	push   %ebx
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	e8 f6 f2 ff ff       	call   800fc1 <fd2data>
  801ccb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ccd:	83 c4 08             	add    $0x8,%esp
  801cd0:	68 48 2a 80 00       	push   $0x802a48
  801cd5:	53                   	push   %ebx
  801cd6:	e8 5c ec ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdb:	8b 46 04             	mov    0x4(%esi),%eax
  801cde:	2b 06                	sub    (%esi),%eax
  801ce0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ced:	00 00 00 
	stat->st_dev = &devpipe;
  801cf0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf7:	30 80 00 
	return 0;
}
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d06:	f3 0f 1e fb          	endbr32 
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	53                   	push   %ebx
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d14:	53                   	push   %ebx
  801d15:	6a 00                	push   $0x0
  801d17:	e8 ea f0 ff ff       	call   800e06 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d1c:	89 1c 24             	mov    %ebx,(%esp)
  801d1f:	e8 9d f2 ff ff       	call   800fc1 <fd2data>
  801d24:	83 c4 08             	add    $0x8,%esp
  801d27:	50                   	push   %eax
  801d28:	6a 00                	push   $0x0
  801d2a:	e8 d7 f0 ff ff       	call   800e06 <sys_page_unmap>
}
  801d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <_pipeisclosed>:
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	57                   	push   %edi
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	83 ec 1c             	sub    $0x1c,%esp
  801d3d:	89 c7                	mov    %eax,%edi
  801d3f:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d41:	a1 08 40 80 00       	mov    0x804008,%eax
  801d46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	57                   	push   %edi
  801d4d:	e8 66 05 00 00       	call   8022b8 <pageref>
  801d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d55:	89 34 24             	mov    %esi,(%esp)
  801d58:	e8 5b 05 00 00       	call   8022b8 <pageref>
		nn = thisenv->env_runs;
  801d5d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d63:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	39 cb                	cmp    %ecx,%ebx
  801d6b:	74 1b                	je     801d88 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d70:	75 cf                	jne    801d41 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d72:	8b 42 58             	mov    0x58(%edx),%eax
  801d75:	6a 01                	push   $0x1
  801d77:	50                   	push   %eax
  801d78:	53                   	push   %ebx
  801d79:	68 4f 2a 80 00       	push   $0x802a4f
  801d7e:	e8 aa e5 ff ff       	call   80032d <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	eb b9                	jmp    801d41 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d88:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d8b:	0f 94 c0             	sete   %al
  801d8e:	0f b6 c0             	movzbl %al,%eax
}
  801d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5e                   	pop    %esi
  801d96:	5f                   	pop    %edi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <devpipe_write>:
{
  801d99:	f3 0f 1e fb          	endbr32 
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	57                   	push   %edi
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 28             	sub    $0x28,%esp
  801da6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da9:	56                   	push   %esi
  801daa:	e8 12 f2 ff ff       	call   800fc1 <fd2data>
  801daf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	bf 00 00 00 00       	mov    $0x0,%edi
  801db9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dbc:	74 4f                	je     801e0d <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dbe:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc1:	8b 0b                	mov    (%ebx),%ecx
  801dc3:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc6:	39 d0                	cmp    %edx,%eax
  801dc8:	72 14                	jb     801dde <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801dca:	89 da                	mov    %ebx,%edx
  801dcc:	89 f0                	mov    %esi,%eax
  801dce:	e8 61 ff ff ff       	call   801d34 <_pipeisclosed>
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	75 3b                	jne    801e12 <devpipe_write+0x79>
			sys_yield();
  801dd7:	e8 7a ef ff ff       	call   800d56 <sys_yield>
  801ddc:	eb e0                	jmp    801dbe <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de8:	89 c2                	mov    %eax,%edx
  801dea:	c1 fa 1f             	sar    $0x1f,%edx
  801ded:	89 d1                	mov    %edx,%ecx
  801def:	c1 e9 1b             	shr    $0x1b,%ecx
  801df2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df5:	83 e2 1f             	and    $0x1f,%edx
  801df8:	29 ca                	sub    %ecx,%edx
  801dfa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dfe:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e02:	83 c0 01             	add    $0x1,%eax
  801e05:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e08:	83 c7 01             	add    $0x1,%edi
  801e0b:	eb ac                	jmp    801db9 <devpipe_write+0x20>
	return i;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	eb 05                	jmp    801e17 <devpipe_write+0x7e>
				return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <devpipe_read>:
{
  801e1f:	f3 0f 1e fb          	endbr32 
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 18             	sub    $0x18,%esp
  801e2c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e2f:	57                   	push   %edi
  801e30:	e8 8c f1 ff ff       	call   800fc1 <fd2data>
  801e35:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e37:	83 c4 10             	add    $0x10,%esp
  801e3a:	be 00 00 00 00       	mov    $0x0,%esi
  801e3f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e42:	75 14                	jne    801e58 <devpipe_read+0x39>
	return i;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	eb 02                	jmp    801e4b <devpipe_read+0x2c>
				return i;
  801e49:	89 f0                	mov    %esi,%eax
}
  801e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    
			sys_yield();
  801e53:	e8 fe ee ff ff       	call   800d56 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e58:	8b 03                	mov    (%ebx),%eax
  801e5a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e5d:	75 18                	jne    801e77 <devpipe_read+0x58>
			if (i > 0)
  801e5f:	85 f6                	test   %esi,%esi
  801e61:	75 e6                	jne    801e49 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801e63:	89 da                	mov    %ebx,%edx
  801e65:	89 f8                	mov    %edi,%eax
  801e67:	e8 c8 fe ff ff       	call   801d34 <_pipeisclosed>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	74 e3                	je     801e53 <devpipe_read+0x34>
				return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	eb d4                	jmp    801e4b <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e77:	99                   	cltd   
  801e78:	c1 ea 1b             	shr    $0x1b,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	83 e0 1f             	and    $0x1f,%eax
  801e80:	29 d0                	sub    %edx,%eax
  801e82:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e8d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e90:	83 c6 01             	add    $0x1,%esi
  801e93:	eb aa                	jmp    801e3f <devpipe_read+0x20>

00801e95 <pipe>:
{
  801e95:	f3 0f 1e fb          	endbr32 
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	56                   	push   %esi
  801e9d:	53                   	push   %ebx
  801e9e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	e8 32 f1 ff ff       	call   800fdc <fd_alloc>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 88 23 01 00 00    	js     801fda <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	68 07 04 00 00       	push   $0x407
  801ebf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 b0 ee ff ff       	call   800d79 <sys_page_alloc>
  801ec9:	89 c3                	mov    %eax,%ebx
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	0f 88 04 01 00 00    	js     801fda <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edc:	50                   	push   %eax
  801edd:	e8 fa f0 ff ff       	call   800fdc <fd_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	0f 88 db 00 00 00    	js     801fca <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 07 04 00 00       	push   $0x407
  801ef7:	ff 75 f0             	pushl  -0x10(%ebp)
  801efa:	6a 00                	push   $0x0
  801efc:	e8 78 ee ff ff       	call   800d79 <sys_page_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	85 c0                	test   %eax,%eax
  801f08:	0f 88 bc 00 00 00    	js     801fca <pipe+0x135>
	va = fd2data(fd0);
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	ff 75 f4             	pushl  -0xc(%ebp)
  801f14:	e8 a8 f0 ff ff       	call   800fc1 <fd2data>
  801f19:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1b:	83 c4 0c             	add    $0xc,%esp
  801f1e:	68 07 04 00 00       	push   $0x407
  801f23:	50                   	push   %eax
  801f24:	6a 00                	push   $0x0
  801f26:	e8 4e ee ff ff       	call   800d79 <sys_page_alloc>
  801f2b:	89 c3                	mov    %eax,%ebx
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	85 c0                	test   %eax,%eax
  801f32:	0f 88 82 00 00 00    	js     801fba <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3e:	e8 7e f0 ff ff       	call   800fc1 <fd2data>
  801f43:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f4a:	50                   	push   %eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	56                   	push   %esi
  801f4e:	6a 00                	push   $0x0
  801f50:	e8 6b ee ff ff       	call   800dc0 <sys_page_map>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	83 c4 20             	add    $0x20,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 4e                	js     801fac <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f66:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f75:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	ff 75 f4             	pushl  -0xc(%ebp)
  801f87:	e8 21 f0 ff ff       	call   800fad <fd2num>
  801f8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f91:	83 c4 04             	add    $0x4,%esp
  801f94:	ff 75 f0             	pushl  -0x10(%ebp)
  801f97:	e8 11 f0 ff ff       	call   800fad <fd2num>
  801f9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801faa:	eb 2e                	jmp    801fda <pipe+0x145>
	sys_page_unmap(0, va);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	56                   	push   %esi
  801fb0:	6a 00                	push   $0x0
  801fb2:	e8 4f ee ff ff       	call   800e06 <sys_page_unmap>
  801fb7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fba:	83 ec 08             	sub    $0x8,%esp
  801fbd:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc0:	6a 00                	push   $0x0
  801fc2:	e8 3f ee ff ff       	call   800e06 <sys_page_unmap>
  801fc7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fca:	83 ec 08             	sub    $0x8,%esp
  801fcd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd0:	6a 00                	push   $0x0
  801fd2:	e8 2f ee ff ff       	call   800e06 <sys_page_unmap>
  801fd7:	83 c4 10             	add    $0x10,%esp
}
  801fda:	89 d8                	mov    %ebx,%eax
  801fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdf:	5b                   	pop    %ebx
  801fe0:	5e                   	pop    %esi
  801fe1:	5d                   	pop    %ebp
  801fe2:	c3                   	ret    

00801fe3 <pipeisclosed>:
{
  801fe3:	f3 0f 1e fb          	endbr32 
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff0:	50                   	push   %eax
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	e8 39 f0 ff ff       	call   801032 <fd_lookup>
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	78 18                	js     802018 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 b6 ef ff ff       	call   800fc1 <fd2data>
  80200b:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	e8 1f fd ff ff       	call   801d34 <_pipeisclosed>
  802015:	83 c4 10             	add    $0x10,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80201a:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	c3                   	ret    

00802024 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802024:	f3 0f 1e fb          	endbr32 
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80202e:	68 67 2a 80 00       	push   $0x802a67
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	e8 fc e8 ff ff       	call   800937 <strcpy>
	return 0;
}
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <devcons_write>:
{
  802042:	f3 0f 1e fb          	endbr32 
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	57                   	push   %edi
  80204a:	56                   	push   %esi
  80204b:	53                   	push   %ebx
  80204c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802052:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802057:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80205d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802060:	73 31                	jae    802093 <devcons_write+0x51>
		m = n - tot;
  802062:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802065:	29 f3                	sub    %esi,%ebx
  802067:	83 fb 7f             	cmp    $0x7f,%ebx
  80206a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80206f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	53                   	push   %ebx
  802076:	89 f0                	mov    %esi,%eax
  802078:	03 45 0c             	add    0xc(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	57                   	push   %edi
  80207d:	e8 6b ea ff ff       	call   800aed <memmove>
		sys_cputs(buf, m);
  802082:	83 c4 08             	add    $0x8,%esp
  802085:	53                   	push   %ebx
  802086:	57                   	push   %edi
  802087:	e8 1d ec ff ff       	call   800ca9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80208c:	01 de                	add    %ebx,%esi
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	eb ca                	jmp    80205d <devcons_write+0x1b>
}
  802093:	89 f0                	mov    %esi,%eax
  802095:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802098:	5b                   	pop    %ebx
  802099:	5e                   	pop    %esi
  80209a:	5f                   	pop    %edi
  80209b:	5d                   	pop    %ebp
  80209c:	c3                   	ret    

0080209d <devcons_read>:
{
  80209d:	f3 0f 1e fb          	endbr32 
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b0:	74 21                	je     8020d3 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8020b2:	e8 14 ec ff ff       	call   800ccb <sys_cgetc>
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	75 07                	jne    8020c2 <devcons_read+0x25>
		sys_yield();
  8020bb:	e8 96 ec ff ff       	call   800d56 <sys_yield>
  8020c0:	eb f0                	jmp    8020b2 <devcons_read+0x15>
	if (c < 0)
  8020c2:	78 0f                	js     8020d3 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8020c4:	83 f8 04             	cmp    $0x4,%eax
  8020c7:	74 0c                	je     8020d5 <devcons_read+0x38>
	*(char*)vbuf = c;
  8020c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cc:	88 02                	mov    %al,(%edx)
	return 1;
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    
		return 0;
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020da:	eb f7                	jmp    8020d3 <devcons_read+0x36>

008020dc <cputchar>:
{
  8020dc:	f3 0f 1e fb          	endbr32 
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ec:	6a 01                	push   $0x1
  8020ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f1:	50                   	push   %eax
  8020f2:	e8 b2 eb ff ff       	call   800ca9 <sys_cputs>
}
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <getchar>:
{
  8020fc:	f3 0f 1e fb          	endbr32 
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802106:	6a 01                	push   $0x1
  802108:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210b:	50                   	push   %eax
  80210c:	6a 00                	push   $0x0
  80210e:	e8 a7 f1 ff ff       	call   8012ba <read>
	if (r < 0)
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	85 c0                	test   %eax,%eax
  802118:	78 06                	js     802120 <getchar+0x24>
	if (r < 1)
  80211a:	74 06                	je     802122 <getchar+0x26>
	return c;
  80211c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    
		return -E_EOF;
  802122:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802127:	eb f7                	jmp    802120 <getchar+0x24>

00802129 <iscons>:
{
  802129:	f3 0f 1e fb          	endbr32 
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802133:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802136:	50                   	push   %eax
  802137:	ff 75 08             	pushl  0x8(%ebp)
  80213a:	e8 f3 ee ff ff       	call   801032 <fd_lookup>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	85 c0                	test   %eax,%eax
  802144:	78 11                	js     802157 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80214f:	39 10                	cmp    %edx,(%eax)
  802151:	0f 94 c0             	sete   %al
  802154:	0f b6 c0             	movzbl %al,%eax
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <opencons>:
{
  802159:	f3 0f 1e fb          	endbr32 
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	e8 70 ee ff ff       	call   800fdc <fd_alloc>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 3a                	js     8021ad <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	68 07 04 00 00       	push   $0x407
  80217b:	ff 75 f4             	pushl  -0xc(%ebp)
  80217e:	6a 00                	push   $0x0
  802180:	e8 f4 eb ff ff       	call   800d79 <sys_page_alloc>
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 21                	js     8021ad <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802195:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	50                   	push   %eax
  8021a5:	e8 03 ee ff ff       	call   800fad <fd2num>
  8021aa:	83 c4 10             	add    $0x10,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021af:	f3 0f 1e fb          	endbr32 
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	56                   	push   %esi
  8021b7:	53                   	push   %ebx
  8021b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8021bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8021c1:	83 e8 01             	sub    $0x1,%eax
  8021c4:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8021c9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021ce:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	50                   	push   %eax
  8021d6:	e8 6a ed ff ff       	call   800f45 <sys_ipc_recv>
	if (!t) {
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 2b                	jne    80220d <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8021e2:	85 f6                	test   %esi,%esi
  8021e4:	74 0a                	je     8021f0 <ipc_recv+0x41>
  8021e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021eb:	8b 40 74             	mov    0x74(%eax),%eax
  8021ee:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8021f0:	85 db                	test   %ebx,%ebx
  8021f2:	74 0a                	je     8021fe <ipc_recv+0x4f>
  8021f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f9:	8b 40 78             	mov    0x78(%eax),%eax
  8021fc:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8021fe:	a1 08 40 80 00       	mov    0x804008,%eax
  802203:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802206:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802209:	5b                   	pop    %ebx
  80220a:	5e                   	pop    %esi
  80220b:	5d                   	pop    %ebp
  80220c:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80220d:	85 f6                	test   %esi,%esi
  80220f:	74 06                	je     802217 <ipc_recv+0x68>
  802211:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802217:	85 db                	test   %ebx,%ebx
  802219:	74 eb                	je     802206 <ipc_recv+0x57>
  80221b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802221:	eb e3                	jmp    802206 <ipc_recv+0x57>

00802223 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802223:	f3 0f 1e fb          	endbr32 
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	57                   	push   %edi
  80222b:	56                   	push   %esi
  80222c:	53                   	push   %ebx
  80222d:	83 ec 0c             	sub    $0xc,%esp
  802230:	8b 7d 08             	mov    0x8(%ebp),%edi
  802233:	8b 75 0c             	mov    0xc(%ebp),%esi
  802236:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802239:	85 db                	test   %ebx,%ebx
  80223b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802240:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802243:	ff 75 14             	pushl  0x14(%ebp)
  802246:	53                   	push   %ebx
  802247:	56                   	push   %esi
  802248:	57                   	push   %edi
  802249:	e8 d0 ec ff ff       	call   800f1e <sys_ipc_try_send>
  80224e:	83 c4 10             	add    $0x10,%esp
  802251:	85 c0                	test   %eax,%eax
  802253:	74 1e                	je     802273 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802255:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802258:	75 07                	jne    802261 <ipc_send+0x3e>
		sys_yield();
  80225a:	e8 f7 ea ff ff       	call   800d56 <sys_yield>
  80225f:	eb e2                	jmp    802243 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802261:	50                   	push   %eax
  802262:	68 73 2a 80 00       	push   $0x802a73
  802267:	6a 39                	push   $0x39
  802269:	68 85 2a 80 00       	push   $0x802a85
  80226e:	e8 d3 df ff ff       	call   800246 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802276:	5b                   	pop    %ebx
  802277:	5e                   	pop    %esi
  802278:	5f                   	pop    %edi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80227b:	f3 0f 1e fb          	endbr32 
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80228a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80228d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802293:	8b 52 50             	mov    0x50(%edx),%edx
  802296:	39 ca                	cmp    %ecx,%edx
  802298:	74 11                	je     8022ab <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80229a:	83 c0 01             	add    $0x1,%eax
  80229d:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022a2:	75 e6                	jne    80228a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a9:	eb 0b                	jmp    8022b6 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8022ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022b3:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b8:	f3 0f 1e fb          	endbr32 
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022c2:	89 c2                	mov    %eax,%edx
  8022c4:	c1 ea 16             	shr    $0x16,%edx
  8022c7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8022ce:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8022d3:	f6 c1 01             	test   $0x1,%cl
  8022d6:	74 1c                	je     8022f4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8022d8:	c1 e8 0c             	shr    $0xc,%eax
  8022db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022e2:	a8 01                	test   $0x1,%al
  8022e4:	74 0e                	je     8022f4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022e6:	c1 e8 0c             	shr    $0xc,%eax
  8022e9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8022f0:	ef 
  8022f1:	0f b7 d2             	movzwl %dx,%edx
}
  8022f4:	89 d0                	mov    %edx,%eax
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <__udivdi3>:
  802300:	f3 0f 1e fb          	endbr32 
  802304:	55                   	push   %ebp
  802305:	57                   	push   %edi
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	83 ec 1c             	sub    $0x1c,%esp
  80230b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80230f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802313:	8b 74 24 34          	mov    0x34(%esp),%esi
  802317:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80231b:	85 d2                	test   %edx,%edx
  80231d:	75 19                	jne    802338 <__udivdi3+0x38>
  80231f:	39 f3                	cmp    %esi,%ebx
  802321:	76 4d                	jbe    802370 <__udivdi3+0x70>
  802323:	31 ff                	xor    %edi,%edi
  802325:	89 e8                	mov    %ebp,%eax
  802327:	89 f2                	mov    %esi,%edx
  802329:	f7 f3                	div    %ebx
  80232b:	89 fa                	mov    %edi,%edx
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	76 14                	jbe    802350 <__udivdi3+0x50>
  80233c:	31 ff                	xor    %edi,%edi
  80233e:	31 c0                	xor    %eax,%eax
  802340:	89 fa                	mov    %edi,%edx
  802342:	83 c4 1c             	add    $0x1c,%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    
  80234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802350:	0f bd fa             	bsr    %edx,%edi
  802353:	83 f7 1f             	xor    $0x1f,%edi
  802356:	75 48                	jne    8023a0 <__udivdi3+0xa0>
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	72 06                	jb     802362 <__udivdi3+0x62>
  80235c:	31 c0                	xor    %eax,%eax
  80235e:	39 eb                	cmp    %ebp,%ebx
  802360:	77 de                	ja     802340 <__udivdi3+0x40>
  802362:	b8 01 00 00 00       	mov    $0x1,%eax
  802367:	eb d7                	jmp    802340 <__udivdi3+0x40>
  802369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802370:	89 d9                	mov    %ebx,%ecx
  802372:	85 db                	test   %ebx,%ebx
  802374:	75 0b                	jne    802381 <__udivdi3+0x81>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	31 d2                	xor    %edx,%edx
  80237d:	f7 f3                	div    %ebx
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	31 d2                	xor    %edx,%edx
  802383:	89 f0                	mov    %esi,%eax
  802385:	f7 f1                	div    %ecx
  802387:	89 c6                	mov    %eax,%esi
  802389:	89 e8                	mov    %ebp,%eax
  80238b:	89 f7                	mov    %esi,%edi
  80238d:	f7 f1                	div    %ecx
  80238f:	89 fa                	mov    %edi,%edx
  802391:	83 c4 1c             	add    $0x1c,%esp
  802394:	5b                   	pop    %ebx
  802395:	5e                   	pop    %esi
  802396:	5f                   	pop    %edi
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    
  802399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a0:	89 f9                	mov    %edi,%ecx
  8023a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023a7:	29 f8                	sub    %edi,%eax
  8023a9:	d3 e2                	shl    %cl,%edx
  8023ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023af:	89 c1                	mov    %eax,%ecx
  8023b1:	89 da                	mov    %ebx,%edx
  8023b3:	d3 ea                	shr    %cl,%edx
  8023b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023b9:	09 d1                	or     %edx,%ecx
  8023bb:	89 f2                	mov    %esi,%edx
  8023bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023c1:	89 f9                	mov    %edi,%ecx
  8023c3:	d3 e3                	shl    %cl,%ebx
  8023c5:	89 c1                	mov    %eax,%ecx
  8023c7:	d3 ea                	shr    %cl,%edx
  8023c9:	89 f9                	mov    %edi,%ecx
  8023cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023cf:	89 eb                	mov    %ebp,%ebx
  8023d1:	d3 e6                	shl    %cl,%esi
  8023d3:	89 c1                	mov    %eax,%ecx
  8023d5:	d3 eb                	shr    %cl,%ebx
  8023d7:	09 de                	or     %ebx,%esi
  8023d9:	89 f0                	mov    %esi,%eax
  8023db:	f7 74 24 08          	divl   0x8(%esp)
  8023df:	89 d6                	mov    %edx,%esi
  8023e1:	89 c3                	mov    %eax,%ebx
  8023e3:	f7 64 24 0c          	mull   0xc(%esp)
  8023e7:	39 d6                	cmp    %edx,%esi
  8023e9:	72 15                	jb     802400 <__udivdi3+0x100>
  8023eb:	89 f9                	mov    %edi,%ecx
  8023ed:	d3 e5                	shl    %cl,%ebp
  8023ef:	39 c5                	cmp    %eax,%ebp
  8023f1:	73 04                	jae    8023f7 <__udivdi3+0xf7>
  8023f3:	39 d6                	cmp    %edx,%esi
  8023f5:	74 09                	je     802400 <__udivdi3+0x100>
  8023f7:	89 d8                	mov    %ebx,%eax
  8023f9:	31 ff                	xor    %edi,%edi
  8023fb:	e9 40 ff ff ff       	jmp    802340 <__udivdi3+0x40>
  802400:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802403:	31 ff                	xor    %edi,%edi
  802405:	e9 36 ff ff ff       	jmp    802340 <__udivdi3+0x40>
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__umoddi3>:
  802410:	f3 0f 1e fb          	endbr32 
  802414:	55                   	push   %ebp
  802415:	57                   	push   %edi
  802416:	56                   	push   %esi
  802417:	53                   	push   %ebx
  802418:	83 ec 1c             	sub    $0x1c,%esp
  80241b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80241f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802423:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 19                	jne    802448 <__umoddi3+0x38>
  80242f:	39 df                	cmp    %ebx,%edi
  802431:	76 5d                	jbe    802490 <__umoddi3+0x80>
  802433:	89 f0                	mov    %esi,%eax
  802435:	89 da                	mov    %ebx,%edx
  802437:	f7 f7                	div    %edi
  802439:	89 d0                	mov    %edx,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	83 c4 1c             	add    $0x1c,%esp
  802440:	5b                   	pop    %ebx
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	89 f2                	mov    %esi,%edx
  80244a:	39 d8                	cmp    %ebx,%eax
  80244c:	76 12                	jbe    802460 <__umoddi3+0x50>
  80244e:	89 f0                	mov    %esi,%eax
  802450:	89 da                	mov    %ebx,%edx
  802452:	83 c4 1c             	add    $0x1c,%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    
  80245a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802460:	0f bd e8             	bsr    %eax,%ebp
  802463:	83 f5 1f             	xor    $0x1f,%ebp
  802466:	75 50                	jne    8024b8 <__umoddi3+0xa8>
  802468:	39 d8                	cmp    %ebx,%eax
  80246a:	0f 82 e0 00 00 00    	jb     802550 <__umoddi3+0x140>
  802470:	89 d9                	mov    %ebx,%ecx
  802472:	39 f7                	cmp    %esi,%edi
  802474:	0f 86 d6 00 00 00    	jbe    802550 <__umoddi3+0x140>
  80247a:	89 d0                	mov    %edx,%eax
  80247c:	89 ca                	mov    %ecx,%edx
  80247e:	83 c4 1c             	add    $0x1c,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5f                   	pop    %edi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    
  802486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	89 fd                	mov    %edi,%ebp
  802492:	85 ff                	test   %edi,%edi
  802494:	75 0b                	jne    8024a1 <__umoddi3+0x91>
  802496:	b8 01 00 00 00       	mov    $0x1,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f7                	div    %edi
  80249f:	89 c5                	mov    %eax,%ebp
  8024a1:	89 d8                	mov    %ebx,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f5                	div    %ebp
  8024a7:	89 f0                	mov    %esi,%eax
  8024a9:	f7 f5                	div    %ebp
  8024ab:	89 d0                	mov    %edx,%eax
  8024ad:	31 d2                	xor    %edx,%edx
  8024af:	eb 8c                	jmp    80243d <__umoddi3+0x2d>
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0x10b>
  802515:	75 10                	jne    802527 <__umoddi3+0x117>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x117>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	29 fe                	sub    %edi,%esi
  802552:	19 c3                	sbb    %eax,%ebx
  802554:	89 f2                	mov    %esi,%edx
  802556:	89 d9                	mov    %ebx,%ecx
  802558:	e9 1d ff ff ff       	jmp    80247a <__umoddi3+0x6a>
