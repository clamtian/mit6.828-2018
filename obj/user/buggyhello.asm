
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 1a 00 00 00       	call   80004b <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  80003d:	6a 01                	push   $0x1
  80003f:	6a 01                	push   $0x1
  800041:	e8 6d 00 00 00       	call   8000b3 <sys_cputs>
}
  800046:	83 c4 10             	add    $0x10,%esp
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004b:	f3 0f 1e fb          	endbr32 
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800057:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005a:	e8 de 00 00 00       	call   80013d <sys_getenvid>
  80005f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800064:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800067:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800071:	85 db                	test   %ebx,%ebx
  800073:	7e 07                	jle    80007c <libmain+0x31>
		binaryname = argv[0];
  800075:	8b 06                	mov    (%esi),%eax
  800077:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	e8 ad ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800086:	e8 0a 00 00 00       	call   800095 <exit>
}
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800091:	5b                   	pop    %ebx
  800092:	5e                   	pop    %esi
  800093:	5d                   	pop    %ebp
  800094:	c3                   	ret    

00800095 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009f:	e8 07 05 00 00       	call   8005ab <close_all>
	sys_env_destroy(0);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	6a 00                	push   $0x0
  8000a9:	e8 4a 00 00 00       	call   8000f8 <sys_env_destroy>
}
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	c9                   	leave  
  8000b2:	c3                   	ret    

008000b3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b3:	f3 0f 1e fb          	endbr32 
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	57                   	push   %edi
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c8:	89 c3                	mov    %eax,%ebx
  8000ca:	89 c7                	mov    %eax,%edi
  8000cc:	89 c6                	mov    %eax,%esi
  8000ce:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d0:	5b                   	pop    %ebx
  8000d1:	5e                   	pop    %esi
  8000d2:	5f                   	pop    %edi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    

008000d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d5:	f3 0f 1e fb          	endbr32 
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	57                   	push   %edi
  8000dd:	56                   	push   %esi
  8000de:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	89 d3                	mov    %edx,%ebx
  8000ed:	89 d7                	mov    %edx,%edi
  8000ef:	89 d6                	mov    %edx,%esi
  8000f1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f8:	f3 0f 1e fb          	endbr32 
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	57                   	push   %edi
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
  800102:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800105:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010a:	8b 55 08             	mov    0x8(%ebp),%edx
  80010d:	b8 03 00 00 00       	mov    $0x3,%eax
  800112:	89 cb                	mov    %ecx,%ebx
  800114:	89 cf                	mov    %ecx,%edi
  800116:	89 ce                	mov    %ecx,%esi
  800118:	cd 30                	int    $0x30
	if(check && ret > 0)
  80011a:	85 c0                	test   %eax,%eax
  80011c:	7f 08                	jg     800126 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80011e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5f                   	pop    %edi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800126:	83 ec 0c             	sub    $0xc,%esp
  800129:	50                   	push   %eax
  80012a:	6a 03                	push   $0x3
  80012c:	68 ea 23 80 00       	push   $0x8023ea
  800131:	6a 23                	push   $0x23
  800133:	68 07 24 80 00       	push   $0x802407
  800138:	e8 7c 14 00 00       	call   8015b9 <_panic>

