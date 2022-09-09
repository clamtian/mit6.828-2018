
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 27 00 00 00       	call   800058 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80003d:	68 c4 03 80 00       	push   $0x8003c4
  800042:	6a 00                	push   $0x0
  800044:	e8 a6 02 00 00       	call   8002ef <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800049:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800050:	00 00 00 
}
  800053:	83 c4 10             	add    $0x10,%esp
  800056:	c9                   	leave  
  800057:	c3                   	ret    

00800058 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800058:	f3 0f 1e fb          	endbr32 
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800067:	e8 de 00 00 00       	call   80014a <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 db                	test   %ebx,%ebx
  800080:	7e 07                	jle    800089 <libmain+0x31>
		binaryname = argv[0];
  800082:	8b 06                	mov    (%esi),%eax
  800084:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	56                   	push   %esi
  80008d:	53                   	push   %ebx
  80008e:	e8 a0 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800093:	e8 0a 00 00 00       	call   8000a2 <exit>
}
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5e                   	pop    %esi
  8000a0:	5d                   	pop    %ebp
  8000a1:	c3                   	ret    

008000a2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a2:	f3 0f 1e fb          	endbr32 
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 2b 05 00 00       	call   8005dc <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 4a 00 00 00       	call   800105 <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c0:	f3 0f 1e fb          	endbr32 
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d5:	89 c3                	mov    %eax,%ebx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 c6                	mov    %eax,%esi
  8000db:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e2:	f3 0f 1e fb          	endbr32 
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	57                   	push   %edi
  8000ea:	56                   	push   %esi
  8000eb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f6:	89 d1                	mov    %edx,%ecx
  8000f8:	89 d3                	mov    %edx,%ebx
  8000fa:	89 d7                	mov    %edx,%edi
  8000fc:	89 d6                	mov    %edx,%esi
  8000fe:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5f                   	pop    %edi
  800103:	5d                   	pop    %ebp
  800104:	c3                   	ret    

00800105 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800105:	f3 0f 1e fb          	endbr32 
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	57                   	push   %edi
  80010d:	56                   	push   %esi
  80010e:	53                   	push   %ebx
  80010f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800112:	b9 00 00 00 00       	mov    $0x0,%ecx
  800117:	8b 55 08             	mov    0x8(%ebp),%edx
  80011a:	b8 03 00 00 00       	mov    $0x3,%eax
  80011f:	89 cb                	mov    %ecx,%ebx
  800121:	89 cf                	mov    %ecx,%edi
  800123:	89 ce                	mov    %ecx,%esi
  800125:	cd 30                	int    $0x30
	if(check && ret > 0)
  800127:	85 c0                	test   %eax,%eax
  800129:	7f 08                	jg     800133 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5f                   	pop    %edi
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	6a 03                	push   $0x3
  800139:	68 8a 24 80 00       	push   $0x80248a
  80013e:	6a 23                	push   $0x23
  800140:	68 a7 24 80 00       	push   $0x8024a7
  800145:	e8 a0 14 00 00       	call   8015ea <_panic>

