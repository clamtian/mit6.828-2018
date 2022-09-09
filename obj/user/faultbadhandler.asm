
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 38 00 00 00       	call   800069 <libmain>
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
  80003a:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  80003d:	6a 07                	push   $0x7
  80003f:	68 00 f0 bf ee       	push   $0xeebff000
  800044:	6a 00                	push   $0x0
  800046:	e8 56 01 00 00       	call   8001a1 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	68 ef be ad de       	push   $0xdeadbeef
  800053:	6a 00                	push   $0x0
  800055:	e8 a6 02 00 00       	call   800300 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80005a:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800061:	00 00 00 
}
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	c9                   	leave  
  800068:	c3                   	ret    

00800069 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800069:	f3 0f 1e fb          	endbr32 
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	56                   	push   %esi
  800071:	53                   	push   %ebx
  800072:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800075:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800078:	e8 de 00 00 00       	call   80015b <sys_getenvid>
  80007d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800082:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800085:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008f:	85 db                	test   %ebx,%ebx
  800091:	7e 07                	jle    80009a <libmain+0x31>
		binaryname = argv[0];
  800093:	8b 06                	mov    (%esi),%eax
  800095:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	e8 8f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a4:	e8 0a 00 00 00       	call   8000b3 <exit>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000af:	5b                   	pop    %ebx
  8000b0:	5e                   	pop    %esi
  8000b1:	5d                   	pop    %ebp
  8000b2:	c3                   	ret    

008000b3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b3:	f3 0f 1e fb          	endbr32 
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bd:	e8 07 05 00 00       	call   8005c9 <close_all>
	sys_env_destroy(0);
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	6a 00                	push   $0x0
  8000c7:	e8 4a 00 00 00       	call   800116 <sys_env_destroy>
}
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d1:	f3 0f 1e fb          	endbr32 
  8000d5:	55                   	push   %ebp
  8000d6:	89 e5                	mov    %esp,%ebp
  8000d8:	57                   	push   %edi
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000db:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e6:	89 c3                	mov    %eax,%ebx
  8000e8:	89 c7                	mov    %eax,%edi
  8000ea:	89 c6                	mov    %eax,%esi
  8000ec:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f3:	f3 0f 1e fb          	endbr32 
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800102:	b8 01 00 00 00       	mov    $0x1,%eax
  800107:	89 d1                	mov    %edx,%ecx
  800109:	89 d3                	mov    %edx,%ebx
  80010b:	89 d7                	mov    %edx,%edi
  80010d:	89 d6                	mov    %edx,%esi
  80010f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800111:	5b                   	pop    %ebx
  800112:	5e                   	pop    %esi
  800113:	5f                   	pop    %edi
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800116:	f3 0f 1e fb          	endbr32 
  80011a:	55                   	push   %ebp
  80011b:	89 e5                	mov    %esp,%ebp
  80011d:	57                   	push   %edi
  80011e:	56                   	push   %esi
  80011f:	53                   	push   %ebx
  800120:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800123:	b9 00 00 00 00       	mov    $0x0,%ecx
  800128:	8b 55 08             	mov    0x8(%ebp),%edx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	89 cb                	mov    %ecx,%ebx
  800132:	89 cf                	mov    %ecx,%edi
  800134:	89 ce                	mov    %ecx,%esi
  800136:	cd 30                	int    $0x30
	if(check && ret > 0)
  800138:	85 c0                	test   %eax,%eax
  80013a:	7f 08                	jg     800144 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013f:	5b                   	pop    %ebx
  800140:	5e                   	pop    %esi
  800141:	5f                   	pop    %edi
  800142:	5d                   	pop    %ebp
  800143:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	50                   	push   %eax
  800148:	6a 03                	push   $0x3
  80014a:	68 0a 24 80 00       	push   $0x80240a
  80014f:	6a 23                	push   $0x23
  800151:	68 27 24 80 00       	push   $0x802427
  800156:	e8 7c 14 00 00       	call   8015d7 <_panic>

