
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 21 00 00 00       	call   800052 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_cputs(hello, 1024*1024);
  80003d:	68 00 00 10 00       	push   $0x100000
  800042:	ff 35 00 30 80 00    	pushl  0x803000
  800048:	e8 6d 00 00 00       	call   8000ba <sys_cputs>
}
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	c9                   	leave  
  800051:	c3                   	ret    

00800052 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800052:	f3 0f 1e fb          	endbr32 
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800061:	e8 de 00 00 00       	call   800144 <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	e8 a6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008d:	e8 0a 00 00 00       	call   80009c <exit>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	f3 0f 1e fb          	endbr32 
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 07 05 00 00       	call   8005b2 <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 4a 00 00 00       	call   8000ff <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ba:	f3 0f 1e fb          	endbr32 
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	57                   	push   %edi
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000cf:	89 c3                	mov    %eax,%ebx
  8000d1:	89 c7                	mov    %eax,%edi
  8000d3:	89 c6                	mov    %eax,%esi
  8000d5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000dc:	f3 0f 1e fb          	endbr32 
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f0:	89 d1                	mov    %edx,%ecx
  8000f2:	89 d3                	mov    %edx,%ebx
  8000f4:	89 d7                	mov    %edx,%edi
  8000f6:	89 d6                	mov    %edx,%esi
  8000f8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ff:	f3 0f 1e fb          	endbr32 
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	57                   	push   %edi
  800107:	56                   	push   %esi
  800108:	53                   	push   %ebx
  800109:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80010c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800111:	8b 55 08             	mov    0x8(%ebp),%edx
  800114:	b8 03 00 00 00       	mov    $0x3,%eax
  800119:	89 cb                	mov    %ecx,%ebx
  80011b:	89 cf                	mov    %ecx,%edi
  80011d:	89 ce                	mov    %ecx,%esi
  80011f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	7f 08                	jg     80012d <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800125:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	6a 03                	push   $0x3
  800133:	68 f8 23 80 00       	push   $0x8023f8
  800138:	6a 23                	push   $0x23
  80013a:	68 15 24 80 00       	push   $0x802415
  80013f:	e8 7c 14 00 00       	call   8015c0 <_panic>

00800144 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800144:	f3 0f 1e fb          	endbr32 
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	57                   	push   %edi
  80014c:	56                   	push   %esi
  80014d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014e:	ba 00 00 00 00       	mov    $0x0,%edx
  800153:	b8 02 00 00 00       	mov    $0x2,%eax
  800158:	89 d1                	mov    %edx,%ecx
  80015a:	89 d3                	mov    %edx,%ebx
  80015c:	89 d7                	mov    %edx,%edi
  80015e:	89 d6                	mov    %edx,%esi
  800160:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800162:	5b                   	pop    %ebx
  800163:	5e                   	pop    %esi
  800164:	5f                   	pop    %edi
  800165:	5d                   	pop    %ebp
  800166:	c3                   	ret    

00800167 <sys_yield>:

void
sys_yield(void)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	57                   	push   %edi
  80016f:	56                   	push   %esi
  800170:	53                   	push   %ebx
	asm volatile("int %1\n"
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	b8 0b 00 00 00       	mov    $0xb,%eax
  80017b:	89 d1                	mov    %edx,%ecx
  80017d:	89 d3                	mov    %edx,%ebx
  80017f:	89 d7                	mov    %edx,%edi
  800181:	89 d6                	mov    %edx,%esi
  800183:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800185:	5b                   	pop    %ebx
  800186:	5e                   	pop    %esi
  800187:	5f                   	pop    %edi
  800188:	5d                   	pop    %ebp
  800189:	c3                   	ret    

0080018a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80018a:	f3 0f 1e fb          	endbr32 
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
  800194:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800197:	be 00 00 00 00       	mov    $0x0,%esi
  80019c:	8b 55 08             	mov    0x8(%ebp),%edx
  80019f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001aa:	89 f7                	mov    %esi,%edi
  8001ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	7f 08                	jg     8001ba <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b5:	5b                   	pop    %ebx
  8001b6:	5e                   	pop    %esi
  8001b7:	5f                   	pop    %edi
  8001b8:	5d                   	pop    %ebp
  8001b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	6a 04                	push   $0x4
  8001c0:	68 f8 23 80 00       	push   $0x8023f8
  8001c5:	6a 23                	push   $0x23
  8001c7:	68 15 24 80 00       	push   $0x802415
  8001cc:	e8 ef 13 00 00       	call   8015c0 <_panic>

008001d1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d1:	f3 0f 1e fb          	endbr32 
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	57                   	push   %edi
  8001d9:	56                   	push   %esi
  8001da:	53                   	push   %ebx
  8001db:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001de:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	7f 08                	jg     800200 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fb:	5b                   	pop    %ebx
  8001fc:	5e                   	pop    %esi
  8001fd:	5f                   	pop    %edi
  8001fe:	5d                   	pop    %ebp
  8001ff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800200:	83 ec 0c             	sub    $0xc,%esp
  800203:	50                   	push   %eax
  800204:	6a 05                	push   $0x5
  800206:	68 f8 23 80 00       	push   $0x8023f8
  80020b:	6a 23                	push   $0x23
  80020d:	68 15 24 80 00       	push   $0x802415
  800212:	e8 a9 13 00 00       	call   8015c0 <_panic>

00800217 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800217:	f3 0f 1e fb          	endbr32 
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	57                   	push   %edi
  80021f:	56                   	push   %esi
  800220:	53                   	push   %ebx
  800221:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800224:	bb 00 00 00 00       	mov    $0x0,%ebx
  800229:	8b 55 08             	mov    0x8(%ebp),%edx
  80022c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80022f:	b8 06 00 00 00       	mov    $0x6,%eax
  800234:	89 df                	mov    %ebx,%edi
  800236:	89 de                	mov    %ebx,%esi
  800238:	cd 30                	int    $0x30
	if(check && ret > 0)
  80023a:	85 c0                	test   %eax,%eax
  80023c:	7f 08                	jg     800246 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80023e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800241:	5b                   	pop    %ebx
  800242:	5e                   	pop    %esi
  800243:	5f                   	pop    %edi
  800244:	5d                   	pop    %ebp
  800245:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	50                   	push   %eax
  80024a:	6a 06                	push   $0x6
  80024c:	68 f8 23 80 00       	push   $0x8023f8
  800251:	6a 23                	push   $0x23
  800253:	68 15 24 80 00       	push   $0x802415
  800258:	e8 63 13 00 00       	call   8015c0 <_panic>

0080025d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80025d:	f3 0f 1e fb          	endbr32 
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026f:	8b 55 08             	mov    0x8(%ebp),%edx
  800272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800275:	b8 08 00 00 00       	mov    $0x8,%eax
  80027a:	89 df                	mov    %ebx,%edi
  80027c:	89 de                	mov    %ebx,%esi
  80027e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800280:	85 c0                	test   %eax,%eax
  800282:	7f 08                	jg     80028c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800287:	5b                   	pop    %ebx
  800288:	5e                   	pop    %esi
  800289:	5f                   	pop    %edi
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	6a 08                	push   $0x8
  800292:	68 f8 23 80 00       	push   $0x8023f8
  800297:	6a 23                	push   $0x23
  800299:	68 15 24 80 00       	push   $0x802415
  80029e:	e8 1d 13 00 00       	call   8015c0 <_panic>

008002a3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a3:	f3 0f 1e fb          	endbr32 
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bb:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c0:	89 df                	mov    %ebx,%edi
  8002c2:	89 de                	mov    %ebx,%esi
  8002c4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c6:	85 c0                	test   %eax,%eax
  8002c8:	7f 08                	jg     8002d2 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d2:	83 ec 0c             	sub    $0xc,%esp
  8002d5:	50                   	push   %eax
  8002d6:	6a 09                	push   $0x9
  8002d8:	68 f8 23 80 00       	push   $0x8023f8
  8002dd:	6a 23                	push   $0x23
  8002df:	68 15 24 80 00       	push   $0x802415
  8002e4:	e8 d7 12 00 00       	call   8015c0 <_panic>

008002e9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e9:	f3 0f 1e fb          	endbr32 
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	b8 0a 00 00 00       	mov    $0xa,%eax
  800306:	89 df                	mov    %ebx,%edi
  800308:	89 de                	mov    %ebx,%esi
  80030a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030c:	85 c0                	test   %eax,%eax
  80030e:	7f 08                	jg     800318 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	6a 0a                	push   $0xa
  80031e:	68 f8 23 80 00       	push   $0x8023f8
  800323:	6a 23                	push   $0x23
  800325:	68 15 24 80 00       	push   $0x802415
  80032a:	e8 91 12 00 00       	call   8015c0 <_panic>

0080032f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80032f:	f3 0f 1e fb          	endbr32 
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	57                   	push   %edi
  800337:	56                   	push   %esi
  800338:	53                   	push   %ebx
	asm volatile("int %1\n"
  800339:	8b 55 08             	mov    0x8(%ebp),%edx
  80033c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800344:	be 00 00 00 00       	mov    $0x0,%esi
  800349:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800351:	5b                   	pop    %ebx
  800352:	5e                   	pop    %esi
  800353:	5f                   	pop    %edi
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800356:	f3 0f 1e fb          	endbr32 
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	57                   	push   %edi
  80035e:	56                   	push   %esi
  80035f:	53                   	push   %ebx
  800360:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800363:	b9 00 00 00 00       	mov    $0x0,%ecx
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800370:	89 cb                	mov    %ecx,%ebx
  800372:	89 cf                	mov    %ecx,%edi
  800374:	89 ce                	mov    %ecx,%esi
  800376:	cd 30                	int    $0x30
	if(check && ret > 0)
  800378:	85 c0                	test   %eax,%eax
  80037a:	7f 08                	jg     800384 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	6a 0d                	push   $0xd
  80038a:	68 f8 23 80 00       	push   $0x8023f8
  80038f:	6a 23                	push   $0x23
  800391:	68 15 24 80 00       	push   $0x802415
  800396:	e8 25 12 00 00       	call   8015c0 <_panic>

0080039b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80039b:	f3 0f 1e fb          	endbr32 
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	57                   	push   %edi
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003af:	89 d1                	mov    %edx,%ecx
  8003b1:	89 d3                	mov    %edx,%ebx
  8003b3:	89 d7                	mov    %edx,%edi
  8003b5:	89 d6                	mov    %edx,%esi
  8003b7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003b9:	5b                   	pop    %ebx
  8003ba:	5e                   	pop    %esi
  8003bb:	5f                   	pop    %edi
  8003bc:	5d                   	pop    %ebp
  8003bd:	c3                   	ret    

008003be <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003be:	f3 0f 1e fb          	endbr32 
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	05 00 00 00 30       	add    $0x30000000,%eax
  8003cd:	c1 e8 0c             	shr    $0xc,%eax
}
  8003d0:	5d                   	pop    %ebp
  8003d1:	c3                   	ret    

008003d2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003d2:	f3 0f 1e fb          	endbr32 
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8003e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003e6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8003ed:	f3 0f 1e fb          	endbr32 
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8003f9:	89 c2                	mov    %eax,%edx
  8003fb:	c1 ea 16             	shr    $0x16,%edx
  8003fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800405:	f6 c2 01             	test   $0x1,%dl
  800408:	74 2d                	je     800437 <fd_alloc+0x4a>
  80040a:	89 c2                	mov    %eax,%edx
  80040c:	c1 ea 0c             	shr    $0xc,%edx
  80040f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800416:	f6 c2 01             	test   $0x1,%dl
  800419:	74 1c                	je     800437 <fd_alloc+0x4a>
  80041b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800420:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800425:	75 d2                	jne    8003f9 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800430:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800435:	eb 0a                	jmp    800441 <fd_alloc+0x54>
			*fd_store = fd;
  800437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80043c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800441:	5d                   	pop    %ebp
  800442:	c3                   	ret    

00800443 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800443:	f3 0f 1e fb          	endbr32 
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80044d:	83 f8 1f             	cmp    $0x1f,%eax
  800450:	77 30                	ja     800482 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800452:	c1 e0 0c             	shl    $0xc,%eax
  800455:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80045a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800460:	f6 c2 01             	test   $0x1,%dl
  800463:	74 24                	je     800489 <fd_lookup+0x46>
  800465:	89 c2                	mov    %eax,%edx
  800467:	c1 ea 0c             	shr    $0xc,%edx
  80046a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800471:	f6 c2 01             	test   $0x1,%dl
  800474:	74 1a                	je     800490 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800476:	8b 55 0c             	mov    0xc(%ebp),%edx
  800479:	89 02                	mov    %eax,(%edx)
	return 0;
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    
		return -E_INVAL;
  800482:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800487:	eb f7                	jmp    800480 <fd_lookup+0x3d>
		return -E_INVAL;
  800489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80048e:	eb f0                	jmp    800480 <fd_lookup+0x3d>
  800490:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800495:	eb e9                	jmp    800480 <fd_lookup+0x3d>

00800497 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800497:	f3 0f 1e fb          	endbr32 
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8004a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a9:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004ae:	39 08                	cmp    %ecx,(%eax)
  8004b0:	74 38                	je     8004ea <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004b2:	83 c2 01             	add    $0x1,%edx
  8004b5:	8b 04 95 a0 24 80 00 	mov    0x8024a0(,%edx,4),%eax
  8004bc:	85 c0                	test   %eax,%eax
  8004be:	75 ee                	jne    8004ae <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8004c5:	8b 40 48             	mov    0x48(%eax),%eax
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	51                   	push   %ecx
  8004cc:	50                   	push   %eax
  8004cd:	68 24 24 80 00       	push   $0x802424
  8004d2:	e8 d0 11 00 00       	call   8016a7 <cprintf>
	*dev = 0;
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    
			*dev = devtab[i];
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	eb f2                	jmp    8004e8 <dev_lookup+0x51>

008004f6 <fd_close>:
{
  8004f6:	f3 0f 1e fb          	endbr32 
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	57                   	push   %edi
  8004fe:	56                   	push   %esi
  8004ff:	53                   	push   %ebx
  800500:	83 ec 24             	sub    $0x24,%esp
  800503:	8b 75 08             	mov    0x8(%ebp),%esi
  800506:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800509:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80050c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80050d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800513:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800516:	50                   	push   %eax
  800517:	e8 27 ff ff ff       	call   800443 <fd_lookup>
  80051c:	89 c3                	mov    %eax,%ebx
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	85 c0                	test   %eax,%eax
  800523:	78 05                	js     80052a <fd_close+0x34>
	    || fd != fd2)
  800525:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800528:	74 16                	je     800540 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80052a:	89 f8                	mov    %edi,%eax
  80052c:	84 c0                	test   %al,%al
  80052e:	b8 00 00 00 00       	mov    $0x0,%eax
  800533:	0f 44 d8             	cmove  %eax,%ebx
}
  800536:	89 d8                	mov    %ebx,%eax
  800538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80053b:	5b                   	pop    %ebx
  80053c:	5e                   	pop    %esi
  80053d:	5f                   	pop    %edi
  80053e:	5d                   	pop    %ebp
  80053f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800546:	50                   	push   %eax
  800547:	ff 36                	pushl  (%esi)
  800549:	e8 49 ff ff ff       	call   800497 <dev_lookup>
  80054e:	89 c3                	mov    %eax,%ebx
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	85 c0                	test   %eax,%eax
  800555:	78 1a                	js     800571 <fd_close+0x7b>
		if (dev->dev_close)
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80055d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800562:	85 c0                	test   %eax,%eax
  800564:	74 0b                	je     800571 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	56                   	push   %esi
  80056a:	ff d0                	call   *%eax
  80056c:	89 c3                	mov    %eax,%ebx
  80056e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	56                   	push   %esi
  800575:	6a 00                	push   $0x0
  800577:	e8 9b fc ff ff       	call   800217 <sys_page_unmap>
	return r;
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	eb b5                	jmp    800536 <fd_close+0x40>