0080014a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014a:	f3 0f 1e fb          	endbr32 
  80014e:	55                   	push   %ebp
  80014f:	89 e5                	mov    %esp,%ebp
  800151:	57                   	push   %edi
  800152:	56                   	push   %esi
  800153:	53                   	push   %ebx
	asm volatile("int %1\n"
  800154:	ba 00 00 00 00       	mov    $0x0,%edx
  800159:	b8 02 00 00 00       	mov    $0x2,%eax
  80015e:	89 d1                	mov    %edx,%ecx
  800160:	89 d3                	mov    %edx,%ebx
  800162:	89 d7                	mov    %edx,%edi
  800164:	89 d6                	mov    %edx,%esi
  800166:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5f                   	pop    %edi
  80016b:	5d                   	pop    %ebp
  80016c:	c3                   	ret    

0080016d <sys_yield>:

void
sys_yield(void)
{
  80016d:	f3 0f 1e fb          	endbr32 
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	57                   	push   %edi
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
	asm volatile("int %1\n"
  800177:	ba 00 00 00 00       	mov    $0x0,%edx
  80017c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800181:	89 d1                	mov    %edx,%ecx
  800183:	89 d3                	mov    %edx,%ebx
  800185:	89 d7                	mov    %edx,%edi
  800187:	89 d6                	mov    %edx,%esi
  800189:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5f                   	pop    %edi
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800190:	f3 0f 1e fb          	endbr32 
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	53                   	push   %ebx
  80019a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80019d:	be 00 00 00 00       	mov    $0x0,%esi
  8001a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a8:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b0:	89 f7                	mov    %esi,%edi
  8001b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	7f 08                	jg     8001c0 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	6a 04                	push   $0x4
  8001c6:	68 8a 24 80 00       	push   $0x80248a
  8001cb:	6a 23                	push   $0x23
  8001cd:	68 a7 24 80 00       	push   $0x8024a7
  8001d2:	e8 13 14 00 00       	call   8015ea <_panic>

008001d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d7:	f3 0f 1e fb          	endbr32 
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
  8001de:	57                   	push   %edi
  8001df:	56                   	push   %esi
  8001e0:	53                   	push   %ebx
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fa:	85 c0                	test   %eax,%eax
  8001fc:	7f 08                	jg     800206 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	50                   	push   %eax
  80020a:	6a 05                	push   $0x5
  80020c:	68 8a 24 80 00       	push   $0x80248a
  800211:	6a 23                	push   $0x23
  800213:	68 a7 24 80 00       	push   $0x8024a7
  800218:	e8 cd 13 00 00       	call   8015ea <_panic>

0080021d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80021d:	f3 0f 1e fb          	endbr32 
  800221:	55                   	push   %ebp
  800222:	89 e5                	mov    %esp,%ebp
  800224:	57                   	push   %edi
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022f:	8b 55 08             	mov    0x8(%ebp),%edx
  800232:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800235:	b8 06 00 00 00       	mov    $0x6,%eax
  80023a:	89 df                	mov    %ebx,%edi
  80023c:	89 de                	mov    %ebx,%esi
  80023e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800240:	85 c0                	test   %eax,%eax
  800242:	7f 08                	jg     80024c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	50                   	push   %eax
  800250:	6a 06                	push   $0x6
  800252:	68 8a 24 80 00       	push   $0x80248a
  800257:	6a 23                	push   $0x23
  800259:	68 a7 24 80 00       	push   $0x8024a7
  80025e:	e8 87 13 00 00       	call   8015ea <_panic>

00800263 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800263:	f3 0f 1e fb          	endbr32 
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	57                   	push   %edi
  80026b:	56                   	push   %esi
  80026c:	53                   	push   %ebx
  80026d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800270:	bb 00 00 00 00       	mov    $0x0,%ebx
  800275:	8b 55 08             	mov    0x8(%ebp),%edx
  800278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027b:	b8 08 00 00 00       	mov    $0x8,%eax
  800280:	89 df                	mov    %ebx,%edi
  800282:	89 de                	mov    %ebx,%esi
  800284:	cd 30                	int    $0x30
	if(check && ret > 0)
  800286:	85 c0                	test   %eax,%eax
  800288:	7f 08                	jg     800292 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80028a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	50                   	push   %eax
  800296:	6a 08                	push   $0x8
  800298:	68 8a 24 80 00       	push   $0x80248a
  80029d:	6a 23                	push   $0x23
  80029f:	68 a7 24 80 00       	push   $0x8024a7
  8002a4:	e8 41 13 00 00       	call   8015ea <_panic>

008002a9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a9:	f3 0f 1e fb          	endbr32 
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	57                   	push   %edi
  8002b1:	56                   	push   %esi
  8002b2:	53                   	push   %ebx
  8002b3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c6:	89 df                	mov    %ebx,%edi
  8002c8:	89 de                	mov    %ebx,%esi
  8002ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	7f 08                	jg     8002d8 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d3:	5b                   	pop    %ebx
  8002d4:	5e                   	pop    %esi
  8002d5:	5f                   	pop    %edi
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	50                   	push   %eax
  8002dc:	6a 09                	push   $0x9
  8002de:	68 8a 24 80 00       	push   $0x80248a
  8002e3:	6a 23                	push   $0x23
  8002e5:	68 a7 24 80 00       	push   $0x8024a7
  8002ea:	e8 fb 12 00 00       	call   8015ea <_panic>

008002ef <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002ef:	f3 0f 1e fb          	endbr32 
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800301:	8b 55 08             	mov    0x8(%ebp),%edx
  800304:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800307:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030c:	89 df                	mov    %ebx,%edi
  80030e:	89 de                	mov    %ebx,%esi
  800310:	cd 30                	int    $0x30
	if(check && ret > 0)
  800312:	85 c0                	test   %eax,%eax
  800314:	7f 08                	jg     80031e <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800316:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800319:	5b                   	pop    %ebx
  80031a:	5e                   	pop    %esi
  80031b:	5f                   	pop    %edi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031e:	83 ec 0c             	sub    $0xc,%esp
  800321:	50                   	push   %eax
  800322:	6a 0a                	push   $0xa
  800324:	68 8a 24 80 00       	push   $0x80248a
  800329:	6a 23                	push   $0x23
  80032b:	68 a7 24 80 00       	push   $0x8024a7
  800330:	e8 b5 12 00 00       	call   8015ea <_panic>

00800335 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800335:	f3 0f 1e fb          	endbr32 
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	57                   	push   %edi
  80033d:	56                   	push   %esi
  80033e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80033f:	8b 55 08             	mov    0x8(%ebp),%edx
  800342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800345:	b8 0c 00 00 00       	mov    $0xc,%eax
  80034a:	be 00 00 00 00       	mov    $0x0,%esi
  80034f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800352:	8b 7d 14             	mov    0x14(%ebp),%edi
  800355:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800357:	5b                   	pop    %ebx
  800358:	5e                   	pop    %esi
  800359:	5f                   	pop    %edi
  80035a:	5d                   	pop    %ebp
  80035b:	c3                   	ret    

0080035c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035c:	f3 0f 1e fb          	endbr32 
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800369:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	b8 0d 00 00 00       	mov    $0xd,%eax
  800376:	89 cb                	mov    %ecx,%ebx
  800378:	89 cf                	mov    %ecx,%edi
  80037a:	89 ce                	mov    %ecx,%esi
  80037c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037e:	85 c0                	test   %eax,%eax
  800380:	7f 08                	jg     80038a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800382:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800385:	5b                   	pop    %ebx
  800386:	5e                   	pop    %esi
  800387:	5f                   	pop    %edi
  800388:	5d                   	pop    %ebp
  800389:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80038a:	83 ec 0c             	sub    $0xc,%esp
  80038d:	50                   	push   %eax
  80038e:	6a 0d                	push   $0xd
  800390:	68 8a 24 80 00       	push   $0x80248a
  800395:	6a 23                	push   $0x23
  800397:	68 a7 24 80 00       	push   $0x8024a7
  80039c:	e8 49 12 00 00       	call   8015ea <_panic>

008003a1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003a1:	f3 0f 1e fb          	endbr32 
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	57                   	push   %edi
  8003a9:	56                   	push   %esi
  8003aa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b0:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003b5:	89 d1                	mov    %edx,%ecx
  8003b7:	89 d3                	mov    %edx,%ebx
  8003b9:	89 d7                	mov    %edx,%edi
  8003bb:	89 d6                	mov    %edx,%esi
  8003bd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003bf:	5b                   	pop    %ebx
  8003c0:	5e                   	pop    %esi
  8003c1:	5f                   	pop    %edi
  8003c2:	5d                   	pop    %ebp
  8003c3:	c3                   	ret    

008003c4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8003c4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8003c5:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8003ca:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8003cc:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8003cf:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8003d3:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8003d8:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8003dc:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8003de:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8003e1:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8003e2:	83 c4 04             	add    $0x4,%esp
    popfl
  8003e5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8003e6:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8003e7:	c3                   	ret    

008003e8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003e8:	f3 0f 1e fb          	endbr32 
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f2:	05 00 00 00 30       	add    $0x30000000,%eax
  8003f7:	c1 e8 0c             	shr    $0xc,%eax
}
  8003fa:	5d                   	pop    %ebp
  8003fb:	c3                   	ret    

008003fc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8003fc:	f3 0f 1e fb          	endbr32 
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80040b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800410:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800415:	5d                   	pop    %ebp
  800416:	c3                   	ret    

00800417 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800417:	f3 0f 1e fb          	endbr32 
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800423:	89 c2                	mov    %eax,%edx
  800425:	c1 ea 16             	shr    $0x16,%edx
  800428:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80042f:	f6 c2 01             	test   $0x1,%dl
  800432:	74 2d                	je     800461 <fd_alloc+0x4a>
  800434:	89 c2                	mov    %eax,%edx
  800436:	c1 ea 0c             	shr    $0xc,%edx
  800439:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800440:	f6 c2 01             	test   $0x1,%dl
  800443:	74 1c                	je     800461 <fd_alloc+0x4a>
  800445:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80044a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80044f:	75 d2                	jne    800423 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80045a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80045f:	eb 0a                	jmp    80046b <fd_alloc+0x54>
			*fd_store = fd;
  800461:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800464:	89 01                	mov    %eax,(%ecx)
			return 0;
  800466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80046d:	f3 0f 1e fb          	endbr32 
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800477:	83 f8 1f             	cmp    $0x1f,%eax
  80047a:	77 30                	ja     8004ac <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80047c:	c1 e0 0c             	shl    $0xc,%eax
  80047f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800484:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80048a:	f6 c2 01             	test   $0x1,%dl
  80048d:	74 24                	je     8004b3 <fd_lookup+0x46>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	c1 ea 0c             	shr    $0xc,%edx
  800494:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80049b:	f6 c2 01             	test   $0x1,%dl
  80049e:	74 1a                	je     8004ba <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 02                	mov    %eax,(%edx)
	return 0;
  8004a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004aa:	5d                   	pop    %ebp
  8004ab:	c3                   	ret    
		return -E_INVAL;
  8004ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b1:	eb f7                	jmp    8004aa <fd_lookup+0x3d>
		return -E_INVAL;
  8004b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b8:	eb f0                	jmp    8004aa <fd_lookup+0x3d>
  8004ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004bf:	eb e9                	jmp    8004aa <fd_lookup+0x3d>

008004c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004c1:	f3 0f 1e fb          	endbr32 
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004d8:	39 08                	cmp    %ecx,(%eax)
  8004da:	74 38                	je     800514 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8004dc:	83 c2 01             	add    $0x1,%edx
  8004df:	8b 04 95 34 25 80 00 	mov    0x802534(,%edx,4),%eax
  8004e6:	85 c0                	test   %eax,%eax
  8004e8:	75 ee                	jne    8004d8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8004ef:	8b 40 48             	mov    0x48(%eax),%eax
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	51                   	push   %ecx
  8004f6:	50                   	push   %eax
  8004f7:	68 b8 24 80 00       	push   $0x8024b8
  8004fc:	e8 d0 11 00 00       	call   8016d1 <cprintf>
	*dev = 0;
  800501:	8b 45 0c             	mov    0xc(%ebp),%eax
  800504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800512:	c9                   	leave  
  800513:	c3                   	ret    
			*dev = devtab[i];
  800514:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800517:	89 01                	mov    %eax,(%ecx)
			return 0;
  800519:	b8 00 00 00 00       	mov    $0x0,%eax
  80051e:	eb f2                	jmp    800512 <dev_lookup+0x51>

00800520 <fd_close>:
{
  800520:	f3 0f 1e fb          	endbr32 
  800524:	55                   	push   %ebp
  800525:	89 e5                	mov    %esp,%ebp
  800527:	57                   	push   %edi
  800528:	56                   	push   %esi
  800529:	53                   	push   %ebx
  80052a:	83 ec 24             	sub    $0x24,%esp
  80052d:	8b 75 08             	mov    0x8(%ebp),%esi
  800530:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800533:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800536:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800537:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80053d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800540:	50                   	push   %eax
  800541:	e8 27 ff ff ff       	call   80046d <fd_lookup>
  800546:	89 c3                	mov    %eax,%ebx
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	85 c0                	test   %eax,%eax
  80054d:	78 05                	js     800554 <fd_close+0x34>
	    || fd != fd2)
  80054f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800552:	74 16                	je     80056a <fd_close+0x4a>
		return (must_exist ? r : 0);
  800554:	89 f8                	mov    %edi,%eax
  800556:	84 c0                	test   %al,%al
  800558:	b8 00 00 00 00       	mov    $0x0,%eax
  80055d:	0f 44 d8             	cmove  %eax,%ebx
}
  800560:	89 d8                	mov    %ebx,%eax
  800562:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800565:	5b                   	pop    %ebx
  800566:	5e                   	pop    %esi
  800567:	5f                   	pop    %edi
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80056a:	83 ec 08             	sub    $0x8,%esp
  80056d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800570:	50                   	push   %eax
  800571:	ff 36                	pushl  (%esi)
  800573:	e8 49 ff ff ff       	call   8004c1 <dev_lookup>
  800578:	89 c3                	mov    %eax,%ebx
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	85 c0                	test   %eax,%eax
  80057f:	78 1a                	js     80059b <fd_close+0x7b>
		if (dev->dev_close)
  800581:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800584:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800587:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80058c:	85 c0                	test   %eax,%eax
  80058e:	74 0b                	je     80059b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800590:	83 ec 0c             	sub    $0xc,%esp
  800593:	56                   	push   %esi
  800594:	ff d0                	call   *%eax
  800596:	89 c3                	mov    %eax,%ebx
  800598:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	56                   	push   %esi
  80059f:	6a 00                	push   $0x0
  8005a1:	e8 77 fc ff ff       	call   80021d <sys_page_unmap>
	return r;
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	eb b5                	jmp    800560 <fd_close+0x40>

008005ab <close>:

int
close(int fdnum)
{
  8005ab:	f3 0f 1e fb          	endbr32 
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005b8:	50                   	push   %eax
  8005b9:	ff 75 08             	pushl  0x8(%ebp)
  8005bc:	e8 ac fe ff ff       	call   80046d <fd_lookup>
  8005c1:	83 c4 10             	add    $0x10,%esp
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	79 02                	jns    8005ca <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    
		return fd_close(fd, 1);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	6a 01                	push   $0x1
  8005cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d2:	e8 49 ff ff ff       	call   800520 <fd_close>
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	eb ec                	jmp    8005c8 <close+0x1d>

008005dc <close_all>:

void
close_all(void)
{
  8005dc:	f3 0f 1e fb          	endbr32 
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	53                   	push   %ebx
  8005e4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005e7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	e8 b6 ff ff ff       	call   8005ab <close>
	for (i = 0; i < MAXFD; i++)
  8005f5:	83 c3 01             	add    $0x1,%ebx
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	83 fb 20             	cmp    $0x20,%ebx
  8005fe:	75 ec                	jne    8005ec <close_all+0x10>
}
  800600:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800603:	c9                   	leave  
  800604:	c3                   	ret    

00800605 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800605:	f3 0f 1e fb          	endbr32 
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
  80060c:	57                   	push   %edi
  80060d:	56                   	push   %esi
  80060e:	53                   	push   %ebx
  80060f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800612:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	ff 75 08             	pushl  0x8(%ebp)
  800619:	e8 4f fe ff ff       	call   80046d <fd_lookup>
  80061e:	89 c3                	mov    %eax,%ebx
  800620:	83 c4 10             	add    $0x10,%esp
  800623:	85 c0                	test   %eax,%eax
  800625:	0f 88 81 00 00 00    	js     8006ac <dup+0xa7>
		return r;
	close(newfdnum);
  80062b:	83 ec 0c             	sub    $0xc,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	e8 75 ff ff ff       	call   8005ab <close>

	newfd = INDEX2FD(newfdnum);
  800636:	8b 75 0c             	mov    0xc(%ebp),%esi
  800639:	c1 e6 0c             	shl    $0xc,%esi
  80063c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800642:	83 c4 04             	add    $0x4,%esp
  800645:	ff 75 e4             	pushl  -0x1c(%ebp)
  800648:	e8 af fd ff ff       	call   8003fc <fd2data>
  80064d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80064f:	89 34 24             	mov    %esi,(%esp)
  800652:	e8 a5 fd ff ff       	call   8003fc <fd2data>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80065c:	89 d8                	mov    %ebx,%eax
  80065e:	c1 e8 16             	shr    $0x16,%eax
  800661:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800668:	a8 01                	test   $0x1,%al
  80066a:	74 11                	je     80067d <dup+0x78>
  80066c:	89 d8                	mov    %ebx,%eax
  80066e:	c1 e8 0c             	shr    $0xc,%eax
  800671:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800678:	f6 c2 01             	test   $0x1,%dl
  80067b:	75 39                	jne    8006b6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80067d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800680:	89 d0                	mov    %edx,%eax
  800682:	c1 e8 0c             	shr    $0xc,%eax
  800685:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	25 07 0e 00 00       	and    $0xe07,%eax
  800694:	50                   	push   %eax
  800695:	56                   	push   %esi
  800696:	6a 00                	push   $0x0
  800698:	52                   	push   %edx
  800699:	6a 00                	push   $0x0
  80069b:	e8 37 fb ff ff       	call   8001d7 <sys_page_map>
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	83 c4 20             	add    $0x20,%esp
  8006a5:	85 c0                	test   %eax,%eax
  8006a7:	78 31                	js     8006da <dup+0xd5>
		goto err;

	return newfdnum;
  8006a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006ac:	89 d8                	mov    %ebx,%eax
  8006ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b1:	5b                   	pop    %ebx
  8006b2:	5e                   	pop    %esi
  8006b3:	5f                   	pop    %edi
  8006b4:	5d                   	pop    %ebp
  8006b5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006bd:	83 ec 0c             	sub    $0xc,%esp
  8006c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8006c5:	50                   	push   %eax
  8006c6:	57                   	push   %edi
  8006c7:	6a 00                	push   $0x0
  8006c9:	53                   	push   %ebx
  8006ca:	6a 00                	push   $0x0
  8006cc:	e8 06 fb ff ff       	call   8001d7 <sys_page_map>
  8006d1:	89 c3                	mov    %eax,%ebx
  8006d3:	83 c4 20             	add    $0x20,%esp
  8006d6:	85 c0                	test   %eax,%eax
  8006d8:	79 a3                	jns    80067d <dup+0x78>
	sys_page_unmap(0, newfd);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	56                   	push   %esi
  8006de:	6a 00                	push   $0x0
  8006e0:	e8 38 fb ff ff       	call   80021d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006e5:	83 c4 08             	add    $0x8,%esp
  8006e8:	57                   	push   %edi
  8006e9:	6a 00                	push   $0x0
  8006eb:	e8 2d fb ff ff       	call   80021d <sys_page_unmap>
	return r;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	eb b7                	jmp    8006ac <dup+0xa7>

008006f5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006f5:	f3 0f 1e fb          	endbr32 
  8006f9:	55                   	push   %ebp
  8006fa:	89 e5                	mov    %esp,%ebp
  8006fc:	53                   	push   %ebx
  8006fd:	83 ec 1c             	sub    $0x1c,%esp
  800700:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800703:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	53                   	push   %ebx
  800708:	e8 60 fd ff ff       	call   80046d <fd_lookup>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	85 c0                	test   %eax,%eax
  800712:	78 3f                	js     800753 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80071a:	50                   	push   %eax
  80071b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071e:	ff 30                	pushl  (%eax)
  800720:	e8 9c fd ff ff       	call   8004c1 <dev_lookup>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	85 c0                	test   %eax,%eax
  80072a:	78 27                	js     800753 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80072c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80072f:	8b 42 08             	mov    0x8(%edx),%eax
  800732:	83 e0 03             	and    $0x3,%eax
  800735:	83 f8 01             	cmp    $0x1,%eax
  800738:	74 1e                	je     800758 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80073a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80073d:	8b 40 08             	mov    0x8(%eax),%eax
  800740:	85 c0                	test   %eax,%eax
  800742:	74 35                	je     800779 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	ff 75 10             	pushl  0x10(%ebp)
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	52                   	push   %edx
  80074e:	ff d0                	call   *%eax
  800750:	83 c4 10             	add    $0x10,%esp
}
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800758:	a1 08 40 80 00       	mov    0x804008,%eax
  80075d:	8b 40 48             	mov    0x48(%eax),%eax
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	53                   	push   %ebx
  800764:	50                   	push   %eax
  800765:	68 f9 24 80 00       	push   $0x8024f9
  80076a:	e8 62 0f 00 00       	call   8016d1 <cprintf>
		return -E_INVAL;
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800777:	eb da                	jmp    800753 <read+0x5e>
		return -E_NOT_SUPP;
  800779:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80077e:	eb d3                	jmp    800753 <read+0x5e>

00800780 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800780:	f3 0f 1e fb          	endbr32 
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	57                   	push   %edi
  800788:	56                   	push   %esi
  800789:	53                   	push   %ebx
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800790:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800793:	bb 00 00 00 00       	mov    $0x0,%ebx
  800798:	eb 02                	jmp    80079c <readn+0x1c>
  80079a:	01 c3                	add    %eax,%ebx
  80079c:	39 f3                	cmp    %esi,%ebx
  80079e:	73 21                	jae    8007c1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007a0:	83 ec 04             	sub    $0x4,%esp
  8007a3:	89 f0                	mov    %esi,%eax
  8007a5:	29 d8                	sub    %ebx,%eax
  8007a7:	50                   	push   %eax
  8007a8:	89 d8                	mov    %ebx,%eax
  8007aa:	03 45 0c             	add    0xc(%ebp),%eax
  8007ad:	50                   	push   %eax
  8007ae:	57                   	push   %edi
  8007af:	e8 41 ff ff ff       	call   8006f5 <read>
		if (m < 0)
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	85 c0                	test   %eax,%eax
  8007b9:	78 04                	js     8007bf <readn+0x3f>
			return m;
		if (m == 0)
  8007bb:	75 dd                	jne    80079a <readn+0x1a>
  8007bd:	eb 02                	jmp    8007c1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007bf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007c1:	89 d8                	mov    %ebx,%eax
  8007c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c6:	5b                   	pop    %ebx
  8007c7:	5e                   	pop    %esi
  8007c8:	5f                   	pop    %edi
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007cb:	f3 0f 1e fb          	endbr32 
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	53                   	push   %ebx
  8007d3:	83 ec 1c             	sub    $0x1c,%esp
  8007d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007dc:	50                   	push   %eax
  8007dd:	53                   	push   %ebx
  8007de:	e8 8a fc ff ff       	call   80046d <fd_lookup>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	78 3a                	js     800824 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007f0:	50                   	push   %eax
  8007f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f4:	ff 30                	pushl  (%eax)
  8007f6:	e8 c6 fc ff ff       	call   8004c1 <dev_lookup>
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	85 c0                	test   %eax,%eax
  800800:	78 22                	js     800824 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800805:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800809:	74 1e                	je     800829 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80080b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080e:	8b 52 0c             	mov    0xc(%edx),%edx
  800811:	85 d2                	test   %edx,%edx
  800813:	74 35                	je     80084a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800815:	83 ec 04             	sub    $0x4,%esp
  800818:	ff 75 10             	pushl  0x10(%ebp)
  80081b:	ff 75 0c             	pushl  0xc(%ebp)
  80081e:	50                   	push   %eax
  80081f:	ff d2                	call   *%edx
  800821:	83 c4 10             	add    $0x10,%esp
}
  800824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800829:	a1 08 40 80 00       	mov    0x804008,%eax
  80082e:	8b 40 48             	mov    0x48(%eax),%eax
  800831:	83 ec 04             	sub    $0x4,%esp
  800834:	53                   	push   %ebx
  800835:	50                   	push   %eax
  800836:	68 15 25 80 00       	push   $0x802515
  80083b:	e8 91 0e 00 00       	call   8016d1 <cprintf>
		return -E_INVAL;
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800848:	eb da                	jmp    800824 <write+0x59>
		return -E_NOT_SUPP;
  80084a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80084f:	eb d3                	jmp    800824 <write+0x59>

00800851 <seek>:

int
seek(int fdnum, off_t offset)
{
  800851:	f3 0f 1e fb          	endbr32 
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80085b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80085e:	50                   	push   %eax
  80085f:	ff 75 08             	pushl  0x8(%ebp)
  800862:	e8 06 fc ff ff       	call   80046d <fd_lookup>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	85 c0                	test   %eax,%eax
  80086c:	78 0e                	js     80087c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800874:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	53                   	push   %ebx
  800886:	83 ec 1c             	sub    $0x1c,%esp
  800889:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80088c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80088f:	50                   	push   %eax
  800890:	53                   	push   %ebx
  800891:	e8 d7 fb ff ff       	call   80046d <fd_lookup>
  800896:	83 c4 10             	add    $0x10,%esp
  800899:	85 c0                	test   %eax,%eax
  80089b:	78 37                	js     8008d4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a7:	ff 30                	pushl  (%eax)
  8008a9:	e8 13 fc ff ff       	call   8004c1 <dev_lookup>
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	78 1f                	js     8008d4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008bc:	74 1b                	je     8008d9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8008be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c1:	8b 52 18             	mov    0x18(%edx),%edx
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	74 32                	je     8008fa <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	50                   	push   %eax
  8008cf:	ff d2                	call   *%edx
  8008d1:	83 c4 10             	add    $0x10,%esp
}
  8008d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008d9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008de:	8b 40 48             	mov    0x48(%eax),%eax
  8008e1:	83 ec 04             	sub    $0x4,%esp
  8008e4:	53                   	push   %ebx
  8008e5:	50                   	push   %eax
  8008e6:	68 d8 24 80 00       	push   $0x8024d8
  8008eb:	e8 e1 0d 00 00       	call   8016d1 <cprintf>
		return -E_INVAL;
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f8:	eb da                	jmp    8008d4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8008fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ff:	eb d3                	jmp    8008d4 <ftruncate+0x56>

00800901 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800901:	f3 0f 1e fb          	endbr32 
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	53                   	push   %ebx
  800909:	83 ec 1c             	sub    $0x1c,%esp
  80090c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80090f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800912:	50                   	push   %eax
  800913:	ff 75 08             	pushl  0x8(%ebp)
  800916:	e8 52 fb ff ff       	call   80046d <fd_lookup>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	85 c0                	test   %eax,%eax
  800920:	78 4b                	js     80096d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800928:	50                   	push   %eax
  800929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092c:	ff 30                	pushl  (%eax)
  80092e:	e8 8e fb ff ff       	call   8004c1 <dev_lookup>
  800933:	83 c4 10             	add    $0x10,%esp
  800936:	85 c0                	test   %eax,%eax
  800938:	78 33                	js     80096d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80093a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800941:	74 2f                	je     800972 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800943:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800946:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80094d:	00 00 00 
	stat->st_isdir = 0;
  800950:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800957:	00 00 00 
	stat->st_dev = dev;
  80095a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	53                   	push   %ebx
  800964:	ff 75 f0             	pushl  -0x10(%ebp)
  800967:	ff 50 14             	call   *0x14(%eax)
  80096a:	83 c4 10             	add    $0x10,%esp
}
  80096d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800970:	c9                   	leave  
  800971:	c3                   	ret    
		return -E_NOT_SUPP;
  800972:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800977:	eb f4                	jmp    80096d <fstat+0x6c>

00800979 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800979:	f3 0f 1e fb          	endbr32 
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	6a 00                	push   $0x0
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 fb 01 00 00       	call   800b8a <open>
  80098f:	89 c3                	mov    %eax,%ebx
  800991:	83 c4 10             	add    $0x10,%esp
  800994:	85 c0                	test   %eax,%eax
  800996:	78 1b                	js     8009b3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	50                   	push   %eax
  80099f:	e8 5d ff ff ff       	call   800901 <fstat>
  8009a4:	89 c6                	mov    %eax,%esi
	close(fd);
  8009a6:	89 1c 24             	mov    %ebx,(%esp)
  8009a9:	e8 fd fb ff ff       	call   8005ab <close>
	return r;
  8009ae:	83 c4 10             	add    $0x10,%esp
  8009b1:	89 f3                	mov    %esi,%ebx
}
  8009b3:	89 d8                	mov    %ebx,%eax
  8009b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	89 c6                	mov    %eax,%esi
  8009c3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8009c5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009cc:	74 27                	je     8009f5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009ce:	6a 07                	push   $0x7
  8009d0:	68 00 50 80 00       	push   $0x805000
  8009d5:	56                   	push   %esi
  8009d6:	ff 35 00 40 80 00    	pushl  0x804000
  8009dc:	e8 61 17 00 00       	call   802142 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009e1:	83 c4 0c             	add    $0xc,%esp
  8009e4:	6a 00                	push   $0x0
  8009e6:	53                   	push   %ebx
  8009e7:	6a 00                	push   $0x0
  8009e9:	e8 e0 16 00 00       	call   8020ce <ipc_recv>
}
  8009ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009f5:	83 ec 0c             	sub    $0xc,%esp
  8009f8:	6a 01                	push   $0x1
  8009fa:	e8 9b 17 00 00       	call   80219a <ipc_find_env>
  8009ff:	a3 00 40 80 00       	mov    %eax,0x804000
  800a04:	83 c4 10             	add    $0x10,%esp
  800a07:	eb c5                	jmp    8009ce <fsipc+0x12>