0080015b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015b:	f3 0f 1e fb          	endbr32 
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
	asm volatile("int %1\n"
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b8 02 00 00 00       	mov    $0x2,%eax
  80016f:	89 d1                	mov    %edx,%ecx
  800171:	89 d3                	mov    %edx,%ebx
  800173:	89 d7                	mov    %edx,%edi
  800175:	89 d6                	mov    %edx,%esi
  800177:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <sys_yield>:

void
sys_yield(void)
{
  80017e:	f3 0f 1e fb          	endbr32 
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	57                   	push   %edi
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
	asm volatile("int %1\n"
  800188:	ba 00 00 00 00       	mov    $0x0,%edx
  80018d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800192:	89 d1                	mov    %edx,%ecx
  800194:	89 d3                	mov    %edx,%ebx
  800196:	89 d7                	mov    %edx,%edi
  800198:	89 d6                	mov    %edx,%esi
  80019a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    

008001a1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a1:	f3 0f 1e fb          	endbr32 
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ae:	be 00 00 00 00       	mov    $0x0,%esi
  8001b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b9:	b8 04 00 00 00       	mov    $0x4,%eax
  8001be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c1:	89 f7                	mov    %esi,%edi
  8001c3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	7f 08                	jg     8001d1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cc:	5b                   	pop    %ebx
  8001cd:	5e                   	pop    %esi
  8001ce:	5f                   	pop    %edi
  8001cf:	5d                   	pop    %ebp
  8001d0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	50                   	push   %eax
  8001d5:	6a 04                	push   $0x4
  8001d7:	68 0a 24 80 00       	push   $0x80240a
  8001dc:	6a 23                	push   $0x23
  8001de:	68 27 24 80 00       	push   $0x802427
  8001e3:	e8 ef 13 00 00       	call   8015d7 <_panic>

008001e8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e8:	f3 0f 1e fb          	endbr32 
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fb:	b8 05 00 00 00       	mov    $0x5,%eax
  800200:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800203:	8b 7d 14             	mov    0x14(%ebp),%edi
  800206:	8b 75 18             	mov    0x18(%ebp),%esi
  800209:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020b:	85 c0                	test   %eax,%eax
  80020d:	7f 08                	jg     800217 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80020f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800212:	5b                   	pop    %ebx
  800213:	5e                   	pop    %esi
  800214:	5f                   	pop    %edi
  800215:	5d                   	pop    %ebp
  800216:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	50                   	push   %eax
  80021b:	6a 05                	push   $0x5
  80021d:	68 0a 24 80 00       	push   $0x80240a
  800222:	6a 23                	push   $0x23
  800224:	68 27 24 80 00       	push   $0x802427
  800229:	e8 a9 13 00 00       	call   8015d7 <_panic>

0080022e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80022e:	f3 0f 1e fb          	endbr32 
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800240:	8b 55 08             	mov    0x8(%ebp),%edx
  800243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800246:	b8 06 00 00 00       	mov    $0x6,%eax
  80024b:	89 df                	mov    %ebx,%edi
  80024d:	89 de                	mov    %ebx,%esi
  80024f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800251:	85 c0                	test   %eax,%eax
  800253:	7f 08                	jg     80025d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800258:	5b                   	pop    %ebx
  800259:	5e                   	pop    %esi
  80025a:	5f                   	pop    %edi
  80025b:	5d                   	pop    %ebp
  80025c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	50                   	push   %eax
  800261:	6a 06                	push   $0x6
  800263:	68 0a 24 80 00       	push   $0x80240a
  800268:	6a 23                	push   $0x23
  80026a:	68 27 24 80 00       	push   $0x802427
  80026f:	e8 63 13 00 00       	call   8015d7 <_panic>

00800274 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800274:	f3 0f 1e fb          	endbr32 
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800281:	bb 00 00 00 00       	mov    $0x0,%ebx
  800286:	8b 55 08             	mov    0x8(%ebp),%edx
  800289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028c:	b8 08 00 00 00       	mov    $0x8,%eax
  800291:	89 df                	mov    %ebx,%edi
  800293:	89 de                	mov    %ebx,%esi
  800295:	cd 30                	int    $0x30
	if(check && ret > 0)
  800297:	85 c0                	test   %eax,%eax
  800299:	7f 08                	jg     8002a3 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80029b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029e:	5b                   	pop    %ebx
  80029f:	5e                   	pop    %esi
  8002a0:	5f                   	pop    %edi
  8002a1:	5d                   	pop    %ebp
  8002a2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a3:	83 ec 0c             	sub    $0xc,%esp
  8002a6:	50                   	push   %eax
  8002a7:	6a 08                	push   $0x8
  8002a9:	68 0a 24 80 00       	push   $0x80240a
  8002ae:	6a 23                	push   $0x23
  8002b0:	68 27 24 80 00       	push   $0x802427
  8002b5:	e8 1d 13 00 00       	call   8015d7 <_panic>

008002ba <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ba:	f3 0f 1e fb          	endbr32 
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	57                   	push   %edi
  8002c2:	56                   	push   %esi
  8002c3:	53                   	push   %ebx
  8002c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d2:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d7:	89 df                	mov    %ebx,%edi
  8002d9:	89 de                	mov    %ebx,%esi
  8002db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002dd:	85 c0                	test   %eax,%eax
  8002df:	7f 08                	jg     8002e9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e9:	83 ec 0c             	sub    $0xc,%esp
  8002ec:	50                   	push   %eax
  8002ed:	6a 09                	push   $0x9
  8002ef:	68 0a 24 80 00       	push   $0x80240a
  8002f4:	6a 23                	push   $0x23
  8002f6:	68 27 24 80 00       	push   $0x802427
  8002fb:	e8 d7 12 00 00       	call   8015d7 <_panic>

00800300 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800300:	f3 0f 1e fb          	endbr32 
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	57                   	push   %edi
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800312:	8b 55 08             	mov    0x8(%ebp),%edx
  800315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800318:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031d:	89 df                	mov    %ebx,%edi
  80031f:	89 de                	mov    %ebx,%esi
  800321:	cd 30                	int    $0x30
	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7f 08                	jg     80032f <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032a:	5b                   	pop    %ebx
  80032b:	5e                   	pop    %esi
  80032c:	5f                   	pop    %edi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	50                   	push   %eax
  800333:	6a 0a                	push   $0xa
  800335:	68 0a 24 80 00       	push   $0x80240a
  80033a:	6a 23                	push   $0x23
  80033c:	68 27 24 80 00       	push   $0x802427
  800341:	e8 91 12 00 00       	call   8015d7 <_panic>

00800346 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800356:	b8 0c 00 00 00       	mov    $0xc,%eax
  80035b:	be 00 00 00 00       	mov    $0x0,%esi
  800360:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800363:	8b 7d 14             	mov    0x14(%ebp),%edi
  800366:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800368:	5b                   	pop    %ebx
  800369:	5e                   	pop    %esi
  80036a:	5f                   	pop    %edi
  80036b:	5d                   	pop    %ebp
  80036c:	c3                   	ret    

0080036d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80036d:	f3 0f 1e fb          	endbr32 
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	57                   	push   %edi
  800375:	56                   	push   %esi
  800376:	53                   	push   %ebx
  800377:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80037a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037f:	8b 55 08             	mov    0x8(%ebp),%edx
  800382:	b8 0d 00 00 00       	mov    $0xd,%eax
  800387:	89 cb                	mov    %ecx,%ebx
  800389:	89 cf                	mov    %ecx,%edi
  80038b:	89 ce                	mov    %ecx,%esi
  80038d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80038f:	85 c0                	test   %eax,%eax
  800391:	7f 08                	jg     80039b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800393:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800396:	5b                   	pop    %ebx
  800397:	5e                   	pop    %esi
  800398:	5f                   	pop    %edi
  800399:	5d                   	pop    %ebp
  80039a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	50                   	push   %eax
  80039f:	6a 0d                	push   $0xd
  8003a1:	68 0a 24 80 00       	push   $0x80240a
  8003a6:	6a 23                	push   $0x23
  8003a8:	68 27 24 80 00       	push   $0x802427
  8003ad:	e8 25 12 00 00       	call   8015d7 <_panic>

008003b2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	57                   	push   %edi
  8003ba:	56                   	push   %esi
  8003bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003c6:	89 d1                	mov    %edx,%ecx
  8003c8:	89 d3                	mov    %edx,%ebx
  8003ca:	89 d7                	mov    %edx,%edi
  8003cc:	89 d6                	mov    %edx,%esi
  8003ce:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003d0:	5b                   	pop    %ebx
  8003d1:	5e                   	pop    %esi
  8003d2:	5f                   	pop    %edi
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    

008003d5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003d5:	f3 0f 1e fb          	endbr32 
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	05 00 00 00 30       	add    $0x30000000,%eax
  8003e4:	c1 e8 0c             	shr    $0xc,%eax
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003e9:	f3 0f 1e fb          	endbr32 
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003fd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800402:	5d                   	pop    %ebp
  800403:	c3                   	ret    

00800404 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800404:	f3 0f 1e fb          	endbr32 
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800410:	89 c2                	mov    %eax,%edx
  800412:	c1 ea 16             	shr    $0x16,%edx
  800415:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80041c:	f6 c2 01             	test   $0x1,%dl
  80041f:	74 2d                	je     80044e <fd_alloc+0x4a>
  800421:	89 c2                	mov    %eax,%edx
  800423:	c1 ea 0c             	shr    $0xc,%edx
  800426:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80042d:	f6 c2 01             	test   $0x1,%dl
  800430:	74 1c                	je     80044e <fd_alloc+0x4a>
  800432:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800437:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80043c:	75 d2                	jne    800410 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800447:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80044c:	eb 0a                	jmp    800458 <fd_alloc+0x54>
			*fd_store = fd;
  80044e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800451:	89 01                	mov    %eax,(%ecx)
			return 0;
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80045a:	f3 0f 1e fb          	endbr32 
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800464:	83 f8 1f             	cmp    $0x1f,%eax
  800467:	77 30                	ja     800499 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800469:	c1 e0 0c             	shl    $0xc,%eax
  80046c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800471:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800477:	f6 c2 01             	test   $0x1,%dl
  80047a:	74 24                	je     8004a0 <fd_lookup+0x46>
  80047c:	89 c2                	mov    %eax,%edx
  80047e:	c1 ea 0c             	shr    $0xc,%edx
  800481:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800488:	f6 c2 01             	test   $0x1,%dl
  80048b:	74 1a                	je     8004a7 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80048d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800490:	89 02                	mov    %eax,(%edx)
	return 0;
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    
		return -E_INVAL;
  800499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80049e:	eb f7                	jmp    800497 <fd_lookup+0x3d>
		return -E_INVAL;
  8004a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004a5:	eb f0                	jmp    800497 <fd_lookup+0x3d>
  8004a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ac:	eb e9                	jmp    800497 <fd_lookup+0x3d>

008004ae <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004ae:	f3 0f 1e fb          	endbr32 
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8004bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c0:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004c5:	39 08                	cmp    %ecx,(%eax)
  8004c7:	74 38                	je     800501 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004c9:	83 c2 01             	add    $0x1,%edx
  8004cc:	8b 04 95 b4 24 80 00 	mov    0x8024b4(,%edx,4),%eax
  8004d3:	85 c0                	test   %eax,%eax
  8004d5:	75 ee                	jne    8004c5 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8004dc:	8b 40 48             	mov    0x48(%eax),%eax
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	51                   	push   %ecx
  8004e3:	50                   	push   %eax
  8004e4:	68 38 24 80 00       	push   $0x802438
  8004e9:	e8 d0 11 00 00       	call   8016be <cprintf>
	*dev = 0;
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004ff:	c9                   	leave  
  800500:	c3                   	ret    
			*dev = devtab[i];
  800501:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800504:	89 01                	mov    %eax,(%ecx)
			return 0;
  800506:	b8 00 00 00 00       	mov    $0x0,%eax
  80050b:	eb f2                	jmp    8004ff <dev_lookup+0x51>

0080050d <fd_close>:
{
  80050d:	f3 0f 1e fb          	endbr32 
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	57                   	push   %edi
  800515:	56                   	push   %esi
  800516:	53                   	push   %ebx
  800517:	83 ec 24             	sub    $0x24,%esp
  80051a:	8b 75 08             	mov    0x8(%ebp),%esi
  80051d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800520:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800523:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800524:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80052a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80052d:	50                   	push   %eax
  80052e:	e8 27 ff ff ff       	call   80045a <fd_lookup>
  800533:	89 c3                	mov    %eax,%ebx
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	85 c0                	test   %eax,%eax
  80053a:	78 05                	js     800541 <fd_close+0x34>
	    || fd != fd2)
  80053c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80053f:	74 16                	je     800557 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800541:	89 f8                	mov    %edi,%eax
  800543:	84 c0                	test   %al,%al
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	0f 44 d8             	cmove  %eax,%ebx
}
  80054d:	89 d8                	mov    %ebx,%eax
  80054f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800552:	5b                   	pop    %ebx
  800553:	5e                   	pop    %esi
  800554:	5f                   	pop    %edi
  800555:	5d                   	pop    %ebp
  800556:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80055d:	50                   	push   %eax
  80055e:	ff 36                	pushl  (%esi)
  800560:	e8 49 ff ff ff       	call   8004ae <dev_lookup>
  800565:	89 c3                	mov    %eax,%ebx
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	85 c0                	test   %eax,%eax
  80056c:	78 1a                	js     800588 <fd_close+0x7b>
		if (dev->dev_close)
  80056e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800571:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800574:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800579:	85 c0                	test   %eax,%eax
  80057b:	74 0b                	je     800588 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80057d:	83 ec 0c             	sub    $0xc,%esp
  800580:	56                   	push   %esi
  800581:	ff d0                	call   *%eax
  800583:	89 c3                	mov    %eax,%ebx
  800585:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	56                   	push   %esi
  80058c:	6a 00                	push   $0x0
  80058e:	e8 9b fc ff ff       	call   80022e <sys_page_unmap>
	return r;
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	eb b5                	jmp    80054d <fd_close+0x40>

00800598 <close>:

int
close(int fdnum)
{
  800598:	f3 0f 1e fb          	endbr32 
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 08             	pushl  0x8(%ebp)
  8005a9:	e8 ac fe ff ff       	call   80045a <fd_lookup>
  8005ae:	83 c4 10             	add    $0x10,%esp
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	79 02                	jns    8005b7 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    
		return fd_close(fd, 1);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	6a 01                	push   $0x1
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	e8 49 ff ff ff       	call   80050d <fd_close>
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	eb ec                	jmp    8005b5 <close+0x1d>

008005c9 <close_all>:

void
close_all(void)
{
  8005c9:	f3 0f 1e fb          	endbr32 
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	53                   	push   %ebx
  8005d1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005d4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005d9:	83 ec 0c             	sub    $0xc,%esp
  8005dc:	53                   	push   %ebx
  8005dd:	e8 b6 ff ff ff       	call   800598 <close>
	for (i = 0; i < MAXFD; i++)
  8005e2:	83 c3 01             	add    $0x1,%ebx
  8005e5:	83 c4 10             	add    $0x10,%esp
  8005e8:	83 fb 20             	cmp    $0x20,%ebx
  8005eb:	75 ec                	jne    8005d9 <close_all+0x10>
}
  8005ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005f0:	c9                   	leave  
  8005f1:	c3                   	ret    

008005f2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005f2:	f3 0f 1e fb          	endbr32 
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	57                   	push   %edi
  8005fa:	56                   	push   %esi
  8005fb:	53                   	push   %ebx
  8005fc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	ff 75 08             	pushl  0x8(%ebp)
  800606:	e8 4f fe ff ff       	call   80045a <fd_lookup>
  80060b:	89 c3                	mov    %eax,%ebx
  80060d:	83 c4 10             	add    $0x10,%esp
  800610:	85 c0                	test   %eax,%eax
  800612:	0f 88 81 00 00 00    	js     800699 <dup+0xa7>
		return r;
	close(newfdnum);
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	e8 75 ff ff ff       	call   800598 <close>

	newfd = INDEX2FD(newfdnum);
  800623:	8b 75 0c             	mov    0xc(%ebp),%esi
  800626:	c1 e6 0c             	shl    $0xc,%esi
  800629:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80062f:	83 c4 04             	add    $0x4,%esp
  800632:	ff 75 e4             	pushl  -0x1c(%ebp)
  800635:	e8 af fd ff ff       	call   8003e9 <fd2data>
  80063a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80063c:	89 34 24             	mov    %esi,(%esp)
  80063f:	e8 a5 fd ff ff       	call   8003e9 <fd2data>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800649:	89 d8                	mov    %ebx,%eax
  80064b:	c1 e8 16             	shr    $0x16,%eax
  80064e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800655:	a8 01                	test   $0x1,%al
  800657:	74 11                	je     80066a <dup+0x78>
  800659:	89 d8                	mov    %ebx,%eax
  80065b:	c1 e8 0c             	shr    $0xc,%eax
  80065e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800665:	f6 c2 01             	test   $0x1,%dl
  800668:	75 39                	jne    8006a3 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80066a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	c1 e8 0c             	shr    $0xc,%eax
  800672:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800679:	83 ec 0c             	sub    $0xc,%esp
  80067c:	25 07 0e 00 00       	and    $0xe07,%eax
  800681:	50                   	push   %eax
  800682:	56                   	push   %esi
  800683:	6a 00                	push   $0x0
  800685:	52                   	push   %edx
  800686:	6a 00                	push   $0x0
  800688:	e8 5b fb ff ff       	call   8001e8 <sys_page_map>
  80068d:	89 c3                	mov    %eax,%ebx
  80068f:	83 c4 20             	add    $0x20,%esp
  800692:	85 c0                	test   %eax,%eax
  800694:	78 31                	js     8006c7 <dup+0xd5>
		goto err;

	return newfdnum;
  800696:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800699:	89 d8                	mov    %ebx,%eax
  80069b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80069e:	5b                   	pop    %ebx
  80069f:	5e                   	pop    %esi
  8006a0:	5f                   	pop    %edi
  8006a1:	5d                   	pop    %ebp
  8006a2:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b2:	50                   	push   %eax
  8006b3:	57                   	push   %edi
  8006b4:	6a 00                	push   $0x0
  8006b6:	53                   	push   %ebx
  8006b7:	6a 00                	push   $0x0
  8006b9:	e8 2a fb ff ff       	call   8001e8 <sys_page_map>
  8006be:	89 c3                	mov    %eax,%ebx
  8006c0:	83 c4 20             	add    $0x20,%esp
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	79 a3                	jns    80066a <dup+0x78>
	sys_page_unmap(0, newfd);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	56                   	push   %esi
  8006cb:	6a 00                	push   $0x0
  8006cd:	e8 5c fb ff ff       	call   80022e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006d2:	83 c4 08             	add    $0x8,%esp
  8006d5:	57                   	push   %edi
  8006d6:	6a 00                	push   $0x0
  8006d8:	e8 51 fb ff ff       	call   80022e <sys_page_unmap>
	return r;
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	eb b7                	jmp    800699 <dup+0xa7>

008006e2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006e2:	f3 0f 1e fb          	endbr32 
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
  8006e9:	53                   	push   %ebx
  8006ea:	83 ec 1c             	sub    $0x1c,%esp
  8006ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006f3:	50                   	push   %eax
  8006f4:	53                   	push   %ebx
  8006f5:	e8 60 fd ff ff       	call   80045a <fd_lookup>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	78 3f                	js     800740 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800707:	50                   	push   %eax
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070b:	ff 30                	pushl  (%eax)
  80070d:	e8 9c fd ff ff       	call   8004ae <dev_lookup>
  800712:	83 c4 10             	add    $0x10,%esp
  800715:	85 c0                	test   %eax,%eax
  800717:	78 27                	js     800740 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800719:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80071c:	8b 42 08             	mov    0x8(%edx),%eax
  80071f:	83 e0 03             	and    $0x3,%eax
  800722:	83 f8 01             	cmp    $0x1,%eax
  800725:	74 1e                	je     800745 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072a:	8b 40 08             	mov    0x8(%eax),%eax
  80072d:	85 c0                	test   %eax,%eax
  80072f:	74 35                	je     800766 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800731:	83 ec 04             	sub    $0x4,%esp
  800734:	ff 75 10             	pushl  0x10(%ebp)
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	52                   	push   %edx
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800743:	c9                   	leave  
  800744:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800745:	a1 08 40 80 00       	mov    0x804008,%eax
  80074a:	8b 40 48             	mov    0x48(%eax),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	53                   	push   %ebx
  800751:	50                   	push   %eax
  800752:	68 79 24 80 00       	push   $0x802479
  800757:	e8 62 0f 00 00       	call   8016be <cprintf>
		return -E_INVAL;
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800764:	eb da                	jmp    800740 <read+0x5e>
		return -E_NOT_SUPP;
  800766:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80076b:	eb d3                	jmp    800740 <read+0x5e>

0080076d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80076d:	f3 0f 1e fb          	endbr32 
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	57                   	push   %edi
  800775:	56                   	push   %esi
  800776:	53                   	push   %ebx
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80077d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800780:	bb 00 00 00 00       	mov    $0x0,%ebx
  800785:	eb 02                	jmp    800789 <readn+0x1c>
  800787:	01 c3                	add    %eax,%ebx
  800789:	39 f3                	cmp    %esi,%ebx
  80078b:	73 21                	jae    8007ae <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	89 f0                	mov    %esi,%eax
  800792:	29 d8                	sub    %ebx,%eax
  800794:	50                   	push   %eax
  800795:	89 d8                	mov    %ebx,%eax
  800797:	03 45 0c             	add    0xc(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	57                   	push   %edi
  80079c:	e8 41 ff ff ff       	call   8006e2 <read>
		if (m < 0)
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	78 04                	js     8007ac <readn+0x3f>
			return m;
		if (m == 0)
  8007a8:	75 dd                	jne    800787 <readn+0x1a>
  8007aa:	eb 02                	jmp    8007ae <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007ac:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007ae:	89 d8                	mov    %ebx,%eax
  8007b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b3:	5b                   	pop    %ebx
  8007b4:	5e                   	pop    %esi
  8007b5:	5f                   	pop    %edi
  8007b6:	5d                   	pop    %ebp
  8007b7:	c3                   	ret    

008007b8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007b8:	f3 0f 1e fb          	endbr32 
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	53                   	push   %ebx
  8007c0:	83 ec 1c             	sub    $0x1c,%esp
  8007c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c9:	50                   	push   %eax
  8007ca:	53                   	push   %ebx
  8007cb:	e8 8a fc ff ff       	call   80045a <fd_lookup>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	78 3a                	js     800811 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007dd:	50                   	push   %eax
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	ff 30                	pushl  (%eax)
  8007e3:	e8 c6 fc ff ff       	call   8004ae <dev_lookup>
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	85 c0                	test   %eax,%eax
  8007ed:	78 22                	js     800811 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007f6:	74 1e                	je     800816 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fb:	8b 52 0c             	mov    0xc(%edx),%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	74 35                	je     800837 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800802:	83 ec 04             	sub    $0x4,%esp
  800805:	ff 75 10             	pushl  0x10(%ebp)
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	50                   	push   %eax
  80080c:	ff d2                	call   *%edx
  80080e:	83 c4 10             	add    $0x10,%esp
}
  800811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800814:	c9                   	leave  
  800815:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800816:	a1 08 40 80 00       	mov    0x804008,%eax
  80081b:	8b 40 48             	mov    0x48(%eax),%eax
  80081e:	83 ec 04             	sub    $0x4,%esp
  800821:	53                   	push   %ebx
  800822:	50                   	push   %eax
  800823:	68 95 24 80 00       	push   $0x802495
  800828:	e8 91 0e 00 00       	call   8016be <cprintf>
		return -E_INVAL;
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800835:	eb da                	jmp    800811 <write+0x59>
		return -E_NOT_SUPP;
  800837:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80083c:	eb d3                	jmp    800811 <write+0x59>

0080083e <seek>:

int
seek(int fdnum, off_t offset)
{
  80083e:	f3 0f 1e fb          	endbr32 
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800848:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80084b:	50                   	push   %eax
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 06 fc ff ff       	call   80045a <fd_lookup>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	85 c0                	test   %eax,%eax
  800859:	78 0e                	js     800869 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80085b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800861:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	53                   	push   %ebx
  800873:	83 ec 1c             	sub    $0x1c,%esp
  800876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800879:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80087c:	50                   	push   %eax
  80087d:	53                   	push   %ebx
  80087e:	e8 d7 fb ff ff       	call   80045a <fd_lookup>
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	85 c0                	test   %eax,%eax
  800888:	78 37                	js     8008c1 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800890:	50                   	push   %eax
  800891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800894:	ff 30                	pushl  (%eax)
  800896:	e8 13 fc ff ff       	call   8004ae <dev_lookup>
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	78 1f                	js     8008c1 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008a9:	74 1b                	je     8008c6 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8008ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ae:	8b 52 18             	mov    0x18(%edx),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	74 32                	je     8008e7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	50                   	push   %eax
  8008bc:	ff d2                	call   *%edx
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c4:	c9                   	leave  
  8008c5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008c6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008cb:	8b 40 48             	mov    0x48(%eax),%eax
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	53                   	push   %ebx
  8008d2:	50                   	push   %eax
  8008d3:	68 58 24 80 00       	push   $0x802458
  8008d8:	e8 e1 0d 00 00       	call   8016be <cprintf>
		return -E_INVAL;
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e5:	eb da                	jmp    8008c1 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ec:	eb d3                	jmp    8008c1 <ftruncate+0x56>

008008ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008ee:	f3 0f 1e fb          	endbr32 
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	83 ec 1c             	sub    $0x1c,%esp
  8008f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ff:	50                   	push   %eax
  800900:	ff 75 08             	pushl  0x8(%ebp)
  800903:	e8 52 fb ff ff       	call   80045a <fd_lookup>
  800908:	83 c4 10             	add    $0x10,%esp
  80090b:	85 c0                	test   %eax,%eax
  80090d:	78 4b                	js     80095a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800915:	50                   	push   %eax
  800916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800919:	ff 30                	pushl  (%eax)
  80091b:	e8 8e fb ff ff       	call   8004ae <dev_lookup>
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	85 c0                	test   %eax,%eax
  800925:	78 33                	js     80095a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80092a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80092e:	74 2f                	je     80095f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800930:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800933:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80093a:	00 00 00 
	stat->st_isdir = 0;
  80093d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800944:	00 00 00 
	stat->st_dev = dev;
  800947:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	53                   	push   %ebx
  800951:	ff 75 f0             	pushl  -0x10(%ebp)
  800954:	ff 50 14             	call   *0x14(%eax)
  800957:	83 c4 10             	add    $0x10,%esp
}
  80095a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80095d:	c9                   	leave  
  80095e:	c3                   	ret    
		return -E_NOT_SUPP;
  80095f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800964:	eb f4                	jmp    80095a <fstat+0x6c>

00800966 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800966:	f3 0f 1e fb          	endbr32 
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	6a 00                	push   $0x0
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 fb 01 00 00       	call   800b77 <open>
  80097c:	89 c3                	mov    %eax,%ebx
  80097e:	83 c4 10             	add    $0x10,%esp
  800981:	85 c0                	test   %eax,%eax
  800983:	78 1b                	js     8009a0 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	50                   	push   %eax
  80098c:	e8 5d ff ff ff       	call   8008ee <fstat>
  800991:	89 c6                	mov    %eax,%esi
	close(fd);
  800993:	89 1c 24             	mov    %ebx,(%esp)
  800996:	e8 fd fb ff ff       	call   800598 <close>
	return r;
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	89 f3                	mov    %esi,%ebx
}
  8009a0:	89 d8                	mov    %ebx,%eax
  8009a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009a5:	5b                   	pop    %ebx
  8009a6:	5e                   	pop    %esi
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	56                   	push   %esi
  8009ad:	53                   	push   %ebx
  8009ae:	89 c6                	mov    %eax,%esi
  8009b0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8009b2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009b9:	74 27                	je     8009e2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009bb:	6a 07                	push   $0x7
  8009bd:	68 00 50 80 00       	push   $0x805000
  8009c2:	56                   	push   %esi
  8009c3:	ff 35 00 40 80 00    	pushl  0x804000
  8009c9:	e8 e0 16 00 00       	call   8020ae <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009ce:	83 c4 0c             	add    $0xc,%esp
  8009d1:	6a 00                	push   $0x0
  8009d3:	53                   	push   %ebx
  8009d4:	6a 00                	push   $0x0
  8009d6:	e8 5f 16 00 00       	call   80203a <ipc_recv>
}
  8009db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009de:	5b                   	pop    %ebx
  8009df:	5e                   	pop    %esi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009e2:	83 ec 0c             	sub    $0xc,%esp
  8009e5:	6a 01                	push   $0x1
  8009e7:	e8 1a 17 00 00       	call   802106 <ipc_find_env>
  8009ec:	a3 00 40 80 00       	mov    %eax,0x804000
  8009f1:	83 c4 10             	add    $0x10,%esp
  8009f4:	eb c5                	jmp    8009bb <fsipc+0x12>

008009f6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 40 0c             	mov    0xc(%eax),%eax
  800a06:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	b8 02 00 00 00       	mov    $0x2,%eax
  800a1d:	e8 87 ff ff ff       	call   8009a9 <fsipc>
}
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <devfile_flush>:
{
  800a24:	f3 0f 1e fb          	endbr32 
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 40 0c             	mov    0xc(%eax),%eax
  800a34:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a39:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800a43:	e8 61 ff ff ff       	call   8009a9 <fsipc>
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <devfile_stat>:
{
  800a4a:	f3 0f 1e fb          	endbr32 
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	83 ec 04             	sub    $0x4,%esp
  800a55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a5e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a63:	ba 00 00 00 00       	mov    $0x0,%edx
  800a68:	b8 05 00 00 00       	mov    $0x5,%eax
  800a6d:	e8 37 ff ff ff       	call   8009a9 <fsipc>
  800a72:	85 c0                	test   %eax,%eax
  800a74:	78 2c                	js     800aa2 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	68 00 50 80 00       	push   $0x805000
  800a7e:	53                   	push   %ebx
  800a7f:	e8 44 12 00 00       	call   801cc8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a84:	a1 80 50 80 00       	mov    0x805080,%eax
  800a89:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a8f:	a1 84 50 80 00       	mov    0x805084,%eax
  800a94:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <devfile_write>:
{
  800aa7:	f3 0f 1e fb          	endbr32 
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 0c             	sub    $0xc,%esp
  800ab1:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab7:	8b 52 0c             	mov    0xc(%edx),%edx
  800aba:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800ac0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ac5:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aca:	0f 47 c2             	cmova  %edx,%eax
  800acd:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800ad2:	50                   	push   %eax
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	68 08 50 80 00       	push   $0x805008
  800adb:	e8 9e 13 00 00       	call   801e7e <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae5:	b8 04 00 00 00       	mov    $0x4,%eax
  800aea:	e8 ba fe ff ff       	call   8009a9 <fsipc>
}
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <devfile_read>:
{
  800af1:	f3 0f 1e fb          	endbr32 
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8b 40 0c             	mov    0xc(%eax),%eax
  800b03:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b08:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b13:	b8 03 00 00 00       	mov    $0x3,%eax
  800b18:	e8 8c fe ff ff       	call   8009a9 <fsipc>
  800b1d:	89 c3                	mov    %eax,%ebx
  800b1f:	85 c0                	test   %eax,%eax
  800b21:	78 1f                	js     800b42 <devfile_read+0x51>
	assert(r <= n);
  800b23:	39 f0                	cmp    %esi,%eax
  800b25:	77 24                	ja     800b4b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b27:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b2c:	7f 33                	jg     800b61 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b2e:	83 ec 04             	sub    $0x4,%esp
  800b31:	50                   	push   %eax
  800b32:	68 00 50 80 00       	push   $0x805000
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	e8 3f 13 00 00       	call   801e7e <memmove>
	return r;
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	89 d8                	mov    %ebx,%eax
  800b44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5d                   	pop    %ebp
  800b4a:	c3                   	ret    
	assert(r <= n);
  800b4b:	68 c8 24 80 00       	push   $0x8024c8
  800b50:	68 cf 24 80 00       	push   $0x8024cf
  800b55:	6a 7c                	push   $0x7c
  800b57:	68 e4 24 80 00       	push   $0x8024e4
  800b5c:	e8 76 0a 00 00       	call   8015d7 <_panic>
	assert(r <= PGSIZE);
  800b61:	68 ef 24 80 00       	push   $0x8024ef
  800b66:	68 cf 24 80 00       	push   $0x8024cf
  800b6b:	6a 7d                	push   $0x7d
  800b6d:	68 e4 24 80 00       	push   $0x8024e4
  800b72:	e8 60 0a 00 00       	call   8015d7 <_panic>

00800b77 <open>:
{
  800b77:	f3 0f 1e fb          	endbr32 
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	83 ec 1c             	sub    $0x1c,%esp
  800b83:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b86:	56                   	push   %esi
  800b87:	e8 f9 10 00 00       	call   801c85 <strlen>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b94:	7f 6c                	jg     800c02 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b96:	83 ec 0c             	sub    $0xc,%esp
  800b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b9c:	50                   	push   %eax
  800b9d:	e8 62 f8 ff ff       	call   800404 <fd_alloc>
  800ba2:	89 c3                	mov    %eax,%ebx
  800ba4:	83 c4 10             	add    $0x10,%esp
  800ba7:	85 c0                	test   %eax,%eax
  800ba9:	78 3c                	js     800be7 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	56                   	push   %esi
  800baf:	68 00 50 80 00       	push   $0x805000
  800bb4:	e8 0f 11 00 00       	call   801cc8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc9:	e8 db fd ff ff       	call   8009a9 <fsipc>
  800bce:	89 c3                	mov    %eax,%ebx
  800bd0:	83 c4 10             	add    $0x10,%esp
  800bd3:	85 c0                	test   %eax,%eax
  800bd5:	78 19                	js     800bf0 <open+0x79>
	return fd2num(fd);
  800bd7:	83 ec 0c             	sub    $0xc,%esp
  800bda:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdd:	e8 f3 f7 ff ff       	call   8003d5 <fd2num>
  800be2:	89 c3                	mov    %eax,%ebx
  800be4:	83 c4 10             	add    $0x10,%esp
}
  800be7:	89 d8                	mov    %ebx,%eax
  800be9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    
		fd_close(fd, 0);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	6a 00                	push   $0x0
  800bf5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf8:	e8 10 f9 ff ff       	call   80050d <fd_close>
		return r;
  800bfd:	83 c4 10             	add    $0x10,%esp
  800c00:	eb e5                	jmp    800be7 <open+0x70>
		return -E_BAD_PATH;
  800c02:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c07:	eb de                	jmp    800be7 <open+0x70>

00800c09 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c09:	f3 0f 1e fb          	endbr32 
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 08 00 00 00       	mov    $0x8,%eax
  800c1d:	e8 87 fd ff ff       	call   8009a9 <fsipc>
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c24:	f3 0f 1e fb          	endbr32 
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c2e:	68 fb 24 80 00       	push   $0x8024fb
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	e8 8d 10 00 00       	call   801cc8 <strcpy>
	return 0;
}
  800c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <devsock_close>:
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 10             	sub    $0x10,%esp
  800c4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c50:	53                   	push   %ebx
  800c51:	e8 ed 14 00 00       	call   802143 <pageref>
  800c56:	89 c2                	mov    %eax,%edx
  800c58:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c60:	83 fa 01             	cmp    $0x1,%edx
  800c63:	74 05                	je     800c6a <devsock_close+0x28>
}
  800c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	ff 73 0c             	pushl  0xc(%ebx)
  800c70:	e8 e3 02 00 00       	call   800f58 <nsipc_close>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	eb eb                	jmp    800c65 <devsock_close+0x23>

00800c7a <devsock_write>:
{
  800c7a:	f3 0f 1e fb          	endbr32 
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c84:	6a 00                	push   $0x0
  800c86:	ff 75 10             	pushl  0x10(%ebp)
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff 70 0c             	pushl  0xc(%eax)
  800c92:	e8 b5 03 00 00       	call   80104c <nsipc_send>
}
  800c97:	c9                   	leave  
  800c98:	c3                   	ret    

00800c99 <devsock_read>:
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ca3:	6a 00                	push   $0x0
  800ca5:	ff 75 10             	pushl  0x10(%ebp)
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff 70 0c             	pushl  0xc(%eax)
  800cb1:	e8 1f 03 00 00       	call   800fd5 <nsipc_recv>
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <fd2sockid>:
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800cbe:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800cc1:	52                   	push   %edx
  800cc2:	50                   	push   %eax
  800cc3:	e8 92 f7 ff ff       	call   80045a <fd_lookup>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	78 10                	js     800cdf <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd2:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800cd8:	39 08                	cmp    %ecx,(%eax)
  800cda:	75 05                	jne    800ce1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cdc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    
		return -E_NOT_SUPP;
  800ce1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ce6:	eb f7                	jmp    800cdf <fd2sockid+0x27>

00800ce8 <alloc_sockfd>:
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 1c             	sub    $0x1c,%esp
  800cf0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cf5:	50                   	push   %eax
  800cf6:	e8 09 f7 ff ff       	call   800404 <fd_alloc>
  800cfb:	89 c3                	mov    %eax,%ebx
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	85 c0                	test   %eax,%eax
  800d02:	78 43                	js     800d47 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d04:	83 ec 04             	sub    $0x4,%esp
  800d07:	68 07 04 00 00       	push   $0x407
  800d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d0f:	6a 00                	push   $0x0
  800d11:	e8 8b f4 ff ff       	call   8001a1 <sys_page_alloc>
  800d16:	89 c3                	mov    %eax,%ebx
  800d18:	83 c4 10             	add    $0x10,%esp
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	78 28                	js     800d47 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d22:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d28:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d2d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d34:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	e8 95 f6 ff ff       	call   8003d5 <fd2num>
  800d40:	89 c3                	mov    %eax,%ebx
  800d42:	83 c4 10             	add    $0x10,%esp
  800d45:	eb 0c                	jmp    800d53 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	56                   	push   %esi
  800d4b:	e8 08 02 00 00       	call   800f58 <nsipc_close>
		return r;
  800d50:	83 c4 10             	add    $0x10,%esp
}
  800d53:	89 d8                	mov    %ebx,%eax
  800d55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <accept>:
{
  800d5c:	f3 0f 1e fb          	endbr32 
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	e8 4a ff ff ff       	call   800cb8 <fd2sockid>
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	78 1b                	js     800d8d <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	ff 75 10             	pushl  0x10(%ebp)
  800d78:	ff 75 0c             	pushl  0xc(%ebp)
  800d7b:	50                   	push   %eax
  800d7c:	e8 22 01 00 00       	call   800ea3 <nsipc_accept>
  800d81:	83 c4 10             	add    $0x10,%esp
  800d84:	85 c0                	test   %eax,%eax
  800d86:	78 05                	js     800d8d <accept+0x31>
	return alloc_sockfd(r);
  800d88:	e8 5b ff ff ff       	call   800ce8 <alloc_sockfd>
}
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <bind>:
{
  800d8f:	f3 0f 1e fb          	endbr32 
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	e8 17 ff ff ff       	call   800cb8 <fd2sockid>
  800da1:	85 c0                	test   %eax,%eax
  800da3:	78 12                	js     800db7 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800da5:	83 ec 04             	sub    $0x4,%esp
  800da8:	ff 75 10             	pushl  0x10(%ebp)
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	50                   	push   %eax
  800daf:	e8 45 01 00 00       	call   800ef9 <nsipc_bind>
  800db4:	83 c4 10             	add    $0x10,%esp
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <shutdown>:
{
  800db9:	f3 0f 1e fb          	endbr32 
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	e8 ed fe ff ff       	call   800cb8 <fd2sockid>
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	78 0f                	js     800dde <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	50                   	push   %eax
  800dd6:	e8 57 01 00 00       	call   800f32 <nsipc_shutdown>
  800ddb:	83 c4 10             	add    $0x10,%esp
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <connect>:
{
  800de0:	f3 0f 1e fb          	endbr32 
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	e8 c6 fe ff ff       	call   800cb8 <fd2sockid>
  800df2:	85 c0                	test   %eax,%eax
  800df4:	78 12                	js     800e08 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	ff 75 10             	pushl  0x10(%ebp)
  800dfc:	ff 75 0c             	pushl  0xc(%ebp)
  800dff:	50                   	push   %eax
  800e00:	e8 71 01 00 00       	call   800f76 <nsipc_connect>
  800e05:	83 c4 10             	add    $0x10,%esp
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <listen>:
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	e8 9c fe ff ff       	call   800cb8 <fd2sockid>
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	78 0f                	js     800e2f <listen+0x25>
	return nsipc_listen(r, backlog);
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	50                   	push   %eax
  800e27:	e8 83 01 00 00       	call   800faf <nsipc_listen>
  800e2c:	83 c4 10             	add    $0x10,%esp
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e31:	f3 0f 1e fb          	endbr32 
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e3b:	ff 75 10             	pushl  0x10(%ebp)
  800e3e:	ff 75 0c             	pushl  0xc(%ebp)
  800e41:	ff 75 08             	pushl  0x8(%ebp)
  800e44:	e8 65 02 00 00       	call   8010ae <nsipc_socket>
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	78 05                	js     800e55 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e50:	e8 93 fe ff ff       	call   800ce8 <alloc_sockfd>
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e60:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e67:	74 26                	je     800e8f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e69:	6a 07                	push   $0x7
  800e6b:	68 00 60 80 00       	push   $0x806000
  800e70:	53                   	push   %ebx
  800e71:	ff 35 04 40 80 00    	pushl  0x804004
  800e77:	e8 32 12 00 00       	call   8020ae <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e7c:	83 c4 0c             	add    $0xc,%esp
  800e7f:	6a 00                	push   $0x0
  800e81:	6a 00                	push   $0x0
  800e83:	6a 00                	push   $0x0
  800e85:	e8 b0 11 00 00       	call   80203a <ipc_recv>
}
  800e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	6a 02                	push   $0x2
  800e94:	e8 6d 12 00 00       	call   802106 <ipc_find_env>
  800e99:	a3 04 40 80 00       	mov    %eax,0x804004
  800e9e:	83 c4 10             	add    $0x10,%esp
  800ea1:	eb c6                	jmp    800e69 <nsipc+0x12>

00800ea3 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800ea3:	f3 0f 1e fb          	endbr32 
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800eb7:	8b 06                	mov    (%esi),%eax
  800eb9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec3:	e8 8f ff ff ff       	call   800e57 <nsipc>
  800ec8:	89 c3                	mov    %eax,%ebx
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	79 09                	jns    800ed7 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800ece:	89 d8                	mov    %ebx,%eax
  800ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ed7:	83 ec 04             	sub    $0x4,%esp
  800eda:	ff 35 10 60 80 00    	pushl  0x806010
  800ee0:	68 00 60 80 00       	push   $0x806000
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	e8 91 0f 00 00       	call   801e7e <memmove>
		*addrlen = ret->ret_addrlen;
  800eed:	a1 10 60 80 00       	mov    0x806010,%eax
  800ef2:	89 06                	mov    %eax,(%esi)
  800ef4:	83 c4 10             	add    $0x10,%esp
	return r;
  800ef7:	eb d5                	jmp    800ece <nsipc_accept+0x2b>

00800ef9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ef9:	f3 0f 1e fb          	endbr32 
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	53                   	push   %ebx
  800f01:	83 ec 08             	sub    $0x8,%esp
  800f04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f0f:	53                   	push   %ebx
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	68 04 60 80 00       	push   $0x806004
  800f18:	e8 61 0f 00 00       	call   801e7e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f1d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f23:	b8 02 00 00 00       	mov    $0x2,%eax
  800f28:	e8 2a ff ff ff       	call   800e57 <nsipc>
}
  800f2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f4c:	b8 03 00 00 00       	mov    $0x3,%eax
  800f51:	e8 01 ff ff ff       	call   800e57 <nsipc>
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <nsipc_close>:

int
nsipc_close(int s)
{
  800f58:	f3 0f 1e fb          	endbr32 
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f6a:	b8 04 00 00 00       	mov    $0x4,%eax
  800f6f:	e8 e3 fe ff ff       	call   800e57 <nsipc>
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f76:	f3 0f 1e fb          	endbr32 
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	53                   	push   %ebx
  800f7e:	83 ec 08             	sub    $0x8,%esp
  800f81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f8c:	53                   	push   %ebx
  800f8d:	ff 75 0c             	pushl  0xc(%ebp)
  800f90:	68 04 60 80 00       	push   $0x806004
  800f95:	e8 e4 0e 00 00       	call   801e7e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f9a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800fa0:	b8 05 00 00 00       	mov    $0x5,%eax
  800fa5:	e8 ad fe ff ff       	call   800e57 <nsipc>
}
  800faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fad:	c9                   	leave  
  800fae:	c3                   	ret    

00800faf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800faf:	f3 0f 1e fb          	endbr32 
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fc9:	b8 06 00 00 00       	mov    $0x6,%eax
  800fce:	e8 84 fe ff ff       	call   800e57 <nsipc>
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fd5:	f3 0f 1e fb          	endbr32 
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	56                   	push   %esi
  800fdd:	53                   	push   %ebx
  800fde:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fe9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fef:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800ff7:	b8 07 00 00 00       	mov    $0x7,%eax
  800ffc:	e8 56 fe ff ff       	call   800e57 <nsipc>
  801001:	89 c3                	mov    %eax,%ebx
  801003:	85 c0                	test   %eax,%eax
  801005:	78 26                	js     80102d <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801007:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80100d:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801012:	0f 4e c6             	cmovle %esi,%eax
  801015:	39 c3                	cmp    %eax,%ebx
  801017:	7f 1d                	jg     801036 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	53                   	push   %ebx
  80101d:	68 00 60 80 00       	push   $0x806000
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	e8 54 0e 00 00       	call   801e7e <memmove>
  80102a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80102d:	89 d8                	mov    %ebx,%eax
  80102f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801036:	68 07 25 80 00       	push   $0x802507
  80103b:	68 cf 24 80 00       	push   $0x8024cf
  801040:	6a 62                	push   $0x62
  801042:	68 1c 25 80 00       	push   $0x80251c
  801047:	e8 8b 05 00 00       	call   8015d7 <_panic>

0080104c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80104c:	f3 0f 1e fb          	endbr32 
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	53                   	push   %ebx
  801054:	83 ec 04             	sub    $0x4,%esp
  801057:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801062:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801068:	7f 2e                	jg     801098 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	53                   	push   %ebx
  80106e:	ff 75 0c             	pushl  0xc(%ebp)
  801071:	68 0c 60 80 00       	push   $0x80600c
  801076:	e8 03 0e 00 00       	call   801e7e <memmove>
	nsipcbuf.send.req_size = size;
  80107b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801081:	8b 45 14             	mov    0x14(%ebp),%eax
  801084:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801089:	b8 08 00 00 00       	mov    $0x8,%eax
  80108e:	e8 c4 fd ff ff       	call   800e57 <nsipc>
}
  801093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801096:	c9                   	leave  
  801097:	c3                   	ret    
	assert(size < 1600);
  801098:	68 28 25 80 00       	push   $0x802528
  80109d:	68 cf 24 80 00       	push   $0x8024cf
  8010a2:	6a 6d                	push   $0x6d
  8010a4:	68 1c 25 80 00       	push   $0x80251c
  8010a9:	e8 29 05 00 00       	call   8015d7 <_panic>

