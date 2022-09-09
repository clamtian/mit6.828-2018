
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $3");
  800037:	cc                   	int3   
}
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	f3 0f 1e fb          	endbr32 
  80003d:	55                   	push   %ebp
  80003e:	89 e5                	mov    %esp,%ebp
  800040:	56                   	push   %esi
  800041:	53                   	push   %ebx
  800042:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800045:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800048:	e8 de 00 00 00       	call   80012b <sys_getenvid>
  80004d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800052:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800055:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005a:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80005f:	85 db                	test   %ebx,%ebx
  800061:	7e 07                	jle    80006a <libmain+0x31>
		binaryname = argv[0];
  800063:	8b 06                	mov    (%esi),%eax
  800065:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	56                   	push   %esi
  80006e:	53                   	push   %ebx
  80006f:	e8 bf ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800074:	e8 0a 00 00 00       	call   800083 <exit>
}
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80007f:	5b                   	pop    %ebx
  800080:	5e                   	pop    %esi
  800081:	5d                   	pop    %ebp
  800082:	c3                   	ret    

00800083 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800083:	f3 0f 1e fb          	endbr32 
  800087:	55                   	push   %ebp
  800088:	89 e5                	mov    %esp,%ebp
  80008a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008d:	e8 07 05 00 00       	call   800599 <close_all>
	sys_env_destroy(0);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	6a 00                	push   $0x0
  800097:	e8 4a 00 00 00       	call   8000e6 <sys_env_destroy>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a1:	f3 0f 1e fb          	endbr32 
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	89 c7                	mov    %eax,%edi
  8000ba:	89 c6                	mov    %eax,%esi
  8000bc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000be:	5b                   	pop    %ebx
  8000bf:	5e                   	pop    %esi
  8000c0:	5f                   	pop    %edi
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c3:	f3 0f 1e fb          	endbr32 
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	57                   	push   %edi
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	89 d1                	mov    %edx,%ecx
  8000d9:	89 d3                	mov    %edx,%ebx
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	89 d6                	mov    %edx,%esi
  8000df:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5f                   	pop    %edi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e6:	f3 0f 1e fb          	endbr32 
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fb:	b8 03 00 00 00       	mov    $0x3,%eax
  800100:	89 cb                	mov    %ecx,%ebx
  800102:	89 cf                	mov    %ecx,%edi
  800104:	89 ce                	mov    %ecx,%esi
  800106:	cd 30                	int    $0x30
	if(check && ret > 0)
  800108:	85 c0                	test   %eax,%eax
  80010a:	7f 08                	jg     800114 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5f                   	pop    %edi
  800112:	5d                   	pop    %ebp
  800113:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	50                   	push   %eax
  800118:	6a 03                	push   $0x3
  80011a:	68 ca 23 80 00       	push   $0x8023ca
  80011f:	6a 23                	push   $0x23
  800121:	68 e7 23 80 00       	push   $0x8023e7
  800126:	e8 7c 14 00 00       	call   8015a7 <_panic>