00800a09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 40 0c             	mov    0xc(%eax),%eax
  800a19:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	b8 02 00 00 00       	mov    $0x2,%eax
  800a30:	e8 87 ff ff ff       	call   8009bc <fsipc>
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <devfile_flush>:
{
  800a37:	f3 0f 1e fb          	endbr32 
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 40 0c             	mov    0xc(%eax),%eax
  800a47:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a51:	b8 06 00 00 00       	mov    $0x6,%eax
  800a56:	e8 61 ff ff ff       	call   8009bc <fsipc>
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <devfile_stat>:
{
  800a5d:	f3 0f 1e fb          	endbr32 
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	53                   	push   %ebx
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a71:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a76:	ba 00 00 00 00       	mov    $0x0,%edx
  800a7b:	b8 05 00 00 00       	mov    $0x5,%eax
  800a80:	e8 37 ff ff ff       	call   8009bc <fsipc>
  800a85:	85 c0                	test   %eax,%eax
  800a87:	78 2c                	js     800ab5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	68 00 50 80 00       	push   $0x805000
  800a91:	53                   	push   %ebx
  800a92:	e8 44 12 00 00       	call   801cdb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a97:	a1 80 50 80 00       	mov    0x805080,%eax
  800a9c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800aa2:	a1 84 50 80 00       	mov    0x805084,%eax
  800aa7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800aad:	83 c4 10             	add    $0x10,%esp
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <devfile_write>:
{
  800aba:	f3 0f 1e fb          	endbr32 
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	83 ec 0c             	sub    $0xc,%esp
  800ac4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  800aca:	8b 52 0c             	mov    0xc(%edx),%edx
  800acd:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800ad3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad8:	ba 00 10 00 00       	mov    $0x1000,%edx
  800add:	0f 47 c2             	cmova  %edx,%eax
  800ae0:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	68 08 50 80 00       	push   $0x805008
  800aee:	e8 9e 13 00 00       	call   801e91 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800af3:	ba 00 00 00 00       	mov    $0x0,%edx
  800af8:	b8 04 00 00 00       	mov    $0x4,%eax
  800afd:	e8 ba fe ff ff       	call   8009bc <fsipc>
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <devfile_read>:
{
  800b04:	f3 0f 1e fb          	endbr32 
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 40 0c             	mov    0xc(%eax),%eax
  800b16:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b1b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b21:	ba 00 00 00 00       	mov    $0x0,%edx
  800b26:	b8 03 00 00 00       	mov    $0x3,%eax
  800b2b:	e8 8c fe ff ff       	call   8009bc <fsipc>
  800b30:	89 c3                	mov    %eax,%ebx
  800b32:	85 c0                	test   %eax,%eax
  800b34:	78 1f                	js     800b55 <devfile_read+0x51>
	assert(r <= n);
  800b36:	39 f0                	cmp    %esi,%eax
  800b38:	77 24                	ja     800b5e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800b3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b3f:	7f 33                	jg     800b74 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	50                   	push   %eax
  800b45:	68 00 50 80 00       	push   $0x805000
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	e8 3f 13 00 00       	call   801e91 <memmove>
	return r;
  800b52:	83 c4 10             	add    $0x10,%esp
}
  800b55:	89 d8                	mov    %ebx,%eax
  800b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5a:	5b                   	pop    %ebx
  800b5b:	5e                   	pop    %esi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    
	assert(r <= n);
  800b5e:	68 48 25 80 00       	push   $0x802548
  800b63:	68 4f 25 80 00       	push   $0x80254f
  800b68:	6a 7c                	push   $0x7c
  800b6a:	68 64 25 80 00       	push   $0x802564
  800b6f:	e8 76 0a 00 00       	call   8015ea <_panic>
	assert(r <= PGSIZE);
  800b74:	68 6f 25 80 00       	push   $0x80256f
  800b79:	68 4f 25 80 00       	push   $0x80254f
  800b7e:	6a 7d                	push   $0x7d
  800b80:	68 64 25 80 00       	push   $0x802564
  800b85:	e8 60 0a 00 00       	call   8015ea <_panic>

00800b8a <open>:
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	83 ec 1c             	sub    $0x1c,%esp
  800b96:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b99:	56                   	push   %esi
  800b9a:	e8 f9 10 00 00       	call   801c98 <strlen>
  800b9f:	83 c4 10             	add    $0x10,%esp
  800ba2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ba7:	7f 6c                	jg     800c15 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800ba9:	83 ec 0c             	sub    $0xc,%esp
  800bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800baf:	50                   	push   %eax
  800bb0:	e8 62 f8 ff ff       	call   800417 <fd_alloc>
  800bb5:	89 c3                	mov    %eax,%ebx
  800bb7:	83 c4 10             	add    $0x10,%esp
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	78 3c                	js     800bfa <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	56                   	push   %esi
  800bc2:	68 00 50 80 00       	push   $0x805000
  800bc7:	e8 0f 11 00 00       	call   801cdb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	b8 01 00 00 00       	mov    $0x1,%eax
  800bdc:	e8 db fd ff ff       	call   8009bc <fsipc>
  800be1:	89 c3                	mov    %eax,%ebx
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	85 c0                	test   %eax,%eax
  800be8:	78 19                	js     800c03 <open+0x79>
	return fd2num(fd);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	e8 f3 f7 ff ff       	call   8003e8 <fd2num>
  800bf5:	89 c3                	mov    %eax,%ebx
  800bf7:	83 c4 10             	add    $0x10,%esp
}
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    
		fd_close(fd, 0);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	6a 00                	push   $0x0
  800c08:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0b:	e8 10 f9 ff ff       	call   800520 <fd_close>
		return r;
  800c10:	83 c4 10             	add    $0x10,%esp
  800c13:	eb e5                	jmp    800bfa <open+0x70>
		return -E_BAD_PATH;
  800c15:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c1a:	eb de                	jmp    800bfa <open+0x70>

00800c1c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c1c:	f3 0f 1e fb          	endbr32 
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c26:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800c30:	e8 87 fd ff ff       	call   8009bc <fsipc>
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800c37:	f3 0f 1e fb          	endbr32 
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  800c41:	68 7b 25 80 00       	push   $0x80257b
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	e8 8d 10 00 00       	call   801cdb <strcpy>
	return 0;
}
  800c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <devsock_close>:
{
  800c55:	f3 0f 1e fb          	endbr32 
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	53                   	push   %ebx
  800c5d:	83 ec 10             	sub    $0x10,%esp
  800c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800c63:	53                   	push   %ebx
  800c64:	e8 6e 15 00 00       	call   8021d7 <pageref>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	83 c4 10             	add    $0x10,%esp
		return 0;
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  800c73:	83 fa 01             	cmp    $0x1,%edx
  800c76:	74 05                	je     800c7d <devsock_close+0x28>
}
  800c78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  800c7d:	83 ec 0c             	sub    $0xc,%esp
  800c80:	ff 73 0c             	pushl  0xc(%ebx)
  800c83:	e8 e3 02 00 00       	call   800f6b <nsipc_close>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	eb eb                	jmp    800c78 <devsock_close+0x23>

00800c8d <devsock_write>:
{
  800c8d:	f3 0f 1e fb          	endbr32 
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800c97:	6a 00                	push   $0x0
  800c99:	ff 75 10             	pushl  0x10(%ebp)
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff 70 0c             	pushl  0xc(%eax)
  800ca5:	e8 b5 03 00 00       	call   80105f <nsipc_send>
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <devsock_read>:
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800cb6:	6a 00                	push   $0x0
  800cb8:	ff 75 10             	pushl  0x10(%ebp)
  800cbb:	ff 75 0c             	pushl  0xc(%ebp)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	ff 70 0c             	pushl  0xc(%eax)
  800cc4:	e8 1f 03 00 00       	call   800fe8 <nsipc_recv>
}
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <fd2sockid>:
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  800cd1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800cd4:	52                   	push   %edx
  800cd5:	50                   	push   %eax
  800cd6:	e8 92 f7 ff ff       	call   80046d <fd_lookup>
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	78 10                	js     800cf2 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  800ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ce5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800ceb:	39 08                	cmp    %ecx,(%eax)
  800ced:	75 05                	jne    800cf4 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  800cef:	8b 40 0c             	mov    0xc(%eax),%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    
		return -E_NOT_SUPP;
  800cf4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cf9:	eb f7                	jmp    800cf2 <fd2sockid+0x27>

00800cfb <alloc_sockfd>:
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 1c             	sub    $0x1c,%esp
  800d03:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  800d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d08:	50                   	push   %eax
  800d09:	e8 09 f7 ff ff       	call   800417 <fd_alloc>
  800d0e:	89 c3                	mov    %eax,%ebx
  800d10:	83 c4 10             	add    $0x10,%esp
  800d13:	85 c0                	test   %eax,%eax
  800d15:	78 43                	js     800d5a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800d17:	83 ec 04             	sub    $0x4,%esp
  800d1a:	68 07 04 00 00       	push   $0x407
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	6a 00                	push   $0x0
  800d24:	e8 67 f4 ff ff       	call   800190 <sys_page_alloc>
  800d29:	89 c3                	mov    %eax,%ebx
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	78 28                	js     800d5a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  800d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d35:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800d3b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d40:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800d47:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	e8 95 f6 ff ff       	call   8003e8 <fd2num>
  800d53:	89 c3                	mov    %eax,%ebx
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	eb 0c                	jmp    800d66 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	56                   	push   %esi
  800d5e:	e8 08 02 00 00       	call   800f6b <nsipc_close>
		return r;
  800d63:	83 c4 10             	add    $0x10,%esp
}
  800d66:	89 d8                	mov    %ebx,%eax
  800d68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <accept>:
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	e8 4a ff ff ff       	call   800ccb <fd2sockid>
  800d81:	85 c0                	test   %eax,%eax
  800d83:	78 1b                	js     800da0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800d85:	83 ec 04             	sub    $0x4,%esp
  800d88:	ff 75 10             	pushl  0x10(%ebp)
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	50                   	push   %eax
  800d8f:	e8 22 01 00 00       	call   800eb6 <nsipc_accept>
  800d94:	83 c4 10             	add    $0x10,%esp
  800d97:	85 c0                	test   %eax,%eax
  800d99:	78 05                	js     800da0 <accept+0x31>
	return alloc_sockfd(r);
  800d9b:	e8 5b ff ff ff       	call   800cfb <alloc_sockfd>
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <bind>:
{
  800da2:	f3 0f 1e fb          	endbr32 
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	e8 17 ff ff ff       	call   800ccb <fd2sockid>
  800db4:	85 c0                	test   %eax,%eax
  800db6:	78 12                	js     800dca <bind+0x28>
	return nsipc_bind(r, name, namelen);
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	ff 75 10             	pushl  0x10(%ebp)
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	e8 45 01 00 00       	call   800f0c <nsipc_bind>
  800dc7:	83 c4 10             	add    $0x10,%esp
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <shutdown>:
{
  800dcc:	f3 0f 1e fb          	endbr32 
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	e8 ed fe ff ff       	call   800ccb <fd2sockid>
  800dde:	85 c0                	test   %eax,%eax
  800de0:	78 0f                	js     800df1 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  800de2:	83 ec 08             	sub    $0x8,%esp
  800de5:	ff 75 0c             	pushl  0xc(%ebp)
  800de8:	50                   	push   %eax
  800de9:	e8 57 01 00 00       	call   800f45 <nsipc_shutdown>
  800dee:	83 c4 10             	add    $0x10,%esp
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <connect>:
{
  800df3:	f3 0f 1e fb          	endbr32 
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	e8 c6 fe ff ff       	call   800ccb <fd2sockid>
  800e05:	85 c0                	test   %eax,%eax
  800e07:	78 12                	js     800e1b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  800e09:	83 ec 04             	sub    $0x4,%esp
  800e0c:	ff 75 10             	pushl  0x10(%ebp)
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	50                   	push   %eax
  800e13:	e8 71 01 00 00       	call   800f89 <nsipc_connect>
  800e18:	83 c4 10             	add    $0x10,%esp
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <listen>:
{
  800e1d:	f3 0f 1e fb          	endbr32 
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	e8 9c fe ff ff       	call   800ccb <fd2sockid>
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	78 0f                	js     800e42 <listen+0x25>
	return nsipc_listen(r, backlog);
  800e33:	83 ec 08             	sub    $0x8,%esp
  800e36:	ff 75 0c             	pushl  0xc(%ebp)
  800e39:	50                   	push   %eax
  800e3a:	e8 83 01 00 00       	call   800fc2 <nsipc_listen>
  800e3f:	83 c4 10             	add    $0x10,%esp
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <socket>:

int
socket(int domain, int type, int protocol)
{
  800e44:	f3 0f 1e fb          	endbr32 
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800e4e:	ff 75 10             	pushl  0x10(%ebp)
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	ff 75 08             	pushl  0x8(%ebp)
  800e57:	e8 65 02 00 00       	call   8010c1 <nsipc_socket>
  800e5c:	83 c4 10             	add    $0x10,%esp
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	78 05                	js     800e68 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  800e63:	e8 93 fe ff ff       	call   800cfb <alloc_sockfd>
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	53                   	push   %ebx
  800e6e:	83 ec 04             	sub    $0x4,%esp
  800e71:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800e73:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800e7a:	74 26                	je     800ea2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800e7c:	6a 07                	push   $0x7
  800e7e:	68 00 60 80 00       	push   $0x806000
  800e83:	53                   	push   %ebx
  800e84:	ff 35 04 40 80 00    	pushl  0x804004
  800e8a:	e8 b3 12 00 00       	call   802142 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800e8f:	83 c4 0c             	add    $0xc,%esp
  800e92:	6a 00                	push   $0x0
  800e94:	6a 00                	push   $0x0
  800e96:	6a 00                	push   $0x0
  800e98:	e8 31 12 00 00       	call   8020ce <ipc_recv>
}
  800e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	6a 02                	push   $0x2
  800ea7:	e8 ee 12 00 00       	call   80219a <ipc_find_env>
  800eac:	a3 04 40 80 00       	mov    %eax,0x804004
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	eb c6                	jmp    800e7c <nsipc+0x12>

00800eb6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  800eca:	8b 06                	mov    (%esi),%eax
  800ecc:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  800ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ed6:	e8 8f ff ff ff       	call   800e6a <nsipc>
  800edb:	89 c3                	mov    %eax,%ebx
  800edd:	85 c0                	test   %eax,%eax
  800edf:	79 09                	jns    800eea <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  800ee1:	89 d8                	mov    %ebx,%eax
  800ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  800eea:	83 ec 04             	sub    $0x4,%esp
  800eed:	ff 35 10 60 80 00    	pushl  0x806010
  800ef3:	68 00 60 80 00       	push   $0x806000
  800ef8:	ff 75 0c             	pushl  0xc(%ebp)
  800efb:	e8 91 0f 00 00       	call   801e91 <memmove>
		*addrlen = ret->ret_addrlen;
  800f00:	a1 10 60 80 00       	mov    0x806010,%eax
  800f05:	89 06                	mov    %eax,(%esi)
  800f07:	83 c4 10             	add    $0x10,%esp
	return r;
  800f0a:	eb d5                	jmp    800ee1 <nsipc_accept+0x2b>

00800f0c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f0c:	f3 0f 1e fb          	endbr32 
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	53                   	push   %ebx
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  800f22:	53                   	push   %ebx
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	68 04 60 80 00       	push   $0x806004
  800f2b:	e8 61 0f 00 00       	call   801e91 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  800f30:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  800f36:	b8 02 00 00 00       	mov    $0x2,%eax
  800f3b:	e8 2a ff ff ff       	call   800e6a <nsipc>
}
  800f40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  800f45:	f3 0f 1e fb          	endbr32 
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  800f5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f64:	e8 01 ff ff ff       	call   800e6a <nsipc>
}
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <nsipc_close>:

int
nsipc_close(int s)
{
  800f6b:	f3 0f 1e fb          	endbr32 
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  800f7d:	b8 04 00 00 00       	mov    $0x4,%eax
  800f82:	e8 e3 fe ff ff       	call   800e6a <nsipc>
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f89:	f3 0f 1e fb          	endbr32 
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	53                   	push   %ebx
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  800f9f:	53                   	push   %ebx
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	68 04 60 80 00       	push   $0x806004
  800fa8:	e8 e4 0e 00 00       	call   801e91 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  800fad:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  800fb3:	b8 05 00 00 00       	mov    $0x5,%eax
  800fb8:	e8 ad fe ff ff       	call   800e6a <nsipc>
}
  800fbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  800fc2:	f3 0f 1e fb          	endbr32 
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  800fdc:	b8 06 00 00 00       	mov    $0x6,%eax
  800fe1:	e8 84 fe ff ff       	call   800e6a <nsipc>
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  800fe8:	f3 0f 1e fb          	endbr32 
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  800ffc:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801002:	8b 45 14             	mov    0x14(%ebp),%eax
  801005:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80100a:	b8 07 00 00 00       	mov    $0x7,%eax
  80100f:	e8 56 fe ff ff       	call   800e6a <nsipc>
  801014:	89 c3                	mov    %eax,%ebx
  801016:	85 c0                	test   %eax,%eax
  801018:	78 26                	js     801040 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80101a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801020:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801025:	0f 4e c6             	cmovle %esi,%eax
  801028:	39 c3                	cmp    %eax,%ebx
  80102a:	7f 1d                	jg     801049 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80102c:	83 ec 04             	sub    $0x4,%esp
  80102f:	53                   	push   %ebx
  801030:	68 00 60 80 00       	push   $0x806000
  801035:	ff 75 0c             	pushl  0xc(%ebp)
  801038:	e8 54 0e 00 00       	call   801e91 <memmove>
  80103d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801040:	89 d8                	mov    %ebx,%eax
  801042:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801049:	68 87 25 80 00       	push   $0x802587
  80104e:	68 4f 25 80 00       	push   $0x80254f
  801053:	6a 62                	push   $0x62
  801055:	68 9c 25 80 00       	push   $0x80259c
  80105a:	e8 8b 05 00 00       	call   8015ea <_panic>

0080105f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80105f:	f3 0f 1e fb          	endbr32 
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	53                   	push   %ebx
  801067:	83 ec 04             	sub    $0x4,%esp
  80106a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801075:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80107b:	7f 2e                	jg     8010ab <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80107d:	83 ec 04             	sub    $0x4,%esp
  801080:	53                   	push   %ebx
  801081:	ff 75 0c             	pushl  0xc(%ebp)
  801084:	68 0c 60 80 00       	push   $0x80600c
  801089:	e8 03 0e 00 00       	call   801e91 <memmove>
	nsipcbuf.send.req_size = size;
  80108e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801094:	8b 45 14             	mov    0x14(%ebp),%eax
  801097:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80109c:	b8 08 00 00 00       	mov    $0x8,%eax
  8010a1:	e8 c4 fd ff ff       	call   800e6a <nsipc>
}
  8010a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    
	assert(size < 1600);
  8010ab:	68 a8 25 80 00       	push   $0x8025a8
  8010b0:	68 4f 25 80 00       	push   $0x80254f
  8010b5:	6a 6d                	push   $0x6d
  8010b7:	68 9c 25 80 00       	push   $0x80259c
  8010bc:	e8 29 05 00 00       	call   8015ea <_panic>

008010c1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8010e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8010e8:	e8 7d fd ff ff       	call   800e6a <nsipc>
}
  8010ed:	c9                   	leave  
  8010ee:	c3                   	ret    

