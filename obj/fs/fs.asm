
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 57 1b 00 00       	call   801b88 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	f3 0f 1e fb          	endbr32 
  800063:	55                   	push   %ebp
  800064:	89 e5                	mov    %esp,%ebp
  800066:	53                   	push   %ebx
  800067:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006a:	b8 00 00 00 00       	mov    $0x0,%eax
  80006f:	e8 bf ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800074:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800079:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007e:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007f:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800084:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800089:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80008a:	a8 a1                	test   $0xa1,%al
  80008c:	74 0b                	je     800099 <ide_probe_disk1+0x3a>
	     x++)
  80008e:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  800091:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800097:	75 f0                	jne    800089 <ide_probe_disk1+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a3:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a4:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000aa:	0f 9e c3             	setle  %bl
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	0f b6 c3             	movzbl %bl,%eax
  8000b3:	50                   	push   %eax
  8000b4:	68 c0 3f 80 00       	push   $0x803fc0
  8000b9:	e8 19 1c 00 00       	call   801cd7 <cprintf>
	return (x < 1000);
}
  8000be:	89 d8                	mov    %ebx,%eax
  8000c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c5:	f3 0f 1e fb          	endbr32 
  8000c9:	55                   	push   %ebp
  8000ca:	89 e5                	mov    %esp,%ebp
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000d2:	83 f8 01             	cmp    $0x1,%eax
  8000d5:	77 07                	ja     8000de <ide_set_disk+0x19>
		panic("bad disk number");
	diskno = d;
  8000d7:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    
		panic("bad disk number");
  8000de:	83 ec 04             	sub    $0x4,%esp
  8000e1:	68 d7 3f 80 00       	push   $0x803fd7
  8000e6:	6a 3a                	push   $0x3a
  8000e8:	68 e7 3f 80 00       	push   $0x803fe7
  8000ed:	e8 fe 1a 00 00       	call   801bf0 <_panic>

008000f2 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f2:	f3 0f 1e fb          	endbr32 
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  800102:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800105:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800108:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010e:	77 60                	ja     800170 <ide_read+0x7e>

	ide_wait_ready(0);
  800110:	b8 00 00 00 00       	mov    $0x0,%eax
  800115:	e8 19 ff ff ff       	call   800033 <ide_wait_ready>
  80011a:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80011f:	89 f0                	mov    %esi,%eax
  800121:	ee                   	out    %al,(%dx)
  800122:	ba f3 01 00 00       	mov    $0x1f3,%edx
  800127:	89 f8                	mov    %edi,%eax
  800129:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  80012a:	89 f8                	mov    %edi,%eax
  80012c:	c1 e8 08             	shr    $0x8,%eax
  80012f:	ba f4 01 00 00       	mov    $0x1f4,%edx
  800134:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800135:	89 f8                	mov    %edi,%eax
  800137:	c1 e8 10             	shr    $0x10,%eax
  80013a:	ba f5 01 00 00       	mov    $0x1f5,%edx
  80013f:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800140:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800147:	c1 e0 04             	shl    $0x4,%eax
  80014a:	83 e0 10             	and    $0x10,%eax
  80014d:	c1 ef 18             	shr    $0x18,%edi
  800150:	83 e7 0f             	and    $0xf,%edi
  800153:	09 f8                	or     %edi,%eax
  800155:	83 c8 e0             	or     $0xffffffe0,%eax
  800158:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80015d:	ee                   	out    %al,(%dx)
  80015e:	b8 20 00 00 00       	mov    $0x20,%eax
  800163:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800168:	ee                   	out    %al,(%dx)
  800169:	c1 e6 09             	shl    $0x9,%esi
  80016c:	01 de                	add    %ebx,%esi
}
  80016e:	eb 2b                	jmp    80019b <ide_read+0xa9>
	assert(nsecs <= 256);
  800170:	68 f0 3f 80 00       	push   $0x803ff0
  800175:	68 fd 3f 80 00       	push   $0x803ffd
  80017a:	6a 44                	push   $0x44
  80017c:	68 e7 3f 80 00       	push   $0x803fe7
  800181:	e8 6a 1a 00 00       	call   801bf0 <_panic>
	asm volatile("cld\n\trepne\n\tinsl"
  800186:	89 df                	mov    %ebx,%edi
  800188:	b9 80 00 00 00       	mov    $0x80,%ecx
  80018d:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800192:	fc                   	cld    
  800193:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800195:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80019b:	39 f3                	cmp    %esi,%ebx
  80019d:	74 10                	je     8001af <ide_read+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  80019f:	b8 01 00 00 00       	mov    $0x1,%eax
  8001a4:	e8 8a fe ff ff       	call   800033 <ide_wait_ready>
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	79 d9                	jns    800186 <ide_read+0x94>
  8001ad:	eb 05                	jmp    8001b4 <ide_read+0xc2>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b7:	5b                   	pop    %ebx
  8001b8:	5e                   	pop    %esi
  8001b9:	5f                   	pop    %edi
  8001ba:	5d                   	pop    %ebp
  8001bb:	c3                   	ret    

008001bc <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001bc:	f3 0f 1e fb          	endbr32 
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8001cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001cf:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001d2:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001d8:	77 60                	ja     80023a <ide_write+0x7e>

	ide_wait_ready(0);
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001e4:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001e9:	89 f8                	mov    %edi,%eax
  8001eb:	ee                   	out    %al,(%dx)
  8001ec:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001f1:	89 f0                	mov    %esi,%eax
  8001f3:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001f4:	89 f0                	mov    %esi,%eax
  8001f6:	c1 e8 08             	shr    $0x8,%eax
  8001f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001fe:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001ff:	89 f0                	mov    %esi,%eax
  800201:	c1 e8 10             	shr    $0x10,%eax
  800204:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800209:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80020a:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800211:	c1 e0 04             	shl    $0x4,%eax
  800214:	83 e0 10             	and    $0x10,%eax
  800217:	c1 ee 18             	shr    $0x18,%esi
  80021a:	83 e6 0f             	and    $0xf,%esi
  80021d:	09 f0                	or     %esi,%eax
  80021f:	83 c8 e0             	or     $0xffffffe0,%eax
  800222:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800227:	ee                   	out    %al,(%dx)
  800228:	b8 30 00 00 00       	mov    $0x30,%eax
  80022d:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800232:	ee                   	out    %al,(%dx)
  800233:	c1 e7 09             	shl    $0x9,%edi
  800236:	01 df                	add    %ebx,%edi
}
  800238:	eb 2b                	jmp    800265 <ide_write+0xa9>
	assert(nsecs <= 256);
  80023a:	68 f0 3f 80 00       	push   $0x803ff0
  80023f:	68 fd 3f 80 00       	push   $0x803ffd
  800244:	6a 5d                	push   $0x5d
  800246:	68 e7 3f 80 00       	push   $0x803fe7
  80024b:	e8 a0 19 00 00       	call   801bf0 <_panic>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800250:	89 de                	mov    %ebx,%esi
  800252:	b9 80 00 00 00       	mov    $0x80,%ecx
  800257:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80025c:	fc                   	cld    
  80025d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80025f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800265:	39 fb                	cmp    %edi,%ebx
  800267:	74 10                	je     800279 <ide_write+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
  800269:	b8 01 00 00 00       	mov    $0x1,%eax
  80026e:	e8 c0 fd ff ff       	call   800033 <ide_wait_ready>
  800273:	85 c0                	test   %eax,%eax
  800275:	79 d9                	jns    800250 <ide_write+0x94>
  800277:	eb 05                	jmp    80027e <ide_write+0xc2>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80027e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    

00800286 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	56                   	push   %esi
  80028e:	53                   	push   %ebx
  80028f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800292:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800294:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80029a:	89 c6                	mov    %eax,%esi
  80029c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80029f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8002a4:	0f 87 95 00 00 00    	ja     80033f <bc_pgfault+0xb9>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002aa:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002af:	85 c0                	test   %eax,%eax
  8002b1:	74 09                	je     8002bc <bc_pgfault+0x36>
  8002b3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002b6:	0f 86 9e 00 00 00    	jbe    80035a <bc_pgfault+0xd4>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = (void*)ROUNDDOWN(addr, BLKSIZE);
  8002bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(0, addr, PTE_U | PTE_W | PTE_P)))
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	6a 07                	push   $0x7
  8002c7:	53                   	push   %ebx
  8002c8:	6a 00                	push   $0x0
  8002ca:	e8 54 24 00 00       	call   802723 <sys_page_alloc>
  8002cf:	83 c4 10             	add    $0x10,%esp
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	0f 85 92 00 00 00    	jne    80036c <bc_pgfault+0xe6>
		panic("bc_pagefault, sys_page_alloc:%e", r);
	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)))
  8002da:	83 ec 04             	sub    $0x4,%esp
  8002dd:	6a 08                	push   $0x8
  8002df:	53                   	push   %ebx
  8002e0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002e7:	50                   	push   %eax
  8002e8:	e8 05 fe ff ff       	call   8000f2 <ide_read>
  8002ed:	83 c4 10             	add    $0x10,%esp
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	0f 85 86 00 00 00    	jne    80037e <bc_pgfault+0xf8>
		panic("bc_pagefault, ide_read:%e", r);
	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002f8:	89 d8                	mov    %ebx,%eax
  8002fa:	c1 e8 0c             	shr    $0xc,%eax
  8002fd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	25 07 0e 00 00       	and    $0xe07,%eax
  80030c:	50                   	push   %eax
  80030d:	53                   	push   %ebx
  80030e:	6a 00                	push   $0x0
  800310:	53                   	push   %ebx
  800311:	6a 00                	push   $0x0
  800313:	e8 52 24 00 00       	call   80276a <sys_page_map>
  800318:	83 c4 20             	add    $0x20,%esp
  80031b:	85 c0                	test   %eax,%eax
  80031d:	78 71                	js     800390 <bc_pgfault+0x10a>
		panic("in bc_pgfault, sys_page_map: %e", r);
	
	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80031f:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  800326:	74 10                	je     800338 <bc_pgfault+0xb2>
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	56                   	push   %esi
  80032c:	e8 1f 05 00 00       	call   800850 <block_is_free>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	84 c0                	test   %al,%al
  800336:	75 6a                	jne    8003a2 <bc_pgfault+0x11c>
		panic("reading free block %08x\n", blockno);
}
  800338:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 72 04             	pushl  0x4(%edx)
  800345:	53                   	push   %ebx
  800346:	ff 72 28             	pushl  0x28(%edx)
  800349:	68 14 40 80 00       	push   $0x804014
  80034e:	6a 26                	push   $0x26
  800350:	68 f0 40 80 00       	push   $0x8040f0
  800355:	e8 96 18 00 00       	call   801bf0 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80035a:	56                   	push   %esi
  80035b:	68 44 40 80 00       	push   $0x804044
  800360:	6a 2b                	push   $0x2b
  800362:	68 f0 40 80 00       	push   $0x8040f0
  800367:	e8 84 18 00 00       	call   801bf0 <_panic>
		panic("bc_pagefault, sys_page_alloc:%e", r);
  80036c:	50                   	push   %eax
  80036d:	68 68 40 80 00       	push   $0x804068
  800372:	6a 35                	push   $0x35
  800374:	68 f0 40 80 00       	push   $0x8040f0
  800379:	e8 72 18 00 00       	call   801bf0 <_panic>
		panic("bc_pagefault, ide_read:%e", r);
  80037e:	50                   	push   %eax
  80037f:	68 f8 40 80 00       	push   $0x8040f8
  800384:	6a 37                	push   $0x37
  800386:	68 f0 40 80 00       	push   $0x8040f0
  80038b:	e8 60 18 00 00       	call   801bf0 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800390:	50                   	push   %eax
  800391:	68 88 40 80 00       	push   $0x804088
  800396:	6a 3b                	push   $0x3b
  800398:	68 f0 40 80 00       	push   $0x8040f0
  80039d:	e8 4e 18 00 00       	call   801bf0 <_panic>
		panic("reading free block %08x\n", blockno);
  8003a2:	56                   	push   %esi
  8003a3:	68 12 41 80 00       	push   $0x804112
  8003a8:	6a 41                	push   $0x41
  8003aa:	68 f0 40 80 00       	push   $0x8040f0
  8003af:	e8 3c 18 00 00       	call   801bf0 <_panic>

008003b4 <diskaddr>:
{
  8003b4:	f3 0f 1e fb          	endbr32 
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003c1:	85 c0                	test   %eax,%eax
  8003c3:	74 19                	je     8003de <diskaddr+0x2a>
  8003c5:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8003cb:	85 d2                	test   %edx,%edx
  8003cd:	74 05                	je     8003d4 <diskaddr+0x20>
  8003cf:	39 42 04             	cmp    %eax,0x4(%edx)
  8003d2:	76 0a                	jbe    8003de <diskaddr+0x2a>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003d4:	05 00 00 01 00       	add    $0x10000,%eax
  8003d9:	c1 e0 0c             	shl    $0xc,%eax
}
  8003dc:	c9                   	leave  
  8003dd:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003de:	50                   	push   %eax
  8003df:	68 a8 40 80 00       	push   $0x8040a8
  8003e4:	6a 09                	push   $0x9
  8003e6:	68 f0 40 80 00       	push   $0x8040f0
  8003eb:	e8 00 18 00 00       	call   801bf0 <_panic>

008003f0 <va_is_mapped>:
{
  8003f0:	f3 0f 1e fb          	endbr32 
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003fa:	89 d0                	mov    %edx,%eax
  8003fc:	c1 e8 16             	shr    $0x16,%eax
  8003ff:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  800406:	b8 00 00 00 00       	mov    $0x0,%eax
  80040b:	f6 c1 01             	test   $0x1,%cl
  80040e:	74 0d                	je     80041d <va_is_mapped+0x2d>
  800410:	c1 ea 0c             	shr    $0xc,%edx
  800413:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80041a:	83 e0 01             	and    $0x1,%eax
  80041d:	83 e0 01             	and    $0x1,%eax
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <va_is_dirty>:
{
  800422:	f3 0f 1e fb          	endbr32 
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	c1 e8 0c             	shr    $0xc,%eax
  80042f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800436:	c1 e8 06             	shr    $0x6,%eax
  800439:	83 e0 01             	and    $0x1,%eax
}
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  80043e:	f3 0f 1e fb          	endbr32 
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
  800445:	56                   	push   %esi
  800446:	53                   	push   %ebx
  800447:	8b 45 08             	mov    0x8(%ebp),%eax
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80044a:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800450:	81 fe ff ff ff bf    	cmp    $0xbfffffff,%esi
  800456:	77 1e                	ja     800476 <flush_block+0x38>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	addr = (void*)ROUNDDOWN(addr, BLKSIZE);
  800458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80045d:	89 c3                	mov    %eax,%ebx
	if (va_is_mapped(addr) && va_is_dirty(addr)) {
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 88 ff ff ff       	call   8003f0 <va_is_mapped>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	84 c0                	test   %al,%al
  80046d:	75 19                	jne    800488 <flush_block+0x4a>
			panic("flush_block, ide_write:%e", r);
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
			panic("flush_block, sys_page_map:%e", r);
	}
	// panic("flush_block not implemented");
}
  80046f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800472:	5b                   	pop    %ebx
  800473:	5e                   	pop    %esi
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800476:	50                   	push   %eax
  800477:	68 2b 41 80 00       	push   $0x80412b
  80047c:	6a 51                	push   $0x51
  80047e:	68 f0 40 80 00       	push   $0x8040f0
  800483:	e8 68 17 00 00       	call   801bf0 <_panic>
	if (va_is_mapped(addr) && va_is_dirty(addr)) {
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	53                   	push   %ebx
  80048c:	e8 91 ff ff ff       	call   800422 <va_is_dirty>
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	84 c0                	test   %al,%al
  800496:	74 d7                	je     80046f <flush_block+0x31>
		if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	6a 08                	push   $0x8
  80049d:	53                   	push   %ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80049e:	c1 ee 0c             	shr    $0xc,%esi
		if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8004a1:	c1 e6 03             	shl    $0x3,%esi
  8004a4:	56                   	push   %esi
  8004a5:	e8 12 fd ff ff       	call   8001bc <ide_write>
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	78 39                	js     8004ea <flush_block+0xac>
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8004b1:	89 d8                	mov    %ebx,%eax
  8004b3:	c1 e8 0c             	shr    $0xc,%eax
  8004b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004bd:	83 ec 0c             	sub    $0xc,%esp
  8004c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8004c5:	50                   	push   %eax
  8004c6:	53                   	push   %ebx
  8004c7:	6a 00                	push   $0x0
  8004c9:	53                   	push   %ebx
  8004ca:	6a 00                	push   $0x0
  8004cc:	e8 99 22 00 00       	call   80276a <sys_page_map>
  8004d1:	83 c4 20             	add    $0x20,%esp
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	79 97                	jns    80046f <flush_block+0x31>
			panic("flush_block, sys_page_map:%e", r);
  8004d8:	50                   	push   %eax
  8004d9:	68 60 41 80 00       	push   $0x804160
  8004de:	6a 5a                	push   $0x5a
  8004e0:	68 f0 40 80 00       	push   $0x8040f0
  8004e5:	e8 06 17 00 00       	call   801bf0 <_panic>
			panic("flush_block, ide_write:%e", r);
  8004ea:	50                   	push   %eax
  8004eb:	68 46 41 80 00       	push   $0x804146
  8004f0:	6a 58                	push   $0x58
  8004f2:	68 f0 40 80 00       	push   $0x8040f0
  8004f7:	e8 f4 16 00 00       	call   801bf0 <_panic>

008004fc <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8004fc:	f3 0f 1e fb          	endbr32 
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	53                   	push   %ebx
  800504:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  80050a:	68 86 02 80 00       	push   $0x800286
  80050f:	e8 43 24 00 00       	call   802957 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  800514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80051b:	e8 94 fe ff ff       	call   8003b4 <diskaddr>
  800520:	83 c4 0c             	add    $0xc,%esp
  800523:	68 08 01 00 00       	push   $0x108
  800528:	50                   	push   %eax
  800529:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 62 1f 00 00       	call   802497 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800535:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80053c:	e8 73 fe ff ff       	call   8003b4 <diskaddr>
  800541:	83 c4 08             	add    $0x8,%esp
  800544:	68 7d 41 80 00       	push   $0x80417d
  800549:	50                   	push   %eax
  80054a:	e8 92 1d 00 00       	call   8022e1 <strcpy>
	flush_block(diskaddr(1));
  80054f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800556:	e8 59 fe ff ff       	call   8003b4 <diskaddr>
  80055b:	89 04 24             	mov    %eax,(%esp)
  80055e:	e8 db fe ff ff       	call   80043e <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800563:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80056a:	e8 45 fe ff ff       	call   8003b4 <diskaddr>
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	e8 79 fe ff ff       	call   8003f0 <va_is_mapped>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	84 c0                	test   %al,%al
  80057c:	0f 84 d1 01 00 00    	je     800753 <bc_init+0x257>
	assert(!va_is_dirty(diskaddr(1)));
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	6a 01                	push   $0x1
  800587:	e8 28 fe ff ff       	call   8003b4 <diskaddr>
  80058c:	89 04 24             	mov    %eax,(%esp)
  80058f:	e8 8e fe ff ff       	call   800422 <va_is_dirty>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	84 c0                	test   %al,%al
  800599:	0f 85 ca 01 00 00    	jne    800769 <bc_init+0x26d>
	sys_page_unmap(0, diskaddr(1));
  80059f:	83 ec 0c             	sub    $0xc,%esp
  8005a2:	6a 01                	push   $0x1
  8005a4:	e8 0b fe ff ff       	call   8003b4 <diskaddr>
  8005a9:	83 c4 08             	add    $0x8,%esp
  8005ac:	50                   	push   %eax
  8005ad:	6a 00                	push   $0x0
  8005af:	e8 fc 21 00 00       	call   8027b0 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005bb:	e8 f4 fd ff ff       	call   8003b4 <diskaddr>
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	e8 28 fe ff ff       	call   8003f0 <va_is_mapped>
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	84 c0                	test   %al,%al
  8005cd:	0f 85 ac 01 00 00    	jne    80077f <bc_init+0x283>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005d3:	83 ec 0c             	sub    $0xc,%esp
  8005d6:	6a 01                	push   $0x1
  8005d8:	e8 d7 fd ff ff       	call   8003b4 <diskaddr>
  8005dd:	83 c4 08             	add    $0x8,%esp
  8005e0:	68 7d 41 80 00       	push   $0x80417d
  8005e5:	50                   	push   %eax
  8005e6:	e8 b5 1d 00 00       	call   8023a0 <strcmp>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	0f 85 9f 01 00 00    	jne    800795 <bc_init+0x299>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	6a 01                	push   $0x1
  8005fb:	e8 b4 fd ff ff       	call   8003b4 <diskaddr>
  800600:	83 c4 0c             	add    $0xc,%esp
  800603:	68 08 01 00 00       	push   $0x108
  800608:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  80060e:	53                   	push   %ebx
  80060f:	50                   	push   %eax
  800610:	e8 82 1e 00 00       	call   802497 <memmove>
	flush_block(diskaddr(1));
  800615:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80061c:	e8 93 fd ff ff       	call   8003b4 <diskaddr>
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 15 fe ff ff       	call   80043e <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  800629:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800630:	e8 7f fd ff ff       	call   8003b4 <diskaddr>
  800635:	83 c4 0c             	add    $0xc,%esp
  800638:	68 08 01 00 00       	push   $0x108
  80063d:	50                   	push   %eax
  80063e:	53                   	push   %ebx
  80063f:	e8 53 1e 00 00       	call   802497 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80064b:	e8 64 fd ff ff       	call   8003b4 <diskaddr>
  800650:	83 c4 08             	add    $0x8,%esp
  800653:	68 7d 41 80 00       	push   $0x80417d
  800658:	50                   	push   %eax
  800659:	e8 83 1c 00 00       	call   8022e1 <strcpy>
	flush_block(diskaddr(1) + 20);
  80065e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800665:	e8 4a fd ff ff       	call   8003b4 <diskaddr>
  80066a:	83 c0 14             	add    $0x14,%eax
  80066d:	89 04 24             	mov    %eax,(%esp)
  800670:	e8 c9 fd ff ff       	call   80043e <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800675:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80067c:	e8 33 fd ff ff       	call   8003b4 <diskaddr>
  800681:	89 04 24             	mov    %eax,(%esp)
  800684:	e8 67 fd ff ff       	call   8003f0 <va_is_mapped>
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	84 c0                	test   %al,%al
  80068e:	0f 84 17 01 00 00    	je     8007ab <bc_init+0x2af>
	sys_page_unmap(0, diskaddr(1));
  800694:	83 ec 0c             	sub    $0xc,%esp
  800697:	6a 01                	push   $0x1
  800699:	e8 16 fd ff ff       	call   8003b4 <diskaddr>
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	50                   	push   %eax
  8006a2:	6a 00                	push   $0x0
  8006a4:	e8 07 21 00 00       	call   8027b0 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8006a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006b0:	e8 ff fc ff ff       	call   8003b4 <diskaddr>
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	e8 33 fd ff ff       	call   8003f0 <va_is_mapped>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	84 c0                	test   %al,%al
  8006c2:	0f 85 fc 00 00 00    	jne    8007c4 <bc_init+0x2c8>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006c8:	83 ec 0c             	sub    $0xc,%esp
  8006cb:	6a 01                	push   $0x1
  8006cd:	e8 e2 fc ff ff       	call   8003b4 <diskaddr>
  8006d2:	83 c4 08             	add    $0x8,%esp
  8006d5:	68 7d 41 80 00       	push   $0x80417d
  8006da:	50                   	push   %eax
  8006db:	e8 c0 1c 00 00       	call   8023a0 <strcmp>
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	0f 85 f2 00 00 00    	jne    8007dd <bc_init+0x2e1>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006eb:	83 ec 0c             	sub    $0xc,%esp
  8006ee:	6a 01                	push   $0x1
  8006f0:	e8 bf fc ff ff       	call   8003b4 <diskaddr>
  8006f5:	83 c4 0c             	add    $0xc,%esp
  8006f8:	68 08 01 00 00       	push   $0x108
  8006fd:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  800703:	52                   	push   %edx
  800704:	50                   	push   %eax
  800705:	e8 8d 1d 00 00       	call   802497 <memmove>
	flush_block(diskaddr(1));
  80070a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800711:	e8 9e fc ff ff       	call   8003b4 <diskaddr>
  800716:	89 04 24             	mov    %eax,(%esp)
  800719:	e8 20 fd ff ff       	call   80043e <flush_block>
	cprintf("block cache is good\n");
  80071e:	c7 04 24 b9 41 80 00 	movl   $0x8041b9,(%esp)
  800725:	e8 ad 15 00 00       	call   801cd7 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80072a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800731:	e8 7e fc ff ff       	call   8003b4 <diskaddr>
  800736:	83 c4 0c             	add    $0xc,%esp
  800739:	68 08 01 00 00       	push   $0x108
  80073e:	50                   	push   %eax
  80073f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800745:	50                   	push   %eax
  800746:	e8 4c 1d 00 00       	call   802497 <memmove>
}
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800753:	68 9f 41 80 00       	push   $0x80419f
  800758:	68 fd 3f 80 00       	push   $0x803ffd
  80075d:	6a 6c                	push   $0x6c
  80075f:	68 f0 40 80 00       	push   $0x8040f0
  800764:	e8 87 14 00 00       	call   801bf0 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800769:	68 84 41 80 00       	push   $0x804184
  80076e:	68 fd 3f 80 00       	push   $0x803ffd
  800773:	6a 6d                	push   $0x6d
  800775:	68 f0 40 80 00       	push   $0x8040f0
  80077a:	e8 71 14 00 00       	call   801bf0 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  80077f:	68 9e 41 80 00       	push   $0x80419e
  800784:	68 fd 3f 80 00       	push   $0x803ffd
  800789:	6a 71                	push   $0x71
  80078b:	68 f0 40 80 00       	push   $0x8040f0
  800790:	e8 5b 14 00 00       	call   801bf0 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800795:	68 cc 40 80 00       	push   $0x8040cc
  80079a:	68 fd 3f 80 00       	push   $0x803ffd
  80079f:	6a 74                	push   $0x74
  8007a1:	68 f0 40 80 00       	push   $0x8040f0
  8007a6:	e8 45 14 00 00       	call   801bf0 <_panic>
	assert(va_is_mapped(diskaddr(1)));
  8007ab:	68 9f 41 80 00       	push   $0x80419f
  8007b0:	68 fd 3f 80 00       	push   $0x803ffd
  8007b5:	68 85 00 00 00       	push   $0x85
  8007ba:	68 f0 40 80 00       	push   $0x8040f0
  8007bf:	e8 2c 14 00 00       	call   801bf0 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007c4:	68 9e 41 80 00       	push   $0x80419e
  8007c9:	68 fd 3f 80 00       	push   $0x803ffd
  8007ce:	68 8d 00 00 00       	push   $0x8d
  8007d3:	68 f0 40 80 00       	push   $0x8040f0
  8007d8:	e8 13 14 00 00       	call   801bf0 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007dd:	68 cc 40 80 00       	push   $0x8040cc
  8007e2:	68 fd 3f 80 00       	push   $0x803ffd
  8007e7:	68 90 00 00 00       	push   $0x90
  8007ec:	68 f0 40 80 00       	push   $0x8040f0
  8007f1:	e8 fa 13 00 00       	call   801bf0 <_panic>

008007f6 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800800:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800805:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  80080b:	75 1b                	jne    800828 <check_super+0x32>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80080d:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800814:	77 26                	ja     80083c <check_super+0x46>
		panic("file system is too large");

	cprintf("superblock is good\n");
  800816:	83 ec 0c             	sub    $0xc,%esp
  800819:	68 0c 42 80 00       	push   $0x80420c
  80081e:	e8 b4 14 00 00       	call   801cd7 <cprintf>
}
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	c9                   	leave  
  800827:	c3                   	ret    
		panic("bad file system magic number");
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 ce 41 80 00       	push   $0x8041ce
  800830:	6a 0f                	push   $0xf
  800832:	68 eb 41 80 00       	push   $0x8041eb
  800837:	e8 b4 13 00 00       	call   801bf0 <_panic>
		panic("file system is too large");
  80083c:	83 ec 04             	sub    $0x4,%esp
  80083f:	68 f3 41 80 00       	push   $0x8041f3
  800844:	6a 12                	push   $0x12
  800846:	68 eb 41 80 00       	push   $0x8041eb
  80084b:	e8 a0 13 00 00       	call   801bf0 <_panic>

00800850 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800850:	f3 0f 1e fb          	endbr32 
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	53                   	push   %ebx
  800858:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  80085b:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800860:	85 c0                	test   %eax,%eax
  800862:	74 27                	je     80088b <block_is_free+0x3b>
		return 0;
  800864:	ba 00 00 00 00       	mov    $0x0,%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800869:	39 48 04             	cmp    %ecx,0x4(%eax)
  80086c:	76 18                	jbe    800886 <block_is_free+0x36>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80086e:	89 cb                	mov    %ecx,%ebx
  800870:	c1 eb 05             	shr    $0x5,%ebx
  800873:	b8 01 00 00 00       	mov    $0x1,%eax
  800878:	d3 e0                	shl    %cl,%eax
  80087a:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800880:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  800883:	0f 95 c2             	setne  %dl
		return 1;
	return 0;
}
  800886:	89 d0                	mov    %edx,%eax
  800888:	5b                   	pop    %ebx
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    
		return 0;
  80088b:	ba 00 00 00 00       	mov    $0x0,%edx
  800890:	eb f4                	jmp    800886 <block_is_free+0x36>

00800892 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800892:	f3 0f 1e fb          	endbr32 
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	53                   	push   %ebx
  80089a:	83 ec 04             	sub    $0x4,%esp
  80089d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8008a0:	85 c9                	test   %ecx,%ecx
  8008a2:	74 1a                	je     8008be <free_block+0x2c>
		panic("attempt to free zero block");
	bitmap[blockno/32] |= 1<<(blockno%32);
  8008a4:	89 cb                	mov    %ecx,%ebx
  8008a6:	c1 eb 05             	shr    $0x5,%ebx
  8008a9:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  8008af:	b8 01 00 00 00       	mov    $0x1,%eax
  8008b4:	d3 e0                	shl    %cl,%eax
  8008b6:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  8008b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    
		panic("attempt to free zero block");
  8008be:	83 ec 04             	sub    $0x4,%esp
  8008c1:	68 20 42 80 00       	push   $0x804220
  8008c6:	6a 2d                	push   $0x2d
  8008c8:	68 eb 41 80 00       	push   $0x8041eb
  8008cd:	e8 1e 13 00 00       	call   801bf0 <_panic>