0080012b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012b:	f3 0f 1e fb          	endbr32 
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
	asm volatile("int %1\n"
  800135:	ba 00 00 00 00       	mov    $0x0,%edx
  80013a:	b8 02 00 00 00       	mov    $0x2,%eax
  80013f:	89 d1                	mov    %edx,%ecx
  800141:	89 d3                	mov    %edx,%ebx
  800143:	89 d7                	mov    %edx,%edi
  800145:	89 d6                	mov    %edx,%esi
  800147:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5f                   	pop    %edi
  80014c:	5d                   	pop    %ebp
  80014d:	c3                   	ret    

0080014e <sys_yield>:

void
sys_yield(void)
{
  80014e:	f3 0f 1e fb          	endbr32 
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	57                   	push   %edi
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
	asm volatile("int %1\n"
  800158:	ba 00 00 00 00       	mov    $0x0,%edx
  80015d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800162:	89 d1                	mov    %edx,%ecx
  800164:	89 d3                	mov    %edx,%ebx
  800166:	89 d7                	mov    %edx,%edi
  800168:	89 d6                	mov    %edx,%esi
  80016a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016c:	5b                   	pop    %ebx
  80016d:	5e                   	pop    %esi
  80016e:	5f                   	pop    %edi
  80016f:	5d                   	pop    %ebp
  800170:	c3                   	ret    

00800171 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800171:	f3 0f 1e fb          	endbr32 
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	57                   	push   %edi
  800179:	56                   	push   %esi
  80017a:	53                   	push   %ebx
  80017b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80017e:	be 00 00 00 00       	mov    $0x0,%esi
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
  800186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800189:	b8 04 00 00 00       	mov    $0x4,%eax
  80018e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800191:	89 f7                	mov    %esi,%edi
  800193:	cd 30                	int    $0x30
	if(check && ret > 0)
  800195:	85 c0                	test   %eax,%eax
  800197:	7f 08                	jg     8001a1 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800199:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	50                   	push   %eax
  8001a5:	6a 04                	push   $0x4
  8001a7:	68 ca 23 80 00       	push   $0x8023ca
  8001ac:	6a 23                	push   $0x23
  8001ae:	68 e7 23 80 00       	push   $0x8023e7
  8001b3:	e8 ef 13 00 00       	call   8015a7 <_panic>

008001b8 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b8:	f3 0f 1e fb          	endbr32 
  8001bc:	55                   	push   %ebp
  8001bd:	89 e5                	mov    %esp,%ebp
  8001bf:	57                   	push   %edi
  8001c0:	56                   	push   %esi
  8001c1:	53                   	push   %ebx
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cb:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001db:	85 c0                	test   %eax,%eax
  8001dd:	7f 08                	jg     8001e7 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5f                   	pop    %edi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	50                   	push   %eax
  8001eb:	6a 05                	push   $0x5
  8001ed:	68 ca 23 80 00       	push   $0x8023ca
  8001f2:	6a 23                	push   $0x23
  8001f4:	68 e7 23 80 00       	push   $0x8023e7
  8001f9:	e8 a9 13 00 00       	call   8015a7 <_panic>

008001fe <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001fe:	f3 0f 1e fb          	endbr32 
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	57                   	push   %edi
  800206:	56                   	push   %esi
  800207:	53                   	push   %ebx
  800208:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800210:	8b 55 08             	mov    0x8(%ebp),%edx
  800213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800216:	b8 06 00 00 00       	mov    $0x6,%eax
  80021b:	89 df                	mov    %ebx,%edi
  80021d:	89 de                	mov    %ebx,%esi
  80021f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800221:	85 c0                	test   %eax,%eax
  800223:	7f 08                	jg     80022d <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800225:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800228:	5b                   	pop    %ebx
  800229:	5e                   	pop    %esi
  80022a:	5f                   	pop    %edi
  80022b:	5d                   	pop    %ebp
  80022c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	6a 06                	push   $0x6
  800233:	68 ca 23 80 00       	push   $0x8023ca
  800238:	6a 23                	push   $0x23
  80023a:	68 e7 23 80 00       	push   $0x8023e7
  80023f:	e8 63 13 00 00       	call   8015a7 <_panic>

00800244 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800244:	f3 0f 1e fb          	endbr32 
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800251:	bb 00 00 00 00       	mov    $0x0,%ebx
  800256:	8b 55 08             	mov    0x8(%ebp),%edx
  800259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	89 df                	mov    %ebx,%edi
  800263:	89 de                	mov    %ebx,%esi
  800265:	cd 30                	int    $0x30
	if(check && ret > 0)
  800267:	85 c0                	test   %eax,%eax
  800269:	7f 08                	jg     800273 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	50                   	push   %eax
  800277:	6a 08                	push   $0x8
  800279:	68 ca 23 80 00       	push   $0x8023ca
  80027e:	6a 23                	push   $0x23
  800280:	68 e7 23 80 00       	push   $0x8023e7
  800285:	e8 1d 13 00 00       	call   8015a7 <_panic>

0080028a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800297:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029c:	8b 55 08             	mov    0x8(%ebp),%edx
  80029f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a7:	89 df                	mov    %ebx,%edi
  8002a9:	89 de                	mov    %ebx,%esi
  8002ab:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	7f 08                	jg     8002b9 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	50                   	push   %eax
  8002bd:	6a 09                	push   $0x9
  8002bf:	68 ca 23 80 00       	push   $0x8023ca
  8002c4:	6a 23                	push   $0x23
  8002c6:	68 e7 23 80 00       	push   $0x8023e7
  8002cb:	e8 d7 12 00 00       	call   8015a7 <_panic>

008002d0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d0:	f3 0f 1e fb          	endbr32 
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	57                   	push   %edi
  8002d8:	56                   	push   %esi
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ed:	89 df                	mov    %ebx,%edi
  8002ef:	89 de                	mov    %ebx,%esi
  8002f1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f3:	85 c0                	test   %eax,%eax
  8002f5:	7f 08                	jg     8002ff <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	50                   	push   %eax
  800303:	6a 0a                	push   $0xa
  800305:	68 ca 23 80 00       	push   $0x8023ca
  80030a:	6a 23                	push   $0x23
  80030c:	68 e7 23 80 00       	push   $0x8023e7
  800311:	e8 91 12 00 00       	call   8015a7 <_panic>

00800316 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800316:	f3 0f 1e fb          	endbr32 
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800320:	8b 55 08             	mov    0x8(%ebp),%edx
  800323:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800326:	b8 0c 00 00 00       	mov    $0xc,%eax
  80032b:	be 00 00 00 00       	mov    $0x0,%esi
  800330:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800333:	8b 7d 14             	mov    0x14(%ebp),%edi
  800336:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800338:	5b                   	pop    %ebx
  800339:	5e                   	pop    %esi
  80033a:	5f                   	pop    %edi
  80033b:	5d                   	pop    %ebp
  80033c:	c3                   	ret    

0080033d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033d:	f3 0f 1e fb          	endbr32 
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	57                   	push   %edi
  800345:	56                   	push   %esi
  800346:	53                   	push   %ebx
  800347:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80034f:	8b 55 08             	mov    0x8(%ebp),%edx
  800352:	b8 0d 00 00 00       	mov    $0xd,%eax
  800357:	89 cb                	mov    %ecx,%ebx
  800359:	89 cf                	mov    %ecx,%edi
  80035b:	89 ce                	mov    %ecx,%esi
  80035d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80035f:	85 c0                	test   %eax,%eax
  800361:	7f 08                	jg     80036b <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800363:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800366:	5b                   	pop    %ebx
  800367:	5e                   	pop    %esi
  800368:	5f                   	pop    %edi
  800369:	5d                   	pop    %ebp
  80036a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	50                   	push   %eax
  80036f:	6a 0d                	push   $0xd
  800371:	68 ca 23 80 00       	push   $0x8023ca
  800376:	6a 23                	push   $0x23
  800378:	68 e7 23 80 00       	push   $0x8023e7
  80037d:	e8 25 12 00 00       	call   8015a7 <_panic>

00800382 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800382:	f3 0f 1e fb          	endbr32 
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	57                   	push   %edi
  80038a:	56                   	push   %esi
  80038b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038c:	ba 00 00 00 00       	mov    $0x0,%edx
  800391:	b8 0e 00 00 00       	mov    $0xe,%eax
  800396:	89 d1                	mov    %edx,%ecx
  800398:	89 d3                	mov    %edx,%ebx
  80039a:	89 d7                	mov    %edx,%edi
  80039c:	89 d6                	mov    %edx,%esi
  80039e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a0:	5b                   	pop    %ebx
  8003a1:	5e                   	pop    %esi
  8003a2:	5f                   	pop    %edi
  8003a3:	5d                   	pop    %ebp
  8003a4:	c3                   	ret    

008003a5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003a5:	f3 0f 1e fb          	endbr32 
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b4:	c1 e8 0c             	shr    $0xc,%eax
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003b9:	f3 0f 1e fb          	endbr32 
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003d4:	f3 0f 1e fb          	endbr32 
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003e0:	89 c2                	mov    %eax,%edx
  8003e2:	c1 ea 16             	shr    $0x16,%edx
  8003e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ec:	f6 c2 01             	test   $0x1,%dl
  8003ef:	74 2d                	je     80041e <fd_alloc+0x4a>
  8003f1:	89 c2                	mov    %eax,%edx
  8003f3:	c1 ea 0c             	shr    $0xc,%edx
  8003f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003fd:	f6 c2 01             	test   $0x1,%dl
  800400:	74 1c                	je     80041e <fd_alloc+0x4a>
  800402:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800407:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80040c:	75 d2                	jne    8003e0 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800417:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80041c:	eb 0a                	jmp    800428 <fd_alloc+0x54>
			*fd_store = fd;
  80041e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800421:	89 01                	mov    %eax,(%ecx)
			return 0;
  800423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80042a:	f3 0f 1e fb          	endbr32 
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800434:	83 f8 1f             	cmp    $0x1f,%eax
  800437:	77 30                	ja     800469 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800439:	c1 e0 0c             	shl    $0xc,%eax
  80043c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800441:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800447:	f6 c2 01             	test   $0x1,%dl
  80044a:	74 24                	je     800470 <fd_lookup+0x46>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	c1 ea 0c             	shr    $0xc,%edx
  800451:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800458:	f6 c2 01             	test   $0x1,%dl
  80045b:	74 1a                	je     800477 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80045d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800460:	89 02                	mov    %eax,(%edx)
	return 0;
  800462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    
		return -E_INVAL;
  800469:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046e:	eb f7                	jmp    800467 <fd_lookup+0x3d>
		return -E_INVAL;
  800470:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800475:	eb f0                	jmp    800467 <fd_lookup+0x3d>
  800477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80047c:	eb e9                	jmp    800467 <fd_lookup+0x3d>

0080047e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80047e:	f3 0f 1e fb          	endbr32 
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
  800490:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800495:	39 08                	cmp    %ecx,(%eax)
  800497:	74 38                	je     8004d1 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800499:	83 c2 01             	add    $0x1,%edx
  80049c:	8b 04 95 74 24 80 00 	mov    0x802474(,%edx,4),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	75 ee                	jne    800495 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8004ac:	8b 40 48             	mov    0x48(%eax),%eax
  8004af:	83 ec 04             	sub    $0x4,%esp
  8004b2:	51                   	push   %ecx
  8004b3:	50                   	push   %eax
  8004b4:	68 f8 23 80 00       	push   $0x8023f8
  8004b9:	e8 d0 11 00 00       	call   80168e <cprintf>
	*dev = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004cf:	c9                   	leave  
  8004d0:	c3                   	ret    
			*dev = devtab[i];
  8004d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004db:	eb f2                	jmp    8004cf <dev_lookup+0x51>

008004dd <fd_close>:
{
  8004dd:	f3 0f 1e fb          	endbr32 
  8004e1:	55                   	push   %ebp
  8004e2:	89 e5                	mov    %esp,%ebp
  8004e4:	57                   	push   %edi
  8004e5:	56                   	push   %esi
  8004e6:	53                   	push   %ebx
  8004e7:	83 ec 24             	sub    $0x24,%esp
  8004ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004f3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004fa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004fd:	50                   	push   %eax
  8004fe:	e8 27 ff ff ff       	call   80042a <fd_lookup>
  800503:	89 c3                	mov    %eax,%ebx
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	85 c0                	test   %eax,%eax
  80050a:	78 05                	js     800511 <fd_close+0x34>
	    || fd != fd2)
  80050c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80050f:	74 16                	je     800527 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800511:	89 f8                	mov    %edi,%eax
  800513:	84 c0                	test   %al,%al
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
  80051a:	0f 44 d8             	cmove  %eax,%ebx
}
  80051d:	89 d8                	mov    %ebx,%eax
  80051f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80052d:	50                   	push   %eax
  80052e:	ff 36                	pushl  (%esi)
  800530:	e8 49 ff ff ff       	call   80047e <dev_lookup>
  800535:	89 c3                	mov    %eax,%ebx
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	85 c0                	test   %eax,%eax
  80053c:	78 1a                	js     800558 <fd_close+0x7b>
		if (dev->dev_close)
  80053e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800541:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800544:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800549:	85 c0                	test   %eax,%eax
  80054b:	74 0b                	je     800558 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	56                   	push   %esi
  800551:	ff d0                	call   *%eax
  800553:	89 c3                	mov    %eax,%ebx
  800555:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800558:	83 ec 08             	sub    $0x8,%esp
  80055b:	56                   	push   %esi
  80055c:	6a 00                	push   $0x0
  80055e:	e8 9b fc ff ff       	call   8001fe <sys_page_unmap>
	return r;
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	eb b5                	jmp    80051d <fd_close+0x40>

00800568 <close>:

int
close(int fdnum)
{
  800568:	f3 0f 1e fb          	endbr32 
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800575:	50                   	push   %eax
  800576:	ff 75 08             	pushl  0x8(%ebp)
  800579:	e8 ac fe ff ff       	call   80042a <fd_lookup>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	85 c0                	test   %eax,%eax
  800583:	79 02                	jns    800587 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800585:	c9                   	leave  
  800586:	c3                   	ret    
		return fd_close(fd, 1);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	6a 01                	push   $0x1
  80058c:	ff 75 f4             	pushl  -0xc(%ebp)
  80058f:	e8 49 ff ff ff       	call   8004dd <fd_close>
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	eb ec                	jmp    800585 <close+0x1d>

00800599 <close_all>:

void
close_all(void)
{
  800599:	f3 0f 1e fb          	endbr32 
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	53                   	push   %ebx
  8005a1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005a9:	83 ec 0c             	sub    $0xc,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	e8 b6 ff ff ff       	call   800568 <close>
	for (i = 0; i < MAXFD; i++)
  8005b2:	83 c3 01             	add    $0x1,%ebx
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	83 fb 20             	cmp    $0x20,%ebx
  8005bb:	75 ec                	jne    8005a9 <close_all+0x10>
}
  8005bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005c2:	f3 0f 1e fb          	endbr32 
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	57                   	push   %edi
  8005ca:	56                   	push   %esi
  8005cb:	53                   	push   %ebx
  8005cc:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005d2:	50                   	push   %eax
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	e8 4f fe ff ff       	call   80042a <fd_lookup>
  8005db:	89 c3                	mov    %eax,%ebx
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	85 c0                	test   %eax,%eax
  8005e2:	0f 88 81 00 00 00    	js     800669 <dup+0xa7>
		return r;
	close(newfdnum);
  8005e8:	83 ec 0c             	sub    $0xc,%esp
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	e8 75 ff ff ff       	call   800568 <close>

	newfd = INDEX2FD(newfdnum);
  8005f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005f6:	c1 e6 0c             	shl    $0xc,%esi
  8005f9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8005ff:	83 c4 04             	add    $0x4,%esp
  800602:	ff 75 e4             	pushl  -0x1c(%ebp)
  800605:	e8 af fd ff ff       	call   8003b9 <fd2data>
  80060a:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80060c:	89 34 24             	mov    %esi,(%esp)
  80060f:	e8 a5 fd ff ff       	call   8003b9 <fd2data>
  800614:	83 c4 10             	add    $0x10,%esp
  800617:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800619:	89 d8                	mov    %ebx,%eax
  80061b:	c1 e8 16             	shr    $0x16,%eax
  80061e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800625:	a8 01                	test   $0x1,%al
  800627:	74 11                	je     80063a <dup+0x78>
  800629:	89 d8                	mov    %ebx,%eax
  80062b:	c1 e8 0c             	shr    $0xc,%eax
  80062e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800635:	f6 c2 01             	test   $0x1,%dl
  800638:	75 39                	jne    800673 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80063a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80063d:	89 d0                	mov    %edx,%eax
  80063f:	c1 e8 0c             	shr    $0xc,%eax
  800642:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800649:	83 ec 0c             	sub    $0xc,%esp
  80064c:	25 07 0e 00 00       	and    $0xe07,%eax
  800651:	50                   	push   %eax
  800652:	56                   	push   %esi
  800653:	6a 00                	push   $0x0
  800655:	52                   	push   %edx
  800656:	6a 00                	push   $0x0
  800658:	e8 5b fb ff ff       	call   8001b8 <sys_page_map>
  80065d:	89 c3                	mov    %eax,%ebx
  80065f:	83 c4 20             	add    $0x20,%esp
  800662:	85 c0                	test   %eax,%eax
  800664:	78 31                	js     800697 <dup+0xd5>
		goto err;

	return newfdnum;
  800666:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800669:	89 d8                	mov    %ebx,%eax
  80066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066e:	5b                   	pop    %ebx
  80066f:	5e                   	pop    %esi
  800670:	5f                   	pop    %edi
  800671:	5d                   	pop    %ebp
  800672:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800673:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80067a:	83 ec 0c             	sub    $0xc,%esp
  80067d:	25 07 0e 00 00       	and    $0xe07,%eax
  800682:	50                   	push   %eax
  800683:	57                   	push   %edi
  800684:	6a 00                	push   $0x0
  800686:	53                   	push   %ebx
  800687:	6a 00                	push   $0x0
  800689:	e8 2a fb ff ff       	call   8001b8 <sys_page_map>
  80068e:	89 c3                	mov    %eax,%ebx
  800690:	83 c4 20             	add    $0x20,%esp
  800693:	85 c0                	test   %eax,%eax
  800695:	79 a3                	jns    80063a <dup+0x78>
	sys_page_unmap(0, newfd);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	56                   	push   %esi
  80069b:	6a 00                	push   $0x0
  80069d:	e8 5c fb ff ff       	call   8001fe <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006a2:	83 c4 08             	add    $0x8,%esp
  8006a5:	57                   	push   %edi
  8006a6:	6a 00                	push   $0x0
  8006a8:	e8 51 fb ff ff       	call   8001fe <sys_page_unmap>
	return r;
  8006ad:	83 c4 10             	add    $0x10,%esp
  8006b0:	eb b7                	jmp    800669 <dup+0xa7>

008006b2 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006b2:	f3 0f 1e fb          	endbr32 
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 1c             	sub    $0x1c,%esp
  8006bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006c3:	50                   	push   %eax
  8006c4:	53                   	push   %ebx
  8006c5:	e8 60 fd ff ff       	call   80042a <fd_lookup>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	78 3f                	js     800710 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006d7:	50                   	push   %eax
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006db:	ff 30                	pushl  (%eax)
  8006dd:	e8 9c fd ff ff       	call   80047e <dev_lookup>
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	85 c0                	test   %eax,%eax
  8006e7:	78 27                	js     800710 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006ec:	8b 42 08             	mov    0x8(%edx),%eax
  8006ef:	83 e0 03             	and    $0x3,%eax
  8006f2:	83 f8 01             	cmp    $0x1,%eax
  8006f5:	74 1e                	je     800715 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006fa:	8b 40 08             	mov    0x8(%eax),%eax
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	74 35                	je     800736 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800701:	83 ec 04             	sub    $0x4,%esp
  800704:	ff 75 10             	pushl  0x10(%ebp)
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	52                   	push   %edx
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
}
  800710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800713:	c9                   	leave  
  800714:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800715:	a1 08 40 80 00       	mov    0x804008,%eax
  80071a:	8b 40 48             	mov    0x48(%eax),%eax
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	53                   	push   %ebx
  800721:	50                   	push   %eax
  800722:	68 39 24 80 00       	push   $0x802439
  800727:	e8 62 0f 00 00       	call   80168e <cprintf>
		return -E_INVAL;
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800734:	eb da                	jmp    800710 <read+0x5e>
		return -E_NOT_SUPP;
  800736:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80073b:	eb d3                	jmp    800710 <read+0x5e>

0080073d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80073d:	f3 0f 1e fb          	endbr32 
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	57                   	push   %edi
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 0c             	sub    $0xc,%esp
  80074a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80074d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800750:	bb 00 00 00 00       	mov    $0x0,%ebx
  800755:	eb 02                	jmp    800759 <readn+0x1c>
  800757:	01 c3                	add    %eax,%ebx
  800759:	39 f3                	cmp    %esi,%ebx
  80075b:	73 21                	jae    80077e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80075d:	83 ec 04             	sub    $0x4,%esp
  800760:	89 f0                	mov    %esi,%eax
  800762:	29 d8                	sub    %ebx,%eax
  800764:	50                   	push   %eax
  800765:	89 d8                	mov    %ebx,%eax
  800767:	03 45 0c             	add    0xc(%ebp),%eax
  80076a:	50                   	push   %eax
  80076b:	57                   	push   %edi
  80076c:	e8 41 ff ff ff       	call   8006b2 <read>
		if (m < 0)
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	85 c0                	test   %eax,%eax
  800776:	78 04                	js     80077c <readn+0x3f>
			return m;
		if (m == 0)
  800778:	75 dd                	jne    800757 <readn+0x1a>
  80077a:	eb 02                	jmp    80077e <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80077c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80077e:	89 d8                	mov    %ebx,%eax
  800780:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800783:	5b                   	pop    %ebx
  800784:	5e                   	pop    %esi
  800785:	5f                   	pop    %edi
  800786:	5d                   	pop    %ebp
  800787:	c3                   	ret    

00800788 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800788:	f3 0f 1e fb          	endbr32 
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	53                   	push   %ebx
  800790:	83 ec 1c             	sub    $0x1c,%esp
  800793:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800799:	50                   	push   %eax
  80079a:	53                   	push   %ebx
  80079b:	e8 8a fc ff ff       	call   80042a <fd_lookup>
  8007a0:	83 c4 10             	add    $0x10,%esp
  8007a3:	85 c0                	test   %eax,%eax
  8007a5:	78 3a                	js     8007e1 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b1:	ff 30                	pushl  (%eax)
  8007b3:	e8 c6 fc ff ff       	call   80047e <dev_lookup>
  8007b8:	83 c4 10             	add    $0x10,%esp
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	78 22                	js     8007e1 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007c6:	74 1e                	je     8007e6 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8007ce:	85 d2                	test   %edx,%edx
  8007d0:	74 35                	je     800807 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007d2:	83 ec 04             	sub    $0x4,%esp
  8007d5:	ff 75 10             	pushl  0x10(%ebp)
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	ff d2                	call   *%edx
  8007de:	83 c4 10             	add    $0x10,%esp
}
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8007eb:	8b 40 48             	mov    0x48(%eax),%eax
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	50                   	push   %eax
  8007f3:	68 55 24 80 00       	push   $0x802455
  8007f8:	e8 91 0e 00 00       	call   80168e <cprintf>
		return -E_INVAL;
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800805:	eb da                	jmp    8007e1 <write+0x59>
		return -E_NOT_SUPP;
  800807:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80080c:	eb d3                	jmp    8007e1 <write+0x59>

0080080e <seek>:

int
seek(int fdnum, off_t offset)
{
  80080e:	f3 0f 1e fb          	endbr32 
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800818:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80081b:	50                   	push   %eax
  80081c:	ff 75 08             	pushl  0x8(%ebp)
  80081f:	e8 06 fc ff ff       	call   80042a <fd_lookup>
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	85 c0                	test   %eax,%eax
  800829:	78 0e                	js     800839 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800831:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80083b:	f3 0f 1e fb          	endbr32 
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	53                   	push   %ebx
  800843:	83 ec 1c             	sub    $0x1c,%esp
  800846:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800849:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	53                   	push   %ebx
  80084e:	e8 d7 fb ff ff       	call   80042a <fd_lookup>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	85 c0                	test   %eax,%eax
  800858:	78 37                	js     800891 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800860:	50                   	push   %eax
  800861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800864:	ff 30                	pushl  (%eax)
  800866:	e8 13 fc ff ff       	call   80047e <dev_lookup>
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	85 c0                	test   %eax,%eax
  800870:	78 1f                	js     800891 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800875:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800879:	74 1b                	je     800896 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80087b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087e:	8b 52 18             	mov    0x18(%edx),%edx
  800881:	85 d2                	test   %edx,%edx
  800883:	74 32                	je     8008b7 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	50                   	push   %eax
  80088c:	ff d2                	call   *%edx
  80088e:	83 c4 10             	add    $0x10,%esp
}
  800891:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800894:	c9                   	leave  
  800895:	c3                   	ret    
			thisenv->env_id, fdnum);
  800896:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80089b:	8b 40 48             	mov    0x48(%eax),%eax
  80089e:	83 ec 04             	sub    $0x4,%esp
  8008a1:	53                   	push   %ebx
  8008a2:	50                   	push   %eax
  8008a3:	68 18 24 80 00       	push   $0x802418
  8008a8:	e8 e1 0d 00 00       	call   80168e <cprintf>
		return -E_INVAL;
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b5:	eb da                	jmp    800891 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bc:	eb d3                	jmp    800891 <ftruncate+0x56>