0080013d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80013d:	f3 0f 1e fb          	endbr32 
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	57                   	push   %edi
  800145:	56                   	push   %esi
  800146:	53                   	push   %ebx
	asm volatile("int %1\n"
  800147:	ba 00 00 00 00       	mov    $0x0,%edx
  80014c:	b8 02 00 00 00       	mov    $0x2,%eax
  800151:	89 d1                	mov    %edx,%ecx
  800153:	89 d3                	mov    %edx,%ebx
  800155:	89 d7                	mov    %edx,%edi
  800157:	89 d6                	mov    %edx,%esi
  800159:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015b:	5b                   	pop    %ebx
  80015c:	5e                   	pop    %esi
  80015d:	5f                   	pop    %edi
  80015e:	5d                   	pop    %ebp
  80015f:	c3                   	ret    

00800160 <sys_yield>:

void
sys_yield(void)
{
  800160:	f3 0f 1e fb          	endbr32 
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	57                   	push   %edi
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
	asm volatile("int %1\n"
  80016a:	ba 00 00 00 00       	mov    $0x0,%edx
  80016f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800174:	89 d1                	mov    %edx,%ecx
  800176:	89 d3                	mov    %edx,%ebx
  800178:	89 d7                	mov    %edx,%edi
  80017a:	89 d6                	mov    %edx,%esi
  80017c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5f                   	pop    %edi
  800181:	5d                   	pop    %ebp
  800182:	c3                   	ret    

00800183 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800183:	f3 0f 1e fb          	endbr32 
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	57                   	push   %edi
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
  80018d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800190:	be 00 00 00 00       	mov    $0x0,%esi
  800195:	8b 55 08             	mov    0x8(%ebp),%edx
  800198:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019b:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a3:	89 f7                	mov    %esi,%edi
  8001a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	7f 08                	jg     8001b3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ae:	5b                   	pop    %ebx
  8001af:	5e                   	pop    %esi
  8001b0:	5f                   	pop    %edi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	50                   	push   %eax
  8001b7:	6a 04                	push   $0x4
  8001b9:	68 ea 23 80 00       	push   $0x8023ea
  8001be:	6a 23                	push   $0x23
  8001c0:	68 07 24 80 00       	push   $0x802407
  8001c5:	e8 ef 13 00 00       	call   8015b9 <_panic>

008001ca <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ca:	f3 0f 1e fb          	endbr32 
  8001ce:	55                   	push   %ebp
  8001cf:	89 e5                	mov    %esp,%ebp
  8001d1:	57                   	push   %edi
  8001d2:	56                   	push   %esi
  8001d3:	53                   	push   %ebx
  8001d4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001dd:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ed:	85 c0                	test   %eax,%eax
  8001ef:	7f 08                	jg     8001f9 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5e                   	pop    %esi
  8001f6:	5f                   	pop    %edi
  8001f7:	5d                   	pop    %ebp
  8001f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	50                   	push   %eax
  8001fd:	6a 05                	push   $0x5
  8001ff:	68 ea 23 80 00       	push   $0x8023ea
  800204:	6a 23                	push   $0x23
  800206:	68 07 24 80 00       	push   $0x802407
  80020b:	e8 a9 13 00 00       	call   8015b9 <_panic>

00800210 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800210:	f3 0f 1e fb          	endbr32 
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
  80021a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80021d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800222:	8b 55 08             	mov    0x8(%ebp),%edx
  800225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800228:	b8 06 00 00 00       	mov    $0x6,%eax
  80022d:	89 df                	mov    %ebx,%edi
  80022f:	89 de                	mov    %ebx,%esi
  800231:	cd 30                	int    $0x30
	if(check && ret > 0)
  800233:	85 c0                	test   %eax,%eax
  800235:	7f 08                	jg     80023f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	6a 06                	push   $0x6
  800245:	68 ea 23 80 00       	push   $0x8023ea
  80024a:	6a 23                	push   $0x23
  80024c:	68 07 24 80 00       	push   $0x802407
  800251:	e8 63 13 00 00       	call   8015b9 <_panic>

00800256 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800256:	f3 0f 1e fb          	endbr32 
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026e:	b8 08 00 00 00       	mov    $0x8,%eax
  800273:	89 df                	mov    %ebx,%edi
  800275:	89 de                	mov    %ebx,%esi
  800277:	cd 30                	int    $0x30
	if(check && ret > 0)
  800279:	85 c0                	test   %eax,%eax
  80027b:	7f 08                	jg     800285 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80027d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800280:	5b                   	pop    %ebx
  800281:	5e                   	pop    %esi
  800282:	5f                   	pop    %edi
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	50                   	push   %eax
  800289:	6a 08                	push   $0x8
  80028b:	68 ea 23 80 00       	push   $0x8023ea
  800290:	6a 23                	push   $0x23
  800292:	68 07 24 80 00       	push   $0x802407
  800297:	e8 1d 13 00 00       	call   8015b9 <_panic>

0080029c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80029c:	f3 0f 1e fb          	endbr32 
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b9:	89 df                	mov    %ebx,%edi
  8002bb:	89 de                	mov    %ebx,%esi
  8002bd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002bf:	85 c0                	test   %eax,%eax
  8002c1:	7f 08                	jg     8002cb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	6a 09                	push   $0x9
  8002d1:	68 ea 23 80 00       	push   $0x8023ea
  8002d6:	6a 23                	push   $0x23
  8002d8:	68 07 24 80 00       	push   $0x802407
  8002dd:	e8 d7 12 00 00       	call   8015b9 <_panic>

008002e2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	57                   	push   %edi
  8002ea:	56                   	push   %esi
  8002eb:	53                   	push   %ebx
  8002ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002ff:	89 df                	mov    %ebx,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	cd 30                	int    $0x30
	if(check && ret > 0)
  800305:	85 c0                	test   %eax,%eax
  800307:	7f 08                	jg     800311 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800309:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030c:	5b                   	pop    %ebx
  80030d:	5e                   	pop    %esi
  80030e:	5f                   	pop    %edi
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	6a 0a                	push   $0xa
  800317:	68 ea 23 80 00       	push   $0x8023ea
  80031c:	6a 23                	push   $0x23
  80031e:	68 07 24 80 00       	push   $0x802407
  800323:	e8 91 12 00 00       	call   8015b9 <_panic>

00800328 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800328:	f3 0f 1e fb          	endbr32 
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
	asm volatile("int %1\n"
  800332:	8b 55 08             	mov    0x8(%ebp),%edx
  800335:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800338:	b8 0c 00 00 00       	mov    $0xc,%eax
  80033d:	be 00 00 00 00       	mov    $0x0,%esi
  800342:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800345:	8b 7d 14             	mov    0x14(%ebp),%edi
  800348:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034f:	f3 0f 1e fb          	endbr32 
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	57                   	push   %edi
  800357:	56                   	push   %esi
  800358:	53                   	push   %ebx
  800359:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800361:	8b 55 08             	mov    0x8(%ebp),%edx
  800364:	b8 0d 00 00 00       	mov    $0xd,%eax
  800369:	89 cb                	mov    %ecx,%ebx
  80036b:	89 cf                	mov    %ecx,%edi
  80036d:	89 ce                	mov    %ecx,%esi
  80036f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800371:	85 c0                	test   %eax,%eax
  800373:	7f 08                	jg     80037d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800375:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800378:	5b                   	pop    %ebx
  800379:	5e                   	pop    %esi
  80037a:	5f                   	pop    %edi
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	50                   	push   %eax
  800381:	6a 0d                	push   $0xd
  800383:	68 ea 23 80 00       	push   $0x8023ea
  800388:	6a 23                	push   $0x23
  80038a:	68 07 24 80 00       	push   $0x802407
  80038f:	e8 25 12 00 00       	call   8015b9 <_panic>

00800394 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800394:	f3 0f 1e fb          	endbr32 
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	57                   	push   %edi
  80039c:	56                   	push   %esi
  80039d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80039e:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a3:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003a8:	89 d1                	mov    %edx,%ecx
  8003aa:	89 d3                	mov    %edx,%ebx
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	89 d6                	mov    %edx,%esi
  8003b0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b2:	5b                   	pop    %ebx
  8003b3:	5e                   	pop    %esi
  8003b4:	5f                   	pop    %edi
  8003b5:	5d                   	pop    %ebp
  8003b6:	c3                   	ret    

008003b7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003b7:	f3 0f 1e fb          	endbr32 
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	05 00 00 00 30       	add    $0x30000000,%eax
  8003c6:	c1 e8 0c             	shr    $0xc,%eax
}
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003cb:	f3 0f 1e fb          	endbr32 
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003df:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003e6:	f3 0f 1e fb          	endbr32 
  8003ea:	55                   	push   %ebp
  8003eb:	89 e5                	mov    %esp,%ebp
  8003ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	c1 ea 16             	shr    $0x16,%edx
  8003f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8003fe:	f6 c2 01             	test   $0x1,%dl
  800401:	74 2d                	je     800430 <fd_alloc+0x4a>
  800403:	89 c2                	mov    %eax,%edx
  800405:	c1 ea 0c             	shr    $0xc,%edx
  800408:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80040f:	f6 c2 01             	test   $0x1,%dl
  800412:	74 1c                	je     800430 <fd_alloc+0x4a>
  800414:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800419:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80041e:	75 d2                	jne    8003f2 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800429:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80042e:	eb 0a                	jmp    80043a <fd_alloc+0x54>
			*fd_store = fd;
  800430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800433:	89 01                	mov    %eax,(%ecx)
			return 0;
  800435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80043a:	5d                   	pop    %ebp
  80043b:	c3                   	ret    

0080043c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80043c:	f3 0f 1e fb          	endbr32 
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800446:	83 f8 1f             	cmp    $0x1f,%eax
  800449:	77 30                	ja     80047b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80044b:	c1 e0 0c             	shl    $0xc,%eax
  80044e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800453:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800459:	f6 c2 01             	test   $0x1,%dl
  80045c:	74 24                	je     800482 <fd_lookup+0x46>
  80045e:	89 c2                	mov    %eax,%edx
  800460:	c1 ea 0c             	shr    $0xc,%edx
  800463:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80046a:	f6 c2 01             	test   $0x1,%dl
  80046d:	74 1a                	je     800489 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	89 02                	mov    %eax,(%edx)
	return 0;
  800474:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800479:	5d                   	pop    %ebp
  80047a:	c3                   	ret    
		return -E_INVAL;
  80047b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800480:	eb f7                	jmp    800479 <fd_lookup+0x3d>
		return -E_INVAL;
  800482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800487:	eb f0                	jmp    800479 <fd_lookup+0x3d>
  800489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80048e:	eb e9                	jmp    800479 <fd_lookup+0x3d>

00800490 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800490:	f3 0f 1e fb          	endbr32 
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004a7:	39 08                	cmp    %ecx,(%eax)
  8004a9:	74 38                	je     8004e3 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004ab:	83 c2 01             	add    $0x1,%edx
  8004ae:	8b 04 95 94 24 80 00 	mov    0x802494(,%edx,4),%eax
  8004b5:	85 c0                	test   %eax,%eax
  8004b7:	75 ee                	jne    8004a7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8004be:	8b 40 48             	mov    0x48(%eax),%eax
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	51                   	push   %ecx
  8004c5:	50                   	push   %eax
  8004c6:	68 18 24 80 00       	push   $0x802418
  8004cb:	e8 d0 11 00 00       	call   8016a0 <cprintf>
	*dev = 0;
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004d9:	83 c4 10             	add    $0x10,%esp
  8004dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    
			*dev = devtab[i];
  8004e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004e6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ed:	eb f2                	jmp    8004e1 <dev_lookup+0x51>

008004ef <fd_close>:
{
  8004ef:	f3 0f 1e fb          	endbr32 
  8004f3:	55                   	push   %ebp
  8004f4:	89 e5                	mov    %esp,%ebp
  8004f6:	57                   	push   %edi
  8004f7:	56                   	push   %esi
  8004f8:	53                   	push   %ebx
  8004f9:	83 ec 24             	sub    $0x24,%esp
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800502:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800505:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800506:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80050c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80050f:	50                   	push   %eax
  800510:	e8 27 ff ff ff       	call   80043c <fd_lookup>
  800515:	89 c3                	mov    %eax,%ebx
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	85 c0                	test   %eax,%eax
  80051c:	78 05                	js     800523 <fd_close+0x34>
	    || fd != fd2)
  80051e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800521:	74 16                	je     800539 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800523:	89 f8                	mov    %edi,%eax
  800525:	84 c0                	test   %al,%al
  800527:	b8 00 00 00 00       	mov    $0x0,%eax
  80052c:	0f 44 d8             	cmove  %eax,%ebx
}
  80052f:	89 d8                	mov    %ebx,%eax
  800531:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800534:	5b                   	pop    %ebx
  800535:	5e                   	pop    %esi
  800536:	5f                   	pop    %edi
  800537:	5d                   	pop    %ebp
  800538:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80053f:	50                   	push   %eax
  800540:	ff 36                	pushl  (%esi)
  800542:	e8 49 ff ff ff       	call   800490 <dev_lookup>
  800547:	89 c3                	mov    %eax,%ebx
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	85 c0                	test   %eax,%eax
  80054e:	78 1a                	js     80056a <fd_close+0x7b>
		if (dev->dev_close)
  800550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800553:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800556:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80055b:	85 c0                	test   %eax,%eax
  80055d:	74 0b                	je     80056a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	56                   	push   %esi
  800563:	ff d0                	call   *%eax
  800565:	89 c3                	mov    %eax,%ebx
  800567:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	56                   	push   %esi
  80056e:	6a 00                	push   $0x0
  800570:	e8 9b fc ff ff       	call   800210 <sys_page_unmap>
	return r;
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	eb b5                	jmp    80052f <fd_close+0x40>

0080057a <close>:

int
close(int fdnum)
{
  80057a:	f3 0f 1e fb          	endbr32 
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800584:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	ff 75 08             	pushl  0x8(%ebp)
  80058b:	e8 ac fe ff ff       	call   80043c <fd_lookup>
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	85 c0                	test   %eax,%eax
  800595:	79 02                	jns    800599 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800597:	c9                   	leave  
  800598:	c3                   	ret    
		return fd_close(fd, 1);
  800599:	83 ec 08             	sub    $0x8,%esp
  80059c:	6a 01                	push   $0x1
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	e8 49 ff ff ff       	call   8004ef <fd_close>
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	eb ec                	jmp    800597 <close+0x1d>

008005ab <close_all>:

void
close_all(void)
{
  8005ab:	f3 0f 1e fb          	endbr32 
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005bb:	83 ec 0c             	sub    $0xc,%esp
  8005be:	53                   	push   %ebx
  8005bf:	e8 b6 ff ff ff       	call   80057a <close>
	for (i = 0; i < MAXFD; i++)
  8005c4:	83 c3 01             	add    $0x1,%ebx
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 fb 20             	cmp    $0x20,%ebx
  8005cd:	75 ec                	jne    8005bb <close_all+0x10>
}
  8005cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005d4:	f3 0f 1e fb          	endbr32 
  8005d8:	55                   	push   %ebp
  8005d9:	89 e5                	mov    %esp,%ebp
  8005db:	57                   	push   %edi
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005e4:	50                   	push   %eax
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	e8 4f fe ff ff       	call   80043c <fd_lookup>
  8005ed:	89 c3                	mov    %eax,%ebx
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	85 c0                	test   %eax,%eax
  8005f4:	0f 88 81 00 00 00    	js     80067b <dup+0xa7>
		return r;
	close(newfdnum);
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	ff 75 0c             	pushl  0xc(%ebp)
  800600:	e8 75 ff ff ff       	call   80057a <close>

	newfd = INDEX2FD(newfdnum);
  800605:	8b 75 0c             	mov    0xc(%ebp),%esi
  800608:	c1 e6 0c             	shl    $0xc,%esi
  80060b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800611:	83 c4 04             	add    $0x4,%esp
  800614:	ff 75 e4             	pushl  -0x1c(%ebp)
  800617:	e8 af fd ff ff       	call   8003cb <fd2data>
  80061c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80061e:	89 34 24             	mov    %esi,(%esp)
  800621:	e8 a5 fd ff ff       	call   8003cb <fd2data>
  800626:	83 c4 10             	add    $0x10,%esp
  800629:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80062b:	89 d8                	mov    %ebx,%eax
  80062d:	c1 e8 16             	shr    $0x16,%eax
  800630:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800637:	a8 01                	test   $0x1,%al
  800639:	74 11                	je     80064c <dup+0x78>
  80063b:	89 d8                	mov    %ebx,%eax
  80063d:	c1 e8 0c             	shr    $0xc,%eax
  800640:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800647:	f6 c2 01             	test   $0x1,%dl
  80064a:	75 39                	jne    800685 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80064c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80064f:	89 d0                	mov    %edx,%eax
  800651:	c1 e8 0c             	shr    $0xc,%eax
  800654:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80065b:	83 ec 0c             	sub    $0xc,%esp
  80065e:	25 07 0e 00 00       	and    $0xe07,%eax
  800663:	50                   	push   %eax
  800664:	56                   	push   %esi
  800665:	6a 00                	push   $0x0
  800667:	52                   	push   %edx
  800668:	6a 00                	push   $0x0
  80066a:	e8 5b fb ff ff       	call   8001ca <sys_page_map>
  80066f:	89 c3                	mov    %eax,%ebx
  800671:	83 c4 20             	add    $0x20,%esp
  800674:	85 c0                	test   %eax,%eax
  800676:	78 31                	js     8006a9 <dup+0xd5>
		goto err;

	return newfdnum;
  800678:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80067b:	89 d8                	mov    %ebx,%eax
  80067d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800680:	5b                   	pop    %ebx
  800681:	5e                   	pop    %esi
  800682:	5f                   	pop    %edi
  800683:	5d                   	pop    %ebp
  800684:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800685:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	25 07 0e 00 00       	and    $0xe07,%eax
  800694:	50                   	push   %eax
  800695:	57                   	push   %edi
  800696:	6a 00                	push   $0x0
  800698:	53                   	push   %ebx
  800699:	6a 00                	push   $0x0
  80069b:	e8 2a fb ff ff       	call   8001ca <sys_page_map>
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	83 c4 20             	add    $0x20,%esp
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	79 a3                	jns    80064c <dup+0x78>
	sys_page_unmap(0, newfd);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	56                   	push   %esi
  8006ad:	6a 00                	push   $0x0
  8006af:	e8 5c fb ff ff       	call   800210 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006b4:	83 c4 08             	add    $0x8,%esp
  8006b7:	57                   	push   %edi
  8006b8:	6a 00                	push   $0x0
  8006ba:	e8 51 fb ff ff       	call   800210 <sys_page_unmap>
	return r;
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb b7                	jmp    80067b <dup+0xa7>

008006c4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006c4:	f3 0f 1e fb          	endbr32 
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	53                   	push   %ebx
  8006cc:	83 ec 1c             	sub    $0x1c,%esp
  8006cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006d5:	50                   	push   %eax
  8006d6:	53                   	push   %ebx
  8006d7:	e8 60 fd ff ff       	call   80043c <fd_lookup>
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	78 3f                	js     800722 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ed:	ff 30                	pushl  (%eax)
  8006ef:	e8 9c fd ff ff       	call   800490 <dev_lookup>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	85 c0                	test   %eax,%eax
  8006f9:	78 27                	js     800722 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8006fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8006fe:	8b 42 08             	mov    0x8(%edx),%eax
  800701:	83 e0 03             	and    $0x3,%eax
  800704:	83 f8 01             	cmp    $0x1,%eax
  800707:	74 1e                	je     800727 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070c:	8b 40 08             	mov    0x8(%eax),%eax
  80070f:	85 c0                	test   %eax,%eax
  800711:	74 35                	je     800748 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	ff 75 10             	pushl  0x10(%ebp)
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	52                   	push   %edx
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
}
  800722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800725:	c9                   	leave  
  800726:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800727:	a1 08 40 80 00       	mov    0x804008,%eax
  80072c:	8b 40 48             	mov    0x48(%eax),%eax
  80072f:	83 ec 04             	sub    $0x4,%esp
  800732:	53                   	push   %ebx
  800733:	50                   	push   %eax
  800734:	68 59 24 80 00       	push   $0x802459
  800739:	e8 62 0f 00 00       	call   8016a0 <cprintf>
		return -E_INVAL;
  80073e:	83 c4 10             	add    $0x10,%esp
  800741:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800746:	eb da                	jmp    800722 <read+0x5e>
		return -E_NOT_SUPP;
  800748:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80074d:	eb d3                	jmp    800722 <read+0x5e>

0080074f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80074f:	f3 0f 1e fb          	endbr32 
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	57                   	push   %edi
  800757:	56                   	push   %esi
  800758:	53                   	push   %ebx
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80075f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800762:	bb 00 00 00 00       	mov    $0x0,%ebx
  800767:	eb 02                	jmp    80076b <readn+0x1c>
  800769:	01 c3                	add    %eax,%ebx
  80076b:	39 f3                	cmp    %esi,%ebx
  80076d:	73 21                	jae    800790 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	89 f0                	mov    %esi,%eax
  800774:	29 d8                	sub    %ebx,%eax
  800776:	50                   	push   %eax
  800777:	89 d8                	mov    %ebx,%eax
  800779:	03 45 0c             	add    0xc(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	57                   	push   %edi
  80077e:	e8 41 ff ff ff       	call   8006c4 <read>
		if (m < 0)
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	85 c0                	test   %eax,%eax
  800788:	78 04                	js     80078e <readn+0x3f>
			return m;
		if (m == 0)
  80078a:	75 dd                	jne    800769 <readn+0x1a>
  80078c:	eb 02                	jmp    800790 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80078e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800790:	89 d8                	mov    %ebx,%eax
  800792:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800795:	5b                   	pop    %ebx
  800796:	5e                   	pop    %esi
  800797:	5f                   	pop    %edi
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80079a:	f3 0f 1e fb          	endbr32 
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	53                   	push   %ebx
  8007a2:	83 ec 1c             	sub    $0x1c,%esp
  8007a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ab:	50                   	push   %eax
  8007ac:	53                   	push   %ebx
  8007ad:	e8 8a fc ff ff       	call   80043c <fd_lookup>
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	85 c0                	test   %eax,%eax
  8007b7:	78 3a                	js     8007f3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c3:	ff 30                	pushl  (%eax)
  8007c5:	e8 c6 fc ff ff       	call   800490 <dev_lookup>
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	85 c0                	test   %eax,%eax
  8007cf:	78 22                	js     8007f3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007d8:	74 1e                	je     8007f8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e0:	85 d2                	test   %edx,%edx
  8007e2:	74 35                	je     800819 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	ff 75 10             	pushl  0x10(%ebp)
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	ff d2                	call   *%edx
  8007f0:	83 c4 10             	add    $0x10,%esp
}
  8007f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8007fd:	8b 40 48             	mov    0x48(%eax),%eax
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	53                   	push   %ebx
  800804:	50                   	push   %eax
  800805:	68 75 24 80 00       	push   $0x802475
  80080a:	e8 91 0e 00 00       	call   8016a0 <cprintf>
		return -E_INVAL;
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800817:	eb da                	jmp    8007f3 <write+0x59>
		return -E_NOT_SUPP;
  800819:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80081e:	eb d3                	jmp    8007f3 <write+0x59>

00800820 <seek>:

int
seek(int fdnum, off_t offset)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80082a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 06 fc ff ff       	call   80043c <fd_lookup>
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	78 0e                	js     80084b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80083d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800843:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	53                   	push   %ebx
  800855:	83 ec 1c             	sub    $0x1c,%esp
  800858:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	53                   	push   %ebx
  800860:	e8 d7 fb ff ff       	call   80043c <fd_lookup>
  800865:	83 c4 10             	add    $0x10,%esp
  800868:	85 c0                	test   %eax,%eax
  80086a:	78 37                	js     8008a3 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800872:	50                   	push   %eax
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	ff 30                	pushl  (%eax)
  800878:	e8 13 fc ff ff       	call   800490 <dev_lookup>
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	85 c0                	test   %eax,%eax
  800882:	78 1f                	js     8008a3 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800887:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80088b:	74 1b                	je     8008a8 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80088d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800890:	8b 52 18             	mov    0x18(%edx),%edx
  800893:	85 d2                	test   %edx,%edx
  800895:	74 32                	je     8008c9 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	50                   	push   %eax
  80089e:	ff d2                	call   *%edx
  8008a0:	83 c4 10             	add    $0x10,%esp
}
  8008a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008a8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008ad:	8b 40 48             	mov    0x48(%eax),%eax
  8008b0:	83 ec 04             	sub    $0x4,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	50                   	push   %eax
  8008b5:	68 38 24 80 00       	push   $0x802438
  8008ba:	e8 e1 0d 00 00       	call   8016a0 <cprintf>
		return -E_INVAL;
  8008bf:	83 c4 10             	add    $0x10,%esp
  8008c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c7:	eb da                	jmp    8008a3 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ce:	eb d3                	jmp    8008a3 <ftruncate+0x56>

008008d0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d0:	f3 0f 1e fb          	endbr32 
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	53                   	push   %ebx
  8008d8:	83 ec 1c             	sub    $0x1c,%esp
  8008db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e1:	50                   	push   %eax
  8008e2:	ff 75 08             	pushl  0x8(%ebp)
  8008e5:	e8 52 fb ff ff       	call   80043c <fd_lookup>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	78 4b                	js     80093c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f7:	50                   	push   %eax
  8008f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fb:	ff 30                	pushl  (%eax)
  8008fd:	e8 8e fb ff ff       	call   800490 <dev_lookup>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	85 c0                	test   %eax,%eax
  800907:	78 33                	js     80093c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800910:	74 2f                	je     800941 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800912:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800915:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80091c:	00 00 00 
	stat->st_isdir = 0;
  80091f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800926:	00 00 00 
	stat->st_dev = dev;
  800929:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	53                   	push   %ebx
  800933:	ff 75 f0             	pushl  -0x10(%ebp)
  800936:	ff 50 14             	call   *0x14(%eax)
  800939:	83 c4 10             	add    $0x10,%esp
}
  80093c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093f:	c9                   	leave  
  800940:	c3                   	ret    
		return -E_NOT_SUPP;
  800941:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800946:	eb f4                	jmp    80093c <fstat+0x6c>