008008d2 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	57                   	push   %edi
  8008da:	56                   	push   %esi
  8008db:	53                   	push   %ebx
  8008dc:	83 ec 0c             	sub    $0xc,%esp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	int i;
	for (i = 2; i < super->s_nblocks; ++i) {
  8008df:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008e4:	8b 70 04             	mov    0x4(%eax),%esi
  8008e7:	bb 02 00 00 00       	mov    $0x2,%ebx
  8008ec:	89 df                	mov    %ebx,%edi
  8008ee:	39 de                	cmp    %ebx,%esi
  8008f0:	76 56                	jbe    800948 <alloc_block+0x76>
		if (block_is_free(i)) {
  8008f2:	83 ec 0c             	sub    $0xc,%esp
  8008f5:	53                   	push   %ebx
  8008f6:	e8 55 ff ff ff       	call   800850 <block_is_free>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	84 c0                	test   %al,%al
  800900:	75 05                	jne    800907 <alloc_block+0x35>
	for (i = 2; i < super->s_nblocks; ++i) {
  800902:	83 c3 01             	add    $0x1,%ebx
  800905:	eb e5                	jmp    8008ec <alloc_block+0x1a>
			bitmap[i / 32] &= ~(1 << (i % 32));
  800907:	8d 43 1f             	lea    0x1f(%ebx),%eax
  80090a:	85 db                	test   %ebx,%ebx
  80090c:	0f 49 c3             	cmovns %ebx,%eax
  80090f:	c1 f8 05             	sar    $0x5,%eax
  800912:	8b 35 08 a0 80 00    	mov    0x80a008,%esi
  800918:	89 da                	mov    %ebx,%edx
  80091a:	c1 fa 1f             	sar    $0x1f,%edx
  80091d:	c1 ea 1b             	shr    $0x1b,%edx
  800920:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  800923:	83 e1 1f             	and    $0x1f,%ecx
  800926:	29 d1                	sub    %edx,%ecx
  800928:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
  80092d:	d3 c2                	rol    %cl,%edx
  80092f:	21 14 86             	and    %edx,(%esi,%eax,4)
			flush_block(diskaddr(i));
  800932:	83 ec 0c             	sub    $0xc,%esp
  800935:	57                   	push   %edi
  800936:	e8 79 fa ff ff       	call   8003b4 <diskaddr>
  80093b:	89 04 24             	mov    %eax,(%esp)
  80093e:	e8 fb fa ff ff       	call   80043e <flush_block>
			return i;
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	eb 05                	jmp    80094d <alloc_block+0x7b>
		}
	}
	
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
  800948:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
}
  80094d:	89 d8                	mov    %ebx,%eax
  80094f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5f                   	pop    %edi
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	57                   	push   %edi
  80095b:	56                   	push   %esi
  80095c:	53                   	push   %ebx
  80095d:	83 ec 1c             	sub    $0x1c,%esp
  800960:	89 c6                	mov    %eax,%esi
  800962:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
        // LAB 5: Your code here.
	    if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  800968:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  80096e:	0f 87 88 00 00 00    	ja     8009fc <file_block_walk+0xa5>
  800974:	89 d3                	mov    %edx,%ebx
	    if (filebno < NDIRECT) {
  800976:	83 fa 09             	cmp    $0x9,%edx
  800979:	77 16                	ja     800991 <file_block_walk+0x3a>
			*ppdiskbno = f->f_direct + filebno;
  80097b:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  800982:	89 01                	mov    %eax,(%ecx)
				memset(diskaddr(blockno), 0, BLKSIZE);
				flush_block(diskaddr(blockno));
			}
			*ppdiskbno = (uint32_t *)diskaddr(f->f_indirect) + (filebno - NDIRECT);
		}
		return 0;
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
		
        //panic("file_block_walk not implemented");
}
  800989:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5f                   	pop    %edi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    
			if (!f->f_indirect) {
  800991:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800998:	75 41                	jne    8009db <file_block_walk+0x84>
				if (!alloc) return -E_NOT_FOUND;
  80099a:	84 c0                	test   %al,%al
  80099c:	74 65                	je     800a03 <file_block_walk+0xac>
				int blockno = alloc_block();
  80099e:	e8 2f ff ff ff       	call   8008d2 <alloc_block>
  8009a3:	89 c7                	mov    %eax,%edi
				if (blockno < 0) return -E_NO_DISK;
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	78 64                	js     800a0d <file_block_walk+0xb6>
				f->f_indirect = blockno;
  8009a9:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
				memset(diskaddr(blockno), 0, BLKSIZE);
  8009af:	83 ec 0c             	sub    $0xc,%esp
  8009b2:	50                   	push   %eax
  8009b3:	e8 fc f9 ff ff       	call   8003b4 <diskaddr>
  8009b8:	83 c4 0c             	add    $0xc,%esp
  8009bb:	68 00 10 00 00       	push   $0x1000
  8009c0:	6a 00                	push   $0x0
  8009c2:	50                   	push   %eax
  8009c3:	e8 83 1a 00 00       	call   80244b <memset>
				flush_block(diskaddr(blockno));
  8009c8:	89 3c 24             	mov    %edi,(%esp)
  8009cb:	e8 e4 f9 ff ff       	call   8003b4 <diskaddr>
  8009d0:	89 04 24             	mov    %eax,(%esp)
  8009d3:	e8 66 fa ff ff       	call   80043e <flush_block>
  8009d8:	83 c4 10             	add    $0x10,%esp
			*ppdiskbno = (uint32_t *)diskaddr(f->f_indirect) + (filebno - NDIRECT);
  8009db:	83 ec 0c             	sub    $0xc,%esp
  8009de:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  8009e4:	e8 cb f9 ff ff       	call   8003b4 <diskaddr>
  8009e9:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  8009ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009f0:	89 07                	mov    %eax,(%edi)
  8009f2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8009f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fa:	eb 8d                	jmp    800989 <file_block_walk+0x32>
	    if (filebno >= NDIRECT + NINDIRECT) return -E_INVAL;
  8009fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a01:	eb 86                	jmp    800989 <file_block_walk+0x32>
				if (!alloc) return -E_NOT_FOUND;
  800a03:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800a08:	e9 7c ff ff ff       	jmp    800989 <file_block_walk+0x32>
				if (blockno < 0) return -E_NO_DISK;
  800a0d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800a12:	e9 72 ff ff ff       	jmp    800989 <file_block_walk+0x32>

00800a17 <check_bitmap>:
{
  800a17:	f3 0f 1e fb          	endbr32 
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a20:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800a25:	8b 70 04             	mov    0x4(%eax),%esi
  800a28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a2d:	89 d8                	mov    %ebx,%eax
  800a2f:	c1 e0 0f             	shl    $0xf,%eax
  800a32:	39 c6                	cmp    %eax,%esi
  800a34:	76 2e                	jbe    800a64 <check_bitmap+0x4d>
		assert(!block_is_free(2+i));
  800a36:	83 ec 0c             	sub    $0xc,%esp
  800a39:	8d 43 02             	lea    0x2(%ebx),%eax
  800a3c:	50                   	push   %eax
  800a3d:	e8 0e fe ff ff       	call   800850 <block_is_free>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	84 c0                	test   %al,%al
  800a47:	75 05                	jne    800a4e <check_bitmap+0x37>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800a49:	83 c3 01             	add    $0x1,%ebx
  800a4c:	eb df                	jmp    800a2d <check_bitmap+0x16>
		assert(!block_is_free(2+i));
  800a4e:	68 3b 42 80 00       	push   $0x80423b
  800a53:	68 fd 3f 80 00       	push   $0x803ffd
  800a58:	6a 59                	push   $0x59
  800a5a:	68 eb 41 80 00       	push   $0x8041eb
  800a5f:	e8 8c 11 00 00       	call   801bf0 <_panic>
	assert(!block_is_free(0));
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	6a 00                	push   $0x0
  800a69:	e8 e2 fd ff ff       	call   800850 <block_is_free>
  800a6e:	83 c4 10             	add    $0x10,%esp
  800a71:	84 c0                	test   %al,%al
  800a73:	75 28                	jne    800a9d <check_bitmap+0x86>
	assert(!block_is_free(1));
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	6a 01                	push   $0x1
  800a7a:	e8 d1 fd ff ff       	call   800850 <block_is_free>
  800a7f:	83 c4 10             	add    $0x10,%esp
  800a82:	84 c0                	test   %al,%al
  800a84:	75 2d                	jne    800ab3 <check_bitmap+0x9c>
	cprintf("bitmap is good\n");
  800a86:	83 ec 0c             	sub    $0xc,%esp
  800a89:	68 73 42 80 00       	push   $0x804273
  800a8e:	e8 44 12 00 00       	call   801cd7 <cprintf>
}
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a99:	5b                   	pop    %ebx
  800a9a:	5e                   	pop    %esi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    
	assert(!block_is_free(0));
  800a9d:	68 4f 42 80 00       	push   $0x80424f
  800aa2:	68 fd 3f 80 00       	push   $0x803ffd
  800aa7:	6a 5c                	push   $0x5c
  800aa9:	68 eb 41 80 00       	push   $0x8041eb
  800aae:	e8 3d 11 00 00       	call   801bf0 <_panic>
	assert(!block_is_free(1));
  800ab3:	68 61 42 80 00       	push   $0x804261
  800ab8:	68 fd 3f 80 00       	push   $0x803ffd
  800abd:	6a 5d                	push   $0x5d
  800abf:	68 eb 41 80 00       	push   $0x8041eb
  800ac4:	e8 27 11 00 00       	call   801bf0 <_panic>

00800ac9 <fs_init>:
{
  800ac9:	f3 0f 1e fb          	endbr32 
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800ad3:	e8 87 f5 ff ff       	call   80005f <ide_probe_disk1>
  800ad8:	84 c0                	test   %al,%al
  800ada:	74 41                	je     800b1d <fs_init+0x54>
		ide_set_disk(1);
  800adc:	83 ec 0c             	sub    $0xc,%esp
  800adf:	6a 01                	push   $0x1
  800ae1:	e8 df f5 ff ff       	call   8000c5 <ide_set_disk>
  800ae6:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800ae9:	e8 0e fa ff ff       	call   8004fc <bc_init>
	super = diskaddr(1);
  800aee:	83 ec 0c             	sub    $0xc,%esp
  800af1:	6a 01                	push   $0x1
  800af3:	e8 bc f8 ff ff       	call   8003b4 <diskaddr>
  800af8:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800afd:	e8 f4 fc ff ff       	call   8007f6 <check_super>
	bitmap = diskaddr(2);
  800b02:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800b09:	e8 a6 f8 ff ff       	call   8003b4 <diskaddr>
  800b0e:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800b13:	e8 ff fe ff ff       	call   800a17 <check_bitmap>
}
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    
		ide_set_disk(0);
  800b1d:	83 ec 0c             	sub    $0xc,%esp
  800b20:	6a 00                	push   $0x0
  800b22:	e8 9e f5 ff ff       	call   8000c5 <ide_set_disk>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	eb bd                	jmp    800ae9 <fs_init+0x20>

00800b2c <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800b2c:	f3 0f 1e fb          	endbr32 
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	83 ec 1c             	sub    $0x1c,%esp
        // LAB 5: Your code here.
	    uint32_t *ppdiskbno;
	    int r;
		if ((r = file_block_walk(f, filebno, &ppdiskbno, 1)))
  800b38:	6a 01                	push   $0x1
  800b3a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	e8 0f fe ff ff       	call   800957 <file_block_walk>
  800b48:	89 c3                	mov    %eax,%ebx
  800b4a:	83 c4 10             	add    $0x10,%esp
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 59                	jne    800baa <file_get_block+0x7e>
	   		return r;
		if (*ppdiskbno == 0) {
  800b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b54:	83 38 00             	cmpl   $0x0,(%eax)
  800b57:	75 3c                	jne    800b95 <file_get_block+0x69>
			if ((r = alloc_block()) < 0) return r;
  800b59:	e8 74 fd ff ff       	call   8008d2 <alloc_block>
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	85 c0                	test   %eax,%eax
  800b62:	78 4f                	js     800bb3 <file_get_block+0x87>
			*ppdiskbno = r;
  800b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b67:	89 30                	mov    %esi,(%eax)
			memset(diskaddr(r), 0, BLKSIZE);
  800b69:	83 ec 0c             	sub    $0xc,%esp
  800b6c:	56                   	push   %esi
  800b6d:	e8 42 f8 ff ff       	call   8003b4 <diskaddr>
  800b72:	83 c4 0c             	add    $0xc,%esp
  800b75:	68 00 10 00 00       	push   $0x1000
  800b7a:	6a 00                	push   $0x0
  800b7c:	50                   	push   %eax
  800b7d:	e8 c9 18 00 00       	call   80244b <memset>
			flush_block(diskaddr(r));
  800b82:	89 34 24             	mov    %esi,(%esp)
  800b85:	e8 2a f8 ff ff       	call   8003b4 <diskaddr>
  800b8a:	89 04 24             	mov    %eax,(%esp)
  800b8d:	e8 ac f8 ff ff       	call   80043e <flush_block>
  800b92:	83 c4 10             	add    $0x10,%esp
		}
		*blk = diskaddr(*ppdiskbno);
  800b95:	83 ec 0c             	sub    $0xc,%esp
  800b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b9b:	ff 30                	pushl  (%eax)
  800b9d:	e8 12 f8 ff ff       	call   8003b4 <diskaddr>
  800ba2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ba5:	89 02                	mov    %eax,(%edx)
		return 0;
  800ba7:	83 c4 10             	add    $0x10,%esp
       //panic("file_get_block not implemented");
}
  800baa:	89 d8                	mov    %ebx,%eax
  800bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    
			if ((r = alloc_block()) < 0) return r;
  800bb3:	89 c3                	mov    %eax,%ebx
  800bb5:	eb f3                	jmp    800baa <file_get_block+0x7e>

00800bb7 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800bc3:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800bc9:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	while (*p == '/')
  800bcf:	80 38 2f             	cmpb   $0x2f,(%eax)
  800bd2:	75 05                	jne    800bd9 <walk_path+0x22>
		p++;
  800bd4:	83 c0 01             	add    $0x1,%eax
  800bd7:	eb f6                	jmp    800bcf <walk_path+0x18>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800bd9:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800bdf:	83 c1 08             	add    $0x8,%ecx
  800be2:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800be8:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800bef:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800bf5:	85 c9                	test   %ecx,%ecx
  800bf7:	74 06                	je     800bff <walk_path+0x48>
		*pdir = 0;
  800bf9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800bff:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800c05:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800c10:	e9 c5 01 00 00       	jmp    800dda <walk_path+0x223>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800c15:	83 c6 01             	add    $0x1,%esi
		while (*path != '/' && *path != '\0')
  800c18:	0f b6 16             	movzbl (%esi),%edx
  800c1b:	80 fa 2f             	cmp    $0x2f,%dl
  800c1e:	74 04                	je     800c24 <walk_path+0x6d>
  800c20:	84 d2                	test   %dl,%dl
  800c22:	75 f1                	jne    800c15 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800c24:	89 f3                	mov    %esi,%ebx
  800c26:	29 c3                	sub    %eax,%ebx
  800c28:	83 fb 7f             	cmp    $0x7f,%ebx
  800c2b:	0f 8f 71 01 00 00    	jg     800da2 <walk_path+0x1eb>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800c31:	83 ec 04             	sub    $0x4,%esp
  800c34:	53                   	push   %ebx
  800c35:	50                   	push   %eax
  800c36:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800c3c:	50                   	push   %eax
  800c3d:	e8 55 18 00 00       	call   802497 <memmove>
		name[path - p] = '\0';
  800c42:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800c49:	00 
	while (*p == '/')
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800c50:	75 05                	jne    800c57 <walk_path+0xa0>
		p++;
  800c52:	83 c6 01             	add    $0x1,%esi
  800c55:	eb f6                	jmp    800c4d <walk_path+0x96>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c57:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c5d:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c64:	0f 85 3f 01 00 00    	jne    800da9 <walk_path+0x1f2>
	assert((dir->f_size % BLKSIZE) == 0);
  800c6a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c70:	89 c1                	mov    %eax,%ecx
  800c72:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
  800c78:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
  800c7e:	0f 85 8e 00 00 00    	jne    800d12 <walk_path+0x15b>
	nblock = dir->f_size / BLKSIZE;
  800c84:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	0f 48 c2             	cmovs  %edx,%eax
  800c8f:	c1 f8 0c             	sar    $0xc,%eax
  800c92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
			if (strcmp(f[j].f_name, name) == 0) {
  800c98:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
  800c9e:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800ca4:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800caa:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800cb0:	74 79                	je     800d2b <walk_path+0x174>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800cb2:	83 ec 04             	sub    $0x4,%esp
  800cb5:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800cbb:	50                   	push   %eax
  800cbc:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800cc2:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800cc8:	e8 5f fe ff ff       	call   800b2c <file_get_block>
  800ccd:	83 c4 10             	add    $0x10,%esp
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	0f 88 d8 00 00 00    	js     800db0 <walk_path+0x1f9>
  800cd8:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800cde:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
			if (strcmp(f[j].f_name, name) == 0) {
  800ce4:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	57                   	push   %edi
  800cee:	53                   	push   %ebx
  800cef:	e8 ac 16 00 00       	call   8023a0 <strcmp>
  800cf4:	83 c4 10             	add    $0x10,%esp
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	0f 84 c1 00 00 00    	je     800dc0 <walk_path+0x209>
  800cff:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800d05:	39 f3                	cmp    %esi,%ebx
  800d07:	75 db                	jne    800ce4 <walk_path+0x12d>
	for (i = 0; i < nblock; i++) {
  800d09:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800d10:	eb 92                	jmp    800ca4 <walk_path+0xed>
	assert((dir->f_size % BLKSIZE) == 0);
  800d12:	68 83 42 80 00       	push   $0x804283
  800d17:	68 fd 3f 80 00       	push   $0x803ffd
  800d1c:	68 d0 00 00 00       	push   $0xd0
  800d21:	68 eb 41 80 00       	push   $0x8041eb
  800d26:	e8 c5 0e 00 00       	call   801bf0 <_panic>
  800d2b:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800d31:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d36:	80 3e 00             	cmpb   $0x0,(%esi)
  800d39:	75 5f                	jne    800d9a <walk_path+0x1e3>
				if (pdir)
  800d3b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d41:	85 c0                	test   %eax,%eax
  800d43:	74 08                	je     800d4d <walk_path+0x196>
					*pdir = dir;
  800d45:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d4b:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d51:	74 15                	je     800d68 <walk_path+0x1b1>
					strcpy(lastelem, name);
  800d53:	83 ec 08             	sub    $0x8,%esp
  800d56:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d5c:	50                   	push   %eax
  800d5d:	ff 75 08             	pushl  0x8(%ebp)
  800d60:	e8 7c 15 00 00       	call   8022e1 <strcpy>
  800d65:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d68:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d74:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d79:	eb 1f                	jmp    800d9a <walk_path+0x1e3>
		}
	}

	if (pdir)
  800d7b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d81:	85 c0                	test   %eax,%eax
  800d83:	74 02                	je     800d87 <walk_path+0x1d0>
		*pdir = dir;
  800d85:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d87:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d8d:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d93:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
			return -E_BAD_PATH;
  800da2:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800da7:	eb f1                	jmp    800d9a <walk_path+0x1e3>
			return -E_NOT_FOUND;
  800da9:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800dae:	eb ea                	jmp    800d9a <walk_path+0x1e3>
  800db0:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800db6:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800db9:	75 df                	jne    800d9a <walk_path+0x1e3>
  800dbb:	e9 71 ff ff ff       	jmp    800d31 <walk_path+0x17a>
  800dc0:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
  800dc6:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800dcc:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800dd2:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800dd8:	89 f0                	mov    %esi,%eax
	while (*path != '\0') {
  800dda:	80 38 00             	cmpb   $0x0,(%eax)
  800ddd:	74 9c                	je     800d7b <walk_path+0x1c4>
  800ddf:	89 c6                	mov    %eax,%esi
  800de1:	e9 32 fe ff ff       	jmp    800c18 <walk_path+0x61>

00800de6 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800df0:	6a 00                	push   $0x0
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	e8 b5 fd ff ff       	call   800bb7 <walk_path>
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800e04:	f3 0f 1e fb          	endbr32 
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 2c             	sub    $0x2c,%esp
  800e11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e17:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800e23:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800e28:	39 ca                	cmp    %ecx,%edx
  800e2a:	7e 7e                	jle    800eaa <file_read+0xa6>

	count = MIN(count, f->f_size - offset);
  800e2c:	29 ca                	sub    %ecx,%edx
  800e2e:	39 da                	cmp    %ebx,%edx
  800e30:	89 d8                	mov    %ebx,%eax
  800e32:	0f 46 c2             	cmovbe %edx,%eax
  800e35:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800e38:	89 cb                	mov    %ecx,%ebx
  800e3a:	01 c1                	add    %eax,%ecx
  800e3c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e3f:	89 de                	mov    %ebx,%esi
  800e41:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800e44:	76 61                	jbe    800ea7 <file_read+0xa3>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800e46:	83 ec 04             	sub    $0x4,%esp
  800e49:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e4c:	50                   	push   %eax
  800e4d:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800e53:	85 db                	test   %ebx,%ebx
  800e55:	0f 49 c3             	cmovns %ebx,%eax
  800e58:	c1 f8 0c             	sar    $0xc,%eax
  800e5b:	50                   	push   %eax
  800e5c:	ff 75 08             	pushl  0x8(%ebp)
  800e5f:	e8 c8 fc ff ff       	call   800b2c <file_get_block>
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	85 c0                	test   %eax,%eax
  800e69:	78 3f                	js     800eaa <file_read+0xa6>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e6b:	89 da                	mov    %ebx,%edx
  800e6d:	c1 fa 1f             	sar    $0x1f,%edx
  800e70:	c1 ea 14             	shr    $0x14,%edx
  800e73:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800e76:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e7b:	29 d0                	sub    %edx,%eax
  800e7d:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e82:	29 c2                	sub    %eax,%edx
  800e84:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e87:	29 f1                	sub    %esi,%ecx
  800e89:	89 ce                	mov    %ecx,%esi
  800e8b:	39 ca                	cmp    %ecx,%edx
  800e8d:	0f 46 f2             	cmovbe %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e90:	83 ec 04             	sub    $0x4,%esp
  800e93:	56                   	push   %esi
  800e94:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	57                   	push   %edi
  800e99:	e8 f9 15 00 00       	call   802497 <memmove>
		pos += bn;
  800e9e:	01 f3                	add    %esi,%ebx
		buf += bn;
  800ea0:	01 f7                	add    %esi,%edi
  800ea2:	83 c4 10             	add    $0x10,%esp
  800ea5:	eb 98                	jmp    800e3f <file_read+0x3b>
	}

	return count;
  800ea7:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800eb2:	f3 0f 1e fb          	endbr32 
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 2c             	sub    $0x2c,%esp
  800ebf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ec2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (f->f_size > newsize)
  800ec5:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800ecb:	39 f8                	cmp    %edi,%eax
  800ecd:	7f 1c                	jg     800eeb <file_set_size+0x39>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800ecf:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
	flush_block(f);
  800ed5:	83 ec 0c             	sub    $0xc,%esp
  800ed8:	53                   	push   %ebx
  800ed9:	e8 60 f5 ff ff       	call   80043e <flush_block>
	return 0;
}
  800ede:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800eeb:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800ef1:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ef6:	0f 48 c2             	cmovs  %edx,%eax
  800ef9:	c1 f8 0c             	sar    $0xc,%eax
  800efc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800eff:	8d 87 fe 1f 00 00    	lea    0x1ffe(%edi),%eax
  800f05:	89 fa                	mov    %edi,%edx
  800f07:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800f0d:	0f 49 c2             	cmovns %edx,%eax
  800f10:	c1 f8 0c             	sar    $0xc,%eax
  800f13:	89 45 d0             	mov    %eax,-0x30(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f16:	89 c6                	mov    %eax,%esi
  800f18:	eb 3c                	jmp    800f56 <file_set_size+0xa4>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800f1a:	83 7d d0 0a          	cmpl   $0xa,-0x30(%ebp)
  800f1e:	77 af                	ja     800ecf <file_set_size+0x1d>
  800f20:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800f26:	85 c0                	test   %eax,%eax
  800f28:	74 a5                	je     800ecf <file_set_size+0x1d>
		free_block(f->f_indirect);
  800f2a:	83 ec 0c             	sub    $0xc,%esp
  800f2d:	50                   	push   %eax
  800f2e:	e8 5f f9 ff ff       	call   800892 <free_block>
		f->f_indirect = 0;
  800f33:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
  800f3a:	00 00 00 
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	eb 8d                	jmp    800ecf <file_set_size+0x1d>
			cprintf("warning: file_free_block: %e", r);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	50                   	push   %eax
  800f46:	68 a0 42 80 00       	push   $0x8042a0
  800f4b:	e8 87 0d 00 00       	call   801cd7 <cprintf>
  800f50:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800f53:	83 c6 01             	add    $0x1,%esi
  800f56:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f59:	76 bf                	jbe    800f1a <file_set_size+0x68>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f5b:	83 ec 0c             	sub    $0xc,%esp
  800f5e:	6a 00                	push   $0x0
  800f60:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f63:	89 f2                	mov    %esi,%edx
  800f65:	89 d8                	mov    %ebx,%eax
  800f67:	e8 eb f9 ff ff       	call   800957 <file_block_walk>
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	78 cf                	js     800f42 <file_set_size+0x90>
	if (*ptr) {
  800f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f76:	8b 00                	mov    (%eax),%eax
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	74 d7                	je     800f53 <file_set_size+0xa1>
		free_block(*ptr);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	e8 0d f9 ff ff       	call   800892 <free_block>
		*ptr = 0;
  800f85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f8e:	83 c4 10             	add    $0x10,%esp
  800f91:	eb c0                	jmp    800f53 <file_set_size+0xa1>

00800f93 <file_write>:
{
  800f93:	f3 0f 1e fb          	endbr32 
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
  800f9d:	83 ec 2c             	sub    $0x2c,%esp
  800fa0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fa3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800fa6:	89 d8                	mov    %ebx,%eax
  800fa8:	03 45 10             	add    0x10(%ebp),%eax
  800fab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb1:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800fb7:	77 68                	ja     801021 <file_write+0x8e>
	for (pos = offset; pos < offset + count; ) {
  800fb9:	89 de                	mov    %ebx,%esi
  800fbb:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800fbe:	76 74                	jbe    801034 <file_write+0xa1>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800fc0:	83 ec 04             	sub    $0x4,%esp
  800fc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc6:	50                   	push   %eax
  800fc7:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800fcd:	85 db                	test   %ebx,%ebx
  800fcf:	0f 49 c3             	cmovns %ebx,%eax
  800fd2:	c1 f8 0c             	sar    $0xc,%eax
  800fd5:	50                   	push   %eax
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 4e fb ff ff       	call   800b2c <file_get_block>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	78 52                	js     801037 <file_write+0xa4>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800fe5:	89 da                	mov    %ebx,%edx
  800fe7:	c1 fa 1f             	sar    $0x1f,%edx
  800fea:	c1 ea 14             	shr    $0x14,%edx
  800fed:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800ff0:	25 ff 0f 00 00       	and    $0xfff,%eax
  800ff5:	29 d0                	sub    %edx,%eax
  800ff7:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800ffc:	29 c1                	sub    %eax,%ecx
  800ffe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801001:	29 f2                	sub    %esi,%edx
  801003:	39 d1                	cmp    %edx,%ecx
  801005:	89 d6                	mov    %edx,%esi
  801007:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	56                   	push   %esi
  80100e:	57                   	push   %edi
  80100f:	03 45 e4             	add    -0x1c(%ebp),%eax
  801012:	50                   	push   %eax
  801013:	e8 7f 14 00 00       	call   802497 <memmove>
		pos += bn;
  801018:	01 f3                	add    %esi,%ebx
		buf += bn;
  80101a:	01 f7                	add    %esi,%edi
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	eb 98                	jmp    800fb9 <file_write+0x26>
		if ((r = file_set_size(f, offset + count)) < 0)
  801021:	83 ec 08             	sub    $0x8,%esp
  801024:	50                   	push   %eax
  801025:	51                   	push   %ecx
  801026:	e8 87 fe ff ff       	call   800eb2 <file_set_size>
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	79 87                	jns    800fb9 <file_write+0x26>
  801032:	eb 03                	jmp    801037 <file_write+0xa4>
	return count;
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801037:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103a:	5b                   	pop    %ebx
  80103b:	5e                   	pop    %esi
  80103c:	5f                   	pop    %edi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  80103f:	f3 0f 1e fb          	endbr32 
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	83 ec 10             	sub    $0x10,%esp
  80104b:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	eb 03                	jmp    801058 <file_flush+0x19>
  801055:	83 c3 01             	add    $0x1,%ebx
  801058:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  80105e:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801064:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  80106a:	0f 49 c2             	cmovns %edx,%eax
  80106d:	c1 f8 0c             	sar    $0xc,%eax
  801070:	39 d8                	cmp    %ebx,%eax
  801072:	7e 3b                	jle    8010af <file_flush+0x70>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	6a 00                	push   $0x0
  801079:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  80107c:	89 da                	mov    %ebx,%edx
  80107e:	89 f0                	mov    %esi,%eax
  801080:	e8 d2 f8 ff ff       	call   800957 <file_block_walk>
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	85 c0                	test   %eax,%eax
  80108a:	78 c9                	js     801055 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  80108c:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 c2                	je     801055 <file_flush+0x16>
		    pdiskbno == NULL || *pdiskbno == 0)
  801093:	8b 00                	mov    (%eax),%eax
  801095:	85 c0                	test   %eax,%eax
  801097:	74 bc                	je     801055 <file_flush+0x16>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801099:	83 ec 0c             	sub    $0xc,%esp
  80109c:	50                   	push   %eax
  80109d:	e8 12 f3 ff ff       	call   8003b4 <diskaddr>
  8010a2:	89 04 24             	mov    %eax,(%esp)
  8010a5:	e8 94 f3 ff ff       	call   80043e <flush_block>
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	eb a6                	jmp    801055 <file_flush+0x16>
	}
	flush_block(f);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	56                   	push   %esi
  8010b3:	e8 86 f3 ff ff       	call   80043e <flush_block>
	if (f->f_indirect)
  8010b8:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 07                	jne    8010cc <file_flush+0x8d>
		flush_block(diskaddr(f->f_indirect));
}
  8010c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010c8:	5b                   	pop    %ebx
  8010c9:	5e                   	pop    %esi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  8010cc:	83 ec 0c             	sub    $0xc,%esp
  8010cf:	50                   	push   %eax
  8010d0:	e8 df f2 ff ff       	call   8003b4 <diskaddr>
  8010d5:	89 04 24             	mov    %eax,(%esp)
  8010d8:	e8 61 f3 ff ff       	call   80043e <flush_block>
  8010dd:	83 c4 10             	add    $0x10,%esp
}
  8010e0:	eb e3                	jmp    8010c5 <file_flush+0x86>