008008be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008be:	f3 0f 1e fb          	endbr32 
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	53                   	push   %ebx
  8008c6:	83 ec 1c             	sub    $0x1c,%esp
  8008c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 52 fb ff ff       	call   80042a <fd_lookup>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	85 c0                	test   %eax,%eax
  8008dd:	78 4b                	js     80092a <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008e5:	50                   	push   %eax
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e9:	ff 30                	pushl  (%eax)
  8008eb:	e8 8e fb ff ff       	call   80047e <dev_lookup>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	78 33                	js     80092a <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008fe:	74 2f                	je     80092f <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800900:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800903:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80090a:	00 00 00 
	stat->st_isdir = 0;
  80090d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800914:	00 00 00 
	stat->st_dev = dev;
  800917:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	53                   	push   %ebx
  800921:	ff 75 f0             	pushl  -0x10(%ebp)
  800924:	ff 50 14             	call   *0x14(%eax)
  800927:	83 c4 10             	add    $0x10,%esp
}
  80092a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092d:	c9                   	leave  
  80092e:	c3                   	ret    
		return -E_NOT_SUPP;
  80092f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800934:	eb f4                	jmp    80092a <fstat+0x6c>

00800936 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800936:	f3 0f 1e fb          	endbr32 
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	56                   	push   %esi
  80093e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	6a 00                	push   $0x0
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	e8 fb 01 00 00       	call   800b47 <open>
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	85 c0                	test   %eax,%eax
  800953:	78 1b                	js     800970 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	50                   	push   %eax
  80095c:	e8 5d ff ff ff       	call   8008be <fstat>
  800961:	89 c6                	mov    %eax,%esi
	close(fd);
  800963:	89 1c 24             	mov    %ebx,(%esp)
  800966:	e8 fd fb ff ff       	call   800568 <close>
	return r;
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 f3                	mov    %esi,%ebx
}
  800970:	89 d8                	mov    %ebx,%eax
  800972:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	89 c6                	mov    %eax,%esi
  800980:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800982:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800989:	74 27                	je     8009b2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80098b:	6a 07                	push   $0x7
  80098d:	68 00 50 80 00       	push   $0x805000
  800992:	56                   	push   %esi
  800993:	ff 35 00 40 80 00    	pushl  0x804000
  800999:	e8 e0 16 00 00       	call   80207e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80099e:	83 c4 0c             	add    $0xc,%esp
  8009a1:	6a 00                	push   $0x0
  8009a3:	53                   	push   %ebx
  8009a4:	6a 00                	push   $0x0
  8009a6:	e8 5f 16 00 00       	call   80200a <ipc_recv>
}
  8009ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ae:	5b                   	pop    %ebx
  8009af:	5e                   	pop    %esi
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009b2:	83 ec 0c             	sub    $0xc,%esp
  8009b5:	6a 01                	push   $0x1
  8009b7:	e8 1a 17 00 00       	call   8020d6 <ipc_find_env>
  8009bc:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	eb c5                	jmp    80098b <fsipc+0x12>

008009c6 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009c6:	f3 0f 1e fb          	endbr32 
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ed:	e8 87 ff ff ff       	call   800979 <fsipc>
}
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <devfile_flush>:
{
  8009f4:	f3 0f 1e fb          	endbr32 
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 40 0c             	mov    0xc(%eax),%eax
  800a04:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a09:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800a13:	e8 61 ff ff ff       	call   800979 <fsipc>
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <devfile_stat>:
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	53                   	push   %ebx
  800a22:	83 ec 04             	sub    $0x4,%esp
  800a25:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a2e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a33:	ba 00 00 00 00       	mov    $0x0,%edx
  800a38:	b8 05 00 00 00       	mov    $0x5,%eax
  800a3d:	e8 37 ff ff ff       	call   800979 <fsipc>
  800a42:	85 c0                	test   %eax,%eax
  800a44:	78 2c                	js     800a72 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	68 00 50 80 00       	push   $0x805000
  800a4e:	53                   	push   %ebx
  800a4f:	e8 44 12 00 00       	call   801c98 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a54:	a1 80 50 80 00       	mov    0x805080,%eax
  800a59:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a5f:	a1 84 50 80 00       	mov    0x805084,%eax
  800a64:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

00800a77 <devfile_write>:
{
  800a77:	f3 0f 1e fb          	endbr32 
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 0c             	sub    $0xc,%esp
  800a81:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a84:	8b 55 08             	mov    0x8(%ebp),%edx
  800a87:	8b 52 0c             	mov    0xc(%edx),%edx
  800a8a:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800a90:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a95:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a9a:	0f 47 c2             	cmova  %edx,%eax
  800a9d:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800aa2:	50                   	push   %eax
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	68 08 50 80 00       	push   $0x805008
  800aab:	e8 9e 13 00 00       	call   801e4e <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	b8 04 00 00 00       	mov    $0x4,%eax
  800aba:	e8 ba fe ff ff       	call   800979 <fsipc>
}
  800abf:	c9                   	leave  
  800ac0:	c3                   	ret    

00800ac1 <devfile_read>:
{
  800ac1:	f3 0f 1e fb          	endbr32 
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ad8:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ade:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae8:	e8 8c fe ff ff       	call   800979 <fsipc>
  800aed:	89 c3                	mov    %eax,%ebx
  800aef:	85 c0                	test   %eax,%eax
  800af1:	78 1f                	js     800b12 <devfile_read+0x51>
	assert(r <= n);
  800af3:	39 f0                	cmp    %esi,%eax
  800af5:	77 24                	ja     800b1b <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800af7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800afc:	7f 33                	jg     800b31 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800afe:	83 ec 04             	sub    $0x4,%esp
  800b01:	50                   	push   %eax
  800b02:	68 00 50 80 00       	push   $0x805000
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	e8 3f 13 00 00       	call   801e4e <memmove>
	return r;
  800b0f:	83 c4 10             	add    $0x10,%esp
}
  800b12:	89 d8                	mov    %ebx,%eax
  800b14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    
	assert(r <= n);
  800b1b:	68 88 24 80 00       	push   $0x802488
  800b20:	68 8f 24 80 00       	push   $0x80248f
  800b25:	6a 7c                	push   $0x7c
  800b27:	68 a4 24 80 00       	push   $0x8024a4
  800b2c:	e8 76 0a 00 00       	call   8015a7 <_panic>
	assert(r <= PGSIZE);
  800b31:	68 af 24 80 00       	push   $0x8024af
  800b36:	68 8f 24 80 00       	push   $0x80248f
  800b3b:	6a 7d                	push   $0x7d
  800b3d:	68 a4 24 80 00       	push   $0x8024a4
  800b42:	e8 60 0a 00 00       	call   8015a7 <_panic>

00800b47 <open>:
{
  800b47:	f3 0f 1e fb          	endbr32 
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	56                   	push   %esi
  800b4f:	53                   	push   %ebx
  800b50:	83 ec 1c             	sub    $0x1c,%esp
  800b53:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b56:	56                   	push   %esi
  800b57:	e8 f9 10 00 00       	call   801c55 <strlen>
  800b5c:	83 c4 10             	add    $0x10,%esp
  800b5f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b64:	7f 6c                	jg     800bd2 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b66:	83 ec 0c             	sub    $0xc,%esp
  800b69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b6c:	50                   	push   %eax
  800b6d:	e8 62 f8 ff ff       	call   8003d4 <fd_alloc>
  800b72:	89 c3                	mov    %eax,%ebx
  800b74:	83 c4 10             	add    $0x10,%esp
  800b77:	85 c0                	test   %eax,%eax
  800b79:	78 3c                	js     800bb7 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	56                   	push   %esi
  800b7f:	68 00 50 80 00       	push   $0x805000
  800b84:	e8 0f 11 00 00       	call   801c98 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b94:	b8 01 00 00 00       	mov    $0x1,%eax
  800b99:	e8 db fd ff ff       	call   800979 <fsipc>
  800b9e:	89 c3                	mov    %eax,%ebx
  800ba0:	83 c4 10             	add    $0x10,%esp
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	78 19                	js     800bc0 <open+0x79>
	return fd2num(fd);
  800ba7:	83 ec 0c             	sub    $0xc,%esp
  800baa:	ff 75 f4             	pushl  -0xc(%ebp)
  800bad:	e8 f3 f7 ff ff       	call   8003a5 <fd2num>
  800bb2:	89 c3                	mov    %eax,%ebx
  800bb4:	83 c4 10             	add    $0x10,%esp
}
  800bb7:	89 d8                	mov    %ebx,%eax
  800bb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    
		fd_close(fd, 0);
  800bc0:	83 ec 08             	sub    $0x8,%esp
  800bc3:	6a 00                	push   $0x0
  800bc5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc8:	e8 10 f9 ff ff       	call   8004dd <fd_close>
		return r;
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	eb e5                	jmp    800bb7 <open+0x70>
		return -E_BAD_PATH;
  800bd2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bd7:	eb de                	jmp    800bb7 <open+0x70>

00800bd9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	b8 08 00 00 00       	mov    $0x8,%eax
  800bed:	e8 87 fd ff ff       	call   800979 <fsipc>
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800bf4:	f3 0f 1e fb          	endbr32 
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800bfe:	68 bb 24 80 00       	push   $0x8024bb
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	e8 8d 10 00 00       	call   801c98 <strcpy>
	return 0;
}
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <devsock_close>:
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	53                   	push   %ebx
  800c1a:	83 ec 10             	sub    $0x10,%esp
  800c1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c20:	53                   	push   %ebx
  800c21:	e8 ed 14 00 00       	call   802113 <pageref>
  800c26:	89 c2                	mov    %eax,%edx
  800c28:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c30:	83 fa 01             	cmp    $0x1,%edx
  800c33:	74 05                	je     800c3a <devsock_close+0x28>
}
  800c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	ff 73 0c             	pushl  0xc(%ebx)
  800c40:	e8 e3 02 00 00       	call   800f28 <nsipc_close>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	eb eb                	jmp    800c35 <devsock_close+0x23>

