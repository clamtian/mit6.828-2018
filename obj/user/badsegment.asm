
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800037:	66 b8 28 00          	mov    $0x28,%ax
  80003b:	8e d8                	mov    %eax,%ds
}
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	f3 0f 1e fb          	endbr32 
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 de 00 00 00       	call   800130 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800064:	85 db                	test   %ebx,%ebx
  800066:	7e 07                	jle    80006f <libmain+0x31>
		binaryname = argv[0];
  800068:	8b 06                	mov    (%esi),%eax
  80006a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006f:	83 ec 08             	sub    $0x8,%esp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	e8 ba ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800079:	e8 0a 00 00 00       	call   800088 <exit>
}
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800084:	5b                   	pop    %ebx
  800085:	5e                   	pop    %esi
  800086:	5d                   	pop    %ebp
  800087:	c3                   	ret    

00800088 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800092:	e8 07 05 00 00       	call   80059e <close_all>
	sys_env_destroy(0);
  800097:	83 ec 0c             	sub    $0xc,%esp
  80009a:	6a 00                	push   $0x0
  80009c:	e8 4a 00 00 00       	call   8000eb <sys_env_destroy>
}
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	c9                   	leave  
  8000a5:	c3                   	ret    

008000a6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a6:	f3 0f 1e fb          	endbr32 
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	57                   	push   %edi
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bb:	89 c3                	mov    %eax,%ebx
  8000bd:	89 c7                	mov    %eax,%edi
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5f                   	pop    %edi
  8000c6:	5d                   	pop    %ebp
  8000c7:	c3                   	ret    

008000c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c8:	f3 0f 1e fb          	endbr32 
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	57                   	push   %edi
  8000d0:	56                   	push   %esi
  8000d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8000dc:	89 d1                	mov    %edx,%ecx
  8000de:	89 d3                	mov    %edx,%ebx
  8000e0:	89 d7                	mov    %edx,%edi
  8000e2:	89 d6                	mov    %edx,%esi
  8000e4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000eb:	f3 0f 1e fb          	endbr32 
  8000ef:	55                   	push   %ebp
  8000f0:	89 e5                	mov    %esp,%ebp
  8000f2:	57                   	push   %edi
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800100:	b8 03 00 00 00       	mov    $0x3,%eax
  800105:	89 cb                	mov    %ecx,%ebx
  800107:	89 cf                	mov    %ecx,%edi
  800109:	89 ce                	mov    %ecx,%esi
  80010b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010d:	85 c0                	test   %eax,%eax
  80010f:	7f 08                	jg     800119 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800111:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5f                   	pop    %edi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	6a 03                	push   $0x3
  80011f:	68 ca 23 80 00       	push   $0x8023ca
  800124:	6a 23                	push   $0x23
  800126:	68 e7 23 80 00       	push   $0x8023e7
  80012b:	e8 7c 14 00 00       	call   8015ac <_panic>

00800130 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800130:	f3 0f 1e fb          	endbr32 
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	57                   	push   %edi
  800138:	56                   	push   %esi
  800139:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013a:	ba 00 00 00 00       	mov    $0x0,%edx
  80013f:	b8 02 00 00 00       	mov    $0x2,%eax
  800144:	89 d1                	mov    %edx,%ecx
  800146:	89 d3                	mov    %edx,%ebx
  800148:	89 d7                	mov    %edx,%edi
  80014a:	89 d6                	mov    %edx,%esi
  80014c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014e:	5b                   	pop    %ebx
  80014f:	5e                   	pop    %esi
  800150:	5f                   	pop    %edi
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    

00800153 <sys_yield>:

