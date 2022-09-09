
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	asm volatile("int $14");	// page fault
  800037:	cd 0e                	int    $0xe
}
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	f3 0f 1e fb          	endbr32 
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800046:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800049:	e8 de 00 00 00       	call   80012c <sys_getenvid>
  80004e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800053:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800056:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800060:	85 db                	test   %ebx,%ebx
  800062:	7e 07                	jle    80006b <libmain+0x31>
		binaryname = argv[0];
  800064:	8b 06                	mov    (%esi),%eax
  800066:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006b:	83 ec 08             	sub    $0x8,%esp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	e8 be ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800075:	e8 0a 00 00 00       	call   800084 <exit>
}
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800080:	5b                   	pop    %ebx
  800081:	5e                   	pop    %esi
  800082:	5d                   	pop    %ebp
  800083:	c3                   	ret    

00800084 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800084:	f3 0f 1e fb          	endbr32 
  800088:	55                   	push   %ebp
  800089:	89 e5                	mov    %esp,%ebp
  80008b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008e:	e8 07 05 00 00       	call   80059a <close_all>
	sys_env_destroy(0);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	6a 00                	push   $0x0
  800098:	e8 4a 00 00 00       	call   8000e7 <sys_env_destroy>
}
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	57                   	push   %edi
  8000aa:	56                   	push   %esi
  8000ab:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b7:	89 c3                	mov    %eax,%ebx
  8000b9:	89 c7                	mov    %eax,%edi
  8000bb:	89 c6                	mov    %eax,%esi
  8000bd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000bf:	5b                   	pop    %ebx
  8000c0:	5e                   	pop    %esi
  8000c1:	5f                   	pop    %edi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	57                   	push   %edi
  8000cc:	56                   	push   %esi
  8000cd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d8:	89 d1                	mov    %edx,%ecx
  8000da:	89 d3                	mov    %edx,%ebx
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	89 d6                	mov    %edx,%esi
  8000e0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5f                   	pop    %edi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	89 cb                	mov    %ecx,%ebx
  800103:	89 cf                	mov    %ecx,%edi
  800105:	89 ce                	mov    %ecx,%esi
  800107:	cd 30                	int    $0x30
	if(check && ret > 0)
  800109:	85 c0                	test   %eax,%eax
  80010b:	7f 08                	jg     800115 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800110:	5b                   	pop    %ebx
  800111:	5e                   	pop    %esi
  800112:	5f                   	pop    %edi
  800113:	5d                   	pop    %ebp
  800114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	50                   	push   %eax
  800119:	6a 03                	push   $0x3
  80011b:	68 ca 23 80 00       	push   $0x8023ca
  800120:	6a 23                	push   $0x23
  800122:	68 e7 23 80 00       	push   $0x8023e7
  800127:	e8 7c 14 00 00       	call   8015a8 <_panic>