00800c4a <devsock_write>:
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c54:	6a 00                	push   $0x0
  800c56:	ff 75 10             	pushl  0x10(%ebp)
  800c59:	ff 75 0c             	pushl  0xc(%ebp)
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	ff 70 0c             	pushl  0xc(%eax)
  800c62:	e8 b5 03 00 00       	call   80101c <nsipc_send>
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <devsock_read>:
{
  800c69:	f3 0f 1e fb          	endbr32 
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c73:	6a 00                	push   $0x0
  800c75:	ff 75 10             	pushl  0x10(%ebp)
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff 70 0c             	pushl  0xc(%eax)
  800c81:	e8 1f 03 00 00       	call   800fa5 <nsipc_recv>
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <fd2sockid>:
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c8e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c91:	52                   	push   %edx
  800c92:	50                   	push   %eax
  800c93:	e8 92 f7 ff ff       	call   80042a <fd_lookup>
  800c98:	83 c4 10             	add    $0x10,%esp
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	78 10                	js     800caf <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca2:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800ca8:	39 08                	cmp    %ecx,(%eax)
  800caa:	75 05                	jne    800cb1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cac:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    
		return -E_NOT_SUPP;
  800cb1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cb6:	eb f7                	jmp    800caf <fd2sockid+0x27>

00800cb8 <alloc_sockfd>:
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
  800cbd:	83 ec 1c             	sub    $0x1c,%esp
  800cc0:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cc5:	50                   	push   %eax
  800cc6:	e8 09 f7 ff ff       	call   8003d4 <fd_alloc>
  800ccb:	89 c3                	mov    %eax,%ebx
  800ccd:	83 c4 10             	add    $0x10,%esp
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	78 43                	js     800d17 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800cd4:	83 ec 04             	sub    $0x4,%esp
  800cd7:	68 07 04 00 00       	push   $0x407
  800cdc:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdf:	6a 00                	push   $0x0
  800ce1:	e8 8b f4 ff ff       	call   800171 <sys_page_alloc>
  800ce6:	89 c3                	mov    %eax,%ebx
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	85 c0                	test   %eax,%eax
  800ced:	78 28                	js     800d17 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800cf8:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d04:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d07:	83 ec 0c             	sub    $0xc,%esp
  800d0a:	50                   	push   %eax
  800d0b:	e8 95 f6 ff ff       	call   8003a5 <fd2num>
  800d10:	89 c3                	mov    %eax,%ebx
  800d12:	83 c4 10             	add    $0x10,%esp
  800d15:	eb 0c                	jmp    800d23 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	56                   	push   %esi
  800d1b:	e8 08 02 00 00       	call   800f28 <nsipc_close>
		return r;
  800d20:	83 c4 10             	add    $0x10,%esp
}
  800d23:	89 d8                	mov    %ebx,%eax
  800d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <accept>:
{
  800d2c:	f3 0f 1e fb          	endbr32 
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	e8 4a ff ff ff       	call   800c88 <fd2sockid>
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	78 1b                	js     800d5d <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	ff 75 10             	pushl  0x10(%ebp)
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	e8 22 01 00 00       	call   800e73 <nsipc_accept>
  800d51:	83 c4 10             	add    $0x10,%esp
  800d54:	85 c0                	test   %eax,%eax
  800d56:	78 05                	js     800d5d <accept+0x31>
	return alloc_sockfd(r);
  800d58:	e8 5b ff ff ff       	call   800cb8 <alloc_sockfd>
}
  800d5d:	c9                   	leave  
  800d5e:	c3                   	ret    

00800d5f <bind>:
{
  800d5f:	f3 0f 1e fb          	endbr32 
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	e8 17 ff ff ff       	call   800c88 <fd2sockid>
  800d71:	85 c0                	test   %eax,%eax
  800d73:	78 12                	js     800d87 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d75:	83 ec 04             	sub    $0x4,%esp
  800d78:	ff 75 10             	pushl  0x10(%ebp)
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	50                   	push   %eax
  800d7f:	e8 45 01 00 00       	call   800ec9 <nsipc_bind>
  800d84:	83 c4 10             	add    $0x10,%esp
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <shutdown>:
{
  800d89:	f3 0f 1e fb          	endbr32 
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	e8 ed fe ff ff       	call   800c88 <fd2sockid>
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	78 0f                	js     800dae <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	50                   	push   %eax
  800da6:	e8 57 01 00 00       	call   800f02 <nsipc_shutdown>
  800dab:	83 c4 10             	add    $0x10,%esp
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <connect>:
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	e8 c6 fe ff ff       	call   800c88 <fd2sockid>
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	78 12                	js     800dd8 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	ff 75 10             	pushl  0x10(%ebp)
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	50                   	push   %eax
  800dd0:	e8 71 01 00 00       	call   800f46 <nsipc_connect>
  800dd5:	83 c4 10             	add    $0x10,%esp
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <listen>:
{
  800dda:	f3 0f 1e fb          	endbr32 
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	e8 9c fe ff ff       	call   800c88 <fd2sockid>
  800dec:	85 c0                	test   %eax,%eax
  800dee:	78 0f                	js     800dff <listen+0x25>
	return nsipc_listen(r, backlog);
  800df0:	83 ec 08             	sub    $0x8,%esp
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	50                   	push   %eax
  800df7:	e8 83 01 00 00       	call   800f7f <nsipc_listen>
  800dfc:	83 c4 10             	add    $0x10,%esp
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e01:	f3 0f 1e fb          	endbr32 
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e0b:	ff 75 10             	pushl  0x10(%ebp)
  800e0e:	ff 75 0c             	pushl  0xc(%ebp)
  800e11:	ff 75 08             	pushl  0x8(%ebp)
  800e14:	e8 65 02 00 00       	call   80107e <nsipc_socket>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	78 05                	js     800e25 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e20:	e8 93 fe ff ff       	call   800cb8 <alloc_sockfd>
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 04             	sub    $0x4,%esp
  800e2e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e30:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e37:	74 26                	je     800e5f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e39:	6a 07                	push   $0x7
  800e3b:	68 00 60 80 00       	push   $0x806000
  800e40:	53                   	push   %ebx
  800e41:	ff 35 04 40 80 00    	pushl  0x804004
  800e47:	e8 32 12 00 00       	call   80207e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e4c:	83 c4 0c             	add    $0xc,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	6a 00                	push   $0x0
  800e53:	6a 00                	push   $0x0
  800e55:	e8 b0 11 00 00       	call   80200a <ipc_recv>
}
  800e5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	6a 02                	push   $0x2
  800e64:	e8 6d 12 00 00       	call   8020d6 <ipc_find_env>
  800e69:	a3 04 40 80 00       	mov    %eax,0x804004
  800e6e:	83 c4 10             	add    $0x10,%esp
  800e71:	eb c6                	jmp    800e39 <nsipc+0x12>

00800e73 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e73:	f3 0f 1e fb          	endbr32 
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e87:	8b 06                	mov    (%esi),%eax
  800e89:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800e93:	e8 8f ff ff ff       	call   800e27 <nsipc>
  800e98:	89 c3                	mov    %eax,%ebx
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	79 09                	jns    800ea7 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800e9e:	89 d8                	mov    %ebx,%eax
  800ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ea3:	5b                   	pop    %ebx
  800ea4:	5e                   	pop    %esi
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	ff 35 10 60 80 00    	pushl  0x806010
  800eb0:	68 00 60 80 00       	push   $0x806000
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	e8 91 0f 00 00       	call   801e4e <memmove>
		*addrlen = ret->ret_addrlen;
  800ebd:	a1 10 60 80 00       	mov    0x806010,%eax
  800ec2:	89 06                	mov    %eax,(%esi)
  800ec4:	83 c4 10             	add    $0x10,%esp
	return r;
  800ec7:	eb d5                	jmp    800e9e <nsipc_accept+0x2b>

00800ec9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ec9:	f3 0f 1e fb          	endbr32 
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	53                   	push   %ebx
  800ed1:	83 ec 08             	sub    $0x8,%esp
  800ed4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800edf:	53                   	push   %ebx
  800ee0:	ff 75 0c             	pushl  0xc(%ebp)
  800ee3:	68 04 60 80 00       	push   $0x806004
  800ee8:	e8 61 0f 00 00       	call   801e4e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800eed:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800ef3:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef8:	e8 2a ff ff ff       	call   800e27 <nsipc>
}
  800efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f02:	f3 0f 1e fb          	endbr32 
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f1c:	b8 03 00 00 00       	mov    $0x3,%eax
  800f21:	e8 01 ff ff ff       	call   800e27 <nsipc>
}
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <nsipc_close>:

int
nsipc_close(int s)
{
  800f28:	f3 0f 1e fb          	endbr32 
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f3a:	b8 04 00 00 00       	mov    $0x4,%eax
  800f3f:	e8 e3 fe ff ff       	call   800e27 <nsipc>
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f46:	f3 0f 1e fb          	endbr32 
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	53                   	push   %ebx
  800f4e:	83 ec 08             	sub    $0x8,%esp
  800f51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f5c:	53                   	push   %ebx
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	68 04 60 80 00       	push   $0x806004
  800f65:	e8 e4 0e 00 00       	call   801e4e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f6a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f70:	b8 05 00 00 00       	mov    $0x5,%eax
  800f75:	e8 ad fe ff ff       	call   800e27 <nsipc>
}
  800f7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f7f:	f3 0f 1e fb          	endbr32 
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800f99:	b8 06 00 00 00       	mov    $0x6,%eax
  800f9e:	e8 84 fe ff ff       	call   800e27 <nsipc>
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fa5:	f3 0f 1e fb          	endbr32 
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
  800fae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fb9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fc7:	b8 07 00 00 00       	mov    $0x7,%eax
  800fcc:	e8 56 fe ff ff       	call   800e27 <nsipc>
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 26                	js     800ffd <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fd7:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800fdd:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800fe2:	0f 4e c6             	cmovle %esi,%eax
  800fe5:	39 c3                	cmp    %eax,%ebx
  800fe7:	7f 1d                	jg     801006 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	53                   	push   %ebx
  800fed:	68 00 60 80 00       	push   $0x806000
  800ff2:	ff 75 0c             	pushl  0xc(%ebp)
  800ff5:	e8 54 0e 00 00       	call   801e4e <memmove>
  800ffa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800ffd:	89 d8                	mov    %ebx,%eax
  800fff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801006:	68 c7 24 80 00       	push   $0x8024c7
  80100b:	68 8f 24 80 00       	push   $0x80248f
  801010:	6a 62                	push   $0x62
  801012:	68 dc 24 80 00       	push   $0x8024dc
  801017:	e8 8b 05 00 00       	call   8015a7 <_panic>

0080101c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80101c:	f3 0f 1e fb          	endbr32 
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	53                   	push   %ebx
  801024:	83 ec 04             	sub    $0x4,%esp
  801027:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801032:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801038:	7f 2e                	jg     801068 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	53                   	push   %ebx
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	68 0c 60 80 00       	push   $0x80600c
  801046:	e8 03 0e 00 00       	call   801e4e <memmove>
	nsipcbuf.send.req_size = size;
  80104b:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801059:	b8 08 00 00 00       	mov    $0x8,%eax
  80105e:	e8 c4 fd ff ff       	call   800e27 <nsipc>
}
  801063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801066:	c9                   	leave  
  801067:	c3                   	ret    
	assert(size < 1600);
  801068:	68 e8 24 80 00       	push   $0x8024e8
  80106d:	68 8f 24 80 00       	push   $0x80248f
  801072:	6a 6d                	push   $0x6d
  801074:	68 dc 24 80 00       	push   $0x8024dc
  801079:	e8 29 05 00 00       	call   8015a7 <_panic>

0080107e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80107e:	f3 0f 1e fb          	endbr32 
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801098:	8b 45 10             	mov    0x10(%ebp),%eax
  80109b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010a0:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a5:	e8 7d fd ff ff       	call   800e27 <nsipc>
}
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010ac:	f3 0f 1e fb          	endbr32 
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
  8010b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010b8:	83 ec 0c             	sub    $0xc,%esp
  8010bb:	ff 75 08             	pushl  0x8(%ebp)
  8010be:	e8 f6 f2 ff ff       	call   8003b9 <fd2data>
  8010c3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010c5:	83 c4 08             	add    $0x8,%esp
  8010c8:	68 f4 24 80 00       	push   $0x8024f4
  8010cd:	53                   	push   %ebx
  8010ce:	e8 c5 0b 00 00       	call   801c98 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010d3:	8b 46 04             	mov    0x4(%esi),%eax
  8010d6:	2b 06                	sub    (%esi),%eax
  8010d8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010e5:	00 00 00 
	stat->st_dev = &devpipe;
  8010e8:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8010ef:	30 80 00 
	return 0;
}
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5d                   	pop    %ebp
  8010fd:	c3                   	ret    

