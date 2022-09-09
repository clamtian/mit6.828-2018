
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
	*(unsigned*)0 = 0;
  800037:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003e:	00 00 00 
}
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	f3 0f 1e fb          	endbr32 
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	56                   	push   %esi
  80004a:	53                   	push   %ebx
  80004b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800051:	e8 de 00 00 00       	call   800134 <sys_getenvid>
  800056:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800063:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800068:	85 db                	test   %ebx,%ebx
  80006a:	7e 07                	jle    800073 <libmain+0x31>
		binaryname = argv[0];
  80006c:	8b 06                	mov    (%esi),%eax
  80006e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800073:	83 ec 08             	sub    $0x8,%esp
  800076:	56                   	push   %esi
  800077:	53                   	push   %ebx
  800078:	e8 b6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007d:	e8 0a 00 00 00       	call   80008c <exit>
}
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800088:	5b                   	pop    %ebx
  800089:	5e                   	pop    %esi
  80008a:	5d                   	pop    %ebp
  80008b:	c3                   	ret    

0080008c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008c:	f3 0f 1e fb          	endbr32 
  800090:	55                   	push   %ebp
  800091:	89 e5                	mov    %esp,%ebp
  800093:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800096:	e8 07 05 00 00       	call   8005a2 <close_all>
	sys_env_destroy(0);
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	6a 00                	push   $0x0
  8000a0:	e8 4a 00 00 00       	call   8000ef <sys_env_destroy>
}
  8000a5:	83 c4 10             	add    $0x10,%esp
  8000a8:	c9                   	leave  
  8000a9:	c3                   	ret    

008000aa <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000aa:	f3 0f 1e fb          	endbr32 
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	57                   	push   %edi
  8000b2:	56                   	push   %esi
  8000b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	89 c3                	mov    %eax,%ebx
  8000c1:	89 c7                	mov    %eax,%edi
  8000c3:	89 c6                	mov    %eax,%esi
  8000c5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c7:	5b                   	pop    %ebx
  8000c8:	5e                   	pop    %esi
  8000c9:	5f                   	pop    %edi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cc:	f3 0f 1e fb          	endbr32 
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	57                   	push   %edi
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e0:	89 d1                	mov    %edx,%ecx
  8000e2:	89 d3                	mov    %edx,%ebx
  8000e4:	89 d7                	mov    %edx,%edi
  8000e6:	89 d6                	mov    %edx,%esi
  8000e8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000ea:	5b                   	pop    %ebx
  8000eb:	5e                   	pop    %esi
  8000ec:	5f                   	pop    %edi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800101:	8b 55 08             	mov    0x8(%ebp),%edx
  800104:	b8 03 00 00 00       	mov    $0x3,%eax
  800109:	89 cb                	mov    %ecx,%ebx
  80010b:	89 cf                	mov    %ecx,%edi
  80010d:	89 ce                	mov    %ecx,%esi
  80010f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800111:	85 c0                	test   %eax,%eax
  800113:	7f 08                	jg     80011d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800115:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5f                   	pop    %edi
  80011b:	5d                   	pop    %ebp
  80011c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	50                   	push   %eax
  800121:	6a 03                	push   $0x3
  800123:	68 ca 23 80 00       	push   $0x8023ca
  800128:	6a 23                	push   $0x23
  80012a:	68 e7 23 80 00       	push   $0x8023e7
  80012f:	e8 7c 14 00 00       	call   8015b0 <_panic>

00800134 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800134:	f3 0f 1e fb          	endbr32 
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	b8 02 00 00 00       	mov    $0x2,%eax
  800148:	89 d1                	mov    %edx,%ecx
  80014a:	89 d3                	mov    %edx,%ebx
  80014c:	89 d7                	mov    %edx,%edi
  80014e:	89 d6                	mov    %edx,%esi
  800150:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800152:	5b                   	pop    %ebx
  800153:	5e                   	pop    %esi
  800154:	5f                   	pop    %edi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <sys_yield>:

void
sys_yield(void)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	57                   	push   %edi
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
	asm volatile("int %1\n"
  800161:	ba 00 00 00 00       	mov    $0x0,%edx
  800166:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016b:	89 d1                	mov    %edx,%ecx
  80016d:	89 d3                	mov    %edx,%ebx
  80016f:	89 d7                	mov    %edx,%edi
  800171:	89 d6                	mov    %edx,%esi
  800173:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017a:	f3 0f 1e fb          	endbr32 
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800187:	be 00 00 00 00       	mov    $0x0,%esi
  80018c:	8b 55 08             	mov    0x8(%ebp),%edx
  80018f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800192:	b8 04 00 00 00       	mov    $0x4,%eax
  800197:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019a:	89 f7                	mov    %esi,%edi
  80019c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	7f 08                	jg     8001aa <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	50                   	push   %eax
  8001ae:	6a 04                	push   $0x4
  8001b0:	68 ca 23 80 00       	push   $0x8023ca
  8001b5:	6a 23                	push   $0x23
  8001b7:	68 e7 23 80 00       	push   $0x8023e7
  8001bc:	e8 ef 13 00 00       	call   8015b0 <_panic>

008001c1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c1:	f3 0f 1e fb          	endbr32 
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	57                   	push   %edi
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001dc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001df:	8b 75 18             	mov    0x18(%ebp),%esi
  8001e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e4:	85 c0                	test   %eax,%eax
  8001e6:	7f 08                	jg     8001f0 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5e                   	pop    %esi
  8001ed:	5f                   	pop    %edi
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	50                   	push   %eax
  8001f4:	6a 05                	push   $0x5
  8001f6:	68 ca 23 80 00       	push   $0x8023ca
  8001fb:	6a 23                	push   $0x23
  8001fd:	68 e7 23 80 00       	push   $0x8023e7
  800202:	e8 a9 13 00 00       	call   8015b0 <_panic>

00800207 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800207:	f3 0f 1e fb          	endbr32 
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800214:	bb 00 00 00 00       	mov    $0x0,%ebx
  800219:	8b 55 08             	mov    0x8(%ebp),%edx
  80021c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021f:	b8 06 00 00 00       	mov    $0x6,%eax
  800224:	89 df                	mov    %ebx,%edi
  800226:	89 de                	mov    %ebx,%esi
  800228:	cd 30                	int    $0x30
	if(check && ret > 0)
  80022a:	85 c0                	test   %eax,%eax
  80022c:	7f 08                	jg     800236 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	50                   	push   %eax
  80023a:	6a 06                	push   $0x6
  80023c:	68 ca 23 80 00       	push   $0x8023ca
  800241:	6a 23                	push   $0x23
  800243:	68 e7 23 80 00       	push   $0x8023e7
  800248:	e8 63 13 00 00       	call   8015b0 <_panic>

0080024d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80024d:	f3 0f 1e fb          	endbr32 
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80025a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025f:	8b 55 08             	mov    0x8(%ebp),%edx
  800262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800265:	b8 08 00 00 00       	mov    $0x8,%eax
  80026a:	89 df                	mov    %ebx,%edi
  80026c:	89 de                	mov    %ebx,%esi
  80026e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800270:	85 c0                	test   %eax,%eax
  800272:	7f 08                	jg     80027c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800277:	5b                   	pop    %ebx
  800278:	5e                   	pop    %esi
  800279:	5f                   	pop    %edi
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	50                   	push   %eax
  800280:	6a 08                	push   $0x8
  800282:	68 ca 23 80 00       	push   $0x8023ca
  800287:	6a 23                	push   $0x23
  800289:	68 e7 23 80 00       	push   $0x8023e7
  80028e:	e8 1d 13 00 00       	call   8015b0 <_panic>

00800293 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800293:	f3 0f 1e fb          	endbr32 
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	57                   	push   %edi
  80029b:	56                   	push   %esi
  80029c:	53                   	push   %ebx
  80029d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ab:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b0:	89 df                	mov    %ebx,%edi
  8002b2:	89 de                	mov    %ebx,%esi
  8002b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	7f 08                	jg     8002c2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	50                   	push   %eax
  8002c6:	6a 09                	push   $0x9
  8002c8:	68 ca 23 80 00       	push   $0x8023ca
  8002cd:	6a 23                	push   $0x23
  8002cf:	68 e7 23 80 00       	push   $0x8023e7
  8002d4:	e8 d7 12 00 00       	call   8015b0 <_panic>

008002d9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002d9:	f3 0f 1e fb          	endbr32 
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002f6:	89 df                	mov    %ebx,%edi
  8002f8:	89 de                	mov    %ebx,%esi
  8002fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	7f 08                	jg     800308 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800300:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800303:	5b                   	pop    %ebx
  800304:	5e                   	pop    %esi
  800305:	5f                   	pop    %edi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	50                   	push   %eax
  80030c:	6a 0a                	push   $0xa
  80030e:	68 ca 23 80 00       	push   $0x8023ca
  800313:	6a 23                	push   $0x23
  800315:	68 e7 23 80 00       	push   $0x8023e7
  80031a:	e8 91 12 00 00       	call   8015b0 <_panic>

0080031f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80031f:	f3 0f 1e fb          	endbr32 
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
	asm volatile("int %1\n"
  800329:	8b 55 08             	mov    0x8(%ebp),%edx
  80032c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80032f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800334:	be 00 00 00 00       	mov    $0x0,%esi
  800339:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80033f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800341:	5b                   	pop    %ebx
  800342:	5e                   	pop    %esi
  800343:	5f                   	pop    %edi
  800344:	5d                   	pop    %ebp
  800345:	c3                   	ret    

00800346 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800346:	f3 0f 1e fb          	endbr32 
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	57                   	push   %edi
  80034e:	56                   	push   %esi
  80034f:	53                   	push   %ebx
  800350:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800353:	b9 00 00 00 00       	mov    $0x0,%ecx
  800358:	8b 55 08             	mov    0x8(%ebp),%edx
  80035b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800360:	89 cb                	mov    %ecx,%ebx
  800362:	89 cf                	mov    %ecx,%edi
  800364:	89 ce                	mov    %ecx,%esi
  800366:	cd 30                	int    $0x30
	if(check && ret > 0)
  800368:	85 c0                	test   %eax,%eax
  80036a:	7f 08                	jg     800374 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	50                   	push   %eax
  800378:	6a 0d                	push   $0xd
  80037a:	68 ca 23 80 00       	push   $0x8023ca
  80037f:	6a 23                	push   $0x23
  800381:	68 e7 23 80 00       	push   $0x8023e7
  800386:	e8 25 12 00 00       	call   8015b0 <_panic>

0080038b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80038b:	f3 0f 1e fb          	endbr32 
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
	asm volatile("int %1\n"
  800395:	ba 00 00 00 00       	mov    $0x0,%edx
  80039a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039f:	89 d1                	mov    %edx,%ecx
  8003a1:	89 d3                	mov    %edx,%ebx
  8003a3:	89 d7                	mov    %edx,%edi
  8003a5:	89 d6                	mov    %edx,%esi
  8003a7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003a9:	5b                   	pop    %ebx
  8003aa:	5e                   	pop    %esi
  8003ab:	5f                   	pop    %edi
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003ae:	f3 0f 1e fb          	endbr32 
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	05 00 00 00 30       	add    $0x30000000,%eax
  8003bd:	c1 e8 0c             	shr    $0xc,%eax
}
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003c2:	f3 0f 1e fb          	endbr32 
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003dd:	f3 0f 1e fb          	endbr32 
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003e9:	89 c2                	mov    %eax,%edx
  8003eb:	c1 ea 16             	shr    $0x16,%edx
  8003ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003f5:	f6 c2 01             	test   $0x1,%dl
  8003f8:	74 2d                	je     800427 <fd_alloc+0x4a>
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	c1 ea 0c             	shr    $0xc,%edx
  8003ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800406:	f6 c2 01             	test   $0x1,%dl
  800409:	74 1c                	je     800427 <fd_alloc+0x4a>
  80040b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800410:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800415:	75 d2                	jne    8003e9 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800420:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800425:	eb 0a                	jmp    800431 <fd_alloc+0x54>
			*fd_store = fd;
  800427:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800431:	5d                   	pop    %ebp
  800432:	c3                   	ret    

00800433 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800433:	f3 0f 1e fb          	endbr32 
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80043d:	83 f8 1f             	cmp    $0x1f,%eax
  800440:	77 30                	ja     800472 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800442:	c1 e0 0c             	shl    $0xc,%eax
  800445:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80044a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800450:	f6 c2 01             	test   $0x1,%dl
  800453:	74 24                	je     800479 <fd_lookup+0x46>
  800455:	89 c2                	mov    %eax,%edx
  800457:	c1 ea 0c             	shr    $0xc,%edx
  80045a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800461:	f6 c2 01             	test   $0x1,%dl
  800464:	74 1a                	je     800480 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800466:	8b 55 0c             	mov    0xc(%ebp),%edx
  800469:	89 02                	mov    %eax,(%edx)
	return 0;
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800470:	5d                   	pop    %ebp
  800471:	c3                   	ret    
		return -E_INVAL;
  800472:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800477:	eb f7                	jmp    800470 <fd_lookup+0x3d>
		return -E_INVAL;
  800479:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80047e:	eb f0                	jmp    800470 <fd_lookup+0x3d>
  800480:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800485:	eb e9                	jmp    800470 <fd_lookup+0x3d>

00800487 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800487:	f3 0f 1e fb          	endbr32 
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800494:	ba 00 00 00 00       	mov    $0x0,%edx
  800499:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80049e:	39 08                	cmp    %ecx,(%eax)
  8004a0:	74 38                	je     8004da <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004a2:	83 c2 01             	add    $0x1,%edx
  8004a5:	8b 04 95 74 24 80 00 	mov    0x802474(,%edx,4),%eax
  8004ac:	85 c0                	test   %eax,%eax
  8004ae:	75 ee                	jne    80049e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8004b5:	8b 40 48             	mov    0x48(%eax),%eax
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	51                   	push   %ecx
  8004bc:	50                   	push   %eax
  8004bd:	68 f8 23 80 00       	push   $0x8023f8
  8004c2:	e8 d0 11 00 00       	call   801697 <cprintf>
	*dev = 0;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    
			*dev = devtab[i];
  8004da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004df:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e4:	eb f2                	jmp    8004d8 <dev_lookup+0x51>

008004e6 <fd_close>:
{
  8004e6:	f3 0f 1e fb          	endbr32 
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	57                   	push   %edi
  8004ee:	56                   	push   %esi
  8004ef:	53                   	push   %ebx
  8004f0:	83 ec 24             	sub    $0x24,%esp
  8004f3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8004f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8004fc:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004fd:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800503:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800506:	50                   	push   %eax
  800507:	e8 27 ff ff ff       	call   800433 <fd_lookup>
  80050c:	89 c3                	mov    %eax,%ebx
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	85 c0                	test   %eax,%eax
  800513:	78 05                	js     80051a <fd_close+0x34>
	    || fd != fd2)
  800515:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800518:	74 16                	je     800530 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80051a:	89 f8                	mov    %edi,%eax
  80051c:	84 c0                	test   %al,%al
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	0f 44 d8             	cmove  %eax,%ebx
}
  800526:	89 d8                	mov    %ebx,%eax
  800528:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80052b:	5b                   	pop    %ebx
  80052c:	5e                   	pop    %esi
  80052d:	5f                   	pop    %edi
  80052e:	5d                   	pop    %ebp
  80052f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800536:	50                   	push   %eax
  800537:	ff 36                	pushl  (%esi)
  800539:	e8 49 ff ff ff       	call   800487 <dev_lookup>
  80053e:	89 c3                	mov    %eax,%ebx
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 c0                	test   %eax,%eax
  800545:	78 1a                	js     800561 <fd_close+0x7b>
		if (dev->dev_close)
  800547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80054d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800552:	85 c0                	test   %eax,%eax
  800554:	74 0b                	je     800561 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800556:	83 ec 0c             	sub    $0xc,%esp
  800559:	56                   	push   %esi
  80055a:	ff d0                	call   *%eax
  80055c:	89 c3                	mov    %eax,%ebx
  80055e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	56                   	push   %esi
  800565:	6a 00                	push   $0x0
  800567:	e8 9b fc ff ff       	call   800207 <sys_page_unmap>
	return r;
  80056c:	83 c4 10             	add    $0x10,%esp
  80056f:	eb b5                	jmp    800526 <fd_close+0x40>

00800571 <close>:

int
close(int fdnum)
{
  800571:	f3 0f 1e fb          	endbr32 
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80057b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80057e:	50                   	push   %eax
  80057f:	ff 75 08             	pushl  0x8(%ebp)
  800582:	e8 ac fe ff ff       	call   800433 <fd_lookup>
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	85 c0                	test   %eax,%eax
  80058c:	79 02                	jns    800590 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    
		return fd_close(fd, 1);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	6a 01                	push   $0x1
  800595:	ff 75 f4             	pushl  -0xc(%ebp)
  800598:	e8 49 ff ff ff       	call   8004e6 <fd_close>
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	eb ec                	jmp    80058e <close+0x1d>

008005a2 <close_all>:

void
close_all(void)
{
  8005a2:	f3 0f 1e fb          	endbr32 
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
  8005a9:	53                   	push   %ebx
  8005aa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005b2:	83 ec 0c             	sub    $0xc,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	e8 b6 ff ff ff       	call   800571 <close>
	for (i = 0; i < MAXFD; i++)
  8005bb:	83 c3 01             	add    $0x1,%ebx
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	83 fb 20             	cmp    $0x20,%ebx
  8005c4:	75 ec                	jne    8005b2 <close_all+0x10>
}
  8005c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005cb:	f3 0f 1e fb          	endbr32 
  8005cf:	55                   	push   %ebp
  8005d0:	89 e5                	mov    %esp,%ebp
  8005d2:	57                   	push   %edi
  8005d3:	56                   	push   %esi
  8005d4:	53                   	push   %ebx
  8005d5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005db:	50                   	push   %eax
  8005dc:	ff 75 08             	pushl  0x8(%ebp)
  8005df:	e8 4f fe ff ff       	call   800433 <fd_lookup>
  8005e4:	89 c3                	mov    %eax,%ebx
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	85 c0                	test   %eax,%eax
  8005eb:	0f 88 81 00 00 00    	js     800672 <dup+0xa7>
		return r;
	close(newfdnum);
  8005f1:	83 ec 0c             	sub    $0xc,%esp
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	e8 75 ff ff ff       	call   800571 <close>

	newfd = INDEX2FD(newfdnum);
  8005fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ff:	c1 e6 0c             	shl    $0xc,%esi
  800602:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800608:	83 c4 04             	add    $0x4,%esp
  80060b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80060e:	e8 af fd ff ff       	call   8003c2 <fd2data>
  800613:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800615:	89 34 24             	mov    %esi,(%esp)
  800618:	e8 a5 fd ff ff       	call   8003c2 <fd2data>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800622:	89 d8                	mov    %ebx,%eax
  800624:	c1 e8 16             	shr    $0x16,%eax
  800627:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80062e:	a8 01                	test   $0x1,%al
  800630:	74 11                	je     800643 <dup+0x78>
  800632:	89 d8                	mov    %ebx,%eax
  800634:	c1 e8 0c             	shr    $0xc,%eax
  800637:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80063e:	f6 c2 01             	test   $0x1,%dl
  800641:	75 39                	jne    80067c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800643:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800646:	89 d0                	mov    %edx,%eax
  800648:	c1 e8 0c             	shr    $0xc,%eax
  80064b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	25 07 0e 00 00       	and    $0xe07,%eax
  80065a:	50                   	push   %eax
  80065b:	56                   	push   %esi
  80065c:	6a 00                	push   $0x0
  80065e:	52                   	push   %edx
  80065f:	6a 00                	push   $0x0
  800661:	e8 5b fb ff ff       	call   8001c1 <sys_page_map>
  800666:	89 c3                	mov    %eax,%ebx
  800668:	83 c4 20             	add    $0x20,%esp
  80066b:	85 c0                	test   %eax,%eax
  80066d:	78 31                	js     8006a0 <dup+0xd5>
		goto err;

	return newfdnum;
  80066f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800672:	89 d8                	mov    %ebx,%eax
  800674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800677:	5b                   	pop    %ebx
  800678:	5e                   	pop    %esi
  800679:	5f                   	pop    %edi
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80067c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800683:	83 ec 0c             	sub    $0xc,%esp
  800686:	25 07 0e 00 00       	and    $0xe07,%eax
  80068b:	50                   	push   %eax
  80068c:	57                   	push   %edi
  80068d:	6a 00                	push   $0x0
  80068f:	53                   	push   %ebx
  800690:	6a 00                	push   $0x0
  800692:	e8 2a fb ff ff       	call   8001c1 <sys_page_map>
  800697:	89 c3                	mov    %eax,%ebx
  800699:	83 c4 20             	add    $0x20,%esp
  80069c:	85 c0                	test   %eax,%eax
  80069e:	79 a3                	jns    800643 <dup+0x78>
	sys_page_unmap(0, newfd);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	56                   	push   %esi
  8006a4:	6a 00                	push   $0x0
  8006a6:	e8 5c fb ff ff       	call   800207 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006ab:	83 c4 08             	add    $0x8,%esp
  8006ae:	57                   	push   %edi
  8006af:	6a 00                	push   $0x0
  8006b1:	e8 51 fb ff ff       	call   800207 <sys_page_unmap>
	return r;
  8006b6:	83 c4 10             	add    $0x10,%esp
  8006b9:	eb b7                	jmp    800672 <dup+0xa7>

008006bb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006bb:	f3 0f 1e fb          	endbr32 
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 1c             	sub    $0x1c,%esp
  8006c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006cc:	50                   	push   %eax
  8006cd:	53                   	push   %ebx
  8006ce:	e8 60 fd ff ff       	call   800433 <fd_lookup>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	78 3f                	js     800719 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e4:	ff 30                	pushl  (%eax)
  8006e6:	e8 9c fd ff ff       	call   800487 <dev_lookup>
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	78 27                	js     800719 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006f5:	8b 42 08             	mov    0x8(%edx),%eax
  8006f8:	83 e0 03             	and    $0x3,%eax
  8006fb:	83 f8 01             	cmp    $0x1,%eax
  8006fe:	74 1e                	je     80071e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800703:	8b 40 08             	mov    0x8(%eax),%eax
  800706:	85 c0                	test   %eax,%eax
  800708:	74 35                	je     80073f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	ff 75 10             	pushl  0x10(%ebp)
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	52                   	push   %edx
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
}
  800719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80071e:	a1 08 40 80 00       	mov    0x804008,%eax
  800723:	8b 40 48             	mov    0x48(%eax),%eax
  800726:	83 ec 04             	sub    $0x4,%esp
  800729:	53                   	push   %ebx
  80072a:	50                   	push   %eax
  80072b:	68 39 24 80 00       	push   $0x802439
  800730:	e8 62 0f 00 00       	call   801697 <cprintf>
		return -E_INVAL;
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073d:	eb da                	jmp    800719 <read+0x5e>
		return -E_NOT_SUPP;
  80073f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800744:	eb d3                	jmp    800719 <read+0x5e>

00800746 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800746:	f3 0f 1e fb          	endbr32 
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	57                   	push   %edi
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	8b 7d 08             	mov    0x8(%ebp),%edi
  800756:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800759:	bb 00 00 00 00       	mov    $0x0,%ebx
  80075e:	eb 02                	jmp    800762 <readn+0x1c>
  800760:	01 c3                	add    %eax,%ebx
  800762:	39 f3                	cmp    %esi,%ebx
  800764:	73 21                	jae    800787 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800766:	83 ec 04             	sub    $0x4,%esp
  800769:	89 f0                	mov    %esi,%eax
  80076b:	29 d8                	sub    %ebx,%eax
  80076d:	50                   	push   %eax
  80076e:	89 d8                	mov    %ebx,%eax
  800770:	03 45 0c             	add    0xc(%ebp),%eax
  800773:	50                   	push   %eax
  800774:	57                   	push   %edi
  800775:	e8 41 ff ff ff       	call   8006bb <read>
		if (m < 0)
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	85 c0                	test   %eax,%eax
  80077f:	78 04                	js     800785 <readn+0x3f>
			return m;
		if (m == 0)
  800781:	75 dd                	jne    800760 <readn+0x1a>
  800783:	eb 02                	jmp    800787 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800785:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800787:	89 d8                	mov    %ebx,%eax
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800791:	f3 0f 1e fb          	endbr32 
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	53                   	push   %ebx
  800799:	83 ec 1c             	sub    $0x1c,%esp
  80079c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80079f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	53                   	push   %ebx
  8007a4:	e8 8a fc ff ff       	call   800433 <fd_lookup>
  8007a9:	83 c4 10             	add    $0x10,%esp
  8007ac:	85 c0                	test   %eax,%eax
  8007ae:	78 3a                	js     8007ea <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007b6:	50                   	push   %eax
  8007b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ba:	ff 30                	pushl  (%eax)
  8007bc:	e8 c6 fc ff ff       	call   800487 <dev_lookup>
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	78 22                	js     8007ea <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007cf:	74 1e                	je     8007ef <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8007d7:	85 d2                	test   %edx,%edx
  8007d9:	74 35                	je     800810 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	ff 75 10             	pushl  0x10(%ebp)
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	50                   	push   %eax
  8007e5:	ff d2                	call   *%edx
  8007e7:	83 c4 10             	add    $0x10,%esp
}
  8007ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8007f4:	8b 40 48             	mov    0x48(%eax),%eax
  8007f7:	83 ec 04             	sub    $0x4,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	50                   	push   %eax
  8007fc:	68 55 24 80 00       	push   $0x802455
  800801:	e8 91 0e 00 00       	call   801697 <cprintf>
		return -E_INVAL;
  800806:	83 c4 10             	add    $0x10,%esp
  800809:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080e:	eb da                	jmp    8007ea <write+0x59>
		return -E_NOT_SUPP;
  800810:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800815:	eb d3                	jmp    8007ea <write+0x59>

00800817 <seek>:

int
seek(int fdnum, off_t offset)
{
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800824:	50                   	push   %eax
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 06 fc ff ff       	call   800433 <fd_lookup>
  80082d:	83 c4 10             	add    $0x10,%esp
  800830:	85 c0                	test   %eax,%eax
  800832:	78 0e                	js     800842 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800834:	8b 55 0c             	mov    0xc(%ebp),%edx
  800837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80083a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800842:	c9                   	leave  
  800843:	c3                   	ret    

00800844 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800844:	f3 0f 1e fb          	endbr32 
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	53                   	push   %ebx
  80084c:	83 ec 1c             	sub    $0x1c,%esp
  80084f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800852:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800855:	50                   	push   %eax
  800856:	53                   	push   %ebx
  800857:	e8 d7 fb ff ff       	call   800433 <fd_lookup>
  80085c:	83 c4 10             	add    $0x10,%esp
  80085f:	85 c0                	test   %eax,%eax
  800861:	78 37                	js     80089a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800869:	50                   	push   %eax
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	ff 30                	pushl  (%eax)
  80086f:	e8 13 fc ff ff       	call   800487 <dev_lookup>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	85 c0                	test   %eax,%eax
  800879:	78 1f                	js     80089a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80087b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800882:	74 1b                	je     80089f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800887:	8b 52 18             	mov    0x18(%edx),%edx
  80088a:	85 d2                	test   %edx,%edx
  80088c:	74 32                	je     8008c0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	50                   	push   %eax
  800895:	ff d2                	call   *%edx
  800897:	83 c4 10             	add    $0x10,%esp
}
  80089a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80089f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008a4:	8b 40 48             	mov    0x48(%eax),%eax
  8008a7:	83 ec 04             	sub    $0x4,%esp
  8008aa:	53                   	push   %ebx
  8008ab:	50                   	push   %eax
  8008ac:	68 18 24 80 00       	push   $0x802418
  8008b1:	e8 e1 0d 00 00       	call   801697 <cprintf>
		return -E_INVAL;
  8008b6:	83 c4 10             	add    $0x10,%esp
  8008b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008be:	eb da                	jmp    80089a <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008c0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008c5:	eb d3                	jmp    80089a <ftruncate+0x56>

008008c7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008c7:	f3 0f 1e fb          	endbr32 
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	53                   	push   %ebx
  8008cf:	83 ec 1c             	sub    $0x1c,%esp
  8008d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 08             	pushl  0x8(%ebp)
  8008dc:	e8 52 fb ff ff       	call   800433 <fd_lookup>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	78 4b                	js     800933 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e8:	83 ec 08             	sub    $0x8,%esp
  8008eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ee:	50                   	push   %eax
  8008ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f2:	ff 30                	pushl  (%eax)
  8008f4:	e8 8e fb ff ff       	call   800487 <dev_lookup>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	85 c0                	test   %eax,%eax
  8008fe:	78 33                	js     800933 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800903:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800907:	74 2f                	je     800938 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800909:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80090c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800913:	00 00 00 
	stat->st_isdir = 0;
  800916:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80091d:	00 00 00 
	stat->st_dev = dev;
  800920:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	53                   	push   %ebx
  80092a:	ff 75 f0             	pushl  -0x10(%ebp)
  80092d:	ff 50 14             	call   *0x14(%eax)
  800930:	83 c4 10             	add    $0x10,%esp
}
  800933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800936:	c9                   	leave  
  800937:	c3                   	ret    
		return -E_NOT_SUPP;
  800938:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80093d:	eb f4                	jmp    800933 <fstat+0x6c>

0080093f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80093f:	f3 0f 1e fb          	endbr32 
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	56                   	push   %esi
  800947:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	6a 00                	push   $0x0
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 fb 01 00 00       	call   800b50 <open>
  800955:	89 c3                	mov    %eax,%ebx
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	85 c0                	test   %eax,%eax
  80095c:	78 1b                	js     800979 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	50                   	push   %eax
  800965:	e8 5d ff ff ff       	call   8008c7 <fstat>
  80096a:	89 c6                	mov    %eax,%esi
	close(fd);
  80096c:	89 1c 24             	mov    %ebx,(%esp)
  80096f:	e8 fd fb ff ff       	call   800571 <close>
	return r;
  800974:	83 c4 10             	add    $0x10,%esp
  800977:	89 f3                	mov    %esi,%ebx
}
  800979:	89 d8                	mov    %ebx,%eax
  80097b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	89 c6                	mov    %eax,%esi
  800989:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80098b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800992:	74 27                	je     8009bb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800994:	6a 07                	push   $0x7
  800996:	68 00 50 80 00       	push   $0x805000
  80099b:	56                   	push   %esi
  80099c:	ff 35 00 40 80 00    	pushl  0x804000
  8009a2:	e8 e0 16 00 00       	call   802087 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a7:	83 c4 0c             	add    $0xc,%esp
  8009aa:	6a 00                	push   $0x0
  8009ac:	53                   	push   %ebx
  8009ad:	6a 00                	push   $0x0
  8009af:	e8 5f 16 00 00       	call   802013 <ipc_recv>
}
  8009b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009bb:	83 ec 0c             	sub    $0xc,%esp
  8009be:	6a 01                	push   $0x1
  8009c0:	e8 1a 17 00 00       	call   8020df <ipc_find_env>
  8009c5:	a3 00 40 80 00       	mov    %eax,0x804000
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	eb c5                	jmp    800994 <fsipc+0x12>

008009cf <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009cf:	f3 0f 1e fb          	endbr32 
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8009df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f1:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f6:	e8 87 ff ff ff       	call   800982 <fsipc>
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <devfile_flush>:
{
  8009fd:	f3 0f 1e fb          	endbr32 
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a12:	ba 00 00 00 00       	mov    $0x0,%edx
  800a17:	b8 06 00 00 00       	mov    $0x6,%eax
  800a1c:	e8 61 ff ff ff       	call   800982 <fsipc>
}
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <devfile_stat>:
{
  800a23:	f3 0f 1e fb          	endbr32 
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 04             	sub    $0x4,%esp
  800a2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8b 40 0c             	mov    0xc(%eax),%eax
  800a37:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a41:	b8 05 00 00 00       	mov    $0x5,%eax
  800a46:	e8 37 ff ff ff       	call   800982 <fsipc>
  800a4b:	85 c0                	test   %eax,%eax
  800a4d:	78 2c                	js     800a7b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	68 00 50 80 00       	push   $0x805000
  800a57:	53                   	push   %ebx
  800a58:	e8 44 12 00 00       	call   801ca1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a5d:	a1 80 50 80 00       	mov    0x805080,%eax
  800a62:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a68:	a1 84 50 80 00       	mov    0x805084,%eax
  800a6d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a73:	83 c4 10             	add    $0x10,%esp
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <devfile_write>:
{
  800a80:	f3 0f 1e fb          	endbr32 
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	83 ec 0c             	sub    $0xc,%esp
  800a8a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a90:	8b 52 0c             	mov    0xc(%edx),%edx
  800a93:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800a99:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800a9e:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aa3:	0f 47 c2             	cmova  %edx,%eax
  800aa6:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800aab:	50                   	push   %eax
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	68 08 50 80 00       	push   $0x805008
  800ab4:	e8 9e 13 00 00       	call   801e57 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ab9:	ba 00 00 00 00       	mov    $0x0,%edx
  800abe:	b8 04 00 00 00       	mov    $0x4,%eax
  800ac3:	e8 ba fe ff ff       	call   800982 <fsipc>
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <devfile_read>:
{
  800aca:	f3 0f 1e fb          	endbr32 
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	56                   	push   %esi
  800ad2:	53                   	push   %ebx
  800ad3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  800adc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ae1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aec:	b8 03 00 00 00       	mov    $0x3,%eax
  800af1:	e8 8c fe ff ff       	call   800982 <fsipc>
  800af6:	89 c3                	mov    %eax,%ebx
  800af8:	85 c0                	test   %eax,%eax
  800afa:	78 1f                	js     800b1b <devfile_read+0x51>
	assert(r <= n);
  800afc:	39 f0                	cmp    %esi,%eax
  800afe:	77 24                	ja     800b24 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b00:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b05:	7f 33                	jg     800b3a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b07:	83 ec 04             	sub    $0x4,%esp
  800b0a:	50                   	push   %eax
  800b0b:	68 00 50 80 00       	push   $0x805000
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	e8 3f 13 00 00       	call   801e57 <memmove>
	return r;
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	89 d8                	mov    %ebx,%eax
  800b1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b20:	5b                   	pop    %ebx
  800b21:	5e                   	pop    %esi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    
	assert(r <= n);
  800b24:	68 88 24 80 00       	push   $0x802488
  800b29:	68 8f 24 80 00       	push   $0x80248f
  800b2e:	6a 7c                	push   $0x7c
  800b30:	68 a4 24 80 00       	push   $0x8024a4
  800b35:	e8 76 0a 00 00       	call   8015b0 <_panic>
	assert(r <= PGSIZE);
  800b3a:	68 af 24 80 00       	push   $0x8024af
  800b3f:	68 8f 24 80 00       	push   $0x80248f
  800b44:	6a 7d                	push   $0x7d
  800b46:	68 a4 24 80 00       	push   $0x8024a4
  800b4b:	e8 60 0a 00 00       	call   8015b0 <_panic>

00800b50 <open>:
{
  800b50:	f3 0f 1e fb          	endbr32 
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 1c             	sub    $0x1c,%esp
  800b5c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b5f:	56                   	push   %esi
  800b60:	e8 f9 10 00 00       	call   801c5e <strlen>
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b6d:	7f 6c                	jg     800bdb <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b6f:	83 ec 0c             	sub    $0xc,%esp
  800b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b75:	50                   	push   %eax
  800b76:	e8 62 f8 ff ff       	call   8003dd <fd_alloc>
  800b7b:	89 c3                	mov    %eax,%ebx
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	85 c0                	test   %eax,%eax
  800b82:	78 3c                	js     800bc0 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	56                   	push   %esi
  800b88:	68 00 50 80 00       	push   $0x805000
  800b8d:	e8 0f 11 00 00       	call   801ca1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba2:	e8 db fd ff ff       	call   800982 <fsipc>
  800ba7:	89 c3                	mov    %eax,%ebx
  800ba9:	83 c4 10             	add    $0x10,%esp
  800bac:	85 c0                	test   %eax,%eax
  800bae:	78 19                	js     800bc9 <open+0x79>
	return fd2num(fd);
  800bb0:	83 ec 0c             	sub    $0xc,%esp
  800bb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb6:	e8 f3 f7 ff ff       	call   8003ae <fd2num>
  800bbb:	89 c3                	mov    %eax,%ebx
  800bbd:	83 c4 10             	add    $0x10,%esp
}
  800bc0:	89 d8                	mov    %ebx,%eax
  800bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc5:	5b                   	pop    %ebx
  800bc6:	5e                   	pop    %esi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    
		fd_close(fd, 0);
  800bc9:	83 ec 08             	sub    $0x8,%esp
  800bcc:	6a 00                	push   $0x0
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	e8 10 f9 ff ff       	call   8004e6 <fd_close>
		return r;
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	eb e5                	jmp    800bc0 <open+0x70>
		return -E_BAD_PATH;
  800bdb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800be0:	eb de                	jmp    800bc0 <open+0x70>

00800be2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800be2:	f3 0f 1e fb          	endbr32 
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bec:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf1:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf6:	e8 87 fd ff ff       	call   800982 <fsipc>
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800bfd:	f3 0f 1e fb          	endbr32 
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c07:	68 bb 24 80 00       	push   $0x8024bb
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	e8 8d 10 00 00       	call   801ca1 <strcpy>
	return 0;
}
  800c14:	b8 00 00 00 00       	mov    $0x0,%eax
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <devsock_close>:
{
  800c1b:	f3 0f 1e fb          	endbr32 
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	53                   	push   %ebx
  800c23:	83 ec 10             	sub    $0x10,%esp
  800c26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c29:	53                   	push   %ebx
  800c2a:	e8 ed 14 00 00       	call   80211c <pageref>
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c39:	83 fa 01             	cmp    $0x1,%edx
  800c3c:	74 05                	je     800c43 <devsock_close+0x28>
}
  800c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c43:	83 ec 0c             	sub    $0xc,%esp
  800c46:	ff 73 0c             	pushl  0xc(%ebx)
  800c49:	e8 e3 02 00 00       	call   800f31 <nsipc_close>
  800c4e:	83 c4 10             	add    $0x10,%esp
  800c51:	eb eb                	jmp    800c3e <devsock_close+0x23>

00800c53 <devsock_write>:
{
  800c53:	f3 0f 1e fb          	endbr32 
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c5d:	6a 00                	push   $0x0
  800c5f:	ff 75 10             	pushl  0x10(%ebp)
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	ff 70 0c             	pushl  0xc(%eax)
  800c6b:	e8 b5 03 00 00       	call   801025 <nsipc_send>
}
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <devsock_read>:
{
  800c72:	f3 0f 1e fb          	endbr32 
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c7c:	6a 00                	push   $0x0
  800c7e:	ff 75 10             	pushl  0x10(%ebp)
  800c81:	ff 75 0c             	pushl  0xc(%ebp)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	ff 70 0c             	pushl  0xc(%eax)
  800c8a:	e8 1f 03 00 00       	call   800fae <nsipc_recv>
}
  800c8f:	c9                   	leave  
  800c90:	c3                   	ret    

00800c91 <fd2sockid>:
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800c97:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800c9a:	52                   	push   %edx
  800c9b:	50                   	push   %eax
  800c9c:	e8 92 f7 ff ff       	call   800433 <fd_lookup>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	78 10                	js     800cb8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cab:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800cb1:	39 08                	cmp    %ecx,(%eax)
  800cb3:	75 05                	jne    800cba <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cb5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    
		return -E_NOT_SUPP;
  800cba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cbf:	eb f7                	jmp    800cb8 <fd2sockid+0x27>

00800cc1 <alloc_sockfd>:
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 1c             	sub    $0x1c,%esp
  800cc9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cce:	50                   	push   %eax
  800ccf:	e8 09 f7 ff ff       	call   8003dd <fd_alloc>
  800cd4:	89 c3                	mov    %eax,%ebx
  800cd6:	83 c4 10             	add    $0x10,%esp
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	78 43                	js     800d20 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800cdd:	83 ec 04             	sub    $0x4,%esp
  800ce0:	68 07 04 00 00       	push   $0x407
  800ce5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce8:	6a 00                	push   $0x0
  800cea:	e8 8b f4 ff ff       	call   80017a <sys_page_alloc>
  800cef:	89 c3                	mov    %eax,%ebx
  800cf1:	83 c4 10             	add    $0x10,%esp
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	78 28                	js     800d20 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d01:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d06:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d0d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d10:	83 ec 0c             	sub    $0xc,%esp
  800d13:	50                   	push   %eax
  800d14:	e8 95 f6 ff ff       	call   8003ae <fd2num>
  800d19:	89 c3                	mov    %eax,%ebx
  800d1b:	83 c4 10             	add    $0x10,%esp
  800d1e:	eb 0c                	jmp    800d2c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	56                   	push   %esi
  800d24:	e8 08 02 00 00       	call   800f31 <nsipc_close>
		return r;
  800d29:	83 c4 10             	add    $0x10,%esp
}
  800d2c:	89 d8                	mov    %ebx,%eax
  800d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <accept>:
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	e8 4a ff ff ff       	call   800c91 <fd2sockid>
  800d47:	85 c0                	test   %eax,%eax
  800d49:	78 1b                	js     800d66 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d4b:	83 ec 04             	sub    $0x4,%esp
  800d4e:	ff 75 10             	pushl  0x10(%ebp)
  800d51:	ff 75 0c             	pushl  0xc(%ebp)
  800d54:	50                   	push   %eax
  800d55:	e8 22 01 00 00       	call   800e7c <nsipc_accept>
  800d5a:	83 c4 10             	add    $0x10,%esp
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	78 05                	js     800d66 <accept+0x31>
	return alloc_sockfd(r);
  800d61:	e8 5b ff ff ff       	call   800cc1 <alloc_sockfd>
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <bind>:
{
  800d68:	f3 0f 1e fb          	endbr32 
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	e8 17 ff ff ff       	call   800c91 <fd2sockid>
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	78 12                	js     800d90 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d7e:	83 ec 04             	sub    $0x4,%esp
  800d81:	ff 75 10             	pushl  0x10(%ebp)
  800d84:	ff 75 0c             	pushl  0xc(%ebp)
  800d87:	50                   	push   %eax
  800d88:	e8 45 01 00 00       	call   800ed2 <nsipc_bind>
  800d8d:	83 c4 10             	add    $0x10,%esp
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <shutdown>:
{
  800d92:	f3 0f 1e fb          	endbr32 
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	e8 ed fe ff ff       	call   800c91 <fd2sockid>
  800da4:	85 c0                	test   %eax,%eax
  800da6:	78 0f                	js     800db7 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	50                   	push   %eax
  800daf:	e8 57 01 00 00       	call   800f0b <nsipc_shutdown>
  800db4:	83 c4 10             	add    $0x10,%esp
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <connect>:
{
  800db9:	f3 0f 1e fb          	endbr32 
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	e8 c6 fe ff ff       	call   800c91 <fd2sockid>
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	78 12                	js     800de1 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	ff 75 10             	pushl  0x10(%ebp)
  800dd5:	ff 75 0c             	pushl  0xc(%ebp)
  800dd8:	50                   	push   %eax
  800dd9:	e8 71 01 00 00       	call   800f4f <nsipc_connect>
  800dde:	83 c4 10             	add    $0x10,%esp
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <listen>:
{
  800de3:	f3 0f 1e fb          	endbr32 
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	e8 9c fe ff ff       	call   800c91 <fd2sockid>
  800df5:	85 c0                	test   %eax,%eax
  800df7:	78 0f                	js     800e08 <listen+0x25>
	return nsipc_listen(r, backlog);
  800df9:	83 ec 08             	sub    $0x8,%esp
  800dfc:	ff 75 0c             	pushl  0xc(%ebp)
  800dff:	50                   	push   %eax
  800e00:	e8 83 01 00 00       	call   800f88 <nsipc_listen>
  800e05:	83 c4 10             	add    $0x10,%esp
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <socket>:

int
socket(int domain, int type, int protocol)
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e14:	ff 75 10             	pushl  0x10(%ebp)
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	ff 75 08             	pushl  0x8(%ebp)
  800e1d:	e8 65 02 00 00       	call   801087 <nsipc_socket>
  800e22:	83 c4 10             	add    $0x10,%esp
  800e25:	85 c0                	test   %eax,%eax
  800e27:	78 05                	js     800e2e <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e29:	e8 93 fe ff ff       	call   800cc1 <alloc_sockfd>
}
  800e2e:	c9                   	leave  
  800e2f:	c3                   	ret    

00800e30 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	53                   	push   %ebx
  800e34:	83 ec 04             	sub    $0x4,%esp
  800e37:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e39:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e40:	74 26                	je     800e68 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e42:	6a 07                	push   $0x7
  800e44:	68 00 60 80 00       	push   $0x806000
  800e49:	53                   	push   %ebx
  800e4a:	ff 35 04 40 80 00    	pushl  0x804004
  800e50:	e8 32 12 00 00       	call   802087 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e55:	83 c4 0c             	add    $0xc,%esp
  800e58:	6a 00                	push   $0x0
  800e5a:	6a 00                	push   $0x0
  800e5c:	6a 00                	push   $0x0
  800e5e:	e8 b0 11 00 00       	call   802013 <ipc_recv>
}
  800e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	6a 02                	push   $0x2
  800e6d:	e8 6d 12 00 00       	call   8020df <ipc_find_env>
  800e72:	a3 04 40 80 00       	mov    %eax,0x804004
  800e77:	83 c4 10             	add    $0x10,%esp
  800e7a:	eb c6                	jmp    800e42 <nsipc+0x12>

00800e7c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e7c:	f3 0f 1e fb          	endbr32 
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e90:	8b 06                	mov    (%esi),%eax
  800e92:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800e97:	b8 01 00 00 00       	mov    $0x1,%eax
  800e9c:	e8 8f ff ff ff       	call   800e30 <nsipc>
  800ea1:	89 c3                	mov    %eax,%ebx
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	79 09                	jns    800eb0 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800ea7:	89 d8                	mov    %ebx,%eax
  800ea9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800eb0:	83 ec 04             	sub    $0x4,%esp
  800eb3:	ff 35 10 60 80 00    	pushl  0x806010
  800eb9:	68 00 60 80 00       	push   $0x806000
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	e8 91 0f 00 00       	call   801e57 <memmove>
		*addrlen = ret->ret_addrlen;
  800ec6:	a1 10 60 80 00       	mov    0x806010,%eax
  800ecb:	89 06                	mov    %eax,(%esi)
  800ecd:	83 c4 10             	add    $0x10,%esp
	return r;
  800ed0:	eb d5                	jmp    800ea7 <nsipc_accept+0x2b>

00800ed2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ed2:	f3 0f 1e fb          	endbr32 
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ee8:	53                   	push   %ebx
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	68 04 60 80 00       	push   $0x806004
  800ef1:	e8 61 0f 00 00       	call   801e57 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800ef6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800efc:	b8 02 00 00 00       	mov    $0x2,%eax
  800f01:	e8 2a ff ff ff       	call   800e30 <nsipc>
}
  800f06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f0b:	f3 0f 1e fb          	endbr32 
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f25:	b8 03 00 00 00       	mov    $0x3,%eax
  800f2a:	e8 01 ff ff ff       	call   800e30 <nsipc>
}
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <nsipc_close>:

int
nsipc_close(int s)
{
  800f31:	f3 0f 1e fb          	endbr32 
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f43:	b8 04 00 00 00       	mov    $0x4,%eax
  800f48:	e8 e3 fe ff ff       	call   800e30 <nsipc>
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f4f:	f3 0f 1e fb          	endbr32 
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	53                   	push   %ebx
  800f57:	83 ec 08             	sub    $0x8,%esp
  800f5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f65:	53                   	push   %ebx
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	68 04 60 80 00       	push   $0x806004
  800f6e:	e8 e4 0e 00 00       	call   801e57 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f79:	b8 05 00 00 00       	mov    $0x5,%eax
  800f7e:	e8 ad fe ff ff       	call   800e30 <nsipc>
}
  800f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f88:	f3 0f 1e fb          	endbr32 
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fa2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fa7:	e8 84 fe ff ff       	call   800e30 <nsipc>
}
  800fac:	c9                   	leave  
  800fad:	c3                   	ret    