008010ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8010ae:	f3 0f 1e fb          	endbr32 
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010d0:	b8 09 00 00 00       	mov    $0x9,%eax
  8010d5:	e8 7d fd ff ff       	call   800e57 <nsipc>
}
  8010da:	c9                   	leave  
  8010db:	c3                   	ret    

008010dc <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010dc:	f3 0f 1e fb          	endbr32 
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	56                   	push   %esi
  8010e4:	53                   	push   %ebx
  8010e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010e8:	83 ec 0c             	sub    $0xc,%esp
  8010eb:	ff 75 08             	pushl  0x8(%ebp)
  8010ee:	e8 f6 f2 ff ff       	call   8003e9 <fd2data>
  8010f3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010f5:	83 c4 08             	add    $0x8,%esp
  8010f8:	68 34 25 80 00       	push   $0x802534
  8010fd:	53                   	push   %ebx
  8010fe:	e8 c5 0b 00 00       	call   801cc8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801103:	8b 46 04             	mov    0x4(%esi),%eax
  801106:	2b 06                	sub    (%esi),%eax
  801108:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80110e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801115:	00 00 00 
	stat->st_dev = &devpipe;
  801118:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80111f:	30 80 00 
	return 0;
}
  801122:	b8 00 00 00 00       	mov    $0x0,%eax
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80112e:	f3 0f 1e fb          	endbr32 
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	53                   	push   %ebx
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80113c:	53                   	push   %ebx
  80113d:	6a 00                	push   $0x0
  80113f:	e8 ea f0 ff ff       	call   80022e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801144:	89 1c 24             	mov    %ebx,(%esp)
  801147:	e8 9d f2 ff ff       	call   8003e9 <fd2data>
  80114c:	83 c4 08             	add    $0x8,%esp
  80114f:	50                   	push   %eax
  801150:	6a 00                	push   $0x0
  801152:	e8 d7 f0 ff ff       	call   80022e <sys_page_unmap>
}
  801157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <_pipeisclosed>:
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
  801162:	83 ec 1c             	sub    $0x1c,%esp
  801165:	89 c7                	mov    %eax,%edi
  801167:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801169:	a1 08 40 80 00       	mov    0x804008,%eax
  80116e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	57                   	push   %edi
  801175:	e8 c9 0f 00 00       	call   802143 <pageref>
  80117a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80117d:	89 34 24             	mov    %esi,(%esp)
  801180:	e8 be 0f 00 00       	call   802143 <pageref>
		nn = thisenv->env_runs;
  801185:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80118b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	39 cb                	cmp    %ecx,%ebx
  801193:	74 1b                	je     8011b0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801195:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801198:	75 cf                	jne    801169 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80119a:	8b 42 58             	mov    0x58(%edx),%eax
  80119d:	6a 01                	push   $0x1
  80119f:	50                   	push   %eax
  8011a0:	53                   	push   %ebx
  8011a1:	68 3b 25 80 00       	push   $0x80253b
  8011a6:	e8 13 05 00 00       	call   8016be <cprintf>
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	eb b9                	jmp    801169 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8011b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011b3:	0f 94 c0             	sete   %al
  8011b6:	0f b6 c0             	movzbl %al,%eax
}
  8011b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bc:	5b                   	pop    %ebx
  8011bd:	5e                   	pop    %esi
  8011be:	5f                   	pop    %edi
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <devpipe_write>:
{
  8011c1:	f3 0f 1e fb          	endbr32 
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	57                   	push   %edi
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 28             	sub    $0x28,%esp
  8011ce:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011d1:	56                   	push   %esi
  8011d2:	e8 12 f2 ff ff       	call   8003e9 <fd2data>
  8011d7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8011e1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011e4:	74 4f                	je     801235 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011e6:	8b 43 04             	mov    0x4(%ebx),%eax
  8011e9:	8b 0b                	mov    (%ebx),%ecx
  8011eb:	8d 51 20             	lea    0x20(%ecx),%edx
  8011ee:	39 d0                	cmp    %edx,%eax
  8011f0:	72 14                	jb     801206 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011f2:	89 da                	mov    %ebx,%edx
  8011f4:	89 f0                	mov    %esi,%eax
  8011f6:	e8 61 ff ff ff       	call   80115c <_pipeisclosed>
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	75 3b                	jne    80123a <devpipe_write+0x79>
			sys_yield();
  8011ff:	e8 7a ef ff ff       	call   80017e <sys_yield>
  801204:	eb e0                	jmp    8011e6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801209:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80120d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801210:	89 c2                	mov    %eax,%edx
  801212:	c1 fa 1f             	sar    $0x1f,%edx
  801215:	89 d1                	mov    %edx,%ecx
  801217:	c1 e9 1b             	shr    $0x1b,%ecx
  80121a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80121d:	83 e2 1f             	and    $0x1f,%edx
  801220:	29 ca                	sub    %ecx,%edx
  801222:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801226:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80122a:	83 c0 01             	add    $0x1,%eax
  80122d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801230:	83 c7 01             	add    $0x1,%edi
  801233:	eb ac                	jmp    8011e1 <devpipe_write+0x20>
	return i;
  801235:	8b 45 10             	mov    0x10(%ebp),%eax
  801238:	eb 05                	jmp    80123f <devpipe_write+0x7e>
				return 0;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801242:	5b                   	pop    %ebx
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <devpipe_read>:
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 18             	sub    $0x18,%esp
  801254:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801257:	57                   	push   %edi
  801258:	e8 8c f1 ff ff       	call   8003e9 <fd2data>
  80125d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	be 00 00 00 00       	mov    $0x0,%esi
  801267:	3b 75 10             	cmp    0x10(%ebp),%esi
  80126a:	75 14                	jne    801280 <devpipe_read+0x39>
	return i;
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	eb 02                	jmp    801273 <devpipe_read+0x2c>
				return i;
  801271:	89 f0                	mov    %esi,%eax
}
  801273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5f                   	pop    %edi
  801279:	5d                   	pop    %ebp
  80127a:	c3                   	ret    
			sys_yield();
  80127b:	e8 fe ee ff ff       	call   80017e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801280:	8b 03                	mov    (%ebx),%eax
  801282:	3b 43 04             	cmp    0x4(%ebx),%eax
  801285:	75 18                	jne    80129f <devpipe_read+0x58>
			if (i > 0)
  801287:	85 f6                	test   %esi,%esi
  801289:	75 e6                	jne    801271 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80128b:	89 da                	mov    %ebx,%edx
  80128d:	89 f8                	mov    %edi,%eax
  80128f:	e8 c8 fe ff ff       	call   80115c <_pipeisclosed>
  801294:	85 c0                	test   %eax,%eax
  801296:	74 e3                	je     80127b <devpipe_read+0x34>
				return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
  80129d:	eb d4                	jmp    801273 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80129f:	99                   	cltd   
  8012a0:	c1 ea 1b             	shr    $0x1b,%edx
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	83 e0 1f             	and    $0x1f,%eax
  8012a8:	29 d0                	sub    %edx,%eax
  8012aa:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8012af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b2:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8012b5:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8012b8:	83 c6 01             	add    $0x1,%esi
  8012bb:	eb aa                	jmp    801267 <devpipe_read+0x20>