008010fe <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8010fe:	f3 0f 1e fb          	endbr32 
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	53                   	push   %ebx
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80110c:	53                   	push   %ebx
  80110d:	6a 00                	push   $0x0
  80110f:	e8 ea f0 ff ff       	call   8001fe <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801114:	89 1c 24             	mov    %ebx,(%esp)
  801117:	e8 9d f2 ff ff       	call   8003b9 <fd2data>
  80111c:	83 c4 08             	add    $0x8,%esp
  80111f:	50                   	push   %eax
  801120:	6a 00                	push   $0x0
  801122:	e8 d7 f0 ff ff       	call   8001fe <sys_page_unmap>
}
  801127:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <_pipeisclosed>:
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 1c             	sub    $0x1c,%esp
  801135:	89 c7                	mov    %eax,%edi
  801137:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801139:	a1 08 40 80 00       	mov    0x804008,%eax
  80113e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	57                   	push   %edi
  801145:	e8 c9 0f 00 00       	call   802113 <pageref>
  80114a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80114d:	89 34 24             	mov    %esi,(%esp)
  801150:	e8 be 0f 00 00       	call   802113 <pageref>
		nn = thisenv->env_runs;
  801155:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80115b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	39 cb                	cmp    %ecx,%ebx
  801163:	74 1b                	je     801180 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801165:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801168:	75 cf                	jne    801139 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80116a:	8b 42 58             	mov    0x58(%edx),%eax
  80116d:	6a 01                	push   $0x1
  80116f:	50                   	push   %eax
  801170:	53                   	push   %ebx
  801171:	68 fb 24 80 00       	push   $0x8024fb
  801176:	e8 13 05 00 00       	call   80168e <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	eb b9                	jmp    801139 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801180:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801183:	0f 94 c0             	sete   %al
  801186:	0f b6 c0             	movzbl %al,%eax
}
  801189:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5f                   	pop    %edi
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <devpipe_write>:
{
  801191:	f3 0f 1e fb          	endbr32 
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	57                   	push   %edi
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	83 ec 28             	sub    $0x28,%esp
  80119e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011a1:	56                   	push   %esi
  8011a2:	e8 12 f2 ff ff       	call   8003b9 <fd2data>
  8011a7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011b4:	74 4f                	je     801205 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011b6:	8b 43 04             	mov    0x4(%ebx),%eax
  8011b9:	8b 0b                	mov    (%ebx),%ecx
  8011bb:	8d 51 20             	lea    0x20(%ecx),%edx
  8011be:	39 d0                	cmp    %edx,%eax
  8011c0:	72 14                	jb     8011d6 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011c2:	89 da                	mov    %ebx,%edx
  8011c4:	89 f0                	mov    %esi,%eax
  8011c6:	e8 61 ff ff ff       	call   80112c <_pipeisclosed>
  8011cb:	85 c0                	test   %eax,%eax
  8011cd:	75 3b                	jne    80120a <devpipe_write+0x79>
			sys_yield();
  8011cf:	e8 7a ef ff ff       	call   80014e <sys_yield>
  8011d4:	eb e0                	jmp    8011b6 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011dd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011e0:	89 c2                	mov    %eax,%edx
  8011e2:	c1 fa 1f             	sar    $0x1f,%edx
  8011e5:	89 d1                	mov    %edx,%ecx
  8011e7:	c1 e9 1b             	shr    $0x1b,%ecx
  8011ea:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8011ed:	83 e2 1f             	and    $0x1f,%edx
  8011f0:	29 ca                	sub    %ecx,%edx
  8011f2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8011f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8011fa:	83 c0 01             	add    $0x1,%eax
  8011fd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801200:	83 c7 01             	add    $0x1,%edi
  801203:	eb ac                	jmp    8011b1 <devpipe_write+0x20>
	return i;
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	eb 05                	jmp    80120f <devpipe_write+0x7e>
				return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801212:	5b                   	pop    %ebx
  801213:	5e                   	pop    %esi
  801214:	5f                   	pop    %edi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <devpipe_read>:
{
  801217:	f3 0f 1e fb          	endbr32 
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	83 ec 18             	sub    $0x18,%esp
  801224:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801227:	57                   	push   %edi
  801228:	e8 8c f1 ff ff       	call   8003b9 <fd2data>
  80122d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	be 00 00 00 00       	mov    $0x0,%esi
  801237:	3b 75 10             	cmp    0x10(%ebp),%esi
  80123a:	75 14                	jne    801250 <devpipe_read+0x39>
	return i;
  80123c:	8b 45 10             	mov    0x10(%ebp),%eax
  80123f:	eb 02                	jmp    801243 <devpipe_read+0x2c>
				return i;
  801241:	89 f0                	mov    %esi,%eax
}
  801243:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801246:	5b                   	pop    %ebx
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    
			sys_yield();
  80124b:	e8 fe ee ff ff       	call   80014e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801250:	8b 03                	mov    (%ebx),%eax
  801252:	3b 43 04             	cmp    0x4(%ebx),%eax
  801255:	75 18                	jne    80126f <devpipe_read+0x58>
			if (i > 0)
  801257:	85 f6                	test   %esi,%esi
  801259:	75 e6                	jne    801241 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80125b:	89 da                	mov    %ebx,%edx
  80125d:	89 f8                	mov    %edi,%eax
  80125f:	e8 c8 fe ff ff       	call   80112c <_pipeisclosed>
  801264:	85 c0                	test   %eax,%eax
  801266:	74 e3                	je     80124b <devpipe_read+0x34>
				return 0;
  801268:	b8 00 00 00 00       	mov    $0x0,%eax
  80126d:	eb d4                	jmp    801243 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80126f:	99                   	cltd   
  801270:	c1 ea 1b             	shr    $0x1b,%edx
  801273:	01 d0                	add    %edx,%eax
  801275:	83 e0 1f             	and    $0x1f,%eax
  801278:	29 d0                	sub    %edx,%eax
  80127a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80127f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801282:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801285:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801288:	83 c6 01             	add    $0x1,%esi
  80128b:	eb aa                	jmp    801237 <devpipe_read+0x20>

0080128d <pipe>:
{
  80128d:	f3 0f 1e fb          	endbr32 
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	50                   	push   %eax
  80129d:	e8 32 f1 ff ff       	call   8003d4 <fd_alloc>
  8012a2:	89 c3                	mov    %eax,%ebx
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	0f 88 23 01 00 00    	js     8013d2 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	68 07 04 00 00       	push   $0x407
  8012b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 b0 ee ff ff       	call   800171 <sys_page_alloc>
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	0f 88 04 01 00 00    	js     8013d2 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012ce:	83 ec 0c             	sub    $0xc,%esp
  8012d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d4:	50                   	push   %eax
  8012d5:	e8 fa f0 ff ff       	call   8003d4 <fd_alloc>
  8012da:	89 c3                	mov    %eax,%ebx
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	0f 88 db 00 00 00    	js     8013c2 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	68 07 04 00 00       	push   $0x407
  8012ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f2:	6a 00                	push   $0x0
  8012f4:	e8 78 ee ff ff       	call   800171 <sys_page_alloc>
  8012f9:	89 c3                	mov    %eax,%ebx
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	0f 88 bc 00 00 00    	js     8013c2 <pipe+0x135>
	va = fd2data(fd0);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	ff 75 f4             	pushl  -0xc(%ebp)
  80130c:	e8 a8 f0 ff ff       	call   8003b9 <fd2data>
  801311:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801313:	83 c4 0c             	add    $0xc,%esp
  801316:	68 07 04 00 00       	push   $0x407
  80131b:	50                   	push   %eax
  80131c:	6a 00                	push   $0x0
  80131e:	e8 4e ee ff ff       	call   800171 <sys_page_alloc>
  801323:	89 c3                	mov    %eax,%ebx
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	85 c0                	test   %eax,%eax
  80132a:	0f 88 82 00 00 00    	js     8013b2 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801330:	83 ec 0c             	sub    $0xc,%esp
  801333:	ff 75 f0             	pushl  -0x10(%ebp)
  801336:	e8 7e f0 ff ff       	call   8003b9 <fd2data>
  80133b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801342:	50                   	push   %eax
  801343:	6a 00                	push   $0x0
  801345:	56                   	push   %esi
  801346:	6a 00                	push   $0x0
  801348:	e8 6b ee ff ff       	call   8001b8 <sys_page_map>
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	83 c4 20             	add    $0x20,%esp
  801352:	85 c0                	test   %eax,%eax
  801354:	78 4e                	js     8013a4 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801356:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80135b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80136a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136d:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801372:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801379:	83 ec 0c             	sub    $0xc,%esp
  80137c:	ff 75 f4             	pushl  -0xc(%ebp)
  80137f:	e8 21 f0 ff ff       	call   8003a5 <fd2num>
  801384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801387:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	ff 75 f0             	pushl  -0x10(%ebp)
  80138f:	e8 11 f0 ff ff       	call   8003a5 <fd2num>
  801394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801397:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a2:	eb 2e                	jmp    8013d2 <pipe+0x145>
	sys_page_unmap(0, va);
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	56                   	push   %esi
  8013a8:	6a 00                	push   $0x0
  8013aa:	e8 4f ee ff ff       	call   8001fe <sys_page_unmap>
  8013af:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8013b8:	6a 00                	push   $0x0
  8013ba:	e8 3f ee ff ff       	call   8001fe <sys_page_unmap>
  8013bf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c8:	6a 00                	push   $0x0
  8013ca:	e8 2f ee ff ff       	call   8001fe <sys_page_unmap>
  8013cf:	83 c4 10             	add    $0x10,%esp
}
  8013d2:	89 d8                	mov    %ebx,%eax
  8013d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d7:	5b                   	pop    %ebx
  8013d8:	5e                   	pop    %esi
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <pipeisclosed>:
{
  8013db:	f3 0f 1e fb          	endbr32 
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	ff 75 08             	pushl  0x8(%ebp)
  8013ec:	e8 39 f0 ff ff       	call   80042a <fd_lookup>
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	78 18                	js     801410 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8013fe:	e8 b6 ef ff ff       	call   8003b9 <fd2data>
  801403:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801408:	e8 1f fd ff ff       	call   80112c <_pipeisclosed>
  80140d:	83 c4 10             	add    $0x10,%esp
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801412:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	c3                   	ret    

0080141c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80141c:	f3 0f 1e fb          	endbr32 
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801426:	68 13 25 80 00       	push   $0x802513
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	e8 65 08 00 00       	call   801c98 <strcpy>
	return 0;
}
  801433:	b8 00 00 00 00       	mov    $0x0,%eax
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <devcons_write>:
{
  80143a:	f3 0f 1e fb          	endbr32 
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80144a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80144f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801455:	3b 75 10             	cmp    0x10(%ebp),%esi
  801458:	73 31                	jae    80148b <devcons_write+0x51>
		m = n - tot;
  80145a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80145d:	29 f3                	sub    %esi,%ebx
  80145f:	83 fb 7f             	cmp    $0x7f,%ebx
  801462:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801467:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	53                   	push   %ebx
  80146e:	89 f0                	mov    %esi,%eax
  801470:	03 45 0c             	add    0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	57                   	push   %edi
  801475:	e8 d4 09 00 00       	call   801e4e <memmove>
		sys_cputs(buf, m);
  80147a:	83 c4 08             	add    $0x8,%esp
  80147d:	53                   	push   %ebx
  80147e:	57                   	push   %edi
  80147f:	e8 1d ec ff ff       	call   8000a1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801484:	01 de                	add    %ebx,%esi
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	eb ca                	jmp    801455 <devcons_write+0x1b>
}
  80148b:	89 f0                	mov    %esi,%eax
  80148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    

00801495 <devcons_read>:
{
  801495:	f3 0f 1e fb          	endbr32 
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a8:	74 21                	je     8014cb <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014aa:	e8 14 ec ff ff       	call   8000c3 <sys_cgetc>
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	75 07                	jne    8014ba <devcons_read+0x25>
		sys_yield();
  8014b3:	e8 96 ec ff ff       	call   80014e <sys_yield>
  8014b8:	eb f0                	jmp    8014aa <devcons_read+0x15>
	if (c < 0)
  8014ba:	78 0f                	js     8014cb <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014bc:	83 f8 04             	cmp    $0x4,%eax
  8014bf:	74 0c                	je     8014cd <devcons_read+0x38>
	*(char*)vbuf = c;
  8014c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c4:	88 02                	mov    %al,(%edx)
	return 1;
  8014c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    
		return 0;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d2:	eb f7                	jmp    8014cb <devcons_read+0x36>

008014d4 <cputchar>:
{
  8014d4:	f3 0f 1e fb          	endbr32 
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014e4:	6a 01                	push   $0x1
  8014e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014e9:	50                   	push   %eax
  8014ea:	e8 b2 eb ff ff       	call   8000a1 <sys_cputs>
}
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <getchar>:
{
  8014f4:	f3 0f 1e fb          	endbr32 
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8014fe:	6a 01                	push   $0x1
  801500:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	6a 00                	push   $0x0
  801506:	e8 a7 f1 ff ff       	call   8006b2 <read>
	if (r < 0)
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 06                	js     801518 <getchar+0x24>
	if (r < 1)
  801512:	74 06                	je     80151a <getchar+0x26>
	return c;
  801514:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    
		return -E_EOF;
  80151a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80151f:	eb f7                	jmp    801518 <getchar+0x24>

00801521 <iscons>:
{
  801521:	f3 0f 1e fb          	endbr32 
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 f3 ee ff ff       	call   80042a <fd_lookup>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 11                	js     80154f <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80153e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801541:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801547:	39 10                	cmp    %edx,(%eax)
  801549:	0f 94 c0             	sete   %al
  80154c:	0f b6 c0             	movzbl %al,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <opencons>:
{
  801551:	f3 0f 1e fb          	endbr32 
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80155b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	e8 70 ee ff ff       	call   8003d4 <fd_alloc>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 3a                	js     8015a5 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	68 07 04 00 00       	push   $0x407
  801573:	ff 75 f4             	pushl  -0xc(%ebp)
  801576:	6a 00                	push   $0x0
  801578:	e8 f4 eb ff ff       	call   800171 <sys_page_alloc>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 21                	js     8015a5 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801587:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80158d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	50                   	push   %eax
  80159d:	e8 03 ee ff ff       	call   8003a5 <fd2num>
  8015a2:	83 c4 10             	add    $0x10,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015a7:	f3 0f 1e fb          	endbr32 
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015b0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015b3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015b9:	e8 6d eb ff ff       	call   80012b <sys_getenvid>
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	56                   	push   %esi
  8015c8:	50                   	push   %eax
  8015c9:	68 20 25 80 00       	push   $0x802520
  8015ce:	e8 bb 00 00 00       	call   80168e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015d3:	83 c4 18             	add    $0x18,%esp
  8015d6:	53                   	push   %ebx
  8015d7:	ff 75 10             	pushl  0x10(%ebp)
  8015da:	e8 5a 00 00 00       	call   801639 <vcprintf>
	cprintf("\n");
  8015df:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  8015e6:	e8 a3 00 00 00       	call   80168e <cprintf>
  8015eb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8015ee:	cc                   	int3   
  8015ef:	eb fd                	jmp    8015ee <_panic+0x47>

008015f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8015f1:	f3 0f 1e fb          	endbr32 
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8015ff:	8b 13                	mov    (%ebx),%edx
  801601:	8d 42 01             	lea    0x1(%edx),%eax
  801604:	89 03                	mov    %eax,(%ebx)
  801606:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801609:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80160d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801612:	74 09                	je     80161d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801614:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	68 ff 00 00 00       	push   $0xff
  801625:	8d 43 08             	lea    0x8(%ebx),%eax
  801628:	50                   	push   %eax
  801629:	e8 73 ea ff ff       	call   8000a1 <sys_cputs>
		b->idx = 0;
  80162e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	eb db                	jmp    801614 <putch+0x23>

00801639 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801639:	f3 0f 1e fb          	endbr32 
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80164d:	00 00 00 
	b.cnt = 0;
  801650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801657:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80165a:	ff 75 0c             	pushl  0xc(%ebp)
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	68 f1 15 80 00       	push   $0x8015f1
  80166c:	e8 20 01 00 00       	call   801791 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801671:	83 c4 08             	add    $0x8,%esp
  801674:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80167a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801680:	50                   	push   %eax
  801681:	e8 1b ea ff ff       	call   8000a1 <sys_cputs>

	return b.cnt;
}
  801686:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80168e:	f3 0f 1e fb          	endbr32 
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801698:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80169b:	50                   	push   %eax
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	e8 95 ff ff ff       	call   801639 <vcprintf>
	va_end(ap);

	return cnt;
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	57                   	push   %edi
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 1c             	sub    $0x1c,%esp
  8016af:	89 c7                	mov    %eax,%edi
  8016b1:	89 d6                	mov    %edx,%esi
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b9:	89 d1                	mov    %edx,%ecx
  8016bb:	89 c2                	mov    %eax,%edx
  8016bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d3:	39 c2                	cmp    %eax,%edx
  8016d5:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016d8:	72 3e                	jb     801718 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	ff 75 18             	pushl  0x18(%ebp)
  8016e0:	83 eb 01             	sub    $0x1,%ebx
  8016e3:	53                   	push   %ebx
  8016e4:	50                   	push   %eax
  8016e5:	83 ec 08             	sub    $0x8,%esp
  8016e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8016ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8016f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8016f4:	e8 67 0a 00 00       	call   802160 <__udivdi3>
  8016f9:	83 c4 18             	add    $0x18,%esp
  8016fc:	52                   	push   %edx
  8016fd:	50                   	push   %eax
  8016fe:	89 f2                	mov    %esi,%edx
  801700:	89 f8                	mov    %edi,%eax
  801702:	e8 9f ff ff ff       	call   8016a6 <printnum>
  801707:	83 c4 20             	add    $0x20,%esp
  80170a:	eb 13                	jmp    80171f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80170c:	83 ec 08             	sub    $0x8,%esp
  80170f:	56                   	push   %esi
  801710:	ff 75 18             	pushl  0x18(%ebp)
  801713:	ff d7                	call   *%edi
  801715:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801718:	83 eb 01             	sub    $0x1,%ebx
  80171b:	85 db                	test   %ebx,%ebx
  80171d:	7f ed                	jg     80170c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	56                   	push   %esi
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	ff 75 e4             	pushl  -0x1c(%ebp)
  801729:	ff 75 e0             	pushl  -0x20(%ebp)
  80172c:	ff 75 dc             	pushl  -0x24(%ebp)
  80172f:	ff 75 d8             	pushl  -0x28(%ebp)
  801732:	e8 39 0b 00 00       	call   802270 <__umoddi3>
  801737:	83 c4 14             	add    $0x14,%esp
  80173a:	0f be 80 43 25 80 00 	movsbl 0x802543(%eax),%eax
  801741:	50                   	push   %eax
  801742:	ff d7                	call   *%edi
}
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80174f:	f3 0f 1e fb          	endbr32 
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801759:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80175d:	8b 10                	mov    (%eax),%edx
  80175f:	3b 50 04             	cmp    0x4(%eax),%edx
  801762:	73 0a                	jae    80176e <sprintputch+0x1f>
		*b->buf++ = ch;
  801764:	8d 4a 01             	lea    0x1(%edx),%ecx
  801767:	89 08                	mov    %ecx,(%eax)
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	88 02                	mov    %al,(%edx)
}
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <printfmt>:
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80177a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80177d:	50                   	push   %eax
  80177e:	ff 75 10             	pushl  0x10(%ebp)
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 05 00 00 00       	call   801791 <vprintfmt>
}
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <vprintfmt>:
{
  801791:	f3 0f 1e fb          	endbr32 
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	57                   	push   %edi
  801799:	56                   	push   %esi
  80179a:	53                   	push   %ebx
  80179b:	83 ec 3c             	sub    $0x3c,%esp
  80179e:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017a4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017a7:	e9 8e 03 00 00       	jmp    801b3a <vprintfmt+0x3a9>
		padc = ' ';
  8017ac:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017b0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017b7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017be:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017c5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017ca:	8d 47 01             	lea    0x1(%edi),%eax
  8017cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d0:	0f b6 17             	movzbl (%edi),%edx
  8017d3:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017d6:	3c 55                	cmp    $0x55,%al
  8017d8:	0f 87 df 03 00 00    	ja     801bbd <vprintfmt+0x42c>
  8017de:	0f b6 c0             	movzbl %al,%eax
  8017e1:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  8017e8:	00 
  8017e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8017ec:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8017f0:	eb d8                	jmp    8017ca <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017f5:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8017f9:	eb cf                	jmp    8017ca <vprintfmt+0x39>
  8017fb:	0f b6 d2             	movzbl %dl,%edx
  8017fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801809:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80180c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801810:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801813:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801816:	83 f9 09             	cmp    $0x9,%ecx
  801819:	77 55                	ja     801870 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80181b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80181e:	eb e9                	jmp    801809 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801820:	8b 45 14             	mov    0x14(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801828:	8b 45 14             	mov    0x14(%ebp),%eax
  80182b:	8d 40 04             	lea    0x4(%eax),%eax
  80182e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801831:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801834:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801838:	79 90                	jns    8017ca <vprintfmt+0x39>
				width = precision, precision = -1;
  80183a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80183d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801840:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801847:	eb 81                	jmp    8017ca <vprintfmt+0x39>
  801849:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184c:	85 c0                	test   %eax,%eax
  80184e:	ba 00 00 00 00       	mov    $0x0,%edx
  801853:	0f 49 d0             	cmovns %eax,%edx
  801856:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801859:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80185c:	e9 69 ff ff ff       	jmp    8017ca <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801861:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801864:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80186b:	e9 5a ff ff ff       	jmp    8017ca <vprintfmt+0x39>
  801870:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801873:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801876:	eb bc                	jmp    801834 <vprintfmt+0xa3>
			lflag++;
  801878:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80187b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80187e:	e9 47 ff ff ff       	jmp    8017ca <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801883:	8b 45 14             	mov    0x14(%ebp),%eax
  801886:	8d 78 04             	lea    0x4(%eax),%edi
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	53                   	push   %ebx
  80188d:	ff 30                	pushl  (%eax)
  80188f:	ff d6                	call   *%esi
			break;
  801891:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801894:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801897:	e9 9b 02 00 00       	jmp    801b37 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80189c:	8b 45 14             	mov    0x14(%ebp),%eax
  80189f:	8d 78 04             	lea    0x4(%eax),%edi
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	99                   	cltd   
  8018a5:	31 d0                	xor    %edx,%eax
  8018a7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018a9:	83 f8 0f             	cmp    $0xf,%eax
  8018ac:	7f 23                	jg     8018d1 <vprintfmt+0x140>
  8018ae:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8018b5:	85 d2                	test   %edx,%edx
  8018b7:	74 18                	je     8018d1 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018b9:	52                   	push   %edx
  8018ba:	68 a1 24 80 00       	push   $0x8024a1
  8018bf:	53                   	push   %ebx
  8018c0:	56                   	push   %esi
  8018c1:	e8 aa fe ff ff       	call   801770 <printfmt>
  8018c6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018c9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018cc:	e9 66 02 00 00       	jmp    801b37 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018d1:	50                   	push   %eax
  8018d2:	68 5b 25 80 00       	push   $0x80255b
  8018d7:	53                   	push   %ebx
  8018d8:	56                   	push   %esi
  8018d9:	e8 92 fe ff ff       	call   801770 <printfmt>
  8018de:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018e1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018e4:	e9 4e 02 00 00       	jmp    801b37 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ec:	83 c0 04             	add    $0x4,%eax
  8018ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f5:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8018f7:	85 d2                	test   %edx,%edx
  8018f9:	b8 54 25 80 00       	mov    $0x802554,%eax
  8018fe:	0f 45 c2             	cmovne %edx,%eax
  801901:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801908:	7e 06                	jle    801910 <vprintfmt+0x17f>
  80190a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80190e:	75 0d                	jne    80191d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801910:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801913:	89 c7                	mov    %eax,%edi
  801915:	03 45 e0             	add    -0x20(%ebp),%eax
  801918:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80191b:	eb 55                	jmp    801972 <vprintfmt+0x1e1>
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	ff 75 d8             	pushl  -0x28(%ebp)
  801923:	ff 75 cc             	pushl  -0x34(%ebp)
  801926:	e8 46 03 00 00       	call   801c71 <strnlen>
  80192b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192e:	29 c2                	sub    %eax,%edx
  801930:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801938:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80193c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80193f:	85 ff                	test   %edi,%edi
  801941:	7e 11                	jle    801954 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	53                   	push   %ebx
  801947:	ff 75 e0             	pushl  -0x20(%ebp)
  80194a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80194c:	83 ef 01             	sub    $0x1,%edi
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	eb eb                	jmp    80193f <vprintfmt+0x1ae>
  801954:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801957:	85 d2                	test   %edx,%edx
  801959:	b8 00 00 00 00       	mov    $0x0,%eax
  80195e:	0f 49 c2             	cmovns %edx,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801966:	eb a8                	jmp    801910 <vprintfmt+0x17f>
					putch(ch, putdat);
  801968:	83 ec 08             	sub    $0x8,%esp
  80196b:	53                   	push   %ebx
  80196c:	52                   	push   %edx
  80196d:	ff d6                	call   *%esi
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801975:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801977:	83 c7 01             	add    $0x1,%edi
  80197a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80197e:	0f be d0             	movsbl %al,%edx
  801981:	85 d2                	test   %edx,%edx
  801983:	74 4b                	je     8019d0 <vprintfmt+0x23f>
  801985:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801989:	78 06                	js     801991 <vprintfmt+0x200>
  80198b:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80198f:	78 1e                	js     8019af <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801991:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801995:	74 d1                	je     801968 <vprintfmt+0x1d7>
  801997:	0f be c0             	movsbl %al,%eax
  80199a:	83 e8 20             	sub    $0x20,%eax
  80199d:	83 f8 5e             	cmp    $0x5e,%eax
  8019a0:	76 c6                	jbe    801968 <vprintfmt+0x1d7>
					putch('?', putdat);
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	53                   	push   %ebx
  8019a6:	6a 3f                	push   $0x3f
  8019a8:	ff d6                	call   *%esi
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	eb c3                	jmp    801972 <vprintfmt+0x1e1>
  8019af:	89 cf                	mov    %ecx,%edi
  8019b1:	eb 0e                	jmp    8019c1 <vprintfmt+0x230>
				putch(' ', putdat);
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	53                   	push   %ebx
  8019b7:	6a 20                	push   $0x20
  8019b9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019bb:	83 ef 01             	sub    $0x1,%edi
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 ff                	test   %edi,%edi
  8019c3:	7f ee                	jg     8019b3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8019cb:	e9 67 01 00 00       	jmp    801b37 <vprintfmt+0x3a6>
  8019d0:	89 cf                	mov    %ecx,%edi
  8019d2:	eb ed                	jmp    8019c1 <vprintfmt+0x230>
	if (lflag >= 2)
  8019d4:	83 f9 01             	cmp    $0x1,%ecx
  8019d7:	7f 1b                	jg     8019f4 <vprintfmt+0x263>
	else if (lflag)
  8019d9:	85 c9                	test   %ecx,%ecx
  8019db:	74 63                	je     801a40 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e0:	8b 00                	mov    (%eax),%eax
  8019e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e5:	99                   	cltd   
  8019e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ec:	8d 40 04             	lea    0x4(%eax),%eax
  8019ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f2:	eb 17                	jmp    801a0b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	8b 50 04             	mov    0x4(%eax),%edx
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a02:	8b 45 14             	mov    0x14(%ebp),%eax
  801a05:	8d 40 08             	lea    0x8(%eax),%eax
  801a08:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a0e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a11:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a16:	85 c9                	test   %ecx,%ecx
  801a18:	0f 89 ff 00 00 00    	jns    801b1d <vprintfmt+0x38c>
				putch('-', putdat);
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	53                   	push   %ebx
  801a22:	6a 2d                	push   $0x2d
  801a24:	ff d6                	call   *%esi
				num = -(long long) num;
  801a26:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a29:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a2c:	f7 da                	neg    %edx
  801a2e:	83 d1 00             	adc    $0x0,%ecx
  801a31:	f7 d9                	neg    %ecx
  801a33:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a36:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a3b:	e9 dd 00 00 00       	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a40:	8b 45 14             	mov    0x14(%ebp),%eax
  801a43:	8b 00                	mov    (%eax),%eax
  801a45:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a48:	99                   	cltd   
  801a49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	8d 40 04             	lea    0x4(%eax),%eax
  801a52:	89 45 14             	mov    %eax,0x14(%ebp)
  801a55:	eb b4                	jmp    801a0b <vprintfmt+0x27a>
	if (lflag >= 2)
  801a57:	83 f9 01             	cmp    $0x1,%ecx
  801a5a:	7f 1e                	jg     801a7a <vprintfmt+0x2e9>
	else if (lflag)
  801a5c:	85 c9                	test   %ecx,%ecx
  801a5e:	74 32                	je     801a92 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a60:	8b 45 14             	mov    0x14(%ebp),%eax
  801a63:	8b 10                	mov    (%eax),%edx
  801a65:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6a:	8d 40 04             	lea    0x4(%eax),%eax
  801a6d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a70:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a75:	e9 a3 00 00 00       	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 10                	mov    (%eax),%edx
  801a7f:	8b 48 04             	mov    0x4(%eax),%ecx
  801a82:	8d 40 08             	lea    0x8(%eax),%eax
  801a85:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a88:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a8d:	e9 8b 00 00 00       	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	8b 10                	mov    (%eax),%edx
  801a97:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9c:	8d 40 04             	lea    0x4(%eax),%eax
  801a9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aa2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801aa7:	eb 74                	jmp    801b1d <vprintfmt+0x38c>
	if (lflag >= 2)
  801aa9:	83 f9 01             	cmp    $0x1,%ecx
  801aac:	7f 1b                	jg     801ac9 <vprintfmt+0x338>
	else if (lflag)
  801aae:	85 c9                	test   %ecx,%ecx
  801ab0:	74 2c                	je     801ade <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab5:	8b 10                	mov    (%eax),%edx
  801ab7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abc:	8d 40 04             	lea    0x4(%eax),%eax
  801abf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ac2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801ac7:	eb 54                	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	8b 10                	mov    (%eax),%edx
  801ace:	8b 48 04             	mov    0x4(%eax),%ecx
  801ad1:	8d 40 08             	lea    0x8(%eax),%eax
  801ad4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ad7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801adc:	eb 3f                	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	8b 10                	mov    (%eax),%edx
  801ae3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae8:	8d 40 04             	lea    0x4(%eax),%eax
  801aeb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801aee:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801af3:	eb 28                	jmp    801b1d <vprintfmt+0x38c>
			putch('0', putdat);
  801af5:	83 ec 08             	sub    $0x8,%esp
  801af8:	53                   	push   %ebx
  801af9:	6a 30                	push   $0x30
  801afb:	ff d6                	call   *%esi
			putch('x', putdat);
  801afd:	83 c4 08             	add    $0x8,%esp
  801b00:	53                   	push   %ebx
  801b01:	6a 78                	push   $0x78
  801b03:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b05:	8b 45 14             	mov    0x14(%ebp),%eax
  801b08:	8b 10                	mov    (%eax),%edx
  801b0a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b0f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b12:	8d 40 04             	lea    0x4(%eax),%eax
  801b15:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b18:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b24:	57                   	push   %edi
  801b25:	ff 75 e0             	pushl  -0x20(%ebp)
  801b28:	50                   	push   %eax
  801b29:	51                   	push   %ecx
  801b2a:	52                   	push   %edx
  801b2b:	89 da                	mov    %ebx,%edx
  801b2d:	89 f0                	mov    %esi,%eax
  801b2f:	e8 72 fb ff ff       	call   8016a6 <printnum>
			break;
  801b34:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b3a:	83 c7 01             	add    $0x1,%edi
  801b3d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b41:	83 f8 25             	cmp    $0x25,%eax
  801b44:	0f 84 62 fc ff ff    	je     8017ac <vprintfmt+0x1b>
			if (ch == '\0')
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	0f 84 8b 00 00 00    	je     801bdd <vprintfmt+0x44c>
			putch(ch, putdat);
  801b52:	83 ec 08             	sub    $0x8,%esp
  801b55:	53                   	push   %ebx
  801b56:	50                   	push   %eax
  801b57:	ff d6                	call   *%esi
  801b59:	83 c4 10             	add    $0x10,%esp
  801b5c:	eb dc                	jmp    801b3a <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b5e:	83 f9 01             	cmp    $0x1,%ecx
  801b61:	7f 1b                	jg     801b7e <vprintfmt+0x3ed>
	else if (lflag)
  801b63:	85 c9                	test   %ecx,%ecx
  801b65:	74 2c                	je     801b93 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b67:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6a:	8b 10                	mov    (%eax),%edx
  801b6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b71:	8d 40 04             	lea    0x4(%eax),%eax
  801b74:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b77:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b7c:	eb 9f                	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 10                	mov    (%eax),%edx
  801b83:	8b 48 04             	mov    0x4(%eax),%ecx
  801b86:	8d 40 08             	lea    0x8(%eax),%eax
  801b89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b8c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801b91:	eb 8a                	jmp    801b1d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b93:	8b 45 14             	mov    0x14(%ebp),%eax
  801b96:	8b 10                	mov    (%eax),%edx
  801b98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9d:	8d 40 04             	lea    0x4(%eax),%eax
  801ba0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801ba8:	e9 70 ff ff ff       	jmp    801b1d <vprintfmt+0x38c>
			putch(ch, putdat);
  801bad:	83 ec 08             	sub    $0x8,%esp
  801bb0:	53                   	push   %ebx
  801bb1:	6a 25                	push   $0x25
  801bb3:	ff d6                	call   *%esi
			break;
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	e9 7a ff ff ff       	jmp    801b37 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bbd:	83 ec 08             	sub    $0x8,%esp
  801bc0:	53                   	push   %ebx
  801bc1:	6a 25                	push   $0x25
  801bc3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bc5:	83 c4 10             	add    $0x10,%esp
  801bc8:	89 f8                	mov    %edi,%eax
  801bca:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bce:	74 05                	je     801bd5 <vprintfmt+0x444>
  801bd0:	83 e8 01             	sub    $0x1,%eax
  801bd3:	eb f5                	jmp    801bca <vprintfmt+0x439>
  801bd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bd8:	e9 5a ff ff ff       	jmp    801b37 <vprintfmt+0x3a6>
}
  801bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801be5:	f3 0f 1e fb          	endbr32 
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 18             	sub    $0x18,%esp
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bfc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801bff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c06:	85 c0                	test   %eax,%eax
  801c08:	74 26                	je     801c30 <vsnprintf+0x4b>
  801c0a:	85 d2                	test   %edx,%edx
  801c0c:	7e 22                	jle    801c30 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c0e:	ff 75 14             	pushl  0x14(%ebp)
  801c11:	ff 75 10             	pushl  0x10(%ebp)
  801c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c17:	50                   	push   %eax
  801c18:	68 4f 17 80 00       	push   $0x80174f
  801c1d:	e8 6f fb ff ff       	call   801791 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c25:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	83 c4 10             	add    $0x10,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    
		return -E_INVAL;
  801c30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c35:	eb f7                	jmp    801c2e <vsnprintf+0x49>

00801c37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c37:	f3 0f 1e fb          	endbr32 
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c41:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c44:	50                   	push   %eax
  801c45:	ff 75 10             	pushl  0x10(%ebp)
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 92 ff ff ff       	call   801be5 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c55:	f3 0f 1e fb          	endbr32 
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c64:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c68:	74 05                	je     801c6f <strlen+0x1a>
		n++;
  801c6a:	83 c0 01             	add    $0x1,%eax
  801c6d:	eb f5                	jmp    801c64 <strlen+0xf>
	return n;
}
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    

00801c71 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c71:	f3 0f 1e fb          	endbr32 
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	39 d0                	cmp    %edx,%eax
  801c85:	74 0d                	je     801c94 <strnlen+0x23>
  801c87:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c8b:	74 05                	je     801c92 <strnlen+0x21>
		n++;
  801c8d:	83 c0 01             	add    $0x1,%eax
  801c90:	eb f1                	jmp    801c83 <strnlen+0x12>
  801c92:	89 c2                	mov    %eax,%edx
	return n;
}
  801c94:	89 d0                	mov    %edx,%eax
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    