0080012c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012c:	f3 0f 1e fb          	endbr32 
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
	asm volatile("int %1\n"
  800136:	ba 00 00 00 00       	mov    $0x0,%edx
  80013b:	b8 02 00 00 00       	mov    $0x2,%eax
  800140:	89 d1                	mov    %edx,%ecx
  800142:	89 d3                	mov    %edx,%ebx
  800144:	89 d7                	mov    %edx,%edi
  800146:	89 d6                	mov    %edx,%esi
  800148:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80014a:	5b                   	pop    %ebx
  80014b:	5e                   	pop    %esi
  80014c:	5f                   	pop    %edi
  80014d:	5d                   	pop    %ebp
  80014e:	c3                   	ret    

0080014f <sys_yield>:

void
sys_yield(void)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	57                   	push   %edi
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
	asm volatile("int %1\n"
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800163:	89 d1                	mov    %edx,%ecx
  800165:	89 d3                	mov    %edx,%ebx
  800167:	89 d7                	mov    %edx,%edi
  800169:	89 d6                	mov    %edx,%esi
  80016b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80016d:	5b                   	pop    %ebx
  80016e:	5e                   	pop    %esi
  80016f:	5f                   	pop    %edi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    

00800172 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800172:	f3 0f 1e fb          	endbr32 
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	57                   	push   %edi
  80017a:	56                   	push   %esi
  80017b:	53                   	push   %ebx
  80017c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80017f:	be 00 00 00 00       	mov    $0x0,%esi
  800184:	8b 55 08             	mov    0x8(%ebp),%edx
  800187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018a:	b8 04 00 00 00       	mov    $0x4,%eax
  80018f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800192:	89 f7                	mov    %esi,%edi
  800194:	cd 30                	int    $0x30
	if(check && ret > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7f 08                	jg     8001a2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019d:	5b                   	pop    %ebx
  80019e:	5e                   	pop    %esi
  80019f:	5f                   	pop    %edi
  8001a0:	5d                   	pop    %ebp
  8001a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	50                   	push   %eax
  8001a6:	6a 04                	push   $0x4
  8001a8:	68 ca 23 80 00       	push   $0x8023ca
  8001ad:	6a 23                	push   $0x23
  8001af:	68 e7 23 80 00       	push   $0x8023e7
  8001b4:	e8 ef 13 00 00       	call   8015a8 <_panic>

008001b9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001b9:	f3 0f 1e fb          	endbr32 
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	57                   	push   %edi
  8001c1:	56                   	push   %esi
  8001c2:	53                   	push   %ebx
  8001c3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cc:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8001da:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001dc:	85 c0                	test   %eax,%eax
  8001de:	7f 08                	jg     8001e8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e3:	5b                   	pop    %ebx
  8001e4:	5e                   	pop    %esi
  8001e5:	5f                   	pop    %edi
  8001e6:	5d                   	pop    %ebp
  8001e7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e8:	83 ec 0c             	sub    $0xc,%esp
  8001eb:	50                   	push   %eax
  8001ec:	6a 05                	push   $0x5
  8001ee:	68 ca 23 80 00       	push   $0x8023ca
  8001f3:	6a 23                	push   $0x23
  8001f5:	68 e7 23 80 00       	push   $0x8023e7
  8001fa:	e8 a9 13 00 00       	call   8015a8 <_panic>

008001ff <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ff:	f3 0f 1e fb          	endbr32 
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	57                   	push   %edi
  800207:	56                   	push   %esi
  800208:	53                   	push   %ebx
  800209:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80020c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800211:	8b 55 08             	mov    0x8(%ebp),%edx
  800214:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800217:	b8 06 00 00 00       	mov    $0x6,%eax
  80021c:	89 df                	mov    %ebx,%edi
  80021e:	89 de                	mov    %ebx,%esi
  800220:	cd 30                	int    $0x30
	if(check && ret > 0)
  800222:	85 c0                	test   %eax,%eax
  800224:	7f 08                	jg     80022e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800229:	5b                   	pop    %ebx
  80022a:	5e                   	pop    %esi
  80022b:	5f                   	pop    %edi
  80022c:	5d                   	pop    %ebp
  80022d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	50                   	push   %eax
  800232:	6a 06                	push   $0x6
  800234:	68 ca 23 80 00       	push   $0x8023ca
  800239:	6a 23                	push   $0x23
  80023b:	68 e7 23 80 00       	push   $0x8023e7
  800240:	e8 63 13 00 00       	call   8015a8 <_panic>

00800245 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800245:	f3 0f 1e fb          	endbr32 
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800252:	bb 00 00 00 00       	mov    $0x0,%ebx
  800257:	8b 55 08             	mov    0x8(%ebp),%edx
  80025a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025d:	b8 08 00 00 00       	mov    $0x8,%eax
  800262:	89 df                	mov    %ebx,%edi
  800264:	89 de                	mov    %ebx,%esi
  800266:	cd 30                	int    $0x30
	if(check && ret > 0)
  800268:	85 c0                	test   %eax,%eax
  80026a:	7f 08                	jg     800274 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	6a 08                	push   $0x8
  80027a:	68 ca 23 80 00       	push   $0x8023ca
  80027f:	6a 23                	push   $0x23
  800281:	68 e7 23 80 00       	push   $0x8023e7
  800286:	e8 1d 13 00 00       	call   8015a8 <_panic>

0080028b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80028b:	f3 0f 1e fb          	endbr32 
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	57                   	push   %edi
  800293:	56                   	push   %esi
  800294:	53                   	push   %ebx
  800295:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800298:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029d:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002a8:	89 df                	mov    %ebx,%edi
  8002aa:	89 de                	mov    %ebx,%esi
  8002ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	7f 08                	jg     8002ba <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	50                   	push   %eax
  8002be:	6a 09                	push   $0x9
  8002c0:	68 ca 23 80 00       	push   $0x8023ca
  8002c5:	6a 23                	push   $0x23
  8002c7:	68 e7 23 80 00       	push   $0x8023e7
  8002cc:	e8 d7 12 00 00       	call   8015a8 <_panic>

008002d1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ee:	89 df                	mov    %ebx,%edi
  8002f0:	89 de                	mov    %ebx,%esi
  8002f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	7f 08                	jg     800300 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fb:	5b                   	pop    %ebx
  8002fc:	5e                   	pop    %esi
  8002fd:	5f                   	pop    %edi
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	50                   	push   %eax
  800304:	6a 0a                	push   $0xa
  800306:	68 ca 23 80 00       	push   $0x8023ca
  80030b:	6a 23                	push   $0x23
  80030d:	68 e7 23 80 00       	push   $0x8023e7
  800312:	e8 91 12 00 00       	call   8015a8 <_panic>

00800317 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800317:	f3 0f 1e fb          	endbr32 
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
	asm volatile("int %1\n"
  800321:	8b 55 08             	mov    0x8(%ebp),%edx
  800324:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800327:	b8 0c 00 00 00       	mov    $0xc,%eax
  80032c:	be 00 00 00 00       	mov    $0x0,%esi
  800331:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800334:	8b 7d 14             	mov    0x14(%ebp),%edi
  800337:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800339:	5b                   	pop    %ebx
  80033a:	5e                   	pop    %esi
  80033b:	5f                   	pop    %edi
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    

0080033e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80033e:	f3 0f 1e fb          	endbr32 
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
  800348:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80034b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	b8 0d 00 00 00       	mov    $0xd,%eax
  800358:	89 cb                	mov    %ecx,%ebx
  80035a:	89 cf                	mov    %ecx,%edi
  80035c:	89 ce                	mov    %ecx,%esi
  80035e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800360:	85 c0                	test   %eax,%eax
  800362:	7f 08                	jg     80036c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800367:	5b                   	pop    %ebx
  800368:	5e                   	pop    %esi
  800369:	5f                   	pop    %edi
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	50                   	push   %eax
  800370:	6a 0d                	push   $0xd
  800372:	68 ca 23 80 00       	push   $0x8023ca
  800377:	6a 23                	push   $0x23
  800379:	68 e7 23 80 00       	push   $0x8023e7
  80037e:	e8 25 12 00 00       	call   8015a8 <_panic>

00800383 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800383:	f3 0f 1e fb          	endbr32 
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	57                   	push   %edi
  80038b:	56                   	push   %esi
  80038c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80038d:	ba 00 00 00 00       	mov    $0x0,%edx
  800392:	b8 0e 00 00 00       	mov    $0xe,%eax
  800397:	89 d1                	mov    %edx,%ecx
  800399:	89 d3                	mov    %edx,%ebx
  80039b:	89 d7                	mov    %edx,%edi
  80039d:	89 d6                	mov    %edx,%esi
  80039f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a1:	5b                   	pop    %ebx
  8003a2:	5e                   	pop    %esi
  8003a3:	5f                   	pop    %edi
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003a6:	f3 0f 1e fb          	endbr32 
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	05 00 00 00 30       	add    $0x30000000,%eax
  8003b5:	c1 e8 0c             	shr    $0xc,%eax
}
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ce:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003d3:	5d                   	pop    %ebp
  8003d4:	c3                   	ret    

008003d5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003d5:	f3 0f 1e fb          	endbr32 
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003e1:	89 c2                	mov    %eax,%edx
  8003e3:	c1 ea 16             	shr    $0x16,%edx
  8003e6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003ed:	f6 c2 01             	test   $0x1,%dl
  8003f0:	74 2d                	je     80041f <fd_alloc+0x4a>
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	c1 ea 0c             	shr    $0xc,%edx
  8003f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8003fe:	f6 c2 01             	test   $0x1,%dl
  800401:	74 1c                	je     80041f <fd_alloc+0x4a>
  800403:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800408:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80040d:	75 d2                	jne    8003e1 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800418:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80041d:	eb 0a                	jmp    800429 <fd_alloc+0x54>
			*fd_store = fd;
  80041f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800422:	89 01                	mov    %eax,(%ecx)
			return 0;
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    

0080042b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80042b:	f3 0f 1e fb          	endbr32 
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800435:	83 f8 1f             	cmp    $0x1f,%eax
  800438:	77 30                	ja     80046a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80043a:	c1 e0 0c             	shl    $0xc,%eax
  80043d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800442:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800448:	f6 c2 01             	test   $0x1,%dl
  80044b:	74 24                	je     800471 <fd_lookup+0x46>
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	c1 ea 0c             	shr    $0xc,%edx
  800452:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800459:	f6 c2 01             	test   $0x1,%dl
  80045c:	74 1a                	je     800478 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80045e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800461:	89 02                	mov    %eax,(%edx)
	return 0;
  800463:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800468:	5d                   	pop    %ebp
  800469:	c3                   	ret    
		return -E_INVAL;
  80046a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80046f:	eb f7                	jmp    800468 <fd_lookup+0x3d>
		return -E_INVAL;
  800471:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800476:	eb f0                	jmp    800468 <fd_lookup+0x3d>
  800478:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80047d:	eb e9                	jmp    800468 <fd_lookup+0x3d>

0080047f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80047f:	f3 0f 1e fb          	endbr32 
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80048c:	ba 00 00 00 00       	mov    $0x0,%edx
  800491:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800496:	39 08                	cmp    %ecx,(%eax)
  800498:	74 38                	je     8004d2 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80049a:	83 c2 01             	add    $0x1,%edx
  80049d:	8b 04 95 74 24 80 00 	mov    0x802474(,%edx,4),%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	75 ee                	jne    800496 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8004ad:	8b 40 48             	mov    0x48(%eax),%eax
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	51                   	push   %ecx
  8004b4:	50                   	push   %eax
  8004b5:	68 f8 23 80 00       	push   $0x8023f8
  8004ba:	e8 d0 11 00 00       	call   80168f <cprintf>
	*dev = 0;
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    
			*dev = devtab[i];
  8004d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	eb f2                	jmp    8004d0 <dev_lookup+0x51>

008004de <fd_close>:
{
  8004de:	f3 0f 1e fb          	endbr32 
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	57                   	push   %edi
  8004e6:	56                   	push   %esi
  8004e7:	53                   	push   %ebx
  8004e8:	83 ec 24             	sub    $0x24,%esp
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004f4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8004fb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004fe:	50                   	push   %eax
  8004ff:	e8 27 ff ff ff       	call   80042b <fd_lookup>
  800504:	89 c3                	mov    %eax,%ebx
  800506:	83 c4 10             	add    $0x10,%esp
  800509:	85 c0                	test   %eax,%eax
  80050b:	78 05                	js     800512 <fd_close+0x34>
	    || fd != fd2)
  80050d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800510:	74 16                	je     800528 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800512:	89 f8                	mov    %edi,%eax
  800514:	84 c0                	test   %al,%al
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	0f 44 d8             	cmove  %eax,%ebx
}
  80051e:	89 d8                	mov    %ebx,%eax
  800520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800523:	5b                   	pop    %ebx
  800524:	5e                   	pop    %esi
  800525:	5f                   	pop    %edi
  800526:	5d                   	pop    %ebp
  800527:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80052e:	50                   	push   %eax
  80052f:	ff 36                	pushl  (%esi)
  800531:	e8 49 ff ff ff       	call   80047f <dev_lookup>
  800536:	89 c3                	mov    %eax,%ebx
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 c0                	test   %eax,%eax
  80053d:	78 1a                	js     800559 <fd_close+0x7b>
		if (dev->dev_close)
  80053f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800542:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800545:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80054a:	85 c0                	test   %eax,%eax
  80054c:	74 0b                	je     800559 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80054e:	83 ec 0c             	sub    $0xc,%esp
  800551:	56                   	push   %esi
  800552:	ff d0                	call   *%eax
  800554:	89 c3                	mov    %eax,%ebx
  800556:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	56                   	push   %esi
  80055d:	6a 00                	push   $0x0
  80055f:	e8 9b fc ff ff       	call   8001ff <sys_page_unmap>
	return r;
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	eb b5                	jmp    80051e <fd_close+0x40>

00800569 <close>:

int
close(int fdnum)
{
  800569:	f3 0f 1e fb          	endbr32 
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800573:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800576:	50                   	push   %eax
  800577:	ff 75 08             	pushl  0x8(%ebp)
  80057a:	e8 ac fe ff ff       	call   80042b <fd_lookup>
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	85 c0                	test   %eax,%eax
  800584:	79 02                	jns    800588 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    
		return fd_close(fd, 1);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	6a 01                	push   $0x1
  80058d:	ff 75 f4             	pushl  -0xc(%ebp)
  800590:	e8 49 ff ff ff       	call   8004de <fd_close>
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	eb ec                	jmp    800586 <close+0x1d>

0080059a <close_all>:

void
close_all(void)
{
  80059a:	f3 0f 1e fb          	endbr32 
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	53                   	push   %ebx
  8005a2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005a5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005aa:	83 ec 0c             	sub    $0xc,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	e8 b6 ff ff ff       	call   800569 <close>
	for (i = 0; i < MAXFD; i++)
  8005b3:	83 c3 01             	add    $0x1,%ebx
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	83 fb 20             	cmp    $0x20,%ebx
  8005bc:	75 ec                	jne    8005aa <close_all+0x10>
}
  8005be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005c3:	f3 0f 1e fb          	endbr32 
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	57                   	push   %edi
  8005cb:	56                   	push   %esi
  8005cc:	53                   	push   %ebx
  8005cd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005d3:	50                   	push   %eax
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 4f fe ff ff       	call   80042b <fd_lookup>
  8005dc:	89 c3                	mov    %eax,%ebx
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	0f 88 81 00 00 00    	js     80066a <dup+0xa7>
		return r;
	close(newfdnum);
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	ff 75 0c             	pushl  0xc(%ebp)
  8005ef:	e8 75 ff ff ff       	call   800569 <close>

	newfd = INDEX2FD(newfdnum);
  8005f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005f7:	c1 e6 0c             	shl    $0xc,%esi
  8005fa:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800600:	83 c4 04             	add    $0x4,%esp
  800603:	ff 75 e4             	pushl  -0x1c(%ebp)
  800606:	e8 af fd ff ff       	call   8003ba <fd2data>
  80060b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80060d:	89 34 24             	mov    %esi,(%esp)
  800610:	e8 a5 fd ff ff       	call   8003ba <fd2data>
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80061a:	89 d8                	mov    %ebx,%eax
  80061c:	c1 e8 16             	shr    $0x16,%eax
  80061f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800626:	a8 01                	test   $0x1,%al
  800628:	74 11                	je     80063b <dup+0x78>
  80062a:	89 d8                	mov    %ebx,%eax
  80062c:	c1 e8 0c             	shr    $0xc,%eax
  80062f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800636:	f6 c2 01             	test   $0x1,%dl
  800639:	75 39                	jne    800674 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80063b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80063e:	89 d0                	mov    %edx,%eax
  800640:	c1 e8 0c             	shr    $0xc,%eax
  800643:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80064a:	83 ec 0c             	sub    $0xc,%esp
  80064d:	25 07 0e 00 00       	and    $0xe07,%eax
  800652:	50                   	push   %eax
  800653:	56                   	push   %esi
  800654:	6a 00                	push   $0x0
  800656:	52                   	push   %edx
  800657:	6a 00                	push   $0x0
  800659:	e8 5b fb ff ff       	call   8001b9 <sys_page_map>
  80065e:	89 c3                	mov    %eax,%ebx
  800660:	83 c4 20             	add    $0x20,%esp
  800663:	85 c0                	test   %eax,%eax
  800665:	78 31                	js     800698 <dup+0xd5>
		goto err;

	return newfdnum;
  800667:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80066a:	89 d8                	mov    %ebx,%eax
  80066c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80066f:	5b                   	pop    %ebx
  800670:	5e                   	pop    %esi
  800671:	5f                   	pop    %edi
  800672:	5d                   	pop    %ebp
  800673:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800674:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80067b:	83 ec 0c             	sub    $0xc,%esp
  80067e:	25 07 0e 00 00       	and    $0xe07,%eax
  800683:	50                   	push   %eax
  800684:	57                   	push   %edi
  800685:	6a 00                	push   $0x0
  800687:	53                   	push   %ebx
  800688:	6a 00                	push   $0x0
  80068a:	e8 2a fb ff ff       	call   8001b9 <sys_page_map>
  80068f:	89 c3                	mov    %eax,%ebx
  800691:	83 c4 20             	add    $0x20,%esp
  800694:	85 c0                	test   %eax,%eax
  800696:	79 a3                	jns    80063b <dup+0x78>
	sys_page_unmap(0, newfd);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	56                   	push   %esi
  80069c:	6a 00                	push   $0x0
  80069e:	e8 5c fb ff ff       	call   8001ff <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006a3:	83 c4 08             	add    $0x8,%esp
  8006a6:	57                   	push   %edi
  8006a7:	6a 00                	push   $0x0
  8006a9:	e8 51 fb ff ff       	call   8001ff <sys_page_unmap>
	return r;
  8006ae:	83 c4 10             	add    $0x10,%esp
  8006b1:	eb b7                	jmp    80066a <dup+0xa7>

008006b3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006b3:	f3 0f 1e fb          	endbr32 
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	53                   	push   %ebx
  8006bb:	83 ec 1c             	sub    $0x1c,%esp
  8006be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006c4:	50                   	push   %eax
  8006c5:	53                   	push   %ebx
  8006c6:	e8 60 fd ff ff       	call   80042b <fd_lookup>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	78 3f                	js     800711 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006d8:	50                   	push   %eax
  8006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006dc:	ff 30                	pushl  (%eax)
  8006de:	e8 9c fd ff ff       	call   80047f <dev_lookup>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	78 27                	js     800711 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006ed:	8b 42 08             	mov    0x8(%edx),%eax
  8006f0:	83 e0 03             	and    $0x3,%eax
  8006f3:	83 f8 01             	cmp    $0x1,%eax
  8006f6:	74 1e                	je     800716 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006fb:	8b 40 08             	mov    0x8(%eax),%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	74 35                	je     800737 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800702:	83 ec 04             	sub    $0x4,%esp
  800705:	ff 75 10             	pushl  0x10(%ebp)
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	52                   	push   %edx
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
}
  800711:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800714:	c9                   	leave  
  800715:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800716:	a1 08 40 80 00       	mov    0x804008,%eax
  80071b:	8b 40 48             	mov    0x48(%eax),%eax
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	53                   	push   %ebx
  800722:	50                   	push   %eax
  800723:	68 39 24 80 00       	push   $0x802439
  800728:	e8 62 0f 00 00       	call   80168f <cprintf>
		return -E_INVAL;
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800735:	eb da                	jmp    800711 <read+0x5e>
		return -E_NOT_SUPP;
  800737:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80073c:	eb d3                	jmp    800711 <read+0x5e>

0080073e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80073e:	f3 0f 1e fb          	endbr32 
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	57                   	push   %edi
  800746:	56                   	push   %esi
  800747:	53                   	push   %ebx
  800748:	83 ec 0c             	sub    $0xc,%esp
  80074b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80074e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800751:	bb 00 00 00 00       	mov    $0x0,%ebx
  800756:	eb 02                	jmp    80075a <readn+0x1c>
  800758:	01 c3                	add    %eax,%ebx
  80075a:	39 f3                	cmp    %esi,%ebx
  80075c:	73 21                	jae    80077f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80075e:	83 ec 04             	sub    $0x4,%esp
  800761:	89 f0                	mov    %esi,%eax
  800763:	29 d8                	sub    %ebx,%eax
  800765:	50                   	push   %eax
  800766:	89 d8                	mov    %ebx,%eax
  800768:	03 45 0c             	add    0xc(%ebp),%eax
  80076b:	50                   	push   %eax
  80076c:	57                   	push   %edi
  80076d:	e8 41 ff ff ff       	call   8006b3 <read>
		if (m < 0)
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	85 c0                	test   %eax,%eax
  800777:	78 04                	js     80077d <readn+0x3f>
			return m;
		if (m == 0)
  800779:	75 dd                	jne    800758 <readn+0x1a>
  80077b:	eb 02                	jmp    80077f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80077d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80077f:	89 d8                	mov    %ebx,%eax
  800781:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800784:	5b                   	pop    %ebx
  800785:	5e                   	pop    %esi
  800786:	5f                   	pop    %edi
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800789:	f3 0f 1e fb          	endbr32 
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	53                   	push   %ebx
  800791:	83 ec 1c             	sub    $0x1c,%esp
  800794:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800797:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80079a:	50                   	push   %eax
  80079b:	53                   	push   %ebx
  80079c:	e8 8a fc ff ff       	call   80042b <fd_lookup>
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	78 3a                	js     8007e2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ae:	50                   	push   %eax
  8007af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b2:	ff 30                	pushl  (%eax)
  8007b4:	e8 c6 fc ff ff       	call   80047f <dev_lookup>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	85 c0                	test   %eax,%eax
  8007be:	78 22                	js     8007e2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007c7:	74 1e                	je     8007e7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007cc:	8b 52 0c             	mov    0xc(%edx),%edx
  8007cf:	85 d2                	test   %edx,%edx
  8007d1:	74 35                	je     800808 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007d3:	83 ec 04             	sub    $0x4,%esp
  8007d6:	ff 75 10             	pushl  0x10(%ebp)
  8007d9:	ff 75 0c             	pushl  0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	ff d2                	call   *%edx
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8007ec:	8b 40 48             	mov    0x48(%eax),%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	53                   	push   %ebx
  8007f3:	50                   	push   %eax
  8007f4:	68 55 24 80 00       	push   $0x802455
  8007f9:	e8 91 0e 00 00       	call   80168f <cprintf>
		return -E_INVAL;
  8007fe:	83 c4 10             	add    $0x10,%esp
  800801:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800806:	eb da                	jmp    8007e2 <write+0x59>
		return -E_NOT_SUPP;
  800808:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80080d:	eb d3                	jmp    8007e2 <write+0x59>

0080080f <seek>:

int
seek(int fdnum, off_t offset)
{
  80080f:	f3 0f 1e fb          	endbr32 
  800813:	55                   	push   %ebp
  800814:	89 e5                	mov    %esp,%ebp
  800816:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80081c:	50                   	push   %eax
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 06 fc ff ff       	call   80042b <fd_lookup>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	85 c0                	test   %eax,%eax
  80082a:	78 0e                	js     80083a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80082c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800832:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80083c:	f3 0f 1e fb          	endbr32 
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 1c             	sub    $0x1c,%esp
  800847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	53                   	push   %ebx
  80084f:	e8 d7 fb ff ff       	call   80042b <fd_lookup>
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	85 c0                	test   %eax,%eax
  800859:	78 37                	js     800892 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800865:	ff 30                	pushl  (%eax)
  800867:	e8 13 fc ff ff       	call   80047f <dev_lookup>
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	85 c0                	test   %eax,%eax
  800871:	78 1f                	js     800892 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80087a:	74 1b                	je     800897 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80087c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80087f:	8b 52 18             	mov    0x18(%edx),%edx
  800882:	85 d2                	test   %edx,%edx
  800884:	74 32                	je     8008b8 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	50                   	push   %eax
  80088d:	ff d2                	call   *%edx
  80088f:	83 c4 10             	add    $0x10,%esp
}
  800892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800895:	c9                   	leave  
  800896:	c3                   	ret    
			thisenv->env_id, fdnum);
  800897:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80089c:	8b 40 48             	mov    0x48(%eax),%eax
  80089f:	83 ec 04             	sub    $0x4,%esp
  8008a2:	53                   	push   %ebx
  8008a3:	50                   	push   %eax
  8008a4:	68 18 24 80 00       	push   $0x802418
  8008a9:	e8 e1 0d 00 00       	call   80168f <cprintf>
		return -E_INVAL;
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b6:	eb da                	jmp    800892 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008bd:	eb d3                	jmp    800892 <ftruncate+0x56>

008008bf <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008bf:	f3 0f 1e fb          	endbr32 
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	53                   	push   %ebx
  8008c7:	83 ec 1c             	sub    $0x1c,%esp
  8008ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d0:	50                   	push   %eax
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 52 fb ff ff       	call   80042b <fd_lookup>
  8008d9:	83 c4 10             	add    $0x10,%esp
  8008dc:	85 c0                	test   %eax,%eax
  8008de:	78 4b                	js     80092b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008e6:	50                   	push   %eax
  8008e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ea:	ff 30                	pushl  (%eax)
  8008ec:	e8 8e fb ff ff       	call   80047f <dev_lookup>
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	78 33                	js     80092b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8008f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008fb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8008ff:	74 2f                	je     800930 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800901:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800904:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80090b:	00 00 00 
	stat->st_isdir = 0;
  80090e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800915:	00 00 00 
	stat->st_dev = dev;
  800918:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	ff 75 f0             	pushl  -0x10(%ebp)
  800925:	ff 50 14             	call   *0x14(%eax)
  800928:	83 c4 10             	add    $0x10,%esp
}
  80092b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    
		return -E_NOT_SUPP;
  800930:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800935:	eb f4                	jmp    80092b <fstat+0x6c>