00800581 <close>:

int
close(int fdnum)
{
  800581:	f3 0f 1e fb          	endbr32 
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80058b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	e8 ac fe ff ff       	call   800443 <fd_lookup>
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	85 c0                	test   %eax,%eax
  80059c:	79 02                	jns    8005a0 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    
		return fd_close(fd, 1);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	6a 01                	push   $0x1
  8005a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a8:	e8 49 ff ff ff       	call   8004f6 <fd_close>
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	eb ec                	jmp    80059e <close+0x1d>

008005b2 <close_all>:

void
close_all(void)
{
  8005b2:	f3 0f 1e fb          	endbr32 
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	53                   	push   %ebx
  8005ba:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005c2:	83 ec 0c             	sub    $0xc,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	e8 b6 ff ff ff       	call   800581 <close>
	for (i = 0; i < MAXFD; i++)
  8005cb:	83 c3 01             	add    $0x1,%ebx
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	83 fb 20             	cmp    $0x20,%ebx
  8005d4:	75 ec                	jne    8005c2 <close_all+0x10>
}
  8005d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005d9:	c9                   	leave  
  8005da:	c3                   	ret    

008005db <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005db:	f3 0f 1e fb          	endbr32 
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	57                   	push   %edi
  8005e3:	56                   	push   %esi
  8005e4:	53                   	push   %ebx
  8005e5:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 08             	pushl  0x8(%ebp)
  8005ef:	e8 4f fe ff ff       	call   800443 <fd_lookup>
  8005f4:	89 c3                	mov    %eax,%ebx
  8005f6:	83 c4 10             	add    $0x10,%esp
  8005f9:	85 c0                	test   %eax,%eax
  8005fb:	0f 88 81 00 00 00    	js     800682 <dup+0xa7>
		return r;
	close(newfdnum);
  800601:	83 ec 0c             	sub    $0xc,%esp
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	e8 75 ff ff ff       	call   800581 <close>

	newfd = INDEX2FD(newfdnum);
  80060c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060f:	c1 e6 0c             	shl    $0xc,%esi
  800612:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800618:	83 c4 04             	add    $0x4,%esp
  80061b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80061e:	e8 af fd ff ff       	call   8003d2 <fd2data>
  800623:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800625:	89 34 24             	mov    %esi,(%esp)
  800628:	e8 a5 fd ff ff       	call   8003d2 <fd2data>
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800632:	89 d8                	mov    %ebx,%eax
  800634:	c1 e8 16             	shr    $0x16,%eax
  800637:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80063e:	a8 01                	test   $0x1,%al
  800640:	74 11                	je     800653 <dup+0x78>
  800642:	89 d8                	mov    %ebx,%eax
  800644:	c1 e8 0c             	shr    $0xc,%eax
  800647:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80064e:	f6 c2 01             	test   $0x1,%dl
  800651:	75 39                	jne    80068c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800653:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800656:	89 d0                	mov    %edx,%eax
  800658:	c1 e8 0c             	shr    $0xc,%eax
  80065b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800662:	83 ec 0c             	sub    $0xc,%esp
  800665:	25 07 0e 00 00       	and    $0xe07,%eax
  80066a:	50                   	push   %eax
  80066b:	56                   	push   %esi
  80066c:	6a 00                	push   $0x0
  80066e:	52                   	push   %edx
  80066f:	6a 00                	push   $0x0
  800671:	e8 5b fb ff ff       	call   8001d1 <sys_page_map>
  800676:	89 c3                	mov    %eax,%ebx
  800678:	83 c4 20             	add    $0x20,%esp
  80067b:	85 c0                	test   %eax,%eax
  80067d:	78 31                	js     8006b0 <dup+0xd5>
		goto err;

	return newfdnum;
  80067f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800682:	89 d8                	mov    %ebx,%eax
  800684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800687:	5b                   	pop    %ebx
  800688:	5e                   	pop    %esi
  800689:	5f                   	pop    %edi
  80068a:	5d                   	pop    %ebp
  80068b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80068c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	25 07 0e 00 00       	and    $0xe07,%eax
  80069b:	50                   	push   %eax
  80069c:	57                   	push   %edi
  80069d:	6a 00                	push   $0x0
  80069f:	53                   	push   %ebx
  8006a0:	6a 00                	push   $0x0
  8006a2:	e8 2a fb ff ff       	call   8001d1 <sys_page_map>
  8006a7:	89 c3                	mov    %eax,%ebx
  8006a9:	83 c4 20             	add    $0x20,%esp
  8006ac:	85 c0                	test   %eax,%eax
  8006ae:	79 a3                	jns    800653 <dup+0x78>
	sys_page_unmap(0, newfd);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	56                   	push   %esi
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 5c fb ff ff       	call   800217 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006bb:	83 c4 08             	add    $0x8,%esp
  8006be:	57                   	push   %edi
  8006bf:	6a 00                	push   $0x0
  8006c1:	e8 51 fb ff ff       	call   800217 <sys_page_unmap>
	return r;
  8006c6:	83 c4 10             	add    $0x10,%esp
  8006c9:	eb b7                	jmp    800682 <dup+0xa7>

008006cb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006cb:	f3 0f 1e fb          	endbr32 
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	53                   	push   %ebx
  8006d3:	83 ec 1c             	sub    $0x1c,%esp
  8006d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006dc:	50                   	push   %eax
  8006dd:	53                   	push   %ebx
  8006de:	e8 60 fd ff ff       	call   800443 <fd_lookup>
  8006e3:	83 c4 10             	add    $0x10,%esp
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	78 3f                	js     800729 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f4:	ff 30                	pushl  (%eax)
  8006f6:	e8 9c fd ff ff       	call   800497 <dev_lookup>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	85 c0                	test   %eax,%eax
  800700:	78 27                	js     800729 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800702:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800705:	8b 42 08             	mov    0x8(%edx),%eax
  800708:	83 e0 03             	and    $0x3,%eax
  80070b:	83 f8 01             	cmp    $0x1,%eax
  80070e:	74 1e                	je     80072e <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800713:	8b 40 08             	mov    0x8(%eax),%eax
  800716:	85 c0                	test   %eax,%eax
  800718:	74 35                	je     80074f <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	52                   	push   %edx
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
}
  800729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80072e:	a1 08 40 80 00       	mov    0x804008,%eax
  800733:	8b 40 48             	mov    0x48(%eax),%eax
  800736:	83 ec 04             	sub    $0x4,%esp
  800739:	53                   	push   %ebx
  80073a:	50                   	push   %eax
  80073b:	68 65 24 80 00       	push   $0x802465
  800740:	e8 62 0f 00 00       	call   8016a7 <cprintf>
		return -E_INVAL;
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074d:	eb da                	jmp    800729 <read+0x5e>
		return -E_NOT_SUPP;
  80074f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800754:	eb d3                	jmp    800729 <read+0x5e>

00800756 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800756:	f3 0f 1e fb          	endbr32 
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	57                   	push   %edi
  80075e:	56                   	push   %esi
  80075f:	53                   	push   %ebx
  800760:	83 ec 0c             	sub    $0xc,%esp
  800763:	8b 7d 08             	mov    0x8(%ebp),%edi
  800766:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800769:	bb 00 00 00 00       	mov    $0x0,%ebx
  80076e:	eb 02                	jmp    800772 <readn+0x1c>
  800770:	01 c3                	add    %eax,%ebx
  800772:	39 f3                	cmp    %esi,%ebx
  800774:	73 21                	jae    800797 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	89 f0                	mov    %esi,%eax
  80077b:	29 d8                	sub    %ebx,%eax
  80077d:	50                   	push   %eax
  80077e:	89 d8                	mov    %ebx,%eax
  800780:	03 45 0c             	add    0xc(%ebp),%eax
  800783:	50                   	push   %eax
  800784:	57                   	push   %edi
  800785:	e8 41 ff ff ff       	call   8006cb <read>
		if (m < 0)
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	85 c0                	test   %eax,%eax
  80078f:	78 04                	js     800795 <readn+0x3f>
			return m;
		if (m == 0)
  800791:	75 dd                	jne    800770 <readn+0x1a>
  800793:	eb 02                	jmp    800797 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800795:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800797:	89 d8                	mov    %ebx,%eax
  800799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079c:	5b                   	pop    %ebx
  80079d:	5e                   	pop    %esi
  80079e:	5f                   	pop    %edi
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	53                   	push   %ebx
  8007a9:	83 ec 1c             	sub    $0x1c,%esp
  8007ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b2:	50                   	push   %eax
  8007b3:	53                   	push   %ebx
  8007b4:	e8 8a fc ff ff       	call   800443 <fd_lookup>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	85 c0                	test   %eax,%eax
  8007be:	78 3a                	js     8007fa <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c0:	83 ec 08             	sub    $0x8,%esp
  8007c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c6:	50                   	push   %eax
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ca:	ff 30                	pushl  (%eax)
  8007cc:	e8 c6 fc ff ff       	call   800497 <dev_lookup>
  8007d1:	83 c4 10             	add    $0x10,%esp
  8007d4:	85 c0                	test   %eax,%eax
  8007d6:	78 22                	js     8007fa <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007db:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007df:	74 1e                	je     8007ff <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e7:	85 d2                	test   %edx,%edx
  8007e9:	74 35                	je     800820 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007eb:	83 ec 04             	sub    $0x4,%esp
  8007ee:	ff 75 10             	pushl  0x10(%ebp)
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	50                   	push   %eax
  8007f5:	ff d2                	call   *%edx
  8007f7:	83 c4 10             	add    $0x10,%esp
}
  8007fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ff:	a1 08 40 80 00       	mov    0x804008,%eax
  800804:	8b 40 48             	mov    0x48(%eax),%eax
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	53                   	push   %ebx
  80080b:	50                   	push   %eax
  80080c:	68 81 24 80 00       	push   $0x802481
  800811:	e8 91 0e 00 00       	call   8016a7 <cprintf>
		return -E_INVAL;
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081e:	eb da                	jmp    8007fa <write+0x59>
		return -E_NOT_SUPP;
  800820:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800825:	eb d3                	jmp    8007fa <write+0x59>

00800827 <seek>:

int
seek(int fdnum, off_t offset)
{
  800827:	f3 0f 1e fb          	endbr32 
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800831:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 06 fc ff ff       	call   800443 <fd_lookup>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	85 c0                	test   %eax,%eax
  800842:	78 0e                	js     800852 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800844:	8b 55 0c             	mov    0xc(%ebp),%edx
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80084a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80084d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800854:	f3 0f 1e fb          	endbr32 
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	53                   	push   %ebx
  80085c:	83 ec 1c             	sub    $0x1c,%esp
  80085f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800862:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	53                   	push   %ebx
  800867:	e8 d7 fb ff ff       	call   800443 <fd_lookup>
  80086c:	83 c4 10             	add    $0x10,%esp
  80086f:	85 c0                	test   %eax,%eax
  800871:	78 37                	js     8008aa <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800879:	50                   	push   %eax
  80087a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087d:	ff 30                	pushl  (%eax)
  80087f:	e8 13 fc ff ff       	call   800497 <dev_lookup>
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	85 c0                	test   %eax,%eax
  800889:	78 1f                	js     8008aa <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800892:	74 1b                	je     8008af <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800897:	8b 52 18             	mov    0x18(%edx),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	74 32                	je     8008d0 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	50                   	push   %eax
  8008a5:	ff d2                	call   *%edx
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008af:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b4:	8b 40 48             	mov    0x48(%eax),%eax
  8008b7:	83 ec 04             	sub    $0x4,%esp
  8008ba:	53                   	push   %ebx
  8008bb:	50                   	push   %eax
  8008bc:	68 44 24 80 00       	push   $0x802444
  8008c1:	e8 e1 0d 00 00       	call   8016a7 <cprintf>
		return -E_INVAL;
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ce:	eb da                	jmp    8008aa <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d5:	eb d3                	jmp    8008aa <ftruncate+0x56>

008008d7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d7:	f3 0f 1e fb          	endbr32 
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	83 ec 1c             	sub    $0x1c,%esp
  8008e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e8:	50                   	push   %eax
  8008e9:	ff 75 08             	pushl  0x8(%ebp)
  8008ec:	e8 52 fb ff ff       	call   800443 <fd_lookup>
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	85 c0                	test   %eax,%eax
  8008f6:	78 4b                	js     800943 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008fe:	50                   	push   %eax
  8008ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800902:	ff 30                	pushl  (%eax)
  800904:	e8 8e fb ff ff       	call   800497 <dev_lookup>
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	85 c0                	test   %eax,%eax
  80090e:	78 33                	js     800943 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800913:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800917:	74 2f                	je     800948 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800919:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80091c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800923:	00 00 00 
	stat->st_isdir = 0;
  800926:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80092d:	00 00 00 
	stat->st_dev = dev;
  800930:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	53                   	push   %ebx
  80093a:	ff 75 f0             	pushl  -0x10(%ebp)
  80093d:	ff 50 14             	call   *0x14(%eax)
  800940:	83 c4 10             	add    $0x10,%esp
}
  800943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800946:	c9                   	leave  
  800947:	c3                   	ret    
		return -E_NOT_SUPP;
  800948:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80094d:	eb f4                	jmp    800943 <fstat+0x6c>

0080094f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80094f:	f3 0f 1e fb          	endbr32 
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	56                   	push   %esi
  800957:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	6a 00                	push   $0x0
  80095d:	ff 75 08             	pushl  0x8(%ebp)
  800960:	e8 fb 01 00 00       	call   800b60 <open>
  800965:	89 c3                	mov    %eax,%ebx
  800967:	83 c4 10             	add    $0x10,%esp
  80096a:	85 c0                	test   %eax,%eax
  80096c:	78 1b                	js     800989 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	e8 5d ff ff ff       	call   8008d7 <fstat>
  80097a:	89 c6                	mov    %eax,%esi
	close(fd);
  80097c:	89 1c 24             	mov    %ebx,(%esp)
  80097f:	e8 fd fb ff ff       	call   800581 <close>
	return r;
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 f3                	mov    %esi,%ebx
}
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098e:	5b                   	pop    %ebx
  80098f:	5e                   	pop    %esi
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	89 c6                	mov    %eax,%esi
  800999:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80099b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009a2:	74 27                	je     8009cb <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a4:	6a 07                	push   $0x7
  8009a6:	68 00 50 80 00       	push   $0x805000
  8009ab:	56                   	push   %esi
  8009ac:	ff 35 00 40 80 00    	pushl  0x804000
  8009b2:	e8 e0 16 00 00       	call   802097 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b7:	83 c4 0c             	add    $0xc,%esp
  8009ba:	6a 00                	push   $0x0
  8009bc:	53                   	push   %ebx
  8009bd:	6a 00                	push   $0x0
  8009bf:	e8 5f 16 00 00       	call   802023 <ipc_recv>
}
  8009c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009cb:	83 ec 0c             	sub    $0xc,%esp
  8009ce:	6a 01                	push   $0x1
  8009d0:	e8 1a 17 00 00       	call   8020ef <ipc_find_env>
  8009d5:	a3 00 40 80 00       	mov    %eax,0x804000
  8009da:	83 c4 10             	add    $0x10,%esp
  8009dd:	eb c5                	jmp    8009a4 <fsipc+0x12>

008009df <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009df:	f3 0f 1e fb          	endbr32 
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8009ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f7:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800a01:	b8 02 00 00 00       	mov    $0x2,%eax
  800a06:	e8 87 ff ff ff       	call   800992 <fsipc>
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <devfile_flush>:
{
  800a0d:	f3 0f 1e fb          	endbr32 
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  800a1d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
  800a27:	b8 06 00 00 00       	mov    $0x6,%eax
  800a2c:	e8 61 ff ff ff       	call   800992 <fsipc>
}
  800a31:	c9                   	leave  
  800a32:	c3                   	ret    