00801c98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c98:	f3 0f 1e fb          	endbr32 
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
  801ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cab:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801caf:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cb2:	83 c0 01             	add    $0x1,%eax
  801cb5:	84 d2                	test   %dl,%dl
  801cb7:	75 f2                	jne    801cab <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cb9:	89 c8                	mov    %ecx,%eax
  801cbb:	5b                   	pop    %ebx
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cbe:	f3 0f 1e fb          	endbr32 
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	53                   	push   %ebx
  801cc6:	83 ec 10             	sub    $0x10,%esp
  801cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ccc:	53                   	push   %ebx
  801ccd:	e8 83 ff ff ff       	call   801c55 <strlen>
  801cd2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	01 d8                	add    %ebx,%eax
  801cda:	50                   	push   %eax
  801cdb:	e8 b8 ff ff ff       	call   801c98 <strcpy>
	return dst;
}
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ce7:	f3 0f 1e fb          	endbr32 
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	89 f3                	mov    %esi,%ebx
  801cf8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801cfb:	89 f0                	mov    %esi,%eax
  801cfd:	39 d8                	cmp    %ebx,%eax
  801cff:	74 11                	je     801d12 <strncpy+0x2b>
		*dst++ = *src;
  801d01:	83 c0 01             	add    $0x1,%eax
  801d04:	0f b6 0a             	movzbl (%edx),%ecx
  801d07:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d0a:	80 f9 01             	cmp    $0x1,%cl
  801d0d:	83 da ff             	sbb    $0xffffffff,%edx
  801d10:	eb eb                	jmp    801cfd <strncpy+0x16>
	}
	return ret;
}
  801d12:	89 f0                	mov    %esi,%eax
  801d14:	5b                   	pop    %ebx
  801d15:	5e                   	pop    %esi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    