void
sys_yield(void)
{
  800153:	f3 0f 1e fb          	endbr32 
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80015d:	ba 00 00 00 00       	mov    $0x0,%edx
  800162:	b8 0b 00 00 00       	mov    $0xb,%eax
  800167:	89 d1                	mov    %edx,%ecx
  800169:	89 d3                	mov    %edx,%ebx
  80016b:	89 d7                	mov    %edx,%edi
  80016d:	89 d6                	mov    %edx,%esi
  80016f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5f                   	pop    %edi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800176:	f3 0f 1e fb          	endbr32 
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	57                   	push   %edi
  80017e:	56                   	push   %esi
  80017f:	53                   	push   %ebx
  800180:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800183:	be 00 00 00 00       	mov    $0x0,%esi
  800188:	8b 55 08             	mov    0x8(%ebp),%edx
  80018b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018e:	b8 04 00 00 00       	mov    $0x4,%eax
  800193:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800196:	89 f7                	mov    %esi,%edi
  800198:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019a:	85 c0                	test   %eax,%eax
  80019c:	7f 08                	jg     8001a6 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	50                   	push   %eax
  8001aa:	6a 04                	push   $0x4
  8001ac:	68 ca 23 80 00       	push   $0x8023ca
  8001b1:	6a 23                	push   $0x23
  8001b3:	68 e7 23 80 00       	push   $0x8023e7
  8001b8:	e8 ef 13 00 00       	call   8015ac <_panic>

008001bd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001bd:	f3 0f 1e fb          	endbr32 
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8001cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001db:	8b 75 18             	mov    0x18(%ebp),%esi
  8001de:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	7f 08                	jg     8001ec <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	50                   	push   %eax
  8001f0:	6a 05                	push   $0x5
  8001f2:	68 ca 23 80 00       	push   $0x8023ca
  8001f7:	6a 23                	push   $0x23
  8001f9:	68 e7 23 80 00       	push   $0x8023e7
  8001fe:	e8 a9 13 00 00       	call   8015ac <_panic>

00800203 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800203:	f3 0f 1e fb          	endbr32 
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	57                   	push   %edi
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
  80020d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800210:	bb 00 00 00 00       	mov    $0x0,%ebx
  800215:	8b 55 08             	mov    0x8(%ebp),%edx
  800218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021b:	b8 06 00 00 00       	mov    $0x6,%eax
  800220:	89 df                	mov    %ebx,%edi
  800222:	89 de                	mov    %ebx,%esi
  800224:	cd 30                	int    $0x30
	if(check && ret > 0)
  800226:	85 c0                	test   %eax,%eax
  800228:	7f 08                	jg     800232 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80022a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022d:	5b                   	pop    %ebx
  80022e:	5e                   	pop    %esi
  80022f:	5f                   	pop    %edi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	50                   	push   %eax
  800236:	6a 06                	push   $0x6
  800238:	68 ca 23 80 00       	push   $0x8023ca
  80023d:	6a 23                	push   $0x23
  80023f:	68 e7 23 80 00       	push   $0x8023e7
  800244:	e8 63 13 00 00       	call   8015ac <_panic>

00800249 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800249:	f3 0f 1e fb          	endbr32 
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	57                   	push   %edi
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
  800253:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800256:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025b:	8b 55 08             	mov    0x8(%ebp),%edx
  80025e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800261:	b8 08 00 00 00       	mov    $0x8,%eax
  800266:	89 df                	mov    %ebx,%edi
  800268:	89 de                	mov    %ebx,%esi
  80026a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80026c:	85 c0                	test   %eax,%eax
  80026e:	7f 08                	jg     800278 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	50                   	push   %eax
  80027c:	6a 08                	push   $0x8
  80027e:	68 ca 23 80 00       	push   $0x8023ca
  800283:	6a 23                	push   $0x23
  800285:	68 e7 23 80 00       	push   $0x8023e7
  80028a:	e8 1d 13 00 00       	call   8015ac <_panic>

0080028f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028f:	f3 0f 1e fb          	endbr32 
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80029c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002ac:	89 df                	mov    %ebx,%edi
  8002ae:	89 de                	mov    %ebx,%esi
  8002b0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b2:	85 c0                	test   %eax,%eax
  8002b4:	7f 08                	jg     8002be <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b9:	5b                   	pop    %ebx
  8002ba:	5e                   	pop    %esi
  8002bb:	5f                   	pop    %edi
  8002bc:	5d                   	pop    %ebp
  8002bd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	6a 09                	push   $0x9
  8002c4:	68 ca 23 80 00       	push   $0x8023ca
  8002c9:	6a 23                	push   $0x23
  8002cb:	68 e7 23 80 00       	push   $0x8023e7
  8002d0:	e8 d7 12 00 00       	call   8015ac <_panic>

008002d5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d5:	f3 0f 1e fb          	endbr32 
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	57                   	push   %edi
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f2:	89 df                	mov    %ebx,%edi
  8002f4:	89 de                	mov    %ebx,%esi
  8002f6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	7f 08                	jg     800304 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	6a 0a                	push   $0xa
  80030a:	68 ca 23 80 00       	push   $0x8023ca
  80030f:	6a 23                	push   $0x23
  800311:	68 e7 23 80 00       	push   $0x8023e7
  800316:	e8 91 12 00 00       	call   8015ac <_panic>

0080031b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031b:	f3 0f 1e fb          	endbr32 
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
	asm volatile("int %1\n"
  800325:	8b 55 08             	mov    0x8(%ebp),%edx
  800328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800330:	be 00 00 00 00       	mov    $0x0,%esi
  800335:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800338:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800342:	f3 0f 1e fb          	endbr32 
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	57                   	push   %edi
  80034a:	56                   	push   %esi
  80034b:	53                   	push   %ebx
  80034c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800354:	8b 55 08             	mov    0x8(%ebp),%edx
  800357:	b8 0d 00 00 00       	mov    $0xd,%eax
  80035c:	89 cb                	mov    %ecx,%ebx
  80035e:	89 cf                	mov    %ecx,%edi
  800360:	89 ce                	mov    %ecx,%esi
  800362:	cd 30                	int    $0x30
	if(check && ret > 0)
  800364:	85 c0                	test   %eax,%eax
  800366:	7f 08                	jg     800370 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800368:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036b:	5b                   	pop    %ebx
  80036c:	5e                   	pop    %esi
  80036d:	5f                   	pop    %edi
  80036e:	5d                   	pop    %ebp
  80036f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	6a 0d                	push   $0xd
  800376:	68 ca 23 80 00       	push   $0x8023ca
  80037b:	6a 23                	push   $0x23
  80037d:	68 e7 23 80 00       	push   $0x8023e7
  800382:	e8 25 12 00 00       	call   8015ac <_panic>

00800387 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
	asm volatile("int %1\n"
  800391:	ba 00 00 00 00       	mov    $0x0,%edx
  800396:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039b:	89 d1                	mov    %edx,%ecx
  80039d:	89 d3                	mov    %edx,%ebx
  80039f:	89 d7                	mov    %edx,%edi
  8003a1:	89 d6                	mov    %edx,%esi
  8003a3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003aa:	f3 0f 1e fb          	endbr32 
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b9:	c1 e8 0c             	shr    $0xc,%eax
}
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003be:	f3 0f 1e fb          	endbr32 
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    

008003d9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003d9:	f3 0f 1e fb          	endbr32 
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003e5:	89 c2                	mov    %eax,%edx
  8003e7:	c1 ea 16             	shr    $0x16,%edx
  8003ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003f1:	f6 c2 01             	test   $0x1,%dl
  8003f4:	74 2d                	je     800423 <fd_alloc+0x4a>
  8003f6:	89 c2                	mov    %eax,%edx
  8003f8:	c1 ea 0c             	shr    $0xc,%edx
  8003fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800402:	f6 c2 01             	test   $0x1,%dl
  800405:	74 1c                	je     800423 <fd_alloc+0x4a>
  800407:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80040c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800411:	75 d2                	jne    8003e5 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80041c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800421:	eb 0a                	jmp    80042d <fd_alloc+0x54>
			*fd_store = fd;
  800423:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800426:	89 01                	mov    %eax,(%ecx)
			return 0;
  800428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80042f:	f3 0f 1e fb          	endbr32 
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800439:	83 f8 1f             	cmp    $0x1f,%eax
  80043c:	77 30                	ja     80046e <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80043e:	c1 e0 0c             	shl    $0xc,%eax
  800441:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800446:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80044c:	f6 c2 01             	test   $0x1,%dl
  80044f:	74 24                	je     800475 <fd_lookup+0x46>
  800451:	89 c2                	mov    %eax,%edx
  800453:	c1 ea 0c             	shr    $0xc,%edx
  800456:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80045d:	f6 c2 01             	test   $0x1,%dl
  800460:	74 1a                	je     80047c <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800462:	8b 55 0c             	mov    0xc(%ebp),%edx
  800465:	89 02                	mov    %eax,(%edx)
	return 0;
  800467:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046c:	5d                   	pop    %ebp
  80046d:	c3                   	ret    
		return -E_INVAL;
  80046e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800473:	eb f7                	jmp    80046c <fd_lookup+0x3d>
		return -E_INVAL;
  800475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80047a:	eb f0                	jmp    80046c <fd_lookup+0x3d>
  80047c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800481:	eb e9                	jmp    80046c <fd_lookup+0x3d>

00800483 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800483:	f3 0f 1e fb          	endbr32 
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800490:	ba 00 00 00 00       	mov    $0x0,%edx
  800495:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80049a:	39 08                	cmp    %ecx,(%eax)
  80049c:	74 38                	je     8004d6 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80049e:	83 c2 01             	add    $0x1,%edx
  8004a1:	8b 04 95 74 24 80 00 	mov    0x802474(,%edx,4),%eax
  8004a8:	85 c0                	test   %eax,%eax
  8004aa:	75 ee                	jne    80049a <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8004b1:	8b 40 48             	mov    0x48(%eax),%eax
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	51                   	push   %ecx
  8004b8:	50                   	push   %eax
  8004b9:	68 f8 23 80 00       	push   $0x8023f8
  8004be:	e8 d0 11 00 00       	call   801693 <cprintf>
	*dev = 0;
  8004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    
			*dev = devtab[i];
  8004d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004db:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e0:	eb f2                	jmp    8004d4 <dev_lookup+0x51>

008004e2 <fd_close>:
{
  8004e2:	f3 0f 1e fb          	endbr32 
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	83 ec 24             	sub    $0x24,%esp
  8004ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004f8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004ff:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800502:	50                   	push   %eax
  800503:	e8 27 ff ff ff       	call   80042f <fd_lookup>
  800508:	89 c3                	mov    %eax,%ebx
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	85 c0                	test   %eax,%eax
  80050f:	78 05                	js     800516 <fd_close+0x34>
	    || fd != fd2)
  800511:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800514:	74 16                	je     80052c <fd_close+0x4a>
		return (must_exist ? r : 0);
  800516:	89 f8                	mov    %edi,%eax
  800518:	84 c0                	test   %al,%al
  80051a:	b8 00 00 00 00       	mov    $0x0,%eax
  80051f:	0f 44 d8             	cmove  %eax,%ebx
}
  800522:	89 d8                	mov    %ebx,%eax
  800524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800527:	5b                   	pop    %ebx
  800528:	5e                   	pop    %esi
  800529:	5f                   	pop    %edi
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80052c:	83 ec 08             	sub    $0x8,%esp
  80052f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800532:	50                   	push   %eax
  800533:	ff 36                	pushl  (%esi)
  800535:	e8 49 ff ff ff       	call   800483 <dev_lookup>
  80053a:	89 c3                	mov    %eax,%ebx
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 c0                	test   %eax,%eax
  800541:	78 1a                	js     80055d <fd_close+0x7b>
		if (dev->dev_close)
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800549:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80054e:	85 c0                	test   %eax,%eax
  800550:	74 0b                	je     80055d <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	56                   	push   %esi
  800556:	ff d0                	call   *%eax
  800558:	89 c3                	mov    %eax,%ebx
  80055a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	56                   	push   %esi
  800561:	6a 00                	push   $0x0
  800563:	e8 9b fc ff ff       	call   800203 <sys_page_unmap>
	return r;
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	eb b5                	jmp    800522 <fd_close+0x40>

0080056d <close>:

int
close(int fdnum)
{
  80056d:	f3 0f 1e fb          	endbr32 
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800577:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	ff 75 08             	pushl  0x8(%ebp)
  80057e:	e8 ac fe ff ff       	call   80042f <fd_lookup>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	85 c0                	test   %eax,%eax
  800588:	79 02                	jns    80058c <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80058a:	c9                   	leave  
  80058b:	c3                   	ret    
		return fd_close(fd, 1);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	6a 01                	push   $0x1
  800591:	ff 75 f4             	pushl  -0xc(%ebp)
  800594:	e8 49 ff ff ff       	call   8004e2 <fd_close>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb ec                	jmp    80058a <close+0x1d>

0080059e <close_all>:

void
close_all(void)
{
  80059e:	f3 0f 1e fb          	endbr32 
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	53                   	push   %ebx
  8005a6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005a9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005ae:	83 ec 0c             	sub    $0xc,%esp
  8005b1:	53                   	push   %ebx
  8005b2:	e8 b6 ff ff ff       	call   80056d <close>
	for (i = 0; i < MAXFD; i++)
  8005b7:	83 c3 01             	add    $0x1,%ebx
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 fb 20             	cmp    $0x20,%ebx
  8005c0:	75 ec                	jne    8005ae <close_all+0x10>
}
  8005c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005c7:	f3 0f 1e fb          	endbr32 
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	57                   	push   %edi
  8005cf:	56                   	push   %esi
  8005d0:	53                   	push   %ebx
  8005d1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	ff 75 08             	pushl  0x8(%ebp)
  8005db:	e8 4f fe ff ff       	call   80042f <fd_lookup>
  8005e0:	89 c3                	mov    %eax,%ebx
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	85 c0                	test   %eax,%eax
  8005e7:	0f 88 81 00 00 00    	js     80066e <dup+0xa7>
		return r;
	close(newfdnum);
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	e8 75 ff ff ff       	call   80056d <close>

	newfd = INDEX2FD(newfdnum);
  8005f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005fb:	c1 e6 0c             	shl    $0xc,%esi
  8005fe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800604:	83 c4 04             	add    $0x4,%esp
  800607:	ff 75 e4             	pushl  -0x1c(%ebp)
  80060a:	e8 af fd ff ff       	call   8003be <fd2data>
  80060f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800611:	89 34 24             	mov    %esi,(%esp)
  800614:	e8 a5 fd ff ff       	call   8003be <fd2data>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80061e:	89 d8                	mov    %ebx,%eax
  800620:	c1 e8 16             	shr    $0x16,%eax
  800623:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80062a:	a8 01                	test   $0x1,%al
  80062c:	74 11                	je     80063f <dup+0x78>
  80062e:	89 d8                	mov    %ebx,%eax
  800630:	c1 e8 0c             	shr    $0xc,%eax
  800633:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80063a:	f6 c2 01             	test   $0x1,%dl
  80063d:	75 39                	jne    800678 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80063f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800642:	89 d0                	mov    %edx,%eax
  800644:	c1 e8 0c             	shr    $0xc,%eax
  800647:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	25 07 0e 00 00       	and    $0xe07,%eax
  800656:	50                   	push   %eax
  800657:	56                   	push   %esi
  800658:	6a 00                	push   $0x0
  80065a:	52                   	push   %edx
  80065b:	6a 00                	push   $0x0
  80065d:	e8 5b fb ff ff       	call   8001bd <sys_page_map>
  800662:	89 c3                	mov    %eax,%ebx
  800664:	83 c4 20             	add    $0x20,%esp
  800667:	85 c0                	test   %eax,%eax
  800669:	78 31                	js     80069c <dup+0xd5>
		goto err;

	return newfdnum;
  80066b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80066e:	89 d8                	mov    %ebx,%eax
  800670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800673:	5b                   	pop    %ebx
  800674:	5e                   	pop    %esi
  800675:	5f                   	pop    %edi
  800676:	5d                   	pop    %ebp
  800677:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800678:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	25 07 0e 00 00       	and    $0xe07,%eax
  800687:	50                   	push   %eax
  800688:	57                   	push   %edi
  800689:	6a 00                	push   $0x0
  80068b:	53                   	push   %ebx
  80068c:	6a 00                	push   $0x0
  80068e:	e8 2a fb ff ff       	call   8001bd <sys_page_map>
  800693:	89 c3                	mov    %eax,%ebx
  800695:	83 c4 20             	add    $0x20,%esp
  800698:	85 c0                	test   %eax,%eax
  80069a:	79 a3                	jns    80063f <dup+0x78>
	sys_page_unmap(0, newfd);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	56                   	push   %esi
  8006a0:	6a 00                	push   $0x0
  8006a2:	e8 5c fb ff ff       	call   800203 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006a7:	83 c4 08             	add    $0x8,%esp
  8006aa:	57                   	push   %edi
  8006ab:	6a 00                	push   $0x0
  8006ad:	e8 51 fb ff ff       	call   800203 <sys_page_unmap>
	return r;
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	eb b7                	jmp    80066e <dup+0xa7>

008006b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006b7:	f3 0f 1e fb          	endbr32 
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	53                   	push   %ebx
  8006bf:	83 ec 1c             	sub    $0x1c,%esp
  8006c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006c8:	50                   	push   %eax
  8006c9:	53                   	push   %ebx
  8006ca:	e8 60 fd ff ff       	call   80042f <fd_lookup>
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	85 c0                	test   %eax,%eax
  8006d4:	78 3f                	js     800715 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006dc:	50                   	push   %eax
  8006dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e0:	ff 30                	pushl  (%eax)
  8006e2:	e8 9c fd ff ff       	call   800483 <dev_lookup>
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	78 27                	js     800715 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006f1:	8b 42 08             	mov    0x8(%edx),%eax
  8006f4:	83 e0 03             	and    $0x3,%eax
  8006f7:	83 f8 01             	cmp    $0x1,%eax
  8006fa:	74 1e                	je     80071a <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ff:	8b 40 08             	mov    0x8(%eax),%eax
  800702:	85 c0                	test   %eax,%eax
  800704:	74 35                	je     80073b <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800706:	83 ec 04             	sub    $0x4,%esp
  800709:	ff 75 10             	pushl  0x10(%ebp)
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	52                   	push   %edx
  800710:	ff d0                	call   *%eax
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800718:	c9                   	leave  
  800719:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80071a:	a1 08 40 80 00       	mov    0x804008,%eax
  80071f:	8b 40 48             	mov    0x48(%eax),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	53                   	push   %ebx
  800726:	50                   	push   %eax
  800727:	68 39 24 80 00       	push   $0x802439
  80072c:	e8 62 0f 00 00       	call   801693 <cprintf>
		return -E_INVAL;
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800739:	eb da                	jmp    800715 <read+0x5e>
		return -E_NOT_SUPP;
  80073b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800740:	eb d3                	jmp    800715 <read+0x5e>

00800742 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800742:	f3 0f 1e fb          	endbr32 
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	57                   	push   %edi
  80074a:	56                   	push   %esi
  80074b:	53                   	push   %ebx
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800752:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800755:	bb 00 00 00 00       	mov    $0x0,%ebx
  80075a:	eb 02                	jmp    80075e <readn+0x1c>
  80075c:	01 c3                	add    %eax,%ebx
  80075e:	39 f3                	cmp    %esi,%ebx
  800760:	73 21                	jae    800783 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800762:	83 ec 04             	sub    $0x4,%esp
  800765:	89 f0                	mov    %esi,%eax
  800767:	29 d8                	sub    %ebx,%eax
  800769:	50                   	push   %eax
  80076a:	89 d8                	mov    %ebx,%eax
  80076c:	03 45 0c             	add    0xc(%ebp),%eax
  80076f:	50                   	push   %eax
  800770:	57                   	push   %edi
  800771:	e8 41 ff ff ff       	call   8006b7 <read>
		if (m < 0)
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	85 c0                	test   %eax,%eax
  80077b:	78 04                	js     800781 <readn+0x3f>
			return m;
		if (m == 0)
  80077d:	75 dd                	jne    80075c <readn+0x1a>
  80077f:	eb 02                	jmp    800783 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800781:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800783:	89 d8                	mov    %ebx,%eax
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	53                   	push   %ebx
  800795:	83 ec 1c             	sub    $0x1c,%esp
  800798:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80079b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80079e:	50                   	push   %eax
  80079f:	53                   	push   %ebx
  8007a0:	e8 8a fc ff ff       	call   80042f <fd_lookup>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	85 c0                	test   %eax,%eax
  8007aa:	78 3a                	js     8007e6 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	ff 30                	pushl  (%eax)
  8007b8:	e8 c6 fc ff ff       	call   800483 <dev_lookup>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	78 22                	js     8007e6 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007cb:	74 1e                	je     8007eb <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d0:	8b 52 0c             	mov    0xc(%edx),%edx
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	74 35                	je     80080c <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007d7:	83 ec 04             	sub    $0x4,%esp
  8007da:	ff 75 10             	pushl  0x10(%ebp)
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	50                   	push   %eax
  8007e1:	ff d2                	call   *%edx
  8007e3:	83 c4 10             	add    $0x10,%esp
}
  8007e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8007f0:	8b 40 48             	mov    0x48(%eax),%eax
  8007f3:	83 ec 04             	sub    $0x4,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	50                   	push   %eax
  8007f8:	68 55 24 80 00       	push   $0x802455
  8007fd:	e8 91 0e 00 00       	call   801693 <cprintf>
		return -E_INVAL;
  800802:	83 c4 10             	add    $0x10,%esp
  800805:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080a:	eb da                	jmp    8007e6 <write+0x59>
		return -E_NOT_SUPP;
  80080c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800811:	eb d3                	jmp    8007e6 <write+0x59>

00800813 <seek>:

int
seek(int fdnum, off_t offset)
{
  800813:	f3 0f 1e fb          	endbr32 
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80081d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	ff 75 08             	pushl  0x8(%ebp)
  800824:	e8 06 fc ff ff       	call   80042f <fd_lookup>
  800829:	83 c4 10             	add    $0x10,%esp
  80082c:	85 c0                	test   %eax,%eax
  80082e:	78 0e                	js     80083e <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800830:	8b 55 0c             	mov    0xc(%ebp),%edx
  800833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800836:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	83 ec 1c             	sub    $0x1c,%esp
  80084b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	53                   	push   %ebx
  800853:	e8 d7 fb ff ff       	call   80042f <fd_lookup>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	85 c0                	test   %eax,%eax
  80085d:	78 37                	js     800896 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800869:	ff 30                	pushl  (%eax)
  80086b:	e8 13 fc ff ff       	call   800483 <dev_lookup>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	85 c0                	test   %eax,%eax
  800875:	78 1f                	js     800896 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80087e:	74 1b                	je     80089b <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800883:	8b 52 18             	mov    0x18(%edx),%edx
  800886:	85 d2                	test   %edx,%edx
  800888:	74 32                	je     8008bc <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	50                   	push   %eax
  800891:	ff d2                	call   *%edx
  800893:	83 c4 10             	add    $0x10,%esp
}
  800896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800899:	c9                   	leave  
  80089a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80089b:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008a0:	8b 40 48             	mov    0x48(%eax),%eax
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	50                   	push   %eax
  8008a8:	68 18 24 80 00       	push   $0x802418
  8008ad:	e8 e1 0d 00 00       	call   801693 <cprintf>
		return -E_INVAL;
  8008b2:	83 c4 10             	add    $0x10,%esp
  8008b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ba:	eb da                	jmp    800896 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c1:	eb d3                	jmp    800896 <ftruncate+0x56>

008008c3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008c3:	f3 0f 1e fb          	endbr32 
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	83 ec 1c             	sub    $0x1c,%esp
  8008ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d4:	50                   	push   %eax
  8008d5:	ff 75 08             	pushl  0x8(%ebp)
  8008d8:	e8 52 fb ff ff       	call   80042f <fd_lookup>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	85 c0                	test   %eax,%eax
  8008e2:	78 4b                	js     80092f <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ee:	ff 30                	pushl  (%eax)
  8008f0:	e8 8e fb ff ff       	call   800483 <dev_lookup>
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	78 33                	js     80092f <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ff:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800903:	74 2f                	je     800934 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800905:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800908:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80090f:	00 00 00 
	stat->st_isdir = 0;
  800912:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800919:	00 00 00 
	stat->st_dev = dev;
  80091c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	53                   	push   %ebx
  800926:	ff 75 f0             	pushl  -0x10(%ebp)
  800929:	ff 50 14             	call   *0x14(%eax)
  80092c:	83 c4 10             	add    $0x10,%esp
}
  80092f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800932:	c9                   	leave  
  800933:	c3                   	ret    
		return -E_NOT_SUPP;
  800934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800939:	eb f4                	jmp    80092f <fstat+0x6c>