00800948 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	56                   	push   %esi
  800950:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	6a 00                	push   $0x0
  800956:	ff 75 08             	pushl  0x8(%ebp)
  800959:	e8 fb 01 00 00       	call   800b59 <open>
  80095e:	89 c3                	mov    %eax,%ebx
  800960:	83 c4 10             	add    $0x10,%esp
  800963:	85 c0                	test   %eax,%eax
  800965:	78 1b                	js     800982 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	50                   	push   %eax
  80096e:	e8 5d ff ff ff       	call   8008d0 <fstat>
  800973:	89 c6                	mov    %eax,%esi
	close(fd);
  800975:	89 1c 24             	mov    %ebx,(%esp)
  800978:	e8 fd fb ff ff       	call   80057a <close>
	return r;
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	89 f3                	mov    %esi,%ebx
}
  800982:	89 d8                	mov    %ebx,%eax
  800984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800987:	5b                   	pop    %ebx
  800988:	5e                   	pop    %esi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	56                   	push   %esi
  80098f:	53                   	push   %ebx
  800990:	89 c6                	mov    %eax,%esi
  800992:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800994:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80099b:	74 27                	je     8009c4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80099d:	6a 07                	push   $0x7
  80099f:	68 00 50 80 00       	push   $0x805000
  8009a4:	56                   	push   %esi
  8009a5:	ff 35 00 40 80 00    	pushl  0x804000
  8009ab:	e8 e0 16 00 00       	call   802090 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b0:	83 c4 0c             	add    $0xc,%esp
  8009b3:	6a 00                	push   $0x0
  8009b5:	53                   	push   %ebx
  8009b6:	6a 00                	push   $0x0
  8009b8:	e8 5f 16 00 00       	call   80201c <ipc_recv>
}
  8009bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c0:	5b                   	pop    %ebx
  8009c1:	5e                   	pop    %esi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009c4:	83 ec 0c             	sub    $0xc,%esp
  8009c7:	6a 01                	push   $0x1
  8009c9:	e8 1a 17 00 00       	call   8020e8 <ipc_find_env>
  8009ce:	a3 00 40 80 00       	mov    %eax,0x804000
  8009d3:	83 c4 10             	add    $0x10,%esp
  8009d6:	eb c5                	jmp    80099d <fsipc+0x12>

008009d8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009d8:	f3 0f 1e fb          	endbr32 
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fa:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ff:	e8 87 ff ff ff       	call   80098b <fsipc>
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <devfile_flush>:
{
  800a06:	f3 0f 1e fb          	endbr32 
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 40 0c             	mov    0xc(%eax),%eax
  800a16:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a20:	b8 06 00 00 00       	mov    $0x6,%eax
  800a25:	e8 61 ff ff ff       	call   80098b <fsipc>
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <devfile_stat>:
{
  800a2c:	f3 0f 1e fb          	endbr32 
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	53                   	push   %ebx
  800a34:	83 ec 04             	sub    $0x4,%esp
  800a37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  800a40:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	b8 05 00 00 00       	mov    $0x5,%eax
  800a4f:	e8 37 ff ff ff       	call   80098b <fsipc>
  800a54:	85 c0                	test   %eax,%eax
  800a56:	78 2c                	js     800a84 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	68 00 50 80 00       	push   $0x805000
  800a60:	53                   	push   %ebx
  800a61:	e8 44 12 00 00       	call   801caa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a66:	a1 80 50 80 00       	mov    0x805080,%eax
  800a6b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a71:	a1 84 50 80 00       	mov    0x805084,%eax
  800a76:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <devfile_write>:
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a96:	8b 55 08             	mov    0x8(%ebp),%edx
  800a99:	8b 52 0c             	mov    0xc(%edx),%edx
  800a9c:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800aa2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aa7:	ba 00 10 00 00       	mov    $0x1000,%edx
  800aac:	0f 47 c2             	cmova  %edx,%eax
  800aaf:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800ab4:	50                   	push   %eax
  800ab5:	ff 75 0c             	pushl  0xc(%ebp)
  800ab8:	68 08 50 80 00       	push   $0x805008
  800abd:	e8 9e 13 00 00       	call   801e60 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	b8 04 00 00 00       	mov    $0x4,%eax
  800acc:	e8 ba fe ff ff       	call   80098b <fsipc>
}
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <devfile_read>:
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ae5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800aea:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800af0:	ba 00 00 00 00       	mov    $0x0,%edx
  800af5:	b8 03 00 00 00       	mov    $0x3,%eax
  800afa:	e8 8c fe ff ff       	call   80098b <fsipc>
  800aff:	89 c3                	mov    %eax,%ebx
  800b01:	85 c0                	test   %eax,%eax
  800b03:	78 1f                	js     800b24 <devfile_read+0x51>
	assert(r <= n);
  800b05:	39 f0                	cmp    %esi,%eax
  800b07:	77 24                	ja     800b2d <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b09:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b0e:	7f 33                	jg     800b43 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b10:	83 ec 04             	sub    $0x4,%esp
  800b13:	50                   	push   %eax
  800b14:	68 00 50 80 00       	push   $0x805000
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	e8 3f 13 00 00       	call   801e60 <memmove>
	return r;
  800b21:	83 c4 10             	add    $0x10,%esp
}
  800b24:	89 d8                	mov    %ebx,%eax
  800b26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b29:	5b                   	pop    %ebx
  800b2a:	5e                   	pop    %esi
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    
	assert(r <= n);
  800b2d:	68 a8 24 80 00       	push   $0x8024a8
  800b32:	68 af 24 80 00       	push   $0x8024af
  800b37:	6a 7c                	push   $0x7c
  800b39:	68 c4 24 80 00       	push   $0x8024c4
  800b3e:	e8 76 0a 00 00       	call   8015b9 <_panic>
	assert(r <= PGSIZE);
  800b43:	68 cf 24 80 00       	push   $0x8024cf
  800b48:	68 af 24 80 00       	push   $0x8024af
  800b4d:	6a 7d                	push   $0x7d
  800b4f:	68 c4 24 80 00       	push   $0x8024c4
  800b54:	e8 60 0a 00 00       	call   8015b9 <_panic>

00800b59 <open>:
{
  800b59:	f3 0f 1e fb          	endbr32 
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 1c             	sub    $0x1c,%esp
  800b65:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b68:	56                   	push   %esi
  800b69:	e8 f9 10 00 00       	call   801c67 <strlen>
  800b6e:	83 c4 10             	add    $0x10,%esp
  800b71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b76:	7f 6c                	jg     800be4 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	e8 62 f8 ff ff       	call   8003e6 <fd_alloc>
  800b84:	89 c3                	mov    %eax,%ebx
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	78 3c                	js     800bc9 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	56                   	push   %esi
  800b91:	68 00 50 80 00       	push   $0x805000
  800b96:	e8 0f 11 00 00       	call   801caa <strcpy>
	fsipcbuf.open.req_omode = mode;
  800b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  800bab:	e8 db fd ff ff       	call   80098b <fsipc>
  800bb0:	89 c3                	mov    %eax,%ebx
  800bb2:	83 c4 10             	add    $0x10,%esp
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	78 19                	js     800bd2 <open+0x79>
	return fd2num(fd);
  800bb9:	83 ec 0c             	sub    $0xc,%esp
  800bbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbf:	e8 f3 f7 ff ff       	call   8003b7 <fd2num>
  800bc4:	89 c3                	mov    %eax,%ebx
  800bc6:	83 c4 10             	add    $0x10,%esp
}
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    
		fd_close(fd, 0);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	6a 00                	push   $0x0
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	e8 10 f9 ff ff       	call   8004ef <fd_close>
		return r;
  800bdf:	83 c4 10             	add    $0x10,%esp
  800be2:	eb e5                	jmp    800bc9 <open+0x70>
		return -E_BAD_PATH;
  800be4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800be9:	eb de                	jmp    800bc9 <open+0x70>

00800beb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800beb:	f3 0f 1e fb          	endbr32 
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 08 00 00 00       	mov    $0x8,%eax
  800bff:	e8 87 fd ff ff       	call   80098b <fsipc>
}
  800c04:	c9                   	leave  
  800c05:	c3                   	ret    

00800c06 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c06:	f3 0f 1e fb          	endbr32 
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c10:	68 db 24 80 00       	push   $0x8024db
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	e8 8d 10 00 00       	call   801caa <strcpy>
	return 0;
}
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <devsock_close>:
{
  800c24:	f3 0f 1e fb          	endbr32 
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	53                   	push   %ebx
  800c2c:	83 ec 10             	sub    $0x10,%esp
  800c2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c32:	53                   	push   %ebx
  800c33:	e8 ed 14 00 00       	call   802125 <pageref>
  800c38:	89 c2                	mov    %eax,%edx
  800c3a:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c42:	83 fa 01             	cmp    $0x1,%edx
  800c45:	74 05                	je     800c4c <devsock_close+0x28>
}
  800c47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c4c:	83 ec 0c             	sub    $0xc,%esp
  800c4f:	ff 73 0c             	pushl  0xc(%ebx)
  800c52:	e8 e3 02 00 00       	call   800f3a <nsipc_close>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	eb eb                	jmp    800c47 <devsock_close+0x23>

00800c5c <devsock_write>:
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c66:	6a 00                	push   $0x0
  800c68:	ff 75 10             	pushl  0x10(%ebp)
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff 70 0c             	pushl  0xc(%eax)
  800c74:	e8 b5 03 00 00       	call   80102e <nsipc_send>
}
  800c79:	c9                   	leave  
  800c7a:	c3                   	ret    

00800c7b <devsock_read>:
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c85:	6a 00                	push   $0x0
  800c87:	ff 75 10             	pushl  0x10(%ebp)
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	ff 70 0c             	pushl  0xc(%eax)
  800c93:	e8 1f 03 00 00       	call   800fb7 <nsipc_recv>
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <fd2sockid>:
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ca0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ca3:	52                   	push   %edx
  800ca4:	50                   	push   %eax
  800ca5:	e8 92 f7 ff ff       	call   80043c <fd_lookup>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	85 c0                	test   %eax,%eax
  800caf:	78 10                	js     800cc1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800cba:	39 08                	cmp    %ecx,(%eax)
  800cbc:	75 05                	jne    800cc3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cbe:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    
		return -E_NOT_SUPP;
  800cc3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cc8:	eb f7                	jmp    800cc1 <fd2sockid+0x27>