00801d18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d18:	f3 0f 1e fb          	endbr32 
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	56                   	push   %esi
  801d20:	53                   	push   %ebx
  801d21:	8b 75 08             	mov    0x8(%ebp),%esi
  801d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d27:	8b 55 10             	mov    0x10(%ebp),%edx
  801d2a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d2c:	85 d2                	test   %edx,%edx
  801d2e:	74 21                	je     801d51 <strlcpy+0x39>
  801d30:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d34:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d36:	39 c2                	cmp    %eax,%edx
  801d38:	74 14                	je     801d4e <strlcpy+0x36>
  801d3a:	0f b6 19             	movzbl (%ecx),%ebx
  801d3d:	84 db                	test   %bl,%bl
  801d3f:	74 0b                	je     801d4c <strlcpy+0x34>
			*dst++ = *src++;
  801d41:	83 c1 01             	add    $0x1,%ecx
  801d44:	83 c2 01             	add    $0x1,%edx
  801d47:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d4a:	eb ea                	jmp    801d36 <strlcpy+0x1e>
  801d4c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d4e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d51:	29 f0                	sub    %esi,%eax
}
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    

00801d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d57:	f3 0f 1e fb          	endbr32 
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d64:	0f b6 01             	movzbl (%ecx),%eax
  801d67:	84 c0                	test   %al,%al
  801d69:	74 0c                	je     801d77 <strcmp+0x20>
  801d6b:	3a 02                	cmp    (%edx),%al
  801d6d:	75 08                	jne    801d77 <strcmp+0x20>
		p++, q++;
  801d6f:	83 c1 01             	add    $0x1,%ecx
  801d72:	83 c2 01             	add    $0x1,%edx
  801d75:	eb ed                	jmp    801d64 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d77:	0f b6 c0             	movzbl %al,%eax
  801d7a:	0f b6 12             	movzbl (%edx),%edx
  801d7d:	29 d0                	sub    %edx,%eax
}
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d81:	f3 0f 1e fb          	endbr32 
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d94:	eb 06                	jmp    801d9c <strncmp+0x1b>
		n--, p++, q++;
  801d96:	83 c0 01             	add    $0x1,%eax
  801d99:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d9c:	39 d8                	cmp    %ebx,%eax
  801d9e:	74 16                	je     801db6 <strncmp+0x35>
  801da0:	0f b6 08             	movzbl (%eax),%ecx
  801da3:	84 c9                	test   %cl,%cl
  801da5:	74 04                	je     801dab <strncmp+0x2a>
  801da7:	3a 0a                	cmp    (%edx),%cl
  801da9:	74 eb                	je     801d96 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dab:	0f b6 00             	movzbl (%eax),%eax
  801dae:	0f b6 12             	movzbl (%edx),%edx
  801db1:	29 d0                	sub    %edx,%eax
}
  801db3:	5b                   	pop    %ebx
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
		return 0;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	eb f6                	jmp    801db3 <strncmp+0x32>

00801dbd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dbd:	f3 0f 1e fb          	endbr32 
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dcb:	0f b6 10             	movzbl (%eax),%edx
  801dce:	84 d2                	test   %dl,%dl
  801dd0:	74 09                	je     801ddb <strchr+0x1e>
		if (*s == c)
  801dd2:	38 ca                	cmp    %cl,%dl
  801dd4:	74 0a                	je     801de0 <strchr+0x23>
	for (; *s; s++)
  801dd6:	83 c0 01             	add    $0x1,%eax
  801dd9:	eb f0                	jmp    801dcb <strchr+0xe>
			return (char *) s;
	return 0;
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de0:	5d                   	pop    %ebp
  801de1:	c3                   	ret    