00800937 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800937:	f3 0f 1e fb          	endbr32 
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	56                   	push   %esi
  80093f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	6a 00                	push   $0x0
  800945:	ff 75 08             	pushl  0x8(%ebp)
  800948:	e8 fb 01 00 00       	call   800b48 <open>
  80094d:	89 c3                	mov    %eax,%ebx
  80094f:	83 c4 10             	add    $0x10,%esp
  800952:	85 c0                	test   %eax,%eax
  800954:	78 1b                	js     800971 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 5d ff ff ff       	call   8008bf <fstat>
  800962:	89 c6                	mov    %eax,%esi
	close(fd);
  800964:	89 1c 24             	mov    %ebx,(%esp)
  800967:	e8 fd fb ff ff       	call   800569 <close>
	return r;
  80096c:	83 c4 10             	add    $0x10,%esp
  80096f:	89 f3                	mov    %esi,%ebx
}
  800971:	89 d8                	mov    %ebx,%eax
  800973:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	89 c6                	mov    %eax,%esi
  800981:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800983:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80098a:	74 27                	je     8009b3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80098c:	6a 07                	push   $0x7
  80098e:	68 00 50 80 00       	push   $0x805000
  800993:	56                   	push   %esi
  800994:	ff 35 00 40 80 00    	pushl  0x804000
  80099a:	e8 e0 16 00 00       	call   80207f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80099f:	83 c4 0c             	add    $0xc,%esp
  8009a2:	6a 00                	push   $0x0
  8009a4:	53                   	push   %ebx
  8009a5:	6a 00                	push   $0x0
  8009a7:	e8 5f 16 00 00       	call   80200b <ipc_recv>
}
  8009ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	6a 01                	push   $0x1
  8009b8:	e8 1a 17 00 00       	call   8020d7 <ipc_find_env>
  8009bd:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	eb c5                	jmp    80098c <fsipc+0x12>

008009c7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009c7:	f3 0f 1e fb          	endbr32 
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e9:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ee:	e8 87 ff ff ff       	call   80097a <fsipc>
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <devfile_flush>:
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 40 0c             	mov    0xc(%eax),%eax
  800a05:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0f:	b8 06 00 00 00       	mov    $0x6,%eax
  800a14:	e8 61 ff ff ff       	call   80097a <fsipc>
}
  800a19:	c9                   	leave  
  800a1a:	c3                   	ret    

00800a1b <devfile_stat>:
{
  800a1b:	f3 0f 1e fb          	endbr32 
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	53                   	push   %ebx
  800a23:	83 ec 04             	sub    $0x4,%esp
  800a26:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  800a2f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a34:	ba 00 00 00 00       	mov    $0x0,%edx
  800a39:	b8 05 00 00 00       	mov    $0x5,%eax
  800a3e:	e8 37 ff ff ff       	call   80097a <fsipc>
  800a43:	85 c0                	test   %eax,%eax
  800a45:	78 2c                	js     800a73 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	68 00 50 80 00       	push   $0x805000
  800a4f:	53                   	push   %ebx
  800a50:	e8 44 12 00 00       	call   801c99 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a55:	a1 80 50 80 00       	mov    0x805080,%eax
  800a5a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a60:	a1 84 50 80 00       	mov    0x805084,%eax
  800a65:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a6b:	83 c4 10             	add    $0x10,%esp
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <devfile_write>:
{
  800a78:	f3 0f 1e fb          	endbr32 
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a85:	8b 55 08             	mov    0x8(%ebp),%edx
  800a88:	8b 52 0c             	mov    0xc(%edx),%edx
  800a8b:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800a91:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a96:	ba 00 10 00 00       	mov    $0x1000,%edx
  800a9b:	0f 47 c2             	cmova  %edx,%eax
  800a9e:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	68 08 50 80 00       	push   $0x805008
  800aac:	e8 9e 13 00 00       	call   801e4f <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ab1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab6:	b8 04 00 00 00       	mov    $0x4,%eax
  800abb:	e8 ba fe ff ff       	call   80097a <fsipc>
}
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <devfile_read>:
{
  800ac2:	f3 0f 1e fb          	endbr32 
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	56                   	push   %esi
  800aca:	53                   	push   %ebx
  800acb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ad9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ae9:	e8 8c fe ff ff       	call   80097a <fsipc>
  800aee:	89 c3                	mov    %eax,%ebx
  800af0:	85 c0                	test   %eax,%eax
  800af2:	78 1f                	js     800b13 <devfile_read+0x51>
	assert(r <= n);
  800af4:	39 f0                	cmp    %esi,%eax
  800af6:	77 24                	ja     800b1c <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800af8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800afd:	7f 33                	jg     800b32 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800aff:	83 ec 04             	sub    $0x4,%esp
  800b02:	50                   	push   %eax
  800b03:	68 00 50 80 00       	push   $0x805000
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	e8 3f 13 00 00       	call   801e4f <memmove>
	return r;
  800b10:	83 c4 10             	add    $0x10,%esp
}
  800b13:	89 d8                	mov    %ebx,%eax
  800b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b18:	5b                   	pop    %ebx
  800b19:	5e                   	pop    %esi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    
	assert(r <= n);
  800b1c:	68 88 24 80 00       	push   $0x802488
  800b21:	68 8f 24 80 00       	push   $0x80248f
  800b26:	6a 7c                	push   $0x7c
  800b28:	68 a4 24 80 00       	push   $0x8024a4
  800b2d:	e8 76 0a 00 00       	call   8015a8 <_panic>
	assert(r <= PGSIZE);
  800b32:	68 af 24 80 00       	push   $0x8024af
  800b37:	68 8f 24 80 00       	push   $0x80248f
  800b3c:	6a 7d                	push   $0x7d
  800b3e:	68 a4 24 80 00       	push   $0x8024a4
  800b43:	e8 60 0a 00 00       	call   8015a8 <_panic>

00800b48 <open>:
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
  800b51:	83 ec 1c             	sub    $0x1c,%esp
  800b54:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b57:	56                   	push   %esi
  800b58:	e8 f9 10 00 00       	call   801c56 <strlen>
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b65:	7f 6c                	jg     800bd3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b6d:	50                   	push   %eax
  800b6e:	e8 62 f8 ff ff       	call   8003d5 <fd_alloc>
  800b73:	89 c3                	mov    %eax,%ebx
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	85 c0                	test   %eax,%eax
  800b7a:	78 3c                	js     800bb8 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	56                   	push   %esi
  800b80:	68 00 50 80 00       	push   $0x805000
  800b85:	e8 0f 11 00 00       	call   801c99 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b95:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9a:	e8 db fd ff ff       	call   80097a <fsipc>
  800b9f:	89 c3                	mov    %eax,%ebx
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	85 c0                	test   %eax,%eax
  800ba6:	78 19                	js     800bc1 <open+0x79>
	return fd2num(fd);
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	e8 f3 f7 ff ff       	call   8003a6 <fd2num>
  800bb3:	89 c3                	mov    %eax,%ebx
  800bb5:	83 c4 10             	add    $0x10,%esp
}
  800bb8:	89 d8                	mov    %ebx,%eax
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    
		fd_close(fd, 0);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	6a 00                	push   $0x0
  800bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc9:	e8 10 f9 ff ff       	call   8004de <fd_close>
		return r;
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	eb e5                	jmp    800bb8 <open+0x70>
		return -E_BAD_PATH;
  800bd3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bd8:	eb de                	jmp    800bb8 <open+0x70>

00800bda <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bda:	f3 0f 1e fb          	endbr32 
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	b8 08 00 00 00       	mov    $0x8,%eax
  800bee:	e8 87 fd ff ff       	call   80097a <fsipc>
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800bf5:	f3 0f 1e fb          	endbr32 
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800bff:	68 bb 24 80 00       	push   $0x8024bb
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	e8 8d 10 00 00       	call   801c99 <strcpy>
	return 0;
}
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	c9                   	leave  
  800c12:	c3                   	ret    

00800c13 <devsock_close>:
{
  800c13:	f3 0f 1e fb          	endbr32 
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	53                   	push   %ebx
  800c1b:	83 ec 10             	sub    $0x10,%esp
  800c1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c21:	53                   	push   %ebx
  800c22:	e8 ed 14 00 00       	call   802114 <pageref>
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c31:	83 fa 01             	cmp    $0x1,%edx
  800c34:	74 05                	je     800c3b <devsock_close+0x28>
}
  800c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c3b:	83 ec 0c             	sub    $0xc,%esp
  800c3e:	ff 73 0c             	pushl  0xc(%ebx)
  800c41:	e8 e3 02 00 00       	call   800f29 <nsipc_close>
  800c46:	83 c4 10             	add    $0x10,%esp
  800c49:	eb eb                	jmp    800c36 <devsock_close+0x23>