0080093b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	6a 00                	push   $0x0
  800949:	ff 75 08             	pushl  0x8(%ebp)
  80094c:	e8 fb 01 00 00       	call   800b4c <open>
  800951:	89 c3                	mov    %eax,%ebx
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	85 c0                	test   %eax,%eax
  800958:	78 1b                	js     800975 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	50                   	push   %eax
  800961:	e8 5d ff ff ff       	call   8008c3 <fstat>
  800966:	89 c6                	mov    %eax,%esi
	close(fd);
  800968:	89 1c 24             	mov    %ebx,(%esp)
  80096b:	e8 fd fb ff ff       	call   80056d <close>
	return r;
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	89 f3                	mov    %esi,%ebx
}
  800975:	89 d8                	mov    %ebx,%eax
  800977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097a:	5b                   	pop    %ebx
  80097b:	5e                   	pop    %esi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	89 c6                	mov    %eax,%esi
  800985:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800987:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80098e:	74 27                	je     8009b7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800990:	6a 07                	push   $0x7
  800992:	68 00 50 80 00       	push   $0x805000
  800997:	56                   	push   %esi
  800998:	ff 35 00 40 80 00    	pushl  0x804000
  80099e:	e8 e0 16 00 00       	call   802083 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a3:	83 c4 0c             	add    $0xc,%esp
  8009a6:	6a 00                	push   $0x0
  8009a8:	53                   	push   %ebx
  8009a9:	6a 00                	push   $0x0
  8009ab:	e8 5f 16 00 00       	call   80200f <ipc_recv>
}
  8009b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b3:	5b                   	pop    %ebx
  8009b4:	5e                   	pop    %esi
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009b7:	83 ec 0c             	sub    $0xc,%esp
  8009ba:	6a 01                	push   $0x1
  8009bc:	e8 1a 17 00 00       	call   8020db <ipc_find_env>
  8009c1:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	eb c5                	jmp    800990 <fsipc+0x12>

008009cb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8009db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f2:	e8 87 ff ff ff       	call   80097e <fsipc>
}
  8009f7:	c9                   	leave  
  8009f8:	c3                   	ret    

008009f9 <devfile_flush>:
{
  8009f9:	f3 0f 1e fb          	endbr32 
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 40 0c             	mov    0xc(%eax),%eax
  800a09:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a13:	b8 06 00 00 00       	mov    $0x6,%eax
  800a18:	e8 61 ff ff ff       	call   80097e <fsipc>
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <devfile_stat>:
{
  800a1f:	f3 0f 1e fb          	endbr32 
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	53                   	push   %ebx
  800a27:	83 ec 04             	sub    $0x4,%esp
  800a2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 40 0c             	mov    0xc(%eax),%eax
  800a33:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a38:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800a42:	e8 37 ff ff ff       	call   80097e <fsipc>
  800a47:	85 c0                	test   %eax,%eax
  800a49:	78 2c                	js     800a77 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	68 00 50 80 00       	push   $0x805000
  800a53:	53                   	push   %ebx
  800a54:	e8 44 12 00 00       	call   801c9d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a59:	a1 80 50 80 00       	mov    0x805080,%eax
  800a5e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a64:	a1 84 50 80 00       	mov    0x805084,%eax
  800a69:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a6f:	83 c4 10             	add    $0x10,%esp
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <devfile_write>:
{
  800a7c:	f3 0f 1e fb          	endbr32 
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a89:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8c:	8b 52 0c             	mov    0xc(%edx),%edx
  800a8f:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800a95:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a9a:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a9f:	0f 47 c2             	cmova  %edx,%eax
  800aa2:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800aa7:	50                   	push   %eax
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	68 08 50 80 00       	push   $0x805008
  800ab0:	e8 9e 13 00 00       	call   801e53 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	b8 04 00 00 00       	mov    $0x4,%eax
  800abf:	e8 ba fe ff ff       	call   80097e <fsipc>
}
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <devfile_read>:
{
  800ac6:	f3 0f 1e fb          	endbr32 
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	56                   	push   %esi
  800ace:	53                   	push   %ebx
  800acf:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800add:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	b8 03 00 00 00       	mov    $0x3,%eax
  800aed:	e8 8c fe ff ff       	call   80097e <fsipc>
  800af2:	89 c3                	mov    %eax,%ebx
  800af4:	85 c0                	test   %eax,%eax
  800af6:	78 1f                	js     800b17 <devfile_read+0x51>
	assert(r <= n);
  800af8:	39 f0                	cmp    %esi,%eax
  800afa:	77 24                	ja     800b20 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800afc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b01:	7f 33                	jg     800b36 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b03:	83 ec 04             	sub    $0x4,%esp
  800b06:	50                   	push   %eax
  800b07:	68 00 50 80 00       	push   $0x805000
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	e8 3f 13 00 00       	call   801e53 <memmove>
	return r;
  800b14:	83 c4 10             	add    $0x10,%esp
}
  800b17:	89 d8                	mov    %ebx,%eax
  800b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b1c:	5b                   	pop    %ebx
  800b1d:	5e                   	pop    %esi
  800b1e:	5d                   	pop    %ebp
  800b1f:	c3                   	ret    
	assert(r <= n);
  800b20:	68 88 24 80 00       	push   $0x802488
  800b25:	68 8f 24 80 00       	push   $0x80248f
  800b2a:	6a 7c                	push   $0x7c
  800b2c:	68 a4 24 80 00       	push   $0x8024a4
  800b31:	e8 76 0a 00 00       	call   8015ac <_panic>
	assert(r <= PGSIZE);
  800b36:	68 af 24 80 00       	push   $0x8024af
  800b3b:	68 8f 24 80 00       	push   $0x80248f
  800b40:	6a 7d                	push   $0x7d
  800b42:	68 a4 24 80 00       	push   $0x8024a4
  800b47:	e8 60 0a 00 00       	call   8015ac <_panic>

00800b4c <open>:
{
  800b4c:	f3 0f 1e fb          	endbr32 
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 1c             	sub    $0x1c,%esp
  800b58:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b5b:	56                   	push   %esi
  800b5c:	e8 f9 10 00 00       	call   801c5a <strlen>
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b69:	7f 6c                	jg     800bd7 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b6b:	83 ec 0c             	sub    $0xc,%esp
  800b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	e8 62 f8 ff ff       	call   8003d9 <fd_alloc>
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	83 c4 10             	add    $0x10,%esp
  800b7c:	85 c0                	test   %eax,%eax
  800b7e:	78 3c                	js     800bbc <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	56                   	push   %esi
  800b84:	68 00 50 80 00       	push   $0x805000
  800b89:	e8 0f 11 00 00       	call   801c9d <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b99:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9e:	e8 db fd ff ff       	call   80097e <fsipc>
  800ba3:	89 c3                	mov    %eax,%ebx
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	85 c0                	test   %eax,%eax
  800baa:	78 19                	js     800bc5 <open+0x79>
	return fd2num(fd);
  800bac:	83 ec 0c             	sub    $0xc,%esp
  800baf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb2:	e8 f3 f7 ff ff       	call   8003aa <fd2num>
  800bb7:	89 c3                	mov    %eax,%ebx
  800bb9:	83 c4 10             	add    $0x10,%esp
}
  800bbc:	89 d8                	mov    %ebx,%eax
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    
		fd_close(fd, 0);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	6a 00                	push   $0x0
  800bca:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcd:	e8 10 f9 ff ff       	call   8004e2 <fd_close>
		return r;
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	eb e5                	jmp    800bbc <open+0x70>
		return -E_BAD_PATH;
  800bd7:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bdc:	eb de                	jmp    800bbc <open+0x70>

00800bde <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bde:	f3 0f 1e fb          	endbr32 
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800be8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bed:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf2:	e8 87 fd ff ff       	call   80097e <fsipc>
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800bf9:	f3 0f 1e fb          	endbr32 
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c03:	68 bb 24 80 00       	push   $0x8024bb
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	e8 8d 10 00 00       	call   801c9d <strcpy>
	return 0;
}
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <devsock_close>:
{
  800c17:	f3 0f 1e fb          	endbr32 
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 10             	sub    $0x10,%esp
  800c22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c25:	53                   	push   %ebx
  800c26:	e8 ed 14 00 00       	call   802118 <pageref>
  800c2b:	89 c2                	mov    %eax,%edx
  800c2d:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c35:	83 fa 01             	cmp    $0x1,%edx
  800c38:	74 05                	je     800c3f <devsock_close+0x28>
}
  800c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c3f:	83 ec 0c             	sub    $0xc,%esp
  800c42:	ff 73 0c             	pushl  0xc(%ebx)
  800c45:	e8 e3 02 00 00       	call   800f2d <nsipc_close>
  800c4a:	83 c4 10             	add    $0x10,%esp
  800c4d:	eb eb                	jmp    800c3a <devsock_close+0x23>

00800c4f <devsock_write>:
{
  800c4f:	f3 0f 1e fb          	endbr32 
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c59:	6a 00                	push   $0x0
  800c5b:	ff 75 10             	pushl  0x10(%ebp)
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff 70 0c             	pushl  0xc(%eax)
  800c67:	e8 b5 03 00 00       	call   801021 <nsipc_send>
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <devsock_read>:
{
  800c6e:	f3 0f 1e fb          	endbr32 
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c78:	6a 00                	push   $0x0
  800c7a:	ff 75 10             	pushl  0x10(%ebp)
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	ff 70 0c             	pushl  0xc(%eax)
  800c86:	e8 1f 03 00 00       	call   800faa <nsipc_recv>
}
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <fd2sockid>:
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c93:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c96:	52                   	push   %edx
  800c97:	50                   	push   %eax
  800c98:	e8 92 f7 ff ff       	call   80042f <fd_lookup>
  800c9d:	83 c4 10             	add    $0x10,%esp
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	78 10                	js     800cb4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800cad:	39 08                	cmp    %ecx,(%eax)
  800caf:	75 05                	jne    800cb6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cb1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cb4:	c9                   	leave  
  800cb5:	c3                   	ret    
		return -E_NOT_SUPP;
  800cb6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cbb:	eb f7                	jmp    800cb4 <fd2sockid+0x27>

00800cbd <alloc_sockfd>:
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	83 ec 1c             	sub    $0x1c,%esp
  800cc5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cca:	50                   	push   %eax
  800ccb:	e8 09 f7 ff ff       	call   8003d9 <fd_alloc>
  800cd0:	89 c3                	mov    %eax,%ebx
  800cd2:	83 c4 10             	add    $0x10,%esp
  800cd5:	85 c0                	test   %eax,%eax
  800cd7:	78 43                	js     800d1c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800cd9:	83 ec 04             	sub    $0x4,%esp
  800cdc:	68 07 04 00 00       	push   $0x407
  800ce1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce4:	6a 00                	push   $0x0
  800ce6:	e8 8b f4 ff ff       	call   800176 <sys_page_alloc>
  800ceb:	89 c3                	mov    %eax,%ebx
  800ced:	83 c4 10             	add    $0x10,%esp
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	78 28                	js     800d1c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800cfd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d02:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d09:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	e8 95 f6 ff ff       	call   8003aa <fd2num>
  800d15:	89 c3                	mov    %eax,%ebx
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	eb 0c                	jmp    800d28 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	56                   	push   %esi
  800d20:	e8 08 02 00 00       	call   800f2d <nsipc_close>
		return r;
  800d25:	83 c4 10             	add    $0x10,%esp
}
  800d28:	89 d8                	mov    %ebx,%eax
  800d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <accept>:
{
  800d31:	f3 0f 1e fb          	endbr32 
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	e8 4a ff ff ff       	call   800c8d <fd2sockid>
  800d43:	85 c0                	test   %eax,%eax
  800d45:	78 1b                	js     800d62 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d47:	83 ec 04             	sub    $0x4,%esp
  800d4a:	ff 75 10             	pushl  0x10(%ebp)
  800d4d:	ff 75 0c             	pushl  0xc(%ebp)
  800d50:	50                   	push   %eax
  800d51:	e8 22 01 00 00       	call   800e78 <nsipc_accept>
  800d56:	83 c4 10             	add    $0x10,%esp
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	78 05                	js     800d62 <accept+0x31>
	return alloc_sockfd(r);
  800d5d:	e8 5b ff ff ff       	call   800cbd <alloc_sockfd>
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <bind>:
{
  800d64:	f3 0f 1e fb          	endbr32 
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	e8 17 ff ff ff       	call   800c8d <fd2sockid>
  800d76:	85 c0                	test   %eax,%eax
  800d78:	78 12                	js     800d8c <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	ff 75 10             	pushl  0x10(%ebp)
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	50                   	push   %eax
  800d84:	e8 45 01 00 00       	call   800ece <nsipc_bind>
  800d89:	83 c4 10             	add    $0x10,%esp
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    

00800d8e <shutdown>:
{
  800d8e:	f3 0f 1e fb          	endbr32 
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	e8 ed fe ff ff       	call   800c8d <fd2sockid>
  800da0:	85 c0                	test   %eax,%eax
  800da2:	78 0f                	js     800db3 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800da4:	83 ec 08             	sub    $0x8,%esp
  800da7:	ff 75 0c             	pushl  0xc(%ebp)
  800daa:	50                   	push   %eax
  800dab:	e8 57 01 00 00       	call   800f07 <nsipc_shutdown>
  800db0:	83 c4 10             	add    $0x10,%esp
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <connect>:
{
  800db5:	f3 0f 1e fb          	endbr32 
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	e8 c6 fe ff ff       	call   800c8d <fd2sockid>
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	78 12                	js     800ddd <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	ff 75 10             	pushl  0x10(%ebp)
  800dd1:	ff 75 0c             	pushl  0xc(%ebp)
  800dd4:	50                   	push   %eax
  800dd5:	e8 71 01 00 00       	call   800f4b <nsipc_connect>
  800dda:	83 c4 10             	add    $0x10,%esp
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <listen>:
{
  800ddf:	f3 0f 1e fb          	endbr32 
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	e8 9c fe ff ff       	call   800c8d <fd2sockid>
  800df1:	85 c0                	test   %eax,%eax
  800df3:	78 0f                	js     800e04 <listen+0x25>
	return nsipc_listen(r, backlog);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 0c             	pushl  0xc(%ebp)
  800dfb:	50                   	push   %eax
  800dfc:	e8 83 01 00 00       	call   800f84 <nsipc_listen>
  800e01:	83 c4 10             	add    $0x10,%esp
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e06:	f3 0f 1e fb          	endbr32 
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e10:	ff 75 10             	pushl  0x10(%ebp)
  800e13:	ff 75 0c             	pushl  0xc(%ebp)
  800e16:	ff 75 08             	pushl  0x8(%ebp)
  800e19:	e8 65 02 00 00       	call   801083 <nsipc_socket>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	85 c0                	test   %eax,%eax
  800e23:	78 05                	js     800e2a <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e25:	e8 93 fe ff ff       	call   800cbd <alloc_sockfd>
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e35:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e3c:	74 26                	je     800e64 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e3e:	6a 07                	push   $0x7
  800e40:	68 00 60 80 00       	push   $0x806000
  800e45:	53                   	push   %ebx
  800e46:	ff 35 04 40 80 00    	pushl  0x804004
  800e4c:	e8 32 12 00 00       	call   802083 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e51:	83 c4 0c             	add    $0xc,%esp
  800e54:	6a 00                	push   $0x0
  800e56:	6a 00                	push   $0x0
  800e58:	6a 00                	push   $0x0
  800e5a:	e8 b0 11 00 00       	call   80200f <ipc_recv>
}
  800e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	6a 02                	push   $0x2
  800e69:	e8 6d 12 00 00       	call   8020db <ipc_find_env>
  800e6e:	a3 04 40 80 00       	mov    %eax,0x804004
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	eb c6                	jmp    800e3e <nsipc+0x12>

00800e78 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e78:	f3 0f 1e fb          	endbr32 
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e8c:	8b 06                	mov    (%esi),%eax
  800e8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800e93:	b8 01 00 00 00       	mov    $0x1,%eax
  800e98:	e8 8f ff ff ff       	call   800e2c <nsipc>
  800e9d:	89 c3                	mov    %eax,%ebx
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	79 09                	jns    800eac <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800ea3:	89 d8                	mov    %ebx,%eax
  800ea5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800eac:	83 ec 04             	sub    $0x4,%esp
  800eaf:	ff 35 10 60 80 00    	pushl  0x806010
  800eb5:	68 00 60 80 00       	push   $0x806000
  800eba:	ff 75 0c             	pushl  0xc(%ebp)
  800ebd:	e8 91 0f 00 00       	call   801e53 <memmove>
		*addrlen = ret->ret_addrlen;
  800ec2:	a1 10 60 80 00       	mov    0x806010,%eax
  800ec7:	89 06                	mov    %eax,(%esi)
  800ec9:	83 c4 10             	add    $0x10,%esp
	return r;
  800ecc:	eb d5                	jmp    800ea3 <nsipc_accept+0x2b>

00800ece <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ee4:	53                   	push   %ebx
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	68 04 60 80 00       	push   $0x806004
  800eed:	e8 61 0f 00 00       	call   801e53 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800ef2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800ef8:	b8 02 00 00 00       	mov    $0x2,%eax
  800efd:	e8 2a ff ff ff       	call   800e2c <nsipc>
}
  800f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f07:	f3 0f 1e fb          	endbr32 
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f21:	b8 03 00 00 00       	mov    $0x3,%eax
  800f26:	e8 01 ff ff ff       	call   800e2c <nsipc>
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <nsipc_close>:

int
nsipc_close(int s)
{
  800f2d:	f3 0f 1e fb          	endbr32 
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f3f:	b8 04 00 00 00       	mov    $0x4,%eax
  800f44:	e8 e3 fe ff ff       	call   800e2c <nsipc>
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f4b:	f3 0f 1e fb          	endbr32 
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	53                   	push   %ebx
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f61:	53                   	push   %ebx
  800f62:	ff 75 0c             	pushl  0xc(%ebp)
  800f65:	68 04 60 80 00       	push   $0x806004
  800f6a:	e8 e4 0e 00 00       	call   801e53 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f6f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f75:	b8 05 00 00 00       	mov    $0x5,%eax
  800f7a:	e8 ad fe ff ff       	call   800e2c <nsipc>
}
  800f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f84:	f3 0f 1e fb          	endbr32 
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800f9e:	b8 06 00 00 00       	mov    $0x6,%eax
  800fa3:	e8 84 fe ff ff       	call   800e2c <nsipc>
}
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800faa:	f3 0f 1e fb          	endbr32 
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fbe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fcc:	b8 07 00 00 00       	mov    $0x7,%eax
  800fd1:	e8 56 fe ff ff       	call   800e2c <nsipc>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	78 26                	js     801002 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fdc:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800fe2:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800fe7:	0f 4e c6             	cmovle %esi,%eax
  800fea:	39 c3                	cmp    %eax,%ebx
  800fec:	7f 1d                	jg     80100b <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	53                   	push   %ebx
  800ff2:	68 00 60 80 00       	push   $0x806000
  800ff7:	ff 75 0c             	pushl  0xc(%ebp)
  800ffa:	e8 54 0e 00 00       	call   801e53 <memmove>
  800fff:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801002:	89 d8                	mov    %ebx,%eax
  801004:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80100b:	68 c7 24 80 00       	push   $0x8024c7
  801010:	68 8f 24 80 00       	push   $0x80248f
  801015:	6a 62                	push   $0x62
  801017:	68 dc 24 80 00       	push   $0x8024dc
  80101c:	e8 8b 05 00 00       	call   8015ac <_panic>

00801021 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801021:	f3 0f 1e fb          	endbr32 
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	53                   	push   %ebx
  801029:	83 ec 04             	sub    $0x4,%esp
  80102c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801037:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80103d:	7f 2e                	jg     80106d <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	53                   	push   %ebx
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	68 0c 60 80 00       	push   $0x80600c
  80104b:	e8 03 0e 00 00       	call   801e53 <memmove>
	nsipcbuf.send.req_size = size;
  801050:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801056:	8b 45 14             	mov    0x14(%ebp),%eax
  801059:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80105e:	b8 08 00 00 00       	mov    $0x8,%eax
  801063:	e8 c4 fd ff ff       	call   800e2c <nsipc>
}
  801068:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    
	assert(size < 1600);
  80106d:	68 e8 24 80 00       	push   $0x8024e8
  801072:	68 8f 24 80 00       	push   $0x80248f
  801077:	6a 6d                	push   $0x6d
  801079:	68 dc 24 80 00       	push   $0x8024dc
  80107e:	e8 29 05 00 00       	call   8015ac <_panic>

00801083 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801083:	f3 0f 1e fb          	endbr32 
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010a5:	b8 09 00 00 00       	mov    $0x9,%eax
  8010aa:	e8 7d fd ff ff       	call   800e2c <nsipc>
}
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    

008010b1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010b1:	f3 0f 1e fb          	endbr32 
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	56                   	push   %esi
  8010b9:	53                   	push   %ebx
  8010ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010bd:	83 ec 0c             	sub    $0xc,%esp
  8010c0:	ff 75 08             	pushl  0x8(%ebp)
  8010c3:	e8 f6 f2 ff ff       	call   8003be <fd2data>
  8010c8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010ca:	83 c4 08             	add    $0x8,%esp
  8010cd:	68 f4 24 80 00       	push   $0x8024f4
  8010d2:	53                   	push   %ebx
  8010d3:	e8 c5 0b 00 00       	call   801c9d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010d8:	8b 46 04             	mov    0x4(%esi),%eax
  8010db:	2b 06                	sub    (%esi),%eax
  8010dd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010ea:	00 00 00 
	stat->st_dev = &devpipe;
  8010ed:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8010f4:	30 80 00 
	return 0;
}
  8010f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ff:	5b                   	pop    %ebx
  801100:	5e                   	pop    %esi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801103:	f3 0f 1e fb          	endbr32 
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	53                   	push   %ebx
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801111:	53                   	push   %ebx
  801112:	6a 00                	push   $0x0
  801114:	e8 ea f0 ff ff       	call   800203 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801119:	89 1c 24             	mov    %ebx,(%esp)
  80111c:	e8 9d f2 ff ff       	call   8003be <fd2data>
  801121:	83 c4 08             	add    $0x8,%esp
  801124:	50                   	push   %eax
  801125:	6a 00                	push   $0x0
  801127:	e8 d7 f0 ff ff       	call   800203 <sys_page_unmap>
}
  80112c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112f:	c9                   	leave  
  801130:	c3                   	ret    

