
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003d:	c7 05 00 30 80 00 e0 	movl   $0x8023e0,0x803000
  800044:	23 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800047:	e8 17 01 00 00       	call   800163 <sys_yield>
  80004c:	eb f9                	jmp    800047 <umain+0x14>

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005d:	e8 de 00 00 00       	call   800140 <sys_getenvid>
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800074:	85 db                	test   %ebx,%ebx
  800076:	7e 07                	jle    80007f <libmain+0x31>
		binaryname = argv[0];
  800078:	8b 06                	mov    (%esi),%eax
  80007a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007f:	83 ec 08             	sub    $0x8,%esp
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	e8 aa ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800089:	e8 0a 00 00 00       	call   800098 <exit>
}
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	f3 0f 1e fb          	endbr32 
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a2:	e8 07 05 00 00       	call   8005ae <close_all>
	sys_env_destroy(0);
  8000a7:	83 ec 0c             	sub    $0xc,%esp
  8000aa:	6a 00                	push   $0x0
  8000ac:	e8 4a 00 00 00       	call   8000fb <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	c9                   	leave  
  8000b5:	c3                   	ret    

008000b6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b6:	f3 0f 1e fb          	endbr32 
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cb:	89 c3                	mov    %eax,%ebx
  8000cd:	89 c7                	mov    %eax,%edi
  8000cf:	89 c6                	mov    %eax,%esi
  8000d1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5f                   	pop    %edi
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d8:	f3 0f 1e fb          	endbr32 
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000ec:	89 d1                	mov    %edx,%ecx
  8000ee:	89 d3                	mov    %edx,%ebx
  8000f0:	89 d7                	mov    %edx,%edi
  8000f2:	89 d6                	mov    %edx,%esi
  8000f4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000fb:	f3 0f 1e fb          	endbr32 
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800108:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010d:	8b 55 08             	mov    0x8(%ebp),%edx
  800110:	b8 03 00 00 00       	mov    $0x3,%eax
  800115:	89 cb                	mov    %ecx,%ebx
  800117:	89 cf                	mov    %ecx,%edi
  800119:	89 ce                	mov    %ecx,%esi
  80011b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011d:	85 c0                	test   %eax,%eax
  80011f:	7f 08                	jg     800129 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5f                   	pop    %edi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	50                   	push   %eax
  80012d:	6a 03                	push   $0x3
  80012f:	68 ef 23 80 00       	push   $0x8023ef
  800134:	6a 23                	push   $0x23
  800136:	68 0c 24 80 00       	push   $0x80240c
  80013b:	e8 7c 14 00 00       	call   8015bc <_panic>

00800140 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800140:	f3 0f 1e fb          	endbr32 
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	57                   	push   %edi
  800148:	56                   	push   %esi
  800149:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014a:	ba 00 00 00 00       	mov    $0x0,%edx
  80014f:	b8 02 00 00 00       	mov    $0x2,%eax
  800154:	89 d1                	mov    %edx,%ecx
  800156:	89 d3                	mov    %edx,%ebx
  800158:	89 d7                	mov    %edx,%edi
  80015a:	89 d6                	mov    %edx,%esi
  80015c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015e:	5b                   	pop    %ebx
  80015f:	5e                   	pop    %esi
  800160:	5f                   	pop    %edi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <sys_yield>:

void
sys_yield(void)
{
  800163:	f3 0f 1e fb          	endbr32 
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016d:	ba 00 00 00 00       	mov    $0x0,%edx
  800172:	b8 0b 00 00 00       	mov    $0xb,%eax
  800177:	89 d1                	mov    %edx,%ecx
  800179:	89 d3                	mov    %edx,%ebx
  80017b:	89 d7                	mov    %edx,%edi
  80017d:	89 d6                	mov    %edx,%esi
  80017f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    

00800186 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800186:	f3 0f 1e fb          	endbr32 
  80018a:	55                   	push   %ebp
  80018b:	89 e5                	mov    %esp,%ebp
  80018d:	57                   	push   %edi
  80018e:	56                   	push   %esi
  80018f:	53                   	push   %ebx
  800190:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800193:	be 00 00 00 00       	mov    $0x0,%esi
  800198:	8b 55 08             	mov    0x8(%ebp),%edx
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a6:	89 f7                	mov    %esi,%edi
  8001a8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001aa:	85 c0                	test   %eax,%eax
  8001ac:	7f 08                	jg     8001b6 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5f                   	pop    %edi
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	6a 04                	push   $0x4
  8001bc:	68 ef 23 80 00       	push   $0x8023ef
  8001c1:	6a 23                	push   $0x23
  8001c3:	68 0c 24 80 00       	push   $0x80240c
  8001c8:	e8 ef 13 00 00       	call   8015bc <_panic>

008001cd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001cd:	f3 0f 1e fb          	endbr32 
  8001d1:	55                   	push   %ebp
  8001d2:	89 e5                	mov    %esp,%ebp
  8001d4:	57                   	push   %edi
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001da:	8b 55 08             	mov    0x8(%ebp),%edx
  8001dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	7f 08                	jg     8001fc <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	50                   	push   %eax
  800200:	6a 05                	push   $0x5
  800202:	68 ef 23 80 00       	push   $0x8023ef
  800207:	6a 23                	push   $0x23
  800209:	68 0c 24 80 00       	push   $0x80240c
  80020e:	e8 a9 13 00 00       	call   8015bc <_panic>

00800213 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800213:	f3 0f 1e fb          	endbr32 
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	57                   	push   %edi
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	8b 55 08             	mov    0x8(%ebp),%edx
  800228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022b:	b8 06 00 00 00       	mov    $0x6,%eax
  800230:	89 df                	mov    %ebx,%edi
  800232:	89 de                	mov    %ebx,%esi
  800234:	cd 30                	int    $0x30
	if(check && ret > 0)
  800236:	85 c0                	test   %eax,%eax
  800238:	7f 08                	jg     800242 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	50                   	push   %eax
  800246:	6a 06                	push   $0x6
  800248:	68 ef 23 80 00       	push   $0x8023ef
  80024d:	6a 23                	push   $0x23
  80024f:	68 0c 24 80 00       	push   $0x80240c
  800254:	e8 63 13 00 00       	call   8015bc <_panic>

00800259 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800259:	f3 0f 1e fb          	endbr32 
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	57                   	push   %edi
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800266:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026b:	8b 55 08             	mov    0x8(%ebp),%edx
  80026e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800271:	b8 08 00 00 00       	mov    $0x8,%eax
  800276:	89 df                	mov    %ebx,%edi
  800278:	89 de                	mov    %ebx,%esi
  80027a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80027c:	85 c0                	test   %eax,%eax
  80027e:	7f 08                	jg     800288 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800283:	5b                   	pop    %ebx
  800284:	5e                   	pop    %esi
  800285:	5f                   	pop    %edi
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	50                   	push   %eax
  80028c:	6a 08                	push   $0x8
  80028e:	68 ef 23 80 00       	push   $0x8023ef
  800293:	6a 23                	push   $0x23
  800295:	68 0c 24 80 00       	push   $0x80240c
  80029a:	e8 1d 13 00 00       	call   8015bc <_panic>

0080029f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029f:	f3 0f 1e fb          	endbr32 
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	57                   	push   %edi
  8002a7:	56                   	push   %esi
  8002a8:	53                   	push   %ebx
  8002a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002bc:	89 df                	mov    %ebx,%edi
  8002be:	89 de                	mov    %ebx,%esi
  8002c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	7f 08                	jg     8002ce <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c9:	5b                   	pop    %ebx
  8002ca:	5e                   	pop    %esi
  8002cb:	5f                   	pop    %edi
  8002cc:	5d                   	pop    %ebp
  8002cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	6a 09                	push   $0x9
  8002d4:	68 ef 23 80 00       	push   $0x8023ef
  8002d9:	6a 23                	push   $0x23
  8002db:	68 0c 24 80 00       	push   $0x80240c
  8002e0:	e8 d7 12 00 00       	call   8015bc <_panic>

008002e5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e5:	f3 0f 1e fb          	endbr32 
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	57                   	push   %edi
  8002ed:	56                   	push   %esi
  8002ee:	53                   	push   %ebx
  8002ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800302:	89 df                	mov    %ebx,%edi
  800304:	89 de                	mov    %ebx,%esi
  800306:	cd 30                	int    $0x30
	if(check && ret > 0)
  800308:	85 c0                	test   %eax,%eax
  80030a:	7f 08                	jg     800314 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030f:	5b                   	pop    %ebx
  800310:	5e                   	pop    %esi
  800311:	5f                   	pop    %edi
  800312:	5d                   	pop    %ebp
  800313:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800314:	83 ec 0c             	sub    $0xc,%esp
  800317:	50                   	push   %eax
  800318:	6a 0a                	push   $0xa
  80031a:	68 ef 23 80 00       	push   $0x8023ef
  80031f:	6a 23                	push   $0x23
  800321:	68 0c 24 80 00       	push   $0x80240c
  800326:	e8 91 12 00 00       	call   8015bc <_panic>

0080032b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032b:	f3 0f 1e fb          	endbr32 
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	57                   	push   %edi
  800333:	56                   	push   %esi
  800334:	53                   	push   %ebx
	asm volatile("int %1\n"
  800335:	8b 55 08             	mov    0x8(%ebp),%edx
  800338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800348:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    

00800352 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800352:	f3 0f 1e fb          	endbr32 
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	57                   	push   %edi
  80035a:	56                   	push   %esi
  80035b:	53                   	push   %ebx
  80035c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800364:	8b 55 08             	mov    0x8(%ebp),%edx
  800367:	b8 0d 00 00 00       	mov    $0xd,%eax
  80036c:	89 cb                	mov    %ecx,%ebx
  80036e:	89 cf                	mov    %ecx,%edi
  800370:	89 ce                	mov    %ecx,%esi
  800372:	cd 30                	int    $0x30
	if(check && ret > 0)
  800374:	85 c0                	test   %eax,%eax
  800376:	7f 08                	jg     800380 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037b:	5b                   	pop    %ebx
  80037c:	5e                   	pop    %esi
  80037d:	5f                   	pop    %edi
  80037e:	5d                   	pop    %ebp
  80037f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800380:	83 ec 0c             	sub    $0xc,%esp
  800383:	50                   	push   %eax
  800384:	6a 0d                	push   $0xd
  800386:	68 ef 23 80 00       	push   $0x8023ef
  80038b:	6a 23                	push   $0x23
  80038d:	68 0c 24 80 00       	push   $0x80240c
  800392:	e8 25 12 00 00       	call   8015bc <_panic>

00800397 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800397:	f3 0f 1e fb          	endbr32 
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	57                   	push   %edi
  80039f:	56                   	push   %esi
  8003a0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	89 d3                	mov    %edx,%ebx
  8003af:	89 d7                	mov    %edx,%edi
  8003b1:	89 d6                	mov    %edx,%esi
  8003b3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b5:	5b                   	pop    %ebx
  8003b6:	5e                   	pop    %esi
  8003b7:	5f                   	pop    %edi
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	05 00 00 00 30       	add    $0x30000000,%eax
  8003c9:	c1 e8 0c             	shr    $0xc,%eax
}
  8003cc:	5d                   	pop    %ebp
  8003cd:	c3                   	ret    

008003ce <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003ce:	f3 0f 1e fb          	endbr32 
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003e9:	f3 0f 1e fb          	endbr32 
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003f5:	89 c2                	mov    %eax,%edx
  8003f7:	c1 ea 16             	shr    $0x16,%edx
  8003fa:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800401:	f6 c2 01             	test   $0x1,%dl
  800404:	74 2d                	je     800433 <fd_alloc+0x4a>
  800406:	89 c2                	mov    %eax,%edx
  800408:	c1 ea 0c             	shr    $0xc,%edx
  80040b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800412:	f6 c2 01             	test   $0x1,%dl
  800415:	74 1c                	je     800433 <fd_alloc+0x4a>
  800417:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80041c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800421:	75 d2                	jne    8003f5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80042c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800431:	eb 0a                	jmp    80043d <fd_alloc+0x54>
			*fd_store = fd;
  800433:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800436:	89 01                	mov    %eax,(%ecx)
			return 0;
  800438:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    

0080043f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80043f:	f3 0f 1e fb          	endbr32 
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800449:	83 f8 1f             	cmp    $0x1f,%eax
  80044c:	77 30                	ja     80047e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80044e:	c1 e0 0c             	shl    $0xc,%eax
  800451:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800456:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80045c:	f6 c2 01             	test   $0x1,%dl
  80045f:	74 24                	je     800485 <fd_lookup+0x46>
  800461:	89 c2                	mov    %eax,%edx
  800463:	c1 ea 0c             	shr    $0xc,%edx
  800466:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80046d:	f6 c2 01             	test   $0x1,%dl
  800470:	74 1a                	je     80048c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800472:	8b 55 0c             	mov    0xc(%ebp),%edx
  800475:	89 02                	mov    %eax,(%edx)
	return 0;
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80047c:	5d                   	pop    %ebp
  80047d:	c3                   	ret    
		return -E_INVAL;
  80047e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800483:	eb f7                	jmp    80047c <fd_lookup+0x3d>
		return -E_INVAL;
  800485:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80048a:	eb f0                	jmp    80047c <fd_lookup+0x3d>
  80048c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800491:	eb e9                	jmp    80047c <fd_lookup+0x3d>

00800493 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800493:	f3 0f 1e fb          	endbr32 
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8004a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004aa:	39 08                	cmp    %ecx,(%eax)
  8004ac:	74 38                	je     8004e6 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004ae:	83 c2 01             	add    $0x1,%edx
  8004b1:	8b 04 95 98 24 80 00 	mov    0x802498(,%edx,4),%eax
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	75 ee                	jne    8004aa <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8004c1:	8b 40 48             	mov    0x48(%eax),%eax
  8004c4:	83 ec 04             	sub    $0x4,%esp
  8004c7:	51                   	push   %ecx
  8004c8:	50                   	push   %eax
  8004c9:	68 1c 24 80 00       	push   $0x80241c
  8004ce:	e8 d0 11 00 00       	call   8016a3 <cprintf>
	*dev = 0;
  8004d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004dc:	83 c4 10             	add    $0x10,%esp
  8004df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004e4:	c9                   	leave  
  8004e5:	c3                   	ret    
			*dev = devtab[i];
  8004e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f0:	eb f2                	jmp    8004e4 <dev_lookup+0x51>

008004f2 <fd_close>:
{
  8004f2:	f3 0f 1e fb          	endbr32 
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	57                   	push   %edi
  8004fa:	56                   	push   %esi
  8004fb:	53                   	push   %ebx
  8004fc:	83 ec 24             	sub    $0x24,%esp
  8004ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800502:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800505:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800508:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800509:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80050f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800512:	50                   	push   %eax
  800513:	e8 27 ff ff ff       	call   80043f <fd_lookup>
  800518:	89 c3                	mov    %eax,%ebx
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	85 c0                	test   %eax,%eax
  80051f:	78 05                	js     800526 <fd_close+0x34>
	    || fd != fd2)
  800521:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800524:	74 16                	je     80053c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800526:	89 f8                	mov    %edi,%eax
  800528:	84 c0                	test   %al,%al
  80052a:	b8 00 00 00 00       	mov    $0x0,%eax
  80052f:	0f 44 d8             	cmove  %eax,%ebx
}
  800532:	89 d8                	mov    %ebx,%eax
  800534:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800537:	5b                   	pop    %ebx
  800538:	5e                   	pop    %esi
  800539:	5f                   	pop    %edi
  80053a:	5d                   	pop    %ebp
  80053b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800542:	50                   	push   %eax
  800543:	ff 36                	pushl  (%esi)
  800545:	e8 49 ff ff ff       	call   800493 <dev_lookup>
  80054a:	89 c3                	mov    %eax,%ebx
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	85 c0                	test   %eax,%eax
  800551:	78 1a                	js     80056d <fd_close+0x7b>
		if (dev->dev_close)
  800553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800556:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800559:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 0b                	je     80056d <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800562:	83 ec 0c             	sub    $0xc,%esp
  800565:	56                   	push   %esi
  800566:	ff d0                	call   *%eax
  800568:	89 c3                	mov    %eax,%ebx
  80056a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80056d:	83 ec 08             	sub    $0x8,%esp
  800570:	56                   	push   %esi
  800571:	6a 00                	push   $0x0
  800573:	e8 9b fc ff ff       	call   800213 <sys_page_unmap>
	return r;
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	eb b5                	jmp    800532 <fd_close+0x40>