00800fae <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fae:	f3 0f 1e fb          	endbr32 
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fc2:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fd0:	b8 07 00 00 00       	mov    $0x7,%eax
  800fd5:	e8 56 fe ff ff       	call   800e30 <nsipc>
  800fda:	89 c3                	mov    %eax,%ebx
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	78 26                	js     801006 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fe0:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800fe6:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800feb:	0f 4e c6             	cmovle %esi,%eax
  800fee:	39 c3                	cmp    %eax,%ebx
  800ff0:	7f 1d                	jg     80100f <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800ff2:	83 ec 04             	sub    $0x4,%esp
  800ff5:	53                   	push   %ebx
  800ff6:	68 00 60 80 00       	push   $0x806000
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	e8 54 0e 00 00       	call   801e57 <memmove>
  801003:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801006:	89 d8                	mov    %ebx,%eax
  801008:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80100f:	68 c7 24 80 00       	push   $0x8024c7
  801014:	68 8f 24 80 00       	push   $0x80248f
  801019:	6a 62                	push   $0x62
  80101b:	68 dc 24 80 00       	push   $0x8024dc
  801020:	e8 8b 05 00 00       	call   8015b0 <_panic>

00801025 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801025:	f3 0f 1e fb          	endbr32 
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	53                   	push   %ebx
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80103b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801041:	7f 2e                	jg     801071 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	53                   	push   %ebx
  801047:	ff 75 0c             	pushl  0xc(%ebp)
  80104a:	68 0c 60 80 00       	push   $0x80600c
  80104f:	e8 03 0e 00 00       	call   801e57 <memmove>
	nsipcbuf.send.req_size = size;
  801054:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801062:	b8 08 00 00 00       	mov    $0x8,%eax
  801067:	e8 c4 fd ff ff       	call   800e30 <nsipc>
}
  80106c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80106f:	c9                   	leave  
  801070:	c3                   	ret    
	assert(size < 1600);
  801071:	68 e8 24 80 00       	push   $0x8024e8
  801076:	68 8f 24 80 00       	push   $0x80248f
  80107b:	6a 6d                	push   $0x6d
  80107d:	68 dc 24 80 00       	push   $0x8024dc
  801082:	e8 29 05 00 00       	call   8015b0 <_panic>

