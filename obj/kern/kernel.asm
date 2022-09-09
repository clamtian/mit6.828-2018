
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 30 12 f0       	mov    $0xf0123000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 62 00 00 00       	call   f01000a0 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	f3 0f 1e fb          	endbr32 
f0100044:	55                   	push   %ebp
f0100045:	89 e5                	mov    %esp,%ebp
f0100047:	56                   	push   %esi
f0100048:	53                   	push   %ebx
f0100049:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004c:	83 3d 8c ee 2b f0 00 	cmpl   $0x0,0xf02bee8c
f0100053:	74 0f                	je     f0100064 <_panic+0x24>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100055:	83 ec 0c             	sub    $0xc,%esp
f0100058:	6a 00                	push   $0x0
f010005a:	e8 1a 09 00 00       	call   f0100979 <monitor>
f010005f:	83 c4 10             	add    $0x10,%esp
f0100062:	eb f1                	jmp    f0100055 <_panic+0x15>
	panicstr = fmt;
f0100064:	89 35 8c ee 2b f0    	mov    %esi,0xf02bee8c
	asm volatile("cli; cld");
f010006a:	fa                   	cli    
f010006b:	fc                   	cld    
	va_start(ap, fmt);
f010006c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006f:	e8 5a 5d 00 00       	call   f0105dce <cpunum>
f0100074:	ff 75 0c             	pushl  0xc(%ebp)
f0100077:	ff 75 08             	pushl  0x8(%ebp)
f010007a:	50                   	push   %eax
f010007b:	68 00 6a 10 f0       	push   $0xf0106a00
f0100080:	e8 e2 38 00 00       	call   f0103967 <cprintf>
	vcprintf(fmt, ap);
f0100085:	83 c4 08             	add    $0x8,%esp
f0100088:	53                   	push   %ebx
f0100089:	56                   	push   %esi
f010008a:	e8 ae 38 00 00       	call   f010393d <vcprintf>
	cprintf("\n");
f010008f:	c7 04 24 6f 72 10 f0 	movl   $0xf010726f,(%esp)
f0100096:	e8 cc 38 00 00       	call   f0103967 <cprintf>
f010009b:	83 c4 10             	add    $0x10,%esp
f010009e:	eb b5                	jmp    f0100055 <_panic+0x15>

f01000a0 <i386_init>:
{
f01000a0:	f3 0f 1e fb          	endbr32 
f01000a4:	55                   	push   %ebp
f01000a5:	89 e5                	mov    %esp,%ebp
f01000a7:	53                   	push   %ebx
f01000a8:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000ab:	e8 b3 05 00 00       	call   f0100663 <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b0:	83 ec 08             	sub    $0x8,%esp
f01000b3:	68 ac 1a 00 00       	push   $0x1aac
f01000b8:	68 6c 6a 10 f0       	push   $0xf0106a6c
f01000bd:	e8 a5 38 00 00       	call   f0103967 <cprintf>
	mem_init();
f01000c2:	e8 88 12 00 00       	call   f010134f <mem_init>
	env_init();
f01000c7:	e8 ab 30 00 00       	call   f0103177 <env_init>
	trap_init();
f01000cc:	e8 92 39 00 00       	call   f0103a63 <trap_init>
	mp_init();
f01000d1:	e8 f9 59 00 00       	call   f0105acf <mp_init>
	lapic_init();
f01000d6:	e8 0d 5d 00 00       	call   f0105de8 <lapic_init>
	pic_init();
f01000db:	e8 86 37 00 00       	call   f0103866 <pic_init>
	time_init();
f01000e0:	e8 52 66 00 00       	call   f0106737 <time_init>
	pci_init();
f01000e5:	e8 29 66 00 00       	call   f0106713 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000ea:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f01000f1:	e8 60 5f 00 00       	call   f0106056 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000f6:	83 c4 10             	add    $0x10,%esp
f01000f9:	83 3d 94 ee 2b f0 07 	cmpl   $0x7,0xf02bee94
f0100100:	76 27                	jbe    f0100129 <i386_init+0x89>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f0100102:	83 ec 04             	sub    $0x4,%esp
f0100105:	b8 32 5a 10 f0       	mov    $0xf0105a32,%eax
f010010a:	2d b8 59 10 f0       	sub    $0xf01059b8,%eax
f010010f:	50                   	push   %eax
f0100110:	68 b8 59 10 f0       	push   $0xf01059b8
f0100115:	68 00 70 00 f0       	push   $0xf0007000
f010011a:	e8 db 56 00 00       	call   f01057fa <memmove>
	for (c = cpus; c < cpus + ncpu; c++) {
f010011f:	83 c4 10             	add    $0x10,%esp
f0100122:	bb 20 f0 2b f0       	mov    $0xf02bf020,%ebx
f0100127:	eb 53                	jmp    f010017c <i386_init+0xdc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100129:	68 00 70 00 00       	push   $0x7000
f010012e:	68 24 6a 10 f0       	push   $0xf0106a24
f0100133:	6a 5e                	push   $0x5e
f0100135:	68 87 6a 10 f0       	push   $0xf0106a87
f010013a:	e8 01 ff ff ff       	call   f0100040 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010013f:	89 d8                	mov    %ebx,%eax
f0100141:	2d 20 f0 2b f0       	sub    $0xf02bf020,%eax
f0100146:	c1 f8 02             	sar    $0x2,%eax
f0100149:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010014f:	c1 e0 0f             	shl    $0xf,%eax
f0100152:	8d 80 00 80 2c f0    	lea    -0xfd38000(%eax),%eax
f0100158:	a3 90 ee 2b f0       	mov    %eax,0xf02bee90
		lapic_startap(c->cpu_id, PADDR(code));
f010015d:	83 ec 08             	sub    $0x8,%esp
f0100160:	68 00 70 00 00       	push   $0x7000
f0100165:	0f b6 03             	movzbl (%ebx),%eax
f0100168:	50                   	push   %eax
f0100169:	e8 d4 5d 00 00       	call   f0105f42 <lapic_startap>
		while(c->cpu_status != CPU_STARTED)
f010016e:	83 c4 10             	add    $0x10,%esp
f0100171:	8b 43 04             	mov    0x4(%ebx),%eax
f0100174:	83 f8 01             	cmp    $0x1,%eax
f0100177:	75 f8                	jne    f0100171 <i386_init+0xd1>
	for (c = cpus; c < cpus + ncpu; c++) {
f0100179:	83 c3 74             	add    $0x74,%ebx
f010017c:	6b 05 c4 f3 2b f0 74 	imul   $0x74,0xf02bf3c4,%eax
f0100183:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
f0100188:	39 c3                	cmp    %eax,%ebx
f010018a:	73 13                	jae    f010019f <i386_init+0xff>
		if (c == cpus + cpunum())  // We've started already.
f010018c:	e8 3d 5c 00 00       	call   f0105dce <cpunum>
f0100191:	6b c0 74             	imul   $0x74,%eax,%eax
f0100194:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
f0100199:	39 c3                	cmp    %eax,%ebx
f010019b:	74 dc                	je     f0100179 <i386_init+0xd9>
f010019d:	eb a0                	jmp    f010013f <i386_init+0x9f>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f010019f:	83 ec 08             	sub    $0x8,%esp
f01001a2:	6a 01                	push   $0x1
f01001a4:	68 50 ee 1d f0       	push   $0xf01dee50
f01001a9:	e8 8e 31 00 00       	call   f010333c <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001ae:	83 c4 08             	add    $0x8,%esp
f01001b1:	6a 00                	push   $0x0
f01001b3:	68 b4 5f 22 f0       	push   $0xf0225fb4
f01001b8:	e8 7f 31 00 00       	call   f010333c <env_create>
	kbd_intr();
f01001bd:	e8 45 04 00 00       	call   f0100607 <kbd_intr>
	sched_yield();
f01001c2:	e8 9c 43 00 00       	call   f0104563 <sched_yield>

f01001c7 <mp_main>:
{
f01001c7:	f3 0f 1e fb          	endbr32 
f01001cb:	55                   	push   %ebp
f01001cc:	89 e5                	mov    %esp,%ebp
f01001ce:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001d1:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f01001d6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001db:	76 52                	jbe    f010022f <mp_main+0x68>
	return (physaddr_t)kva - KERNBASE;
f01001dd:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001e2:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001e5:	e8 e4 5b 00 00       	call   f0105dce <cpunum>
f01001ea:	83 ec 08             	sub    $0x8,%esp
f01001ed:	50                   	push   %eax
f01001ee:	68 93 6a 10 f0       	push   $0xf0106a93
f01001f3:	e8 6f 37 00 00       	call   f0103967 <cprintf>
	lapic_init();
f01001f8:	e8 eb 5b 00 00       	call   f0105de8 <lapic_init>
	env_init_percpu();
f01001fd:	e8 45 2f 00 00       	call   f0103147 <env_init_percpu>
	trap_init_percpu();
f0100202:	e8 78 37 00 00       	call   f010397f <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100207:	e8 c2 5b 00 00       	call   f0105dce <cpunum>
f010020c:	6b d0 74             	imul   $0x74,%eax,%edx
f010020f:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100212:	b8 01 00 00 00       	mov    $0x1,%eax
f0100217:	f0 87 82 20 f0 2b f0 	lock xchg %eax,-0xfd40fe0(%edx)
f010021e:	c7 04 24 c0 53 12 f0 	movl   $0xf01253c0,(%esp)
f0100225:	e8 2c 5e 00 00       	call   f0106056 <spin_lock>
	sched_yield();
f010022a:	e8 34 43 00 00       	call   f0104563 <sched_yield>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010022f:	50                   	push   %eax
f0100230:	68 48 6a 10 f0       	push   $0xf0106a48
f0100235:	6a 75                	push   $0x75
f0100237:	68 87 6a 10 f0       	push   $0xf0106a87
f010023c:	e8 ff fd ff ff       	call   f0100040 <_panic>

f0100241 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100241:	f3 0f 1e fb          	endbr32 
f0100245:	55                   	push   %ebp
f0100246:	89 e5                	mov    %esp,%ebp
f0100248:	53                   	push   %ebx
f0100249:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010024c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010024f:	ff 75 0c             	pushl  0xc(%ebp)
f0100252:	ff 75 08             	pushl  0x8(%ebp)
f0100255:	68 a9 6a 10 f0       	push   $0xf0106aa9
f010025a:	e8 08 37 00 00       	call   f0103967 <cprintf>
	vcprintf(fmt, ap);
f010025f:	83 c4 08             	add    $0x8,%esp
f0100262:	53                   	push   %ebx
f0100263:	ff 75 10             	pushl  0x10(%ebp)
f0100266:	e8 d2 36 00 00       	call   f010393d <vcprintf>
	cprintf("\n");
f010026b:	c7 04 24 6f 72 10 f0 	movl   $0xf010726f,(%esp)
f0100272:	e8 f0 36 00 00       	call   f0103967 <cprintf>
	va_end(ap);
}
f0100277:	83 c4 10             	add    $0x10,%esp
f010027a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010027d:	c9                   	leave  
f010027e:	c3                   	ret    

f010027f <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010027f:	f3 0f 1e fb          	endbr32 
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100283:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100288:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100289:	a8 01                	test   $0x1,%al
f010028b:	74 0a                	je     f0100297 <serial_proc_data+0x18>
f010028d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100292:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100293:	0f b6 c0             	movzbl %al,%eax
f0100296:	c3                   	ret    
		return -1;
f0100297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f010029c:	c3                   	ret    

f010029d <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010029d:	55                   	push   %ebp
f010029e:	89 e5                	mov    %esp,%ebp
f01002a0:	53                   	push   %ebx
f01002a1:	83 ec 04             	sub    $0x4,%esp
f01002a4:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002a6:	ff d3                	call   *%ebx
f01002a8:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002ab:	74 29                	je     f01002d6 <cons_intr+0x39>
		if (c == 0)
f01002ad:	85 c0                	test   %eax,%eax
f01002af:	74 f5                	je     f01002a6 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002b1:	8b 0d 24 e2 2b f0    	mov    0xf02be224,%ecx
f01002b7:	8d 51 01             	lea    0x1(%ecx),%edx
f01002ba:	88 81 20 e0 2b f0    	mov    %al,-0xfd41fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002c0:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.wpos = 0;
f01002c6:	b8 00 00 00 00       	mov    $0x0,%eax
f01002cb:	0f 44 d0             	cmove  %eax,%edx
f01002ce:	89 15 24 e2 2b f0    	mov    %edx,0xf02be224
f01002d4:	eb d0                	jmp    f01002a6 <cons_intr+0x9>
	}
}
f01002d6:	83 c4 04             	add    $0x4,%esp
f01002d9:	5b                   	pop    %ebx
f01002da:	5d                   	pop    %ebp
f01002db:	c3                   	ret    

f01002dc <kbd_proc_data>:
{
f01002dc:	f3 0f 1e fb          	endbr32 
f01002e0:	55                   	push   %ebp
f01002e1:	89 e5                	mov    %esp,%ebp
f01002e3:	53                   	push   %ebx
f01002e4:	83 ec 04             	sub    $0x4,%esp
f01002e7:	ba 64 00 00 00       	mov    $0x64,%edx
f01002ec:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002ed:	a8 01                	test   $0x1,%al
f01002ef:	0f 84 f2 00 00 00    	je     f01003e7 <kbd_proc_data+0x10b>
	if (stat & KBS_TERR)
f01002f5:	a8 20                	test   $0x20,%al
f01002f7:	0f 85 f1 00 00 00    	jne    f01003ee <kbd_proc_data+0x112>
f01002fd:	ba 60 00 00 00       	mov    $0x60,%edx
f0100302:	ec                   	in     (%dx),%al
f0100303:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100305:	3c e0                	cmp    $0xe0,%al
f0100307:	74 61                	je     f010036a <kbd_proc_data+0x8e>
	} else if (data & 0x80) {
f0100309:	84 c0                	test   %al,%al
f010030b:	78 70                	js     f010037d <kbd_proc_data+0xa1>
	} else if (shift & E0ESC) {
f010030d:	8b 0d 00 e0 2b f0    	mov    0xf02be000,%ecx
f0100313:	f6 c1 40             	test   $0x40,%cl
f0100316:	74 0e                	je     f0100326 <kbd_proc_data+0x4a>
		data |= 0x80;
f0100318:	83 c8 80             	or     $0xffffff80,%eax
f010031b:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f010031d:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100320:	89 0d 00 e0 2b f0    	mov    %ecx,0xf02be000
	shift |= shiftcode[data];
f0100326:	0f b6 d2             	movzbl %dl,%edx
f0100329:	0f b6 82 20 6c 10 f0 	movzbl -0xfef93e0(%edx),%eax
f0100330:	0b 05 00 e0 2b f0    	or     0xf02be000,%eax
	shift ^= togglecode[data];
f0100336:	0f b6 8a 20 6b 10 f0 	movzbl -0xfef94e0(%edx),%ecx
f010033d:	31 c8                	xor    %ecx,%eax
f010033f:	a3 00 e0 2b f0       	mov    %eax,0xf02be000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100344:	89 c1                	mov    %eax,%ecx
f0100346:	83 e1 03             	and    $0x3,%ecx
f0100349:	8b 0c 8d 00 6b 10 f0 	mov    -0xfef9500(,%ecx,4),%ecx
f0100350:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100354:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100357:	a8 08                	test   $0x8,%al
f0100359:	74 61                	je     f01003bc <kbd_proc_data+0xe0>
		if ('a' <= c && c <= 'z')
f010035b:	89 da                	mov    %ebx,%edx
f010035d:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100360:	83 f9 19             	cmp    $0x19,%ecx
f0100363:	77 4b                	ja     f01003b0 <kbd_proc_data+0xd4>
			c += 'A' - 'a';
f0100365:	83 eb 20             	sub    $0x20,%ebx
f0100368:	eb 0c                	jmp    f0100376 <kbd_proc_data+0x9a>
		shift |= E0ESC;
f010036a:	83 0d 00 e0 2b f0 40 	orl    $0x40,0xf02be000
		return 0;
f0100371:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0100376:	89 d8                	mov    %ebx,%eax
f0100378:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010037b:	c9                   	leave  
f010037c:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f010037d:	8b 0d 00 e0 2b f0    	mov    0xf02be000,%ecx
f0100383:	89 cb                	mov    %ecx,%ebx
f0100385:	83 e3 40             	and    $0x40,%ebx
f0100388:	83 e0 7f             	and    $0x7f,%eax
f010038b:	85 db                	test   %ebx,%ebx
f010038d:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f0100390:	0f b6 d2             	movzbl %dl,%edx
f0100393:	0f b6 82 20 6c 10 f0 	movzbl -0xfef93e0(%edx),%eax
f010039a:	83 c8 40             	or     $0x40,%eax
f010039d:	0f b6 c0             	movzbl %al,%eax
f01003a0:	f7 d0                	not    %eax
f01003a2:	21 c8                	and    %ecx,%eax
f01003a4:	a3 00 e0 2b f0       	mov    %eax,0xf02be000
		return 0;
f01003a9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003ae:	eb c6                	jmp    f0100376 <kbd_proc_data+0x9a>
		else if ('A' <= c && c <= 'Z')
f01003b0:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003b3:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003b6:	83 fa 1a             	cmp    $0x1a,%edx
f01003b9:	0f 42 d9             	cmovb  %ecx,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f01003bc:	f7 d0                	not    %eax
f01003be:	a8 06                	test   $0x6,%al
f01003c0:	75 b4                	jne    f0100376 <kbd_proc_data+0x9a>
f01003c2:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01003c8:	75 ac                	jne    f0100376 <kbd_proc_data+0x9a>
		cprintf("Rebooting!\n");
f01003ca:	83 ec 0c             	sub    $0xc,%esp
f01003cd:	68 c3 6a 10 f0       	push   $0xf0106ac3
f01003d2:	e8 90 35 00 00       	call   f0103967 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01003d7:	b8 03 00 00 00       	mov    $0x3,%eax
f01003dc:	ba 92 00 00 00       	mov    $0x92,%edx
f01003e1:	ee                   	out    %al,(%dx)
}
f01003e2:	83 c4 10             	add    $0x10,%esp
f01003e5:	eb 8f                	jmp    f0100376 <kbd_proc_data+0x9a>
		return -1;
f01003e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003ec:	eb 88                	jmp    f0100376 <kbd_proc_data+0x9a>
		return -1;
f01003ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003f3:	eb 81                	jmp    f0100376 <kbd_proc_data+0x9a>

f01003f5 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003f5:	55                   	push   %ebp
f01003f6:	89 e5                	mov    %esp,%ebp
f01003f8:	57                   	push   %edi
f01003f9:	56                   	push   %esi
f01003fa:	53                   	push   %ebx
f01003fb:	83 ec 1c             	sub    $0x1c,%esp
f01003fe:	89 c1                	mov    %eax,%ecx
	for (i = 0;
f0100400:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100405:	bf fd 03 00 00       	mov    $0x3fd,%edi
f010040a:	bb 84 00 00 00       	mov    $0x84,%ebx
f010040f:	89 fa                	mov    %edi,%edx
f0100411:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100412:	a8 20                	test   $0x20,%al
f0100414:	75 13                	jne    f0100429 <cons_putc+0x34>
f0100416:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010041c:	7f 0b                	jg     f0100429 <cons_putc+0x34>
f010041e:	89 da                	mov    %ebx,%edx
f0100420:	ec                   	in     (%dx),%al
f0100421:	ec                   	in     (%dx),%al
f0100422:	ec                   	in     (%dx),%al
f0100423:	ec                   	in     (%dx),%al
	     i++)
f0100424:	83 c6 01             	add    $0x1,%esi
f0100427:	eb e6                	jmp    f010040f <cons_putc+0x1a>
	outb(COM1 + COM_TX, c);
f0100429:	88 4d e7             	mov    %cl,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010042c:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100431:	89 c8                	mov    %ecx,%eax
f0100433:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100434:	be 00 00 00 00       	mov    $0x0,%esi
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100439:	bf 79 03 00 00       	mov    $0x379,%edi
f010043e:	bb 84 00 00 00       	mov    $0x84,%ebx
f0100443:	89 fa                	mov    %edi,%edx
f0100445:	ec                   	in     (%dx),%al
f0100446:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
f010044c:	7f 0f                	jg     f010045d <cons_putc+0x68>
f010044e:	84 c0                	test   %al,%al
f0100450:	78 0b                	js     f010045d <cons_putc+0x68>
f0100452:	89 da                	mov    %ebx,%edx
f0100454:	ec                   	in     (%dx),%al
f0100455:	ec                   	in     (%dx),%al
f0100456:	ec                   	in     (%dx),%al
f0100457:	ec                   	in     (%dx),%al
f0100458:	83 c6 01             	add    $0x1,%esi
f010045b:	eb e6                	jmp    f0100443 <cons_putc+0x4e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010045d:	ba 78 03 00 00       	mov    $0x378,%edx
f0100462:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100466:	ee                   	out    %al,(%dx)
f0100467:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010046c:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100471:	ee                   	out    %al,(%dx)
f0100472:	b8 08 00 00 00       	mov    $0x8,%eax
f0100477:	ee                   	out    %al,(%dx)
		c |= 0x0700;
f0100478:	89 c8                	mov    %ecx,%eax
f010047a:	80 cc 07             	or     $0x7,%ah
f010047d:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100483:	0f 44 c8             	cmove  %eax,%ecx
	switch (c & 0xff) {
f0100486:	0f b6 c1             	movzbl %cl,%eax
f0100489:	80 f9 0a             	cmp    $0xa,%cl
f010048c:	0f 84 dd 00 00 00    	je     f010056f <cons_putc+0x17a>
f0100492:	83 f8 0a             	cmp    $0xa,%eax
f0100495:	7f 46                	jg     f01004dd <cons_putc+0xe8>
f0100497:	83 f8 08             	cmp    $0x8,%eax
f010049a:	0f 84 a7 00 00 00    	je     f0100547 <cons_putc+0x152>
f01004a0:	83 f8 09             	cmp    $0x9,%eax
f01004a3:	0f 85 d3 00 00 00    	jne    f010057c <cons_putc+0x187>
		cons_putc(' ');
f01004a9:	b8 20 00 00 00       	mov    $0x20,%eax
f01004ae:	e8 42 ff ff ff       	call   f01003f5 <cons_putc>
		cons_putc(' ');
f01004b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01004b8:	e8 38 ff ff ff       	call   f01003f5 <cons_putc>
		cons_putc(' ');
f01004bd:	b8 20 00 00 00       	mov    $0x20,%eax
f01004c2:	e8 2e ff ff ff       	call   f01003f5 <cons_putc>
		cons_putc(' ');
f01004c7:	b8 20 00 00 00       	mov    $0x20,%eax
f01004cc:	e8 24 ff ff ff       	call   f01003f5 <cons_putc>
		cons_putc(' ');
f01004d1:	b8 20 00 00 00       	mov    $0x20,%eax
f01004d6:	e8 1a ff ff ff       	call   f01003f5 <cons_putc>
		break;
f01004db:	eb 25                	jmp    f0100502 <cons_putc+0x10d>
	switch (c & 0xff) {
f01004dd:	83 f8 0d             	cmp    $0xd,%eax
f01004e0:	0f 85 96 00 00 00    	jne    f010057c <cons_putc+0x187>
		crt_pos -= (crt_pos % CRT_COLS);
f01004e6:	0f b7 05 28 e2 2b f0 	movzwl 0xf02be228,%eax
f01004ed:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004f3:	c1 e8 16             	shr    $0x16,%eax
f01004f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004f9:	c1 e0 04             	shl    $0x4,%eax
f01004fc:	66 a3 28 e2 2b f0    	mov    %ax,0xf02be228
	if (crt_pos >= CRT_SIZE) {
f0100502:	66 81 3d 28 e2 2b f0 	cmpw   $0x7cf,0xf02be228
f0100509:	cf 07 
f010050b:	0f 87 8e 00 00 00    	ja     f010059f <cons_putc+0x1aa>
	outb(addr_6845, 14);
f0100511:	8b 0d 30 e2 2b f0    	mov    0xf02be230,%ecx
f0100517:	b8 0e 00 00 00       	mov    $0xe,%eax
f010051c:	89 ca                	mov    %ecx,%edx
f010051e:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010051f:	0f b7 1d 28 e2 2b f0 	movzwl 0xf02be228,%ebx
f0100526:	8d 71 01             	lea    0x1(%ecx),%esi
f0100529:	89 d8                	mov    %ebx,%eax
f010052b:	66 c1 e8 08          	shr    $0x8,%ax
f010052f:	89 f2                	mov    %esi,%edx
f0100531:	ee                   	out    %al,(%dx)
f0100532:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100537:	89 ca                	mov    %ecx,%edx
f0100539:	ee                   	out    %al,(%dx)
f010053a:	89 d8                	mov    %ebx,%eax
f010053c:	89 f2                	mov    %esi,%edx
f010053e:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010053f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100542:	5b                   	pop    %ebx
f0100543:	5e                   	pop    %esi
f0100544:	5f                   	pop    %edi
f0100545:	5d                   	pop    %ebp
f0100546:	c3                   	ret    
		if (crt_pos > 0) {
f0100547:	0f b7 05 28 e2 2b f0 	movzwl 0xf02be228,%eax
f010054e:	66 85 c0             	test   %ax,%ax
f0100551:	74 be                	je     f0100511 <cons_putc+0x11c>
			crt_pos--;
f0100553:	83 e8 01             	sub    $0x1,%eax
f0100556:	66 a3 28 e2 2b f0    	mov    %ax,0xf02be228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010055c:	0f b7 d0             	movzwl %ax,%edx
f010055f:	b1 00                	mov    $0x0,%cl
f0100561:	83 c9 20             	or     $0x20,%ecx
f0100564:	a1 2c e2 2b f0       	mov    0xf02be22c,%eax
f0100569:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f010056d:	eb 93                	jmp    f0100502 <cons_putc+0x10d>
		crt_pos += CRT_COLS;
f010056f:	66 83 05 28 e2 2b f0 	addw   $0x50,0xf02be228
f0100576:	50 
f0100577:	e9 6a ff ff ff       	jmp    f01004e6 <cons_putc+0xf1>
		crt_buf[crt_pos++] = c;		/* write the character */
f010057c:	0f b7 05 28 e2 2b f0 	movzwl 0xf02be228,%eax
f0100583:	8d 50 01             	lea    0x1(%eax),%edx
f0100586:	66 89 15 28 e2 2b f0 	mov    %dx,0xf02be228
f010058d:	0f b7 c0             	movzwl %ax,%eax
f0100590:	8b 15 2c e2 2b f0    	mov    0xf02be22c,%edx
f0100596:	66 89 0c 42          	mov    %cx,(%edx,%eax,2)
		break;
f010059a:	e9 63 ff ff ff       	jmp    f0100502 <cons_putc+0x10d>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010059f:	a1 2c e2 2b f0       	mov    0xf02be22c,%eax
f01005a4:	83 ec 04             	sub    $0x4,%esp
f01005a7:	68 00 0f 00 00       	push   $0xf00
f01005ac:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005b2:	52                   	push   %edx
f01005b3:	50                   	push   %eax
f01005b4:	e8 41 52 00 00       	call   f01057fa <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005b9:	8b 15 2c e2 2b f0    	mov    0xf02be22c,%edx
f01005bf:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005c5:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005cb:	83 c4 10             	add    $0x10,%esp
f01005ce:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005d3:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005d6:	39 d0                	cmp    %edx,%eax
f01005d8:	75 f4                	jne    f01005ce <cons_putc+0x1d9>
		crt_pos -= CRT_COLS;
f01005da:	66 83 2d 28 e2 2b f0 	subw   $0x50,0xf02be228
f01005e1:	50 
f01005e2:	e9 2a ff ff ff       	jmp    f0100511 <cons_putc+0x11c>

f01005e7 <serial_intr>:
{
f01005e7:	f3 0f 1e fb          	endbr32 
	if (serial_exists)
f01005eb:	80 3d 34 e2 2b f0 00 	cmpb   $0x0,0xf02be234
f01005f2:	75 01                	jne    f01005f5 <serial_intr+0xe>
f01005f4:	c3                   	ret    
{
f01005f5:	55                   	push   %ebp
f01005f6:	89 e5                	mov    %esp,%ebp
f01005f8:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01005fb:	b8 7f 02 10 f0       	mov    $0xf010027f,%eax
f0100600:	e8 98 fc ff ff       	call   f010029d <cons_intr>
}
f0100605:	c9                   	leave  
f0100606:	c3                   	ret    

f0100607 <kbd_intr>:
{
f0100607:	f3 0f 1e fb          	endbr32 
f010060b:	55                   	push   %ebp
f010060c:	89 e5                	mov    %esp,%ebp
f010060e:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100611:	b8 dc 02 10 f0       	mov    $0xf01002dc,%eax
f0100616:	e8 82 fc ff ff       	call   f010029d <cons_intr>
}
f010061b:	c9                   	leave  
f010061c:	c3                   	ret    

f010061d <cons_getc>:
{
f010061d:	f3 0f 1e fb          	endbr32 
f0100621:	55                   	push   %ebp
f0100622:	89 e5                	mov    %esp,%ebp
f0100624:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100627:	e8 bb ff ff ff       	call   f01005e7 <serial_intr>
	kbd_intr();
f010062c:	e8 d6 ff ff ff       	call   f0100607 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100631:	a1 20 e2 2b f0       	mov    0xf02be220,%eax
	return 0;
f0100636:	ba 00 00 00 00       	mov    $0x0,%edx
	if (cons.rpos != cons.wpos) {
f010063b:	3b 05 24 e2 2b f0    	cmp    0xf02be224,%eax
f0100641:	74 1c                	je     f010065f <cons_getc+0x42>
		c = cons.buf[cons.rpos++];
f0100643:	8d 48 01             	lea    0x1(%eax),%ecx
f0100646:	0f b6 90 20 e0 2b f0 	movzbl -0xfd41fe0(%eax),%edx
			cons.rpos = 0;
f010064d:	3d ff 01 00 00       	cmp    $0x1ff,%eax
f0100652:	b8 00 00 00 00       	mov    $0x0,%eax
f0100657:	0f 45 c1             	cmovne %ecx,%eax
f010065a:	a3 20 e2 2b f0       	mov    %eax,0xf02be220
}
f010065f:	89 d0                	mov    %edx,%eax
f0100661:	c9                   	leave  
f0100662:	c3                   	ret    

f0100663 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100663:	f3 0f 1e fb          	endbr32 
f0100667:	55                   	push   %ebp
f0100668:	89 e5                	mov    %esp,%ebp
f010066a:	57                   	push   %edi
f010066b:	56                   	push   %esi
f010066c:	53                   	push   %ebx
f010066d:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100670:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f0100677:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f010067e:	5a a5 
	if (*cp != 0xA55A) {
f0100680:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f0100687:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010068b:	0f 84 de 00 00 00    	je     f010076f <cons_init+0x10c>
		addr_6845 = MONO_BASE;
f0100691:	c7 05 30 e2 2b f0 b4 	movl   $0x3b4,0xf02be230
f0100698:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010069b:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a0:	8b 3d 30 e2 2b f0    	mov    0xf02be230,%edi
f01006a6:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006ab:	89 fa                	mov    %edi,%edx
f01006ad:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006ae:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b1:	89 ca                	mov    %ecx,%edx
f01006b3:	ec                   	in     (%dx),%al
f01006b4:	0f b6 c0             	movzbl %al,%eax
f01006b7:	c1 e0 08             	shl    $0x8,%eax
f01006ba:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006bc:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c1:	89 fa                	mov    %edi,%edx
f01006c3:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006c4:	89 ca                	mov    %ecx,%edx
f01006c6:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006c7:	89 35 2c e2 2b f0    	mov    %esi,0xf02be22c
	pos |= inb(addr_6845 + 1);
f01006cd:	0f b6 c0             	movzbl %al,%eax
f01006d0:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006d2:	66 a3 28 e2 2b f0    	mov    %ax,0xf02be228
	kbd_intr();
f01006d8:	e8 2a ff ff ff       	call   f0100607 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006dd:	83 ec 0c             	sub    $0xc,%esp
f01006e0:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01006e7:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006ec:	50                   	push   %eax
f01006ed:	e8 f2 30 00 00       	call   f01037e4 <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006f2:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006f7:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01006fc:	89 d8                	mov    %ebx,%eax
f01006fe:	89 ca                	mov    %ecx,%edx
f0100700:	ee                   	out    %al,(%dx)
f0100701:	bf fb 03 00 00       	mov    $0x3fb,%edi
f0100706:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f010070b:	89 fa                	mov    %edi,%edx
f010070d:	ee                   	out    %al,(%dx)
f010070e:	b8 0c 00 00 00       	mov    $0xc,%eax
f0100713:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100718:	ee                   	out    %al,(%dx)
f0100719:	be f9 03 00 00       	mov    $0x3f9,%esi
f010071e:	89 d8                	mov    %ebx,%eax
f0100720:	89 f2                	mov    %esi,%edx
f0100722:	ee                   	out    %al,(%dx)
f0100723:	b8 03 00 00 00       	mov    $0x3,%eax
f0100728:	89 fa                	mov    %edi,%edx
f010072a:	ee                   	out    %al,(%dx)
f010072b:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100730:	89 d8                	mov    %ebx,%eax
f0100732:	ee                   	out    %al,(%dx)
f0100733:	b8 01 00 00 00       	mov    $0x1,%eax
f0100738:	89 f2                	mov    %esi,%edx
f010073a:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010073b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100740:	ec                   	in     (%dx),%al
f0100741:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100743:	83 c4 10             	add    $0x10,%esp
f0100746:	3c ff                	cmp    $0xff,%al
f0100748:	0f 95 05 34 e2 2b f0 	setne  0xf02be234
f010074f:	89 ca                	mov    %ecx,%edx
f0100751:	ec                   	in     (%dx),%al
f0100752:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100757:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100758:	80 fb ff             	cmp    $0xff,%bl
f010075b:	75 2d                	jne    f010078a <cons_init+0x127>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f010075d:	83 ec 0c             	sub    $0xc,%esp
f0100760:	68 cf 6a 10 f0       	push   $0xf0106acf
f0100765:	e8 fd 31 00 00       	call   f0103967 <cprintf>
f010076a:	83 c4 10             	add    $0x10,%esp
}
f010076d:	eb 3c                	jmp    f01007ab <cons_init+0x148>
		*cp = was;
f010076f:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100776:	c7 05 30 e2 2b f0 d4 	movl   $0x3d4,0xf02be230
f010077d:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100780:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100785:	e9 16 ff ff ff       	jmp    f01006a0 <cons_init+0x3d>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f010078a:	83 ec 0c             	sub    $0xc,%esp
f010078d:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f0100794:	25 ef ff 00 00       	and    $0xffef,%eax
f0100799:	50                   	push   %eax
f010079a:	e8 45 30 00 00       	call   f01037e4 <irq_setmask_8259A>
	if (!serial_exists)
f010079f:	83 c4 10             	add    $0x10,%esp
f01007a2:	80 3d 34 e2 2b f0 00 	cmpb   $0x0,0xf02be234
f01007a9:	74 b2                	je     f010075d <cons_init+0xfa>
}
f01007ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007ae:	5b                   	pop    %ebx
f01007af:	5e                   	pop    %esi
f01007b0:	5f                   	pop    %edi
f01007b1:	5d                   	pop    %ebp
f01007b2:	c3                   	ret    

f01007b3 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007b3:	f3 0f 1e fb          	endbr32 
f01007b7:	55                   	push   %ebp
f01007b8:	89 e5                	mov    %esp,%ebp
f01007ba:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007bd:	8b 45 08             	mov    0x8(%ebp),%eax
f01007c0:	e8 30 fc ff ff       	call   f01003f5 <cons_putc>
}
f01007c5:	c9                   	leave  
f01007c6:	c3                   	ret    

f01007c7 <getchar>:

int
getchar(void)
{
f01007c7:	f3 0f 1e fb          	endbr32 
f01007cb:	55                   	push   %ebp
f01007cc:	89 e5                	mov    %esp,%ebp
f01007ce:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007d1:	e8 47 fe ff ff       	call   f010061d <cons_getc>
f01007d6:	85 c0                	test   %eax,%eax
f01007d8:	74 f7                	je     f01007d1 <getchar+0xa>
		/* do nothing */;
	return c;
}
f01007da:	c9                   	leave  
f01007db:	c3                   	ret    

f01007dc <iscons>:

int
iscons(int fdnum)
{
f01007dc:	f3 0f 1e fb          	endbr32 
	// used by readline
	return 1;
}
f01007e0:	b8 01 00 00 00       	mov    $0x1,%eax
f01007e5:	c3                   	ret    

f01007e6 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007e6:	f3 0f 1e fb          	endbr32 
f01007ea:	55                   	push   %ebp
f01007eb:	89 e5                	mov    %esp,%ebp
f01007ed:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007f0:	68 20 6d 10 f0       	push   $0xf0106d20
f01007f5:	68 3e 6d 10 f0       	push   $0xf0106d3e
f01007fa:	68 43 6d 10 f0       	push   $0xf0106d43
f01007ff:	e8 63 31 00 00       	call   f0103967 <cprintf>
f0100804:	83 c4 0c             	add    $0xc,%esp
f0100807:	68 f8 6d 10 f0       	push   $0xf0106df8
f010080c:	68 4c 6d 10 f0       	push   $0xf0106d4c
f0100811:	68 43 6d 10 f0       	push   $0xf0106d43
f0100816:	e8 4c 31 00 00       	call   f0103967 <cprintf>
f010081b:	83 c4 0c             	add    $0xc,%esp
f010081e:	68 55 6d 10 f0       	push   $0xf0106d55
f0100823:	68 6b 6d 10 f0       	push   $0xf0106d6b
f0100828:	68 43 6d 10 f0       	push   $0xf0106d43
f010082d:	e8 35 31 00 00       	call   f0103967 <cprintf>
	return 0;
}
f0100832:	b8 00 00 00 00       	mov    $0x0,%eax
f0100837:	c9                   	leave  
f0100838:	c3                   	ret    

f0100839 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100839:	f3 0f 1e fb          	endbr32 
f010083d:	55                   	push   %ebp
f010083e:	89 e5                	mov    %esp,%ebp
f0100840:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f0100843:	68 75 6d 10 f0       	push   $0xf0106d75
f0100848:	e8 1a 31 00 00       	call   f0103967 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f010084d:	83 c4 08             	add    $0x8,%esp
f0100850:	68 0c 00 10 00       	push   $0x10000c
f0100855:	68 20 6e 10 f0       	push   $0xf0106e20
f010085a:	e8 08 31 00 00       	call   f0103967 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f010085f:	83 c4 0c             	add    $0xc,%esp
f0100862:	68 0c 00 10 00       	push   $0x10000c
f0100867:	68 0c 00 10 f0       	push   $0xf010000c
f010086c:	68 48 6e 10 f0       	push   $0xf0106e48
f0100871:	e8 f1 30 00 00       	call   f0103967 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100876:	83 c4 0c             	add    $0xc,%esp
f0100879:	68 ed 69 10 00       	push   $0x1069ed
f010087e:	68 ed 69 10 f0       	push   $0xf01069ed
f0100883:	68 6c 6e 10 f0       	push   $0xf0106e6c
f0100888:	e8 da 30 00 00       	call   f0103967 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010088d:	83 c4 0c             	add    $0xc,%esp
f0100890:	68 00 e0 2b 00       	push   $0x2be000
f0100895:	68 00 e0 2b f0       	push   $0xf02be000
f010089a:	68 90 6e 10 f0       	push   $0xf0106e90
f010089f:	e8 c3 30 00 00       	call   f0103967 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008a4:	83 c4 0c             	add    $0xc,%esp
f01008a7:	68 08 00 30 00       	push   $0x300008
f01008ac:	68 08 00 30 f0       	push   $0xf0300008
f01008b1:	68 b4 6e 10 f0       	push   $0xf0106eb4
f01008b6:	e8 ac 30 00 00       	call   f0103967 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008bb:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008be:	b8 08 00 30 f0       	mov    $0xf0300008,%eax
f01008c3:	2d 0d fc 0f f0       	sub    $0xf00ffc0d,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c8:	c1 f8 0a             	sar    $0xa,%eax
f01008cb:	50                   	push   %eax
f01008cc:	68 d8 6e 10 f0       	push   $0xf0106ed8
f01008d1:	e8 91 30 00 00       	call   f0103967 <cprintf>
	return 0;
}
f01008d6:	b8 00 00 00 00       	mov    $0x0,%eax
f01008db:	c9                   	leave  
f01008dc:	c3                   	ret    

f01008dd <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008dd:	f3 0f 1e fb          	endbr32 
f01008e1:	55                   	push   %ebp
f01008e2:	89 e5                	mov    %esp,%ebp
f01008e4:	57                   	push   %edi
f01008e5:	56                   	push   %esi
f01008e6:	53                   	push   %ebx
f01008e7:	83 ec 3c             	sub    $0x3c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008ea:	89 ee                	mov    %ebp,%esi
	// Your code here.
	int i;
	uint32_t eip;
	uint32_t *ebp = (uint32_t *)read_ebp();

	while(ebp){
f01008ec:	eb 41                	jmp    f010092f <mon_backtrace+0x52>
		cprintf("ebp %x eip %x args ", ebp, eip);
		uint32_t *args = ebp + 2;
		for(i = 0; i < 5; ++i){
			cprintf("%08x ", args[i]);
		}
		cprintf("\n");
f01008ee:	83 ec 0c             	sub    $0xc,%esp
f01008f1:	68 6f 72 10 f0       	push   $0xf010726f
f01008f6:	e8 6c 30 00 00       	call   f0103967 <cprintf>
		

		struct Eipdebuginfo debug_info;
		debuginfo_eip(eip, &debug_info);
f01008fb:	83 c4 08             	add    $0x8,%esp
f01008fe:	8d 45 d0             	lea    -0x30(%ebp),%eax
f0100901:	50                   	push   %eax
f0100902:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0100905:	57                   	push   %edi
f0100906:	e8 6a 43 00 00       	call   f0104c75 <debuginfo_eip>
		cprintf("\t%s:%d: %.*s+%d\n",
f010090b:	83 c4 08             	add    $0x8,%esp
f010090e:	89 f8                	mov    %edi,%eax
f0100910:	2b 45 e0             	sub    -0x20(%ebp),%eax
f0100913:	50                   	push   %eax
f0100914:	ff 75 d8             	pushl  -0x28(%ebp)
f0100917:	ff 75 dc             	pushl  -0x24(%ebp)
f010091a:	ff 75 d4             	pushl  -0x2c(%ebp)
f010091d:	ff 75 d0             	pushl  -0x30(%ebp)
f0100920:	68 a8 6d 10 f0       	push   $0xf0106da8
f0100925:	e8 3d 30 00 00       	call   f0103967 <cprintf>
			debug_info.eip_file, debug_info.eip_line, debug_info.eip_fn_namelen,
			debug_info.eip_fn_name, eip - debug_info.eip_fn_addr);

		ebp = (uint32_t *)*ebp;
f010092a:	8b 36                	mov    (%esi),%esi
f010092c:	83 c4 20             	add    $0x20,%esp
	while(ebp){
f010092f:	85 f6                	test   %esi,%esi
f0100931:	74 39                	je     f010096c <mon_backtrace+0x8f>
		eip = *(ebp + 1);
f0100933:	8b 46 04             	mov    0x4(%esi),%eax
f0100936:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("ebp %x eip %x args ", ebp, eip);
f0100939:	83 ec 04             	sub    $0x4,%esp
f010093c:	50                   	push   %eax
f010093d:	56                   	push   %esi
f010093e:	68 8e 6d 10 f0       	push   $0xf0106d8e
f0100943:	e8 1f 30 00 00       	call   f0103967 <cprintf>
f0100948:	8d 5e 08             	lea    0x8(%esi),%ebx
f010094b:	8d 7e 1c             	lea    0x1c(%esi),%edi
f010094e:	83 c4 10             	add    $0x10,%esp
			cprintf("%08x ", args[i]);
f0100951:	83 ec 08             	sub    $0x8,%esp
f0100954:	ff 33                	pushl  (%ebx)
f0100956:	68 a2 6d 10 f0       	push   $0xf0106da2
f010095b:	e8 07 30 00 00       	call   f0103967 <cprintf>
f0100960:	83 c3 04             	add    $0x4,%ebx
		for(i = 0; i < 5; ++i){
f0100963:	83 c4 10             	add    $0x10,%esp
f0100966:	39 fb                	cmp    %edi,%ebx
f0100968:	75 e7                	jne    f0100951 <mon_backtrace+0x74>
f010096a:	eb 82                	jmp    f01008ee <mon_backtrace+0x11>
	}
	return 0;
}
f010096c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100971:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100974:	5b                   	pop    %ebx
f0100975:	5e                   	pop    %esi
f0100976:	5f                   	pop    %edi
f0100977:	5d                   	pop    %ebp
f0100978:	c3                   	ret    

f0100979 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100979:	f3 0f 1e fb          	endbr32 
f010097d:	55                   	push   %ebp
f010097e:	89 e5                	mov    %esp,%ebp
f0100980:	57                   	push   %edi
f0100981:	56                   	push   %esi
f0100982:	53                   	push   %ebx
f0100983:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100986:	68 04 6f 10 f0       	push   $0xf0106f04
f010098b:	e8 d7 2f 00 00       	call   f0103967 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100990:	c7 04 24 28 6f 10 f0 	movl   $0xf0106f28,(%esp)
f0100997:	e8 cb 2f 00 00       	call   f0103967 <cprintf>

	if (tf != NULL)
f010099c:	83 c4 10             	add    $0x10,%esp
f010099f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f01009a3:	0f 84 d9 00 00 00    	je     f0100a82 <monitor+0x109>
		print_trapframe(tf);
f01009a9:	83 ec 0c             	sub    $0xc,%esp
f01009ac:	ff 75 08             	pushl  0x8(%ebp)
f01009af:	e8 04 35 00 00       	call   f0103eb8 <print_trapframe>
f01009b4:	83 c4 10             	add    $0x10,%esp
f01009b7:	e9 c6 00 00 00       	jmp    f0100a82 <monitor+0x109>
		while (*buf && strchr(WHITESPACE, *buf))
f01009bc:	83 ec 08             	sub    $0x8,%esp
f01009bf:	0f be c0             	movsbl %al,%eax
f01009c2:	50                   	push   %eax
f01009c3:	68 bd 6d 10 f0       	push   $0xf0106dbd
f01009c8:	e8 9c 4d 00 00       	call   f0105769 <strchr>
f01009cd:	83 c4 10             	add    $0x10,%esp
f01009d0:	85 c0                	test   %eax,%eax
f01009d2:	74 63                	je     f0100a37 <monitor+0xbe>
			*buf++ = 0;
f01009d4:	c6 03 00             	movb   $0x0,(%ebx)
f01009d7:	89 f7                	mov    %esi,%edi
f01009d9:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009dc:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f01009de:	0f b6 03             	movzbl (%ebx),%eax
f01009e1:	84 c0                	test   %al,%al
f01009e3:	75 d7                	jne    f01009bc <monitor+0x43>
	argv[argc] = 0;
f01009e5:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009ec:	00 
	if (argc == 0)
f01009ed:	85 f6                	test   %esi,%esi
f01009ef:	0f 84 8d 00 00 00    	je     f0100a82 <monitor+0x109>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01009f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f01009fa:	83 ec 08             	sub    $0x8,%esp
f01009fd:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a00:	ff 34 85 60 6f 10 f0 	pushl  -0xfef90a0(,%eax,4)
f0100a07:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a0a:	e8 f4 4c 00 00       	call   f0105703 <strcmp>
f0100a0f:	83 c4 10             	add    $0x10,%esp
f0100a12:	85 c0                	test   %eax,%eax
f0100a14:	0f 84 8f 00 00 00    	je     f0100aa9 <monitor+0x130>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a1a:	83 c3 01             	add    $0x1,%ebx
f0100a1d:	83 fb 03             	cmp    $0x3,%ebx
f0100a20:	75 d8                	jne    f01009fa <monitor+0x81>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a22:	83 ec 08             	sub    $0x8,%esp
f0100a25:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a28:	68 df 6d 10 f0       	push   $0xf0106ddf
f0100a2d:	e8 35 2f 00 00       	call   f0103967 <cprintf>
	return 0;
f0100a32:	83 c4 10             	add    $0x10,%esp
f0100a35:	eb 4b                	jmp    f0100a82 <monitor+0x109>
		if (*buf == 0)
f0100a37:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a3a:	74 a9                	je     f01009e5 <monitor+0x6c>
		if (argc == MAXARGS-1) {
f0100a3c:	83 fe 0f             	cmp    $0xf,%esi
f0100a3f:	74 2f                	je     f0100a70 <monitor+0xf7>
		argv[argc++] = buf;
f0100a41:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a44:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a48:	0f b6 03             	movzbl (%ebx),%eax
f0100a4b:	84 c0                	test   %al,%al
f0100a4d:	74 8d                	je     f01009dc <monitor+0x63>
f0100a4f:	83 ec 08             	sub    $0x8,%esp
f0100a52:	0f be c0             	movsbl %al,%eax
f0100a55:	50                   	push   %eax
f0100a56:	68 bd 6d 10 f0       	push   $0xf0106dbd
f0100a5b:	e8 09 4d 00 00       	call   f0105769 <strchr>
f0100a60:	83 c4 10             	add    $0x10,%esp
f0100a63:	85 c0                	test   %eax,%eax
f0100a65:	0f 85 71 ff ff ff    	jne    f01009dc <monitor+0x63>
			buf++;
f0100a6b:	83 c3 01             	add    $0x1,%ebx
f0100a6e:	eb d8                	jmp    f0100a48 <monitor+0xcf>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a70:	83 ec 08             	sub    $0x8,%esp
f0100a73:	6a 10                	push   $0x10
f0100a75:	68 c2 6d 10 f0       	push   $0xf0106dc2
f0100a7a:	e8 e8 2e 00 00       	call   f0103967 <cprintf>
			return 0;
f0100a7f:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a82:	83 ec 0c             	sub    $0xc,%esp
f0100a85:	68 b9 6d 10 f0       	push   $0xf0106db9
f0100a8a:	e8 80 4a 00 00       	call   f010550f <readline>
f0100a8f:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a91:	83 c4 10             	add    $0x10,%esp
f0100a94:	85 c0                	test   %eax,%eax
f0100a96:	74 ea                	je     f0100a82 <monitor+0x109>
	argv[argc] = 0;
f0100a98:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a9f:	be 00 00 00 00       	mov    $0x0,%esi
f0100aa4:	e9 35 ff ff ff       	jmp    f01009de <monitor+0x65>
			return commands[i].func(argc, argv, tf);
f0100aa9:	83 ec 04             	sub    $0x4,%esp
f0100aac:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100aaf:	ff 75 08             	pushl  0x8(%ebp)
f0100ab2:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100ab5:	52                   	push   %edx
f0100ab6:	56                   	push   %esi
f0100ab7:	ff 14 85 68 6f 10 f0 	call   *-0xfef9098(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100abe:	83 c4 10             	add    $0x10,%esp
f0100ac1:	85 c0                	test   %eax,%eax
f0100ac3:	79 bd                	jns    f0100a82 <monitor+0x109>
				break;
	}
f0100ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100ac8:	5b                   	pop    %ebx
f0100ac9:	5e                   	pop    %esi
f0100aca:	5f                   	pop    %edi
f0100acb:	5d                   	pop    %ebp
f0100acc:	c3                   	ret    

f0100acd <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100acd:	55                   	push   %ebp
f0100ace:	89 e5                	mov    %esp,%ebp
f0100ad0:	53                   	push   %ebx
f0100ad1:	83 ec 04             	sub    $0x4,%esp
f0100ad4:	89 c3                	mov    %eax,%ebx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100ad6:	83 3d 38 e2 2b f0 00 	cmpl   $0x0,0xf02be238
f0100add:	74 21                	je     f0100b00 <boot_alloc+0x33>
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	//cprintf("boot_alloc, nextfree:%x\n", nextfree);
	//cprintf("nextfree address :%x\n", &nextfree);
	result = nextfree;
f0100adf:	a1 38 e2 2b f0       	mov    0xf02be238,%eax
	if (n != 0) {
f0100ae4:	85 db                	test   %ebx,%ebx
f0100ae6:	74 13                	je     f0100afb <boot_alloc+0x2e>
		nextfree = ROUNDUP(nextfree + n, PGSIZE);
f0100ae8:	8d 94 18 ff 0f 00 00 	lea    0xfff(%eax,%ebx,1),%edx
f0100aef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100af5:	89 15 38 e2 2b f0    	mov    %edx,0xf02be238
	}

	return result;
}
f0100afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100afe:	c9                   	leave  
f0100aff:	c3                   	ret    
		cprintf("end = :%x\n", end);
f0100b00:	83 ec 08             	sub    $0x8,%esp
f0100b03:	68 08 00 30 f0       	push   $0xf0300008
f0100b08:	68 84 6f 10 f0       	push   $0xf0106f84
f0100b0d:	e8 55 2e 00 00       	call   f0103967 <cprintf>
		nextfree = ROUNDUP((char *) end + 1, PGSIZE);
f0100b12:	b8 08 10 30 f0       	mov    $0xf0301008,%eax
f0100b17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b1c:	a3 38 e2 2b f0       	mov    %eax,0xf02be238
f0100b21:	83 c4 10             	add    $0x10,%esp
f0100b24:	eb b9                	jmp    f0100adf <boot_alloc+0x12>

f0100b26 <nvram_read>:
{
f0100b26:	55                   	push   %ebp
f0100b27:	89 e5                	mov    %esp,%ebp
f0100b29:	56                   	push   %esi
f0100b2a:	53                   	push   %ebx
f0100b2b:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b2d:	83 ec 0c             	sub    $0xc,%esp
f0100b30:	50                   	push   %eax
f0100b31:	e8 78 2c 00 00       	call   f01037ae <mc146818_read>
f0100b36:	89 c6                	mov    %eax,%esi
f0100b38:	83 c3 01             	add    $0x1,%ebx
f0100b3b:	89 1c 24             	mov    %ebx,(%esp)
f0100b3e:	e8 6b 2c 00 00       	call   f01037ae <mc146818_read>
f0100b43:	c1 e0 08             	shl    $0x8,%eax
f0100b46:	09 f0                	or     %esi,%eax
}
f0100b48:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100b4b:	5b                   	pop    %ebx
f0100b4c:	5e                   	pop    %esi
f0100b4d:	5d                   	pop    %ebp
f0100b4e:	c3                   	ret    

f0100b4f <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b4f:	89 d1                	mov    %edx,%ecx
f0100b51:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b54:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b57:	a8 01                	test   $0x1,%al
f0100b59:	74 51                	je     f0100bac <check_va2pa+0x5d>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100b5b:	89 c1                	mov    %eax,%ecx
f0100b5d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	if (PGNUM(pa) >= npages)
f0100b63:	c1 e8 0c             	shr    $0xc,%eax
f0100b66:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0100b6c:	73 23                	jae    f0100b91 <check_va2pa+0x42>
	if (!(p[PTX(va)] & PTE_P))
f0100b6e:	c1 ea 0c             	shr    $0xc,%edx
f0100b71:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b77:	8b 94 91 00 00 00 f0 	mov    -0x10000000(%ecx,%edx,4),%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b7e:	89 d0                	mov    %edx,%eax
f0100b80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b85:	f6 c2 01             	test   $0x1,%dl
f0100b88:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b8d:	0f 44 c2             	cmove  %edx,%eax
f0100b90:	c3                   	ret    
{
f0100b91:	55                   	push   %ebp
f0100b92:	89 e5                	mov    %esp,%ebp
f0100b94:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b97:	51                   	push   %ecx
f0100b98:	68 24 6a 10 f0       	push   $0xf0106a24
f0100b9d:	68 a3 03 00 00       	push   $0x3a3
f0100ba2:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100ba7:	e8 94 f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100bb1:	c3                   	ret    

f0100bb2 <check_page_free_list>:
{
f0100bb2:	55                   	push   %ebp
f0100bb3:	89 e5                	mov    %esp,%ebp
f0100bb5:	57                   	push   %edi
f0100bb6:	56                   	push   %esi
f0100bb7:	53                   	push   %ebx
f0100bb8:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bbb:	84 c0                	test   %al,%al
f0100bbd:	0f 85 77 02 00 00    	jne    f0100e3a <check_page_free_list+0x288>
	if (!page_free_list)
f0100bc3:	83 3d 40 e2 2b f0 00 	cmpl   $0x0,0xf02be240
f0100bca:	74 0a                	je     f0100bd6 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bcc:	be 00 04 00 00       	mov    $0x400,%esi
f0100bd1:	e9 bf 02 00 00       	jmp    f0100e95 <check_page_free_list+0x2e3>
		panic("'page_free_list' is a null pointer!");
f0100bd6:	83 ec 04             	sub    $0x4,%esp
f0100bd9:	68 a4 72 10 f0       	push   $0xf01072a4
f0100bde:	68 d6 02 00 00       	push   $0x2d6
f0100be3:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100be8:	e8 53 f4 ff ff       	call   f0100040 <_panic>
f0100bed:	50                   	push   %eax
f0100bee:	68 24 6a 10 f0       	push   $0xf0106a24
f0100bf3:	6a 58                	push   $0x58
f0100bf5:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0100bfa:	e8 41 f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100bff:	8b 1b                	mov    (%ebx),%ebx
f0100c01:	85 db                	test   %ebx,%ebx
f0100c03:	74 41                	je     f0100c46 <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c05:	89 d8                	mov    %ebx,%eax
f0100c07:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0100c0d:	c1 f8 03             	sar    $0x3,%eax
f0100c10:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c13:	89 c2                	mov    %eax,%edx
f0100c15:	c1 ea 16             	shr    $0x16,%edx
f0100c18:	39 f2                	cmp    %esi,%edx
f0100c1a:	73 e3                	jae    f0100bff <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100c1c:	89 c2                	mov    %eax,%edx
f0100c1e:	c1 ea 0c             	shr    $0xc,%edx
f0100c21:	3b 15 94 ee 2b f0    	cmp    0xf02bee94,%edx
f0100c27:	73 c4                	jae    f0100bed <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c29:	83 ec 04             	sub    $0x4,%esp
f0100c2c:	68 80 00 00 00       	push   $0x80
f0100c31:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c36:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c3b:	50                   	push   %eax
f0100c3c:	e8 6d 4b 00 00       	call   f01057ae <memset>
f0100c41:	83 c4 10             	add    $0x10,%esp
f0100c44:	eb b9                	jmp    f0100bff <check_page_free_list+0x4d>
	first_free_page = (char *) boot_alloc(0);
f0100c46:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c4b:	e8 7d fe ff ff       	call   f0100acd <boot_alloc>
f0100c50:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c53:	8b 15 40 e2 2b f0    	mov    0xf02be240,%edx
		assert(pp >= pages);
f0100c59:	8b 0d 9c ee 2b f0    	mov    0xf02bee9c,%ecx
		assert(pp < pages + npages);
f0100c5f:	a1 94 ee 2b f0       	mov    0xf02bee94,%eax
f0100c64:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100c67:	8d 34 c1             	lea    (%ecx,%eax,8),%esi
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c6a:	bf 00 00 00 00       	mov    $0x0,%edi
f0100c6f:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100c72:	e9 f9 00 00 00       	jmp    f0100d70 <check_page_free_list+0x1be>
		assert(pp >= pages);
f0100c77:	68 a9 6f 10 f0       	push   $0xf0106fa9
f0100c7c:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100c81:	68 f0 02 00 00       	push   $0x2f0
f0100c86:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100c8b:	e8 b0 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c90:	68 ca 6f 10 f0       	push   $0xf0106fca
f0100c95:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100c9a:	68 f1 02 00 00       	push   $0x2f1
f0100c9f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100ca4:	e8 97 f3 ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ca9:	68 c8 72 10 f0       	push   $0xf01072c8
f0100cae:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100cb3:	68 f2 02 00 00       	push   $0x2f2
f0100cb8:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100cbd:	e8 7e f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100cc2:	68 de 6f 10 f0       	push   $0xf0106fde
f0100cc7:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100ccc:	68 f5 02 00 00       	push   $0x2f5
f0100cd1:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100cd6:	e8 65 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100cdb:	68 ef 6f 10 f0       	push   $0xf0106fef
f0100ce0:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100ce5:	68 f6 02 00 00       	push   $0x2f6
f0100cea:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100cef:	e8 4c f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100cf4:	68 fc 72 10 f0       	push   $0xf01072fc
f0100cf9:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100cfe:	68 f7 02 00 00       	push   $0x2f7
f0100d03:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100d08:	e8 33 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d0d:	68 08 70 10 f0       	push   $0xf0107008
f0100d12:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100d17:	68 f8 02 00 00       	push   $0x2f8
f0100d1c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100d21:	e8 1a f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d26:	89 c3                	mov    %eax,%ebx
f0100d28:	c1 eb 0c             	shr    $0xc,%ebx
f0100d2b:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
f0100d2e:	76 0f                	jbe    f0100d3f <check_page_free_list+0x18d>
	return (void *)(pa + KERNBASE);
f0100d30:	2d 00 00 00 10       	sub    $0x10000000,%eax
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d35:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f0100d38:	77 17                	ja     f0100d51 <check_page_free_list+0x19f>
			++nfree_extmem;
f0100d3a:	83 c7 01             	add    $0x1,%edi
f0100d3d:	eb 2f                	jmp    f0100d6e <check_page_free_list+0x1bc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d3f:	50                   	push   %eax
f0100d40:	68 24 6a 10 f0       	push   $0xf0106a24
f0100d45:	6a 58                	push   $0x58
f0100d47:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0100d4c:	e8 ef f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100d51:	68 20 73 10 f0       	push   $0xf0107320
f0100d56:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100d5b:	68 f9 02 00 00       	push   $0x2f9
f0100d60:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100d65:	e8 d6 f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d6a:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d6e:	8b 12                	mov    (%edx),%edx
f0100d70:	85 d2                	test   %edx,%edx
f0100d72:	74 74                	je     f0100de8 <check_page_free_list+0x236>
		assert(pp >= pages);
f0100d74:	39 d1                	cmp    %edx,%ecx
f0100d76:	0f 87 fb fe ff ff    	ja     f0100c77 <check_page_free_list+0xc5>
		assert(pp < pages + npages);
f0100d7c:	39 d6                	cmp    %edx,%esi
f0100d7e:	0f 86 0c ff ff ff    	jbe    f0100c90 <check_page_free_list+0xde>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d84:	89 d0                	mov    %edx,%eax
f0100d86:	29 c8                	sub    %ecx,%eax
f0100d88:	a8 07                	test   $0x7,%al
f0100d8a:	0f 85 19 ff ff ff    	jne    f0100ca9 <check_page_free_list+0xf7>
	return (pp - pages) << PGSHIFT;
f0100d90:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100d93:	c1 e0 0c             	shl    $0xc,%eax
f0100d96:	0f 84 26 ff ff ff    	je     f0100cc2 <check_page_free_list+0x110>
		assert(page2pa(pp) != IOPHYSMEM);
f0100d9c:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100da1:	0f 84 34 ff ff ff    	je     f0100cdb <check_page_free_list+0x129>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100da7:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dac:	0f 84 42 ff ff ff    	je     f0100cf4 <check_page_free_list+0x142>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100db2:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100db7:	0f 84 50 ff ff ff    	je     f0100d0d <check_page_free_list+0x15b>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100dbd:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dc2:	0f 87 5e ff ff ff    	ja     f0100d26 <check_page_free_list+0x174>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100dc8:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100dcd:	75 9b                	jne    f0100d6a <check_page_free_list+0x1b8>
f0100dcf:	68 22 70 10 f0       	push   $0xf0107022
f0100dd4:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100dd9:	68 fb 02 00 00       	push   $0x2fb
f0100dde:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100de3:	e8 58 f2 ff ff       	call   f0100040 <_panic>
f0100de8:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
	assert(nfree_basemem > 0);
f0100deb:	85 db                	test   %ebx,%ebx
f0100ded:	7e 19                	jle    f0100e08 <check_page_free_list+0x256>
	assert(nfree_extmem > 0);
f0100def:	85 ff                	test   %edi,%edi
f0100df1:	7e 2e                	jle    f0100e21 <check_page_free_list+0x26f>
	cprintf("check_page_free_list() succeeded!\n");
f0100df3:	83 ec 0c             	sub    $0xc,%esp
f0100df6:	68 68 73 10 f0       	push   $0xf0107368
f0100dfb:	e8 67 2b 00 00       	call   f0103967 <cprintf>
}
f0100e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e03:	5b                   	pop    %ebx
f0100e04:	5e                   	pop    %esi
f0100e05:	5f                   	pop    %edi
f0100e06:	5d                   	pop    %ebp
f0100e07:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e08:	68 3f 70 10 f0       	push   $0xf010703f
f0100e0d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100e12:	68 03 03 00 00       	push   $0x303
f0100e17:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100e1c:	e8 1f f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e21:	68 51 70 10 f0       	push   $0xf0107051
f0100e26:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0100e2b:	68 04 03 00 00       	push   $0x304
f0100e30:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100e35:	e8 06 f2 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e3a:	a1 40 e2 2b f0       	mov    0xf02be240,%eax
f0100e3f:	85 c0                	test   %eax,%eax
f0100e41:	0f 84 8f fd ff ff    	je     f0100bd6 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100e47:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e4a:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e4d:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e50:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e53:	89 c2                	mov    %eax,%edx
f0100e55:	2b 15 9c ee 2b f0    	sub    0xf02bee9c,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e5b:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e61:	0f 95 c2             	setne  %dl
f0100e64:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e67:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e6b:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e6d:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100e71:	8b 00                	mov    (%eax),%eax
f0100e73:	85 c0                	test   %eax,%eax
f0100e75:	75 dc                	jne    f0100e53 <check_page_free_list+0x2a1>
		*tp[1] = 0;
f0100e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e80:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e86:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e88:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e8b:	a3 40 e2 2b f0       	mov    %eax,0xf02be240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100e90:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e95:	8b 1d 40 e2 2b f0    	mov    0xf02be240,%ebx
f0100e9b:	e9 61 fd ff ff       	jmp    f0100c01 <check_page_free_list+0x4f>

f0100ea0 <page_init>:
{
f0100ea0:	f3 0f 1e fb          	endbr32 
f0100ea4:	55                   	push   %ebp
f0100ea5:	89 e5                	mov    %esp,%ebp
f0100ea7:	57                   	push   %edi
f0100ea8:	56                   	push   %esi
f0100ea9:	53                   	push   %ebx
f0100eaa:	83 ec 1c             	sub    $0x1c,%esp
	page_free_list = NULL;
f0100ead:	c7 05 40 e2 2b f0 00 	movl   $0x0,0xf02be240
f0100eb4:	00 00 00 
	pages[0].pp_ref = 1;
f0100eb7:	a1 9c ee 2b f0       	mov    0xf02bee9c,%eax
f0100ebc:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100ec2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	size_t index_IOhole_begin = npages_basemem;
f0100ec8:	8b 1d 44 e2 2b f0    	mov    0xf02be244,%ebx
	size_t index_alloc_end = PADDR(boot_alloc(0)) / PGSIZE;
f0100ece:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ed3:	e8 f5 fb ff ff       	call   f0100acd <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100ed8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100edd:	76 1a                	jbe    f0100ef9 <page_init+0x59>
	return (physaddr_t)kva - KERNBASE;
f0100edf:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
f0100ee5:	c1 ee 0c             	shr    $0xc,%esi
f0100ee8:	8b 3d 40 e2 2b f0    	mov    0xf02be240,%edi
	for (i = 1; i < npages; i++) {
f0100eee:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
f0100ef2:	b8 01 00 00 00       	mov    $0x1,%eax
f0100ef7:	eb 2d                	jmp    f0100f26 <page_init+0x86>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100ef9:	50                   	push   %eax
f0100efa:	68 48 6a 10 f0       	push   $0xf0106a48
f0100eff:	68 58 01 00 00       	push   $0x158
f0100f04:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0100f09:	e8 32 f1 ff ff       	call   f0100040 <_panic>
			pages[i].pp_ref = 1;
f0100f0e:	8b 15 9c ee 2b f0    	mov    0xf02bee9c,%edx
f0100f14:	8d 14 c2             	lea    (%edx,%eax,8),%edx
f0100f17:	66 c7 42 04 01 00    	movw   $0x1,0x4(%edx)
			pages[i].pp_link = NULL;
f0100f1d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	for (i = 1; i < npages; i++) {
f0100f23:	83 c0 01             	add    $0x1,%eax
f0100f26:	39 05 94 ee 2b f0    	cmp    %eax,0xf02bee94
f0100f2c:	76 38                	jbe    f0100f66 <page_init+0xc6>
		if((i >= index_IOhole_begin && i < index_alloc_end) || (i == MPENTRY_PADDR / PGSIZE)){
f0100f2e:	39 d8                	cmp    %ebx,%eax
f0100f30:	0f 93 c1             	setae  %cl
f0100f33:	39 f0                	cmp    %esi,%eax
f0100f35:	0f 92 c2             	setb   %dl
f0100f38:	84 d1                	test   %dl,%cl
f0100f3a:	75 d2                	jne    f0100f0e <page_init+0x6e>
f0100f3c:	83 f8 07             	cmp    $0x7,%eax
f0100f3f:	74 cd                	je     f0100f0e <page_init+0x6e>
f0100f41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
			pages[i].pp_ref = 0;
f0100f48:	89 d1                	mov    %edx,%ecx
f0100f4a:	03 0d 9c ee 2b f0    	add    0xf02bee9c,%ecx
f0100f50:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
			pages[i].pp_link = page_free_list;
f0100f56:	89 39                	mov    %edi,(%ecx)
			page_free_list = &pages[i];
f0100f58:	89 d7                	mov    %edx,%edi
f0100f5a:	03 3d 9c ee 2b f0    	add    0xf02bee9c,%edi
f0100f60:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
f0100f64:	eb bd                	jmp    f0100f23 <page_init+0x83>
f0100f66:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
f0100f6a:	74 06                	je     f0100f72 <page_init+0xd2>
f0100f6c:	89 3d 40 e2 2b f0    	mov    %edi,0xf02be240
}
f0100f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f75:	5b                   	pop    %ebx
f0100f76:	5e                   	pop    %esi
f0100f77:	5f                   	pop    %edi
f0100f78:	5d                   	pop    %ebp
f0100f79:	c3                   	ret    

f0100f7a <page_alloc>:
{
f0100f7a:	f3 0f 1e fb          	endbr32 
f0100f7e:	55                   	push   %ebp
f0100f7f:	89 e5                	mov    %esp,%ebp
f0100f81:	53                   	push   %ebx
f0100f82:	83 ec 04             	sub    $0x4,%esp
	struct PageInfo *res = page_free_list;
f0100f85:	8b 1d 40 e2 2b f0    	mov    0xf02be240,%ebx
	if(!res) return NULL;
f0100f8b:	85 db                	test   %ebx,%ebx
f0100f8d:	74 13                	je     f0100fa2 <page_alloc+0x28>
	page_free_list = page_free_list->pp_link;
f0100f8f:	8b 03                	mov    (%ebx),%eax
f0100f91:	a3 40 e2 2b f0       	mov    %eax,0xf02be240
	res->pp_link = NULL;
f0100f96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if(alloc_flags & ALLOC_ZERO){
f0100f9c:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100fa0:	75 07                	jne    f0100fa9 <page_alloc+0x2f>
}
f0100fa2:	89 d8                	mov    %ebx,%eax
f0100fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fa7:	c9                   	leave  
f0100fa8:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100fa9:	89 d8                	mov    %ebx,%eax
f0100fab:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0100fb1:	c1 f8 03             	sar    $0x3,%eax
f0100fb4:	89 c2                	mov    %eax,%edx
f0100fb6:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0100fb9:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0100fbe:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0100fc4:	73 1b                	jae    f0100fe1 <page_alloc+0x67>
		memset(page2kva(res), '\0', PGSIZE);
f0100fc6:	83 ec 04             	sub    $0x4,%esp
f0100fc9:	68 00 10 00 00       	push   $0x1000
f0100fce:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100fd0:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0100fd6:	52                   	push   %edx
f0100fd7:	e8 d2 47 00 00       	call   f01057ae <memset>
f0100fdc:	83 c4 10             	add    $0x10,%esp
f0100fdf:	eb c1                	jmp    f0100fa2 <page_alloc+0x28>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fe1:	52                   	push   %edx
f0100fe2:	68 24 6a 10 f0       	push   $0xf0106a24
f0100fe7:	6a 58                	push   $0x58
f0100fe9:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0100fee:	e8 4d f0 ff ff       	call   f0100040 <_panic>

f0100ff3 <page_free>:
{
f0100ff3:	f3 0f 1e fb          	endbr32 
f0100ff7:	55                   	push   %ebp
f0100ff8:	89 e5                	mov    %esp,%ebp
f0100ffa:	83 ec 08             	sub    $0x8,%esp
f0100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
	if(!pp || pp->pp_ref != 0 || pp->pp_link){
f0101000:	85 c0                	test   %eax,%eax
f0101002:	74 1b                	je     f010101f <page_free+0x2c>
f0101004:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101009:	75 14                	jne    f010101f <page_free+0x2c>
f010100b:	83 38 00             	cmpl   $0x0,(%eax)
f010100e:	75 0f                	jne    f010101f <page_free+0x2c>
	pp->pp_link = page_free_list;
f0101010:	8b 15 40 e2 2b f0    	mov    0xf02be240,%edx
f0101016:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f0101018:	a3 40 e2 2b f0       	mov    %eax,0xf02be240
}
f010101d:	c9                   	leave  
f010101e:	c3                   	ret    
		panic("page_free : Invalid address, nothing changed...\n");
f010101f:	83 ec 04             	sub    $0x4,%esp
f0101022:	68 8c 73 10 f0       	push   $0xf010738c
f0101027:	68 8c 01 00 00       	push   $0x18c
f010102c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101031:	e8 0a f0 ff ff       	call   f0100040 <_panic>

f0101036 <page_decref>:
{
f0101036:	f3 0f 1e fb          	endbr32 
f010103a:	55                   	push   %ebp
f010103b:	89 e5                	mov    %esp,%ebp
f010103d:	83 ec 08             	sub    $0x8,%esp
f0101040:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101043:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0101047:	83 e8 01             	sub    $0x1,%eax
f010104a:	66 89 42 04          	mov    %ax,0x4(%edx)
f010104e:	66 85 c0             	test   %ax,%ax
f0101051:	74 02                	je     f0101055 <page_decref+0x1f>
}
f0101053:	c9                   	leave  
f0101054:	c3                   	ret    
		page_free(pp);
f0101055:	83 ec 0c             	sub    $0xc,%esp
f0101058:	52                   	push   %edx
f0101059:	e8 95 ff ff ff       	call   f0100ff3 <page_free>
f010105e:	83 c4 10             	add    $0x10,%esp
}
f0101061:	eb f0                	jmp    f0101053 <page_decref+0x1d>

f0101063 <pgdir_walk>:
{
f0101063:	f3 0f 1e fb          	endbr32 
f0101067:	55                   	push   %ebp
f0101068:	89 e5                	mov    %esp,%ebp
f010106a:	56                   	push   %esi
f010106b:	53                   	push   %ebx
f010106c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pde_t pgtab_index = PTX(va);
f010106f:	89 de                	mov    %ebx,%esi
f0101071:	c1 ee 0c             	shr    $0xc,%esi
f0101074:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	pde_t pgdir_index = PDX(va);
f010107a:	c1 eb 16             	shr    $0x16,%ebx
	pde_t *pgdir_add = &pgdir[pgdir_index];
f010107d:	c1 e3 02             	shl    $0x2,%ebx
f0101080:	03 5d 08             	add    0x8(%ebp),%ebx
	if(!(*pgdir_add & PTE_P)){
f0101083:	f6 03 01             	testb  $0x1,(%ebx)
f0101086:	75 2d                	jne    f01010b5 <pgdir_walk+0x52>
		if(!create) return NULL;
f0101088:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010108c:	74 5f                	je     f01010ed <pgdir_walk+0x8a>
		struct PageInfo* new_page = page_alloc(ALLOC_ZERO);
f010108e:	83 ec 0c             	sub    $0xc,%esp
f0101091:	6a 01                	push   $0x1
f0101093:	e8 e2 fe ff ff       	call   f0100f7a <page_alloc>
		if(!new_page) return NULL;
f0101098:	83 c4 10             	add    $0x10,%esp
f010109b:	85 c0                	test   %eax,%eax
f010109d:	74 32                	je     f01010d1 <pgdir_walk+0x6e>
		new_page->pp_ref++;
f010109f:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01010a4:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f01010aa:	c1 f8 03             	sar    $0x3,%eax
f01010ad:	c1 e0 0c             	shl    $0xc,%eax
		*pgdir_add = (page2pa(new_page) | PTE_P | PTE_W | PTE_U);
f01010b0:	83 c8 07             	or     $0x7,%eax
f01010b3:	89 03                	mov    %eax,(%ebx)
	pde_t *pgtab = KADDR(PTE_ADDR(*pgdir_add));
f01010b5:	8b 03                	mov    (%ebx),%eax
f01010b7:	89 c2                	mov    %eax,%edx
f01010b9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f01010bf:	c1 e8 0c             	shr    $0xc,%eax
f01010c2:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f01010c8:	73 0e                	jae    f01010d8 <pgdir_walk+0x75>
	return &pgtab[pgtab_index];
f01010ca:	8d 84 b2 00 00 00 f0 	lea    -0x10000000(%edx,%esi,4),%eax
}
f01010d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01010d4:	5b                   	pop    %ebx
f01010d5:	5e                   	pop    %esi
f01010d6:	5d                   	pop    %ebp
f01010d7:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010d8:	52                   	push   %edx
f01010d9:	68 24 6a 10 f0       	push   $0xf0106a24
f01010de:	68 c7 01 00 00       	push   $0x1c7
f01010e3:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01010e8:	e8 53 ef ff ff       	call   f0100040 <_panic>
		if(!create) return NULL;
f01010ed:	b8 00 00 00 00       	mov    $0x0,%eax
f01010f2:	eb dd                	jmp    f01010d1 <pgdir_walk+0x6e>

f01010f4 <boot_map_region>:
{
f01010f4:	55                   	push   %ebp
f01010f5:	89 e5                	mov    %esp,%ebp
f01010f7:	57                   	push   %edi
f01010f8:	56                   	push   %esi
f01010f9:	53                   	push   %ebx
f01010fa:	83 ec 1c             	sub    $0x1c,%esp
f01010fd:	89 c7                	mov    %eax,%edi
f01010ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0101102:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101108:	01 c1                	add    %eax,%ecx
f010110a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	for(uint32_t i = 0; i < len; ++i){
f010110d:	89 c3                	mov    %eax,%ebx
		pte_t *pg_table_entry = pgdir_walk(pgdir, (void *)va, 1);
f010110f:	89 d6                	mov    %edx,%esi
f0101111:	29 c6                	sub    %eax,%esi
	for(uint32_t i = 0; i < len; ++i){
f0101113:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101116:	74 3f                	je     f0101157 <boot_map_region+0x63>
		pte_t *pg_table_entry = pgdir_walk(pgdir, (void *)va, 1);
f0101118:	83 ec 04             	sub    $0x4,%esp
f010111b:	6a 01                	push   $0x1
f010111d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
f0101120:	50                   	push   %eax
f0101121:	57                   	push   %edi
f0101122:	e8 3c ff ff ff       	call   f0101063 <pgdir_walk>
		if(!pg_table_entry){
f0101127:	83 c4 10             	add    $0x10,%esp
f010112a:	85 c0                	test   %eax,%eax
f010112c:	74 12                	je     f0101140 <boot_map_region+0x4c>
		*pg_table_entry = pa | perm | PTE_P;
f010112e:	89 da                	mov    %ebx,%edx
f0101130:	0b 55 0c             	or     0xc(%ebp),%edx
f0101133:	83 ca 01             	or     $0x1,%edx
f0101136:	89 10                	mov    %edx,(%eax)
		pa += PGSIZE;
f0101138:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010113e:	eb d3                	jmp    f0101113 <boot_map_region+0x1f>
			panic("boot_map_region : something error happened...\n");
f0101140:	83 ec 04             	sub    $0x4,%esp
f0101143:	68 c0 73 10 f0       	push   $0xf01073c0
f0101148:	68 de 01 00 00       	push   $0x1de
f010114d:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101152:	e8 e9 ee ff ff       	call   f0100040 <_panic>
}
f0101157:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010115a:	5b                   	pop    %ebx
f010115b:	5e                   	pop    %esi
f010115c:	5f                   	pop    %edi
f010115d:	5d                   	pop    %ebp
f010115e:	c3                   	ret    

f010115f <page_lookup>:
{
f010115f:	f3 0f 1e fb          	endbr32 
f0101163:	55                   	push   %ebp
f0101164:	89 e5                	mov    %esp,%ebp
f0101166:	53                   	push   %ebx
f0101167:	83 ec 08             	sub    $0x8,%esp
f010116a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pg_table_entry = pgdir_walk(pgdir, (void *)va, 0);
f010116d:	6a 00                	push   $0x0
f010116f:	ff 75 0c             	pushl  0xc(%ebp)
f0101172:	ff 75 08             	pushl  0x8(%ebp)
f0101175:	e8 e9 fe ff ff       	call   f0101063 <pgdir_walk>
	if(!pg_table_entry || !(*pg_table_entry & PTE_P)) return NULL;
f010117a:	83 c4 10             	add    $0x10,%esp
f010117d:	85 c0                	test   %eax,%eax
f010117f:	74 3c                	je     f01011bd <page_lookup+0x5e>
f0101181:	8b 10                	mov    (%eax),%edx
f0101183:	f6 c2 01             	test   $0x1,%dl
f0101186:	74 39                	je     f01011c1 <page_lookup+0x62>
f0101188:	c1 ea 0c             	shr    $0xc,%edx
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010118b:	39 15 94 ee 2b f0    	cmp    %edx,0xf02bee94
f0101191:	76 16                	jbe    f01011a9 <page_lookup+0x4a>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f0101193:	8b 0d 9c ee 2b f0    	mov    0xf02bee9c,%ecx
f0101199:	8d 14 d1             	lea    (%ecx,%edx,8),%edx
	if(pte_store) *pte_store = pg_table_entry ;
f010119c:	85 db                	test   %ebx,%ebx
f010119e:	74 02                	je     f01011a2 <page_lookup+0x43>
f01011a0:	89 03                	mov    %eax,(%ebx)
}
f01011a2:	89 d0                	mov    %edx,%eax
f01011a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01011a7:	c9                   	leave  
f01011a8:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01011a9:	83 ec 04             	sub    $0x4,%esp
f01011ac:	68 f0 73 10 f0       	push   $0xf01073f0
f01011b1:	6a 51                	push   $0x51
f01011b3:	68 9b 6f 10 f0       	push   $0xf0106f9b
f01011b8:	e8 83 ee ff ff       	call   f0100040 <_panic>
	if(!pg_table_entry || !(*pg_table_entry & PTE_P)) return NULL;
f01011bd:	89 c2                	mov    %eax,%edx
f01011bf:	eb e1                	jmp    f01011a2 <page_lookup+0x43>
f01011c1:	ba 00 00 00 00       	mov    $0x0,%edx
f01011c6:	eb da                	jmp    f01011a2 <page_lookup+0x43>

f01011c8 <tlb_invalidate>:
{
f01011c8:	f3 0f 1e fb          	endbr32 
f01011cc:	55                   	push   %ebp
f01011cd:	89 e5                	mov    %esp,%ebp
f01011cf:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01011d2:	e8 f7 4b 00 00       	call   f0105dce <cpunum>
f01011d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01011da:	83 b8 28 f0 2b f0 00 	cmpl   $0x0,-0xfd40fd8(%eax)
f01011e1:	74 16                	je     f01011f9 <tlb_invalidate+0x31>
f01011e3:	e8 e6 4b 00 00       	call   f0105dce <cpunum>
f01011e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01011eb:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01011f1:	8b 55 08             	mov    0x8(%ebp),%edx
f01011f4:	39 50 60             	cmp    %edx,0x60(%eax)
f01011f7:	75 06                	jne    f01011ff <tlb_invalidate+0x37>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01011fc:	0f 01 38             	invlpg (%eax)
}
f01011ff:	c9                   	leave  
f0101200:	c3                   	ret    

f0101201 <page_remove>:
{
f0101201:	f3 0f 1e fb          	endbr32 
f0101205:	55                   	push   %ebp
f0101206:	89 e5                	mov    %esp,%ebp
f0101208:	57                   	push   %edi
f0101209:	56                   	push   %esi
f010120a:	53                   	push   %ebx
f010120b:	83 ec 20             	sub    $0x20,%esp
f010120e:	8b 75 08             	mov    0x8(%ebp),%esi
f0101211:	8b 7d 0c             	mov    0xc(%ebp),%edi
	pte_t *entry = NULL;
f0101214:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	struct PageInfo *page = page_lookup(pgdir, va, &entry);
f010121b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010121e:	50                   	push   %eax
f010121f:	57                   	push   %edi
f0101220:	56                   	push   %esi
f0101221:	e8 39 ff ff ff       	call   f010115f <page_lookup>
f0101226:	89 c3                	mov    %eax,%ebx
	tlb_invalidate(pgdir, va);
f0101228:	83 c4 08             	add    $0x8,%esp
f010122b:	57                   	push   %edi
f010122c:	56                   	push   %esi
f010122d:	e8 96 ff ff ff       	call   f01011c8 <tlb_invalidate>
	page_decref(page);
f0101232:	89 1c 24             	mov    %ebx,(%esp)
f0101235:	e8 fc fd ff ff       	call   f0101036 <page_decref>
	*entry = 0;
f010123a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
f0101243:	83 c4 10             	add    $0x10,%esp
f0101246:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101249:	5b                   	pop    %ebx
f010124a:	5e                   	pop    %esi
f010124b:	5f                   	pop    %edi
f010124c:	5d                   	pop    %ebp
f010124d:	c3                   	ret    

f010124e <page_insert>:
{
f010124e:	f3 0f 1e fb          	endbr32 
f0101252:	55                   	push   %ebp
f0101253:	89 e5                	mov    %esp,%ebp
f0101255:	57                   	push   %edi
f0101256:	56                   	push   %esi
f0101257:	53                   	push   %ebx
f0101258:	83 ec 10             	sub    $0x10,%esp
f010125b:	8b 75 0c             	mov    0xc(%ebp),%esi
f010125e:	8b 7d 10             	mov    0x10(%ebp),%edi
	pte_t *pte = pgdir_walk(pgdir, va, 1);
f0101261:	6a 01                	push   $0x1
f0101263:	57                   	push   %edi
f0101264:	ff 75 08             	pushl  0x8(%ebp)
f0101267:	e8 f7 fd ff ff       	call   f0101063 <pgdir_walk>
	if (pte == NULL) {
f010126c:	83 c4 10             	add    $0x10,%esp
f010126f:	85 c0                	test   %eax,%eax
f0101271:	74 64                	je     f01012d7 <page_insert+0x89>
f0101273:	89 c3                	mov    %eax,%ebx
	if (*pte & PTE_P && PTE_ADDR(*pte) != page2pa(pp)) {
f0101275:	8b 10                	mov    (%eax),%edx
f0101277:	f6 c2 01             	test   $0x1,%dl
f010127a:	74 27                	je     f01012a3 <page_insert+0x55>
	return (pp - pages) << PGSHIFT;
f010127c:	89 f0                	mov    %esi,%eax
f010127e:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101284:	c1 f8 03             	sar    $0x3,%eax
f0101287:	c1 e0 0c             	shl    $0xc,%eax
f010128a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101290:	39 c2                	cmp    %eax,%edx
f0101292:	74 2e                	je     f01012c2 <page_insert+0x74>
		page_remove(pgdir, va);
f0101294:	83 ec 08             	sub    $0x8,%esp
f0101297:	57                   	push   %edi
f0101298:	ff 75 08             	pushl  0x8(%ebp)
f010129b:	e8 61 ff ff ff       	call   f0101201 <page_remove>
f01012a0:	83 c4 10             	add    $0x10,%esp
f01012a3:	89 f0                	mov    %esi,%eax
f01012a5:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f01012ab:	c1 f8 03             	sar    $0x3,%eax
f01012ae:	c1 e0 0c             	shl    $0xc,%eax
	if (PTE_ADDR(*pte) != page2pa(pp)) {
f01012b1:	8b 13                	mov    (%ebx),%edx
f01012b3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01012b9:	39 c2                	cmp    %eax,%edx
f01012bb:	74 05                	je     f01012c2 <page_insert+0x74>
	    ++pp->pp_ref;
f01012bd:	66 83 46 04 01       	addw   $0x1,0x4(%esi)
	*pte = page2pa(pp) | perm | PTE_P;
f01012c2:	0b 45 14             	or     0x14(%ebp),%eax
f01012c5:	83 c8 01             	or     $0x1,%eax
f01012c8:	89 03                	mov    %eax,(%ebx)
	return 0;
f01012ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01012d2:	5b                   	pop    %ebx
f01012d3:	5e                   	pop    %esi
f01012d4:	5f                   	pop    %edi
f01012d5:	5d                   	pop    %ebp
f01012d6:	c3                   	ret    
		return -E_NO_MEM;
f01012d7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01012dc:	eb f1                	jmp    f01012cf <page_insert+0x81>

f01012de <mmio_map_region>:
{
f01012de:	f3 0f 1e fb          	endbr32 
f01012e2:	55                   	push   %ebp
f01012e3:	89 e5                	mov    %esp,%ebp
f01012e5:	53                   	push   %ebx
f01012e6:	83 ec 04             	sub    $0x4,%esp
f01012e9:	8b 45 08             	mov    0x8(%ebp),%eax
	physaddr_t pa_begin = ROUNDDOWN(pa, PGSIZE);
f01012ec:	89 c2                	mov    %eax,%edx
f01012ee:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	physaddr_t pa_end = ROUNDUP(pa + size, PGSIZE);
f01012f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01012f7:	8d 9c 08 ff 0f 00 00 	lea    0xfff(%eax,%ecx,1),%ebx
	if (pa_end - pa_begin >= MMIOLIM - MMIOBASE) {
f01012fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101304:	29 d3                	sub    %edx,%ebx
f0101306:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
f010130c:	77 2a                	ja     f0101338 <mmio_map_region+0x5a>
	boot_map_region(kern_pgdir, base, size, pa_begin, PTE_W | PTE_PCD | PTE_PWT);
f010130e:	83 ec 08             	sub    $0x8,%esp
f0101311:	6a 1a                	push   $0x1a
f0101313:	52                   	push   %edx
f0101314:	89 d9                	mov    %ebx,%ecx
f0101316:	8b 15 00 53 12 f0    	mov    0xf0125300,%edx
f010131c:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101321:	e8 ce fd ff ff       	call   f01010f4 <boot_map_region>
	void *ret = (void *)base;
f0101326:	a1 00 53 12 f0       	mov    0xf0125300,%eax
	base += size;
f010132b:	01 c3                	add    %eax,%ebx
f010132d:	89 1d 00 53 12 f0    	mov    %ebx,0xf0125300
}
f0101333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101336:	c9                   	leave  
f0101337:	c3                   	ret    
	    panic("mmio_map_region: requesting size too large.\n");
f0101338:	83 ec 04             	sub    $0x4,%esp
f010133b:	68 10 74 10 f0       	push   $0xf0107410
f0101340:	68 81 02 00 00       	push   $0x281
f0101345:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010134a:	e8 f1 ec ff ff       	call   f0100040 <_panic>

f010134f <mem_init>:
{
f010134f:	f3 0f 1e fb          	endbr32 
f0101353:	55                   	push   %ebp
f0101354:	89 e5                	mov    %esp,%ebp
f0101356:	57                   	push   %edi
f0101357:	56                   	push   %esi
f0101358:	53                   	push   %ebx
f0101359:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f010135c:	b8 15 00 00 00       	mov    $0x15,%eax
f0101361:	e8 c0 f7 ff ff       	call   f0100b26 <nvram_read>
f0101366:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f0101368:	b8 17 00 00 00       	mov    $0x17,%eax
f010136d:	e8 b4 f7 ff ff       	call   f0100b26 <nvram_read>
f0101372:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101374:	b8 34 00 00 00       	mov    $0x34,%eax
f0101379:	e8 a8 f7 ff ff       	call   f0100b26 <nvram_read>
	if (ext16mem)
f010137e:	c1 e0 06             	shl    $0x6,%eax
f0101381:	0f 84 ea 00 00 00    	je     f0101471 <mem_init+0x122>
		totalmem = 16 * 1024 + ext16mem;
f0101387:	05 00 40 00 00       	add    $0x4000,%eax
	npages = totalmem / (PGSIZE / 1024);
f010138c:	89 c2                	mov    %eax,%edx
f010138e:	c1 ea 02             	shr    $0x2,%edx
f0101391:	89 15 94 ee 2b f0    	mov    %edx,0xf02bee94
	npages_basemem = basemem / (PGSIZE / 1024);
f0101397:	89 da                	mov    %ebx,%edx
f0101399:	c1 ea 02             	shr    $0x2,%edx
f010139c:	89 15 44 e2 2b f0    	mov    %edx,0xf02be244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01013a2:	89 c2                	mov    %eax,%edx
f01013a4:	29 da                	sub    %ebx,%edx
f01013a6:	52                   	push   %edx
f01013a7:	53                   	push   %ebx
f01013a8:	50                   	push   %eax
f01013a9:	68 40 74 10 f0       	push   $0xf0107440
f01013ae:	e8 b4 25 00 00       	call   f0103967 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01013b3:	b8 00 10 00 00       	mov    $0x1000,%eax
f01013b8:	e8 10 f7 ff ff       	call   f0100acd <boot_alloc>
f01013bd:	a3 98 ee 2b f0       	mov    %eax,0xf02bee98
	memset(kern_pgdir, 0, PGSIZE);
f01013c2:	83 c4 0c             	add    $0xc,%esp
f01013c5:	68 00 10 00 00       	push   $0x1000
f01013ca:	6a 00                	push   $0x0
f01013cc:	50                   	push   %eax
f01013cd:	e8 dc 43 00 00       	call   f01057ae <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01013d2:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f01013d7:	83 c4 10             	add    $0x10,%esp
f01013da:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013df:	0f 86 9c 00 00 00    	jbe    f0101481 <mem_init+0x132>
	return (physaddr_t)kva - KERNBASE;
f01013e5:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01013eb:	83 ca 05             	or     $0x5,%edx
f01013ee:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(npages * sizeof(struct PageInfo));
f01013f4:	a1 94 ee 2b f0       	mov    0xf02bee94,%eax
f01013f9:	c1 e0 03             	shl    $0x3,%eax
f01013fc:	e8 cc f6 ff ff       	call   f0100acd <boot_alloc>
f0101401:	a3 9c ee 2b f0       	mov    %eax,0xf02bee9c
	memset(pages, 0, npages * sizeof(struct PageInfo));
f0101406:	83 ec 04             	sub    $0x4,%esp
f0101409:	8b 0d 94 ee 2b f0    	mov    0xf02bee94,%ecx
f010140f:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101416:	52                   	push   %edx
f0101417:	6a 00                	push   $0x0
f0101419:	50                   	push   %eax
f010141a:	e8 8f 43 00 00       	call   f01057ae <memset>
	envs = (struct Env *)boot_alloc(NENV * sizeof(struct Env));
f010141f:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101424:	e8 a4 f6 ff ff       	call   f0100acd <boot_alloc>
f0101429:	a3 48 e2 2b f0       	mov    %eax,0xf02be248
	memset(envs, 0, NENV * sizeof(struct Env));
f010142e:	83 c4 0c             	add    $0xc,%esp
f0101431:	68 00 f0 01 00       	push   $0x1f000
f0101436:	6a 00                	push   $0x0
f0101438:	50                   	push   %eax
f0101439:	e8 70 43 00 00       	call   f01057ae <memset>
	page_init();
f010143e:	e8 5d fa ff ff       	call   f0100ea0 <page_init>
	check_page_free_list(1);
f0101443:	b8 01 00 00 00       	mov    $0x1,%eax
f0101448:	e8 65 f7 ff ff       	call   f0100bb2 <check_page_free_list>
	if (!pages)
f010144d:	83 c4 10             	add    $0x10,%esp
f0101450:	83 3d 9c ee 2b f0 00 	cmpl   $0x0,0xf02bee9c
f0101457:	74 3d                	je     f0101496 <mem_init+0x147>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101459:	a1 40 e2 2b f0       	mov    0xf02be240,%eax
f010145e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0101465:	85 c0                	test   %eax,%eax
f0101467:	74 44                	je     f01014ad <mem_init+0x15e>
		++nfree;
f0101469:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f010146d:	8b 00                	mov    (%eax),%eax
f010146f:	eb f4                	jmp    f0101465 <mem_init+0x116>
		totalmem = 1 * 1024 + extmem;
f0101471:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f0101477:	85 f6                	test   %esi,%esi
f0101479:	0f 44 c3             	cmove  %ebx,%eax
f010147c:	e9 0b ff ff ff       	jmp    f010138c <mem_init+0x3d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101481:	50                   	push   %eax
f0101482:	68 48 6a 10 f0       	push   $0xf0106a48
f0101487:	68 a8 00 00 00       	push   $0xa8
f010148c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101491:	e8 aa eb ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f0101496:	83 ec 04             	sub    $0x4,%esp
f0101499:	68 62 70 10 f0       	push   $0xf0107062
f010149e:	68 17 03 00 00       	push   $0x317
f01014a3:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01014a8:	e8 93 eb ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01014ad:	83 ec 0c             	sub    $0xc,%esp
f01014b0:	6a 00                	push   $0x0
f01014b2:	e8 c3 fa ff ff       	call   f0100f7a <page_alloc>
f01014b7:	89 c3                	mov    %eax,%ebx
f01014b9:	83 c4 10             	add    $0x10,%esp
f01014bc:	85 c0                	test   %eax,%eax
f01014be:	0f 84 11 02 00 00    	je     f01016d5 <mem_init+0x386>
	assert((pp1 = page_alloc(0)));
f01014c4:	83 ec 0c             	sub    $0xc,%esp
f01014c7:	6a 00                	push   $0x0
f01014c9:	e8 ac fa ff ff       	call   f0100f7a <page_alloc>
f01014ce:	89 c6                	mov    %eax,%esi
f01014d0:	83 c4 10             	add    $0x10,%esp
f01014d3:	85 c0                	test   %eax,%eax
f01014d5:	0f 84 13 02 00 00    	je     f01016ee <mem_init+0x39f>
	assert((pp2 = page_alloc(0)));
f01014db:	83 ec 0c             	sub    $0xc,%esp
f01014de:	6a 00                	push   $0x0
f01014e0:	e8 95 fa ff ff       	call   f0100f7a <page_alloc>
f01014e5:	89 c7                	mov    %eax,%edi
f01014e7:	83 c4 10             	add    $0x10,%esp
f01014ea:	85 c0                	test   %eax,%eax
f01014ec:	0f 84 15 02 00 00    	je     f0101707 <mem_init+0x3b8>
	assert(pp1 && pp1 != pp0);
f01014f2:	39 f3                	cmp    %esi,%ebx
f01014f4:	0f 84 26 02 00 00    	je     f0101720 <mem_init+0x3d1>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01014fa:	39 c6                	cmp    %eax,%esi
f01014fc:	0f 84 37 02 00 00    	je     f0101739 <mem_init+0x3ea>
f0101502:	39 c3                	cmp    %eax,%ebx
f0101504:	0f 84 2f 02 00 00    	je     f0101739 <mem_init+0x3ea>
	return (pp - pages) << PGSHIFT;
f010150a:	8b 0d 9c ee 2b f0    	mov    0xf02bee9c,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101510:	8b 15 94 ee 2b f0    	mov    0xf02bee94,%edx
f0101516:	c1 e2 0c             	shl    $0xc,%edx
f0101519:	89 d8                	mov    %ebx,%eax
f010151b:	29 c8                	sub    %ecx,%eax
f010151d:	c1 f8 03             	sar    $0x3,%eax
f0101520:	c1 e0 0c             	shl    $0xc,%eax
f0101523:	39 d0                	cmp    %edx,%eax
f0101525:	0f 83 27 02 00 00    	jae    f0101752 <mem_init+0x403>
f010152b:	89 f0                	mov    %esi,%eax
f010152d:	29 c8                	sub    %ecx,%eax
f010152f:	c1 f8 03             	sar    $0x3,%eax
f0101532:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101535:	39 c2                	cmp    %eax,%edx
f0101537:	0f 86 2e 02 00 00    	jbe    f010176b <mem_init+0x41c>
f010153d:	89 f8                	mov    %edi,%eax
f010153f:	29 c8                	sub    %ecx,%eax
f0101541:	c1 f8 03             	sar    $0x3,%eax
f0101544:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101547:	39 c2                	cmp    %eax,%edx
f0101549:	0f 86 35 02 00 00    	jbe    f0101784 <mem_init+0x435>
	fl = page_free_list;
f010154f:	a1 40 e2 2b f0       	mov    0xf02be240,%eax
f0101554:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101557:	c7 05 40 e2 2b f0 00 	movl   $0x0,0xf02be240
f010155e:	00 00 00 
	assert(!page_alloc(0));
f0101561:	83 ec 0c             	sub    $0xc,%esp
f0101564:	6a 00                	push   $0x0
f0101566:	e8 0f fa ff ff       	call   f0100f7a <page_alloc>
f010156b:	83 c4 10             	add    $0x10,%esp
f010156e:	85 c0                	test   %eax,%eax
f0101570:	0f 85 27 02 00 00    	jne    f010179d <mem_init+0x44e>
	page_free(pp0);
f0101576:	83 ec 0c             	sub    $0xc,%esp
f0101579:	53                   	push   %ebx
f010157a:	e8 74 fa ff ff       	call   f0100ff3 <page_free>
	page_free(pp1);
f010157f:	89 34 24             	mov    %esi,(%esp)
f0101582:	e8 6c fa ff ff       	call   f0100ff3 <page_free>
	page_free(pp2);
f0101587:	89 3c 24             	mov    %edi,(%esp)
f010158a:	e8 64 fa ff ff       	call   f0100ff3 <page_free>
	assert((pp0 = page_alloc(0)));
f010158f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101596:	e8 df f9 ff ff       	call   f0100f7a <page_alloc>
f010159b:	89 c3                	mov    %eax,%ebx
f010159d:	83 c4 10             	add    $0x10,%esp
f01015a0:	85 c0                	test   %eax,%eax
f01015a2:	0f 84 0e 02 00 00    	je     f01017b6 <mem_init+0x467>
	assert((pp1 = page_alloc(0)));
f01015a8:	83 ec 0c             	sub    $0xc,%esp
f01015ab:	6a 00                	push   $0x0
f01015ad:	e8 c8 f9 ff ff       	call   f0100f7a <page_alloc>
f01015b2:	89 c6                	mov    %eax,%esi
f01015b4:	83 c4 10             	add    $0x10,%esp
f01015b7:	85 c0                	test   %eax,%eax
f01015b9:	0f 84 10 02 00 00    	je     f01017cf <mem_init+0x480>
	assert((pp2 = page_alloc(0)));
f01015bf:	83 ec 0c             	sub    $0xc,%esp
f01015c2:	6a 00                	push   $0x0
f01015c4:	e8 b1 f9 ff ff       	call   f0100f7a <page_alloc>
f01015c9:	89 c7                	mov    %eax,%edi
f01015cb:	83 c4 10             	add    $0x10,%esp
f01015ce:	85 c0                	test   %eax,%eax
f01015d0:	0f 84 12 02 00 00    	je     f01017e8 <mem_init+0x499>
	assert(pp1 && pp1 != pp0);
f01015d6:	39 f3                	cmp    %esi,%ebx
f01015d8:	0f 84 23 02 00 00    	je     f0101801 <mem_init+0x4b2>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015de:	39 c3                	cmp    %eax,%ebx
f01015e0:	0f 84 34 02 00 00    	je     f010181a <mem_init+0x4cb>
f01015e6:	39 c6                	cmp    %eax,%esi
f01015e8:	0f 84 2c 02 00 00    	je     f010181a <mem_init+0x4cb>
	assert(!page_alloc(0));
f01015ee:	83 ec 0c             	sub    $0xc,%esp
f01015f1:	6a 00                	push   $0x0
f01015f3:	e8 82 f9 ff ff       	call   f0100f7a <page_alloc>
f01015f8:	83 c4 10             	add    $0x10,%esp
f01015fb:	85 c0                	test   %eax,%eax
f01015fd:	0f 85 30 02 00 00    	jne    f0101833 <mem_init+0x4e4>
f0101603:	89 d8                	mov    %ebx,%eax
f0101605:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f010160b:	c1 f8 03             	sar    $0x3,%eax
f010160e:	89 c2                	mov    %eax,%edx
f0101610:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101613:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101618:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f010161e:	0f 83 28 02 00 00    	jae    f010184c <mem_init+0x4fd>
	memset(page2kva(pp0), 1, PGSIZE);
f0101624:	83 ec 04             	sub    $0x4,%esp
f0101627:	68 00 10 00 00       	push   $0x1000
f010162c:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f010162e:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101634:	52                   	push   %edx
f0101635:	e8 74 41 00 00       	call   f01057ae <memset>
	page_free(pp0);
f010163a:	89 1c 24             	mov    %ebx,(%esp)
f010163d:	e8 b1 f9 ff ff       	call   f0100ff3 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101649:	e8 2c f9 ff ff       	call   f0100f7a <page_alloc>
f010164e:	83 c4 10             	add    $0x10,%esp
f0101651:	85 c0                	test   %eax,%eax
f0101653:	0f 84 05 02 00 00    	je     f010185e <mem_init+0x50f>
	assert(pp && pp0 == pp);
f0101659:	39 c3                	cmp    %eax,%ebx
f010165b:	0f 85 16 02 00 00    	jne    f0101877 <mem_init+0x528>
	return (pp - pages) << PGSHIFT;
f0101661:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101667:	c1 f8 03             	sar    $0x3,%eax
f010166a:	89 c2                	mov    %eax,%edx
f010166c:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010166f:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101674:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f010167a:	0f 83 10 02 00 00    	jae    f0101890 <mem_init+0x541>
	return (void *)(pa + KERNBASE);
f0101680:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0101686:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f010168c:	80 38 00             	cmpb   $0x0,(%eax)
f010168f:	0f 85 0d 02 00 00    	jne    f01018a2 <mem_init+0x553>
f0101695:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f0101698:	39 d0                	cmp    %edx,%eax
f010169a:	75 f0                	jne    f010168c <mem_init+0x33d>
	page_free_list = fl;
f010169c:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010169f:	a3 40 e2 2b f0       	mov    %eax,0xf02be240
	page_free(pp0);
f01016a4:	83 ec 0c             	sub    $0xc,%esp
f01016a7:	53                   	push   %ebx
f01016a8:	e8 46 f9 ff ff       	call   f0100ff3 <page_free>
	page_free(pp1);
f01016ad:	89 34 24             	mov    %esi,(%esp)
f01016b0:	e8 3e f9 ff ff       	call   f0100ff3 <page_free>
	page_free(pp2);
f01016b5:	89 3c 24             	mov    %edi,(%esp)
f01016b8:	e8 36 f9 ff ff       	call   f0100ff3 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01016bd:	a1 40 e2 2b f0       	mov    0xf02be240,%eax
f01016c2:	83 c4 10             	add    $0x10,%esp
f01016c5:	85 c0                	test   %eax,%eax
f01016c7:	0f 84 ee 01 00 00    	je     f01018bb <mem_init+0x56c>
		--nfree;
f01016cd:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01016d1:	8b 00                	mov    (%eax),%eax
f01016d3:	eb f0                	jmp    f01016c5 <mem_init+0x376>
	assert((pp0 = page_alloc(0)));
f01016d5:	68 7d 70 10 f0       	push   $0xf010707d
f01016da:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01016df:	68 1f 03 00 00       	push   $0x31f
f01016e4:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01016e9:	e8 52 e9 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01016ee:	68 93 70 10 f0       	push   $0xf0107093
f01016f3:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01016f8:	68 20 03 00 00       	push   $0x320
f01016fd:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101702:	e8 39 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101707:	68 a9 70 10 f0       	push   $0xf01070a9
f010170c:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101711:	68 21 03 00 00       	push   $0x321
f0101716:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010171b:	e8 20 e9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101720:	68 bf 70 10 f0       	push   $0xf01070bf
f0101725:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010172a:	68 24 03 00 00       	push   $0x324
f010172f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101734:	e8 07 e9 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101739:	68 7c 74 10 f0       	push   $0xf010747c
f010173e:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101743:	68 25 03 00 00       	push   $0x325
f0101748:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010174d:	e8 ee e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101752:	68 d1 70 10 f0       	push   $0xf01070d1
f0101757:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010175c:	68 26 03 00 00       	push   $0x326
f0101761:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101766:	e8 d5 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f010176b:	68 ee 70 10 f0       	push   $0xf01070ee
f0101770:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101775:	68 27 03 00 00       	push   $0x327
f010177a:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010177f:	e8 bc e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101784:	68 0b 71 10 f0       	push   $0xf010710b
f0101789:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010178e:	68 28 03 00 00       	push   $0x328
f0101793:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101798:	e8 a3 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010179d:	68 28 71 10 f0       	push   $0xf0107128
f01017a2:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01017a7:	68 2f 03 00 00       	push   $0x32f
f01017ac:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01017b1:	e8 8a e8 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01017b6:	68 7d 70 10 f0       	push   $0xf010707d
f01017bb:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01017c0:	68 36 03 00 00       	push   $0x336
f01017c5:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01017ca:	e8 71 e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01017cf:	68 93 70 10 f0       	push   $0xf0107093
f01017d4:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01017d9:	68 37 03 00 00       	push   $0x337
f01017de:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01017e3:	e8 58 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017e8:	68 a9 70 10 f0       	push   $0xf01070a9
f01017ed:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01017f2:	68 38 03 00 00       	push   $0x338
f01017f7:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01017fc:	e8 3f e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101801:	68 bf 70 10 f0       	push   $0xf01070bf
f0101806:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010180b:	68 3a 03 00 00       	push   $0x33a
f0101810:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101815:	e8 26 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010181a:	68 7c 74 10 f0       	push   $0xf010747c
f010181f:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101824:	68 3b 03 00 00       	push   $0x33b
f0101829:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010182e:	e8 0d e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101833:	68 28 71 10 f0       	push   $0xf0107128
f0101838:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010183d:	68 3c 03 00 00       	push   $0x33c
f0101842:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101847:	e8 f4 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010184c:	52                   	push   %edx
f010184d:	68 24 6a 10 f0       	push   $0xf0106a24
f0101852:	6a 58                	push   $0x58
f0101854:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0101859:	e8 e2 e7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010185e:	68 37 71 10 f0       	push   $0xf0107137
f0101863:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101868:	68 41 03 00 00       	push   $0x341
f010186d:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0101872:	e8 c9 e7 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101877:	68 55 71 10 f0       	push   $0xf0107155
f010187c:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0101881:	68 42 03 00 00       	push   $0x342
f0101886:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010188b:	e8 b0 e7 ff ff       	call   f0100040 <_panic>
f0101890:	52                   	push   %edx
f0101891:	68 24 6a 10 f0       	push   $0xf0106a24
f0101896:	6a 58                	push   $0x58
f0101898:	68 9b 6f 10 f0       	push   $0xf0106f9b
f010189d:	e8 9e e7 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f01018a2:	68 65 71 10 f0       	push   $0xf0107165
f01018a7:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01018ac:	68 45 03 00 00       	push   $0x345
f01018b1:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01018b6:	e8 85 e7 ff ff       	call   f0100040 <_panic>
	assert(nfree == 0);
f01018bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f01018bf:	0f 85 43 09 00 00    	jne    f0102208 <mem_init+0xeb9>
	cprintf("check_page_alloc() succeeded!\n");
f01018c5:	83 ec 0c             	sub    $0xc,%esp
f01018c8:	68 9c 74 10 f0       	push   $0xf010749c
f01018cd:	e8 95 20 00 00       	call   f0103967 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01018d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018d9:	e8 9c f6 ff ff       	call   f0100f7a <page_alloc>
f01018de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018e1:	83 c4 10             	add    $0x10,%esp
f01018e4:	85 c0                	test   %eax,%eax
f01018e6:	0f 84 35 09 00 00    	je     f0102221 <mem_init+0xed2>
	assert((pp1 = page_alloc(0)));
f01018ec:	83 ec 0c             	sub    $0xc,%esp
f01018ef:	6a 00                	push   $0x0
f01018f1:	e8 84 f6 ff ff       	call   f0100f7a <page_alloc>
f01018f6:	89 c7                	mov    %eax,%edi
f01018f8:	83 c4 10             	add    $0x10,%esp
f01018fb:	85 c0                	test   %eax,%eax
f01018fd:	0f 84 37 09 00 00    	je     f010223a <mem_init+0xeeb>
	assert((pp2 = page_alloc(0)));
f0101903:	83 ec 0c             	sub    $0xc,%esp
f0101906:	6a 00                	push   $0x0
f0101908:	e8 6d f6 ff ff       	call   f0100f7a <page_alloc>
f010190d:	89 c3                	mov    %eax,%ebx
f010190f:	83 c4 10             	add    $0x10,%esp
f0101912:	85 c0                	test   %eax,%eax
f0101914:	0f 84 39 09 00 00    	je     f0102253 <mem_init+0xf04>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010191a:	39 7d d4             	cmp    %edi,-0x2c(%ebp)
f010191d:	0f 84 49 09 00 00    	je     f010226c <mem_init+0xf1d>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101923:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101926:	0f 84 59 09 00 00    	je     f0102285 <mem_init+0xf36>
f010192c:	39 c7                	cmp    %eax,%edi
f010192e:	0f 84 51 09 00 00    	je     f0102285 <mem_init+0xf36>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101934:	a1 40 e2 2b f0       	mov    0xf02be240,%eax
f0101939:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f010193c:	c7 05 40 e2 2b f0 00 	movl   $0x0,0xf02be240
f0101943:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101946:	83 ec 0c             	sub    $0xc,%esp
f0101949:	6a 00                	push   $0x0
f010194b:	e8 2a f6 ff ff       	call   f0100f7a <page_alloc>
f0101950:	83 c4 10             	add    $0x10,%esp
f0101953:	85 c0                	test   %eax,%eax
f0101955:	0f 85 43 09 00 00    	jne    f010229e <mem_init+0xf4f>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010195b:	83 ec 04             	sub    $0x4,%esp
f010195e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101961:	50                   	push   %eax
f0101962:	6a 00                	push   $0x0
f0101964:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f010196a:	e8 f0 f7 ff ff       	call   f010115f <page_lookup>
f010196f:	83 c4 10             	add    $0x10,%esp
f0101972:	85 c0                	test   %eax,%eax
f0101974:	0f 85 3d 09 00 00    	jne    f01022b7 <mem_init+0xf68>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010197a:	6a 02                	push   $0x2
f010197c:	6a 00                	push   $0x0
f010197e:	57                   	push   %edi
f010197f:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101985:	e8 c4 f8 ff ff       	call   f010124e <page_insert>
f010198a:	83 c4 10             	add    $0x10,%esp
f010198d:	85 c0                	test   %eax,%eax
f010198f:	0f 89 3b 09 00 00    	jns    f01022d0 <mem_init+0xf81>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101995:	83 ec 0c             	sub    $0xc,%esp
f0101998:	ff 75 d4             	pushl  -0x2c(%ebp)
f010199b:	e8 53 f6 ff ff       	call   f0100ff3 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01019a0:	6a 02                	push   $0x2
f01019a2:	6a 00                	push   $0x0
f01019a4:	57                   	push   %edi
f01019a5:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f01019ab:	e8 9e f8 ff ff       	call   f010124e <page_insert>
f01019b0:	83 c4 20             	add    $0x20,%esp
f01019b3:	85 c0                	test   %eax,%eax
f01019b5:	0f 85 2e 09 00 00    	jne    f01022e9 <mem_init+0xf9a>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01019bb:	8b 35 98 ee 2b f0    	mov    0xf02bee98,%esi
	return (pp - pages) << PGSHIFT;
f01019c1:	8b 0d 9c ee 2b f0    	mov    0xf02bee9c,%ecx
f01019c7:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f01019ca:	8b 16                	mov    (%esi),%edx
f01019cc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01019d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019d5:	29 c8                	sub    %ecx,%eax
f01019d7:	c1 f8 03             	sar    $0x3,%eax
f01019da:	c1 e0 0c             	shl    $0xc,%eax
f01019dd:	39 c2                	cmp    %eax,%edx
f01019df:	0f 85 1d 09 00 00    	jne    f0102302 <mem_init+0xfb3>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01019e5:	ba 00 00 00 00       	mov    $0x0,%edx
f01019ea:	89 f0                	mov    %esi,%eax
f01019ec:	e8 5e f1 ff ff       	call   f0100b4f <check_va2pa>
f01019f1:	89 c2                	mov    %eax,%edx
f01019f3:	89 f8                	mov    %edi,%eax
f01019f5:	2b 45 d0             	sub    -0x30(%ebp),%eax
f01019f8:	c1 f8 03             	sar    $0x3,%eax
f01019fb:	c1 e0 0c             	shl    $0xc,%eax
f01019fe:	39 c2                	cmp    %eax,%edx
f0101a00:	0f 85 15 09 00 00    	jne    f010231b <mem_init+0xfcc>
	assert(pp1->pp_ref == 1);
f0101a06:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101a0b:	0f 85 23 09 00 00    	jne    f0102334 <mem_init+0xfe5>
	assert(pp0->pp_ref == 1);
f0101a11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a14:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101a19:	0f 85 2e 09 00 00    	jne    f010234d <mem_init+0xffe>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101a1f:	6a 02                	push   $0x2
f0101a21:	68 00 10 00 00       	push   $0x1000
f0101a26:	53                   	push   %ebx
f0101a27:	56                   	push   %esi
f0101a28:	e8 21 f8 ff ff       	call   f010124e <page_insert>
f0101a2d:	83 c4 10             	add    $0x10,%esp
f0101a30:	85 c0                	test   %eax,%eax
f0101a32:	0f 85 2e 09 00 00    	jne    f0102366 <mem_init+0x1017>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a38:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a3d:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101a42:	e8 08 f1 ff ff       	call   f0100b4f <check_va2pa>
f0101a47:	89 c2                	mov    %eax,%edx
f0101a49:	89 d8                	mov    %ebx,%eax
f0101a4b:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101a51:	c1 f8 03             	sar    $0x3,%eax
f0101a54:	c1 e0 0c             	shl    $0xc,%eax
f0101a57:	39 c2                	cmp    %eax,%edx
f0101a59:	0f 85 20 09 00 00    	jne    f010237f <mem_init+0x1030>
	assert(pp2->pp_ref == 1);
f0101a5f:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101a64:	0f 85 2e 09 00 00    	jne    f0102398 <mem_init+0x1049>

	// should be no free memory
	assert(!page_alloc(0));
f0101a6a:	83 ec 0c             	sub    $0xc,%esp
f0101a6d:	6a 00                	push   $0x0
f0101a6f:	e8 06 f5 ff ff       	call   f0100f7a <page_alloc>
f0101a74:	83 c4 10             	add    $0x10,%esp
f0101a77:	85 c0                	test   %eax,%eax
f0101a79:	0f 85 32 09 00 00    	jne    f01023b1 <mem_init+0x1062>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101a7f:	6a 02                	push   $0x2
f0101a81:	68 00 10 00 00       	push   $0x1000
f0101a86:	53                   	push   %ebx
f0101a87:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101a8d:	e8 bc f7 ff ff       	call   f010124e <page_insert>
f0101a92:	83 c4 10             	add    $0x10,%esp
f0101a95:	85 c0                	test   %eax,%eax
f0101a97:	0f 85 2d 09 00 00    	jne    f01023ca <mem_init+0x107b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a9d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101aa2:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101aa7:	e8 a3 f0 ff ff       	call   f0100b4f <check_va2pa>
f0101aac:	89 c2                	mov    %eax,%edx
f0101aae:	89 d8                	mov    %ebx,%eax
f0101ab0:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101ab6:	c1 f8 03             	sar    $0x3,%eax
f0101ab9:	c1 e0 0c             	shl    $0xc,%eax
f0101abc:	39 c2                	cmp    %eax,%edx
f0101abe:	0f 85 1f 09 00 00    	jne    f01023e3 <mem_init+0x1094>
	assert(pp2->pp_ref == 1);
f0101ac4:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101ac9:	0f 85 2d 09 00 00    	jne    f01023fc <mem_init+0x10ad>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101acf:	83 ec 0c             	sub    $0xc,%esp
f0101ad2:	6a 00                	push   $0x0
f0101ad4:	e8 a1 f4 ff ff       	call   f0100f7a <page_alloc>
f0101ad9:	83 c4 10             	add    $0x10,%esp
f0101adc:	85 c0                	test   %eax,%eax
f0101ade:	0f 85 31 09 00 00    	jne    f0102415 <mem_init+0x10c6>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101ae4:	8b 0d 98 ee 2b f0    	mov    0xf02bee98,%ecx
f0101aea:	8b 01                	mov    (%ecx),%eax
f0101aec:	89 c2                	mov    %eax,%edx
f0101aee:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0101af4:	c1 e8 0c             	shr    $0xc,%eax
f0101af7:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0101afd:	0f 83 2b 09 00 00    	jae    f010242e <mem_init+0x10df>
	return (void *)(pa + KERNBASE);
f0101b03:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101b09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101b0c:	83 ec 04             	sub    $0x4,%esp
f0101b0f:	6a 00                	push   $0x0
f0101b11:	68 00 10 00 00       	push   $0x1000
f0101b16:	51                   	push   %ecx
f0101b17:	e8 47 f5 ff ff       	call   f0101063 <pgdir_walk>
f0101b1c:	89 c2                	mov    %eax,%edx
f0101b1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101b21:	83 c0 04             	add    $0x4,%eax
f0101b24:	83 c4 10             	add    $0x10,%esp
f0101b27:	39 d0                	cmp    %edx,%eax
f0101b29:	0f 85 14 09 00 00    	jne    f0102443 <mem_init+0x10f4>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101b2f:	6a 06                	push   $0x6
f0101b31:	68 00 10 00 00       	push   $0x1000
f0101b36:	53                   	push   %ebx
f0101b37:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101b3d:	e8 0c f7 ff ff       	call   f010124e <page_insert>
f0101b42:	83 c4 10             	add    $0x10,%esp
f0101b45:	85 c0                	test   %eax,%eax
f0101b47:	0f 85 0f 09 00 00    	jne    f010245c <mem_init+0x110d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b4d:	8b 35 98 ee 2b f0    	mov    0xf02bee98,%esi
f0101b53:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b58:	89 f0                	mov    %esi,%eax
f0101b5a:	e8 f0 ef ff ff       	call   f0100b4f <check_va2pa>
f0101b5f:	89 c2                	mov    %eax,%edx
	return (pp - pages) << PGSHIFT;
f0101b61:	89 d8                	mov    %ebx,%eax
f0101b63:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101b69:	c1 f8 03             	sar    $0x3,%eax
f0101b6c:	c1 e0 0c             	shl    $0xc,%eax
f0101b6f:	39 c2                	cmp    %eax,%edx
f0101b71:	0f 85 fe 08 00 00    	jne    f0102475 <mem_init+0x1126>
	assert(pp2->pp_ref == 1);
f0101b77:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101b7c:	0f 85 0c 09 00 00    	jne    f010248e <mem_init+0x113f>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101b82:	83 ec 04             	sub    $0x4,%esp
f0101b85:	6a 00                	push   $0x0
f0101b87:	68 00 10 00 00       	push   $0x1000
f0101b8c:	56                   	push   %esi
f0101b8d:	e8 d1 f4 ff ff       	call   f0101063 <pgdir_walk>
f0101b92:	83 c4 10             	add    $0x10,%esp
f0101b95:	f6 00 04             	testb  $0x4,(%eax)
f0101b98:	0f 84 09 09 00 00    	je     f01024a7 <mem_init+0x1158>
	assert(kern_pgdir[0] & PTE_U);
f0101b9e:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101ba3:	f6 00 04             	testb  $0x4,(%eax)
f0101ba6:	0f 84 14 09 00 00    	je     f01024c0 <mem_init+0x1171>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101bac:	6a 02                	push   $0x2
f0101bae:	68 00 10 00 00       	push   $0x1000
f0101bb3:	53                   	push   %ebx
f0101bb4:	50                   	push   %eax
f0101bb5:	e8 94 f6 ff ff       	call   f010124e <page_insert>
f0101bba:	83 c4 10             	add    $0x10,%esp
f0101bbd:	85 c0                	test   %eax,%eax
f0101bbf:	0f 85 14 09 00 00    	jne    f01024d9 <mem_init+0x118a>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101bc5:	83 ec 04             	sub    $0x4,%esp
f0101bc8:	6a 00                	push   $0x0
f0101bca:	68 00 10 00 00       	push   $0x1000
f0101bcf:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101bd5:	e8 89 f4 ff ff       	call   f0101063 <pgdir_walk>
f0101bda:	83 c4 10             	add    $0x10,%esp
f0101bdd:	f6 00 02             	testb  $0x2,(%eax)
f0101be0:	0f 84 0c 09 00 00    	je     f01024f2 <mem_init+0x11a3>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101be6:	83 ec 04             	sub    $0x4,%esp
f0101be9:	6a 00                	push   $0x0
f0101beb:	68 00 10 00 00       	push   $0x1000
f0101bf0:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101bf6:	e8 68 f4 ff ff       	call   f0101063 <pgdir_walk>
f0101bfb:	83 c4 10             	add    $0x10,%esp
f0101bfe:	f6 00 04             	testb  $0x4,(%eax)
f0101c01:	0f 85 04 09 00 00    	jne    f010250b <mem_init+0x11bc>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101c07:	6a 02                	push   $0x2
f0101c09:	68 00 00 40 00       	push   $0x400000
f0101c0e:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101c11:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101c17:	e8 32 f6 ff ff       	call   f010124e <page_insert>
f0101c1c:	83 c4 10             	add    $0x10,%esp
f0101c1f:	85 c0                	test   %eax,%eax
f0101c21:	0f 89 fd 08 00 00    	jns    f0102524 <mem_init+0x11d5>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101c27:	6a 02                	push   $0x2
f0101c29:	68 00 10 00 00       	push   $0x1000
f0101c2e:	57                   	push   %edi
f0101c2f:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101c35:	e8 14 f6 ff ff       	call   f010124e <page_insert>
f0101c3a:	83 c4 10             	add    $0x10,%esp
f0101c3d:	85 c0                	test   %eax,%eax
f0101c3f:	0f 85 f8 08 00 00    	jne    f010253d <mem_init+0x11ee>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101c45:	83 ec 04             	sub    $0x4,%esp
f0101c48:	6a 00                	push   $0x0
f0101c4a:	68 00 10 00 00       	push   $0x1000
f0101c4f:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101c55:	e8 09 f4 ff ff       	call   f0101063 <pgdir_walk>
f0101c5a:	83 c4 10             	add    $0x10,%esp
f0101c5d:	f6 00 04             	testb  $0x4,(%eax)
f0101c60:	0f 85 f0 08 00 00    	jne    f0102556 <mem_init+0x1207>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101c66:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101c6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c6e:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c73:	e8 d7 ee ff ff       	call   f0100b4f <check_va2pa>
f0101c78:	89 fe                	mov    %edi,%esi
f0101c7a:	2b 35 9c ee 2b f0    	sub    0xf02bee9c,%esi
f0101c80:	c1 fe 03             	sar    $0x3,%esi
f0101c83:	c1 e6 0c             	shl    $0xc,%esi
f0101c86:	39 f0                	cmp    %esi,%eax
f0101c88:	0f 85 e1 08 00 00    	jne    f010256f <mem_init+0x1220>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101c8e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101c93:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101c96:	e8 b4 ee ff ff       	call   f0100b4f <check_va2pa>
f0101c9b:	39 c6                	cmp    %eax,%esi
f0101c9d:	0f 85 e5 08 00 00    	jne    f0102588 <mem_init+0x1239>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101ca3:	66 83 7f 04 02       	cmpw   $0x2,0x4(%edi)
f0101ca8:	0f 85 f3 08 00 00    	jne    f01025a1 <mem_init+0x1252>
	assert(pp2->pp_ref == 0);
f0101cae:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101cb3:	0f 85 01 09 00 00    	jne    f01025ba <mem_init+0x126b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101cb9:	83 ec 0c             	sub    $0xc,%esp
f0101cbc:	6a 00                	push   $0x0
f0101cbe:	e8 b7 f2 ff ff       	call   f0100f7a <page_alloc>
f0101cc3:	83 c4 10             	add    $0x10,%esp
f0101cc6:	85 c0                	test   %eax,%eax
f0101cc8:	0f 84 05 09 00 00    	je     f01025d3 <mem_init+0x1284>
f0101cce:	39 c3                	cmp    %eax,%ebx
f0101cd0:	0f 85 fd 08 00 00    	jne    f01025d3 <mem_init+0x1284>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101cd6:	83 ec 08             	sub    $0x8,%esp
f0101cd9:	6a 00                	push   $0x0
f0101cdb:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101ce1:	e8 1b f5 ff ff       	call   f0101201 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101ce6:	8b 35 98 ee 2b f0    	mov    0xf02bee98,%esi
f0101cec:	ba 00 00 00 00       	mov    $0x0,%edx
f0101cf1:	89 f0                	mov    %esi,%eax
f0101cf3:	e8 57 ee ff ff       	call   f0100b4f <check_va2pa>
f0101cf8:	83 c4 10             	add    $0x10,%esp
f0101cfb:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101cfe:	0f 85 e8 08 00 00    	jne    f01025ec <mem_init+0x129d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d04:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d09:	89 f0                	mov    %esi,%eax
f0101d0b:	e8 3f ee ff ff       	call   f0100b4f <check_va2pa>
f0101d10:	89 c2                	mov    %eax,%edx
f0101d12:	89 f8                	mov    %edi,%eax
f0101d14:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101d1a:	c1 f8 03             	sar    $0x3,%eax
f0101d1d:	c1 e0 0c             	shl    $0xc,%eax
f0101d20:	39 c2                	cmp    %eax,%edx
f0101d22:	0f 85 dd 08 00 00    	jne    f0102605 <mem_init+0x12b6>
	assert(pp1->pp_ref == 1);
f0101d28:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101d2d:	0f 85 eb 08 00 00    	jne    f010261e <mem_init+0x12cf>
	assert(pp2->pp_ref == 0);
f0101d33:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d38:	0f 85 f9 08 00 00    	jne    f0102637 <mem_init+0x12e8>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0101d3e:	6a 00                	push   $0x0
f0101d40:	68 00 10 00 00       	push   $0x1000
f0101d45:	57                   	push   %edi
f0101d46:	56                   	push   %esi
f0101d47:	e8 02 f5 ff ff       	call   f010124e <page_insert>
f0101d4c:	83 c4 10             	add    $0x10,%esp
f0101d4f:	85 c0                	test   %eax,%eax
f0101d51:	0f 85 f9 08 00 00    	jne    f0102650 <mem_init+0x1301>
	assert(pp1->pp_ref);
f0101d57:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101d5c:	0f 84 07 09 00 00    	je     f0102669 <mem_init+0x131a>
	assert(pp1->pp_link == NULL);
f0101d62:	83 3f 00             	cmpl   $0x0,(%edi)
f0101d65:	0f 85 17 09 00 00    	jne    f0102682 <mem_init+0x1333>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0101d6b:	83 ec 08             	sub    $0x8,%esp
f0101d6e:	68 00 10 00 00       	push   $0x1000
f0101d73:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101d79:	e8 83 f4 ff ff       	call   f0101201 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d7e:	8b 35 98 ee 2b f0    	mov    0xf02bee98,%esi
f0101d84:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d89:	89 f0                	mov    %esi,%eax
f0101d8b:	e8 bf ed ff ff       	call   f0100b4f <check_va2pa>
f0101d90:	83 c4 10             	add    $0x10,%esp
f0101d93:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d96:	0f 85 ff 08 00 00    	jne    f010269b <mem_init+0x134c>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101d9c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101da1:	89 f0                	mov    %esi,%eax
f0101da3:	e8 a7 ed ff ff       	call   f0100b4f <check_va2pa>
f0101da8:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101dab:	0f 85 03 09 00 00    	jne    f01026b4 <mem_init+0x1365>
	assert(pp1->pp_ref == 0);
f0101db1:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0101db6:	0f 85 11 09 00 00    	jne    f01026cd <mem_init+0x137e>
	assert(pp2->pp_ref == 0);
f0101dbc:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101dc1:	0f 85 1f 09 00 00    	jne    f01026e6 <mem_init+0x1397>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101dc7:	83 ec 0c             	sub    $0xc,%esp
f0101dca:	6a 00                	push   $0x0
f0101dcc:	e8 a9 f1 ff ff       	call   f0100f7a <page_alloc>
f0101dd1:	83 c4 10             	add    $0x10,%esp
f0101dd4:	39 c7                	cmp    %eax,%edi
f0101dd6:	0f 85 23 09 00 00    	jne    f01026ff <mem_init+0x13b0>
f0101ddc:	85 c0                	test   %eax,%eax
f0101dde:	0f 84 1b 09 00 00    	je     f01026ff <mem_init+0x13b0>

	// should be no free memory
	assert(!page_alloc(0));
f0101de4:	83 ec 0c             	sub    $0xc,%esp
f0101de7:	6a 00                	push   $0x0
f0101de9:	e8 8c f1 ff ff       	call   f0100f7a <page_alloc>
f0101dee:	83 c4 10             	add    $0x10,%esp
f0101df1:	85 c0                	test   %eax,%eax
f0101df3:	0f 85 1f 09 00 00    	jne    f0102718 <mem_init+0x13c9>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101df9:	8b 0d 98 ee 2b f0    	mov    0xf02bee98,%ecx
f0101dff:	8b 11                	mov    (%ecx),%edx
f0101e01:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e0a:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101e10:	c1 f8 03             	sar    $0x3,%eax
f0101e13:	c1 e0 0c             	shl    $0xc,%eax
f0101e16:	39 c2                	cmp    %eax,%edx
f0101e18:	0f 85 13 09 00 00    	jne    f0102731 <mem_init+0x13e2>
	kern_pgdir[0] = 0;
f0101e1e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101e24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e27:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e2c:	0f 85 18 09 00 00    	jne    f010274a <mem_init+0x13fb>
	pp0->pp_ref = 0;
f0101e32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e35:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101e3b:	83 ec 0c             	sub    $0xc,%esp
f0101e3e:	50                   	push   %eax
f0101e3f:	e8 af f1 ff ff       	call   f0100ff3 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101e44:	83 c4 0c             	add    $0xc,%esp
f0101e47:	6a 01                	push   $0x1
f0101e49:	68 00 10 40 00       	push   $0x401000
f0101e4e:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101e54:	e8 0a f2 ff ff       	call   f0101063 <pgdir_walk>
f0101e59:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101e5f:	8b 0d 98 ee 2b f0    	mov    0xf02bee98,%ecx
f0101e65:	8b 41 04             	mov    0x4(%ecx),%eax
f0101e68:	89 c6                	mov    %eax,%esi
f0101e6a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0101e70:	8b 15 94 ee 2b f0    	mov    0xf02bee94,%edx
f0101e76:	c1 e8 0c             	shr    $0xc,%eax
f0101e79:	83 c4 10             	add    $0x10,%esp
f0101e7c:	39 d0                	cmp    %edx,%eax
f0101e7e:	0f 83 df 08 00 00    	jae    f0102763 <mem_init+0x1414>
	assert(ptep == ptep1 + PTX(va));
f0101e84:	81 ee fc ff ff 0f    	sub    $0xffffffc,%esi
f0101e8a:	39 75 d0             	cmp    %esi,-0x30(%ebp)
f0101e8d:	0f 85 e5 08 00 00    	jne    f0102778 <mem_init+0x1429>
	kern_pgdir[PDX(va)] = 0;
f0101e93:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%ecx)
	pp0->pp_ref = 0;
f0101e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e9d:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101ea3:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101ea9:	c1 f8 03             	sar    $0x3,%eax
f0101eac:	89 c1                	mov    %eax,%ecx
f0101eae:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f0101eb1:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101eb6:	39 c2                	cmp    %eax,%edx
f0101eb8:	0f 86 d3 08 00 00    	jbe    f0102791 <mem_init+0x1442>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101ebe:	83 ec 04             	sub    $0x4,%esp
f0101ec1:	68 00 10 00 00       	push   $0x1000
f0101ec6:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101ecb:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0101ed1:	51                   	push   %ecx
f0101ed2:	e8 d7 38 00 00       	call   f01057ae <memset>
	page_free(pp0);
f0101ed7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
f0101eda:	89 34 24             	mov    %esi,(%esp)
f0101edd:	e8 11 f1 ff ff       	call   f0100ff3 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101ee2:	83 c4 0c             	add    $0xc,%esp
f0101ee5:	6a 01                	push   $0x1
f0101ee7:	6a 00                	push   $0x0
f0101ee9:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0101eef:	e8 6f f1 ff ff       	call   f0101063 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101ef4:	89 f0                	mov    %esi,%eax
f0101ef6:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0101efc:	c1 f8 03             	sar    $0x3,%eax
f0101eff:	89 c2                	mov    %eax,%edx
f0101f01:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101f04:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0101f09:	83 c4 10             	add    $0x10,%esp
f0101f0c:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0101f12:	0f 83 8b 08 00 00    	jae    f01027a3 <mem_init+0x1454>
	return (void *)(pa + KERNBASE);
f0101f18:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0101f1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101f21:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101f27:	f6 00 01             	testb  $0x1,(%eax)
f0101f2a:	0f 85 85 08 00 00    	jne    f01027b5 <mem_init+0x1466>
f0101f30:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f0101f33:	39 d0                	cmp    %edx,%eax
f0101f35:	75 f0                	jne    f0101f27 <mem_init+0xbd8>
	kern_pgdir[0] = 0;
f0101f37:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0101f3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101f42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f45:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101f4b:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101f4e:	89 0d 40 e2 2b f0    	mov    %ecx,0xf02be240

	// free the pages we took
	page_free(pp0);
f0101f54:	83 ec 0c             	sub    $0xc,%esp
f0101f57:	50                   	push   %eax
f0101f58:	e8 96 f0 ff ff       	call   f0100ff3 <page_free>
	page_free(pp1);
f0101f5d:	89 3c 24             	mov    %edi,(%esp)
f0101f60:	e8 8e f0 ff ff       	call   f0100ff3 <page_free>
	page_free(pp2);
f0101f65:	89 1c 24             	mov    %ebx,(%esp)
f0101f68:	e8 86 f0 ff ff       	call   f0100ff3 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0101f6d:	83 c4 08             	add    $0x8,%esp
f0101f70:	68 01 10 00 00       	push   $0x1001
f0101f75:	6a 00                	push   $0x0
f0101f77:	e8 62 f3 ff ff       	call   f01012de <mmio_map_region>
f0101f7c:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0101f7e:	83 c4 08             	add    $0x8,%esp
f0101f81:	68 00 10 00 00       	push   $0x1000
f0101f86:	6a 00                	push   $0x0
f0101f88:	e8 51 f3 ff ff       	call   f01012de <mmio_map_region>
f0101f8d:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0101f8f:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0101f95:	83 c4 10             	add    $0x10,%esp
f0101f98:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101f9e:	0f 86 2a 08 00 00    	jbe    f01027ce <mem_init+0x147f>
f0101fa4:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101fa9:	0f 87 1f 08 00 00    	ja     f01027ce <mem_init+0x147f>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0101faf:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0101fb5:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0101fbb:	0f 87 26 08 00 00    	ja     f01027e7 <mem_init+0x1498>
f0101fc1:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0101fc7:	0f 86 1a 08 00 00    	jbe    f01027e7 <mem_init+0x1498>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0101fcd:	89 da                	mov    %ebx,%edx
f0101fcf:	09 f2                	or     %esi,%edx
f0101fd1:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101fd7:	0f 85 23 08 00 00    	jne    f0102800 <mem_init+0x14b1>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0101fdd:	39 c6                	cmp    %eax,%esi
f0101fdf:	0f 82 34 08 00 00    	jb     f0102819 <mem_init+0x14ca>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0101fe5:	8b 3d 98 ee 2b f0    	mov    0xf02bee98,%edi
f0101feb:	89 da                	mov    %ebx,%edx
f0101fed:	89 f8                	mov    %edi,%eax
f0101fef:	e8 5b eb ff ff       	call   f0100b4f <check_va2pa>
f0101ff4:	85 c0                	test   %eax,%eax
f0101ff6:	0f 85 36 08 00 00    	jne    f0102832 <mem_init+0x14e3>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0101ffc:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102002:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102005:	89 c2                	mov    %eax,%edx
f0102007:	89 f8                	mov    %edi,%eax
f0102009:	e8 41 eb ff ff       	call   f0100b4f <check_va2pa>
f010200e:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102013:	0f 85 32 08 00 00    	jne    f010284b <mem_init+0x14fc>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102019:	89 f2                	mov    %esi,%edx
f010201b:	89 f8                	mov    %edi,%eax
f010201d:	e8 2d eb ff ff       	call   f0100b4f <check_va2pa>
f0102022:	85 c0                	test   %eax,%eax
f0102024:	0f 85 3a 08 00 00    	jne    f0102864 <mem_init+0x1515>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010202a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102030:	89 f8                	mov    %edi,%eax
f0102032:	e8 18 eb ff ff       	call   f0100b4f <check_va2pa>
f0102037:	83 f8 ff             	cmp    $0xffffffff,%eax
f010203a:	0f 85 3d 08 00 00    	jne    f010287d <mem_init+0x152e>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102040:	83 ec 04             	sub    $0x4,%esp
f0102043:	6a 00                	push   $0x0
f0102045:	53                   	push   %ebx
f0102046:	57                   	push   %edi
f0102047:	e8 17 f0 ff ff       	call   f0101063 <pgdir_walk>
f010204c:	83 c4 10             	add    $0x10,%esp
f010204f:	f6 00 1a             	testb  $0x1a,(%eax)
f0102052:	0f 84 3e 08 00 00    	je     f0102896 <mem_init+0x1547>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102058:	83 ec 04             	sub    $0x4,%esp
f010205b:	6a 00                	push   $0x0
f010205d:	53                   	push   %ebx
f010205e:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0102064:	e8 fa ef ff ff       	call   f0101063 <pgdir_walk>
f0102069:	8b 00                	mov    (%eax),%eax
f010206b:	83 c4 10             	add    $0x10,%esp
f010206e:	83 e0 04             	and    $0x4,%eax
f0102071:	89 c7                	mov    %eax,%edi
f0102073:	0f 85 36 08 00 00    	jne    f01028af <mem_init+0x1560>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102079:	83 ec 04             	sub    $0x4,%esp
f010207c:	6a 00                	push   $0x0
f010207e:	53                   	push   %ebx
f010207f:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0102085:	e8 d9 ef ff ff       	call   f0101063 <pgdir_walk>
f010208a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102090:	83 c4 0c             	add    $0xc,%esp
f0102093:	6a 00                	push   $0x0
f0102095:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102098:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f010209e:	e8 c0 ef ff ff       	call   f0101063 <pgdir_walk>
f01020a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01020a9:	83 c4 0c             	add    $0xc,%esp
f01020ac:	6a 00                	push   $0x0
f01020ae:	56                   	push   %esi
f01020af:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f01020b5:	e8 a9 ef ff ff       	call   f0101063 <pgdir_walk>
f01020ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01020c0:	c7 04 24 58 72 10 f0 	movl   $0xf0107258,(%esp)
f01020c7:	e8 9b 18 00 00       	call   f0103967 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01020cc:	a1 9c ee 2b f0       	mov    0xf02bee9c,%eax
	if ((uint32_t)kva < KERNBASE)
f01020d1:	83 c4 10             	add    $0x10,%esp
f01020d4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020d9:	0f 86 e9 07 00 00    	jbe    f01028c8 <mem_init+0x1579>
f01020df:	83 ec 08             	sub    $0x8,%esp
f01020e2:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01020e4:	05 00 00 00 10       	add    $0x10000000,%eax
f01020e9:	50                   	push   %eax
f01020ea:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01020ef:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01020f4:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f01020f9:	e8 f6 ef ff ff       	call   f01010f4 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f01020fe:	a1 48 e2 2b f0       	mov    0xf02be248,%eax
	if ((uint32_t)kva < KERNBASE)
f0102103:	83 c4 10             	add    $0x10,%esp
f0102106:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010210b:	0f 86 cc 07 00 00    	jbe    f01028dd <mem_init+0x158e>
f0102111:	83 ec 08             	sub    $0x8,%esp
f0102114:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102116:	05 00 00 00 10       	add    $0x10000000,%eax
f010211b:	50                   	push   %eax
f010211c:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102121:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102126:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f010212b:	e8 c4 ef ff ff       	call   f01010f4 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102130:	83 c4 10             	add    $0x10,%esp
f0102133:	b8 00 b0 11 f0       	mov    $0xf011b000,%eax
f0102138:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010213d:	0f 86 af 07 00 00    	jbe    f01028f2 <mem_init+0x15a3>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f0102143:	83 ec 08             	sub    $0x8,%esp
f0102146:	6a 02                	push   $0x2
f0102148:	68 00 b0 11 00       	push   $0x11b000
f010214d:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102152:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102157:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f010215c:	e8 93 ef ff ff       	call   f01010f4 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f0102161:	83 c4 08             	add    $0x8,%esp
f0102164:	6a 02                	push   $0x2
f0102166:	6a 00                	push   $0x0
f0102168:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010216d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102172:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f0102177:	e8 78 ef ff ff       	call   f01010f4 <boot_map_region>
f010217c:	c7 45 d0 00 00 2c f0 	movl   $0xf02c0000,-0x30(%ebp)
f0102183:	83 c4 10             	add    $0x10,%esp
f0102186:	bb 00 00 2c f0       	mov    $0xf02c0000,%ebx
f010218b:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102190:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102196:	0f 86 6b 07 00 00    	jbe    f0102907 <mem_init+0x15b8>
		boot_map_region(kern_pgdir, 
f010219c:	83 ec 08             	sub    $0x8,%esp
f010219f:	6a 03                	push   $0x3
f01021a1:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01021a7:	50                   	push   %eax
f01021a8:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01021ad:	89 f2                	mov    %esi,%edx
f01021af:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f01021b4:	e8 3b ef ff ff       	call   f01010f4 <boot_map_region>
f01021b9:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01021bf:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for(i = 0; i < NCPU; ++i){
f01021c5:	83 c4 10             	add    $0x10,%esp
f01021c8:	81 fb 00 00 30 f0    	cmp    $0xf0300000,%ebx
f01021ce:	75 c0                	jne    f0102190 <mem_init+0xe41>
	pgdir = kern_pgdir;
f01021d0:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
f01021d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01021d8:	a1 94 ee 2b f0       	mov    0xf02bee94,%eax
f01021dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01021e0:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01021e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01021ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01021ef:	8b 35 9c ee 2b f0    	mov    0xf02bee9c,%esi
f01021f5:	89 75 c8             	mov    %esi,-0x38(%ebp)
	return (physaddr_t)kva - KERNBASE;
f01021f8:	8d 86 00 00 00 10    	lea    0x10000000(%esi),%eax
f01021fe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102201:	89 fb                	mov    %edi,%ebx
f0102203:	e9 2f 07 00 00       	jmp    f0102937 <mem_init+0x15e8>
	assert(nfree == 0);
f0102208:	68 6f 71 10 f0       	push   $0xf010716f
f010220d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102212:	68 52 03 00 00       	push   $0x352
f0102217:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010221c:	e8 1f de ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102221:	68 7d 70 10 f0       	push   $0xf010707d
f0102226:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010222b:	68 b8 03 00 00       	push   $0x3b8
f0102230:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102235:	e8 06 de ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f010223a:	68 93 70 10 f0       	push   $0xf0107093
f010223f:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102244:	68 b9 03 00 00       	push   $0x3b9
f0102249:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010224e:	e8 ed dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102253:	68 a9 70 10 f0       	push   $0xf01070a9
f0102258:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010225d:	68 ba 03 00 00       	push   $0x3ba
f0102262:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102267:	e8 d4 dd ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f010226c:	68 bf 70 10 f0       	push   $0xf01070bf
f0102271:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102276:	68 bd 03 00 00       	push   $0x3bd
f010227b:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102280:	e8 bb dd ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102285:	68 7c 74 10 f0       	push   $0xf010747c
f010228a:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010228f:	68 be 03 00 00       	push   $0x3be
f0102294:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102299:	e8 a2 dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010229e:	68 28 71 10 f0       	push   $0xf0107128
f01022a3:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01022a8:	68 c5 03 00 00       	push   $0x3c5
f01022ad:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01022b2:	e8 89 dd ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01022b7:	68 bc 74 10 f0       	push   $0xf01074bc
f01022bc:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01022c1:	68 c8 03 00 00       	push   $0x3c8
f01022c6:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01022cb:	e8 70 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01022d0:	68 f4 74 10 f0       	push   $0xf01074f4
f01022d5:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01022da:	68 cb 03 00 00       	push   $0x3cb
f01022df:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01022e4:	e8 57 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01022e9:	68 24 75 10 f0       	push   $0xf0107524
f01022ee:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01022f3:	68 cf 03 00 00       	push   $0x3cf
f01022f8:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01022fd:	e8 3e dd ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102302:	68 54 75 10 f0       	push   $0xf0107554
f0102307:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010230c:	68 d0 03 00 00       	push   $0x3d0
f0102311:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102316:	e8 25 dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010231b:	68 7c 75 10 f0       	push   $0xf010757c
f0102320:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102325:	68 d1 03 00 00       	push   $0x3d1
f010232a:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010232f:	e8 0c dd ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102334:	68 7a 71 10 f0       	push   $0xf010717a
f0102339:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010233e:	68 d2 03 00 00       	push   $0x3d2
f0102343:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102348:	e8 f3 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010234d:	68 8b 71 10 f0       	push   $0xf010718b
f0102352:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102357:	68 d3 03 00 00       	push   $0x3d3
f010235c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102361:	e8 da dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102366:	68 ac 75 10 f0       	push   $0xf01075ac
f010236b:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102370:	68 d6 03 00 00       	push   $0x3d6
f0102375:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010237a:	e8 c1 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010237f:	68 e8 75 10 f0       	push   $0xf01075e8
f0102384:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102389:	68 d7 03 00 00       	push   $0x3d7
f010238e:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102393:	e8 a8 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102398:	68 9c 71 10 f0       	push   $0xf010719c
f010239d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01023a2:	68 d8 03 00 00       	push   $0x3d8
f01023a7:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01023ac:	e8 8f dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01023b1:	68 28 71 10 f0       	push   $0xf0107128
f01023b6:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01023bb:	68 db 03 00 00       	push   $0x3db
f01023c0:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01023c5:	e8 76 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01023ca:	68 ac 75 10 f0       	push   $0xf01075ac
f01023cf:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01023d4:	68 de 03 00 00       	push   $0x3de
f01023d9:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01023de:	e8 5d dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01023e3:	68 e8 75 10 f0       	push   $0xf01075e8
f01023e8:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01023ed:	68 df 03 00 00       	push   $0x3df
f01023f2:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01023f7:	e8 44 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01023fc:	68 9c 71 10 f0       	push   $0xf010719c
f0102401:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102406:	68 e0 03 00 00       	push   $0x3e0
f010240b:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102410:	e8 2b dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102415:	68 28 71 10 f0       	push   $0xf0107128
f010241a:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010241f:	68 e4 03 00 00       	push   $0x3e4
f0102424:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102429:	e8 12 dc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010242e:	52                   	push   %edx
f010242f:	68 24 6a 10 f0       	push   $0xf0106a24
f0102434:	68 e7 03 00 00       	push   $0x3e7
f0102439:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010243e:	e8 fd db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102443:	68 18 76 10 f0       	push   $0xf0107618
f0102448:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010244d:	68 e8 03 00 00       	push   $0x3e8
f0102452:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102457:	e8 e4 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010245c:	68 58 76 10 f0       	push   $0xf0107658
f0102461:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102466:	68 eb 03 00 00       	push   $0x3eb
f010246b:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102470:	e8 cb db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102475:	68 e8 75 10 f0       	push   $0xf01075e8
f010247a:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010247f:	68 ec 03 00 00       	push   $0x3ec
f0102484:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102489:	e8 b2 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f010248e:	68 9c 71 10 f0       	push   $0xf010719c
f0102493:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102498:	68 ed 03 00 00       	push   $0x3ed
f010249d:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01024a2:	e8 99 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01024a7:	68 98 76 10 f0       	push   $0xf0107698
f01024ac:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01024b1:	68 ee 03 00 00       	push   $0x3ee
f01024b6:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01024bb:	e8 80 db ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01024c0:	68 ad 71 10 f0       	push   $0xf01071ad
f01024c5:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01024ca:	68 ef 03 00 00       	push   $0x3ef
f01024cf:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01024d4:	e8 67 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01024d9:	68 ac 75 10 f0       	push   $0xf01075ac
f01024de:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01024e3:	68 f2 03 00 00       	push   $0x3f2
f01024e8:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01024ed:	e8 4e db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01024f2:	68 cc 76 10 f0       	push   $0xf01076cc
f01024f7:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01024fc:	68 f3 03 00 00       	push   $0x3f3
f0102501:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102506:	e8 35 db ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010250b:	68 00 77 10 f0       	push   $0xf0107700
f0102510:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102515:	68 f4 03 00 00       	push   $0x3f4
f010251a:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010251f:	e8 1c db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102524:	68 38 77 10 f0       	push   $0xf0107738
f0102529:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010252e:	68 f7 03 00 00       	push   $0x3f7
f0102533:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102538:	e8 03 db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010253d:	68 70 77 10 f0       	push   $0xf0107770
f0102542:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102547:	68 fa 03 00 00       	push   $0x3fa
f010254c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102551:	e8 ea da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102556:	68 00 77 10 f0       	push   $0xf0107700
f010255b:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102560:	68 fb 03 00 00       	push   $0x3fb
f0102565:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010256a:	e8 d1 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010256f:	68 ac 77 10 f0       	push   $0xf01077ac
f0102574:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102579:	68 fe 03 00 00       	push   $0x3fe
f010257e:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102583:	e8 b8 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102588:	68 d8 77 10 f0       	push   $0xf01077d8
f010258d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102592:	68 ff 03 00 00       	push   $0x3ff
f0102597:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010259c:	e8 9f da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f01025a1:	68 c3 71 10 f0       	push   $0xf01071c3
f01025a6:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01025ab:	68 01 04 00 00       	push   $0x401
f01025b0:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01025b5:	e8 86 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01025ba:	68 d4 71 10 f0       	push   $0xf01071d4
f01025bf:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01025c4:	68 02 04 00 00       	push   $0x402
f01025c9:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01025ce:	e8 6d da ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f01025d3:	68 08 78 10 f0       	push   $0xf0107808
f01025d8:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01025dd:	68 05 04 00 00       	push   $0x405
f01025e2:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01025e7:	e8 54 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01025ec:	68 2c 78 10 f0       	push   $0xf010782c
f01025f1:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01025f6:	68 09 04 00 00       	push   $0x409
f01025fb:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102600:	e8 3b da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102605:	68 d8 77 10 f0       	push   $0xf01077d8
f010260a:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010260f:	68 0a 04 00 00       	push   $0x40a
f0102614:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102619:	e8 22 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010261e:	68 7a 71 10 f0       	push   $0xf010717a
f0102623:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102628:	68 0b 04 00 00       	push   $0x40b
f010262d:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102632:	e8 09 da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102637:	68 d4 71 10 f0       	push   $0xf01071d4
f010263c:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102641:	68 0c 04 00 00       	push   $0x40c
f0102646:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010264b:	e8 f0 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102650:	68 50 78 10 f0       	push   $0xf0107850
f0102655:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010265a:	68 0f 04 00 00       	push   $0x40f
f010265f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102664:	e8 d7 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102669:	68 e5 71 10 f0       	push   $0xf01071e5
f010266e:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102673:	68 10 04 00 00       	push   $0x410
f0102678:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010267d:	e8 be d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f0102682:	68 f1 71 10 f0       	push   $0xf01071f1
f0102687:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010268c:	68 11 04 00 00       	push   $0x411
f0102691:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102696:	e8 a5 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010269b:	68 2c 78 10 f0       	push   $0xf010782c
f01026a0:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01026a5:	68 15 04 00 00       	push   $0x415
f01026aa:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01026af:	e8 8c d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01026b4:	68 88 78 10 f0       	push   $0xf0107888
f01026b9:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01026be:	68 16 04 00 00       	push   $0x416
f01026c3:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01026c8:	e8 73 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f01026cd:	68 06 72 10 f0       	push   $0xf0107206
f01026d2:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01026d7:	68 17 04 00 00       	push   $0x417
f01026dc:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01026e1:	e8 5a d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01026e6:	68 d4 71 10 f0       	push   $0xf01071d4
f01026eb:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01026f0:	68 18 04 00 00       	push   $0x418
f01026f5:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01026fa:	e8 41 d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f01026ff:	68 b0 78 10 f0       	push   $0xf01078b0
f0102704:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102709:	68 1b 04 00 00       	push   $0x41b
f010270e:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102713:	e8 28 d9 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102718:	68 28 71 10 f0       	push   $0xf0107128
f010271d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102722:	68 1e 04 00 00       	push   $0x41e
f0102727:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010272c:	e8 0f d9 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102731:	68 54 75 10 f0       	push   $0xf0107554
f0102736:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010273b:	68 21 04 00 00       	push   $0x421
f0102740:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102745:	e8 f6 d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f010274a:	68 8b 71 10 f0       	push   $0xf010718b
f010274f:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102754:	68 23 04 00 00       	push   $0x423
f0102759:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010275e:	e8 dd d8 ff ff       	call   f0100040 <_panic>
f0102763:	56                   	push   %esi
f0102764:	68 24 6a 10 f0       	push   $0xf0106a24
f0102769:	68 2a 04 00 00       	push   $0x42a
f010276e:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102773:	e8 c8 d8 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102778:	68 17 72 10 f0       	push   $0xf0107217
f010277d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102782:	68 2b 04 00 00       	push   $0x42b
f0102787:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010278c:	e8 af d8 ff ff       	call   f0100040 <_panic>
f0102791:	51                   	push   %ecx
f0102792:	68 24 6a 10 f0       	push   $0xf0106a24
f0102797:	6a 58                	push   $0x58
f0102799:	68 9b 6f 10 f0       	push   $0xf0106f9b
f010279e:	e8 9d d8 ff ff       	call   f0100040 <_panic>
f01027a3:	52                   	push   %edx
f01027a4:	68 24 6a 10 f0       	push   $0xf0106a24
f01027a9:	6a 58                	push   $0x58
f01027ab:	68 9b 6f 10 f0       	push   $0xf0106f9b
f01027b0:	e8 8b d8 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01027b5:	68 2f 72 10 f0       	push   $0xf010722f
f01027ba:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01027bf:	68 35 04 00 00       	push   $0x435
f01027c4:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01027c9:	e8 72 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f01027ce:	68 d4 78 10 f0       	push   $0xf01078d4
f01027d3:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01027d8:	68 45 04 00 00       	push   $0x445
f01027dd:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01027e2:	e8 59 d8 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f01027e7:	68 fc 78 10 f0       	push   $0xf01078fc
f01027ec:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01027f1:	68 46 04 00 00       	push   $0x446
f01027f6:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01027fb:	e8 40 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102800:	68 24 79 10 f0       	push   $0xf0107924
f0102805:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010280a:	68 48 04 00 00       	push   $0x448
f010280f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102814:	e8 27 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102819:	68 46 72 10 f0       	push   $0xf0107246
f010281e:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102823:	68 4a 04 00 00       	push   $0x44a
f0102828:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010282d:	e8 0e d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102832:	68 4c 79 10 f0       	push   $0xf010794c
f0102837:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010283c:	68 4c 04 00 00       	push   $0x44c
f0102841:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102846:	e8 f5 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010284b:	68 70 79 10 f0       	push   $0xf0107970
f0102850:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102855:	68 4d 04 00 00       	push   $0x44d
f010285a:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010285f:	e8 dc d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102864:	68 a0 79 10 f0       	push   $0xf01079a0
f0102869:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010286e:	68 4e 04 00 00       	push   $0x44e
f0102873:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102878:	e8 c3 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010287d:	68 c4 79 10 f0       	push   $0xf01079c4
f0102882:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102887:	68 4f 04 00 00       	push   $0x44f
f010288c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102891:	e8 aa d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102896:	68 f0 79 10 f0       	push   $0xf01079f0
f010289b:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01028a0:	68 51 04 00 00       	push   $0x451
f01028a5:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01028aa:	e8 91 d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f01028af:	68 34 7a 10 f0       	push   $0xf0107a34
f01028b4:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01028b9:	68 52 04 00 00       	push   $0x452
f01028be:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01028c3:	e8 78 d7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01028c8:	50                   	push   %eax
f01028c9:	68 48 6a 10 f0       	push   $0xf0106a48
f01028ce:	68 d0 00 00 00       	push   $0xd0
f01028d3:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01028d8:	e8 63 d7 ff ff       	call   f0100040 <_panic>
f01028dd:	50                   	push   %eax
f01028de:	68 48 6a 10 f0       	push   $0xf0106a48
f01028e3:	68 d8 00 00 00       	push   $0xd8
f01028e8:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01028ed:	e8 4e d7 ff ff       	call   f0100040 <_panic>
f01028f2:	50                   	push   %eax
f01028f3:	68 48 6a 10 f0       	push   $0xf0106a48
f01028f8:	68 e5 00 00 00       	push   $0xe5
f01028fd:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102902:	e8 39 d7 ff ff       	call   f0100040 <_panic>
f0102907:	53                   	push   %ebx
f0102908:	68 48 6a 10 f0       	push   $0xf0106a48
f010290d:	68 28 01 00 00       	push   $0x128
f0102912:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102917:	e8 24 d7 ff ff       	call   f0100040 <_panic>
f010291c:	56                   	push   %esi
f010291d:	68 48 6a 10 f0       	push   $0xf0106a48
f0102922:	68 6a 03 00 00       	push   $0x36a
f0102927:	68 8f 6f 10 f0       	push   $0xf0106f8f
f010292c:	e8 0f d7 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < n; i += PGSIZE)
f0102931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102937:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f010293a:	76 3a                	jbe    f0102976 <mem_init+0x1627>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010293c:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102945:	e8 05 e2 ff ff       	call   f0100b4f <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f010294a:	81 7d c8 ff ff ff ef 	cmpl   $0xefffffff,-0x38(%ebp)
f0102951:	76 c9                	jbe    f010291c <mem_init+0x15cd>
f0102953:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102956:	8d 14 0b             	lea    (%ebx,%ecx,1),%edx
f0102959:	39 d0                	cmp    %edx,%eax
f010295b:	74 d4                	je     f0102931 <mem_init+0x15e2>
f010295d:	68 68 7a 10 f0       	push   $0xf0107a68
f0102962:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102967:	68 6a 03 00 00       	push   $0x36a
f010296c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102971:	e8 ca d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102976:	a1 48 e2 2b f0       	mov    0xf02be248,%eax
f010297b:	89 45 c8             	mov    %eax,-0x38(%ebp)
f010297e:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102981:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102986:	8d b0 00 00 40 21    	lea    0x21400000(%eax),%esi
f010298c:	89 da                	mov    %ebx,%edx
f010298e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102991:	e8 b9 e1 ff ff       	call   f0100b4f <check_va2pa>
f0102996:	81 7d cc ff ff ff ef 	cmpl   $0xefffffff,-0x34(%ebp)
f010299d:	76 3b                	jbe    f01029da <mem_init+0x168b>
f010299f:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f01029a2:	39 d0                	cmp    %edx,%eax
f01029a4:	75 4b                	jne    f01029f1 <mem_init+0x16a2>
f01029a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f01029ac:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f01029b2:	75 d8                	jne    f010298c <mem_init+0x163d>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029b4:	8b 75 c0             	mov    -0x40(%ebp),%esi
f01029b7:	c1 e6 0c             	shl    $0xc,%esi
f01029ba:	89 fb                	mov    %edi,%ebx
f01029bc:	39 f3                	cmp    %esi,%ebx
f01029be:	73 63                	jae    f0102a23 <mem_init+0x16d4>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01029c0:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f01029c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01029c9:	e8 81 e1 ff ff       	call   f0100b4f <check_va2pa>
f01029ce:	39 c3                	cmp    %eax,%ebx
f01029d0:	75 38                	jne    f0102a0a <mem_init+0x16bb>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029d8:	eb e2                	jmp    f01029bc <mem_init+0x166d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01029da:	ff 75 c8             	pushl  -0x38(%ebp)
f01029dd:	68 48 6a 10 f0       	push   $0xf0106a48
f01029e2:	68 6f 03 00 00       	push   $0x36f
f01029e7:	68 8f 6f 10 f0       	push   $0xf0106f8f
f01029ec:	e8 4f d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01029f1:	68 9c 7a 10 f0       	push   $0xf0107a9c
f01029f6:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01029fb:	68 6f 03 00 00       	push   $0x36f
f0102a00:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102a05:	e8 36 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102a0a:	68 d0 7a 10 f0       	push   $0xf0107ad0
f0102a0f:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102a14:	68 73 03 00 00       	push   $0x373
f0102a19:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102a1e:	e8 1d d6 ff ff       	call   f0100040 <_panic>
f0102a23:	c7 45 cc 00 00 2d 00 	movl   $0x2d0000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102a2a:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f0102a2f:	89 7d c0             	mov    %edi,-0x40(%ebp)
f0102a32:	8d bb 00 80 ff ff    	lea    -0x8000(%ebx),%edi
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102a38:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102a3b:	89 45 bc             	mov    %eax,-0x44(%ebp)
f0102a3e:	89 de                	mov    %ebx,%esi
f0102a40:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102a43:	05 00 80 ff 0f       	add    $0xfff8000,%eax
f0102a48:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a4b:	8d 83 00 80 00 00    	lea    0x8000(%ebx),%eax
f0102a51:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102a54:	89 f2                	mov    %esi,%edx
f0102a56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a59:	e8 f1 e0 ff ff       	call   f0100b4f <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102a5e:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102a65:	76 58                	jbe    f0102abf <mem_init+0x1770>
f0102a67:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0102a6a:	8d 14 31             	lea    (%ecx,%esi,1),%edx
f0102a6d:	39 d0                	cmp    %edx,%eax
f0102a6f:	75 65                	jne    f0102ad6 <mem_init+0x1787>
f0102a71:	81 c6 00 10 00 00    	add    $0x1000,%esi
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a77:	3b 75 c4             	cmp    -0x3c(%ebp),%esi
f0102a7a:	75 d8                	jne    f0102a54 <mem_init+0x1705>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102a7c:	89 fa                	mov    %edi,%edx
f0102a7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102a81:	e8 c9 e0 ff ff       	call   f0100b4f <check_va2pa>
f0102a86:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a89:	75 64                	jne    f0102aef <mem_init+0x17a0>
f0102a8b:	81 c7 00 10 00 00    	add    $0x1000,%edi
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102a91:	39 df                	cmp    %ebx,%edi
f0102a93:	75 e7                	jne    f0102a7c <mem_init+0x172d>
f0102a95:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0102a9b:	81 45 d0 00 80 00 00 	addl   $0x8000,-0x30(%ebp)
f0102aa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102aa5:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102aac:	3d 00 00 30 f0       	cmp    $0xf0300000,%eax
f0102ab1:	0f 85 7b ff ff ff    	jne    f0102a32 <mem_init+0x16e3>
f0102ab7:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0102aba:	e9 84 00 00 00       	jmp    f0102b43 <mem_init+0x17f4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102abf:	ff 75 bc             	pushl  -0x44(%ebp)
f0102ac2:	68 48 6a 10 f0       	push   $0xf0106a48
f0102ac7:	68 7b 03 00 00       	push   $0x37b
f0102acc:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102ad1:	e8 6a d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102ad6:	68 f8 7a 10 f0       	push   $0xf0107af8
f0102adb:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102ae0:	68 7a 03 00 00       	push   $0x37a
f0102ae5:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102aea:	e8 51 d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102aef:	68 40 7b 10 f0       	push   $0xf0107b40
f0102af4:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102af9:	68 7d 03 00 00       	push   $0x37d
f0102afe:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102b03:	e8 38 d5 ff ff       	call   f0100040 <_panic>
			assert(pgdir[i] & PTE_P);
f0102b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b0b:	f6 04 b8 01          	testb  $0x1,(%eax,%edi,4)
f0102b0f:	75 4e                	jne    f0102b5f <mem_init+0x1810>
f0102b11:	68 71 72 10 f0       	push   $0xf0107271
f0102b16:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102b1b:	68 88 03 00 00       	push   $0x388
f0102b20:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102b25:	e8 16 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b2d:	8b 04 b8             	mov    (%eax,%edi,4),%eax
f0102b30:	a8 01                	test   $0x1,%al
f0102b32:	74 30                	je     f0102b64 <mem_init+0x1815>
				assert(pgdir[i] & PTE_W);
f0102b34:	a8 02                	test   $0x2,%al
f0102b36:	74 45                	je     f0102b7d <mem_init+0x182e>
	for (i = 0; i < NPDENTRIES; i++) {
f0102b38:	83 c7 01             	add    $0x1,%edi
f0102b3b:	81 ff 00 04 00 00    	cmp    $0x400,%edi
f0102b41:	74 6c                	je     f0102baf <mem_init+0x1860>
		switch (i) {
f0102b43:	8d 87 45 fc ff ff    	lea    -0x3bb(%edi),%eax
f0102b49:	83 f8 04             	cmp    $0x4,%eax
f0102b4c:	76 ba                	jbe    f0102b08 <mem_init+0x17b9>
			if (i >= PDX(KERNBASE)) {
f0102b4e:	81 ff bf 03 00 00    	cmp    $0x3bf,%edi
f0102b54:	77 d4                	ja     f0102b2a <mem_init+0x17db>
				assert(pgdir[i] == 0);
f0102b56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b59:	83 3c b8 00          	cmpl   $0x0,(%eax,%edi,4)
f0102b5d:	75 37                	jne    f0102b96 <mem_init+0x1847>
	for (i = 0; i < NPDENTRIES; i++) {
f0102b5f:	83 c7 01             	add    $0x1,%edi
f0102b62:	eb df                	jmp    f0102b43 <mem_init+0x17f4>
				assert(pgdir[i] & PTE_P);
f0102b64:	68 71 72 10 f0       	push   $0xf0107271
f0102b69:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102b6e:	68 8c 03 00 00       	push   $0x38c
f0102b73:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102b78:	e8 c3 d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0102b7d:	68 82 72 10 f0       	push   $0xf0107282
f0102b82:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102b87:	68 8d 03 00 00       	push   $0x38d
f0102b8c:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102b91:	e8 aa d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102b96:	68 93 72 10 f0       	push   $0xf0107293
f0102b9b:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102ba0:	68 8f 03 00 00       	push   $0x38f
f0102ba5:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102baa:	e8 91 d4 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102baf:	83 ec 0c             	sub    $0xc,%esp
f0102bb2:	68 64 7b 10 f0       	push   $0xf0107b64
f0102bb7:	e8 ab 0d 00 00       	call   f0103967 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102bbc:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f0102bc1:	83 c4 10             	add    $0x10,%esp
f0102bc4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102bc9:	0f 86 03 02 00 00    	jbe    f0102dd2 <mem_init+0x1a83>
	return (physaddr_t)kva - KERNBASE;
f0102bcf:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102bd4:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102bd7:	b8 00 00 00 00       	mov    $0x0,%eax
f0102bdc:	e8 d1 df ff ff       	call   f0100bb2 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102be1:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102be4:	83 e0 f3             	and    $0xfffffff3,%eax
f0102be7:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102bec:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102bef:	83 ec 0c             	sub    $0xc,%esp
f0102bf2:	6a 00                	push   $0x0
f0102bf4:	e8 81 e3 ff ff       	call   f0100f7a <page_alloc>
f0102bf9:	89 c6                	mov    %eax,%esi
f0102bfb:	83 c4 10             	add    $0x10,%esp
f0102bfe:	85 c0                	test   %eax,%eax
f0102c00:	0f 84 e1 01 00 00    	je     f0102de7 <mem_init+0x1a98>
	assert((pp1 = page_alloc(0)));
f0102c06:	83 ec 0c             	sub    $0xc,%esp
f0102c09:	6a 00                	push   $0x0
f0102c0b:	e8 6a e3 ff ff       	call   f0100f7a <page_alloc>
f0102c10:	89 c7                	mov    %eax,%edi
f0102c12:	83 c4 10             	add    $0x10,%esp
f0102c15:	85 c0                	test   %eax,%eax
f0102c17:	0f 84 e3 01 00 00    	je     f0102e00 <mem_init+0x1ab1>
	assert((pp2 = page_alloc(0)));
f0102c1d:	83 ec 0c             	sub    $0xc,%esp
f0102c20:	6a 00                	push   $0x0
f0102c22:	e8 53 e3 ff ff       	call   f0100f7a <page_alloc>
f0102c27:	89 c3                	mov    %eax,%ebx
f0102c29:	83 c4 10             	add    $0x10,%esp
f0102c2c:	85 c0                	test   %eax,%eax
f0102c2e:	0f 84 e5 01 00 00    	je     f0102e19 <mem_init+0x1aca>
	page_free(pp0);
f0102c34:	83 ec 0c             	sub    $0xc,%esp
f0102c37:	56                   	push   %esi
f0102c38:	e8 b6 e3 ff ff       	call   f0100ff3 <page_free>
	return (pp - pages) << PGSHIFT;
f0102c3d:	89 f8                	mov    %edi,%eax
f0102c3f:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0102c45:	c1 f8 03             	sar    $0x3,%eax
f0102c48:	89 c2                	mov    %eax,%edx
f0102c4a:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c4d:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c52:	83 c4 10             	add    $0x10,%esp
f0102c55:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0102c5b:	0f 83 d1 01 00 00    	jae    f0102e32 <mem_init+0x1ae3>
	memset(page2kva(pp1), 1, PGSIZE);
f0102c61:	83 ec 04             	sub    $0x4,%esp
f0102c64:	68 00 10 00 00       	push   $0x1000
f0102c69:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102c6b:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102c71:	52                   	push   %edx
f0102c72:	e8 37 2b 00 00       	call   f01057ae <memset>
	return (pp - pages) << PGSHIFT;
f0102c77:	89 d8                	mov    %ebx,%eax
f0102c79:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0102c7f:	c1 f8 03             	sar    $0x3,%eax
f0102c82:	89 c2                	mov    %eax,%edx
f0102c84:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102c87:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102c8c:	83 c4 10             	add    $0x10,%esp
f0102c8f:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0102c95:	0f 83 a9 01 00 00    	jae    f0102e44 <mem_init+0x1af5>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c9b:	83 ec 04             	sub    $0x4,%esp
f0102c9e:	68 00 10 00 00       	push   $0x1000
f0102ca3:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102ca5:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0102cab:	52                   	push   %edx
f0102cac:	e8 fd 2a 00 00       	call   f01057ae <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102cb1:	6a 02                	push   $0x2
f0102cb3:	68 00 10 00 00       	push   $0x1000
f0102cb8:	57                   	push   %edi
f0102cb9:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0102cbf:	e8 8a e5 ff ff       	call   f010124e <page_insert>
	assert(pp1->pp_ref == 1);
f0102cc4:	83 c4 20             	add    $0x20,%esp
f0102cc7:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102ccc:	0f 85 84 01 00 00    	jne    f0102e56 <mem_init+0x1b07>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102cd2:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102cd9:	01 01 01 
f0102cdc:	0f 85 8d 01 00 00    	jne    f0102e6f <mem_init+0x1b20>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0102ce2:	6a 02                	push   $0x2
f0102ce4:	68 00 10 00 00       	push   $0x1000
f0102ce9:	53                   	push   %ebx
f0102cea:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0102cf0:	e8 59 e5 ff ff       	call   f010124e <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102cf5:	83 c4 10             	add    $0x10,%esp
f0102cf8:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102cff:	02 02 02 
f0102d02:	0f 85 80 01 00 00    	jne    f0102e88 <mem_init+0x1b39>
	assert(pp2->pp_ref == 1);
f0102d08:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102d0d:	0f 85 8e 01 00 00    	jne    f0102ea1 <mem_init+0x1b52>
	assert(pp1->pp_ref == 0);
f0102d13:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102d18:	0f 85 9c 01 00 00    	jne    f0102eba <mem_init+0x1b6b>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102d1e:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102d25:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102d28:	89 d8                	mov    %ebx,%eax
f0102d2a:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0102d30:	c1 f8 03             	sar    $0x3,%eax
f0102d33:	89 c2                	mov    %eax,%edx
f0102d35:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0102d38:	25 ff ff 0f 00       	and    $0xfffff,%eax
f0102d3d:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0102d43:	0f 83 8a 01 00 00    	jae    f0102ed3 <mem_init+0x1b84>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102d49:	81 ba 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%edx)
f0102d50:	03 03 03 
f0102d53:	0f 85 8c 01 00 00    	jne    f0102ee5 <mem_init+0x1b96>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102d59:	83 ec 08             	sub    $0x8,%esp
f0102d5c:	68 00 10 00 00       	push   $0x1000
f0102d61:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f0102d67:	e8 95 e4 ff ff       	call   f0101201 <page_remove>
	assert(pp2->pp_ref == 0);
f0102d6c:	83 c4 10             	add    $0x10,%esp
f0102d6f:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102d74:	0f 85 84 01 00 00    	jne    f0102efe <mem_init+0x1baf>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d7a:	8b 0d 98 ee 2b f0    	mov    0xf02bee98,%ecx
f0102d80:	8b 11                	mov    (%ecx),%edx
f0102d82:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102d88:	89 f0                	mov    %esi,%eax
f0102d8a:	2b 05 9c ee 2b f0    	sub    0xf02bee9c,%eax
f0102d90:	c1 f8 03             	sar    $0x3,%eax
f0102d93:	c1 e0 0c             	shl    $0xc,%eax
f0102d96:	39 c2                	cmp    %eax,%edx
f0102d98:	0f 85 79 01 00 00    	jne    f0102f17 <mem_init+0x1bc8>
	kern_pgdir[0] = 0;
f0102d9e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102da4:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102da9:	0f 85 81 01 00 00    	jne    f0102f30 <mem_init+0x1be1>
	pp0->pp_ref = 0;
f0102daf:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// free the pages we took
	page_free(pp0);
f0102db5:	83 ec 0c             	sub    $0xc,%esp
f0102db8:	56                   	push   %esi
f0102db9:	e8 35 e2 ff ff       	call   f0100ff3 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102dbe:	c7 04 24 f8 7b 10 f0 	movl   $0xf0107bf8,(%esp)
f0102dc5:	e8 9d 0b 00 00       	call   f0103967 <cprintf>
}
f0102dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102dcd:	5b                   	pop    %ebx
f0102dce:	5e                   	pop    %esi
f0102dcf:	5f                   	pop    %edi
f0102dd0:	5d                   	pop    %ebp
f0102dd1:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102dd2:	50                   	push   %eax
f0102dd3:	68 48 6a 10 f0       	push   $0xf0106a48
f0102dd8:	68 fd 00 00 00       	push   $0xfd
f0102ddd:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102de2:	e8 59 d2 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102de7:	68 7d 70 10 f0       	push   $0xf010707d
f0102dec:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102df1:	68 67 04 00 00       	push   $0x467
f0102df6:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102dfb:	e8 40 d2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102e00:	68 93 70 10 f0       	push   $0xf0107093
f0102e05:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102e0a:	68 68 04 00 00       	push   $0x468
f0102e0f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102e14:	e8 27 d2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102e19:	68 a9 70 10 f0       	push   $0xf01070a9
f0102e1e:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102e23:	68 69 04 00 00       	push   $0x469
f0102e28:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102e2d:	e8 0e d2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102e32:	52                   	push   %edx
f0102e33:	68 24 6a 10 f0       	push   $0xf0106a24
f0102e38:	6a 58                	push   $0x58
f0102e3a:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0102e3f:	e8 fc d1 ff ff       	call   f0100040 <_panic>
f0102e44:	52                   	push   %edx
f0102e45:	68 24 6a 10 f0       	push   $0xf0106a24
f0102e4a:	6a 58                	push   $0x58
f0102e4c:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0102e51:	e8 ea d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102e56:	68 7a 71 10 f0       	push   $0xf010717a
f0102e5b:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102e60:	68 6e 04 00 00       	push   $0x46e
f0102e65:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102e6a:	e8 d1 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e6f:	68 84 7b 10 f0       	push   $0xf0107b84
f0102e74:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102e79:	68 6f 04 00 00       	push   $0x46f
f0102e7e:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102e83:	e8 b8 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e88:	68 a8 7b 10 f0       	push   $0xf0107ba8
f0102e8d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102e92:	68 71 04 00 00       	push   $0x471
f0102e97:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102e9c:	e8 9f d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102ea1:	68 9c 71 10 f0       	push   $0xf010719c
f0102ea6:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102eab:	68 72 04 00 00       	push   $0x472
f0102eb0:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102eb5:	e8 86 d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102eba:	68 06 72 10 f0       	push   $0xf0107206
f0102ebf:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102ec4:	68 73 04 00 00       	push   $0x473
f0102ec9:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102ece:	e8 6d d1 ff ff       	call   f0100040 <_panic>
f0102ed3:	52                   	push   %edx
f0102ed4:	68 24 6a 10 f0       	push   $0xf0106a24
f0102ed9:	6a 58                	push   $0x58
f0102edb:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0102ee0:	e8 5b d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102ee5:	68 cc 7b 10 f0       	push   $0xf0107bcc
f0102eea:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102eef:	68 75 04 00 00       	push   $0x475
f0102ef4:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102ef9:	e8 42 d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102efe:	68 d4 71 10 f0       	push   $0xf01071d4
f0102f03:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102f08:	68 77 04 00 00       	push   $0x477
f0102f0d:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102f12:	e8 29 d1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102f17:	68 54 75 10 f0       	push   $0xf0107554
f0102f1c:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102f21:	68 7a 04 00 00       	push   $0x47a
f0102f26:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102f2b:	e8 10 d1 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102f30:	68 8b 71 10 f0       	push   $0xf010718b
f0102f35:	68 b5 6f 10 f0       	push   $0xf0106fb5
f0102f3a:	68 7c 04 00 00       	push   $0x47c
f0102f3f:	68 8f 6f 10 f0       	push   $0xf0106f8f
f0102f44:	e8 f7 d0 ff ff       	call   f0100040 <_panic>

f0102f49 <user_mem_check>:
{
f0102f49:	f3 0f 1e fb          	endbr32 
f0102f4d:	55                   	push   %ebp
f0102f4e:	89 e5                	mov    %esp,%ebp
f0102f50:	57                   	push   %edi
f0102f51:	56                   	push   %esi
f0102f52:	53                   	push   %ebx
f0102f53:	83 ec 1c             	sub    $0x1c,%esp
f0102f56:	8b 75 14             	mov    0x14(%ebp),%esi
	start = ROUNDDOWN((char *)va, PGSIZE);
f0102f59:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102f5f:	89 c3                	mov    %eax,%ebx
f0102f61:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	end = ROUNDUP((char *)(va + len), PGSIZE);
f0102f67:	89 c7                	mov    %eax,%edi
f0102f69:	03 7d 10             	add    0x10(%ebp),%edi
f0102f6c:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0102f72:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for(; start < end; start += PGSIZE){
f0102f78:	eb 06                	jmp    f0102f80 <user_mem_check+0x37>
f0102f7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f80:	39 fb                	cmp    %edi,%ebx
f0102f82:	73 48                	jae    f0102fcc <user_mem_check+0x83>
		cur = pgdir_walk(env->env_pgdir, start, 0);
f0102f84:	83 ec 04             	sub    $0x4,%esp
f0102f87:	6a 00                	push   $0x0
f0102f89:	53                   	push   %ebx
f0102f8a:	8b 45 08             	mov    0x8(%ebp),%eax
f0102f8d:	ff 70 60             	pushl  0x60(%eax)
f0102f90:	e8 ce e0 ff ff       	call   f0101063 <pgdir_walk>
f0102f95:	89 da                	mov    %ebx,%edx
		if(!cur || (int)start >= ULIM || !(*cur & PTE_P) || ((int)*cur & perm) != perm){
f0102f97:	83 c4 10             	add    $0x10,%esp
f0102f9a:	85 c0                	test   %eax,%eax
f0102f9c:	74 14                	je     f0102fb2 <user_mem_check+0x69>
f0102f9e:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102fa4:	77 0c                	ja     f0102fb2 <user_mem_check+0x69>
f0102fa6:	8b 00                	mov    (%eax),%eax
f0102fa8:	a8 01                	test   $0x1,%al
f0102faa:	74 06                	je     f0102fb2 <user_mem_check+0x69>
f0102fac:	21 f0                	and    %esi,%eax
f0102fae:	39 f0                	cmp    %esi,%eax
f0102fb0:	74 c8                	je     f0102f7a <user_mem_check+0x31>
			user_mem_check_addr = (void *)start < va ? (uintptr_t)va : (uintptr_t)start;
f0102fb2:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102fb5:	0f 42 55 e4          	cmovb  -0x1c(%ebp),%edx
f0102fb9:	89 15 3c e2 2b f0    	mov    %edx,0xf02be23c
			return -E_FAULT;
f0102fbf:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102fc7:	5b                   	pop    %ebx
f0102fc8:	5e                   	pop    %esi
f0102fc9:	5f                   	pop    %edi
f0102fca:	5d                   	pop    %ebp
f0102fcb:	c3                   	ret    
	return 0;
f0102fcc:	b8 00 00 00 00       	mov    $0x0,%eax
f0102fd1:	eb f1                	jmp    f0102fc4 <user_mem_check+0x7b>

f0102fd3 <user_mem_assert>:
{
f0102fd3:	f3 0f 1e fb          	endbr32 
f0102fd7:	55                   	push   %ebp
f0102fd8:	89 e5                	mov    %esp,%ebp
f0102fda:	53                   	push   %ebx
f0102fdb:	83 ec 04             	sub    $0x4,%esp
f0102fde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0102fe1:	8b 45 14             	mov    0x14(%ebp),%eax
f0102fe4:	83 c8 04             	or     $0x4,%eax
f0102fe7:	50                   	push   %eax
f0102fe8:	ff 75 10             	pushl  0x10(%ebp)
f0102feb:	ff 75 0c             	pushl  0xc(%ebp)
f0102fee:	53                   	push   %ebx
f0102fef:	e8 55 ff ff ff       	call   f0102f49 <user_mem_check>
f0102ff4:	83 c4 10             	add    $0x10,%esp
f0102ff7:	85 c0                	test   %eax,%eax
f0102ff9:	78 05                	js     f0103000 <user_mem_assert+0x2d>
}
f0102ffb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102ffe:	c9                   	leave  
f0102fff:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103000:	83 ec 04             	sub    $0x4,%esp
f0103003:	ff 35 3c e2 2b f0    	pushl  0xf02be23c
f0103009:	ff 73 48             	pushl  0x48(%ebx)
f010300c:	68 24 7c 10 f0       	push   $0xf0107c24
f0103011:	e8 51 09 00 00       	call   f0103967 <cprintf>
		env_destroy(env);	// may not return
f0103016:	89 1c 24             	mov    %ebx,(%esp)
f0103019:	e8 0e 06 00 00       	call   f010362c <env_destroy>
f010301e:	83 c4 10             	add    $0x10,%esp
}
f0103021:	eb d8                	jmp    f0102ffb <user_mem_assert+0x28>

f0103023 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103023:	55                   	push   %ebp
f0103024:	89 e5                	mov    %esp,%ebp
f0103026:	57                   	push   %edi
f0103027:	56                   	push   %esi
f0103028:	53                   	push   %ebx
f0103029:	83 ec 0c             	sub    $0xc,%esp
f010302c:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	void* start = (void *)ROUNDDOWN((uint32_t)va, PGSIZE);
f010302e:	89 d3                	mov    %edx,%ebx
f0103030:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    void* end = (void *)ROUNDUP((uint32_t)va+len, PGSIZE);
f0103036:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f010303d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    struct PageInfo *p = NULL;
    void* i;
    int r;

    for(i = start; i < end; i += PGSIZE){
f0103043:	39 f3                	cmp    %esi,%ebx
f0103045:	73 5a                	jae    f01030a1 <region_alloc+0x7e>
        p = page_alloc(0);
f0103047:	83 ec 0c             	sub    $0xc,%esp
f010304a:	6a 00                	push   $0x0
f010304c:	e8 29 df ff ff       	call   f0100f7a <page_alloc>
        if(p == NULL)
f0103051:	83 c4 10             	add    $0x10,%esp
f0103054:	85 c0                	test   %eax,%eax
f0103056:	74 1b                	je     f0103073 <region_alloc+0x50>
           panic(" region alloc failed: allocation failed.\n");

        r = page_insert(e->env_pgdir, p, i, PTE_W | PTE_U);
f0103058:	6a 06                	push   $0x6
f010305a:	53                   	push   %ebx
f010305b:	50                   	push   %eax
f010305c:	ff 77 60             	pushl  0x60(%edi)
f010305f:	e8 ea e1 ff ff       	call   f010124e <page_insert>
        if(r != 0)
f0103064:	83 c4 10             	add    $0x10,%esp
f0103067:	85 c0                	test   %eax,%eax
f0103069:	75 1f                	jne    f010308a <region_alloc+0x67>
    for(i = start; i < end; i += PGSIZE){
f010306b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103071:	eb d0                	jmp    f0103043 <region_alloc+0x20>
           panic(" region alloc failed: allocation failed.\n");
f0103073:	83 ec 04             	sub    $0x4,%esp
f0103076:	68 5c 7c 10 f0       	push   $0xf0107c5c
f010307b:	68 32 01 00 00       	push   $0x132
f0103080:	68 bb 7c 10 f0       	push   $0xf0107cbb
f0103085:	e8 b6 cf ff ff       	call   f0100040 <_panic>
            panic("region alloc failed.\n");
f010308a:	83 ec 04             	sub    $0x4,%esp
f010308d:	68 c6 7c 10 f0       	push   $0xf0107cc6
f0103092:	68 36 01 00 00       	push   $0x136
f0103097:	68 bb 7c 10 f0       	push   $0xf0107cbb
f010309c:	e8 9f cf ff ff       	call   f0100040 <_panic>
    }
}
f01030a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01030a4:	5b                   	pop    %ebx
f01030a5:	5e                   	pop    %esi
f01030a6:	5f                   	pop    %edi
f01030a7:	5d                   	pop    %ebp
f01030a8:	c3                   	ret    

f01030a9 <envid2env>:
{
f01030a9:	f3 0f 1e fb          	endbr32 
f01030ad:	55                   	push   %ebp
f01030ae:	89 e5                	mov    %esp,%ebp
f01030b0:	56                   	push   %esi
f01030b1:	53                   	push   %ebx
f01030b2:	8b 75 08             	mov    0x8(%ebp),%esi
f01030b5:	8b 45 10             	mov    0x10(%ebp),%eax
	if (envid == 0) {
f01030b8:	85 f6                	test   %esi,%esi
f01030ba:	74 2e                	je     f01030ea <envid2env+0x41>
	e = &envs[ENVX(envid)];
f01030bc:	89 f3                	mov    %esi,%ebx
f01030be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f01030c4:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f01030c7:	03 1d 48 e2 2b f0    	add    0xf02be248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01030cd:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01030d1:	74 2e                	je     f0103101 <envid2env+0x58>
f01030d3:	39 73 48             	cmp    %esi,0x48(%ebx)
f01030d6:	75 29                	jne    f0103101 <envid2env+0x58>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01030d8:	84 c0                	test   %al,%al
f01030da:	75 35                	jne    f0103111 <envid2env+0x68>
	*env_store = e;
f01030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030df:	89 18                	mov    %ebx,(%eax)
	return 0;
f01030e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01030e6:	5b                   	pop    %ebx
f01030e7:	5e                   	pop    %esi
f01030e8:	5d                   	pop    %ebp
f01030e9:	c3                   	ret    
		*env_store = curenv;
f01030ea:	e8 df 2c 00 00       	call   f0105dce <cpunum>
f01030ef:	6b c0 74             	imul   $0x74,%eax,%eax
f01030f2:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01030f8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01030fb:	89 02                	mov    %eax,(%edx)
		return 0;
f01030fd:	89 f0                	mov    %esi,%eax
f01030ff:	eb e5                	jmp    f01030e6 <envid2env+0x3d>
		*env_store = 0;
f0103101:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010310a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010310f:	eb d5                	jmp    f01030e6 <envid2env+0x3d>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103111:	e8 b8 2c 00 00       	call   f0105dce <cpunum>
f0103116:	6b c0 74             	imul   $0x74,%eax,%eax
f0103119:	39 98 28 f0 2b f0    	cmp    %ebx,-0xfd40fd8(%eax)
f010311f:	74 bb                	je     f01030dc <envid2env+0x33>
f0103121:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103124:	e8 a5 2c 00 00       	call   f0105dce <cpunum>
f0103129:	6b c0 74             	imul   $0x74,%eax,%eax
f010312c:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0103132:	3b 70 48             	cmp    0x48(%eax),%esi
f0103135:	74 a5                	je     f01030dc <envid2env+0x33>
		*env_store = 0;
f0103137:	8b 45 0c             	mov    0xc(%ebp),%eax
f010313a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103140:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103145:	eb 9f                	jmp    f01030e6 <envid2env+0x3d>

f0103147 <env_init_percpu>:
{
f0103147:	f3 0f 1e fb          	endbr32 
	asm volatile("lgdt (%0)" : : "r" (p));
f010314b:	b8 20 53 12 f0       	mov    $0xf0125320,%eax
f0103150:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f0103153:	b8 23 00 00 00       	mov    $0x23,%eax
f0103158:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f010315a:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f010315c:	b8 10 00 00 00       	mov    $0x10,%eax
f0103161:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f0103163:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103165:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103167:	ea 6e 31 10 f0 08 00 	ljmp   $0x8,$0xf010316e
	asm volatile("lldt %0" : : "r" (sel));
f010316e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103173:	0f 00 d0             	lldt   %ax
}
f0103176:	c3                   	ret    

f0103177 <env_init>:
{
f0103177:	f3 0f 1e fb          	endbr32 
f010317b:	55                   	push   %ebp
f010317c:	89 e5                	mov    %esp,%ebp
f010317e:	56                   	push   %esi
f010317f:	53                   	push   %ebx
		envs[i].env_id = 0;
f0103180:	8b 35 48 e2 2b f0    	mov    0xf02be248,%esi
f0103186:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f010318c:	89 f3                	mov    %esi,%ebx
f010318e:	ba 00 00 00 00       	mov    $0x0,%edx
f0103193:	89 d1                	mov    %edx,%ecx
f0103195:	89 c2                	mov    %eax,%edx
f0103197:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_status = ENV_FREE;
f010319e:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[i].env_link = env_free_list;
f01031a5:	89 48 44             	mov    %ecx,0x44(%eax)
f01031a8:	83 e8 7c             	sub    $0x7c,%eax
	for(int i = NENV - 1; i >= 0; --i){
f01031ab:	39 da                	cmp    %ebx,%edx
f01031ad:	75 e4                	jne    f0103193 <env_init+0x1c>
f01031af:	89 35 4c e2 2b f0    	mov    %esi,0xf02be24c
	env_init_percpu();
f01031b5:	e8 8d ff ff ff       	call   f0103147 <env_init_percpu>
}
f01031ba:	5b                   	pop    %ebx
f01031bb:	5e                   	pop    %esi
f01031bc:	5d                   	pop    %ebp
f01031bd:	c3                   	ret    

f01031be <env_alloc>:
{
f01031be:	f3 0f 1e fb          	endbr32 
f01031c2:	55                   	push   %ebp
f01031c3:	89 e5                	mov    %esp,%ebp
f01031c5:	53                   	push   %ebx
f01031c6:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list)){
f01031c9:	8b 1d 4c e2 2b f0    	mov    0xf02be24c,%ebx
f01031cf:	85 db                	test   %ebx,%ebx
f01031d1:	0f 84 57 01 00 00    	je     f010332e <env_alloc+0x170>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01031d7:	83 ec 0c             	sub    $0xc,%esp
f01031da:	6a 01                	push   $0x1
f01031dc:	e8 99 dd ff ff       	call   f0100f7a <page_alloc>
f01031e1:	83 c4 10             	add    $0x10,%esp
f01031e4:	85 c0                	test   %eax,%eax
f01031e6:	0f 84 49 01 00 00    	je     f0103335 <env_alloc+0x177>
	return (pp - pages) << PGSHIFT;
f01031ec:	89 c2                	mov    %eax,%edx
f01031ee:	2b 15 9c ee 2b f0    	sub    0xf02bee9c,%edx
f01031f4:	c1 fa 03             	sar    $0x3,%edx
f01031f7:	89 d1                	mov    %edx,%ecx
f01031f9:	c1 e1 0c             	shl    $0xc,%ecx
	if (PGNUM(pa) >= npages)
f01031fc:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
f0103202:	3b 15 94 ee 2b f0    	cmp    0xf02bee94,%edx
f0103208:	0f 83 f9 00 00 00    	jae    f0103307 <env_alloc+0x149>
	return (void *)(pa + KERNBASE);
f010320e:	81 e9 00 00 00 10    	sub    $0x10000000,%ecx
f0103214:	89 4b 60             	mov    %ecx,0x60(%ebx)
	p->pp_ref++;
f0103217:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f010321c:	83 ec 04             	sub    $0x4,%esp
f010321f:	68 00 10 00 00       	push   $0x1000
f0103224:	ff 35 98 ee 2b f0    	pushl  0xf02bee98
f010322a:	ff 73 60             	pushl  0x60(%ebx)
f010322d:	e8 2e 26 00 00       	call   f0105860 <memcpy>
f0103232:	83 c4 10             	add    $0x10,%esp
f0103235:	b8 00 00 00 00       	mov    $0x0,%eax
        e->env_pgdir[i] |= PTE_W | PTE_U;
f010323a:	89 c2                	mov    %eax,%edx
f010323c:	03 53 60             	add    0x60(%ebx),%edx
f010323f:	83 0a 06             	orl    $0x6,(%edx)
f0103242:	83 c0 04             	add    $0x4,%eax
	for (i = 0; i < PDX(UTOP); ++i) {
f0103245:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010324a:	75 ee                	jne    f010323a <env_alloc+0x7c>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010324c:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010324f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103254:	0f 86 bf 00 00 00    	jbe    f0103319 <env_alloc+0x15b>
	return (physaddr_t)kva - KERNBASE;
f010325a:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103260:	83 ca 05             	or     $0x5,%edx
f0103263:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103269:	8b 43 48             	mov    0x48(%ebx),%eax
f010326c:	05 00 10 00 00       	add    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
f0103271:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0103276:	ba 00 10 00 00       	mov    $0x1000,%edx
f010327b:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f010327e:	89 da                	mov    %ebx,%edx
f0103280:	2b 15 48 e2 2b f0    	sub    0xf02be248,%edx
f0103286:	c1 fa 02             	sar    $0x2,%edx
f0103289:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f010328f:	09 d0                	or     %edx,%eax
f0103291:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103294:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103297:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f010329a:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01032a1:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01032a8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01032af:	83 ec 04             	sub    $0x4,%esp
f01032b2:	6a 44                	push   $0x44
f01032b4:	6a 00                	push   $0x0
f01032b6:	53                   	push   %ebx
f01032b7:	e8 f2 24 00 00       	call   f01057ae <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f01032bc:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01032c2:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01032c8:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01032ce:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01032d5:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f01032db:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f01032e2:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f01032e9:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f01032ed:	8b 43 44             	mov    0x44(%ebx),%eax
f01032f0:	a3 4c e2 2b f0       	mov    %eax,0xf02be24c
	*newenv_store = e;
f01032f5:	8b 45 08             	mov    0x8(%ebp),%eax
f01032f8:	89 18                	mov    %ebx,(%eax)
	return 0;
f01032fa:	83 c4 10             	add    $0x10,%esp
f01032fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103305:	c9                   	leave  
f0103306:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103307:	51                   	push   %ecx
f0103308:	68 24 6a 10 f0       	push   $0xf0106a24
f010330d:	6a 58                	push   $0x58
f010330f:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0103314:	e8 27 cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103319:	50                   	push   %eax
f010331a:	68 48 6a 10 f0       	push   $0xf0106a48
f010331f:	68 c9 00 00 00       	push   $0xc9
f0103324:	68 bb 7c 10 f0       	push   $0xf0107cbb
f0103329:	e8 12 cd ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f010332e:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103333:	eb cd                	jmp    f0103302 <env_alloc+0x144>
		return -E_NO_MEM;
f0103335:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010333a:	eb c6                	jmp    f0103302 <env_alloc+0x144>

f010333c <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f010333c:	f3 0f 1e fb          	endbr32 
f0103340:	55                   	push   %ebp
f0103341:	89 e5                	mov    %esp,%ebp
f0103343:	57                   	push   %edi
f0103344:	56                   	push   %esi
f0103345:	53                   	push   %ebx
f0103346:	83 ec 34             	sub    $0x34,%esp
f0103349:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Env *e;
	int res = env_alloc(&e, 0);
f010334c:	6a 00                	push   $0x0
f010334e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103351:	50                   	push   %eax
f0103352:	e8 67 fe ff ff       	call   f01031be <env_alloc>
	if(res < 0) panic("load 1st env failed!\n");
f0103357:	83 c4 10             	add    $0x10,%esp
f010335a:	85 c0                	test   %eax,%eax
f010335c:	78 39                	js     f0103397 <env_create+0x5b>

	

	e->env_type = type;
f010335e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0103361:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103364:	89 47 50             	mov    %eax,0x50(%edi)
	if(elf->e_magic != ELF_MAGIC) 
f0103367:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
f010336d:	75 3f                	jne    f01033ae <env_create+0x72>
	ph = (struct Proghdr *) ((uint8_t *) elf + elf->e_phoff);
f010336f:	89 f3                	mov    %esi,%ebx
f0103371:	03 5e 1c             	add    0x1c(%esi),%ebx
	eph = ph + elf->e_phnum;
f0103374:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
f0103378:	c1 e0 05             	shl    $0x5,%eax
f010337b:	01 d8                	add    %ebx,%eax
f010337d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	lcr3(PADDR(e->env_pgdir));   //load user pgdir
f0103380:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f0103383:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103388:	76 3b                	jbe    f01033c5 <env_create+0x89>
	return (physaddr_t)kva - KERNBASE;
f010338a:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010338f:	0f 22 d8             	mov    %eax,%cr3
}
f0103392:	e9 81 00 00 00       	jmp    f0103418 <env_create+0xdc>
	if(res < 0) panic("load 1st env failed!\n");
f0103397:	83 ec 04             	sub    $0x4,%esp
f010339a:	68 dc 7c 10 f0       	push   $0xf0107cdc
f010339f:	68 9c 01 00 00       	push   $0x19c
f01033a4:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01033a9:	e8 92 cc ff ff       	call   f0100040 <_panic>
		panic("There is something wrong in load _icode function!\n");
f01033ae:	83 ec 04             	sub    $0x4,%esp
f01033b1:	68 88 7c 10 f0       	push   $0xf0107c88
f01033b6:	68 78 01 00 00       	push   $0x178
f01033bb:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01033c0:	e8 7b cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01033c5:	50                   	push   %eax
f01033c6:	68 48 6a 10 f0       	push   $0xf0106a48
f01033cb:	68 7d 01 00 00       	push   $0x17d
f01033d0:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01033d5:	e8 66 cc ff ff       	call   f0100040 <_panic>
			region_alloc(e, (void *)ph->p_va, ph->p_memsz);
f01033da:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01033dd:	8b 53 08             	mov    0x8(%ebx),%edx
f01033e0:	89 f8                	mov    %edi,%eax
f01033e2:	e8 3c fc ff ff       	call   f0103023 <region_alloc>
			memmove((void *)ph->p_va, (void *)(binary + ph->p_offset), ph->p_filesz);
f01033e7:	83 ec 04             	sub    $0x4,%esp
f01033ea:	ff 73 10             	pushl  0x10(%ebx)
f01033ed:	89 f0                	mov    %esi,%eax
f01033ef:	03 43 04             	add    0x4(%ebx),%eax
f01033f2:	50                   	push   %eax
f01033f3:	ff 73 08             	pushl  0x8(%ebx)
f01033f6:	e8 ff 23 00 00       	call   f01057fa <memmove>
			memset((void *)(ph->p_va + ph->p_filesz), 0, ph->p_memsz - ph->p_filesz);
f01033fb:	8b 43 10             	mov    0x10(%ebx),%eax
f01033fe:	83 c4 0c             	add    $0xc,%esp
f0103401:	8b 53 14             	mov    0x14(%ebx),%edx
f0103404:	29 c2                	sub    %eax,%edx
f0103406:	52                   	push   %edx
f0103407:	6a 00                	push   $0x0
f0103409:	03 43 08             	add    0x8(%ebx),%eax
f010340c:	50                   	push   %eax
f010340d:	e8 9c 23 00 00       	call   f01057ae <memset>
f0103412:	83 c4 10             	add    $0x10,%esp
	for(; ph < eph; ph++) {
f0103415:	83 c3 20             	add    $0x20,%ebx
f0103418:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f010341b:	76 07                	jbe    f0103424 <env_create+0xe8>
		if(ph->p_type == ELF_PROG_LOAD){
f010341d:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103420:	75 f3                	jne    f0103415 <env_create+0xd9>
f0103422:	eb b6                	jmp    f01033da <env_create+0x9e>
	e->env_tf.tf_eip = elf->e_entry;
f0103424:	8b 46 18             	mov    0x18(%esi),%eax
f0103427:	89 47 30             	mov    %eax,0x30(%edi)
	lcr3(PADDR(kern_pgdir));  
f010342a:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f010342f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103434:	76 27                	jbe    f010345d <env_create+0x121>
	return (physaddr_t)kva - KERNBASE;
f0103436:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010343b:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f010343e:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103443:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103448:	89 f8                	mov    %edi,%eax
f010344a:	e8 d4 fb ff ff       	call   f0103023 <region_alloc>
	// LAB 3: Your code here.

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.

	if (type == ENV_TYPE_FS) 
f010344f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f0103453:	74 1d                	je     f0103472 <env_create+0x136>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
}
f0103455:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103458:	5b                   	pop    %ebx
f0103459:	5e                   	pop    %esi
f010345a:	5f                   	pop    %edi
f010345b:	5d                   	pop    %ebp
f010345c:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010345d:	50                   	push   %eax
f010345e:	68 48 6a 10 f0       	push   $0xf0106a48
f0103463:	68 87 01 00 00       	push   $0x187
f0103468:	68 bb 7c 10 f0       	push   $0xf0107cbb
f010346d:	e8 ce cb ff ff       	call   f0100040 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f0103472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103475:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f010347c:	eb d7                	jmp    f0103455 <env_create+0x119>

f010347e <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010347e:	f3 0f 1e fb          	endbr32 
f0103482:	55                   	push   %ebp
f0103483:	89 e5                	mov    %esp,%ebp
f0103485:	57                   	push   %edi
f0103486:	56                   	push   %esi
f0103487:	53                   	push   %ebx
f0103488:	83 ec 1c             	sub    $0x1c,%esp
f010348b:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f010348e:	e8 3b 29 00 00       	call   f0105dce <cpunum>
f0103493:	6b c0 74             	imul   $0x74,%eax,%eax
f0103496:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010349d:	39 b8 28 f0 2b f0    	cmp    %edi,-0xfd40fd8(%eax)
f01034a3:	0f 85 b3 00 00 00    	jne    f010355c <env_free+0xde>
		lcr3(PADDR(kern_pgdir));
f01034a9:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f01034ae:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034b3:	76 14                	jbe    f01034c9 <env_free+0x4b>
	return (physaddr_t)kva - KERNBASE;
f01034b5:	05 00 00 00 10       	add    $0x10000000,%eax
f01034ba:	0f 22 d8             	mov    %eax,%cr3
}
f01034bd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01034c4:	e9 93 00 00 00       	jmp    f010355c <env_free+0xde>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034c9:	50                   	push   %eax
f01034ca:	68 48 6a 10 f0       	push   $0xf0106a48
f01034cf:	68 b9 01 00 00       	push   $0x1b9
f01034d4:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01034d9:	e8 62 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034de:	56                   	push   %esi
f01034df:	68 24 6a 10 f0       	push   $0xf0106a24
f01034e4:	68 c8 01 00 00       	push   $0x1c8
f01034e9:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01034ee:	e8 4d cb ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01034f3:	83 ec 08             	sub    $0x8,%esp
f01034f6:	89 d8                	mov    %ebx,%eax
f01034f8:	c1 e0 0c             	shl    $0xc,%eax
f01034fb:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01034fe:	50                   	push   %eax
f01034ff:	ff 77 60             	pushl  0x60(%edi)
f0103502:	e8 fa dc ff ff       	call   f0101201 <page_remove>
f0103507:	83 c4 10             	add    $0x10,%esp
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f010350a:	83 c3 01             	add    $0x1,%ebx
f010350d:	83 c6 04             	add    $0x4,%esi
f0103510:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103516:	74 07                	je     f010351f <env_free+0xa1>
			if (pt[pteno] & PTE_P)
f0103518:	f6 06 01             	testb  $0x1,(%esi)
f010351b:	74 ed                	je     f010350a <env_free+0x8c>
f010351d:	eb d4                	jmp    f01034f3 <env_free+0x75>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f010351f:	8b 47 60             	mov    0x60(%edi),%eax
f0103522:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103525:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f010352c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010352f:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0103535:	73 65                	jae    f010359c <env_free+0x11e>
		page_decref(pa2page(pa));
f0103537:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f010353a:	a1 9c ee 2b f0       	mov    0xf02bee9c,%eax
f010353f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103542:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f0103545:	50                   	push   %eax
f0103546:	e8 eb da ff ff       	call   f0101036 <page_decref>
f010354b:	83 c4 10             	add    $0x10,%esp
f010354e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f0103552:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103555:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f010355a:	74 54                	je     f01035b0 <env_free+0x132>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f010355c:	8b 47 60             	mov    0x60(%edi),%eax
f010355f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103562:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103565:	a8 01                	test   $0x1,%al
f0103567:	74 e5                	je     f010354e <env_free+0xd0>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103569:	89 c6                	mov    %eax,%esi
f010356b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (PGNUM(pa) >= npages)
f0103571:	c1 e8 0c             	shr    $0xc,%eax
f0103574:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103577:	39 05 94 ee 2b f0    	cmp    %eax,0xf02bee94
f010357d:	0f 86 5b ff ff ff    	jbe    f01034de <env_free+0x60>
	return (void *)(pa + KERNBASE);
f0103583:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103589:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010358c:	c1 e0 14             	shl    $0x14,%eax
f010358f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103592:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103597:	e9 7c ff ff ff       	jmp    f0103518 <env_free+0x9a>
		panic("pa2page called with invalid pa");
f010359c:	83 ec 04             	sub    $0x4,%esp
f010359f:	68 f0 73 10 f0       	push   $0xf01073f0
f01035a4:	6a 51                	push   $0x51
f01035a6:	68 9b 6f 10 f0       	push   $0xf0106f9b
f01035ab:	e8 90 ca ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01035b0:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f01035b3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035b8:	76 49                	jbe    f0103603 <env_free+0x185>
	e->env_pgdir = 0;
f01035ba:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f01035c1:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01035c6:	c1 e8 0c             	shr    $0xc,%eax
f01035c9:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f01035cf:	73 47                	jae    f0103618 <env_free+0x19a>
	page_decref(pa2page(pa));
f01035d1:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01035d4:	8b 15 9c ee 2b f0    	mov    0xf02bee9c,%edx
f01035da:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01035dd:	50                   	push   %eax
f01035de:	e8 53 da ff ff       	call   f0101036 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01035e3:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f01035ea:	a1 4c e2 2b f0       	mov    0xf02be24c,%eax
f01035ef:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f01035f2:	89 3d 4c e2 2b f0    	mov    %edi,0xf02be24c
}
f01035f8:	83 c4 10             	add    $0x10,%esp
f01035fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01035fe:	5b                   	pop    %ebx
f01035ff:	5e                   	pop    %esi
f0103600:	5f                   	pop    %edi
f0103601:	5d                   	pop    %ebp
f0103602:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103603:	50                   	push   %eax
f0103604:	68 48 6a 10 f0       	push   $0xf0106a48
f0103609:	68 d6 01 00 00       	push   $0x1d6
f010360e:	68 bb 7c 10 f0       	push   $0xf0107cbb
f0103613:	e8 28 ca ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103618:	83 ec 04             	sub    $0x4,%esp
f010361b:	68 f0 73 10 f0       	push   $0xf01073f0
f0103620:	6a 51                	push   $0x51
f0103622:	68 9b 6f 10 f0       	push   $0xf0106f9b
f0103627:	e8 14 ca ff ff       	call   f0100040 <_panic>

f010362c <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f010362c:	f3 0f 1e fb          	endbr32 
f0103630:	55                   	push   %ebp
f0103631:	89 e5                	mov    %esp,%ebp
f0103633:	53                   	push   %ebx
f0103634:	83 ec 04             	sub    $0x4,%esp
f0103637:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010363a:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f010363e:	74 21                	je     f0103661 <env_destroy+0x35>
		e->env_status = ENV_DYING;
		return;
	}
	//cprintf("env %d is free\n", curenv->env_id);
	env_free(e);
f0103640:	83 ec 0c             	sub    $0xc,%esp
f0103643:	53                   	push   %ebx
f0103644:	e8 35 fe ff ff       	call   f010347e <env_free>
	
	if (curenv == e) {
f0103649:	e8 80 27 00 00       	call   f0105dce <cpunum>
f010364e:	6b c0 74             	imul   $0x74,%eax,%eax
f0103651:	83 c4 10             	add    $0x10,%esp
f0103654:	39 98 28 f0 2b f0    	cmp    %ebx,-0xfd40fd8(%eax)
f010365a:	74 1e                	je     f010367a <env_destroy+0x4e>
		curenv = NULL;
		sched_yield();
	}
}
f010365c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010365f:	c9                   	leave  
f0103660:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103661:	e8 68 27 00 00       	call   f0105dce <cpunum>
f0103666:	6b c0 74             	imul   $0x74,%eax,%eax
f0103669:	39 98 28 f0 2b f0    	cmp    %ebx,-0xfd40fd8(%eax)
f010366f:	74 cf                	je     f0103640 <env_destroy+0x14>
		e->env_status = ENV_DYING;
f0103671:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103678:	eb e2                	jmp    f010365c <env_destroy+0x30>
		curenv = NULL;
f010367a:	e8 4f 27 00 00       	call   f0105dce <cpunum>
f010367f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103682:	c7 80 28 f0 2b f0 00 	movl   $0x0,-0xfd40fd8(%eax)
f0103689:	00 00 00 
		sched_yield();
f010368c:	e8 d2 0e 00 00       	call   f0104563 <sched_yield>

f0103691 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103691:	f3 0f 1e fb          	endbr32 
f0103695:	55                   	push   %ebp
f0103696:	89 e5                	mov    %esp,%ebp
f0103698:	53                   	push   %ebx
f0103699:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f010369c:	e8 2d 27 00 00       	call   f0105dce <cpunum>
f01036a1:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a4:	8b 98 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%ebx
f01036aa:	e8 1f 27 00 00       	call   f0105dce <cpunum>
f01036af:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01036b2:	8b 65 08             	mov    0x8(%ebp),%esp
f01036b5:	61                   	popa   
f01036b6:	07                   	pop    %es
f01036b7:	1f                   	pop    %ds
f01036b8:	83 c4 08             	add    $0x8,%esp
f01036bb:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01036bc:	83 ec 04             	sub    $0x4,%esp
f01036bf:	68 f2 7c 10 f0       	push   $0xf0107cf2
f01036c4:	68 0d 02 00 00       	push   $0x20d
f01036c9:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01036ce:	e8 6d c9 ff ff       	call   f0100040 <_panic>

f01036d3 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01036d3:	f3 0f 1e fb          	endbr32 
f01036d7:	55                   	push   %ebp
f01036d8:	89 e5                	mov    %esp,%ebp
f01036da:	83 ec 08             	sub    $0x8,%esp
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.


	if(curenv && curenv->env_status == ENV_RUNNING){
f01036dd:	e8 ec 26 00 00       	call   f0105dce <cpunum>
f01036e2:	6b c0 74             	imul   $0x74,%eax,%eax
f01036e5:	83 b8 28 f0 2b f0 00 	cmpl   $0x0,-0xfd40fd8(%eax)
f01036ec:	74 14                	je     f0103702 <env_run+0x2f>
f01036ee:	e8 db 26 00 00       	call   f0105dce <cpunum>
f01036f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f6:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01036fc:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103700:	74 7d                	je     f010377f <env_run+0xac>
		curenv->env_status = ENV_RUNNABLE;
	}
	curenv = e;
f0103702:	e8 c7 26 00 00       	call   f0105dce <cpunum>
f0103707:	6b c0 74             	imul   $0x74,%eax,%eax
f010370a:	8b 55 08             	mov    0x8(%ebp),%edx
f010370d:	89 90 28 f0 2b f0    	mov    %edx,-0xfd40fd8(%eax)
	curenv->env_status = ENV_RUNNING;
f0103713:	e8 b6 26 00 00       	call   f0105dce <cpunum>
f0103718:	6b c0 74             	imul   $0x74,%eax,%eax
f010371b:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0103721:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	++curenv->env_runs;
f0103728:	e8 a1 26 00 00       	call   f0105dce <cpunum>
f010372d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103730:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0103736:	83 40 58 01          	addl   $0x1,0x58(%eax)

	lcr3(PADDR(curenv->env_pgdir));
f010373a:	e8 8f 26 00 00       	call   f0105dce <cpunum>
f010373f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103742:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0103748:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f010374b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103750:	76 47                	jbe    f0103799 <env_run+0xc6>
	return (physaddr_t)kva - KERNBASE;
f0103752:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103757:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010375a:	83 ec 0c             	sub    $0xc,%esp
f010375d:	68 c0 53 12 f0       	push   $0xf01253c0
f0103762:	e8 8d 29 00 00       	call   f01060f4 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103767:	f3 90                	pause  

	unlock_kernel();
	//cprintf("tfno = %d\n", curenv->env_tf);
	env_pop_tf(&(curenv->env_tf));
f0103769:	e8 60 26 00 00       	call   f0105dce <cpunum>
f010376e:	83 c4 04             	add    $0x4,%esp
f0103771:	6b c0 74             	imul   $0x74,%eax,%eax
f0103774:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f010377a:	e8 12 ff ff ff       	call   f0103691 <env_pop_tf>
		curenv->env_status = ENV_RUNNABLE;
f010377f:	e8 4a 26 00 00       	call   f0105dce <cpunum>
f0103784:	6b c0 74             	imul   $0x74,%eax,%eax
f0103787:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f010378d:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103794:	e9 69 ff ff ff       	jmp    f0103702 <env_run+0x2f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103799:	50                   	push   %eax
f010379a:	68 48 6a 10 f0       	push   $0xf0106a48
f010379f:	68 34 02 00 00       	push   $0x234
f01037a4:	68 bb 7c 10 f0       	push   $0xf0107cbb
f01037a9:	e8 92 c8 ff ff       	call   f0100040 <_panic>

f01037ae <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01037ae:	f3 0f 1e fb          	endbr32 
f01037b2:	55                   	push   %ebp
f01037b3:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037b5:	8b 45 08             	mov    0x8(%ebp),%eax
f01037b8:	ba 70 00 00 00       	mov    $0x70,%edx
f01037bd:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01037be:	ba 71 00 00 00       	mov    $0x71,%edx
f01037c3:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01037c4:	0f b6 c0             	movzbl %al,%eax
}
f01037c7:	5d                   	pop    %ebp
f01037c8:	c3                   	ret    

f01037c9 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01037c9:	f3 0f 1e fb          	endbr32 
f01037cd:	55                   	push   %ebp
f01037ce:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037d0:	8b 45 08             	mov    0x8(%ebp),%eax
f01037d3:	ba 70 00 00 00       	mov    $0x70,%edx
f01037d8:	ee                   	out    %al,(%dx)
f01037d9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01037dc:	ba 71 00 00 00       	mov    $0x71,%edx
f01037e1:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01037e2:	5d                   	pop    %ebp
f01037e3:	c3                   	ret    

f01037e4 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01037e4:	f3 0f 1e fb          	endbr32 
f01037e8:	55                   	push   %ebp
f01037e9:	89 e5                	mov    %esp,%ebp
f01037eb:	56                   	push   %esi
f01037ec:	53                   	push   %ebx
f01037ed:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01037f0:	66 a3 a8 53 12 f0    	mov    %ax,0xf01253a8
	if (!didinit)
f01037f6:	80 3d 50 e2 2b f0 00 	cmpb   $0x0,0xf02be250
f01037fd:	75 07                	jne    f0103806 <irq_setmask_8259A+0x22>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01037ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103802:	5b                   	pop    %ebx
f0103803:	5e                   	pop    %esi
f0103804:	5d                   	pop    %ebp
f0103805:	c3                   	ret    
f0103806:	89 c6                	mov    %eax,%esi
f0103808:	ba 21 00 00 00       	mov    $0x21,%edx
f010380d:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f010380e:	66 c1 e8 08          	shr    $0x8,%ax
f0103812:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103817:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103818:	83 ec 0c             	sub    $0xc,%esp
f010381b:	68 fe 7c 10 f0       	push   $0xf0107cfe
f0103820:	e8 42 01 00 00       	call   f0103967 <cprintf>
f0103825:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103828:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010382d:	0f b7 f6             	movzwl %si,%esi
f0103830:	f7 d6                	not    %esi
f0103832:	eb 19                	jmp    f010384d <irq_setmask_8259A+0x69>
			cprintf(" %d", i);
f0103834:	83 ec 08             	sub    $0x8,%esp
f0103837:	53                   	push   %ebx
f0103838:	68 af 81 10 f0       	push   $0xf01081af
f010383d:	e8 25 01 00 00       	call   f0103967 <cprintf>
f0103842:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f0103845:	83 c3 01             	add    $0x1,%ebx
f0103848:	83 fb 10             	cmp    $0x10,%ebx
f010384b:	74 07                	je     f0103854 <irq_setmask_8259A+0x70>
		if (~mask & (1<<i))
f010384d:	0f a3 de             	bt     %ebx,%esi
f0103850:	73 f3                	jae    f0103845 <irq_setmask_8259A+0x61>
f0103852:	eb e0                	jmp    f0103834 <irq_setmask_8259A+0x50>
	cprintf("\n");
f0103854:	83 ec 0c             	sub    $0xc,%esp
f0103857:	68 6f 72 10 f0       	push   $0xf010726f
f010385c:	e8 06 01 00 00       	call   f0103967 <cprintf>
f0103861:	83 c4 10             	add    $0x10,%esp
f0103864:	eb 99                	jmp    f01037ff <irq_setmask_8259A+0x1b>

f0103866 <pic_init>:
{
f0103866:	f3 0f 1e fb          	endbr32 
f010386a:	55                   	push   %ebp
f010386b:	89 e5                	mov    %esp,%ebp
f010386d:	57                   	push   %edi
f010386e:	56                   	push   %esi
f010386f:	53                   	push   %ebx
f0103870:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103873:	c6 05 50 e2 2b f0 01 	movb   $0x1,0xf02be250
f010387a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010387f:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103884:	89 da                	mov    %ebx,%edx
f0103886:	ee                   	out    %al,(%dx)
f0103887:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010388c:	89 ca                	mov    %ecx,%edx
f010388e:	ee                   	out    %al,(%dx)
f010388f:	bf 11 00 00 00       	mov    $0x11,%edi
f0103894:	be 20 00 00 00       	mov    $0x20,%esi
f0103899:	89 f8                	mov    %edi,%eax
f010389b:	89 f2                	mov    %esi,%edx
f010389d:	ee                   	out    %al,(%dx)
f010389e:	b8 20 00 00 00       	mov    $0x20,%eax
f01038a3:	89 da                	mov    %ebx,%edx
f01038a5:	ee                   	out    %al,(%dx)
f01038a6:	b8 04 00 00 00       	mov    $0x4,%eax
f01038ab:	ee                   	out    %al,(%dx)
f01038ac:	b8 03 00 00 00       	mov    $0x3,%eax
f01038b1:	ee                   	out    %al,(%dx)
f01038b2:	bb a0 00 00 00       	mov    $0xa0,%ebx
f01038b7:	89 f8                	mov    %edi,%eax
f01038b9:	89 da                	mov    %ebx,%edx
f01038bb:	ee                   	out    %al,(%dx)
f01038bc:	b8 28 00 00 00       	mov    $0x28,%eax
f01038c1:	89 ca                	mov    %ecx,%edx
f01038c3:	ee                   	out    %al,(%dx)
f01038c4:	b8 02 00 00 00       	mov    $0x2,%eax
f01038c9:	ee                   	out    %al,(%dx)
f01038ca:	b8 01 00 00 00       	mov    $0x1,%eax
f01038cf:	ee                   	out    %al,(%dx)
f01038d0:	bf 68 00 00 00       	mov    $0x68,%edi
f01038d5:	89 f8                	mov    %edi,%eax
f01038d7:	89 f2                	mov    %esi,%edx
f01038d9:	ee                   	out    %al,(%dx)
f01038da:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01038df:	89 c8                	mov    %ecx,%eax
f01038e1:	ee                   	out    %al,(%dx)
f01038e2:	89 f8                	mov    %edi,%eax
f01038e4:	89 da                	mov    %ebx,%edx
f01038e6:	ee                   	out    %al,(%dx)
f01038e7:	89 c8                	mov    %ecx,%eax
f01038e9:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01038ea:	0f b7 05 a8 53 12 f0 	movzwl 0xf01253a8,%eax
f01038f1:	66 83 f8 ff          	cmp    $0xffff,%ax
f01038f5:	75 08                	jne    f01038ff <pic_init+0x99>
}
f01038f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038fa:	5b                   	pop    %ebx
f01038fb:	5e                   	pop    %esi
f01038fc:	5f                   	pop    %edi
f01038fd:	5d                   	pop    %ebp
f01038fe:	c3                   	ret    
		irq_setmask_8259A(irq_mask_8259A);
f01038ff:	83 ec 0c             	sub    $0xc,%esp
f0103902:	0f b7 c0             	movzwl %ax,%eax
f0103905:	50                   	push   %eax
f0103906:	e8 d9 fe ff ff       	call   f01037e4 <irq_setmask_8259A>
f010390b:	83 c4 10             	add    $0x10,%esp
}
f010390e:	eb e7                	jmp    f01038f7 <pic_init+0x91>

f0103910 <irq_eoi>:

void
irq_eoi(void)
{
f0103910:	f3 0f 1e fb          	endbr32 
f0103914:	b8 20 00 00 00       	mov    $0x20,%eax
f0103919:	ba 20 00 00 00       	mov    $0x20,%edx
f010391e:	ee                   	out    %al,(%dx)
f010391f:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103924:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103925:	c3                   	ret    

f0103926 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103926:	f3 0f 1e fb          	endbr32 
f010392a:	55                   	push   %ebp
f010392b:	89 e5                	mov    %esp,%ebp
f010392d:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103930:	ff 75 08             	pushl  0x8(%ebp)
f0103933:	e8 7b ce ff ff       	call   f01007b3 <cputchar>
	*cnt++;
}
f0103938:	83 c4 10             	add    $0x10,%esp
f010393b:	c9                   	leave  
f010393c:	c3                   	ret    

f010393d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010393d:	f3 0f 1e fb          	endbr32 
f0103941:	55                   	push   %ebp
f0103942:	89 e5                	mov    %esp,%ebp
f0103944:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103947:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010394e:	ff 75 0c             	pushl  0xc(%ebp)
f0103951:	ff 75 08             	pushl  0x8(%ebp)
f0103954:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103957:	50                   	push   %eax
f0103958:	68 26 39 10 f0       	push   $0xf0103926
f010395d:	e8 e9 16 00 00       	call   f010504b <vprintfmt>
	return cnt;
}
f0103962:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103965:	c9                   	leave  
f0103966:	c3                   	ret    

f0103967 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103967:	f3 0f 1e fb          	endbr32 
f010396b:	55                   	push   %ebp
f010396c:	89 e5                	mov    %esp,%ebp
f010396e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103971:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103974:	50                   	push   %eax
f0103975:	ff 75 08             	pushl  0x8(%ebp)
f0103978:	e8 c0 ff ff ff       	call   f010393d <vcprintf>
	va_end(ap);

	return cnt;
}
f010397d:	c9                   	leave  
f010397e:	c3                   	ret    

f010397f <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f010397f:	f3 0f 1e fb          	endbr32 
f0103983:	55                   	push   %ebp
f0103984:	89 e5                	mov    %esp,%ebp
f0103986:	57                   	push   %edi
f0103987:	56                   	push   %esi
f0103988:	53                   	push   %ebx
f0103989:	83 ec 1c             	sub    $0x1c,%esp
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	// ts.ts_esp0 = KSTACKTOP;
	// ts.ts_ss0 = GD_KD;
	// ts.ts_iomb = sizeof(struct Taskstate);
	int id = thiscpu->cpu_id;
f010398c:	e8 3d 24 00 00       	call   f0105dce <cpunum>
f0103991:	6b c0 74             	imul   $0x74,%eax,%eax
f0103994:	0f b6 b8 20 f0 2b f0 	movzbl -0xfd40fe0(%eax),%edi
f010399b:	89 f8                	mov    %edi,%eax
f010399d:	0f b6 d8             	movzbl %al,%ebx
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - (KSTKSIZE + KSTKGAP) * id;
f01039a0:	e8 29 24 00 00       	call   f0105dce <cpunum>
f01039a5:	6b c0 74             	imul   $0x74,%eax,%eax
f01039a8:	89 d9                	mov    %ebx,%ecx
f01039aa:	c1 e1 10             	shl    $0x10,%ecx
f01039ad:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01039b2:	29 ca                	sub    %ecx,%edx
f01039b4:	89 90 30 f0 2b f0    	mov    %edx,-0xfd40fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f01039ba:	e8 0f 24 00 00       	call   f0105dce <cpunum>
f01039bf:	6b c0 74             	imul   $0x74,%eax,%eax
f01039c2:	66 c7 80 34 f0 2b f0 	movw   $0x10,-0xfd40fcc(%eax)
f01039c9:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f01039cb:	e8 fe 23 00 00       	call   f0105dce <cpunum>
f01039d0:	6b c0 74             	imul   $0x74,%eax,%eax
f01039d3:	66 c7 80 92 f0 2b f0 	movw   $0x68,-0xfd40f6e(%eax)
f01039da:	68 00 

	gdt[(GD_TSS0 >> 3) + id] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
f01039dc:	83 c3 05             	add    $0x5,%ebx
f01039df:	e8 ea 23 00 00       	call   f0105dce <cpunum>
f01039e4:	89 c6                	mov    %eax,%esi
f01039e6:	e8 e3 23 00 00       	call   f0105dce <cpunum>
f01039eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01039ee:	e8 db 23 00 00       	call   f0105dce <cpunum>
f01039f3:	66 c7 04 dd 40 53 12 	movw   $0x67,-0xfedacc0(,%ebx,8)
f01039fa:	f0 67 00 
f01039fd:	6b f6 74             	imul   $0x74,%esi,%esi
f0103a00:	81 c6 2c f0 2b f0    	add    $0xf02bf02c,%esi
f0103a06:	66 89 34 dd 42 53 12 	mov    %si,-0xfedacbe(,%ebx,8)
f0103a0d:	f0 
f0103a0e:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f0103a12:	81 c2 2c f0 2b f0    	add    $0xf02bf02c,%edx
f0103a18:	c1 ea 10             	shr    $0x10,%edx
f0103a1b:	88 14 dd 44 53 12 f0 	mov    %dl,-0xfedacbc(,%ebx,8)
f0103a22:	c6 04 dd 46 53 12 f0 	movb   $0x40,-0xfedacba(,%ebx,8)
f0103a29:	40 
f0103a2a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a2d:	05 2c f0 2b f0       	add    $0xf02bf02c,%eax
f0103a32:	c1 e8 18             	shr    $0x18,%eax
f0103a35:	88 04 dd 47 53 12 f0 	mov    %al,-0xfedacb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + id].sd_s = 0;
f0103a3c:	c6 04 dd 45 53 12 f0 	movb   $0x89,-0xfedacbb(,%ebx,8)
f0103a43:	89 
	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (id << 3));
f0103a44:	89 f8                	mov    %edi,%eax
f0103a46:	0f b6 f8             	movzbl %al,%edi
f0103a49:	8d 3c fd 28 00 00 00 	lea    0x28(,%edi,8),%edi
	asm volatile("ltr %0" : : "r" (sel));
f0103a50:	0f 00 df             	ltr    %di
	asm volatile("lidt (%0)" : : "r" (p));
f0103a53:	b8 ac 53 12 f0       	mov    $0xf01253ac,%eax
f0103a58:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103a5b:	83 c4 1c             	add    $0x1c,%esp
f0103a5e:	5b                   	pop    %ebx
f0103a5f:	5e                   	pop    %esi
f0103a60:	5f                   	pop    %edi
f0103a61:	5d                   	pop    %ebp
f0103a62:	c3                   	ret    

f0103a63 <trap_init>:
{
f0103a63:	f3 0f 1e fb          	endbr32 
f0103a67:	55                   	push   %ebp
f0103a68:	89 e5                	mov    %esp,%ebp
f0103a6a:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, handler0, 0);
f0103a6d:	b8 0a 44 10 f0       	mov    $0xf010440a,%eax
f0103a72:	66 a3 60 e2 2b f0    	mov    %ax,0xf02be260
f0103a78:	66 c7 05 62 e2 2b f0 	movw   $0x8,0xf02be262
f0103a7f:	08 00 
f0103a81:	c6 05 64 e2 2b f0 00 	movb   $0x0,0xf02be264
f0103a88:	c6 05 65 e2 2b f0 8e 	movb   $0x8e,0xf02be265
f0103a8f:	c1 e8 10             	shr    $0x10,%eax
f0103a92:	66 a3 66 e2 2b f0    	mov    %ax,0xf02be266
	SETGATE(idt[T_DEBUG], 0, GD_KT, handler1, 0);
f0103a98:	b8 10 44 10 f0       	mov    $0xf0104410,%eax
f0103a9d:	66 a3 68 e2 2b f0    	mov    %ax,0xf02be268
f0103aa3:	66 c7 05 6a e2 2b f0 	movw   $0x8,0xf02be26a
f0103aaa:	08 00 
f0103aac:	c6 05 6c e2 2b f0 00 	movb   $0x0,0xf02be26c
f0103ab3:	c6 05 6d e2 2b f0 8e 	movb   $0x8e,0xf02be26d
f0103aba:	c1 e8 10             	shr    $0x10,%eax
f0103abd:	66 a3 6e e2 2b f0    	mov    %ax,0xf02be26e
	SETGATE(idt[T_NMI], 0, GD_KT, handler2, 0);
f0103ac3:	b8 16 44 10 f0       	mov    $0xf0104416,%eax
f0103ac8:	66 a3 70 e2 2b f0    	mov    %ax,0xf02be270
f0103ace:	66 c7 05 72 e2 2b f0 	movw   $0x8,0xf02be272
f0103ad5:	08 00 
f0103ad7:	c6 05 74 e2 2b f0 00 	movb   $0x0,0xf02be274
f0103ade:	c6 05 75 e2 2b f0 8e 	movb   $0x8e,0xf02be275
f0103ae5:	c1 e8 10             	shr    $0x10,%eax
f0103ae8:	66 a3 76 e2 2b f0    	mov    %ax,0xf02be276
	SETGATE(idt[T_BRKPT], 0, GD_KT, handler3, 3);
f0103aee:	b8 1c 44 10 f0       	mov    $0xf010441c,%eax
f0103af3:	66 a3 78 e2 2b f0    	mov    %ax,0xf02be278
f0103af9:	66 c7 05 7a e2 2b f0 	movw   $0x8,0xf02be27a
f0103b00:	08 00 
f0103b02:	c6 05 7c e2 2b f0 00 	movb   $0x0,0xf02be27c
f0103b09:	c6 05 7d e2 2b f0 ee 	movb   $0xee,0xf02be27d
f0103b10:	c1 e8 10             	shr    $0x10,%eax
f0103b13:	66 a3 7e e2 2b f0    	mov    %ax,0xf02be27e
	SETGATE(idt[T_OFLOW], 0, GD_KT, handler4, 0);
f0103b19:	b8 22 44 10 f0       	mov    $0xf0104422,%eax
f0103b1e:	66 a3 80 e2 2b f0    	mov    %ax,0xf02be280
f0103b24:	66 c7 05 82 e2 2b f0 	movw   $0x8,0xf02be282
f0103b2b:	08 00 
f0103b2d:	c6 05 84 e2 2b f0 00 	movb   $0x0,0xf02be284
f0103b34:	c6 05 85 e2 2b f0 8e 	movb   $0x8e,0xf02be285
f0103b3b:	c1 e8 10             	shr    $0x10,%eax
f0103b3e:	66 a3 86 e2 2b f0    	mov    %ax,0xf02be286
	SETGATE(idt[T_BOUND], 0, GD_KT, handler5, 0);
f0103b44:	b8 28 44 10 f0       	mov    $0xf0104428,%eax
f0103b49:	66 a3 88 e2 2b f0    	mov    %ax,0xf02be288
f0103b4f:	66 c7 05 8a e2 2b f0 	movw   $0x8,0xf02be28a
f0103b56:	08 00 
f0103b58:	c6 05 8c e2 2b f0 00 	movb   $0x0,0xf02be28c
f0103b5f:	c6 05 8d e2 2b f0 8e 	movb   $0x8e,0xf02be28d
f0103b66:	c1 e8 10             	shr    $0x10,%eax
f0103b69:	66 a3 8e e2 2b f0    	mov    %ax,0xf02be28e
	SETGATE(idt[T_ILLOP], 0, GD_KT, handler6, 0);
f0103b6f:	b8 2e 44 10 f0       	mov    $0xf010442e,%eax
f0103b74:	66 a3 90 e2 2b f0    	mov    %ax,0xf02be290
f0103b7a:	66 c7 05 92 e2 2b f0 	movw   $0x8,0xf02be292
f0103b81:	08 00 
f0103b83:	c6 05 94 e2 2b f0 00 	movb   $0x0,0xf02be294
f0103b8a:	c6 05 95 e2 2b f0 8e 	movb   $0x8e,0xf02be295
f0103b91:	c1 e8 10             	shr    $0x10,%eax
f0103b94:	66 a3 96 e2 2b f0    	mov    %ax,0xf02be296
	SETGATE(idt[T_DEVICE], 0, GD_KT, handler7, 0);
f0103b9a:	b8 34 44 10 f0       	mov    $0xf0104434,%eax
f0103b9f:	66 a3 98 e2 2b f0    	mov    %ax,0xf02be298
f0103ba5:	66 c7 05 9a e2 2b f0 	movw   $0x8,0xf02be29a
f0103bac:	08 00 
f0103bae:	c6 05 9c e2 2b f0 00 	movb   $0x0,0xf02be29c
f0103bb5:	c6 05 9d e2 2b f0 8e 	movb   $0x8e,0xf02be29d
f0103bbc:	c1 e8 10             	shr    $0x10,%eax
f0103bbf:	66 a3 9e e2 2b f0    	mov    %ax,0xf02be29e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, handler8, 0);
f0103bc5:	b8 38 44 10 f0       	mov    $0xf0104438,%eax
f0103bca:	66 a3 a0 e2 2b f0    	mov    %ax,0xf02be2a0
f0103bd0:	66 c7 05 a2 e2 2b f0 	movw   $0x8,0xf02be2a2
f0103bd7:	08 00 
f0103bd9:	c6 05 a4 e2 2b f0 00 	movb   $0x0,0xf02be2a4
f0103be0:	c6 05 a5 e2 2b f0 8e 	movb   $0x8e,0xf02be2a5
f0103be7:	c1 e8 10             	shr    $0x10,%eax
f0103bea:	66 a3 a6 e2 2b f0    	mov    %ax,0xf02be2a6
	SETGATE(idt[T_TSS], 0, GD_KT, handler10, 0);
f0103bf0:	b8 3e 44 10 f0       	mov    $0xf010443e,%eax
f0103bf5:	66 a3 b0 e2 2b f0    	mov    %ax,0xf02be2b0
f0103bfb:	66 c7 05 b2 e2 2b f0 	movw   $0x8,0xf02be2b2
f0103c02:	08 00 
f0103c04:	c6 05 b4 e2 2b f0 00 	movb   $0x0,0xf02be2b4
f0103c0b:	c6 05 b5 e2 2b f0 8e 	movb   $0x8e,0xf02be2b5
f0103c12:	c1 e8 10             	shr    $0x10,%eax
f0103c15:	66 a3 b6 e2 2b f0    	mov    %ax,0xf02be2b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, handler11, 0);
f0103c1b:	b8 42 44 10 f0       	mov    $0xf0104442,%eax
f0103c20:	66 a3 b8 e2 2b f0    	mov    %ax,0xf02be2b8
f0103c26:	66 c7 05 ba e2 2b f0 	movw   $0x8,0xf02be2ba
f0103c2d:	08 00 
f0103c2f:	c6 05 bc e2 2b f0 00 	movb   $0x0,0xf02be2bc
f0103c36:	c6 05 bd e2 2b f0 8e 	movb   $0x8e,0xf02be2bd
f0103c3d:	c1 e8 10             	shr    $0x10,%eax
f0103c40:	66 a3 be e2 2b f0    	mov    %ax,0xf02be2be
	SETGATE(idt[T_STACK], 0, GD_KT, handler12, 0);
f0103c46:	b8 46 44 10 f0       	mov    $0xf0104446,%eax
f0103c4b:	66 a3 c0 e2 2b f0    	mov    %ax,0xf02be2c0
f0103c51:	66 c7 05 c2 e2 2b f0 	movw   $0x8,0xf02be2c2
f0103c58:	08 00 
f0103c5a:	c6 05 c4 e2 2b f0 00 	movb   $0x0,0xf02be2c4
f0103c61:	c6 05 c5 e2 2b f0 8e 	movb   $0x8e,0xf02be2c5
f0103c68:	c1 e8 10             	shr    $0x10,%eax
f0103c6b:	66 a3 c6 e2 2b f0    	mov    %ax,0xf02be2c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, handler13, 0);
f0103c71:	b8 4a 44 10 f0       	mov    $0xf010444a,%eax
f0103c76:	66 a3 c8 e2 2b f0    	mov    %ax,0xf02be2c8
f0103c7c:	66 c7 05 ca e2 2b f0 	movw   $0x8,0xf02be2ca
f0103c83:	08 00 
f0103c85:	c6 05 cc e2 2b f0 00 	movb   $0x0,0xf02be2cc
f0103c8c:	c6 05 cd e2 2b f0 8e 	movb   $0x8e,0xf02be2cd
f0103c93:	c1 e8 10             	shr    $0x10,%eax
f0103c96:	66 a3 ce e2 2b f0    	mov    %ax,0xf02be2ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, handler14, 0);
f0103c9c:	b8 4e 44 10 f0       	mov    $0xf010444e,%eax
f0103ca1:	66 a3 d0 e2 2b f0    	mov    %ax,0xf02be2d0
f0103ca7:	66 c7 05 d2 e2 2b f0 	movw   $0x8,0xf02be2d2
f0103cae:	08 00 
f0103cb0:	c6 05 d4 e2 2b f0 00 	movb   $0x0,0xf02be2d4
f0103cb7:	c6 05 d5 e2 2b f0 8e 	movb   $0x8e,0xf02be2d5
f0103cbe:	c1 e8 10             	shr    $0x10,%eax
f0103cc1:	66 a3 d6 e2 2b f0    	mov    %ax,0xf02be2d6
	SETGATE(idt[T_FPERR], 0, GD_KT, handler16, 0);
f0103cc7:	b8 52 44 10 f0       	mov    $0xf0104452,%eax
f0103ccc:	66 a3 e0 e2 2b f0    	mov    %ax,0xf02be2e0
f0103cd2:	66 c7 05 e2 e2 2b f0 	movw   $0x8,0xf02be2e2
f0103cd9:	08 00 
f0103cdb:	c6 05 e4 e2 2b f0 00 	movb   $0x0,0xf02be2e4
f0103ce2:	c6 05 e5 e2 2b f0 8e 	movb   $0x8e,0xf02be2e5
f0103ce9:	c1 e8 10             	shr    $0x10,%eax
f0103cec:	66 a3 e6 e2 2b f0    	mov    %ax,0xf02be2e6
	SETGATE(idt[T_SYSCALL], 0, GD_KT, handler48, 3);
f0103cf2:	b8 58 44 10 f0       	mov    $0xf0104458,%eax
f0103cf7:	66 a3 e0 e3 2b f0    	mov    %ax,0xf02be3e0
f0103cfd:	66 c7 05 e2 e3 2b f0 	movw   $0x8,0xf02be3e2
f0103d04:	08 00 
f0103d06:	c6 05 e4 e3 2b f0 00 	movb   $0x0,0xf02be3e4
f0103d0d:	c6 05 e5 e3 2b f0 ee 	movb   $0xee,0xf02be3e5
f0103d14:	c1 e8 10             	shr    $0x10,%eax
f0103d17:	66 a3 e6 e3 2b f0    	mov    %ax,0xf02be3e6
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER], 0, GD_KT, handler32, 0);
f0103d1d:	b8 5e 44 10 f0       	mov    $0xf010445e,%eax
f0103d22:	66 a3 60 e3 2b f0    	mov    %ax,0xf02be360
f0103d28:	66 c7 05 62 e3 2b f0 	movw   $0x8,0xf02be362
f0103d2f:	08 00 
f0103d31:	c6 05 64 e3 2b f0 00 	movb   $0x0,0xf02be364
f0103d38:	c6 05 65 e3 2b f0 8e 	movb   $0x8e,0xf02be365
f0103d3f:	c1 e8 10             	shr    $0x10,%eax
f0103d42:	66 a3 66 e3 2b f0    	mov    %ax,0xf02be366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD], 0, GD_KT, handler33, 0);
f0103d48:	b8 64 44 10 f0       	mov    $0xf0104464,%eax
f0103d4d:	66 a3 68 e3 2b f0    	mov    %ax,0xf02be368
f0103d53:	66 c7 05 6a e3 2b f0 	movw   $0x8,0xf02be36a
f0103d5a:	08 00 
f0103d5c:	c6 05 6c e3 2b f0 00 	movb   $0x0,0xf02be36c
f0103d63:	c6 05 6d e3 2b f0 8e 	movb   $0x8e,0xf02be36d
f0103d6a:	c1 e8 10             	shr    $0x10,%eax
f0103d6d:	66 a3 6e e3 2b f0    	mov    %ax,0xf02be36e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL], 0, GD_KT, handler36, 0);
f0103d73:	b8 6a 44 10 f0       	mov    $0xf010446a,%eax
f0103d78:	66 a3 80 e3 2b f0    	mov    %ax,0xf02be380
f0103d7e:	66 c7 05 82 e3 2b f0 	movw   $0x8,0xf02be382
f0103d85:	08 00 
f0103d87:	c6 05 84 e3 2b f0 00 	movb   $0x0,0xf02be384
f0103d8e:	c6 05 85 e3 2b f0 8e 	movb   $0x8e,0xf02be385
f0103d95:	c1 e8 10             	shr    $0x10,%eax
f0103d98:	66 a3 86 e3 2b f0    	mov    %ax,0xf02be386
	SETGATE(idt[IRQ_OFFSET+IRQ_SPURIOUS], 0, GD_KT, handler39, 0);
f0103d9e:	b8 70 44 10 f0       	mov    $0xf0104470,%eax
f0103da3:	66 a3 98 e3 2b f0    	mov    %ax,0xf02be398
f0103da9:	66 c7 05 9a e3 2b f0 	movw   $0x8,0xf02be39a
f0103db0:	08 00 
f0103db2:	c6 05 9c e3 2b f0 00 	movb   $0x0,0xf02be39c
f0103db9:	c6 05 9d e3 2b f0 8e 	movb   $0x8e,0xf02be39d
f0103dc0:	c1 e8 10             	shr    $0x10,%eax
f0103dc3:	66 a3 9e e3 2b f0    	mov    %ax,0xf02be39e
	SETGATE(idt[IRQ_OFFSET+IRQ_IDE], 0, GD_KT, handler46, 0);
f0103dc9:	b8 76 44 10 f0       	mov    $0xf0104476,%eax
f0103dce:	66 a3 d0 e3 2b f0    	mov    %ax,0xf02be3d0
f0103dd4:	66 c7 05 d2 e3 2b f0 	movw   $0x8,0xf02be3d2
f0103ddb:	08 00 
f0103ddd:	c6 05 d4 e3 2b f0 00 	movb   $0x0,0xf02be3d4
f0103de4:	c6 05 d5 e3 2b f0 8e 	movb   $0x8e,0xf02be3d5
f0103deb:	c1 e8 10             	shr    $0x10,%eax
f0103dee:	66 a3 d6 e3 2b f0    	mov    %ax,0xf02be3d6
	SETGATE(idt[IRQ_OFFSET+IRQ_ERROR], 0, GD_KT, handler51, 0);
f0103df4:	b8 7c 44 10 f0       	mov    $0xf010447c,%eax
f0103df9:	66 a3 f8 e3 2b f0    	mov    %ax,0xf02be3f8
f0103dff:	66 c7 05 fa e3 2b f0 	movw   $0x8,0xf02be3fa
f0103e06:	08 00 
f0103e08:	c6 05 fc e3 2b f0 00 	movb   $0x0,0xf02be3fc
f0103e0f:	c6 05 fd e3 2b f0 8e 	movb   $0x8e,0xf02be3fd
f0103e16:	c1 e8 10             	shr    $0x10,%eax
f0103e19:	66 a3 fe e3 2b f0    	mov    %ax,0xf02be3fe
	trap_init_percpu();
f0103e1f:	e8 5b fb ff ff       	call   f010397f <trap_init_percpu>
}
f0103e24:	c9                   	leave  
f0103e25:	c3                   	ret    

f0103e26 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103e26:	f3 0f 1e fb          	endbr32 
f0103e2a:	55                   	push   %ebp
f0103e2b:	89 e5                	mov    %esp,%ebp
f0103e2d:	53                   	push   %ebx
f0103e2e:	83 ec 0c             	sub    $0xc,%esp
f0103e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103e34:	ff 33                	pushl  (%ebx)
f0103e36:	68 12 7d 10 f0       	push   $0xf0107d12
f0103e3b:	e8 27 fb ff ff       	call   f0103967 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103e40:	83 c4 08             	add    $0x8,%esp
f0103e43:	ff 73 04             	pushl  0x4(%ebx)
f0103e46:	68 21 7d 10 f0       	push   $0xf0107d21
f0103e4b:	e8 17 fb ff ff       	call   f0103967 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103e50:	83 c4 08             	add    $0x8,%esp
f0103e53:	ff 73 08             	pushl  0x8(%ebx)
f0103e56:	68 30 7d 10 f0       	push   $0xf0107d30
f0103e5b:	e8 07 fb ff ff       	call   f0103967 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103e60:	83 c4 08             	add    $0x8,%esp
f0103e63:	ff 73 0c             	pushl  0xc(%ebx)
f0103e66:	68 3f 7d 10 f0       	push   $0xf0107d3f
f0103e6b:	e8 f7 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103e70:	83 c4 08             	add    $0x8,%esp
f0103e73:	ff 73 10             	pushl  0x10(%ebx)
f0103e76:	68 4e 7d 10 f0       	push   $0xf0107d4e
f0103e7b:	e8 e7 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103e80:	83 c4 08             	add    $0x8,%esp
f0103e83:	ff 73 14             	pushl  0x14(%ebx)
f0103e86:	68 5d 7d 10 f0       	push   $0xf0107d5d
f0103e8b:	e8 d7 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103e90:	83 c4 08             	add    $0x8,%esp
f0103e93:	ff 73 18             	pushl  0x18(%ebx)
f0103e96:	68 6c 7d 10 f0       	push   $0xf0107d6c
f0103e9b:	e8 c7 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103ea0:	83 c4 08             	add    $0x8,%esp
f0103ea3:	ff 73 1c             	pushl  0x1c(%ebx)
f0103ea6:	68 7b 7d 10 f0       	push   $0xf0107d7b
f0103eab:	e8 b7 fa ff ff       	call   f0103967 <cprintf>
}
f0103eb0:	83 c4 10             	add    $0x10,%esp
f0103eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103eb6:	c9                   	leave  
f0103eb7:	c3                   	ret    

f0103eb8 <print_trapframe>:
{
f0103eb8:	f3 0f 1e fb          	endbr32 
f0103ebc:	55                   	push   %ebp
f0103ebd:	89 e5                	mov    %esp,%ebp
f0103ebf:	56                   	push   %esi
f0103ec0:	53                   	push   %ebx
f0103ec1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103ec4:	e8 05 1f 00 00       	call   f0105dce <cpunum>
f0103ec9:	83 ec 04             	sub    $0x4,%esp
f0103ecc:	50                   	push   %eax
f0103ecd:	53                   	push   %ebx
f0103ece:	68 df 7d 10 f0       	push   $0xf0107ddf
f0103ed3:	e8 8f fa ff ff       	call   f0103967 <cprintf>
	print_regs(&tf->tf_regs);
f0103ed8:	89 1c 24             	mov    %ebx,(%esp)
f0103edb:	e8 46 ff ff ff       	call   f0103e26 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103ee0:	83 c4 08             	add    $0x8,%esp
f0103ee3:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0103ee7:	50                   	push   %eax
f0103ee8:	68 fd 7d 10 f0       	push   $0xf0107dfd
f0103eed:	e8 75 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0103ef2:	83 c4 08             	add    $0x8,%esp
f0103ef5:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103ef9:	50                   	push   %eax
f0103efa:	68 10 7e 10 f0       	push   $0xf0107e10
f0103eff:	e8 63 fa ff ff       	call   f0103967 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f04:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0103f07:	83 c4 10             	add    $0x10,%esp
f0103f0a:	83 f8 13             	cmp    $0x13,%eax
f0103f0d:	0f 86 da 00 00 00    	jbe    f0103fed <print_trapframe+0x135>
		return "System call";
f0103f13:	ba 8a 7d 10 f0       	mov    $0xf0107d8a,%edx
	if (trapno == T_SYSCALL)
f0103f18:	83 f8 30             	cmp    $0x30,%eax
f0103f1b:	74 13                	je     f0103f30 <print_trapframe+0x78>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0103f1d:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f0103f20:	83 fa 0f             	cmp    $0xf,%edx
f0103f23:	ba 96 7d 10 f0       	mov    $0xf0107d96,%edx
f0103f28:	b9 a5 7d 10 f0       	mov    $0xf0107da5,%ecx
f0103f2d:	0f 46 d1             	cmovbe %ecx,%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103f30:	83 ec 04             	sub    $0x4,%esp
f0103f33:	52                   	push   %edx
f0103f34:	50                   	push   %eax
f0103f35:	68 23 7e 10 f0       	push   $0xf0107e23
f0103f3a:	e8 28 fa ff ff       	call   f0103967 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103f3f:	83 c4 10             	add    $0x10,%esp
f0103f42:	39 1d 60 ea 2b f0    	cmp    %ebx,0xf02bea60
f0103f48:	0f 84 ab 00 00 00    	je     f0103ff9 <print_trapframe+0x141>
	cprintf("  err  0x%08x", tf->tf_err);
f0103f4e:	83 ec 08             	sub    $0x8,%esp
f0103f51:	ff 73 2c             	pushl  0x2c(%ebx)
f0103f54:	68 44 7e 10 f0       	push   $0xf0107e44
f0103f59:	e8 09 fa ff ff       	call   f0103967 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0103f5e:	83 c4 10             	add    $0x10,%esp
f0103f61:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103f65:	0f 85 b1 00 00 00    	jne    f010401c <print_trapframe+0x164>
			tf->tf_err & 1 ? "protection" : "not-present");
f0103f6b:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0103f6e:	a8 01                	test   $0x1,%al
f0103f70:	b9 b8 7d 10 f0       	mov    $0xf0107db8,%ecx
f0103f75:	ba c3 7d 10 f0       	mov    $0xf0107dc3,%edx
f0103f7a:	0f 44 ca             	cmove  %edx,%ecx
f0103f7d:	a8 02                	test   $0x2,%al
f0103f7f:	be cf 7d 10 f0       	mov    $0xf0107dcf,%esi
f0103f84:	ba d5 7d 10 f0       	mov    $0xf0107dd5,%edx
f0103f89:	0f 45 d6             	cmovne %esi,%edx
f0103f8c:	a8 04                	test   $0x4,%al
f0103f8e:	b8 da 7d 10 f0       	mov    $0xf0107dda,%eax
f0103f93:	be 0f 7f 10 f0       	mov    $0xf0107f0f,%esi
f0103f98:	0f 44 c6             	cmove  %esi,%eax
f0103f9b:	51                   	push   %ecx
f0103f9c:	52                   	push   %edx
f0103f9d:	50                   	push   %eax
f0103f9e:	68 52 7e 10 f0       	push   $0xf0107e52
f0103fa3:	e8 bf f9 ff ff       	call   f0103967 <cprintf>
f0103fa8:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103fab:	83 ec 08             	sub    $0x8,%esp
f0103fae:	ff 73 30             	pushl  0x30(%ebx)
f0103fb1:	68 61 7e 10 f0       	push   $0xf0107e61
f0103fb6:	e8 ac f9 ff ff       	call   f0103967 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103fbb:	83 c4 08             	add    $0x8,%esp
f0103fbe:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103fc2:	50                   	push   %eax
f0103fc3:	68 70 7e 10 f0       	push   $0xf0107e70
f0103fc8:	e8 9a f9 ff ff       	call   f0103967 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103fcd:	83 c4 08             	add    $0x8,%esp
f0103fd0:	ff 73 38             	pushl  0x38(%ebx)
f0103fd3:	68 83 7e 10 f0       	push   $0xf0107e83
f0103fd8:	e8 8a f9 ff ff       	call   f0103967 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0103fdd:	83 c4 10             	add    $0x10,%esp
f0103fe0:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103fe4:	75 4b                	jne    f0104031 <print_trapframe+0x179>
}
f0103fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0103fe9:	5b                   	pop    %ebx
f0103fea:	5e                   	pop    %esi
f0103feb:	5d                   	pop    %ebp
f0103fec:	c3                   	ret    
		return excnames[trapno];
f0103fed:	8b 14 85 c0 80 10 f0 	mov    -0xfef7f40(,%eax,4),%edx
f0103ff4:	e9 37 ff ff ff       	jmp    f0103f30 <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0103ff9:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0103ffd:	0f 85 4b ff ff ff    	jne    f0103f4e <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104003:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104006:	83 ec 08             	sub    $0x8,%esp
f0104009:	50                   	push   %eax
f010400a:	68 35 7e 10 f0       	push   $0xf0107e35
f010400f:	e8 53 f9 ff ff       	call   f0103967 <cprintf>
f0104014:	83 c4 10             	add    $0x10,%esp
f0104017:	e9 32 ff ff ff       	jmp    f0103f4e <print_trapframe+0x96>
		cprintf("\n");
f010401c:	83 ec 0c             	sub    $0xc,%esp
f010401f:	68 6f 72 10 f0       	push   $0xf010726f
f0104024:	e8 3e f9 ff ff       	call   f0103967 <cprintf>
f0104029:	83 c4 10             	add    $0x10,%esp
f010402c:	e9 7a ff ff ff       	jmp    f0103fab <print_trapframe+0xf3>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104031:	83 ec 08             	sub    $0x8,%esp
f0104034:	ff 73 3c             	pushl  0x3c(%ebx)
f0104037:	68 92 7e 10 f0       	push   $0xf0107e92
f010403c:	e8 26 f9 ff ff       	call   f0103967 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104041:	83 c4 08             	add    $0x8,%esp
f0104044:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104048:	50                   	push   %eax
f0104049:	68 a1 7e 10 f0       	push   $0xf0107ea1
f010404e:	e8 14 f9 ff ff       	call   f0103967 <cprintf>
f0104053:	83 c4 10             	add    $0x10,%esp
}
f0104056:	eb 8e                	jmp    f0103fe6 <print_trapframe+0x12e>

f0104058 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104058:	f3 0f 1e fb          	endbr32 
f010405c:	55                   	push   %ebp
f010405d:	89 e5                	mov    %esp,%ebp
f010405f:	57                   	push   %edi
f0104060:	56                   	push   %esi
f0104061:	53                   	push   %ebx
f0104062:	83 ec 0c             	sub    $0xc,%esp
f0104065:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104068:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if(!(tf->tf_cs && 0x01)) panic("kernel-mode page fault, fault address %d\n", fault_va);
f010406b:	66 83 7b 34 00       	cmpw   $0x0,0x34(%ebx)
f0104070:	74 5d                	je     f01040cf <page_fault_handler+0x77>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	if(curenv->env_pgfault_upcall){
f0104072:	e8 57 1d 00 00       	call   f0105dce <cpunum>
f0104077:	6b c0 74             	imul   $0x74,%eax,%eax
f010407a:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104080:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104084:	75 5e                	jne    f01040e4 <page_fault_handler+0x8c>
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
		curenv->env_tf.tf_esp = (uintptr_t)utf;
		env_run(curenv);
	}
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104086:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104089:	e8 40 1d 00 00       	call   f0105dce <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f010408e:	57                   	push   %edi
f010408f:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f0104090:	6b c0 74             	imul   $0x74,%eax,%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104093:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104099:	ff 70 48             	pushl  0x48(%eax)
f010409c:	68 88 80 10 f0       	push   $0xf0108088
f01040a1:	e8 c1 f8 ff ff       	call   f0103967 <cprintf>
	print_trapframe(tf);
f01040a6:	89 1c 24             	mov    %ebx,(%esp)
f01040a9:	e8 0a fe ff ff       	call   f0103eb8 <print_trapframe>
	env_destroy(curenv);
f01040ae:	e8 1b 1d 00 00       	call   f0105dce <cpunum>
f01040b3:	83 c4 04             	add    $0x4,%esp
f01040b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01040b9:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f01040bf:	e8 68 f5 ff ff       	call   f010362c <env_destroy>
}
f01040c4:	83 c4 10             	add    $0x10,%esp
f01040c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01040ca:	5b                   	pop    %ebx
f01040cb:	5e                   	pop    %esi
f01040cc:	5f                   	pop    %edi
f01040cd:	5d                   	pop    %ebp
f01040ce:	c3                   	ret    
	if(!(tf->tf_cs && 0x01)) panic("kernel-mode page fault, fault address %d\n", fault_va);
f01040cf:	56                   	push   %esi
f01040d0:	68 5c 80 10 f0       	push   $0xf010805c
f01040d5:	68 74 01 00 00       	push   $0x174
f01040da:	68 b4 7e 10 f0       	push   $0xf0107eb4
f01040df:	e8 5c bf ff ff       	call   f0100040 <_panic>
		if(tf->tf_esp >=  UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP){
f01040e4:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01040e7:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf = (struct UTrapframe *)(UXSTACKTOP- sizeof(struct UTrapframe));
f01040ed:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if(tf->tf_esp >=  UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP){
f01040f2:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01040f8:	77 05                	ja     f01040ff <page_fault_handler+0xa7>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(struct UTrapframe) - 4);
f01040fa:	83 e8 38             	sub    $0x38,%eax
f01040fd:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, utf, 1, PTE_W);
f01040ff:	e8 ca 1c 00 00       	call   f0105dce <cpunum>
f0104104:	6a 02                	push   $0x2
f0104106:	6a 01                	push   $0x1
f0104108:	57                   	push   %edi
f0104109:	6b c0 74             	imul   $0x74,%eax,%eax
f010410c:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104112:	e8 bc ee ff ff       	call   f0102fd3 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104117:	89 fa                	mov    %edi,%edx
f0104119:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_trapno;
f010411b:	8b 43 28             	mov    0x28(%ebx),%eax
f010411e:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104121:	8d 7f 08             	lea    0x8(%edi),%edi
f0104124:	b9 08 00 00 00       	mov    $0x8,%ecx
f0104129:	89 de                	mov    %ebx,%esi
f010412b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f010412d:	8b 43 30             	mov    0x30(%ebx),%eax
f0104130:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104133:	8b 43 38             	mov    0x38(%ebx),%eax
f0104136:	89 d7                	mov    %edx,%edi
f0104138:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f010413b:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010413e:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0104141:	e8 88 1c 00 00       	call   f0105dce <cpunum>
f0104146:	6b c0 74             	imul   $0x74,%eax,%eax
f0104149:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f010414f:	8b 58 64             	mov    0x64(%eax),%ebx
f0104152:	e8 77 1c 00 00       	call   f0105dce <cpunum>
f0104157:	6b c0 74             	imul   $0x74,%eax,%eax
f010415a:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104160:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uintptr_t)utf;
f0104163:	e8 66 1c 00 00       	call   f0105dce <cpunum>
f0104168:	6b c0 74             	imul   $0x74,%eax,%eax
f010416b:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104171:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104174:	e8 55 1c 00 00       	call   f0105dce <cpunum>
f0104179:	83 c4 04             	add    $0x4,%esp
f010417c:	6b c0 74             	imul   $0x74,%eax,%eax
f010417f:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104185:	e8 49 f5 ff ff       	call   f01036d3 <env_run>

f010418a <trap>:
{
f010418a:	f3 0f 1e fb          	endbr32 
f010418e:	55                   	push   %ebp
f010418f:	89 e5                	mov    %esp,%ebp
f0104191:	57                   	push   %edi
f0104192:	56                   	push   %esi
f0104193:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f0104196:	fc                   	cld    
	if (panicstr)
f0104197:	83 3d 8c ee 2b f0 00 	cmpl   $0x0,0xf02bee8c
f010419e:	74 01                	je     f01041a1 <trap+0x17>
		asm volatile("hlt");
f01041a0:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01041a1:	e8 28 1c 00 00       	call   f0105dce <cpunum>
f01041a6:	6b d0 74             	imul   $0x74,%eax,%edx
f01041a9:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f01041ac:	b8 01 00 00 00       	mov    $0x1,%eax
f01041b1:	f0 87 82 20 f0 2b f0 	lock xchg %eax,-0xfd40fe0(%edx)
f01041b8:	83 f8 02             	cmp    $0x2,%eax
f01041bb:	0f 84 c2 00 00 00    	je     f0104283 <trap+0xf9>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f01041c1:	9c                   	pushf  
f01041c2:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f01041c3:	f6 c4 02             	test   $0x2,%ah
f01041c6:	0f 85 cc 00 00 00    	jne    f0104298 <trap+0x10e>
	if ((tf->tf_cs & 3) == 3) {
f01041cc:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f01041d0:	83 e0 03             	and    $0x3,%eax
f01041d3:	66 83 f8 03          	cmp    $0x3,%ax
f01041d7:	0f 84 d4 00 00 00    	je     f01042b1 <trap+0x127>
	last_tf = tf;
f01041dd:	89 35 60 ea 2b f0    	mov    %esi,0xf02bea60
	if (tf->tf_trapno == T_PGFLT) {
f01041e3:	8b 46 28             	mov    0x28(%esi),%eax
f01041e6:	83 f8 0e             	cmp    $0xe,%eax
f01041e9:	0f 84 67 01 00 00    	je     f0104356 <trap+0x1cc>
	if (tf->tf_trapno == T_BRKPT) {
f01041ef:	83 f8 03             	cmp    $0x3,%eax
f01041f2:	0f 84 6f 01 00 00    	je     f0104367 <trap+0x1dd>
	if (tf->tf_trapno == T_SYSCALL) {
f01041f8:	83 f8 30             	cmp    $0x30,%eax
f01041fb:	0f 84 77 01 00 00    	je     f0104378 <trap+0x1ee>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104201:	83 f8 27             	cmp    $0x27,%eax
f0104204:	0f 84 92 01 00 00    	je     f010439c <trap+0x212>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f010420a:	83 f8 20             	cmp    $0x20,%eax
f010420d:	0f 84 a6 01 00 00    	je     f01043b9 <trap+0x22f>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD){
f0104213:	83 f8 21             	cmp    $0x21,%eax
f0104216:	0f 84 ac 01 00 00    	je     f01043c8 <trap+0x23e>
	else if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL){
f010421c:	83 f8 24             	cmp    $0x24,%eax
f010421f:	0f 84 ad 01 00 00    	je     f01043d2 <trap+0x248>
	print_trapframe(tf);
f0104225:	83 ec 0c             	sub    $0xc,%esp
f0104228:	56                   	push   %esi
f0104229:	e8 8a fc ff ff       	call   f0103eb8 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f010422e:	83 c4 10             	add    $0x10,%esp
f0104231:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104236:	0f 84 a0 01 00 00    	je     f01043dc <trap+0x252>
		env_destroy(curenv);
f010423c:	e8 8d 1b 00 00       	call   f0105dce <cpunum>
f0104241:	83 ec 0c             	sub    $0xc,%esp
f0104244:	6b c0 74             	imul   $0x74,%eax,%eax
f0104247:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f010424d:	e8 da f3 ff ff       	call   f010362c <env_destroy>
		return;
f0104252:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104255:	e8 74 1b 00 00       	call   f0105dce <cpunum>
f010425a:	6b c0 74             	imul   $0x74,%eax,%eax
f010425d:	83 b8 28 f0 2b f0 00 	cmpl   $0x0,-0xfd40fd8(%eax)
f0104264:	74 18                	je     f010427e <trap+0xf4>
f0104266:	e8 63 1b 00 00       	call   f0105dce <cpunum>
f010426b:	6b c0 74             	imul   $0x74,%eax,%eax
f010426e:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104274:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104278:	0f 84 75 01 00 00    	je     f01043f3 <trap+0x269>
		sched_yield();
f010427e:	e8 e0 02 00 00       	call   f0104563 <sched_yield>
	spin_lock(&kernel_lock);
f0104283:	83 ec 0c             	sub    $0xc,%esp
f0104286:	68 c0 53 12 f0       	push   $0xf01253c0
f010428b:	e8 c6 1d 00 00       	call   f0106056 <spin_lock>
}
f0104290:	83 c4 10             	add    $0x10,%esp
f0104293:	e9 29 ff ff ff       	jmp    f01041c1 <trap+0x37>
	assert(!(read_eflags() & FL_IF));
f0104298:	68 c0 7e 10 f0       	push   $0xf0107ec0
f010429d:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01042a2:	68 3f 01 00 00       	push   $0x13f
f01042a7:	68 b4 7e 10 f0       	push   $0xf0107eb4
f01042ac:	e8 8f bd ff ff       	call   f0100040 <_panic>
	spin_lock(&kernel_lock);
f01042b1:	83 ec 0c             	sub    $0xc,%esp
f01042b4:	68 c0 53 12 f0       	push   $0xf01253c0
f01042b9:	e8 98 1d 00 00       	call   f0106056 <spin_lock>
		assert(curenv);
f01042be:	e8 0b 1b 00 00       	call   f0105dce <cpunum>
f01042c3:	6b c0 74             	imul   $0x74,%eax,%eax
f01042c6:	83 c4 10             	add    $0x10,%esp
f01042c9:	83 b8 28 f0 2b f0 00 	cmpl   $0x0,-0xfd40fd8(%eax)
f01042d0:	74 3e                	je     f0104310 <trap+0x186>
		if (curenv->env_status == ENV_DYING) {
f01042d2:	e8 f7 1a 00 00       	call   f0105dce <cpunum>
f01042d7:	6b c0 74             	imul   $0x74,%eax,%eax
f01042da:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01042e0:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01042e4:	74 43                	je     f0104329 <trap+0x19f>
		curenv->env_tf = *tf;
f01042e6:	e8 e3 1a 00 00       	call   f0105dce <cpunum>
f01042eb:	6b c0 74             	imul   $0x74,%eax,%eax
f01042ee:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01042f4:	b9 11 00 00 00       	mov    $0x11,%ecx
f01042f9:	89 c7                	mov    %eax,%edi
f01042fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01042fd:	e8 cc 1a 00 00       	call   f0105dce <cpunum>
f0104302:	6b c0 74             	imul   $0x74,%eax,%eax
f0104305:	8b b0 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%esi
f010430b:	e9 cd fe ff ff       	jmp    f01041dd <trap+0x53>
		assert(curenv);
f0104310:	68 d9 7e 10 f0       	push   $0xf0107ed9
f0104315:	68 b5 6f 10 f0       	push   $0xf0106fb5
f010431a:	68 47 01 00 00       	push   $0x147
f010431f:	68 b4 7e 10 f0       	push   $0xf0107eb4
f0104324:	e8 17 bd ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f0104329:	e8 a0 1a 00 00       	call   f0105dce <cpunum>
f010432e:	83 ec 0c             	sub    $0xc,%esp
f0104331:	6b c0 74             	imul   $0x74,%eax,%eax
f0104334:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f010433a:	e8 3f f1 ff ff       	call   f010347e <env_free>
			curenv = NULL;
f010433f:	e8 8a 1a 00 00       	call   f0105dce <cpunum>
f0104344:	6b c0 74             	imul   $0x74,%eax,%eax
f0104347:	c7 80 28 f0 2b f0 00 	movl   $0x0,-0xfd40fd8(%eax)
f010434e:	00 00 00 
			sched_yield();
f0104351:	e8 0d 02 00 00       	call   f0104563 <sched_yield>
		return page_fault_handler(tf);
f0104356:	83 ec 0c             	sub    $0xc,%esp
f0104359:	56                   	push   %esi
f010435a:	e8 f9 fc ff ff       	call   f0104058 <page_fault_handler>
f010435f:	83 c4 10             	add    $0x10,%esp
f0104362:	e9 ee fe ff ff       	jmp    f0104255 <trap+0xcb>
		return monitor(tf);
f0104367:	83 ec 0c             	sub    $0xc,%esp
f010436a:	56                   	push   %esi
f010436b:	e8 09 c6 ff ff       	call   f0100979 <monitor>
f0104370:	83 c4 10             	add    $0x10,%esp
f0104373:	e9 dd fe ff ff       	jmp    f0104255 <trap+0xcb>
		tf->tf_regs.reg_eax = syscall(
f0104378:	83 ec 08             	sub    $0x8,%esp
f010437b:	ff 76 04             	pushl  0x4(%esi)
f010437e:	ff 36                	pushl  (%esi)
f0104380:	ff 76 10             	pushl  0x10(%esi)
f0104383:	ff 76 18             	pushl  0x18(%esi)
f0104386:	ff 76 14             	pushl  0x14(%esi)
f0104389:	ff 76 1c             	pushl  0x1c(%esi)
f010438c:	e8 6f 02 00 00       	call   f0104600 <syscall>
f0104391:	89 46 1c             	mov    %eax,0x1c(%esi)
		return;
f0104394:	83 c4 20             	add    $0x20,%esp
f0104397:	e9 b9 fe ff ff       	jmp    f0104255 <trap+0xcb>
		cprintf("Spurious interrupt on irq 7\n");
f010439c:	83 ec 0c             	sub    $0xc,%esp
f010439f:	68 e0 7e 10 f0       	push   $0xf0107ee0
f01043a4:	e8 be f5 ff ff       	call   f0103967 <cprintf>
		print_trapframe(tf);
f01043a9:	89 34 24             	mov    %esi,(%esp)
f01043ac:	e8 07 fb ff ff       	call   f0103eb8 <print_trapframe>
		return;
f01043b1:	83 c4 10             	add    $0x10,%esp
f01043b4:	e9 9c fe ff ff       	jmp    f0104255 <trap+0xcb>
		lapic_eoi();
f01043b9:	e8 5f 1b 00 00       	call   f0105f1d <lapic_eoi>
		time_tick();
f01043be:	e8 83 23 00 00       	call   f0106746 <time_tick>
		sched_yield();
f01043c3:	e8 9b 01 00 00       	call   f0104563 <sched_yield>
		kbd_intr();
f01043c8:	e8 3a c2 ff ff       	call   f0100607 <kbd_intr>
		return;
f01043cd:	e9 83 fe ff ff       	jmp    f0104255 <trap+0xcb>
		serial_intr();
f01043d2:	e8 10 c2 ff ff       	call   f01005e7 <serial_intr>
		return;
f01043d7:	e9 79 fe ff ff       	jmp    f0104255 <trap+0xcb>
		panic("unhandled trap in kernel");
f01043dc:	83 ec 04             	sub    $0x4,%esp
f01043df:	68 fd 7e 10 f0       	push   $0xf0107efd
f01043e4:	68 24 01 00 00       	push   $0x124
f01043e9:	68 b4 7e 10 f0       	push   $0xf0107eb4
f01043ee:	e8 4d bc ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f01043f3:	e8 d6 19 00 00       	call   f0105dce <cpunum>
f01043f8:	83 ec 0c             	sub    $0xc,%esp
f01043fb:	6b c0 74             	imul   $0x74,%eax,%eax
f01043fe:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104404:	e8 ca f2 ff ff       	call   f01036d3 <env_run>
f0104409:	90                   	nop

f010440a <handler0>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
 
TRAPHANDLER_NOEC(handler0, T_DIVIDE)
f010440a:	6a 00                	push   $0x0
f010440c:	6a 00                	push   $0x0
f010440e:	eb 72                	jmp    f0104482 <_alltraps>

f0104410 <handler1>:
TRAPHANDLER_NOEC(handler1, T_DEBUG)
f0104410:	6a 00                	push   $0x0
f0104412:	6a 01                	push   $0x1
f0104414:	eb 6c                	jmp    f0104482 <_alltraps>

f0104416 <handler2>:
TRAPHANDLER_NOEC(handler2, T_NMI)
f0104416:	6a 00                	push   $0x0
f0104418:	6a 02                	push   $0x2
f010441a:	eb 66                	jmp    f0104482 <_alltraps>

f010441c <handler3>:
TRAPHANDLER_NOEC(handler3, T_BRKPT)
f010441c:	6a 00                	push   $0x0
f010441e:	6a 03                	push   $0x3
f0104420:	eb 60                	jmp    f0104482 <_alltraps>

f0104422 <handler4>:
TRAPHANDLER_NOEC(handler4, T_OFLOW)
f0104422:	6a 00                	push   $0x0
f0104424:	6a 04                	push   $0x4
f0104426:	eb 5a                	jmp    f0104482 <_alltraps>

f0104428 <handler5>:
TRAPHANDLER_NOEC(handler5, T_BOUND)
f0104428:	6a 00                	push   $0x0
f010442a:	6a 05                	push   $0x5
f010442c:	eb 54                	jmp    f0104482 <_alltraps>

f010442e <handler6>:
TRAPHANDLER_NOEC(handler6, T_ILLOP)
f010442e:	6a 00                	push   $0x0
f0104430:	6a 06                	push   $0x6
f0104432:	eb 4e                	jmp    f0104482 <_alltraps>

f0104434 <handler7>:
TRAPHANDLER(handler7, T_DEVICE)
f0104434:	6a 07                	push   $0x7
f0104436:	eb 4a                	jmp    f0104482 <_alltraps>

f0104438 <handler8>:
TRAPHANDLER_NOEC(handler8, T_DBLFLT)
f0104438:	6a 00                	push   $0x0
f010443a:	6a 08                	push   $0x8
f010443c:	eb 44                	jmp    f0104482 <_alltraps>

f010443e <handler10>:
TRAPHANDLER(handler10, T_TSS)
f010443e:	6a 0a                	push   $0xa
f0104440:	eb 40                	jmp    f0104482 <_alltraps>

f0104442 <handler11>:
TRAPHANDLER(handler11, T_SEGNP)
f0104442:	6a 0b                	push   $0xb
f0104444:	eb 3c                	jmp    f0104482 <_alltraps>

f0104446 <handler12>:
TRAPHANDLER(handler12, T_STACK)
f0104446:	6a 0c                	push   $0xc
f0104448:	eb 38                	jmp    f0104482 <_alltraps>

f010444a <handler13>:
TRAPHANDLER(handler13, T_GPFLT)
f010444a:	6a 0d                	push   $0xd
f010444c:	eb 34                	jmp    f0104482 <_alltraps>

f010444e <handler14>:
TRAPHANDLER(handler14, T_PGFLT)
f010444e:	6a 0e                	push   $0xe
f0104450:	eb 30                	jmp    f0104482 <_alltraps>

f0104452 <handler16>:
TRAPHANDLER_NOEC(handler16, T_FPERR)
f0104452:	6a 00                	push   $0x0
f0104454:	6a 10                	push   $0x10
f0104456:	eb 2a                	jmp    f0104482 <_alltraps>

f0104458 <handler48>:
TRAPHANDLER_NOEC(handler48, T_SYSCALL)
f0104458:	6a 00                	push   $0x0
f010445a:	6a 30                	push   $0x30
f010445c:	eb 24                	jmp    f0104482 <_alltraps>

f010445e <handler32>:

TRAPHANDLER_NOEC(handler32, IRQ_OFFSET + IRQ_TIMER)
f010445e:	6a 00                	push   $0x0
f0104460:	6a 20                	push   $0x20
f0104462:	eb 1e                	jmp    f0104482 <_alltraps>

f0104464 <handler33>:
TRAPHANDLER_NOEC(handler33, IRQ_OFFSET + IRQ_KBD)
f0104464:	6a 00                	push   $0x0
f0104466:	6a 21                	push   $0x21
f0104468:	eb 18                	jmp    f0104482 <_alltraps>

f010446a <handler36>:
TRAPHANDLER_NOEC(handler36, IRQ_OFFSET + IRQ_SERIAL)
f010446a:	6a 00                	push   $0x0
f010446c:	6a 24                	push   $0x24
f010446e:	eb 12                	jmp    f0104482 <_alltraps>

f0104470 <handler39>:
TRAPHANDLER_NOEC(handler39, IRQ_OFFSET + IRQ_SPURIOUS)
f0104470:	6a 00                	push   $0x0
f0104472:	6a 27                	push   $0x27
f0104474:	eb 0c                	jmp    f0104482 <_alltraps>

f0104476 <handler46>:
TRAPHANDLER_NOEC(handler46, IRQ_OFFSET + IRQ_IDE)
f0104476:	6a 00                	push   $0x0
f0104478:	6a 2e                	push   $0x2e
f010447a:	eb 06                	jmp    f0104482 <_alltraps>

f010447c <handler51>:
TRAPHANDLER_NOEC(handler51, IRQ_OFFSET + IRQ_ERROR)
f010447c:	6a 00                	push   $0x0
f010447e:	6a 33                	push   $0x33
f0104480:	eb 00                	jmp    f0104482 <_alltraps>

f0104482 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
f0104482:	1e                   	push   %ds
	pushl %es
f0104483:	06                   	push   %es
	pushal
f0104484:	60                   	pusha  
	movw $GD_KD, %ax
f0104485:	66 b8 10 00          	mov    $0x10,%ax
	movw %ax, %ds
f0104489:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f010448b:	8e c0                	mov    %eax,%es
	pushl %esp
f010448d:	54                   	push   %esp
	call trap /*never return*/
f010448e:	e8 f7 fc ff ff       	call   f010418a <trap>

1:jmp 1b
f0104493:	eb fe                	jmp    f0104493 <_alltraps+0x11>

f0104495 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104495:	f3 0f 1e fb          	endbr32 
f0104499:	55                   	push   %ebp
f010449a:	89 e5                	mov    %esp,%ebp
f010449c:	83 ec 08             	sub    $0x8,%esp
f010449f:	a1 48 e2 2b f0       	mov    0xf02be248,%eax
f01044a4:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01044a7:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01044ac:	8b 02                	mov    (%edx),%eax
f01044ae:	83 e8 01             	sub    $0x1,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01044b1:	83 f8 02             	cmp    $0x2,%eax
f01044b4:	76 2d                	jbe    f01044e3 <sched_halt+0x4e>
	for (i = 0; i < NENV; i++) {
f01044b6:	83 c1 01             	add    $0x1,%ecx
f01044b9:	83 c2 7c             	add    $0x7c,%edx
f01044bc:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01044c2:	75 e8                	jne    f01044ac <sched_halt+0x17>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01044c4:	83 ec 0c             	sub    $0xc,%esp
f01044c7:	68 10 81 10 f0       	push   $0xf0108110
f01044cc:	e8 96 f4 ff ff       	call   f0103967 <cprintf>
f01044d1:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f01044d4:	83 ec 0c             	sub    $0xc,%esp
f01044d7:	6a 00                	push   $0x0
f01044d9:	e8 9b c4 ff ff       	call   f0100979 <monitor>
f01044de:	83 c4 10             	add    $0x10,%esp
f01044e1:	eb f1                	jmp    f01044d4 <sched_halt+0x3f>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f01044e3:	e8 e6 18 00 00       	call   f0105dce <cpunum>
f01044e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01044eb:	c7 80 28 f0 2b f0 00 	movl   $0x0,-0xfd40fd8(%eax)
f01044f2:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f01044f5:	a1 98 ee 2b f0       	mov    0xf02bee98,%eax
	if ((uint32_t)kva < KERNBASE)
f01044fa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01044ff:	76 50                	jbe    f0104551 <sched_halt+0xbc>
	return (physaddr_t)kva - KERNBASE;
f0104501:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104506:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104509:	e8 c0 18 00 00       	call   f0105dce <cpunum>
f010450e:	6b d0 74             	imul   $0x74,%eax,%edx
f0104511:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104514:	b8 02 00 00 00       	mov    $0x2,%eax
f0104519:	f0 87 82 20 f0 2b f0 	lock xchg %eax,-0xfd40fe0(%edx)
	spin_unlock(&kernel_lock);
f0104520:	83 ec 0c             	sub    $0xc,%esp
f0104523:	68 c0 53 12 f0       	push   $0xf01253c0
f0104528:	e8 c7 1b 00 00       	call   f01060f4 <spin_unlock>
	asm volatile("pause");
f010452d:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010452f:	e8 9a 18 00 00       	call   f0105dce <cpunum>
f0104534:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile (
f0104537:	8b 80 30 f0 2b f0    	mov    -0xfd40fd0(%eax),%eax
f010453d:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104542:	89 c4                	mov    %eax,%esp
f0104544:	6a 00                	push   $0x0
f0104546:	6a 00                	push   $0x0
f0104548:	fb                   	sti    
f0104549:	f4                   	hlt    
f010454a:	eb fd                	jmp    f0104549 <sched_halt+0xb4>
}
f010454c:	83 c4 10             	add    $0x10,%esp
f010454f:	c9                   	leave  
f0104550:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104551:	50                   	push   %eax
f0104552:	68 48 6a 10 f0       	push   $0xf0106a48
f0104557:	6a 54                	push   $0x54
f0104559:	68 39 81 10 f0       	push   $0xf0108139
f010455e:	e8 dd ba ff ff       	call   f0100040 <_panic>

f0104563 <sched_yield>:
{
f0104563:	f3 0f 1e fb          	endbr32 
f0104567:	55                   	push   %ebp
f0104568:	89 e5                	mov    %esp,%ebp
f010456a:	57                   	push   %edi
f010456b:	56                   	push   %esi
f010456c:	53                   	push   %ebx
f010456d:	83 ec 0c             	sub    $0xc,%esp
	idle = curenv;
f0104570:	e8 59 18 00 00       	call   f0105dce <cpunum>
f0104575:	6b c0 74             	imul   $0x74,%eax,%eax
f0104578:	8b b0 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%esi
	int idx = idle ? ENVX(idle->env_id) : -1;
f010457e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f0104583:	85 f6                	test   %esi,%esi
f0104585:	74 09                	je     f0104590 <sched_yield+0x2d>
f0104587:	8b 5e 48             	mov    0x48(%esi),%ebx
f010458a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
		if(envs[i].env_status == ENV_RUNNABLE){
f0104590:	8b 0d 48 e2 2b f0    	mov    0xf02be248,%ecx
	for(i = idx + 1; i < NENV; i++){
f0104596:	8d 43 01             	lea    0x1(%ebx),%eax
f0104599:	6b c0 7c             	imul   $0x7c,%eax,%eax
f010459c:	01 c8                	add    %ecx,%eax
f010459e:	89 ca                	mov    %ecx,%edx
f01045a0:	81 c1 00 f0 01 00    	add    $0x1f000,%ecx
f01045a6:	39 c8                	cmp    %ecx,%eax
f01045a8:	74 14                	je     f01045be <sched_yield+0x5b>
		if(envs[i].env_status == ENV_RUNNABLE){
f01045aa:	89 c7                	mov    %eax,%edi
f01045ac:	83 c0 7c             	add    $0x7c,%eax
f01045af:	83 78 d8 02          	cmpl   $0x2,-0x28(%eax)
f01045b3:	75 f1                	jne    f01045a6 <sched_yield+0x43>
			env_run(&envs[i]);
f01045b5:	83 ec 0c             	sub    $0xc,%esp
f01045b8:	57                   	push   %edi
f01045b9:	e8 15 f1 ff ff       	call   f01036d3 <env_run>
	for(i = 0; i <= idx; i++){
f01045be:	b8 00 00 00 00       	mov    $0x0,%eax
f01045c3:	39 d8                	cmp    %ebx,%eax
f01045c5:	7f 19                	jg     f01045e0 <sched_yield+0x7d>
		if(envs[i].env_status == ENV_RUNNABLE){
f01045c7:	89 d1                	mov    %edx,%ecx
f01045c9:	83 c2 7c             	add    $0x7c,%edx
f01045cc:	83 7a d8 02          	cmpl   $0x2,-0x28(%edx)
f01045d0:	74 05                	je     f01045d7 <sched_yield+0x74>
	for(i = 0; i <= idx; i++){
f01045d2:	83 c0 01             	add    $0x1,%eax
f01045d5:	eb ec                	jmp    f01045c3 <sched_yield+0x60>
			env_run(&envs[i]);
f01045d7:	83 ec 0c             	sub    $0xc,%esp
f01045da:	51                   	push   %ecx
f01045db:	e8 f3 f0 ff ff       	call   f01036d3 <env_run>
	if(idle && idle->env_status == ENV_RUNNING) {
f01045e0:	85 f6                	test   %esi,%esi
f01045e2:	74 06                	je     f01045ea <sched_yield+0x87>
f01045e4:	83 7e 54 03          	cmpl   $0x3,0x54(%esi)
f01045e8:	74 0d                	je     f01045f7 <sched_yield+0x94>
	sched_halt();
f01045ea:	e8 a6 fe ff ff       	call   f0104495 <sched_halt>
}
f01045ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01045f2:	5b                   	pop    %ebx
f01045f3:	5e                   	pop    %esi
f01045f4:	5f                   	pop    %edi
f01045f5:	5d                   	pop    %ebp
f01045f6:	c3                   	ret    
		env_run(idle);
f01045f7:	83 ec 0c             	sub    $0xc,%esp
f01045fa:	56                   	push   %esi
f01045fb:	e8 d3 f0 ff ff       	call   f01036d3 <env_run>

f0104600 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104600:	f3 0f 1e fb          	endbr32 
f0104604:	55                   	push   %ebp
f0104605:	89 e5                	mov    %esp,%ebp
f0104607:	57                   	push   %edi
f0104608:	56                   	push   %esi
f0104609:	53                   	push   %ebx
f010460a:	83 ec 1c             	sub    $0x1c,%esp
f010460d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104610:	8b 75 10             	mov    0x10(%ebp),%esi
f0104613:	83 f8 0e             	cmp    $0xe,%eax
f0104616:	0f 87 5a 05 00 00    	ja     f0104b76 <syscall+0x576>
f010461c:	3e ff 24 85 4c 81 10 	notrack jmp *-0xfef7eb4(,%eax,4)
f0104623:	f0 
	user_mem_assert(curenv, s, len, 0);
f0104624:	e8 a5 17 00 00       	call   f0105dce <cpunum>
f0104629:	6a 00                	push   $0x0
f010462b:	56                   	push   %esi
f010462c:	ff 75 0c             	pushl  0xc(%ebp)
f010462f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104632:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104638:	e8 96 e9 ff ff       	call   f0102fd3 <user_mem_assert>
	cprintf("%.*s", len, s);
f010463d:	83 c4 0c             	add    $0xc,%esp
f0104640:	ff 75 0c             	pushl  0xc(%ebp)
f0104643:	56                   	push   %esi
f0104644:	68 46 81 10 f0       	push   $0xf0108146
f0104649:	e8 19 f3 ff ff       	call   f0103967 <cprintf>
}
f010464e:	83 c4 10             	add    $0x10,%esp
	//panic("syscall not implemented");

	switch (syscallno) {
		case SYS_cputs : 
			sys_cputs((const char*)a1, a2);
			return 0;
f0104651:	bb 00 00 00 00       	mov    $0x0,%ebx
		case SYS_time_msec:
			return sys_time_msec();
		default:
			return -E_INVAL;
	}
}
f0104656:	89 d8                	mov    %ebx,%eax
f0104658:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010465b:	5b                   	pop    %ebx
f010465c:	5e                   	pop    %esi
f010465d:	5f                   	pop    %edi
f010465e:	5d                   	pop    %ebp
f010465f:	c3                   	ret    
	return cons_getc();
f0104660:	e8 b8 bf ff ff       	call   f010061d <cons_getc>
f0104665:	89 c3                	mov    %eax,%ebx
			return sys_cgetc();
f0104667:	eb ed                	jmp    f0104656 <syscall+0x56>
	return curenv->env_id;
f0104669:	e8 60 17 00 00       	call   f0105dce <cpunum>
f010466e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104671:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104677:	8b 58 48             	mov    0x48(%eax),%ebx
			return sys_getenvid();
f010467a:	eb da                	jmp    f0104656 <syscall+0x56>
	if ((r = envid2env(envid, &e, 1)) < 0)
f010467c:	83 ec 04             	sub    $0x4,%esp
f010467f:	6a 01                	push   $0x1
f0104681:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104684:	50                   	push   %eax
f0104685:	ff 75 0c             	pushl  0xc(%ebp)
f0104688:	e8 1c ea ff ff       	call   f01030a9 <envid2env>
f010468d:	89 c3                	mov    %eax,%ebx
f010468f:	83 c4 10             	add    $0x10,%esp
f0104692:	85 c0                	test   %eax,%eax
f0104694:	78 c0                	js     f0104656 <syscall+0x56>
	env_destroy(e);
f0104696:	83 ec 0c             	sub    $0xc,%esp
f0104699:	ff 75 e4             	pushl  -0x1c(%ebp)
f010469c:	e8 8b ef ff ff       	call   f010362c <env_destroy>
	return 0;
f01046a1:	83 c4 10             	add    $0x10,%esp
f01046a4:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_destroy(a1);
f01046a9:	eb ab                	jmp    f0104656 <syscall+0x56>
	sched_yield();
f01046ab:	e8 b3 fe ff ff       	call   f0104563 <sched_yield>
	int res = env_alloc(&e, curenv->env_id);
f01046b0:	e8 19 17 00 00       	call   f0105dce <cpunum>
f01046b5:	83 ec 08             	sub    $0x8,%esp
f01046b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01046bb:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f01046c1:	ff 70 48             	pushl  0x48(%eax)
f01046c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01046c7:	50                   	push   %eax
f01046c8:	e8 f1 ea ff ff       	call   f01031be <env_alloc>
f01046cd:	89 c3                	mov    %eax,%ebx
	if(res > 0) return res;
f01046cf:	83 c4 10             	add    $0x10,%esp
f01046d2:	85 c0                	test   %eax,%eax
f01046d4:	7f 80                	jg     f0104656 <syscall+0x56>
	e->env_status = ENV_NOT_RUNNABLE;
f01046d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01046d9:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f01046e0:	e8 e9 16 00 00       	call   f0105dce <cpunum>
f01046e5:	6b c0 74             	imul   $0x74,%eax,%eax
f01046e8:	8b b0 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%esi
f01046ee:	b9 11 00 00 00       	mov    $0x11,%ecx
f01046f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01046f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01046f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01046fb:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f0104702:	8b 58 48             	mov    0x48(%eax),%ebx
        	return sys_exofork();
f0104705:	e9 4c ff ff ff       	jmp    f0104656 <syscall+0x56>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;
f010470a:	8d 46 fe             	lea    -0x2(%esi),%eax
f010470d:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f0104712:	75 2e                	jne    f0104742 <syscall+0x142>
	int res = envid2env(envid, &e, 1);
f0104714:	83 ec 04             	sub    $0x4,%esp
f0104717:	6a 01                	push   $0x1
f0104719:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010471c:	50                   	push   %eax
f010471d:	ff 75 0c             	pushl  0xc(%ebp)
f0104720:	e8 84 e9 ff ff       	call   f01030a9 <envid2env>
f0104725:	89 c3                	mov    %eax,%ebx
	if(res < 0) return res;
f0104727:	83 c4 10             	add    $0x10,%esp
f010472a:	85 c0                	test   %eax,%eax
f010472c:	0f 88 24 ff ff ff    	js     f0104656 <syscall+0x56>
	e->env_status = status;
f0104732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104735:	89 70 54             	mov    %esi,0x54(%eax)
	return 0;
f0104738:	bb 00 00 00 00       	mov    $0x0,%ebx
f010473d:	e9 14 ff ff ff       	jmp    f0104656 <syscall+0x56>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) return -E_INVAL;
f0104742:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
        	return sys_env_set_status(a1, a2);
f0104747:	e9 0a ff ff ff       	jmp    f0104656 <syscall+0x56>
    if (envid2env(envid, &env, 1) < 0)
f010474c:	83 ec 04             	sub    $0x4,%esp
f010474f:	6a 01                	push   $0x1
f0104751:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104754:	50                   	push   %eax
f0104755:	ff 75 0c             	pushl  0xc(%ebp)
f0104758:	e8 4c e9 ff ff       	call   f01030a9 <envid2env>
f010475d:	83 c4 10             	add    $0x10,%esp
f0104760:	85 c0                	test   %eax,%eax
f0104762:	78 6b                	js     f01047cf <syscall+0x1cf>
    if ((uintptr_t)va >= UTOP || PGOFF(va))
f0104764:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f010476a:	77 6d                	ja     f01047d9 <syscall+0x1d9>
f010476c:	89 f0                	mov    %esi,%eax
f010476e:	25 ff 0f 00 00       	and    $0xfff,%eax
    if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0)
f0104773:	8b 55 14             	mov    0x14(%ebp),%edx
f0104776:	83 e2 05             	and    $0x5,%edx
f0104779:	83 fa 05             	cmp    $0x5,%edx
f010477c:	75 65                	jne    f01047e3 <syscall+0x1e3>
    if ((perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) != 0)
f010477e:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104781:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104787:	09 c3                	or     %eax,%ebx
f0104789:	75 62                	jne    f01047ed <syscall+0x1ed>
    if ((pp = page_alloc(ALLOC_ZERO)) == NULL)
f010478b:	83 ec 0c             	sub    $0xc,%esp
f010478e:	6a 01                	push   $0x1
f0104790:	e8 e5 c7 ff ff       	call   f0100f7a <page_alloc>
f0104795:	89 c7                	mov    %eax,%edi
f0104797:	83 c4 10             	add    $0x10,%esp
f010479a:	85 c0                	test   %eax,%eax
f010479c:	74 59                	je     f01047f7 <syscall+0x1f7>
    if (page_insert(env->env_pgdir, pp, va, perm) < 0) {
f010479e:	ff 75 14             	pushl  0x14(%ebp)
f01047a1:	56                   	push   %esi
f01047a2:	50                   	push   %eax
f01047a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047a6:	ff 70 60             	pushl  0x60(%eax)
f01047a9:	e8 a0 ca ff ff       	call   f010124e <page_insert>
f01047ae:	83 c4 10             	add    $0x10,%esp
f01047b1:	85 c0                	test   %eax,%eax
f01047b3:	0f 89 9d fe ff ff    	jns    f0104656 <syscall+0x56>
            page_free(pp);
f01047b9:	83 ec 0c             	sub    $0xc,%esp
f01047bc:	57                   	push   %edi
f01047bd:	e8 31 c8 ff ff       	call   f0100ff3 <page_free>
            return -E_NO_MEM;
f01047c2:	83 c4 10             	add    $0x10,%esp
f01047c5:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f01047ca:	e9 87 fe ff ff       	jmp    f0104656 <syscall+0x56>
            return -E_BAD_ENV;
f01047cf:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01047d4:	e9 7d fe ff ff       	jmp    f0104656 <syscall+0x56>
            return -E_INVAL;
f01047d9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047de:	e9 73 fe ff ff       	jmp    f0104656 <syscall+0x56>
            return -E_INVAL;
f01047e3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047e8:	e9 69 fe ff ff       	jmp    f0104656 <syscall+0x56>
            return -E_INVAL;
f01047ed:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01047f2:	e9 5f fe ff ff       	jmp    f0104656 <syscall+0x56>
            return -E_NO_MEM;
f01047f7:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
        	return sys_page_alloc(a1, (void *)a2, a3);
f01047fc:	e9 55 fe ff ff       	jmp    f0104656 <syscall+0x56>
    if (envid2env(srcenvid, &srcenv, 1) < 0 || envid2env(dstenvid, &dstenv, 1) < 0)
f0104801:	83 ec 04             	sub    $0x4,%esp
f0104804:	6a 01                	push   $0x1
f0104806:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104809:	50                   	push   %eax
f010480a:	ff 75 0c             	pushl  0xc(%ebp)
f010480d:	e8 97 e8 ff ff       	call   f01030a9 <envid2env>
f0104812:	83 c4 10             	add    $0x10,%esp
f0104815:	85 c0                	test   %eax,%eax
f0104817:	0f 88 98 00 00 00    	js     f01048b5 <syscall+0x2b5>
f010481d:	83 ec 04             	sub    $0x4,%esp
f0104820:	6a 01                	push   $0x1
f0104822:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104825:	50                   	push   %eax
f0104826:	ff 75 14             	pushl  0x14(%ebp)
f0104829:	e8 7b e8 ff ff       	call   f01030a9 <envid2env>
f010482e:	83 c4 10             	add    $0x10,%esp
f0104831:	85 c0                	test   %eax,%eax
f0104833:	0f 88 86 00 00 00    	js     f01048bf <syscall+0x2bf>
    if ((uintptr_t)srcva >= UTOP || PGOFF(srcva) || (uintptr_t)dstva >= UTOP || PGOFF(dstva))
f0104839:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f010483f:	0f 87 84 00 00 00    	ja     f01048c9 <syscall+0x2c9>
f0104845:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f010484c:	0f 87 81 00 00 00    	ja     f01048d3 <syscall+0x2d3>
f0104852:	89 f0                	mov    %esi,%eax
f0104854:	0b 45 18             	or     0x18(%ebp),%eax
f0104857:	a9 ff 0f 00 00       	test   $0xfff,%eax
f010485c:	75 7f                	jne    f01048dd <syscall+0x2dd>
    if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0 || (perm & ~PTE_SYSCALL) != 0)
f010485e:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104861:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f0104866:	83 f8 05             	cmp    $0x5,%eax
f0104869:	75 7c                	jne    f01048e7 <syscall+0x2e7>
    if ((pp = page_lookup(srcenv->env_pgdir, srcva, &pte)) == NULL)
f010486b:	83 ec 04             	sub    $0x4,%esp
f010486e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104871:	50                   	push   %eax
f0104872:	56                   	push   %esi
f0104873:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104876:	ff 70 60             	pushl  0x60(%eax)
f0104879:	e8 e1 c8 ff ff       	call   f010115f <page_lookup>
f010487e:	83 c4 10             	add    $0x10,%esp
f0104881:	85 c0                	test   %eax,%eax
f0104883:	74 6c                	je     f01048f1 <syscall+0x2f1>
    if ((perm & PTE_W) && (*pte & PTE_W) == 0)
f0104885:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104889:	74 08                	je     f0104893 <syscall+0x293>
f010488b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010488e:	f6 02 02             	testb  $0x2,(%edx)
f0104891:	74 68                	je     f01048fb <syscall+0x2fb>
    if (page_insert(dstenv->env_pgdir, pp, dstva, perm) < 0)
f0104893:	ff 75 1c             	pushl  0x1c(%ebp)
f0104896:	ff 75 18             	pushl  0x18(%ebp)
f0104899:	50                   	push   %eax
f010489a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010489d:	ff 70 60             	pushl  0x60(%eax)
f01048a0:	e8 a9 c9 ff ff       	call   f010124e <page_insert>
f01048a5:	83 c4 10             	add    $0x10,%esp
        return -E_NO_MEM;
f01048a8:	c1 f8 1f             	sar    $0x1f,%eax
f01048ab:	89 c3                	mov    %eax,%ebx
f01048ad:	83 e3 fc             	and    $0xfffffffc,%ebx
f01048b0:	e9 a1 fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_BAD_ENV;
f01048b5:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01048ba:	e9 97 fd ff ff       	jmp    f0104656 <syscall+0x56>
f01048bf:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f01048c4:	e9 8d fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_INVAL;
f01048c9:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048ce:	e9 83 fd ff ff       	jmp    f0104656 <syscall+0x56>
f01048d3:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048d8:	e9 79 fd ff ff       	jmp    f0104656 <syscall+0x56>
f01048dd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048e2:	e9 6f fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_INVAL;
f01048e7:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048ec:	e9 65 fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_INVAL;
f01048f1:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f01048f6:	e9 5b fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_INVAL;
f01048fb:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104900:	e9 51 fd ff ff       	jmp    f0104656 <syscall+0x56>
    if (envid2env(envid, &env, 1) < 0)
f0104905:	83 ec 04             	sub    $0x4,%esp
f0104908:	6a 01                	push   $0x1
f010490a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010490d:	50                   	push   %eax
f010490e:	ff 75 0c             	pushl  0xc(%ebp)
f0104911:	e8 93 e7 ff ff       	call   f01030a9 <envid2env>
f0104916:	83 c4 10             	add    $0x10,%esp
f0104919:	85 c0                	test   %eax,%eax
f010491b:	78 2c                	js     f0104949 <syscall+0x349>
    if ((uintptr_t)va >= UTOP || PGOFF(va))
f010491d:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0104923:	77 2e                	ja     f0104953 <syscall+0x353>
f0104925:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f010492b:	75 30                	jne    f010495d <syscall+0x35d>
    page_remove(env->env_pgdir, va);
f010492d:	83 ec 08             	sub    $0x8,%esp
f0104930:	56                   	push   %esi
f0104931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104934:	ff 70 60             	pushl  0x60(%eax)
f0104937:	e8 c5 c8 ff ff       	call   f0101201 <page_remove>
    return 0;
f010493c:	83 c4 10             	add    $0x10,%esp
f010493f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104944:	e9 0d fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_BAD_ENV;
f0104949:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010494e:	e9 03 fd ff ff       	jmp    f0104656 <syscall+0x56>
        return -E_INVAL;
f0104953:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104958:	e9 f9 fc ff ff       	jmp    f0104656 <syscall+0x56>
f010495d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
        	return sys_page_unmap(a1, (void *)a2);
f0104962:	e9 ef fc ff ff       	jmp    f0104656 <syscall+0x56>
	int res = envid2env(envid, &e, 1);
f0104967:	83 ec 04             	sub    $0x4,%esp
f010496a:	6a 01                	push   $0x1
f010496c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010496f:	50                   	push   %eax
f0104970:	ff 75 0c             	pushl  0xc(%ebp)
f0104973:	e8 31 e7 ff ff       	call   f01030a9 <envid2env>
f0104978:	89 c3                	mov    %eax,%ebx
	if(res < 0) 
f010497a:	83 c4 10             	add    $0x10,%esp
f010497d:	85 c0                	test   %eax,%eax
f010497f:	0f 88 d1 fc ff ff    	js     f0104656 <syscall+0x56>
	e->env_pgfault_upcall = func;
f0104985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104988:	89 70 64             	mov    %esi,0x64(%eax)
	return 0;
f010498b:	bb 00 00 00 00       	mov    $0x0,%ebx
			return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0104990:	e9 c1 fc ff ff       	jmp    f0104656 <syscall+0x56>
	if ((r = envid2env(envid, &e, 0)) < 0)
f0104995:	83 ec 04             	sub    $0x4,%esp
f0104998:	6a 00                	push   $0x0
f010499a:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010499d:	50                   	push   %eax
f010499e:	ff 75 0c             	pushl  0xc(%ebp)
f01049a1:	e8 03 e7 ff ff       	call   f01030a9 <envid2env>
f01049a6:	83 c4 10             	add    $0x10,%esp
f01049a9:	85 c0                	test   %eax,%eax
f01049ab:	0f 88 fb 00 00 00    	js     f0104aac <syscall+0x4ac>
	if (!e->env_ipc_recving)
f01049b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01049b4:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01049b8:	0f 84 f8 00 00 00    	je     f0104ab6 <syscall+0x4b6>
	if (srcva < (void *)UTOP) {
f01049be:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01049c5:	77 78                	ja     f0104a3f <syscall+0x43f>
		if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0)
f01049c7:	8b 45 18             	mov    0x18(%ebp),%eax
f01049ca:	83 e0 05             	and    $0x5,%eax
            return -E_INVAL;
f01049cd:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		if ((perm & PTE_U) == 0 || (perm & PTE_P) == 0)
f01049d2:	83 f8 05             	cmp    $0x5,%eax
f01049d5:	0f 85 7b fc ff ff    	jne    f0104656 <syscall+0x56>
		if (PGOFF(srcva)) return -E_INVAL;
f01049db:	8b 55 14             	mov    0x14(%ebp),%edx
f01049de:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    	if ((perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) != 0)
f01049e4:	8b 45 18             	mov    0x18(%ebp),%eax
f01049e7:	25 f8 f1 ff ff       	and    $0xfffff1f8,%eax
f01049ec:	09 c2                	or     %eax,%edx
f01049ee:	0f 85 62 fc ff ff    	jne    f0104656 <syscall+0x56>
		struct PageInfo *p = page_lookup(curenv->env_pgdir, srcva, &pte);
f01049f4:	e8 d5 13 00 00       	call   f0105dce <cpunum>
f01049f9:	83 ec 04             	sub    $0x4,%esp
f01049fc:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01049ff:	52                   	push   %edx
f0104a00:	ff 75 14             	pushl  0x14(%ebp)
f0104a03:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a06:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104a0c:	ff 70 60             	pushl  0x60(%eax)
f0104a0f:	e8 4b c7 ff ff       	call   f010115f <page_lookup>
		if (!p) return -E_INVAL;
f0104a14:	83 c4 10             	add    $0x10,%esp
f0104a17:	85 c0                	test   %eax,%eax
f0104a19:	0f 84 83 00 00 00    	je     f0104aa2 <syscall+0x4a2>
		if((perm & PTE_W) && !(*pte & PTE_W))
f0104a1f:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104a23:	74 0c                	je     f0104a31 <syscall+0x431>
f0104a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104a28:	f6 02 02             	testb  $0x2,(%edx)
f0104a2b:	0f 84 25 fc ff ff    	je     f0104656 <syscall+0x56>
		if (e->env_ipc_dstva < (void *)UTOP) {
f0104a31:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104a34:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104a37:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0104a3d:	76 3b                	jbe    f0104a7a <syscall+0x47a>
	e->env_ipc_recving = 0;
f0104a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a42:	c6 40 68 00          	movb   $0x0,0x68(%eax)
	e->env_ipc_from = curenv->env_id;
f0104a46:	e8 83 13 00 00       	call   f0105dce <cpunum>
f0104a4b:	89 c2                	mov    %eax,%edx
f0104a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a50:	6b d2 74             	imul   $0x74,%edx,%edx
f0104a53:	8b 92 28 f0 2b f0    	mov    -0xfd40fd8(%edx),%edx
f0104a59:	8b 52 48             	mov    0x48(%edx),%edx
f0104a5c:	89 50 74             	mov    %edx,0x74(%eax)
	e->env_ipc_value = value;
f0104a5f:	89 70 70             	mov    %esi,0x70(%eax)
	e->env_status = ENV_RUNNABLE;
f0104a62:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	e->env_tf.tf_regs.reg_eax=0;
f0104a69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f0104a70:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104a75:	e9 dc fb ff ff       	jmp    f0104656 <syscall+0x56>
			if ((r = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm)) < 0) 
f0104a7a:	ff 75 18             	pushl  0x18(%ebp)
f0104a7d:	51                   	push   %ecx
f0104a7e:	50                   	push   %eax
f0104a7f:	ff 72 60             	pushl  0x60(%edx)
f0104a82:	e8 c7 c7 ff ff       	call   f010124e <page_insert>
f0104a87:	83 c4 10             	add    $0x10,%esp
				return -E_NO_MEM;
f0104a8a:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
			if ((r = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm)) < 0) 
f0104a8f:	85 c0                	test   %eax,%eax
f0104a91:	0f 88 bf fb ff ff    	js     f0104656 <syscall+0x56>
			e->env_ipc_perm = perm;
f0104a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104a9a:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0104a9d:	89 48 78             	mov    %ecx,0x78(%eax)
f0104aa0:	eb 9d                	jmp    f0104a3f <syscall+0x43f>
		if (!p) return -E_INVAL;
f0104aa2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aa7:	e9 aa fb ff ff       	jmp    f0104656 <syscall+0x56>
		return -E_BAD_ENV;
f0104aac:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f0104ab1:	e9 a0 fb ff ff       	jmp    f0104656 <syscall+0x56>
		return -E_IPC_NOT_RECV;
f0104ab6:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
			return sys_ipc_try_send(a1, a2, (void *)a3, (unsigned int)a4);
f0104abb:	e9 96 fb ff ff       	jmp    f0104656 <syscall+0x56>
	if (dstva < (void *)UTOP && PGOFF(dstva)) return -E_INVAL;
f0104ac0:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104ac7:	77 13                	ja     f0104adc <syscall+0x4dc>
f0104ac9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104ad0:	74 0a                	je     f0104adc <syscall+0x4dc>
			return sys_ipc_recv((void *)a1);
f0104ad2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ad7:	e9 7a fb ff ff       	jmp    f0104656 <syscall+0x56>
	curenv->env_ipc_recving = 1;
f0104adc:	e8 ed 12 00 00       	call   f0105dce <cpunum>
f0104ae1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ae4:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104aea:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104aee:	e8 db 12 00 00       	call   f0105dce <cpunum>
f0104af3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104af6:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104aff:	89 48 6c             	mov    %ecx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104b02:	e8 c7 12 00 00       	call   f0105dce <cpunum>
f0104b07:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b0a:	8b 80 28 f0 2b f0    	mov    -0xfd40fd8(%eax),%eax
f0104b10:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	sched_yield();
f0104b17:	e8 47 fa ff ff       	call   f0104563 <sched_yield>
	int r  =envid2env(envid, &e, 1);
f0104b1c:	83 ec 04             	sub    $0x4,%esp
f0104b1f:	6a 01                	push   $0x1
f0104b21:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b24:	50                   	push   %eax
f0104b25:	ff 75 0c             	pushl  0xc(%ebp)
f0104b28:	e8 7c e5 ff ff       	call   f01030a9 <envid2env>
f0104b2d:	89 c3                	mov    %eax,%ebx
	if(r != 0)
f0104b2f:	83 c4 10             	add    $0x10,%esp
f0104b32:	85 c0                	test   %eax,%eax
f0104b34:	0f 85 1c fb ff ff    	jne    f0104656 <syscall+0x56>
	user_mem_assert(e, (const void *) tf, sizeof(struct Trapframe), PTE_U);
f0104b3a:	6a 04                	push   $0x4
f0104b3c:	6a 44                	push   $0x44
f0104b3e:	56                   	push   %esi
f0104b3f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104b42:	e8 8c e4 ff ff       	call   f0102fd3 <user_mem_assert>
	tf->tf_eflags &= ~FL_IOPL_MASK;         
f0104b47:	8b 46 38             	mov    0x38(%esi),%eax
f0104b4a:	80 e4 cf             	and    $0xcf,%ah
f0104b4d:	80 cc 02             	or     $0x2,%ah
f0104b50:	89 46 38             	mov    %eax,0x38(%esi)
	tf->tf_cs |= 3;
f0104b53:	66 83 4e 34 03       	orw    $0x3,0x34(%esi)
	e->env_tf = *tf;
f0104b58:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104b5d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0; 
f0104b62:	83 c4 10             	add    $0x10,%esp
            return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f0104b65:	e9 ec fa ff ff       	jmp    f0104656 <syscall+0x56>
	return time_msec();
f0104b6a:	e8 09 1c 00 00       	call   f0106778 <time_msec>
f0104b6f:	89 c3                	mov    %eax,%ebx
			return sys_time_msec();
f0104b71:	e9 e0 fa ff ff       	jmp    f0104656 <syscall+0x56>
			return 0;
f0104b76:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b7b:	e9 d6 fa ff ff       	jmp    f0104656 <syscall+0x56>

f0104b80 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104b80:	55                   	push   %ebp
f0104b81:	89 e5                	mov    %esp,%ebp
f0104b83:	57                   	push   %edi
f0104b84:	56                   	push   %esi
f0104b85:	53                   	push   %ebx
f0104b86:	83 ec 14             	sub    $0x14,%esp
f0104b89:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104b8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104b8f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104b92:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104b95:	8b 1a                	mov    (%edx),%ebx
f0104b97:	8b 01                	mov    (%ecx),%eax
f0104b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104b9c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104ba3:	eb 23                	jmp    f0104bc8 <stab_binsearch+0x48>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104ba5:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104ba8:	eb 1e                	jmp    f0104bc8 <stab_binsearch+0x48>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104baa:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104bad:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104bb0:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104bb4:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104bb7:	73 46                	jae    f0104bff <stab_binsearch+0x7f>
			*region_left = m;
f0104bb9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104bbc:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104bbe:	8d 5f 01             	lea    0x1(%edi),%ebx
		any_matches = 1;
f0104bc1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f0104bc8:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104bcb:	7f 5f                	jg     f0104c2c <stab_binsearch+0xac>
		int true_m = (l + r) / 2, m = true_m;
f0104bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104bd0:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0104bd3:	89 d0                	mov    %edx,%eax
f0104bd5:	c1 e8 1f             	shr    $0x1f,%eax
f0104bd8:	01 d0                	add    %edx,%eax
f0104bda:	89 c7                	mov    %eax,%edi
f0104bdc:	d1 ff                	sar    %edi
f0104bde:	83 e0 fe             	and    $0xfffffffe,%eax
f0104be1:	01 f8                	add    %edi,%eax
f0104be3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104be6:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104bea:	89 f8                	mov    %edi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104bec:	39 c3                	cmp    %eax,%ebx
f0104bee:	7f b5                	jg     f0104ba5 <stab_binsearch+0x25>
f0104bf0:	0f b6 0a             	movzbl (%edx),%ecx
f0104bf3:	83 ea 0c             	sub    $0xc,%edx
f0104bf6:	39 f1                	cmp    %esi,%ecx
f0104bf8:	74 b0                	je     f0104baa <stab_binsearch+0x2a>
			m--;
f0104bfa:	83 e8 01             	sub    $0x1,%eax
f0104bfd:	eb ed                	jmp    f0104bec <stab_binsearch+0x6c>
		} else if (stabs[m].n_value > addr) {
f0104bff:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104c02:	76 14                	jbe    f0104c18 <stab_binsearch+0x98>
			*region_right = m - 1;
f0104c04:	83 e8 01             	sub    $0x1,%eax
f0104c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104c0a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104c0d:	89 07                	mov    %eax,(%edi)
		any_matches = 1;
f0104c0f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104c16:	eb b0                	jmp    f0104bc8 <stab_binsearch+0x48>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104c18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c1b:	89 07                	mov    %eax,(%edi)
			l = m;
			addr++;
f0104c1d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104c21:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0104c23:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104c2a:	eb 9c                	jmp    f0104bc8 <stab_binsearch+0x48>
		}
	}

	if (!any_matches)
f0104c2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104c30:	75 15                	jne    f0104c47 <stab_binsearch+0xc7>
		*region_right = *region_left - 1;
f0104c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c35:	8b 00                	mov    (%eax),%eax
f0104c37:	83 e8 01             	sub    $0x1,%eax
f0104c3a:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104c3d:	89 07                	mov    %eax,(%edi)
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104c3f:	83 c4 14             	add    $0x14,%esp
f0104c42:	5b                   	pop    %ebx
f0104c43:	5e                   	pop    %esi
f0104c44:	5f                   	pop    %edi
f0104c45:	5d                   	pop    %ebp
f0104c46:	c3                   	ret    
		for (l = *region_right;
f0104c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c4a:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0104c4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c4f:	8b 0f                	mov    (%edi),%ecx
f0104c51:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104c54:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0104c57:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
		for (l = *region_right;
f0104c5b:	eb 03                	jmp    f0104c60 <stab_binsearch+0xe0>
		     l--)
f0104c5d:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104c60:	39 c1                	cmp    %eax,%ecx
f0104c62:	7d 0a                	jge    f0104c6e <stab_binsearch+0xee>
		     l > *region_left && stabs[l].n_type != type;
f0104c64:	0f b6 1a             	movzbl (%edx),%ebx
f0104c67:	83 ea 0c             	sub    $0xc,%edx
f0104c6a:	39 f3                	cmp    %esi,%ebx
f0104c6c:	75 ef                	jne    f0104c5d <stab_binsearch+0xdd>
		*region_left = l;
f0104c6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c71:	89 07                	mov    %eax,(%edi)
}
f0104c73:	eb ca                	jmp    f0104c3f <stab_binsearch+0xbf>

f0104c75 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104c75:	f3 0f 1e fb          	endbr32 
f0104c79:	55                   	push   %ebp
f0104c7a:	89 e5                	mov    %esp,%ebp
f0104c7c:	57                   	push   %edi
f0104c7d:	56                   	push   %esi
f0104c7e:	53                   	push   %ebx
f0104c7f:	83 ec 4c             	sub    $0x4c,%esp
f0104c82:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104c85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104c88:	c7 03 88 81 10 f0    	movl   $0xf0108188,(%ebx)
	info->eip_line = 0;
f0104c8e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104c95:	c7 43 08 88 81 10 f0 	movl   $0xf0108188,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104c9c:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0104ca3:	89 7b 10             	mov    %edi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104ca6:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104cad:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104cb3:	0f 86 1f 01 00 00    	jbe    f0104dd8 <debuginfo_eip+0x163>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104cb9:	c7 45 b8 17 a7 11 f0 	movl   $0xf011a717,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104cc0:	c7 45 b4 c1 65 11 f0 	movl   $0xf01165c1,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104cc7:	be c0 65 11 f0       	mov    $0xf01165c0,%esi
		stabs = __STAB_BEGIN__;
f0104ccc:	c7 45 bc 88 89 10 f0 	movl   $0xf0108988,-0x44(%ebp)
			return -1;

	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104cd3:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104cd6:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104cd9:	0f 83 5d 02 00 00    	jae    f0104f3c <debuginfo_eip+0x2c7>
f0104cdf:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104ce3:	0f 85 5a 02 00 00    	jne    f0104f43 <debuginfo_eip+0x2ce>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104ce9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104cf0:	2b 75 bc             	sub    -0x44(%ebp),%esi
f0104cf3:	c1 fe 02             	sar    $0x2,%esi
f0104cf6:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f0104cfc:	83 e8 01             	sub    $0x1,%eax
f0104cff:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104d02:	83 ec 08             	sub    $0x8,%esp
f0104d05:	57                   	push   %edi
f0104d06:	6a 64                	push   $0x64
f0104d08:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104d0b:	89 d1                	mov    %edx,%ecx
f0104d0d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104d10:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104d13:	89 f0                	mov    %esi,%eax
f0104d15:	e8 66 fe ff ff       	call   f0104b80 <stab_binsearch>
	if (lfile == 0)
f0104d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104d1d:	83 c4 10             	add    $0x10,%esp
f0104d20:	85 c0                	test   %eax,%eax
f0104d22:	0f 84 22 02 00 00    	je     f0104f4a <debuginfo_eip+0x2d5>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104d28:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104d2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104d31:	83 ec 08             	sub    $0x8,%esp
f0104d34:	57                   	push   %edi
f0104d35:	6a 24                	push   $0x24
f0104d37:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0104d3a:	89 d1                	mov    %edx,%ecx
f0104d3c:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104d3f:	89 f0                	mov    %esi,%eax
f0104d41:	e8 3a fe ff ff       	call   f0104b80 <stab_binsearch>

	if (lfun <= rfun) {
f0104d46:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104d49:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0104d4c:	83 c4 10             	add    $0x10,%esp
f0104d4f:	39 d0                	cmp    %edx,%eax
f0104d51:	0f 8f 1c 01 00 00    	jg     f0104e73 <debuginfo_eip+0x1fe>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104d57:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0104d5a:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0104d5d:	89 75 c4             	mov    %esi,-0x3c(%ebp)
f0104d60:	8b 36                	mov    (%esi),%esi
f0104d62:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104d65:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0104d68:	39 ce                	cmp    %ecx,%esi
f0104d6a:	73 06                	jae    f0104d72 <debuginfo_eip+0xfd>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104d6c:	03 75 b4             	add    -0x4c(%ebp),%esi
f0104d6f:	89 73 08             	mov    %esi,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104d72:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0104d75:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104d78:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0104d7b:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f0104d7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0104d80:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0104d83:	83 ec 08             	sub    $0x8,%esp
f0104d86:	6a 3a                	push   $0x3a
f0104d88:	ff 73 08             	pushl  0x8(%ebx)
f0104d8b:	e8 fe 09 00 00       	call   f010578e <strfind>
f0104d90:	2b 43 08             	sub    0x8(%ebx),%eax
f0104d93:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0104d96:	83 c4 08             	add    $0x8,%esp
f0104d99:	57                   	push   %edi
f0104d9a:	6a 44                	push   $0x44
f0104d9c:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104d9f:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104da2:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0104da5:	89 f0                	mov    %esi,%eax
f0104da7:	e8 d4 fd ff ff       	call   f0104b80 <stab_binsearch>
	if (lline <= rline) {
f0104dac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0104daf:	83 c4 10             	add    $0x10,%esp
f0104db2:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0104db5:	0f 8f cc 00 00 00    	jg     f0104e87 <debuginfo_eip+0x212>
    	info->eip_line = stabs[lline].n_desc;
f0104dbb:	89 d0                	mov    %edx,%eax
f0104dbd:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104dc0:	0f b7 4c 96 06       	movzwl 0x6(%esi,%edx,4),%ecx
f0104dc5:	89 4b 04             	mov    %ecx,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104dc8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104dcb:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0104dcf:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f0104dd3:	e9 ca 00 00 00       	jmp    f0104ea2 <debuginfo_eip+0x22d>
		if(user_mem_check(curenv, usd, sizeof(*usd), PTE_U) < 0) return -1;
f0104dd8:	e8 f1 0f 00 00       	call   f0105dce <cpunum>
f0104ddd:	6a 04                	push   $0x4
f0104ddf:	6a 10                	push   $0x10
f0104de1:	68 00 00 20 00       	push   $0x200000
f0104de6:	6b c0 74             	imul   $0x74,%eax,%eax
f0104de9:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104def:	e8 55 e1 ff ff       	call   f0102f49 <user_mem_check>
f0104df4:	83 c4 10             	add    $0x10,%esp
f0104df7:	85 c0                	test   %eax,%eax
f0104df9:	0f 88 2f 01 00 00    	js     f0104f2e <debuginfo_eip+0x2b9>
		stabs = usd->stabs;
f0104dff:	a1 00 00 20 00       	mov    0x200000,%eax
f0104e04:	89 45 bc             	mov    %eax,-0x44(%ebp)
		stab_end = usd->stab_end;
f0104e07:	8b 35 04 00 20 00    	mov    0x200004,%esi
		stabstr = usd->stabstr;
f0104e0d:	8b 0d 08 00 20 00    	mov    0x200008,%ecx
f0104e13:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0104e16:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0104e1c:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if(user_mem_check(curenv, stabs, sizeof(*stabs), PTE_U) < 0 || user_mem_check(curenv, stabstr, sizeof(*stabstr), PTE_U) < 0)
f0104e1f:	e8 aa 0f 00 00       	call   f0105dce <cpunum>
f0104e24:	6a 04                	push   $0x4
f0104e26:	6a 0c                	push   $0xc
f0104e28:	ff 75 bc             	pushl  -0x44(%ebp)
f0104e2b:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e2e:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104e34:	e8 10 e1 ff ff       	call   f0102f49 <user_mem_check>
f0104e39:	83 c4 10             	add    $0x10,%esp
f0104e3c:	85 c0                	test   %eax,%eax
f0104e3e:	0f 88 f1 00 00 00    	js     f0104f35 <debuginfo_eip+0x2c0>
f0104e44:	e8 85 0f 00 00       	call   f0105dce <cpunum>
f0104e49:	6a 04                	push   $0x4
f0104e4b:	6a 01                	push   $0x1
f0104e4d:	ff 75 b4             	pushl  -0x4c(%ebp)
f0104e50:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e53:	ff b0 28 f0 2b f0    	pushl  -0xfd40fd8(%eax)
f0104e59:	e8 eb e0 ff ff       	call   f0102f49 <user_mem_check>
f0104e5e:	83 c4 10             	add    $0x10,%esp
f0104e61:	85 c0                	test   %eax,%eax
f0104e63:	0f 89 6a fe ff ff    	jns    f0104cd3 <debuginfo_eip+0x5e>
			return -1;
f0104e69:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104e6e:	e9 e3 00 00 00       	jmp    f0104f56 <debuginfo_eip+0x2e1>
		info->eip_fn_addr = addr;
f0104e73:	89 7b 10             	mov    %edi,0x10(%ebx)
		lline = lfile;
f0104e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104e79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0104e7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104e7f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104e82:	e9 fc fe ff ff       	jmp    f0104d83 <debuginfo_eip+0x10e>
    	info->eip_line = 0;
f0104e87:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    	return -1;
f0104e8e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104e93:	e9 be 00 00 00       	jmp    f0104f56 <debuginfo_eip+0x2e1>
f0104e98:	83 e8 01             	sub    $0x1,%eax
f0104e9b:	83 ea 0c             	sub    $0xc,%edx
	while (lline >= lfile
f0104e9e:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
f0104ea2:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0104ea5:	39 c7                	cmp    %eax,%edi
f0104ea7:	7f 45                	jg     f0104eee <debuginfo_eip+0x279>
	       && stabs[lline].n_type != N_SOL
f0104ea9:	0f b6 0a             	movzbl (%edx),%ecx
f0104eac:	80 f9 84             	cmp    $0x84,%cl
f0104eaf:	74 19                	je     f0104eca <debuginfo_eip+0x255>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104eb1:	80 f9 64             	cmp    $0x64,%cl
f0104eb4:	75 e2                	jne    f0104e98 <debuginfo_eip+0x223>
f0104eb6:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f0104eba:	74 dc                	je     f0104e98 <debuginfo_eip+0x223>
f0104ebc:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104ec0:	74 11                	je     f0104ed3 <debuginfo_eip+0x25e>
f0104ec2:	8b 7d c0             	mov    -0x40(%ebp),%edi
f0104ec5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0104ec8:	eb 09                	jmp    f0104ed3 <debuginfo_eip+0x25e>
f0104eca:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0104ece:	74 03                	je     f0104ed3 <debuginfo_eip+0x25e>
f0104ed0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104ed3:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104ed6:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104ed9:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0104edc:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0104edf:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f0104ee2:	29 f8                	sub    %edi,%eax
f0104ee4:	39 c2                	cmp    %eax,%edx
f0104ee6:	73 06                	jae    f0104eee <debuginfo_eip+0x279>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104ee8:	89 f8                	mov    %edi,%eax
f0104eea:	01 d0                	add    %edx,%eax
f0104eec:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104eee:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104ef1:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0104ef4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (lfun < rfun)
f0104ef9:	39 f0                	cmp    %esi,%eax
f0104efb:	7d 59                	jge    f0104f56 <debuginfo_eip+0x2e1>
		for (lline = lfun + 1;
f0104efd:	8d 50 01             	lea    0x1(%eax),%edx
f0104f00:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0104f03:	89 d0                	mov    %edx,%eax
f0104f05:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0104f08:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0104f0b:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f0104f0f:	eb 04                	jmp    f0104f15 <debuginfo_eip+0x2a0>
			info->eip_fn_narg++;
f0104f11:	83 43 14 01          	addl   $0x1,0x14(%ebx)
		for (lline = lfun + 1;
f0104f15:	39 c6                	cmp    %eax,%esi
f0104f17:	7e 38                	jle    f0104f51 <debuginfo_eip+0x2dc>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104f19:	0f b6 0a             	movzbl (%edx),%ecx
f0104f1c:	83 c0 01             	add    $0x1,%eax
f0104f1f:	83 c2 0c             	add    $0xc,%edx
f0104f22:	80 f9 a0             	cmp    $0xa0,%cl
f0104f25:	74 ea                	je     f0104f11 <debuginfo_eip+0x29c>
	return 0;
f0104f27:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f2c:	eb 28                	jmp    f0104f56 <debuginfo_eip+0x2e1>
		if(user_mem_check(curenv, usd, sizeof(*usd), PTE_U) < 0) return -1;
f0104f2e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f33:	eb 21                	jmp    f0104f56 <debuginfo_eip+0x2e1>
			return -1;
f0104f35:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f3a:	eb 1a                	jmp    f0104f56 <debuginfo_eip+0x2e1>
		return -1;
f0104f3c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f41:	eb 13                	jmp    f0104f56 <debuginfo_eip+0x2e1>
f0104f43:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f48:	eb 0c                	jmp    f0104f56 <debuginfo_eip+0x2e1>
		return -1;
f0104f4a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104f4f:	eb 05                	jmp    f0104f56 <debuginfo_eip+0x2e1>
	return 0;
f0104f51:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0104f56:	89 d0                	mov    %edx,%eax
f0104f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104f5b:	5b                   	pop    %ebx
f0104f5c:	5e                   	pop    %esi
f0104f5d:	5f                   	pop    %edi
f0104f5e:	5d                   	pop    %ebp
f0104f5f:	c3                   	ret    

f0104f60 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0104f60:	55                   	push   %ebp
f0104f61:	89 e5                	mov    %esp,%ebp
f0104f63:	57                   	push   %edi
f0104f64:	56                   	push   %esi
f0104f65:	53                   	push   %ebx
f0104f66:	83 ec 1c             	sub    $0x1c,%esp
f0104f69:	89 c7                	mov    %eax,%edi
f0104f6b:	89 d6                	mov    %edx,%esi
f0104f6d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104f70:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104f73:	89 d1                	mov    %edx,%ecx
f0104f75:	89 c2                	mov    %eax,%edx
f0104f77:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0104f7a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104f7d:	8b 45 10             	mov    0x10(%ebp),%eax
f0104f80:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0104f83:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0104f8d:	39 c2                	cmp    %eax,%edx
f0104f8f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0104f92:	72 3e                	jb     f0104fd2 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104f94:	83 ec 0c             	sub    $0xc,%esp
f0104f97:	ff 75 18             	pushl  0x18(%ebp)
f0104f9a:	83 eb 01             	sub    $0x1,%ebx
f0104f9d:	53                   	push   %ebx
f0104f9e:	50                   	push   %eax
f0104f9f:	83 ec 08             	sub    $0x8,%esp
f0104fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104fa5:	ff 75 e0             	pushl  -0x20(%ebp)
f0104fa8:	ff 75 dc             	pushl  -0x24(%ebp)
f0104fab:	ff 75 d8             	pushl  -0x28(%ebp)
f0104fae:	e8 dd 17 00 00       	call   f0106790 <__udivdi3>
f0104fb3:	83 c4 18             	add    $0x18,%esp
f0104fb6:	52                   	push   %edx
f0104fb7:	50                   	push   %eax
f0104fb8:	89 f2                	mov    %esi,%edx
f0104fba:	89 f8                	mov    %edi,%eax
f0104fbc:	e8 9f ff ff ff       	call   f0104f60 <printnum>
f0104fc1:	83 c4 20             	add    $0x20,%esp
f0104fc4:	eb 13                	jmp    f0104fd9 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104fc6:	83 ec 08             	sub    $0x8,%esp
f0104fc9:	56                   	push   %esi
f0104fca:	ff 75 18             	pushl  0x18(%ebp)
f0104fcd:	ff d7                	call   *%edi
f0104fcf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0104fd2:	83 eb 01             	sub    $0x1,%ebx
f0104fd5:	85 db                	test   %ebx,%ebx
f0104fd7:	7f ed                	jg     f0104fc6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104fd9:	83 ec 08             	sub    $0x8,%esp
f0104fdc:	56                   	push   %esi
f0104fdd:	83 ec 04             	sub    $0x4,%esp
f0104fe0:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104fe3:	ff 75 e0             	pushl  -0x20(%ebp)
f0104fe6:	ff 75 dc             	pushl  -0x24(%ebp)
f0104fe9:	ff 75 d8             	pushl  -0x28(%ebp)
f0104fec:	e8 af 18 00 00       	call   f01068a0 <__umoddi3>
f0104ff1:	83 c4 14             	add    $0x14,%esp
f0104ff4:	0f be 80 92 81 10 f0 	movsbl -0xfef7e6e(%eax),%eax
f0104ffb:	50                   	push   %eax
f0104ffc:	ff d7                	call   *%edi
}
f0104ffe:	83 c4 10             	add    $0x10,%esp
f0105001:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105004:	5b                   	pop    %ebx
f0105005:	5e                   	pop    %esi
f0105006:	5f                   	pop    %edi
f0105007:	5d                   	pop    %ebp
f0105008:	c3                   	ret    

f0105009 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105009:	f3 0f 1e fb          	endbr32 
f010500d:	55                   	push   %ebp
f010500e:	89 e5                	mov    %esp,%ebp
f0105010:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105013:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105017:	8b 10                	mov    (%eax),%edx
f0105019:	3b 50 04             	cmp    0x4(%eax),%edx
f010501c:	73 0a                	jae    f0105028 <sprintputch+0x1f>
		*b->buf++ = ch;
f010501e:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105021:	89 08                	mov    %ecx,(%eax)
f0105023:	8b 45 08             	mov    0x8(%ebp),%eax
f0105026:	88 02                	mov    %al,(%edx)
}
f0105028:	5d                   	pop    %ebp
f0105029:	c3                   	ret    

f010502a <printfmt>:
{
f010502a:	f3 0f 1e fb          	endbr32 
f010502e:	55                   	push   %ebp
f010502f:	89 e5                	mov    %esp,%ebp
f0105031:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105034:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105037:	50                   	push   %eax
f0105038:	ff 75 10             	pushl  0x10(%ebp)
f010503b:	ff 75 0c             	pushl  0xc(%ebp)
f010503e:	ff 75 08             	pushl  0x8(%ebp)
f0105041:	e8 05 00 00 00       	call   f010504b <vprintfmt>
}
f0105046:	83 c4 10             	add    $0x10,%esp
f0105049:	c9                   	leave  
f010504a:	c3                   	ret    

f010504b <vprintfmt>:
{
f010504b:	f3 0f 1e fb          	endbr32 
f010504f:	55                   	push   %ebp
f0105050:	89 e5                	mov    %esp,%ebp
f0105052:	57                   	push   %edi
f0105053:	56                   	push   %esi
f0105054:	53                   	push   %ebx
f0105055:	83 ec 3c             	sub    $0x3c,%esp
f0105058:	8b 75 08             	mov    0x8(%ebp),%esi
f010505b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010505e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105061:	e9 8e 03 00 00       	jmp    f01053f4 <vprintfmt+0x3a9>
		padc = ' ';
f0105066:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
f010506a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
f0105071:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
f0105078:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f010507f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105084:	8d 47 01             	lea    0x1(%edi),%eax
f0105087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010508a:	0f b6 17             	movzbl (%edi),%edx
f010508d:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105090:	3c 55                	cmp    $0x55,%al
f0105092:	0f 87 df 03 00 00    	ja     f0105477 <vprintfmt+0x42c>
f0105098:	0f b6 c0             	movzbl %al,%eax
f010509b:	3e ff 24 85 e0 82 10 	notrack jmp *-0xfef7d20(,%eax,4)
f01050a2:	f0 
f01050a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01050a6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
f01050aa:	eb d8                	jmp    f0105084 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f01050ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01050af:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
f01050b3:	eb cf                	jmp    f0105084 <vprintfmt+0x39>
f01050b5:	0f b6 d2             	movzbl %dl,%edx
f01050b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01050bb:	b8 00 00 00 00       	mov    $0x0,%eax
f01050c0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01050c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01050c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01050ca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01050cd:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01050d0:	83 f9 09             	cmp    $0x9,%ecx
f01050d3:	77 55                	ja     f010512a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
f01050d5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01050d8:	eb e9                	jmp    f01050c3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
f01050da:	8b 45 14             	mov    0x14(%ebp),%eax
f01050dd:	8b 00                	mov    (%eax),%eax
f01050df:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01050e2:	8b 45 14             	mov    0x14(%ebp),%eax
f01050e5:	8d 40 04             	lea    0x4(%eax),%eax
f01050e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01050eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01050ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01050f2:	79 90                	jns    f0105084 <vprintfmt+0x39>
				width = precision, precision = -1;
f01050f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01050f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01050fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
f0105101:	eb 81                	jmp    f0105084 <vprintfmt+0x39>
f0105103:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105106:	85 c0                	test   %eax,%eax
f0105108:	ba 00 00 00 00       	mov    $0x0,%edx
f010510d:	0f 49 d0             	cmovns %eax,%edx
f0105110:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105113:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105116:	e9 69 ff ff ff       	jmp    f0105084 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
f010511b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010511e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
f0105125:	e9 5a ff ff ff       	jmp    f0105084 <vprintfmt+0x39>
f010512a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010512d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105130:	eb bc                	jmp    f01050ee <vprintfmt+0xa3>
			lflag++;
f0105132:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105135:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105138:	e9 47 ff ff ff       	jmp    f0105084 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
f010513d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105140:	8d 78 04             	lea    0x4(%eax),%edi
f0105143:	83 ec 08             	sub    $0x8,%esp
f0105146:	53                   	push   %ebx
f0105147:	ff 30                	pushl  (%eax)
f0105149:	ff d6                	call   *%esi
			break;
f010514b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010514e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0105151:	e9 9b 02 00 00       	jmp    f01053f1 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
f0105156:	8b 45 14             	mov    0x14(%ebp),%eax
f0105159:	8d 78 04             	lea    0x4(%eax),%edi
f010515c:	8b 00                	mov    (%eax),%eax
f010515e:	99                   	cltd   
f010515f:	31 d0                	xor    %edx,%eax
f0105161:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105163:	83 f8 0f             	cmp    $0xf,%eax
f0105166:	7f 23                	jg     f010518b <vprintfmt+0x140>
f0105168:	8b 14 85 40 84 10 f0 	mov    -0xfef7bc0(,%eax,4),%edx
f010516f:	85 d2                	test   %edx,%edx
f0105171:	74 18                	je     f010518b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
f0105173:	52                   	push   %edx
f0105174:	68 c7 6f 10 f0       	push   $0xf0106fc7
f0105179:	53                   	push   %ebx
f010517a:	56                   	push   %esi
f010517b:	e8 aa fe ff ff       	call   f010502a <printfmt>
f0105180:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105183:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105186:	e9 66 02 00 00       	jmp    f01053f1 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
f010518b:	50                   	push   %eax
f010518c:	68 aa 81 10 f0       	push   $0xf01081aa
f0105191:	53                   	push   %ebx
f0105192:	56                   	push   %esi
f0105193:	e8 92 fe ff ff       	call   f010502a <printfmt>
f0105198:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010519b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f010519e:	e9 4e 02 00 00       	jmp    f01053f1 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
f01051a3:	8b 45 14             	mov    0x14(%ebp),%eax
f01051a6:	83 c0 04             	add    $0x4,%eax
f01051a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01051ac:	8b 45 14             	mov    0x14(%ebp),%eax
f01051af:	8b 10                	mov    (%eax),%edx
				p = "(null)";
f01051b1:	85 d2                	test   %edx,%edx
f01051b3:	b8 a3 81 10 f0       	mov    $0xf01081a3,%eax
f01051b8:	0f 45 c2             	cmovne %edx,%eax
f01051bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
f01051be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01051c2:	7e 06                	jle    f01051ca <vprintfmt+0x17f>
f01051c4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
f01051c8:	75 0d                	jne    f01051d7 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
f01051ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01051cd:	89 c7                	mov    %eax,%edi
f01051cf:	03 45 e0             	add    -0x20(%ebp),%eax
f01051d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01051d5:	eb 55                	jmp    f010522c <vprintfmt+0x1e1>
f01051d7:	83 ec 08             	sub    $0x8,%esp
f01051da:	ff 75 d8             	pushl  -0x28(%ebp)
f01051dd:	ff 75 cc             	pushl  -0x34(%ebp)
f01051e0:	e8 38 04 00 00       	call   f010561d <strnlen>
f01051e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01051e8:	29 c2                	sub    %eax,%edx
f01051ea:	89 55 c4             	mov    %edx,-0x3c(%ebp)
f01051ed:	83 c4 10             	add    $0x10,%esp
f01051f0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
f01051f2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
f01051f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
f01051f9:	85 ff                	test   %edi,%edi
f01051fb:	7e 11                	jle    f010520e <vprintfmt+0x1c3>
					putch(padc, putdat);
f01051fd:	83 ec 08             	sub    $0x8,%esp
f0105200:	53                   	push   %ebx
f0105201:	ff 75 e0             	pushl  -0x20(%ebp)
f0105204:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105206:	83 ef 01             	sub    $0x1,%edi
f0105209:	83 c4 10             	add    $0x10,%esp
f010520c:	eb eb                	jmp    f01051f9 <vprintfmt+0x1ae>
f010520e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0105211:	85 d2                	test   %edx,%edx
f0105213:	b8 00 00 00 00       	mov    $0x0,%eax
f0105218:	0f 49 c2             	cmovns %edx,%eax
f010521b:	29 c2                	sub    %eax,%edx
f010521d:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0105220:	eb a8                	jmp    f01051ca <vprintfmt+0x17f>
					putch(ch, putdat);
f0105222:	83 ec 08             	sub    $0x8,%esp
f0105225:	53                   	push   %ebx
f0105226:	52                   	push   %edx
f0105227:	ff d6                	call   *%esi
f0105229:	83 c4 10             	add    $0x10,%esp
f010522c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010522f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105231:	83 c7 01             	add    $0x1,%edi
f0105234:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f0105238:	0f be d0             	movsbl %al,%edx
f010523b:	85 d2                	test   %edx,%edx
f010523d:	74 4b                	je     f010528a <vprintfmt+0x23f>
f010523f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105243:	78 06                	js     f010524b <vprintfmt+0x200>
f0105245:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
f0105249:	78 1e                	js     f0105269 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
f010524b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f010524f:	74 d1                	je     f0105222 <vprintfmt+0x1d7>
f0105251:	0f be c0             	movsbl %al,%eax
f0105254:	83 e8 20             	sub    $0x20,%eax
f0105257:	83 f8 5e             	cmp    $0x5e,%eax
f010525a:	76 c6                	jbe    f0105222 <vprintfmt+0x1d7>
					putch('?', putdat);
f010525c:	83 ec 08             	sub    $0x8,%esp
f010525f:	53                   	push   %ebx
f0105260:	6a 3f                	push   $0x3f
f0105262:	ff d6                	call   *%esi
f0105264:	83 c4 10             	add    $0x10,%esp
f0105267:	eb c3                	jmp    f010522c <vprintfmt+0x1e1>
f0105269:	89 cf                	mov    %ecx,%edi
f010526b:	eb 0e                	jmp    f010527b <vprintfmt+0x230>
				putch(' ', putdat);
f010526d:	83 ec 08             	sub    $0x8,%esp
f0105270:	53                   	push   %ebx
f0105271:	6a 20                	push   $0x20
f0105273:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0105275:	83 ef 01             	sub    $0x1,%edi
f0105278:	83 c4 10             	add    $0x10,%esp
f010527b:	85 ff                	test   %edi,%edi
f010527d:	7f ee                	jg     f010526d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
f010527f:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105282:	89 45 14             	mov    %eax,0x14(%ebp)
f0105285:	e9 67 01 00 00       	jmp    f01053f1 <vprintfmt+0x3a6>
f010528a:	89 cf                	mov    %ecx,%edi
f010528c:	eb ed                	jmp    f010527b <vprintfmt+0x230>
	if (lflag >= 2)
f010528e:	83 f9 01             	cmp    $0x1,%ecx
f0105291:	7f 1b                	jg     f01052ae <vprintfmt+0x263>
	else if (lflag)
f0105293:	85 c9                	test   %ecx,%ecx
f0105295:	74 63                	je     f01052fa <vprintfmt+0x2af>
		return va_arg(*ap, long);
f0105297:	8b 45 14             	mov    0x14(%ebp),%eax
f010529a:	8b 00                	mov    (%eax),%eax
f010529c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010529f:	99                   	cltd   
f01052a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01052a3:	8b 45 14             	mov    0x14(%ebp),%eax
f01052a6:	8d 40 04             	lea    0x4(%eax),%eax
f01052a9:	89 45 14             	mov    %eax,0x14(%ebp)
f01052ac:	eb 17                	jmp    f01052c5 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
f01052ae:	8b 45 14             	mov    0x14(%ebp),%eax
f01052b1:	8b 50 04             	mov    0x4(%eax),%edx
f01052b4:	8b 00                	mov    (%eax),%eax
f01052b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01052b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01052bc:	8b 45 14             	mov    0x14(%ebp),%eax
f01052bf:	8d 40 08             	lea    0x8(%eax),%eax
f01052c2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01052c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01052c8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f01052cb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01052d0:	85 c9                	test   %ecx,%ecx
f01052d2:	0f 89 ff 00 00 00    	jns    f01053d7 <vprintfmt+0x38c>
				putch('-', putdat);
f01052d8:	83 ec 08             	sub    $0x8,%esp
f01052db:	53                   	push   %ebx
f01052dc:	6a 2d                	push   $0x2d
f01052de:	ff d6                	call   *%esi
				num = -(long long) num;
f01052e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01052e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01052e6:	f7 da                	neg    %edx
f01052e8:	83 d1 00             	adc    $0x0,%ecx
f01052eb:	f7 d9                	neg    %ecx
f01052ed:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01052f0:	b8 0a 00 00 00       	mov    $0xa,%eax
f01052f5:	e9 dd 00 00 00       	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, int);
f01052fa:	8b 45 14             	mov    0x14(%ebp),%eax
f01052fd:	8b 00                	mov    (%eax),%eax
f01052ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105302:	99                   	cltd   
f0105303:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105306:	8b 45 14             	mov    0x14(%ebp),%eax
f0105309:	8d 40 04             	lea    0x4(%eax),%eax
f010530c:	89 45 14             	mov    %eax,0x14(%ebp)
f010530f:	eb b4                	jmp    f01052c5 <vprintfmt+0x27a>
	if (lflag >= 2)
f0105311:	83 f9 01             	cmp    $0x1,%ecx
f0105314:	7f 1e                	jg     f0105334 <vprintfmt+0x2e9>
	else if (lflag)
f0105316:	85 c9                	test   %ecx,%ecx
f0105318:	74 32                	je     f010534c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
f010531a:	8b 45 14             	mov    0x14(%ebp),%eax
f010531d:	8b 10                	mov    (%eax),%edx
f010531f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105324:	8d 40 04             	lea    0x4(%eax),%eax
f0105327:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010532a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
f010532f:	e9 a3 00 00 00       	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105334:	8b 45 14             	mov    0x14(%ebp),%eax
f0105337:	8b 10                	mov    (%eax),%edx
f0105339:	8b 48 04             	mov    0x4(%eax),%ecx
f010533c:	8d 40 08             	lea    0x8(%eax),%eax
f010533f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105342:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
f0105347:	e9 8b 00 00 00       	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f010534c:	8b 45 14             	mov    0x14(%ebp),%eax
f010534f:	8b 10                	mov    (%eax),%edx
f0105351:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105356:	8d 40 04             	lea    0x4(%eax),%eax
f0105359:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010535c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
f0105361:	eb 74                	jmp    f01053d7 <vprintfmt+0x38c>
	if (lflag >= 2)
f0105363:	83 f9 01             	cmp    $0x1,%ecx
f0105366:	7f 1b                	jg     f0105383 <vprintfmt+0x338>
	else if (lflag)
f0105368:	85 c9                	test   %ecx,%ecx
f010536a:	74 2c                	je     f0105398 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
f010536c:	8b 45 14             	mov    0x14(%ebp),%eax
f010536f:	8b 10                	mov    (%eax),%edx
f0105371:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105376:	8d 40 04             	lea    0x4(%eax),%eax
f0105379:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010537c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
f0105381:	eb 54                	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105383:	8b 45 14             	mov    0x14(%ebp),%eax
f0105386:	8b 10                	mov    (%eax),%edx
f0105388:	8b 48 04             	mov    0x4(%eax),%ecx
f010538b:	8d 40 08             	lea    0x8(%eax),%eax
f010538e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105391:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
f0105396:	eb 3f                	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f0105398:	8b 45 14             	mov    0x14(%ebp),%eax
f010539b:	8b 10                	mov    (%eax),%edx
f010539d:	b9 00 00 00 00       	mov    $0x0,%ecx
f01053a2:	8d 40 04             	lea    0x4(%eax),%eax
f01053a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01053a8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
f01053ad:	eb 28                	jmp    f01053d7 <vprintfmt+0x38c>
			putch('0', putdat);
f01053af:	83 ec 08             	sub    $0x8,%esp
f01053b2:	53                   	push   %ebx
f01053b3:	6a 30                	push   $0x30
f01053b5:	ff d6                	call   *%esi
			putch('x', putdat);
f01053b7:	83 c4 08             	add    $0x8,%esp
f01053ba:	53                   	push   %ebx
f01053bb:	6a 78                	push   $0x78
f01053bd:	ff d6                	call   *%esi
			num = (unsigned long long)
f01053bf:	8b 45 14             	mov    0x14(%ebp),%eax
f01053c2:	8b 10                	mov    (%eax),%edx
f01053c4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01053c9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01053cc:	8d 40 04             	lea    0x4(%eax),%eax
f01053cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01053d2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01053d7:	83 ec 0c             	sub    $0xc,%esp
f01053da:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
f01053de:	57                   	push   %edi
f01053df:	ff 75 e0             	pushl  -0x20(%ebp)
f01053e2:	50                   	push   %eax
f01053e3:	51                   	push   %ecx
f01053e4:	52                   	push   %edx
f01053e5:	89 da                	mov    %ebx,%edx
f01053e7:	89 f0                	mov    %esi,%eax
f01053e9:	e8 72 fb ff ff       	call   f0104f60 <printnum>
			break;
f01053ee:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
f01053f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01053f4:	83 c7 01             	add    $0x1,%edi
f01053f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01053fb:	83 f8 25             	cmp    $0x25,%eax
f01053fe:	0f 84 62 fc ff ff    	je     f0105066 <vprintfmt+0x1b>
			if (ch == '\0')
f0105404:	85 c0                	test   %eax,%eax
f0105406:	0f 84 8b 00 00 00    	je     f0105497 <vprintfmt+0x44c>
			putch(ch, putdat);
f010540c:	83 ec 08             	sub    $0x8,%esp
f010540f:	53                   	push   %ebx
f0105410:	50                   	push   %eax
f0105411:	ff d6                	call   *%esi
f0105413:	83 c4 10             	add    $0x10,%esp
f0105416:	eb dc                	jmp    f01053f4 <vprintfmt+0x3a9>
	if (lflag >= 2)
f0105418:	83 f9 01             	cmp    $0x1,%ecx
f010541b:	7f 1b                	jg     f0105438 <vprintfmt+0x3ed>
	else if (lflag)
f010541d:	85 c9                	test   %ecx,%ecx
f010541f:	74 2c                	je     f010544d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
f0105421:	8b 45 14             	mov    0x14(%ebp),%eax
f0105424:	8b 10                	mov    (%eax),%edx
f0105426:	b9 00 00 00 00       	mov    $0x0,%ecx
f010542b:	8d 40 04             	lea    0x4(%eax),%eax
f010542e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105431:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
f0105436:	eb 9f                	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
f0105438:	8b 45 14             	mov    0x14(%ebp),%eax
f010543b:	8b 10                	mov    (%eax),%edx
f010543d:	8b 48 04             	mov    0x4(%eax),%ecx
f0105440:	8d 40 08             	lea    0x8(%eax),%eax
f0105443:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105446:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
f010544b:	eb 8a                	jmp    f01053d7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
f010544d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105450:	8b 10                	mov    (%eax),%edx
f0105452:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105457:	8d 40 04             	lea    0x4(%eax),%eax
f010545a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010545d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
f0105462:	e9 70 ff ff ff       	jmp    f01053d7 <vprintfmt+0x38c>
			putch(ch, putdat);
f0105467:	83 ec 08             	sub    $0x8,%esp
f010546a:	53                   	push   %ebx
f010546b:	6a 25                	push   $0x25
f010546d:	ff d6                	call   *%esi
			break;
f010546f:	83 c4 10             	add    $0x10,%esp
f0105472:	e9 7a ff ff ff       	jmp    f01053f1 <vprintfmt+0x3a6>
			putch('%', putdat);
f0105477:	83 ec 08             	sub    $0x8,%esp
f010547a:	53                   	push   %ebx
f010547b:	6a 25                	push   $0x25
f010547d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010547f:	83 c4 10             	add    $0x10,%esp
f0105482:	89 f8                	mov    %edi,%eax
f0105484:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105488:	74 05                	je     f010548f <vprintfmt+0x444>
f010548a:	83 e8 01             	sub    $0x1,%eax
f010548d:	eb f5                	jmp    f0105484 <vprintfmt+0x439>
f010548f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105492:	e9 5a ff ff ff       	jmp    f01053f1 <vprintfmt+0x3a6>
}
f0105497:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010549a:	5b                   	pop    %ebx
f010549b:	5e                   	pop    %esi
f010549c:	5f                   	pop    %edi
f010549d:	5d                   	pop    %ebp
f010549e:	c3                   	ret    

f010549f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010549f:	f3 0f 1e fb          	endbr32 
f01054a3:	55                   	push   %ebp
f01054a4:	89 e5                	mov    %esp,%ebp
f01054a6:	83 ec 18             	sub    $0x18,%esp
f01054a9:	8b 45 08             	mov    0x8(%ebp),%eax
f01054ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01054af:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01054b2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01054b6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01054b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01054c0:	85 c0                	test   %eax,%eax
f01054c2:	74 26                	je     f01054ea <vsnprintf+0x4b>
f01054c4:	85 d2                	test   %edx,%edx
f01054c6:	7e 22                	jle    f01054ea <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01054c8:	ff 75 14             	pushl  0x14(%ebp)
f01054cb:	ff 75 10             	pushl  0x10(%ebp)
f01054ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01054d1:	50                   	push   %eax
f01054d2:	68 09 50 10 f0       	push   $0xf0105009
f01054d7:	e8 6f fb ff ff       	call   f010504b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01054dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01054df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01054e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01054e5:	83 c4 10             	add    $0x10,%esp
}
f01054e8:	c9                   	leave  
f01054e9:	c3                   	ret    
		return -E_INVAL;
f01054ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01054ef:	eb f7                	jmp    f01054e8 <vsnprintf+0x49>

f01054f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01054f1:	f3 0f 1e fb          	endbr32 
f01054f5:	55                   	push   %ebp
f01054f6:	89 e5                	mov    %esp,%ebp
f01054f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01054fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01054fe:	50                   	push   %eax
f01054ff:	ff 75 10             	pushl  0x10(%ebp)
f0105502:	ff 75 0c             	pushl  0xc(%ebp)
f0105505:	ff 75 08             	pushl  0x8(%ebp)
f0105508:	e8 92 ff ff ff       	call   f010549f <vsnprintf>
	va_end(ap);

	return rc;
}
f010550d:	c9                   	leave  
f010550e:	c3                   	ret    

f010550f <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f010550f:	f3 0f 1e fb          	endbr32 
f0105513:	55                   	push   %ebp
f0105514:	89 e5                	mov    %esp,%ebp
f0105516:	57                   	push   %edi
f0105517:	56                   	push   %esi
f0105518:	53                   	push   %ebx
f0105519:	83 ec 0c             	sub    $0xc,%esp
f010551c:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010551f:	85 c0                	test   %eax,%eax
f0105521:	74 11                	je     f0105534 <readline+0x25>
		cprintf("%s", prompt);
f0105523:	83 ec 08             	sub    $0x8,%esp
f0105526:	50                   	push   %eax
f0105527:	68 c7 6f 10 f0       	push   $0xf0106fc7
f010552c:	e8 36 e4 ff ff       	call   f0103967 <cprintf>
f0105531:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105534:	83 ec 0c             	sub    $0xc,%esp
f0105537:	6a 00                	push   $0x0
f0105539:	e8 9e b2 ff ff       	call   f01007dc <iscons>
f010553e:	89 c7                	mov    %eax,%edi
f0105540:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105543:	be 00 00 00 00       	mov    $0x0,%esi
f0105548:	eb 57                	jmp    f01055a1 <readline+0x92>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010554a:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f010554f:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105552:	75 08                	jne    f010555c <readline+0x4d>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0105554:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105557:	5b                   	pop    %ebx
f0105558:	5e                   	pop    %esi
f0105559:	5f                   	pop    %edi
f010555a:	5d                   	pop    %ebp
f010555b:	c3                   	ret    
				cprintf("read error: %e\n", c);
f010555c:	83 ec 08             	sub    $0x8,%esp
f010555f:	53                   	push   %ebx
f0105560:	68 9f 84 10 f0       	push   $0xf010849f
f0105565:	e8 fd e3 ff ff       	call   f0103967 <cprintf>
f010556a:	83 c4 10             	add    $0x10,%esp
			return NULL;
f010556d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105572:	eb e0                	jmp    f0105554 <readline+0x45>
			if (echoing)
f0105574:	85 ff                	test   %edi,%edi
f0105576:	75 05                	jne    f010557d <readline+0x6e>
			i--;
f0105578:	83 ee 01             	sub    $0x1,%esi
f010557b:	eb 24                	jmp    f01055a1 <readline+0x92>
				cputchar('\b');
f010557d:	83 ec 0c             	sub    $0xc,%esp
f0105580:	6a 08                	push   $0x8
f0105582:	e8 2c b2 ff ff       	call   f01007b3 <cputchar>
f0105587:	83 c4 10             	add    $0x10,%esp
f010558a:	eb ec                	jmp    f0105578 <readline+0x69>
				cputchar(c);
f010558c:	83 ec 0c             	sub    $0xc,%esp
f010558f:	53                   	push   %ebx
f0105590:	e8 1e b2 ff ff       	call   f01007b3 <cputchar>
f0105595:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f0105598:	88 9e 80 ea 2b f0    	mov    %bl,-0xfd41580(%esi)
f010559e:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01055a1:	e8 21 b2 ff ff       	call   f01007c7 <getchar>
f01055a6:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01055a8:	85 c0                	test   %eax,%eax
f01055aa:	78 9e                	js     f010554a <readline+0x3b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01055ac:	83 f8 08             	cmp    $0x8,%eax
f01055af:	0f 94 c2             	sete   %dl
f01055b2:	83 f8 7f             	cmp    $0x7f,%eax
f01055b5:	0f 94 c0             	sete   %al
f01055b8:	08 c2                	or     %al,%dl
f01055ba:	74 04                	je     f01055c0 <readline+0xb1>
f01055bc:	85 f6                	test   %esi,%esi
f01055be:	7f b4                	jg     f0105574 <readline+0x65>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01055c0:	83 fb 1f             	cmp    $0x1f,%ebx
f01055c3:	7e 0e                	jle    f01055d3 <readline+0xc4>
f01055c5:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01055cb:	7f 06                	jg     f01055d3 <readline+0xc4>
			if (echoing)
f01055cd:	85 ff                	test   %edi,%edi
f01055cf:	74 c7                	je     f0105598 <readline+0x89>
f01055d1:	eb b9                	jmp    f010558c <readline+0x7d>
		} else if (c == '\n' || c == '\r') {
f01055d3:	83 fb 0a             	cmp    $0xa,%ebx
f01055d6:	74 05                	je     f01055dd <readline+0xce>
f01055d8:	83 fb 0d             	cmp    $0xd,%ebx
f01055db:	75 c4                	jne    f01055a1 <readline+0x92>
			if (echoing)
f01055dd:	85 ff                	test   %edi,%edi
f01055df:	75 11                	jne    f01055f2 <readline+0xe3>
			buf[i] = 0;
f01055e1:	c6 86 80 ea 2b f0 00 	movb   $0x0,-0xfd41580(%esi)
			return buf;
f01055e8:	b8 80 ea 2b f0       	mov    $0xf02bea80,%eax
f01055ed:	e9 62 ff ff ff       	jmp    f0105554 <readline+0x45>
				cputchar('\n');
f01055f2:	83 ec 0c             	sub    $0xc,%esp
f01055f5:	6a 0a                	push   $0xa
f01055f7:	e8 b7 b1 ff ff       	call   f01007b3 <cputchar>
f01055fc:	83 c4 10             	add    $0x10,%esp
f01055ff:	eb e0                	jmp    f01055e1 <readline+0xd2>

f0105601 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105601:	f3 0f 1e fb          	endbr32 
f0105605:	55                   	push   %ebp
f0105606:	89 e5                	mov    %esp,%ebp
f0105608:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010560b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105610:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105614:	74 05                	je     f010561b <strlen+0x1a>
		n++;
f0105616:	83 c0 01             	add    $0x1,%eax
f0105619:	eb f5                	jmp    f0105610 <strlen+0xf>
	return n;
}
f010561b:	5d                   	pop    %ebp
f010561c:	c3                   	ret    

f010561d <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010561d:	f3 0f 1e fb          	endbr32 
f0105621:	55                   	push   %ebp
f0105622:	89 e5                	mov    %esp,%ebp
f0105624:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105627:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010562a:	b8 00 00 00 00       	mov    $0x0,%eax
f010562f:	39 d0                	cmp    %edx,%eax
f0105631:	74 0d                	je     f0105640 <strnlen+0x23>
f0105633:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105637:	74 05                	je     f010563e <strnlen+0x21>
		n++;
f0105639:	83 c0 01             	add    $0x1,%eax
f010563c:	eb f1                	jmp    f010562f <strnlen+0x12>
f010563e:	89 c2                	mov    %eax,%edx
	return n;
}
f0105640:	89 d0                	mov    %edx,%eax
f0105642:	5d                   	pop    %ebp
f0105643:	c3                   	ret    

f0105644 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105644:	f3 0f 1e fb          	endbr32 
f0105648:	55                   	push   %ebp
f0105649:	89 e5                	mov    %esp,%ebp
f010564b:	53                   	push   %ebx
f010564c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010564f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105652:	b8 00 00 00 00       	mov    $0x0,%eax
f0105657:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
f010565b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
f010565e:	83 c0 01             	add    $0x1,%eax
f0105661:	84 d2                	test   %dl,%dl
f0105663:	75 f2                	jne    f0105657 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
f0105665:	89 c8                	mov    %ecx,%eax
f0105667:	5b                   	pop    %ebx
f0105668:	5d                   	pop    %ebp
f0105669:	c3                   	ret    

f010566a <strcat>:

char *
strcat(char *dst, const char *src)
{
f010566a:	f3 0f 1e fb          	endbr32 
f010566e:	55                   	push   %ebp
f010566f:	89 e5                	mov    %esp,%ebp
f0105671:	53                   	push   %ebx
f0105672:	83 ec 10             	sub    $0x10,%esp
f0105675:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105678:	53                   	push   %ebx
f0105679:	e8 83 ff ff ff       	call   f0105601 <strlen>
f010567e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
f0105681:	ff 75 0c             	pushl  0xc(%ebp)
f0105684:	01 d8                	add    %ebx,%eax
f0105686:	50                   	push   %eax
f0105687:	e8 b8 ff ff ff       	call   f0105644 <strcpy>
	return dst;
}
f010568c:	89 d8                	mov    %ebx,%eax
f010568e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105691:	c9                   	leave  
f0105692:	c3                   	ret    

f0105693 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105693:	f3 0f 1e fb          	endbr32 
f0105697:	55                   	push   %ebp
f0105698:	89 e5                	mov    %esp,%ebp
f010569a:	56                   	push   %esi
f010569b:	53                   	push   %ebx
f010569c:	8b 75 08             	mov    0x8(%ebp),%esi
f010569f:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056a2:	89 f3                	mov    %esi,%ebx
f01056a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01056a7:	89 f0                	mov    %esi,%eax
f01056a9:	39 d8                	cmp    %ebx,%eax
f01056ab:	74 11                	je     f01056be <strncpy+0x2b>
		*dst++ = *src;
f01056ad:	83 c0 01             	add    $0x1,%eax
f01056b0:	0f b6 0a             	movzbl (%edx),%ecx
f01056b3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01056b6:	80 f9 01             	cmp    $0x1,%cl
f01056b9:	83 da ff             	sbb    $0xffffffff,%edx
f01056bc:	eb eb                	jmp    f01056a9 <strncpy+0x16>
	}
	return ret;
}
f01056be:	89 f0                	mov    %esi,%eax
f01056c0:	5b                   	pop    %ebx
f01056c1:	5e                   	pop    %esi
f01056c2:	5d                   	pop    %ebp
f01056c3:	c3                   	ret    

f01056c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01056c4:	f3 0f 1e fb          	endbr32 
f01056c8:	55                   	push   %ebp
f01056c9:	89 e5                	mov    %esp,%ebp
f01056cb:	56                   	push   %esi
f01056cc:	53                   	push   %ebx
f01056cd:	8b 75 08             	mov    0x8(%ebp),%esi
f01056d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01056d3:	8b 55 10             	mov    0x10(%ebp),%edx
f01056d6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01056d8:	85 d2                	test   %edx,%edx
f01056da:	74 21                	je     f01056fd <strlcpy+0x39>
f01056dc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
f01056e0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
f01056e2:	39 c2                	cmp    %eax,%edx
f01056e4:	74 14                	je     f01056fa <strlcpy+0x36>
f01056e6:	0f b6 19             	movzbl (%ecx),%ebx
f01056e9:	84 db                	test   %bl,%bl
f01056eb:	74 0b                	je     f01056f8 <strlcpy+0x34>
			*dst++ = *src++;
f01056ed:	83 c1 01             	add    $0x1,%ecx
f01056f0:	83 c2 01             	add    $0x1,%edx
f01056f3:	88 5a ff             	mov    %bl,-0x1(%edx)
f01056f6:	eb ea                	jmp    f01056e2 <strlcpy+0x1e>
f01056f8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
f01056fa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01056fd:	29 f0                	sub    %esi,%eax
}
f01056ff:	5b                   	pop    %ebx
f0105700:	5e                   	pop    %esi
f0105701:	5d                   	pop    %ebp
f0105702:	c3                   	ret    

f0105703 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105703:	f3 0f 1e fb          	endbr32 
f0105707:	55                   	push   %ebp
f0105708:	89 e5                	mov    %esp,%ebp
f010570a:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010570d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105710:	0f b6 01             	movzbl (%ecx),%eax
f0105713:	84 c0                	test   %al,%al
f0105715:	74 0c                	je     f0105723 <strcmp+0x20>
f0105717:	3a 02                	cmp    (%edx),%al
f0105719:	75 08                	jne    f0105723 <strcmp+0x20>
		p++, q++;
f010571b:	83 c1 01             	add    $0x1,%ecx
f010571e:	83 c2 01             	add    $0x1,%edx
f0105721:	eb ed                	jmp    f0105710 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105723:	0f b6 c0             	movzbl %al,%eax
f0105726:	0f b6 12             	movzbl (%edx),%edx
f0105729:	29 d0                	sub    %edx,%eax
}
f010572b:	5d                   	pop    %ebp
f010572c:	c3                   	ret    

f010572d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f010572d:	f3 0f 1e fb          	endbr32 
f0105731:	55                   	push   %ebp
f0105732:	89 e5                	mov    %esp,%ebp
f0105734:	53                   	push   %ebx
f0105735:	8b 45 08             	mov    0x8(%ebp),%eax
f0105738:	8b 55 0c             	mov    0xc(%ebp),%edx
f010573b:	89 c3                	mov    %eax,%ebx
f010573d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105740:	eb 06                	jmp    f0105748 <strncmp+0x1b>
		n--, p++, q++;
f0105742:	83 c0 01             	add    $0x1,%eax
f0105745:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105748:	39 d8                	cmp    %ebx,%eax
f010574a:	74 16                	je     f0105762 <strncmp+0x35>
f010574c:	0f b6 08             	movzbl (%eax),%ecx
f010574f:	84 c9                	test   %cl,%cl
f0105751:	74 04                	je     f0105757 <strncmp+0x2a>
f0105753:	3a 0a                	cmp    (%edx),%cl
f0105755:	74 eb                	je     f0105742 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105757:	0f b6 00             	movzbl (%eax),%eax
f010575a:	0f b6 12             	movzbl (%edx),%edx
f010575d:	29 d0                	sub    %edx,%eax
}
f010575f:	5b                   	pop    %ebx
f0105760:	5d                   	pop    %ebp
f0105761:	c3                   	ret    
		return 0;
f0105762:	b8 00 00 00 00       	mov    $0x0,%eax
f0105767:	eb f6                	jmp    f010575f <strncmp+0x32>

f0105769 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105769:	f3 0f 1e fb          	endbr32 
f010576d:	55                   	push   %ebp
f010576e:	89 e5                	mov    %esp,%ebp
f0105770:	8b 45 08             	mov    0x8(%ebp),%eax
f0105773:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105777:	0f b6 10             	movzbl (%eax),%edx
f010577a:	84 d2                	test   %dl,%dl
f010577c:	74 09                	je     f0105787 <strchr+0x1e>
		if (*s == c)
f010577e:	38 ca                	cmp    %cl,%dl
f0105780:	74 0a                	je     f010578c <strchr+0x23>
	for (; *s; s++)
f0105782:	83 c0 01             	add    $0x1,%eax
f0105785:	eb f0                	jmp    f0105777 <strchr+0xe>
			return (char *) s;
	return 0;
f0105787:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010578c:	5d                   	pop    %ebp
f010578d:	c3                   	ret    

f010578e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010578e:	f3 0f 1e fb          	endbr32 
f0105792:	55                   	push   %ebp
f0105793:	89 e5                	mov    %esp,%ebp
f0105795:	8b 45 08             	mov    0x8(%ebp),%eax
f0105798:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010579c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f010579f:	38 ca                	cmp    %cl,%dl
f01057a1:	74 09                	je     f01057ac <strfind+0x1e>
f01057a3:	84 d2                	test   %dl,%dl
f01057a5:	74 05                	je     f01057ac <strfind+0x1e>
	for (; *s; s++)
f01057a7:	83 c0 01             	add    $0x1,%eax
f01057aa:	eb f0                	jmp    f010579c <strfind+0xe>
			break;
	return (char *) s;
}
f01057ac:	5d                   	pop    %ebp
f01057ad:	c3                   	ret    

f01057ae <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01057ae:	f3 0f 1e fb          	endbr32 
f01057b2:	55                   	push   %ebp
f01057b3:	89 e5                	mov    %esp,%ebp
f01057b5:	57                   	push   %edi
f01057b6:	56                   	push   %esi
f01057b7:	53                   	push   %ebx
f01057b8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01057bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01057be:	85 c9                	test   %ecx,%ecx
f01057c0:	74 31                	je     f01057f3 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01057c2:	89 f8                	mov    %edi,%eax
f01057c4:	09 c8                	or     %ecx,%eax
f01057c6:	a8 03                	test   $0x3,%al
f01057c8:	75 23                	jne    f01057ed <memset+0x3f>
		c &= 0xFF;
f01057ca:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01057ce:	89 d3                	mov    %edx,%ebx
f01057d0:	c1 e3 08             	shl    $0x8,%ebx
f01057d3:	89 d0                	mov    %edx,%eax
f01057d5:	c1 e0 18             	shl    $0x18,%eax
f01057d8:	89 d6                	mov    %edx,%esi
f01057da:	c1 e6 10             	shl    $0x10,%esi
f01057dd:	09 f0                	or     %esi,%eax
f01057df:	09 c2                	or     %eax,%edx
f01057e1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01057e3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f01057e6:	89 d0                	mov    %edx,%eax
f01057e8:	fc                   	cld    
f01057e9:	f3 ab                	rep stos %eax,%es:(%edi)
f01057eb:	eb 06                	jmp    f01057f3 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01057ed:	8b 45 0c             	mov    0xc(%ebp),%eax
f01057f0:	fc                   	cld    
f01057f1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01057f3:	89 f8                	mov    %edi,%eax
f01057f5:	5b                   	pop    %ebx
f01057f6:	5e                   	pop    %esi
f01057f7:	5f                   	pop    %edi
f01057f8:	5d                   	pop    %ebp
f01057f9:	c3                   	ret    

f01057fa <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01057fa:	f3 0f 1e fb          	endbr32 
f01057fe:	55                   	push   %ebp
f01057ff:	89 e5                	mov    %esp,%ebp
f0105801:	57                   	push   %edi
f0105802:	56                   	push   %esi
f0105803:	8b 45 08             	mov    0x8(%ebp),%eax
f0105806:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105809:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010580c:	39 c6                	cmp    %eax,%esi
f010580e:	73 32                	jae    f0105842 <memmove+0x48>
f0105810:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105813:	39 c2                	cmp    %eax,%edx
f0105815:	76 2b                	jbe    f0105842 <memmove+0x48>
		s += n;
		d += n;
f0105817:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010581a:	89 fe                	mov    %edi,%esi
f010581c:	09 ce                	or     %ecx,%esi
f010581e:	09 d6                	or     %edx,%esi
f0105820:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105826:	75 0e                	jne    f0105836 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105828:	83 ef 04             	sub    $0x4,%edi
f010582b:	8d 72 fc             	lea    -0x4(%edx),%esi
f010582e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105831:	fd                   	std    
f0105832:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105834:	eb 09                	jmp    f010583f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105836:	83 ef 01             	sub    $0x1,%edi
f0105839:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f010583c:	fd                   	std    
f010583d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010583f:	fc                   	cld    
f0105840:	eb 1a                	jmp    f010585c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105842:	89 c2                	mov    %eax,%edx
f0105844:	09 ca                	or     %ecx,%edx
f0105846:	09 f2                	or     %esi,%edx
f0105848:	f6 c2 03             	test   $0x3,%dl
f010584b:	75 0a                	jne    f0105857 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010584d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105850:	89 c7                	mov    %eax,%edi
f0105852:	fc                   	cld    
f0105853:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105855:	eb 05                	jmp    f010585c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
f0105857:	89 c7                	mov    %eax,%edi
f0105859:	fc                   	cld    
f010585a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010585c:	5e                   	pop    %esi
f010585d:	5f                   	pop    %edi
f010585e:	5d                   	pop    %ebp
f010585f:	c3                   	ret    

f0105860 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105860:	f3 0f 1e fb          	endbr32 
f0105864:	55                   	push   %ebp
f0105865:	89 e5                	mov    %esp,%ebp
f0105867:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f010586a:	ff 75 10             	pushl  0x10(%ebp)
f010586d:	ff 75 0c             	pushl  0xc(%ebp)
f0105870:	ff 75 08             	pushl  0x8(%ebp)
f0105873:	e8 82 ff ff ff       	call   f01057fa <memmove>
}
f0105878:	c9                   	leave  
f0105879:	c3                   	ret    

f010587a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010587a:	f3 0f 1e fb          	endbr32 
f010587e:	55                   	push   %ebp
f010587f:	89 e5                	mov    %esp,%ebp
f0105881:	56                   	push   %esi
f0105882:	53                   	push   %ebx
f0105883:	8b 45 08             	mov    0x8(%ebp),%eax
f0105886:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105889:	89 c6                	mov    %eax,%esi
f010588b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010588e:	39 f0                	cmp    %esi,%eax
f0105890:	74 1c                	je     f01058ae <memcmp+0x34>
		if (*s1 != *s2)
f0105892:	0f b6 08             	movzbl (%eax),%ecx
f0105895:	0f b6 1a             	movzbl (%edx),%ebx
f0105898:	38 d9                	cmp    %bl,%cl
f010589a:	75 08                	jne    f01058a4 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f010589c:	83 c0 01             	add    $0x1,%eax
f010589f:	83 c2 01             	add    $0x1,%edx
f01058a2:	eb ea                	jmp    f010588e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
f01058a4:	0f b6 c1             	movzbl %cl,%eax
f01058a7:	0f b6 db             	movzbl %bl,%ebx
f01058aa:	29 d8                	sub    %ebx,%eax
f01058ac:	eb 05                	jmp    f01058b3 <memcmp+0x39>
	}

	return 0;
f01058ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01058b3:	5b                   	pop    %ebx
f01058b4:	5e                   	pop    %esi
f01058b5:	5d                   	pop    %ebp
f01058b6:	c3                   	ret    

f01058b7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01058b7:	f3 0f 1e fb          	endbr32 
f01058bb:	55                   	push   %ebp
f01058bc:	89 e5                	mov    %esp,%ebp
f01058be:	8b 45 08             	mov    0x8(%ebp),%eax
f01058c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01058c4:	89 c2                	mov    %eax,%edx
f01058c6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01058c9:	39 d0                	cmp    %edx,%eax
f01058cb:	73 09                	jae    f01058d6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
f01058cd:	38 08                	cmp    %cl,(%eax)
f01058cf:	74 05                	je     f01058d6 <memfind+0x1f>
	for (; s < ends; s++)
f01058d1:	83 c0 01             	add    $0x1,%eax
f01058d4:	eb f3                	jmp    f01058c9 <memfind+0x12>
			break;
	return (void *) s;
}
f01058d6:	5d                   	pop    %ebp
f01058d7:	c3                   	ret    

f01058d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01058d8:	f3 0f 1e fb          	endbr32 
f01058dc:	55                   	push   %ebp
f01058dd:	89 e5                	mov    %esp,%ebp
f01058df:	57                   	push   %edi
f01058e0:	56                   	push   %esi
f01058e1:	53                   	push   %ebx
f01058e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01058e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01058e8:	eb 03                	jmp    f01058ed <strtol+0x15>
		s++;
f01058ea:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f01058ed:	0f b6 01             	movzbl (%ecx),%eax
f01058f0:	3c 20                	cmp    $0x20,%al
f01058f2:	74 f6                	je     f01058ea <strtol+0x12>
f01058f4:	3c 09                	cmp    $0x9,%al
f01058f6:	74 f2                	je     f01058ea <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
f01058f8:	3c 2b                	cmp    $0x2b,%al
f01058fa:	74 2a                	je     f0105926 <strtol+0x4e>
	int neg = 0;
f01058fc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105901:	3c 2d                	cmp    $0x2d,%al
f0105903:	74 2b                	je     f0105930 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105905:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010590b:	75 0f                	jne    f010591c <strtol+0x44>
f010590d:	80 39 30             	cmpb   $0x30,(%ecx)
f0105910:	74 28                	je     f010593a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105912:	85 db                	test   %ebx,%ebx
f0105914:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105919:	0f 44 d8             	cmove  %eax,%ebx
f010591c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105921:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105924:	eb 46                	jmp    f010596c <strtol+0x94>
		s++;
f0105926:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105929:	bf 00 00 00 00       	mov    $0x0,%edi
f010592e:	eb d5                	jmp    f0105905 <strtol+0x2d>
		s++, neg = 1;
f0105930:	83 c1 01             	add    $0x1,%ecx
f0105933:	bf 01 00 00 00       	mov    $0x1,%edi
f0105938:	eb cb                	jmp    f0105905 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010593a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010593e:	74 0e                	je     f010594e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105940:	85 db                	test   %ebx,%ebx
f0105942:	75 d8                	jne    f010591c <strtol+0x44>
		s++, base = 8;
f0105944:	83 c1 01             	add    $0x1,%ecx
f0105947:	bb 08 00 00 00       	mov    $0x8,%ebx
f010594c:	eb ce                	jmp    f010591c <strtol+0x44>
		s += 2, base = 16;
f010594e:	83 c1 02             	add    $0x2,%ecx
f0105951:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105956:	eb c4                	jmp    f010591c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
f0105958:	0f be d2             	movsbl %dl,%edx
f010595b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f010595e:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105961:	7d 3a                	jge    f010599d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105963:	83 c1 01             	add    $0x1,%ecx
f0105966:	0f af 45 10          	imul   0x10(%ebp),%eax
f010596a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f010596c:	0f b6 11             	movzbl (%ecx),%edx
f010596f:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105972:	89 f3                	mov    %esi,%ebx
f0105974:	80 fb 09             	cmp    $0x9,%bl
f0105977:	76 df                	jbe    f0105958 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
f0105979:	8d 72 9f             	lea    -0x61(%edx),%esi
f010597c:	89 f3                	mov    %esi,%ebx
f010597e:	80 fb 19             	cmp    $0x19,%bl
f0105981:	77 08                	ja     f010598b <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105983:	0f be d2             	movsbl %dl,%edx
f0105986:	83 ea 57             	sub    $0x57,%edx
f0105989:	eb d3                	jmp    f010595e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
f010598b:	8d 72 bf             	lea    -0x41(%edx),%esi
f010598e:	89 f3                	mov    %esi,%ebx
f0105990:	80 fb 19             	cmp    $0x19,%bl
f0105993:	77 08                	ja     f010599d <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105995:	0f be d2             	movsbl %dl,%edx
f0105998:	83 ea 37             	sub    $0x37,%edx
f010599b:	eb c1                	jmp    f010595e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
f010599d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01059a1:	74 05                	je     f01059a8 <strtol+0xd0>
		*endptr = (char *) s;
f01059a3:	8b 75 0c             	mov    0xc(%ebp),%esi
f01059a6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f01059a8:	89 c2                	mov    %eax,%edx
f01059aa:	f7 da                	neg    %edx
f01059ac:	85 ff                	test   %edi,%edi
f01059ae:	0f 45 c2             	cmovne %edx,%eax
}
f01059b1:	5b                   	pop    %ebx
f01059b2:	5e                   	pop    %esi
f01059b3:	5f                   	pop    %edi
f01059b4:	5d                   	pop    %ebp
f01059b5:	c3                   	ret    
f01059b6:	66 90                	xchg   %ax,%ax

f01059b8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01059b8:	fa                   	cli    

	xorw    %ax, %ax
f01059b9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01059bb:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059bd:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059bf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01059c1:	0f 01 16             	lgdtl  (%esi)
f01059c4:	74 70                	je     f0105a36 <mpsearch1+0x3>
	movl    %cr0, %eax
f01059c6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01059c9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01059cd:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01059d0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01059d6:	08 00                	or     %al,(%eax)

f01059d8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01059d8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01059dc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01059de:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01059e0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01059e2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01059e6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01059e8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01059ea:	b8 00 30 12 00       	mov    $0x123000,%eax
	movl    %eax, %cr3
f01059ef:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01059f2:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01059f5:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01059fa:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01059fd:	8b 25 90 ee 2b f0    	mov    0xf02bee90,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105a03:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105a08:	b8 c7 01 10 f0       	mov    $0xf01001c7,%eax
	call    *%eax
f0105a0d:	ff d0                	call   *%eax

f0105a0f <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105a0f:	eb fe                	jmp    f0105a0f <spin>
f0105a11:	8d 76 00             	lea    0x0(%esi),%esi

f0105a14 <gdt>:
	...
f0105a1c:	ff                   	(bad)  
f0105a1d:	ff 00                	incl   (%eax)
f0105a1f:	00 00                	add    %al,(%eax)
f0105a21:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105a28:	00                   	.byte 0x0
f0105a29:	92                   	xchg   %eax,%edx
f0105a2a:	cf                   	iret   
	...

f0105a2c <gdtdesc>:
f0105a2c:	17                   	pop    %ss
f0105a2d:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105a32 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105a32:	90                   	nop

f0105a33 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105a33:	55                   	push   %ebp
f0105a34:	89 e5                	mov    %esp,%ebp
f0105a36:	57                   	push   %edi
f0105a37:	56                   	push   %esi
f0105a38:	53                   	push   %ebx
f0105a39:	83 ec 0c             	sub    $0xc,%esp
f0105a3c:	89 c7                	mov    %eax,%edi
	if (PGNUM(pa) >= npages)
f0105a3e:	a1 94 ee 2b f0       	mov    0xf02bee94,%eax
f0105a43:	89 f9                	mov    %edi,%ecx
f0105a45:	c1 e9 0c             	shr    $0xc,%ecx
f0105a48:	39 c1                	cmp    %eax,%ecx
f0105a4a:	73 19                	jae    f0105a65 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105a4c:	8d 9f 00 00 00 f0    	lea    -0x10000000(%edi),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105a52:	01 d7                	add    %edx,%edi
	if (PGNUM(pa) >= npages)
f0105a54:	89 fa                	mov    %edi,%edx
f0105a56:	c1 ea 0c             	shr    $0xc,%edx
f0105a59:	39 c2                	cmp    %eax,%edx
f0105a5b:	73 1a                	jae    f0105a77 <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105a5d:	81 ef 00 00 00 10    	sub    $0x10000000,%edi

	for (; mp < end; mp++)
f0105a63:	eb 27                	jmp    f0105a8c <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105a65:	57                   	push   %edi
f0105a66:	68 24 6a 10 f0       	push   $0xf0106a24
f0105a6b:	6a 57                	push   $0x57
f0105a6d:	68 3d 86 10 f0       	push   $0xf010863d
f0105a72:	e8 c9 a5 ff ff       	call   f0100040 <_panic>
f0105a77:	57                   	push   %edi
f0105a78:	68 24 6a 10 f0       	push   $0xf0106a24
f0105a7d:	6a 57                	push   $0x57
f0105a7f:	68 3d 86 10 f0       	push   $0xf010863d
f0105a84:	e8 b7 a5 ff ff       	call   f0100040 <_panic>
f0105a89:	83 c3 10             	add    $0x10,%ebx
f0105a8c:	39 fb                	cmp    %edi,%ebx
f0105a8e:	73 30                	jae    f0105ac0 <mpsearch1+0x8d>
f0105a90:	89 de                	mov    %ebx,%esi
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105a92:	83 ec 04             	sub    $0x4,%esp
f0105a95:	6a 04                	push   $0x4
f0105a97:	68 4d 86 10 f0       	push   $0xf010864d
f0105a9c:	53                   	push   %ebx
f0105a9d:	e8 d8 fd ff ff       	call   f010587a <memcmp>
f0105aa2:	83 c4 10             	add    $0x10,%esp
f0105aa5:	85 c0                	test   %eax,%eax
f0105aa7:	75 e0                	jne    f0105a89 <mpsearch1+0x56>
f0105aa9:	89 da                	mov    %ebx,%edx
	for (i = 0; i < len; i++)
f0105aab:	83 c6 10             	add    $0x10,%esi
		sum += ((uint8_t *)addr)[i];
f0105aae:	0f b6 0a             	movzbl (%edx),%ecx
f0105ab1:	01 c8                	add    %ecx,%eax
f0105ab3:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105ab6:	39 f2                	cmp    %esi,%edx
f0105ab8:	75 f4                	jne    f0105aae <mpsearch1+0x7b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105aba:	84 c0                	test   %al,%al
f0105abc:	75 cb                	jne    f0105a89 <mpsearch1+0x56>
f0105abe:	eb 05                	jmp    f0105ac5 <mpsearch1+0x92>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105ac0:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105ac5:	89 d8                	mov    %ebx,%eax
f0105ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105aca:	5b                   	pop    %ebx
f0105acb:	5e                   	pop    %esi
f0105acc:	5f                   	pop    %edi
f0105acd:	5d                   	pop    %ebp
f0105ace:	c3                   	ret    

f0105acf <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105acf:	f3 0f 1e fb          	endbr32 
f0105ad3:	55                   	push   %ebp
f0105ad4:	89 e5                	mov    %esp,%ebp
f0105ad6:	57                   	push   %edi
f0105ad7:	56                   	push   %esi
f0105ad8:	53                   	push   %ebx
f0105ad9:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105adc:	c7 05 c0 f3 2b f0 20 	movl   $0xf02bf020,0xf02bf3c0
f0105ae3:	f0 2b f0 
	if (PGNUM(pa) >= npages)
f0105ae6:	83 3d 94 ee 2b f0 00 	cmpl   $0x0,0xf02bee94
f0105aed:	0f 84 a3 00 00 00    	je     f0105b96 <mp_init+0xc7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105af3:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105afa:	85 c0                	test   %eax,%eax
f0105afc:	0f 84 aa 00 00 00    	je     f0105bac <mp_init+0xdd>
		p <<= 4;	// Translate from segment to PA
f0105b02:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105b05:	ba 00 04 00 00       	mov    $0x400,%edx
f0105b0a:	e8 24 ff ff ff       	call   f0105a33 <mpsearch1>
f0105b0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105b12:	85 c0                	test   %eax,%eax
f0105b14:	75 1a                	jne    f0105b30 <mp_init+0x61>
	return mpsearch1(0xF0000, 0x10000);
f0105b16:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105b1b:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105b20:	e8 0e ff ff ff       	call   f0105a33 <mpsearch1>
f0105b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0)
f0105b28:	85 c0                	test   %eax,%eax
f0105b2a:	0f 84 35 02 00 00    	je     f0105d65 <mp_init+0x296>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105b33:	8b 58 04             	mov    0x4(%eax),%ebx
f0105b36:	85 db                	test   %ebx,%ebx
f0105b38:	0f 84 97 00 00 00    	je     f0105bd5 <mp_init+0x106>
f0105b3e:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0105b42:	0f 85 8d 00 00 00    	jne    f0105bd5 <mp_init+0x106>
f0105b48:	89 d8                	mov    %ebx,%eax
f0105b4a:	c1 e8 0c             	shr    $0xc,%eax
f0105b4d:	3b 05 94 ee 2b f0    	cmp    0xf02bee94,%eax
f0105b53:	0f 83 91 00 00 00    	jae    f0105bea <mp_init+0x11b>
	return (void *)(pa + KERNBASE);
f0105b59:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
f0105b5f:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105b61:	83 ec 04             	sub    $0x4,%esp
f0105b64:	6a 04                	push   $0x4
f0105b66:	68 52 86 10 f0       	push   $0xf0108652
f0105b6b:	53                   	push   %ebx
f0105b6c:	e8 09 fd ff ff       	call   f010587a <memcmp>
f0105b71:	83 c4 10             	add    $0x10,%esp
f0105b74:	85 c0                	test   %eax,%eax
f0105b76:	0f 85 83 00 00 00    	jne    f0105bff <mp_init+0x130>
f0105b7c:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105b80:	01 df                	add    %ebx,%edi
	sum = 0;
f0105b82:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0105b84:	39 fb                	cmp    %edi,%ebx
f0105b86:	0f 84 88 00 00 00    	je     f0105c14 <mp_init+0x145>
		sum += ((uint8_t *)addr)[i];
f0105b8c:	0f b6 0b             	movzbl (%ebx),%ecx
f0105b8f:	01 ca                	add    %ecx,%edx
f0105b91:	83 c3 01             	add    $0x1,%ebx
f0105b94:	eb ee                	jmp    f0105b84 <mp_init+0xb5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105b96:	68 00 04 00 00       	push   $0x400
f0105b9b:	68 24 6a 10 f0       	push   $0xf0106a24
f0105ba0:	6a 6f                	push   $0x6f
f0105ba2:	68 3d 86 10 f0       	push   $0xf010863d
f0105ba7:	e8 94 a4 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105bac:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105bb3:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105bb6:	2d 00 04 00 00       	sub    $0x400,%eax
f0105bbb:	ba 00 04 00 00       	mov    $0x400,%edx
f0105bc0:	e8 6e fe ff ff       	call   f0105a33 <mpsearch1>
f0105bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105bc8:	85 c0                	test   %eax,%eax
f0105bca:	0f 85 60 ff ff ff    	jne    f0105b30 <mp_init+0x61>
f0105bd0:	e9 41 ff ff ff       	jmp    f0105b16 <mp_init+0x47>
		cprintf("SMP: Default configurations not implemented\n");
f0105bd5:	83 ec 0c             	sub    $0xc,%esp
f0105bd8:	68 b0 84 10 f0       	push   $0xf01084b0
f0105bdd:	e8 85 dd ff ff       	call   f0103967 <cprintf>
		return NULL;
f0105be2:	83 c4 10             	add    $0x10,%esp
f0105be5:	e9 7b 01 00 00       	jmp    f0105d65 <mp_init+0x296>
f0105bea:	53                   	push   %ebx
f0105beb:	68 24 6a 10 f0       	push   $0xf0106a24
f0105bf0:	68 90 00 00 00       	push   $0x90
f0105bf5:	68 3d 86 10 f0       	push   $0xf010863d
f0105bfa:	e8 41 a4 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105bff:	83 ec 0c             	sub    $0xc,%esp
f0105c02:	68 e0 84 10 f0       	push   $0xf01084e0
f0105c07:	e8 5b dd ff ff       	call   f0103967 <cprintf>
		return NULL;
f0105c0c:	83 c4 10             	add    $0x10,%esp
f0105c0f:	e9 51 01 00 00       	jmp    f0105d65 <mp_init+0x296>
	if (sum(conf, conf->length) != 0) {
f0105c14:	84 d2                	test   %dl,%dl
f0105c16:	75 22                	jne    f0105c3a <mp_init+0x16b>
	if (conf->version != 1 && conf->version != 4) {
f0105c18:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105c1c:	80 fa 01             	cmp    $0x1,%dl
f0105c1f:	74 05                	je     f0105c26 <mp_init+0x157>
f0105c21:	80 fa 04             	cmp    $0x4,%dl
f0105c24:	75 29                	jne    f0105c4f <mp_init+0x180>
f0105c26:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105c2a:	01 d9                	add    %ebx,%ecx
	for (i = 0; i < len; i++)
f0105c2c:	39 d9                	cmp    %ebx,%ecx
f0105c2e:	74 38                	je     f0105c68 <mp_init+0x199>
		sum += ((uint8_t *)addr)[i];
f0105c30:	0f b6 13             	movzbl (%ebx),%edx
f0105c33:	01 d0                	add    %edx,%eax
f0105c35:	83 c3 01             	add    $0x1,%ebx
f0105c38:	eb f2                	jmp    f0105c2c <mp_init+0x15d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105c3a:	83 ec 0c             	sub    $0xc,%esp
f0105c3d:	68 14 85 10 f0       	push   $0xf0108514
f0105c42:	e8 20 dd ff ff       	call   f0103967 <cprintf>
		return NULL;
f0105c47:	83 c4 10             	add    $0x10,%esp
f0105c4a:	e9 16 01 00 00       	jmp    f0105d65 <mp_init+0x296>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105c4f:	83 ec 08             	sub    $0x8,%esp
f0105c52:	0f b6 d2             	movzbl %dl,%edx
f0105c55:	52                   	push   %edx
f0105c56:	68 38 85 10 f0       	push   $0xf0108538
f0105c5b:	e8 07 dd ff ff       	call   f0103967 <cprintf>
		return NULL;
f0105c60:	83 c4 10             	add    $0x10,%esp
f0105c63:	e9 fd 00 00 00       	jmp    f0105d65 <mp_init+0x296>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105c68:	02 46 2a             	add    0x2a(%esi),%al
f0105c6b:	75 1c                	jne    f0105c89 <mp_init+0x1ba>
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0105c6d:	c7 05 00 f0 2b f0 01 	movl   $0x1,0xf02bf000
f0105c74:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105c77:	8b 46 24             	mov    0x24(%esi),%eax
f0105c7a:	a3 00 00 30 f0       	mov    %eax,0xf0300000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105c7f:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105c82:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105c87:	eb 4d                	jmp    f0105cd6 <mp_init+0x207>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105c89:	83 ec 0c             	sub    $0xc,%esp
f0105c8c:	68 58 85 10 f0       	push   $0xf0108558
f0105c91:	e8 d1 dc ff ff       	call   f0103967 <cprintf>
		return NULL;
f0105c96:	83 c4 10             	add    $0x10,%esp
f0105c99:	e9 c7 00 00 00       	jmp    f0105d65 <mp_init+0x296>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105c9e:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105ca2:	74 11                	je     f0105cb5 <mp_init+0x1e6>
				bootcpu = &cpus[ncpu];
f0105ca4:	6b 05 c4 f3 2b f0 74 	imul   $0x74,0xf02bf3c4,%eax
f0105cab:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
f0105cb0:	a3 c0 f3 2b f0       	mov    %eax,0xf02bf3c0
			if (ncpu < NCPU) {
f0105cb5:	a1 c4 f3 2b f0       	mov    0xf02bf3c4,%eax
f0105cba:	83 f8 07             	cmp    $0x7,%eax
f0105cbd:	7f 33                	jg     f0105cf2 <mp_init+0x223>
				cpus[ncpu].cpu_id = ncpu;
f0105cbf:	6b d0 74             	imul   $0x74,%eax,%edx
f0105cc2:	88 82 20 f0 2b f0    	mov    %al,-0xfd40fe0(%edx)
				ncpu++;
f0105cc8:	83 c0 01             	add    $0x1,%eax
f0105ccb:	a3 c4 f3 2b f0       	mov    %eax,0xf02bf3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105cd0:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105cd3:	83 c3 01             	add    $0x1,%ebx
f0105cd6:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105cda:	39 d8                	cmp    %ebx,%eax
f0105cdc:	76 4f                	jbe    f0105d2d <mp_init+0x25e>
		switch (*p) {
f0105cde:	0f b6 07             	movzbl (%edi),%eax
f0105ce1:	84 c0                	test   %al,%al
f0105ce3:	74 b9                	je     f0105c9e <mp_init+0x1cf>
f0105ce5:	8d 50 ff             	lea    -0x1(%eax),%edx
f0105ce8:	80 fa 03             	cmp    $0x3,%dl
f0105ceb:	77 1c                	ja     f0105d09 <mp_init+0x23a>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105ced:	83 c7 08             	add    $0x8,%edi
			continue;
f0105cf0:	eb e1                	jmp    f0105cd3 <mp_init+0x204>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105cf2:	83 ec 08             	sub    $0x8,%esp
f0105cf5:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105cf9:	50                   	push   %eax
f0105cfa:	68 88 85 10 f0       	push   $0xf0108588
f0105cff:	e8 63 dc ff ff       	call   f0103967 <cprintf>
f0105d04:	83 c4 10             	add    $0x10,%esp
f0105d07:	eb c7                	jmp    f0105cd0 <mp_init+0x201>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d09:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f0105d0c:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0105d0f:	50                   	push   %eax
f0105d10:	68 b0 85 10 f0       	push   $0xf01085b0
f0105d15:	e8 4d dc ff ff       	call   f0103967 <cprintf>
			ismp = 0;
f0105d1a:	c7 05 00 f0 2b f0 00 	movl   $0x0,0xf02bf000
f0105d21:	00 00 00 
			i = conf->entry;
f0105d24:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f0105d28:	83 c4 10             	add    $0x10,%esp
f0105d2b:	eb a6                	jmp    f0105cd3 <mp_init+0x204>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105d2d:	a1 c0 f3 2b f0       	mov    0xf02bf3c0,%eax
f0105d32:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105d39:	83 3d 00 f0 2b f0 00 	cmpl   $0x0,0xf02bf000
f0105d40:	74 2b                	je     f0105d6d <mp_init+0x29e>
		ncpu = 1;
		lapicaddr = 0;
		cprintf("SMP: configuration not found, SMP disabled\n");
		return;
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0105d42:	83 ec 04             	sub    $0x4,%esp
f0105d45:	ff 35 c4 f3 2b f0    	pushl  0xf02bf3c4
f0105d4b:	0f b6 00             	movzbl (%eax),%eax
f0105d4e:	50                   	push   %eax
f0105d4f:	68 57 86 10 f0       	push   $0xf0108657
f0105d54:	e8 0e dc ff ff       	call   f0103967 <cprintf>

	if (mp->imcrp) {
f0105d59:	83 c4 10             	add    $0x10,%esp
f0105d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105d5f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0105d63:	75 2e                	jne    f0105d93 <mp_init+0x2c4>
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0105d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105d68:	5b                   	pop    %ebx
f0105d69:	5e                   	pop    %esi
f0105d6a:	5f                   	pop    %edi
f0105d6b:	5d                   	pop    %ebp
f0105d6c:	c3                   	ret    
		ncpu = 1;
f0105d6d:	c7 05 c4 f3 2b f0 01 	movl   $0x1,0xf02bf3c4
f0105d74:	00 00 00 
		lapicaddr = 0;
f0105d77:	c7 05 00 00 30 f0 00 	movl   $0x0,0xf0300000
f0105d7e:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0105d81:	83 ec 0c             	sub    $0xc,%esp
f0105d84:	68 d0 85 10 f0       	push   $0xf01085d0
f0105d89:	e8 d9 db ff ff       	call   f0103967 <cprintf>
		return;
f0105d8e:	83 c4 10             	add    $0x10,%esp
f0105d91:	eb d2                	jmp    f0105d65 <mp_init+0x296>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0105d93:	83 ec 0c             	sub    $0xc,%esp
f0105d96:	68 fc 85 10 f0       	push   $0xf01085fc
f0105d9b:	e8 c7 db ff ff       	call   f0103967 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105da0:	b8 70 00 00 00       	mov    $0x70,%eax
f0105da5:	ba 22 00 00 00       	mov    $0x22,%edx
f0105daa:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105dab:	ba 23 00 00 00       	mov    $0x23,%edx
f0105db0:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0105db1:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105db4:	ee                   	out    %al,(%dx)
}
f0105db5:	83 c4 10             	add    $0x10,%esp
f0105db8:	eb ab                	jmp    f0105d65 <mp_init+0x296>

f0105dba <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0105dba:	8b 0d 04 00 30 f0    	mov    0xf0300004,%ecx
f0105dc0:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0105dc3:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0105dc5:	a1 04 00 30 f0       	mov    0xf0300004,%eax
f0105dca:	8b 40 20             	mov    0x20(%eax),%eax
}
f0105dcd:	c3                   	ret    

f0105dce <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0105dce:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105dd2:	8b 15 04 00 30 f0    	mov    0xf0300004,%edx
		return lapic[ID] >> 24;
	return 0;
f0105dd8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f0105ddd:	85 d2                	test   %edx,%edx
f0105ddf:	74 06                	je     f0105de7 <cpunum+0x19>
		return lapic[ID] >> 24;
f0105de1:	8b 42 20             	mov    0x20(%edx),%eax
f0105de4:	c1 e8 18             	shr    $0x18,%eax
}
f0105de7:	c3                   	ret    

f0105de8 <lapic_init>:
{
f0105de8:	f3 0f 1e fb          	endbr32 
	if (!lapicaddr)
f0105dec:	a1 00 00 30 f0       	mov    0xf0300000,%eax
f0105df1:	85 c0                	test   %eax,%eax
f0105df3:	75 01                	jne    f0105df6 <lapic_init+0xe>
f0105df5:	c3                   	ret    
{
f0105df6:	55                   	push   %ebp
f0105df7:	89 e5                	mov    %esp,%ebp
f0105df9:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f0105dfc:	68 00 10 00 00       	push   $0x1000
f0105e01:	50                   	push   %eax
f0105e02:	e8 d7 b4 ff ff       	call   f01012de <mmio_map_region>
f0105e07:	a3 04 00 30 f0       	mov    %eax,0xf0300004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0105e0c:	ba 27 01 00 00       	mov    $0x127,%edx
f0105e11:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0105e16:	e8 9f ff ff ff       	call   f0105dba <lapicw>
	lapicw(TDCR, X1);
f0105e1b:	ba 0b 00 00 00       	mov    $0xb,%edx
f0105e20:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0105e25:	e8 90 ff ff ff       	call   f0105dba <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0105e2a:	ba 20 00 02 00       	mov    $0x20020,%edx
f0105e2f:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0105e34:	e8 81 ff ff ff       	call   f0105dba <lapicw>
	lapicw(TICR, 10000000); 
f0105e39:	ba 80 96 98 00       	mov    $0x989680,%edx
f0105e3e:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0105e43:	e8 72 ff ff ff       	call   f0105dba <lapicw>
	if (thiscpu != bootcpu)
f0105e48:	e8 81 ff ff ff       	call   f0105dce <cpunum>
f0105e4d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105e50:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
f0105e55:	83 c4 10             	add    $0x10,%esp
f0105e58:	39 05 c0 f3 2b f0    	cmp    %eax,0xf02bf3c0
f0105e5e:	74 0f                	je     f0105e6f <lapic_init+0x87>
		lapicw(LINT0, MASKED);
f0105e60:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e65:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0105e6a:	e8 4b ff ff ff       	call   f0105dba <lapicw>
	lapicw(LINT1, MASKED);
f0105e6f:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105e74:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0105e79:	e8 3c ff ff ff       	call   f0105dba <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0105e7e:	a1 04 00 30 f0       	mov    0xf0300004,%eax
f0105e83:	8b 40 30             	mov    0x30(%eax),%eax
f0105e86:	c1 e8 10             	shr    $0x10,%eax
f0105e89:	a8 fc                	test   $0xfc,%al
f0105e8b:	75 7c                	jne    f0105f09 <lapic_init+0x121>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0105e8d:	ba 33 00 00 00       	mov    $0x33,%edx
f0105e92:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0105e97:	e8 1e ff ff ff       	call   f0105dba <lapicw>
	lapicw(ESR, 0);
f0105e9c:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ea1:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105ea6:	e8 0f ff ff ff       	call   f0105dba <lapicw>
	lapicw(ESR, 0);
f0105eab:	ba 00 00 00 00       	mov    $0x0,%edx
f0105eb0:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0105eb5:	e8 00 ff ff ff       	call   f0105dba <lapicw>
	lapicw(EOI, 0);
f0105eba:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ebf:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105ec4:	e8 f1 fe ff ff       	call   f0105dba <lapicw>
	lapicw(ICRHI, 0);
f0105ec9:	ba 00 00 00 00       	mov    $0x0,%edx
f0105ece:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105ed3:	e8 e2 fe ff ff       	call   f0105dba <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0105ed8:	ba 00 85 08 00       	mov    $0x88500,%edx
f0105edd:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105ee2:	e8 d3 fe ff ff       	call   f0105dba <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0105ee7:	8b 15 04 00 30 f0    	mov    0xf0300004,%edx
f0105eed:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0105ef3:	f6 c4 10             	test   $0x10,%ah
f0105ef6:	75 f5                	jne    f0105eed <lapic_init+0x105>
	lapicw(TPR, 0);
f0105ef8:	ba 00 00 00 00       	mov    $0x0,%edx
f0105efd:	b8 20 00 00 00       	mov    $0x20,%eax
f0105f02:	e8 b3 fe ff ff       	call   f0105dba <lapicw>
}
f0105f07:	c9                   	leave  
f0105f08:	c3                   	ret    
		lapicw(PCINT, MASKED);
f0105f09:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105f0e:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0105f13:	e8 a2 fe ff ff       	call   f0105dba <lapicw>
f0105f18:	e9 70 ff ff ff       	jmp    f0105e8d <lapic_init+0xa5>

f0105f1d <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0105f1d:	f3 0f 1e fb          	endbr32 
	if (lapic)
f0105f21:	83 3d 04 00 30 f0 00 	cmpl   $0x0,0xf0300004
f0105f28:	74 17                	je     f0105f41 <lapic_eoi+0x24>
{
f0105f2a:	55                   	push   %ebp
f0105f2b:	89 e5                	mov    %esp,%ebp
f0105f2d:	83 ec 08             	sub    $0x8,%esp
		lapicw(EOI, 0);
f0105f30:	ba 00 00 00 00       	mov    $0x0,%edx
f0105f35:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0105f3a:	e8 7b fe ff ff       	call   f0105dba <lapicw>
}
f0105f3f:	c9                   	leave  
f0105f40:	c3                   	ret    
f0105f41:	c3                   	ret    

f0105f42 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0105f42:	f3 0f 1e fb          	endbr32 
f0105f46:	55                   	push   %ebp
f0105f47:	89 e5                	mov    %esp,%ebp
f0105f49:	56                   	push   %esi
f0105f4a:	53                   	push   %ebx
f0105f4b:	8b 75 08             	mov    0x8(%ebp),%esi
f0105f4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105f51:	b8 0f 00 00 00       	mov    $0xf,%eax
f0105f56:	ba 70 00 00 00       	mov    $0x70,%edx
f0105f5b:	ee                   	out    %al,(%dx)
f0105f5c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105f61:	ba 71 00 00 00       	mov    $0x71,%edx
f0105f66:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0105f67:	83 3d 94 ee 2b f0 00 	cmpl   $0x0,0xf02bee94
f0105f6e:	74 7e                	je     f0105fee <lapic_startap+0xac>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0105f70:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0105f77:	00 00 
	wrv[1] = addr >> 4;
f0105f79:	89 d8                	mov    %ebx,%eax
f0105f7b:	c1 e8 04             	shr    $0x4,%eax
f0105f7e:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0105f84:	c1 e6 18             	shl    $0x18,%esi
f0105f87:	89 f2                	mov    %esi,%edx
f0105f89:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105f8e:	e8 27 fe ff ff       	call   f0105dba <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0105f93:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0105f98:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105f9d:	e8 18 fe ff ff       	call   f0105dba <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0105fa2:	ba 00 85 00 00       	mov    $0x8500,%edx
f0105fa7:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fac:	e8 09 fe ff ff       	call   f0105dba <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105fb1:	c1 eb 0c             	shr    $0xc,%ebx
f0105fb4:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f0105fb7:	89 f2                	mov    %esi,%edx
f0105fb9:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105fbe:	e8 f7 fd ff ff       	call   f0105dba <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105fc3:	89 da                	mov    %ebx,%edx
f0105fc5:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fca:	e8 eb fd ff ff       	call   f0105dba <lapicw>
		lapicw(ICRHI, apicid << 24);
f0105fcf:	89 f2                	mov    %esi,%edx
f0105fd1:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0105fd6:	e8 df fd ff ff       	call   f0105dba <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0105fdb:	89 da                	mov    %ebx,%edx
f0105fdd:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0105fe2:	e8 d3 fd ff ff       	call   f0105dba <lapicw>
		microdelay(200);
	}
}
f0105fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0105fea:	5b                   	pop    %ebx
f0105feb:	5e                   	pop    %esi
f0105fec:	5d                   	pop    %ebp
f0105fed:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105fee:	68 67 04 00 00       	push   $0x467
f0105ff3:	68 24 6a 10 f0       	push   $0xf0106a24
f0105ff8:	68 98 00 00 00       	push   $0x98
f0105ffd:	68 74 86 10 f0       	push   $0xf0108674
f0106002:	e8 39 a0 ff ff       	call   f0100040 <_panic>

f0106007 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0106007:	f3 0f 1e fb          	endbr32 
f010600b:	55                   	push   %ebp
f010600c:	89 e5                	mov    %esp,%ebp
f010600e:	83 ec 08             	sub    $0x8,%esp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106011:	8b 55 08             	mov    0x8(%ebp),%edx
f0106014:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010601a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010601f:	e8 96 fd ff ff       	call   f0105dba <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106024:	8b 15 04 00 30 f0    	mov    0xf0300004,%edx
f010602a:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106030:	f6 c4 10             	test   $0x10,%ah
f0106033:	75 f5                	jne    f010602a <lapic_ipi+0x23>
		;
}
f0106035:	c9                   	leave  
f0106036:	c3                   	ret    

f0106037 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106037:	f3 0f 1e fb          	endbr32 
f010603b:	55                   	push   %ebp
f010603c:	89 e5                	mov    %esp,%ebp
f010603e:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0106041:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106047:	8b 55 0c             	mov    0xc(%ebp),%edx
f010604a:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010604d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106054:	5d                   	pop    %ebp
f0106055:	c3                   	ret    

f0106056 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106056:	f3 0f 1e fb          	endbr32 
f010605a:	55                   	push   %ebp
f010605b:	89 e5                	mov    %esp,%ebp
f010605d:	56                   	push   %esi
f010605e:	53                   	push   %ebx
f010605f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f0106062:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106065:	75 07                	jne    f010606e <spin_lock+0x18>
	asm volatile("lock; xchgl %0, %1"
f0106067:	ba 01 00 00 00       	mov    $0x1,%edx
f010606c:	eb 34                	jmp    f01060a2 <spin_lock+0x4c>
f010606e:	8b 73 08             	mov    0x8(%ebx),%esi
f0106071:	e8 58 fd ff ff       	call   f0105dce <cpunum>
f0106076:	6b c0 74             	imul   $0x74,%eax,%eax
f0106079:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f010607e:	39 c6                	cmp    %eax,%esi
f0106080:	75 e5                	jne    f0106067 <spin_lock+0x11>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106082:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106085:	e8 44 fd ff ff       	call   f0105dce <cpunum>
f010608a:	83 ec 0c             	sub    $0xc,%esp
f010608d:	53                   	push   %ebx
f010608e:	50                   	push   %eax
f010608f:	68 84 86 10 f0       	push   $0xf0108684
f0106094:	6a 41                	push   $0x41
f0106096:	68 e6 86 10 f0       	push   $0xf01086e6
f010609b:	e8 a0 9f ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01060a0:	f3 90                	pause  
f01060a2:	89 d0                	mov    %edx,%eax
f01060a4:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f01060a7:	85 c0                	test   %eax,%eax
f01060a9:	75 f5                	jne    f01060a0 <spin_lock+0x4a>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01060ab:	e8 1e fd ff ff       	call   f0105dce <cpunum>
f01060b0:	6b c0 74             	imul   $0x74,%eax,%eax
f01060b3:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
f01060b8:	89 43 08             	mov    %eax,0x8(%ebx)
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01060bb:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01060bd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01060c2:	83 f8 09             	cmp    $0x9,%eax
f01060c5:	7f 21                	jg     f01060e8 <spin_lock+0x92>
f01060c7:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01060cd:	76 19                	jbe    f01060e8 <spin_lock+0x92>
		pcs[i] = ebp[1];          // saved %eip
f01060cf:	8b 4a 04             	mov    0x4(%edx),%ecx
f01060d2:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01060d6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01060d8:	83 c0 01             	add    $0x1,%eax
f01060db:	eb e5                	jmp    f01060c2 <spin_lock+0x6c>
		pcs[i] = 0;
f01060dd:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f01060e4:	00 
	for (; i < 10; i++)
f01060e5:	83 c0 01             	add    $0x1,%eax
f01060e8:	83 f8 09             	cmp    $0x9,%eax
f01060eb:	7e f0                	jle    f01060dd <spin_lock+0x87>
	get_caller_pcs(lk->pcs);
#endif
}
f01060ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01060f0:	5b                   	pop    %ebx
f01060f1:	5e                   	pop    %esi
f01060f2:	5d                   	pop    %ebp
f01060f3:	c3                   	ret    

f01060f4 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01060f4:	f3 0f 1e fb          	endbr32 
f01060f8:	55                   	push   %ebp
f01060f9:	89 e5                	mov    %esp,%ebp
f01060fb:	57                   	push   %edi
f01060fc:	56                   	push   %esi
f01060fd:	53                   	push   %ebx
f01060fe:	83 ec 4c             	sub    $0x4c,%esp
f0106101:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f0106104:	83 3e 00             	cmpl   $0x0,(%esi)
f0106107:	75 35                	jne    f010613e <spin_unlock+0x4a>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106109:	83 ec 04             	sub    $0x4,%esp
f010610c:	6a 28                	push   $0x28
f010610e:	8d 46 0c             	lea    0xc(%esi),%eax
f0106111:	50                   	push   %eax
f0106112:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106115:	53                   	push   %ebx
f0106116:	e8 df f6 ff ff       	call   f01057fa <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f010611b:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f010611e:	0f b6 38             	movzbl (%eax),%edi
f0106121:	8b 76 04             	mov    0x4(%esi),%esi
f0106124:	e8 a5 fc ff ff       	call   f0105dce <cpunum>
f0106129:	57                   	push   %edi
f010612a:	56                   	push   %esi
f010612b:	50                   	push   %eax
f010612c:	68 b0 86 10 f0       	push   $0xf01086b0
f0106131:	e8 31 d8 ff ff       	call   f0103967 <cprintf>
f0106136:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106139:	8d 7d a8             	lea    -0x58(%ebp),%edi
f010613c:	eb 4e                	jmp    f010618c <spin_unlock+0x98>
	return lock->locked && lock->cpu == thiscpu;
f010613e:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106141:	e8 88 fc ff ff       	call   f0105dce <cpunum>
f0106146:	6b c0 74             	imul   $0x74,%eax,%eax
f0106149:	05 20 f0 2b f0       	add    $0xf02bf020,%eax
	if (!holding(lk)) {
f010614e:	39 c3                	cmp    %eax,%ebx
f0106150:	75 b7                	jne    f0106109 <spin_unlock+0x15>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0106152:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106159:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106160:	b8 00 00 00 00       	mov    $0x0,%eax
f0106165:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106168:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010616b:	5b                   	pop    %ebx
f010616c:	5e                   	pop    %esi
f010616d:	5f                   	pop    %edi
f010616e:	5d                   	pop    %ebp
f010616f:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106170:	83 ec 08             	sub    $0x8,%esp
f0106173:	ff 36                	pushl  (%esi)
f0106175:	68 0d 87 10 f0       	push   $0xf010870d
f010617a:	e8 e8 d7 ff ff       	call   f0103967 <cprintf>
f010617f:	83 c4 10             	add    $0x10,%esp
f0106182:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106185:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106188:	39 c3                	cmp    %eax,%ebx
f010618a:	74 40                	je     f01061cc <spin_unlock+0xd8>
f010618c:	89 de                	mov    %ebx,%esi
f010618e:	8b 03                	mov    (%ebx),%eax
f0106190:	85 c0                	test   %eax,%eax
f0106192:	74 38                	je     f01061cc <spin_unlock+0xd8>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106194:	83 ec 08             	sub    $0x8,%esp
f0106197:	57                   	push   %edi
f0106198:	50                   	push   %eax
f0106199:	e8 d7 ea ff ff       	call   f0104c75 <debuginfo_eip>
f010619e:	83 c4 10             	add    $0x10,%esp
f01061a1:	85 c0                	test   %eax,%eax
f01061a3:	78 cb                	js     f0106170 <spin_unlock+0x7c>
					pcs[i] - info.eip_fn_addr);
f01061a5:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01061a7:	83 ec 04             	sub    $0x4,%esp
f01061aa:	89 c2                	mov    %eax,%edx
f01061ac:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01061af:	52                   	push   %edx
f01061b0:	ff 75 b0             	pushl  -0x50(%ebp)
f01061b3:	ff 75 b4             	pushl  -0x4c(%ebp)
f01061b6:	ff 75 ac             	pushl  -0x54(%ebp)
f01061b9:	ff 75 a8             	pushl  -0x58(%ebp)
f01061bc:	50                   	push   %eax
f01061bd:	68 f6 86 10 f0       	push   $0xf01086f6
f01061c2:	e8 a0 d7 ff ff       	call   f0103967 <cprintf>
f01061c7:	83 c4 20             	add    $0x20,%esp
f01061ca:	eb b6                	jmp    f0106182 <spin_unlock+0x8e>
		panic("spin_unlock");
f01061cc:	83 ec 04             	sub    $0x4,%esp
f01061cf:	68 15 87 10 f0       	push   $0xf0108715
f01061d4:	6a 67                	push   $0x67
f01061d6:	68 e6 86 10 f0       	push   $0xf01086e6
f01061db:	e8 60 9e ff ff       	call   f0100040 <_panic>

f01061e0 <e1000_init>:

// LAB 6: Your driver code here

int 
e1000_init(struct pci_func *pcif)
{
f01061e0:	f3 0f 1e fb          	endbr32 
f01061e4:	55                   	push   %ebp
f01061e5:	89 e5                	mov    %esp,%ebp
f01061e7:	83 ec 14             	sub    $0x14,%esp
    pci_func_enable(pcif);
f01061ea:	ff 75 08             	pushl  0x8(%ebp)
f01061ed:	e8 d4 03 00 00       	call   f01065c6 <pci_func_enable>
    return 1;
}
f01061f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01061f7:	c9                   	leave  
f01061f8:	c3                   	ret    

f01061f9 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01061f9:	55                   	push   %ebp
f01061fa:	89 e5                	mov    %esp,%ebp
f01061fc:	57                   	push   %edi
f01061fd:	56                   	push   %esi
f01061fe:	53                   	push   %ebx
f01061ff:	83 ec 0c             	sub    $0xc,%esp
f0106202:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106205:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106208:	eb 03                	jmp    f010620d <pci_attach_match+0x14>
f010620a:	83 c3 0c             	add    $0xc,%ebx
f010620d:	89 de                	mov    %ebx,%esi
f010620f:	8b 43 08             	mov    0x8(%ebx),%eax
f0106212:	85 c0                	test   %eax,%eax
f0106214:	74 37                	je     f010624d <pci_attach_match+0x54>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0106216:	39 3b                	cmp    %edi,(%ebx)
f0106218:	75 f0                	jne    f010620a <pci_attach_match+0x11>
f010621a:	8b 55 0c             	mov    0xc(%ebp),%edx
f010621d:	39 56 04             	cmp    %edx,0x4(%esi)
f0106220:	75 e8                	jne    f010620a <pci_attach_match+0x11>
			int r = list[i].attachfn(pcif);
f0106222:	83 ec 0c             	sub    $0xc,%esp
f0106225:	ff 75 14             	pushl  0x14(%ebp)
f0106228:	ff d0                	call   *%eax
			if (r > 0)
f010622a:	83 c4 10             	add    $0x10,%esp
f010622d:	85 c0                	test   %eax,%eax
f010622f:	7f 1c                	jg     f010624d <pci_attach_match+0x54>
				return r;
			if (r < 0)
f0106231:	79 d7                	jns    f010620a <pci_attach_match+0x11>
				cprintf("pci_attach_match: attaching "
f0106233:	83 ec 0c             	sub    $0xc,%esp
f0106236:	50                   	push   %eax
f0106237:	ff 76 08             	pushl  0x8(%esi)
f010623a:	ff 75 0c             	pushl  0xc(%ebp)
f010623d:	57                   	push   %edi
f010623e:	68 30 87 10 f0       	push   $0xf0108730
f0106243:	e8 1f d7 ff ff       	call   f0103967 <cprintf>
f0106248:	83 c4 20             	add    $0x20,%esp
f010624b:	eb bd                	jmp    f010620a <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f010624d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106250:	5b                   	pop    %ebx
f0106251:	5e                   	pop    %esi
f0106252:	5f                   	pop    %edi
f0106253:	5d                   	pop    %ebp
f0106254:	c3                   	ret    

f0106255 <pci_conf1_set_addr>:
{
f0106255:	55                   	push   %ebp
f0106256:	89 e5                	mov    %esp,%ebp
f0106258:	53                   	push   %ebx
f0106259:	83 ec 04             	sub    $0x4,%esp
f010625c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f010625f:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106264:	77 36                	ja     f010629c <pci_conf1_set_addr+0x47>
	assert(dev < 32);
f0106266:	83 fa 1f             	cmp    $0x1f,%edx
f0106269:	77 47                	ja     f01062b2 <pci_conf1_set_addr+0x5d>
	assert(func < 8);
f010626b:	83 f9 07             	cmp    $0x7,%ecx
f010626e:	77 58                	ja     f01062c8 <pci_conf1_set_addr+0x73>
	assert(offset < 256);
f0106270:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0106276:	77 66                	ja     f01062de <pci_conf1_set_addr+0x89>
	assert((offset & 0x3) == 0);
f0106278:	f6 c3 03             	test   $0x3,%bl
f010627b:	75 77                	jne    f01062f4 <pci_conf1_set_addr+0x9f>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010627d:	c1 e0 10             	shl    $0x10,%eax
f0106280:	09 d8                	or     %ebx,%eax
f0106282:	c1 e1 08             	shl    $0x8,%ecx
f0106285:	09 c8                	or     %ecx,%eax
f0106287:	c1 e2 0b             	shl    $0xb,%edx
f010628a:	09 d0                	or     %edx,%eax
	uint32_t v = (1 << 31) |		// config-space
f010628c:	0d 00 00 00 80       	or     $0x80000000,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106291:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0106296:	ef                   	out    %eax,(%dx)
}
f0106297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010629a:	c9                   	leave  
f010629b:	c3                   	ret    
	assert(bus < 256);
f010629c:	68 87 88 10 f0       	push   $0xf0108887
f01062a1:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01062a6:	6a 2c                	push   $0x2c
f01062a8:	68 91 88 10 f0       	push   $0xf0108891
f01062ad:	e8 8e 9d ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f01062b2:	68 9c 88 10 f0       	push   $0xf010889c
f01062b7:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01062bc:	6a 2d                	push   $0x2d
f01062be:	68 91 88 10 f0       	push   $0xf0108891
f01062c3:	e8 78 9d ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f01062c8:	68 a5 88 10 f0       	push   $0xf01088a5
f01062cd:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01062d2:	6a 2e                	push   $0x2e
f01062d4:	68 91 88 10 f0       	push   $0xf0108891
f01062d9:	e8 62 9d ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f01062de:	68 ae 88 10 f0       	push   $0xf01088ae
f01062e3:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01062e8:	6a 2f                	push   $0x2f
f01062ea:	68 91 88 10 f0       	push   $0xf0108891
f01062ef:	e8 4c 9d ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f01062f4:	68 bb 88 10 f0       	push   $0xf01088bb
f01062f9:	68 b5 6f 10 f0       	push   $0xf0106fb5
f01062fe:	6a 30                	push   $0x30
f0106300:	68 91 88 10 f0       	push   $0xf0108891
f0106305:	e8 36 9d ff ff       	call   f0100040 <_panic>

f010630a <pci_conf_read>:
{
f010630a:	55                   	push   %ebp
f010630b:	89 e5                	mov    %esp,%ebp
f010630d:	53                   	push   %ebx
f010630e:	83 ec 10             	sub    $0x10,%esp
f0106311:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106313:	8b 48 08             	mov    0x8(%eax),%ecx
f0106316:	8b 50 04             	mov    0x4(%eax),%edx
f0106319:	8b 00                	mov    (%eax),%eax
f010631b:	8b 40 04             	mov    0x4(%eax),%eax
f010631e:	53                   	push   %ebx
f010631f:	e8 31 ff ff ff       	call   f0106255 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0106324:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106329:	ed                   	in     (%dx),%eax
}
f010632a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010632d:	c9                   	leave  
f010632e:	c3                   	ret    

f010632f <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f010632f:	55                   	push   %ebp
f0106330:	89 e5                	mov    %esp,%ebp
f0106332:	57                   	push   %edi
f0106333:	56                   	push   %esi
f0106334:	53                   	push   %ebx
f0106335:	81 ec 00 01 00 00    	sub    $0x100,%esp
f010633b:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f010633d:	6a 48                	push   $0x48
f010633f:	6a 00                	push   $0x0
f0106341:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106344:	50                   	push   %eax
f0106345:	e8 64 f4 ff ff       	call   f01057ae <memset>
	df.bus = bus;
f010634a:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f010634d:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0106354:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f0106357:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f010635e:	00 00 00 
f0106361:	e9 27 01 00 00       	jmp    f010648d <pci_scan_bus+0x15e>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106366:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010636c:	83 ec 08             	sub    $0x8,%esp
f010636f:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0106373:	57                   	push   %edi
f0106374:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0106375:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0106378:	0f b6 c0             	movzbl %al,%eax
f010637b:	50                   	push   %eax
f010637c:	51                   	push   %ecx
f010637d:	89 d0                	mov    %edx,%eax
f010637f:	c1 e8 10             	shr    $0x10,%eax
f0106382:	50                   	push   %eax
f0106383:	0f b7 d2             	movzwl %dx,%edx
f0106386:	52                   	push   %edx
f0106387:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f010638d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0106393:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0106399:	ff 70 04             	pushl  0x4(%eax)
f010639c:	68 5c 87 10 f0       	push   $0xf010875c
f01063a1:	e8 c1 d5 ff ff       	call   f0103967 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f01063a6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f01063ac:	83 c4 30             	add    $0x30,%esp
f01063af:	53                   	push   %ebx
f01063b0:	68 0c 54 12 f0       	push   $0xf012540c
				 PCI_SUBCLASS(f->dev_class),
f01063b5:	89 c2                	mov    %eax,%edx
f01063b7:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f01063ba:	0f b6 d2             	movzbl %dl,%edx
f01063bd:	52                   	push   %edx
f01063be:	c1 e8 18             	shr    $0x18,%eax
f01063c1:	50                   	push   %eax
f01063c2:	e8 32 fe ff ff       	call   f01061f9 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f01063c7:	83 c4 10             	add    $0x10,%esp
f01063ca:	85 c0                	test   %eax,%eax
f01063cc:	0f 84 8a 00 00 00    	je     f010645c <pci_scan_bus+0x12d>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f01063d2:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01063d9:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01063df:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f01063e5:	0f 83 94 00 00 00    	jae    f010647f <pci_scan_bus+0x150>
			struct pci_func af = f;
f01063eb:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f01063f1:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f01063f7:	b9 12 00 00 00       	mov    $0x12,%ecx
f01063fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01063fe:	ba 00 00 00 00       	mov    $0x0,%edx
f0106403:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0106409:	e8 fc fe ff ff       	call   f010630a <pci_conf_read>
f010640e:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0106414:	66 83 f8 ff          	cmp    $0xffff,%ax
f0106418:	74 b8                	je     f01063d2 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f010641a:	ba 3c 00 00 00       	mov    $0x3c,%edx
f010641f:	89 d8                	mov    %ebx,%eax
f0106421:	e8 e4 fe ff ff       	call   f010630a <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0106426:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0106429:	ba 08 00 00 00       	mov    $0x8,%edx
f010642e:	89 d8                	mov    %ebx,%eax
f0106430:	e8 d5 fe ff ff       	call   f010630a <pci_conf_read>
f0106435:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010643b:	89 c1                	mov    %eax,%ecx
f010643d:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0106440:	be cf 88 10 f0       	mov    $0xf01088cf,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106445:	3d ff ff ff 06       	cmp    $0x6ffffff,%eax
f010644a:	0f 87 16 ff ff ff    	ja     f0106366 <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0106450:	8b 34 8d 44 89 10 f0 	mov    -0xfef76bc(,%ecx,4),%esi
f0106457:	e9 0a ff ff ff       	jmp    f0106366 <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f010645c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0106462:	53                   	push   %ebx
f0106463:	68 f4 53 12 f0       	push   $0xf01253f4
f0106468:	89 c2                	mov    %eax,%edx
f010646a:	c1 ea 10             	shr    $0x10,%edx
f010646d:	52                   	push   %edx
f010646e:	0f b7 c0             	movzwl %ax,%eax
f0106471:	50                   	push   %eax
f0106472:	e8 82 fd ff ff       	call   f01061f9 <pci_attach_match>
f0106477:	83 c4 10             	add    $0x10,%esp
f010647a:	e9 53 ff ff ff       	jmp    f01063d2 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f010647f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0106482:	83 c0 01             	add    $0x1,%eax
f0106485:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0106488:	83 f8 1f             	cmp    $0x1f,%eax
f010648b:	77 59                	ja     f01064e6 <pci_scan_bus+0x1b7>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f010648d:	ba 0c 00 00 00       	mov    $0xc,%edx
f0106492:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106495:	e8 70 fe ff ff       	call   f010630a <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f010649a:	89 c2                	mov    %eax,%edx
f010649c:	c1 ea 10             	shr    $0x10,%edx
f010649f:	f6 c2 7e             	test   $0x7e,%dl
f01064a2:	75 db                	jne    f010647f <pci_scan_bus+0x150>
		totaldev++;
f01064a4:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f01064ab:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f01064b1:	8d 75 a0             	lea    -0x60(%ebp),%esi
f01064b4:	b9 12 00 00 00       	mov    $0x12,%ecx
f01064b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01064bb:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f01064c2:	00 00 00 
f01064c5:	25 00 00 80 00       	and    $0x800000,%eax
f01064ca:	83 f8 01             	cmp    $0x1,%eax
f01064cd:	19 c0                	sbb    %eax,%eax
f01064cf:	83 e0 f9             	and    $0xfffffff9,%eax
f01064d2:	83 c0 08             	add    $0x8,%eax
f01064d5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01064db:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01064e1:	e9 f3 fe ff ff       	jmp    f01063d9 <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f01064e6:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01064ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01064ef:	5b                   	pop    %ebx
f01064f0:	5e                   	pop    %esi
f01064f1:	5f                   	pop    %edi
f01064f2:	5d                   	pop    %ebp
f01064f3:	c3                   	ret    

f01064f4 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01064f4:	f3 0f 1e fb          	endbr32 
f01064f8:	55                   	push   %ebp
f01064f9:	89 e5                	mov    %esp,%ebp
f01064fb:	57                   	push   %edi
f01064fc:	56                   	push   %esi
f01064fd:	53                   	push   %ebx
f01064fe:	83 ec 1c             	sub    $0x1c,%esp
f0106501:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0106504:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0106509:	89 f0                	mov    %esi,%eax
f010650b:	e8 fa fd ff ff       	call   f010630a <pci_conf_read>
f0106510:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0106512:	ba 18 00 00 00       	mov    $0x18,%edx
f0106517:	89 f0                	mov    %esi,%eax
f0106519:	e8 ec fd ff ff       	call   f010630a <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f010651e:	83 e7 0f             	and    $0xf,%edi
f0106521:	83 ff 01             	cmp    $0x1,%edi
f0106524:	74 52                	je     f0106578 <pci_bridge_attach+0x84>
f0106526:	89 c3                	mov    %eax,%ebx
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0106528:	83 ec 04             	sub    $0x4,%esp
f010652b:	6a 08                	push   $0x8
f010652d:	6a 00                	push   $0x0
f010652f:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0106532:	57                   	push   %edi
f0106533:	e8 76 f2 ff ff       	call   f01057ae <memset>
	nbus.parent_bridge = pcif;
f0106538:	89 75 e0             	mov    %esi,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010653b:	0f b6 c7             	movzbl %bh,%eax
f010653e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106541:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0106544:	c1 eb 10             	shr    $0x10,%ebx
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106547:	0f b6 db             	movzbl %bl,%ebx
f010654a:	53                   	push   %ebx
f010654b:	50                   	push   %eax
f010654c:	ff 76 08             	pushl  0x8(%esi)
f010654f:	ff 76 04             	pushl  0x4(%esi)
f0106552:	8b 06                	mov    (%esi),%eax
f0106554:	ff 70 04             	pushl  0x4(%eax)
f0106557:	68 cc 87 10 f0       	push   $0xf01087cc
f010655c:	e8 06 d4 ff ff       	call   f0103967 <cprintf>

	pci_scan_bus(&nbus);
f0106561:	83 c4 20             	add    $0x20,%esp
f0106564:	89 f8                	mov    %edi,%eax
f0106566:	e8 c4 fd ff ff       	call   f010632f <pci_scan_bus>
	return 1;
f010656b:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0106570:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106573:	5b                   	pop    %ebx
f0106574:	5e                   	pop    %esi
f0106575:	5f                   	pop    %edi
f0106576:	5d                   	pop    %ebp
f0106577:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0106578:	ff 76 08             	pushl  0x8(%esi)
f010657b:	ff 76 04             	pushl  0x4(%esi)
f010657e:	8b 06                	mov    (%esi),%eax
f0106580:	ff 70 04             	pushl  0x4(%eax)
f0106583:	68 98 87 10 f0       	push   $0xf0108798
f0106588:	e8 da d3 ff ff       	call   f0103967 <cprintf>
		return 0;
f010658d:	83 c4 10             	add    $0x10,%esp
f0106590:	b8 00 00 00 00       	mov    $0x0,%eax
f0106595:	eb d9                	jmp    f0106570 <pci_bridge_attach+0x7c>

f0106597 <pci_conf_write>:
{
f0106597:	55                   	push   %ebp
f0106598:	89 e5                	mov    %esp,%ebp
f010659a:	56                   	push   %esi
f010659b:	53                   	push   %ebx
f010659c:	89 d6                	mov    %edx,%esi
f010659e:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01065a0:	8b 48 08             	mov    0x8(%eax),%ecx
f01065a3:	8b 50 04             	mov    0x4(%eax),%edx
f01065a6:	8b 00                	mov    (%eax),%eax
f01065a8:	8b 40 04             	mov    0x4(%eax),%eax
f01065ab:	83 ec 0c             	sub    $0xc,%esp
f01065ae:	56                   	push   %esi
f01065af:	e8 a1 fc ff ff       	call   f0106255 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01065b4:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01065b9:	89 d8                	mov    %ebx,%eax
f01065bb:	ef                   	out    %eax,(%dx)
}
f01065bc:	83 c4 10             	add    $0x10,%esp
f01065bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01065c2:	5b                   	pop    %ebx
f01065c3:	5e                   	pop    %esi
f01065c4:	5d                   	pop    %ebp
f01065c5:	c3                   	ret    

f01065c6 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f01065c6:	f3 0f 1e fb          	endbr32 
f01065ca:	55                   	push   %ebp
f01065cb:	89 e5                	mov    %esp,%ebp
f01065cd:	57                   	push   %edi
f01065ce:	56                   	push   %esi
f01065cf:	53                   	push   %ebx
f01065d0:	83 ec 2c             	sub    $0x2c,%esp
f01065d3:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01065d6:	b9 07 00 00 00       	mov    $0x7,%ecx
f01065db:	ba 04 00 00 00       	mov    $0x4,%edx
f01065e0:	89 f8                	mov    %edi,%eax
f01065e2:	e8 b0 ff ff ff       	call   f0106597 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01065e7:	be 10 00 00 00       	mov    $0x10,%esi
f01065ec:	eb 56                	jmp    f0106644 <pci_func_enable+0x7e>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01065ee:	83 e0 fc             	and    $0xfffffffc,%eax
f01065f1:	f7 d8                	neg    %eax
f01065f3:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f01065f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01065f8:	83 e0 fc             	and    $0xfffffffc,%eax
f01065fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01065fe:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0106605:	e9 aa 00 00 00       	jmp    f01066b4 <pci_func_enable+0xee>
		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010660a:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010660d:	83 ec 0c             	sub    $0xc,%esp
f0106610:	53                   	push   %ebx
f0106611:	6a 00                	push   $0x0
f0106613:	ff 75 d4             	pushl  -0x2c(%ebp)
f0106616:	89 c2                	mov    %eax,%edx
f0106618:	c1 ea 10             	shr    $0x10,%edx
f010661b:	52                   	push   %edx
f010661c:	0f b7 c0             	movzwl %ax,%eax
f010661f:	50                   	push   %eax
f0106620:	ff 77 08             	pushl  0x8(%edi)
f0106623:	ff 77 04             	pushl  0x4(%edi)
f0106626:	8b 07                	mov    (%edi),%eax
f0106628:	ff 70 04             	pushl  0x4(%eax)
f010662b:	68 fc 87 10 f0       	push   $0xf01087fc
f0106630:	e8 32 d3 ff ff       	call   f0103967 <cprintf>
f0106635:	83 c4 30             	add    $0x30,%esp
	     bar += bar_width)
f0106638:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010663b:	83 fe 27             	cmp    $0x27,%esi
f010663e:	0f 87 9f 00 00 00    	ja     f01066e3 <pci_func_enable+0x11d>
		uint32_t oldv = pci_conf_read(f, bar);
f0106644:	89 f2                	mov    %esi,%edx
f0106646:	89 f8                	mov    %edi,%eax
f0106648:	e8 bd fc ff ff       	call   f010630a <pci_conf_read>
f010664d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0106650:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0106655:	89 f2                	mov    %esi,%edx
f0106657:	89 f8                	mov    %edi,%eax
f0106659:	e8 39 ff ff ff       	call   f0106597 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f010665e:	89 f2                	mov    %esi,%edx
f0106660:	89 f8                	mov    %edi,%eax
f0106662:	e8 a3 fc ff ff       	call   f010630a <pci_conf_read>
f0106667:	89 c3                	mov    %eax,%ebx
		bar_width = 4;
f0106669:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0106670:	85 c0                	test   %eax,%eax
f0106672:	74 c4                	je     f0106638 <pci_func_enable+0x72>
		int regnum = PCI_MAPREG_NUM(bar);
f0106674:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0106677:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010667a:	c1 e9 02             	shr    $0x2,%ecx
f010667d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0106680:	a8 01                	test   $0x1,%al
f0106682:	0f 85 66 ff ff ff    	jne    f01065ee <pci_func_enable+0x28>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0106688:	89 c1                	mov    %eax,%ecx
f010668a:	83 e1 06             	and    $0x6,%ecx
				bar_width = 8;
f010668d:	83 f9 04             	cmp    $0x4,%ecx
f0106690:	0f 94 c1             	sete   %cl
f0106693:	0f b6 c9             	movzbl %cl,%ecx
f0106696:	8d 14 8d 04 00 00 00 	lea    0x4(,%ecx,4),%edx
f010669d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f01066a0:	89 c2                	mov    %eax,%edx
f01066a2:	83 e2 f0             	and    $0xfffffff0,%edx
f01066a5:	89 d0                	mov    %edx,%eax
f01066a7:	f7 d8                	neg    %eax
f01066a9:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01066ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01066ae:	83 e0 f0             	and    $0xfffffff0,%eax
f01066b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		pci_conf_write(f, bar, oldv);
f01066b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01066b7:	89 f2                	mov    %esi,%edx
f01066b9:	89 f8                	mov    %edi,%eax
f01066bb:	e8 d7 fe ff ff       	call   f0106597 <pci_conf_write>
f01066c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01066c3:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f01066c5:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01066c8:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f01066cb:	89 58 2c             	mov    %ebx,0x2c(%eax)
		if (size && !base)
f01066ce:	85 db                	test   %ebx,%ebx
f01066d0:	0f 84 62 ff ff ff    	je     f0106638 <pci_func_enable+0x72>
f01066d6:	85 d2                	test   %edx,%edx
f01066d8:	0f 85 5a ff ff ff    	jne    f0106638 <pci_func_enable+0x72>
f01066de:	e9 27 ff ff ff       	jmp    f010660a <pci_func_enable+0x44>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01066e3:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f01066e6:	83 ec 08             	sub    $0x8,%esp
f01066e9:	89 c2                	mov    %eax,%edx
f01066eb:	c1 ea 10             	shr    $0x10,%edx
f01066ee:	52                   	push   %edx
f01066ef:	0f b7 c0             	movzwl %ax,%eax
f01066f2:	50                   	push   %eax
f01066f3:	ff 77 08             	pushl  0x8(%edi)
f01066f6:	ff 77 04             	pushl  0x4(%edi)
f01066f9:	8b 07                	mov    (%edi),%eax
f01066fb:	ff 70 04             	pushl  0x4(%eax)
f01066fe:	68 58 88 10 f0       	push   $0xf0108858
f0106703:	e8 5f d2 ff ff       	call   f0103967 <cprintf>
}
f0106708:	83 c4 20             	add    $0x20,%esp
f010670b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010670e:	5b                   	pop    %ebx
f010670f:	5e                   	pop    %esi
f0106710:	5f                   	pop    %edi
f0106711:	5d                   	pop    %ebp
f0106712:	c3                   	ret    

f0106713 <pci_init>:

int
pci_init(void)
{
f0106713:	f3 0f 1e fb          	endbr32 
f0106717:	55                   	push   %ebp
f0106718:	89 e5                	mov    %esp,%ebp
f010671a:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f010671d:	6a 08                	push   $0x8
f010671f:	6a 00                	push   $0x0
f0106721:	68 80 ee 2b f0       	push   $0xf02bee80
f0106726:	e8 83 f0 ff ff       	call   f01057ae <memset>

	return pci_scan_bus(&root_bus);
f010672b:	b8 80 ee 2b f0       	mov    $0xf02bee80,%eax
f0106730:	e8 fa fb ff ff       	call   f010632f <pci_scan_bus>
}
f0106735:	c9                   	leave  
f0106736:	c3                   	ret    

f0106737 <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f0106737:	f3 0f 1e fb          	endbr32 
	ticks = 0;
f010673b:	c7 05 88 ee 2b f0 00 	movl   $0x0,0xf02bee88
f0106742:	00 00 00 
}
f0106745:	c3                   	ret    

f0106746 <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0106746:	f3 0f 1e fb          	endbr32 
	ticks++;
f010674a:	a1 88 ee 2b f0       	mov    0xf02bee88,%eax
f010674f:	83 c0 01             	add    $0x1,%eax
f0106752:	a3 88 ee 2b f0       	mov    %eax,0xf02bee88
	if (ticks * 10 < ticks)
f0106757:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010675a:	01 d2                	add    %edx,%edx
f010675c:	39 d0                	cmp    %edx,%eax
f010675e:	77 01                	ja     f0106761 <time_tick+0x1b>
f0106760:	c3                   	ret    
{
f0106761:	55                   	push   %ebp
f0106762:	89 e5                	mov    %esp,%ebp
f0106764:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0106767:	68 60 89 10 f0       	push   $0xf0108960
f010676c:	6a 13                	push   $0x13
f010676e:	68 7b 89 10 f0       	push   $0xf010897b
f0106773:	e8 c8 98 ff ff       	call   f0100040 <_panic>

f0106778 <time_msec>:
}

unsigned int
time_msec(void)
{
f0106778:	f3 0f 1e fb          	endbr32 
	return ticks * 10;
f010677c:	a1 88 ee 2b f0       	mov    0xf02bee88,%eax
f0106781:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106784:	01 c0                	add    %eax,%eax
}
f0106786:	c3                   	ret    
f0106787:	66 90                	xchg   %ax,%ax
f0106789:	66 90                	xchg   %ax,%ax
f010678b:	66 90                	xchg   %ax,%ax
f010678d:	66 90                	xchg   %ax,%ax
f010678f:	90                   	nop

f0106790 <__udivdi3>:
f0106790:	f3 0f 1e fb          	endbr32 
f0106794:	55                   	push   %ebp
f0106795:	57                   	push   %edi
f0106796:	56                   	push   %esi
f0106797:	53                   	push   %ebx
f0106798:	83 ec 1c             	sub    $0x1c,%esp
f010679b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010679f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f01067a3:	8b 74 24 34          	mov    0x34(%esp),%esi
f01067a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f01067ab:	85 d2                	test   %edx,%edx
f01067ad:	75 19                	jne    f01067c8 <__udivdi3+0x38>
f01067af:	39 f3                	cmp    %esi,%ebx
f01067b1:	76 4d                	jbe    f0106800 <__udivdi3+0x70>
f01067b3:	31 ff                	xor    %edi,%edi
f01067b5:	89 e8                	mov    %ebp,%eax
f01067b7:	89 f2                	mov    %esi,%edx
f01067b9:	f7 f3                	div    %ebx
f01067bb:	89 fa                	mov    %edi,%edx
f01067bd:	83 c4 1c             	add    $0x1c,%esp
f01067c0:	5b                   	pop    %ebx
f01067c1:	5e                   	pop    %esi
f01067c2:	5f                   	pop    %edi
f01067c3:	5d                   	pop    %ebp
f01067c4:	c3                   	ret    
f01067c5:	8d 76 00             	lea    0x0(%esi),%esi
f01067c8:	39 f2                	cmp    %esi,%edx
f01067ca:	76 14                	jbe    f01067e0 <__udivdi3+0x50>
f01067cc:	31 ff                	xor    %edi,%edi
f01067ce:	31 c0                	xor    %eax,%eax
f01067d0:	89 fa                	mov    %edi,%edx
f01067d2:	83 c4 1c             	add    $0x1c,%esp
f01067d5:	5b                   	pop    %ebx
f01067d6:	5e                   	pop    %esi
f01067d7:	5f                   	pop    %edi
f01067d8:	5d                   	pop    %ebp
f01067d9:	c3                   	ret    
f01067da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01067e0:	0f bd fa             	bsr    %edx,%edi
f01067e3:	83 f7 1f             	xor    $0x1f,%edi
f01067e6:	75 48                	jne    f0106830 <__udivdi3+0xa0>
f01067e8:	39 f2                	cmp    %esi,%edx
f01067ea:	72 06                	jb     f01067f2 <__udivdi3+0x62>
f01067ec:	31 c0                	xor    %eax,%eax
f01067ee:	39 eb                	cmp    %ebp,%ebx
f01067f0:	77 de                	ja     f01067d0 <__udivdi3+0x40>
f01067f2:	b8 01 00 00 00       	mov    $0x1,%eax
f01067f7:	eb d7                	jmp    f01067d0 <__udivdi3+0x40>
f01067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106800:	89 d9                	mov    %ebx,%ecx
f0106802:	85 db                	test   %ebx,%ebx
f0106804:	75 0b                	jne    f0106811 <__udivdi3+0x81>
f0106806:	b8 01 00 00 00       	mov    $0x1,%eax
f010680b:	31 d2                	xor    %edx,%edx
f010680d:	f7 f3                	div    %ebx
f010680f:	89 c1                	mov    %eax,%ecx
f0106811:	31 d2                	xor    %edx,%edx
f0106813:	89 f0                	mov    %esi,%eax
f0106815:	f7 f1                	div    %ecx
f0106817:	89 c6                	mov    %eax,%esi
f0106819:	89 e8                	mov    %ebp,%eax
f010681b:	89 f7                	mov    %esi,%edi
f010681d:	f7 f1                	div    %ecx
f010681f:	89 fa                	mov    %edi,%edx
f0106821:	83 c4 1c             	add    $0x1c,%esp
f0106824:	5b                   	pop    %ebx
f0106825:	5e                   	pop    %esi
f0106826:	5f                   	pop    %edi
f0106827:	5d                   	pop    %ebp
f0106828:	c3                   	ret    
f0106829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106830:	89 f9                	mov    %edi,%ecx
f0106832:	b8 20 00 00 00       	mov    $0x20,%eax
f0106837:	29 f8                	sub    %edi,%eax
f0106839:	d3 e2                	shl    %cl,%edx
f010683b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010683f:	89 c1                	mov    %eax,%ecx
f0106841:	89 da                	mov    %ebx,%edx
f0106843:	d3 ea                	shr    %cl,%edx
f0106845:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106849:	09 d1                	or     %edx,%ecx
f010684b:	89 f2                	mov    %esi,%edx
f010684d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106851:	89 f9                	mov    %edi,%ecx
f0106853:	d3 e3                	shl    %cl,%ebx
f0106855:	89 c1                	mov    %eax,%ecx
f0106857:	d3 ea                	shr    %cl,%edx
f0106859:	89 f9                	mov    %edi,%ecx
f010685b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010685f:	89 eb                	mov    %ebp,%ebx
f0106861:	d3 e6                	shl    %cl,%esi
f0106863:	89 c1                	mov    %eax,%ecx
f0106865:	d3 eb                	shr    %cl,%ebx
f0106867:	09 de                	or     %ebx,%esi
f0106869:	89 f0                	mov    %esi,%eax
f010686b:	f7 74 24 08          	divl   0x8(%esp)
f010686f:	89 d6                	mov    %edx,%esi
f0106871:	89 c3                	mov    %eax,%ebx
f0106873:	f7 64 24 0c          	mull   0xc(%esp)
f0106877:	39 d6                	cmp    %edx,%esi
f0106879:	72 15                	jb     f0106890 <__udivdi3+0x100>
f010687b:	89 f9                	mov    %edi,%ecx
f010687d:	d3 e5                	shl    %cl,%ebp
f010687f:	39 c5                	cmp    %eax,%ebp
f0106881:	73 04                	jae    f0106887 <__udivdi3+0xf7>
f0106883:	39 d6                	cmp    %edx,%esi
f0106885:	74 09                	je     f0106890 <__udivdi3+0x100>
f0106887:	89 d8                	mov    %ebx,%eax
f0106889:	31 ff                	xor    %edi,%edi
f010688b:	e9 40 ff ff ff       	jmp    f01067d0 <__udivdi3+0x40>
f0106890:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106893:	31 ff                	xor    %edi,%edi
f0106895:	e9 36 ff ff ff       	jmp    f01067d0 <__udivdi3+0x40>
f010689a:	66 90                	xchg   %ax,%ax
f010689c:	66 90                	xchg   %ax,%ax
f010689e:	66 90                	xchg   %ax,%ax

f01068a0 <__umoddi3>:
f01068a0:	f3 0f 1e fb          	endbr32 
f01068a4:	55                   	push   %ebp
f01068a5:	57                   	push   %edi
f01068a6:	56                   	push   %esi
f01068a7:	53                   	push   %ebx
f01068a8:	83 ec 1c             	sub    $0x1c,%esp
f01068ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f01068af:	8b 74 24 30          	mov    0x30(%esp),%esi
f01068b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f01068b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
f01068bb:	85 c0                	test   %eax,%eax
f01068bd:	75 19                	jne    f01068d8 <__umoddi3+0x38>
f01068bf:	39 df                	cmp    %ebx,%edi
f01068c1:	76 5d                	jbe    f0106920 <__umoddi3+0x80>
f01068c3:	89 f0                	mov    %esi,%eax
f01068c5:	89 da                	mov    %ebx,%edx
f01068c7:	f7 f7                	div    %edi
f01068c9:	89 d0                	mov    %edx,%eax
f01068cb:	31 d2                	xor    %edx,%edx
f01068cd:	83 c4 1c             	add    $0x1c,%esp
f01068d0:	5b                   	pop    %ebx
f01068d1:	5e                   	pop    %esi
f01068d2:	5f                   	pop    %edi
f01068d3:	5d                   	pop    %ebp
f01068d4:	c3                   	ret    
f01068d5:	8d 76 00             	lea    0x0(%esi),%esi
f01068d8:	89 f2                	mov    %esi,%edx
f01068da:	39 d8                	cmp    %ebx,%eax
f01068dc:	76 12                	jbe    f01068f0 <__umoddi3+0x50>
f01068de:	89 f0                	mov    %esi,%eax
f01068e0:	89 da                	mov    %ebx,%edx
f01068e2:	83 c4 1c             	add    $0x1c,%esp
f01068e5:	5b                   	pop    %ebx
f01068e6:	5e                   	pop    %esi
f01068e7:	5f                   	pop    %edi
f01068e8:	5d                   	pop    %ebp
f01068e9:	c3                   	ret    
f01068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01068f0:	0f bd e8             	bsr    %eax,%ebp
f01068f3:	83 f5 1f             	xor    $0x1f,%ebp
f01068f6:	75 50                	jne    f0106948 <__umoddi3+0xa8>
f01068f8:	39 d8                	cmp    %ebx,%eax
f01068fa:	0f 82 e0 00 00 00    	jb     f01069e0 <__umoddi3+0x140>
f0106900:	89 d9                	mov    %ebx,%ecx
f0106902:	39 f7                	cmp    %esi,%edi
f0106904:	0f 86 d6 00 00 00    	jbe    f01069e0 <__umoddi3+0x140>
f010690a:	89 d0                	mov    %edx,%eax
f010690c:	89 ca                	mov    %ecx,%edx
f010690e:	83 c4 1c             	add    $0x1c,%esp
f0106911:	5b                   	pop    %ebx
f0106912:	5e                   	pop    %esi
f0106913:	5f                   	pop    %edi
f0106914:	5d                   	pop    %ebp
f0106915:	c3                   	ret    
f0106916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f010691d:	8d 76 00             	lea    0x0(%esi),%esi
f0106920:	89 fd                	mov    %edi,%ebp
f0106922:	85 ff                	test   %edi,%edi
f0106924:	75 0b                	jne    f0106931 <__umoddi3+0x91>
f0106926:	b8 01 00 00 00       	mov    $0x1,%eax
f010692b:	31 d2                	xor    %edx,%edx
f010692d:	f7 f7                	div    %edi
f010692f:	89 c5                	mov    %eax,%ebp
f0106931:	89 d8                	mov    %ebx,%eax
f0106933:	31 d2                	xor    %edx,%edx
f0106935:	f7 f5                	div    %ebp
f0106937:	89 f0                	mov    %esi,%eax
f0106939:	f7 f5                	div    %ebp
f010693b:	89 d0                	mov    %edx,%eax
f010693d:	31 d2                	xor    %edx,%edx
f010693f:	eb 8c                	jmp    f01068cd <__umoddi3+0x2d>
f0106941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106948:	89 e9                	mov    %ebp,%ecx
f010694a:	ba 20 00 00 00       	mov    $0x20,%edx
f010694f:	29 ea                	sub    %ebp,%edx
f0106951:	d3 e0                	shl    %cl,%eax
f0106953:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106957:	89 d1                	mov    %edx,%ecx
f0106959:	89 f8                	mov    %edi,%eax
f010695b:	d3 e8                	shr    %cl,%eax
f010695d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106961:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106965:	8b 54 24 04          	mov    0x4(%esp),%edx
f0106969:	09 c1                	or     %eax,%ecx
f010696b:	89 d8                	mov    %ebx,%eax
f010696d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106971:	89 e9                	mov    %ebp,%ecx
f0106973:	d3 e7                	shl    %cl,%edi
f0106975:	89 d1                	mov    %edx,%ecx
f0106977:	d3 e8                	shr    %cl,%eax
f0106979:	89 e9                	mov    %ebp,%ecx
f010697b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010697f:	d3 e3                	shl    %cl,%ebx
f0106981:	89 c7                	mov    %eax,%edi
f0106983:	89 d1                	mov    %edx,%ecx
f0106985:	89 f0                	mov    %esi,%eax
f0106987:	d3 e8                	shr    %cl,%eax
f0106989:	89 e9                	mov    %ebp,%ecx
f010698b:	89 fa                	mov    %edi,%edx
f010698d:	d3 e6                	shl    %cl,%esi
f010698f:	09 d8                	or     %ebx,%eax
f0106991:	f7 74 24 08          	divl   0x8(%esp)
f0106995:	89 d1                	mov    %edx,%ecx
f0106997:	89 f3                	mov    %esi,%ebx
f0106999:	f7 64 24 0c          	mull   0xc(%esp)
f010699d:	89 c6                	mov    %eax,%esi
f010699f:	89 d7                	mov    %edx,%edi
f01069a1:	39 d1                	cmp    %edx,%ecx
f01069a3:	72 06                	jb     f01069ab <__umoddi3+0x10b>
f01069a5:	75 10                	jne    f01069b7 <__umoddi3+0x117>
f01069a7:	39 c3                	cmp    %eax,%ebx
f01069a9:	73 0c                	jae    f01069b7 <__umoddi3+0x117>
f01069ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
f01069af:	1b 54 24 08          	sbb    0x8(%esp),%edx
f01069b3:	89 d7                	mov    %edx,%edi
f01069b5:	89 c6                	mov    %eax,%esi
f01069b7:	89 ca                	mov    %ecx,%edx
f01069b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01069be:	29 f3                	sub    %esi,%ebx
f01069c0:	19 fa                	sbb    %edi,%edx
f01069c2:	89 d0                	mov    %edx,%eax
f01069c4:	d3 e0                	shl    %cl,%eax
f01069c6:	89 e9                	mov    %ebp,%ecx
f01069c8:	d3 eb                	shr    %cl,%ebx
f01069ca:	d3 ea                	shr    %cl,%edx
f01069cc:	09 d8                	or     %ebx,%eax
f01069ce:	83 c4 1c             	add    $0x1c,%esp
f01069d1:	5b                   	pop    %ebx
f01069d2:	5e                   	pop    %esi
f01069d3:	5f                   	pop    %edi
f01069d4:	5d                   	pop    %ebp
f01069d5:	c3                   	ret    
f01069d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f01069dd:	8d 76 00             	lea    0x0(%esi),%esi
f01069e0:	29 fe                	sub    %edi,%esi
f01069e2:	19 c3                	sbb    %eax,%ebx
f01069e4:	89 f2                	mov    %esi,%edx
f01069e6:	89 d9                	mov    %ebx,%ecx
f01069e8:	e9 1d ff ff ff       	jmp    f010690a <__umoddi3+0x6a>