0080057d <close>:

int
close(int fdnum)
{
  80057d:	f3 0f 1e fb          	endbr32 
  800581:	55                   	push   %ebp
  800582:	89 e5                	mov    %esp,%ebp
  800584:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800587:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80058a:	50                   	push   %eax
  80058b:	ff 75 08             	pushl  0x8(%ebp)
  80058e:	e8 ac fe ff ff       	call   80043f <fd_lookup>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 c0                	test   %eax,%eax
  800598:	79 02                	jns    80059c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    
		return fd_close(fd, 1);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	6a 01                	push   $0x1
  8005a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a4:	e8 49 ff ff ff       	call   8004f2 <fd_close>
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	eb ec                	jmp    80059a <close+0x1d>

008005ae <close_all>:

void
close_all(void)
{
  8005ae:	f3 0f 1e fb          	endbr32 
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005b9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005be:	83 ec 0c             	sub    $0xc,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	e8 b6 ff ff ff       	call   80057d <close>
	for (i = 0; i < MAXFD; i++)
  8005c7:	83 c3 01             	add    $0x1,%ebx
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	83 fb 20             	cmp    $0x20,%ebx
  8005d0:	75 ec                	jne    8005be <close_all+0x10>
}
  8005d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    

008005d7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005d7:	f3 0f 1e fb          	endbr32 
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	57                   	push   %edi
  8005df:	56                   	push   %esi
  8005e0:	53                   	push   %ebx
  8005e1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	e8 4f fe ff ff       	call   80043f <fd_lookup>
  8005f0:	89 c3                	mov    %eax,%ebx
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	85 c0                	test   %eax,%eax
  8005f7:	0f 88 81 00 00 00    	js     80067e <dup+0xa7>
		return r;
	close(newfdnum);
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	e8 75 ff ff ff       	call   80057d <close>

	newfd = INDEX2FD(newfdnum);
  800608:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060b:	c1 e6 0c             	shl    $0xc,%esi
  80060e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800614:	83 c4 04             	add    $0x4,%esp
  800617:	ff 75 e4             	pushl  -0x1c(%ebp)
  80061a:	e8 af fd ff ff       	call   8003ce <fd2data>
  80061f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800621:	89 34 24             	mov    %esi,(%esp)
  800624:	e8 a5 fd ff ff       	call   8003ce <fd2data>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80062e:	89 d8                	mov    %ebx,%eax
  800630:	c1 e8 16             	shr    $0x16,%eax
  800633:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80063a:	a8 01                	test   $0x1,%al
  80063c:	74 11                	je     80064f <dup+0x78>
  80063e:	89 d8                	mov    %ebx,%eax
  800640:	c1 e8 0c             	shr    $0xc,%eax
  800643:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80064a:	f6 c2 01             	test   $0x1,%dl
  80064d:	75 39                	jne    800688 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80064f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800652:	89 d0                	mov    %edx,%eax
  800654:	c1 e8 0c             	shr    $0xc,%eax
  800657:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80065e:	83 ec 0c             	sub    $0xc,%esp
  800661:	25 07 0e 00 00       	and    $0xe07,%eax
  800666:	50                   	push   %eax
  800667:	56                   	push   %esi
  800668:	6a 00                	push   $0x0
  80066a:	52                   	push   %edx
  80066b:	6a 00                	push   $0x0
  80066d:	e8 5b fb ff ff       	call   8001cd <sys_page_map>
  800672:	89 c3                	mov    %eax,%ebx
  800674:	83 c4 20             	add    $0x20,%esp
  800677:	85 c0                	test   %eax,%eax
  800679:	78 31                	js     8006ac <dup+0xd5>
		goto err;

	return newfdnum;
  80067b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80067e:	89 d8                	mov    %ebx,%eax
  800680:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800683:	5b                   	pop    %ebx
  800684:	5e                   	pop    %esi
  800685:	5f                   	pop    %edi
  800686:	5d                   	pop    %ebp
  800687:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800688:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80068f:	83 ec 0c             	sub    $0xc,%esp
  800692:	25 07 0e 00 00       	and    $0xe07,%eax
  800697:	50                   	push   %eax
  800698:	57                   	push   %edi
  800699:	6a 00                	push   $0x0
  80069b:	53                   	push   %ebx
  80069c:	6a 00                	push   $0x0
  80069e:	e8 2a fb ff ff       	call   8001cd <sys_page_map>
  8006a3:	89 c3                	mov    %eax,%ebx
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	85 c0                	test   %eax,%eax
  8006aa:	79 a3                	jns    80064f <dup+0x78>
	sys_page_unmap(0, newfd);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	56                   	push   %esi
  8006b0:	6a 00                	push   $0x0
  8006b2:	e8 5c fb ff ff       	call   800213 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006b7:	83 c4 08             	add    $0x8,%esp
  8006ba:	57                   	push   %edi
  8006bb:	6a 00                	push   $0x0
  8006bd:	e8 51 fb ff ff       	call   800213 <sys_page_unmap>
	return r;
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	eb b7                	jmp    80067e <dup+0xa7>

008006c7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006c7:	f3 0f 1e fb          	endbr32 
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	53                   	push   %ebx
  8006cf:	83 ec 1c             	sub    $0x1c,%esp
  8006d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006d8:	50                   	push   %eax
  8006d9:	53                   	push   %ebx
  8006da:	e8 60 fd ff ff       	call   80043f <fd_lookup>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	85 c0                	test   %eax,%eax
  8006e4:	78 3f                	js     800725 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006e6:	83 ec 08             	sub    $0x8,%esp
  8006e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006ec:	50                   	push   %eax
  8006ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f0:	ff 30                	pushl  (%eax)
  8006f2:	e8 9c fd ff ff       	call   800493 <dev_lookup>
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	78 27                	js     800725 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800701:	8b 42 08             	mov    0x8(%edx),%eax
  800704:	83 e0 03             	and    $0x3,%eax
  800707:	83 f8 01             	cmp    $0x1,%eax
  80070a:	74 1e                	je     80072a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80070c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070f:	8b 40 08             	mov    0x8(%eax),%eax
  800712:	85 c0                	test   %eax,%eax
  800714:	74 35                	je     80074b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	ff 75 10             	pushl  0x10(%ebp)
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	52                   	push   %edx
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
}
  800725:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800728:	c9                   	leave  
  800729:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80072a:	a1 08 40 80 00       	mov    0x804008,%eax
  80072f:	8b 40 48             	mov    0x48(%eax),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	53                   	push   %ebx
  800736:	50                   	push   %eax
  800737:	68 5d 24 80 00       	push   $0x80245d
  80073c:	e8 62 0f 00 00       	call   8016a3 <cprintf>
		return -E_INVAL;
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800749:	eb da                	jmp    800725 <read+0x5e>
		return -E_NOT_SUPP;
  80074b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800750:	eb d3                	jmp    800725 <read+0x5e>

00800752 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800752:	f3 0f 1e fb          	endbr32 
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	57                   	push   %edi
  80075a:	56                   	push   %esi
  80075b:	53                   	push   %ebx
  80075c:	83 ec 0c             	sub    $0xc,%esp
  80075f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800762:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800765:	bb 00 00 00 00       	mov    $0x0,%ebx
  80076a:	eb 02                	jmp    80076e <readn+0x1c>
  80076c:	01 c3                	add    %eax,%ebx
  80076e:	39 f3                	cmp    %esi,%ebx
  800770:	73 21                	jae    800793 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800772:	83 ec 04             	sub    $0x4,%esp
  800775:	89 f0                	mov    %esi,%eax
  800777:	29 d8                	sub    %ebx,%eax
  800779:	50                   	push   %eax
  80077a:	89 d8                	mov    %ebx,%eax
  80077c:	03 45 0c             	add    0xc(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	57                   	push   %edi
  800781:	e8 41 ff ff ff       	call   8006c7 <read>
		if (m < 0)
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	85 c0                	test   %eax,%eax
  80078b:	78 04                	js     800791 <readn+0x3f>
			return m;
		if (m == 0)
  80078d:	75 dd                	jne    80076c <readn+0x1a>
  80078f:	eb 02                	jmp    800793 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800791:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800793:	89 d8                	mov    %ebx,%eax
  800795:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800798:	5b                   	pop    %ebx
  800799:	5e                   	pop    %esi
  80079a:	5f                   	pop    %edi
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	53                   	push   %ebx
  8007a5:	83 ec 1c             	sub    $0x1c,%esp
  8007a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	53                   	push   %ebx
  8007b0:	e8 8a fc ff ff       	call   80043f <fd_lookup>
  8007b5:	83 c4 10             	add    $0x10,%esp
  8007b8:	85 c0                	test   %eax,%eax
  8007ba:	78 3a                	js     8007f6 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c2:	50                   	push   %eax
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	ff 30                	pushl  (%eax)
  8007c8:	e8 c6 fc ff ff       	call   800493 <dev_lookup>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	78 22                	js     8007f6 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007db:	74 1e                	je     8007fb <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e0:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	74 35                	je     80081c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007e7:	83 ec 04             	sub    $0x4,%esp
  8007ea:	ff 75 10             	pushl  0x10(%ebp)
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	50                   	push   %eax
  8007f1:	ff d2                	call   *%edx
  8007f3:	83 c4 10             	add    $0x10,%esp
}
  8007f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f9:	c9                   	leave  
  8007fa:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007fb:	a1 08 40 80 00       	mov    0x804008,%eax
  800800:	8b 40 48             	mov    0x48(%eax),%eax
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	53                   	push   %ebx
  800807:	50                   	push   %eax
  800808:	68 79 24 80 00       	push   $0x802479
  80080d:	e8 91 0e 00 00       	call   8016a3 <cprintf>
		return -E_INVAL;
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081a:	eb da                	jmp    8007f6 <write+0x59>
		return -E_NOT_SUPP;
  80081c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800821:	eb d3                	jmp    8007f6 <write+0x59>

00800823 <seek>:

int
seek(int fdnum, off_t offset)
{
  800823:	f3 0f 1e fb          	endbr32 
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80082d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800830:	50                   	push   %eax
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 06 fc ff ff       	call   80043f <fd_lookup>
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 c0                	test   %eax,%eax
  80083e:	78 0e                	js     80084e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
  800843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800846:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084e:	c9                   	leave  
  80084f:	c3                   	ret    

00800850 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800850:	f3 0f 1e fb          	endbr32 
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	53                   	push   %ebx
  800858:	83 ec 1c             	sub    $0x1c,%esp
  80085b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	53                   	push   %ebx
  800863:	e8 d7 fb ff ff       	call   80043f <fd_lookup>
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	85 c0                	test   %eax,%eax
  80086d:	78 37                	js     8008a6 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800875:	50                   	push   %eax
  800876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800879:	ff 30                	pushl  (%eax)
  80087b:	e8 13 fc ff ff       	call   800493 <dev_lookup>
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	85 c0                	test   %eax,%eax
  800885:	78 1f                	js     8008a6 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80088e:	74 1b                	je     8008ab <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800893:	8b 52 18             	mov    0x18(%edx),%edx
  800896:	85 d2                	test   %edx,%edx
  800898:	74 32                	je     8008cc <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	50                   	push   %eax
  8008a1:	ff d2                	call   *%edx
  8008a3:	83 c4 10             	add    $0x10,%esp
}
  8008a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a9:	c9                   	leave  
  8008aa:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008ab:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b0:	8b 40 48             	mov    0x48(%eax),%eax
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	50                   	push   %eax
  8008b8:	68 3c 24 80 00       	push   $0x80243c
  8008bd:	e8 e1 0d 00 00       	call   8016a3 <cprintf>
		return -E_INVAL;
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ca:	eb da                	jmp    8008a6 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d1:	eb d3                	jmp    8008a6 <ftruncate+0x56>

008008d3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d3:	f3 0f 1e fb          	endbr32 
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 1c             	sub    $0x1c,%esp
  8008de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 52 fb ff ff       	call   80043f <fd_lookup>
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	78 4b                	js     80093f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fa:	50                   	push   %eax
  8008fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fe:	ff 30                	pushl  (%eax)
  800900:	e8 8e fb ff ff       	call   800493 <dev_lookup>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	85 c0                	test   %eax,%eax
  80090a:	78 33                	js     80093f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80090c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800913:	74 2f                	je     800944 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800915:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800918:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80091f:	00 00 00 
	stat->st_isdir = 0;
  800922:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800929:	00 00 00 
	stat->st_dev = dev;
  80092c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	53                   	push   %ebx
  800936:	ff 75 f0             	pushl  -0x10(%ebp)
  800939:	ff 50 14             	call   *0x14(%eax)
  80093c:	83 c4 10             	add    $0x10,%esp
}
  80093f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800942:	c9                   	leave  
  800943:	c3                   	ret    
		return -E_NOT_SUPP;
  800944:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800949:	eb f4                	jmp    80093f <fstat+0x6c>