00800c4b <devsock_write>:
{
  800c4b:	f3 0f 1e fb          	endbr32 
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c55:	6a 00                	push   $0x0
  800c57:	ff 75 10             	pushl  0x10(%ebp)
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	ff 70 0c             	pushl  0xc(%eax)
  800c63:	e8 b5 03 00 00       	call   80101d <nsipc_send>
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <devsock_read>:
{
  800c6a:	f3 0f 1e fb          	endbr32 
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c74:	6a 00                	push   $0x0
  800c76:	ff 75 10             	pushl  0x10(%ebp)
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff 70 0c             	pushl  0xc(%eax)
  800c82:	e8 1f 03 00 00       	call   800fa6 <nsipc_recv>
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <fd2sockid>:
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 92 f7 ff ff       	call   80042b <fd_lookup>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	85 c0                	test   %eax,%eax
  800c9e:	78 10                	js     800cb0 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca3:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800ca9:	39 08                	cmp    %ecx,(%eax)
  800cab:	75 05                	jne    800cb2 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cad:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    
		return -E_NOT_SUPP;
  800cb2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cb7:	eb f7                	jmp    800cb0 <fd2sockid+0x27>

00800cb9 <alloc_sockfd>:
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 1c             	sub    $0x1c,%esp
  800cc1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cc6:	50                   	push   %eax
  800cc7:	e8 09 f7 ff ff       	call   8003d5 <fd_alloc>
  800ccc:	89 c3                	mov    %eax,%ebx
  800cce:	83 c4 10             	add    $0x10,%esp
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	78 43                	js     800d18 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	68 07 04 00 00       	push   $0x407
  800cdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce0:	6a 00                	push   $0x0
  800ce2:	e8 8b f4 ff ff       	call   800172 <sys_page_alloc>
  800ce7:	89 c3                	mov    %eax,%ebx
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	85 c0                	test   %eax,%eax
  800cee:	78 28                	js     800d18 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800cf9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d05:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d08:	83 ec 0c             	sub    $0xc,%esp
  800d0b:	50                   	push   %eax
  800d0c:	e8 95 f6 ff ff       	call   8003a6 <fd2num>
  800d11:	89 c3                	mov    %eax,%ebx
  800d13:	83 c4 10             	add    $0x10,%esp
  800d16:	eb 0c                	jmp    800d24 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	56                   	push   %esi
  800d1c:	e8 08 02 00 00       	call   800f29 <nsipc_close>
		return r;
  800d21:	83 c4 10             	add    $0x10,%esp
}
  800d24:	89 d8                	mov    %ebx,%eax
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <accept>:
{
  800d2d:	f3 0f 1e fb          	endbr32 
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	e8 4a ff ff ff       	call   800c89 <fd2sockid>
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	78 1b                	js     800d5e <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	ff 75 10             	pushl  0x10(%ebp)
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	50                   	push   %eax
  800d4d:	e8 22 01 00 00       	call   800e74 <nsipc_accept>
  800d52:	83 c4 10             	add    $0x10,%esp
  800d55:	85 c0                	test   %eax,%eax
  800d57:	78 05                	js     800d5e <accept+0x31>
	return alloc_sockfd(r);
  800d59:	e8 5b ff ff ff       	call   800cb9 <alloc_sockfd>
}
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <bind>:
{
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	e8 17 ff ff ff       	call   800c89 <fd2sockid>
  800d72:	85 c0                	test   %eax,%eax
  800d74:	78 12                	js     800d88 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d76:	83 ec 04             	sub    $0x4,%esp
  800d79:	ff 75 10             	pushl  0x10(%ebp)
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	50                   	push   %eax
  800d80:	e8 45 01 00 00       	call   800eca <nsipc_bind>
  800d85:	83 c4 10             	add    $0x10,%esp
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <shutdown>:
{
  800d8a:	f3 0f 1e fb          	endbr32 
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	e8 ed fe ff ff       	call   800c89 <fd2sockid>
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	78 0f                	js     800daf <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800da0:	83 ec 08             	sub    $0x8,%esp
  800da3:	ff 75 0c             	pushl  0xc(%ebp)
  800da6:	50                   	push   %eax
  800da7:	e8 57 01 00 00       	call   800f03 <nsipc_shutdown>
  800dac:	83 c4 10             	add    $0x10,%esp
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <connect>:
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	e8 c6 fe ff ff       	call   800c89 <fd2sockid>
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	78 12                	js     800dd9 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800dc7:	83 ec 04             	sub    $0x4,%esp
  800dca:	ff 75 10             	pushl  0x10(%ebp)
  800dcd:	ff 75 0c             	pushl  0xc(%ebp)
  800dd0:	50                   	push   %eax
  800dd1:	e8 71 01 00 00       	call   800f47 <nsipc_connect>
  800dd6:	83 c4 10             	add    $0x10,%esp
}
  800dd9:	c9                   	leave  
  800dda:	c3                   	ret    

00800ddb <listen>:
{
  800ddb:	f3 0f 1e fb          	endbr32 
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	e8 9c fe ff ff       	call   800c89 <fd2sockid>
  800ded:	85 c0                	test   %eax,%eax
  800def:	78 0f                	js     800e00 <listen+0x25>
	return nsipc_listen(r, backlog);
  800df1:	83 ec 08             	sub    $0x8,%esp
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	50                   	push   %eax
  800df8:	e8 83 01 00 00       	call   800f80 <nsipc_listen>
  800dfd:	83 c4 10             	add    $0x10,%esp
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e02:	f3 0f 1e fb          	endbr32 
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e0c:	ff 75 10             	pushl  0x10(%ebp)
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	ff 75 08             	pushl  0x8(%ebp)
  800e15:	e8 65 02 00 00       	call   80107f <nsipc_socket>
  800e1a:	83 c4 10             	add    $0x10,%esp
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	78 05                	js     800e26 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e21:	e8 93 fe ff ff       	call   800cb9 <alloc_sockfd>
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	53                   	push   %ebx
  800e2c:	83 ec 04             	sub    $0x4,%esp
  800e2f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e31:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e38:	74 26                	je     800e60 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e3a:	6a 07                	push   $0x7
  800e3c:	68 00 60 80 00       	push   $0x806000
  800e41:	53                   	push   %ebx
  800e42:	ff 35 04 40 80 00    	pushl  0x804004
  800e48:	e8 32 12 00 00       	call   80207f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e4d:	83 c4 0c             	add    $0xc,%esp
  800e50:	6a 00                	push   $0x0
  800e52:	6a 00                	push   $0x0
  800e54:	6a 00                	push   $0x0
  800e56:	e8 b0 11 00 00       	call   80200b <ipc_recv>
}
  800e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e60:	83 ec 0c             	sub    $0xc,%esp
  800e63:	6a 02                	push   $0x2
  800e65:	e8 6d 12 00 00       	call   8020d7 <ipc_find_env>
  800e6a:	a3 04 40 80 00       	mov    %eax,0x804004
  800e6f:	83 c4 10             	add    $0x10,%esp
  800e72:	eb c6                	jmp    800e3a <nsipc+0x12>

00800e74 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e74:	f3 0f 1e fb          	endbr32 
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e88:	8b 06                	mov    (%esi),%eax
  800e8a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800e8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e94:	e8 8f ff ff ff       	call   800e28 <nsipc>
  800e99:	89 c3                	mov    %eax,%ebx
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	79 09                	jns    800ea8 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800e9f:	89 d8                	mov    %ebx,%eax
  800ea1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ea8:	83 ec 04             	sub    $0x4,%esp
  800eab:	ff 35 10 60 80 00    	pushl  0x806010
  800eb1:	68 00 60 80 00       	push   $0x806000
  800eb6:	ff 75 0c             	pushl  0xc(%ebp)
  800eb9:	e8 91 0f 00 00       	call   801e4f <memmove>
		*addrlen = ret->ret_addrlen;
  800ebe:	a1 10 60 80 00       	mov    0x806010,%eax
  800ec3:	89 06                	mov    %eax,(%esi)
  800ec5:	83 c4 10             	add    $0x10,%esp
	return r;
  800ec8:	eb d5                	jmp    800e9f <nsipc_accept+0x2b>

00800eca <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800eca:	f3 0f 1e fb          	endbr32 
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ee0:	53                   	push   %ebx
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	68 04 60 80 00       	push   $0x806004
  800ee9:	e8 61 0f 00 00       	call   801e4f <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800eee:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800ef4:	b8 02 00 00 00       	mov    $0x2,%eax
  800ef9:	e8 2a ff ff ff       	call   800e28 <nsipc>
}
  800efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f03:	f3 0f 1e fb          	endbr32 
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f1d:	b8 03 00 00 00       	mov    $0x3,%eax
  800f22:	e8 01 ff ff ff       	call   800e28 <nsipc>
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <nsipc_close>:

int
nsipc_close(int s)
{
  800f29:	f3 0f 1e fb          	endbr32 
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f3b:	b8 04 00 00 00       	mov    $0x4,%eax
  800f40:	e8 e3 fe ff ff       	call   800e28 <nsipc>
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f47:	f3 0f 1e fb          	endbr32 
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	53                   	push   %ebx
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f5d:	53                   	push   %ebx
  800f5e:	ff 75 0c             	pushl  0xc(%ebp)
  800f61:	68 04 60 80 00       	push   $0x806004
  800f66:	e8 e4 0e 00 00       	call   801e4f <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f6b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f71:	b8 05 00 00 00       	mov    $0x5,%eax
  800f76:	e8 ad fe ff ff       	call   800e28 <nsipc>
}
  800f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800f9a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f9f:	e8 84 fe ff ff       	call   800e28 <nsipc>
}
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fa6:	f3 0f 1e fb          	endbr32 
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fba:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fc8:	b8 07 00 00 00       	mov    $0x7,%eax
  800fcd:	e8 56 fe ff ff       	call   800e28 <nsipc>
  800fd2:	89 c3                	mov    %eax,%ebx
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	78 26                	js     800ffe <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fd8:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800fde:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800fe3:	0f 4e c6             	cmovle %esi,%eax
  800fe6:	39 c3                	cmp    %eax,%ebx
  800fe8:	7f 1d                	jg     801007 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800fea:	83 ec 04             	sub    $0x4,%esp
  800fed:	53                   	push   %ebx
  800fee:	68 00 60 80 00       	push   $0x806000
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	e8 54 0e 00 00       	call   801e4f <memmove>
  800ffb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  800ffe:	89 d8                	mov    %ebx,%eax
  801000:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801007:	68 c7 24 80 00       	push   $0x8024c7
  80100c:	68 8f 24 80 00       	push   $0x80248f
  801011:	6a 62                	push   $0x62
  801013:	68 dc 24 80 00       	push   $0x8024dc
  801018:	e8 8b 05 00 00       	call   8015a8 <_panic>

0080101d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80101d:	f3 0f 1e fb          	endbr32 
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	53                   	push   %ebx
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801033:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801039:	7f 2e                	jg     801069 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	53                   	push   %ebx
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	68 0c 60 80 00       	push   $0x80600c
  801047:	e8 03 0e 00 00       	call   801e4f <memmove>
	nsipcbuf.send.req_size = size;
  80104c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801052:	8b 45 14             	mov    0x14(%ebp),%eax
  801055:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80105a:	b8 08 00 00 00       	mov    $0x8,%eax
  80105f:	e8 c4 fd ff ff       	call   800e28 <nsipc>
}
  801064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801067:	c9                   	leave  
  801068:	c3                   	ret    
	assert(size < 1600);
  801069:	68 e8 24 80 00       	push   $0x8024e8
  80106e:	68 8f 24 80 00       	push   $0x80248f
  801073:	6a 6d                	push   $0x6d
  801075:	68 dc 24 80 00       	push   $0x8024dc
  80107a:	e8 29 05 00 00       	call   8015a8 <_panic>

0080107f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80107f:	f3 0f 1e fb          	endbr32 
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010a1:	b8 09 00 00 00       	mov    $0x9,%eax
  8010a6:	e8 7d fd ff ff       	call   800e28 <nsipc>
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010ad:	f3 0f 1e fb          	endbr32 
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	56                   	push   %esi
  8010b5:	53                   	push   %ebx
  8010b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	ff 75 08             	pushl  0x8(%ebp)
  8010bf:	e8 f6 f2 ff ff       	call   8003ba <fd2data>
  8010c4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010c6:	83 c4 08             	add    $0x8,%esp
  8010c9:	68 f4 24 80 00       	push   $0x8024f4
  8010ce:	53                   	push   %ebx
  8010cf:	e8 c5 0b 00 00       	call   801c99 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010d4:	8b 46 04             	mov    0x4(%esi),%eax
  8010d7:	2b 06                	sub    (%esi),%eax
  8010d9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010df:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010e6:	00 00 00 
	stat->st_dev = &devpipe;
  8010e9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8010f0:	30 80 00 
	return 0;
}
  8010f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    