00801131 <_pipeisclosed>:
{
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	57                   	push   %edi
  801135:	56                   	push   %esi
  801136:	53                   	push   %ebx
  801137:	83 ec 1c             	sub    $0x1c,%esp
  80113a:	89 c7                	mov    %eax,%edi
  80113c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80113e:	a1 08 40 80 00       	mov    0x804008,%eax
  801143:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	57                   	push   %edi
  80114a:	e8 c9 0f 00 00       	call   802118 <pageref>
  80114f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801152:	89 34 24             	mov    %esi,(%esp)
  801155:	e8 be 0f 00 00       	call   802118 <pageref>
		nn = thisenv->env_runs;
  80115a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801160:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	39 cb                	cmp    %ecx,%ebx
  801168:	74 1b                	je     801185 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80116a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80116d:	75 cf                	jne    80113e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80116f:	8b 42 58             	mov    0x58(%edx),%eax
  801172:	6a 01                	push   $0x1
  801174:	50                   	push   %eax
  801175:	53                   	push   %ebx
  801176:	68 fb 24 80 00       	push   $0x8024fb
  80117b:	e8 13 05 00 00       	call   801693 <cprintf>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	eb b9                	jmp    80113e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801185:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801188:	0f 94 c0             	sete   %al
  80118b:	0f b6 c0             	movzbl %al,%eax
}
  80118e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <devpipe_write>:
{
  801196:	f3 0f 1e fb          	endbr32 
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 28             	sub    $0x28,%esp
  8011a3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011a6:	56                   	push   %esi
  8011a7:	e8 12 f2 ff ff       	call   8003be <fd2data>
  8011ac:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011b9:	74 4f                	je     80120a <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8011be:	8b 0b                	mov    (%ebx),%ecx
  8011c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8011c3:	39 d0                	cmp    %edx,%eax
  8011c5:	72 14                	jb     8011db <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011c7:	89 da                	mov    %ebx,%edx
  8011c9:	89 f0                	mov    %esi,%eax
  8011cb:	e8 61 ff ff ff       	call   801131 <_pipeisclosed>
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	75 3b                	jne    80120f <devpipe_write+0x79>
			sys_yield();
  8011d4:	e8 7a ef ff ff       	call   800153 <sys_yield>
  8011d9:	eb e0                	jmp    8011bb <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011de:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011e2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	c1 fa 1f             	sar    $0x1f,%edx
  8011ea:	89 d1                	mov    %edx,%ecx
  8011ec:	c1 e9 1b             	shr    $0x1b,%ecx
  8011ef:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8011f2:	83 e2 1f             	and    $0x1f,%edx
  8011f5:	29 ca                	sub    %ecx,%edx
  8011f7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8011fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8011ff:	83 c0 01             	add    $0x1,%eax
  801202:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801205:	83 c7 01             	add    $0x1,%edi
  801208:	eb ac                	jmp    8011b6 <devpipe_write+0x20>
	return i;
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	eb 05                	jmp    801214 <devpipe_write+0x7e>
				return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <devpipe_read>:
{
  80121c:	f3 0f 1e fb          	endbr32 
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 18             	sub    $0x18,%esp
  801229:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80122c:	57                   	push   %edi
  80122d:	e8 8c f1 ff ff       	call   8003be <fd2data>
  801232:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	be 00 00 00 00       	mov    $0x0,%esi
  80123c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80123f:	75 14                	jne    801255 <devpipe_read+0x39>
	return i;
  801241:	8b 45 10             	mov    0x10(%ebp),%eax
  801244:	eb 02                	jmp    801248 <devpipe_read+0x2c>
				return i;
  801246:	89 f0                	mov    %esi,%eax
}
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
			sys_yield();
  801250:	e8 fe ee ff ff       	call   800153 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801255:	8b 03                	mov    (%ebx),%eax
  801257:	3b 43 04             	cmp    0x4(%ebx),%eax
  80125a:	75 18                	jne    801274 <devpipe_read+0x58>
			if (i > 0)
  80125c:	85 f6                	test   %esi,%esi
  80125e:	75 e6                	jne    801246 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801260:	89 da                	mov    %ebx,%edx
  801262:	89 f8                	mov    %edi,%eax
  801264:	e8 c8 fe ff ff       	call   801131 <_pipeisclosed>
  801269:	85 c0                	test   %eax,%eax
  80126b:	74 e3                	je     801250 <devpipe_read+0x34>
				return 0;
  80126d:	b8 00 00 00 00       	mov    $0x0,%eax
  801272:	eb d4                	jmp    801248 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801274:	99                   	cltd   
  801275:	c1 ea 1b             	shr    $0x1b,%edx
  801278:	01 d0                	add    %edx,%eax
  80127a:	83 e0 1f             	and    $0x1f,%eax
  80127d:	29 d0                	sub    %edx,%eax
  80127f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801284:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801287:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80128a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80128d:	83 c6 01             	add    $0x1,%esi
  801290:	eb aa                	jmp    80123c <devpipe_read+0x20>

00801292 <pipe>:
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	56                   	push   %esi
  80129a:	53                   	push   %ebx
  80129b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80129e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a1:	50                   	push   %eax
  8012a2:	e8 32 f1 ff ff       	call   8003d9 <fd_alloc>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	0f 88 23 01 00 00    	js     8013d7 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 07 04 00 00       	push   $0x407
  8012bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 b0 ee ff ff       	call   800176 <sys_page_alloc>
  8012c6:	89 c3                	mov    %eax,%ebx
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	0f 88 04 01 00 00    	js     8013d7 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	e8 fa f0 ff ff       	call   8003d9 <fd_alloc>
  8012df:	89 c3                	mov    %eax,%ebx
  8012e1:	83 c4 10             	add    $0x10,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	0f 88 db 00 00 00    	js     8013c7 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 07 04 00 00       	push   $0x407
  8012f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 78 ee ff ff       	call   800176 <sys_page_alloc>
  8012fe:	89 c3                	mov    %eax,%ebx
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	0f 88 bc 00 00 00    	js     8013c7 <pipe+0x135>
	va = fd2data(fd0);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	ff 75 f4             	pushl  -0xc(%ebp)
  801311:	e8 a8 f0 ff ff       	call   8003be <fd2data>
  801316:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801318:	83 c4 0c             	add    $0xc,%esp
  80131b:	68 07 04 00 00       	push   $0x407
  801320:	50                   	push   %eax
  801321:	6a 00                	push   $0x0
  801323:	e8 4e ee ff ff       	call   800176 <sys_page_alloc>
  801328:	89 c3                	mov    %eax,%ebx
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	0f 88 82 00 00 00    	js     8013b7 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	ff 75 f0             	pushl  -0x10(%ebp)
  80133b:	e8 7e f0 ff ff       	call   8003be <fd2data>
  801340:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801347:	50                   	push   %eax
  801348:	6a 00                	push   $0x0
  80134a:	56                   	push   %esi
  80134b:	6a 00                	push   $0x0
  80134d:	e8 6b ee ff ff       	call   8001bd <sys_page_map>
  801352:	89 c3                	mov    %eax,%ebx
  801354:	83 c4 20             	add    $0x20,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 4e                	js     8013a9 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80135b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801368:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80136f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801372:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801377:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 f4             	pushl  -0xc(%ebp)
  801384:	e8 21 f0 ff ff       	call   8003aa <fd2num>
  801389:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80138e:	83 c4 04             	add    $0x4,%esp
  801391:	ff 75 f0             	pushl  -0x10(%ebp)
  801394:	e8 11 f0 ff ff       	call   8003aa <fd2num>
  801399:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a7:	eb 2e                	jmp    8013d7 <pipe+0x145>
	sys_page_unmap(0, va);
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	56                   	push   %esi
  8013ad:	6a 00                	push   $0x0
  8013af:	e8 4f ee ff ff       	call   800203 <sys_page_unmap>
  8013b4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013b7:	83 ec 08             	sub    $0x8,%esp
  8013ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8013bd:	6a 00                	push   $0x0
  8013bf:	e8 3f ee ff ff       	call   800203 <sys_page_unmap>
  8013c4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013c7:	83 ec 08             	sub    $0x8,%esp
  8013ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8013cd:	6a 00                	push   $0x0
  8013cf:	e8 2f ee ff ff       	call   800203 <sys_page_unmap>
  8013d4:	83 c4 10             	add    $0x10,%esp
}
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <pipeisclosed>:
{
  8013e0:	f3 0f 1e fb          	endbr32 
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ed:	50                   	push   %eax
  8013ee:	ff 75 08             	pushl  0x8(%ebp)
  8013f1:	e8 39 f0 ff ff       	call   80042f <fd_lookup>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 18                	js     801415 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	ff 75 f4             	pushl  -0xc(%ebp)
  801403:	e8 b6 ef ff ff       	call   8003be <fd2data>
  801408:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80140a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140d:	e8 1f fd ff ff       	call   801131 <_pipeisclosed>
  801412:	83 c4 10             	add    $0x10,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801417:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80141b:	b8 00 00 00 00       	mov    $0x0,%eax
  801420:	c3                   	ret    

00801421 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801421:	f3 0f 1e fb          	endbr32 
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80142b:	68 13 25 80 00       	push   $0x802513
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	e8 65 08 00 00       	call   801c9d <strcpy>
	return 0;
}
  801438:	b8 00 00 00 00       	mov    $0x0,%eax
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <devcons_write>:
{
  80143f:	f3 0f 1e fb          	endbr32 
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80144f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801454:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80145a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80145d:	73 31                	jae    801490 <devcons_write+0x51>
		m = n - tot;
  80145f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801462:	29 f3                	sub    %esi,%ebx
  801464:	83 fb 7f             	cmp    $0x7f,%ebx
  801467:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80146c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	53                   	push   %ebx
  801473:	89 f0                	mov    %esi,%eax
  801475:	03 45 0c             	add    0xc(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	57                   	push   %edi
  80147a:	e8 d4 09 00 00       	call   801e53 <memmove>
		sys_cputs(buf, m);
  80147f:	83 c4 08             	add    $0x8,%esp
  801482:	53                   	push   %ebx
  801483:	57                   	push   %edi
  801484:	e8 1d ec ff ff       	call   8000a6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801489:	01 de                	add    %ebx,%esi
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	eb ca                	jmp    80145a <devcons_write+0x1b>
}
  801490:	89 f0                	mov    %esi,%eax
  801492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5f                   	pop    %edi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    

0080149a <devcons_read>:
{
  80149a:	f3 0f 1e fb          	endbr32 
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	74 21                	je     8014d0 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014af:	e8 14 ec ff ff       	call   8000c8 <sys_cgetc>
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	75 07                	jne    8014bf <devcons_read+0x25>
		sys_yield();
  8014b8:	e8 96 ec ff ff       	call   800153 <sys_yield>
  8014bd:	eb f0                	jmp    8014af <devcons_read+0x15>
	if (c < 0)
  8014bf:	78 0f                	js     8014d0 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014c1:	83 f8 04             	cmp    $0x4,%eax
  8014c4:	74 0c                	je     8014d2 <devcons_read+0x38>
	*(char*)vbuf = c;
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	88 02                	mov    %al,(%edx)
	return 1;
  8014cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb f7                	jmp    8014d0 <devcons_read+0x36>

008014d9 <cputchar>:
{
  8014d9:	f3 0f 1e fb          	endbr32 
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014e9:	6a 01                	push   $0x1
  8014eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	e8 b2 eb ff ff       	call   8000a6 <sys_cputs>
}
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <getchar>:
{
  8014f9:	f3 0f 1e fb          	endbr32 
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801503:	6a 01                	push   $0x1
  801505:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801508:	50                   	push   %eax
  801509:	6a 00                	push   $0x0
  80150b:	e8 a7 f1 ff ff       	call   8006b7 <read>
	if (r < 0)
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	85 c0                	test   %eax,%eax
  801515:	78 06                	js     80151d <getchar+0x24>
	if (r < 1)
  801517:	74 06                	je     80151f <getchar+0x26>
	return c;
  801519:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    
		return -E_EOF;
  80151f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801524:	eb f7                	jmp    80151d <getchar+0x24>

00801526 <iscons>:
{
  801526:	f3 0f 1e fb          	endbr32 
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801530:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801533:	50                   	push   %eax
  801534:	ff 75 08             	pushl  0x8(%ebp)
  801537:	e8 f3 ee ff ff       	call   80042f <fd_lookup>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 11                	js     801554 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801546:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80154c:	39 10                	cmp    %edx,(%eax)
  80154e:	0f 94 c0             	sete   %al
  801551:	0f b6 c0             	movzbl %al,%eax
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <opencons>:
{
  801556:	f3 0f 1e fb          	endbr32 
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801560:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801563:	50                   	push   %eax
  801564:	e8 70 ee ff ff       	call   8003d9 <fd_alloc>
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 3a                	js     8015aa <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	68 07 04 00 00       	push   $0x407
  801578:	ff 75 f4             	pushl  -0xc(%ebp)
  80157b:	6a 00                	push   $0x0
  80157d:	e8 f4 eb ff ff       	call   800176 <sys_page_alloc>
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	78 21                	js     8015aa <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801592:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	50                   	push   %eax
  8015a2:	e8 03 ee ff ff       	call   8003aa <fd2num>
  8015a7:	83 c4 10             	add    $0x10,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015ac:	f3 0f 1e fb          	endbr32 
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015b5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015b8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015be:	e8 6d eb ff ff       	call   800130 <sys_getenvid>
  8015c3:	83 ec 0c             	sub    $0xc,%esp
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	56                   	push   %esi
  8015cd:	50                   	push   %eax
  8015ce:	68 20 25 80 00       	push   $0x802520
  8015d3:	e8 bb 00 00 00       	call   801693 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015d8:	83 c4 18             	add    $0x18,%esp
  8015db:	53                   	push   %ebx
  8015dc:	ff 75 10             	pushl  0x10(%ebp)
  8015df:	e8 5a 00 00 00       	call   80163e <vcprintf>
	cprintf("\n");
  8015e4:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  8015eb:	e8 a3 00 00 00       	call   801693 <cprintf>
  8015f0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8015f3:	cc                   	int3   
  8015f4:	eb fd                	jmp    8015f3 <_panic+0x47>

008015f6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8015f6:	f3 0f 1e fb          	endbr32 
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801604:	8b 13                	mov    (%ebx),%edx
  801606:	8d 42 01             	lea    0x1(%edx),%eax
  801609:	89 03                	mov    %eax,(%ebx)
  80160b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801612:	3d ff 00 00 00       	cmp    $0xff,%eax
  801617:	74 09                	je     801622 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801619:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801620:	c9                   	leave  
  801621:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	68 ff 00 00 00       	push   $0xff
  80162a:	8d 43 08             	lea    0x8(%ebx),%eax
  80162d:	50                   	push   %eax
  80162e:	e8 73 ea ff ff       	call   8000a6 <sys_cputs>
		b->idx = 0;
  801633:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	eb db                	jmp    801619 <putch+0x23>

0080163e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80163e:	f3 0f 1e fb          	endbr32 
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80164b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801652:	00 00 00 
	b.cnt = 0;
  801655:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80165c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	68 f6 15 80 00       	push   $0x8015f6
  801671:	e8 20 01 00 00       	call   801796 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801676:	83 c4 08             	add    $0x8,%esp
  801679:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80167f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	e8 1b ea ff ff       	call   8000a6 <sys_cputs>

	return b.cnt;
}
  80168b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801693:	f3 0f 1e fb          	endbr32 
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80169d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016a0:	50                   	push   %eax
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	e8 95 ff ff ff       	call   80163e <vcprintf>
	va_end(ap);

	return cnt;
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 1c             	sub    $0x1c,%esp
  8016b4:	89 c7                	mov    %eax,%edi
  8016b6:	89 d6                	mov    %edx,%esi
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	89 d1                	mov    %edx,%ecx
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d8:	39 c2                	cmp    %eax,%edx
  8016da:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016dd:	72 3e                	jb     80171d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	ff 75 18             	pushl  0x18(%ebp)
  8016e5:	83 eb 01             	sub    $0x1,%ebx
  8016e8:	53                   	push   %ebx
  8016e9:	50                   	push   %eax
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8016f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8016f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8016f9:	e8 62 0a 00 00       	call   802160 <__udivdi3>
  8016fe:	83 c4 18             	add    $0x18,%esp
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	89 f2                	mov    %esi,%edx
  801705:	89 f8                	mov    %edi,%eax
  801707:	e8 9f ff ff ff       	call   8016ab <printnum>
  80170c:	83 c4 20             	add    $0x20,%esp
  80170f:	eb 13                	jmp    801724 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	56                   	push   %esi
  801715:	ff 75 18             	pushl  0x18(%ebp)
  801718:	ff d7                	call   *%edi
  80171a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80171d:	83 eb 01             	sub    $0x1,%ebx
  801720:	85 db                	test   %ebx,%ebx
  801722:	7f ed                	jg     801711 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	56                   	push   %esi
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80172e:	ff 75 e0             	pushl  -0x20(%ebp)
  801731:	ff 75 dc             	pushl  -0x24(%ebp)
  801734:	ff 75 d8             	pushl  -0x28(%ebp)
  801737:	e8 34 0b 00 00       	call   802270 <__umoddi3>
  80173c:	83 c4 14             	add    $0x14,%esp
  80173f:	0f be 80 43 25 80 00 	movsbl 0x802543(%eax),%eax
  801746:	50                   	push   %eax
  801747:	ff d7                	call   *%edi
}
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80175e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801762:	8b 10                	mov    (%eax),%edx
  801764:	3b 50 04             	cmp    0x4(%eax),%edx
  801767:	73 0a                	jae    801773 <sprintputch+0x1f>
		*b->buf++ = ch;
  801769:	8d 4a 01             	lea    0x1(%edx),%ecx
  80176c:	89 08                	mov    %ecx,(%eax)
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	88 02                	mov    %al,(%edx)
}
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <printfmt>:
{
  801775:	f3 0f 1e fb          	endbr32 
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80177f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801782:	50                   	push   %eax
  801783:	ff 75 10             	pushl  0x10(%ebp)
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	ff 75 08             	pushl  0x8(%ebp)
  80178c:	e8 05 00 00 00       	call   801796 <vprintfmt>
}
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <vprintfmt>:
{
  801796:	f3 0f 1e fb          	endbr32 
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 3c             	sub    $0x3c,%esp
  8017a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017ac:	e9 8e 03 00 00       	jmp    801b3f <vprintfmt+0x3a9>
		padc = ' ';
  8017b1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017ca:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017cf:	8d 47 01             	lea    0x1(%edi),%eax
  8017d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d5:	0f b6 17             	movzbl (%edi),%edx
  8017d8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017db:	3c 55                	cmp    $0x55,%al
  8017dd:	0f 87 df 03 00 00    	ja     801bc2 <vprintfmt+0x42c>
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  8017ed:	00 
  8017ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8017f1:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8017f5:	eb d8                	jmp    8017cf <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017fa:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8017fe:	eb cf                	jmp    8017cf <vprintfmt+0x39>
  801800:	0f b6 d2             	movzbl %dl,%edx
  801803:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
  80180b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80180e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801811:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801815:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801818:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80181b:	83 f9 09             	cmp    $0x9,%ecx
  80181e:	77 55                	ja     801875 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801820:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801823:	eb e9                	jmp    80180e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801825:	8b 45 14             	mov    0x14(%ebp),%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80182d:	8b 45 14             	mov    0x14(%ebp),%eax
  801830:	8d 40 04             	lea    0x4(%eax),%eax
  801833:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801839:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183d:	79 90                	jns    8017cf <vprintfmt+0x39>
				width = precision, precision = -1;
  80183f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801842:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801845:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80184c:	eb 81                	jmp    8017cf <vprintfmt+0x39>
  80184e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801851:	85 c0                	test   %eax,%eax
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	0f 49 d0             	cmovns %eax,%edx
  80185b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80185e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801861:	e9 69 ff ff ff       	jmp    8017cf <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801869:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801870:	e9 5a ff ff ff       	jmp    8017cf <vprintfmt+0x39>
  801875:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801878:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80187b:	eb bc                	jmp    801839 <vprintfmt+0xa3>
			lflag++;
  80187d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801880:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801883:	e9 47 ff ff ff       	jmp    8017cf <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801888:	8b 45 14             	mov    0x14(%ebp),%eax
  80188b:	8d 78 04             	lea    0x4(%eax),%edi
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	53                   	push   %ebx
  801892:	ff 30                	pushl  (%eax)
  801894:	ff d6                	call   *%esi
			break;
  801896:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801899:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80189c:	e9 9b 02 00 00       	jmp    801b3c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	8d 78 04             	lea    0x4(%eax),%edi
  8018a7:	8b 00                	mov    (%eax),%eax
  8018a9:	99                   	cltd   
  8018aa:	31 d0                	xor    %edx,%eax
  8018ac:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018ae:	83 f8 0f             	cmp    $0xf,%eax
  8018b1:	7f 23                	jg     8018d6 <vprintfmt+0x140>
  8018b3:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8018ba:	85 d2                	test   %edx,%edx
  8018bc:	74 18                	je     8018d6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018be:	52                   	push   %edx
  8018bf:	68 a1 24 80 00       	push   $0x8024a1
  8018c4:	53                   	push   %ebx
  8018c5:	56                   	push   %esi
  8018c6:	e8 aa fe ff ff       	call   801775 <printfmt>
  8018cb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018ce:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018d1:	e9 66 02 00 00       	jmp    801b3c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018d6:	50                   	push   %eax
  8018d7:	68 5b 25 80 00       	push   $0x80255b
  8018dc:	53                   	push   %ebx
  8018dd:	56                   	push   %esi
  8018de:	e8 92 fe ff ff       	call   801775 <printfmt>
  8018e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018e6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018e9:	e9 4e 02 00 00       	jmp    801b3c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f1:	83 c0 04             	add    $0x4,%eax
  8018f4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fa:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8018fc:	85 d2                	test   %edx,%edx
  8018fe:	b8 54 25 80 00       	mov    $0x802554,%eax
  801903:	0f 45 c2             	cmovne %edx,%eax
  801906:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801909:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80190d:	7e 06                	jle    801915 <vprintfmt+0x17f>
  80190f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801913:	75 0d                	jne    801922 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801918:	89 c7                	mov    %eax,%edi
  80191a:	03 45 e0             	add    -0x20(%ebp),%eax
  80191d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801920:	eb 55                	jmp    801977 <vprintfmt+0x1e1>
  801922:	83 ec 08             	sub    $0x8,%esp
  801925:	ff 75 d8             	pushl  -0x28(%ebp)
  801928:	ff 75 cc             	pushl  -0x34(%ebp)
  80192b:	e8 46 03 00 00       	call   801c76 <strnlen>
  801930:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801933:	29 c2                	sub    %eax,%edx
  801935:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80193d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801941:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801944:	85 ff                	test   %edi,%edi
  801946:	7e 11                	jle    801959 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801948:	83 ec 08             	sub    $0x8,%esp
  80194b:	53                   	push   %ebx
  80194c:	ff 75 e0             	pushl  -0x20(%ebp)
  80194f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801951:	83 ef 01             	sub    $0x1,%edi
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	eb eb                	jmp    801944 <vprintfmt+0x1ae>
  801959:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80195c:	85 d2                	test   %edx,%edx
  80195e:	b8 00 00 00 00       	mov    $0x0,%eax
  801963:	0f 49 c2             	cmovns %edx,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80196b:	eb a8                	jmp    801915 <vprintfmt+0x17f>
					putch(ch, putdat);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	53                   	push   %ebx
  801971:	52                   	push   %edx
  801972:	ff d6                	call   *%esi
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80197a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80197c:	83 c7 01             	add    $0x1,%edi
  80197f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801983:	0f be d0             	movsbl %al,%edx
  801986:	85 d2                	test   %edx,%edx
  801988:	74 4b                	je     8019d5 <vprintfmt+0x23f>
  80198a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80198e:	78 06                	js     801996 <vprintfmt+0x200>
  801990:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801994:	78 1e                	js     8019b4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801996:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80199a:	74 d1                	je     80196d <vprintfmt+0x1d7>
  80199c:	0f be c0             	movsbl %al,%eax
  80199f:	83 e8 20             	sub    $0x20,%eax
  8019a2:	83 f8 5e             	cmp    $0x5e,%eax
  8019a5:	76 c6                	jbe    80196d <vprintfmt+0x1d7>
					putch('?', putdat);
  8019a7:	83 ec 08             	sub    $0x8,%esp
  8019aa:	53                   	push   %ebx
  8019ab:	6a 3f                	push   $0x3f
  8019ad:	ff d6                	call   *%esi
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	eb c3                	jmp    801977 <vprintfmt+0x1e1>
  8019b4:	89 cf                	mov    %ecx,%edi
  8019b6:	eb 0e                	jmp    8019c6 <vprintfmt+0x230>
				putch(' ', putdat);
  8019b8:	83 ec 08             	sub    $0x8,%esp
  8019bb:	53                   	push   %ebx
  8019bc:	6a 20                	push   $0x20
  8019be:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019c0:	83 ef 01             	sub    $0x1,%edi
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 ff                	test   %edi,%edi
  8019c8:	7f ee                	jg     8019b8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8019d0:	e9 67 01 00 00       	jmp    801b3c <vprintfmt+0x3a6>
  8019d5:	89 cf                	mov    %ecx,%edi
  8019d7:	eb ed                	jmp    8019c6 <vprintfmt+0x230>
	if (lflag >= 2)
  8019d9:	83 f9 01             	cmp    $0x1,%ecx
  8019dc:	7f 1b                	jg     8019f9 <vprintfmt+0x263>
	else if (lflag)
  8019de:	85 c9                	test   %ecx,%ecx
  8019e0:	74 63                	je     801a45 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ea:	99                   	cltd   
  8019eb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f1:	8d 40 04             	lea    0x4(%eax),%eax
  8019f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f7:	eb 17                	jmp    801a10 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8019f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fc:	8b 50 04             	mov    0x4(%eax),%edx
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	8d 40 08             	lea    0x8(%eax),%eax
  801a0d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a10:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a13:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a16:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a1b:	85 c9                	test   %ecx,%ecx
  801a1d:	0f 89 ff 00 00 00    	jns    801b22 <vprintfmt+0x38c>
				putch('-', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	53                   	push   %ebx
  801a27:	6a 2d                	push   $0x2d
  801a29:	ff d6                	call   *%esi
				num = -(long long) num;
  801a2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a2e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a31:	f7 da                	neg    %edx
  801a33:	83 d1 00             	adc    $0x0,%ecx
  801a36:	f7 d9                	neg    %ecx
  801a38:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a40:	e9 dd 00 00 00       	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	8b 00                	mov    (%eax),%eax
  801a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a4d:	99                   	cltd   
  801a4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a51:	8b 45 14             	mov    0x14(%ebp),%eax
  801a54:	8d 40 04             	lea    0x4(%eax),%eax
  801a57:	89 45 14             	mov    %eax,0x14(%ebp)
  801a5a:	eb b4                	jmp    801a10 <vprintfmt+0x27a>
	if (lflag >= 2)
  801a5c:	83 f9 01             	cmp    $0x1,%ecx
  801a5f:	7f 1e                	jg     801a7f <vprintfmt+0x2e9>
	else if (lflag)
  801a61:	85 c9                	test   %ecx,%ecx
  801a63:	74 32                	je     801a97 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a65:	8b 45 14             	mov    0x14(%ebp),%eax
  801a68:	8b 10                	mov    (%eax),%edx
  801a6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6f:	8d 40 04             	lea    0x4(%eax),%eax
  801a72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a75:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a7a:	e9 a3 00 00 00       	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a82:	8b 10                	mov    (%eax),%edx
  801a84:	8b 48 04             	mov    0x4(%eax),%ecx
  801a87:	8d 40 08             	lea    0x8(%eax),%eax
  801a8a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a92:	e9 8b 00 00 00       	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a97:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9a:	8b 10                	mov    (%eax),%edx
  801a9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa1:	8d 40 04             	lea    0x4(%eax),%eax
  801aa4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aa7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801aac:	eb 74                	jmp    801b22 <vprintfmt+0x38c>
	if (lflag >= 2)
  801aae:	83 f9 01             	cmp    $0x1,%ecx
  801ab1:	7f 1b                	jg     801ace <vprintfmt+0x338>
	else if (lflag)
  801ab3:	85 c9                	test   %ecx,%ecx
  801ab5:	74 2c                	je     801ae3 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aba:	8b 10                	mov    (%eax),%edx
  801abc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac1:	8d 40 04             	lea    0x4(%eax),%eax
  801ac4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ac7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801acc:	eb 54                	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ace:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad1:	8b 10                	mov    (%eax),%edx
  801ad3:	8b 48 04             	mov    0x4(%eax),%ecx
  801ad6:	8d 40 08             	lea    0x8(%eax),%eax
  801ad9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801adc:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801ae1:	eb 3f                	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae6:	8b 10                	mov    (%eax),%edx
  801ae8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aed:	8d 40 04             	lea    0x4(%eax),%eax
  801af0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801af3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801af8:	eb 28                	jmp    801b22 <vprintfmt+0x38c>
			putch('0', putdat);
  801afa:	83 ec 08             	sub    $0x8,%esp
  801afd:	53                   	push   %ebx
  801afe:	6a 30                	push   $0x30
  801b00:	ff d6                	call   *%esi
			putch('x', putdat);
  801b02:	83 c4 08             	add    $0x8,%esp
  801b05:	53                   	push   %ebx
  801b06:	6a 78                	push   $0x78
  801b08:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0d:	8b 10                	mov    (%eax),%edx
  801b0f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b14:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b17:	8d 40 04             	lea    0x4(%eax),%eax
  801b1a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b1d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b29:	57                   	push   %edi
  801b2a:	ff 75 e0             	pushl  -0x20(%ebp)
  801b2d:	50                   	push   %eax
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	89 da                	mov    %ebx,%edx
  801b32:	89 f0                	mov    %esi,%eax
  801b34:	e8 72 fb ff ff       	call   8016ab <printnum>
			break;
  801b39:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b3c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b3f:	83 c7 01             	add    $0x1,%edi
  801b42:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b46:	83 f8 25             	cmp    $0x25,%eax
  801b49:	0f 84 62 fc ff ff    	je     8017b1 <vprintfmt+0x1b>
			if (ch == '\0')
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	0f 84 8b 00 00 00    	je     801be2 <vprintfmt+0x44c>
			putch(ch, putdat);
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	53                   	push   %ebx
  801b5b:	50                   	push   %eax
  801b5c:	ff d6                	call   *%esi
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	eb dc                	jmp    801b3f <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b63:	83 f9 01             	cmp    $0x1,%ecx
  801b66:	7f 1b                	jg     801b83 <vprintfmt+0x3ed>
	else if (lflag)
  801b68:	85 c9                	test   %ecx,%ecx
  801b6a:	74 2c                	je     801b98 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6f:	8b 10                	mov    (%eax),%edx
  801b71:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b76:	8d 40 04             	lea    0x4(%eax),%eax
  801b79:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b7c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b81:	eb 9f                	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	8b 10                	mov    (%eax),%edx
  801b88:	8b 48 04             	mov    0x4(%eax),%ecx
  801b8b:	8d 40 08             	lea    0x8(%eax),%eax
  801b8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b91:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801b96:	eb 8a                	jmp    801b22 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b98:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9b:	8b 10                	mov    (%eax),%edx
  801b9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba2:	8d 40 04             	lea    0x4(%eax),%eax
  801ba5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bad:	e9 70 ff ff ff       	jmp    801b22 <vprintfmt+0x38c>
			putch(ch, putdat);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	53                   	push   %ebx
  801bb6:	6a 25                	push   $0x25
  801bb8:	ff d6                	call   *%esi
			break;
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	e9 7a ff ff ff       	jmp    801b3c <vprintfmt+0x3a6>
			putch('%', putdat);
  801bc2:	83 ec 08             	sub    $0x8,%esp
  801bc5:	53                   	push   %ebx
  801bc6:	6a 25                	push   $0x25
  801bc8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 f8                	mov    %edi,%eax
  801bcf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bd3:	74 05                	je     801bda <vprintfmt+0x444>
  801bd5:	83 e8 01             	sub    $0x1,%eax
  801bd8:	eb f5                	jmp    801bcf <vprintfmt+0x439>
  801bda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bdd:	e9 5a ff ff ff       	jmp    801b3c <vprintfmt+0x3a6>
}
  801be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5f                   	pop    %edi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    

00801bea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bea:	f3 0f 1e fb          	endbr32 
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 18             	sub    $0x18,%esp
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bfd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c01:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	74 26                	je     801c35 <vsnprintf+0x4b>
  801c0f:	85 d2                	test   %edx,%edx
  801c11:	7e 22                	jle    801c35 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c13:	ff 75 14             	pushl  0x14(%ebp)
  801c16:	ff 75 10             	pushl  0x10(%ebp)
  801c19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c1c:	50                   	push   %eax
  801c1d:	68 54 17 80 00       	push   $0x801754
  801c22:	e8 6f fb ff ff       	call   801796 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c30:	83 c4 10             	add    $0x10,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    
		return -E_INVAL;
  801c35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3a:	eb f7                	jmp    801c33 <vsnprintf+0x49>

00801c3c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c3c:	f3 0f 1e fb          	endbr32 
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c46:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c49:	50                   	push   %eax
  801c4a:	ff 75 10             	pushl  0x10(%ebp)
  801c4d:	ff 75 0c             	pushl  0xc(%ebp)
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	e8 92 ff ff ff       	call   801bea <vsnprintf>
	va_end(ap);

	return rc;
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c5a:	f3 0f 1e fb          	endbr32 
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
  801c69:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c6d:	74 05                	je     801c74 <strlen+0x1a>
		n++;
  801c6f:	83 c0 01             	add    $0x1,%eax
  801c72:	eb f5                	jmp    801c69 <strlen+0xf>
	return n;
}
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c76:	f3 0f 1e fb          	endbr32 
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c83:	b8 00 00 00 00       	mov    $0x0,%eax
  801c88:	39 d0                	cmp    %edx,%eax
  801c8a:	74 0d                	je     801c99 <strnlen+0x23>
  801c8c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c90:	74 05                	je     801c97 <strnlen+0x21>
		n++;
  801c92:	83 c0 01             	add    $0x1,%eax
  801c95:	eb f1                	jmp    801c88 <strnlen+0x12>
  801c97:	89 c2                	mov    %eax,%edx
	return n;
}
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    

00801c9d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c9d:	f3 0f 1e fb          	endbr32 
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	53                   	push   %ebx
  801ca5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cb4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cb7:	83 c0 01             	add    $0x1,%eax
  801cba:	84 d2                	test   %dl,%dl
  801cbc:	75 f2                	jne    801cb0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cbe:	89 c8                	mov    %ecx,%eax
  801cc0:	5b                   	pop    %ebx
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cc3:	f3 0f 1e fb          	endbr32 
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	53                   	push   %ebx
  801ccb:	83 ec 10             	sub    $0x10,%esp
  801cce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801cd1:	53                   	push   %ebx
  801cd2:	e8 83 ff ff ff       	call   801c5a <strlen>
  801cd7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	01 d8                	add    %ebx,%eax
  801cdf:	50                   	push   %eax
  801ce0:	e8 b8 ff ff ff       	call   801c9d <strcpy>
	return dst;
}
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801cec:	f3 0f 1e fb          	endbr32 
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfb:	89 f3                	mov    %esi,%ebx
  801cfd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d00:	89 f0                	mov    %esi,%eax
  801d02:	39 d8                	cmp    %ebx,%eax
  801d04:	74 11                	je     801d17 <strncpy+0x2b>
		*dst++ = *src;
  801d06:	83 c0 01             	add    $0x1,%eax
  801d09:	0f b6 0a             	movzbl (%edx),%ecx
  801d0c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d0f:	80 f9 01             	cmp    $0x1,%cl
  801d12:	83 da ff             	sbb    $0xffffffff,%edx
  801d15:	eb eb                	jmp    801d02 <strncpy+0x16>
	}
	return ret;
}
  801d17:	89 f0                	mov    %esi,%eax
  801d19:	5b                   	pop    %ebx
  801d1a:	5e                   	pop    %esi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	56                   	push   %esi
  801d25:	53                   	push   %ebx
  801d26:	8b 75 08             	mov    0x8(%ebp),%esi
  801d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d2c:	8b 55 10             	mov    0x10(%ebp),%edx
  801d2f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d31:	85 d2                	test   %edx,%edx
  801d33:	74 21                	je     801d56 <strlcpy+0x39>
  801d35:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d39:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d3b:	39 c2                	cmp    %eax,%edx
  801d3d:	74 14                	je     801d53 <strlcpy+0x36>
  801d3f:	0f b6 19             	movzbl (%ecx),%ebx
  801d42:	84 db                	test   %bl,%bl
  801d44:	74 0b                	je     801d51 <strlcpy+0x34>
			*dst++ = *src++;
  801d46:	83 c1 01             	add    $0x1,%ecx
  801d49:	83 c2 01             	add    $0x1,%edx
  801d4c:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d4f:	eb ea                	jmp    801d3b <strlcpy+0x1e>
  801d51:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d53:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d56:	29 f0                	sub    %esi,%eax
}
  801d58:	5b                   	pop    %ebx
  801d59:	5e                   	pop    %esi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    