0080094b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80094b:	f3 0f 1e fb          	endbr32 
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	6a 00                	push   $0x0
  800959:	ff 75 08             	pushl  0x8(%ebp)
  80095c:	e8 fb 01 00 00       	call   800b5c <open>
  800961:	89 c3                	mov    %eax,%ebx
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	85 c0                	test   %eax,%eax
  800968:	78 1b                	js     800985 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	50                   	push   %eax
  800971:	e8 5d ff ff ff       	call   8008d3 <fstat>
  800976:	89 c6                	mov    %eax,%esi
	close(fd);
  800978:	89 1c 24             	mov    %ebx,(%esp)
  80097b:	e8 fd fb ff ff       	call   80057d <close>
	return r;
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	89 f3                	mov    %esi,%ebx
}
  800985:	89 d8                	mov    %ebx,%eax
  800987:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	89 c6                	mov    %eax,%esi
  800995:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800997:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80099e:	74 27                	je     8009c7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a0:	6a 07                	push   $0x7
  8009a2:	68 00 50 80 00       	push   $0x805000
  8009a7:	56                   	push   %esi
  8009a8:	ff 35 00 40 80 00    	pushl  0x804000
  8009ae:	e8 e0 16 00 00       	call   802093 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b3:	83 c4 0c             	add    $0xc,%esp
  8009b6:	6a 00                	push   $0x0
  8009b8:	53                   	push   %ebx
  8009b9:	6a 00                	push   $0x0
  8009bb:	e8 5f 16 00 00       	call   80201f <ipc_recv>
}
  8009c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c3:	5b                   	pop    %ebx
  8009c4:	5e                   	pop    %esi
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009c7:	83 ec 0c             	sub    $0xc,%esp
  8009ca:	6a 01                	push   $0x1
  8009cc:	e8 1a 17 00 00       	call   8020eb <ipc_find_env>
  8009d1:	a3 00 40 80 00       	mov    %eax,0x804000
  8009d6:	83 c4 10             	add    $0x10,%esp
  8009d9:	eb c5                	jmp    8009a0 <fsipc+0x12>

008009db <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8009eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fd:	b8 02 00 00 00       	mov    $0x2,%eax
  800a02:	e8 87 ff ff ff       	call   80098e <fsipc>
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <devfile_flush>:
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 40 0c             	mov    0xc(%eax),%eax
  800a19:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a23:	b8 06 00 00 00       	mov    $0x6,%eax
  800a28:	e8 61 ff ff ff       	call   80098e <fsipc>
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <devfile_stat>:
{
  800a2f:	f3 0f 1e fb          	endbr32 
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	53                   	push   %ebx
  800a37:	83 ec 04             	sub    $0x4,%esp
  800a3a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 40 0c             	mov    0xc(%eax),%eax
  800a43:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	b8 05 00 00 00       	mov    $0x5,%eax
  800a52:	e8 37 ff ff ff       	call   80098e <fsipc>
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 2c                	js     800a87 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	68 00 50 80 00       	push   $0x805000
  800a63:	53                   	push   %ebx
  800a64:	e8 44 12 00 00       	call   801cad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a69:	a1 80 50 80 00       	mov    0x805080,%eax
  800a6e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a74:	a1 84 50 80 00       	mov    0x805084,%eax
  800a79:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a7f:	83 c4 10             	add    $0x10,%esp
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <devfile_write>:
{
  800a8c:	f3 0f 1e fb          	endbr32 
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 0c             	sub    $0xc,%esp
  800a96:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a99:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9c:	8b 52 0c             	mov    0xc(%edx),%edx
  800a9f:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800aa5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aaa:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aaf:	0f 47 c2             	cmova  %edx,%eax
  800ab2:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800ab7:	50                   	push   %eax
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	68 08 50 80 00       	push   $0x805008
  800ac0:	e8 9e 13 00 00       	call   801e63 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aca:	b8 04 00 00 00       	mov    $0x4,%eax
  800acf:	e8 ba fe ff ff       	call   80098e <fsipc>
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <devfile_read>:
{
  800ad6:	f3 0f 1e fb          	endbr32 
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ae8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800aed:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800af3:	ba 00 00 00 00       	mov    $0x0,%edx
  800af8:	b8 03 00 00 00       	mov    $0x3,%eax
  800afd:	e8 8c fe ff ff       	call   80098e <fsipc>
  800b02:	89 c3                	mov    %eax,%ebx
  800b04:	85 c0                	test   %eax,%eax
  800b06:	78 1f                	js     800b27 <devfile_read+0x51>
	assert(r <= n);
  800b08:	39 f0                	cmp    %esi,%eax
  800b0a:	77 24                	ja     800b30 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b0c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b11:	7f 33                	jg     800b46 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	68 00 50 80 00       	push   $0x805000
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	e8 3f 13 00 00       	call   801e63 <memmove>
	return r;
  800b24:	83 c4 10             	add    $0x10,%esp
}
  800b27:	89 d8                	mov    %ebx,%eax
  800b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b2c:	5b                   	pop    %ebx
  800b2d:	5e                   	pop    %esi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    
	assert(r <= n);
  800b30:	68 ac 24 80 00       	push   $0x8024ac
  800b35:	68 b3 24 80 00       	push   $0x8024b3
  800b3a:	6a 7c                	push   $0x7c
  800b3c:	68 c8 24 80 00       	push   $0x8024c8
  800b41:	e8 76 0a 00 00       	call   8015bc <_panic>
	assert(r <= PGSIZE);
  800b46:	68 d3 24 80 00       	push   $0x8024d3
  800b4b:	68 b3 24 80 00       	push   $0x8024b3
  800b50:	6a 7d                	push   $0x7d
  800b52:	68 c8 24 80 00       	push   $0x8024c8
  800b57:	e8 60 0a 00 00       	call   8015bc <_panic>

00800b5c <open>:
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	56                   	push   %esi
  800b64:	53                   	push   %ebx
  800b65:	83 ec 1c             	sub    $0x1c,%esp
  800b68:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b6b:	56                   	push   %esi
  800b6c:	e8 f9 10 00 00       	call   801c6a <strlen>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b79:	7f 6c                	jg     800be7 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b7b:	83 ec 0c             	sub    $0xc,%esp
  800b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	e8 62 f8 ff ff       	call   8003e9 <fd_alloc>
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	83 c4 10             	add    $0x10,%esp
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	78 3c                	js     800bcc <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	56                   	push   %esi
  800b94:	68 00 50 80 00       	push   $0x805000
  800b99:	e8 0f 11 00 00       	call   801cad <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bae:	e8 db fd ff ff       	call   80098e <fsipc>
  800bb3:	89 c3                	mov    %eax,%ebx
  800bb5:	83 c4 10             	add    $0x10,%esp
  800bb8:	85 c0                	test   %eax,%eax
  800bba:	78 19                	js     800bd5 <open+0x79>
	return fd2num(fd);
  800bbc:	83 ec 0c             	sub    $0xc,%esp
  800bbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc2:	e8 f3 f7 ff ff       	call   8003ba <fd2num>
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	83 c4 10             	add    $0x10,%esp
}
  800bcc:	89 d8                	mov    %ebx,%eax
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    
		fd_close(fd, 0);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	6a 00                	push   $0x0
  800bda:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdd:	e8 10 f9 ff ff       	call   8004f2 <fd_close>
		return r;
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	eb e5                	jmp    800bcc <open+0x70>
		return -E_BAD_PATH;
  800be7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bec:	eb de                	jmp    800bcc <open+0x70>

00800bee <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bee:	f3 0f 1e fb          	endbr32 
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfd:	b8 08 00 00 00       	mov    $0x8,%eax
  800c02:	e8 87 fd ff ff       	call   80098e <fsipc>
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c09:	f3 0f 1e fb          	endbr32 
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c13:	68 df 24 80 00       	push   $0x8024df
  800c18:	ff 75 0c             	pushl  0xc(%ebp)
  800c1b:	e8 8d 10 00 00       	call   801cad <strcpy>
	return 0;
}
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <devsock_close>:
{
  800c27:	f3 0f 1e fb          	endbr32 
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	53                   	push   %ebx
  800c2f:	83 ec 10             	sub    $0x10,%esp
  800c32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c35:	53                   	push   %ebx
  800c36:	e8 ed 14 00 00       	call   802128 <pageref>
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c45:	83 fa 01             	cmp    $0x1,%edx
  800c48:	74 05                	je     800c4f <devsock_close+0x28>
}
  800c4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	ff 73 0c             	pushl  0xc(%ebx)
  800c55:	e8 e3 02 00 00       	call   800f3d <nsipc_close>
  800c5a:	83 c4 10             	add    $0x10,%esp
  800c5d:	eb eb                	jmp    800c4a <devsock_close+0x23>

00800c5f <devsock_write>:
{
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c69:	6a 00                	push   $0x0
  800c6b:	ff 75 10             	pushl  0x10(%ebp)
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff 70 0c             	pushl  0xc(%eax)
  800c77:	e8 b5 03 00 00       	call   801031 <nsipc_send>
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <devsock_read>:
{
  800c7e:	f3 0f 1e fb          	endbr32 
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c88:	6a 00                	push   $0x0
  800c8a:	ff 75 10             	pushl  0x10(%ebp)
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff 70 0c             	pushl  0xc(%eax)
  800c96:	e8 1f 03 00 00       	call   800fba <nsipc_recv>
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <fd2sockid>:
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ca3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ca6:	52                   	push   %edx
  800ca7:	50                   	push   %eax
  800ca8:	e8 92 f7 ff ff       	call   80043f <fd_lookup>
  800cad:	83 c4 10             	add    $0x10,%esp
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	78 10                	js     800cc4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800cbd:	39 08                	cmp    %ecx,(%eax)
  800cbf:	75 05                	jne    800cc6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cc1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    
		return -E_NOT_SUPP;
  800cc6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ccb:	eb f7                	jmp    800cc4 <fd2sockid+0x27>

00800ccd <alloc_sockfd>:
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	83 ec 1c             	sub    $0x1c,%esp
  800cd5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cda:	50                   	push   %eax
  800cdb:	e8 09 f7 ff ff       	call   8003e9 <fd_alloc>
  800ce0:	89 c3                	mov    %eax,%ebx
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	78 43                	js     800d2c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ce9:	83 ec 04             	sub    $0x4,%esp
  800cec:	68 07 04 00 00       	push   $0x407
  800cf1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf4:	6a 00                	push   $0x0
  800cf6:	e8 8b f4 ff ff       	call   800186 <sys_page_alloc>
  800cfb:	89 c3                	mov    %eax,%ebx
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	85 c0                	test   %eax,%eax
  800d02:	78 28                	js     800d2c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d07:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d0d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d19:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	e8 95 f6 ff ff       	call   8003ba <fd2num>
  800d25:	89 c3                	mov    %eax,%ebx
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	eb 0c                	jmp    800d38 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d2c:	83 ec 0c             	sub    $0xc,%esp
  800d2f:	56                   	push   %esi
  800d30:	e8 08 02 00 00       	call   800f3d <nsipc_close>
		return r;
  800d35:	83 c4 10             	add    $0x10,%esp
}
  800d38:	89 d8                	mov    %ebx,%eax
  800d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <accept>:
{
  800d41:	f3 0f 1e fb          	endbr32 
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	e8 4a ff ff ff       	call   800c9d <fd2sockid>
  800d53:	85 c0                	test   %eax,%eax
  800d55:	78 1b                	js     800d72 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	ff 75 10             	pushl  0x10(%ebp)
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	50                   	push   %eax
  800d61:	e8 22 01 00 00       	call   800e88 <nsipc_accept>
  800d66:	83 c4 10             	add    $0x10,%esp
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	78 05                	js     800d72 <accept+0x31>
	return alloc_sockfd(r);
  800d6d:	e8 5b ff ff ff       	call   800ccd <alloc_sockfd>
}
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <bind>:
{
  800d74:	f3 0f 1e fb          	endbr32 
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	e8 17 ff ff ff       	call   800c9d <fd2sockid>
  800d86:	85 c0                	test   %eax,%eax
  800d88:	78 12                	js     800d9c <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	ff 75 10             	pushl  0x10(%ebp)
  800d90:	ff 75 0c             	pushl  0xc(%ebp)
  800d93:	50                   	push   %eax
  800d94:	e8 45 01 00 00       	call   800ede <nsipc_bind>
  800d99:	83 c4 10             	add    $0x10,%esp
}
  800d9c:	c9                   	leave  
  800d9d:	c3                   	ret    

00800d9e <shutdown>:
{
  800d9e:	f3 0f 1e fb          	endbr32 
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	e8 ed fe ff ff       	call   800c9d <fd2sockid>
  800db0:	85 c0                	test   %eax,%eax
  800db2:	78 0f                	js     800dc3 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800db4:	83 ec 08             	sub    $0x8,%esp
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	50                   	push   %eax
  800dbb:	e8 57 01 00 00       	call   800f17 <nsipc_shutdown>
  800dc0:	83 c4 10             	add    $0x10,%esp
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <connect>:
{
  800dc5:	f3 0f 1e fb          	endbr32 
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	e8 c6 fe ff ff       	call   800c9d <fd2sockid>
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	78 12                	js     800ded <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800ddb:	83 ec 04             	sub    $0x4,%esp
  800dde:	ff 75 10             	pushl  0x10(%ebp)
  800de1:	ff 75 0c             	pushl  0xc(%ebp)
  800de4:	50                   	push   %eax
  800de5:	e8 71 01 00 00       	call   800f5b <nsipc_connect>
  800dea:	83 c4 10             	add    $0x10,%esp
}
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <listen>:
{
  800def:	f3 0f 1e fb          	endbr32 
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	e8 9c fe ff ff       	call   800c9d <fd2sockid>
  800e01:	85 c0                	test   %eax,%eax
  800e03:	78 0f                	js     800e14 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	50                   	push   %eax
  800e0c:	e8 83 01 00 00       	call   800f94 <nsipc_listen>
  800e11:	83 c4 10             	add    $0x10,%esp
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e16:	f3 0f 1e fb          	endbr32 
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e20:	ff 75 10             	pushl  0x10(%ebp)
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	ff 75 08             	pushl  0x8(%ebp)
  800e29:	e8 65 02 00 00       	call   801093 <nsipc_socket>
  800e2e:	83 c4 10             	add    $0x10,%esp
  800e31:	85 c0                	test   %eax,%eax
  800e33:	78 05                	js     800e3a <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e35:	e8 93 fe ff ff       	call   800ccd <alloc_sockfd>
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 04             	sub    $0x4,%esp
  800e43:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e45:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e4c:	74 26                	je     800e74 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e4e:	6a 07                	push   $0x7
  800e50:	68 00 60 80 00       	push   $0x806000
  800e55:	53                   	push   %ebx
  800e56:	ff 35 04 40 80 00    	pushl  0x804004
  800e5c:	e8 32 12 00 00       	call   802093 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e61:	83 c4 0c             	add    $0xc,%esp
  800e64:	6a 00                	push   $0x0
  800e66:	6a 00                	push   $0x0
  800e68:	6a 00                	push   $0x0
  800e6a:	e8 b0 11 00 00       	call   80201f <ipc_recv>
}
  800e6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	6a 02                	push   $0x2
  800e79:	e8 6d 12 00 00       	call   8020eb <ipc_find_env>
  800e7e:	a3 04 40 80 00       	mov    %eax,0x804004
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	eb c6                	jmp    800e4e <nsipc+0x12>

00800e88 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e88:	f3 0f 1e fb          	endbr32 
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e9c:	8b 06                	mov    (%esi),%eax
  800e9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ea3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea8:	e8 8f ff ff ff       	call   800e3c <nsipc>
  800ead:	89 c3                	mov    %eax,%ebx
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	79 09                	jns    800ebc <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800eb3:	89 d8                	mov    %ebx,%eax
  800eb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ebc:	83 ec 04             	sub    $0x4,%esp
  800ebf:	ff 35 10 60 80 00    	pushl  0x806010
  800ec5:	68 00 60 80 00       	push   $0x806000
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	e8 91 0f 00 00       	call   801e63 <memmove>
		*addrlen = ret->ret_addrlen;
  800ed2:	a1 10 60 80 00       	mov    0x806010,%eax
  800ed7:	89 06                	mov    %eax,(%esi)
  800ed9:	83 c4 10             	add    $0x10,%esp
	return r;
  800edc:	eb d5                	jmp    800eb3 <nsipc_accept+0x2b>

00800ede <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ede:	f3 0f 1e fb          	endbr32 
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ef4:	53                   	push   %ebx
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	68 04 60 80 00       	push   $0x806004
  800efd:	e8 61 0f 00 00       	call   801e63 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f02:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f08:	b8 02 00 00 00       	mov    $0x2,%eax
  800f0d:	e8 2a ff ff ff       	call   800e3c <nsipc>
}
  800f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f17:	f3 0f 1e fb          	endbr32 
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f31:	b8 03 00 00 00       	mov    $0x3,%eax
  800f36:	e8 01 ff ff ff       	call   800e3c <nsipc>
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <nsipc_close>:

int
nsipc_close(int s)
{
  800f3d:	f3 0f 1e fb          	endbr32 
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800f54:	e8 e3 fe ff ff       	call   800e3c <nsipc>
}
  800f59:	c9                   	leave  
  800f5a:	c3                   	ret    

00800f5b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	53                   	push   %ebx
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f71:	53                   	push   %ebx
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	68 04 60 80 00       	push   $0x806004
  800f7a:	e8 e4 0e 00 00       	call   801e63 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f7f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f85:	b8 05 00 00 00       	mov    $0x5,%eax
  800f8a:	e8 ad fe ff ff       	call   800e3c <nsipc>
}
  800f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f94:	f3 0f 1e fb          	endbr32 
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fae:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb3:	e8 84 fe ff ff       	call   800e3c <nsipc>
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fba:	f3 0f 1e fb          	endbr32 
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fdc:	b8 07 00 00 00       	mov    $0x7,%eax
  800fe1:	e8 56 fe ff ff       	call   800e3c <nsipc>
  800fe6:	89 c3                	mov    %eax,%ebx
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	78 26                	js     801012 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fec:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800ff2:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800ff7:	0f 4e c6             	cmovle %esi,%eax
  800ffa:	39 c3                	cmp    %eax,%ebx
  800ffc:	7f 1d                	jg     80101b <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800ffe:	83 ec 04             	sub    $0x4,%esp
  801001:	53                   	push   %ebx
  801002:	68 00 60 80 00       	push   $0x806000
  801007:	ff 75 0c             	pushl  0xc(%ebp)
  80100a:	e8 54 0e 00 00       	call   801e63 <memmove>
  80100f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801012:	89 d8                	mov    %ebx,%eax
  801014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80101b:	68 eb 24 80 00       	push   $0x8024eb
  801020:	68 b3 24 80 00       	push   $0x8024b3
  801025:	6a 62                	push   $0x62
  801027:	68 00 25 80 00       	push   $0x802500
  80102c:	e8 8b 05 00 00       	call   8015bc <_panic>