008010ff <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8010ff:	f3 0f 1e fb          	endbr32 
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	53                   	push   %ebx
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80110d:	53                   	push   %ebx
  80110e:	6a 00                	push   $0x0
  801110:	e8 ea f0 ff ff       	call   8001ff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801115:	89 1c 24             	mov    %ebx,(%esp)
  801118:	e8 9d f2 ff ff       	call   8003ba <fd2data>
  80111d:	83 c4 08             	add    $0x8,%esp
  801120:	50                   	push   %eax
  801121:	6a 00                	push   $0x0
  801123:	e8 d7 f0 ff ff       	call   8001ff <sys_page_unmap>
}
  801128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <_pipeisclosed>:
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	57                   	push   %edi
  801131:	56                   	push   %esi
  801132:	53                   	push   %ebx
  801133:	83 ec 1c             	sub    $0x1c,%esp
  801136:	89 c7                	mov    %eax,%edi
  801138:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80113a:	a1 08 40 80 00       	mov    0x804008,%eax
  80113f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	57                   	push   %edi
  801146:	e8 c9 0f 00 00       	call   802114 <pageref>
  80114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80114e:	89 34 24             	mov    %esi,(%esp)
  801151:	e8 be 0f 00 00       	call   802114 <pageref>
		nn = thisenv->env_runs;
  801156:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80115c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	39 cb                	cmp    %ecx,%ebx
  801164:	74 1b                	je     801181 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801166:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801169:	75 cf                	jne    80113a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80116b:	8b 42 58             	mov    0x58(%edx),%eax
  80116e:	6a 01                	push   $0x1
  801170:	50                   	push   %eax
  801171:	53                   	push   %ebx
  801172:	68 fb 24 80 00       	push   $0x8024fb
  801177:	e8 13 05 00 00       	call   80168f <cprintf>
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	eb b9                	jmp    80113a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801181:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801184:	0f 94 c0             	sete   %al
  801187:	0f b6 c0             	movzbl %al,%eax
}
  80118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118d:	5b                   	pop    %ebx
  80118e:	5e                   	pop    %esi
  80118f:	5f                   	pop    %edi
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <devpipe_write>:
{
  801192:	f3 0f 1e fb          	endbr32 
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
  80119c:	83 ec 28             	sub    $0x28,%esp
  80119f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011a2:	56                   	push   %esi
  8011a3:	e8 12 f2 ff ff       	call   8003ba <fd2data>
  8011a8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011b5:	74 4f                	je     801206 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011b7:	8b 43 04             	mov    0x4(%ebx),%eax
  8011ba:	8b 0b                	mov    (%ebx),%ecx
  8011bc:	8d 51 20             	lea    0x20(%ecx),%edx
  8011bf:	39 d0                	cmp    %edx,%eax
  8011c1:	72 14                	jb     8011d7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011c3:	89 da                	mov    %ebx,%edx
  8011c5:	89 f0                	mov    %esi,%eax
  8011c7:	e8 61 ff ff ff       	call   80112d <_pipeisclosed>
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	75 3b                	jne    80120b <devpipe_write+0x79>
			sys_yield();
  8011d0:	e8 7a ef ff ff       	call   80014f <sys_yield>
  8011d5:	eb e0                	jmp    8011b7 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	c1 fa 1f             	sar    $0x1f,%edx
  8011e6:	89 d1                	mov    %edx,%ecx
  8011e8:	c1 e9 1b             	shr    $0x1b,%ecx
  8011eb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8011ee:	83 e2 1f             	and    $0x1f,%edx
  8011f1:	29 ca                	sub    %ecx,%edx
  8011f3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8011f7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8011fb:	83 c0 01             	add    $0x1,%eax
  8011fe:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801201:	83 c7 01             	add    $0x1,%edi
  801204:	eb ac                	jmp    8011b2 <devpipe_write+0x20>
	return i;
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	eb 05                	jmp    801210 <devpipe_write+0x7e>
				return 0;
  80120b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5f                   	pop    %edi
  801216:	5d                   	pop    %ebp
  801217:	c3                   	ret    

00801218 <devpipe_read>:
{
  801218:	f3 0f 1e fb          	endbr32 
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	57                   	push   %edi
  801220:	56                   	push   %esi
  801221:	53                   	push   %ebx
  801222:	83 ec 18             	sub    $0x18,%esp
  801225:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801228:	57                   	push   %edi
  801229:	e8 8c f1 ff ff       	call   8003ba <fd2data>
  80122e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	be 00 00 00 00       	mov    $0x0,%esi
  801238:	3b 75 10             	cmp    0x10(%ebp),%esi
  80123b:	75 14                	jne    801251 <devpipe_read+0x39>
	return i;
  80123d:	8b 45 10             	mov    0x10(%ebp),%eax
  801240:	eb 02                	jmp    801244 <devpipe_read+0x2c>
				return i;
  801242:	89 f0                	mov    %esi,%eax
}
  801244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    
			sys_yield();
  80124c:	e8 fe ee ff ff       	call   80014f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801251:	8b 03                	mov    (%ebx),%eax
  801253:	3b 43 04             	cmp    0x4(%ebx),%eax
  801256:	75 18                	jne    801270 <devpipe_read+0x58>
			if (i > 0)
  801258:	85 f6                	test   %esi,%esi
  80125a:	75 e6                	jne    801242 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80125c:	89 da                	mov    %ebx,%edx
  80125e:	89 f8                	mov    %edi,%eax
  801260:	e8 c8 fe ff ff       	call   80112d <_pipeisclosed>
  801265:	85 c0                	test   %eax,%eax
  801267:	74 e3                	je     80124c <devpipe_read+0x34>
				return 0;
  801269:	b8 00 00 00 00       	mov    $0x0,%eax
  80126e:	eb d4                	jmp    801244 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801270:	99                   	cltd   
  801271:	c1 ea 1b             	shr    $0x1b,%edx
  801274:	01 d0                	add    %edx,%eax
  801276:	83 e0 1f             	and    $0x1f,%eax
  801279:	29 d0                	sub    %edx,%eax
  80127b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801280:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801283:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801286:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801289:	83 c6 01             	add    $0x1,%esi
  80128c:	eb aa                	jmp    801238 <devpipe_read+0x20>

0080128e <pipe>:
{
  80128e:	f3 0f 1e fb          	endbr32 
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80129a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	e8 32 f1 ff ff       	call   8003d5 <fd_alloc>
  8012a3:	89 c3                	mov    %eax,%ebx
  8012a5:	83 c4 10             	add    $0x10,%esp
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	0f 88 23 01 00 00    	js     8013d3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	68 07 04 00 00       	push   $0x407
  8012b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8012bb:	6a 00                	push   $0x0
  8012bd:	e8 b0 ee ff ff       	call   800172 <sys_page_alloc>
  8012c2:	89 c3                	mov    %eax,%ebx
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	0f 88 04 01 00 00    	js     8013d3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d5:	50                   	push   %eax
  8012d6:	e8 fa f0 ff ff       	call   8003d5 <fd_alloc>
  8012db:	89 c3                	mov    %eax,%ebx
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	0f 88 db 00 00 00    	js     8013c3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 07 04 00 00       	push   $0x407
  8012f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f3:	6a 00                	push   $0x0
  8012f5:	e8 78 ee ff ff       	call   800172 <sys_page_alloc>
  8012fa:	89 c3                	mov    %eax,%ebx
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	0f 88 bc 00 00 00    	js     8013c3 <pipe+0x135>
	va = fd2data(fd0);
  801307:	83 ec 0c             	sub    $0xc,%esp
  80130a:	ff 75 f4             	pushl  -0xc(%ebp)
  80130d:	e8 a8 f0 ff ff       	call   8003ba <fd2data>
  801312:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801314:	83 c4 0c             	add    $0xc,%esp
  801317:	68 07 04 00 00       	push   $0x407
  80131c:	50                   	push   %eax
  80131d:	6a 00                	push   $0x0
  80131f:	e8 4e ee ff ff       	call   800172 <sys_page_alloc>
  801324:	89 c3                	mov    %eax,%ebx
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	0f 88 82 00 00 00    	js     8013b3 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801331:	83 ec 0c             	sub    $0xc,%esp
  801334:	ff 75 f0             	pushl  -0x10(%ebp)
  801337:	e8 7e f0 ff ff       	call   8003ba <fd2data>
  80133c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801343:	50                   	push   %eax
  801344:	6a 00                	push   $0x0
  801346:	56                   	push   %esi
  801347:	6a 00                	push   $0x0
  801349:	e8 6b ee ff ff       	call   8001b9 <sys_page_map>
  80134e:	89 c3                	mov    %eax,%ebx
  801350:	83 c4 20             	add    $0x20,%esp
  801353:	85 c0                	test   %eax,%eax
  801355:	78 4e                	js     8013a5 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801357:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80135c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801364:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80136b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801373:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80137a:	83 ec 0c             	sub    $0xc,%esp
  80137d:	ff 75 f4             	pushl  -0xc(%ebp)
  801380:	e8 21 f0 ff ff       	call   8003a6 <fd2num>
  801385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801388:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80138a:	83 c4 04             	add    $0x4,%esp
  80138d:	ff 75 f0             	pushl  -0x10(%ebp)
  801390:	e8 11 f0 ff ff       	call   8003a6 <fd2num>
  801395:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801398:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a3:	eb 2e                	jmp    8013d3 <pipe+0x145>
	sys_page_unmap(0, va);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	56                   	push   %esi
  8013a9:	6a 00                	push   $0x0
  8013ab:	e8 4f ee ff ff       	call   8001ff <sys_page_unmap>
  8013b0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8013b9:	6a 00                	push   $0x0
  8013bb:	e8 3f ee ff ff       	call   8001ff <sys_page_unmap>
  8013c0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c9:	6a 00                	push   $0x0
  8013cb:	e8 2f ee ff ff       	call   8001ff <sys_page_unmap>
  8013d0:	83 c4 10             	add    $0x10,%esp
}
  8013d3:	89 d8                	mov    %ebx,%eax
  8013d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <pipeisclosed>:
{
  8013dc:	f3 0f 1e fb          	endbr32 
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e9:	50                   	push   %eax
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	e8 39 f0 ff ff       	call   80042b <fd_lookup>
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 18                	js     801411 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ff:	e8 b6 ef ff ff       	call   8003ba <fd2data>
  801404:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	e8 1f fd ff ff       	call   80112d <_pipeisclosed>
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801413:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
  80141c:	c3                   	ret    

0080141d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80141d:	f3 0f 1e fb          	endbr32 
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801427:	68 13 25 80 00       	push   $0x802513
  80142c:	ff 75 0c             	pushl  0xc(%ebp)
  80142f:	e8 65 08 00 00       	call   801c99 <strcpy>
	return 0;
}
  801434:	b8 00 00 00 00       	mov    $0x0,%eax
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <devcons_write>:
{
  80143b:	f3 0f 1e fb          	endbr32 
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80144b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801450:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801456:	3b 75 10             	cmp    0x10(%ebp),%esi
  801459:	73 31                	jae    80148c <devcons_write+0x51>
		m = n - tot;
  80145b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80145e:	29 f3                	sub    %esi,%ebx
  801460:	83 fb 7f             	cmp    $0x7f,%ebx
  801463:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801468:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	53                   	push   %ebx
  80146f:	89 f0                	mov    %esi,%eax
  801471:	03 45 0c             	add    0xc(%ebp),%eax
  801474:	50                   	push   %eax
  801475:	57                   	push   %edi
  801476:	e8 d4 09 00 00       	call   801e4f <memmove>
		sys_cputs(buf, m);
  80147b:	83 c4 08             	add    $0x8,%esp
  80147e:	53                   	push   %ebx
  80147f:	57                   	push   %edi
  801480:	e8 1d ec ff ff       	call   8000a2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801485:	01 de                	add    %ebx,%esi
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	eb ca                	jmp    801456 <devcons_write+0x1b>
}
  80148c:	89 f0                	mov    %esi,%eax
  80148e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801491:	5b                   	pop    %ebx
  801492:	5e                   	pop    %esi
  801493:	5f                   	pop    %edi
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    

00801496 <devcons_read>:
{
  801496:	f3 0f 1e fb          	endbr32 
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a9:	74 21                	je     8014cc <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014ab:	e8 14 ec ff ff       	call   8000c4 <sys_cgetc>
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	75 07                	jne    8014bb <devcons_read+0x25>
		sys_yield();
  8014b4:	e8 96 ec ff ff       	call   80014f <sys_yield>
  8014b9:	eb f0                	jmp    8014ab <devcons_read+0x15>
	if (c < 0)
  8014bb:	78 0f                	js     8014cc <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014bd:	83 f8 04             	cmp    $0x4,%eax
  8014c0:	74 0c                	je     8014ce <devcons_read+0x38>
	*(char*)vbuf = c;
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	88 02                	mov    %al,(%edx)
	return 1;
  8014c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    
		return 0;
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d3:	eb f7                	jmp    8014cc <devcons_read+0x36>

008014d5 <cputchar>:
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014e5:	6a 01                	push   $0x1
  8014e7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	e8 b2 eb ff ff       	call   8000a2 <sys_cputs>
}
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <getchar>:
{
  8014f5:	f3 0f 1e fb          	endbr32 
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8014ff:	6a 01                	push   $0x1
  801501:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	6a 00                	push   $0x0
  801507:	e8 a7 f1 ff ff       	call   8006b3 <read>
	if (r < 0)
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 06                	js     801519 <getchar+0x24>
	if (r < 1)
  801513:	74 06                	je     80151b <getchar+0x26>
	return c;
  801515:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    
		return -E_EOF;
  80151b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801520:	eb f7                	jmp    801519 <getchar+0x24>

00801522 <iscons>:
{
  801522:	f3 0f 1e fb          	endbr32 
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152f:	50                   	push   %eax
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	e8 f3 ee ff ff       	call   80042b <fd_lookup>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 11                	js     801550 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801542:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801548:	39 10                	cmp    %edx,(%eax)
  80154a:	0f 94 c0             	sete   %al
  80154d:	0f b6 c0             	movzbl %al,%eax
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <opencons>:
{
  801552:	f3 0f 1e fb          	endbr32 
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80155c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155f:	50                   	push   %eax
  801560:	e8 70 ee ff ff       	call   8003d5 <fd_alloc>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 3a                	js     8015a6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 07 04 00 00       	push   $0x407
  801574:	ff 75 f4             	pushl  -0xc(%ebp)
  801577:	6a 00                	push   $0x0
  801579:	e8 f4 eb ff ff       	call   800172 <sys_page_alloc>
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 21                	js     8015a6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801588:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80158e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	50                   	push   %eax
  80159e:	e8 03 ee ff ff       	call   8003a6 <fd2num>
  8015a3:	83 c4 10             	add    $0x10,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015a8:	f3 0f 1e fb          	endbr32 
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	56                   	push   %esi
  8015b0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015b1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015b4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015ba:	e8 6d eb ff ff       	call   80012c <sys_getenvid>
  8015bf:	83 ec 0c             	sub    $0xc,%esp
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	56                   	push   %esi
  8015c9:	50                   	push   %eax
  8015ca:	68 20 25 80 00       	push   $0x802520
  8015cf:	e8 bb 00 00 00       	call   80168f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015d4:	83 c4 18             	add    $0x18,%esp
  8015d7:	53                   	push   %ebx
  8015d8:	ff 75 10             	pushl  0x10(%ebp)
  8015db:	e8 5a 00 00 00       	call   80163a <vcprintf>
	cprintf("\n");
  8015e0:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  8015e7:	e8 a3 00 00 00       	call   80168f <cprintf>
  8015ec:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8015ef:	cc                   	int3   
  8015f0:	eb fd                	jmp    8015ef <_panic+0x47>

008015f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8015f2:	f3 0f 1e fb          	endbr32 
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801600:	8b 13                	mov    (%ebx),%edx
  801602:	8d 42 01             	lea    0x1(%edx),%eax
  801605:	89 03                	mov    %eax,(%ebx)
  801607:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80160a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80160e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801613:	74 09                	je     80161e <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801615:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	68 ff 00 00 00       	push   $0xff
  801626:	8d 43 08             	lea    0x8(%ebx),%eax
  801629:	50                   	push   %eax
  80162a:	e8 73 ea ff ff       	call   8000a2 <sys_cputs>
		b->idx = 0;
  80162f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	eb db                	jmp    801615 <putch+0x23>

0080163a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80163a:	f3 0f 1e fb          	endbr32 
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801647:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80164e:	00 00 00 
	b.cnt = 0;
  801651:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801658:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801667:	50                   	push   %eax
  801668:	68 f2 15 80 00       	push   $0x8015f2
  80166d:	e8 20 01 00 00       	call   801792 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801672:	83 c4 08             	add    $0x8,%esp
  801675:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80167b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801681:	50                   	push   %eax
  801682:	e8 1b ea ff ff       	call   8000a2 <sys_cputs>

	return b.cnt;
}
  801687:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80168f:	f3 0f 1e fb          	endbr32 
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801699:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80169c:	50                   	push   %eax
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	e8 95 ff ff ff       	call   80163a <vcprintf>
	va_end(ap);

	return cnt;
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	57                   	push   %edi
  8016ab:	56                   	push   %esi
  8016ac:	53                   	push   %ebx
  8016ad:	83 ec 1c             	sub    $0x1c,%esp
  8016b0:	89 c7                	mov    %eax,%edi
  8016b2:	89 d6                	mov    %edx,%esi
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	89 d1                	mov    %edx,%ecx
  8016bc:	89 c2                	mov    %eax,%edx
  8016be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016c1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d4:	39 c2                	cmp    %eax,%edx
  8016d6:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016d9:	72 3e                	jb     801719 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016db:	83 ec 0c             	sub    $0xc,%esp
  8016de:	ff 75 18             	pushl  0x18(%ebp)
  8016e1:	83 eb 01             	sub    $0x1,%ebx
  8016e4:	53                   	push   %ebx
  8016e5:	50                   	push   %eax
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8016ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8016f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8016f5:	e8 66 0a 00 00       	call   802160 <__udivdi3>
  8016fa:	83 c4 18             	add    $0x18,%esp
  8016fd:	52                   	push   %edx
  8016fe:	50                   	push   %eax
  8016ff:	89 f2                	mov    %esi,%edx
  801701:	89 f8                	mov    %edi,%eax
  801703:	e8 9f ff ff ff       	call   8016a7 <printnum>
  801708:	83 c4 20             	add    $0x20,%esp
  80170b:	eb 13                	jmp    801720 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	56                   	push   %esi
  801711:	ff 75 18             	pushl  0x18(%ebp)
  801714:	ff d7                	call   *%edi
  801716:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801719:	83 eb 01             	sub    $0x1,%ebx
  80171c:	85 db                	test   %ebx,%ebx
  80171e:	7f ed                	jg     80170d <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	56                   	push   %esi
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	ff 75 e4             	pushl  -0x1c(%ebp)
  80172a:	ff 75 e0             	pushl  -0x20(%ebp)
  80172d:	ff 75 dc             	pushl  -0x24(%ebp)
  801730:	ff 75 d8             	pushl  -0x28(%ebp)
  801733:	e8 38 0b 00 00       	call   802270 <__umoddi3>
  801738:	83 c4 14             	add    $0x14,%esp
  80173b:	0f be 80 43 25 80 00 	movsbl 0x802543(%eax),%eax
  801742:	50                   	push   %eax
  801743:	ff d7                	call   *%edi
}
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801750:	f3 0f 1e fb          	endbr32 
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80175a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80175e:	8b 10                	mov    (%eax),%edx
  801760:	3b 50 04             	cmp    0x4(%eax),%edx
  801763:	73 0a                	jae    80176f <sprintputch+0x1f>
		*b->buf++ = ch;
  801765:	8d 4a 01             	lea    0x1(%edx),%ecx
  801768:	89 08                	mov    %ecx,(%eax)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	88 02                	mov    %al,(%edx)
}
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    

00801771 <printfmt>:
{
  801771:	f3 0f 1e fb          	endbr32 
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80177b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80177e:	50                   	push   %eax
  80177f:	ff 75 10             	pushl  0x10(%ebp)
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	ff 75 08             	pushl  0x8(%ebp)
  801788:	e8 05 00 00 00       	call   801792 <vprintfmt>
}
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <vprintfmt>:
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	57                   	push   %edi
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
  80179c:	83 ec 3c             	sub    $0x3c,%esp
  80179f:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017a5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017a8:	e9 8e 03 00 00       	jmp    801b3b <vprintfmt+0x3a9>
		padc = ' ';
  8017ad:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017b1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017c6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017cb:	8d 47 01             	lea    0x1(%edi),%eax
  8017ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d1:	0f b6 17             	movzbl (%edi),%edx
  8017d4:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017d7:	3c 55                	cmp    $0x55,%al
  8017d9:	0f 87 df 03 00 00    	ja     801bbe <vprintfmt+0x42c>
  8017df:	0f b6 c0             	movzbl %al,%eax
  8017e2:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  8017e9:	00 
  8017ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8017ed:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8017f1:	eb d8                	jmp    8017cb <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017f6:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8017fa:	eb cf                	jmp    8017cb <vprintfmt+0x39>
  8017fc:	0f b6 d2             	movzbl %dl,%edx
  8017ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
  801807:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80180a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80180d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801811:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801814:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801817:	83 f9 09             	cmp    $0x9,%ecx
  80181a:	77 55                	ja     801871 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80181c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80181f:	eb e9                	jmp    80180a <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801821:	8b 45 14             	mov    0x14(%ebp),%eax
  801824:	8b 00                	mov    (%eax),%eax
  801826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801829:	8b 45 14             	mov    0x14(%ebp),%eax
  80182c:	8d 40 04             	lea    0x4(%eax),%eax
  80182f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801832:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801835:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801839:	79 90                	jns    8017cb <vprintfmt+0x39>
				width = precision, precision = -1;
  80183b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80183e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801841:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801848:	eb 81                	jmp    8017cb <vprintfmt+0x39>
  80184a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184d:	85 c0                	test   %eax,%eax
  80184f:	ba 00 00 00 00       	mov    $0x0,%edx
  801854:	0f 49 d0             	cmovns %eax,%edx
  801857:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80185a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80185d:	e9 69 ff ff ff       	jmp    8017cb <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801862:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801865:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80186c:	e9 5a ff ff ff       	jmp    8017cb <vprintfmt+0x39>
  801871:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801874:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801877:	eb bc                	jmp    801835 <vprintfmt+0xa3>
			lflag++;
  801879:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80187c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80187f:	e9 47 ff ff ff       	jmp    8017cb <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801884:	8b 45 14             	mov    0x14(%ebp),%eax
  801887:	8d 78 04             	lea    0x4(%eax),%edi
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	53                   	push   %ebx
  80188e:	ff 30                	pushl  (%eax)
  801890:	ff d6                	call   *%esi
			break;
  801892:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801895:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801898:	e9 9b 02 00 00       	jmp    801b38 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80189d:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a0:	8d 78 04             	lea    0x4(%eax),%edi
  8018a3:	8b 00                	mov    (%eax),%eax
  8018a5:	99                   	cltd   
  8018a6:	31 d0                	xor    %edx,%eax
  8018a8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018aa:	83 f8 0f             	cmp    $0xf,%eax
  8018ad:	7f 23                	jg     8018d2 <vprintfmt+0x140>
  8018af:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8018b6:	85 d2                	test   %edx,%edx
  8018b8:	74 18                	je     8018d2 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018ba:	52                   	push   %edx
  8018bb:	68 a1 24 80 00       	push   $0x8024a1
  8018c0:	53                   	push   %ebx
  8018c1:	56                   	push   %esi
  8018c2:	e8 aa fe ff ff       	call   801771 <printfmt>
  8018c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018ca:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018cd:	e9 66 02 00 00       	jmp    801b38 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018d2:	50                   	push   %eax
  8018d3:	68 5b 25 80 00       	push   $0x80255b
  8018d8:	53                   	push   %ebx
  8018d9:	56                   	push   %esi
  8018da:	e8 92 fe ff ff       	call   801771 <printfmt>
  8018df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018e2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018e5:	e9 4e 02 00 00       	jmp    801b38 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ed:	83 c0 04             	add    $0x4,%eax
  8018f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8018f8:	85 d2                	test   %edx,%edx
  8018fa:	b8 54 25 80 00       	mov    $0x802554,%eax
  8018ff:	0f 45 c2             	cmovne %edx,%eax
  801902:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801905:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801909:	7e 06                	jle    801911 <vprintfmt+0x17f>
  80190b:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80190f:	75 0d                	jne    80191e <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801911:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801914:	89 c7                	mov    %eax,%edi
  801916:	03 45 e0             	add    -0x20(%ebp),%eax
  801919:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80191c:	eb 55                	jmp    801973 <vprintfmt+0x1e1>
  80191e:	83 ec 08             	sub    $0x8,%esp
  801921:	ff 75 d8             	pushl  -0x28(%ebp)
  801924:	ff 75 cc             	pushl  -0x34(%ebp)
  801927:	e8 46 03 00 00       	call   801c72 <strnlen>
  80192c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192f:	29 c2                	sub    %eax,%edx
  801931:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801939:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80193d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801940:	85 ff                	test   %edi,%edi
  801942:	7e 11                	jle    801955 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	53                   	push   %ebx
  801948:	ff 75 e0             	pushl  -0x20(%ebp)
  80194b:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80194d:	83 ef 01             	sub    $0x1,%edi
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	eb eb                	jmp    801940 <vprintfmt+0x1ae>
  801955:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801958:	85 d2                	test   %edx,%edx
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
  80195f:	0f 49 c2             	cmovns %edx,%eax
  801962:	29 c2                	sub    %eax,%edx
  801964:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801967:	eb a8                	jmp    801911 <vprintfmt+0x17f>
					putch(ch, putdat);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	53                   	push   %ebx
  80196d:	52                   	push   %edx
  80196e:	ff d6                	call   *%esi
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801976:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801978:	83 c7 01             	add    $0x1,%edi
  80197b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80197f:	0f be d0             	movsbl %al,%edx
  801982:	85 d2                	test   %edx,%edx
  801984:	74 4b                	je     8019d1 <vprintfmt+0x23f>
  801986:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80198a:	78 06                	js     801992 <vprintfmt+0x200>
  80198c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801990:	78 1e                	js     8019b0 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801992:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801996:	74 d1                	je     801969 <vprintfmt+0x1d7>
  801998:	0f be c0             	movsbl %al,%eax
  80199b:	83 e8 20             	sub    $0x20,%eax
  80199e:	83 f8 5e             	cmp    $0x5e,%eax
  8019a1:	76 c6                	jbe    801969 <vprintfmt+0x1d7>
					putch('?', putdat);
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	53                   	push   %ebx
  8019a7:	6a 3f                	push   $0x3f
  8019a9:	ff d6                	call   *%esi
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	eb c3                	jmp    801973 <vprintfmt+0x1e1>
  8019b0:	89 cf                	mov    %ecx,%edi
  8019b2:	eb 0e                	jmp    8019c2 <vprintfmt+0x230>
				putch(' ', putdat);
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	53                   	push   %ebx
  8019b8:	6a 20                	push   $0x20
  8019ba:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019bc:	83 ef 01             	sub    $0x1,%edi
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 ff                	test   %edi,%edi
  8019c4:	7f ee                	jg     8019b4 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8019cc:	e9 67 01 00 00       	jmp    801b38 <vprintfmt+0x3a6>
  8019d1:	89 cf                	mov    %ecx,%edi
  8019d3:	eb ed                	jmp    8019c2 <vprintfmt+0x230>
	if (lflag >= 2)
  8019d5:	83 f9 01             	cmp    $0x1,%ecx
  8019d8:	7f 1b                	jg     8019f5 <vprintfmt+0x263>
	else if (lflag)
  8019da:	85 c9                	test   %ecx,%ecx
  8019dc:	74 63                	je     801a41 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e6:	99                   	cltd   
  8019e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	8d 40 04             	lea    0x4(%eax),%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	eb 17                	jmp    801a0c <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f8:	8b 50 04             	mov    0x4(%eax),%edx
  8019fb:	8b 00                	mov    (%eax),%eax
  8019fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a00:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	8d 40 08             	lea    0x8(%eax),%eax
  801a09:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a0f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a12:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a17:	85 c9                	test   %ecx,%ecx
  801a19:	0f 89 ff 00 00 00    	jns    801b1e <vprintfmt+0x38c>
				putch('-', putdat);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	53                   	push   %ebx
  801a23:	6a 2d                	push   $0x2d
  801a25:	ff d6                	call   *%esi
				num = -(long long) num;
  801a27:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a2a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a2d:	f7 da                	neg    %edx
  801a2f:	83 d1 00             	adc    $0x0,%ecx
  801a32:	f7 d9                	neg    %ecx
  801a34:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a37:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a3c:	e9 dd 00 00 00       	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a41:	8b 45 14             	mov    0x14(%ebp),%eax
  801a44:	8b 00                	mov    (%eax),%eax
  801a46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a49:	99                   	cltd   
  801a4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	8d 40 04             	lea    0x4(%eax),%eax
  801a53:	89 45 14             	mov    %eax,0x14(%ebp)
  801a56:	eb b4                	jmp    801a0c <vprintfmt+0x27a>
	if (lflag >= 2)
  801a58:	83 f9 01             	cmp    $0x1,%ecx
  801a5b:	7f 1e                	jg     801a7b <vprintfmt+0x2e9>
	else if (lflag)
  801a5d:	85 c9                	test   %ecx,%ecx
  801a5f:	74 32                	je     801a93 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	8b 10                	mov    (%eax),%edx
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	8d 40 04             	lea    0x4(%eax),%eax
  801a6e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a71:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a76:	e9 a3 00 00 00       	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7e:	8b 10                	mov    (%eax),%edx
  801a80:	8b 48 04             	mov    0x4(%eax),%ecx
  801a83:	8d 40 08             	lea    0x8(%eax),%eax
  801a86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a89:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a8e:	e9 8b 00 00 00       	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8b 10                	mov    (%eax),%edx
  801a98:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a9d:	8d 40 04             	lea    0x4(%eax),%eax
  801aa0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aa3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801aa8:	eb 74                	jmp    801b1e <vprintfmt+0x38c>
	if (lflag >= 2)
  801aaa:	83 f9 01             	cmp    $0x1,%ecx
  801aad:	7f 1b                	jg     801aca <vprintfmt+0x338>
	else if (lflag)
  801aaf:	85 c9                	test   %ecx,%ecx
  801ab1:	74 2c                	je     801adf <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 10                	mov    (%eax),%edx
  801ab8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801abd:	8d 40 04             	lea    0x4(%eax),%eax
  801ac0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ac3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801ac8:	eb 54                	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801aca:	8b 45 14             	mov    0x14(%ebp),%eax
  801acd:	8b 10                	mov    (%eax),%edx
  801acf:	8b 48 04             	mov    0x4(%eax),%ecx
  801ad2:	8d 40 08             	lea    0x8(%eax),%eax
  801ad5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ad8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801add:	eb 3f                	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801adf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae2:	8b 10                	mov    (%eax),%edx
  801ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae9:	8d 40 04             	lea    0x4(%eax),%eax
  801aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801aef:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801af4:	eb 28                	jmp    801b1e <vprintfmt+0x38c>
			putch('0', putdat);
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	53                   	push   %ebx
  801afa:	6a 30                	push   $0x30
  801afc:	ff d6                	call   *%esi
			putch('x', putdat);
  801afe:	83 c4 08             	add    $0x8,%esp
  801b01:	53                   	push   %ebx
  801b02:	6a 78                	push   $0x78
  801b04:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b06:	8b 45 14             	mov    0x14(%ebp),%eax
  801b09:	8b 10                	mov    (%eax),%edx
  801b0b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b10:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b13:	8d 40 04             	lea    0x4(%eax),%eax
  801b16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b19:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b1e:	83 ec 0c             	sub    $0xc,%esp
  801b21:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b25:	57                   	push   %edi
  801b26:	ff 75 e0             	pushl  -0x20(%ebp)
  801b29:	50                   	push   %eax
  801b2a:	51                   	push   %ecx
  801b2b:	52                   	push   %edx
  801b2c:	89 da                	mov    %ebx,%edx
  801b2e:	89 f0                	mov    %esi,%eax
  801b30:	e8 72 fb ff ff       	call   8016a7 <printnum>
			break;
  801b35:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b3b:	83 c7 01             	add    $0x1,%edi
  801b3e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b42:	83 f8 25             	cmp    $0x25,%eax
  801b45:	0f 84 62 fc ff ff    	je     8017ad <vprintfmt+0x1b>
			if (ch == '\0')
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	0f 84 8b 00 00 00    	je     801bde <vprintfmt+0x44c>
			putch(ch, putdat);
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	53                   	push   %ebx
  801b57:	50                   	push   %eax
  801b58:	ff d6                	call   *%esi
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	eb dc                	jmp    801b3b <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b5f:	83 f9 01             	cmp    $0x1,%ecx
  801b62:	7f 1b                	jg     801b7f <vprintfmt+0x3ed>
	else if (lflag)
  801b64:	85 c9                	test   %ecx,%ecx
  801b66:	74 2c                	je     801b94 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b68:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6b:	8b 10                	mov    (%eax),%edx
  801b6d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b72:	8d 40 04             	lea    0x4(%eax),%eax
  801b75:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b78:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b7d:	eb 9f                	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b82:	8b 10                	mov    (%eax),%edx
  801b84:	8b 48 04             	mov    0x4(%eax),%ecx
  801b87:	8d 40 08             	lea    0x8(%eax),%eax
  801b8a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b8d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801b92:	eb 8a                	jmp    801b1e <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b94:	8b 45 14             	mov    0x14(%ebp),%eax
  801b97:	8b 10                	mov    (%eax),%edx
  801b99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9e:	8d 40 04             	lea    0x4(%eax),%eax
  801ba1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801ba9:	e9 70 ff ff ff       	jmp    801b1e <vprintfmt+0x38c>
			putch(ch, putdat);
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	53                   	push   %ebx
  801bb2:	6a 25                	push   $0x25
  801bb4:	ff d6                	call   *%esi
			break;
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	e9 7a ff ff ff       	jmp    801b38 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	53                   	push   %ebx
  801bc2:	6a 25                	push   $0x25
  801bc4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	89 f8                	mov    %edi,%eax
  801bcb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bcf:	74 05                	je     801bd6 <vprintfmt+0x444>
  801bd1:	83 e8 01             	sub    $0x1,%eax
  801bd4:	eb f5                	jmp    801bcb <vprintfmt+0x439>
  801bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bd9:	e9 5a ff ff ff       	jmp    801b38 <vprintfmt+0x3a6>
}
  801bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5f                   	pop    %edi
  801be4:	5d                   	pop    %ebp
  801be5:	c3                   	ret    