00800cca <alloc_sockfd>:
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
  800ccf:	83 ec 1c             	sub    $0x1c,%esp
  800cd2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cd7:	50                   	push   %eax
  800cd8:	e8 09 f7 ff ff       	call   8003e6 <fd_alloc>
  800cdd:	89 c3                	mov    %eax,%ebx
  800cdf:	83 c4 10             	add    $0x10,%esp
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	78 43                	js     800d29 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ce6:	83 ec 04             	sub    $0x4,%esp
  800ce9:	68 07 04 00 00       	push   $0x407
  800cee:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf1:	6a 00                	push   $0x0
  800cf3:	e8 8b f4 ff ff       	call   800183 <sys_page_alloc>
  800cf8:	89 c3                	mov    %eax,%ebx
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	78 28                	js     800d29 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d04:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d0a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d0f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d16:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	e8 95 f6 ff ff       	call   8003b7 <fd2num>
  800d22:	89 c3                	mov    %eax,%ebx
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	eb 0c                	jmp    800d35 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	56                   	push   %esi
  800d2d:	e8 08 02 00 00       	call   800f3a <nsipc_close>
		return r;
  800d32:	83 c4 10             	add    $0x10,%esp
}
  800d35:	89 d8                	mov    %ebx,%eax
  800d37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <accept>:
{
  800d3e:	f3 0f 1e fb          	endbr32 
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	e8 4a ff ff ff       	call   800c9a <fd2sockid>
  800d50:	85 c0                	test   %eax,%eax
  800d52:	78 1b                	js     800d6f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d54:	83 ec 04             	sub    $0x4,%esp
  800d57:	ff 75 10             	pushl  0x10(%ebp)
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	50                   	push   %eax
  800d5e:	e8 22 01 00 00       	call   800e85 <nsipc_accept>
  800d63:	83 c4 10             	add    $0x10,%esp
  800d66:	85 c0                	test   %eax,%eax
  800d68:	78 05                	js     800d6f <accept+0x31>
	return alloc_sockfd(r);
  800d6a:	e8 5b ff ff ff       	call   800cca <alloc_sockfd>
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <bind>:
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	e8 17 ff ff ff       	call   800c9a <fd2sockid>
  800d83:	85 c0                	test   %eax,%eax
  800d85:	78 12                	js     800d99 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d87:	83 ec 04             	sub    $0x4,%esp
  800d8a:	ff 75 10             	pushl  0x10(%ebp)
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	50                   	push   %eax
  800d91:	e8 45 01 00 00       	call   800edb <nsipc_bind>
  800d96:	83 c4 10             	add    $0x10,%esp
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <shutdown>:
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	e8 ed fe ff ff       	call   800c9a <fd2sockid>
  800dad:	85 c0                	test   %eax,%eax
  800daf:	78 0f                	js     800dc0 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800db1:	83 ec 08             	sub    $0x8,%esp
  800db4:	ff 75 0c             	pushl  0xc(%ebp)
  800db7:	50                   	push   %eax
  800db8:	e8 57 01 00 00       	call   800f14 <nsipc_shutdown>
  800dbd:	83 c4 10             	add    $0x10,%esp
}
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <connect>:
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	e8 c6 fe ff ff       	call   800c9a <fd2sockid>
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	78 12                	js     800dea <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	ff 75 10             	pushl  0x10(%ebp)
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	50                   	push   %eax
  800de2:	e8 71 01 00 00       	call   800f58 <nsipc_connect>
  800de7:	83 c4 10             	add    $0x10,%esp
}
  800dea:	c9                   	leave  
  800deb:	c3                   	ret    

00800dec <listen>:
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	e8 9c fe ff ff       	call   800c9a <fd2sockid>
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	78 0f                	js     800e11 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 0c             	pushl  0xc(%ebp)
  800e08:	50                   	push   %eax
  800e09:	e8 83 01 00 00       	call   800f91 <nsipc_listen>
  800e0e:	83 c4 10             	add    $0x10,%esp
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e13:	f3 0f 1e fb          	endbr32 
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e1d:	ff 75 10             	pushl  0x10(%ebp)
  800e20:	ff 75 0c             	pushl  0xc(%ebp)
  800e23:	ff 75 08             	pushl  0x8(%ebp)
  800e26:	e8 65 02 00 00       	call   801090 <nsipc_socket>
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	78 05                	js     800e37 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e32:	e8 93 fe ff ff       	call   800cca <alloc_sockfd>
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 04             	sub    $0x4,%esp
  800e40:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e42:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e49:	74 26                	je     800e71 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e4b:	6a 07                	push   $0x7
  800e4d:	68 00 60 80 00       	push   $0x806000
  800e52:	53                   	push   %ebx
  800e53:	ff 35 04 40 80 00    	pushl  0x804004
  800e59:	e8 32 12 00 00       	call   802090 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e5e:	83 c4 0c             	add    $0xc,%esp
  800e61:	6a 00                	push   $0x0
  800e63:	6a 00                	push   $0x0
  800e65:	6a 00                	push   $0x0
  800e67:	e8 b0 11 00 00       	call   80201c <ipc_recv>
}
  800e6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	6a 02                	push   $0x2
  800e76:	e8 6d 12 00 00       	call   8020e8 <ipc_find_env>
  800e7b:	a3 04 40 80 00       	mov    %eax,0x804004
  800e80:	83 c4 10             	add    $0x10,%esp
  800e83:	eb c6                	jmp    800e4b <nsipc+0x12>

00800e85 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e85:	f3 0f 1e fb          	endbr32 
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800e99:	8b 06                	mov    (%esi),%eax
  800e9b:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ea0:	b8 01 00 00 00       	mov    $0x1,%eax
  800ea5:	e8 8f ff ff ff       	call   800e39 <nsipc>
  800eaa:	89 c3                	mov    %eax,%ebx
  800eac:	85 c0                	test   %eax,%eax
  800eae:	79 09                	jns    800eb9 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800eb0:	89 d8                	mov    %ebx,%eax
  800eb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800eb9:	83 ec 04             	sub    $0x4,%esp
  800ebc:	ff 35 10 60 80 00    	pushl  0x806010
  800ec2:	68 00 60 80 00       	push   $0x806000
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	e8 91 0f 00 00       	call   801e60 <memmove>
		*addrlen = ret->ret_addrlen;
  800ecf:	a1 10 60 80 00       	mov    0x806010,%eax
  800ed4:	89 06                	mov    %eax,(%esi)
  800ed6:	83 c4 10             	add    $0x10,%esp
	return r;
  800ed9:	eb d5                	jmp    800eb0 <nsipc_accept+0x2b>

00800edb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800edb:	f3 0f 1e fb          	endbr32 
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ef1:	53                   	push   %ebx
  800ef2:	ff 75 0c             	pushl  0xc(%ebp)
  800ef5:	68 04 60 80 00       	push   $0x806004
  800efa:	e8 61 0f 00 00       	call   801e60 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800eff:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f05:	b8 02 00 00 00       	mov    $0x2,%eax
  800f0a:	e8 2a ff ff ff       	call   800e39 <nsipc>
}
  800f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f2e:	b8 03 00 00 00       	mov    $0x3,%eax
  800f33:	e8 01 ff ff ff       	call   800e39 <nsipc>
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <nsipc_close>:

int
nsipc_close(int s)
{
  800f3a:	f3 0f 1e fb          	endbr32 
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f4c:	b8 04 00 00 00       	mov    $0x4,%eax
  800f51:	e8 e3 fe ff ff       	call   800e39 <nsipc>
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f58:	f3 0f 1e fb          	endbr32 
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f6e:	53                   	push   %ebx
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	68 04 60 80 00       	push   $0x806004
  800f77:	e8 e4 0e 00 00       	call   801e60 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f7c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f82:	b8 05 00 00 00       	mov    $0x5,%eax
  800f87:	e8 ad fe ff ff       	call   800e39 <nsipc>
}
  800f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f91:	f3 0f 1e fb          	endbr32 
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fab:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb0:	e8 84 fe ff ff       	call   800e39 <nsipc>
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fb7:	f3 0f 1e fb          	endbr32 
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fcb:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fd9:	b8 07 00 00 00       	mov    $0x7,%eax
  800fde:	e8 56 fe ff ff       	call   800e39 <nsipc>
  800fe3:	89 c3                	mov    %eax,%ebx
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	78 26                	js     80100f <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800fe9:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800fef:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800ff4:	0f 4e c6             	cmovle %esi,%eax
  800ff7:	39 c3                	cmp    %eax,%ebx
  800ff9:	7f 1d                	jg     801018 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	53                   	push   %ebx
  800fff:	68 00 60 80 00       	push   $0x806000
  801004:	ff 75 0c             	pushl  0xc(%ebp)
  801007:	e8 54 0e 00 00       	call   801e60 <memmove>
  80100c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80100f:	89 d8                	mov    %ebx,%eax
  801011:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801018:	68 e7 24 80 00       	push   $0x8024e7
  80101d:	68 af 24 80 00       	push   $0x8024af
  801022:	6a 62                	push   $0x62
  801024:	68 fc 24 80 00       	push   $0x8024fc
  801029:	e8 8b 05 00 00       	call   8015b9 <_panic>

0080102e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80102e:	f3 0f 1e fb          	endbr32 
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	53                   	push   %ebx
  801036:	83 ec 04             	sub    $0x4,%esp
  801039:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801044:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80104a:	7f 2e                	jg     80107a <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80104c:	83 ec 04             	sub    $0x4,%esp
  80104f:	53                   	push   %ebx
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	68 0c 60 80 00       	push   $0x80600c
  801058:	e8 03 0e 00 00       	call   801e60 <memmove>
	nsipcbuf.send.req_size = size;
  80105d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801063:	8b 45 14             	mov    0x14(%ebp),%eax
  801066:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80106b:	b8 08 00 00 00       	mov    $0x8,%eax
  801070:	e8 c4 fd ff ff       	call   800e39 <nsipc>
}
  801075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801078:	c9                   	leave  
  801079:	c3                   	ret    
	assert(size < 1600);
  80107a:	68 08 25 80 00       	push   $0x802508
  80107f:	68 af 24 80 00       	push   $0x8024af
  801084:	6a 6d                	push   $0x6d
  801086:	68 fc 24 80 00       	push   $0x8024fc
  80108b:	e8 29 05 00 00       	call   8015b9 <_panic>

00801090 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010b2:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b7:	e8 7d fd ff ff       	call   800e39 <nsipc>
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010be:	f3 0f 1e fb          	endbr32 
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
  8010c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	ff 75 08             	pushl  0x8(%ebp)
  8010d0:	e8 f6 f2 ff ff       	call   8003cb <fd2data>
  8010d5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010d7:	83 c4 08             	add    $0x8,%esp
  8010da:	68 14 25 80 00       	push   $0x802514
  8010df:	53                   	push   %ebx
  8010e0:	e8 c5 0b 00 00       	call   801caa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010e5:	8b 46 04             	mov    0x4(%esi),%eax
  8010e8:	2b 06                	sub    (%esi),%eax
  8010ea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010f7:	00 00 00 
	stat->st_dev = &devpipe;
  8010fa:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801101:	30 80 00 
	return 0;
}
  801104:	b8 00 00 00 00       	mov    $0x0,%eax
  801109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801110:	f3 0f 1e fb          	endbr32 
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	53                   	push   %ebx
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80111e:	53                   	push   %ebx
  80111f:	6a 00                	push   $0x0
  801121:	e8 ea f0 ff ff       	call   800210 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801126:	89 1c 24             	mov    %ebx,(%esp)
  801129:	e8 9d f2 ff ff       	call   8003cb <fd2data>
  80112e:	83 c4 08             	add    $0x8,%esp
  801131:	50                   	push   %eax
  801132:	6a 00                	push   $0x0
  801134:	e8 d7 f0 ff ff       	call   800210 <sys_page_unmap>
}
  801139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <_pipeisclosed>:
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	57                   	push   %edi
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
  801144:	83 ec 1c             	sub    $0x1c,%esp
  801147:	89 c7                	mov    %eax,%edi
  801149:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80114b:	a1 08 40 80 00       	mov    0x804008,%eax
  801150:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	57                   	push   %edi
  801157:	e8 c9 0f 00 00       	call   802125 <pageref>
  80115c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80115f:	89 34 24             	mov    %esi,(%esp)
  801162:	e8 be 0f 00 00       	call   802125 <pageref>
		nn = thisenv->env_runs;
  801167:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80116d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	39 cb                	cmp    %ecx,%ebx
  801175:	74 1b                	je     801192 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801177:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80117a:	75 cf                	jne    80114b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80117c:	8b 42 58             	mov    0x58(%edx),%eax
  80117f:	6a 01                	push   $0x1
  801181:	50                   	push   %eax
  801182:	53                   	push   %ebx
  801183:	68 1b 25 80 00       	push   $0x80251b
  801188:	e8 13 05 00 00       	call   8016a0 <cprintf>
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	eb b9                	jmp    80114b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801192:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801195:	0f 94 c0             	sete   %al
  801198:	0f b6 c0             	movzbl %al,%eax
}
  80119b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119e:	5b                   	pop    %ebx
  80119f:	5e                   	pop    %esi
  8011a0:	5f                   	pop    %edi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <devpipe_write>:
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	57                   	push   %edi
  8011ab:	56                   	push   %esi
  8011ac:	53                   	push   %ebx
  8011ad:	83 ec 28             	sub    $0x28,%esp
  8011b0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011b3:	56                   	push   %esi
  8011b4:	e8 12 f2 ff ff       	call   8003cb <fd2data>
  8011b9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011bb:	83 c4 10             	add    $0x10,%esp
  8011be:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011c6:	74 4f                	je     801217 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011c8:	8b 43 04             	mov    0x4(%ebx),%eax
  8011cb:	8b 0b                	mov    (%ebx),%ecx
  8011cd:	8d 51 20             	lea    0x20(%ecx),%edx
  8011d0:	39 d0                	cmp    %edx,%eax
  8011d2:	72 14                	jb     8011e8 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011d4:	89 da                	mov    %ebx,%edx
  8011d6:	89 f0                	mov    %esi,%eax
  8011d8:	e8 61 ff ff ff       	call   80113e <_pipeisclosed>
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	75 3b                	jne    80121c <devpipe_write+0x79>
			sys_yield();
  8011e1:	e8 7a ef ff ff       	call   800160 <sys_yield>
  8011e6:	eb e0                	jmp    8011c8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011eb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011ef:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	c1 fa 1f             	sar    $0x1f,%edx
  8011f7:	89 d1                	mov    %edx,%ecx
  8011f9:	c1 e9 1b             	shr    $0x1b,%ecx
  8011fc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8011ff:	83 e2 1f             	and    $0x1f,%edx
  801202:	29 ca                	sub    %ecx,%edx
  801204:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801208:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80120c:	83 c0 01             	add    $0x1,%eax
  80120f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801212:	83 c7 01             	add    $0x1,%edi
  801215:	eb ac                	jmp    8011c3 <devpipe_write+0x20>
	return i;
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	eb 05                	jmp    801221 <devpipe_write+0x7e>
				return 0;
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <devpipe_read>:
{
  801229:	f3 0f 1e fb          	endbr32 
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 18             	sub    $0x18,%esp
  801236:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801239:	57                   	push   %edi
  80123a:	e8 8c f1 ff ff       	call   8003cb <fd2data>
  80123f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	be 00 00 00 00       	mov    $0x0,%esi
  801249:	3b 75 10             	cmp    0x10(%ebp),%esi
  80124c:	75 14                	jne    801262 <devpipe_read+0x39>
	return i;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	eb 02                	jmp    801255 <devpipe_read+0x2c>
				return i;
  801253:	89 f0                	mov    %esi,%eax
}
  801255:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801258:	5b                   	pop    %ebx
  801259:	5e                   	pop    %esi
  80125a:	5f                   	pop    %edi
  80125b:	5d                   	pop    %ebp
  80125c:	c3                   	ret    
			sys_yield();
  80125d:	e8 fe ee ff ff       	call   800160 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801262:	8b 03                	mov    (%ebx),%eax
  801264:	3b 43 04             	cmp    0x4(%ebx),%eax
  801267:	75 18                	jne    801281 <devpipe_read+0x58>
			if (i > 0)
  801269:	85 f6                	test   %esi,%esi
  80126b:	75 e6                	jne    801253 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80126d:	89 da                	mov    %ebx,%edx
  80126f:	89 f8                	mov    %edi,%eax
  801271:	e8 c8 fe ff ff       	call   80113e <_pipeisclosed>
  801276:	85 c0                	test   %eax,%eax
  801278:	74 e3                	je     80125d <devpipe_read+0x34>
				return 0;
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
  80127f:	eb d4                	jmp    801255 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801281:	99                   	cltd   
  801282:	c1 ea 1b             	shr    $0x1b,%edx
  801285:	01 d0                	add    %edx,%eax
  801287:	83 e0 1f             	and    $0x1f,%eax
  80128a:	29 d0                	sub    %edx,%eax
  80128c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801291:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801294:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801297:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80129a:	83 c6 01             	add    $0x1,%esi
  80129d:	eb aa                	jmp    801249 <devpipe_read+0x20>