008012bd <pipe>:
{
  8012bd:	f3 0f 1e fb          	endbr32 
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	e8 32 f1 ff ff       	call   800404 <fd_alloc>
  8012d2:	89 c3                	mov    %eax,%ebx
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	85 c0                	test   %eax,%eax
  8012d9:	0f 88 23 01 00 00    	js     801402 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012df:	83 ec 04             	sub    $0x4,%esp
  8012e2:	68 07 04 00 00       	push   $0x407
  8012e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ea:	6a 00                	push   $0x0
  8012ec:	e8 b0 ee ff ff       	call   8001a1 <sys_page_alloc>
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	0f 88 04 01 00 00    	js     801402 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	e8 fa f0 ff ff       	call   800404 <fd_alloc>
  80130a:	89 c3                	mov    %eax,%ebx
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	85 c0                	test   %eax,%eax
  801311:	0f 88 db 00 00 00    	js     8013f2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801317:	83 ec 04             	sub    $0x4,%esp
  80131a:	68 07 04 00 00       	push   $0x407
  80131f:	ff 75 f0             	pushl  -0x10(%ebp)
  801322:	6a 00                	push   $0x0
  801324:	e8 78 ee ff ff       	call   8001a1 <sys_page_alloc>
  801329:	89 c3                	mov    %eax,%ebx
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	0f 88 bc 00 00 00    	js     8013f2 <pipe+0x135>
	va = fd2data(fd0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	ff 75 f4             	pushl  -0xc(%ebp)
  80133c:	e8 a8 f0 ff ff       	call   8003e9 <fd2data>
  801341:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801343:	83 c4 0c             	add    $0xc,%esp
  801346:	68 07 04 00 00       	push   $0x407
  80134b:	50                   	push   %eax
  80134c:	6a 00                	push   $0x0
  80134e:	e8 4e ee ff ff       	call   8001a1 <sys_page_alloc>
  801353:	89 c3                	mov    %eax,%ebx
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	0f 88 82 00 00 00    	js     8013e2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	ff 75 f0             	pushl  -0x10(%ebp)
  801366:	e8 7e f0 ff ff       	call   8003e9 <fd2data>
  80136b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801372:	50                   	push   %eax
  801373:	6a 00                	push   $0x0
  801375:	56                   	push   %esi
  801376:	6a 00                	push   $0x0
  801378:	e8 6b ee ff ff       	call   8001e8 <sys_page_map>
  80137d:	89 c3                	mov    %eax,%ebx
  80137f:	83 c4 20             	add    $0x20,%esp
  801382:	85 c0                	test   %eax,%eax
  801384:	78 4e                	js     8013d4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801386:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80138b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801393:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80139a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8013af:	e8 21 f0 ff ff       	call   8003d5 <fd2num>
  8013b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8013b9:	83 c4 04             	add    $0x4,%esp
  8013bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8013bf:	e8 11 f0 ff ff       	call   8003d5 <fd2num>
  8013c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d2:	eb 2e                	jmp    801402 <pipe+0x145>
	sys_page_unmap(0, va);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	56                   	push   %esi
  8013d8:	6a 00                	push   $0x0
  8013da:	e8 4f ee ff ff       	call   80022e <sys_page_unmap>
  8013df:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 3f ee ff ff       	call   80022e <sys_page_unmap>
  8013ef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f8:	6a 00                	push   $0x0
  8013fa:	e8 2f ee ff ff       	call   80022e <sys_page_unmap>
  8013ff:	83 c4 10             	add    $0x10,%esp
}
  801402:	89 d8                	mov    %ebx,%eax
  801404:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801407:	5b                   	pop    %ebx
  801408:	5e                   	pop    %esi
  801409:	5d                   	pop    %ebp
  80140a:	c3                   	ret    

0080140b <pipeisclosed>:
{
  80140b:	f3 0f 1e fb          	endbr32 
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	e8 39 f0 ff ff       	call   80045a <fd_lookup>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 18                	js     801440 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	ff 75 f4             	pushl  -0xc(%ebp)
  80142e:	e8 b6 ef ff ff       	call   8003e9 <fd2data>
  801433:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801438:	e8 1f fd ff ff       	call   80115c <_pipeisclosed>
  80143d:	83 c4 10             	add    $0x10,%esp
}
  801440:	c9                   	leave  
  801441:	c3                   	ret    

00801442 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801442:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	c3                   	ret    

0080144c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801456:	68 53 25 80 00       	push   $0x802553
  80145b:	ff 75 0c             	pushl  0xc(%ebp)
  80145e:	e8 65 08 00 00       	call   801cc8 <strcpy>
	return 0;
}
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <devcons_write>:
{
  80146a:	f3 0f 1e fb          	endbr32 
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	57                   	push   %edi
  801472:	56                   	push   %esi
  801473:	53                   	push   %ebx
  801474:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80147a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80147f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801485:	3b 75 10             	cmp    0x10(%ebp),%esi
  801488:	73 31                	jae    8014bb <devcons_write+0x51>
		m = n - tot;
  80148a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80148d:	29 f3                	sub    %esi,%ebx
  80148f:	83 fb 7f             	cmp    $0x7f,%ebx
  801492:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801497:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	53                   	push   %ebx
  80149e:	89 f0                	mov    %esi,%eax
  8014a0:	03 45 0c             	add    0xc(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	57                   	push   %edi
  8014a5:	e8 d4 09 00 00       	call   801e7e <memmove>
		sys_cputs(buf, m);
  8014aa:	83 c4 08             	add    $0x8,%esp
  8014ad:	53                   	push   %ebx
  8014ae:	57                   	push   %edi
  8014af:	e8 1d ec ff ff       	call   8000d1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8014b4:	01 de                	add    %ebx,%esi
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	eb ca                	jmp    801485 <devcons_write+0x1b>
}
  8014bb:	89 f0                	mov    %esi,%eax
  8014bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5e                   	pop    %esi
  8014c2:	5f                   	pop    %edi
  8014c3:	5d                   	pop    %ebp
  8014c4:	c3                   	ret    

008014c5 <devcons_read>:
{
  8014c5:	f3 0f 1e fb          	endbr32 
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d8:	74 21                	je     8014fb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014da:	e8 14 ec ff ff       	call   8000f3 <sys_cgetc>
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	75 07                	jne    8014ea <devcons_read+0x25>
		sys_yield();
  8014e3:	e8 96 ec ff ff       	call   80017e <sys_yield>
  8014e8:	eb f0                	jmp    8014da <devcons_read+0x15>
	if (c < 0)
  8014ea:	78 0f                	js     8014fb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014ec:	83 f8 04             	cmp    $0x4,%eax
  8014ef:	74 0c                	je     8014fd <devcons_read+0x38>
	*(char*)vbuf = c;
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	88 02                	mov    %al,(%edx)
	return 1;
  8014f6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    
		return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	eb f7                	jmp    8014fb <devcons_read+0x36>

00801504 <cputchar>:
{
  801504:	f3 0f 1e fb          	endbr32 
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801514:	6a 01                	push   $0x1
  801516:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801519:	50                   	push   %eax
  80151a:	e8 b2 eb ff ff       	call   8000d1 <sys_cputs>
}
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <getchar>:
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80152e:	6a 01                	push   $0x1
  801530:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801533:	50                   	push   %eax
  801534:	6a 00                	push   $0x0
  801536:	e8 a7 f1 ff ff       	call   8006e2 <read>
	if (r < 0)
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 06                	js     801548 <getchar+0x24>
	if (r < 1)
  801542:	74 06                	je     80154a <getchar+0x26>
	return c;
  801544:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    
		return -E_EOF;
  80154a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80154f:	eb f7                	jmp    801548 <getchar+0x24>

00801551 <iscons>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	e8 f3 ee ff ff       	call   80045a <fd_lookup>
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 11                	js     80157f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801577:	39 10                	cmp    %edx,(%eax)
  801579:	0f 94 c0             	sete   %al
  80157c:	0f b6 c0             	movzbl %al,%eax
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <opencons>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80158b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158e:	50                   	push   %eax
  80158f:	e8 70 ee ff ff       	call   800404 <fd_alloc>
  801594:	83 c4 10             	add    $0x10,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	78 3a                	js     8015d5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80159b:	83 ec 04             	sub    $0x4,%esp
  80159e:	68 07 04 00 00       	push   $0x407
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	6a 00                	push   $0x0
  8015a8:	e8 f4 eb ff ff       	call   8001a1 <sys_page_alloc>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 21                	js     8015d5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8015b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015bd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	50                   	push   %eax
  8015cd:	e8 03 ee ff ff       	call   8003d5 <fd2num>
  8015d2:	83 c4 10             	add    $0x10,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015d7:	f3 0f 1e fb          	endbr32 
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015e9:	e8 6d eb ff ff       	call   80015b <sys_getenvid>
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	ff 75 0c             	pushl  0xc(%ebp)
  8015f4:	ff 75 08             	pushl  0x8(%ebp)
  8015f7:	56                   	push   %esi
  8015f8:	50                   	push   %eax
  8015f9:	68 60 25 80 00       	push   $0x802560
  8015fe:	e8 bb 00 00 00       	call   8016be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801603:	83 c4 18             	add    $0x18,%esp
  801606:	53                   	push   %ebx
  801607:	ff 75 10             	pushl  0x10(%ebp)
  80160a:	e8 5a 00 00 00       	call   801669 <vcprintf>
	cprintf("\n");
  80160f:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  801616:	e8 a3 00 00 00       	call   8016be <cprintf>
  80161b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80161e:	cc                   	int3   
  80161f:	eb fd                	jmp    80161e <_panic+0x47>

00801621 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801621:	f3 0f 1e fb          	endbr32 
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80162f:	8b 13                	mov    (%ebx),%edx
  801631:	8d 42 01             	lea    0x1(%edx),%eax
  801634:	89 03                	mov    %eax,(%ebx)
  801636:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801639:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80163d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801642:	74 09                	je     80164d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801644:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	68 ff 00 00 00       	push   $0xff
  801655:	8d 43 08             	lea    0x8(%ebx),%eax
  801658:	50                   	push   %eax
  801659:	e8 73 ea ff ff       	call   8000d1 <sys_cputs>
		b->idx = 0;
  80165e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	eb db                	jmp    801644 <putch+0x23>

00801669 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801669:	f3 0f 1e fb          	endbr32 
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801676:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80167d:	00 00 00 
	b.cnt = 0;
  801680:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801687:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	ff 75 08             	pushl  0x8(%ebp)
  801690:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	68 21 16 80 00       	push   $0x801621
  80169c:	e8 20 01 00 00       	call   8017c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8016a1:	83 c4 08             	add    $0x8,%esp
  8016a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8016aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8016b0:	50                   	push   %eax
  8016b1:	e8 1b ea ff ff       	call   8000d1 <sys_cputs>

	return b.cnt;
}
  8016b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016be:	f3 0f 1e fb          	endbr32 
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016cb:	50                   	push   %eax
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	e8 95 ff ff ff       	call   801669 <vcprintf>
	va_end(ap);

	return cnt;
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	57                   	push   %edi
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 1c             	sub    $0x1c,%esp
  8016df:	89 c7                	mov    %eax,%edi
  8016e1:	89 d6                	mov    %edx,%esi
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e9:	89 d1                	mov    %edx,%ecx
  8016eb:	89 c2                	mov    %eax,%edx
  8016ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801703:	39 c2                	cmp    %eax,%edx
  801705:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801708:	72 3e                	jb     801748 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	ff 75 18             	pushl  0x18(%ebp)
  801710:	83 eb 01             	sub    $0x1,%ebx
  801713:	53                   	push   %ebx
  801714:	50                   	push   %eax
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	ff 75 e4             	pushl  -0x1c(%ebp)
  80171b:	ff 75 e0             	pushl  -0x20(%ebp)
  80171e:	ff 75 dc             	pushl  -0x24(%ebp)
  801721:	ff 75 d8             	pushl  -0x28(%ebp)
  801724:	e8 67 0a 00 00       	call   802190 <__udivdi3>
  801729:	83 c4 18             	add    $0x18,%esp
  80172c:	52                   	push   %edx
  80172d:	50                   	push   %eax
  80172e:	89 f2                	mov    %esi,%edx
  801730:	89 f8                	mov    %edi,%eax
  801732:	e8 9f ff ff ff       	call   8016d6 <printnum>
  801737:	83 c4 20             	add    $0x20,%esp
  80173a:	eb 13                	jmp    80174f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	56                   	push   %esi
  801740:	ff 75 18             	pushl  0x18(%ebp)
  801743:	ff d7                	call   *%edi
  801745:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801748:	83 eb 01             	sub    $0x1,%ebx
  80174b:	85 db                	test   %ebx,%ebx
  80174d:	7f ed                	jg     80173c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	56                   	push   %esi
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	ff 75 e4             	pushl  -0x1c(%ebp)
  801759:	ff 75 e0             	pushl  -0x20(%ebp)
  80175c:	ff 75 dc             	pushl  -0x24(%ebp)
  80175f:	ff 75 d8             	pushl  -0x28(%ebp)
  801762:	e8 39 0b 00 00       	call   8022a0 <__umoddi3>
  801767:	83 c4 14             	add    $0x14,%esp
  80176a:	0f be 80 83 25 80 00 	movsbl 0x802583(%eax),%eax
  801771:	50                   	push   %eax
  801772:	ff d7                	call   *%edi
}
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80177a:	5b                   	pop    %ebx
  80177b:	5e                   	pop    %esi
  80177c:	5f                   	pop    %edi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80177f:	f3 0f 1e fb          	endbr32 
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801789:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80178d:	8b 10                	mov    (%eax),%edx
  80178f:	3b 50 04             	cmp    0x4(%eax),%edx
  801792:	73 0a                	jae    80179e <sprintputch+0x1f>
		*b->buf++ = ch;
  801794:	8d 4a 01             	lea    0x1(%edx),%ecx
  801797:	89 08                	mov    %ecx,(%eax)
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	88 02                	mov    %al,(%edx)
}
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <printfmt>:
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8017aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8017ad:	50                   	push   %eax
  8017ae:	ff 75 10             	pushl  0x10(%ebp)
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 05 00 00 00       	call   8017c1 <vprintfmt>
}
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <vprintfmt>:
{
  8017c1:	f3 0f 1e fb          	endbr32 
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	57                   	push   %edi
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
  8017cb:	83 ec 3c             	sub    $0x3c,%esp
  8017ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8017d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017d7:	e9 8e 03 00 00       	jmp    801b6a <vprintfmt+0x3a9>
		padc = ' ';
  8017dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017fa:	8d 47 01             	lea    0x1(%edi),%eax
  8017fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801800:	0f b6 17             	movzbl (%edi),%edx
  801803:	8d 42 dd             	lea    -0x23(%edx),%eax
  801806:	3c 55                	cmp    $0x55,%al
  801808:	0f 87 df 03 00 00    	ja     801bed <vprintfmt+0x42c>
  80180e:	0f b6 c0             	movzbl %al,%eax
  801811:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  801818:	00 
  801819:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80181c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801820:	eb d8                	jmp    8017fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801822:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801825:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801829:	eb cf                	jmp    8017fa <vprintfmt+0x39>
  80182b:	0f b6 d2             	movzbl %dl,%edx
  80182e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801831:	b8 00 00 00 00       	mov    $0x0,%eax
  801836:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801839:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80183c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801840:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801843:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801846:	83 f9 09             	cmp    $0x9,%ecx
  801849:	77 55                	ja     8018a0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80184b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80184e:	eb e9                	jmp    801839 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801850:	8b 45 14             	mov    0x14(%ebp),%eax
  801853:	8b 00                	mov    (%eax),%eax
  801855:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801858:	8b 45 14             	mov    0x14(%ebp),%eax
  80185b:	8d 40 04             	lea    0x4(%eax),%eax
  80185e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801861:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801868:	79 90                	jns    8017fa <vprintfmt+0x39>
				width = precision, precision = -1;
  80186a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80186d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801870:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801877:	eb 81                	jmp    8017fa <vprintfmt+0x39>
  801879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187c:	85 c0                	test   %eax,%eax
  80187e:	ba 00 00 00 00       	mov    $0x0,%edx
  801883:	0f 49 d0             	cmovns %eax,%edx
  801886:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801889:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80188c:	e9 69 ff ff ff       	jmp    8017fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801891:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801894:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80189b:	e9 5a ff ff ff       	jmp    8017fa <vprintfmt+0x39>
  8018a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8018a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018a6:	eb bc                	jmp    801864 <vprintfmt+0xa3>
			lflag++;
  8018a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8018ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018ae:	e9 47 ff ff ff       	jmp    8017fa <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8018b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b6:	8d 78 04             	lea    0x4(%eax),%edi
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	53                   	push   %ebx
  8018bd:	ff 30                	pushl  (%eax)
  8018bf:	ff d6                	call   *%esi
			break;
  8018c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8018c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018c7:	e9 9b 02 00 00       	jmp    801b67 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cf:	8d 78 04             	lea    0x4(%eax),%edi
  8018d2:	8b 00                	mov    (%eax),%eax
  8018d4:	99                   	cltd   
  8018d5:	31 d0                	xor    %edx,%eax
  8018d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018d9:	83 f8 0f             	cmp    $0xf,%eax
  8018dc:	7f 23                	jg     801901 <vprintfmt+0x140>
  8018de:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  8018e5:	85 d2                	test   %edx,%edx
  8018e7:	74 18                	je     801901 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018e9:	52                   	push   %edx
  8018ea:	68 e1 24 80 00       	push   $0x8024e1
  8018ef:	53                   	push   %ebx
  8018f0:	56                   	push   %esi
  8018f1:	e8 aa fe ff ff       	call   8017a0 <printfmt>
  8018f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018fc:	e9 66 02 00 00       	jmp    801b67 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801901:	50                   	push   %eax
  801902:	68 9b 25 80 00       	push   $0x80259b
  801907:	53                   	push   %ebx
  801908:	56                   	push   %esi
  801909:	e8 92 fe ff ff       	call   8017a0 <printfmt>
  80190e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801911:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801914:	e9 4e 02 00 00       	jmp    801b67 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801919:	8b 45 14             	mov    0x14(%ebp),%eax
  80191c:	83 c0 04             	add    $0x4,%eax
  80191f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801922:	8b 45 14             	mov    0x14(%ebp),%eax
  801925:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801927:	85 d2                	test   %edx,%edx
  801929:	b8 94 25 80 00       	mov    $0x802594,%eax
  80192e:	0f 45 c2             	cmovne %edx,%eax
  801931:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801938:	7e 06                	jle    801940 <vprintfmt+0x17f>
  80193a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80193e:	75 0d                	jne    80194d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801940:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801943:	89 c7                	mov    %eax,%edi
  801945:	03 45 e0             	add    -0x20(%ebp),%eax
  801948:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80194b:	eb 55                	jmp    8019a2 <vprintfmt+0x1e1>
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	ff 75 d8             	pushl  -0x28(%ebp)
  801953:	ff 75 cc             	pushl  -0x34(%ebp)
  801956:	e8 46 03 00 00       	call   801ca1 <strnlen>
  80195b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80195e:	29 c2                	sub    %eax,%edx
  801960:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801968:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80196c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80196f:	85 ff                	test   %edi,%edi
  801971:	7e 11                	jle    801984 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	53                   	push   %ebx
  801977:	ff 75 e0             	pushl  -0x20(%ebp)
  80197a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80197c:	83 ef 01             	sub    $0x1,%edi
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	eb eb                	jmp    80196f <vprintfmt+0x1ae>
  801984:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801987:	85 d2                	test   %edx,%edx
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
  80198e:	0f 49 c2             	cmovns %edx,%eax
  801991:	29 c2                	sub    %eax,%edx
  801993:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801996:	eb a8                	jmp    801940 <vprintfmt+0x17f>
					putch(ch, putdat);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	53                   	push   %ebx
  80199c:	52                   	push   %edx
  80199d:	ff d6                	call   *%esi
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8019a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019a7:	83 c7 01             	add    $0x1,%edi
  8019aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8019ae:	0f be d0             	movsbl %al,%edx
  8019b1:	85 d2                	test   %edx,%edx
  8019b3:	74 4b                	je     801a00 <vprintfmt+0x23f>
  8019b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8019b9:	78 06                	js     8019c1 <vprintfmt+0x200>
  8019bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8019bf:	78 1e                	js     8019df <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8019c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019c5:	74 d1                	je     801998 <vprintfmt+0x1d7>
  8019c7:	0f be c0             	movsbl %al,%eax
  8019ca:	83 e8 20             	sub    $0x20,%eax
  8019cd:	83 f8 5e             	cmp    $0x5e,%eax
  8019d0:	76 c6                	jbe    801998 <vprintfmt+0x1d7>
					putch('?', putdat);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	53                   	push   %ebx
  8019d6:	6a 3f                	push   $0x3f
  8019d8:	ff d6                	call   *%esi
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	eb c3                	jmp    8019a2 <vprintfmt+0x1e1>
  8019df:	89 cf                	mov    %ecx,%edi
  8019e1:	eb 0e                	jmp    8019f1 <vprintfmt+0x230>
				putch(' ', putdat);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	53                   	push   %ebx
  8019e7:	6a 20                	push   $0x20
  8019e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019eb:	83 ef 01             	sub    $0x1,%edi
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	85 ff                	test   %edi,%edi
  8019f3:	7f ee                	jg     8019e3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8019fb:	e9 67 01 00 00       	jmp    801b67 <vprintfmt+0x3a6>
  801a00:	89 cf                	mov    %ecx,%edi
  801a02:	eb ed                	jmp    8019f1 <vprintfmt+0x230>
	if (lflag >= 2)
  801a04:	83 f9 01             	cmp    $0x1,%ecx
  801a07:	7f 1b                	jg     801a24 <vprintfmt+0x263>
	else if (lflag)
  801a09:	85 c9                	test   %ecx,%ecx
  801a0b:	74 63                	je     801a70 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a10:	8b 00                	mov    (%eax),%eax
  801a12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a15:	99                   	cltd   
  801a16:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8d 40 04             	lea    0x4(%eax),%eax
  801a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  801a22:	eb 17                	jmp    801a3b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a24:	8b 45 14             	mov    0x14(%ebp),%eax
  801a27:	8b 50 04             	mov    0x4(%eax),%edx
  801a2a:	8b 00                	mov    (%eax),%eax
  801a2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a32:	8b 45 14             	mov    0x14(%ebp),%eax
  801a35:	8d 40 08             	lea    0x8(%eax),%eax
  801a38:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a3e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a41:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a46:	85 c9                	test   %ecx,%ecx
  801a48:	0f 89 ff 00 00 00    	jns    801b4d <vprintfmt+0x38c>
				putch('-', putdat);
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	53                   	push   %ebx
  801a52:	6a 2d                	push   $0x2d
  801a54:	ff d6                	call   *%esi
				num = -(long long) num;
  801a56:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a59:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a5c:	f7 da                	neg    %edx
  801a5e:	83 d1 00             	adc    $0x0,%ecx
  801a61:	f7 d9                	neg    %ecx
  801a63:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a66:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a6b:	e9 dd 00 00 00       	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a78:	99                   	cltd   
  801a79:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7f:	8d 40 04             	lea    0x4(%eax),%eax
  801a82:	89 45 14             	mov    %eax,0x14(%ebp)
  801a85:	eb b4                	jmp    801a3b <vprintfmt+0x27a>
	if (lflag >= 2)
  801a87:	83 f9 01             	cmp    $0x1,%ecx
  801a8a:	7f 1e                	jg     801aaa <vprintfmt+0x2e9>
	else if (lflag)
  801a8c:	85 c9                	test   %ecx,%ecx
  801a8e:	74 32                	je     801ac2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a90:	8b 45 14             	mov    0x14(%ebp),%eax
  801a93:	8b 10                	mov    (%eax),%edx
  801a95:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9a:	8d 40 04             	lea    0x4(%eax),%eax
  801a9d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aa0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801aa5:	e9 a3 00 00 00       	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801aaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801aad:	8b 10                	mov    (%eax),%edx
  801aaf:	8b 48 04             	mov    0x4(%eax),%ecx
  801ab2:	8d 40 08             	lea    0x8(%eax),%eax
  801ab5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ab8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801abd:	e9 8b 00 00 00       	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ac2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac5:	8b 10                	mov    (%eax),%edx
  801ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801acc:	8d 40 04             	lea    0x4(%eax),%eax
  801acf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ad2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801ad7:	eb 74                	jmp    801b4d <vprintfmt+0x38c>
	if (lflag >= 2)
  801ad9:	83 f9 01             	cmp    $0x1,%ecx
  801adc:	7f 1b                	jg     801af9 <vprintfmt+0x338>
	else if (lflag)
  801ade:	85 c9                	test   %ecx,%ecx
  801ae0:	74 2c                	je     801b0e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae5:	8b 10                	mov    (%eax),%edx
  801ae7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aec:	8d 40 04             	lea    0x4(%eax),%eax
  801aef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801af2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801af7:	eb 54                	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801af9:	8b 45 14             	mov    0x14(%ebp),%eax
  801afc:	8b 10                	mov    (%eax),%edx
  801afe:	8b 48 04             	mov    0x4(%eax),%ecx
  801b01:	8d 40 08             	lea    0x8(%eax),%eax
  801b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b07:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b0c:	eb 3f                	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8b 10                	mov    (%eax),%edx
  801b13:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b18:	8d 40 04             	lea    0x4(%eax),%eax
  801b1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b1e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b23:	eb 28                	jmp    801b4d <vprintfmt+0x38c>
			putch('0', putdat);
  801b25:	83 ec 08             	sub    $0x8,%esp
  801b28:	53                   	push   %ebx
  801b29:	6a 30                	push   $0x30
  801b2b:	ff d6                	call   *%esi
			putch('x', putdat);
  801b2d:	83 c4 08             	add    $0x8,%esp
  801b30:	53                   	push   %ebx
  801b31:	6a 78                	push   $0x78
  801b33:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b35:	8b 45 14             	mov    0x14(%ebp),%eax
  801b38:	8b 10                	mov    (%eax),%edx
  801b3a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b3f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b42:	8d 40 04             	lea    0x4(%eax),%eax
  801b45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b48:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b54:	57                   	push   %edi
  801b55:	ff 75 e0             	pushl  -0x20(%ebp)
  801b58:	50                   	push   %eax
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	89 da                	mov    %ebx,%edx
  801b5d:	89 f0                	mov    %esi,%eax
  801b5f:	e8 72 fb ff ff       	call   8016d6 <printnum>
			break;
  801b64:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b6a:	83 c7 01             	add    $0x1,%edi
  801b6d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b71:	83 f8 25             	cmp    $0x25,%eax
  801b74:	0f 84 62 fc ff ff    	je     8017dc <vprintfmt+0x1b>
			if (ch == '\0')
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	0f 84 8b 00 00 00    	je     801c0d <vprintfmt+0x44c>
			putch(ch, putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	53                   	push   %ebx
  801b86:	50                   	push   %eax
  801b87:	ff d6                	call   *%esi
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	eb dc                	jmp    801b6a <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b8e:	83 f9 01             	cmp    $0x1,%ecx
  801b91:	7f 1b                	jg     801bae <vprintfmt+0x3ed>
	else if (lflag)
  801b93:	85 c9                	test   %ecx,%ecx
  801b95:	74 2c                	je     801bc3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b97:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9a:	8b 10                	mov    (%eax),%edx
  801b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba1:	8d 40 04             	lea    0x4(%eax),%eax
  801ba4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801bac:	eb 9f                	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801bae:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb1:	8b 10                	mov    (%eax),%edx
  801bb3:	8b 48 04             	mov    0x4(%eax),%ecx
  801bb6:	8d 40 08             	lea    0x8(%eax),%eax
  801bb9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bbc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801bc1:	eb 8a                	jmp    801b4d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801bc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc6:	8b 10                	mov    (%eax),%edx
  801bc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bcd:	8d 40 04             	lea    0x4(%eax),%eax
  801bd0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bd3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bd8:	e9 70 ff ff ff       	jmp    801b4d <vprintfmt+0x38c>
			putch(ch, putdat);
  801bdd:	83 ec 08             	sub    $0x8,%esp
  801be0:	53                   	push   %ebx
  801be1:	6a 25                	push   $0x25
  801be3:	ff d6                	call   *%esi
			break;
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	e9 7a ff ff ff       	jmp    801b67 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bed:	83 ec 08             	sub    $0x8,%esp
  801bf0:	53                   	push   %ebx
  801bf1:	6a 25                	push   $0x25
  801bf3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bf5:	83 c4 10             	add    $0x10,%esp
  801bf8:	89 f8                	mov    %edi,%eax
  801bfa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bfe:	74 05                	je     801c05 <vprintfmt+0x444>
  801c00:	83 e8 01             	sub    $0x1,%eax
  801c03:	eb f5                	jmp    801bfa <vprintfmt+0x439>
  801c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c08:	e9 5a ff ff ff       	jmp    801b67 <vprintfmt+0x3a6>
}
  801c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    

00801c15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c15:	f3 0f 1e fb          	endbr32 
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 18             	sub    $0x18,%esp
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c28:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c2c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c36:	85 c0                	test   %eax,%eax
  801c38:	74 26                	je     801c60 <vsnprintf+0x4b>
  801c3a:	85 d2                	test   %edx,%edx
  801c3c:	7e 22                	jle    801c60 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c3e:	ff 75 14             	pushl  0x14(%ebp)
  801c41:	ff 75 10             	pushl  0x10(%ebp)
  801c44:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c47:	50                   	push   %eax
  801c48:	68 7f 17 80 00       	push   $0x80177f
  801c4d:	e8 6f fb ff ff       	call   8017c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c55:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5b:	83 c4 10             	add    $0x10,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    
		return -E_INVAL;
  801c60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c65:	eb f7                	jmp    801c5e <vsnprintf+0x49>

00801c67 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c67:	f3 0f 1e fb          	endbr32 
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c71:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c74:	50                   	push   %eax
  801c75:	ff 75 10             	pushl  0x10(%ebp)
  801c78:	ff 75 0c             	pushl  0xc(%ebp)
  801c7b:	ff 75 08             	pushl  0x8(%ebp)
  801c7e:	e8 92 ff ff ff       	call   801c15 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c85:	f3 0f 1e fb          	endbr32 
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c98:	74 05                	je     801c9f <strlen+0x1a>
		n++;
  801c9a:	83 c0 01             	add    $0x1,%eax
  801c9d:	eb f5                	jmp    801c94 <strlen+0xf>
	return n;
}
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    