00801031 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801031:	f3 0f 1e fb          	endbr32 
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	53                   	push   %ebx
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801047:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80104d:	7f 2e                	jg     80107d <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	53                   	push   %ebx
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	68 0c 60 80 00       	push   $0x80600c
  80105b:	e8 03 0e 00 00       	call   801e63 <memmove>
	nsipcbuf.send.req_size = size;
  801060:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801066:	8b 45 14             	mov    0x14(%ebp),%eax
  801069:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80106e:	b8 08 00 00 00       	mov    $0x8,%eax
  801073:	e8 c4 fd ff ff       	call   800e3c <nsipc>
}
  801078:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107b:	c9                   	leave  
  80107c:	c3                   	ret    
	assert(size < 1600);
  80107d:	68 0c 25 80 00       	push   $0x80250c
  801082:	68 b3 24 80 00       	push   $0x8024b3
  801087:	6a 6d                	push   $0x6d
  801089:	68 00 25 80 00       	push   $0x802500
  80108e:	e8 29 05 00 00       	call   8015bc <_panic>

00801093 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801093:	f3 0f 1e fb          	endbr32 
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8010ba:	e8 7d fd ff ff       	call   800e3c <nsipc>
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
  8010ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	ff 75 08             	pushl  0x8(%ebp)
  8010d3:	e8 f6 f2 ff ff       	call   8003ce <fd2data>
  8010d8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	68 18 25 80 00       	push   $0x802518
  8010e2:	53                   	push   %ebx
  8010e3:	e8 c5 0b 00 00       	call   801cad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010e8:	8b 46 04             	mov    0x4(%esi),%eax
  8010eb:	2b 06                	sub    (%esi),%eax
  8010ed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010f3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010fa:	00 00 00 
	stat->st_dev = &devpipe;
  8010fd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801104:	30 80 00 
	return 0;
}
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801113:	f3 0f 1e fb          	endbr32 
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	53                   	push   %ebx
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801121:	53                   	push   %ebx
  801122:	6a 00                	push   $0x0
  801124:	e8 ea f0 ff ff       	call   800213 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801129:	89 1c 24             	mov    %ebx,(%esp)
  80112c:	e8 9d f2 ff ff       	call   8003ce <fd2data>
  801131:	83 c4 08             	add    $0x8,%esp
  801134:	50                   	push   %eax
  801135:	6a 00                	push   $0x0
  801137:	e8 d7 f0 ff ff       	call   800213 <sys_page_unmap>
}
  80113c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <_pipeisclosed>:
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	57                   	push   %edi
  801145:	56                   	push   %esi
  801146:	53                   	push   %ebx
  801147:	83 ec 1c             	sub    $0x1c,%esp
  80114a:	89 c7                	mov    %eax,%edi
  80114c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80114e:	a1 08 40 80 00       	mov    0x804008,%eax
  801153:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	57                   	push   %edi
  80115a:	e8 c9 0f 00 00       	call   802128 <pageref>
  80115f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801162:	89 34 24             	mov    %esi,(%esp)
  801165:	e8 be 0f 00 00       	call   802128 <pageref>
		nn = thisenv->env_runs;
  80116a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801170:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	39 cb                	cmp    %ecx,%ebx
  801178:	74 1b                	je     801195 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80117a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80117d:	75 cf                	jne    80114e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80117f:	8b 42 58             	mov    0x58(%edx),%eax
  801182:	6a 01                	push   $0x1
  801184:	50                   	push   %eax
  801185:	53                   	push   %ebx
  801186:	68 1f 25 80 00       	push   $0x80251f
  80118b:	e8 13 05 00 00       	call   8016a3 <cprintf>
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	eb b9                	jmp    80114e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801195:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801198:	0f 94 c0             	sete   %al
  80119b:	0f b6 c0             	movzbl %al,%eax
}
  80119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <devpipe_write>:
{
  8011a6:	f3 0f 1e fb          	endbr32 
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	57                   	push   %edi
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
  8011b0:	83 ec 28             	sub    $0x28,%esp
  8011b3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011b6:	56                   	push   %esi
  8011b7:	e8 12 f2 ff ff       	call   8003ce <fd2data>
  8011bc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011c9:	74 4f                	je     80121a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8011ce:	8b 0b                	mov    (%ebx),%ecx
  8011d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8011d3:	39 d0                	cmp    %edx,%eax
  8011d5:	72 14                	jb     8011eb <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011d7:	89 da                	mov    %ebx,%edx
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	e8 61 ff ff ff       	call   801141 <_pipeisclosed>
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	75 3b                	jne    80121f <devpipe_write+0x79>
			sys_yield();
  8011e4:	e8 7a ef ff ff       	call   800163 <sys_yield>
  8011e9:	eb e0                	jmp    8011cb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ee:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011f2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	c1 fa 1f             	sar    $0x1f,%edx
  8011fa:	89 d1                	mov    %edx,%ecx
  8011fc:	c1 e9 1b             	shr    $0x1b,%ecx
  8011ff:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801202:	83 e2 1f             	and    $0x1f,%edx
  801205:	29 ca                	sub    %ecx,%edx
  801207:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80120b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80120f:	83 c0 01             	add    $0x1,%eax
  801212:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801215:	83 c7 01             	add    $0x1,%edi
  801218:	eb ac                	jmp    8011c6 <devpipe_write+0x20>
	return i;
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	eb 05                	jmp    801224 <devpipe_write+0x7e>
				return 0;
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801224:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801227:	5b                   	pop    %ebx
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <devpipe_read>:
{
  80122c:	f3 0f 1e fb          	endbr32 
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 18             	sub    $0x18,%esp
  801239:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80123c:	57                   	push   %edi
  80123d:	e8 8c f1 ff ff       	call   8003ce <fd2data>
  801242:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	be 00 00 00 00       	mov    $0x0,%esi
  80124c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80124f:	75 14                	jne    801265 <devpipe_read+0x39>
	return i;
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	eb 02                	jmp    801258 <devpipe_read+0x2c>
				return i;
  801256:	89 f0                	mov    %esi,%eax
}
  801258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5f                   	pop    %edi
  80125e:	5d                   	pop    %ebp
  80125f:	c3                   	ret    
			sys_yield();
  801260:	e8 fe ee ff ff       	call   800163 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801265:	8b 03                	mov    (%ebx),%eax
  801267:	3b 43 04             	cmp    0x4(%ebx),%eax
  80126a:	75 18                	jne    801284 <devpipe_read+0x58>
			if (i > 0)
  80126c:	85 f6                	test   %esi,%esi
  80126e:	75 e6                	jne    801256 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801270:	89 da                	mov    %ebx,%edx
  801272:	89 f8                	mov    %edi,%eax
  801274:	e8 c8 fe ff ff       	call   801141 <_pipeisclosed>
  801279:	85 c0                	test   %eax,%eax
  80127b:	74 e3                	je     801260 <devpipe_read+0x34>
				return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
  801282:	eb d4                	jmp    801258 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801284:	99                   	cltd   
  801285:	c1 ea 1b             	shr    $0x1b,%edx
  801288:	01 d0                	add    %edx,%eax
  80128a:	83 e0 1f             	and    $0x1f,%eax
  80128d:	29 d0                	sub    %edx,%eax
  80128f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801294:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801297:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80129a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80129d:	83 c6 01             	add    $0x1,%esi
  8012a0:	eb aa                	jmp    80124c <devpipe_read+0x20>

008012a2 <pipe>:
{
  8012a2:	f3 0f 1e fb          	endbr32 
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b1:	50                   	push   %eax
  8012b2:	e8 32 f1 ff ff       	call   8003e9 <fd_alloc>
  8012b7:	89 c3                	mov    %eax,%ebx
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	0f 88 23 01 00 00    	js     8013e7 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	68 07 04 00 00       	push   $0x407
  8012cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 b0 ee ff ff       	call   800186 <sys_page_alloc>
  8012d6:	89 c3                	mov    %eax,%ebx
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 04 01 00 00    	js     8013e7 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e9:	50                   	push   %eax
  8012ea:	e8 fa f0 ff ff       	call   8003e9 <fd_alloc>
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	0f 88 db 00 00 00    	js     8013d7 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	68 07 04 00 00       	push   $0x407
  801304:	ff 75 f0             	pushl  -0x10(%ebp)
  801307:	6a 00                	push   $0x0
  801309:	e8 78 ee ff ff       	call   800186 <sys_page_alloc>
  80130e:	89 c3                	mov    %eax,%ebx
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	0f 88 bc 00 00 00    	js     8013d7 <pipe+0x135>
	va = fd2data(fd0);
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	e8 a8 f0 ff ff       	call   8003ce <fd2data>
  801326:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801328:	83 c4 0c             	add    $0xc,%esp
  80132b:	68 07 04 00 00       	push   $0x407
  801330:	50                   	push   %eax
  801331:	6a 00                	push   $0x0
  801333:	e8 4e ee ff ff       	call   800186 <sys_page_alloc>
  801338:	89 c3                	mov    %eax,%ebx
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	0f 88 82 00 00 00    	js     8013c7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801345:	83 ec 0c             	sub    $0xc,%esp
  801348:	ff 75 f0             	pushl  -0x10(%ebp)
  80134b:	e8 7e f0 ff ff       	call   8003ce <fd2data>
  801350:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801357:	50                   	push   %eax
  801358:	6a 00                	push   $0x0
  80135a:	56                   	push   %esi
  80135b:	6a 00                	push   $0x0
  80135d:	e8 6b ee ff ff       	call   8001cd <sys_page_map>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 20             	add    $0x20,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 4e                	js     8013b9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80136b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801373:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801375:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801378:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80137f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801382:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801387:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80138e:	83 ec 0c             	sub    $0xc,%esp
  801391:	ff 75 f4             	pushl  -0xc(%ebp)
  801394:	e8 21 f0 ff ff       	call   8003ba <fd2num>
  801399:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80139e:	83 c4 04             	add    $0x4,%esp
  8013a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a4:	e8 11 f0 ff ff       	call   8003ba <fd2num>
  8013a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b7:	eb 2e                	jmp    8013e7 <pipe+0x145>
	sys_page_unmap(0, va);
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	56                   	push   %esi
  8013bd:	6a 00                	push   $0x0
  8013bf:	e8 4f ee ff ff       	call   800213 <sys_page_unmap>
  8013c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8013cd:	6a 00                	push   $0x0
  8013cf:	e8 3f ee ff ff       	call   800213 <sys_page_unmap>
  8013d4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	ff 75 f4             	pushl  -0xc(%ebp)
  8013dd:	6a 00                	push   $0x0
  8013df:	e8 2f ee ff ff       	call   800213 <sys_page_unmap>
  8013e4:	83 c4 10             	add    $0x10,%esp
}
  8013e7:	89 d8                	mov    %ebx,%eax
  8013e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ec:	5b                   	pop    %ebx
  8013ed:	5e                   	pop    %esi
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <pipeisclosed>:
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	e8 39 f0 ff ff       	call   80043f <fd_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 18                	js     801425 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 f4             	pushl  -0xc(%ebp)
  801413:	e8 b6 ef ff ff       	call   8003ce <fd2data>
  801418:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80141a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141d:	e8 1f fd ff ff       	call   801141 <_pipeisclosed>
  801422:	83 c4 10             	add    $0x10,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801427:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
  801430:	c3                   	ret    

00801431 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801431:	f3 0f 1e fb          	endbr32 
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80143b:	68 37 25 80 00       	push   $0x802537
  801440:	ff 75 0c             	pushl  0xc(%ebp)
  801443:	e8 65 08 00 00       	call   801cad <strcpy>
	return 0;
}
  801448:	b8 00 00 00 00       	mov    $0x0,%eax
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <devcons_write>:
{
  80144f:	f3 0f 1e fb          	endbr32 
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	57                   	push   %edi
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80145f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801464:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80146a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80146d:	73 31                	jae    8014a0 <devcons_write+0x51>
		m = n - tot;
  80146f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801472:	29 f3                	sub    %esi,%ebx
  801474:	83 fb 7f             	cmp    $0x7f,%ebx
  801477:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80147c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	53                   	push   %ebx
  801483:	89 f0                	mov    %esi,%eax
  801485:	03 45 0c             	add    0xc(%ebp),%eax
  801488:	50                   	push   %eax
  801489:	57                   	push   %edi
  80148a:	e8 d4 09 00 00       	call   801e63 <memmove>
		sys_cputs(buf, m);
  80148f:	83 c4 08             	add    $0x8,%esp
  801492:	53                   	push   %ebx
  801493:	57                   	push   %edi
  801494:	e8 1d ec ff ff       	call   8000b6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801499:	01 de                	add    %ebx,%esi
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	eb ca                	jmp    80146a <devcons_write+0x1b>
}
  8014a0:	89 f0                	mov    %esi,%eax
  8014a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a5:	5b                   	pop    %ebx
  8014a6:	5e                   	pop    %esi
  8014a7:	5f                   	pop    %edi
  8014a8:	5d                   	pop    %ebp
  8014a9:	c3                   	ret    