008010e2 <file_create>:
{
  8010e2:	f3 0f 1e fb          	endbr32 
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8010f2:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8010f8:	50                   	push   %eax
  8010f9:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8010ff:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	e8 aa fa ff ff       	call   800bb7 <walk_path>
  80110d:	83 c4 10             	add    $0x10,%esp
  801110:	85 c0                	test   %eax,%eax
  801112:	0f 84 0b 01 00 00    	je     801223 <file_create+0x141>
	if (r != -E_NOT_FOUND || dir == 0)
  801118:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80111b:	0f 85 ca 00 00 00    	jne    8011eb <file_create+0x109>
  801121:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  801127:	85 f6                	test   %esi,%esi
  801129:	0f 84 bc 00 00 00    	je     8011eb <file_create+0x109>
	assert((dir->f_size % BLKSIZE) == 0);
  80112f:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  801135:	89 c3                	mov    %eax,%ebx
  801137:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  80113d:	75 57                	jne    801196 <file_create+0xb4>
	nblock = dir->f_size / BLKSIZE;
  80113f:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  801145:	85 c0                	test   %eax,%eax
  801147:	0f 48 c2             	cmovs  %edx,%eax
  80114a:	c1 f8 0c             	sar    $0xc,%eax
  80114d:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801153:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  801159:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  80115f:	0f 84 8e 00 00 00    	je     8011f3 <file_create+0x111>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	57                   	push   %edi
  801169:	53                   	push   %ebx
  80116a:	56                   	push   %esi
  80116b:	e8 bc f9 ff ff       	call   800b2c <file_get_block>
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	85 c0                	test   %eax,%eax
  801175:	78 74                	js     8011eb <file_create+0x109>
  801177:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80117d:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  801183:	80 38 00             	cmpb   $0x0,(%eax)
  801186:	74 27                	je     8011af <file_create+0xcd>
  801188:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  80118d:	39 d0                	cmp    %edx,%eax
  80118f:	75 f2                	jne    801183 <file_create+0xa1>
	for (i = 0; i < nblock; i++) {
  801191:	83 c3 01             	add    $0x1,%ebx
  801194:	eb c3                	jmp    801159 <file_create+0x77>
	assert((dir->f_size % BLKSIZE) == 0);
  801196:	68 83 42 80 00       	push   $0x804283
  80119b:	68 fd 3f 80 00       	push   $0x803ffd
  8011a0:	68 e9 00 00 00       	push   $0xe9
  8011a5:	68 eb 41 80 00       	push   $0x8041eb
  8011aa:	e8 41 0a 00 00       	call   801bf0 <_panic>
				*file = &f[j];
  8011af:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8011be:	50                   	push   %eax
  8011bf:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  8011c5:	e8 17 11 00 00       	call   8022e1 <strcpy>
	*pf = f;
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8011d3:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8011d5:	83 c4 04             	add    $0x4,%esp
  8011d8:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  8011de:	e8 5c fe ff ff       	call   80103f <file_flush>
	return 0;
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    
	dir->f_size += BLKSIZE;
  8011f3:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  8011fa:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8011fd:	83 ec 04             	sub    $0x4,%esp
  801200:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801206:	50                   	push   %eax
  801207:	53                   	push   %ebx
  801208:	56                   	push   %esi
  801209:	e8 1e f9 ff ff       	call   800b2c <file_get_block>
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	78 d6                	js     8011eb <file_create+0x109>
	*file = &f[0];
  801215:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80121b:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	return 0;
  801221:	eb 92                	jmp    8011b5 <file_create+0xd3>
		return -E_FILE_EXISTS;
  801223:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801228:	eb c1                	jmp    8011eb <file_create+0x109>

0080122a <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  80122a:	f3 0f 1e fb          	endbr32 
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	53                   	push   %ebx
  801232:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801235:	bb 01 00 00 00       	mov    $0x1,%ebx
  80123a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80123f:	39 58 04             	cmp    %ebx,0x4(%eax)
  801242:	76 19                	jbe    80125d <fs_sync+0x33>
		flush_block(diskaddr(i));
  801244:	83 ec 0c             	sub    $0xc,%esp
  801247:	53                   	push   %ebx
  801248:	e8 67 f1 ff ff       	call   8003b4 <diskaddr>
  80124d:	89 04 24             	mov    %eax,(%esp)
  801250:	e8 e9 f1 ff ff       	call   80043e <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  801255:	83 c3 01             	add    $0x1,%ebx
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	eb dd                	jmp    80123a <fs_sync+0x10>
}
  80125d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801262:	f3 0f 1e fb          	endbr32 
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  80126c:	e8 b9 ff ff ff       	call   80122a <fs_sync>
	return 0;
}
  801271:	b8 00 00 00 00       	mov    $0x0,%eax
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <serve_init>:
{
  801278:	f3 0f 1e fb          	endbr32 
  80127c:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  801281:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801286:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  80128b:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  80128d:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801290:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  801296:	83 c0 01             	add    $0x1,%eax
  801299:	83 c2 10             	add    $0x10,%edx
  80129c:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012a1:	75 e8                	jne    80128b <serve_init+0x13>
}
  8012a3:	c3                   	ret    