00801ca1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ca1:	f3 0f 1e fb          	endbr32 
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	39 d0                	cmp    %edx,%eax
  801cb5:	74 0d                	je     801cc4 <strnlen+0x23>
  801cb7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801cbb:	74 05                	je     801cc2 <strnlen+0x21>
		n++;
  801cbd:	83 c0 01             	add    $0x1,%eax
  801cc0:	eb f1                	jmp    801cb3 <strnlen+0x12>
  801cc2:	89 c2                	mov    %eax,%edx
	return n;
}
  801cc4:	89 d0                	mov    %edx,%eax
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    

00801cc8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cc8:	f3 0f 1e fb          	endbr32 
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	53                   	push   %ebx
  801cd0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cdf:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801ce2:	83 c0 01             	add    $0x1,%eax
  801ce5:	84 d2                	test   %dl,%dl
  801ce7:	75 f2                	jne    801cdb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801ce9:	89 c8                	mov    %ecx,%eax
  801ceb:	5b                   	pop    %ebx
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    

00801cee <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cee:	f3 0f 1e fb          	endbr32 
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 10             	sub    $0x10,%esp
  801cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801cfc:	53                   	push   %ebx
  801cfd:	e8 83 ff ff ff       	call   801c85 <strlen>
  801d02:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	01 d8                	add    %ebx,%eax
  801d0a:	50                   	push   %eax
  801d0b:	e8 b8 ff ff ff       	call   801cc8 <strcpy>
	return dst;
}
  801d10:	89 d8                	mov    %ebx,%eax
  801d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d17:	f3 0f 1e fb          	endbr32 
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	8b 75 08             	mov    0x8(%ebp),%esi
  801d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d26:	89 f3                	mov    %esi,%ebx
  801d28:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d2b:	89 f0                	mov    %esi,%eax
  801d2d:	39 d8                	cmp    %ebx,%eax
  801d2f:	74 11                	je     801d42 <strncpy+0x2b>
		*dst++ = *src;
  801d31:	83 c0 01             	add    $0x1,%eax
  801d34:	0f b6 0a             	movzbl (%edx),%ecx
  801d37:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d3a:	80 f9 01             	cmp    $0x1,%cl
  801d3d:	83 da ff             	sbb    $0xffffffff,%edx
  801d40:	eb eb                	jmp    801d2d <strncpy+0x16>
	}
	return ret;
}
  801d42:	89 f0                	mov    %esi,%eax
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    