00800a33 <devfile_stat>:
{
  800a33:	f3 0f 1e fb          	endbr32 
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 04             	sub    $0x4,%esp
  800a3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 40 0c             	mov    0xc(%eax),%eax
  800a47:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a51:	b8 05 00 00 00       	mov    $0x5,%eax
  800a56:	e8 37 ff ff ff       	call   800992 <fsipc>
  800a5b:	85 c0                	test   %eax,%eax
  800a5d:	78 2c                	js     800a8b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	68 00 50 80 00       	push   $0x805000
  800a67:	53                   	push   %ebx
  800a68:	e8 44 12 00 00       	call   801cb1 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a6d:	a1 80 50 80 00       	mov    0x805080,%eax
  800a72:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800a78:	a1 84 50 80 00       	mov    0x805084,%eax
  800a7d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a8e:	c9                   	leave  
  800a8f:	c3                   	ret    

00800a90 <devfile_write>:
{
  800a90:	f3 0f 1e fb          	endbr32 
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa0:	8b 52 0c             	mov    0xc(%edx),%edx
  800aa3:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800aa9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800aae:	ba 00 10 00 00       	mov    $0x1000,%edx
  800ab3:	0f 47 c2             	cmova  %edx,%eax
  800ab6:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800abb:	50                   	push   %eax
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	68 08 50 80 00       	push   $0x805008
  800ac4:	e8 9e 13 00 00       	call   801e67 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800ac9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ace:	b8 04 00 00 00       	mov    $0x4,%eax
  800ad3:	e8 ba fe ff ff       	call   800992 <fsipc>
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <devfile_read>:
{
  800ada:	f3 0f 1e fb          	endbr32 
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	56                   	push   %esi
  800ae2:	53                   	push   %ebx
  800ae3:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  800aec:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800af1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
  800afc:	b8 03 00 00 00       	mov    $0x3,%eax
  800b01:	e8 8c fe ff ff       	call   800992 <fsipc>
  800b06:	89 c3                	mov    %eax,%ebx
  800b08:	85 c0                	test   %eax,%eax
  800b0a:	78 1f                	js     800b2b <devfile_read+0x51>
	assert(r <= n);
  800b0c:	39 f0                	cmp    %esi,%eax
  800b0e:	77 24                	ja     800b34 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b10:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b15:	7f 33                	jg     800b4a <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b17:	83 ec 04             	sub    $0x4,%esp
  800b1a:	50                   	push   %eax
  800b1b:	68 00 50 80 00       	push   $0x805000
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	e8 3f 13 00 00       	call   801e67 <memmove>
	return r;
  800b28:	83 c4 10             	add    $0x10,%esp
}
  800b2b:	89 d8                	mov    %ebx,%eax
  800b2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    
	assert(r <= n);
  800b34:	68 b4 24 80 00       	push   $0x8024b4
  800b39:	68 bb 24 80 00       	push   $0x8024bb
  800b3e:	6a 7c                	push   $0x7c
  800b40:	68 d0 24 80 00       	push   $0x8024d0
  800b45:	e8 76 0a 00 00       	call   8015c0 <_panic>
	assert(r <= PGSIZE);
  800b4a:	68 db 24 80 00       	push   $0x8024db
  800b4f:	68 bb 24 80 00       	push   $0x8024bb
  800b54:	6a 7d                	push   $0x7d
  800b56:	68 d0 24 80 00       	push   $0x8024d0
  800b5b:	e8 60 0a 00 00       	call   8015c0 <_panic>

00800b60 <open>:
{
  800b60:	f3 0f 1e fb          	endbr32 
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	83 ec 1c             	sub    $0x1c,%esp
  800b6c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b6f:	56                   	push   %esi
  800b70:	e8 f9 10 00 00       	call   801c6e <strlen>
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b7d:	7f 6c                	jg     800beb <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800b7f:	83 ec 0c             	sub    $0xc,%esp
  800b82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b85:	50                   	push   %eax
  800b86:	e8 62 f8 ff ff       	call   8003ed <fd_alloc>
  800b8b:	89 c3                	mov    %eax,%ebx
  800b8d:	83 c4 10             	add    $0x10,%esp
  800b90:	85 c0                	test   %eax,%eax
  800b92:	78 3c                	js     800bd0 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	56                   	push   %esi
  800b98:	68 00 50 80 00       	push   $0x805000
  800b9d:	e8 0f 11 00 00       	call   801cb1 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bad:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb2:	e8 db fd ff ff       	call   800992 <fsipc>
  800bb7:	89 c3                	mov    %eax,%ebx
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	78 19                	js     800bd9 <open+0x79>
	return fd2num(fd);
  800bc0:	83 ec 0c             	sub    $0xc,%esp
  800bc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc6:	e8 f3 f7 ff ff       	call   8003be <fd2num>
  800bcb:	89 c3                	mov    %eax,%ebx
  800bcd:	83 c4 10             	add    $0x10,%esp
}
  800bd0:	89 d8                	mov    %ebx,%eax
  800bd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    
		fd_close(fd, 0);
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	6a 00                	push   $0x0
  800bde:	ff 75 f4             	pushl  -0xc(%ebp)
  800be1:	e8 10 f9 ff ff       	call   8004f6 <fd_close>
		return r;
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	eb e5                	jmp    800bd0 <open+0x70>
		return -E_BAD_PATH;
  800beb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800bf0:	eb de                	jmp    800bd0 <open+0x70>

00800bf2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 08 00 00 00       	mov    $0x8,%eax
  800c06:	e8 87 fd ff ff       	call   800992 <fsipc>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c0d:	f3 0f 1e fb          	endbr32 
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c17:	68 e7 24 80 00       	push   $0x8024e7
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	e8 8d 10 00 00       	call   801cb1 <strcpy>
	return 0;
}
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <devsock_close>:
{
  800c2b:	f3 0f 1e fb          	endbr32 
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	53                   	push   %ebx
  800c33:	83 ec 10             	sub    $0x10,%esp
  800c36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c39:	53                   	push   %ebx
  800c3a:	e8 ed 14 00 00       	call   80212c <pageref>
  800c3f:	89 c2                	mov    %eax,%edx
  800c41:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c44:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c49:	83 fa 01             	cmp    $0x1,%edx
  800c4c:	74 05                	je     800c53 <devsock_close+0x28>
}
  800c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	ff 73 0c             	pushl  0xc(%ebx)
  800c59:	e8 e3 02 00 00       	call   800f41 <nsipc_close>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	eb eb                	jmp    800c4e <devsock_close+0x23>

00800c63 <devsock_write>:
{
  800c63:	f3 0f 1e fb          	endbr32 
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c6d:	6a 00                	push   $0x0
  800c6f:	ff 75 10             	pushl  0x10(%ebp)
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	ff 70 0c             	pushl  0xc(%eax)
  800c7b:	e8 b5 03 00 00       	call   801035 <nsipc_send>
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <devsock_read>:
{
  800c82:	f3 0f 1e fb          	endbr32 
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800c8c:	6a 00                	push   $0x0
  800c8e:	ff 75 10             	pushl  0x10(%ebp)
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	ff 70 0c             	pushl  0xc(%eax)
  800c9a:	e8 1f 03 00 00       	call   800fbe <nsipc_recv>
}
  800c9f:	c9                   	leave  
  800ca0:	c3                   	ret    

00800ca1 <fd2sockid>:
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800ca7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800caa:	52                   	push   %edx
  800cab:	50                   	push   %eax
  800cac:	e8 92 f7 ff ff       	call   800443 <fd_lookup>
  800cb1:	83 c4 10             	add    $0x10,%esp
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	78 10                	js     800cc8 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cbb:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800cc1:	39 08                	cmp    %ecx,(%eax)
  800cc3:	75 05                	jne    800cca <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cc5:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    
		return -E_NOT_SUPP;
  800cca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ccf:	eb f7                	jmp    800cc8 <fd2sockid+0x27>

00800cd1 <alloc_sockfd>:
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 1c             	sub    $0x1c,%esp
  800cd9:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cde:	50                   	push   %eax
  800cdf:	e8 09 f7 ff ff       	call   8003ed <fd_alloc>
  800ce4:	89 c3                	mov    %eax,%ebx
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	78 43                	js     800d30 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ced:	83 ec 04             	sub    $0x4,%esp
  800cf0:	68 07 04 00 00       	push   $0x407
  800cf5:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf8:	6a 00                	push   $0x0
  800cfa:	e8 8b f4 ff ff       	call   80018a <sys_page_alloc>
  800cff:	89 c3                	mov    %eax,%ebx
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	85 c0                	test   %eax,%eax
  800d06:	78 28                	js     800d30 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d0b:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800d11:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d16:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d1d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d20:	83 ec 0c             	sub    $0xc,%esp
  800d23:	50                   	push   %eax
  800d24:	e8 95 f6 ff ff       	call   8003be <fd2num>
  800d29:	89 c3                	mov    %eax,%ebx
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	eb 0c                	jmp    800d3c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	56                   	push   %esi
  800d34:	e8 08 02 00 00       	call   800f41 <nsipc_close>
		return r;
  800d39:	83 c4 10             	add    $0x10,%esp
}
  800d3c:	89 d8                	mov    %ebx,%eax
  800d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <accept>:
{
  800d45:	f3 0f 1e fb          	endbr32 
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	e8 4a ff ff ff       	call   800ca1 <fd2sockid>
  800d57:	85 c0                	test   %eax,%eax
  800d59:	78 1b                	js     800d76 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	ff 75 10             	pushl  0x10(%ebp)
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	50                   	push   %eax
  800d65:	e8 22 01 00 00       	call   800e8c <nsipc_accept>
  800d6a:	83 c4 10             	add    $0x10,%esp
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	78 05                	js     800d76 <accept+0x31>
	return alloc_sockfd(r);
  800d71:	e8 5b ff ff ff       	call   800cd1 <alloc_sockfd>
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <bind>:
{
  800d78:	f3 0f 1e fb          	endbr32 
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	e8 17 ff ff ff       	call   800ca1 <fd2sockid>
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	78 12                	js     800da0 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800d8e:	83 ec 04             	sub    $0x4,%esp
  800d91:	ff 75 10             	pushl  0x10(%ebp)
  800d94:	ff 75 0c             	pushl  0xc(%ebp)
  800d97:	50                   	push   %eax
  800d98:	e8 45 01 00 00       	call   800ee2 <nsipc_bind>
  800d9d:	83 c4 10             	add    $0x10,%esp
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <shutdown>:
{
  800da2:	f3 0f 1e fb          	endbr32 
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	e8 ed fe ff ff       	call   800ca1 <fd2sockid>
  800db4:	85 c0                	test   %eax,%eax
  800db6:	78 0f                	js     800dc7 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	ff 75 0c             	pushl  0xc(%ebp)
  800dbe:	50                   	push   %eax
  800dbf:	e8 57 01 00 00       	call   800f1b <nsipc_shutdown>
  800dc4:	83 c4 10             	add    $0x10,%esp
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <connect>:
{
  800dc9:	f3 0f 1e fb          	endbr32 
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	e8 c6 fe ff ff       	call   800ca1 <fd2sockid>
  800ddb:	85 c0                	test   %eax,%eax
  800ddd:	78 12                	js     800df1 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800ddf:	83 ec 04             	sub    $0x4,%esp
  800de2:	ff 75 10             	pushl  0x10(%ebp)
  800de5:	ff 75 0c             	pushl  0xc(%ebp)
  800de8:	50                   	push   %eax
  800de9:	e8 71 01 00 00       	call   800f5f <nsipc_connect>
  800dee:	83 c4 10             	add    $0x10,%esp
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <listen>:
{
  800df3:	f3 0f 1e fb          	endbr32 
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	e8 9c fe ff ff       	call   800ca1 <fd2sockid>
  800e05:	85 c0                	test   %eax,%eax
  800e07:	78 0f                	js     800e18 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e09:	83 ec 08             	sub    $0x8,%esp
  800e0c:	ff 75 0c             	pushl  0xc(%ebp)
  800e0f:	50                   	push   %eax
  800e10:	e8 83 01 00 00       	call   800f98 <nsipc_listen>
  800e15:	83 c4 10             	add    $0x10,%esp
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <socket>:

int
socket(int domain, int type, int protocol)
{
  800e1a:	f3 0f 1e fb          	endbr32 
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e24:	ff 75 10             	pushl  0x10(%ebp)
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	ff 75 08             	pushl  0x8(%ebp)
  800e2d:	e8 65 02 00 00       	call   801097 <nsipc_socket>
  800e32:	83 c4 10             	add    $0x10,%esp
  800e35:	85 c0                	test   %eax,%eax
  800e37:	78 05                	js     800e3e <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e39:	e8 93 fe ff ff       	call   800cd1 <alloc_sockfd>
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	53                   	push   %ebx
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e49:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e50:	74 26                	je     800e78 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e52:	6a 07                	push   $0x7
  800e54:	68 00 60 80 00       	push   $0x806000
  800e59:	53                   	push   %ebx
  800e5a:	ff 35 04 40 80 00    	pushl  0x804004
  800e60:	e8 32 12 00 00       	call   802097 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e65:	83 c4 0c             	add    $0xc,%esp
  800e68:	6a 00                	push   $0x0
  800e6a:	6a 00                	push   $0x0
  800e6c:	6a 00                	push   $0x0
  800e6e:	e8 b0 11 00 00       	call   802023 <ipc_recv>
}
  800e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	6a 02                	push   $0x2
  800e7d:	e8 6d 12 00 00       	call   8020ef <ipc_find_env>
  800e82:	a3 04 40 80 00       	mov    %eax,0x804004
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	eb c6                	jmp    800e52 <nsipc+0x12>

00800e8c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800ea0:	8b 06                	mov    (%esi),%eax
  800ea2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ea7:	b8 01 00 00 00       	mov    $0x1,%eax
  800eac:	e8 8f ff ff ff       	call   800e40 <nsipc>
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	79 09                	jns    800ec0 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800eb7:	89 d8                	mov    %ebx,%eax
  800eb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	ff 35 10 60 80 00    	pushl  0x806010
  800ec9:	68 00 60 80 00       	push   $0x806000
  800ece:	ff 75 0c             	pushl  0xc(%ebp)
  800ed1:	e8 91 0f 00 00       	call   801e67 <memmove>
		*addrlen = ret->ret_addrlen;
  800ed6:	a1 10 60 80 00       	mov    0x806010,%eax
  800edb:	89 06                	mov    %eax,(%esi)
  800edd:	83 c4 10             	add    $0x10,%esp
	return r;
  800ee0:	eb d5                	jmp    800eb7 <nsipc_accept+0x2b>

00800ee2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ee2:	f3 0f 1e fb          	endbr32 
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	53                   	push   %ebx
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800ef8:	53                   	push   %ebx
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	68 04 60 80 00       	push   $0x806004
  800f01:	e8 61 0f 00 00       	call   801e67 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f06:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f0c:	b8 02 00 00 00       	mov    $0x2,%eax
  800f11:	e8 2a ff ff ff       	call   800e40 <nsipc>
}
  800f16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f1b:	f3 0f 1e fb          	endbr32 
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f35:	b8 03 00 00 00       	mov    $0x3,%eax
  800f3a:	e8 01 ff ff ff       	call   800e40 <nsipc>
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <nsipc_close>:

int
nsipc_close(int s)
{
  800f41:	f3 0f 1e fb          	endbr32 
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f53:	b8 04 00 00 00       	mov    $0x4,%eax
  800f58:	e8 e3 fe ff ff       	call   800e40 <nsipc>
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f5f:	f3 0f 1e fb          	endbr32 
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	53                   	push   %ebx
  800f67:	83 ec 08             	sub    $0x8,%esp
  800f6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f75:	53                   	push   %ebx
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	68 04 60 80 00       	push   $0x806004
  800f7e:	e8 e4 0e 00 00       	call   801e67 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800f83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800f89:	b8 05 00 00 00       	mov    $0x5,%eax
  800f8e:	e8 ad fe ff ff       	call   800e40 <nsipc>
}
  800f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800f98:	f3 0f 1e fb          	endbr32 
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800fb7:	e8 84 fe ff ff       	call   800e40 <nsipc>
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fbe:	f3 0f 1e fb          	endbr32 
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800fd2:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  800fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdb:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  800fe0:	b8 07 00 00 00       	mov    $0x7,%eax
  800fe5:	e8 56 fe ff ff       	call   800e40 <nsipc>
  800fea:	89 c3                	mov    %eax,%ebx
  800fec:	85 c0                	test   %eax,%eax
  800fee:	78 26                	js     801016 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  800ff0:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  800ff6:	b8 3f 06 00 00       	mov    $0x63f,%eax
  800ffb:	0f 4e c6             	cmovle %esi,%eax
  800ffe:	39 c3                	cmp    %eax,%ebx
  801000:	7f 1d                	jg     80101f <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801002:	83 ec 04             	sub    $0x4,%esp
  801005:	53                   	push   %ebx
  801006:	68 00 60 80 00       	push   $0x806000
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	e8 54 0e 00 00       	call   801e67 <memmove>
  801013:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801016:	89 d8                	mov    %ebx,%eax
  801018:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80101f:	68 f3 24 80 00       	push   $0x8024f3
  801024:	68 bb 24 80 00       	push   $0x8024bb
  801029:	6a 62                	push   $0x62
  80102b:	68 08 25 80 00       	push   $0x802508
  801030:	e8 8b 05 00 00       	call   8015c0 <_panic>

00801035 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801035:	f3 0f 1e fb          	endbr32 
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 04             	sub    $0x4,%esp
  801040:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80104b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801051:	7f 2e                	jg     801081 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801053:	83 ec 04             	sub    $0x4,%esp
  801056:	53                   	push   %ebx
  801057:	ff 75 0c             	pushl  0xc(%ebp)
  80105a:	68 0c 60 80 00       	push   $0x80600c
  80105f:	e8 03 0e 00 00       	call   801e67 <memmove>
	nsipcbuf.send.req_size = size;
  801064:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801072:	b8 08 00 00 00       	mov    $0x8,%eax
  801077:	e8 c4 fd ff ff       	call   800e40 <nsipc>
}
  80107c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80107f:	c9                   	leave  
  801080:	c3                   	ret    
	assert(size < 1600);
  801081:	68 14 25 80 00       	push   $0x802514
  801086:	68 bb 24 80 00       	push   $0x8024bb
  80108b:	6a 6d                	push   $0x6d
  80108d:	68 08 25 80 00       	push   $0x802508
  801092:	e8 29 05 00 00       	call   8015c0 <_panic>

00801097 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801097:	f3 0f 1e fb          	endbr32 
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8010a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ac:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010b9:	b8 09 00 00 00       	mov    $0x9,%eax
  8010be:	e8 7d fd ff ff       	call   800e40 <nsipc>
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010c5:	f3 0f 1e fb          	endbr32 
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	56                   	push   %esi
  8010cd:	53                   	push   %ebx
  8010ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	ff 75 08             	pushl  0x8(%ebp)
  8010d7:	e8 f6 f2 ff ff       	call   8003d2 <fd2data>
  8010dc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8010de:	83 c4 08             	add    $0x8,%esp
  8010e1:	68 20 25 80 00       	push   $0x802520
  8010e6:	53                   	push   %ebx
  8010e7:	e8 c5 0b 00 00       	call   801cb1 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8010ec:	8b 46 04             	mov    0x4(%esi),%eax
  8010ef:	2b 06                	sub    (%esi),%eax
  8010f1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8010f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8010fe:	00 00 00 
	stat->st_dev = &devpipe;
  801101:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801108:	30 80 00 
	return 0;
}
  80110b:	b8 00 00 00 00       	mov    $0x0,%eax
  801110:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801117:	f3 0f 1e fb          	endbr32 
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	53                   	push   %ebx
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801125:	53                   	push   %ebx
  801126:	6a 00                	push   $0x0
  801128:	e8 ea f0 ff ff       	call   800217 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80112d:	89 1c 24             	mov    %ebx,(%esp)
  801130:	e8 9d f2 ff ff       	call   8003d2 <fd2data>
  801135:	83 c4 08             	add    $0x8,%esp
  801138:	50                   	push   %eax
  801139:	6a 00                	push   $0x0
  80113b:	e8 d7 f0 ff ff       	call   800217 <sys_page_unmap>
}
  801140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <_pipeisclosed>:
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	57                   	push   %edi
  801149:	56                   	push   %esi
  80114a:	53                   	push   %ebx
  80114b:	83 ec 1c             	sub    $0x1c,%esp
  80114e:	89 c7                	mov    %eax,%edi
  801150:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801152:	a1 08 40 80 00       	mov    0x804008,%eax
  801157:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80115a:	83 ec 0c             	sub    $0xc,%esp
  80115d:	57                   	push   %edi
  80115e:	e8 c9 0f 00 00       	call   80212c <pageref>
  801163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801166:	89 34 24             	mov    %esi,(%esp)
  801169:	e8 be 0f 00 00       	call   80212c <pageref>
		nn = thisenv->env_runs;
  80116e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801174:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	39 cb                	cmp    %ecx,%ebx
  80117c:	74 1b                	je     801199 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80117e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801181:	75 cf                	jne    801152 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801183:	8b 42 58             	mov    0x58(%edx),%eax
  801186:	6a 01                	push   $0x1
  801188:	50                   	push   %eax
  801189:	53                   	push   %ebx
  80118a:	68 27 25 80 00       	push   $0x802527
  80118f:	e8 13 05 00 00       	call   8016a7 <cprintf>
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	eb b9                	jmp    801152 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801199:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80119c:	0f 94 c0             	sete   %al
  80119f:	0f b6 c0             	movzbl %al,%eax
}
  8011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a5:	5b                   	pop    %ebx
  8011a6:	5e                   	pop    %esi
  8011a7:	5f                   	pop    %edi
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <devpipe_write>:
{
  8011aa:	f3 0f 1e fb          	endbr32 
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	57                   	push   %edi
  8011b2:	56                   	push   %esi
  8011b3:	53                   	push   %ebx
  8011b4:	83 ec 28             	sub    $0x28,%esp
  8011b7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011ba:	56                   	push   %esi
  8011bb:	e8 12 f2 ff ff       	call   8003d2 <fd2data>
  8011c0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ca:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011cd:	74 4f                	je     80121e <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011cf:	8b 43 04             	mov    0x4(%ebx),%eax
  8011d2:	8b 0b                	mov    (%ebx),%ecx
  8011d4:	8d 51 20             	lea    0x20(%ecx),%edx
  8011d7:	39 d0                	cmp    %edx,%eax
  8011d9:	72 14                	jb     8011ef <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8011db:	89 da                	mov    %ebx,%edx
  8011dd:	89 f0                	mov    %esi,%eax
  8011df:	e8 61 ff ff ff       	call   801145 <_pipeisclosed>
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	75 3b                	jne    801223 <devpipe_write+0x79>
			sys_yield();
  8011e8:	e8 7a ef ff ff       	call   800167 <sys_yield>
  8011ed:	eb e0                	jmp    8011cf <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8011ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8011f6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8011f9:	89 c2                	mov    %eax,%edx
  8011fb:	c1 fa 1f             	sar    $0x1f,%edx
  8011fe:	89 d1                	mov    %edx,%ecx
  801200:	c1 e9 1b             	shr    $0x1b,%ecx
  801203:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801206:	83 e2 1f             	and    $0x1f,%edx
  801209:	29 ca                	sub    %ecx,%edx
  80120b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80120f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801213:	83 c0 01             	add    $0x1,%eax
  801216:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801219:	83 c7 01             	add    $0x1,%edi
  80121c:	eb ac                	jmp    8011ca <devpipe_write+0x20>
	return i;
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	eb 05                	jmp    801228 <devpipe_write+0x7e>
				return 0;
  801223:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <devpipe_read>:
{
  801230:	f3 0f 1e fb          	endbr32 
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	57                   	push   %edi
  801238:	56                   	push   %esi
  801239:	53                   	push   %ebx
  80123a:	83 ec 18             	sub    $0x18,%esp
  80123d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801240:	57                   	push   %edi
  801241:	e8 8c f1 ff ff       	call   8003d2 <fd2data>
  801246:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	be 00 00 00 00       	mov    $0x0,%esi
  801250:	3b 75 10             	cmp    0x10(%ebp),%esi
  801253:	75 14                	jne    801269 <devpipe_read+0x39>
	return i;
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	eb 02                	jmp    80125c <devpipe_read+0x2c>
				return i;
  80125a:	89 f0                	mov    %esi,%eax
}
  80125c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5f                   	pop    %edi
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    
			sys_yield();
  801264:	e8 fe ee ff ff       	call   800167 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801269:	8b 03                	mov    (%ebx),%eax
  80126b:	3b 43 04             	cmp    0x4(%ebx),%eax
  80126e:	75 18                	jne    801288 <devpipe_read+0x58>
			if (i > 0)
  801270:	85 f6                	test   %esi,%esi
  801272:	75 e6                	jne    80125a <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801274:	89 da                	mov    %ebx,%edx
  801276:	89 f8                	mov    %edi,%eax
  801278:	e8 c8 fe ff ff       	call   801145 <_pipeisclosed>
  80127d:	85 c0                	test   %eax,%eax
  80127f:	74 e3                	je     801264 <devpipe_read+0x34>
				return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb d4                	jmp    80125c <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801288:	99                   	cltd   
  801289:	c1 ea 1b             	shr    $0x1b,%edx
  80128c:	01 d0                	add    %edx,%eax
  80128e:	83 e0 1f             	and    $0x1f,%eax
  801291:	29 d0                	sub    %edx,%eax
  801293:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80129e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8012a1:	83 c6 01             	add    $0x1,%esi
  8012a4:	eb aa                	jmp    801250 <devpipe_read+0x20>

008012a6 <pipe>:
{
  8012a6:	f3 0f 1e fb          	endbr32 
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b5:	50                   	push   %eax
  8012b6:	e8 32 f1 ff ff       	call   8003ed <fd_alloc>
  8012bb:	89 c3                	mov    %eax,%ebx
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	0f 88 23 01 00 00    	js     8013eb <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	68 07 04 00 00       	push   $0x407
  8012d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d3:	6a 00                	push   $0x0
  8012d5:	e8 b0 ee ff ff       	call   80018a <sys_page_alloc>
  8012da:	89 c3                	mov    %eax,%ebx
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	0f 88 04 01 00 00    	js     8013eb <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	e8 fa f0 ff ff       	call   8003ed <fd_alloc>
  8012f3:	89 c3                	mov    %eax,%ebx
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	85 c0                	test   %eax,%eax
  8012fa:	0f 88 db 00 00 00    	js     8013db <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801300:	83 ec 04             	sub    $0x4,%esp
  801303:	68 07 04 00 00       	push   $0x407
  801308:	ff 75 f0             	pushl  -0x10(%ebp)
  80130b:	6a 00                	push   $0x0
  80130d:	e8 78 ee ff ff       	call   80018a <sys_page_alloc>
  801312:	89 c3                	mov    %eax,%ebx
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	0f 88 bc 00 00 00    	js     8013db <pipe+0x135>
	va = fd2data(fd0);
  80131f:	83 ec 0c             	sub    $0xc,%esp
  801322:	ff 75 f4             	pushl  -0xc(%ebp)
  801325:	e8 a8 f0 ff ff       	call   8003d2 <fd2data>
  80132a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80132c:	83 c4 0c             	add    $0xc,%esp
  80132f:	68 07 04 00 00       	push   $0x407
  801334:	50                   	push   %eax
  801335:	6a 00                	push   $0x0
  801337:	e8 4e ee ff ff       	call   80018a <sys_page_alloc>
  80133c:	89 c3                	mov    %eax,%ebx
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	0f 88 82 00 00 00    	js     8013cb <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 f0             	pushl  -0x10(%ebp)
  80134f:	e8 7e f0 ff ff       	call   8003d2 <fd2data>
  801354:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80135b:	50                   	push   %eax
  80135c:	6a 00                	push   $0x0
  80135e:	56                   	push   %esi
  80135f:	6a 00                	push   $0x0
  801361:	e8 6b ee ff ff       	call   8001d1 <sys_page_map>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 20             	add    $0x20,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 4e                	js     8013bd <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80136f:	a1 40 30 80 00       	mov    0x803040,%eax
  801374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801377:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801383:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801386:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801392:	83 ec 0c             	sub    $0xc,%esp
  801395:	ff 75 f4             	pushl  -0xc(%ebp)
  801398:	e8 21 f0 ff ff       	call   8003be <fd2num>
  80139d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8013a2:	83 c4 04             	add    $0x4,%esp
  8013a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a8:	e8 11 f0 ff ff       	call   8003be <fd2num>
  8013ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bb:	eb 2e                	jmp    8013eb <pipe+0x145>
	sys_page_unmap(0, va);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	56                   	push   %esi
  8013c1:	6a 00                	push   $0x0
  8013c3:	e8 4f ee ff ff       	call   800217 <sys_page_unmap>
  8013c8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013cb:	83 ec 08             	sub    $0x8,%esp
  8013ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d1:	6a 00                	push   $0x0
  8013d3:	e8 3f ee ff ff       	call   800217 <sys_page_unmap>
  8013d8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8013db:	83 ec 08             	sub    $0x8,%esp
  8013de:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e1:	6a 00                	push   $0x0
  8013e3:	e8 2f ee ff ff       	call   800217 <sys_page_unmap>
  8013e8:	83 c4 10             	add    $0x10,%esp
}
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <pipeisclosed>:
{
  8013f4:	f3 0f 1e fb          	endbr32 
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801401:	50                   	push   %eax
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 39 f0 ff ff       	call   800443 <fd_lookup>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 18                	js     801429 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	ff 75 f4             	pushl  -0xc(%ebp)
  801417:	e8 b6 ef ff ff       	call   8003d2 <fd2data>
  80141c:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80141e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801421:	e8 1f fd ff ff       	call   801145 <_pipeisclosed>
  801426:	83 c4 10             	add    $0x10,%esp
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80142b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80142f:	b8 00 00 00 00       	mov    $0x0,%eax
  801434:	c3                   	ret    

00801435 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80143f:	68 3f 25 80 00       	push   $0x80253f
  801444:	ff 75 0c             	pushl  0xc(%ebp)
  801447:	e8 65 08 00 00       	call   801cb1 <strcpy>
	return 0;
}
  80144c:	b8 00 00 00 00       	mov    $0x0,%eax
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <devcons_write>:
{
  801453:	f3 0f 1e fb          	endbr32 
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	57                   	push   %edi
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801463:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801468:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80146e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801471:	73 31                	jae    8014a4 <devcons_write+0x51>
		m = n - tot;
  801473:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801476:	29 f3                	sub    %esi,%ebx
  801478:	83 fb 7f             	cmp    $0x7f,%ebx
  80147b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801480:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	53                   	push   %ebx
  801487:	89 f0                	mov    %esi,%eax
  801489:	03 45 0c             	add    0xc(%ebp),%eax
  80148c:	50                   	push   %eax
  80148d:	57                   	push   %edi
  80148e:	e8 d4 09 00 00       	call   801e67 <memmove>
		sys_cputs(buf, m);
  801493:	83 c4 08             	add    $0x8,%esp
  801496:	53                   	push   %ebx
  801497:	57                   	push   %edi
  801498:	e8 1d ec ff ff       	call   8000ba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80149d:	01 de                	add    %ebx,%esi
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	eb ca                	jmp    80146e <devcons_write+0x1b>
}
  8014a4:	89 f0                	mov    %esi,%eax
  8014a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5e                   	pop    %esi
  8014ab:	5f                   	pop    %edi
  8014ac:	5d                   	pop    %ebp
  8014ad:	c3                   	ret    

008014ae <devcons_read>:
{
  8014ae:	f3 0f 1e fb          	endbr32 
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c1:	74 21                	je     8014e4 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014c3:	e8 14 ec ff ff       	call   8000dc <sys_cgetc>
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	75 07                	jne    8014d3 <devcons_read+0x25>
		sys_yield();
  8014cc:	e8 96 ec ff ff       	call   800167 <sys_yield>
  8014d1:	eb f0                	jmp    8014c3 <devcons_read+0x15>
	if (c < 0)
  8014d3:	78 0f                	js     8014e4 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014d5:	83 f8 04             	cmp    $0x4,%eax
  8014d8:	74 0c                	je     8014e6 <devcons_read+0x38>
	*(char*)vbuf = c;
  8014da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014dd:	88 02                	mov    %al,(%edx)
	return 1;
  8014df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    
		return 0;
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	eb f7                	jmp    8014e4 <devcons_read+0x36>

008014ed <cputchar>:
{
  8014ed:	f3 0f 1e fb          	endbr32 
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8014fd:	6a 01                	push   $0x1
  8014ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801502:	50                   	push   %eax
  801503:	e8 b2 eb ff ff       	call   8000ba <sys_cputs>
}
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <getchar>:
{
  80150d:	f3 0f 1e fb          	endbr32 
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801517:	6a 01                	push   $0x1
  801519:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	6a 00                	push   $0x0
  80151f:	e8 a7 f1 ff ff       	call   8006cb <read>
	if (r < 0)
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 06                	js     801531 <getchar+0x24>
	if (r < 1)
  80152b:	74 06                	je     801533 <getchar+0x26>
	return c;
  80152d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    
		return -E_EOF;
  801533:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801538:	eb f7                	jmp    801531 <getchar+0x24>

0080153a <iscons>:
{
  80153a:	f3 0f 1e fb          	endbr32 
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801544:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801547:	50                   	push   %eax
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	e8 f3 ee ff ff       	call   800443 <fd_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 11                	js     801568 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155a:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801560:	39 10                	cmp    %edx,(%eax)
  801562:	0f 94 c0             	sete   %al
  801565:	0f b6 c0             	movzbl %al,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <opencons>:
{
  80156a:	f3 0f 1e fb          	endbr32 
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	e8 70 ee ff ff       	call   8003ed <fd_alloc>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 3a                	js     8015be <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 07 04 00 00       	push   $0x407
  80158c:	ff 75 f4             	pushl  -0xc(%ebp)
  80158f:	6a 00                	push   $0x0
  801591:	e8 f4 eb ff ff       	call   80018a <sys_page_alloc>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 21                	js     8015be <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8015a6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ab:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015b2:	83 ec 0c             	sub    $0xc,%esp
  8015b5:	50                   	push   %eax
  8015b6:	e8 03 ee ff ff       	call   8003be <fd2num>
  8015bb:	83 c4 10             	add    $0x10,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015c0:	f3 0f 1e fb          	endbr32 
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	56                   	push   %esi
  8015c8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015c9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015cc:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8015d2:	e8 6d eb ff ff       	call   800144 <sys_getenvid>
  8015d7:	83 ec 0c             	sub    $0xc,%esp
  8015da:	ff 75 0c             	pushl  0xc(%ebp)
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	56                   	push   %esi
  8015e1:	50                   	push   %eax
  8015e2:	68 4c 25 80 00       	push   $0x80254c
  8015e7:	e8 bb 00 00 00       	call   8016a7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8015ec:	83 c4 18             	add    $0x18,%esp
  8015ef:	53                   	push   %ebx
  8015f0:	ff 75 10             	pushl  0x10(%ebp)
  8015f3:	e8 5a 00 00 00       	call   801652 <vcprintf>
	cprintf("\n");
  8015f8:	c7 04 24 38 25 80 00 	movl   $0x802538,(%esp)
  8015ff:	e8 a3 00 00 00       	call   8016a7 <cprintf>
  801604:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801607:	cc                   	int3   
  801608:	eb fd                	jmp    801607 <_panic+0x47>

0080160a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80160a:	f3 0f 1e fb          	endbr32 
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	53                   	push   %ebx
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801618:	8b 13                	mov    (%ebx),%edx
  80161a:	8d 42 01             	lea    0x1(%edx),%eax
  80161d:	89 03                	mov    %eax,(%ebx)
  80161f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801622:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801626:	3d ff 00 00 00       	cmp    $0xff,%eax
  80162b:	74 09                	je     801636 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80162d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801634:	c9                   	leave  
  801635:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801636:	83 ec 08             	sub    $0x8,%esp
  801639:	68 ff 00 00 00       	push   $0xff
  80163e:	8d 43 08             	lea    0x8(%ebx),%eax
  801641:	50                   	push   %eax
  801642:	e8 73 ea ff ff       	call   8000ba <sys_cputs>
		b->idx = 0;
  801647:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	eb db                	jmp    80162d <putch+0x23>

00801652 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801652:	f3 0f 1e fb          	endbr32 
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80165f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801666:	00 00 00 
	b.cnt = 0;
  801669:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801670:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	ff 75 08             	pushl  0x8(%ebp)
  801679:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80167f:	50                   	push   %eax
  801680:	68 0a 16 80 00       	push   $0x80160a
  801685:	e8 20 01 00 00       	call   8017aa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80168a:	83 c4 08             	add    $0x8,%esp
  80168d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801693:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	e8 1b ea ff ff       	call   8000ba <sys_cputs>

	return b.cnt;
}
  80169f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016a7:	f3 0f 1e fb          	endbr32 
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 95 ff ff ff       	call   801652 <vcprintf>
	va_end(ap);

	return cnt;
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	57                   	push   %edi
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 1c             	sub    $0x1c,%esp
  8016c8:	89 c7                	mov    %eax,%edi
  8016ca:	89 d6                	mov    %edx,%esi
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	89 d1                	mov    %edx,%ecx
  8016d4:	89 c2                	mov    %eax,%edx
  8016d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8016e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016ec:	39 c2                	cmp    %eax,%edx
  8016ee:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8016f1:	72 3e                	jb     801731 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016f3:	83 ec 0c             	sub    $0xc,%esp
  8016f6:	ff 75 18             	pushl  0x18(%ebp)
  8016f9:	83 eb 01             	sub    $0x1,%ebx
  8016fc:	53                   	push   %ebx
  8016fd:	50                   	push   %eax
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	ff 75 e4             	pushl  -0x1c(%ebp)
  801704:	ff 75 e0             	pushl  -0x20(%ebp)
  801707:	ff 75 dc             	pushl  -0x24(%ebp)
  80170a:	ff 75 d8             	pushl  -0x28(%ebp)
  80170d:	e8 5e 0a 00 00       	call   802170 <__udivdi3>
  801712:	83 c4 18             	add    $0x18,%esp
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	89 f2                	mov    %esi,%edx
  801719:	89 f8                	mov    %edi,%eax
  80171b:	e8 9f ff ff ff       	call   8016bf <printnum>
  801720:	83 c4 20             	add    $0x20,%esp
  801723:	eb 13                	jmp    801738 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	56                   	push   %esi
  801729:	ff 75 18             	pushl  0x18(%ebp)
  80172c:	ff d7                	call   *%edi
  80172e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801731:	83 eb 01             	sub    $0x1,%ebx
  801734:	85 db                	test   %ebx,%ebx
  801736:	7f ed                	jg     801725 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	56                   	push   %esi
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801742:	ff 75 e0             	pushl  -0x20(%ebp)
  801745:	ff 75 dc             	pushl  -0x24(%ebp)
  801748:	ff 75 d8             	pushl  -0x28(%ebp)
  80174b:	e8 30 0b 00 00       	call   802280 <__umoddi3>
  801750:	83 c4 14             	add    $0x14,%esp
  801753:	0f be 80 6f 25 80 00 	movsbl 0x80256f(%eax),%eax
  80175a:	50                   	push   %eax
  80175b:	ff d7                	call   *%edi
}
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801763:	5b                   	pop    %ebx
  801764:	5e                   	pop    %esi
  801765:	5f                   	pop    %edi
  801766:	5d                   	pop    %ebp
  801767:	c3                   	ret    

00801768 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801768:	f3 0f 1e fb          	endbr32 
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801772:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801776:	8b 10                	mov    (%eax),%edx
  801778:	3b 50 04             	cmp    0x4(%eax),%edx
  80177b:	73 0a                	jae    801787 <sprintputch+0x1f>
		*b->buf++ = ch;
  80177d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801780:	89 08                	mov    %ecx,(%eax)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	88 02                	mov    %al,(%edx)
}
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    

00801789 <printfmt>:
{
  801789:	f3 0f 1e fb          	endbr32 
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801793:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801796:	50                   	push   %eax
  801797:	ff 75 10             	pushl  0x10(%ebp)
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 05 00 00 00       	call   8017aa <vprintfmt>
}
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <vprintfmt>:
{
  8017aa:	f3 0f 1e fb          	endbr32 
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	57                   	push   %edi
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 3c             	sub    $0x3c,%esp
  8017b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8017ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017c0:	e9 8e 03 00 00       	jmp    801b53 <vprintfmt+0x3a9>
		padc = ' ';
  8017c5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017c9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017d0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8017d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8017de:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8017e3:	8d 47 01             	lea    0x1(%edi),%eax
  8017e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017e9:	0f b6 17             	movzbl (%edi),%edx
  8017ec:	8d 42 dd             	lea    -0x23(%edx),%eax
  8017ef:	3c 55                	cmp    $0x55,%al
  8017f1:	0f 87 df 03 00 00    	ja     801bd6 <vprintfmt+0x42c>
  8017f7:	0f b6 c0             	movzbl %al,%eax
  8017fa:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  801801:	00 
  801802:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801805:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801809:	eb d8                	jmp    8017e3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80180b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80180e:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801812:	eb cf                	jmp    8017e3 <vprintfmt+0x39>
  801814:	0f b6 d2             	movzbl %dl,%edx
  801817:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801822:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801825:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801829:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80182c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80182f:	83 f9 09             	cmp    $0x9,%ecx
  801832:	77 55                	ja     801889 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801834:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801837:	eb e9                	jmp    801822 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801839:	8b 45 14             	mov    0x14(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801841:	8b 45 14             	mov    0x14(%ebp),%eax
  801844:	8d 40 04             	lea    0x4(%eax),%eax
  801847:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80184a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80184d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801851:	79 90                	jns    8017e3 <vprintfmt+0x39>
				width = precision, precision = -1;
  801853:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801856:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801859:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801860:	eb 81                	jmp    8017e3 <vprintfmt+0x39>
  801862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801865:	85 c0                	test   %eax,%eax
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	0f 49 d0             	cmovns %eax,%edx
  80186f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801872:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801875:	e9 69 ff ff ff       	jmp    8017e3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80187a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80187d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801884:	e9 5a ff ff ff       	jmp    8017e3 <vprintfmt+0x39>
  801889:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80188c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80188f:	eb bc                	jmp    80184d <vprintfmt+0xa3>
			lflag++;
  801891:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801894:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801897:	e9 47 ff ff ff       	jmp    8017e3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80189c:	8b 45 14             	mov    0x14(%ebp),%eax
  80189f:	8d 78 04             	lea    0x4(%eax),%edi
  8018a2:	83 ec 08             	sub    $0x8,%esp
  8018a5:	53                   	push   %ebx
  8018a6:	ff 30                	pushl  (%eax)
  8018a8:	ff d6                	call   *%esi
			break;
  8018aa:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8018ad:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018b0:	e9 9b 02 00 00       	jmp    801b50 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b8:	8d 78 04             	lea    0x4(%eax),%edi
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	99                   	cltd   
  8018be:	31 d0                	xor    %edx,%eax
  8018c0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018c2:	83 f8 0f             	cmp    $0xf,%eax
  8018c5:	7f 23                	jg     8018ea <vprintfmt+0x140>
  8018c7:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  8018ce:	85 d2                	test   %edx,%edx
  8018d0:	74 18                	je     8018ea <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018d2:	52                   	push   %edx
  8018d3:	68 cd 24 80 00       	push   $0x8024cd
  8018d8:	53                   	push   %ebx
  8018d9:	56                   	push   %esi
  8018da:	e8 aa fe ff ff       	call   801789 <printfmt>
  8018df:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018e2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8018e5:	e9 66 02 00 00       	jmp    801b50 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8018ea:	50                   	push   %eax
  8018eb:	68 87 25 80 00       	push   $0x802587
  8018f0:	53                   	push   %ebx
  8018f1:	56                   	push   %esi
  8018f2:	e8 92 fe ff ff       	call   801789 <printfmt>
  8018f7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8018fa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8018fd:	e9 4e 02 00 00       	jmp    801b50 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	83 c0 04             	add    $0x4,%eax
  801908:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80190b:	8b 45 14             	mov    0x14(%ebp),%eax
  80190e:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801910:	85 d2                	test   %edx,%edx
  801912:	b8 80 25 80 00       	mov    $0x802580,%eax
  801917:	0f 45 c2             	cmovne %edx,%eax
  80191a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80191d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801921:	7e 06                	jle    801929 <vprintfmt+0x17f>
  801923:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801927:	75 0d                	jne    801936 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801929:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80192c:	89 c7                	mov    %eax,%edi
  80192e:	03 45 e0             	add    -0x20(%ebp),%eax
  801931:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801934:	eb 55                	jmp    80198b <vprintfmt+0x1e1>
  801936:	83 ec 08             	sub    $0x8,%esp
  801939:	ff 75 d8             	pushl  -0x28(%ebp)
  80193c:	ff 75 cc             	pushl  -0x34(%ebp)
  80193f:	e8 46 03 00 00       	call   801c8a <strnlen>
  801944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801947:	29 c2                	sub    %eax,%edx
  801949:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801951:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801955:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801958:	85 ff                	test   %edi,%edi
  80195a:	7e 11                	jle    80196d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80195c:	83 ec 08             	sub    $0x8,%esp
  80195f:	53                   	push   %ebx
  801960:	ff 75 e0             	pushl  -0x20(%ebp)
  801963:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801965:	83 ef 01             	sub    $0x1,%edi
  801968:	83 c4 10             	add    $0x10,%esp
  80196b:	eb eb                	jmp    801958 <vprintfmt+0x1ae>
  80196d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
  801977:	0f 49 c2             	cmovns %edx,%eax
  80197a:	29 c2                	sub    %eax,%edx
  80197c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80197f:	eb a8                	jmp    801929 <vprintfmt+0x17f>
					putch(ch, putdat);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	53                   	push   %ebx
  801985:	52                   	push   %edx
  801986:	ff d6                	call   *%esi
  801988:	83 c4 10             	add    $0x10,%esp
  80198b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80198e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801990:	83 c7 01             	add    $0x1,%edi
  801993:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801997:	0f be d0             	movsbl %al,%edx
  80199a:	85 d2                	test   %edx,%edx
  80199c:	74 4b                	je     8019e9 <vprintfmt+0x23f>
  80199e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8019a2:	78 06                	js     8019aa <vprintfmt+0x200>
  8019a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8019a8:	78 1e                	js     8019c8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8019aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019ae:	74 d1                	je     801981 <vprintfmt+0x1d7>
  8019b0:	0f be c0             	movsbl %al,%eax
  8019b3:	83 e8 20             	sub    $0x20,%eax
  8019b6:	83 f8 5e             	cmp    $0x5e,%eax
  8019b9:	76 c6                	jbe    801981 <vprintfmt+0x1d7>
					putch('?', putdat);
  8019bb:	83 ec 08             	sub    $0x8,%esp
  8019be:	53                   	push   %ebx
  8019bf:	6a 3f                	push   $0x3f
  8019c1:	ff d6                	call   *%esi
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	eb c3                	jmp    80198b <vprintfmt+0x1e1>
  8019c8:	89 cf                	mov    %ecx,%edi
  8019ca:	eb 0e                	jmp    8019da <vprintfmt+0x230>
				putch(' ', putdat);
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	53                   	push   %ebx
  8019d0:	6a 20                	push   $0x20
  8019d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019d4:	83 ef 01             	sub    $0x1,%edi
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	85 ff                	test   %edi,%edi
  8019dc:	7f ee                	jg     8019cc <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8019de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8019e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8019e4:	e9 67 01 00 00       	jmp    801b50 <vprintfmt+0x3a6>
  8019e9:	89 cf                	mov    %ecx,%edi
  8019eb:	eb ed                	jmp    8019da <vprintfmt+0x230>
	if (lflag >= 2)
  8019ed:	83 f9 01             	cmp    $0x1,%ecx
  8019f0:	7f 1b                	jg     801a0d <vprintfmt+0x263>
	else if (lflag)
  8019f2:	85 c9                	test   %ecx,%ecx
  8019f4:	74 63                	je     801a59 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8019f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019fe:	99                   	cltd   
  8019ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a02:	8b 45 14             	mov    0x14(%ebp),%eax
  801a05:	8d 40 04             	lea    0x4(%eax),%eax
  801a08:	89 45 14             	mov    %eax,0x14(%ebp)
  801a0b:	eb 17                	jmp    801a24 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a10:	8b 50 04             	mov    0x4(%eax),%edx
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a18:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1e:	8d 40 08             	lea    0x8(%eax),%eax
  801a21:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a24:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a27:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a2a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a2f:	85 c9                	test   %ecx,%ecx
  801a31:	0f 89 ff 00 00 00    	jns    801b36 <vprintfmt+0x38c>
				putch('-', putdat);
  801a37:	83 ec 08             	sub    $0x8,%esp
  801a3a:	53                   	push   %ebx
  801a3b:	6a 2d                	push   $0x2d
  801a3d:	ff d6                	call   *%esi
				num = -(long long) num;
  801a3f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a42:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a45:	f7 da                	neg    %edx
  801a47:	83 d1 00             	adc    $0x0,%ecx
  801a4a:	f7 d9                	neg    %ecx
  801a4c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a54:	e9 dd 00 00 00       	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a59:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5c:	8b 00                	mov    (%eax),%eax
  801a5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a61:	99                   	cltd   
  801a62:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a65:	8b 45 14             	mov    0x14(%ebp),%eax
  801a68:	8d 40 04             	lea    0x4(%eax),%eax
  801a6b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a6e:	eb b4                	jmp    801a24 <vprintfmt+0x27a>
	if (lflag >= 2)
  801a70:	83 f9 01             	cmp    $0x1,%ecx
  801a73:	7f 1e                	jg     801a93 <vprintfmt+0x2e9>
	else if (lflag)
  801a75:	85 c9                	test   %ecx,%ecx
  801a77:	74 32                	je     801aab <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 10                	mov    (%eax),%edx
  801a7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a83:	8d 40 04             	lea    0x4(%eax),%eax
  801a86:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801a89:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801a8e:	e9 a3 00 00 00       	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	8b 10                	mov    (%eax),%edx
  801a98:	8b 48 04             	mov    0x4(%eax),%ecx
  801a9b:	8d 40 08             	lea    0x8(%eax),%eax
  801a9e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801aa1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801aa6:	e9 8b 00 00 00       	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801aab:	8b 45 14             	mov    0x14(%ebp),%eax
  801aae:	8b 10                	mov    (%eax),%edx
  801ab0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab5:	8d 40 04             	lea    0x4(%eax),%eax
  801ab8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801abb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801ac0:	eb 74                	jmp    801b36 <vprintfmt+0x38c>
	if (lflag >= 2)
  801ac2:	83 f9 01             	cmp    $0x1,%ecx
  801ac5:	7f 1b                	jg     801ae2 <vprintfmt+0x338>
	else if (lflag)
  801ac7:	85 c9                	test   %ecx,%ecx
  801ac9:	74 2c                	je     801af7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801acb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ace:	8b 10                	mov    (%eax),%edx
  801ad0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ad5:	8d 40 04             	lea    0x4(%eax),%eax
  801ad8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801adb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801ae0:	eb 54                	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae5:	8b 10                	mov    (%eax),%edx
  801ae7:	8b 48 04             	mov    0x4(%eax),%ecx
  801aea:	8d 40 08             	lea    0x8(%eax),%eax
  801aed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801af0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801af5:	eb 3f                	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	8b 10                	mov    (%eax),%edx
  801afc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b01:	8d 40 04             	lea    0x4(%eax),%eax
  801b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b07:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b0c:	eb 28                	jmp    801b36 <vprintfmt+0x38c>
			putch('0', putdat);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	53                   	push   %ebx
  801b12:	6a 30                	push   $0x30
  801b14:	ff d6                	call   *%esi
			putch('x', putdat);
  801b16:	83 c4 08             	add    $0x8,%esp
  801b19:	53                   	push   %ebx
  801b1a:	6a 78                	push   $0x78
  801b1c:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 10                	mov    (%eax),%edx
  801b23:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b28:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b2b:	8d 40 04             	lea    0x4(%eax),%eax
  801b2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b31:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b3d:	57                   	push   %edi
  801b3e:	ff 75 e0             	pushl  -0x20(%ebp)
  801b41:	50                   	push   %eax
  801b42:	51                   	push   %ecx
  801b43:	52                   	push   %edx
  801b44:	89 da                	mov    %ebx,%edx
  801b46:	89 f0                	mov    %esi,%eax
  801b48:	e8 72 fb ff ff       	call   8016bf <printnum>
			break;
  801b4d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b50:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b53:	83 c7 01             	add    $0x1,%edi
  801b56:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b5a:	83 f8 25             	cmp    $0x25,%eax
  801b5d:	0f 84 62 fc ff ff    	je     8017c5 <vprintfmt+0x1b>
			if (ch == '\0')
  801b63:	85 c0                	test   %eax,%eax
  801b65:	0f 84 8b 00 00 00    	je     801bf6 <vprintfmt+0x44c>
			putch(ch, putdat);
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	53                   	push   %ebx
  801b6f:	50                   	push   %eax
  801b70:	ff d6                	call   *%esi
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	eb dc                	jmp    801b53 <vprintfmt+0x3a9>
	if (lflag >= 2)
  801b77:	83 f9 01             	cmp    $0x1,%ecx
  801b7a:	7f 1b                	jg     801b97 <vprintfmt+0x3ed>
	else if (lflag)
  801b7c:	85 c9                	test   %ecx,%ecx
  801b7e:	74 2c                	je     801bac <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801b80:	8b 45 14             	mov    0x14(%ebp),%eax
  801b83:	8b 10                	mov    (%eax),%edx
  801b85:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b8a:	8d 40 04             	lea    0x4(%eax),%eax
  801b8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b90:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801b95:	eb 9f                	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b97:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9a:	8b 10                	mov    (%eax),%edx
  801b9c:	8b 48 04             	mov    0x4(%eax),%ecx
  801b9f:	8d 40 08             	lea    0x8(%eax),%eax
  801ba2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ba5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801baa:	eb 8a                	jmp    801b36 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801bac:	8b 45 14             	mov    0x14(%ebp),%eax
  801baf:	8b 10                	mov    (%eax),%edx
  801bb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb6:	8d 40 04             	lea    0x4(%eax),%eax
  801bb9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bbc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801bc1:	e9 70 ff ff ff       	jmp    801b36 <vprintfmt+0x38c>
			putch(ch, putdat);
  801bc6:	83 ec 08             	sub    $0x8,%esp
  801bc9:	53                   	push   %ebx
  801bca:	6a 25                	push   $0x25
  801bcc:	ff d6                	call   *%esi
			break;
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	e9 7a ff ff ff       	jmp    801b50 <vprintfmt+0x3a6>
			putch('%', putdat);
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	53                   	push   %ebx
  801bda:	6a 25                	push   $0x25
  801bdc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	89 f8                	mov    %edi,%eax
  801be3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801be7:	74 05                	je     801bee <vprintfmt+0x444>
  801be9:	83 e8 01             	sub    $0x1,%eax
  801bec:	eb f5                	jmp    801be3 <vprintfmt+0x439>
  801bee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bf1:	e9 5a ff ff ff       	jmp    801b50 <vprintfmt+0x3a6>
}
  801bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5f                   	pop    %edi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    

00801bfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801bfe:	f3 0f 1e fb          	endbr32 
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 18             	sub    $0x18,%esp
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c11:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	74 26                	je     801c49 <vsnprintf+0x4b>
  801c23:	85 d2                	test   %edx,%edx
  801c25:	7e 22                	jle    801c49 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c27:	ff 75 14             	pushl  0x14(%ebp)
  801c2a:	ff 75 10             	pushl  0x10(%ebp)
  801c2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c30:	50                   	push   %eax
  801c31:	68 68 17 80 00       	push   $0x801768
  801c36:	e8 6f fb ff ff       	call   8017aa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c44:	83 c4 10             	add    $0x10,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    
		return -E_INVAL;
  801c49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c4e:	eb f7                	jmp    801c47 <vsnprintf+0x49>

00801c50 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c50:	f3 0f 1e fb          	endbr32 
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c5a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c5d:	50                   	push   %eax
  801c5e:	ff 75 10             	pushl  0x10(%ebp)
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	e8 92 ff ff ff       	call   801bfe <vsnprintf>
	va_end(ap);

	return rc;
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c6e:	f3 0f 1e fb          	endbr32 
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801c81:	74 05                	je     801c88 <strlen+0x1a>
		n++;
  801c83:	83 c0 01             	add    $0x1,%eax
  801c86:	eb f5                	jmp    801c7d <strlen+0xf>
	return n;
}
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801c8a:	f3 0f 1e fb          	endbr32 
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9c:	39 d0                	cmp    %edx,%eax
  801c9e:	74 0d                	je     801cad <strnlen+0x23>
  801ca0:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ca4:	74 05                	je     801cab <strnlen+0x21>
		n++;
  801ca6:	83 c0 01             	add    $0x1,%eax
  801ca9:	eb f1                	jmp    801c9c <strnlen+0x12>
  801cab:	89 c2                	mov    %eax,%edx
	return n;
}
  801cad:	89 d0                	mov    %edx,%eax
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    

00801cb1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cb1:	f3 0f 1e fb          	endbr32 
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	53                   	push   %ebx
  801cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cc8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801ccb:	83 c0 01             	add    $0x1,%eax
  801cce:	84 d2                	test   %dl,%dl
  801cd0:	75 f2                	jne    801cc4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cd2:	89 c8                	mov    %ecx,%eax
  801cd4:	5b                   	pop    %ebx
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    

00801cd7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801cd7:	f3 0f 1e fb          	endbr32 
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 10             	sub    $0x10,%esp
  801ce2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ce5:	53                   	push   %ebx
  801ce6:	e8 83 ff ff ff       	call   801c6e <strlen>
  801ceb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	01 d8                	add    %ebx,%eax
  801cf3:	50                   	push   %eax
  801cf4:	e8 b8 ff ff ff       	call   801cb1 <strcpy>
	return dst;
}
  801cf9:	89 d8                	mov    %ebx,%eax
  801cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d00:	f3 0f 1e fb          	endbr32 
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	8b 75 08             	mov    0x8(%ebp),%esi
  801d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0f:	89 f3                	mov    %esi,%ebx
  801d11:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d14:	89 f0                	mov    %esi,%eax
  801d16:	39 d8                	cmp    %ebx,%eax
  801d18:	74 11                	je     801d2b <strncpy+0x2b>
		*dst++ = *src;
  801d1a:	83 c0 01             	add    $0x1,%eax
  801d1d:	0f b6 0a             	movzbl (%edx),%ecx
  801d20:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d23:	80 f9 01             	cmp    $0x1,%cl
  801d26:	83 da ff             	sbb    $0xffffffff,%edx
  801d29:	eb eb                	jmp    801d16 <strncpy+0x16>
	}
	return ret;
}
  801d2b:	89 f0                	mov    %esi,%eax
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d31:	f3 0f 1e fb          	endbr32 
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	8b 75 08             	mov    0x8(%ebp),%esi
  801d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d40:	8b 55 10             	mov    0x10(%ebp),%edx
  801d43:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d45:	85 d2                	test   %edx,%edx
  801d47:	74 21                	je     801d6a <strlcpy+0x39>
  801d49:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d4d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d4f:	39 c2                	cmp    %eax,%edx
  801d51:	74 14                	je     801d67 <strlcpy+0x36>
  801d53:	0f b6 19             	movzbl (%ecx),%ebx
  801d56:	84 db                	test   %bl,%bl
  801d58:	74 0b                	je     801d65 <strlcpy+0x34>
			*dst++ = *src++;
  801d5a:	83 c1 01             	add    $0x1,%ecx
  801d5d:	83 c2 01             	add    $0x1,%edx
  801d60:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d63:	eb ea                	jmp    801d4f <strlcpy+0x1e>
  801d65:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d67:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d6a:	29 f0                	sub    %esi,%eax
}
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d70:	f3 0f 1e fb          	endbr32 
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801d7d:	0f b6 01             	movzbl (%ecx),%eax
  801d80:	84 c0                	test   %al,%al
  801d82:	74 0c                	je     801d90 <strcmp+0x20>
  801d84:	3a 02                	cmp    (%edx),%al
  801d86:	75 08                	jne    801d90 <strcmp+0x20>
		p++, q++;
  801d88:	83 c1 01             	add    $0x1,%ecx
  801d8b:	83 c2 01             	add    $0x1,%edx
  801d8e:	eb ed                	jmp    801d7d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d90:	0f b6 c0             	movzbl %al,%eax
  801d93:	0f b6 12             	movzbl (%edx),%edx
  801d96:	29 d0                	sub    %edx,%eax
}
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801d9a:	f3 0f 1e fb          	endbr32 
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	53                   	push   %ebx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801dad:	eb 06                	jmp    801db5 <strncmp+0x1b>
		n--, p++, q++;
  801daf:	83 c0 01             	add    $0x1,%eax
  801db2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801db5:	39 d8                	cmp    %ebx,%eax
  801db7:	74 16                	je     801dcf <strncmp+0x35>
  801db9:	0f b6 08             	movzbl (%eax),%ecx
  801dbc:	84 c9                	test   %cl,%cl
  801dbe:	74 04                	je     801dc4 <strncmp+0x2a>
  801dc0:	3a 0a                	cmp    (%edx),%cl
  801dc2:	74 eb                	je     801daf <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dc4:	0f b6 00             	movzbl (%eax),%eax
  801dc7:	0f b6 12             	movzbl (%edx),%edx
  801dca:	29 d0                	sub    %edx,%eax
}
  801dcc:	5b                   	pop    %ebx
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	eb f6                	jmp    801dcc <strncmp+0x32>