008010ef <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8010ef:	f3 0f 1e fb          	endbr32 
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	56                   	push   %esi
  8010f7:	53                   	push   %ebx
  8010f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	ff 75 08             	pushl  0x8(%ebp)
  801101:	e8 f6 f2 ff ff       	call   8003fc <fd2data>
  801106:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801108:	83 c4 08             	add    $0x8,%esp
  80110b:	68 b4 25 80 00       	push   $0x8025b4
  801110:	53                   	push   %ebx
  801111:	e8 c5 0b 00 00       	call   801cdb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801116:	8b 46 04             	mov    0x4(%esi),%eax
  801119:	2b 06                	sub    (%esi),%eax
  80111b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801121:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801128:	00 00 00 
	stat->st_dev = &devpipe;
  80112b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801132:	30 80 00 
	return 0;
}
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113d:	5b                   	pop    %ebx
  80113e:	5e                   	pop    %esi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801141:	f3 0f 1e fb          	endbr32 
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	53                   	push   %ebx
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80114f:	53                   	push   %ebx
  801150:	6a 00                	push   $0x0
  801152:	e8 c6 f0 ff ff       	call   80021d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801157:	89 1c 24             	mov    %ebx,(%esp)
  80115a:	e8 9d f2 ff ff       	call   8003fc <fd2data>
  80115f:	83 c4 08             	add    $0x8,%esp
  801162:	50                   	push   %eax
  801163:	6a 00                	push   $0x0
  801165:	e8 b3 f0 ff ff       	call   80021d <sys_page_unmap>
}
  80116a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <_pipeisclosed>:
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 1c             	sub    $0x1c,%esp
  801178:	89 c7                	mov    %eax,%edi
  80117a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80117c:	a1 08 40 80 00       	mov    0x804008,%eax
  801181:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	57                   	push   %edi
  801188:	e8 4a 10 00 00       	call   8021d7 <pageref>
  80118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801190:	89 34 24             	mov    %esi,(%esp)
  801193:	e8 3f 10 00 00       	call   8021d7 <pageref>
		nn = thisenv->env_runs;
  801198:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80119e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	39 cb                	cmp    %ecx,%ebx
  8011a6:	74 1b                	je     8011c3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8011a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011ab:	75 cf                	jne    80117c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8011ad:	8b 42 58             	mov    0x58(%edx),%eax
  8011b0:	6a 01                	push   $0x1
  8011b2:	50                   	push   %eax
  8011b3:	53                   	push   %ebx
  8011b4:	68 bb 25 80 00       	push   $0x8025bb
  8011b9:	e8 13 05 00 00       	call   8016d1 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
  8011c1:	eb b9                	jmp    80117c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8011c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8011c6:	0f 94 c0             	sete   %al
  8011c9:	0f b6 c0             	movzbl %al,%eax
}
  8011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cf:	5b                   	pop    %ebx
  8011d0:	5e                   	pop    %esi
  8011d1:	5f                   	pop    %edi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <devpipe_write>:
{
  8011d4:	f3 0f 1e fb          	endbr32 
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 28             	sub    $0x28,%esp
  8011e1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8011e4:	56                   	push   %esi
  8011e5:	e8 12 f2 ff ff       	call   8003fc <fd2data>
  8011ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8011f4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8011f7:	74 4f                	je     801248 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8011f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8011fc:	8b 0b                	mov    (%ebx),%ecx
  8011fe:	8d 51 20             	lea    0x20(%ecx),%edx
  801201:	39 d0                	cmp    %edx,%eax
  801203:	72 14                	jb     801219 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801205:	89 da                	mov    %ebx,%edx
  801207:	89 f0                	mov    %esi,%eax
  801209:	e8 61 ff ff ff       	call   80116f <_pipeisclosed>
  80120e:	85 c0                	test   %eax,%eax
  801210:	75 3b                	jne    80124d <devpipe_write+0x79>
			sys_yield();
  801212:	e8 56 ef ff ff       	call   80016d <sys_yield>
  801217:	eb e0                	jmp    8011f9 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801220:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801223:	89 c2                	mov    %eax,%edx
  801225:	c1 fa 1f             	sar    $0x1f,%edx
  801228:	89 d1                	mov    %edx,%ecx
  80122a:	c1 e9 1b             	shr    $0x1b,%ecx
  80122d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801230:	83 e2 1f             	and    $0x1f,%edx
  801233:	29 ca                	sub    %ecx,%edx
  801235:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801239:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80123d:	83 c0 01             	add    $0x1,%eax
  801240:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801243:	83 c7 01             	add    $0x1,%edi
  801246:	eb ac                	jmp    8011f4 <devpipe_write+0x20>
	return i;
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	eb 05                	jmp    801252 <devpipe_write+0x7e>
				return 0;
  80124d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801255:	5b                   	pop    %ebx
  801256:	5e                   	pop    %esi
  801257:	5f                   	pop    %edi
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <devpipe_read>:
{
  80125a:	f3 0f 1e fb          	endbr32 
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	57                   	push   %edi
  801262:	56                   	push   %esi
  801263:	53                   	push   %ebx
  801264:	83 ec 18             	sub    $0x18,%esp
  801267:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80126a:	57                   	push   %edi
  80126b:	e8 8c f1 ff ff       	call   8003fc <fd2data>
  801270:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	be 00 00 00 00       	mov    $0x0,%esi
  80127a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80127d:	75 14                	jne    801293 <devpipe_read+0x39>
	return i;
  80127f:	8b 45 10             	mov    0x10(%ebp),%eax
  801282:	eb 02                	jmp    801286 <devpipe_read+0x2c>
				return i;
  801284:	89 f0                	mov    %esi,%eax
}
  801286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801289:	5b                   	pop    %ebx
  80128a:	5e                   	pop    %esi
  80128b:	5f                   	pop    %edi
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    
			sys_yield();
  80128e:	e8 da ee ff ff       	call   80016d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801293:	8b 03                	mov    (%ebx),%eax
  801295:	3b 43 04             	cmp    0x4(%ebx),%eax
  801298:	75 18                	jne    8012b2 <devpipe_read+0x58>
			if (i > 0)
  80129a:	85 f6                	test   %esi,%esi
  80129c:	75 e6                	jne    801284 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80129e:	89 da                	mov    %ebx,%edx
  8012a0:	89 f8                	mov    %edi,%eax
  8012a2:	e8 c8 fe ff ff       	call   80116f <_pipeisclosed>
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	74 e3                	je     80128e <devpipe_read+0x34>
				return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b0:	eb d4                	jmp    801286 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8012b2:	99                   	cltd   
  8012b3:	c1 ea 1b             	shr    $0x1b,%edx
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	83 e0 1f             	and    $0x1f,%eax
  8012bb:	29 d0                	sub    %edx,%eax
  8012bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8012c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8012c8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8012cb:	83 c6 01             	add    $0x1,%esi
  8012ce:	eb aa                	jmp    80127a <devpipe_read+0x20>

008012d0 <pipe>:
{
  8012d0:	f3 0f 1e fb          	endbr32 
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8012dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012df:	50                   	push   %eax
  8012e0:	e8 32 f1 ff ff       	call   800417 <fd_alloc>
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	0f 88 23 01 00 00    	js     801415 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	68 07 04 00 00       	push   $0x407
  8012fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fd:	6a 00                	push   $0x0
  8012ff:	e8 8c ee ff ff       	call   800190 <sys_page_alloc>
  801304:	89 c3                	mov    %eax,%ebx
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	0f 88 04 01 00 00    	js     801415 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801311:	83 ec 0c             	sub    $0xc,%esp
  801314:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	e8 fa f0 ff ff       	call   800417 <fd_alloc>
  80131d:	89 c3                	mov    %eax,%ebx
  80131f:	83 c4 10             	add    $0x10,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	0f 88 db 00 00 00    	js     801405 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	68 07 04 00 00       	push   $0x407
  801332:	ff 75 f0             	pushl  -0x10(%ebp)
  801335:	6a 00                	push   $0x0
  801337:	e8 54 ee ff ff       	call   800190 <sys_page_alloc>
  80133c:	89 c3                	mov    %eax,%ebx
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	0f 88 bc 00 00 00    	js     801405 <pipe+0x135>
	va = fd2data(fd0);
  801349:	83 ec 0c             	sub    $0xc,%esp
  80134c:	ff 75 f4             	pushl  -0xc(%ebp)
  80134f:	e8 a8 f0 ff ff       	call   8003fc <fd2data>
  801354:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801356:	83 c4 0c             	add    $0xc,%esp
  801359:	68 07 04 00 00       	push   $0x407
  80135e:	50                   	push   %eax
  80135f:	6a 00                	push   $0x0
  801361:	e8 2a ee ff ff       	call   800190 <sys_page_alloc>
  801366:	89 c3                	mov    %eax,%ebx
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	0f 88 82 00 00 00    	js     8013f5 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	ff 75 f0             	pushl  -0x10(%ebp)
  801379:	e8 7e f0 ff ff       	call   8003fc <fd2data>
  80137e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801385:	50                   	push   %eax
  801386:	6a 00                	push   $0x0
  801388:	56                   	push   %esi
  801389:	6a 00                	push   $0x0
  80138b:	e8 47 ee ff ff       	call   8001d7 <sys_page_map>
  801390:	89 c3                	mov    %eax,%ebx
  801392:	83 c4 20             	add    $0x20,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 4e                	js     8013e7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801399:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8013a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8013ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c2:	e8 21 f0 ff ff       	call   8003e8 <fd2num>
  8013c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8013cc:	83 c4 04             	add    $0x4,%esp
  8013cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d2:	e8 11 f0 ff ff       	call   8003e8 <fd2num>
  8013d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8013dd:	83 c4 10             	add    $0x10,%esp
  8013e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e5:	eb 2e                	jmp    801415 <pipe+0x145>
	sys_page_unmap(0, va);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	56                   	push   %esi
  8013eb:	6a 00                	push   $0x0
  8013ed:	e8 2b ee ff ff       	call   80021d <sys_page_unmap>
  8013f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8013fb:	6a 00                	push   $0x0
  8013fd:	e8 1b ee ff ff       	call   80021d <sys_page_unmap>
  801402:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	ff 75 f4             	pushl  -0xc(%ebp)
  80140b:	6a 00                	push   $0x0
  80140d:	e8 0b ee ff ff       	call   80021d <sys_page_unmap>
  801412:	83 c4 10             	add    $0x10,%esp
}
  801415:	89 d8                	mov    %ebx,%eax
  801417:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80141a:	5b                   	pop    %ebx
  80141b:	5e                   	pop    %esi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    

0080141e <pipeisclosed>:
{
  80141e:	f3 0f 1e fb          	endbr32 
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801428:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142b:	50                   	push   %eax
  80142c:	ff 75 08             	pushl  0x8(%ebp)
  80142f:	e8 39 f0 ff ff       	call   80046d <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 18                	js     801453 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80143b:	83 ec 0c             	sub    $0xc,%esp
  80143e:	ff 75 f4             	pushl  -0xc(%ebp)
  801441:	e8 b6 ef ff ff       	call   8003fc <fd2data>
  801446:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	e8 1f fd ff ff       	call   80116f <_pipeisclosed>
  801450:	83 c4 10             	add    $0x10,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801455:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
  80145e:	c3                   	ret    

0080145f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80145f:	f3 0f 1e fb          	endbr32 
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801469:	68 d3 25 80 00       	push   $0x8025d3
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	e8 65 08 00 00       	call   801cdb <strcpy>
	return 0;
}
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <devcons_write>:
{
  80147d:	f3 0f 1e fb          	endbr32 
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	57                   	push   %edi
  801485:	56                   	push   %esi
  801486:	53                   	push   %ebx
  801487:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80148d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801492:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801498:	3b 75 10             	cmp    0x10(%ebp),%esi
  80149b:	73 31                	jae    8014ce <devcons_write+0x51>
		m = n - tot;
  80149d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014a0:	29 f3                	sub    %esi,%ebx
  8014a2:	83 fb 7f             	cmp    $0x7f,%ebx
  8014a5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8014aa:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	53                   	push   %ebx
  8014b1:	89 f0                	mov    %esi,%eax
  8014b3:	03 45 0c             	add    0xc(%ebp),%eax
  8014b6:	50                   	push   %eax
  8014b7:	57                   	push   %edi
  8014b8:	e8 d4 09 00 00       	call   801e91 <memmove>
		sys_cputs(buf, m);
  8014bd:	83 c4 08             	add    $0x8,%esp
  8014c0:	53                   	push   %ebx
  8014c1:	57                   	push   %edi
  8014c2:	e8 f9 eb ff ff       	call   8000c0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8014c7:	01 de                	add    %ebx,%esi
  8014c9:	83 c4 10             	add    $0x10,%esp
  8014cc:	eb ca                	jmp    801498 <devcons_write+0x1b>
}
  8014ce:	89 f0                	mov    %esi,%eax
  8014d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d3:	5b                   	pop    %ebx
  8014d4:	5e                   	pop    %esi
  8014d5:	5f                   	pop    %edi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    

008014d8 <devcons_read>:
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8014e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014eb:	74 21                	je     80150e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8014ed:	e8 f0 eb ff ff       	call   8000e2 <sys_cgetc>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	75 07                	jne    8014fd <devcons_read+0x25>
		sys_yield();
  8014f6:	e8 72 ec ff ff       	call   80016d <sys_yield>
  8014fb:	eb f0                	jmp    8014ed <devcons_read+0x15>
	if (c < 0)
  8014fd:	78 0f                	js     80150e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8014ff:	83 f8 04             	cmp    $0x4,%eax
  801502:	74 0c                	je     801510 <devcons_read+0x38>
	*(char*)vbuf = c;
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	88 02                	mov    %al,(%edx)
	return 1;
  801509:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    
		return 0;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
  801515:	eb f7                	jmp    80150e <devcons_read+0x36>

00801517 <cputchar>:
{
  801517:	f3 0f 1e fb          	endbr32 
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801527:	6a 01                	push   $0x1
  801529:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	e8 8e eb ff ff       	call   8000c0 <sys_cputs>
}
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	c9                   	leave  
  801536:	c3                   	ret    

00801537 <getchar>:
{
  801537:	f3 0f 1e fb          	endbr32 
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801541:	6a 01                	push   $0x1
  801543:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	6a 00                	push   $0x0
  801549:	e8 a7 f1 ff ff       	call   8006f5 <read>
	if (r < 0)
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 06                	js     80155b <getchar+0x24>
	if (r < 1)
  801555:	74 06                	je     80155d <getchar+0x26>
	return c;
  801557:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    
		return -E_EOF;
  80155d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801562:	eb f7                	jmp    80155b <getchar+0x24>

00801564 <iscons>:
{
  801564:	f3 0f 1e fb          	endbr32 
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80156e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801571:	50                   	push   %eax
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 f3 ee ff ff       	call   80046d <fd_lookup>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 11                	js     801592 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801584:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80158a:	39 10                	cmp    %edx,(%eax)
  80158c:	0f 94 c0             	sete   %al
  80158f:	0f b6 c0             	movzbl %al,%eax
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <opencons>:
{
  801594:	f3 0f 1e fb          	endbr32 
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80159e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a1:	50                   	push   %eax
  8015a2:	e8 70 ee ff ff       	call   800417 <fd_alloc>
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	78 3a                	js     8015e8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	68 07 04 00 00       	push   $0x407
  8015b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b9:	6a 00                	push   $0x0
  8015bb:	e8 d0 eb ff ff       	call   800190 <sys_page_alloc>
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 21                	js     8015e8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ca:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8015d0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	50                   	push   %eax
  8015e0:	e8 03 ee ff ff       	call   8003e8 <fd2num>
  8015e5:	83 c4 10             	add    $0x10,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8015ea:	f3 0f 1e fb          	endbr32 
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	56                   	push   %esi
  8015f2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8015f3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8015f6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8015fc:	e8 49 eb ff ff       	call   80014a <sys_getenvid>
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	56                   	push   %esi
  80160b:	50                   	push   %eax
  80160c:	68 e0 25 80 00       	push   $0x8025e0
  801611:	e8 bb 00 00 00       	call   8016d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801616:	83 c4 18             	add    $0x18,%esp
  801619:	53                   	push   %ebx
  80161a:	ff 75 10             	pushl  0x10(%ebp)
  80161d:	e8 5a 00 00 00       	call   80167c <vcprintf>
	cprintf("\n");
  801622:	c7 04 24 cc 25 80 00 	movl   $0x8025cc,(%esp)
  801629:	e8 a3 00 00 00       	call   8016d1 <cprintf>
  80162e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801631:	cc                   	int3   
  801632:	eb fd                	jmp    801631 <_panic+0x47>

00801634 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801634:	f3 0f 1e fb          	endbr32 
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	53                   	push   %ebx
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801642:	8b 13                	mov    (%ebx),%edx
  801644:	8d 42 01             	lea    0x1(%edx),%eax
  801647:	89 03                	mov    %eax,(%ebx)
  801649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801650:	3d ff 00 00 00       	cmp    $0xff,%eax
  801655:	74 09                	je     801660 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801657:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	68 ff 00 00 00       	push   $0xff
  801668:	8d 43 08             	lea    0x8(%ebx),%eax
  80166b:	50                   	push   %eax
  80166c:	e8 4f ea ff ff       	call   8000c0 <sys_cputs>
		b->idx = 0;
  801671:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	eb db                	jmp    801657 <putch+0x23>

0080167c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80167c:	f3 0f 1e fb          	endbr32 
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801689:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801690:	00 00 00 
	b.cnt = 0;
  801693:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80169a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016a9:	50                   	push   %eax
  8016aa:	68 34 16 80 00       	push   $0x801634
  8016af:	e8 20 01 00 00       	call   8017d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8016b4:	83 c4 08             	add    $0x8,%esp
  8016b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8016bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8016c3:	50                   	push   %eax
  8016c4:	e8 f7 e9 ff ff       	call   8000c0 <sys_cputs>

	return b.cnt;
}
  8016c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8016d1:	f3 0f 1e fb          	endbr32 
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8016db:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8016de:	50                   	push   %eax
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	e8 95 ff ff ff       	call   80167c <vcprintf>
	va_end(ap);

	return cnt;
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	57                   	push   %edi
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 1c             	sub    $0x1c,%esp
  8016f2:	89 c7                	mov    %eax,%edi
  8016f4:	89 d6                	mov    %edx,%esi
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	89 d1                	mov    %edx,%ecx
  8016fe:	89 c2                	mov    %eax,%edx
  801700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801703:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801706:	8b 45 10             	mov    0x10(%ebp),%eax
  801709:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80170c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80170f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801716:	39 c2                	cmp    %eax,%edx
  801718:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80171b:	72 3e                	jb     80175b <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	ff 75 18             	pushl  0x18(%ebp)
  801723:	83 eb 01             	sub    $0x1,%ebx
  801726:	53                   	push   %ebx
  801727:	50                   	push   %eax
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80172e:	ff 75 e0             	pushl  -0x20(%ebp)
  801731:	ff 75 dc             	pushl  -0x24(%ebp)
  801734:	ff 75 d8             	pushl  -0x28(%ebp)
  801737:	e8 e4 0a 00 00       	call   802220 <__udivdi3>
  80173c:	83 c4 18             	add    $0x18,%esp
  80173f:	52                   	push   %edx
  801740:	50                   	push   %eax
  801741:	89 f2                	mov    %esi,%edx
  801743:	89 f8                	mov    %edi,%eax
  801745:	e8 9f ff ff ff       	call   8016e9 <printnum>
  80174a:	83 c4 20             	add    $0x20,%esp
  80174d:	eb 13                	jmp    801762 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	56                   	push   %esi
  801753:	ff 75 18             	pushl  0x18(%ebp)
  801756:	ff d7                	call   *%edi
  801758:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80175b:	83 eb 01             	sub    $0x1,%ebx
  80175e:	85 db                	test   %ebx,%ebx
  801760:	7f ed                	jg     80174f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801762:	83 ec 08             	sub    $0x8,%esp
  801765:	56                   	push   %esi
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	ff 75 e4             	pushl  -0x1c(%ebp)
  80176c:	ff 75 e0             	pushl  -0x20(%ebp)
  80176f:	ff 75 dc             	pushl  -0x24(%ebp)
  801772:	ff 75 d8             	pushl  -0x28(%ebp)
  801775:	e8 b6 0b 00 00       	call   802330 <__umoddi3>
  80177a:	83 c4 14             	add    $0x14,%esp
  80177d:	0f be 80 03 26 80 00 	movsbl 0x802603(%eax),%eax
  801784:	50                   	push   %eax
  801785:	ff d7                	call   *%edi
}
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5f                   	pop    %edi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80179c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8017a0:	8b 10                	mov    (%eax),%edx
  8017a2:	3b 50 04             	cmp    0x4(%eax),%edx
  8017a5:	73 0a                	jae    8017b1 <sprintputch+0x1f>
		*b->buf++ = ch;
  8017a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017aa:	89 08                	mov    %ecx,(%eax)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	88 02                	mov    %al,(%edx)
}
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <printfmt>:
{
  8017b3:	f3 0f 1e fb          	endbr32 
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8017bd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8017c0:	50                   	push   %eax
  8017c1:	ff 75 10             	pushl  0x10(%ebp)
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 05 00 00 00       	call   8017d4 <vprintfmt>
}
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <vprintfmt>:
{
  8017d4:	f3 0f 1e fb          	endbr32 
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	57                   	push   %edi
  8017dc:	56                   	push   %esi
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 3c             	sub    $0x3c,%esp
  8017e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8017e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8017ea:	e9 8e 03 00 00       	jmp    801b7d <vprintfmt+0x3a9>
		padc = ' ';
  8017ef:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8017f3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8017fa:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801801:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801808:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80180d:	8d 47 01             	lea    0x1(%edi),%eax
  801810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801813:	0f b6 17             	movzbl (%edi),%edx
  801816:	8d 42 dd             	lea    -0x23(%edx),%eax
  801819:	3c 55                	cmp    $0x55,%al
  80181b:	0f 87 df 03 00 00    	ja     801c00 <vprintfmt+0x42c>
  801821:	0f b6 c0             	movzbl %al,%eax
  801824:	3e ff 24 85 40 27 80 	notrack jmp *0x802740(,%eax,4)
  80182b:	00 
  80182c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80182f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801833:	eb d8                	jmp    80180d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801835:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801838:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80183c:	eb cf                	jmp    80180d <vprintfmt+0x39>
  80183e:	0f b6 d2             	movzbl %dl,%edx
  801841:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
  801849:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80184c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80184f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801853:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801856:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801859:	83 f9 09             	cmp    $0x9,%ecx
  80185c:	77 55                	ja     8018b3 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80185e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801861:	eb e9                	jmp    80184c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801863:	8b 45 14             	mov    0x14(%ebp),%eax
  801866:	8b 00                	mov    (%eax),%eax
  801868:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	8d 40 04             	lea    0x4(%eax),%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801874:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801877:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80187b:	79 90                	jns    80180d <vprintfmt+0x39>
				width = precision, precision = -1;
  80187d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801880:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801883:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80188a:	eb 81                	jmp    80180d <vprintfmt+0x39>
  80188c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	ba 00 00 00 00       	mov    $0x0,%edx
  801896:	0f 49 d0             	cmovns %eax,%edx
  801899:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80189c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80189f:	e9 69 ff ff ff       	jmp    80180d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8018a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8018a7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8018ae:	e9 5a ff ff ff       	jmp    80180d <vprintfmt+0x39>
  8018b3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8018b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018b9:	eb bc                	jmp    801877 <vprintfmt+0xa3>
			lflag++;
  8018bb:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8018be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8018c1:	e9 47 ff ff ff       	jmp    80180d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8018c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c9:	8d 78 04             	lea    0x4(%eax),%edi
  8018cc:	83 ec 08             	sub    $0x8,%esp
  8018cf:	53                   	push   %ebx
  8018d0:	ff 30                	pushl  (%eax)
  8018d2:	ff d6                	call   *%esi
			break;
  8018d4:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8018d7:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8018da:	e9 9b 02 00 00       	jmp    801b7a <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8018df:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e2:	8d 78 04             	lea    0x4(%eax),%edi
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	99                   	cltd   
  8018e8:	31 d0                	xor    %edx,%eax
  8018ea:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8018ec:	83 f8 0f             	cmp    $0xf,%eax
  8018ef:	7f 23                	jg     801914 <vprintfmt+0x140>
  8018f1:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  8018f8:	85 d2                	test   %edx,%edx
  8018fa:	74 18                	je     801914 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8018fc:	52                   	push   %edx
  8018fd:	68 61 25 80 00       	push   $0x802561
  801902:	53                   	push   %ebx
  801903:	56                   	push   %esi
  801904:	e8 aa fe ff ff       	call   8017b3 <printfmt>
  801909:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80190c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80190f:	e9 66 02 00 00       	jmp    801b7a <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801914:	50                   	push   %eax
  801915:	68 1b 26 80 00       	push   $0x80261b
  80191a:	53                   	push   %ebx
  80191b:	56                   	push   %esi
  80191c:	e8 92 fe ff ff       	call   8017b3 <printfmt>
  801921:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801924:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801927:	e9 4e 02 00 00       	jmp    801b7a <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	83 c0 04             	add    $0x4,%eax
  801932:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801935:	8b 45 14             	mov    0x14(%ebp),%eax
  801938:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80193a:	85 d2                	test   %edx,%edx
  80193c:	b8 14 26 80 00       	mov    $0x802614,%eax
  801941:	0f 45 c2             	cmovne %edx,%eax
  801944:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801947:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80194b:	7e 06                	jle    801953 <vprintfmt+0x17f>
  80194d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801951:	75 0d                	jne    801960 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801953:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801956:	89 c7                	mov    %eax,%edi
  801958:	03 45 e0             	add    -0x20(%ebp),%eax
  80195b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80195e:	eb 55                	jmp    8019b5 <vprintfmt+0x1e1>
  801960:	83 ec 08             	sub    $0x8,%esp
  801963:	ff 75 d8             	pushl  -0x28(%ebp)
  801966:	ff 75 cc             	pushl  -0x34(%ebp)
  801969:	e8 46 03 00 00       	call   801cb4 <strnlen>
  80196e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801971:	29 c2                	sub    %eax,%edx
  801973:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80197b:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80197f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801982:	85 ff                	test   %edi,%edi
  801984:	7e 11                	jle    801997 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801986:	83 ec 08             	sub    $0x8,%esp
  801989:	53                   	push   %ebx
  80198a:	ff 75 e0             	pushl  -0x20(%ebp)
  80198d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80198f:	83 ef 01             	sub    $0x1,%edi
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	eb eb                	jmp    801982 <vprintfmt+0x1ae>
  801997:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80199a:	85 d2                	test   %edx,%edx
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a1:	0f 49 c2             	cmovns %edx,%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8019a9:	eb a8                	jmp    801953 <vprintfmt+0x17f>
					putch(ch, putdat);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	53                   	push   %ebx
  8019af:	52                   	push   %edx
  8019b0:	ff d6                	call   *%esi
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8019b8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019ba:	83 c7 01             	add    $0x1,%edi
  8019bd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8019c1:	0f be d0             	movsbl %al,%edx
  8019c4:	85 d2                	test   %edx,%edx
  8019c6:	74 4b                	je     801a13 <vprintfmt+0x23f>
  8019c8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8019cc:	78 06                	js     8019d4 <vprintfmt+0x200>
  8019ce:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8019d2:	78 1e                	js     8019f2 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8019d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8019d8:	74 d1                	je     8019ab <vprintfmt+0x1d7>
  8019da:	0f be c0             	movsbl %al,%eax
  8019dd:	83 e8 20             	sub    $0x20,%eax
  8019e0:	83 f8 5e             	cmp    $0x5e,%eax
  8019e3:	76 c6                	jbe    8019ab <vprintfmt+0x1d7>
					putch('?', putdat);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	53                   	push   %ebx
  8019e9:	6a 3f                	push   $0x3f
  8019eb:	ff d6                	call   *%esi
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	eb c3                	jmp    8019b5 <vprintfmt+0x1e1>
  8019f2:	89 cf                	mov    %ecx,%edi
  8019f4:	eb 0e                	jmp    801a04 <vprintfmt+0x230>
				putch(' ', putdat);
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	53                   	push   %ebx
  8019fa:	6a 20                	push   $0x20
  8019fc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8019fe:	83 ef 01             	sub    $0x1,%edi
  801a01:	83 c4 10             	add    $0x10,%esp
  801a04:	85 ff                	test   %edi,%edi
  801a06:	7f ee                	jg     8019f6 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801a08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801a0b:	89 45 14             	mov    %eax,0x14(%ebp)
  801a0e:	e9 67 01 00 00       	jmp    801b7a <vprintfmt+0x3a6>
  801a13:	89 cf                	mov    %ecx,%edi
  801a15:	eb ed                	jmp    801a04 <vprintfmt+0x230>
	if (lflag >= 2)
  801a17:	83 f9 01             	cmp    $0x1,%ecx
  801a1a:	7f 1b                	jg     801a37 <vprintfmt+0x263>
	else if (lflag)
  801a1c:	85 c9                	test   %ecx,%ecx
  801a1e:	74 63                	je     801a83 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801a20:	8b 45 14             	mov    0x14(%ebp),%eax
  801a23:	8b 00                	mov    (%eax),%eax
  801a25:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a28:	99                   	cltd   
  801a29:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2f:	8d 40 04             	lea    0x4(%eax),%eax
  801a32:	89 45 14             	mov    %eax,0x14(%ebp)
  801a35:	eb 17                	jmp    801a4e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801a37:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3a:	8b 50 04             	mov    0x4(%eax),%edx
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a42:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a45:	8b 45 14             	mov    0x14(%ebp),%eax
  801a48:	8d 40 08             	lea    0x8(%eax),%eax
  801a4b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801a4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801a54:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801a59:	85 c9                	test   %ecx,%ecx
  801a5b:	0f 89 ff 00 00 00    	jns    801b60 <vprintfmt+0x38c>
				putch('-', putdat);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	53                   	push   %ebx
  801a65:	6a 2d                	push   $0x2d
  801a67:	ff d6                	call   *%esi
				num = -(long long) num;
  801a69:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a6c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801a6f:	f7 da                	neg    %edx
  801a71:	83 d1 00             	adc    $0x0,%ecx
  801a74:	f7 d9                	neg    %ecx
  801a76:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801a79:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a7e:	e9 dd 00 00 00       	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801a83:	8b 45 14             	mov    0x14(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a8b:	99                   	cltd   
  801a8c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a92:	8d 40 04             	lea    0x4(%eax),%eax
  801a95:	89 45 14             	mov    %eax,0x14(%ebp)
  801a98:	eb b4                	jmp    801a4e <vprintfmt+0x27a>
	if (lflag >= 2)
  801a9a:	83 f9 01             	cmp    $0x1,%ecx
  801a9d:	7f 1e                	jg     801abd <vprintfmt+0x2e9>
	else if (lflag)
  801a9f:	85 c9                	test   %ecx,%ecx
  801aa1:	74 32                	je     801ad5 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa6:	8b 10                	mov    (%eax),%edx
  801aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aad:	8d 40 04             	lea    0x4(%eax),%eax
  801ab0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ab3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801ab8:	e9 a3 00 00 00       	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801abd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac0:	8b 10                	mov    (%eax),%edx
  801ac2:	8b 48 04             	mov    0x4(%eax),%ecx
  801ac5:	8d 40 08             	lea    0x8(%eax),%eax
  801ac8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801acb:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801ad0:	e9 8b 00 00 00       	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 10                	mov    (%eax),%edx
  801ada:	b9 00 00 00 00       	mov    $0x0,%ecx
  801adf:	8d 40 04             	lea    0x4(%eax),%eax
  801ae2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ae5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801aea:	eb 74                	jmp    801b60 <vprintfmt+0x38c>
	if (lflag >= 2)
  801aec:	83 f9 01             	cmp    $0x1,%ecx
  801aef:	7f 1b                	jg     801b0c <vprintfmt+0x338>
	else if (lflag)
  801af1:	85 c9                	test   %ecx,%ecx
  801af3:	74 2c                	je     801b21 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801af5:	8b 45 14             	mov    0x14(%ebp),%eax
  801af8:	8b 10                	mov    (%eax),%edx
  801afa:	b9 00 00 00 00       	mov    $0x0,%ecx
  801aff:	8d 40 04             	lea    0x4(%eax),%eax
  801b02:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b05:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801b0a:	eb 54                	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0f:	8b 10                	mov    (%eax),%edx
  801b11:	8b 48 04             	mov    0x4(%eax),%ecx
  801b14:	8d 40 08             	lea    0x8(%eax),%eax
  801b17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b1a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801b1f:	eb 3f                	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	8b 10                	mov    (%eax),%edx
  801b26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2b:	8d 40 04             	lea    0x4(%eax),%eax
  801b2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801b31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801b36:	eb 28                	jmp    801b60 <vprintfmt+0x38c>
			putch('0', putdat);
  801b38:	83 ec 08             	sub    $0x8,%esp
  801b3b:	53                   	push   %ebx
  801b3c:	6a 30                	push   $0x30
  801b3e:	ff d6                	call   *%esi
			putch('x', putdat);
  801b40:	83 c4 08             	add    $0x8,%esp
  801b43:	53                   	push   %ebx
  801b44:	6a 78                	push   $0x78
  801b46:	ff d6                	call   *%esi
			num = (unsigned long long)
  801b48:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4b:	8b 10                	mov    (%eax),%edx
  801b4d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801b52:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801b55:	8d 40 04             	lea    0x4(%eax),%eax
  801b58:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801b5b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801b60:	83 ec 0c             	sub    $0xc,%esp
  801b63:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801b67:	57                   	push   %edi
  801b68:	ff 75 e0             	pushl  -0x20(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	51                   	push   %ecx
  801b6d:	52                   	push   %edx
  801b6e:	89 da                	mov    %ebx,%edx
  801b70:	89 f0                	mov    %esi,%eax
  801b72:	e8 72 fb ff ff       	call   8016e9 <printnum>
			break;
  801b77:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801b7a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b7d:	83 c7 01             	add    $0x1,%edi
  801b80:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801b84:	83 f8 25             	cmp    $0x25,%eax
  801b87:	0f 84 62 fc ff ff    	je     8017ef <vprintfmt+0x1b>
			if (ch == '\0')
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	0f 84 8b 00 00 00    	je     801c20 <vprintfmt+0x44c>
			putch(ch, putdat);
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	53                   	push   %ebx
  801b99:	50                   	push   %eax
  801b9a:	ff d6                	call   *%esi
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	eb dc                	jmp    801b7d <vprintfmt+0x3a9>
	if (lflag >= 2)
  801ba1:	83 f9 01             	cmp    $0x1,%ecx
  801ba4:	7f 1b                	jg     801bc1 <vprintfmt+0x3ed>
	else if (lflag)
  801ba6:	85 c9                	test   %ecx,%ecx
  801ba8:	74 2c                	je     801bd6 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801baa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bad:	8b 10                	mov    (%eax),%edx
  801baf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bb4:	8d 40 04             	lea    0x4(%eax),%eax
  801bb7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bba:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801bbf:	eb 9f                	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	8b 10                	mov    (%eax),%edx
  801bc6:	8b 48 04             	mov    0x4(%eax),%ecx
  801bc9:	8d 40 08             	lea    0x8(%eax),%eax
  801bcc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801bcf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801bd4:	eb 8a                	jmp    801b60 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd9:	8b 10                	mov    (%eax),%edx
  801bdb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be0:	8d 40 04             	lea    0x4(%eax),%eax
  801be3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801be6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  801beb:	e9 70 ff ff ff       	jmp    801b60 <vprintfmt+0x38c>
			putch(ch, putdat);
  801bf0:	83 ec 08             	sub    $0x8,%esp
  801bf3:	53                   	push   %ebx
  801bf4:	6a 25                	push   $0x25
  801bf6:	ff d6                	call   *%esi
			break;
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	e9 7a ff ff ff       	jmp    801b7a <vprintfmt+0x3a6>
			putch('%', putdat);
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	53                   	push   %ebx
  801c04:	6a 25                	push   $0x25
  801c06:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 f8                	mov    %edi,%eax
  801c0d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801c11:	74 05                	je     801c18 <vprintfmt+0x444>
  801c13:	83 e8 01             	sub    $0x1,%eax
  801c16:	eb f5                	jmp    801c0d <vprintfmt+0x439>
  801c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c1b:	e9 5a ff ff ff       	jmp    801b7a <vprintfmt+0x3a6>
}
  801c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c23:	5b                   	pop    %ebx
  801c24:	5e                   	pop    %esi
  801c25:	5f                   	pop    %edi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    

00801c28 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c28:	f3 0f 1e fb          	endbr32 
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 18             	sub    $0x18,%esp
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c38:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c3b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801c3f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	74 26                	je     801c73 <vsnprintf+0x4b>
  801c4d:	85 d2                	test   %edx,%edx
  801c4f:	7e 22                	jle    801c73 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c51:	ff 75 14             	pushl  0x14(%ebp)
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	68 92 17 80 00       	push   $0x801792
  801c60:	e8 6f fb ff ff       	call   8017d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c68:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	83 c4 10             	add    $0x10,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    
		return -E_INVAL;
  801c73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c78:	eb f7                	jmp    801c71 <vsnprintf+0x49>

00801c7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c7a:	f3 0f 1e fb          	endbr32 
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c84:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801c87:	50                   	push   %eax
  801c88:	ff 75 10             	pushl  0x10(%ebp)
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	e8 92 ff ff ff       	call   801c28 <vsnprintf>
	va_end(ap);

	return rc;
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801c98:	f3 0f 1e fb          	endbr32 
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801cab:	74 05                	je     801cb2 <strlen+0x1a>
		n++;
  801cad:	83 c0 01             	add    $0x1,%eax
  801cb0:	eb f5                	jmp    801ca7 <strlen+0xf>
	return n;
}
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    

00801cb4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801cb4:	f3 0f 1e fb          	endbr32 
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc6:	39 d0                	cmp    %edx,%eax
  801cc8:	74 0d                	je     801cd7 <strnlen+0x23>
  801cca:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801cce:	74 05                	je     801cd5 <strnlen+0x21>
		n++;
  801cd0:	83 c0 01             	add    $0x1,%eax
  801cd3:	eb f1                	jmp    801cc6 <strnlen+0x12>
  801cd5:	89 c2                	mov    %eax,%edx
	return n;
}
  801cd7:	89 d0                	mov    %edx,%eax
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801cdb:	f3 0f 1e fb          	endbr32 
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	53                   	push   %ebx
  801ce3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  801cf2:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  801cf5:	83 c0 01             	add    $0x1,%eax
  801cf8:	84 d2                	test   %dl,%dl
  801cfa:	75 f2                	jne    801cee <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  801cfc:	89 c8                	mov    %ecx,%eax
  801cfe:	5b                   	pop    %ebx
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801d01:	f3 0f 1e fb          	endbr32 
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	53                   	push   %ebx
  801d09:	83 ec 10             	sub    $0x10,%esp
  801d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801d0f:	53                   	push   %ebx
  801d10:	e8 83 ff ff ff       	call   801c98 <strlen>
  801d15:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	01 d8                	add    %ebx,%eax
  801d1d:	50                   	push   %eax
  801d1e:	e8 b8 ff ff ff       	call   801cdb <strcpy>
	return dst;
}
  801d23:	89 d8                	mov    %ebx,%eax
  801d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801d2a:	f3 0f 1e fb          	endbr32 
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	8b 75 08             	mov    0x8(%ebp),%esi
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	89 f3                	mov    %esi,%ebx
  801d3b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d3e:	89 f0                	mov    %esi,%eax
  801d40:	39 d8                	cmp    %ebx,%eax
  801d42:	74 11                	je     801d55 <strncpy+0x2b>
		*dst++ = *src;
  801d44:	83 c0 01             	add    $0x1,%eax
  801d47:	0f b6 0a             	movzbl (%edx),%ecx
  801d4a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801d4d:	80 f9 01             	cmp    $0x1,%cl
  801d50:	83 da ff             	sbb    $0xffffffff,%edx
  801d53:	eb eb                	jmp    801d40 <strncpy+0x16>
	}
	return ret;
}
  801d55:	89 f0                	mov    %esi,%eax
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801d5b:	f3 0f 1e fb          	endbr32 
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	8b 75 08             	mov    0x8(%ebp),%esi
  801d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d6a:	8b 55 10             	mov    0x10(%ebp),%edx
  801d6d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801d6f:	85 d2                	test   %edx,%edx
  801d71:	74 21                	je     801d94 <strlcpy+0x39>
  801d73:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  801d77:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  801d79:	39 c2                	cmp    %eax,%edx
  801d7b:	74 14                	je     801d91 <strlcpy+0x36>
  801d7d:	0f b6 19             	movzbl (%ecx),%ebx
  801d80:	84 db                	test   %bl,%bl
  801d82:	74 0b                	je     801d8f <strlcpy+0x34>
			*dst++ = *src++;
  801d84:	83 c1 01             	add    $0x1,%ecx
  801d87:	83 c2 01             	add    $0x1,%edx
  801d8a:	88 5a ff             	mov    %bl,-0x1(%edx)
  801d8d:	eb ea                	jmp    801d79 <strlcpy+0x1e>
  801d8f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801d91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801d94:	29 f0                	sub    %esi,%eax
}
  801d96:	5b                   	pop    %ebx
  801d97:	5e                   	pop    %esi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801d9a:	f3 0f 1e fb          	endbr32 
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801da4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801da7:	0f b6 01             	movzbl (%ecx),%eax
  801daa:	84 c0                	test   %al,%al
  801dac:	74 0c                	je     801dba <strcmp+0x20>
  801dae:	3a 02                	cmp    (%edx),%al
  801db0:	75 08                	jne    801dba <strcmp+0x20>
		p++, q++;
  801db2:	83 c1 01             	add    $0x1,%ecx
  801db5:	83 c2 01             	add    $0x1,%edx
  801db8:	eb ed                	jmp    801da7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801dba:	0f b6 c0             	movzbl %al,%eax
  801dbd:	0f b6 12             	movzbl (%edx),%edx
  801dc0:	29 d0                	sub    %edx,%eax
}
  801dc2:	5d                   	pop    %ebp
  801dc3:	c3                   	ret    