008014aa <devcons_read>:
{
  8014aa:	f3 0f 1e fb          	endbr32 
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bd:	74 21                	je     8014e0 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014bf:	e8 14 ec ff ff       	call   8000d8 <sys_cgetc>
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	75 07                	jne    8014cf <devcons_read+0x25>
		sys_yield();
  8014c8:	e8 96 ec ff ff       	call   800163 <sys_yield>
  8014cd:	eb f0                	jmp    8014bf <devcons_read+0x15>
	if (c < 0)
  8014cf:	78 0f                	js     8014e0 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014d1:	83 f8 04             	cmp    $0x4,%eax
  8014d4:	74 0c                	je     8014e2 <devcons_read+0x38>
	*(char*)vbuf = c;
  8014d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d9:	88 02                	mov    %al,(%edx)
	return 1;
  8014db:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
		return 0;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb f7                	jmp    8014e0 <devcons_read+0x36>

008014e9 <cputchar>:
{
  8014e9:	f3 0f 1e fb          	endbr32 
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014f9:	6a 01                	push   $0x1
  8014fb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	e8 b2 eb ff ff       	call   8000b6 <sys_cputs>
}
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <getchar>:
{
  801509:	f3 0f 1e fb          	endbr32 
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801513:	6a 01                	push   $0x1
  801515:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801518:	50                   	push   %eax
  801519:	6a 00                	push   $0x0
  80151b:	e8 a7 f1 ff ff       	call   8006c7 <read>
	if (r < 0)
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 06                	js     80152d <getchar+0x24>
	if (r < 1)
  801527:	74 06                	je     80152f <getchar+0x26>
	return c;
  801529:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    
		return -E_EOF;
  80152f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801534:	eb f7                	jmp    80152d <getchar+0x24>

00801536 <iscons>:
{
  801536:	f3 0f 1e fb          	endbr32 
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801540:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801543:	50                   	push   %eax
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	e8 f3 ee ff ff       	call   80043f <fd_lookup>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 11                	js     801564 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80155c:	39 10                	cmp    %edx,(%eax)
  80155e:	0f 94 c0             	sete   %al
  801561:	0f b6 c0             	movzbl %al,%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <opencons>:
{
  801566:	f3 0f 1e fb          	endbr32 
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	e8 70 ee ff ff       	call   8003e9 <fd_alloc>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 3a                	js     8015ba <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	68 07 04 00 00       	push   $0x407
  801588:	ff 75 f4             	pushl  -0xc(%ebp)
  80158b:	6a 00                	push   $0x0
  80158d:	e8 f4 eb ff ff       	call   800186 <sys_page_alloc>
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	85 c0                	test   %eax,%eax
  801597:	78 21                	js     8015ba <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015a2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	50                   	push   %eax
  8015b2:	e8 03 ee ff ff       	call   8003ba <fd2num>
  8015b7:	83 c4 10             	add    $0x10,%esp
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015bc:	f3 0f 1e fb          	endbr32 
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015c5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015c8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015ce:	e8 6d eb ff ff       	call   800140 <sys_getenvid>
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	ff 75 0c             	pushl  0xc(%ebp)
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	56                   	push   %esi
  8015dd:	50                   	push   %eax
  8015de:	68 44 25 80 00       	push   $0x802544
  8015e3:	e8 bb 00 00 00       	call   8016a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015e8:	83 c4 18             	add    $0x18,%esp
  8015eb:	53                   	push   %ebx
  8015ec:	ff 75 10             	pushl  0x10(%ebp)
  8015ef:	e8 5a 00 00 00       	call   80164e <vcprintf>
	cprintf("\n");
  8015f4:	c7 04 24 30 25 80 00 	movl   $0x802530,(%esp)
  8015fb:	e8 a3 00 00 00       	call   8016a3 <cprintf>
  801600:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801603:	cc                   	int3   
  801604:	eb fd                	jmp    801603 <_panic+0x47>

00801606 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801606:	f3 0f 1e fb          	endbr32 
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801614:	8b 13                	mov    (%ebx),%edx
  801616:	8d 42 01             	lea    0x1(%edx),%eax
  801619:	89 03                	mov    %eax,(%ebx)
  80161b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801622:	3d ff 00 00 00       	cmp    $0xff,%eax
  801627:	74 09                	je     801632 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801629:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80162d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801630:	c9                   	leave  
  801631:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	68 ff 00 00 00       	push   $0xff
  80163a:	8d 43 08             	lea    0x8(%ebx),%eax
  80163d:	50                   	push   %eax
  80163e:	e8 73 ea ff ff       	call   8000b6 <sys_cputs>
		b->idx = 0;
  801643:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	eb db                	jmp    801629 <putch+0x23>

0080164e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80164e:	f3 0f 1e fb          	endbr32 
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80165b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801662:	00 00 00 
	b.cnt = 0;
  801665:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80166c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80166f:	ff 75 0c             	pushl  0xc(%ebp)
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80167b:	50                   	push   %eax
  80167c:	68 06 16 80 00       	push   $0x801606
  801681:	e8 20 01 00 00       	call   8017a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801686:	83 c4 08             	add    $0x8,%esp
  801689:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80168f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801695:	50                   	push   %eax
  801696:	e8 1b ea ff ff       	call   8000b6 <sys_cputs>

	return b.cnt;
}
  80169b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016a3:	f3 0f 1e fb          	endbr32 
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016ad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 08             	pushl  0x8(%ebp)
  8016b4:	e8 95 ff ff ff       	call   80164e <vcprintf>
	va_end(ap);

	return cnt;
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	57                   	push   %edi
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 1c             	sub    $0x1c,%esp
  8016c4:	89 c7                	mov    %eax,%edi
  8016c6:	89 d6                	mov    %edx,%esi
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	89 d1                	mov    %edx,%ecx
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016d5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016e8:	39 c2                	cmp    %eax,%edx
  8016ea:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016ed:	72 3e                	jb     80172d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016ef:	83 ec 0c             	sub    $0xc,%esp
  8016f2:	ff 75 18             	pushl  0x18(%ebp)
  8016f5:	83 eb 01             	sub    $0x1,%ebx
  8016f8:	53                   	push   %ebx
  8016f9:	50                   	push   %eax
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801700:	ff 75 e0             	pushl  -0x20(%ebp)
  801703:	ff 75 dc             	pushl  -0x24(%ebp)
  801706:	ff 75 d8             	pushl  -0x28(%ebp)
  801709:	e8 62 0a 00 00       	call   802170 <__udivdi3>
  80170e:	83 c4 18             	add    $0x18,%esp
  801711:	52                   	push   %edx
  801712:	50                   	push   %eax
  801713:	89 f2                	mov    %esi,%edx
  801715:	89 f8                	mov    %edi,%eax
  801717:	e8 9f ff ff ff       	call   8016bb <printnum>
  80171c:	83 c4 20             	add    $0x20,%esp
  80171f:	eb 13                	jmp    801734 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	56                   	push   %esi
  801725:	ff 75 18             	pushl  0x18(%ebp)
  801728:	ff d7                	call   *%edi
  80172a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80172d:	83 eb 01             	sub    $0x1,%ebx
  801730:	85 db                	test   %ebx,%ebx
  801732:	7f ed                	jg     801721 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	56                   	push   %esi
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80173e:	ff 75 e0             	pushl  -0x20(%ebp)
  801741:	ff 75 dc             	pushl  -0x24(%ebp)
  801744:	ff 75 d8             	pushl  -0x28(%ebp)
  801747:	e8 34 0b 00 00       	call   802280 <__umoddi3>
  80174c:	83 c4 14             	add    $0x14,%esp
  80174f:	0f be 80 67 25 80 00 	movsbl 0x802567(%eax),%eax
  801756:	50                   	push   %eax
  801757:	ff d7                	call   *%edi
}
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5f                   	pop    %edi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801764:	f3 0f 1e fb          	endbr32 
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80176e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801772:	8b 10                	mov    (%eax),%edx
  801774:	3b 50 04             	cmp    0x4(%eax),%edx
  801777:	73 0a                	jae    801783 <sprintputch+0x1f>
		*b->buf++ = ch;
  801779:	8d 4a 01             	lea    0x1(%edx),%ecx
  80177c:	89 08                	mov    %ecx,(%eax)
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	88 02                	mov    %al,(%edx)
}
  801783:	5d                   	pop    %ebp
  801784:	c3                   	ret    

00801785 <printfmt>:
{
  801785:	f3 0f 1e fb          	endbr32 
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80178f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801792:	50                   	push   %eax
  801793:	ff 75 10             	pushl  0x10(%ebp)
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	e8 05 00 00 00       	call   8017a6 <vprintfmt>
}
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <vprintfmt>:
{
  8017a6:	f3 0f 1e fb          	endbr32 
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	57                   	push   %edi
  8017ae:	56                   	push   %esi
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 3c             	sub    $0x3c,%esp
  8017b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8017b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017bc:	e9 8e 03 00 00       	jmp    801b4f <vprintfmt+0x3a9>
		padc = ' ';
  8017c1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017df:	8d 47 01             	lea    0x1(%edi),%eax
  8017e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017e5:	0f b6 17             	movzbl (%edi),%edx
  8017e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017eb:	3c 55                	cmp    $0x55,%al
  8017ed:	0f 87 df 03 00 00    	ja     801bd2 <vprintfmt+0x42c>
  8017f3:	0f b6 c0             	movzbl %al,%eax
  8017f6:	3e ff 24 85 a0 26 80 	notrack jmp *0x8026a0(,%eax,4)
  8017fd:	00 
  8017fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801801:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801805:	eb d8                	jmp    8017df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801807:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80180a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80180e:	eb cf                	jmp    8017df <vprintfmt+0x39>
  801810:	0f b6 d2             	movzbl %dl,%edx
  801813:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
  80181b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80181e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801821:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801825:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801828:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80182b:	83 f9 09             	cmp    $0x9,%ecx
  80182e:	77 55                	ja     801885 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801830:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801833:	eb e9                	jmp    80181e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801835:	8b 45 14             	mov    0x14(%ebp),%eax
  801838:	8b 00                	mov    (%eax),%eax
  80183a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80183d:	8b 45 14             	mov    0x14(%ebp),%eax
  801840:	8d 40 04             	lea    0x4(%eax),%eax
  801843:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801849:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184d:	79 90                	jns    8017df <vprintfmt+0x39>
				width = precision, precision = -1;
  80184f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801852:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801855:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80185c:	eb 81                	jmp    8017df <vprintfmt+0x39>
  80185e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801861:	85 c0                	test   %eax,%eax
  801863:	ba 00 00 00 00       	mov    $0x0,%edx
  801868:	0f 49 d0             	cmovns %eax,%edx
  80186b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80186e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801871:	e9 69 ff ff ff       	jmp    8017df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801879:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801880:	e9 5a ff ff ff       	jmp    8017df <vprintfmt+0x39>
  801885:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801888:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80188b:	eb bc                	jmp    801849 <vprintfmt+0xa3>
			lflag++;
  80188d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801890:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801893:	e9 47 ff ff ff       	jmp    8017df <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801898:	8b 45 14             	mov    0x14(%ebp),%eax
  80189b:	8d 78 04             	lea    0x4(%eax),%edi
  80189e:	83 ec 08             	sub    $0x8,%esp
  8018a1:	53                   	push   %ebx
  8018a2:	ff 30                	pushl  (%eax)
  8018a4:	ff d6                	call   *%esi
			break;
  8018a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8018a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018ac:	e9 9b 02 00 00       	jmp    801b4c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b4:	8d 78 04             	lea    0x4(%eax),%edi
  8018b7:	8b 00                	mov    (%eax),%eax
  8018b9:	99                   	cltd   
  8018ba:	31 d0                	xor    %edx,%eax
  8018bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018be:	83 f8 0f             	cmp    $0xf,%eax
  8018c1:	7f 23                	jg     8018e6 <vprintfmt+0x140>
  8018c3:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  8018ca:	85 d2                	test   %edx,%edx
  8018cc:	74 18                	je     8018e6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018ce:	52                   	push   %edx
  8018cf:	68 c5 24 80 00       	push   $0x8024c5
  8018d4:	53                   	push   %ebx
  8018d5:	56                   	push   %esi
  8018d6:	e8 aa fe ff ff       	call   801785 <printfmt>
  8018db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018e1:	e9 66 02 00 00       	jmp    801b4c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018e6:	50                   	push   %eax
  8018e7:	68 7f 25 80 00       	push   $0x80257f
  8018ec:	53                   	push   %ebx
  8018ed:	56                   	push   %esi
  8018ee:	e8 92 fe ff ff       	call   801785 <printfmt>
  8018f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018f6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018f9:	e9 4e 02 00 00       	jmp    801b4c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801901:	83 c0 04             	add    $0x4,%eax
  801904:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801907:	8b 45 14             	mov    0x14(%ebp),%eax
  80190a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80190c:	85 d2                	test   %edx,%edx
  80190e:	b8 78 25 80 00       	mov    $0x802578,%eax
  801913:	0f 45 c2             	cmovne %edx,%eax
  801916:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80191d:	7e 06                	jle    801925 <vprintfmt+0x17f>
  80191f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801923:	75 0d                	jne    801932 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801925:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801928:	89 c7                	mov    %eax,%edi
  80192a:	03 45 e0             	add    -0x20(%ebp),%eax
  80192d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801930:	eb 55                	jmp    801987 <vprintfmt+0x1e1>
  801932:	83 ec 08             	sub    $0x8,%esp
  801935:	ff 75 d8             	pushl  -0x28(%ebp)
  801938:	ff 75 cc             	pushl  -0x34(%ebp)
  80193b:	e8 46 03 00 00       	call   801c86 <strnlen>
  801940:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801943:	29 c2                	sub    %eax,%edx
  801945:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80194d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801951:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801954:	85 ff                	test   %edi,%edi
  801956:	7e 11                	jle    801969 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	53                   	push   %ebx
  80195c:	ff 75 e0             	pushl  -0x20(%ebp)
  80195f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801961:	83 ef 01             	sub    $0x1,%edi
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	eb eb                	jmp    801954 <vprintfmt+0x1ae>
  801969:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80196c:	85 d2                	test   %edx,%edx
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	0f 49 c2             	cmovns %edx,%eax
  801976:	29 c2                	sub    %eax,%edx
  801978:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80197b:	eb a8                	jmp    801925 <vprintfmt+0x17f>
					putch(ch, putdat);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	53                   	push   %ebx
  801981:	52                   	push   %edx
  801982:	ff d6                	call   *%esi
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80198a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80198c:	83 c7 01             	add    $0x1,%edi
  80198f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801993:	0f be d0             	movsbl %al,%edx
  801996:	85 d2                	test   %edx,%edx
  801998:	74 4b                	je     8019e5 <vprintfmt+0x23f>
  80199a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80199e:	78 06                	js     8019a6 <vprintfmt+0x200>
  8019a0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8019a4:	78 1e                	js     8019c4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8019a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019aa:	74 d1                	je     80197d <vprintfmt+0x1d7>
  8019ac:	0f be c0             	movsbl %al,%eax
  8019af:	83 e8 20             	sub    $0x20,%eax
  8019b2:	83 f8 5e             	cmp    $0x5e,%eax
  8019b5:	76 c6                	jbe    80197d <vprintfmt+0x1d7>
					putch('?', putdat);
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	53                   	push   %ebx
  8019bb:	6a 3f                	push   $0x3f
  8019bd:	ff d6                	call   *%esi
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	eb c3                	jmp    801987 <vprintfmt+0x1e1>
  8019c4:	89 cf                	mov    %ecx,%edi
  8019c6:	eb 0e                	jmp    8019d6 <vprintfmt+0x230>
				putch(' ', putdat);
  8019c8:	83 ec 08             	sub    $0x8,%esp
  8019cb:	53                   	push   %ebx
  8019cc:	6a 20                	push   $0x20
  8019ce:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019d0:	83 ef 01             	sub    $0x1,%edi
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 ff                	test   %edi,%edi
  8019d8:	7f ee                	jg     8019c8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8019e0:	e9 67 01 00 00       	jmp    801b4c <vprintfmt+0x3a6>
  8019e5:	89 cf                	mov    %ecx,%edi
  8019e7:	eb ed                	jmp    8019d6 <vprintfmt+0x230>
	if (lflag >= 2)
  8019e9:	83 f9 01             	cmp    $0x1,%ecx
  8019ec:	7f 1b                	jg     801a09 <vprintfmt+0x263>
	else if (lflag)
  8019ee:	85 c9                	test   %ecx,%ecx
  8019f0:	74 63                	je     801a55 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f5:	8b 00                	mov    (%eax),%eax
  8019f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019fa:	99                   	cltd   
  8019fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801a01:	8d 40 04             	lea    0x4(%eax),%eax
  801a04:	89 45 14             	mov    %eax,0x14(%ebp)
  801a07:	eb 17                	jmp    801a20 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a09:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0c:	8b 50 04             	mov    0x4(%eax),%edx
  801a0f:	8b 00                	mov    (%eax),%eax
  801a11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a17:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1a:	8d 40 08             	lea    0x8(%eax),%eax
  801a1d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a20:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a23:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a26:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a2b:	85 c9                	test   %ecx,%ecx
  801a2d:	0f 89 ff 00 00 00    	jns    801b32 <vprintfmt+0x38c>
				putch('-', putdat);
  801a33:	83 ec 08             	sub    $0x8,%esp
  801a36:	53                   	push   %ebx
  801a37:	6a 2d                	push   $0x2d
  801a39:	ff d6                	call   *%esi
				num = -(long long) num;
  801a3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a3e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a41:	f7 da                	neg    %edx
  801a43:	83 d1 00             	adc    $0x0,%ecx
  801a46:	f7 d9                	neg    %ecx
  801a48:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a4b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a50:	e9 dd 00 00 00       	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	8b 00                	mov    (%eax),%eax
  801a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a5d:	99                   	cltd   
  801a5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	8d 40 04             	lea    0x4(%eax),%eax
  801a67:	89 45 14             	mov    %eax,0x14(%ebp)
  801a6a:	eb b4                	jmp    801a20 <vprintfmt+0x27a>
	if (lflag >= 2)
  801a6c:	83 f9 01             	cmp    $0x1,%ecx
  801a6f:	7f 1e                	jg     801a8f <vprintfmt+0x2e9>
	else if (lflag)
  801a71:	85 c9                	test   %ecx,%ecx
  801a73:	74 32                	je     801aa7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a75:	8b 45 14             	mov    0x14(%ebp),%eax
  801a78:	8b 10                	mov    (%eax),%edx
  801a7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7f:	8d 40 04             	lea    0x4(%eax),%eax
  801a82:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a85:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a8a:	e9 a3 00 00 00       	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	8b 10                	mov    (%eax),%edx
  801a94:	8b 48 04             	mov    0x4(%eax),%ecx
  801a97:	8d 40 08             	lea    0x8(%eax),%eax
  801a9a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a9d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801aa2:	e9 8b 00 00 00       	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aaa:	8b 10                	mov    (%eax),%edx
  801aac:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab1:	8d 40 04             	lea    0x4(%eax),%eax
  801ab4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ab7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801abc:	eb 74                	jmp    801b32 <vprintfmt+0x38c>
	if (lflag >= 2)
  801abe:	83 f9 01             	cmp    $0x1,%ecx
  801ac1:	7f 1b                	jg     801ade <vprintfmt+0x338>
	else if (lflag)
  801ac3:	85 c9                	test   %ecx,%ecx
  801ac5:	74 2c                	je     801af3 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ac7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aca:	8b 10                	mov    (%eax),%edx
  801acc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad1:	8d 40 04             	lea    0x4(%eax),%eax
  801ad4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ad7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801adc:	eb 54                	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	8b 10                	mov    (%eax),%edx
  801ae3:	8b 48 04             	mov    0x4(%eax),%ecx
  801ae6:	8d 40 08             	lea    0x8(%eax),%eax
  801ae9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801aec:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801af1:	eb 3f                	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801af3:	8b 45 14             	mov    0x14(%ebp),%eax
  801af6:	8b 10                	mov    (%eax),%edx
  801af8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afd:	8d 40 04             	lea    0x4(%eax),%eax
  801b00:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b03:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b08:	eb 28                	jmp    801b32 <vprintfmt+0x38c>
			putch('0', putdat);
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	53                   	push   %ebx
  801b0e:	6a 30                	push   $0x30
  801b10:	ff d6                	call   *%esi
			putch('x', putdat);
  801b12:	83 c4 08             	add    $0x8,%esp
  801b15:	53                   	push   %ebx
  801b16:	6a 78                	push   $0x78
  801b18:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1d:	8b 10                	mov    (%eax),%edx
  801b1f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b24:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b27:	8d 40 04             	lea    0x4(%eax),%eax
  801b2a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b2d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b32:	83 ec 0c             	sub    $0xc,%esp
  801b35:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b39:	57                   	push   %edi
  801b3a:	ff 75 e0             	pushl  -0x20(%ebp)
  801b3d:	50                   	push   %eax
  801b3e:	51                   	push   %ecx
  801b3f:	52                   	push   %edx
  801b40:	89 da                	mov    %ebx,%edx
  801b42:	89 f0                	mov    %esi,%eax
  801b44:	e8 72 fb ff ff       	call   8016bb <printnum>
			break;
  801b49:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b4f:	83 c7 01             	add    $0x1,%edi
  801b52:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b56:	83 f8 25             	cmp    $0x25,%eax
  801b59:	0f 84 62 fc ff ff    	je     8017c1 <vprintfmt+0x1b>
			if (ch == '\0')
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	0f 84 8b 00 00 00    	je     801bf2 <vprintfmt+0x44c>
			putch(ch, putdat);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	53                   	push   %ebx
  801b6b:	50                   	push   %eax
  801b6c:	ff d6                	call   *%esi
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	eb dc                	jmp    801b4f <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b73:	83 f9 01             	cmp    $0x1,%ecx
  801b76:	7f 1b                	jg     801b93 <vprintfmt+0x3ed>
	else if (lflag)
  801b78:	85 c9                	test   %ecx,%ecx
  801b7a:	74 2c                	je     801ba8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7f:	8b 10                	mov    (%eax),%edx
  801b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b86:	8d 40 04             	lea    0x4(%eax),%eax
  801b89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b8c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b91:	eb 9f                	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b93:	8b 45 14             	mov    0x14(%ebp),%eax
  801b96:	8b 10                	mov    (%eax),%edx
  801b98:	8b 48 04             	mov    0x4(%eax),%ecx
  801b9b:	8d 40 08             	lea    0x8(%eax),%eax
  801b9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801ba6:	eb 8a                	jmp    801b32 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ba8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bab:	8b 10                	mov    (%eax),%edx
  801bad:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb2:	8d 40 04             	lea    0x4(%eax),%eax
  801bb5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bb8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bbd:	e9 70 ff ff ff       	jmp    801b32 <vprintfmt+0x38c>
			putch(ch, putdat);
  801bc2:	83 ec 08             	sub    $0x8,%esp
  801bc5:	53                   	push   %ebx
  801bc6:	6a 25                	push   $0x25
  801bc8:	ff d6                	call   *%esi
			break;
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	e9 7a ff ff ff       	jmp    801b4c <vprintfmt+0x3a6>
			putch('%', putdat);
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	53                   	push   %ebx
  801bd6:	6a 25                	push   $0x25
  801bd8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	89 f8                	mov    %edi,%eax
  801bdf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801be3:	74 05                	je     801bea <vprintfmt+0x444>
  801be5:	83 e8 01             	sub    $0x1,%eax
  801be8:	eb f5                	jmp    801bdf <vprintfmt+0x439>
  801bea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bed:	e9 5a ff ff ff       	jmp    801b4c <vprintfmt+0x3a6>
}
  801bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    

00801bfa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bfa:	f3 0f 1e fb          	endbr32 
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 18             	sub    $0x18,%esp
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c0d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c11:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	74 26                	je     801c45 <vsnprintf+0x4b>
  801c1f:	85 d2                	test   %edx,%edx
  801c21:	7e 22                	jle    801c45 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c23:	ff 75 14             	pushl  0x14(%ebp)
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c2c:	50                   	push   %eax
  801c2d:	68 64 17 80 00       	push   $0x801764
  801c32:	e8 6f fb ff ff       	call   8017a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	83 c4 10             	add    $0x10,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    
		return -E_INVAL;
  801c45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c4a:	eb f7                	jmp    801c43 <vsnprintf+0x49>

00801c4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c4c:	f3 0f 1e fb          	endbr32 
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c56:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c59:	50                   	push   %eax
  801c5a:	ff 75 10             	pushl  0x10(%ebp)
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	e8 92 ff ff ff       	call   801bfa <vsnprintf>
	va_end(ap);

	return rc;
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c6a:	f3 0f 1e fb          	endbr32 
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c7d:	74 05                	je     801c84 <strlen+0x1a>
		n++;
  801c7f:	83 c0 01             	add    $0x1,%eax
  801c82:	eb f5                	jmp    801c79 <strlen+0xf>
	return n;
}
  801c84:	5d                   	pop    %ebp
  801c85:	c3                   	ret    