00801dd6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801dd6:	f3 0f 1e fb          	endbr32 
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801de4:	0f b6 10             	movzbl (%eax),%edx
  801de7:	84 d2                	test   %dl,%dl
  801de9:	74 09                	je     801df4 <strchr+0x1e>
		if (*s == c)
  801deb:	38 ca                	cmp    %cl,%dl
  801ded:	74 0a                	je     801df9 <strchr+0x23>
	for (; *s; s++)
  801def:	83 c0 01             	add    $0x1,%eax
  801df2:	eb f0                	jmp    801de4 <strchr+0xe>
			return (char *) s;
	return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df9:	5d                   	pop    %ebp
  801dfa:	c3                   	ret    

00801dfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801dfb:	f3 0f 1e fb          	endbr32 
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e09:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e0c:	38 ca                	cmp    %cl,%dl
  801e0e:	74 09                	je     801e19 <strfind+0x1e>
  801e10:	84 d2                	test   %dl,%dl
  801e12:	74 05                	je     801e19 <strfind+0x1e>
	for (; *s; s++)
  801e14:	83 c0 01             	add    $0x1,%eax
  801e17:	eb f0                	jmp    801e09 <strfind+0xe>
			break;
	return (char *) s;
}
  801e19:	5d                   	pop    %ebp
  801e1a:	c3                   	ret    