00801087 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801087:	f3 0f 1e fb          	endbr32 
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010a9:	b8 09 00 00 00       	mov    $0x9,%eax
  8010ae:	e8 7d fd ff ff       	call   800e30 <nsipc>
}
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010b5:	f3 0f 1e fb          	endbr32 
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
  8010be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010c1:	83 ec 0c             	sub    $0xc,%esp
  8010c4:	ff 75 08             	pushl  0x8(%ebp)
  8010c7:	e8 f6 f2 ff ff       	call   8003c2 <fd2data>
  8010cc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010ce:	83 c4 08             	add    $0x8,%esp
  8010d1:	68 f4 24 80 00       	push   $0x8024f4
  8010d6:	53                   	push   %ebx
  8010d7:	e8 c5 0b 00 00       	call   801ca1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010dc:	8b 46 04             	mov    0x4(%esi),%eax
  8010df:	2b 06                	sub    (%esi),%eax
  8010e1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010ee:	00 00 00 
	stat->st_dev = &devpipe;
  8010f1:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8010f8:	30 80 00 
	return 0;
}
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5e                   	pop    %esi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801107:	f3 0f 1e fb          	endbr32 
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	53                   	push   %ebx
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801115:	53                   	push   %ebx
  801116:	6a 00                	push   $0x0
  801118:	e8 ea f0 ff ff       	call   800207 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80111d:	89 1c 24             	mov    %ebx,(%esp)
  801120:	e8 9d f2 ff ff       	call   8003c2 <fd2data>
  801125:	83 c4 08             	add    $0x8,%esp
  801128:	50                   	push   %eax
  801129:	6a 00                	push   $0x0
  80112b:	e8 d7 f0 ff ff       	call   800207 <sys_page_unmap>
}
  801130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <_pipeisclosed>:
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	53                   	push   %ebx
  80113b:	83 ec 1c             	sub    $0x1c,%esp
  80113e:	89 c7                	mov    %eax,%edi
  801140:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801142:	a1 08 40 80 00       	mov    0x804008,%eax
  801147:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	57                   	push   %edi
  80114e:	e8 c9 0f 00 00       	call   80211c <pageref>
  801153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801156:	89 34 24             	mov    %esi,(%esp)
  801159:	e8 be 0f 00 00       	call   80211c <pageref>
		nn = thisenv->env_runs;
  80115e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801164:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	39 cb                	cmp    %ecx,%ebx
  80116c:	74 1b                	je     801189 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80116e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801171:	75 cf                	jne    801142 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801173:	8b 42 58             	mov    0x58(%edx),%eax
  801176:	6a 01                	push   $0x1
  801178:	50                   	push   %eax
  801179:	53                   	push   %ebx
  80117a:	68 fb 24 80 00       	push   $0x8024fb
  80117f:	e8 13 05 00 00       	call   801697 <cprintf>
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	eb b9                	jmp    801142 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801189:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80118c:	0f 94 c0             	sete   %al
  80118f:	0f b6 c0             	movzbl %al,%eax
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <devpipe_write>:
{
  80119a:	f3 0f 1e fb          	endbr32 
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	57                   	push   %edi
  8011a2:	56                   	push   %esi
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 28             	sub    $0x28,%esp
  8011a7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011aa:	56                   	push   %esi
  8011ab:	e8 12 f2 ff ff       	call   8003c2 <fd2data>
  8011b0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011bd:	74 4f                	je     80120e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011bf:	8b 43 04             	mov    0x4(%ebx),%eax
  8011c2:	8b 0b                	mov    (%ebx),%ecx
  8011c4:	8d 51 20             	lea    0x20(%ecx),%edx
  8011c7:	39 d0                	cmp    %edx,%eax
  8011c9:	72 14                	jb     8011df <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011cb:	89 da                	mov    %ebx,%edx
  8011cd:	89 f0                	mov    %esi,%eax
  8011cf:	e8 61 ff ff ff       	call   801135 <_pipeisclosed>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	75 3b                	jne    801213 <devpipe_write+0x79>
			sys_yield();
  8011d8:	e8 7a ef ff ff       	call   800157 <sys_yield>
  8011dd:	eb e0                	jmp    8011bf <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011e6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011e9:	89 c2                	mov    %eax,%edx
  8011eb:	c1 fa 1f             	sar    $0x1f,%edx
  8011ee:	89 d1                	mov    %edx,%ecx
  8011f0:	c1 e9 1b             	shr    $0x1b,%ecx
  8011f3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8011f6:	83 e2 1f             	and    $0x1f,%edx
  8011f9:	29 ca                	sub    %ecx,%edx
  8011fb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8011ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801203:	83 c0 01             	add    $0x1,%eax
  801206:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801209:	83 c7 01             	add    $0x1,%edi
  80120c:	eb ac                	jmp    8011ba <devpipe_write+0x20>
	return i;
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	eb 05                	jmp    801218 <devpipe_write+0x7e>
				return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801218:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5e                   	pop    %esi
  80121d:	5f                   	pop    %edi
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <devpipe_read>:
{
  801220:	f3 0f 1e fb          	endbr32 
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	57                   	push   %edi
  801228:	56                   	push   %esi
  801229:	53                   	push   %ebx
  80122a:	83 ec 18             	sub    $0x18,%esp
  80122d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801230:	57                   	push   %edi
  801231:	e8 8c f1 ff ff       	call   8003c2 <fd2data>
  801236:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	be 00 00 00 00       	mov    $0x0,%esi
  801240:	3b 75 10             	cmp    0x10(%ebp),%esi
  801243:	75 14                	jne    801259 <devpipe_read+0x39>
	return i;
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	eb 02                	jmp    80124c <devpipe_read+0x2c>
				return i;
  80124a:	89 f0                	mov    %esi,%eax
}
  80124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    
			sys_yield();
  801254:	e8 fe ee ff ff       	call   800157 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801259:	8b 03                	mov    (%ebx),%eax
  80125b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80125e:	75 18                	jne    801278 <devpipe_read+0x58>
			if (i > 0)
  801260:	85 f6                	test   %esi,%esi
  801262:	75 e6                	jne    80124a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801264:	89 da                	mov    %ebx,%edx
  801266:	89 f8                	mov    %edi,%eax
  801268:	e8 c8 fe ff ff       	call   801135 <_pipeisclosed>
  80126d:	85 c0                	test   %eax,%eax
  80126f:	74 e3                	je     801254 <devpipe_read+0x34>
				return 0;
  801271:	b8 00 00 00 00       	mov    $0x0,%eax
  801276:	eb d4                	jmp    80124c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801278:	99                   	cltd   
  801279:	c1 ea 1b             	shr    $0x1b,%edx
  80127c:	01 d0                	add    %edx,%eax
  80127e:	83 e0 1f             	and    $0x1f,%eax
  801281:	29 d0                	sub    %edx,%eax
  801283:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801288:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80128e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801291:	83 c6 01             	add    $0x1,%esi
  801294:	eb aa                	jmp    801240 <devpipe_read+0x20>

00801296 <pipe>:
{
  801296:	f3 0f 1e fb          	endbr32 
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	e8 32 f1 ff ff       	call   8003dd <fd_alloc>
  8012ab:	89 c3                	mov    %eax,%ebx
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	0f 88 23 01 00 00    	js     8013db <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	68 07 04 00 00       	push   $0x407
  8012c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 b0 ee ff ff       	call   80017a <sys_page_alloc>
  8012ca:	89 c3                	mov    %eax,%ebx
  8012cc:	83 c4 10             	add    $0x10,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	0f 88 04 01 00 00    	js     8013db <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	e8 fa f0 ff ff       	call   8003dd <fd_alloc>
  8012e3:	89 c3                	mov    %eax,%ebx
  8012e5:	83 c4 10             	add    $0x10,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	0f 88 db 00 00 00    	js     8013cb <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012f0:	83 ec 04             	sub    $0x4,%esp
  8012f3:	68 07 04 00 00       	push   $0x407
  8012f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 78 ee ff ff       	call   80017a <sys_page_alloc>
  801302:	89 c3                	mov    %eax,%ebx
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	85 c0                	test   %eax,%eax
  801309:	0f 88 bc 00 00 00    	js     8013cb <pipe+0x135>
	va = fd2data(fd0);
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	ff 75 f4             	pushl  -0xc(%ebp)
  801315:	e8 a8 f0 ff ff       	call   8003c2 <fd2data>
  80131a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80131c:	83 c4 0c             	add    $0xc,%esp
  80131f:	68 07 04 00 00       	push   $0x407
  801324:	50                   	push   %eax
  801325:	6a 00                	push   $0x0
  801327:	e8 4e ee ff ff       	call   80017a <sys_page_alloc>
  80132c:	89 c3                	mov    %eax,%ebx
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	0f 88 82 00 00 00    	js     8013bb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801339:	83 ec 0c             	sub    $0xc,%esp
  80133c:	ff 75 f0             	pushl  -0x10(%ebp)
  80133f:	e8 7e f0 ff ff       	call   8003c2 <fd2data>
  801344:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80134b:	50                   	push   %eax
  80134c:	6a 00                	push   $0x0
  80134e:	56                   	push   %esi
  80134f:	6a 00                	push   $0x0
  801351:	e8 6b ee ff ff       	call   8001c1 <sys_page_map>
  801356:	89 c3                	mov    %eax,%ebx
  801358:	83 c4 20             	add    $0x20,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 4e                	js     8013ad <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80135f:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801367:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801376:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	ff 75 f4             	pushl  -0xc(%ebp)
  801388:	e8 21 f0 ff ff       	call   8003ae <fd2num>
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801392:	83 c4 04             	add    $0x4,%esp
  801395:	ff 75 f0             	pushl  -0x10(%ebp)
  801398:	e8 11 f0 ff ff       	call   8003ae <fd2num>
  80139d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ab:	eb 2e                	jmp    8013db <pipe+0x145>
	sys_page_unmap(0, va);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	56                   	push   %esi
  8013b1:	6a 00                	push   $0x0
  8013b3:	e8 4f ee ff ff       	call   800207 <sys_page_unmap>
  8013b8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	ff 75 f0             	pushl  -0x10(%ebp)
  8013c1:	6a 00                	push   $0x0
  8013c3:	e8 3f ee ff ff       	call   800207 <sys_page_unmap>
  8013c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d1:	6a 00                	push   $0x0
  8013d3:	e8 2f ee ff ff       	call   800207 <sys_page_unmap>
  8013d8:	83 c4 10             	add    $0x10,%esp
}
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <pipeisclosed>:
{
  8013e4:	f3 0f 1e fb          	endbr32 
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	ff 75 08             	pushl  0x8(%ebp)
  8013f5:	e8 39 f0 ff ff       	call   800433 <fd_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 18                	js     801419 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	ff 75 f4             	pushl  -0xc(%ebp)
  801407:	e8 b6 ef ff ff       	call   8003c2 <fd2data>
  80140c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801411:	e8 1f fd ff ff       	call   801135 <_pipeisclosed>
  801416:	83 c4 10             	add    $0x10,%esp
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80141b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
  801424:	c3                   	ret    

00801425 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801425:	f3 0f 1e fb          	endbr32 
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80142f:	68 13 25 80 00       	push   $0x802513
  801434:	ff 75 0c             	pushl  0xc(%ebp)
  801437:	e8 65 08 00 00       	call   801ca1 <strcpy>
	return 0;
}
  80143c:	b8 00 00 00 00       	mov    $0x0,%eax
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <devcons_write>:
{
  801443:	f3 0f 1e fb          	endbr32 
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	57                   	push   %edi
  80144b:	56                   	push   %esi
  80144c:	53                   	push   %ebx
  80144d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801453:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801458:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80145e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801461:	73 31                	jae    801494 <devcons_write+0x51>
		m = n - tot;
  801463:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801466:	29 f3                	sub    %esi,%ebx
  801468:	83 fb 7f             	cmp    $0x7f,%ebx
  80146b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801470:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	53                   	push   %ebx
  801477:	89 f0                	mov    %esi,%eax
  801479:	03 45 0c             	add    0xc(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	57                   	push   %edi
  80147e:	e8 d4 09 00 00       	call   801e57 <memmove>
		sys_cputs(buf, m);
  801483:	83 c4 08             	add    $0x8,%esp
  801486:	53                   	push   %ebx
  801487:	57                   	push   %edi
  801488:	e8 1d ec ff ff       	call   8000aa <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80148d:	01 de                	add    %ebx,%esi
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	eb ca                	jmp    80145e <devcons_write+0x1b>
}
  801494:	89 f0                	mov    %esi,%eax
  801496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5f                   	pop    %edi
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    

0080149e <devcons_read>:
{
  80149e:	f3 0f 1e fb          	endbr32 
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	74 21                	je     8014d4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014b3:	e8 14 ec ff ff       	call   8000cc <sys_cgetc>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	75 07                	jne    8014c3 <devcons_read+0x25>
		sys_yield();
  8014bc:	e8 96 ec ff ff       	call   800157 <sys_yield>
  8014c1:	eb f0                	jmp    8014b3 <devcons_read+0x15>
	if (c < 0)
  8014c3:	78 0f                	js     8014d4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014c5:	83 f8 04             	cmp    $0x4,%eax
  8014c8:	74 0c                	je     8014d6 <devcons_read+0x38>
	*(char*)vbuf = c;
  8014ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cd:	88 02                	mov    %al,(%edx)
	return 1;
  8014cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    
		return 0;
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014db:	eb f7                	jmp    8014d4 <devcons_read+0x36>

008014dd <cputchar>:
{
  8014dd:	f3 0f 1e fb          	endbr32 
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014ed:	6a 01                	push   $0x1
  8014ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014f2:	50                   	push   %eax
  8014f3:	e8 b2 eb ff ff       	call   8000aa <sys_cputs>
}
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <getchar>:
{
  8014fd:	f3 0f 1e fb          	endbr32 
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801507:	6a 01                	push   $0x1
  801509:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	6a 00                	push   $0x0
  80150f:	e8 a7 f1 ff ff       	call   8006bb <read>
	if (r < 0)
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 06                	js     801521 <getchar+0x24>
	if (r < 1)
  80151b:	74 06                	je     801523 <getchar+0x26>
	return c;
  80151d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    
		return -E_EOF;
  801523:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801528:	eb f7                	jmp    801521 <getchar+0x24>

0080152a <iscons>:
{
  80152a:	f3 0f 1e fb          	endbr32 
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801537:	50                   	push   %eax
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 f3 ee ff ff       	call   800433 <fd_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 11                	js     801558 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801550:	39 10                	cmp    %edx,(%eax)
  801552:	0f 94 c0             	sete   %al
  801555:	0f b6 c0             	movzbl %al,%eax
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <opencons>:
{
  80155a:	f3 0f 1e fb          	endbr32 
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801567:	50                   	push   %eax
  801568:	e8 70 ee ff ff       	call   8003dd <fd_alloc>
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 3a                	js     8015ae <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 07 04 00 00       	push   $0x407
  80157c:	ff 75 f4             	pushl  -0xc(%ebp)
  80157f:	6a 00                	push   $0x0
  801581:	e8 f4 eb ff ff       	call   80017a <sys_page_alloc>
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 21                	js     8015ae <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801596:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015a2:	83 ec 0c             	sub    $0xc,%esp
  8015a5:	50                   	push   %eax
  8015a6:	e8 03 ee ff ff       	call   8003ae <fd2num>
  8015ab:	83 c4 10             	add    $0x10,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015b0:	f3 0f 1e fb          	endbr32 
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015b9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015bc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015c2:	e8 6d eb ff ff       	call   800134 <sys_getenvid>
  8015c7:	83 ec 0c             	sub    $0xc,%esp
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	56                   	push   %esi
  8015d1:	50                   	push   %eax
  8015d2:	68 20 25 80 00       	push   $0x802520
  8015d7:	e8 bb 00 00 00       	call   801697 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015dc:	83 c4 18             	add    $0x18,%esp
  8015df:	53                   	push   %ebx
  8015e0:	ff 75 10             	pushl  0x10(%ebp)
  8015e3:	e8 5a 00 00 00       	call   801642 <vcprintf>
	cprintf("\n");
  8015e8:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  8015ef:	e8 a3 00 00 00       	call   801697 <cprintf>
  8015f4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8015f7:	cc                   	int3   
  8015f8:	eb fd                	jmp    8015f7 <_panic+0x47>

008015fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8015fa:	f3 0f 1e fb          	endbr32 
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	53                   	push   %ebx
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801608:	8b 13                	mov    (%ebx),%edx
  80160a:	8d 42 01             	lea    0x1(%edx),%eax
  80160d:	89 03                	mov    %eax,(%ebx)
  80160f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801612:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801616:	3d ff 00 00 00       	cmp    $0xff,%eax
  80161b:	74 09                	je     801626 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80161d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801621:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801624:	c9                   	leave  
  801625:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	68 ff 00 00 00       	push   $0xff
  80162e:	8d 43 08             	lea    0x8(%ebx),%eax
  801631:	50                   	push   %eax
  801632:	e8 73 ea ff ff       	call   8000aa <sys_cputs>
		b->idx = 0;
  801637:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	eb db                	jmp    80161d <putch+0x23>

00801642 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801642:	f3 0f 1e fb          	endbr32 
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80164f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801656:	00 00 00 
	b.cnt = 0;
  801659:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801660:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80166f:	50                   	push   %eax
  801670:	68 fa 15 80 00       	push   $0x8015fa
  801675:	e8 20 01 00 00       	call   80179a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80167a:	83 c4 08             	add    $0x8,%esp
  80167d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801683:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801689:	50                   	push   %eax
  80168a:	e8 1b ea ff ff       	call   8000aa <sys_cputs>

	return b.cnt;
}
  80168f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801697:	f3 0f 1e fb          	endbr32 
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016a1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016a4:	50                   	push   %eax
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	e8 95 ff ff ff       	call   801642 <vcprintf>
	va_end(ap);

	return cnt;
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	57                   	push   %edi
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 1c             	sub    $0x1c,%esp
  8016b8:	89 c7                	mov    %eax,%edi
  8016ba:	89 d6                	mov    %edx,%esi
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c2:	89 d1                	mov    %edx,%ecx
  8016c4:	89 c2                	mov    %eax,%edx
  8016c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016dc:	39 c2                	cmp    %eax,%edx
  8016de:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016e1:	72 3e                	jb     801721 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	ff 75 18             	pushl  0x18(%ebp)
  8016e9:	83 eb 01             	sub    $0x1,%ebx
  8016ec:	53                   	push   %ebx
  8016ed:	50                   	push   %eax
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8016f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8016fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8016fd:	e8 5e 0a 00 00       	call   802160 <__udivdi3>
  801702:	83 c4 18             	add    $0x18,%esp
  801705:	52                   	push   %edx
  801706:	50                   	push   %eax
  801707:	89 f2                	mov    %esi,%edx
  801709:	89 f8                	mov    %edi,%eax
  80170b:	e8 9f ff ff ff       	call   8016af <printnum>
  801710:	83 c4 20             	add    $0x20,%esp
  801713:	eb 13                	jmp    801728 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	56                   	push   %esi
  801719:	ff 75 18             	pushl  0x18(%ebp)
  80171c:	ff d7                	call   *%edi
  80171e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801721:	83 eb 01             	sub    $0x1,%ebx
  801724:	85 db                	test   %ebx,%ebx
  801726:	7f ed                	jg     801715 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	56                   	push   %esi
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801732:	ff 75 e0             	pushl  -0x20(%ebp)
  801735:	ff 75 dc             	pushl  -0x24(%ebp)
  801738:	ff 75 d8             	pushl  -0x28(%ebp)
  80173b:	e8 30 0b 00 00       	call   802270 <__umoddi3>
  801740:	83 c4 14             	add    $0x14,%esp
  801743:	0f be 80 43 25 80 00 	movsbl 0x802543(%eax),%eax
  80174a:	50                   	push   %eax
  80174b:	ff d7                	call   *%edi
}
  80174d:	83 c4 10             	add    $0x10,%esp
  801750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5f                   	pop    %edi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801758:	f3 0f 1e fb          	endbr32 
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801762:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801766:	8b 10                	mov    (%eax),%edx
  801768:	3b 50 04             	cmp    0x4(%eax),%edx
  80176b:	73 0a                	jae    801777 <sprintputch+0x1f>
		*b->buf++ = ch;
  80176d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801770:	89 08                	mov    %ecx,(%eax)
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	88 02                	mov    %al,(%edx)
}
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <printfmt>:
{
  801779:	f3 0f 1e fb          	endbr32 
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801783:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801786:	50                   	push   %eax
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	ff 75 08             	pushl  0x8(%ebp)
  801790:	e8 05 00 00 00       	call   80179a <vprintfmt>
}
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <vprintfmt>:
{
  80179a:	f3 0f 1e fb          	endbr32 
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	57                   	push   %edi
  8017a2:	56                   	push   %esi
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 3c             	sub    $0x3c,%esp
  8017a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8017aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017b0:	e9 8e 03 00 00       	jmp    801b43 <vprintfmt+0x3a9>
		padc = ' ';
  8017b5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017b9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017c0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017ce:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017d3:	8d 47 01             	lea    0x1(%edi),%eax
  8017d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017d9:	0f b6 17             	movzbl (%edi),%edx
  8017dc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017df:	3c 55                	cmp    $0x55,%al
  8017e1:	0f 87 df 03 00 00    	ja     801bc6 <vprintfmt+0x42c>
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  8017f1:	00 
  8017f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8017f5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8017f9:	eb d8                	jmp    8017d3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8017fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8017fe:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801802:	eb cf                	jmp    8017d3 <vprintfmt+0x39>
  801804:	0f b6 d2             	movzbl %dl,%edx
  801807:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
  80180f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801812:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801815:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801819:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80181c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80181f:	83 f9 09             	cmp    $0x9,%ecx
  801822:	77 55                	ja     801879 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801824:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801827:	eb e9                	jmp    801812 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801829:	8b 45 14             	mov    0x14(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801831:	8b 45 14             	mov    0x14(%ebp),%eax
  801834:	8d 40 04             	lea    0x4(%eax),%eax
  801837:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80183a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80183d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801841:	79 90                	jns    8017d3 <vprintfmt+0x39>
				width = precision, precision = -1;
  801843:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801846:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801849:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801850:	eb 81                	jmp    8017d3 <vprintfmt+0x39>
  801852:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801855:	85 c0                	test   %eax,%eax
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	0f 49 d0             	cmovns %eax,%edx
  80185f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801862:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801865:	e9 69 ff ff ff       	jmp    8017d3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80186a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80186d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801874:	e9 5a ff ff ff       	jmp    8017d3 <vprintfmt+0x39>
  801879:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80187c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80187f:	eb bc                	jmp    80183d <vprintfmt+0xa3>
			lflag++;
  801881:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801884:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801887:	e9 47 ff ff ff       	jmp    8017d3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80188c:	8b 45 14             	mov    0x14(%ebp),%eax
  80188f:	8d 78 04             	lea    0x4(%eax),%edi
  801892:	83 ec 08             	sub    $0x8,%esp
  801895:	53                   	push   %ebx
  801896:	ff 30                	pushl  (%eax)
  801898:	ff d6                	call   *%esi
			break;
  80189a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80189d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018a0:	e9 9b 02 00 00       	jmp    801b40 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a8:	8d 78 04             	lea    0x4(%eax),%edi
  8018ab:	8b 00                	mov    (%eax),%eax
  8018ad:	99                   	cltd   
  8018ae:	31 d0                	xor    %edx,%eax
  8018b0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018b2:	83 f8 0f             	cmp    $0xf,%eax
  8018b5:	7f 23                	jg     8018da <vprintfmt+0x140>
  8018b7:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  8018be:	85 d2                	test   %edx,%edx
  8018c0:	74 18                	je     8018da <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018c2:	52                   	push   %edx
  8018c3:	68 a1 24 80 00       	push   $0x8024a1
  8018c8:	53                   	push   %ebx
  8018c9:	56                   	push   %esi
  8018ca:	e8 aa fe ff ff       	call   801779 <printfmt>
  8018cf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018d2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018d5:	e9 66 02 00 00       	jmp    801b40 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018da:	50                   	push   %eax
  8018db:	68 5b 25 80 00       	push   $0x80255b
  8018e0:	53                   	push   %ebx
  8018e1:	56                   	push   %esi
  8018e2:	e8 92 fe ff ff       	call   801779 <printfmt>
  8018e7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018ea:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018ed:	e9 4e 02 00 00       	jmp    801b40 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f5:	83 c0 04             	add    $0x4,%eax
  8018f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8018fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fe:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801900:	85 d2                	test   %edx,%edx
  801902:	b8 54 25 80 00       	mov    $0x802554,%eax
  801907:	0f 45 c2             	cmovne %edx,%eax
  80190a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80190d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801911:	7e 06                	jle    801919 <vprintfmt+0x17f>
  801913:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801917:	75 0d                	jne    801926 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801919:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80191c:	89 c7                	mov    %eax,%edi
  80191e:	03 45 e0             	add    -0x20(%ebp),%eax
  801921:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801924:	eb 55                	jmp    80197b <vprintfmt+0x1e1>
  801926:	83 ec 08             	sub    $0x8,%esp
  801929:	ff 75 d8             	pushl  -0x28(%ebp)
  80192c:	ff 75 cc             	pushl  -0x34(%ebp)
  80192f:	e8 46 03 00 00       	call   801c7a <strnlen>
  801934:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801941:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801945:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801948:	85 ff                	test   %edi,%edi
  80194a:	7e 11                	jle    80195d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80194c:	83 ec 08             	sub    $0x8,%esp
  80194f:	53                   	push   %ebx
  801950:	ff 75 e0             	pushl  -0x20(%ebp)
  801953:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801955:	83 ef 01             	sub    $0x1,%edi
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	eb eb                	jmp    801948 <vprintfmt+0x1ae>
  80195d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801960:	85 d2                	test   %edx,%edx
  801962:	b8 00 00 00 00       	mov    $0x0,%eax
  801967:	0f 49 c2             	cmovns %edx,%eax
  80196a:	29 c2                	sub    %eax,%edx
  80196c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80196f:	eb a8                	jmp    801919 <vprintfmt+0x17f>
					putch(ch, putdat);
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	53                   	push   %ebx
  801975:	52                   	push   %edx
  801976:	ff d6                	call   *%esi
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80197e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801980:	83 c7 01             	add    $0x1,%edi
  801983:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801987:	0f be d0             	movsbl %al,%edx
  80198a:	85 d2                	test   %edx,%edx
  80198c:	74 4b                	je     8019d9 <vprintfmt+0x23f>
  80198e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801992:	78 06                	js     80199a <vprintfmt+0x200>
  801994:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801998:	78 1e                	js     8019b8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80199a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80199e:	74 d1                	je     801971 <vprintfmt+0x1d7>
  8019a0:	0f be c0             	movsbl %al,%eax
  8019a3:	83 e8 20             	sub    $0x20,%eax
  8019a6:	83 f8 5e             	cmp    $0x5e,%eax
  8019a9:	76 c6                	jbe    801971 <vprintfmt+0x1d7>
					putch('?', putdat);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	53                   	push   %ebx
  8019af:	6a 3f                	push   $0x3f
  8019b1:	ff d6                	call   *%esi
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	eb c3                	jmp    80197b <vprintfmt+0x1e1>
  8019b8:	89 cf                	mov    %ecx,%edi
  8019ba:	eb 0e                	jmp    8019ca <vprintfmt+0x230>
				putch(' ', putdat);
  8019bc:	83 ec 08             	sub    $0x8,%esp
  8019bf:	53                   	push   %ebx
  8019c0:	6a 20                	push   $0x20
  8019c2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019c4:	83 ef 01             	sub    $0x1,%edi
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 ff                	test   %edi,%edi
  8019cc:	7f ee                	jg     8019bc <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8019d4:	e9 67 01 00 00       	jmp    801b40 <vprintfmt+0x3a6>
  8019d9:	89 cf                	mov    %ecx,%edi
  8019db:	eb ed                	jmp    8019ca <vprintfmt+0x230>
	if (lflag >= 2)
  8019dd:	83 f9 01             	cmp    $0x1,%ecx
  8019e0:	7f 1b                	jg     8019fd <vprintfmt+0x263>
	else if (lflag)
  8019e2:	85 c9                	test   %ecx,%ecx
  8019e4:	74 63                	je     801a49 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e9:	8b 00                	mov    (%eax),%eax
  8019eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019ee:	99                   	cltd   
  8019ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f5:	8d 40 04             	lea    0x4(%eax),%eax
  8019f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8019fb:	eb 17                	jmp    801a14 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 50 04             	mov    0x4(%eax),%edx
  801a03:	8b 00                	mov    (%eax),%eax
  801a05:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a08:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0e:	8d 40 08             	lea    0x8(%eax),%eax
  801a11:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a17:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a1a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a1f:	85 c9                	test   %ecx,%ecx
  801a21:	0f 89 ff 00 00 00    	jns    801b26 <vprintfmt+0x38c>
				putch('-', putdat);
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	53                   	push   %ebx
  801a2b:	6a 2d                	push   $0x2d
  801a2d:	ff d6                	call   *%esi
				num = -(long long) num;
  801a2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a32:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a35:	f7 da                	neg    %edx
  801a37:	83 d1 00             	adc    $0x0,%ecx
  801a3a:	f7 d9                	neg    %ecx
  801a3c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a3f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a44:	e9 dd 00 00 00       	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a49:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4c:	8b 00                	mov    (%eax),%eax
  801a4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a51:	99                   	cltd   
  801a52:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	8d 40 04             	lea    0x4(%eax),%eax
  801a5b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a5e:	eb b4                	jmp    801a14 <vprintfmt+0x27a>
	if (lflag >= 2)
  801a60:	83 f9 01             	cmp    $0x1,%ecx
  801a63:	7f 1e                	jg     801a83 <vprintfmt+0x2e9>
	else if (lflag)
  801a65:	85 c9                	test   %ecx,%ecx
  801a67:	74 32                	je     801a9b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a69:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6c:	8b 10                	mov    (%eax),%edx
  801a6e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a73:	8d 40 04             	lea    0x4(%eax),%eax
  801a76:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a79:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a7e:	e9 a3 00 00 00       	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a83:	8b 45 14             	mov    0x14(%ebp),%eax
  801a86:	8b 10                	mov    (%eax),%edx
  801a88:	8b 48 04             	mov    0x4(%eax),%ecx
  801a8b:	8d 40 08             	lea    0x8(%eax),%eax
  801a8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a91:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a96:	e9 8b 00 00 00       	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9e:	8b 10                	mov    (%eax),%edx
  801aa0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aa5:	8d 40 04             	lea    0x4(%eax),%eax
  801aa8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aab:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801ab0:	eb 74                	jmp    801b26 <vprintfmt+0x38c>
	if (lflag >= 2)
  801ab2:	83 f9 01             	cmp    $0x1,%ecx
  801ab5:	7f 1b                	jg     801ad2 <vprintfmt+0x338>
	else if (lflag)
  801ab7:	85 c9                	test   %ecx,%ecx
  801ab9:	74 2c                	je     801ae7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801abb:	8b 45 14             	mov    0x14(%ebp),%eax
  801abe:	8b 10                	mov    (%eax),%edx
  801ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac5:	8d 40 04             	lea    0x4(%eax),%eax
  801ac8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801acb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801ad0:	eb 54                	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad5:	8b 10                	mov    (%eax),%edx
  801ad7:	8b 48 04             	mov    0x4(%eax),%ecx
  801ada:	8d 40 08             	lea    0x8(%eax),%eax
  801add:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ae0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801ae5:	eb 3f                	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aea:	8b 10                	mov    (%eax),%edx
  801aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af1:	8d 40 04             	lea    0x4(%eax),%eax
  801af4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801af7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801afc:	eb 28                	jmp    801b26 <vprintfmt+0x38c>
			putch('0', putdat);
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	53                   	push   %ebx
  801b02:	6a 30                	push   $0x30
  801b04:	ff d6                	call   *%esi
			putch('x', putdat);
  801b06:	83 c4 08             	add    $0x8,%esp
  801b09:	53                   	push   %ebx
  801b0a:	6a 78                	push   $0x78
  801b0c:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b11:	8b 10                	mov    (%eax),%edx
  801b13:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b18:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b1b:	8d 40 04             	lea    0x4(%eax),%eax
  801b1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b21:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b26:	83 ec 0c             	sub    $0xc,%esp
  801b29:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b2d:	57                   	push   %edi
  801b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  801b31:	50                   	push   %eax
  801b32:	51                   	push   %ecx
  801b33:	52                   	push   %edx
  801b34:	89 da                	mov    %ebx,%edx
  801b36:	89 f0                	mov    %esi,%eax
  801b38:	e8 72 fb ff ff       	call   8016af <printnum>
			break;
  801b3d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b43:	83 c7 01             	add    $0x1,%edi
  801b46:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b4a:	83 f8 25             	cmp    $0x25,%eax
  801b4d:	0f 84 62 fc ff ff    	je     8017b5 <vprintfmt+0x1b>
			if (ch == '\0')
  801b53:	85 c0                	test   %eax,%eax
  801b55:	0f 84 8b 00 00 00    	je     801be6 <vprintfmt+0x44c>
			putch(ch, putdat);
  801b5b:	83 ec 08             	sub    $0x8,%esp
  801b5e:	53                   	push   %ebx
  801b5f:	50                   	push   %eax
  801b60:	ff d6                	call   *%esi
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	eb dc                	jmp    801b43 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b67:	83 f9 01             	cmp    $0x1,%ecx
  801b6a:	7f 1b                	jg     801b87 <vprintfmt+0x3ed>
	else if (lflag)
  801b6c:	85 c9                	test   %ecx,%ecx
  801b6e:	74 2c                	je     801b9c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b70:	8b 45 14             	mov    0x14(%ebp),%eax
  801b73:	8b 10                	mov    (%eax),%edx
  801b75:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b7a:	8d 40 04             	lea    0x4(%eax),%eax
  801b7d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b80:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b85:	eb 9f                	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b87:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8a:	8b 10                	mov    (%eax),%edx
  801b8c:	8b 48 04             	mov    0x4(%eax),%ecx
  801b8f:	8d 40 08             	lea    0x8(%eax),%eax
  801b92:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b95:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801b9a:	eb 8a                	jmp    801b26 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9f:	8b 10                	mov    (%eax),%edx
  801ba1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ba6:	8d 40 04             	lea    0x4(%eax),%eax
  801ba9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bac:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bb1:	e9 70 ff ff ff       	jmp    801b26 <vprintfmt+0x38c>
			putch(ch, putdat);
  801bb6:	83 ec 08             	sub    $0x8,%esp
  801bb9:	53                   	push   %ebx
  801bba:	6a 25                	push   $0x25
  801bbc:	ff d6                	call   *%esi
			break;
  801bbe:	83 c4 10             	add    $0x10,%esp
  801bc1:	e9 7a ff ff ff       	jmp    801b40 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bc6:	83 ec 08             	sub    $0x8,%esp
  801bc9:	53                   	push   %ebx
  801bca:	6a 25                	push   $0x25
  801bcc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	89 f8                	mov    %edi,%eax
  801bd3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801bd7:	74 05                	je     801bde <vprintfmt+0x444>
  801bd9:	83 e8 01             	sub    $0x1,%eax
  801bdc:	eb f5                	jmp    801bd3 <vprintfmt+0x439>
  801bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801be1:	e9 5a ff ff ff       	jmp    801b40 <vprintfmt+0x3a6>
}
  801be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be9:	5b                   	pop    %ebx
  801bea:	5e                   	pop    %esi
  801beb:	5f                   	pop    %edi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bee:	f3 0f 1e fb          	endbr32 
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 18             	sub    $0x18,%esp
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c01:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c05:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	74 26                	je     801c39 <vsnprintf+0x4b>
  801c13:	85 d2                	test   %edx,%edx
  801c15:	7e 22                	jle    801c39 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c17:	ff 75 14             	pushl  0x14(%ebp)
  801c1a:	ff 75 10             	pushl  0x10(%ebp)
  801c1d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c20:	50                   	push   %eax
  801c21:	68 58 17 80 00       	push   $0x801758
  801c26:	e8 6f fb ff ff       	call   80179a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	83 c4 10             	add    $0x10,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    
		return -E_INVAL;
  801c39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c3e:	eb f7                	jmp    801c37 <vsnprintf+0x49>

00801c40 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c40:	f3 0f 1e fb          	endbr32 
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c4a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c4d:	50                   	push   %eax
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	e8 92 ff ff ff       	call   801bee <vsnprintf>
	va_end(ap);

	return rc;
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c71:	74 05                	je     801c78 <strlen+0x1a>
		n++;
  801c73:	83 c0 01             	add    $0x1,%eax
  801c76:	eb f5                	jmp    801c6d <strlen+0xf>
	return n;
}
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c7a:	f3 0f 1e fb          	endbr32 
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c87:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8c:	39 d0                	cmp    %edx,%eax
  801c8e:	74 0d                	je     801c9d <strnlen+0x23>
  801c90:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c94:	74 05                	je     801c9b <strnlen+0x21>
		n++;
  801c96:	83 c0 01             	add    $0x1,%eax
  801c99:	eb f1                	jmp    801c8c <strnlen+0x12>
  801c9b:	89 c2                	mov    %eax,%edx
	return n;
}
  801c9d:	89 d0                	mov    %edx,%eax
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    

00801ca1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ca1:	f3 0f 1e fb          	endbr32 
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
  801ca9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801caf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cb8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cbb:	83 c0 01             	add    $0x1,%eax
  801cbe:	84 d2                	test   %dl,%dl
  801cc0:	75 f2                	jne    801cb4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cc2:	89 c8                	mov    %ecx,%eax
  801cc4:	5b                   	pop    %ebx
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    

00801cc7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cc7:	f3 0f 1e fb          	endbr32 
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 10             	sub    $0x10,%esp
  801cd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801cd5:	53                   	push   %ebx
  801cd6:	e8 83 ff ff ff       	call   801c5e <strlen>
  801cdb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	01 d8                	add    %ebx,%eax
  801ce3:	50                   	push   %eax
  801ce4:	e8 b8 ff ff ff       	call   801ca1 <strcpy>
	return dst;
}
  801ce9:	89 d8                	mov    %ebx,%eax
  801ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801cf0:	f3 0f 1e fb          	endbr32 
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	56                   	push   %esi
  801cf8:	53                   	push   %ebx
  801cf9:	8b 75 08             	mov    0x8(%ebp),%esi
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	89 f3                	mov    %esi,%ebx
  801d01:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d04:	89 f0                	mov    %esi,%eax
  801d06:	39 d8                	cmp    %ebx,%eax
  801d08:	74 11                	je     801d1b <strncpy+0x2b>
		*dst++ = *src;
  801d0a:	83 c0 01             	add    $0x1,%eax
  801d0d:	0f b6 0a             	movzbl (%edx),%ecx
  801d10:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d13:	80 f9 01             	cmp    $0x1,%cl
  801d16:	83 da ff             	sbb    $0xffffffff,%edx
  801d19:	eb eb                	jmp    801d06 <strncpy+0x16>
	}
	return ret;
}
  801d1b:	89 f0                	mov    %esi,%eax
  801d1d:	5b                   	pop    %ebx
  801d1e:	5e                   	pop    %esi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	56                   	push   %esi
  801d29:	53                   	push   %ebx
  801d2a:	8b 75 08             	mov    0x8(%ebp),%esi
  801d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d30:	8b 55 10             	mov    0x10(%ebp),%edx
  801d33:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d35:	85 d2                	test   %edx,%edx
  801d37:	74 21                	je     801d5a <strlcpy+0x39>
  801d39:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d3d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d3f:	39 c2                	cmp    %eax,%edx
  801d41:	74 14                	je     801d57 <strlcpy+0x36>
  801d43:	0f b6 19             	movzbl (%ecx),%ebx
  801d46:	84 db                	test   %bl,%bl
  801d48:	74 0b                	je     801d55 <strlcpy+0x34>
			*dst++ = *src++;
  801d4a:	83 c1 01             	add    $0x1,%ecx
  801d4d:	83 c2 01             	add    $0x1,%edx
  801d50:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d53:	eb ea                	jmp    801d3f <strlcpy+0x1e>
  801d55:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d57:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d5a:	29 f0                	sub    %esi,%eax
}
  801d5c:	5b                   	pop    %ebx
  801d5d:	5e                   	pop    %esi
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d60:	f3 0f 1e fb          	endbr32 
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d6d:	0f b6 01             	movzbl (%ecx),%eax
  801d70:	84 c0                	test   %al,%al
  801d72:	74 0c                	je     801d80 <strcmp+0x20>
  801d74:	3a 02                	cmp    (%edx),%al
  801d76:	75 08                	jne    801d80 <strcmp+0x20>
		p++, q++;
  801d78:	83 c1 01             	add    $0x1,%ecx
  801d7b:	83 c2 01             	add    $0x1,%edx
  801d7e:	eb ed                	jmp    801d6d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d80:	0f b6 c0             	movzbl %al,%eax
  801d83:	0f b6 12             	movzbl (%edx),%edx
  801d86:	29 d0                	sub    %edx,%eax
}
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    