00801be6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801be6:	f3 0f 1e fb          	endbr32 
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 18             	sub    $0x18,%esp
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801bfd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c07:	85 c0                	test   %eax,%eax
  801c09:	74 26                	je     801c31 <vsnprintf+0x4b>
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	7e 22                	jle    801c31 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c0f:	ff 75 14             	pushl  0x14(%ebp)
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c18:	50                   	push   %eax
  801c19:	68 50 17 80 00       	push   $0x801750
  801c1e:	e8 6f fb ff ff       	call   801792 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c26:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	83 c4 10             	add    $0x10,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    
		return -E_INVAL;
  801c31:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c36:	eb f7                	jmp    801c2f <vsnprintf+0x49>

00801c38 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c38:	f3 0f 1e fb          	endbr32 
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c42:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c45:	50                   	push   %eax
  801c46:	ff 75 10             	pushl  0x10(%ebp)
  801c49:	ff 75 0c             	pushl  0xc(%ebp)
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	e8 92 ff ff ff       	call   801be6 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c56:	f3 0f 1e fb          	endbr32 
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c60:	b8 00 00 00 00       	mov    $0x0,%eax
  801c65:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c69:	74 05                	je     801c70 <strlen+0x1a>
		n++;
  801c6b:	83 c0 01             	add    $0x1,%eax
  801c6e:	eb f5                	jmp    801c65 <strlen+0xf>
	return n;
}
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    