00801e1b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e1b:	f3 0f 1e fb          	endbr32 
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e2b:	85 c9                	test   %ecx,%ecx
  801e2d:	74 31                	je     801e60 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e2f:	89 f8                	mov    %edi,%eax
  801e31:	09 c8                	or     %ecx,%eax
  801e33:	a8 03                	test   $0x3,%al
  801e35:	75 23                	jne    801e5a <memset+0x3f>
		c &= 0xFF;
  801e37:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e3b:	89 d3                	mov    %edx,%ebx
  801e3d:	c1 e3 08             	shl    $0x8,%ebx
  801e40:	89 d0                	mov    %edx,%eax
  801e42:	c1 e0 18             	shl    $0x18,%eax
  801e45:	89 d6                	mov    %edx,%esi
  801e47:	c1 e6 10             	shl    $0x10,%esi
  801e4a:	09 f0                	or     %esi,%eax
  801e4c:	09 c2                	or     %eax,%edx
  801e4e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e50:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e53:	89 d0                	mov    %edx,%eax
  801e55:	fc                   	cld    
  801e56:	f3 ab                	rep stos %eax,%es:(%edi)
  801e58:	eb 06                	jmp    801e60 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	fc                   	cld    
  801e5e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e60:	89 f8                	mov    %edi,%eax
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5f                   	pop    %edi
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e67:	f3 0f 1e fb          	endbr32 
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	57                   	push   %edi
  801e6f:	56                   	push   %esi
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e79:	39 c6                	cmp    %eax,%esi
  801e7b:	73 32                	jae    801eaf <memmove+0x48>
  801e7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801e80:	39 c2                	cmp    %eax,%edx
  801e82:	76 2b                	jbe    801eaf <memmove+0x48>
		s += n;
		d += n;
  801e84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801e87:	89 fe                	mov    %edi,%esi
  801e89:	09 ce                	or     %ecx,%esi
  801e8b:	09 d6                	or     %edx,%esi
  801e8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801e93:	75 0e                	jne    801ea3 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801e95:	83 ef 04             	sub    $0x4,%edi
  801e98:	8d 72 fc             	lea    -0x4(%edx),%esi
  801e9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801e9e:	fd                   	std    
  801e9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ea1:	eb 09                	jmp    801eac <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ea3:	83 ef 01             	sub    $0x1,%edi
  801ea6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801ea9:	fd                   	std    
  801eaa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801eac:	fc                   	cld    
  801ead:	eb 1a                	jmp    801ec9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801eaf:	89 c2                	mov    %eax,%edx
  801eb1:	09 ca                	or     %ecx,%edx
  801eb3:	09 f2                	or     %esi,%edx
  801eb5:	f6 c2 03             	test   $0x3,%dl
  801eb8:	75 0a                	jne    801ec4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801eba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ebd:	89 c7                	mov    %eax,%edi
  801ebf:	fc                   	cld    
  801ec0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ec2:	eb 05                	jmp    801ec9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801ec4:	89 c7                	mov    %eax,%edi
  801ec6:	fc                   	cld    
  801ec7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    