00801d48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d48:	f3 0f 1e fb          	endbr32 
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	56                   	push   %esi
  801d50:	53                   	push   %ebx
  801d51:	8b 75 08             	mov    0x8(%ebp),%esi
  801d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d57:	8b 55 10             	mov    0x10(%ebp),%edx
  801d5a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d5c:	85 d2                	test   %edx,%edx
  801d5e:	74 21                	je     801d81 <strlcpy+0x39>
  801d60:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d64:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d66:	39 c2                	cmp    %eax,%edx
  801d68:	74 14                	je     801d7e <strlcpy+0x36>
  801d6a:	0f b6 19             	movzbl (%ecx),%ebx
  801d6d:	84 db                	test   %bl,%bl
  801d6f:	74 0b                	je     801d7c <strlcpy+0x34>
			*dst++ = *src++;
  801d71:	83 c1 01             	add    $0x1,%ecx
  801d74:	83 c2 01             	add    $0x1,%edx
  801d77:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d7a:	eb ea                	jmp    801d66 <strlcpy+0x1e>
  801d7c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d7e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d81:	29 f0                	sub    %esi,%eax
}
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5d                   	pop    %ebp
  801d86:	c3                   	ret    

00801d87 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d87:	f3 0f 1e fb          	endbr32 
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d94:	0f b6 01             	movzbl (%ecx),%eax
  801d97:	84 c0                	test   %al,%al
  801d99:	74 0c                	je     801da7 <strcmp+0x20>
  801d9b:	3a 02                	cmp    (%edx),%al
  801d9d:	75 08                	jne    801da7 <strcmp+0x20>
		p++, q++;
  801d9f:	83 c1 01             	add    $0x1,%ecx
  801da2:	83 c2 01             	add    $0x1,%edx
  801da5:	eb ed                	jmp    801d94 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801da7:	0f b6 c0             	movzbl %al,%eax
  801daa:	0f b6 12             	movzbl (%edx),%edx
  801dad:	29 d0                	sub    %edx,%eax
}
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    