008012a4 <openfile_alloc>:
{
  8012a4:	f3 0f 1e fb          	endbr32 
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  8012b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b9:	89 de                	mov    %ebx,%esi
  8012bb:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  8012be:	83 ec 0c             	sub    $0xc,%esp
  8012c1:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  8012c7:	e8 88 20 00 00       	call   803354 <pageref>
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	74 17                	je     8012ea <openfile_alloc+0x46>
  8012d3:	83 f8 01             	cmp    $0x1,%eax
  8012d6:	74 30                	je     801308 <openfile_alloc+0x64>
	for (i = 0; i < MAXOPEN; i++) {
  8012d8:	83 c3 01             	add    $0x1,%ebx
  8012db:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8012e1:	75 d6                	jne    8012b9 <openfile_alloc+0x15>
	return -E_MAX_OPEN;
  8012e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012e8:	eb 4f                	jmp    801339 <openfile_alloc+0x95>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8012ea:	83 ec 04             	sub    $0x4,%esp
  8012ed:	6a 07                	push   $0x7
  8012ef:	89 d8                	mov    %ebx,%eax
  8012f1:	c1 e0 04             	shl    $0x4,%eax
  8012f4:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 22 14 00 00       	call   802723 <sys_page_alloc>
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 31                	js     801339 <openfile_alloc+0x95>
			opentab[i].o_fileid += MAXOPEN;
  801308:	c1 e3 04             	shl    $0x4,%ebx
  80130b:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  801312:	04 00 00 
			*o = &opentab[i];
  801315:	81 c6 60 50 80 00    	add    $0x805060,%esi
  80131b:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80131d:	83 ec 04             	sub    $0x4,%esp
  801320:	68 00 10 00 00       	push   $0x1000
  801325:	6a 00                	push   $0x0
  801327:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  80132d:	e8 19 11 00 00       	call   80244b <memset>
			return (*o)->o_fileid;
  801332:	8b 07                	mov    (%edi),%eax
  801334:	8b 00                	mov    (%eax),%eax
  801336:	83 c4 10             	add    $0x10,%esp
}
  801339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    

00801341 <openfile_lookup>:
{
  801341:	f3 0f 1e fb          	endbr32 
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	57                   	push   %edi
  801349:	56                   	push   %esi
  80134a:	53                   	push   %ebx
  80134b:	83 ec 18             	sub    $0x18,%esp
  80134e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  801351:	89 fb                	mov    %edi,%ebx
  801353:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801359:	89 de                	mov    %ebx,%esi
  80135b:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80135e:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  801364:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80136a:	e8 e5 1f 00 00       	call   803354 <pageref>
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	83 f8 01             	cmp    $0x1,%eax
  801375:	7e 1d                	jle    801394 <openfile_lookup+0x53>
  801377:	c1 e3 04             	shl    $0x4,%ebx
  80137a:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  801380:	75 19                	jne    80139b <openfile_lookup+0x5a>
	*po = o;
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	89 30                	mov    %esi,(%eax)
	return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    
		return -E_INVAL;
  801394:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801399:	eb f1                	jmp    80138c <openfile_lookup+0x4b>
  80139b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a0:	eb ea                	jmp    80138c <openfile_lookup+0x4b>

008013a2 <serve_set_size>:
{
  8013a2:	f3 0f 1e fb          	endbr32 
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 18             	sub    $0x18,%esp
  8013ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	ff 33                	pushl  (%ebx)
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	e8 83 ff ff ff       	call   801341 <openfile_lookup>
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	78 14                	js     8013d9 <serve_set_size+0x37>
	return file_set_size(o->o_file, req->req_size);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 73 04             	pushl  0x4(%ebx)
  8013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ce:	ff 70 04             	pushl  0x4(%eax)
  8013d1:	e8 dc fa ff ff       	call   800eb2 <file_set_size>
  8013d6:	83 c4 10             	add    $0x10,%esp
}
  8013d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <serve_read>:
{
  8013de:	f3 0f 1e fb          	endbr32 
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 18             	sub    $0x18,%esp
  8013e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	ff 33                	pushl  (%ebx)
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	e8 47 ff ff ff       	call   801341 <openfile_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 25                	js     801426 <serve_read+0x48>
	if ((r = file_read(o->o_file, ret->ret_buf, ipc->read.req_n, o->o_fd->fd_offset)) < 0)
  801401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801404:	8b 50 0c             	mov    0xc(%eax),%edx
  801407:	ff 72 04             	pushl  0x4(%edx)
  80140a:	ff 73 04             	pushl  0x4(%ebx)
  80140d:	53                   	push   %ebx
  80140e:	ff 70 04             	pushl  0x4(%eax)
  801411:	e8 ee f9 ff ff       	call   800e04 <file_read>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 09                	js     801426 <serve_read+0x48>
	o->o_fd->fd_offset += r;
  80141d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801420:	8b 52 0c             	mov    0xc(%edx),%edx
  801423:	01 42 04             	add    %eax,0x4(%edx)
}
  801426:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <serve_write>:
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	53                   	push   %ebx
  801433:	83 ec 18             	sub    $0x18,%esp
  801436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 33                	pushl  (%ebx)
  80143f:	ff 75 08             	pushl  0x8(%ebp)
  801442:	e8 fa fe ff ff       	call   801341 <openfile_lookup>
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 28                	js     801476 <serve_write+0x4b>
	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  80144e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801451:	8b 50 0c             	mov    0xc(%eax),%edx
  801454:	ff 72 04             	pushl  0x4(%edx)
  801457:	ff 73 04             	pushl  0x4(%ebx)
  80145a:	83 c3 08             	add    $0x8,%ebx
  80145d:	53                   	push   %ebx
  80145e:	ff 70 04             	pushl  0x4(%eax)
  801461:	e8 2d fb ff ff       	call   800f93 <file_write>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 09                	js     801476 <serve_write+0x4b>
	o->o_fd->fd_offset += r;
  80146d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801470:	8b 52 0c             	mov    0xc(%edx),%edx
  801473:	01 42 04             	add    %eax,0x4(%edx)
}
  801476:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <serve_stat>:
{
  80147b:	f3 0f 1e fb          	endbr32 
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	53                   	push   %ebx
  801483:	83 ec 18             	sub    $0x18,%esp
  801486:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148c:	50                   	push   %eax
  80148d:	ff 33                	pushl  (%ebx)
  80148f:	ff 75 08             	pushl  0x8(%ebp)
  801492:	e8 aa fe ff ff       	call   801341 <openfile_lookup>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 3f                	js     8014dd <serve_stat+0x62>
	strcpy(ret->ret_name, o->o_file->f_name);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a4:	ff 70 04             	pushl  0x4(%eax)
  8014a7:	53                   	push   %ebx
  8014a8:	e8 34 0e 00 00       	call   8022e1 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	8b 50 04             	mov    0x4(%eax),%edx
  8014b3:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8014b9:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8014bf:	8b 40 04             	mov    0x4(%eax),%eax
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8014cc:	0f 94 c0             	sete   %al
  8014cf:	0f b6 c0             	movzbl %al,%eax
  8014d2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <serve_flush>:
{
  8014e2:	f3 0f 1e fb          	endbr32 
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ef:	50                   	push   %eax
  8014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f3:	ff 30                	pushl  (%eax)
  8014f5:	ff 75 08             	pushl  0x8(%ebp)
  8014f8:	e8 44 fe ff ff       	call   801341 <openfile_lookup>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	78 16                	js     80151a <serve_flush+0x38>
	file_flush(o->o_file);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	ff 70 04             	pushl  0x4(%eax)
  80150d:	e8 2d fb ff ff       	call   80103f <file_flush>
	return 0;
  801512:	83 c4 10             	add    $0x10,%esp
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <serve_open>:
{
  80151c:	f3 0f 1e fb          	endbr32 
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	53                   	push   %ebx
  801524:	81 ec 18 04 00 00    	sub    $0x418,%esp
  80152a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  80152d:	68 00 04 00 00       	push   $0x400
  801532:	53                   	push   %ebx
  801533:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	e8 58 0f 00 00       	call   802497 <memmove>
	path[MAXPATHLEN-1] = 0;
  80153f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  801543:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801549:	89 04 24             	mov    %eax,(%esp)
  80154c:	e8 53 fd ff ff       	call   8012a4 <openfile_alloc>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	0f 88 f0 00 00 00    	js     80164c <serve_open+0x130>
	if (req->req_omode & O_CREAT) {
  80155c:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  801563:	74 33                	je     801598 <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  801565:	83 ec 08             	sub    $0x8,%esp
  801568:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80156e:	50                   	push   %eax
  80156f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801575:	50                   	push   %eax
  801576:	e8 67 fb ff ff       	call   8010e2 <file_create>
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	79 37                	jns    8015b9 <serve_open+0x9d>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801582:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801589:	0f 85 bd 00 00 00    	jne    80164c <serve_open+0x130>
  80158f:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801592:	0f 85 b4 00 00 00    	jne    80164c <serve_open+0x130>
		if ((r = file_open(path, &f)) < 0) {
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	e8 38 f8 ff ff       	call   800de6 <file_open>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	0f 88 93 00 00 00    	js     80164c <serve_open+0x130>
	if (req->req_omode & O_TRUNC) {
  8015b9:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015c0:	74 17                	je     8015d9 <serve_open+0xbd>
		if ((r = file_set_size(f, 0)) < 0) {
  8015c2:	83 ec 08             	sub    $0x8,%esp
  8015c5:	6a 00                	push   $0x0
  8015c7:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  8015cd:	e8 e0 f8 ff ff       	call   800eb2 <file_set_size>
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 73                	js     80164c <serve_open+0x130>
	if ((r = file_open(path, &f)) < 0) {
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8015e2:	50                   	push   %eax
  8015e3:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8015e9:	50                   	push   %eax
  8015ea:	e8 f7 f7 ff ff       	call   800de6 <file_open>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 56                	js     80164c <serve_open+0x130>
	o->o_file = f;
  8015f6:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015fc:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801602:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801605:	8b 50 0c             	mov    0xc(%eax),%edx
  801608:	8b 08                	mov    (%eax),%ecx
  80160a:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80160d:	8b 48 0c             	mov    0xc(%eax),%ecx
  801610:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801616:	83 e2 03             	and    $0x3,%edx
  801619:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  80161c:	8b 40 0c             	mov    0xc(%eax),%eax
  80161f:	8b 15 64 90 80 00    	mov    0x809064,%edx
  801625:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801627:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80162d:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801633:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  801636:	8b 50 0c             	mov    0xc(%eax),%edx
  801639:	8b 45 10             	mov    0x10(%ebp),%eax
  80163c:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  80163e:	8b 45 14             	mov    0x14(%ebp),%eax
  801641:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80165d:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  801660:	8d 75 f4             	lea    -0xc(%ebp),%esi
  801663:	e9 82 00 00 00       	jmp    8016ea <serve+0x99>
			cprintf("Invalid request from %08x: no argument page\n",
				whom);
			continue; // just leave it hanging...
		}

		pg = NULL;
  801668:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  80166f:	83 f8 01             	cmp    $0x1,%eax
  801672:	74 23                	je     801697 <serve+0x46>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  801674:	83 f8 08             	cmp    $0x8,%eax
  801677:	77 36                	ja     8016af <serve+0x5e>
  801679:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801680:	85 d2                	test   %edx,%edx
  801682:	74 2b                	je     8016af <serve+0x5e>
			r = handlers[req](whom, fsreq);
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	ff 35 44 50 80 00    	pushl  0x805044
  80168d:	ff 75 f4             	pushl  -0xc(%ebp)
  801690:	ff d2                	call   *%edx
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	eb 31                	jmp    8016c8 <serve+0x77>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  801697:	53                   	push   %ebx
  801698:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	ff 35 44 50 80 00    	pushl  0x805044
  8016a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a5:	e8 72 fe ff ff       	call   80151c <serve_open>
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	eb 19                	jmp    8016c8 <serve+0x77>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b5:	50                   	push   %eax
  8016b6:	68 f0 42 80 00       	push   $0x8042f0
  8016bb:	e8 17 06 00 00       	call   801cd7 <cprintf>
  8016c0:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8016c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8016c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d2:	e8 99 13 00 00       	call   802a70 <ipc_send>
		sys_page_unmap(0, fsreq);
  8016d7:	83 c4 08             	add    $0x8,%esp
  8016da:	ff 35 44 50 80 00    	pushl  0x805044
  8016e0:	6a 00                	push   $0x0
  8016e2:	e8 c9 10 00 00       	call   8027b0 <sys_page_unmap>
  8016e7:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  8016ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	53                   	push   %ebx
  8016f5:	ff 35 44 50 80 00    	pushl  0x805044
  8016fb:	56                   	push   %esi
  8016fc:	e8 fb 12 00 00       	call   8029fc <ipc_recv>
		if (!(perm & PTE_P)) {
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801708:	0f 85 5a ff ff ff    	jne    801668 <serve+0x17>
			cprintf("Invalid request from %08x: no argument page\n",
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	ff 75 f4             	pushl  -0xc(%ebp)
  801714:	68 c0 42 80 00       	push   $0x8042c0
  801719:	e8 b9 05 00 00       	call   801cd7 <cprintf>
			continue; // just leave it hanging...
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	eb c7                	jmp    8016ea <serve+0x99>

00801723 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801723:	f3 0f 1e fb          	endbr32 
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80172d:	c7 05 60 90 80 00 13 	movl   $0x804313,0x809060
  801734:	43 80 00 
	cprintf("FS is running\n");
  801737:	68 16 43 80 00       	push   $0x804316
  80173c:	e8 96 05 00 00       	call   801cd7 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801741:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801746:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  80174b:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  80174d:	c7 04 24 25 43 80 00 	movl   $0x804325,(%esp)
  801754:	e8 7e 05 00 00       	call   801cd7 <cprintf>

	serve_init();
  801759:	e8 1a fb ff ff       	call   801278 <serve_init>
	fs_init();
  80175e:	e8 66 f3 ff ff       	call   800ac9 <fs_init>
	serve();
  801763:	e8 e9 fe ff ff       	call   801651 <serve>

00801768 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	53                   	push   %ebx
  801770:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801773:	6a 07                	push   $0x7
  801775:	68 00 10 00 00       	push   $0x1000
  80177a:	6a 00                	push   $0x0
  80177c:	e8 a2 0f 00 00       	call   802723 <sys_page_alloc>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	85 c0                	test   %eax,%eax
  801786:	0f 88 68 02 00 00    	js     8019f4 <fs_test+0x28c>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 00 10 00 00       	push   $0x1000
  801794:	ff 35 08 a0 80 00    	pushl  0x80a008
  80179a:	68 00 10 00 00       	push   $0x1000
  80179f:	e8 f3 0c 00 00       	call   802497 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017a4:	e8 29 f1 ff ff       	call   8008d2 <alloc_block>
  8017a9:	83 c4 10             	add    $0x10,%esp
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	0f 88 52 02 00 00    	js     801a06 <fs_test+0x29e>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8017b4:	8d 50 1f             	lea    0x1f(%eax),%edx
  8017b7:	0f 49 d0             	cmovns %eax,%edx
  8017ba:	c1 fa 05             	sar    $0x5,%edx
  8017bd:	89 c3                	mov    %eax,%ebx
  8017bf:	c1 fb 1f             	sar    $0x1f,%ebx
  8017c2:	c1 eb 1b             	shr    $0x1b,%ebx
  8017c5:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  8017c8:	83 e1 1f             	and    $0x1f,%ecx
  8017cb:	29 d9                	sub    %ebx,%ecx
  8017cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d2:	d3 e0                	shl    %cl,%eax
  8017d4:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  8017db:	0f 84 37 02 00 00    	je     801a18 <fs_test+0x2b0>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8017e1:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  8017e7:	85 04 91             	test   %eax,(%ecx,%edx,4)
  8017ea:	0f 85 3e 02 00 00    	jne    801a2e <fs_test+0x2c6>
	cprintf("alloc_block is good\n");
  8017f0:	83 ec 0c             	sub    $0xc,%esp
  8017f3:	68 7c 43 80 00       	push   $0x80437c
  8017f8:	e8 da 04 00 00       	call   801cd7 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8017fd:	83 c4 08             	add    $0x8,%esp
  801800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	68 91 43 80 00       	push   $0x804391
  801809:	e8 d8 f5 ff ff       	call   800de6 <file_open>
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801814:	74 08                	je     80181e <fs_test+0xb6>
  801816:	85 c0                	test   %eax,%eax
  801818:	0f 88 26 02 00 00    	js     801a44 <fs_test+0x2dc>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  80181e:	85 c0                	test   %eax,%eax
  801820:	0f 84 30 02 00 00    	je     801a56 <fs_test+0x2ee>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	50                   	push   %eax
  80182d:	68 b5 43 80 00       	push   $0x8043b5
  801832:	e8 af f5 ff ff       	call   800de6 <file_open>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	0f 88 28 02 00 00    	js     801a6a <fs_test+0x302>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  801842:	83 ec 0c             	sub    $0xc,%esp
  801845:	68 d5 43 80 00       	push   $0x8043d5
  80184a:	e8 88 04 00 00       	call   801cd7 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80184f:	83 c4 0c             	add    $0xc,%esp
  801852:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801855:	50                   	push   %eax
  801856:	6a 00                	push   $0x0
  801858:	ff 75 f4             	pushl  -0xc(%ebp)
  80185b:	e8 cc f2 ff ff       	call   800b2c <file_get_block>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	0f 88 11 02 00 00    	js     801a7c <fs_test+0x314>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	68 1c 45 80 00       	push   $0x80451c
  801873:	ff 75 f0             	pushl  -0x10(%ebp)
  801876:	e8 25 0b 00 00       	call   8023a0 <strcmp>
  80187b:	83 c4 10             	add    $0x10,%esp
  80187e:	85 c0                	test   %eax,%eax
  801880:	0f 85 08 02 00 00    	jne    801a8e <fs_test+0x326>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	68 fb 43 80 00       	push   $0x8043fb
  80188e:	e8 44 04 00 00       	call   801cd7 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	0f b6 10             	movzbl (%eax),%edx
  801899:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	c1 e8 0c             	shr    $0xc,%eax
  8018a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	a8 40                	test   $0x40,%al
  8018ad:	0f 84 ef 01 00 00    	je     801aa2 <fs_test+0x33a>
	file_flush(f);
  8018b3:	83 ec 0c             	sub    $0xc,%esp
  8018b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b9:	e8 81 f7 ff ff       	call   80103f <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	c1 e8 0c             	shr    $0xc,%eax
  8018c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	a8 40                	test   $0x40,%al
  8018d0:	0f 85 e2 01 00 00    	jne    801ab8 <fs_test+0x350>
	cprintf("file_flush is good\n");
  8018d6:	83 ec 0c             	sub    $0xc,%esp
  8018d9:	68 2f 44 80 00       	push   $0x80442f
  8018de:	e8 f4 03 00 00       	call   801cd7 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8018e3:	83 c4 08             	add    $0x8,%esp
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018eb:	e8 c2 f5 ff ff       	call   800eb2 <file_set_size>
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	0f 88 d3 01 00 00    	js     801ace <fs_test+0x366>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801905:	0f 85 d5 01 00 00    	jne    801ae0 <fs_test+0x378>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80190b:	c1 e8 0c             	shr    $0xc,%eax
  80190e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801915:	a8 40                	test   $0x40,%al
  801917:	0f 85 d9 01 00 00    	jne    801af6 <fs_test+0x38e>
	cprintf("file_truncate is good\n");
  80191d:	83 ec 0c             	sub    $0xc,%esp
  801920:	68 83 44 80 00       	push   $0x804483
  801925:	e8 ad 03 00 00       	call   801cd7 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80192a:	c7 04 24 1c 45 80 00 	movl   $0x80451c,(%esp)
  801931:	e8 68 09 00 00       	call   80229e <strlen>
  801936:	83 c4 08             	add    $0x8,%esp
  801939:	50                   	push   %eax
  80193a:	ff 75 f4             	pushl  -0xc(%ebp)
  80193d:	e8 70 f5 ff ff       	call   800eb2 <file_set_size>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	0f 88 bf 01 00 00    	js     801b0c <fs_test+0x3a4>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	89 c2                	mov    %eax,%edx
  801952:	c1 ea 0c             	shr    $0xc,%edx
  801955:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80195c:	f6 c2 40             	test   $0x40,%dl
  80195f:	0f 85 b9 01 00 00    	jne    801b1e <fs_test+0x3b6>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80196b:	52                   	push   %edx
  80196c:	6a 00                	push   $0x0
  80196e:	50                   	push   %eax
  80196f:	e8 b8 f1 ff ff       	call   800b2c <file_get_block>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	0f 88 b5 01 00 00    	js     801b34 <fs_test+0x3cc>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  80197f:	83 ec 08             	sub    $0x8,%esp
  801982:	68 1c 45 80 00       	push   $0x80451c
  801987:	ff 75 f0             	pushl  -0x10(%ebp)
  80198a:	e8 52 09 00 00       	call   8022e1 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801992:	c1 e8 0c             	shr    $0xc,%eax
  801995:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	a8 40                	test   $0x40,%al
  8019a1:	0f 84 9f 01 00 00    	je     801b46 <fs_test+0x3de>
	file_flush(f);
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ad:	e8 8d f6 ff ff       	call   80103f <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8019b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b5:	c1 e8 0c             	shr    $0xc,%eax
  8019b8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	a8 40                	test   $0x40,%al
  8019c4:	0f 85 92 01 00 00    	jne    801b5c <fs_test+0x3f4>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8019ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cd:	c1 e8 0c             	shr    $0xc,%eax
  8019d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d7:	a8 40                	test   $0x40,%al
  8019d9:	0f 85 93 01 00 00    	jne    801b72 <fs_test+0x40a>
	cprintf("file rewrite is good\n");
  8019df:	83 ec 0c             	sub    $0xc,%esp
  8019e2:	68 c3 44 80 00       	push   $0x8044c3
  8019e7:	e8 eb 02 00 00       	call   801cd7 <cprintf>
}
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  8019f4:	50                   	push   %eax
  8019f5:	68 34 43 80 00       	push   $0x804334
  8019fa:	6a 12                	push   $0x12
  8019fc:	68 47 43 80 00       	push   $0x804347
  801a01:	e8 ea 01 00 00       	call   801bf0 <_panic>
		panic("alloc_block: %e", r);
  801a06:	50                   	push   %eax
  801a07:	68 51 43 80 00       	push   $0x804351
  801a0c:	6a 17                	push   $0x17
  801a0e:	68 47 43 80 00       	push   $0x804347
  801a13:	e8 d8 01 00 00       	call   801bf0 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801a18:	68 61 43 80 00       	push   $0x804361
  801a1d:	68 fd 3f 80 00       	push   $0x803ffd
  801a22:	6a 19                	push   $0x19
  801a24:	68 47 43 80 00       	push   $0x804347
  801a29:	e8 c2 01 00 00       	call   801bf0 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801a2e:	68 dc 44 80 00       	push   $0x8044dc
  801a33:	68 fd 3f 80 00       	push   $0x803ffd
  801a38:	6a 1b                	push   $0x1b
  801a3a:	68 47 43 80 00       	push   $0x804347
  801a3f:	e8 ac 01 00 00       	call   801bf0 <_panic>
		panic("file_open /not-found: %e", r);
  801a44:	50                   	push   %eax
  801a45:	68 9c 43 80 00       	push   $0x80439c
  801a4a:	6a 1f                	push   $0x1f
  801a4c:	68 47 43 80 00       	push   $0x804347
  801a51:	e8 9a 01 00 00       	call   801bf0 <_panic>
		panic("file_open /not-found succeeded!");
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 fc 44 80 00       	push   $0x8044fc
  801a5e:	6a 21                	push   $0x21
  801a60:	68 47 43 80 00       	push   $0x804347
  801a65:	e8 86 01 00 00       	call   801bf0 <_panic>
		panic("file_open /newmotd: %e", r);
  801a6a:	50                   	push   %eax
  801a6b:	68 be 43 80 00       	push   $0x8043be
  801a70:	6a 23                	push   $0x23
  801a72:	68 47 43 80 00       	push   $0x804347
  801a77:	e8 74 01 00 00       	call   801bf0 <_panic>
		panic("file_get_block: %e", r);
  801a7c:	50                   	push   %eax
  801a7d:	68 e8 43 80 00       	push   $0x8043e8
  801a82:	6a 27                	push   $0x27
  801a84:	68 47 43 80 00       	push   $0x804347
  801a89:	e8 62 01 00 00       	call   801bf0 <_panic>
		panic("file_get_block returned wrong data");
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	68 44 45 80 00       	push   $0x804544
  801a96:	6a 29                	push   $0x29
  801a98:	68 47 43 80 00       	push   $0x804347
  801a9d:	e8 4e 01 00 00       	call   801bf0 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801aa2:	68 14 44 80 00       	push   $0x804414
  801aa7:	68 fd 3f 80 00       	push   $0x803ffd
  801aac:	6a 2d                	push   $0x2d
  801aae:	68 47 43 80 00       	push   $0x804347
  801ab3:	e8 38 01 00 00       	call   801bf0 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801ab8:	68 13 44 80 00       	push   $0x804413
  801abd:	68 fd 3f 80 00       	push   $0x803ffd
  801ac2:	6a 2f                	push   $0x2f
  801ac4:	68 47 43 80 00       	push   $0x804347
  801ac9:	e8 22 01 00 00       	call   801bf0 <_panic>
		panic("file_set_size: %e", r);
  801ace:	50                   	push   %eax
  801acf:	68 43 44 80 00       	push   $0x804443
  801ad4:	6a 33                	push   $0x33
  801ad6:	68 47 43 80 00       	push   $0x804347
  801adb:	e8 10 01 00 00       	call   801bf0 <_panic>
	assert(f->f_direct[0] == 0);
  801ae0:	68 55 44 80 00       	push   $0x804455
  801ae5:	68 fd 3f 80 00       	push   $0x803ffd
  801aea:	6a 34                	push   $0x34
  801aec:	68 47 43 80 00       	push   $0x804347
  801af1:	e8 fa 00 00 00       	call   801bf0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801af6:	68 69 44 80 00       	push   $0x804469
  801afb:	68 fd 3f 80 00       	push   $0x803ffd
  801b00:	6a 35                	push   $0x35
  801b02:	68 47 43 80 00       	push   $0x804347
  801b07:	e8 e4 00 00 00       	call   801bf0 <_panic>
		panic("file_set_size 2: %e", r);
  801b0c:	50                   	push   %eax
  801b0d:	68 9a 44 80 00       	push   $0x80449a
  801b12:	6a 39                	push   $0x39
  801b14:	68 47 43 80 00       	push   $0x804347
  801b19:	e8 d2 00 00 00       	call   801bf0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b1e:	68 69 44 80 00       	push   $0x804469
  801b23:	68 fd 3f 80 00       	push   $0x803ffd
  801b28:	6a 3a                	push   $0x3a
  801b2a:	68 47 43 80 00       	push   $0x804347
  801b2f:	e8 bc 00 00 00       	call   801bf0 <_panic>
		panic("file_get_block 2: %e", r);
  801b34:	50                   	push   %eax
  801b35:	68 ae 44 80 00       	push   $0x8044ae
  801b3a:	6a 3c                	push   $0x3c
  801b3c:	68 47 43 80 00       	push   $0x804347
  801b41:	e8 aa 00 00 00       	call   801bf0 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801b46:	68 14 44 80 00       	push   $0x804414
  801b4b:	68 fd 3f 80 00       	push   $0x803ffd
  801b50:	6a 3e                	push   $0x3e
  801b52:	68 47 43 80 00       	push   $0x804347
  801b57:	e8 94 00 00 00       	call   801bf0 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b5c:	68 13 44 80 00       	push   $0x804413
  801b61:	68 fd 3f 80 00       	push   $0x803ffd
  801b66:	6a 40                	push   $0x40
  801b68:	68 47 43 80 00       	push   $0x804347
  801b6d:	e8 7e 00 00 00       	call   801bf0 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801b72:	68 69 44 80 00       	push   $0x804469
  801b77:	68 fd 3f 80 00       	push   $0x803ffd
  801b7c:	6a 41                	push   $0x41
  801b7e:	68 47 43 80 00       	push   $0x804347
  801b83:	e8 68 00 00 00       	call   801bf0 <_panic>

00801b88 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801b88:	f3 0f 1e fb          	endbr32 
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	56                   	push   %esi
  801b90:	53                   	push   %ebx
  801b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b94:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b97:	e8 41 0b 00 00       	call   8026dd <sys_getenvid>
  801b9c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801ba1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ba4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801ba9:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801bae:	85 db                	test   %ebx,%ebx
  801bb0:	7e 07                	jle    801bb9 <libmain+0x31>
		binaryname = argv[0];
  801bb2:	8b 06                	mov    (%esi),%eax
  801bb4:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
  801bbe:	e8 60 fb ff ff       	call   801723 <umain>

	// exit gracefully
	exit();
  801bc3:	e8 0a 00 00 00       	call   801bd2 <exit>
}
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5d                   	pop    %ebp
  801bd1:	c3                   	ret    

00801bd2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801bd2:	f3 0f 1e fb          	endbr32 
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801bdc:	e8 18 11 00 00       	call   802cf9 <close_all>
	sys_env_destroy(0);
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	6a 00                	push   $0x0
  801be6:	e8 ad 0a 00 00       	call   802698 <sys_env_destroy>
}
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801bf0:	f3 0f 1e fb          	endbr32 
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801bf9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801bfc:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801c02:	e8 d6 0a 00 00       	call   8026dd <sys_getenvid>
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	56                   	push   %esi
  801c11:	50                   	push   %eax
  801c12:	68 74 45 80 00       	push   $0x804574
  801c17:	e8 bb 00 00 00       	call   801cd7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c1c:	83 c4 18             	add    $0x18,%esp
  801c1f:	53                   	push   %ebx
  801c20:	ff 75 10             	pushl  0x10(%ebp)
  801c23:	e8 5a 00 00 00       	call   801c82 <vcprintf>
	cprintf("\n");
  801c28:	c7 04 24 82 41 80 00 	movl   $0x804182,(%esp)
  801c2f:	e8 a3 00 00 00       	call   801cd7 <cprintf>
  801c34:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c37:	cc                   	int3   
  801c38:	eb fd                	jmp    801c37 <_panic+0x47>

00801c3a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c3a:	f3 0f 1e fb          	endbr32 
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c48:	8b 13                	mov    (%ebx),%edx
  801c4a:	8d 42 01             	lea    0x1(%edx),%eax
  801c4d:	89 03                	mov    %eax,(%ebx)
  801c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c52:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c56:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c5b:	74 09                	je     801c66 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801c5d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801c61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801c66:	83 ec 08             	sub    $0x8,%esp
  801c69:	68 ff 00 00 00       	push   $0xff
  801c6e:	8d 43 08             	lea    0x8(%ebx),%eax
  801c71:	50                   	push   %eax
  801c72:	e8 dc 09 00 00       	call   802653 <sys_cputs>
		b->idx = 0;
  801c77:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	eb db                	jmp    801c5d <putch+0x23>

00801c82 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c82:	f3 0f 1e fb          	endbr32 
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c96:	00 00 00 
	b.cnt = 0;
  801c99:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801ca0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801ca3:	ff 75 0c             	pushl  0xc(%ebp)
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801caf:	50                   	push   %eax
  801cb0:	68 3a 1c 80 00       	push   $0x801c3a
  801cb5:	e8 20 01 00 00       	call   801dda <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801cba:	83 c4 08             	add    $0x8,%esp
  801cbd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801cc3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cc9:	50                   	push   %eax
  801cca:	e8 84 09 00 00       	call   802653 <sys_cputs>

	return b.cnt;
}
  801ccf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801cd7:	f3 0f 1e fb          	endbr32 
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ce1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801ce4:	50                   	push   %eax
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	e8 95 ff ff ff       	call   801c82 <vcprintf>
	va_end(ap);

	return cnt;
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	57                   	push   %edi
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 1c             	sub    $0x1c,%esp
  801cf8:	89 c7                	mov    %eax,%edi
  801cfa:	89 d6                	mov    %edx,%esi
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	89 d1                	mov    %edx,%ecx
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d09:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d12:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d1c:	39 c2                	cmp    %eax,%edx
  801d1e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801d21:	72 3e                	jb     801d61 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d23:	83 ec 0c             	sub    $0xc,%esp
  801d26:	ff 75 18             	pushl  0x18(%ebp)
  801d29:	83 eb 01             	sub    $0x1,%ebx
  801d2c:	53                   	push   %ebx
  801d2d:	50                   	push   %eax
  801d2e:	83 ec 08             	sub    $0x8,%esp
  801d31:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d34:	ff 75 e0             	pushl  -0x20(%ebp)
  801d37:	ff 75 dc             	pushl  -0x24(%ebp)
  801d3a:	ff 75 d8             	pushl  -0x28(%ebp)
  801d3d:	e8 0e 20 00 00       	call   803d50 <__udivdi3>
  801d42:	83 c4 18             	add    $0x18,%esp
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	89 f2                	mov    %esi,%edx
  801d49:	89 f8                	mov    %edi,%eax
  801d4b:	e8 9f ff ff ff       	call   801cef <printnum>
  801d50:	83 c4 20             	add    $0x20,%esp
  801d53:	eb 13                	jmp    801d68 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	56                   	push   %esi
  801d59:	ff 75 18             	pushl  0x18(%ebp)
  801d5c:	ff d7                	call   *%edi
  801d5e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801d61:	83 eb 01             	sub    $0x1,%ebx
  801d64:	85 db                	test   %ebx,%ebx
  801d66:	7f ed                	jg     801d55 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	56                   	push   %esi
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d72:	ff 75 e0             	pushl  -0x20(%ebp)
  801d75:	ff 75 dc             	pushl  -0x24(%ebp)
  801d78:	ff 75 d8             	pushl  -0x28(%ebp)
  801d7b:	e8 e0 20 00 00       	call   803e60 <__umoddi3>
  801d80:	83 c4 14             	add    $0x14,%esp
  801d83:	0f be 80 97 45 80 00 	movsbl 0x804597(%eax),%eax
  801d8a:	50                   	push   %eax
  801d8b:	ff d7                	call   *%edi
}
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801d98:	f3 0f 1e fb          	endbr32 
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801da2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801da6:	8b 10                	mov    (%eax),%edx
  801da8:	3b 50 04             	cmp    0x4(%eax),%edx
  801dab:	73 0a                	jae    801db7 <sprintputch+0x1f>
		*b->buf++ = ch;
  801dad:	8d 4a 01             	lea    0x1(%edx),%ecx
  801db0:	89 08                	mov    %ecx,(%eax)
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	88 02                	mov    %al,(%edx)
}
  801db7:	5d                   	pop    %ebp
  801db8:	c3                   	ret    

00801db9 <printfmt>:
{
  801db9:	f3 0f 1e fb          	endbr32 
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801dc3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801dc6:	50                   	push   %eax
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	e8 05 00 00 00       	call   801dda <vprintfmt>
}
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <vprintfmt>:
{
  801dda:	f3 0f 1e fb          	endbr32 
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	57                   	push   %edi
  801de2:	56                   	push   %esi
  801de3:	53                   	push   %ebx
  801de4:	83 ec 3c             	sub    $0x3c,%esp
  801de7:	8b 75 08             	mov    0x8(%ebp),%esi
  801dea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ded:	8b 7d 10             	mov    0x10(%ebp),%edi
  801df0:	e9 8e 03 00 00       	jmp    802183 <vprintfmt+0x3a9>
		padc = ' ';
  801df5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801df9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801e00:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801e07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801e0e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e13:	8d 47 01             	lea    0x1(%edi),%eax
  801e16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e19:	0f b6 17             	movzbl (%edi),%edx
  801e1c:	8d 42 dd             	lea    -0x23(%edx),%eax
  801e1f:	3c 55                	cmp    $0x55,%al
  801e21:	0f 87 df 03 00 00    	ja     802206 <vprintfmt+0x42c>
  801e27:	0f b6 c0             	movzbl %al,%eax
  801e2a:	3e ff 24 85 e0 46 80 	notrack jmp *0x8046e0(,%eax,4)
  801e31:	00 
  801e32:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801e35:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801e39:	eb d8                	jmp    801e13 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801e3b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801e3e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801e42:	eb cf                	jmp    801e13 <vprintfmt+0x39>
  801e44:	0f b6 d2             	movzbl %dl,%edx
  801e47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801e52:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801e55:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801e59:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801e5c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801e5f:	83 f9 09             	cmp    $0x9,%ecx
  801e62:	77 55                	ja     801eb9 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801e64:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801e67:	eb e9                	jmp    801e52 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801e69:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e71:	8b 45 14             	mov    0x14(%ebp),%eax
  801e74:	8d 40 04             	lea    0x4(%eax),%eax
  801e77:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801e7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801e7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e81:	79 90                	jns    801e13 <vprintfmt+0x39>
				width = precision, precision = -1;
  801e83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801e90:	eb 81                	jmp    801e13 <vprintfmt+0x39>
  801e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e95:	85 c0                	test   %eax,%eax
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	0f 49 d0             	cmovns %eax,%edx
  801e9f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801ea2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ea5:	e9 69 ff ff ff       	jmp    801e13 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801eaa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801ead:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801eb4:	e9 5a ff ff ff       	jmp    801e13 <vprintfmt+0x39>
  801eb9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801ebc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ebf:	eb bc                	jmp    801e7d <vprintfmt+0xa3>
			lflag++;
  801ec1:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801ec4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ec7:	e9 47 ff ff ff       	jmp    801e13 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecf:	8d 78 04             	lea    0x4(%eax),%edi
  801ed2:	83 ec 08             	sub    $0x8,%esp
  801ed5:	53                   	push   %ebx
  801ed6:	ff 30                	pushl  (%eax)
  801ed8:	ff d6                	call   *%esi
			break;
  801eda:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801edd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801ee0:	e9 9b 02 00 00       	jmp    802180 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee8:	8d 78 04             	lea    0x4(%eax),%edi
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	99                   	cltd   
  801eee:	31 d0                	xor    %edx,%eax
  801ef0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801ef2:	83 f8 0f             	cmp    $0xf,%eax
  801ef5:	7f 23                	jg     801f1a <vprintfmt+0x140>
  801ef7:	8b 14 85 40 48 80 00 	mov    0x804840(,%eax,4),%edx
  801efe:	85 d2                	test   %edx,%edx
  801f00:	74 18                	je     801f1a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801f02:	52                   	push   %edx
  801f03:	68 0f 40 80 00       	push   $0x80400f
  801f08:	53                   	push   %ebx
  801f09:	56                   	push   %esi
  801f0a:	e8 aa fe ff ff       	call   801db9 <printfmt>
  801f0f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f12:	89 7d 14             	mov    %edi,0x14(%ebp)
  801f15:	e9 66 02 00 00       	jmp    802180 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801f1a:	50                   	push   %eax
  801f1b:	68 af 45 80 00       	push   $0x8045af
  801f20:	53                   	push   %ebx
  801f21:	56                   	push   %esi
  801f22:	e8 92 fe ff ff       	call   801db9 <printfmt>
  801f27:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801f2a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801f2d:	e9 4e 02 00 00       	jmp    802180 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801f32:	8b 45 14             	mov    0x14(%ebp),%eax
  801f35:	83 c0 04             	add    $0x4,%eax
  801f38:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801f40:	85 d2                	test   %edx,%edx
  801f42:	b8 a8 45 80 00       	mov    $0x8045a8,%eax
  801f47:	0f 45 c2             	cmovne %edx,%eax
  801f4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801f4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f51:	7e 06                	jle    801f59 <vprintfmt+0x17f>
  801f53:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801f57:	75 0d                	jne    801f66 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f5c:	89 c7                	mov    %eax,%edi
  801f5e:	03 45 e0             	add    -0x20(%ebp),%eax
  801f61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f64:	eb 55                	jmp    801fbb <vprintfmt+0x1e1>
  801f66:	83 ec 08             	sub    $0x8,%esp
  801f69:	ff 75 d8             	pushl  -0x28(%ebp)
  801f6c:	ff 75 cc             	pushl  -0x34(%ebp)
  801f6f:	e8 46 03 00 00       	call   8022ba <strnlen>
  801f74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f77:	29 c2                	sub    %eax,%edx
  801f79:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801f81:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801f85:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801f88:	85 ff                	test   %edi,%edi
  801f8a:	7e 11                	jle    801f9d <vprintfmt+0x1c3>
					putch(padc, putdat);
  801f8c:	83 ec 08             	sub    $0x8,%esp
  801f8f:	53                   	push   %ebx
  801f90:	ff 75 e0             	pushl  -0x20(%ebp)
  801f93:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801f95:	83 ef 01             	sub    $0x1,%edi
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	eb eb                	jmp    801f88 <vprintfmt+0x1ae>
  801f9d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801fa0:	85 d2                	test   %edx,%edx
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	0f 49 c2             	cmovns %edx,%eax
  801faa:	29 c2                	sub    %eax,%edx
  801fac:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801faf:	eb a8                	jmp    801f59 <vprintfmt+0x17f>
					putch(ch, putdat);
  801fb1:	83 ec 08             	sub    $0x8,%esp
  801fb4:	53                   	push   %ebx
  801fb5:	52                   	push   %edx
  801fb6:	ff d6                	call   *%esi
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fbe:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fc0:	83 c7 01             	add    $0x1,%edi
  801fc3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fc7:	0f be d0             	movsbl %al,%edx
  801fca:	85 d2                	test   %edx,%edx
  801fcc:	74 4b                	je     802019 <vprintfmt+0x23f>
  801fce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801fd2:	78 06                	js     801fda <vprintfmt+0x200>
  801fd4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801fd8:	78 1e                	js     801ff8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801fda:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801fde:	74 d1                	je     801fb1 <vprintfmt+0x1d7>
  801fe0:	0f be c0             	movsbl %al,%eax
  801fe3:	83 e8 20             	sub    $0x20,%eax
  801fe6:	83 f8 5e             	cmp    $0x5e,%eax
  801fe9:	76 c6                	jbe    801fb1 <vprintfmt+0x1d7>
					putch('?', putdat);
  801feb:	83 ec 08             	sub    $0x8,%esp
  801fee:	53                   	push   %ebx
  801fef:	6a 3f                	push   $0x3f
  801ff1:	ff d6                	call   *%esi
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	eb c3                	jmp    801fbb <vprintfmt+0x1e1>
  801ff8:	89 cf                	mov    %ecx,%edi
  801ffa:	eb 0e                	jmp    80200a <vprintfmt+0x230>
				putch(' ', putdat);
  801ffc:	83 ec 08             	sub    $0x8,%esp
  801fff:	53                   	push   %ebx
  802000:	6a 20                	push   $0x20
  802002:	ff d6                	call   *%esi
			for (; width > 0; width--)
  802004:	83 ef 01             	sub    $0x1,%edi
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 ff                	test   %edi,%edi
  80200c:	7f ee                	jg     801ffc <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80200e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802011:	89 45 14             	mov    %eax,0x14(%ebp)
  802014:	e9 67 01 00 00       	jmp    802180 <vprintfmt+0x3a6>
  802019:	89 cf                	mov    %ecx,%edi
  80201b:	eb ed                	jmp    80200a <vprintfmt+0x230>
	if (lflag >= 2)
  80201d:	83 f9 01             	cmp    $0x1,%ecx
  802020:	7f 1b                	jg     80203d <vprintfmt+0x263>
	else if (lflag)
  802022:	85 c9                	test   %ecx,%ecx
  802024:	74 63                	je     802089 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  802026:	8b 45 14             	mov    0x14(%ebp),%eax
  802029:	8b 00                	mov    (%eax),%eax
  80202b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80202e:	99                   	cltd   
  80202f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802032:	8b 45 14             	mov    0x14(%ebp),%eax
  802035:	8d 40 04             	lea    0x4(%eax),%eax
  802038:	89 45 14             	mov    %eax,0x14(%ebp)
  80203b:	eb 17                	jmp    802054 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80203d:	8b 45 14             	mov    0x14(%ebp),%eax
  802040:	8b 50 04             	mov    0x4(%eax),%edx
  802043:	8b 00                	mov    (%eax),%eax
  802045:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802048:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80204b:	8b 45 14             	mov    0x14(%ebp),%eax
  80204e:	8d 40 08             	lea    0x8(%eax),%eax
  802051:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  802054:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802057:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80205a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80205f:	85 c9                	test   %ecx,%ecx
  802061:	0f 89 ff 00 00 00    	jns    802166 <vprintfmt+0x38c>
				putch('-', putdat);
  802067:	83 ec 08             	sub    $0x8,%esp
  80206a:	53                   	push   %ebx
  80206b:	6a 2d                	push   $0x2d
  80206d:	ff d6                	call   *%esi
				num = -(long long) num;
  80206f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802072:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  802075:	f7 da                	neg    %edx
  802077:	83 d1 00             	adc    $0x0,%ecx
  80207a:	f7 d9                	neg    %ecx
  80207c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80207f:	b8 0a 00 00 00       	mov    $0xa,%eax
  802084:	e9 dd 00 00 00       	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  802089:	8b 45 14             	mov    0x14(%ebp),%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802091:	99                   	cltd   
  802092:	89 55 dc             	mov    %edx,-0x24(%ebp)
  802095:	8b 45 14             	mov    0x14(%ebp),%eax
  802098:	8d 40 04             	lea    0x4(%eax),%eax
  80209b:	89 45 14             	mov    %eax,0x14(%ebp)
  80209e:	eb b4                	jmp    802054 <vprintfmt+0x27a>
	if (lflag >= 2)
  8020a0:	83 f9 01             	cmp    $0x1,%ecx
  8020a3:	7f 1e                	jg     8020c3 <vprintfmt+0x2e9>
	else if (lflag)
  8020a5:	85 c9                	test   %ecx,%ecx
  8020a7:	74 32                	je     8020db <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8020a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ac:	8b 10                	mov    (%eax),%edx
  8020ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b3:	8d 40 04             	lea    0x4(%eax),%eax
  8020b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020b9:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8020be:	e9 a3 00 00 00       	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8020c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c6:	8b 10                	mov    (%eax),%edx
  8020c8:	8b 48 04             	mov    0x4(%eax),%ecx
  8020cb:	8d 40 08             	lea    0x8(%eax),%eax
  8020ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020d1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8020d6:	e9 8b 00 00 00       	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8020db:	8b 45 14             	mov    0x14(%ebp),%eax
  8020de:	8b 10                	mov    (%eax),%edx
  8020e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020e5:	8d 40 04             	lea    0x4(%eax),%eax
  8020e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8020eb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8020f0:	eb 74                	jmp    802166 <vprintfmt+0x38c>
	if (lflag >= 2)
  8020f2:	83 f9 01             	cmp    $0x1,%ecx
  8020f5:	7f 1b                	jg     802112 <vprintfmt+0x338>
	else if (lflag)
  8020f7:	85 c9                	test   %ecx,%ecx
  8020f9:	74 2c                	je     802127 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8020fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fe:	8b 10                	mov    (%eax),%edx
  802100:	b9 00 00 00 00       	mov    $0x0,%ecx
  802105:	8d 40 04             	lea    0x4(%eax),%eax
  802108:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80210b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  802110:	eb 54                	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  802112:	8b 45 14             	mov    0x14(%ebp),%eax
  802115:	8b 10                	mov    (%eax),%edx
  802117:	8b 48 04             	mov    0x4(%eax),%ecx
  80211a:	8d 40 08             	lea    0x8(%eax),%eax
  80211d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802120:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  802125:	eb 3f                	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  802127:	8b 45 14             	mov    0x14(%ebp),%eax
  80212a:	8b 10                	mov    (%eax),%edx
  80212c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802131:	8d 40 04             	lea    0x4(%eax),%eax
  802134:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  802137:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80213c:	eb 28                	jmp    802166 <vprintfmt+0x38c>
			putch('0', putdat);
  80213e:	83 ec 08             	sub    $0x8,%esp
  802141:	53                   	push   %ebx
  802142:	6a 30                	push   $0x30
  802144:	ff d6                	call   *%esi
			putch('x', putdat);
  802146:	83 c4 08             	add    $0x8,%esp
  802149:	53                   	push   %ebx
  80214a:	6a 78                	push   $0x78
  80214c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80214e:	8b 45 14             	mov    0x14(%ebp),%eax
  802151:	8b 10                	mov    (%eax),%edx
  802153:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  802158:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80215b:	8d 40 04             	lea    0x4(%eax),%eax
  80215e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802161:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  802166:	83 ec 0c             	sub    $0xc,%esp
  802169:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80216d:	57                   	push   %edi
  80216e:	ff 75 e0             	pushl  -0x20(%ebp)
  802171:	50                   	push   %eax
  802172:	51                   	push   %ecx
  802173:	52                   	push   %edx
  802174:	89 da                	mov    %ebx,%edx
  802176:	89 f0                	mov    %esi,%eax
  802178:	e8 72 fb ff ff       	call   801cef <printnum>
			break;
  80217d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  802180:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802183:	83 c7 01             	add    $0x1,%edi
  802186:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80218a:	83 f8 25             	cmp    $0x25,%eax
  80218d:	0f 84 62 fc ff ff    	je     801df5 <vprintfmt+0x1b>
			if (ch == '\0')
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 84 8b 00 00 00    	je     802226 <vprintfmt+0x44c>
			putch(ch, putdat);
  80219b:	83 ec 08             	sub    $0x8,%esp
  80219e:	53                   	push   %ebx
  80219f:	50                   	push   %eax
  8021a0:	ff d6                	call   *%esi
  8021a2:	83 c4 10             	add    $0x10,%esp
  8021a5:	eb dc                	jmp    802183 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8021a7:	83 f9 01             	cmp    $0x1,%ecx
  8021aa:	7f 1b                	jg     8021c7 <vprintfmt+0x3ed>
	else if (lflag)
  8021ac:	85 c9                	test   %ecx,%ecx
  8021ae:	74 2c                	je     8021dc <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8021b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b3:	8b 10                	mov    (%eax),%edx
  8021b5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021ba:	8d 40 04             	lea    0x4(%eax),%eax
  8021bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021c0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8021c5:	eb 9f                	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8021c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ca:	8b 10                	mov    (%eax),%edx
  8021cc:	8b 48 04             	mov    0x4(%eax),%ecx
  8021cf:	8d 40 08             	lea    0x8(%eax),%eax
  8021d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021d5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8021da:	eb 8a                	jmp    802166 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8021dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8021df:	8b 10                	mov    (%eax),%edx
  8021e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e6:	8d 40 04             	lea    0x4(%eax),%eax
  8021e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8021ec:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8021f1:	e9 70 ff ff ff       	jmp    802166 <vprintfmt+0x38c>
			putch(ch, putdat);
  8021f6:	83 ec 08             	sub    $0x8,%esp
  8021f9:	53                   	push   %ebx
  8021fa:	6a 25                	push   $0x25
  8021fc:	ff d6                	call   *%esi
			break;
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	e9 7a ff ff ff       	jmp    802180 <vprintfmt+0x3a6>
			putch('%', putdat);
  802206:	83 ec 08             	sub    $0x8,%esp
  802209:	53                   	push   %ebx
  80220a:	6a 25                	push   $0x25
  80220c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	89 f8                	mov    %edi,%eax
  802213:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802217:	74 05                	je     80221e <vprintfmt+0x444>
  802219:	83 e8 01             	sub    $0x1,%eax
  80221c:	eb f5                	jmp    802213 <vprintfmt+0x439>
  80221e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802221:	e9 5a ff ff ff       	jmp    802180 <vprintfmt+0x3a6>
}
  802226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802229:	5b                   	pop    %ebx
  80222a:	5e                   	pop    %esi
  80222b:	5f                   	pop    %edi
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80222e:	f3 0f 1e fb          	endbr32 
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 18             	sub    $0x18,%esp
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80223e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802241:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802245:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 26                	je     802279 <vsnprintf+0x4b>
  802253:	85 d2                	test   %edx,%edx
  802255:	7e 22                	jle    802279 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802257:	ff 75 14             	pushl  0x14(%ebp)
  80225a:	ff 75 10             	pushl  0x10(%ebp)
  80225d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802260:	50                   	push   %eax
  802261:	68 98 1d 80 00       	push   $0x801d98
  802266:	e8 6f fb ff ff       	call   801dda <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80226b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	83 c4 10             	add    $0x10,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    
		return -E_INVAL;
  802279:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80227e:	eb f7                	jmp    802277 <vsnprintf+0x49>

00802280 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802280:	f3 0f 1e fb          	endbr32 
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80228a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80228d:	50                   	push   %eax
  80228e:	ff 75 10             	pushl  0x10(%ebp)
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	ff 75 08             	pushl  0x8(%ebp)
  802297:	e8 92 ff ff ff       	call   80222e <vsnprintf>
	va_end(ap);

	return rc;
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80229e:	f3 0f 1e fb          	endbr32 
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8022a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ad:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8022b1:	74 05                	je     8022b8 <strlen+0x1a>
		n++;
  8022b3:	83 c0 01             	add    $0x1,%eax
  8022b6:	eb f5                	jmp    8022ad <strlen+0xf>
	return n;
}
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8022ba:	f3 0f 1e fb          	endbr32 
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cc:	39 d0                	cmp    %edx,%eax
  8022ce:	74 0d                	je     8022dd <strnlen+0x23>
  8022d0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8022d4:	74 05                	je     8022db <strnlen+0x21>
		n++;
  8022d6:	83 c0 01             	add    $0x1,%eax
  8022d9:	eb f1                	jmp    8022cc <strnlen+0x12>
  8022db:	89 c2                	mov    %eax,%edx
	return n;
}
  8022dd:	89 d0                	mov    %edx,%eax
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    

008022e1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022e1:	f3 0f 1e fb          	endbr32 
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	53                   	push   %ebx
  8022e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8022f8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8022fb:	83 c0 01             	add    $0x1,%eax
  8022fe:	84 d2                	test   %dl,%dl
  802300:	75 f2                	jne    8022f4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  802302:	89 c8                	mov    %ecx,%eax
  802304:	5b                   	pop    %ebx
  802305:	5d                   	pop    %ebp
  802306:	c3                   	ret    

00802307 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802307:	f3 0f 1e fb          	endbr32 
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	53                   	push   %ebx
  80230f:	83 ec 10             	sub    $0x10,%esp
  802312:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802315:	53                   	push   %ebx
  802316:	e8 83 ff ff ff       	call   80229e <strlen>
  80231b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80231e:	ff 75 0c             	pushl  0xc(%ebp)
  802321:	01 d8                	add    %ebx,%eax
  802323:	50                   	push   %eax
  802324:	e8 b8 ff ff ff       	call   8022e1 <strcpy>
	return dst;
}
  802329:	89 d8                	mov    %ebx,%eax
  80232b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	56                   	push   %esi
  802338:	53                   	push   %ebx
  802339:	8b 75 08             	mov    0x8(%ebp),%esi
  80233c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233f:	89 f3                	mov    %esi,%ebx
  802341:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802344:	89 f0                	mov    %esi,%eax
  802346:	39 d8                	cmp    %ebx,%eax
  802348:	74 11                	je     80235b <strncpy+0x2b>
		*dst++ = *src;
  80234a:	83 c0 01             	add    $0x1,%eax
  80234d:	0f b6 0a             	movzbl (%edx),%ecx
  802350:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802353:	80 f9 01             	cmp    $0x1,%cl
  802356:	83 da ff             	sbb    $0xffffffff,%edx
  802359:	eb eb                	jmp    802346 <strncpy+0x16>
	}
	return ret;
}
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	5b                   	pop    %ebx
  80235e:	5e                   	pop    %esi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    