00801ecd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ecd:	f3 0f 1e fb          	endbr32 
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ed7:	ff 75 10             	pushl  0x10(%ebp)
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	ff 75 08             	pushl  0x8(%ebp)
  801ee0:	e8 82 ff ff ff       	call   801e67 <memmove>
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801ee7:	f3 0f 1e fb          	endbr32 
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	89 c6                	mov    %eax,%esi
  801ef8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801efb:	39 f0                	cmp    %esi,%eax
  801efd:	74 1c                	je     801f1b <memcmp+0x34>
		if (*s1 != *s2)
  801eff:	0f b6 08             	movzbl (%eax),%ecx
  801f02:	0f b6 1a             	movzbl (%edx),%ebx
  801f05:	38 d9                	cmp    %bl,%cl
  801f07:	75 08                	jne    801f11 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f09:	83 c0 01             	add    $0x1,%eax
  801f0c:	83 c2 01             	add    $0x1,%edx
  801f0f:	eb ea                	jmp    801efb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f11:	0f b6 c1             	movzbl %cl,%eax
  801f14:	0f b6 db             	movzbl %bl,%ebx
  801f17:	29 d8                	sub    %ebx,%eax
  801f19:	eb 05                	jmp    801f20 <memcmp+0x39>
	}

	return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f24:	f3 0f 1e fb          	endbr32 
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f31:	89 c2                	mov    %eax,%edx
  801f33:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f36:	39 d0                	cmp    %edx,%eax
  801f38:	73 09                	jae    801f43 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f3a:	38 08                	cmp    %cl,(%eax)
  801f3c:	74 05                	je     801f43 <memfind+0x1f>
	for (; s < ends; s++)
  801f3e:	83 c0 01             	add    $0x1,%eax
  801f41:	eb f3                	jmp    801f36 <memfind+0x12>
			break;
	return (void *) s;
}
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    