00801d8a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d8a:	f3 0f 1e fb          	endbr32 
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	53                   	push   %ebx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	89 c3                	mov    %eax,%ebx
  801d9a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801d9d:	eb 06                	jmp    801da5 <strncmp+0x1b>
		n--, p++, q++;
  801d9f:	83 c0 01             	add    $0x1,%eax
  801da2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801da5:	39 d8                	cmp    %ebx,%eax
  801da7:	74 16                	je     801dbf <strncmp+0x35>
  801da9:	0f b6 08             	movzbl (%eax),%ecx
  801dac:	84 c9                	test   %cl,%cl
  801dae:	74 04                	je     801db4 <strncmp+0x2a>
  801db0:	3a 0a                	cmp    (%edx),%cl
  801db2:	74 eb                	je     801d9f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801db4:	0f b6 00             	movzbl (%eax),%eax
  801db7:	0f b6 12             	movzbl (%edx),%edx
  801dba:	29 d0                	sub    %edx,%eax
}
  801dbc:	5b                   	pop    %ebx
  801dbd:	5d                   	pop    %ebp
  801dbe:	c3                   	ret    
		return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb f6                	jmp    801dbc <strncmp+0x32>

00801dc6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dc6:	f3 0f 1e fb          	endbr32 
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801dd4:	0f b6 10             	movzbl (%eax),%edx
  801dd7:	84 d2                	test   %dl,%dl
  801dd9:	74 09                	je     801de4 <strchr+0x1e>
		if (*s == c)
  801ddb:	38 ca                	cmp    %cl,%dl
  801ddd:	74 0a                	je     801de9 <strchr+0x23>
	for (; *s; s++)
  801ddf:	83 c0 01             	add    $0x1,%eax
  801de2:	eb f0                	jmp    801dd4 <strchr+0xe>
			return (char *) s;
	return 0;
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de9:	5d                   	pop    %ebp
  801dea:	c3                   	ret    