0080129f <pipe>:
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	56                   	push   %esi
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ae:	50                   	push   %eax
  8012af:	e8 32 f1 ff ff       	call   8003e6 <fd_alloc>
  8012b4:	89 c3                	mov    %eax,%ebx
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	0f 88 23 01 00 00    	js     8013e4 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	68 07 04 00 00       	push   $0x407
  8012c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cc:	6a 00                	push   $0x0
  8012ce:	e8 b0 ee ff ff       	call   800183 <sys_page_alloc>
  8012d3:	89 c3                	mov    %eax,%ebx
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	0f 88 04 01 00 00    	js     8013e4 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	e8 fa f0 ff ff       	call   8003e6 <fd_alloc>
  8012ec:	89 c3                	mov    %eax,%ebx
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	85 c0                	test   %eax,%eax
  8012f3:	0f 88 db 00 00 00    	js     8013d4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	68 07 04 00 00       	push   $0x407
  801301:	ff 75 f0             	pushl  -0x10(%ebp)
  801304:	6a 00                	push   $0x0
  801306:	e8 78 ee ff ff       	call   800183 <sys_page_alloc>
  80130b:	89 c3                	mov    %eax,%ebx
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	85 c0                	test   %eax,%eax
  801312:	0f 88 bc 00 00 00    	js     8013d4 <pipe+0x135>
	va = fd2data(fd0);
  801318:	83 ec 0c             	sub    $0xc,%esp
  80131b:	ff 75 f4             	pushl  -0xc(%ebp)
  80131e:	e8 a8 f0 ff ff       	call   8003cb <fd2data>
  801323:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801325:	83 c4 0c             	add    $0xc,%esp
  801328:	68 07 04 00 00       	push   $0x407
  80132d:	50                   	push   %eax
  80132e:	6a 00                	push   $0x0
  801330:	e8 4e ee ff ff       	call   800183 <sys_page_alloc>
  801335:	89 c3                	mov    %eax,%ebx
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	85 c0                	test   %eax,%eax
  80133c:	0f 88 82 00 00 00    	js     8013c4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801342:	83 ec 0c             	sub    $0xc,%esp
  801345:	ff 75 f0             	pushl  -0x10(%ebp)
  801348:	e8 7e f0 ff ff       	call   8003cb <fd2data>
  80134d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801354:	50                   	push   %eax
  801355:	6a 00                	push   $0x0
  801357:	56                   	push   %esi
  801358:	6a 00                	push   $0x0
  80135a:	e8 6b ee ff ff       	call   8001ca <sys_page_map>
  80135f:	89 c3                	mov    %eax,%ebx
  801361:	83 c4 20             	add    $0x20,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 4e                	js     8013b6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801368:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801375:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80137c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80137f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	ff 75 f4             	pushl  -0xc(%ebp)
  801391:	e8 21 f0 ff ff       	call   8003b7 <fd2num>
  801396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801399:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80139b:	83 c4 04             	add    $0x4,%esp
  80139e:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a1:	e8 11 f0 ff ff       	call   8003b7 <fd2num>
  8013a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b4:	eb 2e                	jmp    8013e4 <pipe+0x145>
	sys_page_unmap(0, va);
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	56                   	push   %esi
  8013ba:	6a 00                	push   $0x0
  8013bc:	e8 4f ee ff ff       	call   800210 <sys_page_unmap>
  8013c1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013c4:	83 ec 08             	sub    $0x8,%esp
  8013c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ca:	6a 00                	push   $0x0
  8013cc:	e8 3f ee ff ff       	call   800210 <sys_page_unmap>
  8013d1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013d4:	83 ec 08             	sub    $0x8,%esp
  8013d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8013da:	6a 00                	push   $0x0
  8013dc:	e8 2f ee ff ff       	call   800210 <sys_page_unmap>
  8013e1:	83 c4 10             	add    $0x10,%esp
}
  8013e4:	89 d8                	mov    %ebx,%eax
  8013e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <pipeisclosed>:
{
  8013ed:	f3 0f 1e fb          	endbr32 
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fa:	50                   	push   %eax
  8013fb:	ff 75 08             	pushl  0x8(%ebp)
  8013fe:	e8 39 f0 ff ff       	call   80043c <fd_lookup>
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	78 18                	js     801422 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	ff 75 f4             	pushl  -0xc(%ebp)
  801410:	e8 b6 ef ff ff       	call   8003cb <fd2data>
  801415:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141a:	e8 1f fd ff ff       	call   80113e <_pipeisclosed>
  80141f:	83 c4 10             	add    $0x10,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801424:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801428:	b8 00 00 00 00       	mov    $0x0,%eax
  80142d:	c3                   	ret    

0080142e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80142e:	f3 0f 1e fb          	endbr32 
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801438:	68 33 25 80 00       	push   $0x802533
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	e8 65 08 00 00       	call   801caa <strcpy>
	return 0;
}
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <devcons_write>:
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	57                   	push   %edi
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80145c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801461:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801467:	3b 75 10             	cmp    0x10(%ebp),%esi
  80146a:	73 31                	jae    80149d <devcons_write+0x51>
		m = n - tot;
  80146c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80146f:	29 f3                	sub    %esi,%ebx
  801471:	83 fb 7f             	cmp    $0x7f,%ebx
  801474:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801479:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	53                   	push   %ebx
  801480:	89 f0                	mov    %esi,%eax
  801482:	03 45 0c             	add    0xc(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	57                   	push   %edi
  801487:	e8 d4 09 00 00       	call   801e60 <memmove>
		sys_cputs(buf, m);
  80148c:	83 c4 08             	add    $0x8,%esp
  80148f:	53                   	push   %ebx
  801490:	57                   	push   %edi
  801491:	e8 1d ec ff ff       	call   8000b3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801496:	01 de                	add    %ebx,%esi
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	eb ca                	jmp    801467 <devcons_write+0x1b>
}
  80149d:	89 f0                	mov    %esi,%eax
  80149f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5e                   	pop    %esi
  8014a4:	5f                   	pop    %edi
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <devcons_read>:
{
  8014a7:	f3 0f 1e fb          	endbr32 
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ba:	74 21                	je     8014dd <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014bc:	e8 14 ec ff ff       	call   8000d5 <sys_cgetc>
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	75 07                	jne    8014cc <devcons_read+0x25>
		sys_yield();
  8014c5:	e8 96 ec ff ff       	call   800160 <sys_yield>
  8014ca:	eb f0                	jmp    8014bc <devcons_read+0x15>
	if (c < 0)
  8014cc:	78 0f                	js     8014dd <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014ce:	83 f8 04             	cmp    $0x4,%eax
  8014d1:	74 0c                	je     8014df <devcons_read+0x38>
	*(char*)vbuf = c;
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	88 02                	mov    %al,(%edx)
	return 1;
  8014d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    
		return 0;
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e4:	eb f7                	jmp    8014dd <devcons_read+0x36>

008014e6 <cputchar>:
{
  8014e6:	f3 0f 1e fb          	endbr32 
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014f6:	6a 01                	push   $0x1
  8014f8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8014fb:	50                   	push   %eax
  8014fc:	e8 b2 eb ff ff       	call   8000b3 <sys_cputs>
}
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <getchar>:
{
  801506:	f3 0f 1e fb          	endbr32 
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801510:	6a 01                	push   $0x1
  801512:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	6a 00                	push   $0x0
  801518:	e8 a7 f1 ff ff       	call   8006c4 <read>
	if (r < 0)
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	78 06                	js     80152a <getchar+0x24>
	if (r < 1)
  801524:	74 06                	je     80152c <getchar+0x26>
	return c;
  801526:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    
		return -E_EOF;
  80152c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801531:	eb f7                	jmp    80152a <getchar+0x24>

00801533 <iscons>:
{
  801533:	f3 0f 1e fb          	endbr32 
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801540:	50                   	push   %eax
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	e8 f3 ee ff ff       	call   80043c <fd_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 11                	js     801561 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801559:	39 10                	cmp    %edx,(%eax)
  80155b:	0f 94 c0             	sete   %al
  80155e:	0f b6 c0             	movzbl %al,%eax
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <opencons>:
{
  801563:	f3 0f 1e fb          	endbr32 
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80156d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801570:	50                   	push   %eax
  801571:	e8 70 ee ff ff       	call   8003e6 <fd_alloc>
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 3a                	js     8015b7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80157d:	83 ec 04             	sub    $0x4,%esp
  801580:	68 07 04 00 00       	push   $0x407
  801585:	ff 75 f4             	pushl  -0xc(%ebp)
  801588:	6a 00                	push   $0x0
  80158a:	e8 f4 eb ff ff       	call   800183 <sys_page_alloc>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 21                	js     8015b7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80159f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015ab:	83 ec 0c             	sub    $0xc,%esp
  8015ae:	50                   	push   %eax
  8015af:	e8 03 ee ff ff       	call   8003b7 <fd2num>
  8015b4:	83 c4 10             	add    $0x10,%esp
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015b9:	f3 0f 1e fb          	endbr32 
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015c2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015c5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015cb:	e8 6d eb ff ff       	call   80013d <sys_getenvid>
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	56                   	push   %esi
  8015da:	50                   	push   %eax
  8015db:	68 40 25 80 00       	push   $0x802540
  8015e0:	e8 bb 00 00 00       	call   8016a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015e5:	83 c4 18             	add    $0x18,%esp
  8015e8:	53                   	push   %ebx
  8015e9:	ff 75 10             	pushl  0x10(%ebp)
  8015ec:	e8 5a 00 00 00       	call   80164b <vcprintf>
	cprintf("\n");
  8015f1:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  8015f8:	e8 a3 00 00 00       	call   8016a0 <cprintf>
  8015fd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801600:	cc                   	int3   
  801601:	eb fd                	jmp    801600 <_panic+0x47>

00801603 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801603:	f3 0f 1e fb          	endbr32 
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	53                   	push   %ebx
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801611:	8b 13                	mov    (%ebx),%edx
  801613:	8d 42 01             	lea    0x1(%edx),%eax
  801616:	89 03                	mov    %eax,(%ebx)
  801618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80161b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80161f:	3d ff 00 00 00       	cmp    $0xff,%eax
  801624:	74 09                	je     80162f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801626:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80162a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80162f:	83 ec 08             	sub    $0x8,%esp
  801632:	68 ff 00 00 00       	push   $0xff
  801637:	8d 43 08             	lea    0x8(%ebx),%eax
  80163a:	50                   	push   %eax
  80163b:	e8 73 ea ff ff       	call   8000b3 <sys_cputs>
		b->idx = 0;
  801640:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	eb db                	jmp    801626 <putch+0x23>

0080164b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80164b:	f3 0f 1e fb          	endbr32 
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801658:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80165f:	00 00 00 
	b.cnt = 0;
  801662:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801669:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	68 03 16 80 00       	push   $0x801603
  80167e:	e8 20 01 00 00       	call   8017a3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801683:	83 c4 08             	add    $0x8,%esp
  801686:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80168c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	e8 1b ea ff ff       	call   8000b3 <sys_cputs>

	return b.cnt;
}
  801698:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016a0:	f3 0f 1e fb          	endbr32 
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016aa:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016ad:	50                   	push   %eax
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 95 ff ff ff       	call   80164b <vcprintf>
	va_end(ap);

	return cnt;
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	57                   	push   %edi
  8016bc:	56                   	push   %esi
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 1c             	sub    $0x1c,%esp
  8016c1:	89 c7                	mov    %eax,%edi
  8016c3:	89 d6                	mov    %edx,%esi
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	89 d1                	mov    %edx,%ecx
  8016cd:	89 c2                	mov    %eax,%edx
  8016cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016e5:	39 c2                	cmp    %eax,%edx
  8016e7:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016ea:	72 3e                	jb     80172a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016ec:	83 ec 0c             	sub    $0xc,%esp
  8016ef:	ff 75 18             	pushl  0x18(%ebp)
  8016f2:	83 eb 01             	sub    $0x1,%ebx
  8016f5:	53                   	push   %ebx
  8016f6:	50                   	push   %eax
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016fd:	ff 75 e0             	pushl  -0x20(%ebp)
  801700:	ff 75 dc             	pushl  -0x24(%ebp)
  801703:	ff 75 d8             	pushl  -0x28(%ebp)
  801706:	e8 65 0a 00 00       	call   802170 <__udivdi3>
  80170b:	83 c4 18             	add    $0x18,%esp
  80170e:	52                   	push   %edx
  80170f:	50                   	push   %eax
  801710:	89 f2                	mov    %esi,%edx
  801712:	89 f8                	mov    %edi,%eax
  801714:	e8 9f ff ff ff       	call   8016b8 <printnum>
  801719:	83 c4 20             	add    $0x20,%esp
  80171c:	eb 13                	jmp    801731 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	56                   	push   %esi
  801722:	ff 75 18             	pushl  0x18(%ebp)
  801725:	ff d7                	call   *%edi
  801727:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80172a:	83 eb 01             	sub    $0x1,%ebx
  80172d:	85 db                	test   %ebx,%ebx
  80172f:	7f ed                	jg     80171e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	56                   	push   %esi
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	ff 75 e4             	pushl  -0x1c(%ebp)
  80173b:	ff 75 e0             	pushl  -0x20(%ebp)
  80173e:	ff 75 dc             	pushl  -0x24(%ebp)
  801741:	ff 75 d8             	pushl  -0x28(%ebp)
  801744:	e8 37 0b 00 00       	call   802280 <__umoddi3>
  801749:	83 c4 14             	add    $0x14,%esp
  80174c:	0f be 80 63 25 80 00 	movsbl 0x802563(%eax),%eax
  801753:	50                   	push   %eax
  801754:	ff d7                	call   *%edi
}
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175c:	5b                   	pop    %ebx
  80175d:	5e                   	pop    %esi
  80175e:	5f                   	pop    %edi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    

00801761 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801761:	f3 0f 1e fb          	endbr32 
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80176b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80176f:	8b 10                	mov    (%eax),%edx
  801771:	3b 50 04             	cmp    0x4(%eax),%edx
  801774:	73 0a                	jae    801780 <sprintputch+0x1f>
		*b->buf++ = ch;
  801776:	8d 4a 01             	lea    0x1(%edx),%ecx
  801779:	89 08                	mov    %ecx,(%eax)
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	88 02                	mov    %al,(%edx)
}
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <printfmt>:
{
  801782:	f3 0f 1e fb          	endbr32 
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80178c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80178f:	50                   	push   %eax
  801790:	ff 75 10             	pushl  0x10(%ebp)
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	ff 75 08             	pushl  0x8(%ebp)
  801799:	e8 05 00 00 00       	call   8017a3 <vprintfmt>
}
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <vprintfmt>:
{
  8017a3:	f3 0f 1e fb          	endbr32 
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	57                   	push   %edi
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 3c             	sub    $0x3c,%esp
  8017b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8017b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017b9:	e9 8e 03 00 00       	jmp    801b4c <vprintfmt+0x3a9>
		padc = ' ';
  8017be:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017c2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017dc:	8d 47 01             	lea    0x1(%edi),%eax
  8017df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017e2:	0f b6 17             	movzbl (%edi),%edx
  8017e5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017e8:	3c 55                	cmp    $0x55,%al
  8017ea:	0f 87 df 03 00 00    	ja     801bcf <vprintfmt+0x42c>
  8017f0:	0f b6 c0             	movzbl %al,%eax
  8017f3:	3e ff 24 85 a0 26 80 	notrack jmp *0x8026a0(,%eax,4)
  8017fa:	00 
  8017fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8017fe:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801802:	eb d8                	jmp    8017dc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801804:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801807:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80180b:	eb cf                	jmp    8017dc <vprintfmt+0x39>
  80180d:	0f b6 d2             	movzbl %dl,%edx
  801810:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80181b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80181e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801822:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801825:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801828:	83 f9 09             	cmp    $0x9,%ecx
  80182b:	77 55                	ja     801882 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80182d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801830:	eb e9                	jmp    80181b <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801832:	8b 45 14             	mov    0x14(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80183a:	8b 45 14             	mov    0x14(%ebp),%eax
  80183d:	8d 40 04             	lea    0x4(%eax),%eax
  801840:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801843:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801846:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80184a:	79 90                	jns    8017dc <vprintfmt+0x39>
				width = precision, precision = -1;
  80184c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80184f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801852:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801859:	eb 81                	jmp    8017dc <vprintfmt+0x39>
  80185b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185e:	85 c0                	test   %eax,%eax
  801860:	ba 00 00 00 00       	mov    $0x0,%edx
  801865:	0f 49 d0             	cmovns %eax,%edx
  801868:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80186b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80186e:	e9 69 ff ff ff       	jmp    8017dc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801873:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801876:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80187d:	e9 5a ff ff ff       	jmp    8017dc <vprintfmt+0x39>
  801882:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801885:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801888:	eb bc                	jmp    801846 <vprintfmt+0xa3>
			lflag++;
  80188a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80188d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801890:	e9 47 ff ff ff       	jmp    8017dc <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801895:	8b 45 14             	mov    0x14(%ebp),%eax
  801898:	8d 78 04             	lea    0x4(%eax),%edi
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	53                   	push   %ebx
  80189f:	ff 30                	pushl  (%eax)
  8018a1:	ff d6                	call   *%esi
			break;
  8018a3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8018a6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018a9:	e9 9b 02 00 00       	jmp    801b49 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b1:	8d 78 04             	lea    0x4(%eax),%edi
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	99                   	cltd   
  8018b7:	31 d0                	xor    %edx,%eax
  8018b9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018bb:	83 f8 0f             	cmp    $0xf,%eax
  8018be:	7f 23                	jg     8018e3 <vprintfmt+0x140>
  8018c0:	8b 14 85 00 28 80 00 	mov    0x802800(,%eax,4),%edx
  8018c7:	85 d2                	test   %edx,%edx
  8018c9:	74 18                	je     8018e3 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018cb:	52                   	push   %edx
  8018cc:	68 c1 24 80 00       	push   $0x8024c1
  8018d1:	53                   	push   %ebx
  8018d2:	56                   	push   %esi
  8018d3:	e8 aa fe ff ff       	call   801782 <printfmt>
  8018d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018db:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018de:	e9 66 02 00 00       	jmp    801b49 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018e3:	50                   	push   %eax
  8018e4:	68 7b 25 80 00       	push   $0x80257b
  8018e9:	53                   	push   %ebx
  8018ea:	56                   	push   %esi
  8018eb:	e8 92 fe ff ff       	call   801782 <printfmt>
  8018f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018f3:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018f6:	e9 4e 02 00 00       	jmp    801b49 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8018fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8018fe:	83 c0 04             	add    $0x4,%eax
  801901:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801909:	85 d2                	test   %edx,%edx
  80190b:	b8 74 25 80 00       	mov    $0x802574,%eax
  801910:	0f 45 c2             	cmovne %edx,%eax
  801913:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801916:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80191a:	7e 06                	jle    801922 <vprintfmt+0x17f>
  80191c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801920:	75 0d                	jne    80192f <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801922:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801925:	89 c7                	mov    %eax,%edi
  801927:	03 45 e0             	add    -0x20(%ebp),%eax
  80192a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80192d:	eb 55                	jmp    801984 <vprintfmt+0x1e1>
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	ff 75 d8             	pushl  -0x28(%ebp)
  801935:	ff 75 cc             	pushl  -0x34(%ebp)
  801938:	e8 46 03 00 00       	call   801c83 <strnlen>
  80193d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801940:	29 c2                	sub    %eax,%edx
  801942:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80194a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80194e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801951:	85 ff                	test   %edi,%edi
  801953:	7e 11                	jle    801966 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801955:	83 ec 08             	sub    $0x8,%esp
  801958:	53                   	push   %ebx
  801959:	ff 75 e0             	pushl  -0x20(%ebp)
  80195c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80195e:	83 ef 01             	sub    $0x1,%edi
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	eb eb                	jmp    801951 <vprintfmt+0x1ae>
  801966:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801969:	85 d2                	test   %edx,%edx
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	0f 49 c2             	cmovns %edx,%eax
  801973:	29 c2                	sub    %eax,%edx
  801975:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801978:	eb a8                	jmp    801922 <vprintfmt+0x17f>
					putch(ch, putdat);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	53                   	push   %ebx
  80197e:	52                   	push   %edx
  80197f:	ff d6                	call   *%esi
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801987:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801989:	83 c7 01             	add    $0x1,%edi
  80198c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801990:	0f be d0             	movsbl %al,%edx
  801993:	85 d2                	test   %edx,%edx
  801995:	74 4b                	je     8019e2 <vprintfmt+0x23f>
  801997:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80199b:	78 06                	js     8019a3 <vprintfmt+0x200>
  80199d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8019a1:	78 1e                	js     8019c1 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8019a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019a7:	74 d1                	je     80197a <vprintfmt+0x1d7>
  8019a9:	0f be c0             	movsbl %al,%eax
  8019ac:	83 e8 20             	sub    $0x20,%eax
  8019af:	83 f8 5e             	cmp    $0x5e,%eax
  8019b2:	76 c6                	jbe    80197a <vprintfmt+0x1d7>
					putch('?', putdat);
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	53                   	push   %ebx
  8019b8:	6a 3f                	push   $0x3f
  8019ba:	ff d6                	call   *%esi
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	eb c3                	jmp    801984 <vprintfmt+0x1e1>
  8019c1:	89 cf                	mov    %ecx,%edi
  8019c3:	eb 0e                	jmp    8019d3 <vprintfmt+0x230>
				putch(' ', putdat);
  8019c5:	83 ec 08             	sub    $0x8,%esp
  8019c8:	53                   	push   %ebx
  8019c9:	6a 20                	push   $0x20
  8019cb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019cd:	83 ef 01             	sub    $0x1,%edi
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 ff                	test   %edi,%edi
  8019d5:	7f ee                	jg     8019c5 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019da:	89 45 14             	mov    %eax,0x14(%ebp)
  8019dd:	e9 67 01 00 00       	jmp    801b49 <vprintfmt+0x3a6>
  8019e2:	89 cf                	mov    %ecx,%edi
  8019e4:	eb ed                	jmp    8019d3 <vprintfmt+0x230>
	if (lflag >= 2)
  8019e6:	83 f9 01             	cmp    $0x1,%ecx
  8019e9:	7f 1b                	jg     801a06 <vprintfmt+0x263>
	else if (lflag)
  8019eb:	85 c9                	test   %ecx,%ecx
  8019ed:	74 63                	je     801a52 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019f7:	99                   	cltd   
  8019f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8019fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019fe:	8d 40 04             	lea    0x4(%eax),%eax
  801a01:	89 45 14             	mov    %eax,0x14(%ebp)
  801a04:	eb 17                	jmp    801a1d <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a06:	8b 45 14             	mov    0x14(%ebp),%eax
  801a09:	8b 50 04             	mov    0x4(%eax),%edx
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a11:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a14:	8b 45 14             	mov    0x14(%ebp),%eax
  801a17:	8d 40 08             	lea    0x8(%eax),%eax
  801a1a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a1d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a20:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a23:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a28:	85 c9                	test   %ecx,%ecx
  801a2a:	0f 89 ff 00 00 00    	jns    801b2f <vprintfmt+0x38c>
				putch('-', putdat);
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	53                   	push   %ebx
  801a34:	6a 2d                	push   $0x2d
  801a36:	ff d6                	call   *%esi
				num = -(long long) num;
  801a38:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a3b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a3e:	f7 da                	neg    %edx
  801a40:	83 d1 00             	adc    $0x0,%ecx
  801a43:	f7 d9                	neg    %ecx
  801a45:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a48:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a4d:	e9 dd 00 00 00       	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a52:	8b 45 14             	mov    0x14(%ebp),%eax
  801a55:	8b 00                	mov    (%eax),%eax
  801a57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a5a:	99                   	cltd   
  801a5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a61:	8d 40 04             	lea    0x4(%eax),%eax
  801a64:	89 45 14             	mov    %eax,0x14(%ebp)
  801a67:	eb b4                	jmp    801a1d <vprintfmt+0x27a>
	if (lflag >= 2)
  801a69:	83 f9 01             	cmp    $0x1,%ecx
  801a6c:	7f 1e                	jg     801a8c <vprintfmt+0x2e9>
	else if (lflag)
  801a6e:	85 c9                	test   %ecx,%ecx
  801a70:	74 32                	je     801aa4 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a72:	8b 45 14             	mov    0x14(%ebp),%eax
  801a75:	8b 10                	mov    (%eax),%edx
  801a77:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a7c:	8d 40 04             	lea    0x4(%eax),%eax
  801a7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a82:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a87:	e9 a3 00 00 00       	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8f:	8b 10                	mov    (%eax),%edx
  801a91:	8b 48 04             	mov    0x4(%eax),%ecx
  801a94:	8d 40 08             	lea    0x8(%eax),%eax
  801a97:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a9a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801a9f:	e9 8b 00 00 00       	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa7:	8b 10                	mov    (%eax),%edx
  801aa9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aae:	8d 40 04             	lea    0x4(%eax),%eax
  801ab1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ab4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801ab9:	eb 74                	jmp    801b2f <vprintfmt+0x38c>
	if (lflag >= 2)
  801abb:	83 f9 01             	cmp    $0x1,%ecx
  801abe:	7f 1b                	jg     801adb <vprintfmt+0x338>
	else if (lflag)
  801ac0:	85 c9                	test   %ecx,%ecx
  801ac2:	74 2c                	je     801af0 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac7:	8b 10                	mov    (%eax),%edx
  801ac9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ace:	8d 40 04             	lea    0x4(%eax),%eax
  801ad1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ad4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801ad9:	eb 54                	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	8b 10                	mov    (%eax),%edx
  801ae0:	8b 48 04             	mov    0x4(%eax),%ecx
  801ae3:	8d 40 08             	lea    0x8(%eax),%eax
  801ae6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801ae9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801aee:	eb 3f                	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801af0:	8b 45 14             	mov    0x14(%ebp),%eax
  801af3:	8b 10                	mov    (%eax),%edx
  801af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801afa:	8d 40 04             	lea    0x4(%eax),%eax
  801afd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b00:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b05:	eb 28                	jmp    801b2f <vprintfmt+0x38c>
			putch('0', putdat);
  801b07:	83 ec 08             	sub    $0x8,%esp
  801b0a:	53                   	push   %ebx
  801b0b:	6a 30                	push   $0x30
  801b0d:	ff d6                	call   *%esi
			putch('x', putdat);
  801b0f:	83 c4 08             	add    $0x8,%esp
  801b12:	53                   	push   %ebx
  801b13:	6a 78                	push   $0x78
  801b15:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	8b 10                	mov    (%eax),%edx
  801b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b21:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b24:	8d 40 04             	lea    0x4(%eax),%eax
  801b27:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b2a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b36:	57                   	push   %edi
  801b37:	ff 75 e0             	pushl  -0x20(%ebp)
  801b3a:	50                   	push   %eax
  801b3b:	51                   	push   %ecx
  801b3c:	52                   	push   %edx
  801b3d:	89 da                	mov    %ebx,%edx
  801b3f:	89 f0                	mov    %esi,%eax
  801b41:	e8 72 fb ff ff       	call   8016b8 <printnum>
			break;
  801b46:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b49:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b4c:	83 c7 01             	add    $0x1,%edi
  801b4f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b53:	83 f8 25             	cmp    $0x25,%eax
  801b56:	0f 84 62 fc ff ff    	je     8017be <vprintfmt+0x1b>
			if (ch == '\0')
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	0f 84 8b 00 00 00    	je     801bef <vprintfmt+0x44c>
			putch(ch, putdat);
  801b64:	83 ec 08             	sub    $0x8,%esp
  801b67:	53                   	push   %ebx
  801b68:	50                   	push   %eax
  801b69:	ff d6                	call   *%esi
  801b6b:	83 c4 10             	add    $0x10,%esp
  801b6e:	eb dc                	jmp    801b4c <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b70:	83 f9 01             	cmp    $0x1,%ecx
  801b73:	7f 1b                	jg     801b90 <vprintfmt+0x3ed>
	else if (lflag)
  801b75:	85 c9                	test   %ecx,%ecx
  801b77:	74 2c                	je     801ba5 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b79:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7c:	8b 10                	mov    (%eax),%edx
  801b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b83:	8d 40 04             	lea    0x4(%eax),%eax
  801b86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b89:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b8e:	eb 9f                	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b90:	8b 45 14             	mov    0x14(%ebp),%eax
  801b93:	8b 10                	mov    (%eax),%edx
  801b95:	8b 48 04             	mov    0x4(%eax),%ecx
  801b98:	8d 40 08             	lea    0x8(%eax),%eax
  801b9b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b9e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801ba3:	eb 8a                	jmp    801b2f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba8:	8b 10                	mov    (%eax),%edx
  801baa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801baf:	8d 40 04             	lea    0x4(%eax),%eax
  801bb2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bb5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bba:	e9 70 ff ff ff       	jmp    801b2f <vprintfmt+0x38c>
			putch(ch, putdat);
  801bbf:	83 ec 08             	sub    $0x8,%esp
  801bc2:	53                   	push   %ebx
  801bc3:	6a 25                	push   $0x25
  801bc5:	ff d6                	call   *%esi
			break;
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	e9 7a ff ff ff       	jmp    801b49 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bcf:	83 ec 08             	sub    $0x8,%esp
  801bd2:	53                   	push   %ebx
  801bd3:	6a 25                	push   $0x25
  801bd5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	89 f8                	mov    %edi,%eax
  801bdc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801be0:	74 05                	je     801be7 <vprintfmt+0x444>
  801be2:	83 e8 01             	sub    $0x1,%eax
  801be5:	eb f5                	jmp    801bdc <vprintfmt+0x439>
  801be7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bea:	e9 5a ff ff ff       	jmp    801b49 <vprintfmt+0x3a6>
}
  801bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    

00801bf7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bf7:	f3 0f 1e fb          	endbr32 
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 18             	sub    $0x18,%esp
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c0a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c0e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	74 26                	je     801c42 <vsnprintf+0x4b>
  801c1c:	85 d2                	test   %edx,%edx
  801c1e:	7e 22                	jle    801c42 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c20:	ff 75 14             	pushl  0x14(%ebp)
  801c23:	ff 75 10             	pushl  0x10(%ebp)
  801c26:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c29:	50                   	push   %eax
  801c2a:	68 61 17 80 00       	push   $0x801761
  801c2f:	e8 6f fb ff ff       	call   8017a3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3d:	83 c4 10             	add    $0x10,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    
		return -E_INVAL;
  801c42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c47:	eb f7                	jmp    801c40 <vsnprintf+0x49>

00801c49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c53:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c56:	50                   	push   %eax
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	ff 75 08             	pushl  0x8(%ebp)
  801c60:	e8 92 ff ff ff       	call   801bf7 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c67:	f3 0f 1e fb          	endbr32 
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
  801c76:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c7a:	74 05                	je     801c81 <strlen+0x1a>
		n++;
  801c7c:	83 c0 01             	add    $0x1,%eax
  801c7f:	eb f5                	jmp    801c76 <strlen+0xf>
	return n;
}
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c83:	f3 0f 1e fb          	endbr32 
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
  801c95:	39 d0                	cmp    %edx,%eax
  801c97:	74 0d                	je     801ca6 <strnlen+0x23>
  801c99:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801c9d:	74 05                	je     801ca4 <strnlen+0x21>
		n++;
  801c9f:	83 c0 01             	add    $0x1,%eax
  801ca2:	eb f1                	jmp    801c95 <strnlen+0x12>
  801ca4:	89 c2                	mov    %eax,%edx
	return n;
}
  801ca6:	89 d0                	mov    %edx,%eax
  801ca8:	5d                   	pop    %ebp
  801ca9:	c3                   	ret    