00801db1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801db1:	f3 0f 1e fb          	endbr32 
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbf:	89 c3                	mov    %eax,%ebx
  801dc1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801dc4:	eb 06                	jmp    801dcc <strncmp+0x1b>
		n--, p++, q++;
  801dc6:	83 c0 01             	add    $0x1,%eax
  801dc9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801dcc:	39 d8                	cmp    %ebx,%eax
  801dce:	74 16                	je     801de6 <strncmp+0x35>
  801dd0:	0f b6 08             	movzbl (%eax),%ecx
  801dd3:	84 c9                	test   %cl,%cl
  801dd5:	74 04                	je     801ddb <strncmp+0x2a>
  801dd7:	3a 0a                	cmp    (%edx),%cl
  801dd9:	74 eb                	je     801dc6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ddb:	0f b6 00             	movzbl (%eax),%eax
  801dde:	0f b6 12             	movzbl (%edx),%edx
  801de1:	29 d0                	sub    %edx,%eax
}
  801de3:	5b                   	pop    %ebx
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
		return 0;
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
  801deb:	eb f6                	jmp    801de3 <strncmp+0x32>

00801ded <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ded:	f3 0f 1e fb          	endbr32 
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dfb:	0f b6 10             	movzbl (%eax),%edx
  801dfe:	84 d2                	test   %dl,%dl
  801e00:	74 09                	je     801e0b <strchr+0x1e>
		if (*s == c)
  801e02:	38 ca                	cmp    %cl,%dl
  801e04:	74 0a                	je     801e10 <strchr+0x23>
	for (; *s; s++)
  801e06:	83 c0 01             	add    $0x1,%eax
  801e09:	eb f0                	jmp    801dfb <strchr+0xe>
			return (char *) s;
	return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e12:	f3 0f 1e fb          	endbr32 
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e20:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e23:	38 ca                	cmp    %cl,%dl
  801e25:	74 09                	je     801e30 <strfind+0x1e>
  801e27:	84 d2                	test   %dl,%dl
  801e29:	74 05                	je     801e30 <strfind+0x1e>
	for (; *s; s++)
  801e2b:	83 c0 01             	add    $0x1,%eax
  801e2e:	eb f0                	jmp    801e20 <strfind+0xe>
			break;
	return (char *) s;
}
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    