00802361 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802361:	f3 0f 1e fb          	endbr32 
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	56                   	push   %esi
  802369:	53                   	push   %ebx
  80236a:	8b 75 08             	mov    0x8(%ebp),%esi
  80236d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802370:	8b 55 10             	mov    0x10(%ebp),%edx
  802373:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802375:	85 d2                	test   %edx,%edx
  802377:	74 21                	je     80239a <strlcpy+0x39>
  802379:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80237d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80237f:	39 c2                	cmp    %eax,%edx
  802381:	74 14                	je     802397 <strlcpy+0x36>
  802383:	0f b6 19             	movzbl (%ecx),%ebx
  802386:	84 db                	test   %bl,%bl
  802388:	74 0b                	je     802395 <strlcpy+0x34>
			*dst++ = *src++;
  80238a:	83 c1 01             	add    $0x1,%ecx
  80238d:	83 c2 01             	add    $0x1,%edx
  802390:	88 5a ff             	mov    %bl,-0x1(%edx)
  802393:	eb ea                	jmp    80237f <strlcpy+0x1e>
  802395:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  802397:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80239a:	29 f0                	sub    %esi,%eax
}
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    

008023a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023a0:	f3 0f 1e fb          	endbr32 
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8023ad:	0f b6 01             	movzbl (%ecx),%eax
  8023b0:	84 c0                	test   %al,%al
  8023b2:	74 0c                	je     8023c0 <strcmp+0x20>
  8023b4:	3a 02                	cmp    (%edx),%al
  8023b6:	75 08                	jne    8023c0 <strcmp+0x20>
		p++, q++;
  8023b8:	83 c1 01             	add    $0x1,%ecx
  8023bb:	83 c2 01             	add    $0x1,%edx
  8023be:	eb ed                	jmp    8023ad <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023c0:	0f b6 c0             	movzbl %al,%eax
  8023c3:	0f b6 12             	movzbl (%edx),%edx
  8023c6:	29 d0                	sub    %edx,%eax
}
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023ca:	f3 0f 1e fb          	endbr32 
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	53                   	push   %ebx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d8:	89 c3                	mov    %eax,%ebx
  8023da:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8023dd:	eb 06                	jmp    8023e5 <strncmp+0x1b>
		n--, p++, q++;
  8023df:	83 c0 01             	add    $0x1,%eax
  8023e2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8023e5:	39 d8                	cmp    %ebx,%eax
  8023e7:	74 16                	je     8023ff <strncmp+0x35>
  8023e9:	0f b6 08             	movzbl (%eax),%ecx
  8023ec:	84 c9                	test   %cl,%cl
  8023ee:	74 04                	je     8023f4 <strncmp+0x2a>
  8023f0:	3a 0a                	cmp    (%edx),%cl
  8023f2:	74 eb                	je     8023df <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023f4:	0f b6 00             	movzbl (%eax),%eax
  8023f7:	0f b6 12             	movzbl (%edx),%edx
  8023fa:	29 d0                	sub    %edx,%eax
}
  8023fc:	5b                   	pop    %ebx
  8023fd:	5d                   	pop    %ebp
  8023fe:	c3                   	ret    
		return 0;
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802404:	eb f6                	jmp    8023fc <strncmp+0x32>

00802406 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802406:	f3 0f 1e fb          	endbr32 
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802414:	0f b6 10             	movzbl (%eax),%edx
  802417:	84 d2                	test   %dl,%dl
  802419:	74 09                	je     802424 <strchr+0x1e>
		if (*s == c)
  80241b:	38 ca                	cmp    %cl,%dl
  80241d:	74 0a                	je     802429 <strchr+0x23>
	for (; *s; s++)
  80241f:	83 c0 01             	add    $0x1,%eax
  802422:	eb f0                	jmp    802414 <strchr+0xe>
			return (char *) s;
	return 0;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802429:	5d                   	pop    %ebp
  80242a:	c3                   	ret    

0080242b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80242b:	f3 0f 1e fb          	endbr32 
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802439:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80243c:	38 ca                	cmp    %cl,%dl
  80243e:	74 09                	je     802449 <strfind+0x1e>
  802440:	84 d2                	test   %dl,%dl
  802442:	74 05                	je     802449 <strfind+0x1e>
	for (; *s; s++)
  802444:	83 c0 01             	add    $0x1,%eax
  802447:	eb f0                	jmp    802439 <strfind+0xe>
			break;
	return (char *) s;
}
  802449:	5d                   	pop    %ebp
  80244a:	c3                   	ret    

0080244b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80244b:	f3 0f 1e fb          	endbr32 
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	57                   	push   %edi
  802453:	56                   	push   %esi
  802454:	53                   	push   %ebx
  802455:	8b 7d 08             	mov    0x8(%ebp),%edi
  802458:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80245b:	85 c9                	test   %ecx,%ecx
  80245d:	74 31                	je     802490 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80245f:	89 f8                	mov    %edi,%eax
  802461:	09 c8                	or     %ecx,%eax
  802463:	a8 03                	test   $0x3,%al
  802465:	75 23                	jne    80248a <memset+0x3f>
		c &= 0xFF;
  802467:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80246b:	89 d3                	mov    %edx,%ebx
  80246d:	c1 e3 08             	shl    $0x8,%ebx
  802470:	89 d0                	mov    %edx,%eax
  802472:	c1 e0 18             	shl    $0x18,%eax
  802475:	89 d6                	mov    %edx,%esi
  802477:	c1 e6 10             	shl    $0x10,%esi
  80247a:	09 f0                	or     %esi,%eax
  80247c:	09 c2                	or     %eax,%edx
  80247e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  802480:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  802483:	89 d0                	mov    %edx,%eax
  802485:	fc                   	cld    
  802486:	f3 ab                	rep stos %eax,%es:(%edi)
  802488:	eb 06                	jmp    802490 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80248a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248d:	fc                   	cld    
  80248e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802490:	89 f8                	mov    %edi,%eax
  802492:	5b                   	pop    %ebx
  802493:	5e                   	pop    %esi
  802494:	5f                   	pop    %edi
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802497:	f3 0f 1e fb          	endbr32 
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	57                   	push   %edi
  80249f:	56                   	push   %esi
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8024a9:	39 c6                	cmp    %eax,%esi
  8024ab:	73 32                	jae    8024df <memmove+0x48>
  8024ad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8024b0:	39 c2                	cmp    %eax,%edx
  8024b2:	76 2b                	jbe    8024df <memmove+0x48>
		s += n;
		d += n;
  8024b4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024b7:	89 fe                	mov    %edi,%esi
  8024b9:	09 ce                	or     %ecx,%esi
  8024bb:	09 d6                	or     %edx,%esi
  8024bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8024c3:	75 0e                	jne    8024d3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8024c5:	83 ef 04             	sub    $0x4,%edi
  8024c8:	8d 72 fc             	lea    -0x4(%edx),%esi
  8024cb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8024ce:	fd                   	std    
  8024cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024d1:	eb 09                	jmp    8024dc <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8024d3:	83 ef 01             	sub    $0x1,%edi
  8024d6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8024d9:	fd                   	std    
  8024da:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8024dc:	fc                   	cld    
  8024dd:	eb 1a                	jmp    8024f9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8024df:	89 c2                	mov    %eax,%edx
  8024e1:	09 ca                	or     %ecx,%edx
  8024e3:	09 f2                	or     %esi,%edx
  8024e5:	f6 c2 03             	test   $0x3,%dl
  8024e8:	75 0a                	jne    8024f4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8024ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8024ed:	89 c7                	mov    %eax,%edi
  8024ef:	fc                   	cld    
  8024f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8024f2:	eb 05                	jmp    8024f9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8024f4:	89 c7                	mov    %eax,%edi
  8024f6:	fc                   	cld    
  8024f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8024f9:	5e                   	pop    %esi
  8024fa:	5f                   	pop    %edi
  8024fb:	5d                   	pop    %ebp
  8024fc:	c3                   	ret    

008024fd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8024fd:	f3 0f 1e fb          	endbr32 
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802507:	ff 75 10             	pushl  0x10(%ebp)
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	e8 82 ff ff ff       	call   802497 <memmove>
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802517:	f3 0f 1e fb          	endbr32 
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	56                   	push   %esi
  80251f:	53                   	push   %ebx
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	89 c6                	mov    %eax,%esi
  802528:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80252b:	39 f0                	cmp    %esi,%eax
  80252d:	74 1c                	je     80254b <memcmp+0x34>
		if (*s1 != *s2)
  80252f:	0f b6 08             	movzbl (%eax),%ecx
  802532:	0f b6 1a             	movzbl (%edx),%ebx
  802535:	38 d9                	cmp    %bl,%cl
  802537:	75 08                	jne    802541 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802539:	83 c0 01             	add    $0x1,%eax
  80253c:	83 c2 01             	add    $0x1,%edx
  80253f:	eb ea                	jmp    80252b <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  802541:	0f b6 c1             	movzbl %cl,%eax
  802544:	0f b6 db             	movzbl %bl,%ebx
  802547:	29 d8                	sub    %ebx,%eax
  802549:	eb 05                	jmp    802550 <memcmp+0x39>
	}

	return 0;
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802550:	5b                   	pop    %ebx
  802551:	5e                   	pop    %esi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802554:	f3 0f 1e fb          	endbr32 
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802561:	89 c2                	mov    %eax,%edx
  802563:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802566:	39 d0                	cmp    %edx,%eax
  802568:	73 09                	jae    802573 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80256a:	38 08                	cmp    %cl,(%eax)
  80256c:	74 05                	je     802573 <memfind+0x1f>
	for (; s < ends; s++)
  80256e:	83 c0 01             	add    $0x1,%eax
  802571:	eb f3                	jmp    802566 <memfind+0x12>
			break;
	return (void *) s;
}
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802575:	f3 0f 1e fb          	endbr32 
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	57                   	push   %edi
  80257d:	56                   	push   %esi
  80257e:	53                   	push   %ebx
  80257f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802582:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802585:	eb 03                	jmp    80258a <strtol+0x15>
		s++;
  802587:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80258a:	0f b6 01             	movzbl (%ecx),%eax
  80258d:	3c 20                	cmp    $0x20,%al
  80258f:	74 f6                	je     802587 <strtol+0x12>
  802591:	3c 09                	cmp    $0x9,%al
  802593:	74 f2                	je     802587 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  802595:	3c 2b                	cmp    $0x2b,%al
  802597:	74 2a                	je     8025c3 <strtol+0x4e>
	int neg = 0;
  802599:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80259e:	3c 2d                	cmp    $0x2d,%al
  8025a0:	74 2b                	je     8025cd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025a2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8025a8:	75 0f                	jne    8025b9 <strtol+0x44>
  8025aa:	80 39 30             	cmpb   $0x30,(%ecx)
  8025ad:	74 28                	je     8025d7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8025af:	85 db                	test   %ebx,%ebx
  8025b1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8025b6:	0f 44 d8             	cmove  %eax,%ebx
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8025c1:	eb 46                	jmp    802609 <strtol+0x94>
		s++;
  8025c3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8025c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cb:	eb d5                	jmp    8025a2 <strtol+0x2d>
		s++, neg = 1;
  8025cd:	83 c1 01             	add    $0x1,%ecx
  8025d0:	bf 01 00 00 00       	mov    $0x1,%edi
  8025d5:	eb cb                	jmp    8025a2 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8025d7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8025db:	74 0e                	je     8025eb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8025dd:	85 db                	test   %ebx,%ebx
  8025df:	75 d8                	jne    8025b9 <strtol+0x44>
		s++, base = 8;
  8025e1:	83 c1 01             	add    $0x1,%ecx
  8025e4:	bb 08 00 00 00       	mov    $0x8,%ebx
  8025e9:	eb ce                	jmp    8025b9 <strtol+0x44>
		s += 2, base = 16;
  8025eb:	83 c1 02             	add    $0x2,%ecx
  8025ee:	bb 10 00 00 00       	mov    $0x10,%ebx
  8025f3:	eb c4                	jmp    8025b9 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8025f5:	0f be d2             	movsbl %dl,%edx
  8025f8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8025fb:	3b 55 10             	cmp    0x10(%ebp),%edx
  8025fe:	7d 3a                	jge    80263a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802600:	83 c1 01             	add    $0x1,%ecx
  802603:	0f af 45 10          	imul   0x10(%ebp),%eax
  802607:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802609:	0f b6 11             	movzbl (%ecx),%edx
  80260c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80260f:	89 f3                	mov    %esi,%ebx
  802611:	80 fb 09             	cmp    $0x9,%bl
  802614:	76 df                	jbe    8025f5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802616:	8d 72 9f             	lea    -0x61(%edx),%esi
  802619:	89 f3                	mov    %esi,%ebx
  80261b:	80 fb 19             	cmp    $0x19,%bl
  80261e:	77 08                	ja     802628 <strtol+0xb3>
			dig = *s - 'a' + 10;
  802620:	0f be d2             	movsbl %dl,%edx
  802623:	83 ea 57             	sub    $0x57,%edx
  802626:	eb d3                	jmp    8025fb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802628:	8d 72 bf             	lea    -0x41(%edx),%esi
  80262b:	89 f3                	mov    %esi,%ebx
  80262d:	80 fb 19             	cmp    $0x19,%bl
  802630:	77 08                	ja     80263a <strtol+0xc5>
			dig = *s - 'A' + 10;
  802632:	0f be d2             	movsbl %dl,%edx
  802635:	83 ea 37             	sub    $0x37,%edx
  802638:	eb c1                	jmp    8025fb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80263a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80263e:	74 05                	je     802645 <strtol+0xd0>
		*endptr = (char *) s;
  802640:	8b 75 0c             	mov    0xc(%ebp),%esi
  802643:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802645:	89 c2                	mov    %eax,%edx
  802647:	f7 da                	neg    %edx
  802649:	85 ff                	test   %edi,%edi
  80264b:	0f 45 c2             	cmovne %edx,%eax
}
  80264e:	5b                   	pop    %ebx
  80264f:	5e                   	pop    %esi
  802650:	5f                   	pop    %edi
  802651:	5d                   	pop    %ebp
  802652:	c3                   	ret    

00802653 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802653:	f3 0f 1e fb          	endbr32 
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	57                   	push   %edi
  80265b:	56                   	push   %esi
  80265c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	8b 55 08             	mov    0x8(%ebp),%edx
  802665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802668:	89 c3                	mov    %eax,%ebx
  80266a:	89 c7                	mov    %eax,%edi
  80266c:	89 c6                	mov    %eax,%esi
  80266e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802670:	5b                   	pop    %ebx
  802671:	5e                   	pop    %esi
  802672:	5f                   	pop    %edi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    

00802675 <sys_cgetc>:

int
sys_cgetc(void)
{
  802675:	f3 0f 1e fb          	endbr32 
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	57                   	push   %edi
  80267d:	56                   	push   %esi
  80267e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80267f:	ba 00 00 00 00       	mov    $0x0,%edx
  802684:	b8 01 00 00 00       	mov    $0x1,%eax
  802689:	89 d1                	mov    %edx,%ecx
  80268b:	89 d3                	mov    %edx,%ebx
  80268d:	89 d7                	mov    %edx,%edi
  80268f:	89 d6                	mov    %edx,%esi
  802691:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802693:	5b                   	pop    %ebx
  802694:	5e                   	pop    %esi
  802695:	5f                   	pop    %edi
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    

00802698 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802698:	f3 0f 1e fb          	endbr32 
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	57                   	push   %edi
  8026a0:	56                   	push   %esi
  8026a1:	53                   	push   %ebx
  8026a2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ad:	b8 03 00 00 00       	mov    $0x3,%eax
  8026b2:	89 cb                	mov    %ecx,%ebx
  8026b4:	89 cf                	mov    %ecx,%edi
  8026b6:	89 ce                	mov    %ecx,%esi
  8026b8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	7f 08                	jg     8026c6 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8026be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	50                   	push   %eax
  8026ca:	6a 03                	push   $0x3
  8026cc:	68 9f 48 80 00       	push   $0x80489f
  8026d1:	6a 23                	push   $0x23
  8026d3:	68 bc 48 80 00       	push   $0x8048bc
  8026d8:	e8 13 f5 ff ff       	call   801bf0 <_panic>

008026dd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8026dd:	f3 0f 1e fb          	endbr32 
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	57                   	push   %edi
  8026e5:	56                   	push   %esi
  8026e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8026e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8026f1:	89 d1                	mov    %edx,%ecx
  8026f3:	89 d3                	mov    %edx,%ebx
  8026f5:	89 d7                	mov    %edx,%edi
  8026f7:	89 d6                	mov    %edx,%esi
  8026f9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8026fb:	5b                   	pop    %ebx
  8026fc:	5e                   	pop    %esi
  8026fd:	5f                   	pop    %edi
  8026fe:	5d                   	pop    %ebp
  8026ff:	c3                   	ret    

00802700 <sys_yield>:

void
sys_yield(void)
{
  802700:	f3 0f 1e fb          	endbr32 
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	57                   	push   %edi
  802708:	56                   	push   %esi
  802709:	53                   	push   %ebx
	asm volatile("int %1\n"
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
  80270f:	b8 0b 00 00 00       	mov    $0xb,%eax
  802714:	89 d1                	mov    %edx,%ecx
  802716:	89 d3                	mov    %edx,%ebx
  802718:	89 d7                	mov    %edx,%edi
  80271a:	89 d6                	mov    %edx,%esi
  80271c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80271e:	5b                   	pop    %ebx
  80271f:	5e                   	pop    %esi
  802720:	5f                   	pop    %edi
  802721:	5d                   	pop    %ebp
  802722:	c3                   	ret    

00802723 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802723:	f3 0f 1e fb          	endbr32 
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	57                   	push   %edi
  80272b:	56                   	push   %esi
  80272c:	53                   	push   %ebx
  80272d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802730:	be 00 00 00 00       	mov    $0x0,%esi
  802735:	8b 55 08             	mov    0x8(%ebp),%edx
  802738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80273b:	b8 04 00 00 00       	mov    $0x4,%eax
  802740:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802743:	89 f7                	mov    %esi,%edi
  802745:	cd 30                	int    $0x30
	if(check && ret > 0)
  802747:	85 c0                	test   %eax,%eax
  802749:	7f 08                	jg     802753 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80274b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80274e:	5b                   	pop    %ebx
  80274f:	5e                   	pop    %esi
  802750:	5f                   	pop    %edi
  802751:	5d                   	pop    %ebp
  802752:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802753:	83 ec 0c             	sub    $0xc,%esp
  802756:	50                   	push   %eax
  802757:	6a 04                	push   $0x4
  802759:	68 9f 48 80 00       	push   $0x80489f
  80275e:	6a 23                	push   $0x23
  802760:	68 bc 48 80 00       	push   $0x8048bc
  802765:	e8 86 f4 ff ff       	call   801bf0 <_panic>

0080276a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80276a:	f3 0f 1e fb          	endbr32 
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	57                   	push   %edi
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802777:	8b 55 08             	mov    0x8(%ebp),%edx
  80277a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80277d:	b8 05 00 00 00       	mov    $0x5,%eax
  802782:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802785:	8b 7d 14             	mov    0x14(%ebp),%edi
  802788:	8b 75 18             	mov    0x18(%ebp),%esi
  80278b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80278d:	85 c0                	test   %eax,%eax
  80278f:	7f 08                	jg     802799 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802791:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802794:	5b                   	pop    %ebx
  802795:	5e                   	pop    %esi
  802796:	5f                   	pop    %edi
  802797:	5d                   	pop    %ebp
  802798:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	50                   	push   %eax
  80279d:	6a 05                	push   $0x5
  80279f:	68 9f 48 80 00       	push   $0x80489f
  8027a4:	6a 23                	push   $0x23
  8027a6:	68 bc 48 80 00       	push   $0x8048bc
  8027ab:	e8 40 f4 ff ff       	call   801bf0 <_panic>

008027b0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8027b0:	f3 0f 1e fb          	endbr32 
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
  8027b7:	57                   	push   %edi
  8027b8:	56                   	push   %esi
  8027b9:	53                   	push   %ebx
  8027ba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8027cd:	89 df                	mov    %ebx,%edi
  8027cf:	89 de                	mov    %ebx,%esi
  8027d1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	7f 08                	jg     8027df <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8027d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027da:	5b                   	pop    %ebx
  8027db:	5e                   	pop    %esi
  8027dc:	5f                   	pop    %edi
  8027dd:	5d                   	pop    %ebp
  8027de:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	50                   	push   %eax
  8027e3:	6a 06                	push   $0x6
  8027e5:	68 9f 48 80 00       	push   $0x80489f
  8027ea:	6a 23                	push   $0x23
  8027ec:	68 bc 48 80 00       	push   $0x8048bc
  8027f1:	e8 fa f3 ff ff       	call   801bf0 <_panic>

008027f6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8027f6:	f3 0f 1e fb          	endbr32 
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	57                   	push   %edi
  8027fe:	56                   	push   %esi
  8027ff:	53                   	push   %ebx
  802800:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802803:	bb 00 00 00 00       	mov    $0x0,%ebx
  802808:	8b 55 08             	mov    0x8(%ebp),%edx
  80280b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80280e:	b8 08 00 00 00       	mov    $0x8,%eax
  802813:	89 df                	mov    %ebx,%edi
  802815:	89 de                	mov    %ebx,%esi
  802817:	cd 30                	int    $0x30
	if(check && ret > 0)
  802819:	85 c0                	test   %eax,%eax
  80281b:	7f 08                	jg     802825 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80281d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802820:	5b                   	pop    %ebx
  802821:	5e                   	pop    %esi
  802822:	5f                   	pop    %edi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	50                   	push   %eax
  802829:	6a 08                	push   $0x8
  80282b:	68 9f 48 80 00       	push   $0x80489f
  802830:	6a 23                	push   $0x23
  802832:	68 bc 48 80 00       	push   $0x8048bc
  802837:	e8 b4 f3 ff ff       	call   801bf0 <_panic>

0080283c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80283c:	f3 0f 1e fb          	endbr32 
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	57                   	push   %edi
  802844:	56                   	push   %esi
  802845:	53                   	push   %ebx
  802846:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802849:	bb 00 00 00 00       	mov    $0x0,%ebx
  80284e:	8b 55 08             	mov    0x8(%ebp),%edx
  802851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802854:	b8 09 00 00 00       	mov    $0x9,%eax
  802859:	89 df                	mov    %ebx,%edi
  80285b:	89 de                	mov    %ebx,%esi
  80285d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80285f:	85 c0                	test   %eax,%eax
  802861:	7f 08                	jg     80286b <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802863:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802866:	5b                   	pop    %ebx
  802867:	5e                   	pop    %esi
  802868:	5f                   	pop    %edi
  802869:	5d                   	pop    %ebp
  80286a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	50                   	push   %eax
  80286f:	6a 09                	push   $0x9
  802871:	68 9f 48 80 00       	push   $0x80489f
  802876:	6a 23                	push   $0x23
  802878:	68 bc 48 80 00       	push   $0x8048bc
  80287d:	e8 6e f3 ff ff       	call   801bf0 <_panic>

00802882 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802882:	f3 0f 1e fb          	endbr32 
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	57                   	push   %edi
  80288a:	56                   	push   %esi
  80288b:	53                   	push   %ebx
  80288c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80288f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802894:	8b 55 08             	mov    0x8(%ebp),%edx
  802897:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80289a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80289f:	89 df                	mov    %ebx,%edi
  8028a1:	89 de                	mov    %ebx,%esi
  8028a3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	7f 08                	jg     8028b1 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8028a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028ac:	5b                   	pop    %ebx
  8028ad:	5e                   	pop    %esi
  8028ae:	5f                   	pop    %edi
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8028b1:	83 ec 0c             	sub    $0xc,%esp
  8028b4:	50                   	push   %eax
  8028b5:	6a 0a                	push   $0xa
  8028b7:	68 9f 48 80 00       	push   $0x80489f
  8028bc:	6a 23                	push   $0x23
  8028be:	68 bc 48 80 00       	push   $0x8048bc
  8028c3:	e8 28 f3 ff ff       	call   801bf0 <_panic>

008028c8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8028c8:	f3 0f 1e fb          	endbr32 
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	57                   	push   %edi
  8028d0:	56                   	push   %esi
  8028d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8028d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028d8:	b8 0c 00 00 00       	mov    $0xc,%eax
  8028dd:	be 00 00 00 00       	mov    $0x0,%esi
  8028e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8028e8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8028ea:	5b                   	pop    %ebx
  8028eb:	5e                   	pop    %esi
  8028ec:	5f                   	pop    %edi
  8028ed:	5d                   	pop    %ebp
  8028ee:	c3                   	ret    

008028ef <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8028ef:	f3 0f 1e fb          	endbr32 
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	57                   	push   %edi
  8028f7:	56                   	push   %esi
  8028f8:	53                   	push   %ebx
  8028f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8028fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  802901:	8b 55 08             	mov    0x8(%ebp),%edx
  802904:	b8 0d 00 00 00       	mov    $0xd,%eax
  802909:	89 cb                	mov    %ecx,%ebx
  80290b:	89 cf                	mov    %ecx,%edi
  80290d:	89 ce                	mov    %ecx,%esi
  80290f:	cd 30                	int    $0x30
	if(check && ret > 0)
  802911:	85 c0                	test   %eax,%eax
  802913:	7f 08                	jg     80291d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802915:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802918:	5b                   	pop    %ebx
  802919:	5e                   	pop    %esi
  80291a:	5f                   	pop    %edi
  80291b:	5d                   	pop    %ebp
  80291c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80291d:	83 ec 0c             	sub    $0xc,%esp
  802920:	50                   	push   %eax
  802921:	6a 0d                	push   $0xd
  802923:	68 9f 48 80 00       	push   $0x80489f
  802928:	6a 23                	push   $0x23
  80292a:	68 bc 48 80 00       	push   $0x8048bc
  80292f:	e8 bc f2 ff ff       	call   801bf0 <_panic>

00802934 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802934:	f3 0f 1e fb          	endbr32 
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	57                   	push   %edi
  80293c:	56                   	push   %esi
  80293d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80293e:	ba 00 00 00 00       	mov    $0x0,%edx
  802943:	b8 0e 00 00 00       	mov    $0xe,%eax
  802948:	89 d1                	mov    %edx,%ecx
  80294a:	89 d3                	mov    %edx,%ebx
  80294c:	89 d7                	mov    %edx,%edi
  80294e:	89 d6                	mov    %edx,%esi
  802950:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802952:	5b                   	pop    %ebx
  802953:	5e                   	pop    %esi
  802954:	5f                   	pop    %edi
  802955:	5d                   	pop    %ebp
  802956:	c3                   	ret    

00802957 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802957:	f3 0f 1e fb          	endbr32 
  80295b:	55                   	push   %ebp
  80295c:	89 e5                	mov    %esp,%ebp
  80295e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802961:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802968:	74 0a                	je     802974 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802972:	c9                   	leave  
  802973:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802974:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802979:	8b 40 48             	mov    0x48(%eax),%eax
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	6a 07                	push   $0x7
  802981:	68 00 f0 bf ee       	push   $0xeebff000
  802986:	50                   	push   %eax
  802987:	e8 97 fd ff ff       	call   802723 <sys_page_alloc>
  80298c:	83 c4 10             	add    $0x10,%esp
  80298f:	85 c0                	test   %eax,%eax
  802991:	75 31                	jne    8029c4 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802993:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802998:	8b 40 48             	mov    0x48(%eax),%eax
  80299b:	83 ec 08             	sub    $0x8,%esp
  80299e:	68 d8 29 80 00       	push   $0x8029d8
  8029a3:	50                   	push   %eax
  8029a4:	e8 d9 fe ff ff       	call   802882 <sys_env_set_pgfault_upcall>
  8029a9:	83 c4 10             	add    $0x10,%esp
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	74 ba                	je     80296a <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  8029b0:	83 ec 04             	sub    $0x4,%esp
  8029b3:	68 f4 48 80 00       	push   $0x8048f4
  8029b8:	6a 24                	push   $0x24
  8029ba:	68 22 49 80 00       	push   $0x804922
  8029bf:	e8 2c f2 ff ff       	call   801bf0 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 cc 48 80 00       	push   $0x8048cc
  8029cc:	6a 21                	push   $0x21
  8029ce:	68 22 49 80 00       	push   $0x804922
  8029d3:	e8 18 f2 ff ff       	call   801bf0 <_panic>

008029d8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029d9:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  8029de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029e0:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8029e3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8029e7:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8029ec:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8029f0:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8029f2:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8029f5:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8029f6:	83 c4 04             	add    $0x4,%esp
    popfl
  8029f9:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8029fa:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8029fb:	c3                   	ret    

008029fc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029fc:	f3 0f 1e fb          	endbr32 
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	56                   	push   %esi
  802a04:	53                   	push   %ebx
  802a05:	8b 75 08             	mov    0x8(%ebp),%esi
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802a0e:	83 e8 01             	sub    $0x1,%eax
  802a11:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802a16:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a1b:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802a1f:	83 ec 0c             	sub    $0xc,%esp
  802a22:	50                   	push   %eax
  802a23:	e8 c7 fe ff ff       	call   8028ef <sys_ipc_recv>
	if (!t) {
  802a28:	83 c4 10             	add    $0x10,%esp
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	75 2b                	jne    802a5a <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802a2f:	85 f6                	test   %esi,%esi
  802a31:	74 0a                	je     802a3d <ipc_recv+0x41>
  802a33:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802a38:	8b 40 74             	mov    0x74(%eax),%eax
  802a3b:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802a3d:	85 db                	test   %ebx,%ebx
  802a3f:	74 0a                	je     802a4b <ipc_recv+0x4f>
  802a41:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802a46:	8b 40 78             	mov    0x78(%eax),%eax
  802a49:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802a4b:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802a50:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802a53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a56:	5b                   	pop    %ebx
  802a57:	5e                   	pop    %esi
  802a58:	5d                   	pop    %ebp
  802a59:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802a5a:	85 f6                	test   %esi,%esi
  802a5c:	74 06                	je     802a64 <ipc_recv+0x68>
  802a5e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802a64:	85 db                	test   %ebx,%ebx
  802a66:	74 eb                	je     802a53 <ipc_recv+0x57>
  802a68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a6e:	eb e3                	jmp    802a53 <ipc_recv+0x57>

00802a70 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a70:	f3 0f 1e fb          	endbr32 
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	57                   	push   %edi
  802a78:	56                   	push   %esi
  802a79:	53                   	push   %ebx
  802a7a:	83 ec 0c             	sub    $0xc,%esp
  802a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802a80:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802a86:	85 db                	test   %ebx,%ebx
  802a88:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a8d:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802a90:	ff 75 14             	pushl  0x14(%ebp)
  802a93:	53                   	push   %ebx
  802a94:	56                   	push   %esi
  802a95:	57                   	push   %edi
  802a96:	e8 2d fe ff ff       	call   8028c8 <sys_ipc_try_send>
  802a9b:	83 c4 10             	add    $0x10,%esp
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 1e                	je     802ac0 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802aa2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802aa5:	75 07                	jne    802aae <ipc_send+0x3e>
		sys_yield();
  802aa7:	e8 54 fc ff ff       	call   802700 <sys_yield>
  802aac:	eb e2                	jmp    802a90 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802aae:	50                   	push   %eax
  802aaf:	68 30 49 80 00       	push   $0x804930
  802ab4:	6a 39                	push   $0x39
  802ab6:	68 42 49 80 00       	push   $0x804942
  802abb:	e8 30 f1 ff ff       	call   801bf0 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ac3:	5b                   	pop    %ebx
  802ac4:	5e                   	pop    %esi
  802ac5:	5f                   	pop    %edi
  802ac6:	5d                   	pop    %ebp
  802ac7:	c3                   	ret    

00802ac8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ac8:	f3 0f 1e fb          	endbr32 
  802acc:	55                   	push   %ebp
  802acd:	89 e5                	mov    %esp,%ebp
  802acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802ad7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802ada:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802ae0:	8b 52 50             	mov    0x50(%edx),%edx
  802ae3:	39 ca                	cmp    %ecx,%edx
  802ae5:	74 11                	je     802af8 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802ae7:	83 c0 01             	add    $0x1,%eax
  802aea:	3d 00 04 00 00       	cmp    $0x400,%eax
  802aef:	75 e6                	jne    802ad7 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802af1:	b8 00 00 00 00       	mov    $0x0,%eax
  802af6:	eb 0b                	jmp    802b03 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802af8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802afb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802b00:	8b 40 48             	mov    0x48(%eax),%eax
}
  802b03:	5d                   	pop    %ebp
  802b04:	c3                   	ret    

00802b05 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802b05:	f3 0f 1e fb          	endbr32 
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	05 00 00 00 30       	add    $0x30000000,%eax
  802b14:	c1 e8 0c             	shr    $0xc,%eax
}
  802b17:	5d                   	pop    %ebp
  802b18:	c3                   	ret    

00802b19 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802b19:	f3 0f 1e fb          	endbr32 
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802b28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802b2d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802b32:	5d                   	pop    %ebp
  802b33:	c3                   	ret    

00802b34 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802b34:	f3 0f 1e fb          	endbr32 
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
  802b3b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b40:	89 c2                	mov    %eax,%edx
  802b42:	c1 ea 16             	shr    $0x16,%edx
  802b45:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b4c:	f6 c2 01             	test   $0x1,%dl
  802b4f:	74 2d                	je     802b7e <fd_alloc+0x4a>
  802b51:	89 c2                	mov    %eax,%edx
  802b53:	c1 ea 0c             	shr    $0xc,%edx
  802b56:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802b5d:	f6 c2 01             	test   $0x1,%dl
  802b60:	74 1c                	je     802b7e <fd_alloc+0x4a>
  802b62:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802b67:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802b6c:	75 d2                	jne    802b40 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  802b77:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802b7c:	eb 0a                	jmp    802b88 <fd_alloc+0x54>
			*fd_store = fd;
  802b7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b81:	89 01                	mov    %eax,(%ecx)
			return 0;
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b88:	5d                   	pop    %ebp
  802b89:	c3                   	ret    

00802b8a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b8a:	f3 0f 1e fb          	endbr32 
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b94:	83 f8 1f             	cmp    $0x1f,%eax
  802b97:	77 30                	ja     802bc9 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802b99:	c1 e0 0c             	shl    $0xc,%eax
  802b9c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802ba1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  802ba7:	f6 c2 01             	test   $0x1,%dl
  802baa:	74 24                	je     802bd0 <fd_lookup+0x46>
  802bac:	89 c2                	mov    %eax,%edx
  802bae:	c1 ea 0c             	shr    $0xc,%edx
  802bb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802bb8:	f6 c2 01             	test   $0x1,%dl
  802bbb:	74 1a                	je     802bd7 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc0:	89 02                	mov    %eax,(%edx)
	return 0;
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc7:	5d                   	pop    %ebp
  802bc8:	c3                   	ret    
		return -E_INVAL;
  802bc9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bce:	eb f7                	jmp    802bc7 <fd_lookup+0x3d>
		return -E_INVAL;
  802bd0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bd5:	eb f0                	jmp    802bc7 <fd_lookup+0x3d>
  802bd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bdc:	eb e9                	jmp    802bc7 <fd_lookup+0x3d>

00802bde <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bde:	f3 0f 1e fb          	endbr32 
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
  802be5:	83 ec 08             	sub    $0x8,%esp
  802be8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802beb:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf0:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802bf5:	39 08                	cmp    %ecx,(%eax)
  802bf7:	74 38                	je     802c31 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  802bf9:	83 c2 01             	add    $0x1,%edx
  802bfc:	8b 04 95 c8 49 80 00 	mov    0x8049c8(,%edx,4),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	75 ee                	jne    802bf5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802c07:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802c0c:	8b 40 48             	mov    0x48(%eax),%eax
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	51                   	push   %ecx
  802c13:	50                   	push   %eax
  802c14:	68 4c 49 80 00       	push   $0x80494c
  802c19:	e8 b9 f0 ff ff       	call   801cd7 <cprintf>
	*dev = 0;
  802c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802c27:	83 c4 10             	add    $0x10,%esp
  802c2a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    
			*dev = devtab[i];
  802c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c34:	89 01                	mov    %eax,(%ecx)
			return 0;
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	eb f2                	jmp    802c2f <dev_lookup+0x51>

00802c3d <fd_close>:
{
  802c3d:	f3 0f 1e fb          	endbr32 
  802c41:	55                   	push   %ebp
  802c42:	89 e5                	mov    %esp,%ebp
  802c44:	57                   	push   %edi
  802c45:	56                   	push   %esi
  802c46:	53                   	push   %ebx
  802c47:	83 ec 24             	sub    $0x24,%esp
  802c4a:	8b 75 08             	mov    0x8(%ebp),%esi
  802c4d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c53:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802c54:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802c5a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c5d:	50                   	push   %eax
  802c5e:	e8 27 ff ff ff       	call   802b8a <fd_lookup>
  802c63:	89 c3                	mov    %eax,%ebx
  802c65:	83 c4 10             	add    $0x10,%esp
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	78 05                	js     802c71 <fd_close+0x34>
	    || fd != fd2)
  802c6c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802c6f:	74 16                	je     802c87 <fd_close+0x4a>
		return (must_exist ? r : 0);
  802c71:	89 f8                	mov    %edi,%eax
  802c73:	84 c0                	test   %al,%al
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7a:	0f 44 d8             	cmove  %eax,%ebx
}
  802c7d:	89 d8                	mov    %ebx,%eax
  802c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c82:	5b                   	pop    %ebx
  802c83:	5e                   	pop    %esi
  802c84:	5f                   	pop    %edi
  802c85:	5d                   	pop    %ebp
  802c86:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c87:	83 ec 08             	sub    $0x8,%esp
  802c8a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802c8d:	50                   	push   %eax
  802c8e:	ff 36                	pushl  (%esi)
  802c90:	e8 49 ff ff ff       	call   802bde <dev_lookup>
  802c95:	89 c3                	mov    %eax,%ebx
  802c97:	83 c4 10             	add    $0x10,%esp
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	78 1a                	js     802cb8 <fd_close+0x7b>
		if (dev->dev_close)
  802c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  802ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0b                	je     802cb8 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  802cad:	83 ec 0c             	sub    $0xc,%esp
  802cb0:	56                   	push   %esi
  802cb1:	ff d0                	call   *%eax
  802cb3:	89 c3                	mov    %eax,%ebx
  802cb5:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802cb8:	83 ec 08             	sub    $0x8,%esp
  802cbb:	56                   	push   %esi
  802cbc:	6a 00                	push   $0x0
  802cbe:	e8 ed fa ff ff       	call   8027b0 <sys_page_unmap>
	return r;
  802cc3:	83 c4 10             	add    $0x10,%esp
  802cc6:	eb b5                	jmp    802c7d <fd_close+0x40>

00802cc8 <close>:

int
close(int fdnum)
{
  802cc8:	f3 0f 1e fb          	endbr32 
  802ccc:	55                   	push   %ebp
  802ccd:	89 e5                	mov    %esp,%ebp
  802ccf:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cd5:	50                   	push   %eax
  802cd6:	ff 75 08             	pushl  0x8(%ebp)
  802cd9:	e8 ac fe ff ff       	call   802b8a <fd_lookup>
  802cde:	83 c4 10             	add    $0x10,%esp
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	79 02                	jns    802ce7 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  802ce5:	c9                   	leave  
  802ce6:	c3                   	ret    
		return fd_close(fd, 1);
  802ce7:	83 ec 08             	sub    $0x8,%esp
  802cea:	6a 01                	push   $0x1
  802cec:	ff 75 f4             	pushl  -0xc(%ebp)
  802cef:	e8 49 ff ff ff       	call   802c3d <fd_close>
  802cf4:	83 c4 10             	add    $0x10,%esp
  802cf7:	eb ec                	jmp    802ce5 <close+0x1d>

00802cf9 <close_all>:

void
close_all(void)
{
  802cf9:	f3 0f 1e fb          	endbr32 
  802cfd:	55                   	push   %ebp
  802cfe:	89 e5                	mov    %esp,%ebp
  802d00:	53                   	push   %ebx
  802d01:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d04:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	53                   	push   %ebx
  802d0d:	e8 b6 ff ff ff       	call   802cc8 <close>
	for (i = 0; i < MAXFD; i++)
  802d12:	83 c3 01             	add    $0x1,%ebx
  802d15:	83 c4 10             	add    $0x10,%esp
  802d18:	83 fb 20             	cmp    $0x20,%ebx
  802d1b:	75 ec                	jne    802d09 <close_all+0x10>
}
  802d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d20:	c9                   	leave  
  802d21:	c3                   	ret    

00802d22 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d22:	f3 0f 1e fb          	endbr32 
  802d26:	55                   	push   %ebp
  802d27:	89 e5                	mov    %esp,%ebp
  802d29:	57                   	push   %edi
  802d2a:	56                   	push   %esi
  802d2b:	53                   	push   %ebx
  802d2c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d2f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802d32:	50                   	push   %eax
  802d33:	ff 75 08             	pushl  0x8(%ebp)
  802d36:	e8 4f fe ff ff       	call   802b8a <fd_lookup>
  802d3b:	89 c3                	mov    %eax,%ebx
  802d3d:	83 c4 10             	add    $0x10,%esp
  802d40:	85 c0                	test   %eax,%eax
  802d42:	0f 88 81 00 00 00    	js     802dc9 <dup+0xa7>
		return r;
	close(newfdnum);
  802d48:	83 ec 0c             	sub    $0xc,%esp
  802d4b:	ff 75 0c             	pushl  0xc(%ebp)
  802d4e:	e8 75 ff ff ff       	call   802cc8 <close>

	newfd = INDEX2FD(newfdnum);
  802d53:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d56:	c1 e6 0c             	shl    $0xc,%esi
  802d59:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802d5f:	83 c4 04             	add    $0x4,%esp
  802d62:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d65:	e8 af fd ff ff       	call   802b19 <fd2data>
  802d6a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802d6c:	89 34 24             	mov    %esi,(%esp)
  802d6f:	e8 a5 fd ff ff       	call   802b19 <fd2data>
  802d74:	83 c4 10             	add    $0x10,%esp
  802d77:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802d79:	89 d8                	mov    %ebx,%eax
  802d7b:	c1 e8 16             	shr    $0x16,%eax
  802d7e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d85:	a8 01                	test   $0x1,%al
  802d87:	74 11                	je     802d9a <dup+0x78>
  802d89:	89 d8                	mov    %ebx,%eax
  802d8b:	c1 e8 0c             	shr    $0xc,%eax
  802d8e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802d95:	f6 c2 01             	test   $0x1,%dl
  802d98:	75 39                	jne    802dd3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802d9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9d:	89 d0                	mov    %edx,%eax
  802d9f:	c1 e8 0c             	shr    $0xc,%eax
  802da2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802da9:	83 ec 0c             	sub    $0xc,%esp
  802dac:	25 07 0e 00 00       	and    $0xe07,%eax
  802db1:	50                   	push   %eax
  802db2:	56                   	push   %esi
  802db3:	6a 00                	push   $0x0
  802db5:	52                   	push   %edx
  802db6:	6a 00                	push   $0x0
  802db8:	e8 ad f9 ff ff       	call   80276a <sys_page_map>
  802dbd:	89 c3                	mov    %eax,%ebx
  802dbf:	83 c4 20             	add    $0x20,%esp
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	78 31                	js     802df7 <dup+0xd5>
		goto err;

	return newfdnum;
  802dc6:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802dc9:	89 d8                	mov    %ebx,%eax
  802dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802dce:	5b                   	pop    %ebx
  802dcf:	5e                   	pop    %esi
  802dd0:	5f                   	pop    %edi
  802dd1:	5d                   	pop    %ebp
  802dd2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802dd3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802dda:	83 ec 0c             	sub    $0xc,%esp
  802ddd:	25 07 0e 00 00       	and    $0xe07,%eax
  802de2:	50                   	push   %eax
  802de3:	57                   	push   %edi
  802de4:	6a 00                	push   $0x0
  802de6:	53                   	push   %ebx
  802de7:	6a 00                	push   $0x0
  802de9:	e8 7c f9 ff ff       	call   80276a <sys_page_map>
  802dee:	89 c3                	mov    %eax,%ebx
  802df0:	83 c4 20             	add    $0x20,%esp
  802df3:	85 c0                	test   %eax,%eax
  802df5:	79 a3                	jns    802d9a <dup+0x78>
	sys_page_unmap(0, newfd);
  802df7:	83 ec 08             	sub    $0x8,%esp
  802dfa:	56                   	push   %esi
  802dfb:	6a 00                	push   $0x0
  802dfd:	e8 ae f9 ff ff       	call   8027b0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802e02:	83 c4 08             	add    $0x8,%esp
  802e05:	57                   	push   %edi
  802e06:	6a 00                	push   $0x0
  802e08:	e8 a3 f9 ff ff       	call   8027b0 <sys_page_unmap>
	return r;
  802e0d:	83 c4 10             	add    $0x10,%esp
  802e10:	eb b7                	jmp    802dc9 <dup+0xa7>

00802e12 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802e12:	f3 0f 1e fb          	endbr32 
  802e16:	55                   	push   %ebp
  802e17:	89 e5                	mov    %esp,%ebp
  802e19:	53                   	push   %ebx
  802e1a:	83 ec 1c             	sub    $0x1c,%esp
  802e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e23:	50                   	push   %eax
  802e24:	53                   	push   %ebx
  802e25:	e8 60 fd ff ff       	call   802b8a <fd_lookup>
  802e2a:	83 c4 10             	add    $0x10,%esp
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	78 3f                	js     802e70 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e31:	83 ec 08             	sub    $0x8,%esp
  802e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e37:	50                   	push   %eax
  802e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3b:	ff 30                	pushl  (%eax)
  802e3d:	e8 9c fd ff ff       	call   802bde <dev_lookup>
  802e42:	83 c4 10             	add    $0x10,%esp
  802e45:	85 c0                	test   %eax,%eax
  802e47:	78 27                	js     802e70 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	8b 42 08             	mov    0x8(%edx),%eax
  802e4f:	83 e0 03             	and    $0x3,%eax
  802e52:	83 f8 01             	cmp    $0x1,%eax
  802e55:	74 1e                	je     802e75 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 08             	mov    0x8(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 35                	je     802e96 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	ff 75 10             	pushl  0x10(%ebp)
  802e67:	ff 75 0c             	pushl  0xc(%ebp)
  802e6a:	52                   	push   %edx
  802e6b:	ff d0                	call   *%eax
  802e6d:	83 c4 10             	add    $0x10,%esp
}
  802e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e73:	c9                   	leave  
  802e74:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802e75:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802e7a:	8b 40 48             	mov    0x48(%eax),%eax
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	53                   	push   %ebx
  802e81:	50                   	push   %eax
  802e82:	68 8d 49 80 00       	push   $0x80498d
  802e87:	e8 4b ee ff ff       	call   801cd7 <cprintf>
		return -E_INVAL;
  802e8c:	83 c4 10             	add    $0x10,%esp
  802e8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e94:	eb da                	jmp    802e70 <read+0x5e>
		return -E_NOT_SUPP;
  802e96:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e9b:	eb d3                	jmp    802e70 <read+0x5e>

00802e9d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e9d:	f3 0f 1e fb          	endbr32 
  802ea1:	55                   	push   %ebp
  802ea2:	89 e5                	mov    %esp,%ebp
  802ea4:	57                   	push   %edi
  802ea5:	56                   	push   %esi
  802ea6:	53                   	push   %ebx
  802ea7:	83 ec 0c             	sub    $0xc,%esp
  802eaa:	8b 7d 08             	mov    0x8(%ebp),%edi
  802ead:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802eb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  802eb5:	eb 02                	jmp    802eb9 <readn+0x1c>
  802eb7:	01 c3                	add    %eax,%ebx
  802eb9:	39 f3                	cmp    %esi,%ebx
  802ebb:	73 21                	jae    802ede <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	89 f0                	mov    %esi,%eax
  802ec2:	29 d8                	sub    %ebx,%eax
  802ec4:	50                   	push   %eax
  802ec5:	89 d8                	mov    %ebx,%eax
  802ec7:	03 45 0c             	add    0xc(%ebp),%eax
  802eca:	50                   	push   %eax
  802ecb:	57                   	push   %edi
  802ecc:	e8 41 ff ff ff       	call   802e12 <read>
		if (m < 0)
  802ed1:	83 c4 10             	add    $0x10,%esp
  802ed4:	85 c0                	test   %eax,%eax
  802ed6:	78 04                	js     802edc <readn+0x3f>
			return m;
		if (m == 0)
  802ed8:	75 dd                	jne    802eb7 <readn+0x1a>
  802eda:	eb 02                	jmp    802ede <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802edc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802ede:	89 d8                	mov    %ebx,%eax
  802ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ee3:	5b                   	pop    %ebx
  802ee4:	5e                   	pop    %esi
  802ee5:	5f                   	pop    %edi
  802ee6:	5d                   	pop    %ebp
  802ee7:	c3                   	ret    

00802ee8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802ee8:	f3 0f 1e fb          	endbr32 
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	53                   	push   %ebx
  802ef0:	83 ec 1c             	sub    $0x1c,%esp
  802ef3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ef6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ef9:	50                   	push   %eax
  802efa:	53                   	push   %ebx
  802efb:	e8 8a fc ff ff       	call   802b8a <fd_lookup>
  802f00:	83 c4 10             	add    $0x10,%esp
  802f03:	85 c0                	test   %eax,%eax
  802f05:	78 3a                	js     802f41 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f07:	83 ec 08             	sub    $0x8,%esp
  802f0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f0d:	50                   	push   %eax
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	ff 30                	pushl  (%eax)
  802f13:	e8 c6 fc ff ff       	call   802bde <dev_lookup>
  802f18:	83 c4 10             	add    $0x10,%esp
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	78 22                	js     802f41 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802f26:	74 1e                	je     802f46 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2b:	8b 52 0c             	mov    0xc(%edx),%edx
  802f2e:	85 d2                	test   %edx,%edx
  802f30:	74 35                	je     802f67 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	ff 75 10             	pushl  0x10(%ebp)
  802f38:	ff 75 0c             	pushl  0xc(%ebp)
  802f3b:	50                   	push   %eax
  802f3c:	ff d2                	call   *%edx
  802f3e:	83 c4 10             	add    $0x10,%esp
}
  802f41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f44:	c9                   	leave  
  802f45:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802f46:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802f4b:	8b 40 48             	mov    0x48(%eax),%eax
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	53                   	push   %ebx
  802f52:	50                   	push   %eax
  802f53:	68 a9 49 80 00       	push   $0x8049a9
  802f58:	e8 7a ed ff ff       	call   801cd7 <cprintf>
		return -E_INVAL;
  802f5d:	83 c4 10             	add    $0x10,%esp
  802f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802f65:	eb da                	jmp    802f41 <write+0x59>
		return -E_NOT_SUPP;
  802f67:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f6c:	eb d3                	jmp    802f41 <write+0x59>

00802f6e <seek>:

int
seek(int fdnum, off_t offset)
{
  802f6e:	f3 0f 1e fb          	endbr32 
  802f72:	55                   	push   %ebp
  802f73:	89 e5                	mov    %esp,%ebp
  802f75:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f7b:	50                   	push   %eax
  802f7c:	ff 75 08             	pushl  0x8(%ebp)
  802f7f:	e8 06 fc ff ff       	call   802b8a <fd_lookup>
  802f84:	83 c4 10             	add    $0x10,%esp
  802f87:	85 c0                	test   %eax,%eax
  802f89:	78 0e                	js     802f99 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  802f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f99:	c9                   	leave  
  802f9a:	c3                   	ret    

00802f9b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f9b:	f3 0f 1e fb          	endbr32 
  802f9f:	55                   	push   %ebp
  802fa0:	89 e5                	mov    %esp,%ebp
  802fa2:	53                   	push   %ebx
  802fa3:	83 ec 1c             	sub    $0x1c,%esp
  802fa6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fa9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802fac:	50                   	push   %eax
  802fad:	53                   	push   %ebx
  802fae:	e8 d7 fb ff ff       	call   802b8a <fd_lookup>
  802fb3:	83 c4 10             	add    $0x10,%esp
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	78 37                	js     802ff1 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fba:	83 ec 08             	sub    $0x8,%esp
  802fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fc0:	50                   	push   %eax
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	ff 30                	pushl  (%eax)
  802fc6:	e8 13 fc ff ff       	call   802bde <dev_lookup>
  802fcb:	83 c4 10             	add    $0x10,%esp
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	78 1f                	js     802ff1 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802fd9:	74 1b                	je     802ff6 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fde:	8b 52 18             	mov    0x18(%edx),%edx
  802fe1:	85 d2                	test   %edx,%edx
  802fe3:	74 32                	je     803017 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802fe5:	83 ec 08             	sub    $0x8,%esp
  802fe8:	ff 75 0c             	pushl  0xc(%ebp)
  802feb:	50                   	push   %eax
  802fec:	ff d2                	call   *%edx
  802fee:	83 c4 10             	add    $0x10,%esp
}
  802ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ff4:	c9                   	leave  
  802ff5:	c3                   	ret    
			thisenv->env_id, fdnum);
  802ff6:	a1 10 a0 80 00       	mov    0x80a010,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ffb:	8b 40 48             	mov    0x48(%eax),%eax
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	53                   	push   %ebx
  803002:	50                   	push   %eax
  803003:	68 6c 49 80 00       	push   $0x80496c
  803008:	e8 ca ec ff ff       	call   801cd7 <cprintf>
		return -E_INVAL;
  80300d:	83 c4 10             	add    $0x10,%esp
  803010:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803015:	eb da                	jmp    802ff1 <ftruncate+0x56>
		return -E_NOT_SUPP;
  803017:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80301c:	eb d3                	jmp    802ff1 <ftruncate+0x56>

0080301e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80301e:	f3 0f 1e fb          	endbr32 
  803022:	55                   	push   %ebp
  803023:	89 e5                	mov    %esp,%ebp
  803025:	53                   	push   %ebx
  803026:	83 ec 1c             	sub    $0x1c,%esp
  803029:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80302c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80302f:	50                   	push   %eax
  803030:	ff 75 08             	pushl  0x8(%ebp)
  803033:	e8 52 fb ff ff       	call   802b8a <fd_lookup>
  803038:	83 c4 10             	add    $0x10,%esp
  80303b:	85 c0                	test   %eax,%eax
  80303d:	78 4b                	js     80308a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80303f:	83 ec 08             	sub    $0x8,%esp
  803042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803045:	50                   	push   %eax
  803046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803049:	ff 30                	pushl  (%eax)
  80304b:	e8 8e fb ff ff       	call   802bde <dev_lookup>
  803050:	83 c4 10             	add    $0x10,%esp
  803053:	85 c0                	test   %eax,%eax
  803055:	78 33                	js     80308a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80305e:	74 2f                	je     80308f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803060:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803063:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80306a:	00 00 00 
	stat->st_isdir = 0;
  80306d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803074:	00 00 00 
	stat->st_dev = dev;
  803077:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80307d:	83 ec 08             	sub    $0x8,%esp
  803080:	53                   	push   %ebx
  803081:	ff 75 f0             	pushl  -0x10(%ebp)
  803084:	ff 50 14             	call   *0x14(%eax)
  803087:	83 c4 10             	add    $0x10,%esp
}
  80308a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80308d:	c9                   	leave  
  80308e:	c3                   	ret    
		return -E_NOT_SUPP;
  80308f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803094:	eb f4                	jmp    80308a <fstat+0x6c>

00803096 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803096:	f3 0f 1e fb          	endbr32 
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
  80309d:	56                   	push   %esi
  80309e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80309f:	83 ec 08             	sub    $0x8,%esp
  8030a2:	6a 00                	push   $0x0
  8030a4:	ff 75 08             	pushl  0x8(%ebp)
  8030a7:	e8 fb 01 00 00       	call   8032a7 <open>
  8030ac:	89 c3                	mov    %eax,%ebx
  8030ae:	83 c4 10             	add    $0x10,%esp
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	78 1b                	js     8030d0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8030b5:	83 ec 08             	sub    $0x8,%esp
  8030b8:	ff 75 0c             	pushl  0xc(%ebp)
  8030bb:	50                   	push   %eax
  8030bc:	e8 5d ff ff ff       	call   80301e <fstat>
  8030c1:	89 c6                	mov    %eax,%esi
	close(fd);
  8030c3:	89 1c 24             	mov    %ebx,(%esp)
  8030c6:	e8 fd fb ff ff       	call   802cc8 <close>
	return r;
  8030cb:	83 c4 10             	add    $0x10,%esp
  8030ce:	89 f3                	mov    %esi,%ebx
}
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030d5:	5b                   	pop    %ebx
  8030d6:	5e                   	pop    %esi
  8030d7:	5d                   	pop    %ebp
  8030d8:	c3                   	ret    

008030d9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
  8030dc:	56                   	push   %esi
  8030dd:	53                   	push   %ebx
  8030de:	89 c6                	mov    %eax,%esi
  8030e0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8030e2:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  8030e9:	74 27                	je     803112 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8030eb:	6a 07                	push   $0x7
  8030ed:	68 00 b0 80 00       	push   $0x80b000
  8030f2:	56                   	push   %esi
  8030f3:	ff 35 00 a0 80 00    	pushl  0x80a000
  8030f9:	e8 72 f9 ff ff       	call   802a70 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8030fe:	83 c4 0c             	add    $0xc,%esp
  803101:	6a 00                	push   $0x0
  803103:	53                   	push   %ebx
  803104:	6a 00                	push   $0x0
  803106:	e8 f1 f8 ff ff       	call   8029fc <ipc_recv>
}
  80310b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80310e:	5b                   	pop    %ebx
  80310f:	5e                   	pop    %esi
  803110:	5d                   	pop    %ebp
  803111:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803112:	83 ec 0c             	sub    $0xc,%esp
  803115:	6a 01                	push   $0x1
  803117:	e8 ac f9 ff ff       	call   802ac8 <ipc_find_env>
  80311c:	a3 00 a0 80 00       	mov    %eax,0x80a000
  803121:	83 c4 10             	add    $0x10,%esp
  803124:	eb c5                	jmp    8030eb <fsipc+0x12>

00803126 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803126:	f3 0f 1e fb          	endbr32 
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
  80312d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 40 0c             	mov    0xc(%eax),%eax
  803136:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  80313b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313e:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803143:	ba 00 00 00 00       	mov    $0x0,%edx
  803148:	b8 02 00 00 00       	mov    $0x2,%eax
  80314d:	e8 87 ff ff ff       	call   8030d9 <fsipc>
}
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <devfile_flush>:
{
  803154:	f3 0f 1e fb          	endbr32 
  803158:	55                   	push   %ebp
  803159:	89 e5                	mov    %esp,%ebp
  80315b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  803169:	ba 00 00 00 00       	mov    $0x0,%edx
  80316e:	b8 06 00 00 00       	mov    $0x6,%eax
  803173:	e8 61 ff ff ff       	call   8030d9 <fsipc>
}
  803178:	c9                   	leave  
  803179:	c3                   	ret    