00801dc4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801dc4:	f3 0f 1e fb          	endbr32 
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
  801dcb:	53                   	push   %ebx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	89 c3                	mov    %eax,%ebx
  801dd4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801dd7:	eb 06                	jmp    801ddf <strncmp+0x1b>
		n--, p++, q++;
  801dd9:	83 c0 01             	add    $0x1,%eax
  801ddc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801ddf:	39 d8                	cmp    %ebx,%eax
  801de1:	74 16                	je     801df9 <strncmp+0x35>
  801de3:	0f b6 08             	movzbl (%eax),%ecx
  801de6:	84 c9                	test   %cl,%cl
  801de8:	74 04                	je     801dee <strncmp+0x2a>
  801dea:	3a 0a                	cmp    (%edx),%cl
  801dec:	74 eb                	je     801dd9 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801dee:	0f b6 00             	movzbl (%eax),%eax
  801df1:	0f b6 12             	movzbl (%edx),%edx
  801df4:	29 d0                	sub    %edx,%eax
}
  801df6:	5b                   	pop    %ebx
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
		return 0;
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfe:	eb f6                	jmp    801df6 <strncmp+0x32>

00801e00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e00:	f3 0f 1e fb          	endbr32 
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e0e:	0f b6 10             	movzbl (%eax),%edx
  801e11:	84 d2                	test   %dl,%dl
  801e13:	74 09                	je     801e1e <strchr+0x1e>
		if (*s == c)
  801e15:	38 ca                	cmp    %cl,%dl
  801e17:	74 0a                	je     801e23 <strchr+0x23>
	for (; *s; s++)
  801e19:	83 c0 01             	add    $0x1,%eax
  801e1c:	eb f0                	jmp    801e0e <strchr+0xe>
			return (char *) s;
	return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e25:	f3 0f 1e fb          	endbr32 
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801e33:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801e36:	38 ca                	cmp    %cl,%dl
  801e38:	74 09                	je     801e43 <strfind+0x1e>
  801e3a:	84 d2                	test   %dl,%dl
  801e3c:	74 05                	je     801e43 <strfind+0x1e>
	for (; *s; s++)
  801e3e:	83 c0 01             	add    $0x1,%eax
  801e41:	eb f0                	jmp    801e33 <strfind+0xe>
			break;
	return (char *) s;
}
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801e45:	f3 0f 1e fb          	endbr32 
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	57                   	push   %edi
  801e4d:	56                   	push   %esi
  801e4e:	53                   	push   %ebx
  801e4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801e55:	85 c9                	test   %ecx,%ecx
  801e57:	74 31                	je     801e8a <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801e59:	89 f8                	mov    %edi,%eax
  801e5b:	09 c8                	or     %ecx,%eax
  801e5d:	a8 03                	test   $0x3,%al
  801e5f:	75 23                	jne    801e84 <memset+0x3f>
		c &= 0xFF;
  801e61:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801e65:	89 d3                	mov    %edx,%ebx
  801e67:	c1 e3 08             	shl    $0x8,%ebx
  801e6a:	89 d0                	mov    %edx,%eax
  801e6c:	c1 e0 18             	shl    $0x18,%eax
  801e6f:	89 d6                	mov    %edx,%esi
  801e71:	c1 e6 10             	shl    $0x10,%esi
  801e74:	09 f0                	or     %esi,%eax
  801e76:	09 c2                	or     %eax,%edx
  801e78:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801e7a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801e7d:	89 d0                	mov    %edx,%eax
  801e7f:	fc                   	cld    
  801e80:	f3 ab                	rep stos %eax,%es:(%edi)
  801e82:	eb 06                	jmp    801e8a <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	fc                   	cld    
  801e88:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801e8a:	89 f8                	mov    %edi,%eax
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5f                   	pop    %edi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801e91:	f3 0f 1e fb          	endbr32 
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	57                   	push   %edi
  801e99:	56                   	push   %esi
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ea0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ea3:	39 c6                	cmp    %eax,%esi
  801ea5:	73 32                	jae    801ed9 <memmove+0x48>
  801ea7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801eaa:	39 c2                	cmp    %eax,%edx
  801eac:	76 2b                	jbe    801ed9 <memmove+0x48>
		s += n;
		d += n;
  801eae:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801eb1:	89 fe                	mov    %edi,%esi
  801eb3:	09 ce                	or     %ecx,%esi
  801eb5:	09 d6                	or     %edx,%esi
  801eb7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801ebd:	75 0e                	jne    801ecd <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801ebf:	83 ef 04             	sub    $0x4,%edi
  801ec2:	8d 72 fc             	lea    -0x4(%edx),%esi
  801ec5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801ec8:	fd                   	std    
  801ec9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ecb:	eb 09                	jmp    801ed6 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ecd:	83 ef 01             	sub    $0x1,%edi
  801ed0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801ed3:	fd                   	std    
  801ed4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ed6:	fc                   	cld    
  801ed7:	eb 1a                	jmp    801ef3 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801ed9:	89 c2                	mov    %eax,%edx
  801edb:	09 ca                	or     %ecx,%edx
  801edd:	09 f2                	or     %esi,%edx
  801edf:	f6 c2 03             	test   $0x3,%dl
  801ee2:	75 0a                	jne    801eee <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801ee4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801ee7:	89 c7                	mov    %eax,%edi
  801ee9:	fc                   	cld    
  801eea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801eec:	eb 05                	jmp    801ef3 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  801eee:	89 c7                	mov    %eax,%edi
  801ef0:	fc                   	cld    
  801ef1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801ef7:	f3 0f 1e fb          	endbr32 
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	e8 82 ff ff ff       	call   801e91 <memmove>
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801f11:	f3 0f 1e fb          	endbr32 
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	56                   	push   %esi
  801f19:	53                   	push   %ebx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f20:	89 c6                	mov    %eax,%esi
  801f22:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801f25:	39 f0                	cmp    %esi,%eax
  801f27:	74 1c                	je     801f45 <memcmp+0x34>
		if (*s1 != *s2)
  801f29:	0f b6 08             	movzbl (%eax),%ecx
  801f2c:	0f b6 1a             	movzbl (%edx),%ebx
  801f2f:	38 d9                	cmp    %bl,%cl
  801f31:	75 08                	jne    801f3b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801f33:	83 c0 01             	add    $0x1,%eax
  801f36:	83 c2 01             	add    $0x1,%edx
  801f39:	eb ea                	jmp    801f25 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801f3b:	0f b6 c1             	movzbl %cl,%eax
  801f3e:	0f b6 db             	movzbl %bl,%ebx
  801f41:	29 d8                	sub    %ebx,%eax
  801f43:	eb 05                	jmp    801f4a <memcmp+0x39>
	}

	return 0;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	5b                   	pop    %ebx
  801f4b:	5e                   	pop    %esi
  801f4c:	5d                   	pop    %ebp
  801f4d:	c3                   	ret    