00801deb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801deb:	f3 0f 1e fb          	endbr32 
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801df9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801dfc:	38 ca                	cmp    %cl,%dl
  801dfe:	74 09                	je     801e09 <strfind+0x1e>
  801e00:	84 d2                	test   %dl,%dl
  801e02:	74 05                	je     801e09 <strfind+0x1e>
	for (; *s; s++)
  801e04:	83 c0 01             	add    $0x1,%eax
  801e07:	eb f0                	jmp    801df9 <strfind+0xe>
			break;
	return (char *) s;
}
  801e09:	5d                   	pop    %ebp
  801e0a:	c3                   	ret    

00801e0b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e0b:	f3 0f 1e fb          	endbr32 
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	57                   	push   %edi
  801e13:	56                   	push   %esi
  801e14:	53                   	push   %ebx
  801e15:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e1b:	85 c9                	test   %ecx,%ecx
  801e1d:	74 31                	je     801e50 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e1f:	89 f8                	mov    %edi,%eax
  801e21:	09 c8                	or     %ecx,%eax
  801e23:	a8 03                	test   $0x3,%al
  801e25:	75 23                	jne    801e4a <memset+0x3f>
		c &= 0xFF;
  801e27:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e2b:	89 d3                	mov    %edx,%ebx
  801e2d:	c1 e3 08             	shl    $0x8,%ebx
  801e30:	89 d0                	mov    %edx,%eax
  801e32:	c1 e0 18             	shl    $0x18,%eax
  801e35:	89 d6                	mov    %edx,%esi
  801e37:	c1 e6 10             	shl    $0x10,%esi
  801e3a:	09 f0                	or     %esi,%eax
  801e3c:	09 c2                	or     %eax,%edx
  801e3e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e40:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	fc                   	cld    
  801e46:	f3 ab                	rep stos %eax,%es:(%edi)
  801e48:	eb 06                	jmp    801e50 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	fc                   	cld    
  801e4e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e50:	89 f8                	mov    %edi,%eax
  801e52:	5b                   	pop    %ebx
  801e53:	5e                   	pop    %esi
  801e54:	5f                   	pop    %edi
  801e55:	5d                   	pop    %ebp
  801e56:	c3                   	ret    