00801d5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d5c:	f3 0f 1e fb          	endbr32 
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d69:	0f b6 01             	movzbl (%ecx),%eax
  801d6c:	84 c0                	test   %al,%al
  801d6e:	74 0c                	je     801d7c <strcmp+0x20>
  801d70:	3a 02                	cmp    (%edx),%al
  801d72:	75 08                	jne    801d7c <strcmp+0x20>
		p++, q++;
  801d74:	83 c1 01             	add    $0x1,%ecx
  801d77:	83 c2 01             	add    $0x1,%edx
  801d7a:	eb ed                	jmp    801d69 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d7c:	0f b6 c0             	movzbl %al,%eax
  801d7f:	0f b6 12             	movzbl (%edx),%edx
  801d82:	29 d0                	sub    %edx,%eax
}
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d86:	f3 0f 1e fb          	endbr32 
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	53                   	push   %ebx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	89 c3                	mov    %eax,%ebx
  801d96:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d99:	eb 06                	jmp    801da1 <strncmp+0x1b>
		n--, p++, q++;
  801d9b:	83 c0 01             	add    $0x1,%eax
  801d9e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801da1:	39 d8                	cmp    %ebx,%eax
  801da3:	74 16                	je     801dbb <strncmp+0x35>
  801da5:	0f b6 08             	movzbl (%eax),%ecx
  801da8:	84 c9                	test   %cl,%cl
  801daa:	74 04                	je     801db0 <strncmp+0x2a>
  801dac:	3a 0a                	cmp    (%edx),%cl
  801dae:	74 eb                	je     801d9b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801db0:	0f b6 00             	movzbl (%eax),%eax
  801db3:	0f b6 12             	movzbl (%edx),%edx
  801db6:	29 d0                	sub    %edx,%eax
}
  801db8:	5b                   	pop    %ebx
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	eb f6                	jmp    801db8 <strncmp+0x32>