00801f4e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801f4e:	f3 0f 1e fb          	endbr32 
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801f5b:	89 c2                	mov    %eax,%edx
  801f5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801f60:	39 d0                	cmp    %edx,%eax
  801f62:	73 09                	jae    801f6d <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f64:	38 08                	cmp    %cl,(%eax)
  801f66:	74 05                	je     801f6d <memfind+0x1f>
	for (; s < ends; s++)
  801f68:	83 c0 01             	add    $0x1,%eax
  801f6b:	eb f3                	jmp    801f60 <memfind+0x12>
			break;
	return (void *) s;
}
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f6f:	f3 0f 1e fb          	endbr32 
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	57                   	push   %edi
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
  801f79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f7f:	eb 03                	jmp    801f84 <strtol+0x15>
		s++;
  801f81:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801f84:	0f b6 01             	movzbl (%ecx),%eax
  801f87:	3c 20                	cmp    $0x20,%al
  801f89:	74 f6                	je     801f81 <strtol+0x12>
  801f8b:	3c 09                	cmp    $0x9,%al
  801f8d:	74 f2                	je     801f81 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801f8f:	3c 2b                	cmp    $0x2b,%al
  801f91:	74 2a                	je     801fbd <strtol+0x4e>
	int neg = 0;
  801f93:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801f98:	3c 2d                	cmp    $0x2d,%al
  801f9a:	74 2b                	je     801fc7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f9c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801fa2:	75 0f                	jne    801fb3 <strtol+0x44>
  801fa4:	80 39 30             	cmpb   $0x30,(%ecx)
  801fa7:	74 28                	je     801fd1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801fa9:	85 db                	test   %ebx,%ebx
  801fab:	b8 0a 00 00 00       	mov    $0xa,%eax
  801fb0:	0f 44 d8             	cmove  %eax,%ebx
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801fbb:	eb 46                	jmp    802003 <strtol+0x94>
		s++;
  801fbd:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc5:	eb d5                	jmp    801f9c <strtol+0x2d>
		s++, neg = 1;
  801fc7:	83 c1 01             	add    $0x1,%ecx
  801fca:	bf 01 00 00 00       	mov    $0x1,%edi
  801fcf:	eb cb                	jmp    801f9c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801fd1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801fd5:	74 0e                	je     801fe5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801fd7:	85 db                	test   %ebx,%ebx
  801fd9:	75 d8                	jne    801fb3 <strtol+0x44>
		s++, base = 8;
  801fdb:	83 c1 01             	add    $0x1,%ecx
  801fde:	bb 08 00 00 00       	mov    $0x8,%ebx
  801fe3:	eb ce                	jmp    801fb3 <strtol+0x44>
		s += 2, base = 16;
  801fe5:	83 c1 02             	add    $0x2,%ecx
  801fe8:	bb 10 00 00 00       	mov    $0x10,%ebx
  801fed:	eb c4                	jmp    801fb3 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801fef:	0f be d2             	movsbl %dl,%edx
  801ff2:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ff5:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ff8:	7d 3a                	jge    802034 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ffa:	83 c1 01             	add    $0x1,%ecx
  801ffd:	0f af 45 10          	imul   0x10(%ebp),%eax
  802001:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802003:	0f b6 11             	movzbl (%ecx),%edx
  802006:	8d 72 d0             	lea    -0x30(%edx),%esi
  802009:	89 f3                	mov    %esi,%ebx
  80200b:	80 fb 09             	cmp    $0x9,%bl
  80200e:	76 df                	jbe    801fef <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  802010:	8d 72 9f             	lea    -0x61(%edx),%esi
  802013:	89 f3                	mov    %esi,%ebx
  802015:	80 fb 19             	cmp    $0x19,%bl
  802018:	77 08                	ja     802022 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80201a:	0f be d2             	movsbl %dl,%edx
  80201d:	83 ea 57             	sub    $0x57,%edx
  802020:	eb d3                	jmp    801ff5 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  802022:	8d 72 bf             	lea    -0x41(%edx),%esi
  802025:	89 f3                	mov    %esi,%ebx
  802027:	80 fb 19             	cmp    $0x19,%bl
  80202a:	77 08                	ja     802034 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80202c:	0f be d2             	movsbl %dl,%edx
  80202f:	83 ea 37             	sub    $0x37,%edx
  802032:	eb c1                	jmp    801ff5 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  802034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802038:	74 05                	je     80203f <strtol+0xd0>
		*endptr = (char *) s;
  80203a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80203d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80203f:	89 c2                	mov    %eax,%edx
  802041:	f7 da                	neg    %edx
  802043:	85 ff                	test   %edi,%edi
  802045:	0f 45 c2             	cmovne %edx,%eax
}
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5f                   	pop    %edi
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    