00801caa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801caa:	f3 0f 1e fb          	endbr32 
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	53                   	push   %ebx
  801cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbd:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cc1:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cc4:	83 c0 01             	add    $0x1,%eax
  801cc7:	84 d2                	test   %dl,%dl
  801cc9:	75 f2                	jne    801cbd <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801ccb:	89 c8                	mov    %ecx,%eax
  801ccd:	5b                   	pop    %ebx
  801cce:	5d                   	pop    %ebp
  801ccf:	c3                   	ret    

00801cd0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cd0:	f3 0f 1e fb          	endbr32 
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 10             	sub    $0x10,%esp
  801cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801cde:	53                   	push   %ebx
  801cdf:	e8 83 ff ff ff       	call   801c67 <strlen>
  801ce4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	01 d8                	add    %ebx,%eax
  801cec:	50                   	push   %eax
  801ced:	e8 b8 ff ff ff       	call   801caa <strcpy>
	return dst;
}
  801cf2:	89 d8                	mov    %ebx,%eax
  801cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801cf9:	f3 0f 1e fb          	endbr32 
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
  801d02:	8b 75 08             	mov    0x8(%ebp),%esi
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	89 f3                	mov    %esi,%ebx
  801d0a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d0d:	89 f0                	mov    %esi,%eax
  801d0f:	39 d8                	cmp    %ebx,%eax
  801d11:	74 11                	je     801d24 <strncpy+0x2b>
		*dst++ = *src;
  801d13:	83 c0 01             	add    $0x1,%eax
  801d16:	0f b6 0a             	movzbl (%edx),%ecx
  801d19:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d1c:	80 f9 01             	cmp    $0x1,%cl
  801d1f:	83 da ff             	sbb    $0xffffffff,%edx
  801d22:	eb eb                	jmp    801d0f <strncpy+0x16>
	}
	return ret;
}
  801d24:	89 f0                	mov    %esi,%eax
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d2a:	f3 0f 1e fb          	endbr32 
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	8b 75 08             	mov    0x8(%ebp),%esi
  801d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d39:	8b 55 10             	mov    0x10(%ebp),%edx
  801d3c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d3e:	85 d2                	test   %edx,%edx
  801d40:	74 21                	je     801d63 <strlcpy+0x39>
  801d42:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d46:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d48:	39 c2                	cmp    %eax,%edx
  801d4a:	74 14                	je     801d60 <strlcpy+0x36>
  801d4c:	0f b6 19             	movzbl (%ecx),%ebx
  801d4f:	84 db                	test   %bl,%bl
  801d51:	74 0b                	je     801d5e <strlcpy+0x34>
			*dst++ = *src++;
  801d53:	83 c1 01             	add    $0x1,%ecx
  801d56:	83 c2 01             	add    $0x1,%edx
  801d59:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d5c:	eb ea                	jmp    801d48 <strlcpy+0x1e>
  801d5e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d60:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d63:	29 f0                	sub    %esi,%eax
}
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5d                   	pop    %ebp
  801d68:	c3                   	ret    