00801c86 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c86:	f3 0f 1e fb          	endbr32 
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	39 d0                	cmp    %edx,%eax
  801c9a:	74 0d                	je     801ca9 <strnlen+0x23>
  801c9c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ca0:	74 05                	je     801ca7 <strnlen+0x21>
		n++;
  801ca2:	83 c0 01             	add    $0x1,%eax
  801ca5:	eb f1                	jmp    801c98 <strnlen+0x12>
  801ca7:	89 c2                	mov    %eax,%edx
	return n;
}
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cad:	f3 0f 1e fb          	endbr32 
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	53                   	push   %ebx
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cc4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cc7:	83 c0 01             	add    $0x1,%eax
  801cca:	84 d2                	test   %dl,%dl
  801ccc:	75 f2                	jne    801cc0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	5b                   	pop    %ebx
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cd3:	f3 0f 1e fb          	endbr32 
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 10             	sub    $0x10,%esp
  801cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ce1:	53                   	push   %ebx
  801ce2:	e8 83 ff ff ff       	call   801c6a <strlen>
  801ce7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	01 d8                	add    %ebx,%eax
  801cef:	50                   	push   %eax
  801cf0:	e8 b8 ff ff ff       	call   801cad <strcpy>
	return dst;
}
  801cf5:	89 d8                	mov    %ebx,%eax
  801cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801cfc:	f3 0f 1e fb          	endbr32 
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	56                   	push   %esi
  801d04:	53                   	push   %ebx
  801d05:	8b 75 08             	mov    0x8(%ebp),%esi
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	89 f3                	mov    %esi,%ebx
  801d0d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d10:	89 f0                	mov    %esi,%eax
  801d12:	39 d8                	cmp    %ebx,%eax
  801d14:	74 11                	je     801d27 <strncpy+0x2b>
		*dst++ = *src;
  801d16:	83 c0 01             	add    $0x1,%eax
  801d19:	0f b6 0a             	movzbl (%edx),%ecx
  801d1c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d1f:	80 f9 01             	cmp    $0x1,%cl
  801d22:	83 da ff             	sbb    $0xffffffff,%edx
  801d25:	eb eb                	jmp    801d12 <strncpy+0x16>
	}
	return ret;
}
  801d27:	89 f0                	mov    %esi,%eax
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    