00801c72 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c72:	f3 0f 1e fb          	endbr32 
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	39 d0                	cmp    %edx,%eax
  801c86:	74 0d                	je     801c95 <strnlen+0x23>
  801c88:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c8c:	74 05                	je     801c93 <strnlen+0x21>
		n++;
  801c8e:	83 c0 01             	add    $0x1,%eax
  801c91:	eb f1                	jmp    801c84 <strnlen+0x12>
  801c93:	89 c2                	mov    %eax,%edx
	return n;
}
  801c95:	89 d0                	mov    %edx,%eax
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c99:	f3 0f 1e fb          	endbr32 
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	53                   	push   %ebx
  801ca1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cac:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cb0:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cb3:	83 c0 01             	add    $0x1,%eax
  801cb6:	84 d2                	test   %dl,%dl
  801cb8:	75 f2                	jne    801cac <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cba:	89 c8                	mov    %ecx,%eax
  801cbc:	5b                   	pop    %ebx
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    

00801cbf <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cbf:	f3 0f 1e fb          	endbr32 
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 10             	sub    $0x10,%esp
  801cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ccd:	53                   	push   %ebx
  801cce:	e8 83 ff ff ff       	call   801c56 <strlen>
  801cd3:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cd6:	ff 75 0c             	pushl  0xc(%ebp)
  801cd9:	01 d8                	add    %ebx,%eax
  801cdb:	50                   	push   %eax
  801cdc:	e8 b8 ff ff ff       	call   801c99 <strcpy>
	return dst;
}
  801ce1:	89 d8                	mov    %ebx,%eax
  801ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ce8:	f3 0f 1e fb          	endbr32 
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	89 f3                	mov    %esi,%ebx
  801cf9:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801cfc:	89 f0                	mov    %esi,%eax
  801cfe:	39 d8                	cmp    %ebx,%eax
  801d00:	74 11                	je     801d13 <strncpy+0x2b>
		*dst++ = *src;
  801d02:	83 c0 01             	add    $0x1,%eax
  801d05:	0f b6 0a             	movzbl (%edx),%ecx
  801d08:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d0b:	80 f9 01             	cmp    $0x1,%cl
  801d0e:	83 da ff             	sbb    $0xffffffff,%edx
  801d11:	eb eb                	jmp    801cfe <strncpy+0x16>
	}
	return ret;
}
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	5b                   	pop    %ebx
  801d16:	5e                   	pop    %esi
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d19:	f3 0f 1e fb          	endbr32 
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	56                   	push   %esi
  801d21:	53                   	push   %ebx
  801d22:	8b 75 08             	mov    0x8(%ebp),%esi
  801d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d28:	8b 55 10             	mov    0x10(%ebp),%edx
  801d2b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d2d:	85 d2                	test   %edx,%edx
  801d2f:	74 21                	je     801d52 <strlcpy+0x39>
  801d31:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d35:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d37:	39 c2                	cmp    %eax,%edx
  801d39:	74 14                	je     801d4f <strlcpy+0x36>
  801d3b:	0f b6 19             	movzbl (%ecx),%ebx
  801d3e:	84 db                	test   %bl,%bl
  801d40:	74 0b                	je     801d4d <strlcpy+0x34>
			*dst++ = *src++;
  801d42:	83 c1 01             	add    $0x1,%ecx
  801d45:	83 c2 01             	add    $0x1,%edx
  801d48:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d4b:	eb ea                	jmp    801d37 <strlcpy+0x1e>
  801d4d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d4f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d52:	29 f0                	sub    %esi,%eax
}
  801d54:	5b                   	pop    %ebx
  801d55:	5e                   	pop    %esi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    

00801d58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d58:	f3 0f 1e fb          	endbr32 
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d65:	0f b6 01             	movzbl (%ecx),%eax
  801d68:	84 c0                	test   %al,%al
  801d6a:	74 0c                	je     801d78 <strcmp+0x20>
  801d6c:	3a 02                	cmp    (%edx),%al
  801d6e:	75 08                	jne    801d78 <strcmp+0x20>
		p++, q++;
  801d70:	83 c1 01             	add    $0x1,%ecx
  801d73:	83 c2 01             	add    $0x1,%edx
  801d76:	eb ed                	jmp    801d65 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d78:	0f b6 c0             	movzbl %al,%eax
  801d7b:	0f b6 12             	movzbl (%edx),%edx
  801d7e:	29 d0                	sub    %edx,%eax
}
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d82:	f3 0f 1e fb          	endbr32 
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	53                   	push   %ebx
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d95:	eb 06                	jmp    801d9d <strncmp+0x1b>
		n--, p++, q++;
  801d97:	83 c0 01             	add    $0x1,%eax
  801d9a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801d9d:	39 d8                	cmp    %ebx,%eax
  801d9f:	74 16                	je     801db7 <strncmp+0x35>
  801da1:	0f b6 08             	movzbl (%eax),%ecx
  801da4:	84 c9                	test   %cl,%cl
  801da6:	74 04                	je     801dac <strncmp+0x2a>
  801da8:	3a 0a                	cmp    (%edx),%cl
  801daa:	74 eb                	je     801d97 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dac:	0f b6 00             	movzbl (%eax),%eax
  801daf:	0f b6 12             	movzbl (%edx),%edx
  801db2:	29 d0                	sub    %edx,%eax
}
  801db4:	5b                   	pop    %ebx
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    
		return 0;
  801db7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbc:	eb f6                	jmp    801db4 <strncmp+0x32>