00801e57 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e57:	f3 0f 1e fb          	endbr32 
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	57                   	push   %edi
  801e5f:	56                   	push   %esi
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e66:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e69:	39 c6                	cmp    %eax,%esi
  801e6b:	73 32                	jae    801e9f <memmove+0x48>
  801e6d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e70:	39 c2                	cmp    %eax,%edx
  801e72:	76 2b                	jbe    801e9f <memmove+0x48>
		s += n;
		d += n;
  801e74:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e77:	89 fe                	mov    %edi,%esi
  801e79:	09 ce                	or     %ecx,%esi
  801e7b:	09 d6                	or     %edx,%esi
  801e7d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e83:	75 0e                	jne    801e93 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e85:	83 ef 04             	sub    $0x4,%edi
  801e88:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e8b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e8e:	fd                   	std    
  801e8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e91:	eb 09                	jmp    801e9c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e93:	83 ef 01             	sub    $0x1,%edi
  801e96:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801e99:	fd                   	std    
  801e9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801e9c:	fc                   	cld    
  801e9d:	eb 1a                	jmp    801eb9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e9f:	89 c2                	mov    %eax,%edx
  801ea1:	09 ca                	or     %ecx,%edx
  801ea3:	09 f2                	or     %esi,%edx
  801ea5:	f6 c2 03             	test   $0x3,%dl
  801ea8:	75 0a                	jne    801eb4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801eaa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ead:	89 c7                	mov    %eax,%edi
  801eaf:	fc                   	cld    
  801eb0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801eb2:	eb 05                	jmp    801eb9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801eb4:	89 c7                	mov    %eax,%edi
  801eb6:	fc                   	cld    
  801eb7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    

00801ebd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ebd:	f3 0f 1e fb          	endbr32 
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 82 ff ff ff       	call   801e57 <memmove>
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ed7:	f3 0f 1e fb          	endbr32 
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee6:	89 c6                	mov    %eax,%esi
  801ee8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801eeb:	39 f0                	cmp    %esi,%eax
  801eed:	74 1c                	je     801f0b <memcmp+0x34>
		if (*s1 != *s2)
  801eef:	0f b6 08             	movzbl (%eax),%ecx
  801ef2:	0f b6 1a             	movzbl (%edx),%ebx
  801ef5:	38 d9                	cmp    %bl,%cl
  801ef7:	75 08                	jne    801f01 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801ef9:	83 c0 01             	add    $0x1,%eax
  801efc:	83 c2 01             	add    $0x1,%edx
  801eff:	eb ea                	jmp    801eeb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f01:	0f b6 c1             	movzbl %cl,%eax
  801f04:	0f b6 db             	movzbl %bl,%ebx
  801f07:	29 d8                	sub    %ebx,%eax
  801f09:	eb 05                	jmp    801f10 <memcmp+0x39>
	}

	return 0;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    

00801f14 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f14:	f3 0f 1e fb          	endbr32 
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f21:	89 c2                	mov    %eax,%edx
  801f23:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f26:	39 d0                	cmp    %edx,%eax
  801f28:	73 09                	jae    801f33 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f2a:	38 08                	cmp    %cl,(%eax)
  801f2c:	74 05                	je     801f33 <memfind+0x1f>
	for (; s < ends; s++)
  801f2e:	83 c0 01             	add    $0x1,%eax
  801f31:	eb f3                	jmp    801f26 <memfind+0x12>
			break;
	return (void *) s;
}
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    

00801f35 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f35:	f3 0f 1e fb          	endbr32 
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	57                   	push   %edi
  801f3d:	56                   	push   %esi
  801f3e:	53                   	push   %ebx
  801f3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f45:	eb 03                	jmp    801f4a <strtol+0x15>
		s++;
  801f47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f4a:	0f b6 01             	movzbl (%ecx),%eax
  801f4d:	3c 20                	cmp    $0x20,%al
  801f4f:	74 f6                	je     801f47 <strtol+0x12>
  801f51:	3c 09                	cmp    $0x9,%al
  801f53:	74 f2                	je     801f47 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f55:	3c 2b                	cmp    $0x2b,%al
  801f57:	74 2a                	je     801f83 <strtol+0x4e>
	int neg = 0;
  801f59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f5e:	3c 2d                	cmp    $0x2d,%al
  801f60:	74 2b                	je     801f8d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f68:	75 0f                	jne    801f79 <strtol+0x44>
  801f6a:	80 39 30             	cmpb   $0x30,(%ecx)
  801f6d:	74 28                	je     801f97 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f6f:	85 db                	test   %ebx,%ebx
  801f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f76:	0f 44 d8             	cmove  %eax,%ebx
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f81:	eb 46                	jmp    801fc9 <strtol+0x94>
		s++;
  801f83:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f86:	bf 00 00 00 00       	mov    $0x0,%edi
  801f8b:	eb d5                	jmp    801f62 <strtol+0x2d>
		s++, neg = 1;
  801f8d:	83 c1 01             	add    $0x1,%ecx
  801f90:	bf 01 00 00 00       	mov    $0x1,%edi
  801f95:	eb cb                	jmp    801f62 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f97:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801f9b:	74 0e                	je     801fab <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801f9d:	85 db                	test   %ebx,%ebx
  801f9f:	75 d8                	jne    801f79 <strtol+0x44>
		s++, base = 8;
  801fa1:	83 c1 01             	add    $0x1,%ecx
  801fa4:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fa9:	eb ce                	jmp    801f79 <strtol+0x44>
		s += 2, base = 16;
  801fab:	83 c1 02             	add    $0x2,%ecx
  801fae:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fb3:	eb c4                	jmp    801f79 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fb5:	0f be d2             	movsbl %dl,%edx
  801fb8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fbb:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fbe:	7d 3a                	jge    801ffa <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fc0:	83 c1 01             	add    $0x1,%ecx
  801fc3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fc7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fc9:	0f b6 11             	movzbl (%ecx),%edx
  801fcc:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fcf:	89 f3                	mov    %esi,%ebx
  801fd1:	80 fb 09             	cmp    $0x9,%bl
  801fd4:	76 df                	jbe    801fb5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fd6:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fd9:	89 f3                	mov    %esi,%ebx
  801fdb:	80 fb 19             	cmp    $0x19,%bl
  801fde:	77 08                	ja     801fe8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fe0:	0f be d2             	movsbl %dl,%edx
  801fe3:	83 ea 57             	sub    $0x57,%edx
  801fe6:	eb d3                	jmp    801fbb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801fe8:	8d 72 bf             	lea    -0x41(%edx),%esi
  801feb:	89 f3                	mov    %esi,%ebx
  801fed:	80 fb 19             	cmp    $0x19,%bl
  801ff0:	77 08                	ja     801ffa <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ff2:	0f be d2             	movsbl %dl,%edx
  801ff5:	83 ea 37             	sub    $0x37,%edx
  801ff8:	eb c1                	jmp    801fbb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801ffa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ffe:	74 05                	je     802005 <strtol+0xd0>
		*endptr = (char *) s;
  802000:	8b 75 0c             	mov    0xc(%ebp),%esi
  802003:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802005:	89 c2                	mov    %eax,%edx
  802007:	f7 da                	neg    %edx
  802009:	85 ff                	test   %edi,%edi
  80200b:	0f 45 c2             	cmovne %edx,%eax
}
  80200e:	5b                   	pop    %ebx
  80200f:	5e                   	pop    %esi
  802010:	5f                   	pop    %edi
  802011:	5d                   	pop    %ebp
  802012:	c3                   	ret    

00802013 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802013:	f3 0f 1e fb          	endbr32 
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	56                   	push   %esi
  80201b:	53                   	push   %ebx
  80201c:	8b 75 08             	mov    0x8(%ebp),%esi
  80201f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802022:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802025:	83 e8 01             	sub    $0x1,%eax
  802028:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80202d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802032:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	50                   	push   %eax
  80203a:	e8 07 e3 ff ff       	call   800346 <sys_ipc_recv>
	if (!t) {
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	85 c0                	test   %eax,%eax
  802044:	75 2b                	jne    802071 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802046:	85 f6                	test   %esi,%esi
  802048:	74 0a                	je     802054 <ipc_recv+0x41>
  80204a:	a1 08 40 80 00       	mov    0x804008,%eax
  80204f:	8b 40 74             	mov    0x74(%eax),%eax
  802052:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802054:	85 db                	test   %ebx,%ebx
  802056:	74 0a                	je     802062 <ipc_recv+0x4f>
  802058:	a1 08 40 80 00       	mov    0x804008,%eax
  80205d:	8b 40 78             	mov    0x78(%eax),%eax
  802060:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802062:	a1 08 40 80 00       	mov    0x804008,%eax
  802067:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80206a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802071:	85 f6                	test   %esi,%esi
  802073:	74 06                	je     80207b <ipc_recv+0x68>
  802075:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80207b:	85 db                	test   %ebx,%ebx
  80207d:	74 eb                	je     80206a <ipc_recv+0x57>
  80207f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802085:	eb e3                	jmp    80206a <ipc_recv+0x57>

00802087 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802087:	f3 0f 1e fb          	endbr32 
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	57                   	push   %edi
  80208f:	56                   	push   %esi
  802090:	53                   	push   %ebx
  802091:	83 ec 0c             	sub    $0xc,%esp
  802094:	8b 7d 08             	mov    0x8(%ebp),%edi
  802097:	8b 75 0c             	mov    0xc(%ebp),%esi
  80209a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80209d:	85 db                	test   %ebx,%ebx
  80209f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020a4:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020a7:	ff 75 14             	pushl  0x14(%ebp)
  8020aa:	53                   	push   %ebx
  8020ab:	56                   	push   %esi
  8020ac:	57                   	push   %edi
  8020ad:	e8 6d e2 ff ff       	call   80031f <sys_ipc_try_send>
  8020b2:	83 c4 10             	add    $0x10,%esp
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	74 1e                	je     8020d7 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020b9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020bc:	75 07                	jne    8020c5 <ipc_send+0x3e>
		sys_yield();
  8020be:	e8 94 e0 ff ff       	call   800157 <sys_yield>
  8020c3:	eb e2                	jmp    8020a7 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c5:	50                   	push   %eax
  8020c6:	68 3f 28 80 00       	push   $0x80283f
  8020cb:	6a 39                	push   $0x39
  8020cd:	68 51 28 80 00       	push   $0x802851
  8020d2:	e8 d9 f4 ff ff       	call   8015b0 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020da:	5b                   	pop    %ebx
  8020db:	5e                   	pop    %esi
  8020dc:	5f                   	pop    %edi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    

008020df <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020df:	f3 0f 1e fb          	endbr32 
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020ee:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020f1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020f7:	8b 52 50             	mov    0x50(%edx),%edx
  8020fa:	39 ca                	cmp    %ecx,%edx
  8020fc:	74 11                	je     80210f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8020fe:	83 c0 01             	add    $0x1,%eax
  802101:	3d 00 04 00 00       	cmp    $0x400,%eax
  802106:	75 e6                	jne    8020ee <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	eb 0b                	jmp    80211a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80210f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802112:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802117:	8b 40 48             	mov    0x48(%eax),%eax
}
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80211c:	f3 0f 1e fb          	endbr32 
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802126:	89 c2                	mov    %eax,%edx
  802128:	c1 ea 16             	shr    $0x16,%edx
  80212b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802132:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802137:	f6 c1 01             	test   $0x1,%cl
  80213a:	74 1c                	je     802158 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80213c:	c1 e8 0c             	shr    $0xc,%eax
  80213f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802146:	a8 01                	test   $0x1,%al
  802148:	74 0e                	je     802158 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80214a:	c1 e8 0c             	shr    $0xc,%eax
  80214d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802154:	ef 
  802155:	0f b7 d2             	movzwl %dx,%edx
}
  802158:	89 d0                	mov    %edx,%eax
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
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