00801d2d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d2d:	f3 0f 1e fb          	endbr32 
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	56                   	push   %esi
  801d35:	53                   	push   %ebx
  801d36:	8b 75 08             	mov    0x8(%ebp),%esi
  801d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d3c:	8b 55 10             	mov    0x10(%ebp),%edx
  801d3f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d41:	85 d2                	test   %edx,%edx
  801d43:	74 21                	je     801d66 <strlcpy+0x39>
  801d45:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d49:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d4b:	39 c2                	cmp    %eax,%edx
  801d4d:	74 14                	je     801d63 <strlcpy+0x36>
  801d4f:	0f b6 19             	movzbl (%ecx),%ebx
  801d52:	84 db                	test   %bl,%bl
  801d54:	74 0b                	je     801d61 <strlcpy+0x34>
			*dst++ = *src++;
  801d56:	83 c1 01             	add    $0x1,%ecx
  801d59:	83 c2 01             	add    $0x1,%edx
  801d5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d5f:	eb ea                	jmp    801d4b <strlcpy+0x1e>
  801d61:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d63:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d66:	29 f0                	sub    %esi,%eax
}
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d6c:	f3 0f 1e fb          	endbr32 
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d79:	0f b6 01             	movzbl (%ecx),%eax
  801d7c:	84 c0                	test   %al,%al
  801d7e:	74 0c                	je     801d8c <strcmp+0x20>
  801d80:	3a 02                	cmp    (%edx),%al
  801d82:	75 08                	jne    801d8c <strcmp+0x20>
		p++, q++;
  801d84:	83 c1 01             	add    $0x1,%ecx
  801d87:	83 c2 01             	add    $0x1,%edx
  801d8a:	eb ed                	jmp    801d79 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d8c:	0f b6 c0             	movzbl %al,%eax
  801d8f:	0f b6 12             	movzbl (%edx),%edx
  801d92:	29 d0                	sub    %edx,%eax
}
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    

00801d96 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d96:	f3 0f 1e fb          	endbr32 
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	53                   	push   %ebx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	89 c3                	mov    %eax,%ebx
  801da6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801da9:	eb 06                	jmp    801db1 <strncmp+0x1b>
		n--, p++, q++;
  801dab:	83 c0 01             	add    $0x1,%eax
  801dae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801db1:	39 d8                	cmp    %ebx,%eax
  801db3:	74 16                	je     801dcb <strncmp+0x35>
  801db5:	0f b6 08             	movzbl (%eax),%ecx
  801db8:	84 c9                	test   %cl,%cl
  801dba:	74 04                	je     801dc0 <strncmp+0x2a>
  801dbc:	3a 0a                	cmp    (%edx),%cl
  801dbe:	74 eb                	je     801dab <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dc0:	0f b6 00             	movzbl (%eax),%eax
  801dc3:	0f b6 12             	movzbl (%edx),%edx
  801dc6:	29 d0                	sub    %edx,%eax
}
  801dc8:	5b                   	pop    %ebx
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    
		return 0;
  801dcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd0:	eb f6                	jmp    801dc8 <strncmp+0x32>

00801dd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dd2:	f3 0f 1e fb          	endbr32 
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801de0:	0f b6 10             	movzbl (%eax),%edx
  801de3:	84 d2                	test   %dl,%dl
  801de5:	74 09                	je     801df0 <strchr+0x1e>
		if (*s == c)
  801de7:	38 ca                	cmp    %cl,%dl
  801de9:	74 0a                	je     801df5 <strchr+0x23>
	for (; *s; s++)
  801deb:	83 c0 01             	add    $0x1,%eax
  801dee:	eb f0                	jmp    801de0 <strchr+0xe>
			return (char *) s;
	return 0;
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df5:	5d                   	pop    %ebp
  801df6:	c3                   	ret    

00801df7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801df7:	f3 0f 1e fb          	endbr32 
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e05:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e08:	38 ca                	cmp    %cl,%dl
  801e0a:	74 09                	je     801e15 <strfind+0x1e>
  801e0c:	84 d2                	test   %dl,%dl
  801e0e:	74 05                	je     801e15 <strfind+0x1e>
	for (; *s; s++)
  801e10:	83 c0 01             	add    $0x1,%eax
  801e13:	eb f0                	jmp    801e05 <strfind+0xe>
			break;
	return (char *) s;
}
  801e15:	5d                   	pop    %ebp
  801e16:	c3                   	ret    

00801e17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e17:	f3 0f 1e fb          	endbr32 
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	57                   	push   %edi
  801e1f:	56                   	push   %esi
  801e20:	53                   	push   %ebx
  801e21:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e27:	85 c9                	test   %ecx,%ecx
  801e29:	74 31                	je     801e5c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e2b:	89 f8                	mov    %edi,%eax
  801e2d:	09 c8                	or     %ecx,%eax
  801e2f:	a8 03                	test   $0x3,%al
  801e31:	75 23                	jne    801e56 <memset+0x3f>
		c &= 0xFF;
  801e33:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e37:	89 d3                	mov    %edx,%ebx
  801e39:	c1 e3 08             	shl    $0x8,%ebx
  801e3c:	89 d0                	mov    %edx,%eax
  801e3e:	c1 e0 18             	shl    $0x18,%eax
  801e41:	89 d6                	mov    %edx,%esi
  801e43:	c1 e6 10             	shl    $0x10,%esi
  801e46:	09 f0                	or     %esi,%eax
  801e48:	09 c2                	or     %eax,%edx
  801e4a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e4c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e4f:	89 d0                	mov    %edx,%eax
  801e51:	fc                   	cld    
  801e52:	f3 ab                	rep stos %eax,%es:(%edi)
  801e54:	eb 06                	jmp    801e5c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	fc                   	cld    
  801e5a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e5c:	89 f8                	mov    %edi,%eax
  801e5e:	5b                   	pop    %ebx
  801e5f:	5e                   	pop    %esi
  801e60:	5f                   	pop    %edi
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    

00801e63 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e63:	f3 0f 1e fb          	endbr32 
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	57                   	push   %edi
  801e6b:	56                   	push   %esi
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e72:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e75:	39 c6                	cmp    %eax,%esi
  801e77:	73 32                	jae    801eab <memmove+0x48>
  801e79:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	76 2b                	jbe    801eab <memmove+0x48>
		s += n;
		d += n;
  801e80:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e83:	89 fe                	mov    %edi,%esi
  801e85:	09 ce                	or     %ecx,%esi
  801e87:	09 d6                	or     %edx,%esi
  801e89:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e8f:	75 0e                	jne    801e9f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e91:	83 ef 04             	sub    $0x4,%edi
  801e94:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e9a:	fd                   	std    
  801e9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e9d:	eb 09                	jmp    801ea8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e9f:	83 ef 01             	sub    $0x1,%edi
  801ea2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801ea5:	fd                   	std    
  801ea6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ea8:	fc                   	cld    
  801ea9:	eb 1a                	jmp    801ec5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801eab:	89 c2                	mov    %eax,%edx
  801ead:	09 ca                	or     %ecx,%edx
  801eaf:	09 f2                	or     %esi,%edx
  801eb1:	f6 c2 03             	test   $0x3,%dl
  801eb4:	75 0a                	jne    801ec0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801eb6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801eb9:	89 c7                	mov    %eax,%edi
  801ebb:	fc                   	cld    
  801ebc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ebe:	eb 05                	jmp    801ec5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801ec0:	89 c7                	mov    %eax,%edi
  801ec2:	fc                   	cld    
  801ec3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801ec5:	5e                   	pop    %esi
  801ec6:	5f                   	pop    %edi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ec9:	f3 0f 1e fb          	endbr32 
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ed3:	ff 75 10             	pushl  0x10(%ebp)
  801ed6:	ff 75 0c             	pushl  0xc(%ebp)
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	e8 82 ff ff ff       	call   801e63 <memmove>
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ee3:	f3 0f 1e fb          	endbr32 
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	89 c6                	mov    %eax,%esi
  801ef4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ef7:	39 f0                	cmp    %esi,%eax
  801ef9:	74 1c                	je     801f17 <memcmp+0x34>
		if (*s1 != *s2)
  801efb:	0f b6 08             	movzbl (%eax),%ecx
  801efe:	0f b6 1a             	movzbl (%edx),%ebx
  801f01:	38 d9                	cmp    %bl,%cl
  801f03:	75 08                	jne    801f0d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f05:	83 c0 01             	add    $0x1,%eax
  801f08:	83 c2 01             	add    $0x1,%edx
  801f0b:	eb ea                	jmp    801ef7 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f0d:	0f b6 c1             	movzbl %cl,%eax
  801f10:	0f b6 db             	movzbl %bl,%ebx
  801f13:	29 d8                	sub    %ebx,%eax
  801f15:	eb 05                	jmp    801f1c <memcmp+0x39>
	}

	return 0;
  801f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1c:	5b                   	pop    %ebx
  801f1d:	5e                   	pop    %esi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f20:	f3 0f 1e fb          	endbr32 
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f2d:	89 c2                	mov    %eax,%edx
  801f2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f32:	39 d0                	cmp    %edx,%eax
  801f34:	73 09                	jae    801f3f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f36:	38 08                	cmp    %cl,(%eax)
  801f38:	74 05                	je     801f3f <memfind+0x1f>
	for (; s < ends; s++)
  801f3a:	83 c0 01             	add    $0x1,%eax
  801f3d:	eb f3                	jmp    801f32 <memfind+0x12>
			break;
	return (void *) s;
}
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f41:	f3 0f 1e fb          	endbr32 
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	57                   	push   %edi
  801f49:	56                   	push   %esi
  801f4a:	53                   	push   %ebx
  801f4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f51:	eb 03                	jmp    801f56 <strtol+0x15>
		s++;
  801f53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f56:	0f b6 01             	movzbl (%ecx),%eax
  801f59:	3c 20                	cmp    $0x20,%al
  801f5b:	74 f6                	je     801f53 <strtol+0x12>
  801f5d:	3c 09                	cmp    $0x9,%al
  801f5f:	74 f2                	je     801f53 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f61:	3c 2b                	cmp    $0x2b,%al
  801f63:	74 2a                	je     801f8f <strtol+0x4e>
	int neg = 0;
  801f65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f6a:	3c 2d                	cmp    $0x2d,%al
  801f6c:	74 2b                	je     801f99 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f74:	75 0f                	jne    801f85 <strtol+0x44>
  801f76:	80 39 30             	cmpb   $0x30,(%ecx)
  801f79:	74 28                	je     801fa3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f7b:	85 db                	test   %ebx,%ebx
  801f7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f82:	0f 44 d8             	cmove  %eax,%ebx
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f8d:	eb 46                	jmp    801fd5 <strtol+0x94>
		s++;
  801f8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f92:	bf 00 00 00 00       	mov    $0x0,%edi
  801f97:	eb d5                	jmp    801f6e <strtol+0x2d>
		s++, neg = 1;
  801f99:	83 c1 01             	add    $0x1,%ecx
  801f9c:	bf 01 00 00 00       	mov    $0x1,%edi
  801fa1:	eb cb                	jmp    801f6e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fa3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801fa7:	74 0e                	je     801fb7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801fa9:	85 db                	test   %ebx,%ebx
  801fab:	75 d8                	jne    801f85 <strtol+0x44>
		s++, base = 8;
  801fad:	83 c1 01             	add    $0x1,%ecx
  801fb0:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fb5:	eb ce                	jmp    801f85 <strtol+0x44>
		s += 2, base = 16;
  801fb7:	83 c1 02             	add    $0x2,%ecx
  801fba:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fbf:	eb c4                	jmp    801f85 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fc1:	0f be d2             	movsbl %dl,%edx
  801fc4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fc7:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fca:	7d 3a                	jge    802006 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fcc:	83 c1 01             	add    $0x1,%ecx
  801fcf:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fd3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fd5:	0f b6 11             	movzbl (%ecx),%edx
  801fd8:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fdb:	89 f3                	mov    %esi,%ebx
  801fdd:	80 fb 09             	cmp    $0x9,%bl
  801fe0:	76 df                	jbe    801fc1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fe2:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fe5:	89 f3                	mov    %esi,%ebx
  801fe7:	80 fb 19             	cmp    $0x19,%bl
  801fea:	77 08                	ja     801ff4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fec:	0f be d2             	movsbl %dl,%edx
  801fef:	83 ea 57             	sub    $0x57,%edx
  801ff2:	eb d3                	jmp    801fc7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801ff4:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ff7:	89 f3                	mov    %esi,%ebx
  801ff9:	80 fb 19             	cmp    $0x19,%bl
  801ffc:	77 08                	ja     802006 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ffe:	0f be d2             	movsbl %dl,%edx
  802001:	83 ea 37             	sub    $0x37,%edx
  802004:	eb c1                	jmp    801fc7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802006:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80200a:	74 05                	je     802011 <strtol+0xd0>
		*endptr = (char *) s;
  80200c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80200f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802011:	89 c2                	mov    %eax,%edx
  802013:	f7 da                	neg    %edx
  802015:	85 ff                	test   %edi,%edi
  802017:	0f 45 c2             	cmovne %edx,%eax
}
  80201a:	5b                   	pop    %ebx
  80201b:	5e                   	pop    %esi
  80201c:	5f                   	pop    %edi
  80201d:	5d                   	pop    %ebp
  80201e:	c3                   	ret    