00801dc2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dc2:	f3 0f 1e fb          	endbr32 
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dd0:	0f b6 10             	movzbl (%eax),%edx
  801dd3:	84 d2                	test   %dl,%dl
  801dd5:	74 09                	je     801de0 <strchr+0x1e>
		if (*s == c)
  801dd7:	38 ca                	cmp    %cl,%dl
  801dd9:	74 0a                	je     801de5 <strchr+0x23>
	for (; *s; s++)
  801ddb:	83 c0 01             	add    $0x1,%eax
  801dde:	eb f0                	jmp    801dd0 <strchr+0xe>
			return (char *) s;
	return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801de7:	f3 0f 1e fb          	endbr32 
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801df5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801df8:	38 ca                	cmp    %cl,%dl
  801dfa:	74 09                	je     801e05 <strfind+0x1e>
  801dfc:	84 d2                	test   %dl,%dl
  801dfe:	74 05                	je     801e05 <strfind+0x1e>
	for (; *s; s++)
  801e00:	83 c0 01             	add    $0x1,%eax
  801e03:	eb f0                	jmp    801df5 <strfind+0xe>
			break;
	return (char *) s;
}
  801e05:	5d                   	pop    %ebp
  801e06:	c3                   	ret    

00801e07 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e07:	f3 0f 1e fb          	endbr32 
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	57                   	push   %edi
  801e0f:	56                   	push   %esi
  801e10:	53                   	push   %ebx
  801e11:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e17:	85 c9                	test   %ecx,%ecx
  801e19:	74 31                	je     801e4c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e1b:	89 f8                	mov    %edi,%eax
  801e1d:	09 c8                	or     %ecx,%eax
  801e1f:	a8 03                	test   $0x3,%al
  801e21:	75 23                	jne    801e46 <memset+0x3f>
		c &= 0xFF;
  801e23:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e27:	89 d3                	mov    %edx,%ebx
  801e29:	c1 e3 08             	shl    $0x8,%ebx
  801e2c:	89 d0                	mov    %edx,%eax
  801e2e:	c1 e0 18             	shl    $0x18,%eax
  801e31:	89 d6                	mov    %edx,%esi
  801e33:	c1 e6 10             	shl    $0x10,%esi
  801e36:	09 f0                	or     %esi,%eax
  801e38:	09 c2                	or     %eax,%edx
  801e3a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e3c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e3f:	89 d0                	mov    %edx,%eax
  801e41:	fc                   	cld    
  801e42:	f3 ab                	rep stos %eax,%es:(%edi)
  801e44:	eb 06                	jmp    801e4c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	fc                   	cld    
  801e4a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e4c:	89 f8                	mov    %edi,%eax
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    