00801d69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d69:	f3 0f 1e fb          	endbr32 
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d76:	0f b6 01             	movzbl (%ecx),%eax
  801d79:	84 c0                	test   %al,%al
  801d7b:	74 0c                	je     801d89 <strcmp+0x20>
  801d7d:	3a 02                	cmp    (%edx),%al
  801d7f:	75 08                	jne    801d89 <strcmp+0x20>
		p++, q++;
  801d81:	83 c1 01             	add    $0x1,%ecx
  801d84:	83 c2 01             	add    $0x1,%edx
  801d87:	eb ed                	jmp    801d76 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d89:	0f b6 c0             	movzbl %al,%eax
  801d8c:	0f b6 12             	movzbl (%edx),%edx
  801d8f:	29 d0                	sub    %edx,%eax
}
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d93:	f3 0f 1e fb          	endbr32 
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	53                   	push   %ebx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801da6:	eb 06                	jmp    801dae <strncmp+0x1b>
		n--, p++, q++;
  801da8:	83 c0 01             	add    $0x1,%eax
  801dab:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801dae:	39 d8                	cmp    %ebx,%eax
  801db0:	74 16                	je     801dc8 <strncmp+0x35>
  801db2:	0f b6 08             	movzbl (%eax),%ecx
  801db5:	84 c9                	test   %cl,%cl
  801db7:	74 04                	je     801dbd <strncmp+0x2a>
  801db9:	3a 0a                	cmp    (%edx),%cl
  801dbb:	74 eb                	je     801da8 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dbd:	0f b6 00             	movzbl (%eax),%eax
  801dc0:	0f b6 12             	movzbl (%edx),%edx
  801dc3:	29 d0                	sub    %edx,%eax
}
  801dc5:	5b                   	pop    %ebx
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    
		return 0;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	eb f6                	jmp    801dc5 <strncmp+0x32>