0080201f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80201f:	f3 0f 1e fb          	endbr32 
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	8b 75 08             	mov    0x8(%ebp),%esi
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802031:	83 e8 01             	sub    $0x1,%eax
  802034:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802039:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80203e:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	50                   	push   %eax
  802046:	e8 07 e3 ff ff       	call   800352 <sys_ipc_recv>
	if (!t) {
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	75 2b                	jne    80207d <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802052:	85 f6                	test   %esi,%esi
  802054:	74 0a                	je     802060 <ipc_recv+0x41>
  802056:	a1 08 40 80 00       	mov    0x804008,%eax
  80205b:	8b 40 74             	mov    0x74(%eax),%eax
  80205e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802060:	85 db                	test   %ebx,%ebx
  802062:	74 0a                	je     80206e <ipc_recv+0x4f>
  802064:	a1 08 40 80 00       	mov    0x804008,%eax
  802069:	8b 40 78             	mov    0x78(%eax),%eax
  80206c:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80206e:	a1 08 40 80 00       	mov    0x804008,%eax
  802073:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80207d:	85 f6                	test   %esi,%esi
  80207f:	74 06                	je     802087 <ipc_recv+0x68>
  802081:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802087:	85 db                	test   %ebx,%ebx
  802089:	74 eb                	je     802076 <ipc_recv+0x57>
  80208b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802091:	eb e3                	jmp    802076 <ipc_recv+0x57>

00802093 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802093:	f3 0f 1e fb          	endbr32 
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	57                   	push   %edi
  80209b:	56                   	push   %esi
  80209c:	53                   	push   %ebx
  80209d:	83 ec 0c             	sub    $0xc,%esp
  8020a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020a9:	85 db                	test   %ebx,%ebx
  8020ab:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b0:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020b3:	ff 75 14             	pushl  0x14(%ebp)
  8020b6:	53                   	push   %ebx
  8020b7:	56                   	push   %esi
  8020b8:	57                   	push   %edi
  8020b9:	e8 6d e2 ff ff       	call   80032b <sys_ipc_try_send>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	74 1e                	je     8020e3 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020c8:	75 07                	jne    8020d1 <ipc_send+0x3e>
		sys_yield();
  8020ca:	e8 94 e0 ff ff       	call   800163 <sys_yield>
  8020cf:	eb e2                	jmp    8020b3 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020d1:	50                   	push   %eax
  8020d2:	68 5f 28 80 00       	push   $0x80285f
  8020d7:	6a 39                	push   $0x39
  8020d9:	68 71 28 80 00       	push   $0x802871
  8020de:	e8 d9 f4 ff ff       	call   8015bc <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e6:	5b                   	pop    %ebx
  8020e7:	5e                   	pop    %esi
  8020e8:	5f                   	pop    %edi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020eb:	f3 0f 1e fb          	endbr32 
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020fa:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020fd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802103:	8b 52 50             	mov    0x50(%edx),%edx
  802106:	39 ca                	cmp    %ecx,%edx
  802108:	74 11                	je     80211b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80210a:	83 c0 01             	add    $0x1,%eax
  80210d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802112:	75 e6                	jne    8020fa <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	eb 0b                	jmp    802126 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80211b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80211e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802123:	8b 40 48             	mov    0x48(%eax),%eax
}
  802126:	5d                   	pop    %ebp
  802127:	c3                   	ret    

00802128 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802128:	f3 0f 1e fb          	endbr32 
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802132:	89 c2                	mov    %eax,%edx
  802134:	c1 ea 16             	shr    $0x16,%edx
  802137:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80213e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802143:	f6 c1 01             	test   $0x1,%cl
  802146:	74 1c                	je     802164 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802148:	c1 e8 0c             	shr    $0xc,%eax
  80214b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802152:	a8 01                	test   $0x1,%al
  802154:	74 0e                	je     802164 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802156:	c1 e8 0c             	shr    $0xc,%eax
  802159:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802160:	ef 
  802161:	0f b7 d2             	movzwl %dx,%edx
}
  802164:	89 d0                	mov    %edx,%eax
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	66 90                	xchg   %ax,%ax
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	66 90                	xchg   %ax,%ax
  80216e:	66 90                	xchg   %ax,%ax

00802170 <__udivdi3>:
  802170:	f3 0f 1e fb          	endbr32 
  802174:	55                   	push   %ebp
  802175:	57                   	push   %edi
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	83 ec 1c             	sub    $0x1c,%esp
  80217b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80217f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802183:	8b 74 24 34          	mov    0x34(%esp),%esi
  802187:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80218b:	85 d2                	test   %edx,%edx
  80218d:	75 19                	jne    8021a8 <__udivdi3+0x38>
  80218f:	39 f3                	cmp    %esi,%ebx
  802191:	76 4d                	jbe    8021e0 <__udivdi3+0x70>
  802193:	31 ff                	xor    %edi,%edi
  802195:	89 e8                	mov    %ebp,%eax
  802197:	89 f2                	mov    %esi,%edx
  802199:	f7 f3                	div    %ebx
  80219b:	89 fa                	mov    %edi,%edx
  80219d:	83 c4 1c             	add    $0x1c,%esp
  8021a0:	5b                   	pop    %ebx
  8021a1:	5e                   	pop    %esi
  8021a2:	5f                   	pop    %edi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
  8021a5:	8d 76 00             	lea    0x0(%esi),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	76 14                	jbe    8021c0 <__udivdi3+0x50>
  8021ac:	31 ff                	xor    %edi,%edi
  8021ae:	31 c0                	xor    %eax,%eax
  8021b0:	89 fa                	mov    %edi,%edx
  8021b2:	83 c4 1c             	add    $0x1c,%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5f                   	pop    %edi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    
  8021ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c0:	0f bd fa             	bsr    %edx,%edi
  8021c3:	83 f7 1f             	xor    $0x1f,%edi
  8021c6:	75 48                	jne    802210 <__udivdi3+0xa0>
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	72 06                	jb     8021d2 <__udivdi3+0x62>
  8021cc:	31 c0                	xor    %eax,%eax
  8021ce:	39 eb                	cmp    %ebp,%ebx
  8021d0:	77 de                	ja     8021b0 <__udivdi3+0x40>
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb d7                	jmp    8021b0 <__udivdi3+0x40>
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 d9                	mov    %ebx,%ecx
  8021e2:	85 db                	test   %ebx,%ebx
  8021e4:	75 0b                	jne    8021f1 <__udivdi3+0x81>
  8021e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	f7 f3                	div    %ebx
  8021ef:	89 c1                	mov    %eax,%ecx
  8021f1:	31 d2                	xor    %edx,%edx
  8021f3:	89 f0                	mov    %esi,%eax
  8021f5:	f7 f1                	div    %ecx
  8021f7:	89 c6                	mov    %eax,%esi
  8021f9:	89 e8                	mov    %ebp,%eax
  8021fb:	89 f7                	mov    %esi,%edi
  8021fd:	f7 f1                	div    %ecx
  8021ff:	89 fa                	mov    %edi,%edx
  802201:	83 c4 1c             	add    $0x1c,%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 f9                	mov    %edi,%ecx
  802212:	b8 20 00 00 00       	mov    $0x20,%eax
  802217:	29 f8                	sub    %edi,%eax
  802219:	d3 e2                	shl    %cl,%edx
  80221b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	89 da                	mov    %ebx,%edx
  802223:	d3 ea                	shr    %cl,%edx
  802225:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802229:	09 d1                	or     %edx,%ecx
  80222b:	89 f2                	mov    %esi,%edx
  80222d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802231:	89 f9                	mov    %edi,%ecx
  802233:	d3 e3                	shl    %cl,%ebx
  802235:	89 c1                	mov    %eax,%ecx
  802237:	d3 ea                	shr    %cl,%edx
  802239:	89 f9                	mov    %edi,%ecx
  80223b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80223f:	89 eb                	mov    %ebp,%ebx
  802241:	d3 e6                	shl    %cl,%esi
  802243:	89 c1                	mov    %eax,%ecx
  802245:	d3 eb                	shr    %cl,%ebx
  802247:	09 de                	or     %ebx,%esi
  802249:	89 f0                	mov    %esi,%eax
  80224b:	f7 74 24 08          	divl   0x8(%esp)
  80224f:	89 d6                	mov    %edx,%esi
  802251:	89 c3                	mov    %eax,%ebx
  802253:	f7 64 24 0c          	mull   0xc(%esp)
  802257:	39 d6                	cmp    %edx,%esi
  802259:	72 15                	jb     802270 <__udivdi3+0x100>
  80225b:	89 f9                	mov    %edi,%ecx
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	39 c5                	cmp    %eax,%ebp
  802261:	73 04                	jae    802267 <__udivdi3+0xf7>
  802263:	39 d6                	cmp    %edx,%esi
  802265:	74 09                	je     802270 <__udivdi3+0x100>
  802267:	89 d8                	mov    %ebx,%eax
  802269:	31 ff                	xor    %edi,%edi
  80226b:	e9 40 ff ff ff       	jmp    8021b0 <__udivdi3+0x40>
  802270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802273:	31 ff                	xor    %edi,%edi
  802275:	e9 36 ff ff ff       	jmp    8021b0 <__udivdi3+0x40>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	f3 0f 1e fb          	endbr32 
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80228f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802293:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802297:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 19                	jne    8022b8 <__umoddi3+0x38>
  80229f:	39 df                	cmp    %ebx,%edi
  8022a1:	76 5d                	jbe    802300 <__umoddi3+0x80>
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	89 da                	mov    %ebx,%edx
  8022a7:	f7 f7                	div    %edi
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	89 f2                	mov    %esi,%edx
  8022ba:	39 d8                	cmp    %ebx,%eax
  8022bc:	76 12                	jbe    8022d0 <__umoddi3+0x50>
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	89 da                	mov    %ebx,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d0:	0f bd e8             	bsr    %eax,%ebp
  8022d3:	83 f5 1f             	xor    $0x1f,%ebp
  8022d6:	75 50                	jne    802328 <__umoddi3+0xa8>
  8022d8:	39 d8                	cmp    %ebx,%eax
  8022da:	0f 82 e0 00 00 00    	jb     8023c0 <__umoddi3+0x140>
  8022e0:	89 d9                	mov    %ebx,%ecx
  8022e2:	39 f7                	cmp    %esi,%edi
  8022e4:	0f 86 d6 00 00 00    	jbe    8023c0 <__umoddi3+0x140>
  8022ea:	89 d0                	mov    %edx,%eax
  8022ec:	89 ca                	mov    %ecx,%edx
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	89 fd                	mov    %edi,%ebp
  802302:	85 ff                	test   %edi,%edi
  802304:	75 0b                	jne    802311 <__umoddi3+0x91>
  802306:	b8 01 00 00 00       	mov    $0x1,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f7                	div    %edi
  80230f:	89 c5                	mov    %eax,%ebp
  802311:	89 d8                	mov    %ebx,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f5                	div    %ebp
  802317:	89 f0                	mov    %esi,%eax
  802319:	f7 f5                	div    %ebp
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	31 d2                	xor    %edx,%edx
  80231f:	eb 8c                	jmp    8022ad <__umoddi3+0x2d>
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 e9                	mov    %ebp,%ecx
  80232a:	ba 20 00 00 00       	mov    $0x20,%edx
  80232f:	29 ea                	sub    %ebp,%edx
  802331:	d3 e0                	shl    %cl,%eax
  802333:	89 44 24 08          	mov    %eax,0x8(%esp)
  802337:	89 d1                	mov    %edx,%ecx
  802339:	89 f8                	mov    %edi,%eax
  80233b:	d3 e8                	shr    %cl,%eax
  80233d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802341:	89 54 24 04          	mov    %edx,0x4(%esp)
  802345:	8b 54 24 04          	mov    0x4(%esp),%edx
  802349:	09 c1                	or     %eax,%ecx
  80234b:	89 d8                	mov    %ebx,%eax
  80234d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802351:	89 e9                	mov    %ebp,%ecx
  802353:	d3 e7                	shl    %cl,%edi
  802355:	89 d1                	mov    %edx,%ecx
  802357:	d3 e8                	shr    %cl,%eax
  802359:	89 e9                	mov    %ebp,%ecx
  80235b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80235f:	d3 e3                	shl    %cl,%ebx
  802361:	89 c7                	mov    %eax,%edi
  802363:	89 d1                	mov    %edx,%ecx
  802365:	89 f0                	mov    %esi,%eax
  802367:	d3 e8                	shr    %cl,%eax
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	89 fa                	mov    %edi,%edx
  80236d:	d3 e6                	shl    %cl,%esi
  80236f:	09 d8                	or     %ebx,%eax
  802371:	f7 74 24 08          	divl   0x8(%esp)
  802375:	89 d1                	mov    %edx,%ecx
  802377:	89 f3                	mov    %esi,%ebx
  802379:	f7 64 24 0c          	mull   0xc(%esp)
  80237d:	89 c6                	mov    %eax,%esi
  80237f:	89 d7                	mov    %edx,%edi
  802381:	39 d1                	cmp    %edx,%ecx
  802383:	72 06                	jb     80238b <__umoddi3+0x10b>
  802385:	75 10                	jne    802397 <__umoddi3+0x117>
  802387:	39 c3                	cmp    %eax,%ebx
  802389:	73 0c                	jae    802397 <__umoddi3+0x117>
  80238b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80238f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802393:	89 d7                	mov    %edx,%edi
  802395:	89 c6                	mov    %eax,%esi
  802397:	89 ca                	mov    %ecx,%edx
  802399:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80239e:	29 f3                	sub    %esi,%ebx
  8023a0:	19 fa                	sbb    %edi,%edx
  8023a2:	89 d0                	mov    %edx,%eax
  8023a4:	d3 e0                	shl    %cl,%eax
  8023a6:	89 e9                	mov    %ebp,%ecx
  8023a8:	d3 eb                	shr    %cl,%ebx
  8023aa:	d3 ea                	shr    %cl,%edx
  8023ac:	09 d8                	or     %ebx,%eax
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	29 fe                	sub    %edi,%esi
  8023c2:	19 c3                	sbb    %eax,%ebx
  8023c4:	89 f2                	mov    %esi,%edx
  8023c6:	89 d9                	mov    %ebx,%ecx
  8023c8:	e9 1d ff ff ff       	jmp    8022ea <__umoddi3+0x6a>