00801dbe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dbe:	f3 0f 1e fb          	endbr32 
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dcc:	0f b6 10             	movzbl (%eax),%edx
  801dcf:	84 d2                	test   %dl,%dl
  801dd1:	74 09                	je     801ddc <strchr+0x1e>
		if (*s == c)
  801dd3:	38 ca                	cmp    %cl,%dl
  801dd5:	74 0a                	je     801de1 <strchr+0x23>
	for (; *s; s++)
  801dd7:	83 c0 01             	add    $0x1,%eax
  801dda:	eb f0                	jmp    801dcc <strchr+0xe>
			return (char *) s;
	return 0;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801de3:	f3 0f 1e fb          	endbr32 
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801df1:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801df4:	38 ca                	cmp    %cl,%dl
  801df6:	74 09                	je     801e01 <strfind+0x1e>
  801df8:	84 d2                	test   %dl,%dl
  801dfa:	74 05                	je     801e01 <strfind+0x1e>
	for (; *s; s++)
  801dfc:	83 c0 01             	add    $0x1,%eax
  801dff:	eb f0                	jmp    801df1 <strfind+0xe>
			break;
	return (char *) s;
}
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e03:	f3 0f 1e fb          	endbr32 
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	57                   	push   %edi
  801e0b:	56                   	push   %esi
  801e0c:	53                   	push   %ebx
  801e0d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e13:	85 c9                	test   %ecx,%ecx
  801e15:	74 31                	je     801e48 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e17:	89 f8                	mov    %edi,%eax
  801e19:	09 c8                	or     %ecx,%eax
  801e1b:	a8 03                	test   $0x3,%al
  801e1d:	75 23                	jne    801e42 <memset+0x3f>
		c &= 0xFF;
  801e1f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e23:	89 d3                	mov    %edx,%ebx
  801e25:	c1 e3 08             	shl    $0x8,%ebx
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	c1 e0 18             	shl    $0x18,%eax
  801e2d:	89 d6                	mov    %edx,%esi
  801e2f:	c1 e6 10             	shl    $0x10,%esi
  801e32:	09 f0                	or     %esi,%eax
  801e34:	09 c2                	or     %eax,%edx
  801e36:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e38:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	fc                   	cld    
  801e3e:	f3 ab                	rep stos %eax,%es:(%edi)
  801e40:	eb 06                	jmp    801e48 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	fc                   	cld    
  801e46:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e48:	89 f8                	mov    %edi,%eax
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e4f:	f3 0f 1e fb          	endbr32 
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	57                   	push   %edi
  801e57:	56                   	push   %esi
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e61:	39 c6                	cmp    %eax,%esi
  801e63:	73 32                	jae    801e97 <memmove+0x48>
  801e65:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e68:	39 c2                	cmp    %eax,%edx
  801e6a:	76 2b                	jbe    801e97 <memmove+0x48>
		s += n;
		d += n;
  801e6c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e6f:	89 fe                	mov    %edi,%esi
  801e71:	09 ce                	or     %ecx,%esi
  801e73:	09 d6                	or     %edx,%esi
  801e75:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e7b:	75 0e                	jne    801e8b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e7d:	83 ef 04             	sub    $0x4,%edi
  801e80:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e83:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e86:	fd                   	std    
  801e87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e89:	eb 09                	jmp    801e94 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e8b:	83 ef 01             	sub    $0x1,%edi
  801e8e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e91:	fd                   	std    
  801e92:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e94:	fc                   	cld    
  801e95:	eb 1a                	jmp    801eb1 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e97:	89 c2                	mov    %eax,%edx
  801e99:	09 ca                	or     %ecx,%edx
  801e9b:	09 f2                	or     %esi,%edx
  801e9d:	f6 c2 03             	test   $0x3,%dl
  801ea0:	75 0a                	jne    801eac <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ea2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ea5:	89 c7                	mov    %eax,%edi
  801ea7:	fc                   	cld    
  801ea8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801eaa:	eb 05                	jmp    801eb1 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801eac:	89 c7                	mov    %eax,%edi
  801eae:	fc                   	cld    
  801eaf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801eb1:	5e                   	pop    %esi
  801eb2:	5f                   	pop    %edi
  801eb3:	5d                   	pop    %ebp
  801eb4:	c3                   	ret    

00801eb5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801eb5:	f3 0f 1e fb          	endbr32 
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ebf:	ff 75 10             	pushl  0x10(%ebp)
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	ff 75 08             	pushl  0x8(%ebp)
  801ec8:	e8 82 ff ff ff       	call   801e4f <memmove>
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ecf:	f3 0f 1e fb          	endbr32 
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	56                   	push   %esi
  801ed7:	53                   	push   %ebx
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	89 c6                	mov    %eax,%esi
  801ee0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ee3:	39 f0                	cmp    %esi,%eax
  801ee5:	74 1c                	je     801f03 <memcmp+0x34>
		if (*s1 != *s2)
  801ee7:	0f b6 08             	movzbl (%eax),%ecx
  801eea:	0f b6 1a             	movzbl (%edx),%ebx
  801eed:	38 d9                	cmp    %bl,%cl
  801eef:	75 08                	jne    801ef9 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801ef1:	83 c0 01             	add    $0x1,%eax
  801ef4:	83 c2 01             	add    $0x1,%edx
  801ef7:	eb ea                	jmp    801ee3 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801ef9:	0f b6 c1             	movzbl %cl,%eax
  801efc:	0f b6 db             	movzbl %bl,%ebx
  801eff:	29 d8                	sub    %ebx,%eax
  801f01:	eb 05                	jmp    801f08 <memcmp+0x39>
	}

	return 0;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f08:	5b                   	pop    %ebx
  801f09:	5e                   	pop    %esi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    

00801f0c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f0c:	f3 0f 1e fb          	endbr32 
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f19:	89 c2                	mov    %eax,%edx
  801f1b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f1e:	39 d0                	cmp    %edx,%eax
  801f20:	73 09                	jae    801f2b <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f22:	38 08                	cmp    %cl,(%eax)
  801f24:	74 05                	je     801f2b <memfind+0x1f>
	for (; s < ends; s++)
  801f26:	83 c0 01             	add    $0x1,%eax
  801f29:	eb f3                	jmp    801f1e <memfind+0x12>
			break;
	return (void *) s;
}
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    

00801f2d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f2d:	f3 0f 1e fb          	endbr32 
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f3d:	eb 03                	jmp    801f42 <strtol+0x15>
		s++;
  801f3f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f42:	0f b6 01             	movzbl (%ecx),%eax
  801f45:	3c 20                	cmp    $0x20,%al
  801f47:	74 f6                	je     801f3f <strtol+0x12>
  801f49:	3c 09                	cmp    $0x9,%al
  801f4b:	74 f2                	je     801f3f <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f4d:	3c 2b                	cmp    $0x2b,%al
  801f4f:	74 2a                	je     801f7b <strtol+0x4e>
	int neg = 0;
  801f51:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f56:	3c 2d                	cmp    $0x2d,%al
  801f58:	74 2b                	je     801f85 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f5a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f60:	75 0f                	jne    801f71 <strtol+0x44>
  801f62:	80 39 30             	cmpb   $0x30,(%ecx)
  801f65:	74 28                	je     801f8f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f67:	85 db                	test   %ebx,%ebx
  801f69:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f6e:	0f 44 d8             	cmove  %eax,%ebx
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
  801f76:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f79:	eb 46                	jmp    801fc1 <strtol+0x94>
		s++;
  801f7b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f7e:	bf 00 00 00 00       	mov    $0x0,%edi
  801f83:	eb d5                	jmp    801f5a <strtol+0x2d>
		s++, neg = 1;
  801f85:	83 c1 01             	add    $0x1,%ecx
  801f88:	bf 01 00 00 00       	mov    $0x1,%edi
  801f8d:	eb cb                	jmp    801f5a <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f93:	74 0e                	je     801fa3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f95:	85 db                	test   %ebx,%ebx
  801f97:	75 d8                	jne    801f71 <strtol+0x44>
		s++, base = 8;
  801f99:	83 c1 01             	add    $0x1,%ecx
  801f9c:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fa1:	eb ce                	jmp    801f71 <strtol+0x44>
		s += 2, base = 16;
  801fa3:	83 c1 02             	add    $0x2,%ecx
  801fa6:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fab:	eb c4                	jmp    801f71 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fad:	0f be d2             	movsbl %dl,%edx
  801fb0:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fb3:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fb6:	7d 3a                	jge    801ff2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fb8:	83 c1 01             	add    $0x1,%ecx
  801fbb:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fbf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fc1:	0f b6 11             	movzbl (%ecx),%edx
  801fc4:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fc7:	89 f3                	mov    %esi,%ebx
  801fc9:	80 fb 09             	cmp    $0x9,%bl
  801fcc:	76 df                	jbe    801fad <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fce:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fd1:	89 f3                	mov    %esi,%ebx
  801fd3:	80 fb 19             	cmp    $0x19,%bl
  801fd6:	77 08                	ja     801fe0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fd8:	0f be d2             	movsbl %dl,%edx
  801fdb:	83 ea 57             	sub    $0x57,%edx
  801fde:	eb d3                	jmp    801fb3 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801fe0:	8d 72 bf             	lea    -0x41(%edx),%esi
  801fe3:	89 f3                	mov    %esi,%ebx
  801fe5:	80 fb 19             	cmp    $0x19,%bl
  801fe8:	77 08                	ja     801ff2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801fea:	0f be d2             	movsbl %dl,%edx
  801fed:	83 ea 37             	sub    $0x37,%edx
  801ff0:	eb c1                	jmp    801fb3 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ff2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ff6:	74 05                	je     801ffd <strtol+0xd0>
		*endptr = (char *) s;
  801ff8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ffb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801ffd:	89 c2                	mov    %eax,%edx
  801fff:	f7 da                	neg    %edx
  802001:	85 ff                	test   %edi,%edi
  802003:	0f 45 c2             	cmovne %edx,%eax
}
  802006:	5b                   	pop    %ebx
  802007:	5e                   	pop    %esi
  802008:	5f                   	pop    %edi
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    

0080200b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80200b:	f3 0f 1e fb          	endbr32 
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	8b 75 08             	mov    0x8(%ebp),%esi
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80201d:	83 e8 01             	sub    $0x1,%eax
  802020:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802025:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80202a:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	50                   	push   %eax
  802032:	e8 07 e3 ff ff       	call   80033e <sys_ipc_recv>
	if (!t) {
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	75 2b                	jne    802069 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80203e:	85 f6                	test   %esi,%esi
  802040:	74 0a                	je     80204c <ipc_recv+0x41>
  802042:	a1 08 40 80 00       	mov    0x804008,%eax
  802047:	8b 40 74             	mov    0x74(%eax),%eax
  80204a:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80204c:	85 db                	test   %ebx,%ebx
  80204e:	74 0a                	je     80205a <ipc_recv+0x4f>
  802050:	a1 08 40 80 00       	mov    0x804008,%eax
  802055:	8b 40 78             	mov    0x78(%eax),%eax
  802058:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80205a:	a1 08 40 80 00       	mov    0x804008,%eax
  80205f:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802062:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802065:	5b                   	pop    %ebx
  802066:	5e                   	pop    %esi
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802069:	85 f6                	test   %esi,%esi
  80206b:	74 06                	je     802073 <ipc_recv+0x68>
  80206d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802073:	85 db                	test   %ebx,%ebx
  802075:	74 eb                	je     802062 <ipc_recv+0x57>
  802077:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80207d:	eb e3                	jmp    802062 <ipc_recv+0x57>

0080207f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80207f:	f3 0f 1e fb          	endbr32 
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	57                   	push   %edi
  802087:	56                   	push   %esi
  802088:	53                   	push   %ebx
  802089:	83 ec 0c             	sub    $0xc,%esp
  80208c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80208f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802092:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802095:	85 db                	test   %ebx,%ebx
  802097:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80209c:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80209f:	ff 75 14             	pushl  0x14(%ebp)
  8020a2:	53                   	push   %ebx
  8020a3:	56                   	push   %esi
  8020a4:	57                   	push   %edi
  8020a5:	e8 6d e2 ff ff       	call   800317 <sys_ipc_try_send>
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	74 1e                	je     8020cf <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020b1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020b4:	75 07                	jne    8020bd <ipc_send+0x3e>
		sys_yield();
  8020b6:	e8 94 e0 ff ff       	call   80014f <sys_yield>
  8020bb:	eb e2                	jmp    80209f <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020bd:	50                   	push   %eax
  8020be:	68 3f 28 80 00       	push   $0x80283f
  8020c3:	6a 39                	push   $0x39
  8020c5:	68 51 28 80 00       	push   $0x802851
  8020ca:	e8 d9 f4 ff ff       	call   8015a8 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5f                   	pop    %edi
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020d7:	f3 0f 1e fb          	endbr32 
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020e6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020e9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020ef:	8b 52 50             	mov    0x50(%edx),%edx
  8020f2:	39 ca                	cmp    %ecx,%edx
  8020f4:	74 11                	je     802107 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8020f6:	83 c0 01             	add    $0x1,%eax
  8020f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020fe:	75 e6                	jne    8020e6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
  802105:	eb 0b                	jmp    802112 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802107:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80210a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80210f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802112:	5d                   	pop    %ebp
  802113:	c3                   	ret    

00802114 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802114:	f3 0f 1e fb          	endbr32 
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80211e:	89 c2                	mov    %eax,%edx
  802120:	c1 ea 16             	shr    $0x16,%edx
  802123:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80212a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80212f:	f6 c1 01             	test   $0x1,%cl
  802132:	74 1c                	je     802150 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802134:	c1 e8 0c             	shr    $0xc,%eax
  802137:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80213e:	a8 01                	test   $0x1,%al
  802140:	74 0e                	je     802150 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802142:	c1 e8 0c             	shr    $0xc,%eax
  802145:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80214c:	ef 
  80214d:	0f b7 d2             	movzwl %dx,%edx
}
  802150:	89 d0                	mov    %edx,%eax
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    
  802154:	66 90                	xchg   %ax,%ax
  802156:	66 90                	xchg   %ax,%ax
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