00801de2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801de2:	f3 0f 1e fb          	endbr32 
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801df0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801df3:	38 ca                	cmp    %cl,%dl
  801df5:	74 09                	je     801e00 <strfind+0x1e>
  801df7:	84 d2                	test   %dl,%dl
  801df9:	74 05                	je     801e00 <strfind+0x1e>
	for (; *s; s++)
  801dfb:	83 c0 01             	add    $0x1,%eax
  801dfe:	eb f0                	jmp    801df0 <strfind+0xe>
			break;
	return (char *) s;
}
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e02:	f3 0f 1e fb          	endbr32 
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	57                   	push   %edi
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e12:	85 c9                	test   %ecx,%ecx
  801e14:	74 31                	je     801e47 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e16:	89 f8                	mov    %edi,%eax
  801e18:	09 c8                	or     %ecx,%eax
  801e1a:	a8 03                	test   $0x3,%al
  801e1c:	75 23                	jne    801e41 <memset+0x3f>
		c &= 0xFF;
  801e1e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e22:	89 d3                	mov    %edx,%ebx
  801e24:	c1 e3 08             	shl    $0x8,%ebx
  801e27:	89 d0                	mov    %edx,%eax
  801e29:	c1 e0 18             	shl    $0x18,%eax
  801e2c:	89 d6                	mov    %edx,%esi
  801e2e:	c1 e6 10             	shl    $0x10,%esi
  801e31:	09 f0                	or     %esi,%eax
  801e33:	09 c2                	or     %eax,%edx
  801e35:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e37:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	fc                   	cld    
  801e3d:	f3 ab                	rep stos %eax,%es:(%edi)
  801e3f:	eb 06                	jmp    801e47 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e44:	fc                   	cld    
  801e45:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e47:	89 f8                	mov    %edi,%eax
  801e49:	5b                   	pop    %ebx
  801e4a:	5e                   	pop    %esi
  801e4b:	5f                   	pop    %edi
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e4e:	f3 0f 1e fb          	endbr32 
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e60:	39 c6                	cmp    %eax,%esi
  801e62:	73 32                	jae    801e96 <memmove+0x48>
  801e64:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e67:	39 c2                	cmp    %eax,%edx
  801e69:	76 2b                	jbe    801e96 <memmove+0x48>
		s += n;
		d += n;
  801e6b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e6e:	89 fe                	mov    %edi,%esi
  801e70:	09 ce                	or     %ecx,%esi
  801e72:	09 d6                	or     %edx,%esi
  801e74:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e7a:	75 0e                	jne    801e8a <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e7c:	83 ef 04             	sub    $0x4,%edi
  801e7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e82:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e85:	fd                   	std    
  801e86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e88:	eb 09                	jmp    801e93 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e8a:	83 ef 01             	sub    $0x1,%edi
  801e8d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e90:	fd                   	std    
  801e91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e93:	fc                   	cld    
  801e94:	eb 1a                	jmp    801eb0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e96:	89 c2                	mov    %eax,%edx
  801e98:	09 ca                	or     %ecx,%edx
  801e9a:	09 f2                	or     %esi,%edx
  801e9c:	f6 c2 03             	test   $0x3,%dl
  801e9f:	75 0a                	jne    801eab <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ea1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ea4:	89 c7                	mov    %eax,%edi
  801ea6:	fc                   	cld    
  801ea7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ea9:	eb 05                	jmp    801eb0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801eab:	89 c7                	mov    %eax,%edi
  801ead:	fc                   	cld    
  801eae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    

00801eb4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801eb4:	f3 0f 1e fb          	endbr32 
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ebe:	ff 75 10             	pushl  0x10(%ebp)
  801ec1:	ff 75 0c             	pushl  0xc(%ebp)
  801ec4:	ff 75 08             	pushl  0x8(%ebp)
  801ec7:	e8 82 ff ff ff       	call   801e4e <memmove>
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ece:	f3 0f 1e fb          	endbr32 
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	56                   	push   %esi
  801ed6:	53                   	push   %ebx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	89 c6                	mov    %eax,%esi
  801edf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ee2:	39 f0                	cmp    %esi,%eax
  801ee4:	74 1c                	je     801f02 <memcmp+0x34>
		if (*s1 != *s2)
  801ee6:	0f b6 08             	movzbl (%eax),%ecx
  801ee9:	0f b6 1a             	movzbl (%edx),%ebx
  801eec:	38 d9                	cmp    %bl,%cl
  801eee:	75 08                	jne    801ef8 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801ef0:	83 c0 01             	add    $0x1,%eax
  801ef3:	83 c2 01             	add    $0x1,%edx
  801ef6:	eb ea                	jmp    801ee2 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801ef8:	0f b6 c1             	movzbl %cl,%eax
  801efb:	0f b6 db             	movzbl %bl,%ebx
  801efe:	29 d8                	sub    %ebx,%eax
  801f00:	eb 05                	jmp    801f07 <memcmp+0x39>
	}

	return 0;
  801f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    

00801f0b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f0b:	f3 0f 1e fb          	endbr32 
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f18:	89 c2                	mov    %eax,%edx
  801f1a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f1d:	39 d0                	cmp    %edx,%eax
  801f1f:	73 09                	jae    801f2a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f21:	38 08                	cmp    %cl,(%eax)
  801f23:	74 05                	je     801f2a <memfind+0x1f>
	for (; s < ends; s++)
  801f25:	83 c0 01             	add    $0x1,%eax
  801f28:	eb f3                	jmp    801f1d <memfind+0x12>
			break;
	return (void *) s;
}
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    

00801f2c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f2c:	f3 0f 1e fb          	endbr32 
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	57                   	push   %edi
  801f34:	56                   	push   %esi
  801f35:	53                   	push   %ebx
  801f36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f3c:	eb 03                	jmp    801f41 <strtol+0x15>
		s++;
  801f3e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f41:	0f b6 01             	movzbl (%ecx),%eax
  801f44:	3c 20                	cmp    $0x20,%al
  801f46:	74 f6                	je     801f3e <strtol+0x12>
  801f48:	3c 09                	cmp    $0x9,%al
  801f4a:	74 f2                	je     801f3e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f4c:	3c 2b                	cmp    $0x2b,%al
  801f4e:	74 2a                	je     801f7a <strtol+0x4e>
	int neg = 0;
  801f50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f55:	3c 2d                	cmp    $0x2d,%al
  801f57:	74 2b                	je     801f84 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f59:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f5f:	75 0f                	jne    801f70 <strtol+0x44>
  801f61:	80 39 30             	cmpb   $0x30,(%ecx)
  801f64:	74 28                	je     801f8e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f66:	85 db                	test   %ebx,%ebx
  801f68:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f6d:	0f 44 d8             	cmove  %eax,%ebx
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
  801f75:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f78:	eb 46                	jmp    801fc0 <strtol+0x94>
		s++;
  801f7a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f7d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f82:	eb d5                	jmp    801f59 <strtol+0x2d>
		s++, neg = 1;
  801f84:	83 c1 01             	add    $0x1,%ecx
  801f87:	bf 01 00 00 00       	mov    $0x1,%edi
  801f8c:	eb cb                	jmp    801f59 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f92:	74 0e                	je     801fa2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f94:	85 db                	test   %ebx,%ebx
  801f96:	75 d8                	jne    801f70 <strtol+0x44>
		s++, base = 8;
  801f98:	83 c1 01             	add    $0x1,%ecx
  801f9b:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fa0:	eb ce                	jmp    801f70 <strtol+0x44>
		s += 2, base = 16;
  801fa2:	83 c1 02             	add    $0x2,%ecx
  801fa5:	bb 10 00 00 00       	mov    $0x10,%ebx
  801faa:	eb c4                	jmp    801f70 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fac:	0f be d2             	movsbl %dl,%edx
  801faf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fb2:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fb5:	7d 3a                	jge    801ff1 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fb7:	83 c1 01             	add    $0x1,%ecx
  801fba:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fbe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fc0:	0f b6 11             	movzbl (%ecx),%edx
  801fc3:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fc6:	89 f3                	mov    %esi,%ebx
  801fc8:	80 fb 09             	cmp    $0x9,%bl
  801fcb:	76 df                	jbe    801fac <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fcd:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fd0:	89 f3                	mov    %esi,%ebx
  801fd2:	80 fb 19             	cmp    $0x19,%bl
  801fd5:	77 08                	ja     801fdf <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fd7:	0f be d2             	movsbl %dl,%edx
  801fda:	83 ea 57             	sub    $0x57,%edx
  801fdd:	eb d3                	jmp    801fb2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801fdf:	8d 72 bf             	lea    -0x41(%edx),%esi
  801fe2:	89 f3                	mov    %esi,%ebx
  801fe4:	80 fb 19             	cmp    $0x19,%bl
  801fe7:	77 08                	ja     801ff1 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801fe9:	0f be d2             	movsbl %dl,%edx
  801fec:	83 ea 37             	sub    $0x37,%edx
  801fef:	eb c1                	jmp    801fb2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ff1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ff5:	74 05                	je     801ffc <strtol+0xd0>
		*endptr = (char *) s;
  801ff7:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ffa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ffc:	89 c2                	mov    %eax,%edx
  801ffe:	f7 da                	neg    %edx
  802000:	85 ff                	test   %edi,%edi
  802002:	0f 45 c2             	cmovne %edx,%eax
}
  802005:	5b                   	pop    %ebx
  802006:	5e                   	pop    %esi
  802007:	5f                   	pop    %edi
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80200a:	f3 0f 1e fb          	endbr32 
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	8b 75 08             	mov    0x8(%ebp),%esi
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80201c:	83 e8 01             	sub    $0x1,%eax
  80201f:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802024:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802029:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	50                   	push   %eax
  802031:	e8 07 e3 ff ff       	call   80033d <sys_ipc_recv>
	if (!t) {
  802036:	83 c4 10             	add    $0x10,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	75 2b                	jne    802068 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80203d:	85 f6                	test   %esi,%esi
  80203f:	74 0a                	je     80204b <ipc_recv+0x41>
  802041:	a1 08 40 80 00       	mov    0x804008,%eax
  802046:	8b 40 74             	mov    0x74(%eax),%eax
  802049:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80204b:	85 db                	test   %ebx,%ebx
  80204d:	74 0a                	je     802059 <ipc_recv+0x4f>
  80204f:	a1 08 40 80 00       	mov    0x804008,%eax
  802054:	8b 40 78             	mov    0x78(%eax),%eax
  802057:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802059:	a1 08 40 80 00       	mov    0x804008,%eax
  80205e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802061:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802064:	5b                   	pop    %ebx
  802065:	5e                   	pop    %esi
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802068:	85 f6                	test   %esi,%esi
  80206a:	74 06                	je     802072 <ipc_recv+0x68>
  80206c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802072:	85 db                	test   %ebx,%ebx
  802074:	74 eb                	je     802061 <ipc_recv+0x57>
  802076:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80207c:	eb e3                	jmp    802061 <ipc_recv+0x57>

0080207e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80207e:	f3 0f 1e fb          	endbr32 
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	57                   	push   %edi
  802086:	56                   	push   %esi
  802087:	53                   	push   %ebx
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80208e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802091:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802094:	85 db                	test   %ebx,%ebx
  802096:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80209b:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80209e:	ff 75 14             	pushl  0x14(%ebp)
  8020a1:	53                   	push   %ebx
  8020a2:	56                   	push   %esi
  8020a3:	57                   	push   %edi
  8020a4:	e8 6d e2 ff ff       	call   800316 <sys_ipc_try_send>
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	74 1e                	je     8020ce <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020b0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020b3:	75 07                	jne    8020bc <ipc_send+0x3e>
		sys_yield();
  8020b5:	e8 94 e0 ff ff       	call   80014e <sys_yield>
  8020ba:	eb e2                	jmp    80209e <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020bc:	50                   	push   %eax
  8020bd:	68 3f 28 80 00       	push   $0x80283f
  8020c2:	6a 39                	push   $0x39
  8020c4:	68 51 28 80 00       	push   $0x802851
  8020c9:	e8 d9 f4 ff ff       	call   8015a7 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020d6:	f3 0f 1e fb          	endbr32 
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020e5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020e8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020ee:	8b 52 50             	mov    0x50(%edx),%edx
  8020f1:	39 ca                	cmp    %ecx,%edx
  8020f3:	74 11                	je     802106 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8020f5:	83 c0 01             	add    $0x1,%eax
  8020f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020fd:	75 e6                	jne    8020e5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	eb 0b                	jmp    802111 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802106:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80210e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    

00802113 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802113:	f3 0f 1e fb          	endbr32 
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80211d:	89 c2                	mov    %eax,%edx
  80211f:	c1 ea 16             	shr    $0x16,%edx
  802122:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802129:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80212e:	f6 c1 01             	test   $0x1,%cl
  802131:	74 1c                	je     80214f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802133:	c1 e8 0c             	shr    $0xc,%eax
  802136:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80213d:	a8 01                	test   $0x1,%al
  80213f:	74 0e                	je     80214f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802141:	c1 e8 0c             	shr    $0xc,%eax
  802144:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80214b:	ef 
  80214c:	0f b7 d2             	movzwl %dx,%edx
}
  80214f:	89 d0                	mov    %edx,%eax
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    
  802153:	66 90                	xchg   %ax,%ax
  802155:	66 90                	xchg   %ax,%ax
  802157:	66 90                	xchg   %ax,%ax
  802159:	66 90                	xchg   %ax,%ax
  80215b:	66 90                	xchg   %ax,%ax
  80215d:	66 90                	xchg   %ax,%ax
  80215f:	90                   	nop

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