00801e53 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e53:	f3 0f 1e fb          	endbr32 
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	57                   	push   %edi
  801e5b:	56                   	push   %esi
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e65:	39 c6                	cmp    %eax,%esi
  801e67:	73 32                	jae    801e9b <memmove+0x48>
  801e69:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e6c:	39 c2                	cmp    %eax,%edx
  801e6e:	76 2b                	jbe    801e9b <memmove+0x48>
		s += n;
		d += n;
  801e70:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e73:	89 fe                	mov    %edi,%esi
  801e75:	09 ce                	or     %ecx,%esi
  801e77:	09 d6                	or     %edx,%esi
  801e79:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e7f:	75 0e                	jne    801e8f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e81:	83 ef 04             	sub    $0x4,%edi
  801e84:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e87:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e8a:	fd                   	std    
  801e8b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e8d:	eb 09                	jmp    801e98 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e8f:	83 ef 01             	sub    $0x1,%edi
  801e92:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e95:	fd                   	std    
  801e96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e98:	fc                   	cld    
  801e99:	eb 1a                	jmp    801eb5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e9b:	89 c2                	mov    %eax,%edx
  801e9d:	09 ca                	or     %ecx,%edx
  801e9f:	09 f2                	or     %esi,%edx
  801ea1:	f6 c2 03             	test   $0x3,%dl
  801ea4:	75 0a                	jne    801eb0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ea6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ea9:	89 c7                	mov    %eax,%edi
  801eab:	fc                   	cld    
  801eac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801eae:	eb 05                	jmp    801eb5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801eb0:	89 c7                	mov    %eax,%edi
  801eb2:	fc                   	cld    
  801eb3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801eb5:	5e                   	pop    %esi
  801eb6:	5f                   	pop    %edi
  801eb7:	5d                   	pop    %ebp
  801eb8:	c3                   	ret    

00801eb9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801eb9:	f3 0f 1e fb          	endbr32 
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	ff 75 08             	pushl  0x8(%ebp)
  801ecc:	e8 82 ff ff ff       	call   801e53 <memmove>
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ed3:	f3 0f 1e fb          	endbr32 
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	89 c6                	mov    %eax,%esi
  801ee4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ee7:	39 f0                	cmp    %esi,%eax
  801ee9:	74 1c                	je     801f07 <memcmp+0x34>
		if (*s1 != *s2)
  801eeb:	0f b6 08             	movzbl (%eax),%ecx
  801eee:	0f b6 1a             	movzbl (%edx),%ebx
  801ef1:	38 d9                	cmp    %bl,%cl
  801ef3:	75 08                	jne    801efd <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801ef5:	83 c0 01             	add    $0x1,%eax
  801ef8:	83 c2 01             	add    $0x1,%edx
  801efb:	eb ea                	jmp    801ee7 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801efd:	0f b6 c1             	movzbl %cl,%eax
  801f00:	0f b6 db             	movzbl %bl,%ebx
  801f03:	29 d8                	sub    %ebx,%eax
  801f05:	eb 05                	jmp    801f0c <memcmp+0x39>
	}

	return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f10:	f3 0f 1e fb          	endbr32 
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f1d:	89 c2                	mov    %eax,%edx
  801f1f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f22:	39 d0                	cmp    %edx,%eax
  801f24:	73 09                	jae    801f2f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f26:	38 08                	cmp    %cl,(%eax)
  801f28:	74 05                	je     801f2f <memfind+0x1f>
	for (; s < ends; s++)
  801f2a:	83 c0 01             	add    $0x1,%eax
  801f2d:	eb f3                	jmp    801f22 <memfind+0x12>
			break;
	return (void *) s;
}
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f31:	f3 0f 1e fb          	endbr32 
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	57                   	push   %edi
  801f39:	56                   	push   %esi
  801f3a:	53                   	push   %ebx
  801f3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f41:	eb 03                	jmp    801f46 <strtol+0x15>
		s++;
  801f43:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f46:	0f b6 01             	movzbl (%ecx),%eax
  801f49:	3c 20                	cmp    $0x20,%al
  801f4b:	74 f6                	je     801f43 <strtol+0x12>
  801f4d:	3c 09                	cmp    $0x9,%al
  801f4f:	74 f2                	je     801f43 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f51:	3c 2b                	cmp    $0x2b,%al
  801f53:	74 2a                	je     801f7f <strtol+0x4e>
	int neg = 0;
  801f55:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f5a:	3c 2d                	cmp    $0x2d,%al
  801f5c:	74 2b                	je     801f89 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f5e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f64:	75 0f                	jne    801f75 <strtol+0x44>
  801f66:	80 39 30             	cmpb   $0x30,(%ecx)
  801f69:	74 28                	je     801f93 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f6b:	85 db                	test   %ebx,%ebx
  801f6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f72:	0f 44 d8             	cmove  %eax,%ebx
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f7d:	eb 46                	jmp    801fc5 <strtol+0x94>
		s++;
  801f7f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	eb d5                	jmp    801f5e <strtol+0x2d>
		s++, neg = 1;
  801f89:	83 c1 01             	add    $0x1,%ecx
  801f8c:	bf 01 00 00 00       	mov    $0x1,%edi
  801f91:	eb cb                	jmp    801f5e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f93:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f97:	74 0e                	je     801fa7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f99:	85 db                	test   %ebx,%ebx
  801f9b:	75 d8                	jne    801f75 <strtol+0x44>
		s++, base = 8;
  801f9d:	83 c1 01             	add    $0x1,%ecx
  801fa0:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fa5:	eb ce                	jmp    801f75 <strtol+0x44>
		s += 2, base = 16;
  801fa7:	83 c1 02             	add    $0x2,%ecx
  801faa:	bb 10 00 00 00       	mov    $0x10,%ebx
  801faf:	eb c4                	jmp    801f75 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fb1:	0f be d2             	movsbl %dl,%edx
  801fb4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fb7:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fba:	7d 3a                	jge    801ff6 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fbc:	83 c1 01             	add    $0x1,%ecx
  801fbf:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fc3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fc5:	0f b6 11             	movzbl (%ecx),%edx
  801fc8:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fcb:	89 f3                	mov    %esi,%ebx
  801fcd:	80 fb 09             	cmp    $0x9,%bl
  801fd0:	76 df                	jbe    801fb1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fd2:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fd5:	89 f3                	mov    %esi,%ebx
  801fd7:	80 fb 19             	cmp    $0x19,%bl
  801fda:	77 08                	ja     801fe4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fdc:	0f be d2             	movsbl %dl,%edx
  801fdf:	83 ea 57             	sub    $0x57,%edx
  801fe2:	eb d3                	jmp    801fb7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801fe4:	8d 72 bf             	lea    -0x41(%edx),%esi
  801fe7:	89 f3                	mov    %esi,%ebx
  801fe9:	80 fb 19             	cmp    $0x19,%bl
  801fec:	77 08                	ja     801ff6 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801fee:	0f be d2             	movsbl %dl,%edx
  801ff1:	83 ea 37             	sub    $0x37,%edx
  801ff4:	eb c1                	jmp    801fb7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ff6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ffa:	74 05                	je     802001 <strtol+0xd0>
		*endptr = (char *) s;
  801ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fff:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802001:	89 c2                	mov    %eax,%edx
  802003:	f7 da                	neg    %edx
  802005:	85 ff                	test   %edi,%edi
  802007:	0f 45 c2             	cmovne %edx,%eax
}
  80200a:	5b                   	pop    %ebx
  80200b:	5e                   	pop    %esi
  80200c:	5f                   	pop    %edi
  80200d:	5d                   	pop    %ebp
  80200e:	c3                   	ret    