0080204d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80204d:	f3 0f 1e fb          	endbr32 
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802057:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80205e:	74 0a                	je     80206a <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  80206a:	a1 08 40 80 00       	mov    0x804008,%eax
  80206f:	8b 40 48             	mov    0x48(%eax),%eax
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	6a 07                	push   $0x7
  802077:	68 00 f0 bf ee       	push   $0xeebff000
  80207c:	50                   	push   %eax
  80207d:	e8 0e e1 ff ff       	call   800190 <sys_page_alloc>
  802082:	83 c4 10             	add    $0x10,%esp
  802085:	85 c0                	test   %eax,%eax
  802087:	75 31                	jne    8020ba <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802089:	a1 08 40 80 00       	mov    0x804008,%eax
  80208e:	8b 40 48             	mov    0x48(%eax),%eax
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	68 c4 03 80 00       	push   $0x8003c4
  802099:	50                   	push   %eax
  80209a:	e8 50 e2 ff ff       	call   8002ef <sys_env_set_pgfault_upcall>
  80209f:	83 c4 10             	add    $0x10,%esp
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	74 ba                	je     802060 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  8020a6:	83 ec 04             	sub    $0x4,%esp
  8020a9:	68 28 29 80 00       	push   $0x802928
  8020ae:	6a 24                	push   $0x24
  8020b0:	68 56 29 80 00       	push   $0x802956
  8020b5:	e8 30 f5 ff ff       	call   8015ea <_panic>
			panic("set_pgfault_handler page_alloc failed");
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	68 00 29 80 00       	push   $0x802900
  8020c2:	6a 21                	push   $0x21
  8020c4:	68 56 29 80 00       	push   $0x802956
  8020c9:	e8 1c f5 ff ff       	call   8015ea <_panic>

008020ce <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020ce:	f3 0f 1e fb          	endbr32 
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	56                   	push   %esi
  8020d6:	53                   	push   %ebx
  8020d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8020da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8020e0:	83 e8 01             	sub    $0x1,%eax
  8020e3:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8020e8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020ed:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8020f1:	83 ec 0c             	sub    $0xc,%esp
  8020f4:	50                   	push   %eax
  8020f5:	e8 62 e2 ff ff       	call   80035c <sys_ipc_recv>
	if (!t) {
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	75 2b                	jne    80212c <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802101:	85 f6                	test   %esi,%esi
  802103:	74 0a                	je     80210f <ipc_recv+0x41>
  802105:	a1 08 40 80 00       	mov    0x804008,%eax
  80210a:	8b 40 74             	mov    0x74(%eax),%eax
  80210d:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80210f:	85 db                	test   %ebx,%ebx
  802111:	74 0a                	je     80211d <ipc_recv+0x4f>
  802113:	a1 08 40 80 00       	mov    0x804008,%eax
  802118:	8b 40 78             	mov    0x78(%eax),%eax
  80211b:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80211d:	a1 08 40 80 00       	mov    0x804008,%eax
  802122:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802125:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802128:	5b                   	pop    %ebx
  802129:	5e                   	pop    %esi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80212c:	85 f6                	test   %esi,%esi
  80212e:	74 06                	je     802136 <ipc_recv+0x68>
  802130:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802136:	85 db                	test   %ebx,%ebx
  802138:	74 eb                	je     802125 <ipc_recv+0x57>
  80213a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802140:	eb e3                	jmp    802125 <ipc_recv+0x57>

00802142 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802142:	f3 0f 1e fb          	endbr32 
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	57                   	push   %edi
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802152:	8b 75 0c             	mov    0xc(%ebp),%esi
  802155:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802158:	85 db                	test   %ebx,%ebx
  80215a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80215f:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802162:	ff 75 14             	pushl  0x14(%ebp)
  802165:	53                   	push   %ebx
  802166:	56                   	push   %esi
  802167:	57                   	push   %edi
  802168:	e8 c8 e1 ff ff       	call   800335 <sys_ipc_try_send>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	74 1e                	je     802192 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802174:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802177:	75 07                	jne    802180 <ipc_send+0x3e>
		sys_yield();
  802179:	e8 ef df ff ff       	call   80016d <sys_yield>
  80217e:	eb e2                	jmp    802162 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802180:	50                   	push   %eax
  802181:	68 64 29 80 00       	push   $0x802964
  802186:	6a 39                	push   $0x39
  802188:	68 76 29 80 00       	push   $0x802976
  80218d:	e8 58 f4 ff ff       	call   8015ea <_panic>
	}
	//panic("ipc_send not implemented");
}
  802192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5f                   	pop    %edi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    

0080219a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80219a:	f3 0f 1e fb          	endbr32 
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021a9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b2:	8b 52 50             	mov    0x50(%edx),%edx
  8021b5:	39 ca                	cmp    %ecx,%edx
  8021b7:	74 11                	je     8021ca <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021b9:	83 c0 01             	add    $0x1,%eax
  8021bc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c1:	75 e6                	jne    8021a9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	eb 0b                	jmp    8021d5 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d5:	5d                   	pop    %ebp
  8021d6:	c3                   	ret    

008021d7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d7:	f3 0f 1e fb          	endbr32 
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e1:	89 c2                	mov    %eax,%edx
  8021e3:	c1 ea 16             	shr    $0x16,%edx
  8021e6:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ed:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f2:	f6 c1 01             	test   $0x1,%cl
  8021f5:	74 1c                	je     802213 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021f7:	c1 e8 0c             	shr    $0xc,%eax
  8021fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802201:	a8 01                	test   $0x1,%al
  802203:	74 0e                	je     802213 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802205:	c1 e8 0c             	shr    $0xc,%eax
  802208:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80220f:	ef 
  802210:	0f b7 d2             	movzwl %dx,%edx
}
  802213:	89 d0                	mov    %edx,%eax
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    
  802217:	66 90                	xchg   %ax,%ax
  802219:	66 90                	xchg   %ax,%ax
  80221b:	66 90                	xchg   %ax,%ax
  80221d:	66 90                	xchg   %ax,%ax
  80221f:	90                   	nop

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