0080317a <devfile_stat>:
{
  80317a:	f3 0f 1e fb          	endbr32 
  80317e:	55                   	push   %ebp
  80317f:	89 e5                	mov    %esp,%ebp
  803181:	53                   	push   %ebx
  803182:	83 ec 04             	sub    $0x4,%esp
  803185:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 40 0c             	mov    0xc(%eax),%eax
  80318e:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803193:	ba 00 00 00 00       	mov    $0x0,%edx
  803198:	b8 05 00 00 00       	mov    $0x5,%eax
  80319d:	e8 37 ff ff ff       	call   8030d9 <fsipc>
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	78 2c                	js     8031d2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031a6:	83 ec 08             	sub    $0x8,%esp
  8031a9:	68 00 b0 80 00       	push   $0x80b000
  8031ae:	53                   	push   %ebx
  8031af:	e8 2d f1 ff ff       	call   8022e1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8031b4:	a1 80 b0 80 00       	mov    0x80b080,%eax
  8031b9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8031bf:	a1 84 b0 80 00       	mov    0x80b084,%eax
  8031c4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8031ca:	83 c4 10             	add    $0x10,%esp
  8031cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <devfile_write>:
{
  8031d7:	f3 0f 1e fb          	endbr32 
  8031db:	55                   	push   %ebp
  8031dc:	89 e5                	mov    %esp,%ebp
  8031de:	83 ec 0c             	sub    $0xc,%esp
  8031e1:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8031e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8031ea:	89 15 00 b0 80 00    	mov    %edx,0x80b000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8031f0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8031f5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031fa:	0f 47 c2             	cmova  %edx,%eax
  8031fd:	a3 04 b0 80 00       	mov    %eax,0x80b004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  803202:	50                   	push   %eax
  803203:	ff 75 0c             	pushl  0xc(%ebp)
  803206:	68 08 b0 80 00       	push   $0x80b008
  80320b:	e8 87 f2 ff ff       	call   802497 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  803210:	ba 00 00 00 00       	mov    $0x0,%edx
  803215:	b8 04 00 00 00       	mov    $0x4,%eax
  80321a:	e8 ba fe ff ff       	call   8030d9 <fsipc>
}
  80321f:	c9                   	leave  
  803220:	c3                   	ret    

00803221 <devfile_read>:
{
  803221:	f3 0f 1e fb          	endbr32 
  803225:	55                   	push   %ebp
  803226:	89 e5                	mov    %esp,%ebp
  803228:	56                   	push   %esi
  803229:	53                   	push   %ebx
  80322a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 40 0c             	mov    0xc(%eax),%eax
  803233:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  803238:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80323e:	ba 00 00 00 00       	mov    $0x0,%edx
  803243:	b8 03 00 00 00       	mov    $0x3,%eax
  803248:	e8 8c fe ff ff       	call   8030d9 <fsipc>
  80324d:	89 c3                	mov    %eax,%ebx
  80324f:	85 c0                	test   %eax,%eax
  803251:	78 1f                	js     803272 <devfile_read+0x51>
	assert(r <= n);
  803253:	39 f0                	cmp    %esi,%eax
  803255:	77 24                	ja     80327b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  803257:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80325c:	7f 33                	jg     803291 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80325e:	83 ec 04             	sub    $0x4,%esp
  803261:	50                   	push   %eax
  803262:	68 00 b0 80 00       	push   $0x80b000
  803267:	ff 75 0c             	pushl  0xc(%ebp)
  80326a:	e8 28 f2 ff ff       	call   802497 <memmove>
	return r;
  80326f:	83 c4 10             	add    $0x10,%esp
}
  803272:	89 d8                	mov    %ebx,%eax
  803274:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5d                   	pop    %ebp
  80327a:	c3                   	ret    
	assert(r <= n);
  80327b:	68 dc 49 80 00       	push   $0x8049dc
  803280:	68 fd 3f 80 00       	push   $0x803ffd
  803285:	6a 7c                	push   $0x7c
  803287:	68 e3 49 80 00       	push   $0x8049e3
  80328c:	e8 5f e9 ff ff       	call   801bf0 <_panic>
	assert(r <= PGSIZE);
  803291:	68 ee 49 80 00       	push   $0x8049ee
  803296:	68 fd 3f 80 00       	push   $0x803ffd
  80329b:	6a 7d                	push   $0x7d
  80329d:	68 e3 49 80 00       	push   $0x8049e3
  8032a2:	e8 49 e9 ff ff       	call   801bf0 <_panic>

008032a7 <open>:
{
  8032a7:	f3 0f 1e fb          	endbr32 
  8032ab:	55                   	push   %ebp
  8032ac:	89 e5                	mov    %esp,%ebp
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8032b6:	56                   	push   %esi
  8032b7:	e8 e2 ef ff ff       	call   80229e <strlen>
  8032bc:	83 c4 10             	add    $0x10,%esp
  8032bf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8032c4:	7f 6c                	jg     803332 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8032c6:	83 ec 0c             	sub    $0xc,%esp
  8032c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032cc:	50                   	push   %eax
  8032cd:	e8 62 f8 ff ff       	call   802b34 <fd_alloc>
  8032d2:	89 c3                	mov    %eax,%ebx
  8032d4:	83 c4 10             	add    $0x10,%esp
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	78 3c                	js     803317 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8032db:	83 ec 08             	sub    $0x8,%esp
  8032de:	56                   	push   %esi
  8032df:	68 00 b0 80 00       	push   $0x80b000
  8032e4:	e8 f8 ef ff ff       	call   8022e1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8032e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ec:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8032f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f9:	e8 db fd ff ff       	call   8030d9 <fsipc>
  8032fe:	89 c3                	mov    %eax,%ebx
  803300:	83 c4 10             	add    $0x10,%esp
  803303:	85 c0                	test   %eax,%eax
  803305:	78 19                	js     803320 <open+0x79>
	return fd2num(fd);
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 f4             	pushl  -0xc(%ebp)
  80330d:	e8 f3 f7 ff ff       	call   802b05 <fd2num>
  803312:	89 c3                	mov    %eax,%ebx
  803314:	83 c4 10             	add    $0x10,%esp
}
  803317:	89 d8                	mov    %ebx,%eax
  803319:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80331c:	5b                   	pop    %ebx
  80331d:	5e                   	pop    %esi
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    
		fd_close(fd, 0);
  803320:	83 ec 08             	sub    $0x8,%esp
  803323:	6a 00                	push   $0x0
  803325:	ff 75 f4             	pushl  -0xc(%ebp)
  803328:	e8 10 f9 ff ff       	call   802c3d <fd_close>
		return r;
  80332d:	83 c4 10             	add    $0x10,%esp
  803330:	eb e5                	jmp    803317 <open+0x70>
		return -E_BAD_PATH;
  803332:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803337:	eb de                	jmp    803317 <open+0x70>

00803339 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  803339:	f3 0f 1e fb          	endbr32 
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
  803340:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803343:	ba 00 00 00 00       	mov    $0x0,%edx
  803348:	b8 08 00 00 00       	mov    $0x8,%eax
  80334d:	e8 87 fd ff ff       	call   8030d9 <fsipc>
}
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803354:	f3 0f 1e fb          	endbr32 
  803358:	55                   	push   %ebp
  803359:	89 e5                	mov    %esp,%ebp
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80335e:	89 c2                	mov    %eax,%edx
  803360:	c1 ea 16             	shr    $0x16,%edx
  803363:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80336a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80336f:	f6 c1 01             	test   $0x1,%cl
  803372:	74 1c                	je     803390 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  803374:	c1 e8 0c             	shr    $0xc,%eax
  803377:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80337e:	a8 01                	test   $0x1,%al
  803380:	74 0e                	je     803390 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803382:	c1 e8 0c             	shr    $0xc,%eax
  803385:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80338c:	ef 
  80338d:	0f b7 d2             	movzwl %dx,%edx
}
  803390:	89 d0                	mov    %edx,%eax
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    

00803394 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803394:	f3 0f 1e fb          	endbr32 
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
  80339b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80339e:	68 fa 49 80 00       	push   $0x8049fa
  8033a3:	ff 75 0c             	pushl  0xc(%ebp)
  8033a6:	e8 36 ef ff ff       	call   8022e1 <strcpy>
	return 0;
}
  8033ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <devsock_close>:
{
  8033b2:	f3 0f 1e fb          	endbr32 
  8033b6:	55                   	push   %ebp
  8033b7:	89 e5                	mov    %esp,%ebp
  8033b9:	53                   	push   %ebx
  8033ba:	83 ec 10             	sub    $0x10,%esp
  8033bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8033c0:	53                   	push   %ebx
  8033c1:	e8 8e ff ff ff       	call   803354 <pageref>
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8033cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8033d0:	83 fa 01             	cmp    $0x1,%edx
  8033d3:	74 05                	je     8033da <devsock_close+0x28>
}
  8033d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033d8:	c9                   	leave  
  8033d9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8033da:	83 ec 0c             	sub    $0xc,%esp
  8033dd:	ff 73 0c             	pushl  0xc(%ebx)
  8033e0:	e8 e3 02 00 00       	call   8036c8 <nsipc_close>
  8033e5:	83 c4 10             	add    $0x10,%esp
  8033e8:	eb eb                	jmp    8033d5 <devsock_close+0x23>

008033ea <devsock_write>:
{
  8033ea:	f3 0f 1e fb          	endbr32 
  8033ee:	55                   	push   %ebp
  8033ef:	89 e5                	mov    %esp,%ebp
  8033f1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033f4:	6a 00                	push   $0x0
  8033f6:	ff 75 10             	pushl  0x10(%ebp)
  8033f9:	ff 75 0c             	pushl  0xc(%ebp)
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	ff 70 0c             	pushl  0xc(%eax)
  803402:	e8 b5 03 00 00       	call   8037bc <nsipc_send>
}
  803407:	c9                   	leave  
  803408:	c3                   	ret    

00803409 <devsock_read>:
{
  803409:	f3 0f 1e fb          	endbr32 
  80340d:	55                   	push   %ebp
  80340e:	89 e5                	mov    %esp,%ebp
  803410:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803413:	6a 00                	push   $0x0
  803415:	ff 75 10             	pushl  0x10(%ebp)
  803418:	ff 75 0c             	pushl  0xc(%ebp)
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	ff 70 0c             	pushl  0xc(%eax)
  803421:	e8 1f 03 00 00       	call   803745 <nsipc_recv>
}
  803426:	c9                   	leave  
  803427:	c3                   	ret    

00803428 <fd2sockid>:
{
  803428:	55                   	push   %ebp
  803429:	89 e5                	mov    %esp,%ebp
  80342b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80342e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803431:	52                   	push   %edx
  803432:	50                   	push   %eax
  803433:	e8 52 f7 ff ff       	call   802b8a <fd_lookup>
  803438:	83 c4 10             	add    $0x10,%esp
  80343b:	85 c0                	test   %eax,%eax
  80343d:	78 10                	js     80344f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  803448:	39 08                	cmp    %ecx,(%eax)
  80344a:	75 05                	jne    803451 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80344c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80344f:	c9                   	leave  
  803450:	c3                   	ret    
		return -E_NOT_SUPP;
  803451:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803456:	eb f7                	jmp    80344f <fd2sockid+0x27>

00803458 <alloc_sockfd>:
{
  803458:	55                   	push   %ebp
  803459:	89 e5                	mov    %esp,%ebp
  80345b:	56                   	push   %esi
  80345c:	53                   	push   %ebx
  80345d:	83 ec 1c             	sub    $0x1c,%esp
  803460:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  803462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803465:	50                   	push   %eax
  803466:	e8 c9 f6 ff ff       	call   802b34 <fd_alloc>
  80346b:	89 c3                	mov    %eax,%ebx
  80346d:	83 c4 10             	add    $0x10,%esp
  803470:	85 c0                	test   %eax,%eax
  803472:	78 43                	js     8034b7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803474:	83 ec 04             	sub    $0x4,%esp
  803477:	68 07 04 00 00       	push   $0x407
  80347c:	ff 75 f4             	pushl  -0xc(%ebp)
  80347f:	6a 00                	push   $0x0
  803481:	e8 9d f2 ff ff       	call   802723 <sys_page_alloc>
  803486:	89 c3                	mov    %eax,%ebx
  803488:	83 c4 10             	add    $0x10,%esp
  80348b:	85 c0                	test   %eax,%eax
  80348d:	78 28                	js     8034b7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803498:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8034a4:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8034a7:	83 ec 0c             	sub    $0xc,%esp
  8034aa:	50                   	push   %eax
  8034ab:	e8 55 f6 ff ff       	call   802b05 <fd2num>
  8034b0:	89 c3                	mov    %eax,%ebx
  8034b2:	83 c4 10             	add    $0x10,%esp
  8034b5:	eb 0c                	jmp    8034c3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8034b7:	83 ec 0c             	sub    $0xc,%esp
  8034ba:	56                   	push   %esi
  8034bb:	e8 08 02 00 00       	call   8036c8 <nsipc_close>
		return r;
  8034c0:	83 c4 10             	add    $0x10,%esp
}
  8034c3:	89 d8                	mov    %ebx,%eax
  8034c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034c8:	5b                   	pop    %ebx
  8034c9:	5e                   	pop    %esi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    

008034cc <accept>:
{
  8034cc:	f3 0f 1e fb          	endbr32 
  8034d0:	55                   	push   %ebp
  8034d1:	89 e5                	mov    %esp,%ebp
  8034d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	e8 4a ff ff ff       	call   803428 <fd2sockid>
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	78 1b                	js     8034fd <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034e2:	83 ec 04             	sub    $0x4,%esp
  8034e5:	ff 75 10             	pushl  0x10(%ebp)
  8034e8:	ff 75 0c             	pushl  0xc(%ebp)
  8034eb:	50                   	push   %eax
  8034ec:	e8 22 01 00 00       	call   803613 <nsipc_accept>
  8034f1:	83 c4 10             	add    $0x10,%esp
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	78 05                	js     8034fd <accept+0x31>
	return alloc_sockfd(r);
  8034f8:	e8 5b ff ff ff       	call   803458 <alloc_sockfd>
}
  8034fd:	c9                   	leave  
  8034fe:	c3                   	ret    

008034ff <bind>:
{
  8034ff:	f3 0f 1e fb          	endbr32 
  803503:	55                   	push   %ebp
  803504:	89 e5                	mov    %esp,%ebp
  803506:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	e8 17 ff ff ff       	call   803428 <fd2sockid>
  803511:	85 c0                	test   %eax,%eax
  803513:	78 12                	js     803527 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	ff 75 10             	pushl  0x10(%ebp)
  80351b:	ff 75 0c             	pushl  0xc(%ebp)
  80351e:	50                   	push   %eax
  80351f:	e8 45 01 00 00       	call   803669 <nsipc_bind>
  803524:	83 c4 10             	add    $0x10,%esp
}
  803527:	c9                   	leave  
  803528:	c3                   	ret    

00803529 <shutdown>:
{
  803529:	f3 0f 1e fb          	endbr32 
  80352d:	55                   	push   %ebp
  80352e:	89 e5                	mov    %esp,%ebp
  803530:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	e8 ed fe ff ff       	call   803428 <fd2sockid>
  80353b:	85 c0                	test   %eax,%eax
  80353d:	78 0f                	js     80354e <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80353f:	83 ec 08             	sub    $0x8,%esp
  803542:	ff 75 0c             	pushl  0xc(%ebp)
  803545:	50                   	push   %eax
  803546:	e8 57 01 00 00       	call   8036a2 <nsipc_shutdown>
  80354b:	83 c4 10             	add    $0x10,%esp
}
  80354e:	c9                   	leave  
  80354f:	c3                   	ret    

00803550 <connect>:
{
  803550:	f3 0f 1e fb          	endbr32 
  803554:	55                   	push   %ebp
  803555:	89 e5                	mov    %esp,%ebp
  803557:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	e8 c6 fe ff ff       	call   803428 <fd2sockid>
  803562:	85 c0                	test   %eax,%eax
  803564:	78 12                	js     803578 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	ff 75 10             	pushl  0x10(%ebp)
  80356c:	ff 75 0c             	pushl  0xc(%ebp)
  80356f:	50                   	push   %eax
  803570:	e8 71 01 00 00       	call   8036e6 <nsipc_connect>
  803575:	83 c4 10             	add    $0x10,%esp
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <listen>:
{
  80357a:	f3 0f 1e fb          	endbr32 
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
  803581:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	e8 9c fe ff ff       	call   803428 <fd2sockid>
  80358c:	85 c0                	test   %eax,%eax
  80358e:	78 0f                	js     80359f <listen+0x25>
	return nsipc_listen(r, backlog);
  803590:	83 ec 08             	sub    $0x8,%esp
  803593:	ff 75 0c             	pushl  0xc(%ebp)
  803596:	50                   	push   %eax
  803597:	e8 83 01 00 00       	call   80371f <nsipc_listen>
  80359c:	83 c4 10             	add    $0x10,%esp
}
  80359f:	c9                   	leave  
  8035a0:	c3                   	ret    

008035a1 <socket>:

int
socket(int domain, int type, int protocol)
{
  8035a1:	f3 0f 1e fb          	endbr32 
  8035a5:	55                   	push   %ebp
  8035a6:	89 e5                	mov    %esp,%ebp
  8035a8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8035ab:	ff 75 10             	pushl  0x10(%ebp)
  8035ae:	ff 75 0c             	pushl  0xc(%ebp)
  8035b1:	ff 75 08             	pushl  0x8(%ebp)
  8035b4:	e8 65 02 00 00       	call   80381e <nsipc_socket>
  8035b9:	83 c4 10             	add    $0x10,%esp
  8035bc:	85 c0                	test   %eax,%eax
  8035be:	78 05                	js     8035c5 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8035c0:	e8 93 fe ff ff       	call   803458 <alloc_sockfd>
}
  8035c5:	c9                   	leave  
  8035c6:	c3                   	ret    

008035c7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035c7:	55                   	push   %ebp
  8035c8:	89 e5                	mov    %esp,%ebp
  8035ca:	53                   	push   %ebx
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8035d0:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  8035d7:	74 26                	je     8035ff <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035d9:	6a 07                	push   $0x7
  8035db:	68 00 c0 80 00       	push   $0x80c000
  8035e0:	53                   	push   %ebx
  8035e1:	ff 35 04 a0 80 00    	pushl  0x80a004
  8035e7:	e8 84 f4 ff ff       	call   802a70 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8035ec:	83 c4 0c             	add    $0xc,%esp
  8035ef:	6a 00                	push   $0x0
  8035f1:	6a 00                	push   $0x0
  8035f3:	6a 00                	push   $0x0
  8035f5:	e8 02 f4 ff ff       	call   8029fc <ipc_recv>
}
  8035fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8035fd:	c9                   	leave  
  8035fe:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035ff:	83 ec 0c             	sub    $0xc,%esp
  803602:	6a 02                	push   $0x2
  803604:	e8 bf f4 ff ff       	call   802ac8 <ipc_find_env>
  803609:	a3 04 a0 80 00       	mov    %eax,0x80a004
  80360e:	83 c4 10             	add    $0x10,%esp
  803611:	eb c6                	jmp    8035d9 <nsipc+0x12>

00803613 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803613:	f3 0f 1e fb          	endbr32 
  803617:	55                   	push   %ebp
  803618:	89 e5                	mov    %esp,%ebp
  80361a:	56                   	push   %esi
  80361b:	53                   	push   %ebx
  80361c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803627:	8b 06                	mov    (%esi),%eax
  803629:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80362e:	b8 01 00 00 00       	mov    $0x1,%eax
  803633:	e8 8f ff ff ff       	call   8035c7 <nsipc>
  803638:	89 c3                	mov    %eax,%ebx
  80363a:	85 c0                	test   %eax,%eax
  80363c:	79 09                	jns    803647 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80363e:	89 d8                	mov    %ebx,%eax
  803640:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5d                   	pop    %ebp
  803646:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	ff 35 10 c0 80 00    	pushl  0x80c010
  803650:	68 00 c0 80 00       	push   $0x80c000
  803655:	ff 75 0c             	pushl  0xc(%ebp)
  803658:	e8 3a ee ff ff       	call   802497 <memmove>
		*addrlen = ret->ret_addrlen;
  80365d:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803662:	89 06                	mov    %eax,(%esi)
  803664:	83 c4 10             	add    $0x10,%esp
	return r;
  803667:	eb d5                	jmp    80363e <nsipc_accept+0x2b>

00803669 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803669:	f3 0f 1e fb          	endbr32 
  80366d:	55                   	push   %ebp
  80366e:	89 e5                	mov    %esp,%ebp
  803670:	53                   	push   %ebx
  803671:	83 ec 08             	sub    $0x8,%esp
  803674:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80367f:	53                   	push   %ebx
  803680:	ff 75 0c             	pushl  0xc(%ebp)
  803683:	68 04 c0 80 00       	push   $0x80c004
  803688:	e8 0a ee ff ff       	call   802497 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80368d:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803693:	b8 02 00 00 00       	mov    $0x2,%eax
  803698:	e8 2a ff ff ff       	call   8035c7 <nsipc>
}
  80369d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036a0:	c9                   	leave  
  8036a1:	c3                   	ret    

008036a2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036a2:	f3 0f 1e fb          	endbr32 
  8036a6:	55                   	push   %ebp
  8036a7:	89 e5                	mov    %esp,%ebp
  8036a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8036b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b7:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8036bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8036c1:	e8 01 ff ff ff       	call   8035c7 <nsipc>
}
  8036c6:	c9                   	leave  
  8036c7:	c3                   	ret    

008036c8 <nsipc_close>:

int
nsipc_close(int s)
{
  8036c8:	f3 0f 1e fb          	endbr32 
  8036cc:	55                   	push   %ebp
  8036cd:	89 e5                	mov    %esp,%ebp
  8036cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  8036da:	b8 04 00 00 00       	mov    $0x4,%eax
  8036df:	e8 e3 fe ff ff       	call   8035c7 <nsipc>
}
  8036e4:	c9                   	leave  
  8036e5:	c3                   	ret    

008036e6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036e6:	f3 0f 1e fb          	endbr32 
  8036ea:	55                   	push   %ebp
  8036eb:	89 e5                	mov    %esp,%ebp
  8036ed:	53                   	push   %ebx
  8036ee:	83 ec 08             	sub    $0x8,%esp
  8036f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036fc:	53                   	push   %ebx
  8036fd:	ff 75 0c             	pushl  0xc(%ebp)
  803700:	68 04 c0 80 00       	push   $0x80c004
  803705:	e8 8d ed ff ff       	call   802497 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80370a:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803710:	b8 05 00 00 00       	mov    $0x5,%eax
  803715:	e8 ad fe ff ff       	call   8035c7 <nsipc>
}
  80371a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80371d:	c9                   	leave  
  80371e:	c3                   	ret    

0080371f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80371f:	f3 0f 1e fb          	endbr32 
  803723:	55                   	push   %ebp
  803724:	89 e5                	mov    %esp,%ebp
  803726:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803731:	8b 45 0c             	mov    0xc(%ebp),%eax
  803734:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803739:	b8 06 00 00 00       	mov    $0x6,%eax
  80373e:	e8 84 fe ff ff       	call   8035c7 <nsipc>
}
  803743:	c9                   	leave  
  803744:	c3                   	ret    

00803745 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803745:	f3 0f 1e fb          	endbr32 
  803749:	55                   	push   %ebp
  80374a:	89 e5                	mov    %esp,%ebp
  80374c:	56                   	push   %esi
  80374d:	53                   	push   %ebx
  80374e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803759:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  80375f:	8b 45 14             	mov    0x14(%ebp),%eax
  803762:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803767:	b8 07 00 00 00       	mov    $0x7,%eax
  80376c:	e8 56 fe ff ff       	call   8035c7 <nsipc>
  803771:	89 c3                	mov    %eax,%ebx
  803773:	85 c0                	test   %eax,%eax
  803775:	78 26                	js     80379d <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  803777:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80377d:	b8 3f 06 00 00       	mov    $0x63f,%eax
  803782:	0f 4e c6             	cmovle %esi,%eax
  803785:	39 c3                	cmp    %eax,%ebx
  803787:	7f 1d                	jg     8037a6 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	53                   	push   %ebx
  80378d:	68 00 c0 80 00       	push   $0x80c000
  803792:	ff 75 0c             	pushl  0xc(%ebp)
  803795:	e8 fd ec ff ff       	call   802497 <memmove>
  80379a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80379d:	89 d8                	mov    %ebx,%eax
  80379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8037a2:	5b                   	pop    %ebx
  8037a3:	5e                   	pop    %esi
  8037a4:	5d                   	pop    %ebp
  8037a5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8037a6:	68 06 4a 80 00       	push   $0x804a06
  8037ab:	68 fd 3f 80 00       	push   $0x803ffd
  8037b0:	6a 62                	push   $0x62
  8037b2:	68 1b 4a 80 00       	push   $0x804a1b
  8037b7:	e8 34 e4 ff ff       	call   801bf0 <_panic>

008037bc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037bc:	f3 0f 1e fb          	endbr32 
  8037c0:	55                   	push   %ebp
  8037c1:	89 e5                	mov    %esp,%ebp
  8037c3:	53                   	push   %ebx
  8037c4:	83 ec 04             	sub    $0x4,%esp
  8037c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  8037d2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8037d8:	7f 2e                	jg     803808 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	53                   	push   %ebx
  8037de:	ff 75 0c             	pushl  0xc(%ebp)
  8037e1:	68 0c c0 80 00       	push   $0x80c00c
  8037e6:	e8 ac ec ff ff       	call   802497 <memmove>
	nsipcbuf.send.req_size = size;
  8037eb:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  8037f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8037f4:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  8037f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8037fe:	e8 c4 fd ff ff       	call   8035c7 <nsipc>
}
  803803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803806:	c9                   	leave  
  803807:	c3                   	ret    
	assert(size < 1600);
  803808:	68 27 4a 80 00       	push   $0x804a27
  80380d:	68 fd 3f 80 00       	push   $0x803ffd
  803812:	6a 6d                	push   $0x6d
  803814:	68 1b 4a 80 00       	push   $0x804a1b
  803819:	e8 d2 e3 ff ff       	call   801bf0 <_panic>

0080381e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80381e:	f3 0f 1e fb          	endbr32 
  803822:	55                   	push   %ebp
  803823:	89 e5                	mov    %esp,%ebp
  803825:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803830:	8b 45 0c             	mov    0xc(%ebp),%eax
  803833:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803838:	8b 45 10             	mov    0x10(%ebp),%eax
  80383b:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803840:	b8 09 00 00 00       	mov    $0x9,%eax
  803845:	e8 7d fd ff ff       	call   8035c7 <nsipc>
}
  80384a:	c9                   	leave  
  80384b:	c3                   	ret    

0080384c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80384c:	f3 0f 1e fb          	endbr32 
  803850:	55                   	push   %ebp
  803851:	89 e5                	mov    %esp,%ebp
  803853:	56                   	push   %esi
  803854:	53                   	push   %ebx
  803855:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803858:	83 ec 0c             	sub    $0xc,%esp
  80385b:	ff 75 08             	pushl  0x8(%ebp)
  80385e:	e8 b6 f2 ff ff       	call   802b19 <fd2data>
  803863:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803865:	83 c4 08             	add    $0x8,%esp
  803868:	68 33 4a 80 00       	push   $0x804a33
  80386d:	53                   	push   %ebx
  80386e:	e8 6e ea ff ff       	call   8022e1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803873:	8b 46 04             	mov    0x4(%esi),%eax
  803876:	2b 06                	sub    (%esi),%eax
  803878:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80387e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803885:	00 00 00 
	stat->st_dev = &devpipe;
  803888:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  80388f:	90 80 00 
	return 0;
}
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
  803897:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80389a:	5b                   	pop    %ebx
  80389b:	5e                   	pop    %esi
  80389c:	5d                   	pop    %ebp
  80389d:	c3                   	ret    

0080389e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80389e:	f3 0f 1e fb          	endbr32 
  8038a2:	55                   	push   %ebp
  8038a3:	89 e5                	mov    %esp,%ebp
  8038a5:	53                   	push   %ebx
  8038a6:	83 ec 0c             	sub    $0xc,%esp
  8038a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8038ac:	53                   	push   %ebx
  8038ad:	6a 00                	push   $0x0
  8038af:	e8 fc ee ff ff       	call   8027b0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8038b4:	89 1c 24             	mov    %ebx,(%esp)
  8038b7:	e8 5d f2 ff ff       	call   802b19 <fd2data>
  8038bc:	83 c4 08             	add    $0x8,%esp
  8038bf:	50                   	push   %eax
  8038c0:	6a 00                	push   $0x0
  8038c2:	e8 e9 ee ff ff       	call   8027b0 <sys_page_unmap>
}
  8038c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038ca:	c9                   	leave  
  8038cb:	c3                   	ret    

008038cc <_pipeisclosed>:
{
  8038cc:	55                   	push   %ebp
  8038cd:	89 e5                	mov    %esp,%ebp
  8038cf:	57                   	push   %edi
  8038d0:	56                   	push   %esi
  8038d1:	53                   	push   %ebx
  8038d2:	83 ec 1c             	sub    $0x1c,%esp
  8038d5:	89 c7                	mov    %eax,%edi
  8038d7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8038d9:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8038de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8038e1:	83 ec 0c             	sub    $0xc,%esp
  8038e4:	57                   	push   %edi
  8038e5:	e8 6a fa ff ff       	call   803354 <pageref>
  8038ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8038ed:	89 34 24             	mov    %esi,(%esp)
  8038f0:	e8 5f fa ff ff       	call   803354 <pageref>
		nn = thisenv->env_runs;
  8038f5:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  8038fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8038fe:	83 c4 10             	add    $0x10,%esp
  803901:	39 cb                	cmp    %ecx,%ebx
  803903:	74 1b                	je     803920 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803905:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803908:	75 cf                	jne    8038d9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80390a:	8b 42 58             	mov    0x58(%edx),%eax
  80390d:	6a 01                	push   $0x1
  80390f:	50                   	push   %eax
  803910:	53                   	push   %ebx
  803911:	68 3a 4a 80 00       	push   $0x804a3a
  803916:	e8 bc e3 ff ff       	call   801cd7 <cprintf>
  80391b:	83 c4 10             	add    $0x10,%esp
  80391e:	eb b9                	jmp    8038d9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803920:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803923:	0f 94 c0             	sete   %al
  803926:	0f b6 c0             	movzbl %al,%eax
}
  803929:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80392c:	5b                   	pop    %ebx
  80392d:	5e                   	pop    %esi
  80392e:	5f                   	pop    %edi
  80392f:	5d                   	pop    %ebp
  803930:	c3                   	ret    