00801e32 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e32:	f3 0f 1e fb          	endbr32 
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	57                   	push   %edi
  801e3a:	56                   	push   %esi
  801e3b:	53                   	push   %ebx
  801e3c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e42:	85 c9                	test   %ecx,%ecx
  801e44:	74 31                	je     801e77 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e46:	89 f8                	mov    %edi,%eax
  801e48:	09 c8                	or     %ecx,%eax
  801e4a:	a8 03                	test   $0x3,%al
  801e4c:	75 23                	jne    801e71 <memset+0x3f>
		c &= 0xFF;
  801e4e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e52:	89 d3                	mov    %edx,%ebx
  801e54:	c1 e3 08             	shl    $0x8,%ebx
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	c1 e0 18             	shl    $0x18,%eax
  801e5c:	89 d6                	mov    %edx,%esi
  801e5e:	c1 e6 10             	shl    $0x10,%esi
  801e61:	09 f0                	or     %esi,%eax
  801e63:	09 c2                	or     %eax,%edx
  801e65:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e67:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	fc                   	cld    
  801e6d:	f3 ab                	rep stos %eax,%es:(%edi)
  801e6f:	eb 06                	jmp    801e77 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	fc                   	cld    
  801e75:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e77:	89 f8                	mov    %edi,%eax
  801e79:	5b                   	pop    %ebx
  801e7a:	5e                   	pop    %esi
  801e7b:	5f                   	pop    %edi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e7e:	f3 0f 1e fb          	endbr32 
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	57                   	push   %edi
  801e86:	56                   	push   %esi
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e90:	39 c6                	cmp    %eax,%esi
  801e92:	73 32                	jae    801ec6 <memmove+0x48>
  801e94:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e97:	39 c2                	cmp    %eax,%edx
  801e99:	76 2b                	jbe    801ec6 <memmove+0x48>
		s += n;
		d += n;
  801e9b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e9e:	89 fe                	mov    %edi,%esi
  801ea0:	09 ce                	or     %ecx,%esi
  801ea2:	09 d6                	or     %edx,%esi
  801ea4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801eaa:	75 0e                	jne    801eba <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801eac:	83 ef 04             	sub    $0x4,%edi
  801eaf:	8d 72 fc             	lea    -0x4(%edx),%esi
  801eb2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801eb5:	fd                   	std    
  801eb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801eb8:	eb 09                	jmp    801ec3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801eba:	83 ef 01             	sub    $0x1,%edi
  801ebd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801ec0:	fd                   	std    
  801ec1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ec3:	fc                   	cld    
  801ec4:	eb 1a                	jmp    801ee0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801ec6:	89 c2                	mov    %eax,%edx
  801ec8:	09 ca                	or     %ecx,%edx
  801eca:	09 f2                	or     %esi,%edx
  801ecc:	f6 c2 03             	test   $0x3,%dl
  801ecf:	75 0a                	jne    801edb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ed1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ed4:	89 c7                	mov    %eax,%edi
  801ed6:	fc                   	cld    
  801ed7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ed9:	eb 05                	jmp    801ee0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801edb:	89 c7                	mov    %eax,%edi
  801edd:	fc                   	cld    
  801ede:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ee4:	f3 0f 1e fb          	endbr32 
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801eee:	ff 75 10             	pushl  0x10(%ebp)
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 82 ff ff ff       	call   801e7e <memmove>
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801efe:	f3 0f 1e fb          	endbr32 
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	56                   	push   %esi
  801f06:	53                   	push   %ebx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	89 c6                	mov    %eax,%esi
  801f0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f12:	39 f0                	cmp    %esi,%eax
  801f14:	74 1c                	je     801f32 <memcmp+0x34>
		if (*s1 != *s2)
  801f16:	0f b6 08             	movzbl (%eax),%ecx
  801f19:	0f b6 1a             	movzbl (%edx),%ebx
  801f1c:	38 d9                	cmp    %bl,%cl
  801f1e:	75 08                	jne    801f28 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f20:	83 c0 01             	add    $0x1,%eax
  801f23:	83 c2 01             	add    $0x1,%edx
  801f26:	eb ea                	jmp    801f12 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f28:	0f b6 c1             	movzbl %cl,%eax
  801f2b:	0f b6 db             	movzbl %bl,%ebx
  801f2e:	29 d8                	sub    %ebx,%eax
  801f30:	eb 05                	jmp    801f37 <memcmp+0x39>
	}

	return 0;
  801f32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f3b:	f3 0f 1e fb          	endbr32 
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f48:	89 c2                	mov    %eax,%edx
  801f4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f4d:	39 d0                	cmp    %edx,%eax
  801f4f:	73 09                	jae    801f5a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f51:	38 08                	cmp    %cl,(%eax)
  801f53:	74 05                	je     801f5a <memfind+0x1f>
	for (; s < ends; s++)
  801f55:	83 c0 01             	add    $0x1,%eax
  801f58:	eb f3                	jmp    801f4d <memfind+0x12>
			break;
	return (void *) s;
}
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f5c:	f3 0f 1e fb          	endbr32 
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	57                   	push   %edi
  801f64:	56                   	push   %esi
  801f65:	53                   	push   %ebx
  801f66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f6c:	eb 03                	jmp    801f71 <strtol+0x15>
		s++;
  801f6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f71:	0f b6 01             	movzbl (%ecx),%eax
  801f74:	3c 20                	cmp    $0x20,%al
  801f76:	74 f6                	je     801f6e <strtol+0x12>
  801f78:	3c 09                	cmp    $0x9,%al
  801f7a:	74 f2                	je     801f6e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f7c:	3c 2b                	cmp    $0x2b,%al
  801f7e:	74 2a                	je     801faa <strtol+0x4e>
	int neg = 0;
  801f80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f85:	3c 2d                	cmp    $0x2d,%al
  801f87:	74 2b                	je     801fb4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f8f:	75 0f                	jne    801fa0 <strtol+0x44>
  801f91:	80 39 30             	cmpb   $0x30,(%ecx)
  801f94:	74 28                	je     801fbe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f96:	85 db                	test   %ebx,%ebx
  801f98:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f9d:	0f 44 d8             	cmove  %eax,%ebx
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801fa8:	eb 46                	jmp    801ff0 <strtol+0x94>
		s++;
  801faa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801fad:	bf 00 00 00 00       	mov    $0x0,%edi
  801fb2:	eb d5                	jmp    801f89 <strtol+0x2d>
		s++, neg = 1;
  801fb4:	83 c1 01             	add    $0x1,%ecx
  801fb7:	bf 01 00 00 00       	mov    $0x1,%edi
  801fbc:	eb cb                	jmp    801f89 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fbe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801fc2:	74 0e                	je     801fd2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801fc4:	85 db                	test   %ebx,%ebx
  801fc6:	75 d8                	jne    801fa0 <strtol+0x44>
		s++, base = 8;
  801fc8:	83 c1 01             	add    $0x1,%ecx
  801fcb:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fd0:	eb ce                	jmp    801fa0 <strtol+0x44>
		s += 2, base = 16;
  801fd2:	83 c1 02             	add    $0x2,%ecx
  801fd5:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fda:	eb c4                	jmp    801fa0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fdc:	0f be d2             	movsbl %dl,%edx
  801fdf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fe2:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fe5:	7d 3a                	jge    802021 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fe7:	83 c1 01             	add    $0x1,%ecx
  801fea:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ff0:	0f b6 11             	movzbl (%ecx),%edx
  801ff3:	8d 72 d0             	lea    -0x30(%edx),%esi
  801ff6:	89 f3                	mov    %esi,%ebx
  801ff8:	80 fb 09             	cmp    $0x9,%bl
  801ffb:	76 df                	jbe    801fdc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801ffd:	8d 72 9f             	lea    -0x61(%edx),%esi
  802000:	89 f3                	mov    %esi,%ebx
  802002:	80 fb 19             	cmp    $0x19,%bl
  802005:	77 08                	ja     80200f <strtol+0xb3>
			dig = *s - 'a' + 10;
  802007:	0f be d2             	movsbl %dl,%edx
  80200a:	83 ea 57             	sub    $0x57,%edx
  80200d:	eb d3                	jmp    801fe2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80200f:	8d 72 bf             	lea    -0x41(%edx),%esi
  802012:	89 f3                	mov    %esi,%ebx
  802014:	80 fb 19             	cmp    $0x19,%bl
  802017:	77 08                	ja     802021 <strtol+0xc5>
			dig = *s - 'A' + 10;
  802019:	0f be d2             	movsbl %dl,%edx
  80201c:	83 ea 37             	sub    $0x37,%edx
  80201f:	eb c1                	jmp    801fe2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802021:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802025:	74 05                	je     80202c <strtol+0xd0>
		*endptr = (char *) s;
  802027:	8b 75 0c             	mov    0xc(%ebp),%esi
  80202a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80202c:	89 c2                	mov    %eax,%edx
  80202e:	f7 da                	neg    %edx
  802030:	85 ff                	test   %edi,%edi
  802032:	0f 45 c2             	cmovne %edx,%eax
}
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80203a:	f3 0f 1e fb          	endbr32 
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	8b 75 08             	mov    0x8(%ebp),%esi
  802046:	8b 45 0c             	mov    0xc(%ebp),%eax
  802049:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80204c:	83 e8 01             	sub    $0x1,%eax
  80204f:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802054:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802059:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	50                   	push   %eax
  802061:	e8 07 e3 ff ff       	call   80036d <sys_ipc_recv>
	if (!t) {
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	75 2b                	jne    802098 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80206d:	85 f6                	test   %esi,%esi
  80206f:	74 0a                	je     80207b <ipc_recv+0x41>
  802071:	a1 08 40 80 00       	mov    0x804008,%eax
  802076:	8b 40 74             	mov    0x74(%eax),%eax
  802079:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80207b:	85 db                	test   %ebx,%ebx
  80207d:	74 0a                	je     802089 <ipc_recv+0x4f>
  80207f:	a1 08 40 80 00       	mov    0x804008,%eax
  802084:	8b 40 78             	mov    0x78(%eax),%eax
  802087:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802089:	a1 08 40 80 00       	mov    0x804008,%eax
  80208e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802091:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802094:	5b                   	pop    %ebx
  802095:	5e                   	pop    %esi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802098:	85 f6                	test   %esi,%esi
  80209a:	74 06                	je     8020a2 <ipc_recv+0x68>
  80209c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8020a2:	85 db                	test   %ebx,%ebx
  8020a4:	74 eb                	je     802091 <ipc_recv+0x57>
  8020a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020ac:	eb e3                	jmp    802091 <ipc_recv+0x57>

008020ae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020ae:	f3 0f 1e fb          	endbr32 
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020c4:	85 db                	test   %ebx,%ebx
  8020c6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020cb:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020ce:	ff 75 14             	pushl  0x14(%ebp)
  8020d1:	53                   	push   %ebx
  8020d2:	56                   	push   %esi
  8020d3:	57                   	push   %edi
  8020d4:	e8 6d e2 ff ff       	call   800346 <sys_ipc_try_send>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 1e                	je     8020fe <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020e0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020e3:	75 07                	jne    8020ec <ipc_send+0x3e>
		sys_yield();
  8020e5:	e8 94 e0 ff ff       	call   80017e <sys_yield>
  8020ea:	eb e2                	jmp    8020ce <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020ec:	50                   	push   %eax
  8020ed:	68 7f 28 80 00       	push   $0x80287f
  8020f2:	6a 39                	push   $0x39
  8020f4:	68 91 28 80 00       	push   $0x802891
  8020f9:	e8 d9 f4 ff ff       	call   8015d7 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802101:	5b                   	pop    %ebx
  802102:	5e                   	pop    %esi
  802103:	5f                   	pop    %edi
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    

00802106 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802106:	f3 0f 1e fb          	endbr32 
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802115:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802118:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80211e:	8b 52 50             	mov    0x50(%edx),%edx
  802121:	39 ca                	cmp    %ecx,%edx
  802123:	74 11                	je     802136 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802125:	83 c0 01             	add    $0x1,%eax
  802128:	3d 00 04 00 00       	cmp    $0x400,%eax
  80212d:	75 e6                	jne    802115 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	eb 0b                	jmp    802141 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802136:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802139:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80213e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802141:	5d                   	pop    %ebp
  802142:	c3                   	ret    

00802143 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802143:	f3 0f 1e fb          	endbr32 
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80214d:	89 c2                	mov    %eax,%edx
  80214f:	c1 ea 16             	shr    $0x16,%edx
  802152:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802159:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80215e:	f6 c1 01             	test   $0x1,%cl
  802161:	74 1c                	je     80217f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802163:	c1 e8 0c             	shr    $0xc,%eax
  802166:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80216d:	a8 01                	test   $0x1,%al
  80216f:	74 0e                	je     80217f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802171:	c1 e8 0c             	shr    $0xc,%eax
  802174:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80217b:	ef 
  80217c:	0f b7 d2             	movzwl %dx,%edx
}
  80217f:	89 d0                	mov    %edx,%eax
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    
  802183:	66 90                	xchg   %ax,%ax
  802185:	66 90                	xchg   %ax,%ax
  802187:	66 90                	xchg   %ax,%ax
  802189:	66 90                	xchg   %ax,%ax
  80218b:	66 90                	xchg   %ax,%ax
  80218d:	66 90                	xchg   %ax,%ax
  80218f:	90                   	nop

00802190 <__udivdi3>:
  802190:	f3 0f 1e fb          	endbr32 
  802194:	55                   	push   %ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021ab:	85 d2                	test   %edx,%edx
  8021ad:	75 19                	jne    8021c8 <__udivdi3+0x38>
  8021af:	39 f3                	cmp    %esi,%ebx
  8021b1:	76 4d                	jbe    802200 <__udivdi3+0x70>
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	89 e8                	mov    %ebp,%eax
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	f7 f3                	div    %ebx
  8021bb:	89 fa                	mov    %edi,%edx
  8021bd:	83 c4 1c             	add    $0x1c,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	76 14                	jbe    8021e0 <__udivdi3+0x50>
  8021cc:	31 ff                	xor    %edi,%edi
  8021ce:	31 c0                	xor    %eax,%eax
  8021d0:	89 fa                	mov    %edi,%edx
  8021d2:	83 c4 1c             	add    $0x1c,%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5f                   	pop    %edi
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    
  8021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e0:	0f bd fa             	bsr    %edx,%edi
  8021e3:	83 f7 1f             	xor    $0x1f,%edi
  8021e6:	75 48                	jne    802230 <__udivdi3+0xa0>
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x62>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 de                	ja     8021d0 <__udivdi3+0x40>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb d7                	jmp    8021d0 <__udivdi3+0x40>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d9                	mov    %ebx,%ecx
  802202:	85 db                	test   %ebx,%ebx
  802204:	75 0b                	jne    802211 <__udivdi3+0x81>
  802206:	b8 01 00 00 00       	mov    $0x1,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f3                	div    %ebx
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	31 d2                	xor    %edx,%edx
  802213:	89 f0                	mov    %esi,%eax
  802215:	f7 f1                	div    %ecx
  802217:	89 c6                	mov    %eax,%esi
  802219:	89 e8                	mov    %ebp,%eax
  80221b:	89 f7                	mov    %esi,%edi
  80221d:	f7 f1                	div    %ecx
  80221f:	89 fa                	mov    %edi,%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	89 eb                	mov    %ebp,%ebx
  802261:	d3 e6                	shl    %cl,%esi
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 15                	jb     802290 <__udivdi3+0x100>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 04                	jae    802287 <__udivdi3+0xf7>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	74 09                	je     802290 <__udivdi3+0x100>
  802287:	89 d8                	mov    %ebx,%eax
  802289:	31 ff                	xor    %edi,%edi
  80228b:	e9 40 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  802290:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802293:	31 ff                	xor    %edi,%edi
  802295:	e9 36 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__umoddi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	75 19                	jne    8022d8 <__umoddi3+0x38>
  8022bf:	39 df                	cmp    %ebx,%edi
  8022c1:	76 5d                	jbe    802320 <__umoddi3+0x80>
  8022c3:	89 f0                	mov    %esi,%eax
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	f7 f7                	div    %edi
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	89 f2                	mov    %esi,%edx
  8022da:	39 d8                	cmp    %ebx,%eax
  8022dc:	76 12                	jbe    8022f0 <__umoddi3+0x50>
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	89 da                	mov    %ebx,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd e8             	bsr    %eax,%ebp
  8022f3:	83 f5 1f             	xor    $0x1f,%ebp
  8022f6:	75 50                	jne    802348 <__umoddi3+0xa8>
  8022f8:	39 d8                	cmp    %ebx,%eax
  8022fa:	0f 82 e0 00 00 00    	jb     8023e0 <__umoddi3+0x140>
  802300:	89 d9                	mov    %ebx,%ecx
  802302:	39 f7                	cmp    %esi,%edi
  802304:	0f 86 d6 00 00 00    	jbe    8023e0 <__umoddi3+0x140>
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	89 ca                	mov    %ecx,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 fd                	mov    %edi,%ebp
  802322:	85 ff                	test   %edi,%edi
  802324:	75 0b                	jne    802331 <__umoddi3+0x91>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f7                	div    %edi
  80232f:	89 c5                	mov    %eax,%ebp
  802331:	89 d8                	mov    %ebx,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f5                	div    %ebp
  802337:	89 f0                	mov    %esi,%eax
  802339:	f7 f5                	div    %ebp
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	31 d2                	xor    %edx,%edx
  80233f:	eb 8c                	jmp    8022cd <__umoddi3+0x2d>
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 e9                	mov    %ebp,%ecx
  80234a:	ba 20 00 00 00       	mov    $0x20,%edx
  80234f:	29 ea                	sub    %ebp,%edx
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 44 24 08          	mov    %eax,0x8(%esp)
  802357:	89 d1                	mov    %edx,%ecx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802361:	89 54 24 04          	mov    %edx,0x4(%esp)
  802365:	8b 54 24 04          	mov    0x4(%esp),%edx
  802369:	09 c1                	or     %eax,%ecx
  80236b:	89 d8                	mov    %ebx,%eax
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 e7                	shl    %cl,%edi
  802375:	89 d1                	mov    %edx,%ecx
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80237f:	d3 e3                	shl    %cl,%ebx
  802381:	89 c7                	mov    %eax,%edi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	89 f0                	mov    %esi,%eax
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 fa                	mov    %edi,%edx
  80238d:	d3 e6                	shl    %cl,%esi
  80238f:	09 d8                	or     %ebx,%eax
  802391:	f7 74 24 08          	divl   0x8(%esp)
  802395:	89 d1                	mov    %edx,%ecx
  802397:	89 f3                	mov    %esi,%ebx
  802399:	f7 64 24 0c          	mull   0xc(%esp)
  80239d:	89 c6                	mov    %eax,%esi
  80239f:	89 d7                	mov    %edx,%edi
  8023a1:	39 d1                	cmp    %edx,%ecx
  8023a3:	72 06                	jb     8023ab <__umoddi3+0x10b>
  8023a5:	75 10                	jne    8023b7 <__umoddi3+0x117>
  8023a7:	39 c3                	cmp    %eax,%ebx
  8023a9:	73 0c                	jae    8023b7 <__umoddi3+0x117>
  8023ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023b3:	89 d7                	mov    %edx,%edi
  8023b5:	89 c6                	mov    %eax,%esi
  8023b7:	89 ca                	mov    %ecx,%edx
  8023b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023be:	29 f3                	sub    %esi,%ebx
  8023c0:	19 fa                	sbb    %edi,%edx
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	d3 e0                	shl    %cl,%eax
  8023c6:	89 e9                	mov    %ebp,%ecx
  8023c8:	d3 eb                	shr    %cl,%ebx
  8023ca:	d3 ea                	shr    %cl,%edx
  8023cc:	09 d8                	or     %ebx,%eax
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	29 fe                	sub    %edi,%esi
  8023e2:	19 c3                	sbb    %eax,%ebx
  8023e4:	89 f2                	mov    %esi,%edx
  8023e6:	89 d9                	mov    %ebx,%ecx
  8023e8:	e9 1d ff ff ff       	jmp    80230a <__umoddi3+0x6a>