00801f45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f45:	f3 0f 1e fb          	endbr32 
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	57                   	push   %edi
  801f4d:	56                   	push   %esi
  801f4e:	53                   	push   %ebx
  801f4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f55:	eb 03                	jmp    801f5a <strtol+0x15>
		s++;
  801f57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f5a:	0f b6 01             	movzbl (%ecx),%eax
  801f5d:	3c 20                	cmp    $0x20,%al
  801f5f:	74 f6                	je     801f57 <strtol+0x12>
  801f61:	3c 09                	cmp    $0x9,%al
  801f63:	74 f2                	je     801f57 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f65:	3c 2b                	cmp    $0x2b,%al
  801f67:	74 2a                	je     801f93 <strtol+0x4e>
	int neg = 0;
  801f69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f6e:	3c 2d                	cmp    $0x2d,%al
  801f70:	74 2b                	je     801f9d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801f78:	75 0f                	jne    801f89 <strtol+0x44>
  801f7a:	80 39 30             	cmpb   $0x30,(%ecx)
  801f7d:	74 28                	je     801fa7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801f7f:	85 db                	test   %ebx,%ebx
  801f81:	b8 0a 00 00 00       	mov    $0xa,%eax
  801f86:	0f 44 d8             	cmove  %eax,%ebx
  801f89:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801f91:	eb 46                	jmp    801fd9 <strtol+0x94>
		s++;
  801f93:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801f96:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9b:	eb d5                	jmp    801f72 <strtol+0x2d>
		s++, neg = 1;
  801f9d:	83 c1 01             	add    $0x1,%ecx
  801fa0:	bf 01 00 00 00       	mov    $0x1,%edi
  801fa5:	eb cb                	jmp    801f72 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fa7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801fab:	74 0e                	je     801fbb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801fad:	85 db                	test   %ebx,%ebx
  801faf:	75 d8                	jne    801f89 <strtol+0x44>
		s++, base = 8;
  801fb1:	83 c1 01             	add    $0x1,%ecx
  801fb4:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fb9:	eb ce                	jmp    801f89 <strtol+0x44>
		s += 2, base = 16;
  801fbb:	83 c1 02             	add    $0x2,%ecx
  801fbe:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fc3:	eb c4                	jmp    801f89 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fc5:	0f be d2             	movsbl %dl,%edx
  801fc8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801fcb:	3b 55 10             	cmp    0x10(%ebp),%edx
  801fce:	7d 3a                	jge    80200a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801fd0:	83 c1 01             	add    $0x1,%ecx
  801fd3:	0f af 45 10          	imul   0x10(%ebp),%eax
  801fd7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801fd9:	0f b6 11             	movzbl (%ecx),%edx
  801fdc:	8d 72 d0             	lea    -0x30(%edx),%esi
  801fdf:	89 f3                	mov    %esi,%ebx
  801fe1:	80 fb 09             	cmp    $0x9,%bl
  801fe4:	76 df                	jbe    801fc5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801fe6:	8d 72 9f             	lea    -0x61(%edx),%esi
  801fe9:	89 f3                	mov    %esi,%ebx
  801feb:	80 fb 19             	cmp    $0x19,%bl
  801fee:	77 08                	ja     801ff8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801ff0:	0f be d2             	movsbl %dl,%edx
  801ff3:	83 ea 57             	sub    $0x57,%edx
  801ff6:	eb d3                	jmp    801fcb <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801ff8:	8d 72 bf             	lea    -0x41(%edx),%esi
  801ffb:	89 f3                	mov    %esi,%ebx
  801ffd:	80 fb 19             	cmp    $0x19,%bl
  802000:	77 08                	ja     80200a <strtol+0xc5>
			dig = *s - 'A' + 10;
  802002:	0f be d2             	movsbl %dl,%edx
  802005:	83 ea 37             	sub    $0x37,%edx
  802008:	eb c1                	jmp    801fcb <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80200a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80200e:	74 05                	je     802015 <strtol+0xd0>
		*endptr = (char *) s;
  802010:	8b 75 0c             	mov    0xc(%ebp),%esi
  802013:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802015:	89 c2                	mov    %eax,%edx
  802017:	f7 da                	neg    %edx
  802019:	85 ff                	test   %edi,%edi
  80201b:	0f 45 c2             	cmovne %edx,%eax
}
  80201e:	5b                   	pop    %ebx
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    

00802023 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802023:	f3 0f 1e fb          	endbr32 
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	8b 75 08             	mov    0x8(%ebp),%esi
  80202f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802032:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802035:	83 e8 01             	sub    $0x1,%eax
  802038:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80203d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802042:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	50                   	push   %eax
  80204a:	e8 07 e3 ff ff       	call   800356 <sys_ipc_recv>
	if (!t) {
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	85 c0                	test   %eax,%eax
  802054:	75 2b                	jne    802081 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802056:	85 f6                	test   %esi,%esi
  802058:	74 0a                	je     802064 <ipc_recv+0x41>
  80205a:	a1 08 40 80 00       	mov    0x804008,%eax
  80205f:	8b 40 74             	mov    0x74(%eax),%eax
  802062:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802064:	85 db                	test   %ebx,%ebx
  802066:	74 0a                	je     802072 <ipc_recv+0x4f>
  802068:	a1 08 40 80 00       	mov    0x804008,%eax
  80206d:	8b 40 78             	mov    0x78(%eax),%eax
  802070:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802072:	a1 08 40 80 00       	mov    0x804008,%eax
  802077:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80207a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207d:	5b                   	pop    %ebx
  80207e:	5e                   	pop    %esi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802081:	85 f6                	test   %esi,%esi
  802083:	74 06                	je     80208b <ipc_recv+0x68>
  802085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80208b:	85 db                	test   %ebx,%ebx
  80208d:	74 eb                	je     80207a <ipc_recv+0x57>
  80208f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802095:	eb e3                	jmp    80207a <ipc_recv+0x57>

00802097 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802097:	f3 0f 1e fb          	endbr32 
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	57                   	push   %edi
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020ad:	85 db                	test   %ebx,%ebx
  8020af:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b4:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020b7:	ff 75 14             	pushl  0x14(%ebp)
  8020ba:	53                   	push   %ebx
  8020bb:	56                   	push   %esi
  8020bc:	57                   	push   %edi
  8020bd:	e8 6d e2 ff ff       	call   80032f <sys_ipc_try_send>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	74 1e                	je     8020e7 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020cc:	75 07                	jne    8020d5 <ipc_send+0x3e>
		sys_yield();
  8020ce:	e8 94 e0 ff ff       	call   800167 <sys_yield>
  8020d3:	eb e2                	jmp    8020b7 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020d5:	50                   	push   %eax
  8020d6:	68 7f 28 80 00       	push   $0x80287f
  8020db:	6a 39                	push   $0x39
  8020dd:	68 91 28 80 00       	push   $0x802891
  8020e2:	e8 d9 f4 ff ff       	call   8015c0 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ea:	5b                   	pop    %ebx
  8020eb:	5e                   	pop    %esi
  8020ec:	5f                   	pop    %edi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020ef:	f3 0f 1e fb          	endbr32 
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020fe:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802101:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802107:	8b 52 50             	mov    0x50(%edx),%edx
  80210a:	39 ca                	cmp    %ecx,%edx
  80210c:	74 11                	je     80211f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80210e:	83 c0 01             	add    $0x1,%eax
  802111:	3d 00 04 00 00       	cmp    $0x400,%eax
  802116:	75 e6                	jne    8020fe <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	eb 0b                	jmp    80212a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80211f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802122:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802127:	8b 40 48             	mov    0x48(%eax),%eax
}
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80212c:	f3 0f 1e fb          	endbr32 
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802136:	89 c2                	mov    %eax,%edx
  802138:	c1 ea 16             	shr    $0x16,%edx
  80213b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802142:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802147:	f6 c1 01             	test   $0x1,%cl
  80214a:	74 1c                	je     802168 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80214c:	c1 e8 0c             	shr    $0xc,%eax
  80214f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802156:	a8 01                	test   $0x1,%al
  802158:	74 0e                	je     802168 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80215a:	c1 e8 0c             	shr    $0xc,%eax
  80215d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802164:	ef 
  802165:	0f b7 d2             	movzwl %dx,%edx
}
  802168:	89 d0                	mov    %edx,%eax
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
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