00803931 <devpipe_write>:
{
  803931:	f3 0f 1e fb          	endbr32 
  803935:	55                   	push   %ebp
  803936:	89 e5                	mov    %esp,%ebp
  803938:	57                   	push   %edi
  803939:	56                   	push   %esi
  80393a:	53                   	push   %ebx
  80393b:	83 ec 28             	sub    $0x28,%esp
  80393e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803941:	56                   	push   %esi
  803942:	e8 d2 f1 ff ff       	call   802b19 <fd2data>
  803947:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  803949:	83 c4 10             	add    $0x10,%esp
  80394c:	bf 00 00 00 00       	mov    $0x0,%edi
  803951:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803954:	74 4f                	je     8039a5 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803956:	8b 43 04             	mov    0x4(%ebx),%eax
  803959:	8b 0b                	mov    (%ebx),%ecx
  80395b:	8d 51 20             	lea    0x20(%ecx),%edx
  80395e:	39 d0                	cmp    %edx,%eax
  803960:	72 14                	jb     803976 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  803962:	89 da                	mov    %ebx,%edx
  803964:	89 f0                	mov    %esi,%eax
  803966:	e8 61 ff ff ff       	call   8038cc <_pipeisclosed>
  80396b:	85 c0                	test   %eax,%eax
  80396d:	75 3b                	jne    8039aa <devpipe_write+0x79>
			sys_yield();
  80396f:	e8 8c ed ff ff       	call   802700 <sys_yield>
  803974:	eb e0                	jmp    803956 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803976:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803979:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80397d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803980:	89 c2                	mov    %eax,%edx
  803982:	c1 fa 1f             	sar    $0x1f,%edx
  803985:	89 d1                	mov    %edx,%ecx
  803987:	c1 e9 1b             	shr    $0x1b,%ecx
  80398a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80398d:	83 e2 1f             	and    $0x1f,%edx
  803990:	29 ca                	sub    %ecx,%edx
  803992:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  803996:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80399a:	83 c0 01             	add    $0x1,%eax
  80399d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8039a0:	83 c7 01             	add    $0x1,%edi
  8039a3:	eb ac                	jmp    803951 <devpipe_write+0x20>
	return i;
  8039a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8039a8:	eb 05                	jmp    8039af <devpipe_write+0x7e>
				return 0;
  8039aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8039b2:	5b                   	pop    %ebx
  8039b3:	5e                   	pop    %esi
  8039b4:	5f                   	pop    %edi
  8039b5:	5d                   	pop    %ebp
  8039b6:	c3                   	ret    

008039b7 <devpipe_read>:
{
  8039b7:	f3 0f 1e fb          	endbr32 
  8039bb:	55                   	push   %ebp
  8039bc:	89 e5                	mov    %esp,%ebp
  8039be:	57                   	push   %edi
  8039bf:	56                   	push   %esi
  8039c0:	53                   	push   %ebx
  8039c1:	83 ec 18             	sub    $0x18,%esp
  8039c4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8039c7:	57                   	push   %edi
  8039c8:	e8 4c f1 ff ff       	call   802b19 <fd2data>
  8039cd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8039cf:	83 c4 10             	add    $0x10,%esp
  8039d2:	be 00 00 00 00       	mov    $0x0,%esi
  8039d7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8039da:	75 14                	jne    8039f0 <devpipe_read+0x39>
	return i;
  8039dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8039df:	eb 02                	jmp    8039e3 <devpipe_read+0x2c>
				return i;
  8039e1:	89 f0                	mov    %esi,%eax
}
  8039e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8039e6:	5b                   	pop    %ebx
  8039e7:	5e                   	pop    %esi
  8039e8:	5f                   	pop    %edi
  8039e9:	5d                   	pop    %ebp
  8039ea:	c3                   	ret    
			sys_yield();
  8039eb:	e8 10 ed ff ff       	call   802700 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8039f0:	8b 03                	mov    (%ebx),%eax
  8039f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8039f5:	75 18                	jne    803a0f <devpipe_read+0x58>
			if (i > 0)
  8039f7:	85 f6                	test   %esi,%esi
  8039f9:	75 e6                	jne    8039e1 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8039fb:	89 da                	mov    %ebx,%edx
  8039fd:	89 f8                	mov    %edi,%eax
  8039ff:	e8 c8 fe ff ff       	call   8038cc <_pipeisclosed>
  803a04:	85 c0                	test   %eax,%eax
  803a06:	74 e3                	je     8039eb <devpipe_read+0x34>
				return 0;
  803a08:	b8 00 00 00 00       	mov    $0x0,%eax
  803a0d:	eb d4                	jmp    8039e3 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a0f:	99                   	cltd   
  803a10:	c1 ea 1b             	shr    $0x1b,%edx
  803a13:	01 d0                	add    %edx,%eax
  803a15:	83 e0 1f             	and    $0x1f,%eax
  803a18:	29 d0                	sub    %edx,%eax
  803a1a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803a1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a22:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803a25:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  803a28:	83 c6 01             	add    $0x1,%esi
  803a2b:	eb aa                	jmp    8039d7 <devpipe_read+0x20>

00803a2d <pipe>:
{
  803a2d:	f3 0f 1e fb          	endbr32 
  803a31:	55                   	push   %ebp
  803a32:	89 e5                	mov    %esp,%ebp
  803a34:	56                   	push   %esi
  803a35:	53                   	push   %ebx
  803a36:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a3c:	50                   	push   %eax
  803a3d:	e8 f2 f0 ff ff       	call   802b34 <fd_alloc>
  803a42:	89 c3                	mov    %eax,%ebx
  803a44:	83 c4 10             	add    $0x10,%esp
  803a47:	85 c0                	test   %eax,%eax
  803a49:	0f 88 23 01 00 00    	js     803b72 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a4f:	83 ec 04             	sub    $0x4,%esp
  803a52:	68 07 04 00 00       	push   $0x407
  803a57:	ff 75 f4             	pushl  -0xc(%ebp)
  803a5a:	6a 00                	push   $0x0
  803a5c:	e8 c2 ec ff ff       	call   802723 <sys_page_alloc>
  803a61:	89 c3                	mov    %eax,%ebx
  803a63:	83 c4 10             	add    $0x10,%esp
  803a66:	85 c0                	test   %eax,%eax
  803a68:	0f 88 04 01 00 00    	js     803b72 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  803a6e:	83 ec 0c             	sub    $0xc,%esp
  803a71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803a74:	50                   	push   %eax
  803a75:	e8 ba f0 ff ff       	call   802b34 <fd_alloc>
  803a7a:	89 c3                	mov    %eax,%ebx
  803a7c:	83 c4 10             	add    $0x10,%esp
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	0f 88 db 00 00 00    	js     803b62 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a87:	83 ec 04             	sub    $0x4,%esp
  803a8a:	68 07 04 00 00       	push   $0x407
  803a8f:	ff 75 f0             	pushl  -0x10(%ebp)
  803a92:	6a 00                	push   $0x0
  803a94:	e8 8a ec ff ff       	call   802723 <sys_page_alloc>
  803a99:	89 c3                	mov    %eax,%ebx
  803a9b:	83 c4 10             	add    $0x10,%esp
  803a9e:	85 c0                	test   %eax,%eax
  803aa0:	0f 88 bc 00 00 00    	js     803b62 <pipe+0x135>
	va = fd2data(fd0);
  803aa6:	83 ec 0c             	sub    $0xc,%esp
  803aa9:	ff 75 f4             	pushl  -0xc(%ebp)
  803aac:	e8 68 f0 ff ff       	call   802b19 <fd2data>
  803ab1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ab3:	83 c4 0c             	add    $0xc,%esp
  803ab6:	68 07 04 00 00       	push   $0x407
  803abb:	50                   	push   %eax
  803abc:	6a 00                	push   $0x0
  803abe:	e8 60 ec ff ff       	call   802723 <sys_page_alloc>
  803ac3:	89 c3                	mov    %eax,%ebx
  803ac5:	83 c4 10             	add    $0x10,%esp
  803ac8:	85 c0                	test   %eax,%eax
  803aca:	0f 88 82 00 00 00    	js     803b52 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ad0:	83 ec 0c             	sub    $0xc,%esp
  803ad3:	ff 75 f0             	pushl  -0x10(%ebp)
  803ad6:	e8 3e f0 ff ff       	call   802b19 <fd2data>
  803adb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803ae2:	50                   	push   %eax
  803ae3:	6a 00                	push   $0x0
  803ae5:	56                   	push   %esi
  803ae6:	6a 00                	push   $0x0
  803ae8:	e8 7d ec ff ff       	call   80276a <sys_page_map>
  803aed:	89 c3                	mov    %eax,%ebx
  803aef:	83 c4 20             	add    $0x20,%esp
  803af2:	85 c0                	test   %eax,%eax
  803af4:	78 4e                	js     803b44 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  803af6:	a1 9c 90 80 00       	mov    0x80909c,%eax
  803afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803afe:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  803b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b03:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  803b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b0d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  803b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b12:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803b19:	83 ec 0c             	sub    $0xc,%esp
  803b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  803b1f:	e8 e1 ef ff ff       	call   802b05 <fd2num>
  803b24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803b27:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803b29:	83 c4 04             	add    $0x4,%esp
  803b2c:	ff 75 f0             	pushl  -0x10(%ebp)
  803b2f:	e8 d1 ef ff ff       	call   802b05 <fd2num>
  803b34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803b37:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803b3a:	83 c4 10             	add    $0x10,%esp
  803b3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  803b42:	eb 2e                	jmp    803b72 <pipe+0x145>
	sys_page_unmap(0, va);
  803b44:	83 ec 08             	sub    $0x8,%esp
  803b47:	56                   	push   %esi
  803b48:	6a 00                	push   $0x0
  803b4a:	e8 61 ec ff ff       	call   8027b0 <sys_page_unmap>
  803b4f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803b52:	83 ec 08             	sub    $0x8,%esp
  803b55:	ff 75 f0             	pushl  -0x10(%ebp)
  803b58:	6a 00                	push   $0x0
  803b5a:	e8 51 ec ff ff       	call   8027b0 <sys_page_unmap>
  803b5f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  803b62:	83 ec 08             	sub    $0x8,%esp
  803b65:	ff 75 f4             	pushl  -0xc(%ebp)
  803b68:	6a 00                	push   $0x0
  803b6a:	e8 41 ec ff ff       	call   8027b0 <sys_page_unmap>
  803b6f:	83 c4 10             	add    $0x10,%esp
}
  803b72:	89 d8                	mov    %ebx,%eax
  803b74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803b77:	5b                   	pop    %ebx
  803b78:	5e                   	pop    %esi
  803b79:	5d                   	pop    %ebp
  803b7a:	c3                   	ret    

00803b7b <pipeisclosed>:
{
  803b7b:	f3 0f 1e fb          	endbr32 
  803b7f:	55                   	push   %ebp
  803b80:	89 e5                	mov    %esp,%ebp
  803b82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803b88:	50                   	push   %eax
  803b89:	ff 75 08             	pushl  0x8(%ebp)
  803b8c:	e8 f9 ef ff ff       	call   802b8a <fd_lookup>
  803b91:	83 c4 10             	add    $0x10,%esp
  803b94:	85 c0                	test   %eax,%eax
  803b96:	78 18                	js     803bb0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  803b98:	83 ec 0c             	sub    $0xc,%esp
  803b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  803b9e:	e8 76 ef ff ff       	call   802b19 <fd2data>
  803ba3:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	e8 1f fd ff ff       	call   8038cc <_pipeisclosed>
  803bad:	83 c4 10             	add    $0x10,%esp
}
  803bb0:	c9                   	leave  
  803bb1:	c3                   	ret    

00803bb2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803bb2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  803bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bbb:	c3                   	ret    

00803bbc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803bbc:	f3 0f 1e fb          	endbr32 
  803bc0:	55                   	push   %ebp
  803bc1:	89 e5                	mov    %esp,%ebp
  803bc3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803bc6:	68 52 4a 80 00       	push   $0x804a52
  803bcb:	ff 75 0c             	pushl  0xc(%ebp)
  803bce:	e8 0e e7 ff ff       	call   8022e1 <strcpy>
	return 0;
}
  803bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bd8:	c9                   	leave  
  803bd9:	c3                   	ret    

00803bda <devcons_write>:
{
  803bda:	f3 0f 1e fb          	endbr32 
  803bde:	55                   	push   %ebp
  803bdf:	89 e5                	mov    %esp,%ebp
  803be1:	57                   	push   %edi
  803be2:	56                   	push   %esi
  803be3:	53                   	push   %ebx
  803be4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  803bea:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  803bef:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803bf5:	3b 75 10             	cmp    0x10(%ebp),%esi
  803bf8:	73 31                	jae    803c2b <devcons_write+0x51>
		m = n - tot;
  803bfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803bfd:	29 f3                	sub    %esi,%ebx
  803bff:	83 fb 7f             	cmp    $0x7f,%ebx
  803c02:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803c07:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803c0a:	83 ec 04             	sub    $0x4,%esp
  803c0d:	53                   	push   %ebx
  803c0e:	89 f0                	mov    %esi,%eax
  803c10:	03 45 0c             	add    0xc(%ebp),%eax
  803c13:	50                   	push   %eax
  803c14:	57                   	push   %edi
  803c15:	e8 7d e8 ff ff       	call   802497 <memmove>
		sys_cputs(buf, m);
  803c1a:	83 c4 08             	add    $0x8,%esp
  803c1d:	53                   	push   %ebx
  803c1e:	57                   	push   %edi
  803c1f:	e8 2f ea ff ff       	call   802653 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803c24:	01 de                	add    %ebx,%esi
  803c26:	83 c4 10             	add    $0x10,%esp
  803c29:	eb ca                	jmp    803bf5 <devcons_write+0x1b>
}
  803c2b:	89 f0                	mov    %esi,%eax
  803c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803c30:	5b                   	pop    %ebx
  803c31:	5e                   	pop    %esi
  803c32:	5f                   	pop    %edi
  803c33:	5d                   	pop    %ebp
  803c34:	c3                   	ret    

00803c35 <devcons_read>:
{
  803c35:	f3 0f 1e fb          	endbr32 
  803c39:	55                   	push   %ebp
  803c3a:	89 e5                	mov    %esp,%ebp
  803c3c:	83 ec 08             	sub    $0x8,%esp
  803c3f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803c44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803c48:	74 21                	je     803c6b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  803c4a:	e8 26 ea ff ff       	call   802675 <sys_cgetc>
  803c4f:	85 c0                	test   %eax,%eax
  803c51:	75 07                	jne    803c5a <devcons_read+0x25>
		sys_yield();
  803c53:	e8 a8 ea ff ff       	call   802700 <sys_yield>
  803c58:	eb f0                	jmp    803c4a <devcons_read+0x15>
	if (c < 0)
  803c5a:	78 0f                	js     803c6b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  803c5c:	83 f8 04             	cmp    $0x4,%eax
  803c5f:	74 0c                	je     803c6d <devcons_read+0x38>
	*(char*)vbuf = c;
  803c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  803c64:	88 02                	mov    %al,(%edx)
	return 1;
  803c66:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803c6b:	c9                   	leave  
  803c6c:	c3                   	ret    
		return 0;
  803c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c72:	eb f7                	jmp    803c6b <devcons_read+0x36>

00803c74 <cputchar>:
{
  803c74:	f3 0f 1e fb          	endbr32 
  803c78:	55                   	push   %ebp
  803c79:	89 e5                	mov    %esp,%ebp
  803c7b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c81:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803c84:	6a 01                	push   $0x1
  803c86:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803c89:	50                   	push   %eax
  803c8a:	e8 c4 e9 ff ff       	call   802653 <sys_cputs>
}
  803c8f:	83 c4 10             	add    $0x10,%esp
  803c92:	c9                   	leave  
  803c93:	c3                   	ret    

00803c94 <getchar>:
{
  803c94:	f3 0f 1e fb          	endbr32 
  803c98:	55                   	push   %ebp
  803c99:	89 e5                	mov    %esp,%ebp
  803c9b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803c9e:	6a 01                	push   $0x1
  803ca0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803ca3:	50                   	push   %eax
  803ca4:	6a 00                	push   $0x0
  803ca6:	e8 67 f1 ff ff       	call   802e12 <read>
	if (r < 0)
  803cab:	83 c4 10             	add    $0x10,%esp
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	78 06                	js     803cb8 <getchar+0x24>
	if (r < 1)
  803cb2:	74 06                	je     803cba <getchar+0x26>
	return c;
  803cb4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803cb8:	c9                   	leave  
  803cb9:	c3                   	ret    
		return -E_EOF;
  803cba:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803cbf:	eb f7                	jmp    803cb8 <getchar+0x24>

00803cc1 <iscons>:
{
  803cc1:	f3 0f 1e fb          	endbr32 
  803cc5:	55                   	push   %ebp
  803cc6:	89 e5                	mov    %esp,%ebp
  803cc8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803cce:	50                   	push   %eax
  803ccf:	ff 75 08             	pushl  0x8(%ebp)
  803cd2:	e8 b3 ee ff ff       	call   802b8a <fd_lookup>
  803cd7:	83 c4 10             	add    $0x10,%esp
  803cda:	85 c0                	test   %eax,%eax
  803cdc:	78 11                	js     803cef <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  803cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce1:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803ce7:	39 10                	cmp    %edx,(%eax)
  803ce9:	0f 94 c0             	sete   %al
  803cec:	0f b6 c0             	movzbl %al,%eax
}
  803cef:	c9                   	leave  
  803cf0:	c3                   	ret    

00803cf1 <opencons>:
{
  803cf1:	f3 0f 1e fb          	endbr32 
  803cf5:	55                   	push   %ebp
  803cf6:	89 e5                	mov    %esp,%ebp
  803cf8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803cfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803cfe:	50                   	push   %eax
  803cff:	e8 30 ee ff ff       	call   802b34 <fd_alloc>
  803d04:	83 c4 10             	add    $0x10,%esp
  803d07:	85 c0                	test   %eax,%eax
  803d09:	78 3a                	js     803d45 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803d0b:	83 ec 04             	sub    $0x4,%esp
  803d0e:	68 07 04 00 00       	push   $0x407
  803d13:	ff 75 f4             	pushl  -0xc(%ebp)
  803d16:	6a 00                	push   $0x0
  803d18:	e8 06 ea ff ff       	call   802723 <sys_page_alloc>
  803d1d:	83 c4 10             	add    $0x10,%esp
  803d20:	85 c0                	test   %eax,%eax
  803d22:	78 21                	js     803d45 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d27:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803d2d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803d39:	83 ec 0c             	sub    $0xc,%esp
  803d3c:	50                   	push   %eax
  803d3d:	e8 c3 ed ff ff       	call   802b05 <fd2num>
  803d42:	83 c4 10             	add    $0x10,%esp
}
  803d45:	c9                   	leave  
  803d46:	c3                   	ret    
  803d47:	66 90                	xchg   %ax,%ax
  803d49:	66 90                	xchg   %ax,%ax
  803d4b:	66 90                	xchg   %ax,%ax
  803d4d:	66 90                	xchg   %ax,%ax
  803d4f:	90                   	nop

00803d50 <__udivdi3>:
  803d50:	f3 0f 1e fb          	endbr32 
  803d54:	55                   	push   %ebp
  803d55:	57                   	push   %edi
  803d56:	56                   	push   %esi
  803d57:	53                   	push   %ebx
  803d58:	83 ec 1c             	sub    $0x1c,%esp
  803d5b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803d5f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803d63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d67:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803d6b:	85 d2                	test   %edx,%edx
  803d6d:	75 19                	jne    803d88 <__udivdi3+0x38>
  803d6f:	39 f3                	cmp    %esi,%ebx
  803d71:	76 4d                	jbe    803dc0 <__udivdi3+0x70>
  803d73:	31 ff                	xor    %edi,%edi
  803d75:	89 e8                	mov    %ebp,%eax
  803d77:	89 f2                	mov    %esi,%edx
  803d79:	f7 f3                	div    %ebx
  803d7b:	89 fa                	mov    %edi,%edx
  803d7d:	83 c4 1c             	add    $0x1c,%esp
  803d80:	5b                   	pop    %ebx
  803d81:	5e                   	pop    %esi
  803d82:	5f                   	pop    %edi
  803d83:	5d                   	pop    %ebp
  803d84:	c3                   	ret    
  803d85:	8d 76 00             	lea    0x0(%esi),%esi
  803d88:	39 f2                	cmp    %esi,%edx
  803d8a:	76 14                	jbe    803da0 <__udivdi3+0x50>
  803d8c:	31 ff                	xor    %edi,%edi
  803d8e:	31 c0                	xor    %eax,%eax
  803d90:	89 fa                	mov    %edi,%edx
  803d92:	83 c4 1c             	add    $0x1c,%esp
  803d95:	5b                   	pop    %ebx
  803d96:	5e                   	pop    %esi
  803d97:	5f                   	pop    %edi
  803d98:	5d                   	pop    %ebp
  803d99:	c3                   	ret    
  803d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803da0:	0f bd fa             	bsr    %edx,%edi
  803da3:	83 f7 1f             	xor    $0x1f,%edi
  803da6:	75 48                	jne    803df0 <__udivdi3+0xa0>
  803da8:	39 f2                	cmp    %esi,%edx
  803daa:	72 06                	jb     803db2 <__udivdi3+0x62>
  803dac:	31 c0                	xor    %eax,%eax
  803dae:	39 eb                	cmp    %ebp,%ebx
  803db0:	77 de                	ja     803d90 <__udivdi3+0x40>
  803db2:	b8 01 00 00 00       	mov    $0x1,%eax
  803db7:	eb d7                	jmp    803d90 <__udivdi3+0x40>
  803db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803dc0:	89 d9                	mov    %ebx,%ecx
  803dc2:	85 db                	test   %ebx,%ebx
  803dc4:	75 0b                	jne    803dd1 <__udivdi3+0x81>
  803dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcb:	31 d2                	xor    %edx,%edx
  803dcd:	f7 f3                	div    %ebx
  803dcf:	89 c1                	mov    %eax,%ecx
  803dd1:	31 d2                	xor    %edx,%edx
  803dd3:	89 f0                	mov    %esi,%eax
  803dd5:	f7 f1                	div    %ecx
  803dd7:	89 c6                	mov    %eax,%esi
  803dd9:	89 e8                	mov    %ebp,%eax
  803ddb:	89 f7                	mov    %esi,%edi
  803ddd:	f7 f1                	div    %ecx
  803ddf:	89 fa                	mov    %edi,%edx
  803de1:	83 c4 1c             	add    $0x1c,%esp
  803de4:	5b                   	pop    %ebx
  803de5:	5e                   	pop    %esi
  803de6:	5f                   	pop    %edi
  803de7:	5d                   	pop    %ebp
  803de8:	c3                   	ret    
  803de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803df0:	89 f9                	mov    %edi,%ecx
  803df2:	b8 20 00 00 00       	mov    $0x20,%eax
  803df7:	29 f8                	sub    %edi,%eax
  803df9:	d3 e2                	shl    %cl,%edx
  803dfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  803dff:	89 c1                	mov    %eax,%ecx
  803e01:	89 da                	mov    %ebx,%edx
  803e03:	d3 ea                	shr    %cl,%edx
  803e05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803e09:	09 d1                	or     %edx,%ecx
  803e0b:	89 f2                	mov    %esi,%edx
  803e0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e11:	89 f9                	mov    %edi,%ecx
  803e13:	d3 e3                	shl    %cl,%ebx
  803e15:	89 c1                	mov    %eax,%ecx
  803e17:	d3 ea                	shr    %cl,%edx
  803e19:	89 f9                	mov    %edi,%ecx
  803e1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803e1f:	89 eb                	mov    %ebp,%ebx
  803e21:	d3 e6                	shl    %cl,%esi
  803e23:	89 c1                	mov    %eax,%ecx
  803e25:	d3 eb                	shr    %cl,%ebx
  803e27:	09 de                	or     %ebx,%esi
  803e29:	89 f0                	mov    %esi,%eax
  803e2b:	f7 74 24 08          	divl   0x8(%esp)
  803e2f:	89 d6                	mov    %edx,%esi
  803e31:	89 c3                	mov    %eax,%ebx
  803e33:	f7 64 24 0c          	mull   0xc(%esp)
  803e37:	39 d6                	cmp    %edx,%esi
  803e39:	72 15                	jb     803e50 <__udivdi3+0x100>
  803e3b:	89 f9                	mov    %edi,%ecx
  803e3d:	d3 e5                	shl    %cl,%ebp
  803e3f:	39 c5                	cmp    %eax,%ebp
  803e41:	73 04                	jae    803e47 <__udivdi3+0xf7>
  803e43:	39 d6                	cmp    %edx,%esi
  803e45:	74 09                	je     803e50 <__udivdi3+0x100>
  803e47:	89 d8                	mov    %ebx,%eax
  803e49:	31 ff                	xor    %edi,%edi
  803e4b:	e9 40 ff ff ff       	jmp    803d90 <__udivdi3+0x40>
  803e50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e53:	31 ff                	xor    %edi,%edi
  803e55:	e9 36 ff ff ff       	jmp    803d90 <__udivdi3+0x40>
  803e5a:	66 90                	xchg   %ax,%ax
  803e5c:	66 90                	xchg   %ax,%ax
  803e5e:	66 90                	xchg   %ax,%ax

00803e60 <__umoddi3>:
  803e60:	f3 0f 1e fb          	endbr32 
  803e64:	55                   	push   %ebp
  803e65:	57                   	push   %edi
  803e66:	56                   	push   %esi
  803e67:	53                   	push   %ebx
  803e68:	83 ec 1c             	sub    $0x1c,%esp
  803e6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  803e73:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e7b:	85 c0                	test   %eax,%eax
  803e7d:	75 19                	jne    803e98 <__umoddi3+0x38>
  803e7f:	39 df                	cmp    %ebx,%edi
  803e81:	76 5d                	jbe    803ee0 <__umoddi3+0x80>
  803e83:	89 f0                	mov    %esi,%eax
  803e85:	89 da                	mov    %ebx,%edx
  803e87:	f7 f7                	div    %edi
  803e89:	89 d0                	mov    %edx,%eax
  803e8b:	31 d2                	xor    %edx,%edx
  803e8d:	83 c4 1c             	add    $0x1c,%esp
  803e90:	5b                   	pop    %ebx
  803e91:	5e                   	pop    %esi
  803e92:	5f                   	pop    %edi
  803e93:	5d                   	pop    %ebp
  803e94:	c3                   	ret    
  803e95:	8d 76 00             	lea    0x0(%esi),%esi
  803e98:	89 f2                	mov    %esi,%edx
  803e9a:	39 d8                	cmp    %ebx,%eax
  803e9c:	76 12                	jbe    803eb0 <__umoddi3+0x50>
  803e9e:	89 f0                	mov    %esi,%eax
  803ea0:	89 da                	mov    %ebx,%edx
  803ea2:	83 c4 1c             	add    $0x1c,%esp
  803ea5:	5b                   	pop    %ebx
  803ea6:	5e                   	pop    %esi
  803ea7:	5f                   	pop    %edi
  803ea8:	5d                   	pop    %ebp
  803ea9:	c3                   	ret    
  803eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803eb0:	0f bd e8             	bsr    %eax,%ebp
  803eb3:	83 f5 1f             	xor    $0x1f,%ebp
  803eb6:	75 50                	jne    803f08 <__umoddi3+0xa8>
  803eb8:	39 d8                	cmp    %ebx,%eax
  803eba:	0f 82 e0 00 00 00    	jb     803fa0 <__umoddi3+0x140>
  803ec0:	89 d9                	mov    %ebx,%ecx
  803ec2:	39 f7                	cmp    %esi,%edi
  803ec4:	0f 86 d6 00 00 00    	jbe    803fa0 <__umoddi3+0x140>
  803eca:	89 d0                	mov    %edx,%eax
  803ecc:	89 ca                	mov    %ecx,%edx
  803ece:	83 c4 1c             	add    $0x1c,%esp
  803ed1:	5b                   	pop    %ebx
  803ed2:	5e                   	pop    %esi
  803ed3:	5f                   	pop    %edi
  803ed4:	5d                   	pop    %ebp
  803ed5:	c3                   	ret    
  803ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803edd:	8d 76 00             	lea    0x0(%esi),%esi
  803ee0:	89 fd                	mov    %edi,%ebp
  803ee2:	85 ff                	test   %edi,%edi
  803ee4:	75 0b                	jne    803ef1 <__umoddi3+0x91>
  803ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eeb:	31 d2                	xor    %edx,%edx
  803eed:	f7 f7                	div    %edi
  803eef:	89 c5                	mov    %eax,%ebp
  803ef1:	89 d8                	mov    %ebx,%eax
  803ef3:	31 d2                	xor    %edx,%edx
  803ef5:	f7 f5                	div    %ebp
  803ef7:	89 f0                	mov    %esi,%eax
  803ef9:	f7 f5                	div    %ebp
  803efb:	89 d0                	mov    %edx,%eax
  803efd:	31 d2                	xor    %edx,%edx
  803eff:	eb 8c                	jmp    803e8d <__umoddi3+0x2d>
  803f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f08:	89 e9                	mov    %ebp,%ecx
  803f0a:	ba 20 00 00 00       	mov    $0x20,%edx
  803f0f:	29 ea                	sub    %ebp,%edx
  803f11:	d3 e0                	shl    %cl,%eax
  803f13:	89 44 24 08          	mov    %eax,0x8(%esp)
  803f17:	89 d1                	mov    %edx,%ecx
  803f19:	89 f8                	mov    %edi,%eax
  803f1b:	d3 e8                	shr    %cl,%eax
  803f1d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803f21:	89 54 24 04          	mov    %edx,0x4(%esp)
  803f25:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f29:	09 c1                	or     %eax,%ecx
  803f2b:	89 d8                	mov    %ebx,%eax
  803f2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f31:	89 e9                	mov    %ebp,%ecx
  803f33:	d3 e7                	shl    %cl,%edi
  803f35:	89 d1                	mov    %edx,%ecx
  803f37:	d3 e8                	shr    %cl,%eax
  803f39:	89 e9                	mov    %ebp,%ecx
  803f3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f3f:	d3 e3                	shl    %cl,%ebx
  803f41:	89 c7                	mov    %eax,%edi
  803f43:	89 d1                	mov    %edx,%ecx
  803f45:	89 f0                	mov    %esi,%eax
  803f47:	d3 e8                	shr    %cl,%eax
  803f49:	89 e9                	mov    %ebp,%ecx
  803f4b:	89 fa                	mov    %edi,%edx
  803f4d:	d3 e6                	shl    %cl,%esi
  803f4f:	09 d8                	or     %ebx,%eax
  803f51:	f7 74 24 08          	divl   0x8(%esp)
  803f55:	89 d1                	mov    %edx,%ecx
  803f57:	89 f3                	mov    %esi,%ebx
  803f59:	f7 64 24 0c          	mull   0xc(%esp)
  803f5d:	89 c6                	mov    %eax,%esi
  803f5f:	89 d7                	mov    %edx,%edi
  803f61:	39 d1                	cmp    %edx,%ecx
  803f63:	72 06                	jb     803f6b <__umoddi3+0x10b>
  803f65:	75 10                	jne    803f77 <__umoddi3+0x117>
  803f67:	39 c3                	cmp    %eax,%ebx
  803f69:	73 0c                	jae    803f77 <__umoddi3+0x117>
  803f6b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  803f6f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  803f73:	89 d7                	mov    %edx,%edi
  803f75:	89 c6                	mov    %eax,%esi
  803f77:	89 ca                	mov    %ecx,%edx
  803f79:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803f7e:	29 f3                	sub    %esi,%ebx
  803f80:	19 fa                	sbb    %edi,%edx
  803f82:	89 d0                	mov    %edx,%eax
  803f84:	d3 e0                	shl    %cl,%eax
  803f86:	89 e9                	mov    %ebp,%ecx
  803f88:	d3 eb                	shr    %cl,%ebx
  803f8a:	d3 ea                	shr    %cl,%edx
  803f8c:	09 d8                	or     %ebx,%eax
  803f8e:	83 c4 1c             	add    $0x1c,%esp
  803f91:	5b                   	pop    %ebx
  803f92:	5e                   	pop    %esi
  803f93:	5f                   	pop    %edi
  803f94:	5d                   	pop    %ebp
  803f95:	c3                   	ret    
  803f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803f9d:	8d 76 00             	lea    0x0(%esi),%esi
  803fa0:	29 fe                	sub    %edi,%esi
  803fa2:	19 c3                	sbb    %eax,%ebx
  803fa4:	89 f2                	mov    %esi,%edx
  803fa6:	89 d9                	mov    %ebx,%ecx
  803fa8:	e9 1d ff ff ff       	jmp    803eca <__umoddi3+0x6a>