00801dcf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dcf:	f3 0f 1e fb          	endbr32 
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801ddd:	0f b6 10             	movzbl (%eax),%edx
  801de0:	84 d2                	test   %dl,%dl
  801de2:	74 09                	je     801ded <strchr+0x1e>
		if (*s == c)
  801de4:	38 ca                	cmp    %cl,%dl
  801de6:	74 0a                	je     801df2 <strchr+0x23>
	for (; *s; s++)
  801de8:	83 c0 01             	add    $0x1,%eax
  801deb:	eb f0                	jmp    801ddd <strchr+0xe>
			return (char *) s;
	return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801df4:	f3 0f 1e fb          	endbr32 
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e02:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e05:	38 ca                	cmp    %cl,%dl
  801e07:	74 09                	je     801e12 <strfind+0x1e>
  801e09:	84 d2                	test   %dl,%dl
  801e0b:	74 05                	je     801e12 <strfind+0x1e>
	for (; *s; s++)
  801e0d:	83 c0 01             	add    $0x1,%eax
  801e10:	eb f0                	jmp    801e02 <strfind+0xe>
			break;
	return (char *) s;
}
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    

00801e14 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e14:	f3 0f 1e fb          	endbr32 
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	57                   	push   %edi
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e24:	85 c9                	test   %ecx,%ecx
  801e26:	74 31                	je     801e59 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e28:	89 f8                	mov    %edi,%eax
  801e2a:	09 c8                	or     %ecx,%eax
  801e2c:	a8 03                	test   $0x3,%al
  801e2e:	75 23                	jne    801e53 <memset+0x3f>
		c &= 0xFF;
  801e30:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e34:	89 d3                	mov    %edx,%ebx
  801e36:	c1 e3 08             	shl    $0x8,%ebx
  801e39:	89 d0                	mov    %edx,%eax
  801e3b:	c1 e0 18             	shl    $0x18,%eax
  801e3e:	89 d6                	mov    %edx,%esi
  801e40:	c1 e6 10             	shl    $0x10,%esi
  801e43:	09 f0                	or     %esi,%eax
  801e45:	09 c2                	or     %eax,%edx
  801e47:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e49:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e4c:	89 d0                	mov    %edx,%eax
  801e4e:	fc                   	cld    
  801e4f:	f3 ab                	rep stos %eax,%es:(%edi)
  801e51:	eb 06                	jmp    801e59 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e56:	fc                   	cld    
  801e57:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e59:	89 f8                	mov    %edi,%eax
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5f                   	pop    %edi
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    

00801e60 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e60:	f3 0f 1e fb          	endbr32 
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	57                   	push   %edi
  801e68:	56                   	push   %esi
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e72:	39 c6                	cmp    %eax,%esi
  801e74:	73 32                	jae    801ea8 <memmove+0x48>
  801e76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e79:	39 c2                	cmp    %eax,%edx
  801e7b:	76 2b                	jbe    801ea8 <memmove+0x48>
		s += n;
		d += n;
  801e7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e80:	89 fe                	mov    %edi,%esi
  801e82:	09 ce                	or     %ecx,%esi
  801e84:	09 d6                	or     %edx,%esi
  801e86:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e8c:	75 0e                	jne    801e9c <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e8e:	83 ef 04             	sub    $0x4,%edi
  801e91:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e97:	fd                   	std    
  801e98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801e9a:	eb 09                	jmp    801ea5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801e9c:	83 ef 01             	sub    $0x1,%edi
  801e9f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801ea2:	fd                   	std    
  801ea3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ea5:	fc                   	cld    
  801ea6:	eb 1a                	jmp    801ec2 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801ea8:	89 c2                	mov    %eax,%edx
  801eaa:	09 ca                	or     %ecx,%edx
  801eac:	09 f2                	or     %esi,%edx
  801eae:	f6 c2 03             	test   $0x3,%dl
  801eb1:	75 0a                	jne    801ebd <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801eb3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801eb6:	89 c7                	mov    %eax,%edi
  801eb8:	fc                   	cld    
  801eb9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ebb:	eb 05                	jmp    801ec2 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801ebd:	89 c7                	mov    %eax,%edi
  801ebf:	fc                   	cld    
  801ec0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ec6:	f3 0f 1e fb          	endbr32 
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ed0:	ff 75 10             	pushl  0x10(%ebp)
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	ff 75 08             	pushl  0x8(%ebp)
  801ed9:	e8 82 ff ff ff       	call   801e60 <memmove>
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ee0:	f3 0f 1e fb          	endbr32 
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	56                   	push   %esi
  801ee8:	53                   	push   %ebx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	89 c6                	mov    %eax,%esi
  801ef1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801ef4:	39 f0                	cmp    %esi,%eax
  801ef6:	74 1c                	je     801f14 <memcmp+0x34>
		if (*s1 != *s2)
  801ef8:	0f b6 08             	movzbl (%eax),%ecx
  801efb:	0f b6 1a             	movzbl (%edx),%ebx
  801efe:	38 d9                	cmp    %bl,%cl
  801f00:	75 08                	jne    801f0a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f02:	83 c0 01             	add    $0x1,%eax
  801f05:	83 c2 01             	add    $0x1,%edx
  801f08:	eb ea                	jmp    801ef4 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f0a:	0f b6 c1             	movzbl %cl,%eax
  801f0d:	0f b6 db             	movzbl %bl,%ebx
  801f10:	29 d8                	sub    %ebx,%eax
  801f12:	eb 05                	jmp    801f19 <memcmp+0x39>
	}

	return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	5b                   	pop    %ebx
  801f1a:	5e                   	pop    %esi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    

00801f1d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f1d:	f3 0f 1e fb          	endbr32 
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f2a:	89 c2                	mov    %eax,%edx
  801f2c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f2f:	39 d0                	cmp    %edx,%eax
  801f31:	73 09                	jae    801f3c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f33:	38 08                	cmp    %cl,(%eax)
  801f35:	74 05                	je     801f3c <memfind+0x1f>
	for (; s < ends; s++)
  801f37:	83 c0 01             	add    $0x1,%eax
  801f3a:	eb f3                	jmp    801f2f <memfind+0x12>
			break;
	return (void *) s;
}
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f3e:	f3 0f 1e fb          	endbr32 
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f4e:	eb 03                	jmp    801f53 <strtol+0x15>
		s++;
  801f50:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f53:	0f b6 01             	movzbl (%ecx),%eax
  801f56:	3c 20                	cmp    $0x20,%al
  801f58:	74 f6                	je     801f50 <strtol+0x12>
  801f5a:	3c 09                	cmp    $0x9,%al
  801f5c:	74 f2                	je     801f50 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f5e:	3c 2b                	cmp    $0x2b,%al
  801f60:	74 2a                	je     801f8c <strtol+0x4e>
	int neg = 0;
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f67:	3c 2d                	cmp    $0x2d,%al
  801f69:	74 2b                	je     801f96 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f6b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f71:	75 0f                	jne    801f82 <strtol+0x44>
  801f73:	80 39 30             	cmpb   $0x30,(%ecx)
  801f76:	74 28                	je     801fa0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f78:	85 db                	test   %ebx,%ebx
  801f7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f7f:	0f 44 d8             	cmove  %eax,%ebx
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
  801f87:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f8a:	eb 46                	jmp    801fd2 <strtol+0x94>
		s++;
  801f8c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f8f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f94:	eb d5                	jmp    801f6b <strtol+0x2d>
		s++, neg = 1;
  801f96:	83 c1 01             	add    $0x1,%ecx
  801f99:	bf 01 00 00 00       	mov    $0x1,%edi
  801f9e:	eb cb                	jmp    801f6b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fa0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801fa4:	74 0e                	je     801fb4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801fa6:	85 db                	test   %ebx,%ebx
  801fa8:	75 d8                	jne    801f82 <strtol+0x44>
		s++, base = 8;
  801faa:	83 c1 01             	add    $0x1,%ecx
  801fad:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fb2:	eb ce                	jmp    801f82 <strtol+0x44>
		s += 2, base = 16;
  801fb4:	83 c1 02             	add    $0x2,%ecx
  801fb7:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fbc:	eb c4                	jmp    801f82 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fbe:	0f be d2             	movsbl %dl,%edx
  801fc1:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fc4:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fc7:	7d 3a                	jge    802003 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fc9:	83 c1 01             	add    $0x1,%ecx
  801fcc:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fd0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fd2:	0f b6 11             	movzbl (%ecx),%edx
  801fd5:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fd8:	89 f3                	mov    %esi,%ebx
  801fda:	80 fb 09             	cmp    $0x9,%bl
  801fdd:	76 df                	jbe    801fbe <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fdf:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fe2:	89 f3                	mov    %esi,%ebx
  801fe4:	80 fb 19             	cmp    $0x19,%bl
  801fe7:	77 08                	ja     801ff1 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801fe9:	0f be d2             	movsbl %dl,%edx
  801fec:	83 ea 57             	sub    $0x57,%edx
  801fef:	eb d3                	jmp    801fc4 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801ff1:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ff4:	89 f3                	mov    %esi,%ebx
  801ff6:	80 fb 19             	cmp    $0x19,%bl
  801ff9:	77 08                	ja     802003 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801ffb:	0f be d2             	movsbl %dl,%edx
  801ffe:	83 ea 37             	sub    $0x37,%edx
  802001:	eb c1                	jmp    801fc4 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802003:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802007:	74 05                	je     80200e <strtol+0xd0>
		*endptr = (char *) s;
  802009:	8b 75 0c             	mov    0xc(%ebp),%esi
  80200c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80200e:	89 c2                	mov    %eax,%edx
  802010:	f7 da                	neg    %edx
  802012:	85 ff                	test   %edi,%edi
  802014:	0f 45 c2             	cmovne %edx,%eax
}
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80201c:	f3 0f 1e fb          	endbr32 
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	56                   	push   %esi
  802024:	53                   	push   %ebx
  802025:	8b 75 08             	mov    0x8(%ebp),%esi
  802028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80202e:	83 e8 01             	sub    $0x1,%eax
  802031:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802036:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80203b:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	50                   	push   %eax
  802043:	e8 07 e3 ff ff       	call   80034f <sys_ipc_recv>
	if (!t) {
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	85 c0                	test   %eax,%eax
  80204d:	75 2b                	jne    80207a <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80204f:	85 f6                	test   %esi,%esi
  802051:	74 0a                	je     80205d <ipc_recv+0x41>
  802053:	a1 08 40 80 00       	mov    0x804008,%eax
  802058:	8b 40 74             	mov    0x74(%eax),%eax
  80205b:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80205d:	85 db                	test   %ebx,%ebx
  80205f:	74 0a                	je     80206b <ipc_recv+0x4f>
  802061:	a1 08 40 80 00       	mov    0x804008,%eax
  802066:	8b 40 78             	mov    0x78(%eax),%eax
  802069:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80206b:	a1 08 40 80 00       	mov    0x804008,%eax
  802070:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802073:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802076:	5b                   	pop    %ebx
  802077:	5e                   	pop    %esi
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80207a:	85 f6                	test   %esi,%esi
  80207c:	74 06                	je     802084 <ipc_recv+0x68>
  80207e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802084:	85 db                	test   %ebx,%ebx
  802086:	74 eb                	je     802073 <ipc_recv+0x57>
  802088:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80208e:	eb e3                	jmp    802073 <ipc_recv+0x57>

00802090 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802090:	f3 0f 1e fb          	endbr32 
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	57                   	push   %edi
  802098:	56                   	push   %esi
  802099:	53                   	push   %ebx
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020a6:	85 db                	test   %ebx,%ebx
  8020a8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020ad:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020b0:	ff 75 14             	pushl  0x14(%ebp)
  8020b3:	53                   	push   %ebx
  8020b4:	56                   	push   %esi
  8020b5:	57                   	push   %edi
  8020b6:	e8 6d e2 ff ff       	call   800328 <sys_ipc_try_send>
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	74 1e                	je     8020e0 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020c5:	75 07                	jne    8020ce <ipc_send+0x3e>
		sys_yield();
  8020c7:	e8 94 e0 ff ff       	call   800160 <sys_yield>
  8020cc:	eb e2                	jmp    8020b0 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020ce:	50                   	push   %eax
  8020cf:	68 5f 28 80 00       	push   $0x80285f
  8020d4:	6a 39                	push   $0x39
  8020d6:	68 71 28 80 00       	push   $0x802871
  8020db:	e8 d9 f4 ff ff       	call   8015b9 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5f                   	pop    %edi
  8020e6:	5d                   	pop    %ebp
  8020e7:	c3                   	ret    

008020e8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020e8:	f3 0f 1e fb          	endbr32 
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020f7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020fa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802100:	8b 52 50             	mov    0x50(%edx),%edx
  802103:	39 ca                	cmp    %ecx,%edx
  802105:	74 11                	je     802118 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802107:	83 c0 01             	add    $0x1,%eax
  80210a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80210f:	75 e6                	jne    8020f7 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	eb 0b                	jmp    802123 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80211b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802120:	8b 40 48             	mov    0x48(%eax),%eax
}
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802125:	f3 0f 1e fb          	endbr32 
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80212f:	89 c2                	mov    %eax,%edx
  802131:	c1 ea 16             	shr    $0x16,%edx
  802134:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80213b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802140:	f6 c1 01             	test   $0x1,%cl
  802143:	74 1c                	je     802161 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802145:	c1 e8 0c             	shr    $0xc,%eax
  802148:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80214f:	a8 01                	test   $0x1,%al
  802151:	74 0e                	je     802161 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802153:	c1 e8 0c             	shr    $0xc,%eax
  802156:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80215d:	ef 
  80215e:	0f b7 d2             	movzwl %dx,%edx
}
  802161:	89 d0                	mov    %edx,%eax
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	66 90                	xchg   %ax,%ax
  802167:	66 90                	xchg   %ax,%ax
  802169:	66 90                	xchg   %ax,%ax
  80216b:	66 90                	xchg   %ax,%ax
  80216d:	66 90                	xchg   %ax,%ax
  80216f:	90                   	nop

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