0080200f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80200f:	f3 0f 1e fb          	endbr32 
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	56                   	push   %esi
  802017:	53                   	push   %ebx
  802018:	8b 75 08             	mov    0x8(%ebp),%esi
  80201b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802021:	83 e8 01             	sub    $0x1,%eax
  802024:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802029:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80202e:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	50                   	push   %eax
  802036:	e8 07 e3 ff ff       	call   800342 <sys_ipc_recv>
	if (!t) {
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 2b                	jne    80206d <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802042:	85 f6                	test   %esi,%esi
  802044:	74 0a                	je     802050 <ipc_recv+0x41>
  802046:	a1 08 40 80 00       	mov    0x804008,%eax
  80204b:	8b 40 74             	mov    0x74(%eax),%eax
  80204e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802050:	85 db                	test   %ebx,%ebx
  802052:	74 0a                	je     80205e <ipc_recv+0x4f>
  802054:	a1 08 40 80 00       	mov    0x804008,%eax
  802059:	8b 40 78             	mov    0x78(%eax),%eax
  80205c:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80205e:	a1 08 40 80 00       	mov    0x804008,%eax
  802063:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802066:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80206d:	85 f6                	test   %esi,%esi
  80206f:	74 06                	je     802077 <ipc_recv+0x68>
  802071:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802077:	85 db                	test   %ebx,%ebx
  802079:	74 eb                	je     802066 <ipc_recv+0x57>
  80207b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802081:	eb e3                	jmp    802066 <ipc_recv+0x57>

00802083 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802083:	f3 0f 1e fb          	endbr32 
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	57                   	push   %edi
  80208b:	56                   	push   %esi
  80208c:	53                   	push   %ebx
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	8b 7d 08             	mov    0x8(%ebp),%edi
  802093:	8b 75 0c             	mov    0xc(%ebp),%esi
  802096:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802099:	85 db                	test   %ebx,%ebx
  80209b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020a0:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020a3:	ff 75 14             	pushl  0x14(%ebp)
  8020a6:	53                   	push   %ebx
  8020a7:	56                   	push   %esi
  8020a8:	57                   	push   %edi
  8020a9:	e8 6d e2 ff ff       	call   80031b <sys_ipc_try_send>
  8020ae:	83 c4 10             	add    $0x10,%esp
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 1e                	je     8020d3 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020b5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020b8:	75 07                	jne    8020c1 <ipc_send+0x3e>
		sys_yield();
  8020ba:	e8 94 e0 ff ff       	call   800153 <sys_yield>
  8020bf:	eb e2                	jmp    8020a3 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c1:	50                   	push   %eax
  8020c2:	68 3f 28 80 00       	push   $0x80283f
  8020c7:	6a 39                	push   $0x39
  8020c9:	68 51 28 80 00       	push   $0x802851
  8020ce:	e8 d9 f4 ff ff       	call   8015ac <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d6:	5b                   	pop    %ebx
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020db:	f3 0f 1e fb          	endbr32 
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020ea:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020ed:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020f3:	8b 52 50             	mov    0x50(%edx),%edx
  8020f6:	39 ca                	cmp    %ecx,%edx
  8020f8:	74 11                	je     80210b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8020fa:	83 c0 01             	add    $0x1,%eax
  8020fd:	3d 00 04 00 00       	cmp    $0x400,%eax
  802102:	75 e6                	jne    8020ea <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802104:	b8 00 00 00 00       	mov    $0x0,%eax
  802109:	eb 0b                	jmp    802116 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80210b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80210e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802113:	8b 40 48             	mov    0x48(%eax),%eax
}
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    

00802118 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802118:	f3 0f 1e fb          	endbr32 
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802122:	89 c2                	mov    %eax,%edx
  802124:	c1 ea 16             	shr    $0x16,%edx
  802127:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80212e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802133:	f6 c1 01             	test   $0x1,%cl
  802136:	74 1c                	je     802154 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802138:	c1 e8 0c             	shr    $0xc,%eax
  80213b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802142:	a8 01                	test   $0x1,%al
  802144:	74 0e                	je     802154 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802146:	c1 e8 0c             	shr    $0xc,%eax
  802149:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802150:	ef 
  802151:	0f b7 d2             	movzwl %dx,%edx
}
  802154:	89 d0                	mov    %edx,%eax
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    
  802158:	66 90                	xchg   %ax,%ax
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <__udivdi3>:
  802160:	f3 0f 1e fb          	endbr32 
  802164:	55                   	push   %ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 1c             	sub    $0x1c,%esp
  80216b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80216f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802173:	8b 74 24 34          	mov    0x34(%esp),%esi
  802177:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80217b:	85 d2                	test   %edx,%edx
  80217d:	75 19                	jne    802198 <__udivdi3+0x38>
  80217f:	39 f3                	cmp    %esi,%ebx
  802181:	76 4d                	jbe    8021d0 <__udivdi3+0x70>
  802183:	31 ff                	xor    %edi,%edi
  802185:	89 e8                	mov    %ebp,%eax
  802187:	89 f2                	mov    %esi,%edx
  802189:	f7 f3                	div    %ebx
  80218b:	89 fa                	mov    %edi,%edx
  80218d:	83 c4 1c             	add    $0x1c,%esp
  802190:	5b                   	pop    %ebx
  802191:	5e                   	pop    %esi
  802192:	5f                   	pop    %edi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
  802195:	8d 76 00             	lea    0x0(%esi),%esi
  802198:	39 f2                	cmp    %esi,%edx
  80219a:	76 14                	jbe    8021b0 <__udivdi3+0x50>
  80219c:	31 ff                	xor    %edi,%edi
  80219e:	31 c0                	xor    %eax,%eax
  8021a0:	89 fa                	mov    %edi,%edx
  8021a2:	83 c4 1c             	add    $0x1c,%esp
  8021a5:	5b                   	pop    %ebx
  8021a6:	5e                   	pop    %esi
  8021a7:	5f                   	pop    %edi
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    
  8021aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b0:	0f bd fa             	bsr    %edx,%edi
  8021b3:	83 f7 1f             	xor    $0x1f,%edi
  8021b6:	75 48                	jne    802200 <__udivdi3+0xa0>
  8021b8:	39 f2                	cmp    %esi,%edx
  8021ba:	72 06                	jb     8021c2 <__udivdi3+0x62>
  8021bc:	31 c0                	xor    %eax,%eax
  8021be:	39 eb                	cmp    %ebp,%ebx
  8021c0:	77 de                	ja     8021a0 <__udivdi3+0x40>
  8021c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c7:	eb d7                	jmp    8021a0 <__udivdi3+0x40>
  8021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	89 d9                	mov    %ebx,%ecx
  8021d2:	85 db                	test   %ebx,%ebx
  8021d4:	75 0b                	jne    8021e1 <__udivdi3+0x81>
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021db:	31 d2                	xor    %edx,%edx
  8021dd:	f7 f3                	div    %ebx
  8021df:	89 c1                	mov    %eax,%ecx
  8021e1:	31 d2                	xor    %edx,%edx
  8021e3:	89 f0                	mov    %esi,%eax
  8021e5:	f7 f1                	div    %ecx
  8021e7:	89 c6                	mov    %eax,%esi
  8021e9:	89 e8                	mov    %ebp,%eax
  8021eb:	89 f7                	mov    %esi,%edi
  8021ed:	f7 f1                	div    %ecx
  8021ef:	89 fa                	mov    %edi,%edx
  8021f1:	83 c4 1c             	add    $0x1c,%esp
  8021f4:	5b                   	pop    %ebx
  8021f5:	5e                   	pop    %esi
  8021f6:	5f                   	pop    %edi
  8021f7:	5d                   	pop    %ebp
  8021f8:	c3                   	ret    
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 f9                	mov    %edi,%ecx
  802202:	b8 20 00 00 00       	mov    $0x20,%eax
  802207:	29 f8                	sub    %edi,%eax
  802209:	d3 e2                	shl    %cl,%edx
  80220b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	89 da                	mov    %ebx,%edx
  802213:	d3 ea                	shr    %cl,%edx
  802215:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802219:	09 d1                	or     %edx,%ecx
  80221b:	89 f2                	mov    %esi,%edx
  80221d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802221:	89 f9                	mov    %edi,%ecx
  802223:	d3 e3                	shl    %cl,%ebx
  802225:	89 c1                	mov    %eax,%ecx
  802227:	d3 ea                	shr    %cl,%edx
  802229:	89 f9                	mov    %edi,%ecx
  80222b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80222f:	89 eb                	mov    %ebp,%ebx
  802231:	d3 e6                	shl    %cl,%esi
  802233:	89 c1                	mov    %eax,%ecx
  802235:	d3 eb                	shr    %cl,%ebx
  802237:	09 de                	or     %ebx,%esi
  802239:	89 f0                	mov    %esi,%eax
  80223b:	f7 74 24 08          	divl   0x8(%esp)
  80223f:	89 d6                	mov    %edx,%esi
  802241:	89 c3                	mov    %eax,%ebx
  802243:	f7 64 24 0c          	mull   0xc(%esp)
  802247:	39 d6                	cmp    %edx,%esi
  802249:	72 15                	jb     802260 <__udivdi3+0x100>
  80224b:	89 f9                	mov    %edi,%ecx
  80224d:	d3 e5                	shl    %cl,%ebp
  80224f:	39 c5                	cmp    %eax,%ebp
  802251:	73 04                	jae    802257 <__udivdi3+0xf7>
  802253:	39 d6                	cmp    %edx,%esi
  802255:	74 09                	je     802260 <__udivdi3+0x100>
  802257:	89 d8                	mov    %ebx,%eax
  802259:	31 ff                	xor    %edi,%edi
  80225b:	e9 40 ff ff ff       	jmp    8021a0 <__udivdi3+0x40>
  802260:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802263:	31 ff                	xor    %edi,%edi
  802265:	e9 36 ff ff ff       	jmp    8021a0 <__udivdi3+0x40>
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	66 90                	xchg   %ax,%ax
  80226e:	66 90                	xchg   %ax,%ax

00802270 <__umoddi3>:
  802270:	f3 0f 1e fb          	endbr32 
  802274:	55                   	push   %ebp
  802275:	57                   	push   %edi
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	83 ec 1c             	sub    $0x1c,%esp
  80227b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80227f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802283:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802287:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80228b:	85 c0                	test   %eax,%eax
  80228d:	75 19                	jne    8022a8 <__umoddi3+0x38>
  80228f:	39 df                	cmp    %ebx,%edi
  802291:	76 5d                	jbe    8022f0 <__umoddi3+0x80>
  802293:	89 f0                	mov    %esi,%eax
  802295:	89 da                	mov    %ebx,%edx
  802297:	f7 f7                	div    %edi
  802299:	89 d0                	mov    %edx,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	83 c4 1c             	add    $0x1c,%esp
  8022a0:	5b                   	pop    %ebx
  8022a1:	5e                   	pop    %esi
  8022a2:	5f                   	pop    %edi
  8022a3:	5d                   	pop    %ebp
  8022a4:	c3                   	ret    
  8022a5:	8d 76 00             	lea    0x0(%esi),%esi
  8022a8:	89 f2                	mov    %esi,%edx
  8022aa:	39 d8                	cmp    %ebx,%eax
  8022ac:	76 12                	jbe    8022c0 <__umoddi3+0x50>
  8022ae:	89 f0                	mov    %esi,%eax
  8022b0:	89 da                	mov    %ebx,%edx
  8022b2:	83 c4 1c             	add    $0x1c,%esp
  8022b5:	5b                   	pop    %ebx
  8022b6:	5e                   	pop    %esi
  8022b7:	5f                   	pop    %edi
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    
  8022ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022c0:	0f bd e8             	bsr    %eax,%ebp
  8022c3:	83 f5 1f             	xor    $0x1f,%ebp
  8022c6:	75 50                	jne    802318 <__umoddi3+0xa8>
  8022c8:	39 d8                	cmp    %ebx,%eax
  8022ca:	0f 82 e0 00 00 00    	jb     8023b0 <__umoddi3+0x140>
  8022d0:	89 d9                	mov    %ebx,%ecx
  8022d2:	39 f7                	cmp    %esi,%edi
  8022d4:	0f 86 d6 00 00 00    	jbe    8023b0 <__umoddi3+0x140>
  8022da:	89 d0                	mov    %edx,%eax
  8022dc:	89 ca                	mov    %ecx,%edx
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	89 fd                	mov    %edi,%ebp
  8022f2:	85 ff                	test   %edi,%edi
  8022f4:	75 0b                	jne    802301 <__umoddi3+0x91>
  8022f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f7                	div    %edi
  8022ff:	89 c5                	mov    %eax,%ebp
  802301:	89 d8                	mov    %ebx,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f5                	div    %ebp
  802307:	89 f0                	mov    %esi,%eax
  802309:	f7 f5                	div    %ebp
  80230b:	89 d0                	mov    %edx,%eax
  80230d:	31 d2                	xor    %edx,%edx
  80230f:	eb 8c                	jmp    80229d <__umoddi3+0x2d>
  802311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802318:	89 e9                	mov    %ebp,%ecx
  80231a:	ba 20 00 00 00       	mov    $0x20,%edx
  80231f:	29 ea                	sub    %ebp,%edx
  802321:	d3 e0                	shl    %cl,%eax
  802323:	89 44 24 08          	mov    %eax,0x8(%esp)
  802327:	89 d1                	mov    %edx,%ecx
  802329:	89 f8                	mov    %edi,%eax
  80232b:	d3 e8                	shr    %cl,%eax
  80232d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802331:	89 54 24 04          	mov    %edx,0x4(%esp)
  802335:	8b 54 24 04          	mov    0x4(%esp),%edx
  802339:	09 c1                	or     %eax,%ecx
  80233b:	89 d8                	mov    %ebx,%eax
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 e9                	mov    %ebp,%ecx
  802343:	d3 e7                	shl    %cl,%edi
  802345:	89 d1                	mov    %edx,%ecx
  802347:	d3 e8                	shr    %cl,%eax
  802349:	89 e9                	mov    %ebp,%ecx
  80234b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80234f:	d3 e3                	shl    %cl,%ebx
  802351:	89 c7                	mov    %eax,%edi
  802353:	89 d1                	mov    %edx,%ecx
  802355:	89 f0                	mov    %esi,%eax
  802357:	d3 e8                	shr    %cl,%eax
  802359:	89 e9                	mov    %ebp,%ecx
  80235b:	89 fa                	mov    %edi,%edx
  80235d:	d3 e6                	shl    %cl,%esi
  80235f:	09 d8                	or     %ebx,%eax
  802361:	f7 74 24 08          	divl   0x8(%esp)
  802365:	89 d1                	mov    %edx,%ecx
  802367:	89 f3                	mov    %esi,%ebx
  802369:	f7 64 24 0c          	mull   0xc(%esp)
  80236d:	89 c6                	mov    %eax,%esi
  80236f:	89 d7                	mov    %edx,%edi
  802371:	39 d1                	cmp    %edx,%ecx
  802373:	72 06                	jb     80237b <__umoddi3+0x10b>
  802375:	75 10                	jne    802387 <__umoddi3+0x117>
  802377:	39 c3                	cmp    %eax,%ebx
  802379:	73 0c                	jae    802387 <__umoddi3+0x117>
  80237b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80237f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802383:	89 d7                	mov    %edx,%edi
  802385:	89 c6                	mov    %eax,%esi
  802387:	89 ca                	mov    %ecx,%edx
  802389:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80238e:	29 f3                	sub    %esi,%ebx
  802390:	19 fa                	sbb    %edi,%edx
  802392:	89 d0                	mov    %edx,%eax
  802394:	d3 e0                	shl    %cl,%eax
  802396:	89 e9                	mov    %ebp,%ecx
  802398:	d3 eb                	shr    %cl,%ebx
  80239a:	d3 ea                	shr    %cl,%edx
  80239c:	09 d8                	or     %ebx,%eax
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	29 fe                	sub    %edi,%esi
  8023b2:	19 c3                	sbb    %eax,%ebx
  8023b4:	89 f2                	mov    %esi,%edx
  8023b6:	89 d9                	mov    %ebx,%ecx
  8023b8:	e9 1d ff ff ff       	jmp    8022da <__umoddi3+0x6a>
