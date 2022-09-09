
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 b8 05 00 00       	call   8005e9 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 51 2a 80 00       	push   $0x802a51
  800049:	68 20 2a 80 00       	push   $0x802a20
  80004e:	e8 e5 06 00 00       	call   800738 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 30 2a 80 00       	push   $0x802a30
  80005c:	68 34 2a 80 00       	push   $0x802a34
  800061:	e8 d2 06 00 00       	call   800738 <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 2e 02 00 00    	je     8002a1 <check_regs+0x26e>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 48 2a 80 00       	push   $0x802a48
  80007b:	e8 b8 06 00 00       	call   800738 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 52 2a 80 00       	push   $0x802a52
  800093:	68 34 2a 80 00       	push   $0x802a34
  800098:	e8 9b 06 00 00       	call   800738 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 0f 02 00 00    	je     8002bb <check_regs+0x288>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 48 2a 80 00       	push   $0x802a48
  8000b4:	e8 7f 06 00 00       	call   800738 <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 56 2a 80 00       	push   $0x802a56
  8000cc:	68 34 2a 80 00       	push   $0x802a34
  8000d1:	e8 62 06 00 00       	call   800738 <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 eb 01 00 00    	je     8002d0 <check_regs+0x29d>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 48 2a 80 00       	push   $0x802a48
  8000ed:	e8 46 06 00 00       	call   800738 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 5a 2a 80 00       	push   $0x802a5a
  800105:	68 34 2a 80 00       	push   $0x802a34
  80010a:	e8 29 06 00 00       	call   800738 <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 c7 01 00 00    	je     8002e5 <check_regs+0x2b2>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 48 2a 80 00       	push   $0x802a48
  800126:	e8 0d 06 00 00       	call   800738 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 5e 2a 80 00       	push   $0x802a5e
  80013e:	68 34 2a 80 00       	push   $0x802a34
  800143:	e8 f0 05 00 00       	call   800738 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a3 01 00 00    	je     8002fa <check_regs+0x2c7>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 48 2a 80 00       	push   $0x802a48
  80015f:	e8 d4 05 00 00       	call   800738 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 62 2a 80 00       	push   $0x802a62
  800177:	68 34 2a 80 00       	push   $0x802a34
  80017c:	e8 b7 05 00 00       	call   800738 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 7f 01 00 00    	je     80030f <check_regs+0x2dc>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 48 2a 80 00       	push   $0x802a48
  800198:	e8 9b 05 00 00       	call   800738 <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 66 2a 80 00       	push   $0x802a66
  8001b0:	68 34 2a 80 00       	push   $0x802a34
  8001b5:	e8 7e 05 00 00       	call   800738 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5b 01 00 00    	je     800324 <check_regs+0x2f1>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 48 2a 80 00       	push   $0x802a48
  8001d1:	e8 62 05 00 00       	call   800738 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 6a 2a 80 00       	push   $0x802a6a
  8001e9:	68 34 2a 80 00       	push   $0x802a34
  8001ee:	e8 45 05 00 00       	call   800738 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 37 01 00 00    	je     800339 <check_regs+0x306>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 48 2a 80 00       	push   $0x802a48
  80020a:	e8 29 05 00 00       	call   800738 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 6e 2a 80 00       	push   $0x802a6e
  800222:	68 34 2a 80 00       	push   $0x802a34
  800227:	e8 0c 05 00 00       	call   800738 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 13 01 00 00    	je     80034e <check_regs+0x31b>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 48 2a 80 00       	push   $0x802a48
  800243:	e8 f0 04 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 75 2a 80 00       	push   $0x802a75
  800253:	68 34 2a 80 00       	push   $0x802a34
  800258:	e8 db 04 00 00       	call   800738 <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 48 2a 80 00       	push   $0x802a48
  800274:	e8 bf 04 00 00       	call   800738 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 79 2a 80 00       	push   $0x802a79
  800284:	e8 af 04 00 00       	call   800738 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 48 2a 80 00       	push   $0x802a48
  800294:	e8 9f 04 00 00       	call   800738 <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	e9 16 01 00 00       	jmp    8003b7 <check_regs+0x384>
	CHECK(edi, regs.reg_edi);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	68 44 2a 80 00       	push   $0x802a44
  8002a9:	e8 8a 04 00 00       	call   800738 <cprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b6:	e9 cd fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 44 2a 80 00       	push   $0x802a44
  8002c3:	e8 70 04 00 00       	call   800738 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
  8002cb:	e9 f1 fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	68 44 2a 80 00       	push   $0x802a44
  8002d8:	e8 5b 04 00 00       	call   800738 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	e9 15 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 44 2a 80 00       	push   $0x802a44
  8002ed:	e8 46 04 00 00       	call   800738 <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	e9 39 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	68 44 2a 80 00       	push   $0x802a44
  800302:	e8 31 04 00 00       	call   800738 <cprintf>
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	e9 5d fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	68 44 2a 80 00       	push   $0x802a44
  800317:	e8 1c 04 00 00       	call   800738 <cprintf>
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	e9 81 fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 44 2a 80 00       	push   $0x802a44
  80032c:	e8 07 04 00 00       	call   800738 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
  800334:	e9 a5 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	68 44 2a 80 00       	push   $0x802a44
  800341:	e8 f2 03 00 00       	call   800738 <cprintf>
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	e9 c9 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	68 44 2a 80 00       	push   $0x802a44
  800356:	e8 dd 03 00 00       	call   800738 <cprintf>
	CHECK(esp, esp);
  80035b:	ff 73 28             	pushl  0x28(%ebx)
  80035e:	ff 76 28             	pushl  0x28(%esi)
  800361:	68 75 2a 80 00       	push   $0x802a75
  800366:	68 34 2a 80 00       	push   $0x802a34
  80036b:	e8 c8 03 00 00       	call   800738 <cprintf>
  800370:	83 c4 20             	add    $0x20,%esp
  800373:	8b 43 28             	mov    0x28(%ebx),%eax
  800376:	39 46 28             	cmp    %eax,0x28(%esi)
  800379:	0f 85 ed fe ff ff    	jne    80026c <check_regs+0x239>
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 44 2a 80 00       	push   $0x802a44
  800387:	e8 ac 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  80038c:	83 c4 08             	add    $0x8,%esp
  80038f:	ff 75 0c             	pushl  0xc(%ebp)
  800392:	68 79 2a 80 00       	push   $0x802a79
  800397:	e8 9c 03 00 00       	call   800738 <cprintf>
	if (!mismatch)
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	85 ff                	test   %edi,%edi
  8003a1:	0f 85 e5 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	68 44 2a 80 00       	push   $0x802a44
  8003af:	e8 84 03 00 00       	call   800738 <cprintf>
  8003b4:	83 c4 10             	add    $0x10,%esp
}
  8003b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 44 2a 80 00       	push   $0x802a44
  8003c7:	e8 6c 03 00 00       	call   800738 <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 79 2a 80 00       	push   $0x802a79
  8003d7:	e8 5c 03 00 00       	call   800738 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003f1:	8b 10                	mov    (%eax),%edx
  8003f3:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f9:	0f 85 a3 00 00 00    	jne    8004a2 <pgfault+0xbe>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003ff:	8b 50 08             	mov    0x8(%eax),%edx
  800402:	89 15 40 50 80 00    	mov    %edx,0x805040
  800408:	8b 50 0c             	mov    0xc(%eax),%edx
  80040b:	89 15 44 50 80 00    	mov    %edx,0x805044
  800411:	8b 50 10             	mov    0x10(%eax),%edx
  800414:	89 15 48 50 80 00    	mov    %edx,0x805048
  80041a:	8b 50 14             	mov    0x14(%eax),%edx
  80041d:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  800423:	8b 50 18             	mov    0x18(%eax),%edx
  800426:	89 15 50 50 80 00    	mov    %edx,0x805050
  80042c:	8b 50 1c             	mov    0x1c(%eax),%edx
  80042f:	89 15 54 50 80 00    	mov    %edx,0x805054
  800435:	8b 50 20             	mov    0x20(%eax),%edx
  800438:	89 15 58 50 80 00    	mov    %edx,0x805058
  80043e:	8b 50 24             	mov    0x24(%eax),%edx
  800441:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800447:	8b 50 28             	mov    0x28(%eax),%edx
  80044a:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags & ~FL_RF;
  800450:	8b 50 2c             	mov    0x2c(%eax),%edx
  800453:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800459:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  80045f:	8b 40 30             	mov    0x30(%eax),%eax
  800462:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	68 9f 2a 80 00       	push   $0x802a9f
  80046f:	68 ad 2a 80 00       	push   $0x802aad
  800474:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800479:	ba 98 2a 80 00       	mov    $0x802a98,%edx
  80047e:	b8 80 50 80 00       	mov    $0x805080,%eax
  800483:	e8 ab fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800488:	83 c4 0c             	add    $0xc,%esp
  80048b:	6a 07                	push   $0x7
  80048d:	68 00 00 40 00       	push   $0x400000
  800492:	6a 00                	push   $0x0
  800494:	e8 eb 0c 00 00       	call   801184 <sys_page_alloc>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 c0                	test   %eax,%eax
  80049e:	78 1a                	js     8004ba <pgfault+0xd6>
		panic("sys_page_alloc: %e", r);
}
  8004a0:	c9                   	leave  
  8004a1:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	ff 70 28             	pushl  0x28(%eax)
  8004a8:	52                   	push   %edx
  8004a9:	68 e0 2a 80 00       	push   $0x802ae0
  8004ae:	6a 50                	push   $0x50
  8004b0:	68 87 2a 80 00       	push   $0x802a87
  8004b5:	e8 97 01 00 00       	call   800651 <_panic>
		panic("sys_page_alloc: %e", r);
  8004ba:	50                   	push   %eax
  8004bb:	68 b4 2a 80 00       	push   $0x802ab4
  8004c0:	6a 5c                	push   $0x5c
  8004c2:	68 87 2a 80 00       	push   $0x802a87
  8004c7:	e8 85 01 00 00       	call   800651 <_panic>

008004cc <umain>:

void
umain(int argc, char **argv)
{
  8004cc:	f3 0f 1e fb          	endbr32 
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  8004d6:	68 e4 03 80 00       	push   $0x8003e4
  8004db:	e8 d8 0e 00 00       	call   8013b8 <set_pgfault_handler>

	asm volatile(
  8004e0:	50                   	push   %eax
  8004e1:	9c                   	pushf  
  8004e2:	58                   	pop    %eax
  8004e3:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004e8:	50                   	push   %eax
  8004e9:	9d                   	popf   
  8004ea:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004ef:	8d 05 2a 05 80 00    	lea    0x80052a,%eax
  8004f5:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004fa:	58                   	pop    %eax
  8004fb:	89 3d 80 50 80 00    	mov    %edi,0x805080
  800501:	89 35 84 50 80 00    	mov    %esi,0x805084
  800507:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  80050d:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  800513:	89 15 94 50 80 00    	mov    %edx,0x805094
  800519:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  80051f:	a3 9c 50 80 00       	mov    %eax,0x80509c
  800524:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  80052a:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  800531:	00 00 00 
  800534:	89 3d 00 50 80 00    	mov    %edi,0x805000
  80053a:	89 35 04 50 80 00    	mov    %esi,0x805004
  800540:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  800546:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  80054c:	89 15 14 50 80 00    	mov    %edx,0x805014
  800552:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  800558:	a3 1c 50 80 00       	mov    %eax,0x80501c
  80055d:	89 25 28 50 80 00    	mov    %esp,0x805028
  800563:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  800569:	8b 35 84 50 80 00    	mov    0x805084,%esi
  80056f:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  800575:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  80057b:	8b 15 94 50 80 00    	mov    0x805094,%edx
  800581:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  800587:	a1 9c 50 80 00       	mov    0x80509c,%eax
  80058c:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  800592:	50                   	push   %eax
  800593:	9c                   	pushf  
  800594:	58                   	pop    %eax
  800595:	a3 24 50 80 00       	mov    %eax,0x805024
  80059a:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  8005a5:	75 30                	jne    8005d7 <umain+0x10b>
		cprintf("EIP after page-fault MISMATCH\n");
	after.eip = before.eip;
  8005a7:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  8005ac:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	68 c7 2a 80 00       	push   $0x802ac7
  8005b9:	68 d8 2a 80 00       	push   $0x802ad8
  8005be:	b9 00 50 80 00       	mov    $0x805000,%ecx
  8005c3:	ba 98 2a 80 00       	mov    $0x802a98,%edx
  8005c8:	b8 80 50 80 00       	mov    $0x805080,%eax
  8005cd:	e8 61 fa ff ff       	call   800033 <check_regs>
}
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    
		cprintf("EIP after page-fault MISMATCH\n");
  8005d7:	83 ec 0c             	sub    $0xc,%esp
  8005da:	68 14 2b 80 00       	push   $0x802b14
  8005df:	e8 54 01 00 00       	call   800738 <cprintf>
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb be                	jmp    8005a7 <umain+0xdb>

008005e9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005e9:	f3 0f 1e fb          	endbr32 
  8005ed:	55                   	push   %ebp
  8005ee:	89 e5                	mov    %esp,%ebp
  8005f0:	56                   	push   %esi
  8005f1:	53                   	push   %ebx
  8005f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005f8:	e8 41 0b 00 00       	call   80113e <sys_getenvid>
  8005fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800602:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800605:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060a:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060f:	85 db                	test   %ebx,%ebx
  800611:	7e 07                	jle    80061a <libmain+0x31>
		binaryname = argv[0];
  800613:	8b 06                	mov    (%esi),%eax
  800615:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	56                   	push   %esi
  80061e:	53                   	push   %ebx
  80061f:	e8 a8 fe ff ff       	call   8004cc <umain>

	// exit gracefully
	exit();
  800624:	e8 0a 00 00 00       	call   800633 <exit>
}
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80062f:	5b                   	pop    %ebx
  800630:	5e                   	pop    %esi
  800631:	5d                   	pop    %ebp
  800632:	c3                   	ret    

00800633 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800633:	f3 0f 1e fb          	endbr32 
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80063d:	e8 0f 10 00 00       	call   801651 <close_all>
	sys_env_destroy(0);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	6a 00                	push   $0x0
  800647:	e8 ad 0a 00 00       	call   8010f9 <sys_env_destroy>
}
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800651:	f3 0f 1e fb          	endbr32 
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	56                   	push   %esi
  800659:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80065a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80065d:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800663:	e8 d6 0a 00 00       	call   80113e <sys_getenvid>
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	ff 75 08             	pushl  0x8(%ebp)
  800671:	56                   	push   %esi
  800672:	50                   	push   %eax
  800673:	68 40 2b 80 00       	push   $0x802b40
  800678:	e8 bb 00 00 00       	call   800738 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80067d:	83 c4 18             	add    $0x18,%esp
  800680:	53                   	push   %ebx
  800681:	ff 75 10             	pushl  0x10(%ebp)
  800684:	e8 5a 00 00 00       	call   8006e3 <vcprintf>
	cprintf("\n");
  800689:	c7 04 24 50 2a 80 00 	movl   $0x802a50,(%esp)
  800690:	e8 a3 00 00 00       	call   800738 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800698:	cc                   	int3   
  800699:	eb fd                	jmp    800698 <_panic+0x47>

0080069b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80069b:	f3 0f 1e fb          	endbr32 
  80069f:	55                   	push   %ebp
  8006a0:	89 e5                	mov    %esp,%ebp
  8006a2:	53                   	push   %ebx
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006a9:	8b 13                	mov    (%ebx),%edx
  8006ab:	8d 42 01             	lea    0x1(%edx),%eax
  8006ae:	89 03                	mov    %eax,(%ebx)
  8006b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bc:	74 09                	je     8006c7 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006be:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c5:	c9                   	leave  
  8006c6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	68 ff 00 00 00       	push   $0xff
  8006cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8006d2:	50                   	push   %eax
  8006d3:	e8 dc 09 00 00       	call   8010b4 <sys_cputs>
		b->idx = 0;
  8006d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	eb db                	jmp    8006be <putch+0x23>

008006e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006e3:	f3 0f 1e fb          	endbr32 
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f7:	00 00 00 
	b.cnt = 0;
  8006fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800701:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	ff 75 08             	pushl  0x8(%ebp)
  80070a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	68 9b 06 80 00       	push   $0x80069b
  800716:	e8 20 01 00 00       	call   80083b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80071b:	83 c4 08             	add    $0x8,%esp
  80071e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800724:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80072a:	50                   	push   %eax
  80072b:	e8 84 09 00 00       	call   8010b4 <sys_cputs>

	return b.cnt;
}
  800730:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800738:	f3 0f 1e fb          	endbr32 
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800742:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800745:	50                   	push   %eax
  800746:	ff 75 08             	pushl  0x8(%ebp)
  800749:	e8 95 ff ff ff       	call   8006e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80074e:	c9                   	leave  
  80074f:	c3                   	ret    

00800750 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	57                   	push   %edi
  800754:	56                   	push   %esi
  800755:	53                   	push   %ebx
  800756:	83 ec 1c             	sub    $0x1c,%esp
  800759:	89 c7                	mov    %eax,%edi
  80075b:	89 d6                	mov    %edx,%esi
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 55 0c             	mov    0xc(%ebp),%edx
  800763:	89 d1                	mov    %edx,%ecx
  800765:	89 c2                	mov    %eax,%edx
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800773:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800776:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800782:	72 3e                	jb     8007c2 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800784:	83 ec 0c             	sub    $0xc,%esp
  800787:	ff 75 18             	pushl  0x18(%ebp)
  80078a:	83 eb 01             	sub    $0x1,%ebx
  80078d:	53                   	push   %ebx
  80078e:	50                   	push   %eax
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 e4             	pushl  -0x1c(%ebp)
  800795:	ff 75 e0             	pushl  -0x20(%ebp)
  800798:	ff 75 dc             	pushl  -0x24(%ebp)
  80079b:	ff 75 d8             	pushl  -0x28(%ebp)
  80079e:	e8 0d 20 00 00       	call   8027b0 <__udivdi3>
  8007a3:	83 c4 18             	add    $0x18,%esp
  8007a6:	52                   	push   %edx
  8007a7:	50                   	push   %eax
  8007a8:	89 f2                	mov    %esi,%edx
  8007aa:	89 f8                	mov    %edi,%eax
  8007ac:	e8 9f ff ff ff       	call   800750 <printnum>
  8007b1:	83 c4 20             	add    $0x20,%esp
  8007b4:	eb 13                	jmp    8007c9 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	56                   	push   %esi
  8007ba:	ff 75 18             	pushl  0x18(%ebp)
  8007bd:	ff d7                	call   *%edi
  8007bf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007c2:	83 eb 01             	sub    $0x1,%ebx
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	7f ed                	jg     8007b6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	56                   	push   %esi
  8007cd:	83 ec 04             	sub    $0x4,%esp
  8007d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8007d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007dc:	e8 df 20 00 00       	call   8028c0 <__umoddi3>
  8007e1:	83 c4 14             	add    $0x14,%esp
  8007e4:	0f be 80 63 2b 80 00 	movsbl 0x802b63(%eax),%eax
  8007eb:	50                   	push   %eax
  8007ec:	ff d7                	call   *%edi
}
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f4:	5b                   	pop    %ebx
  8007f5:	5e                   	pop    %esi
  8007f6:	5f                   	pop    %edi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800803:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800807:	8b 10                	mov    (%eax),%edx
  800809:	3b 50 04             	cmp    0x4(%eax),%edx
  80080c:	73 0a                	jae    800818 <sprintputch+0x1f>
		*b->buf++ = ch;
  80080e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800811:	89 08                	mov    %ecx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	88 02                	mov    %al,(%edx)
}
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <printfmt>:
{
  80081a:	f3 0f 1e fb          	endbr32 
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800827:	50                   	push   %eax
  800828:	ff 75 10             	pushl  0x10(%ebp)
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 05 00 00 00       	call   80083b <vprintfmt>
}
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	c9                   	leave  
  80083a:	c3                   	ret    

0080083b <vprintfmt>:
{
  80083b:	f3 0f 1e fb          	endbr32 
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	57                   	push   %edi
  800843:	56                   	push   %esi
  800844:	53                   	push   %ebx
  800845:	83 ec 3c             	sub    $0x3c,%esp
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80084e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800851:	e9 8e 03 00 00       	jmp    800be4 <vprintfmt+0x3a9>
		padc = ' ';
  800856:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80085a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800861:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800868:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80086f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800874:	8d 47 01             	lea    0x1(%edi),%eax
  800877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087a:	0f b6 17             	movzbl (%edi),%edx
  80087d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800880:	3c 55                	cmp    $0x55,%al
  800882:	0f 87 df 03 00 00    	ja     800c67 <vprintfmt+0x42c>
  800888:	0f b6 c0             	movzbl %al,%eax
  80088b:	3e ff 24 85 a0 2c 80 	notrack jmp *0x802ca0(,%eax,4)
  800892:	00 
  800893:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800896:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80089a:	eb d8                	jmp    800874 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80089c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80089f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8008a3:	eb cf                	jmp    800874 <vprintfmt+0x39>
  8008a5:	0f b6 d2             	movzbl %dl,%edx
  8008a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8008b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8008ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8008bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8008c0:	83 f9 09             	cmp    $0x9,%ecx
  8008c3:	77 55                	ja     80091a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8008c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8008c8:	eb e9                	jmp    8008b3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 40 04             	lea    0x4(%eax),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008e2:	79 90                	jns    800874 <vprintfmt+0x39>
				width = precision, precision = -1;
  8008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ea:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8008f1:	eb 81                	jmp    800874 <vprintfmt+0x39>
  8008f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008fd:	0f 49 d0             	cmovns %eax,%edx
  800900:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800903:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800906:	e9 69 ff ff ff       	jmp    800874 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80090b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80090e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800915:	e9 5a ff ff ff       	jmp    800874 <vprintfmt+0x39>
  80091a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80091d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800920:	eb bc                	jmp    8008de <vprintfmt+0xa3>
			lflag++;
  800922:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800928:	e9 47 ff ff ff       	jmp    800874 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	8d 78 04             	lea    0x4(%eax),%edi
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	53                   	push   %ebx
  800937:	ff 30                	pushl  (%eax)
  800939:	ff d6                	call   *%esi
			break;
  80093b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80093e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800941:	e9 9b 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	8d 78 04             	lea    0x4(%eax),%edi
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	99                   	cltd   
  80094f:	31 d0                	xor    %edx,%eax
  800951:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800953:	83 f8 0f             	cmp    $0xf,%eax
  800956:	7f 23                	jg     80097b <vprintfmt+0x140>
  800958:	8b 14 85 00 2e 80 00 	mov    0x802e00(,%eax,4),%edx
  80095f:	85 d2                	test   %edx,%edx
  800961:	74 18                	je     80097b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800963:	52                   	push   %edx
  800964:	68 99 2f 80 00       	push   $0x802f99
  800969:	53                   	push   %ebx
  80096a:	56                   	push   %esi
  80096b:	e8 aa fe ff ff       	call   80081a <printfmt>
  800970:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800973:	89 7d 14             	mov    %edi,0x14(%ebp)
  800976:	e9 66 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80097b:	50                   	push   %eax
  80097c:	68 7b 2b 80 00       	push   $0x802b7b
  800981:	53                   	push   %ebx
  800982:	56                   	push   %esi
  800983:	e8 92 fe ff ff       	call   80081a <printfmt>
  800988:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80098b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80098e:	e9 4e 02 00 00       	jmp    800be1 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800993:	8b 45 14             	mov    0x14(%ebp),%eax
  800996:	83 c0 04             	add    $0x4,%eax
  800999:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8009a1:	85 d2                	test   %edx,%edx
  8009a3:	b8 74 2b 80 00       	mov    $0x802b74,%eax
  8009a8:	0f 45 c2             	cmovne %edx,%eax
  8009ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8009ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b2:	7e 06                	jle    8009ba <vprintfmt+0x17f>
  8009b4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8009b8:	75 0d                	jne    8009c7 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8009bd:	89 c7                	mov    %eax,%edi
  8009bf:	03 45 e0             	add    -0x20(%ebp),%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009c5:	eb 55                	jmp    800a1c <vprintfmt+0x1e1>
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8009cd:	ff 75 cc             	pushl  -0x34(%ebp)
  8009d0:	e8 46 03 00 00       	call   800d1b <strnlen>
  8009d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d8:	29 c2                	sub    %eax,%edx
  8009da:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8009e2:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e9:	85 ff                	test   %edi,%edi
  8009eb:	7e 11                	jle    8009fe <vprintfmt+0x1c3>
					putch(padc, putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	53                   	push   %ebx
  8009f1:	ff 75 e0             	pushl  -0x20(%ebp)
  8009f4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f6:	83 ef 01             	sub    $0x1,%edi
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	eb eb                	jmp    8009e9 <vprintfmt+0x1ae>
  8009fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a01:	85 d2                	test   %edx,%edx
  800a03:	b8 00 00 00 00       	mov    $0x0,%eax
  800a08:	0f 49 c2             	cmovns %edx,%eax
  800a0b:	29 c2                	sub    %eax,%edx
  800a0d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800a10:	eb a8                	jmp    8009ba <vprintfmt+0x17f>
					putch(ch, putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	53                   	push   %ebx
  800a16:	52                   	push   %edx
  800a17:	ff d6                	call   *%esi
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a1f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a21:	83 c7 01             	add    $0x1,%edi
  800a24:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a28:	0f be d0             	movsbl %al,%edx
  800a2b:	85 d2                	test   %edx,%edx
  800a2d:	74 4b                	je     800a7a <vprintfmt+0x23f>
  800a2f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a33:	78 06                	js     800a3b <vprintfmt+0x200>
  800a35:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a39:	78 1e                	js     800a59 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a3b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a3f:	74 d1                	je     800a12 <vprintfmt+0x1d7>
  800a41:	0f be c0             	movsbl %al,%eax
  800a44:	83 e8 20             	sub    $0x20,%eax
  800a47:	83 f8 5e             	cmp    $0x5e,%eax
  800a4a:	76 c6                	jbe    800a12 <vprintfmt+0x1d7>
					putch('?', putdat);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	53                   	push   %ebx
  800a50:	6a 3f                	push   $0x3f
  800a52:	ff d6                	call   *%esi
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	eb c3                	jmp    800a1c <vprintfmt+0x1e1>
  800a59:	89 cf                	mov    %ecx,%edi
  800a5b:	eb 0e                	jmp    800a6b <vprintfmt+0x230>
				putch(' ', putdat);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	53                   	push   %ebx
  800a61:	6a 20                	push   $0x20
  800a63:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a65:	83 ef 01             	sub    $0x1,%edi
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	85 ff                	test   %edi,%edi
  800a6d:	7f ee                	jg     800a5d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800a6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
  800a75:	e9 67 01 00 00       	jmp    800be1 <vprintfmt+0x3a6>
  800a7a:	89 cf                	mov    %ecx,%edi
  800a7c:	eb ed                	jmp    800a6b <vprintfmt+0x230>
	if (lflag >= 2)
  800a7e:	83 f9 01             	cmp    $0x1,%ecx
  800a81:	7f 1b                	jg     800a9e <vprintfmt+0x263>
	else if (lflag)
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	74 63                	je     800aea <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a8f:	99                   	cltd   
  800a90:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	8d 40 04             	lea    0x4(%eax),%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	eb 17                	jmp    800ab5 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	8b 50 04             	mov    0x4(%eax),%edx
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	8d 40 08             	lea    0x8(%eax),%eax
  800ab2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ab5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ab8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800abb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800ac0:	85 c9                	test   %ecx,%ecx
  800ac2:	0f 89 ff 00 00 00    	jns    800bc7 <vprintfmt+0x38c>
				putch('-', putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	53                   	push   %ebx
  800acc:	6a 2d                	push   $0x2d
  800ace:	ff d6                	call   *%esi
				num = -(long long) num;
  800ad0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ad3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ad6:	f7 da                	neg    %edx
  800ad8:	83 d1 00             	adc    $0x0,%ecx
  800adb:	f7 d9                	neg    %ecx
  800add:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ae0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ae5:	e9 dd 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800aea:	8b 45 14             	mov    0x14(%ebp),%eax
  800aed:	8b 00                	mov    (%eax),%eax
  800aef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800af2:	99                   	cltd   
  800af3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8d 40 04             	lea    0x4(%eax),%eax
  800afc:	89 45 14             	mov    %eax,0x14(%ebp)
  800aff:	eb b4                	jmp    800ab5 <vprintfmt+0x27a>
	if (lflag >= 2)
  800b01:	83 f9 01             	cmp    $0x1,%ecx
  800b04:	7f 1e                	jg     800b24 <vprintfmt+0x2e9>
	else if (lflag)
  800b06:	85 c9                	test   %ecx,%ecx
  800b08:	74 32                	je     800b3c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	8b 10                	mov    (%eax),%edx
  800b0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b14:	8d 40 04             	lea    0x4(%eax),%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800b1f:	e9 a3 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8b 10                	mov    (%eax),%edx
  800b29:	8b 48 04             	mov    0x4(%eax),%ecx
  800b2c:	8d 40 08             	lea    0x8(%eax),%eax
  800b2f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b32:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800b37:	e9 8b 00 00 00       	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3f:	8b 10                	mov    (%eax),%edx
  800b41:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b46:	8d 40 04             	lea    0x4(%eax),%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b4c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800b51:	eb 74                	jmp    800bc7 <vprintfmt+0x38c>
	if (lflag >= 2)
  800b53:	83 f9 01             	cmp    $0x1,%ecx
  800b56:	7f 1b                	jg     800b73 <vprintfmt+0x338>
	else if (lflag)
  800b58:	85 c9                	test   %ecx,%ecx
  800b5a:	74 2c                	je     800b88 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	8b 10                	mov    (%eax),%edx
  800b61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b66:	8d 40 04             	lea    0x4(%eax),%eax
  800b69:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b6c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800b71:	eb 54                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800b73:	8b 45 14             	mov    0x14(%ebp),%eax
  800b76:	8b 10                	mov    (%eax),%edx
  800b78:	8b 48 04             	mov    0x4(%eax),%ecx
  800b7b:	8d 40 08             	lea    0x8(%eax),%eax
  800b7e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b81:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800b86:	eb 3f                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b88:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8b:	8b 10                	mov    (%eax),%edx
  800b8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b92:	8d 40 04             	lea    0x4(%eax),%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b98:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800b9d:	eb 28                	jmp    800bc7 <vprintfmt+0x38c>
			putch('0', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	53                   	push   %ebx
  800ba3:	6a 30                	push   $0x30
  800ba5:	ff d6                	call   *%esi
			putch('x', putdat);
  800ba7:	83 c4 08             	add    $0x8,%esp
  800baa:	53                   	push   %ebx
  800bab:	6a 78                	push   $0x78
  800bad:	ff d6                	call   *%esi
			num = (unsigned long long)
  800baf:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb2:	8b 10                	mov    (%eax),%edx
  800bb4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bb9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bbc:	8d 40 04             	lea    0x4(%eax),%eax
  800bbf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bc2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bc7:	83 ec 0c             	sub    $0xc,%esp
  800bca:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800bce:	57                   	push   %edi
  800bcf:	ff 75 e0             	pushl  -0x20(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	51                   	push   %ecx
  800bd4:	52                   	push   %edx
  800bd5:	89 da                	mov    %ebx,%edx
  800bd7:	89 f0                	mov    %esi,%eax
  800bd9:	e8 72 fb ff ff       	call   800750 <printnum>
			break;
  800bde:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800be1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be4:	83 c7 01             	add    $0x1,%edi
  800be7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800beb:	83 f8 25             	cmp    $0x25,%eax
  800bee:	0f 84 62 fc ff ff    	je     800856 <vprintfmt+0x1b>
			if (ch == '\0')
  800bf4:	85 c0                	test   %eax,%eax
  800bf6:	0f 84 8b 00 00 00    	je     800c87 <vprintfmt+0x44c>
			putch(ch, putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	53                   	push   %ebx
  800c00:	50                   	push   %eax
  800c01:	ff d6                	call   *%esi
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	eb dc                	jmp    800be4 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800c08:	83 f9 01             	cmp    $0x1,%ecx
  800c0b:	7f 1b                	jg     800c28 <vprintfmt+0x3ed>
	else if (lflag)
  800c0d:	85 c9                	test   %ecx,%ecx
  800c0f:	74 2c                	je     800c3d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	8b 10                	mov    (%eax),%edx
  800c16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1b:	8d 40 04             	lea    0x4(%eax),%eax
  800c1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c21:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800c26:	eb 9f                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800c28:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2b:	8b 10                	mov    (%eax),%edx
  800c2d:	8b 48 04             	mov    0x4(%eax),%ecx
  800c30:	8d 40 08             	lea    0x8(%eax),%eax
  800c33:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c36:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800c3b:	eb 8a                	jmp    800bc7 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800c3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c40:	8b 10                	mov    (%eax),%edx
  800c42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c47:	8d 40 04             	lea    0x4(%eax),%eax
  800c4a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c4d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800c52:	e9 70 ff ff ff       	jmp    800bc7 <vprintfmt+0x38c>
			putch(ch, putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	53                   	push   %ebx
  800c5b:	6a 25                	push   $0x25
  800c5d:	ff d6                	call   *%esi
			break;
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	e9 7a ff ff ff       	jmp    800be1 <vprintfmt+0x3a6>
			putch('%', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	53                   	push   %ebx
  800c6b:	6a 25                	push   $0x25
  800c6d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 f8                	mov    %edi,%eax
  800c74:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c78:	74 05                	je     800c7f <vprintfmt+0x444>
  800c7a:	83 e8 01             	sub    $0x1,%eax
  800c7d:	eb f5                	jmp    800c74 <vprintfmt+0x439>
  800c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c82:	e9 5a ff ff ff       	jmp    800be1 <vprintfmt+0x3a6>
}
  800c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c8f:	f3 0f 1e fb          	endbr32 
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 18             	sub    $0x18,%esp
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ca6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	74 26                	je     800cda <vsnprintf+0x4b>
  800cb4:	85 d2                	test   %edx,%edx
  800cb6:	7e 22                	jle    800cda <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb8:	ff 75 14             	pushl  0x14(%ebp)
  800cbb:	ff 75 10             	pushl  0x10(%ebp)
  800cbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc1:	50                   	push   %eax
  800cc2:	68 f9 07 80 00       	push   $0x8007f9
  800cc7:	e8 6f fb ff ff       	call   80083b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cd5:	83 c4 10             	add    $0x10,%esp
}
  800cd8:	c9                   	leave  
  800cd9:	c3                   	ret    
		return -E_INVAL;
  800cda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cdf:	eb f7                	jmp    800cd8 <vsnprintf+0x49>

00800ce1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ce1:	f3 0f 1e fb          	endbr32 
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ceb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cee:	50                   	push   %eax
  800cef:	ff 75 10             	pushl  0x10(%ebp)
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	ff 75 08             	pushl  0x8(%ebp)
  800cf8:	e8 92 ff ff ff       	call   800c8f <vsnprintf>
	va_end(ap);

	return rc;
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cff:	f3 0f 1e fb          	endbr32 
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d09:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d12:	74 05                	je     800d19 <strlen+0x1a>
		n++;
  800d14:	83 c0 01             	add    $0x1,%eax
  800d17:	eb f5                	jmp    800d0e <strlen+0xf>
	return n;
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d1b:	f3 0f 1e fb          	endbr32 
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2d:	39 d0                	cmp    %edx,%eax
  800d2f:	74 0d                	je     800d3e <strnlen+0x23>
  800d31:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d35:	74 05                	je     800d3c <strnlen+0x21>
		n++;
  800d37:	83 c0 01             	add    $0x1,%eax
  800d3a:	eb f1                	jmp    800d2d <strnlen+0x12>
  800d3c:	89 c2                	mov    %eax,%edx
	return n;
}
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d42:	f3 0f 1e fb          	endbr32 
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	53                   	push   %ebx
  800d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800d59:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800d5c:	83 c0 01             	add    $0x1,%eax
  800d5f:	84 d2                	test   %dl,%dl
  800d61:	75 f2                	jne    800d55 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800d63:	89 c8                	mov    %ecx,%eax
  800d65:	5b                   	pop    %ebx
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d68:	f3 0f 1e fb          	endbr32 
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 10             	sub    $0x10,%esp
  800d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d76:	53                   	push   %ebx
  800d77:	e8 83 ff ff ff       	call   800cff <strlen>
  800d7c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	01 d8                	add    %ebx,%eax
  800d84:	50                   	push   %eax
  800d85:	e8 b8 ff ff ff       	call   800d42 <strcpy>
	return dst;
}
  800d8a:	89 d8                	mov    %ebx,%eax
  800d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d91:	f3 0f 1e fb          	endbr32 
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	8b 75 08             	mov    0x8(%ebp),%esi
  800d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da0:	89 f3                	mov    %esi,%ebx
  800da2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800da5:	89 f0                	mov    %esi,%eax
  800da7:	39 d8                	cmp    %ebx,%eax
  800da9:	74 11                	je     800dbc <strncpy+0x2b>
		*dst++ = *src;
  800dab:	83 c0 01             	add    $0x1,%eax
  800dae:	0f b6 0a             	movzbl (%edx),%ecx
  800db1:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800db4:	80 f9 01             	cmp    $0x1,%cl
  800db7:	83 da ff             	sbb    $0xffffffff,%edx
  800dba:	eb eb                	jmp    800da7 <strncpy+0x16>
	}
	return ret;
}
  800dbc:	89 f0                	mov    %esi,%eax
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	8b 75 08             	mov    0x8(%ebp),%esi
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	8b 55 10             	mov    0x10(%ebp),%edx
  800dd4:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dd6:	85 d2                	test   %edx,%edx
  800dd8:	74 21                	je     800dfb <strlcpy+0x39>
  800dda:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800dde:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800de0:	39 c2                	cmp    %eax,%edx
  800de2:	74 14                	je     800df8 <strlcpy+0x36>
  800de4:	0f b6 19             	movzbl (%ecx),%ebx
  800de7:	84 db                	test   %bl,%bl
  800de9:	74 0b                	je     800df6 <strlcpy+0x34>
			*dst++ = *src++;
  800deb:	83 c1 01             	add    $0x1,%ecx
  800dee:	83 c2 01             	add    $0x1,%edx
  800df1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800df4:	eb ea                	jmp    800de0 <strlcpy+0x1e>
  800df6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800df8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dfb:	29 f0                	sub    %esi,%eax
}
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e01:	f3 0f 1e fb          	endbr32 
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e0e:	0f b6 01             	movzbl (%ecx),%eax
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0c                	je     800e21 <strcmp+0x20>
  800e15:	3a 02                	cmp    (%edx),%al
  800e17:	75 08                	jne    800e21 <strcmp+0x20>
		p++, q++;
  800e19:	83 c1 01             	add    $0x1,%ecx
  800e1c:	83 c2 01             	add    $0x1,%edx
  800e1f:	eb ed                	jmp    800e0e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e21:	0f b6 c0             	movzbl %al,%eax
  800e24:	0f b6 12             	movzbl (%edx),%edx
  800e27:	29 d0                	sub    %edx,%eax
}
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    

00800e2b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	53                   	push   %ebx
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e39:	89 c3                	mov    %eax,%ebx
  800e3b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e3e:	eb 06                	jmp    800e46 <strncmp+0x1b>
		n--, p++, q++;
  800e40:	83 c0 01             	add    $0x1,%eax
  800e43:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e46:	39 d8                	cmp    %ebx,%eax
  800e48:	74 16                	je     800e60 <strncmp+0x35>
  800e4a:	0f b6 08             	movzbl (%eax),%ecx
  800e4d:	84 c9                	test   %cl,%cl
  800e4f:	74 04                	je     800e55 <strncmp+0x2a>
  800e51:	3a 0a                	cmp    (%edx),%cl
  800e53:	74 eb                	je     800e40 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e55:	0f b6 00             	movzbl (%eax),%eax
  800e58:	0f b6 12             	movzbl (%edx),%edx
  800e5b:	29 d0                	sub    %edx,%eax
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    
		return 0;
  800e60:	b8 00 00 00 00       	mov    $0x0,%eax
  800e65:	eb f6                	jmp    800e5d <strncmp+0x32>

00800e67 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e67:	f3 0f 1e fb          	endbr32 
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e75:	0f b6 10             	movzbl (%eax),%edx
  800e78:	84 d2                	test   %dl,%dl
  800e7a:	74 09                	je     800e85 <strchr+0x1e>
		if (*s == c)
  800e7c:	38 ca                	cmp    %cl,%dl
  800e7e:	74 0a                	je     800e8a <strchr+0x23>
	for (; *s; s++)
  800e80:	83 c0 01             	add    $0x1,%eax
  800e83:	eb f0                	jmp    800e75 <strchr+0xe>
			return (char *) s;
	return 0;
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e9a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e9d:	38 ca                	cmp    %cl,%dl
  800e9f:	74 09                	je     800eaa <strfind+0x1e>
  800ea1:	84 d2                	test   %dl,%dl
  800ea3:	74 05                	je     800eaa <strfind+0x1e>
	for (; *s; s++)
  800ea5:	83 c0 01             	add    $0x1,%eax
  800ea8:	eb f0                	jmp    800e9a <strfind+0xe>
			break;
	return (char *) s;
}
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800eac:	f3 0f 1e fb          	endbr32 
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ebc:	85 c9                	test   %ecx,%ecx
  800ebe:	74 31                	je     800ef1 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ec0:	89 f8                	mov    %edi,%eax
  800ec2:	09 c8                	or     %ecx,%eax
  800ec4:	a8 03                	test   $0x3,%al
  800ec6:	75 23                	jne    800eeb <memset+0x3f>
		c &= 0xFF;
  800ec8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ecc:	89 d3                	mov    %edx,%ebx
  800ece:	c1 e3 08             	shl    $0x8,%ebx
  800ed1:	89 d0                	mov    %edx,%eax
  800ed3:	c1 e0 18             	shl    $0x18,%eax
  800ed6:	89 d6                	mov    %edx,%esi
  800ed8:	c1 e6 10             	shl    $0x10,%esi
  800edb:	09 f0                	or     %esi,%eax
  800edd:	09 c2                	or     %eax,%edx
  800edf:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ee1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ee4:	89 d0                	mov    %edx,%eax
  800ee6:	fc                   	cld    
  800ee7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ee9:	eb 06                	jmp    800ef1 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	fc                   	cld    
  800eef:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ef1:	89 f8                	mov    %edi,%eax
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ef8:	f3 0f 1e fb          	endbr32 
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0a:	39 c6                	cmp    %eax,%esi
  800f0c:	73 32                	jae    800f40 <memmove+0x48>
  800f0e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f11:	39 c2                	cmp    %eax,%edx
  800f13:	76 2b                	jbe    800f40 <memmove+0x48>
		s += n;
		d += n;
  800f15:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f18:	89 fe                	mov    %edi,%esi
  800f1a:	09 ce                	or     %ecx,%esi
  800f1c:	09 d6                	or     %edx,%esi
  800f1e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f24:	75 0e                	jne    800f34 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f26:	83 ef 04             	sub    $0x4,%edi
  800f29:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f2c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f2f:	fd                   	std    
  800f30:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f32:	eb 09                	jmp    800f3d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f34:	83 ef 01             	sub    $0x1,%edi
  800f37:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f3a:	fd                   	std    
  800f3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f3d:	fc                   	cld    
  800f3e:	eb 1a                	jmp    800f5a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f40:	89 c2                	mov    %eax,%edx
  800f42:	09 ca                	or     %ecx,%edx
  800f44:	09 f2                	or     %esi,%edx
  800f46:	f6 c2 03             	test   $0x3,%dl
  800f49:	75 0a                	jne    800f55 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f4b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f4e:	89 c7                	mov    %eax,%edi
  800f50:	fc                   	cld    
  800f51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f53:	eb 05                	jmp    800f5a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800f55:	89 c7                	mov    %eax,%edi
  800f57:	fc                   	cld    
  800f58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f5a:	5e                   	pop    %esi
  800f5b:	5f                   	pop    %edi
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f5e:	f3 0f 1e fb          	endbr32 
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f68:	ff 75 10             	pushl  0x10(%ebp)
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 82 ff ff ff       	call   800ef8 <memmove>
}
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f78:	f3 0f 1e fb          	endbr32 
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f87:	89 c6                	mov    %eax,%esi
  800f89:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f8c:	39 f0                	cmp    %esi,%eax
  800f8e:	74 1c                	je     800fac <memcmp+0x34>
		if (*s1 != *s2)
  800f90:	0f b6 08             	movzbl (%eax),%ecx
  800f93:	0f b6 1a             	movzbl (%edx),%ebx
  800f96:	38 d9                	cmp    %bl,%cl
  800f98:	75 08                	jne    800fa2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f9a:	83 c0 01             	add    $0x1,%eax
  800f9d:	83 c2 01             	add    $0x1,%edx
  800fa0:	eb ea                	jmp    800f8c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800fa2:	0f b6 c1             	movzbl %cl,%eax
  800fa5:	0f b6 db             	movzbl %bl,%ebx
  800fa8:	29 d8                	sub    %ebx,%eax
  800faa:	eb 05                	jmp    800fb1 <memcmp+0x39>
	}

	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800fb5:	f3 0f 1e fb          	endbr32 
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800fc2:	89 c2                	mov    %eax,%edx
  800fc4:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800fc7:	39 d0                	cmp    %edx,%eax
  800fc9:	73 09                	jae    800fd4 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fcb:	38 08                	cmp    %cl,(%eax)
  800fcd:	74 05                	je     800fd4 <memfind+0x1f>
	for (; s < ends; s++)
  800fcf:	83 c0 01             	add    $0x1,%eax
  800fd2:	eb f3                	jmp    800fc7 <memfind+0x12>
			break;
	return (void *) s;
}
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd6:	f3 0f 1e fb          	endbr32 
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe6:	eb 03                	jmp    800feb <strtol+0x15>
		s++;
  800fe8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800feb:	0f b6 01             	movzbl (%ecx),%eax
  800fee:	3c 20                	cmp    $0x20,%al
  800ff0:	74 f6                	je     800fe8 <strtol+0x12>
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 f2                	je     800fe8 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ff6:	3c 2b                	cmp    $0x2b,%al
  800ff8:	74 2a                	je     801024 <strtol+0x4e>
	int neg = 0;
  800ffa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fff:	3c 2d                	cmp    $0x2d,%al
  801001:	74 2b                	je     80102e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801003:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801009:	75 0f                	jne    80101a <strtol+0x44>
  80100b:	80 39 30             	cmpb   $0x30,(%ecx)
  80100e:	74 28                	je     801038 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801010:	85 db                	test   %ebx,%ebx
  801012:	b8 0a 00 00 00       	mov    $0xa,%eax
  801017:	0f 44 d8             	cmove  %eax,%ebx
  80101a:	b8 00 00 00 00       	mov    $0x0,%eax
  80101f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801022:	eb 46                	jmp    80106a <strtol+0x94>
		s++;
  801024:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801027:	bf 00 00 00 00       	mov    $0x0,%edi
  80102c:	eb d5                	jmp    801003 <strtol+0x2d>
		s++, neg = 1;
  80102e:	83 c1 01             	add    $0x1,%ecx
  801031:	bf 01 00 00 00       	mov    $0x1,%edi
  801036:	eb cb                	jmp    801003 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801038:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80103c:	74 0e                	je     80104c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80103e:	85 db                	test   %ebx,%ebx
  801040:	75 d8                	jne    80101a <strtol+0x44>
		s++, base = 8;
  801042:	83 c1 01             	add    $0x1,%ecx
  801045:	bb 08 00 00 00       	mov    $0x8,%ebx
  80104a:	eb ce                	jmp    80101a <strtol+0x44>
		s += 2, base = 16;
  80104c:	83 c1 02             	add    $0x2,%ecx
  80104f:	bb 10 00 00 00       	mov    $0x10,%ebx
  801054:	eb c4                	jmp    80101a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801056:	0f be d2             	movsbl %dl,%edx
  801059:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80105c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80105f:	7d 3a                	jge    80109b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801061:	83 c1 01             	add    $0x1,%ecx
  801064:	0f af 45 10          	imul   0x10(%ebp),%eax
  801068:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80106a:	0f b6 11             	movzbl (%ecx),%edx
  80106d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801070:	89 f3                	mov    %esi,%ebx
  801072:	80 fb 09             	cmp    $0x9,%bl
  801075:	76 df                	jbe    801056 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801077:	8d 72 9f             	lea    -0x61(%edx),%esi
  80107a:	89 f3                	mov    %esi,%ebx
  80107c:	80 fb 19             	cmp    $0x19,%bl
  80107f:	77 08                	ja     801089 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801081:	0f be d2             	movsbl %dl,%edx
  801084:	83 ea 57             	sub    $0x57,%edx
  801087:	eb d3                	jmp    80105c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801089:	8d 72 bf             	lea    -0x41(%edx),%esi
  80108c:	89 f3                	mov    %esi,%ebx
  80108e:	80 fb 19             	cmp    $0x19,%bl
  801091:	77 08                	ja     80109b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801093:	0f be d2             	movsbl %dl,%edx
  801096:	83 ea 37             	sub    $0x37,%edx
  801099:	eb c1                	jmp    80105c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80109b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109f:	74 05                	je     8010a6 <strtol+0xd0>
		*endptr = (char *) s;
  8010a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010a4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010a6:	89 c2                	mov    %eax,%edx
  8010a8:	f7 da                	neg    %edx
  8010aa:	85 ff                	test   %edi,%edi
  8010ac:	0f 45 c2             	cmovne %edx,%eax
}
  8010af:	5b                   	pop    %ebx
  8010b0:	5e                   	pop    %esi
  8010b1:	5f                   	pop    %edi
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8010b4:	f3 0f 1e fb          	endbr32 
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	89 c3                	mov    %eax,%ebx
  8010cb:	89 c7                	mov    %eax,%edi
  8010cd:	89 c6                	mov    %eax,%esi
  8010cf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8010d6:	f3 0f 1e fb          	endbr32 
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	57                   	push   %edi
  8010de:	56                   	push   %esi
  8010df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8010ea:	89 d1                	mov    %edx,%ecx
  8010ec:	89 d3                	mov    %edx,%ebx
  8010ee:	89 d7                	mov    %edx,%edi
  8010f0:	89 d6                	mov    %edx,%esi
  8010f2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010f9:	f3 0f 1e fb          	endbr32 
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	57                   	push   %edi
  801101:	56                   	push   %esi
  801102:	53                   	push   %ebx
  801103:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801106:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	b8 03 00 00 00       	mov    $0x3,%eax
  801113:	89 cb                	mov    %ecx,%ebx
  801115:	89 cf                	mov    %ecx,%edi
  801117:	89 ce                	mov    %ecx,%esi
  801119:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	7f 08                	jg     801127 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80111f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801127:	83 ec 0c             	sub    $0xc,%esp
  80112a:	50                   	push   %eax
  80112b:	6a 03                	push   $0x3
  80112d:	68 5f 2e 80 00       	push   $0x802e5f
  801132:	6a 23                	push   $0x23
  801134:	68 7c 2e 80 00       	push   $0x802e7c
  801139:	e8 13 f5 ff ff       	call   800651 <_panic>

0080113e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80113e:	f3 0f 1e fb          	endbr32 
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	57                   	push   %edi
  801146:	56                   	push   %esi
  801147:	53                   	push   %ebx
	asm volatile("int %1\n"
  801148:	ba 00 00 00 00       	mov    $0x0,%edx
  80114d:	b8 02 00 00 00       	mov    $0x2,%eax
  801152:	89 d1                	mov    %edx,%ecx
  801154:	89 d3                	mov    %edx,%ebx
  801156:	89 d7                	mov    %edx,%edi
  801158:	89 d6                	mov    %edx,%esi
  80115a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5f                   	pop    %edi
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <sys_yield>:

void
sys_yield(void)
{
  801161:	f3 0f 1e fb          	endbr32 
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	57                   	push   %edi
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80116b:	ba 00 00 00 00       	mov    $0x0,%edx
  801170:	b8 0b 00 00 00       	mov    $0xb,%eax
  801175:	89 d1                	mov    %edx,%ecx
  801177:	89 d3                	mov    %edx,%ebx
  801179:	89 d7                	mov    %edx,%edi
  80117b:	89 d6                	mov    %edx,%esi
  80117d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801184:	f3 0f 1e fb          	endbr32 
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	57                   	push   %edi
  80118c:	56                   	push   %esi
  80118d:	53                   	push   %ebx
  80118e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801191:	be 00 00 00 00       	mov    $0x0,%esi
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119c:	b8 04 00 00 00       	mov    $0x4,%eax
  8011a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a4:	89 f7                	mov    %esi,%edi
  8011a6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	7f 08                	jg     8011b4 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b4:	83 ec 0c             	sub    $0xc,%esp
  8011b7:	50                   	push   %eax
  8011b8:	6a 04                	push   $0x4
  8011ba:	68 5f 2e 80 00       	push   $0x802e5f
  8011bf:	6a 23                	push   $0x23
  8011c1:	68 7c 2e 80 00       	push   $0x802e7c
  8011c6:	e8 86 f4 ff ff       	call   800651 <_panic>

008011cb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011cb:	f3 0f 1e fb          	endbr32 
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	57                   	push   %edi
  8011d3:	56                   	push   %esi
  8011d4:	53                   	push   %ebx
  8011d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011de:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ec:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	7f 08                	jg     8011fa <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	6a 05                	push   $0x5
  801200:	68 5f 2e 80 00       	push   $0x802e5f
  801205:	6a 23                	push   $0x23
  801207:	68 7c 2e 80 00       	push   $0x802e7c
  80120c:	e8 40 f4 ff ff       	call   800651 <_panic>

00801211 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80121e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801223:	8b 55 08             	mov    0x8(%ebp),%edx
  801226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801229:	b8 06 00 00 00       	mov    $0x6,%eax
  80122e:	89 df                	mov    %ebx,%edi
  801230:	89 de                	mov    %ebx,%esi
  801232:	cd 30                	int    $0x30
	if(check && ret > 0)
  801234:	85 c0                	test   %eax,%eax
  801236:	7f 08                	jg     801240 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	50                   	push   %eax
  801244:	6a 06                	push   $0x6
  801246:	68 5f 2e 80 00       	push   $0x802e5f
  80124b:	6a 23                	push   $0x23
  80124d:	68 7c 2e 80 00       	push   $0x802e7c
  801252:	e8 fa f3 ff ff       	call   800651 <_panic>

00801257 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801257:	f3 0f 1e fb          	endbr32 
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801264:	bb 00 00 00 00       	mov    $0x0,%ebx
  801269:	8b 55 08             	mov    0x8(%ebp),%edx
  80126c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126f:	b8 08 00 00 00       	mov    $0x8,%eax
  801274:	89 df                	mov    %ebx,%edi
  801276:	89 de                	mov    %ebx,%esi
  801278:	cd 30                	int    $0x30
	if(check && ret > 0)
  80127a:	85 c0                	test   %eax,%eax
  80127c:	7f 08                	jg     801286 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	50                   	push   %eax
  80128a:	6a 08                	push   $0x8
  80128c:	68 5f 2e 80 00       	push   $0x802e5f
  801291:	6a 23                	push   $0x23
  801293:	68 7c 2e 80 00       	push   $0x802e7c
  801298:	e8 b4 f3 ff ff       	call   800651 <_panic>

0080129d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80129d:	f3 0f 1e fb          	endbr32 
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012af:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8012ba:	89 df                	mov    %ebx,%edi
  8012bc:	89 de                	mov    %ebx,%esi
  8012be:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	7f 08                	jg     8012cc <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5f                   	pop    %edi
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	50                   	push   %eax
  8012d0:	6a 09                	push   $0x9
  8012d2:	68 5f 2e 80 00       	push   $0x802e5f
  8012d7:	6a 23                	push   $0x23
  8012d9:	68 7c 2e 80 00       	push   $0x802e7c
  8012de:	e8 6e f3 ff ff       	call   800651 <_panic>

008012e3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012e3:	f3 0f 1e fb          	endbr32 
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	57                   	push   %edi
  8012eb:	56                   	push   %esi
  8012ec:	53                   	push   %ebx
  8012ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  801300:	89 df                	mov    %ebx,%edi
  801302:	89 de                	mov    %ebx,%esi
  801304:	cd 30                	int    $0x30
	if(check && ret > 0)
  801306:	85 c0                	test   %eax,%eax
  801308:	7f 08                	jg     801312 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	50                   	push   %eax
  801316:	6a 0a                	push   $0xa
  801318:	68 5f 2e 80 00       	push   $0x802e5f
  80131d:	6a 23                	push   $0x23
  80131f:	68 7c 2e 80 00       	push   $0x802e7c
  801324:	e8 28 f3 ff ff       	call   800651 <_panic>

00801329 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801329:	f3 0f 1e fb          	endbr32 
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
	asm volatile("int %1\n"
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	b8 0c 00 00 00       	mov    $0xc,%eax
  80133e:	be 00 00 00 00       	mov    $0x0,%esi
  801343:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801346:	8b 7d 14             	mov    0x14(%ebp),%edi
  801349:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80134b:	5b                   	pop    %ebx
  80134c:	5e                   	pop    %esi
  80134d:	5f                   	pop    %edi
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801350:	f3 0f 1e fb          	endbr32 
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	57                   	push   %edi
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80135d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	b8 0d 00 00 00       	mov    $0xd,%eax
  80136a:	89 cb                	mov    %ecx,%ebx
  80136c:	89 cf                	mov    %ecx,%edi
  80136e:	89 ce                	mov    %ecx,%esi
  801370:	cd 30                	int    $0x30
	if(check && ret > 0)
  801372:	85 c0                	test   %eax,%eax
  801374:	7f 08                	jg     80137e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801376:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801379:	5b                   	pop    %ebx
  80137a:	5e                   	pop    %esi
  80137b:	5f                   	pop    %edi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	50                   	push   %eax
  801382:	6a 0d                	push   $0xd
  801384:	68 5f 2e 80 00       	push   $0x802e5f
  801389:	6a 23                	push   $0x23
  80138b:	68 7c 2e 80 00       	push   $0x802e7c
  801390:	e8 bc f2 ff ff       	call   800651 <_panic>

00801395 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801395:	f3 0f 1e fb          	endbr32 
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	57                   	push   %edi
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013a9:	89 d1                	mov    %edx,%ecx
  8013ab:	89 d3                	mov    %edx,%ebx
  8013ad:	89 d7                	mov    %edx,%edi
  8013af:	89 d6                	mov    %edx,%esi
  8013b1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5f                   	pop    %edi
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8013b8:	f3 0f 1e fb          	endbr32 
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8013c2:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  8013c9:	74 0a                	je     8013d5 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  8013d5:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8013da:	8b 40 48             	mov    0x48(%eax),%eax
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	6a 07                	push   $0x7
  8013e2:	68 00 f0 bf ee       	push   $0xeebff000
  8013e7:	50                   	push   %eax
  8013e8:	e8 97 fd ff ff       	call   801184 <sys_page_alloc>
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	85 c0                	test   %eax,%eax
  8013f2:	75 31                	jne    801425 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  8013f4:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8013f9:	8b 40 48             	mov    0x48(%eax),%eax
  8013fc:	83 ec 08             	sub    $0x8,%esp
  8013ff:	68 39 14 80 00       	push   $0x801439
  801404:	50                   	push   %eax
  801405:	e8 d9 fe ff ff       	call   8012e3 <sys_env_set_pgfault_upcall>
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	74 ba                	je     8013cb <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	68 b4 2e 80 00       	push   $0x802eb4
  801419:	6a 24                	push   $0x24
  80141b:	68 e2 2e 80 00       	push   $0x802ee2
  801420:	e8 2c f2 ff ff       	call   800651 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  801425:	83 ec 04             	sub    $0x4,%esp
  801428:	68 8c 2e 80 00       	push   $0x802e8c
  80142d:	6a 21                	push   $0x21
  80142f:	68 e2 2e 80 00       	push   $0x802ee2
  801434:	e8 18 f2 ff ff       	call   800651 <_panic>

00801439 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801439:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80143a:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  80143f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801441:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  801444:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  801448:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  80144d:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  801451:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  801453:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  801456:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  801457:	83 c4 04             	add    $0x4,%esp
    popfl
  80145a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  80145b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  80145c:	c3                   	ret    

0080145d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80145d:	f3 0f 1e fb          	endbr32 
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	05 00 00 00 30       	add    $0x30000000,%eax
  80146c:	c1 e8 0c             	shr    $0xc,%eax
}
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801471:	f3 0f 1e fb          	endbr32 
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801480:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801485:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80148c:	f3 0f 1e fb          	endbr32 
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801498:	89 c2                	mov    %eax,%edx
  80149a:	c1 ea 16             	shr    $0x16,%edx
  80149d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014a4:	f6 c2 01             	test   $0x1,%dl
  8014a7:	74 2d                	je     8014d6 <fd_alloc+0x4a>
  8014a9:	89 c2                	mov    %eax,%edx
  8014ab:	c1 ea 0c             	shr    $0xc,%edx
  8014ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014b5:	f6 c2 01             	test   $0x1,%dl
  8014b8:	74 1c                	je     8014d6 <fd_alloc+0x4a>
  8014ba:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8014bf:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014c4:	75 d2                	jne    801498 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8014cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8014d4:	eb 0a                	jmp    8014e0 <fd_alloc+0x54>
			*fd_store = fd;
  8014d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014e0:	5d                   	pop    %ebp
  8014e1:	c3                   	ret    

008014e2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014e2:	f3 0f 1e fb          	endbr32 
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014ec:	83 f8 1f             	cmp    $0x1f,%eax
  8014ef:	77 30                	ja     801521 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014f1:	c1 e0 0c             	shl    $0xc,%eax
  8014f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014f9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014ff:	f6 c2 01             	test   $0x1,%dl
  801502:	74 24                	je     801528 <fd_lookup+0x46>
  801504:	89 c2                	mov    %eax,%edx
  801506:	c1 ea 0c             	shr    $0xc,%edx
  801509:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801510:	f6 c2 01             	test   $0x1,%dl
  801513:	74 1a                	je     80152f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801515:	8b 55 0c             	mov    0xc(%ebp),%edx
  801518:	89 02                	mov    %eax,(%edx)
	return 0;
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    
		return -E_INVAL;
  801521:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801526:	eb f7                	jmp    80151f <fd_lookup+0x3d>
		return -E_INVAL;
  801528:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80152d:	eb f0                	jmp    80151f <fd_lookup+0x3d>
  80152f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801534:	eb e9                	jmp    80151f <fd_lookup+0x3d>

00801536 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801536:	f3 0f 1e fb          	endbr32 
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801543:	ba 00 00 00 00       	mov    $0x0,%edx
  801548:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80154d:	39 08                	cmp    %ecx,(%eax)
  80154f:	74 38                	je     801589 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801551:	83 c2 01             	add    $0x1,%edx
  801554:	8b 04 95 6c 2f 80 00 	mov    0x802f6c(,%edx,4),%eax
  80155b:	85 c0                	test   %eax,%eax
  80155d:	75 ee                	jne    80154d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80155f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801564:	8b 40 48             	mov    0x48(%eax),%eax
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	51                   	push   %ecx
  80156b:	50                   	push   %eax
  80156c:	68 f0 2e 80 00       	push   $0x802ef0
  801571:	e8 c2 f1 ff ff       	call   800738 <cprintf>
	*dev = 0;
  801576:	8b 45 0c             	mov    0xc(%ebp),%eax
  801579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    
			*dev = devtab[i];
  801589:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80158e:	b8 00 00 00 00       	mov    $0x0,%eax
  801593:	eb f2                	jmp    801587 <dev_lookup+0x51>

00801595 <fd_close>:
{
  801595:	f3 0f 1e fb          	endbr32 
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	57                   	push   %edi
  80159d:	56                   	push   %esi
  80159e:	53                   	push   %ebx
  80159f:	83 ec 24             	sub    $0x24,%esp
  8015a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8015a5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ab:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015ac:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015b2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b5:	50                   	push   %eax
  8015b6:	e8 27 ff ff ff       	call   8014e2 <fd_lookup>
  8015bb:	89 c3                	mov    %eax,%ebx
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	78 05                	js     8015c9 <fd_close+0x34>
	    || fd != fd2)
  8015c4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8015c7:	74 16                	je     8015df <fd_close+0x4a>
		return (must_exist ? r : 0);
  8015c9:	89 f8                	mov    %edi,%eax
  8015cb:	84 c0                	test   %al,%al
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	0f 44 d8             	cmove  %eax,%ebx
}
  8015d5:	89 d8                	mov    %ebx,%eax
  8015d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015da:	5b                   	pop    %ebx
  8015db:	5e                   	pop    %esi
  8015dc:	5f                   	pop    %edi
  8015dd:	5d                   	pop    %ebp
  8015de:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8015e5:	50                   	push   %eax
  8015e6:	ff 36                	pushl  (%esi)
  8015e8:	e8 49 ff ff ff       	call   801536 <dev_lookup>
  8015ed:	89 c3                	mov    %eax,%ebx
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 1a                	js     801610 <fd_close+0x7b>
		if (dev->dev_close)
  8015f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015fc:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801601:	85 c0                	test   %eax,%eax
  801603:	74 0b                	je     801610 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801605:	83 ec 0c             	sub    $0xc,%esp
  801608:	56                   	push   %esi
  801609:	ff d0                	call   *%eax
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	56                   	push   %esi
  801614:	6a 00                	push   $0x0
  801616:	e8 f6 fb ff ff       	call   801211 <sys_page_unmap>
	return r;
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	eb b5                	jmp    8015d5 <fd_close+0x40>

00801620 <close>:

int
close(int fdnum)
{
  801620:	f3 0f 1e fb          	endbr32 
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	e8 ac fe ff ff       	call   8014e2 <fd_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	79 02                	jns    80163f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    
		return fd_close(fd, 1);
  80163f:	83 ec 08             	sub    $0x8,%esp
  801642:	6a 01                	push   $0x1
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	e8 49 ff ff ff       	call   801595 <fd_close>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	eb ec                	jmp    80163d <close+0x1d>

00801651 <close_all>:

void
close_all(void)
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	53                   	push   %ebx
  801659:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80165c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	53                   	push   %ebx
  801665:	e8 b6 ff ff ff       	call   801620 <close>
	for (i = 0; i < MAXFD; i++)
  80166a:	83 c3 01             	add    $0x1,%ebx
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	83 fb 20             	cmp    $0x20,%ebx
  801673:	75 ec                	jne    801661 <close_all+0x10>
}
  801675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80167a:	f3 0f 1e fb          	endbr32 
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	57                   	push   %edi
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80168a:	50                   	push   %eax
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 4f fe ff ff       	call   8014e2 <fd_lookup>
  801693:	89 c3                	mov    %eax,%ebx
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	0f 88 81 00 00 00    	js     801721 <dup+0xa7>
		return r;
	close(newfdnum);
  8016a0:	83 ec 0c             	sub    $0xc,%esp
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	e8 75 ff ff ff       	call   801620 <close>

	newfd = INDEX2FD(newfdnum);
  8016ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016ae:	c1 e6 0c             	shl    $0xc,%esi
  8016b1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8016b7:	83 c4 04             	add    $0x4,%esp
  8016ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016bd:	e8 af fd ff ff       	call   801471 <fd2data>
  8016c2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016c4:	89 34 24             	mov    %esi,(%esp)
  8016c7:	e8 a5 fd ff ff       	call   801471 <fd2data>
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016d1:	89 d8                	mov    %ebx,%eax
  8016d3:	c1 e8 16             	shr    $0x16,%eax
  8016d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016dd:	a8 01                	test   $0x1,%al
  8016df:	74 11                	je     8016f2 <dup+0x78>
  8016e1:	89 d8                	mov    %ebx,%eax
  8016e3:	c1 e8 0c             	shr    $0xc,%eax
  8016e6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016ed:	f6 c2 01             	test   $0x1,%dl
  8016f0:	75 39                	jne    80172b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	c1 e8 0c             	shr    $0xc,%eax
  8016fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	25 07 0e 00 00       	and    $0xe07,%eax
  801709:	50                   	push   %eax
  80170a:	56                   	push   %esi
  80170b:	6a 00                	push   $0x0
  80170d:	52                   	push   %edx
  80170e:	6a 00                	push   $0x0
  801710:	e8 b6 fa ff ff       	call   8011cb <sys_page_map>
  801715:	89 c3                	mov    %eax,%ebx
  801717:	83 c4 20             	add    $0x20,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 31                	js     80174f <dup+0xd5>
		goto err;

	return newfdnum;
  80171e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801721:	89 d8                	mov    %ebx,%eax
  801723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801726:	5b                   	pop    %ebx
  801727:	5e                   	pop    %esi
  801728:	5f                   	pop    %edi
  801729:	5d                   	pop    %ebp
  80172a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80172b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	25 07 0e 00 00       	and    $0xe07,%eax
  80173a:	50                   	push   %eax
  80173b:	57                   	push   %edi
  80173c:	6a 00                	push   $0x0
  80173e:	53                   	push   %ebx
  80173f:	6a 00                	push   $0x0
  801741:	e8 85 fa ff ff       	call   8011cb <sys_page_map>
  801746:	89 c3                	mov    %eax,%ebx
  801748:	83 c4 20             	add    $0x20,%esp
  80174b:	85 c0                	test   %eax,%eax
  80174d:	79 a3                	jns    8016f2 <dup+0x78>
	sys_page_unmap(0, newfd);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	56                   	push   %esi
  801753:	6a 00                	push   $0x0
  801755:	e8 b7 fa ff ff       	call   801211 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80175a:	83 c4 08             	add    $0x8,%esp
  80175d:	57                   	push   %edi
  80175e:	6a 00                	push   $0x0
  801760:	e8 ac fa ff ff       	call   801211 <sys_page_unmap>
	return r;
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	eb b7                	jmp    801721 <dup+0xa7>

0080176a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80176a:	f3 0f 1e fb          	endbr32 
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	53                   	push   %ebx
  801772:	83 ec 1c             	sub    $0x1c,%esp
  801775:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801778:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	53                   	push   %ebx
  80177d:	e8 60 fd ff ff       	call   8014e2 <fd_lookup>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	85 c0                	test   %eax,%eax
  801787:	78 3f                	js     8017c8 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178f:	50                   	push   %eax
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	ff 30                	pushl  (%eax)
  801795:	e8 9c fd ff ff       	call   801536 <dev_lookup>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 27                	js     8017c8 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a4:	8b 42 08             	mov    0x8(%edx),%eax
  8017a7:	83 e0 03             	and    $0x3,%eax
  8017aa:	83 f8 01             	cmp    $0x1,%eax
  8017ad:	74 1e                	je     8017cd <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	8b 40 08             	mov    0x8(%eax),%eax
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	74 35                	je     8017ee <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	ff 75 10             	pushl  0x10(%ebp)
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	52                   	push   %edx
  8017c3:	ff d0                	call   *%eax
  8017c5:	83 c4 10             	add    $0x10,%esp
}
  8017c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017cd:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8017d2:	8b 40 48             	mov    0x48(%eax),%eax
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	53                   	push   %ebx
  8017d9:	50                   	push   %eax
  8017da:	68 31 2f 80 00       	push   $0x802f31
  8017df:	e8 54 ef ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ec:	eb da                	jmp    8017c8 <read+0x5e>
		return -E_NOT_SUPP;
  8017ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f3:	eb d3                	jmp    8017c8 <read+0x5e>

008017f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017f5:	f3 0f 1e fb          	endbr32 
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	57                   	push   %edi
  8017fd:	56                   	push   %esi
  8017fe:	53                   	push   %ebx
  8017ff:	83 ec 0c             	sub    $0xc,%esp
  801802:	8b 7d 08             	mov    0x8(%ebp),%edi
  801805:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801808:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180d:	eb 02                	jmp    801811 <readn+0x1c>
  80180f:	01 c3                	add    %eax,%ebx
  801811:	39 f3                	cmp    %esi,%ebx
  801813:	73 21                	jae    801836 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801815:	83 ec 04             	sub    $0x4,%esp
  801818:	89 f0                	mov    %esi,%eax
  80181a:	29 d8                	sub    %ebx,%eax
  80181c:	50                   	push   %eax
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	03 45 0c             	add    0xc(%ebp),%eax
  801822:	50                   	push   %eax
  801823:	57                   	push   %edi
  801824:	e8 41 ff ff ff       	call   80176a <read>
		if (m < 0)
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 04                	js     801834 <readn+0x3f>
			return m;
		if (m == 0)
  801830:	75 dd                	jne    80180f <readn+0x1a>
  801832:	eb 02                	jmp    801836 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801834:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801836:	89 d8                	mov    %ebx,%eax
  801838:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5f                   	pop    %edi
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801840:	f3 0f 1e fb          	endbr32 
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	53                   	push   %ebx
  801848:	83 ec 1c             	sub    $0x1c,%esp
  80184b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	53                   	push   %ebx
  801853:	e8 8a fc ff ff       	call   8014e2 <fd_lookup>
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 3a                	js     801899 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801865:	50                   	push   %eax
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	ff 30                	pushl  (%eax)
  80186b:	e8 c6 fc ff ff       	call   801536 <dev_lookup>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	85 c0                	test   %eax,%eax
  801875:	78 22                	js     801899 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80187e:	74 1e                	je     80189e <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801883:	8b 52 0c             	mov    0xc(%edx),%edx
  801886:	85 d2                	test   %edx,%edx
  801888:	74 35                	je     8018bf <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	ff 75 10             	pushl  0x10(%ebp)
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	50                   	push   %eax
  801894:	ff d2                	call   *%edx
  801896:	83 c4 10             	add    $0x10,%esp
}
  801899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80189e:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8018a3:	8b 40 48             	mov    0x48(%eax),%eax
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	53                   	push   %ebx
  8018aa:	50                   	push   %eax
  8018ab:	68 4d 2f 80 00       	push   $0x802f4d
  8018b0:	e8 83 ee ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018bd:	eb da                	jmp    801899 <write+0x59>
		return -E_NOT_SUPP;
  8018bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c4:	eb d3                	jmp    801899 <write+0x59>

008018c6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018c6:	f3 0f 1e fb          	endbr32 
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d3:	50                   	push   %eax
  8018d4:	ff 75 08             	pushl  0x8(%ebp)
  8018d7:	e8 06 fc ff ff       	call   8014e2 <fd_lookup>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 0e                	js     8018f1 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018f3:	f3 0f 1e fb          	endbr32 
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 1c             	sub    $0x1c,%esp
  8018fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801901:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801904:	50                   	push   %eax
  801905:	53                   	push   %ebx
  801906:	e8 d7 fb ff ff       	call   8014e2 <fd_lookup>
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 37                	js     801949 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801912:	83 ec 08             	sub    $0x8,%esp
  801915:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801918:	50                   	push   %eax
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	ff 30                	pushl  (%eax)
  80191e:	e8 13 fc ff ff       	call   801536 <dev_lookup>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 1f                	js     801949 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801931:	74 1b                	je     80194e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801936:	8b 52 18             	mov    0x18(%edx),%edx
  801939:	85 d2                	test   %edx,%edx
  80193b:	74 32                	je     80196f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	ff d2                	call   *%edx
  801946:	83 c4 10             	add    $0x10,%esp
}
  801949:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80194e:	a1 b4 50 80 00       	mov    0x8050b4,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801953:	8b 40 48             	mov    0x48(%eax),%eax
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	53                   	push   %ebx
  80195a:	50                   	push   %eax
  80195b:	68 10 2f 80 00       	push   $0x802f10
  801960:	e8 d3 ed ff ff       	call   800738 <cprintf>
		return -E_INVAL;
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80196d:	eb da                	jmp    801949 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80196f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801974:	eb d3                	jmp    801949 <ftruncate+0x56>

00801976 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801976:	f3 0f 1e fb          	endbr32 
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 1c             	sub    $0x1c,%esp
  801981:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801984:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801987:	50                   	push   %eax
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	e8 52 fb ff ff       	call   8014e2 <fd_lookup>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 4b                	js     8019e2 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801997:	83 ec 08             	sub    $0x8,%esp
  80199a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a1:	ff 30                	pushl  (%eax)
  8019a3:	e8 8e fb ff ff       	call   801536 <dev_lookup>
  8019a8:	83 c4 10             	add    $0x10,%esp
  8019ab:	85 c0                	test   %eax,%eax
  8019ad:	78 33                	js     8019e2 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019b6:	74 2f                	je     8019e7 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019b8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019bb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019c2:	00 00 00 
	stat->st_isdir = 0;
  8019c5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019cc:	00 00 00 
	stat->st_dev = dev;
  8019cf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	53                   	push   %ebx
  8019d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019dc:	ff 50 14             	call   *0x14(%eax)
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    
		return -E_NOT_SUPP;
  8019e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ec:	eb f4                	jmp    8019e2 <fstat+0x6c>

008019ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019ee:	f3 0f 1e fb          	endbr32 
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	56                   	push   %esi
  8019f6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 08             	pushl  0x8(%ebp)
  8019ff:	e8 fb 01 00 00       	call   801bff <open>
  801a04:	89 c3                	mov    %eax,%ebx
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 1b                	js     801a28 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801a0d:	83 ec 08             	sub    $0x8,%esp
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	50                   	push   %eax
  801a14:	e8 5d ff ff ff       	call   801976 <fstat>
  801a19:	89 c6                	mov    %eax,%esi
	close(fd);
  801a1b:	89 1c 24             	mov    %ebx,(%esp)
  801a1e:	e8 fd fb ff ff       	call   801620 <close>
	return r;
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	89 f3                	mov    %esi,%ebx
}
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5e                   	pop    %esi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	89 c6                	mov    %eax,%esi
  801a38:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a3a:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801a41:	74 27                	je     801a6a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a43:	6a 07                	push   $0x7
  801a45:	68 00 60 80 00       	push   $0x806000
  801a4a:	56                   	push   %esi
  801a4b:	ff 35 ac 50 80 00    	pushl  0x8050ac
  801a51:	e8 7d 0c 00 00       	call   8026d3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a56:	83 c4 0c             	add    $0xc,%esp
  801a59:	6a 00                	push   $0x0
  801a5b:	53                   	push   %ebx
  801a5c:	6a 00                	push   $0x0
  801a5e:	e8 fc 0b 00 00       	call   80265f <ipc_recv>
}
  801a63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	6a 01                	push   $0x1
  801a6f:	e8 b7 0c 00 00       	call   80272b <ipc_find_env>
  801a74:	a3 ac 50 80 00       	mov    %eax,0x8050ac
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	eb c5                	jmp    801a43 <fsipc+0x12>

00801a7e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a7e:	f3 0f 1e fb          	endbr32 
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8e:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a96:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	b8 02 00 00 00       	mov    $0x2,%eax
  801aa5:	e8 87 ff ff ff       	call   801a31 <fsipc>
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <devfile_flush>:
{
  801aac:	f3 0f 1e fb          	endbr32 
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  801abc:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac6:	b8 06 00 00 00       	mov    $0x6,%eax
  801acb:	e8 61 ff ff ff       	call   801a31 <fsipc>
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <devfile_stat>:
{
  801ad2:	f3 0f 1e fb          	endbr32 
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae6:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801af0:	b8 05 00 00 00       	mov    $0x5,%eax
  801af5:	e8 37 ff ff ff       	call   801a31 <fsipc>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 2c                	js     801b2a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801afe:	83 ec 08             	sub    $0x8,%esp
  801b01:	68 00 60 80 00       	push   $0x806000
  801b06:	53                   	push   %ebx
  801b07:	e8 36 f2 ff ff       	call   800d42 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b0c:	a1 80 60 80 00       	mov    0x806080,%eax
  801b11:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b17:	a1 84 60 80 00       	mov    0x806084,%eax
  801b1c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b22:	83 c4 10             	add    $0x10,%esp
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <devfile_write>:
{
  801b2f:	f3 0f 1e fb          	endbr32 
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  801b3f:	8b 52 0c             	mov    0xc(%edx),%edx
  801b42:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801b48:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b4d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b52:	0f 47 c2             	cmova  %edx,%eax
  801b55:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801b5a:	50                   	push   %eax
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	68 08 60 80 00       	push   $0x806008
  801b63:	e8 90 f3 ff ff       	call   800ef8 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801b68:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6d:	b8 04 00 00 00       	mov    $0x4,%eax
  801b72:	e8 ba fe ff ff       	call   801a31 <fsipc>
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <devfile_read>:
{
  801b79:	f3 0f 1e fb          	endbr32 
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	56                   	push   %esi
  801b81:	53                   	push   %ebx
  801b82:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8b:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b90:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b96:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9b:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba0:	e8 8c fe ff ff       	call   801a31 <fsipc>
  801ba5:	89 c3                	mov    %eax,%ebx
  801ba7:	85 c0                	test   %eax,%eax
  801ba9:	78 1f                	js     801bca <devfile_read+0x51>
	assert(r <= n);
  801bab:	39 f0                	cmp    %esi,%eax
  801bad:	77 24                	ja     801bd3 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801baf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb4:	7f 33                	jg     801be9 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bb6:	83 ec 04             	sub    $0x4,%esp
  801bb9:	50                   	push   %eax
  801bba:	68 00 60 80 00       	push   $0x806000
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	e8 31 f3 ff ff       	call   800ef8 <memmove>
	return r;
  801bc7:	83 c4 10             	add    $0x10,%esp
}
  801bca:	89 d8                	mov    %ebx,%eax
  801bcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    
	assert(r <= n);
  801bd3:	68 80 2f 80 00       	push   $0x802f80
  801bd8:	68 87 2f 80 00       	push   $0x802f87
  801bdd:	6a 7c                	push   $0x7c
  801bdf:	68 9c 2f 80 00       	push   $0x802f9c
  801be4:	e8 68 ea ff ff       	call   800651 <_panic>
	assert(r <= PGSIZE);
  801be9:	68 a7 2f 80 00       	push   $0x802fa7
  801bee:	68 87 2f 80 00       	push   $0x802f87
  801bf3:	6a 7d                	push   $0x7d
  801bf5:	68 9c 2f 80 00       	push   $0x802f9c
  801bfa:	e8 52 ea ff ff       	call   800651 <_panic>

00801bff <open>:
{
  801bff:	f3 0f 1e fb          	endbr32 
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 1c             	sub    $0x1c,%esp
  801c0b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c0e:	56                   	push   %esi
  801c0f:	e8 eb f0 ff ff       	call   800cff <strlen>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c1c:	7f 6c                	jg     801c8a <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c24:	50                   	push   %eax
  801c25:	e8 62 f8 ff ff       	call   80148c <fd_alloc>
  801c2a:	89 c3                	mov    %eax,%ebx
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 3c                	js     801c6f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	56                   	push   %esi
  801c37:	68 00 60 80 00       	push   $0x806000
  801c3c:	e8 01 f1 ff ff       	call   800d42 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c44:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c51:	e8 db fd ff ff       	call   801a31 <fsipc>
  801c56:	89 c3                	mov    %eax,%ebx
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	85 c0                	test   %eax,%eax
  801c5d:	78 19                	js     801c78 <open+0x79>
	return fd2num(fd);
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	ff 75 f4             	pushl  -0xc(%ebp)
  801c65:	e8 f3 f7 ff ff       	call   80145d <fd2num>
  801c6a:	89 c3                	mov    %eax,%ebx
  801c6c:	83 c4 10             	add    $0x10,%esp
}
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5d                   	pop    %ebp
  801c77:	c3                   	ret    
		fd_close(fd, 0);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c80:	e8 10 f9 ff ff       	call   801595 <fd_close>
		return r;
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb e5                	jmp    801c6f <open+0x70>
		return -E_BAD_PATH;
  801c8a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c8f:	eb de                	jmp    801c6f <open+0x70>

00801c91 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c91:	f3 0f 1e fb          	endbr32 
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca0:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca5:	e8 87 fd ff ff       	call   801a31 <fsipc>
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cac:	f3 0f 1e fb          	endbr32 
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cb6:	68 b3 2f 80 00       	push   $0x802fb3
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	e8 7f f0 ff ff       	call   800d42 <strcpy>
	return 0;
}
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <devsock_close>:
{
  801cca:	f3 0f 1e fb          	endbr32 
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	53                   	push   %ebx
  801cd2:	83 ec 10             	sub    $0x10,%esp
  801cd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cd8:	53                   	push   %ebx
  801cd9:	e8 8a 0a 00 00       	call   802768 <pageref>
  801cde:	89 c2                	mov    %eax,%edx
  801ce0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801ce8:	83 fa 01             	cmp    $0x1,%edx
  801ceb:	74 05                	je     801cf2 <devsock_close+0x28>
}
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	ff 73 0c             	pushl  0xc(%ebx)
  801cf8:	e8 e3 02 00 00       	call   801fe0 <nsipc_close>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	eb eb                	jmp    801ced <devsock_close+0x23>

00801d02 <devsock_write>:
{
  801d02:	f3 0f 1e fb          	endbr32 
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	ff 70 0c             	pushl  0xc(%eax)
  801d1a:	e8 b5 03 00 00       	call   8020d4 <nsipc_send>
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <devsock_read>:
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	ff 70 0c             	pushl  0xc(%eax)
  801d39:	e8 1f 03 00 00       	call   80205d <nsipc_recv>
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <fd2sockid>:
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d46:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	e8 92 f7 ff ff       	call   8014e2 <fd_lookup>
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 10                	js     801d67 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d60:	39 08                	cmp    %ecx,(%eax)
  801d62:	75 05                	jne    801d69 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d64:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    
		return -E_NOT_SUPP;
  801d69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d6e:	eb f7                	jmp    801d67 <fd2sockid+0x27>

00801d70 <alloc_sockfd>:
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
  801d75:	83 ec 1c             	sub    $0x1c,%esp
  801d78:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7d:	50                   	push   %eax
  801d7e:	e8 09 f7 ff ff       	call   80148c <fd_alloc>
  801d83:	89 c3                	mov    %eax,%ebx
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	78 43                	js     801dcf <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	68 07 04 00 00       	push   $0x407
  801d94:	ff 75 f4             	pushl  -0xc(%ebp)
  801d97:	6a 00                	push   $0x0
  801d99:	e8 e6 f3 ff ff       	call   801184 <sys_page_alloc>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 28                	js     801dcf <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801db0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801dbc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	50                   	push   %eax
  801dc3:	e8 95 f6 ff ff       	call   80145d <fd2num>
  801dc8:	89 c3                	mov    %eax,%ebx
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	eb 0c                	jmp    801ddb <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	56                   	push   %esi
  801dd3:	e8 08 02 00 00       	call   801fe0 <nsipc_close>
		return r;
  801dd8:	83 c4 10             	add    $0x10,%esp
}
  801ddb:	89 d8                	mov    %ebx,%eax
  801ddd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    

00801de4 <accept>:
{
  801de4:	f3 0f 1e fb          	endbr32 
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	e8 4a ff ff ff       	call   801d40 <fd2sockid>
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 1b                	js     801e15 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	ff 75 10             	pushl  0x10(%ebp)
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	50                   	push   %eax
  801e04:	e8 22 01 00 00       	call   801f2b <nsipc_accept>
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	78 05                	js     801e15 <accept+0x31>
	return alloc_sockfd(r);
  801e10:	e8 5b ff ff ff       	call   801d70 <alloc_sockfd>
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <bind>:
{
  801e17:	f3 0f 1e fb          	endbr32 
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	e8 17 ff ff ff       	call   801d40 <fd2sockid>
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	78 12                	js     801e3f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	ff 75 10             	pushl  0x10(%ebp)
  801e33:	ff 75 0c             	pushl  0xc(%ebp)
  801e36:	50                   	push   %eax
  801e37:	e8 45 01 00 00       	call   801f81 <nsipc_bind>
  801e3c:	83 c4 10             	add    $0x10,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <shutdown>:
{
  801e41:	f3 0f 1e fb          	endbr32 
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	e8 ed fe ff ff       	call   801d40 <fd2sockid>
  801e53:	85 c0                	test   %eax,%eax
  801e55:	78 0f                	js     801e66 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801e57:	83 ec 08             	sub    $0x8,%esp
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	50                   	push   %eax
  801e5e:	e8 57 01 00 00       	call   801fba <nsipc_shutdown>
  801e63:	83 c4 10             	add    $0x10,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <connect>:
{
  801e68:	f3 0f 1e fb          	endbr32 
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	e8 c6 fe ff ff       	call   801d40 <fd2sockid>
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 12                	js     801e90 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	ff 75 10             	pushl  0x10(%ebp)
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	50                   	push   %eax
  801e88:	e8 71 01 00 00       	call   801ffe <nsipc_connect>
  801e8d:	83 c4 10             	add    $0x10,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <listen>:
{
  801e92:	f3 0f 1e fb          	endbr32 
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	e8 9c fe ff ff       	call   801d40 <fd2sockid>
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	78 0f                	js     801eb7 <listen+0x25>
	return nsipc_listen(r, backlog);
  801ea8:	83 ec 08             	sub    $0x8,%esp
  801eab:	ff 75 0c             	pushl  0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	e8 83 01 00 00       	call   802037 <nsipc_listen>
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801eb9:	f3 0f 1e fb          	endbr32 
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	ff 75 08             	pushl  0x8(%ebp)
  801ecc:	e8 65 02 00 00       	call   802136 <nsipc_socket>
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 05                	js     801edd <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ed8:	e8 93 fe ff ff       	call   801d70 <alloc_sockfd>
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	53                   	push   %ebx
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ee8:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  801eef:	74 26                	je     801f17 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ef1:	6a 07                	push   $0x7
  801ef3:	68 00 70 80 00       	push   $0x807000
  801ef8:	53                   	push   %ebx
  801ef9:	ff 35 b0 50 80 00    	pushl  0x8050b0
  801eff:	e8 cf 07 00 00       	call   8026d3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f04:	83 c4 0c             	add    $0xc,%esp
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	e8 4d 07 00 00       	call   80265f <ipc_recv>
}
  801f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f17:	83 ec 0c             	sub    $0xc,%esp
  801f1a:	6a 02                	push   $0x2
  801f1c:	e8 0a 08 00 00       	call   80272b <ipc_find_env>
  801f21:	a3 b0 50 80 00       	mov    %eax,0x8050b0
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	eb c6                	jmp    801ef1 <nsipc+0x12>

00801f2b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f2b:	f3 0f 1e fb          	endbr32 
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	56                   	push   %esi
  801f33:	53                   	push   %ebx
  801f34:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f3f:	8b 06                	mov    (%esi),%eax
  801f41:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f46:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4b:	e8 8f ff ff ff       	call   801edf <nsipc>
  801f50:	89 c3                	mov    %eax,%ebx
  801f52:	85 c0                	test   %eax,%eax
  801f54:	79 09                	jns    801f5f <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f56:	89 d8                	mov    %ebx,%eax
  801f58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	ff 35 10 70 80 00    	pushl  0x807010
  801f68:	68 00 70 80 00       	push   $0x807000
  801f6d:	ff 75 0c             	pushl  0xc(%ebp)
  801f70:	e8 83 ef ff ff       	call   800ef8 <memmove>
		*addrlen = ret->ret_addrlen;
  801f75:	a1 10 70 80 00       	mov    0x807010,%eax
  801f7a:	89 06                	mov    %eax,(%esi)
  801f7c:	83 c4 10             	add    $0x10,%esp
	return r;
  801f7f:	eb d5                	jmp    801f56 <nsipc_accept+0x2b>

00801f81 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f81:	f3 0f 1e fb          	endbr32 
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	53                   	push   %ebx
  801f89:	83 ec 08             	sub    $0x8,%esp
  801f8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f97:	53                   	push   %ebx
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	68 04 70 80 00       	push   $0x807004
  801fa0:	e8 53 ef ff ff       	call   800ef8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fa5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fab:	b8 02 00 00 00       	mov    $0x2,%eax
  801fb0:	e8 2a ff ff ff       	call   801edf <nsipc>
}
  801fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fba:	f3 0f 1e fb          	endbr32 
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801fd9:	e8 01 ff ff ff       	call   801edf <nsipc>
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fe0:	f3 0f 1e fb          	endbr32 
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801ff2:	b8 04 00 00 00       	mov    $0x4,%eax
  801ff7:	e8 e3 fe ff ff       	call   801edf <nsipc>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ffe:	f3 0f 1e fb          	endbr32 
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	53                   	push   %ebx
  802006:	83 ec 08             	sub    $0x8,%esp
  802009:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802014:	53                   	push   %ebx
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	68 04 70 80 00       	push   $0x807004
  80201d:	e8 d6 ee ff ff       	call   800ef8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802022:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802028:	b8 05 00 00 00       	mov    $0x5,%eax
  80202d:	e8 ad fe ff ff       	call   801edf <nsipc>
}
  802032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802037:	f3 0f 1e fb          	endbr32 
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802051:	b8 06 00 00 00       	mov    $0x6,%eax
  802056:	e8 84 fe ff ff       	call   801edf <nsipc>
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80205d:	f3 0f 1e fb          	endbr32 
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	56                   	push   %esi
  802065:	53                   	push   %ebx
  802066:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802071:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802077:	8b 45 14             	mov    0x14(%ebp),%eax
  80207a:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80207f:	b8 07 00 00 00       	mov    $0x7,%eax
  802084:	e8 56 fe ff ff       	call   801edf <nsipc>
  802089:	89 c3                	mov    %eax,%ebx
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 26                	js     8020b5 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80208f:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802095:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80209a:	0f 4e c6             	cmovle %esi,%eax
  80209d:	39 c3                	cmp    %eax,%ebx
  80209f:	7f 1d                	jg     8020be <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	53                   	push   %ebx
  8020a5:	68 00 70 80 00       	push   $0x807000
  8020aa:	ff 75 0c             	pushl  0xc(%ebp)
  8020ad:	e8 46 ee ff ff       	call   800ef8 <memmove>
  8020b2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020b5:	89 d8                	mov    %ebx,%eax
  8020b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ba:	5b                   	pop    %ebx
  8020bb:	5e                   	pop    %esi
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020be:	68 bf 2f 80 00       	push   $0x802fbf
  8020c3:	68 87 2f 80 00       	push   $0x802f87
  8020c8:	6a 62                	push   $0x62
  8020ca:	68 d4 2f 80 00       	push   $0x802fd4
  8020cf:	e8 7d e5 ff ff       	call   800651 <_panic>

008020d4 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020d4:	f3 0f 1e fb          	endbr32 
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020ea:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020f0:	7f 2e                	jg     802120 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	53                   	push   %ebx
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	68 0c 70 80 00       	push   $0x80700c
  8020fe:	e8 f5 ed ff ff       	call   800ef8 <memmove>
	nsipcbuf.send.req_size = size;
  802103:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802109:	8b 45 14             	mov    0x14(%ebp),%eax
  80210c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802111:	b8 08 00 00 00       	mov    $0x8,%eax
  802116:	e8 c4 fd ff ff       	call   801edf <nsipc>
}
  80211b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    
	assert(size < 1600);
  802120:	68 e0 2f 80 00       	push   $0x802fe0
  802125:	68 87 2f 80 00       	push   $0x802f87
  80212a:	6a 6d                	push   $0x6d
  80212c:	68 d4 2f 80 00       	push   $0x802fd4
  802131:	e8 1b e5 ff ff       	call   800651 <_panic>

00802136 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802136:	f3 0f 1e fb          	endbr32 
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802150:	8b 45 10             	mov    0x10(%ebp),%eax
  802153:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802158:	b8 09 00 00 00       	mov    $0x9,%eax
  80215d:	e8 7d fd ff ff       	call   801edf <nsipc>
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802164:	f3 0f 1e fb          	endbr32 
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
  80216d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 08             	pushl  0x8(%ebp)
  802176:	e8 f6 f2 ff ff       	call   801471 <fd2data>
  80217b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80217d:	83 c4 08             	add    $0x8,%esp
  802180:	68 ec 2f 80 00       	push   $0x802fec
  802185:	53                   	push   %ebx
  802186:	e8 b7 eb ff ff       	call   800d42 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80218b:	8b 46 04             	mov    0x4(%esi),%eax
  80218e:	2b 06                	sub    (%esi),%eax
  802190:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802196:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80219d:	00 00 00 
	stat->st_dev = &devpipe;
  8021a0:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021a7:	40 80 00 
	return 0;
}
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b2:	5b                   	pop    %ebx
  8021b3:	5e                   	pop    %esi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021b6:	f3 0f 1e fb          	endbr32 
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	53                   	push   %ebx
  8021be:	83 ec 0c             	sub    $0xc,%esp
  8021c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021c4:	53                   	push   %ebx
  8021c5:	6a 00                	push   $0x0
  8021c7:	e8 45 f0 ff ff       	call   801211 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021cc:	89 1c 24             	mov    %ebx,(%esp)
  8021cf:	e8 9d f2 ff ff       	call   801471 <fd2data>
  8021d4:	83 c4 08             	add    $0x8,%esp
  8021d7:	50                   	push   %eax
  8021d8:	6a 00                	push   $0x0
  8021da:	e8 32 f0 ff ff       	call   801211 <sys_page_unmap>
}
  8021df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <_pipeisclosed>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	57                   	push   %edi
  8021e8:	56                   	push   %esi
  8021e9:	53                   	push   %ebx
  8021ea:	83 ec 1c             	sub    $0x1c,%esp
  8021ed:	89 c7                	mov    %eax,%edi
  8021ef:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021f1:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8021f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	57                   	push   %edi
  8021fd:	e8 66 05 00 00       	call   802768 <pageref>
  802202:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802205:	89 34 24             	mov    %esi,(%esp)
  802208:	e8 5b 05 00 00       	call   802768 <pageref>
		nn = thisenv->env_runs;
  80220d:	8b 15 b4 50 80 00    	mov    0x8050b4,%edx
  802213:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	39 cb                	cmp    %ecx,%ebx
  80221b:	74 1b                	je     802238 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80221d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802220:	75 cf                	jne    8021f1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802222:	8b 42 58             	mov    0x58(%edx),%eax
  802225:	6a 01                	push   $0x1
  802227:	50                   	push   %eax
  802228:	53                   	push   %ebx
  802229:	68 f3 2f 80 00       	push   $0x802ff3
  80222e:	e8 05 e5 ff ff       	call   800738 <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp
  802236:	eb b9                	jmp    8021f1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802238:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80223b:	0f 94 c0             	sete   %al
  80223e:	0f b6 c0             	movzbl %al,%eax
}
  802241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <devpipe_write>:
{
  802249:	f3 0f 1e fb          	endbr32 
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	57                   	push   %edi
  802251:	56                   	push   %esi
  802252:	53                   	push   %ebx
  802253:	83 ec 28             	sub    $0x28,%esp
  802256:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802259:	56                   	push   %esi
  80225a:	e8 12 f2 ff ff       	call   801471 <fd2data>
  80225f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	bf 00 00 00 00       	mov    $0x0,%edi
  802269:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80226c:	74 4f                	je     8022bd <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80226e:	8b 43 04             	mov    0x4(%ebx),%eax
  802271:	8b 0b                	mov    (%ebx),%ecx
  802273:	8d 51 20             	lea    0x20(%ecx),%edx
  802276:	39 d0                	cmp    %edx,%eax
  802278:	72 14                	jb     80228e <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80227a:	89 da                	mov    %ebx,%edx
  80227c:	89 f0                	mov    %esi,%eax
  80227e:	e8 61 ff ff ff       	call   8021e4 <_pipeisclosed>
  802283:	85 c0                	test   %eax,%eax
  802285:	75 3b                	jne    8022c2 <devpipe_write+0x79>
			sys_yield();
  802287:	e8 d5 ee ff ff       	call   801161 <sys_yield>
  80228c:	eb e0                	jmp    80226e <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80228e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802291:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802295:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802298:	89 c2                	mov    %eax,%edx
  80229a:	c1 fa 1f             	sar    $0x1f,%edx
  80229d:	89 d1                	mov    %edx,%ecx
  80229f:	c1 e9 1b             	shr    $0x1b,%ecx
  8022a2:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022a5:	83 e2 1f             	and    $0x1f,%edx
  8022a8:	29 ca                	sub    %ecx,%edx
  8022aa:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022b2:	83 c0 01             	add    $0x1,%eax
  8022b5:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022b8:	83 c7 01             	add    $0x1,%edi
  8022bb:	eb ac                	jmp    802269 <devpipe_write+0x20>
	return i;
  8022bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c0:	eb 05                	jmp    8022c7 <devpipe_write+0x7e>
				return 0;
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5f                   	pop    %edi
  8022cd:	5d                   	pop    %ebp
  8022ce:	c3                   	ret    

008022cf <devpipe_read>:
{
  8022cf:	f3 0f 1e fb          	endbr32 
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	57                   	push   %edi
  8022d7:	56                   	push   %esi
  8022d8:	53                   	push   %ebx
  8022d9:	83 ec 18             	sub    $0x18,%esp
  8022dc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022df:	57                   	push   %edi
  8022e0:	e8 8c f1 ff ff       	call   801471 <fd2data>
  8022e5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	be 00 00 00 00       	mov    $0x0,%esi
  8022ef:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f2:	75 14                	jne    802308 <devpipe_read+0x39>
	return i;
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	eb 02                	jmp    8022fb <devpipe_read+0x2c>
				return i;
  8022f9:	89 f0                	mov    %esi,%eax
}
  8022fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5f                   	pop    %edi
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    
			sys_yield();
  802303:	e8 59 ee ff ff       	call   801161 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802308:	8b 03                	mov    (%ebx),%eax
  80230a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80230d:	75 18                	jne    802327 <devpipe_read+0x58>
			if (i > 0)
  80230f:	85 f6                	test   %esi,%esi
  802311:	75 e6                	jne    8022f9 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802313:	89 da                	mov    %ebx,%edx
  802315:	89 f8                	mov    %edi,%eax
  802317:	e8 c8 fe ff ff       	call   8021e4 <_pipeisclosed>
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 e3                	je     802303 <devpipe_read+0x34>
				return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	eb d4                	jmp    8022fb <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802327:	99                   	cltd   
  802328:	c1 ea 1b             	shr    $0x1b,%edx
  80232b:	01 d0                	add    %edx,%eax
  80232d:	83 e0 1f             	and    $0x1f,%eax
  802330:	29 d0                	sub    %edx,%eax
  802332:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80233a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80233d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802340:	83 c6 01             	add    $0x1,%esi
  802343:	eb aa                	jmp    8022ef <devpipe_read+0x20>

00802345 <pipe>:
{
  802345:	f3 0f 1e fb          	endbr32 
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	56                   	push   %esi
  80234d:	53                   	push   %ebx
  80234e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802351:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802354:	50                   	push   %eax
  802355:	e8 32 f1 ff ff       	call   80148c <fd_alloc>
  80235a:	89 c3                	mov    %eax,%ebx
  80235c:	83 c4 10             	add    $0x10,%esp
  80235f:	85 c0                	test   %eax,%eax
  802361:	0f 88 23 01 00 00    	js     80248a <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	68 07 04 00 00       	push   $0x407
  80236f:	ff 75 f4             	pushl  -0xc(%ebp)
  802372:	6a 00                	push   $0x0
  802374:	e8 0b ee ff ff       	call   801184 <sys_page_alloc>
  802379:	89 c3                	mov    %eax,%ebx
  80237b:	83 c4 10             	add    $0x10,%esp
  80237e:	85 c0                	test   %eax,%eax
  802380:	0f 88 04 01 00 00    	js     80248a <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80238c:	50                   	push   %eax
  80238d:	e8 fa f0 ff ff       	call   80148c <fd_alloc>
  802392:	89 c3                	mov    %eax,%ebx
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	85 c0                	test   %eax,%eax
  802399:	0f 88 db 00 00 00    	js     80247a <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 07 04 00 00       	push   $0x407
  8023a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8023aa:	6a 00                	push   $0x0
  8023ac:	e8 d3 ed ff ff       	call   801184 <sys_page_alloc>
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	0f 88 bc 00 00 00    	js     80247a <pipe+0x135>
	va = fd2data(fd0);
  8023be:	83 ec 0c             	sub    $0xc,%esp
  8023c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c4:	e8 a8 f0 ff ff       	call   801471 <fd2data>
  8023c9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023cb:	83 c4 0c             	add    $0xc,%esp
  8023ce:	68 07 04 00 00       	push   $0x407
  8023d3:	50                   	push   %eax
  8023d4:	6a 00                	push   $0x0
  8023d6:	e8 a9 ed ff ff       	call   801184 <sys_page_alloc>
  8023db:	89 c3                	mov    %eax,%ebx
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	0f 88 82 00 00 00    	js     80246a <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e8:	83 ec 0c             	sub    $0xc,%esp
  8023eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ee:	e8 7e f0 ff ff       	call   801471 <fd2data>
  8023f3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023fa:	50                   	push   %eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	56                   	push   %esi
  8023fe:	6a 00                	push   $0x0
  802400:	e8 c6 ed ff ff       	call   8011cb <sys_page_map>
  802405:	89 c3                	mov    %eax,%ebx
  802407:	83 c4 20             	add    $0x20,%esp
  80240a:	85 c0                	test   %eax,%eax
  80240c:	78 4e                	js     80245c <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80240e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802416:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802418:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802425:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	ff 75 f4             	pushl  -0xc(%ebp)
  802437:	e8 21 f0 ff ff       	call   80145d <fd2num>
  80243c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802441:	83 c4 04             	add    $0x4,%esp
  802444:	ff 75 f0             	pushl  -0x10(%ebp)
  802447:	e8 11 f0 ff ff       	call   80145d <fd2num>
  80244c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802452:	83 c4 10             	add    $0x10,%esp
  802455:	bb 00 00 00 00       	mov    $0x0,%ebx
  80245a:	eb 2e                	jmp    80248a <pipe+0x145>
	sys_page_unmap(0, va);
  80245c:	83 ec 08             	sub    $0x8,%esp
  80245f:	56                   	push   %esi
  802460:	6a 00                	push   $0x0
  802462:	e8 aa ed ff ff       	call   801211 <sys_page_unmap>
  802467:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80246a:	83 ec 08             	sub    $0x8,%esp
  80246d:	ff 75 f0             	pushl  -0x10(%ebp)
  802470:	6a 00                	push   $0x0
  802472:	e8 9a ed ff ff       	call   801211 <sys_page_unmap>
  802477:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80247a:	83 ec 08             	sub    $0x8,%esp
  80247d:	ff 75 f4             	pushl  -0xc(%ebp)
  802480:	6a 00                	push   $0x0
  802482:	e8 8a ed ff ff       	call   801211 <sys_page_unmap>
  802487:	83 c4 10             	add    $0x10,%esp
}
  80248a:	89 d8                	mov    %ebx,%eax
  80248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5d                   	pop    %ebp
  802492:	c3                   	ret    

00802493 <pipeisclosed>:
{
  802493:	f3 0f 1e fb          	endbr32 
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80249d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a0:	50                   	push   %eax
  8024a1:	ff 75 08             	pushl  0x8(%ebp)
  8024a4:	e8 39 f0 ff ff       	call   8014e2 <fd_lookup>
  8024a9:	83 c4 10             	add    $0x10,%esp
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	78 18                	js     8024c8 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8024b0:	83 ec 0c             	sub    $0xc,%esp
  8024b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b6:	e8 b6 ef ff ff       	call   801471 <fd2data>
  8024bb:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	e8 1f fd ff ff       	call   8021e4 <_pipeisclosed>
  8024c5:	83 c4 10             	add    $0x10,%esp
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024ca:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	c3                   	ret    

008024d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024d4:	f3 0f 1e fb          	endbr32 
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024de:	68 0b 30 80 00       	push   $0x80300b
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	e8 57 e8 ff ff       	call   800d42 <strcpy>
	return 0;
}
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <devcons_write>:
{
  8024f2:	f3 0f 1e fb          	endbr32 
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	57                   	push   %edi
  8024fa:	56                   	push   %esi
  8024fb:	53                   	push   %ebx
  8024fc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802502:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802507:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80250d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802510:	73 31                	jae    802543 <devcons_write+0x51>
		m = n - tot;
  802512:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802515:	29 f3                	sub    %esi,%ebx
  802517:	83 fb 7f             	cmp    $0x7f,%ebx
  80251a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80251f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802522:	83 ec 04             	sub    $0x4,%esp
  802525:	53                   	push   %ebx
  802526:	89 f0                	mov    %esi,%eax
  802528:	03 45 0c             	add    0xc(%ebp),%eax
  80252b:	50                   	push   %eax
  80252c:	57                   	push   %edi
  80252d:	e8 c6 e9 ff ff       	call   800ef8 <memmove>
		sys_cputs(buf, m);
  802532:	83 c4 08             	add    $0x8,%esp
  802535:	53                   	push   %ebx
  802536:	57                   	push   %edi
  802537:	e8 78 eb ff ff       	call   8010b4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80253c:	01 de                	add    %ebx,%esi
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	eb ca                	jmp    80250d <devcons_write+0x1b>
}
  802543:	89 f0                	mov    %esi,%eax
  802545:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802548:	5b                   	pop    %ebx
  802549:	5e                   	pop    %esi
  80254a:	5f                   	pop    %edi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    

0080254d <devcons_read>:
{
  80254d:	f3 0f 1e fb          	endbr32 
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	83 ec 08             	sub    $0x8,%esp
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80255c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802560:	74 21                	je     802583 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802562:	e8 6f eb ff ff       	call   8010d6 <sys_cgetc>
  802567:	85 c0                	test   %eax,%eax
  802569:	75 07                	jne    802572 <devcons_read+0x25>
		sys_yield();
  80256b:	e8 f1 eb ff ff       	call   801161 <sys_yield>
  802570:	eb f0                	jmp    802562 <devcons_read+0x15>
	if (c < 0)
  802572:	78 0f                	js     802583 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802574:	83 f8 04             	cmp    $0x4,%eax
  802577:	74 0c                	je     802585 <devcons_read+0x38>
	*(char*)vbuf = c;
  802579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257c:	88 02                	mov    %al,(%edx)
	return 1;
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    
		return 0;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
  80258a:	eb f7                	jmp    802583 <devcons_read+0x36>

0080258c <cputchar>:
{
  80258c:	f3 0f 1e fb          	endbr32 
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80259c:	6a 01                	push   $0x1
  80259e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025a1:	50                   	push   %eax
  8025a2:	e8 0d eb ff ff       	call   8010b4 <sys_cputs>
}
  8025a7:	83 c4 10             	add    $0x10,%esp
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <getchar>:
{
  8025ac:	f3 0f 1e fb          	endbr32 
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025b6:	6a 01                	push   $0x1
  8025b8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025bb:	50                   	push   %eax
  8025bc:	6a 00                	push   $0x0
  8025be:	e8 a7 f1 ff ff       	call   80176a <read>
	if (r < 0)
  8025c3:	83 c4 10             	add    $0x10,%esp
  8025c6:	85 c0                	test   %eax,%eax
  8025c8:	78 06                	js     8025d0 <getchar+0x24>
	if (r < 1)
  8025ca:	74 06                	je     8025d2 <getchar+0x26>
	return c;
  8025cc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    
		return -E_EOF;
  8025d2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025d7:	eb f7                	jmp    8025d0 <getchar+0x24>

008025d9 <iscons>:
{
  8025d9:	f3 0f 1e fb          	endbr32 
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
  8025e0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e6:	50                   	push   %eax
  8025e7:	ff 75 08             	pushl  0x8(%ebp)
  8025ea:	e8 f3 ee ff ff       	call   8014e2 <fd_lookup>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	78 11                	js     802607 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025ff:	39 10                	cmp    %edx,(%eax)
  802601:	0f 94 c0             	sete   %al
  802604:	0f b6 c0             	movzbl %al,%eax
}
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <opencons>:
{
  802609:	f3 0f 1e fb          	endbr32 
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
  802610:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802616:	50                   	push   %eax
  802617:	e8 70 ee ff ff       	call   80148c <fd_alloc>
  80261c:	83 c4 10             	add    $0x10,%esp
  80261f:	85 c0                	test   %eax,%eax
  802621:	78 3a                	js     80265d <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802623:	83 ec 04             	sub    $0x4,%esp
  802626:	68 07 04 00 00       	push   $0x407
  80262b:	ff 75 f4             	pushl  -0xc(%ebp)
  80262e:	6a 00                	push   $0x0
  802630:	e8 4f eb ff ff       	call   801184 <sys_page_alloc>
  802635:	83 c4 10             	add    $0x10,%esp
  802638:	85 c0                	test   %eax,%eax
  80263a:	78 21                	js     80265d <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802645:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802651:	83 ec 0c             	sub    $0xc,%esp
  802654:	50                   	push   %eax
  802655:	e8 03 ee ff ff       	call   80145d <fd2num>
  80265a:	83 c4 10             	add    $0x10,%esp
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80265f:	f3 0f 1e fb          	endbr32 
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	56                   	push   %esi
  802667:	53                   	push   %ebx
  802668:	8b 75 08             	mov    0x8(%ebp),%esi
  80266b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802671:	83 e8 01             	sub    $0x1,%eax
  802674:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802679:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80267e:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	50                   	push   %eax
  802686:	e8 c5 ec ff ff       	call   801350 <sys_ipc_recv>
	if (!t) {
  80268b:	83 c4 10             	add    $0x10,%esp
  80268e:	85 c0                	test   %eax,%eax
  802690:	75 2b                	jne    8026bd <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802692:	85 f6                	test   %esi,%esi
  802694:	74 0a                	je     8026a0 <ipc_recv+0x41>
  802696:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80269b:	8b 40 74             	mov    0x74(%eax),%eax
  80269e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8026a0:	85 db                	test   %ebx,%ebx
  8026a2:	74 0a                	je     8026ae <ipc_recv+0x4f>
  8026a4:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8026a9:	8b 40 78             	mov    0x78(%eax),%eax
  8026ac:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8026ae:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8026b3:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8026b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026b9:	5b                   	pop    %ebx
  8026ba:	5e                   	pop    %esi
  8026bb:	5d                   	pop    %ebp
  8026bc:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8026bd:	85 f6                	test   %esi,%esi
  8026bf:	74 06                	je     8026c7 <ipc_recv+0x68>
  8026c1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8026c7:	85 db                	test   %ebx,%ebx
  8026c9:	74 eb                	je     8026b6 <ipc_recv+0x57>
  8026cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026d1:	eb e3                	jmp    8026b6 <ipc_recv+0x57>

008026d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026d3:	f3 0f 1e fb          	endbr32 
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	57                   	push   %edi
  8026db:	56                   	push   %esi
  8026dc:	53                   	push   %ebx
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8026e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8026e9:	85 db                	test   %ebx,%ebx
  8026eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8026f0:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8026f3:	ff 75 14             	pushl  0x14(%ebp)
  8026f6:	53                   	push   %ebx
  8026f7:	56                   	push   %esi
  8026f8:	57                   	push   %edi
  8026f9:	e8 2b ec ff ff       	call   801329 <sys_ipc_try_send>
  8026fe:	83 c4 10             	add    $0x10,%esp
  802701:	85 c0                	test   %eax,%eax
  802703:	74 1e                	je     802723 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802705:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802708:	75 07                	jne    802711 <ipc_send+0x3e>
		sys_yield();
  80270a:	e8 52 ea ff ff       	call   801161 <sys_yield>
  80270f:	eb e2                	jmp    8026f3 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802711:	50                   	push   %eax
  802712:	68 17 30 80 00       	push   $0x803017
  802717:	6a 39                	push   $0x39
  802719:	68 29 30 80 00       	push   $0x803029
  80271e:	e8 2e df ff ff       	call   800651 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802723:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802726:	5b                   	pop    %ebx
  802727:	5e                   	pop    %esi
  802728:	5f                   	pop    %edi
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    

0080272b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80272b:	f3 0f 1e fb          	endbr32 
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80273a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80273d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802743:	8b 52 50             	mov    0x50(%edx),%edx
  802746:	39 ca                	cmp    %ecx,%edx
  802748:	74 11                	je     80275b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80274a:	83 c0 01             	add    $0x1,%eax
  80274d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802752:	75 e6                	jne    80273a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	eb 0b                	jmp    802766 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80275b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80275e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802763:	8b 40 48             	mov    0x48(%eax),%eax
}
  802766:	5d                   	pop    %ebp
  802767:	c3                   	ret    

00802768 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802768:	f3 0f 1e fb          	endbr32 
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802772:	89 c2                	mov    %eax,%edx
  802774:	c1 ea 16             	shr    $0x16,%edx
  802777:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80277e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802783:	f6 c1 01             	test   $0x1,%cl
  802786:	74 1c                	je     8027a4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802788:	c1 e8 0c             	shr    $0xc,%eax
  80278b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802792:	a8 01                	test   $0x1,%al
  802794:	74 0e                	je     8027a4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802796:	c1 e8 0c             	shr    $0xc,%eax
  802799:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8027a0:	ef 
  8027a1:	0f b7 d2             	movzwl %dx,%edx
}
  8027a4:	89 d0                	mov    %edx,%eax
  8027a6:	5d                   	pop    %ebp
  8027a7:	c3                   	ret    
  8027a8:	66 90                	xchg   %ax,%ax
  8027aa:	66 90                	xchg   %ax,%ax
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <__udivdi3>:
  8027b0:	f3 0f 1e fb          	endbr32 
  8027b4:	55                   	push   %ebp
  8027b5:	57                   	push   %edi
  8027b6:	56                   	push   %esi
  8027b7:	53                   	push   %ebx
  8027b8:	83 ec 1c             	sub    $0x1c,%esp
  8027bb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027bf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027c7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027cb:	85 d2                	test   %edx,%edx
  8027cd:	75 19                	jne    8027e8 <__udivdi3+0x38>
  8027cf:	39 f3                	cmp    %esi,%ebx
  8027d1:	76 4d                	jbe    802820 <__udivdi3+0x70>
  8027d3:	31 ff                	xor    %edi,%edi
  8027d5:	89 e8                	mov    %ebp,%eax
  8027d7:	89 f2                	mov    %esi,%edx
  8027d9:	f7 f3                	div    %ebx
  8027db:	89 fa                	mov    %edi,%edx
  8027dd:	83 c4 1c             	add    $0x1c,%esp
  8027e0:	5b                   	pop    %ebx
  8027e1:	5e                   	pop    %esi
  8027e2:	5f                   	pop    %edi
  8027e3:	5d                   	pop    %ebp
  8027e4:	c3                   	ret    
  8027e5:	8d 76 00             	lea    0x0(%esi),%esi
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	76 14                	jbe    802800 <__udivdi3+0x50>
  8027ec:	31 ff                	xor    %edi,%edi
  8027ee:	31 c0                	xor    %eax,%eax
  8027f0:	89 fa                	mov    %edi,%edx
  8027f2:	83 c4 1c             	add    $0x1c,%esp
  8027f5:	5b                   	pop    %ebx
  8027f6:	5e                   	pop    %esi
  8027f7:	5f                   	pop    %edi
  8027f8:	5d                   	pop    %ebp
  8027f9:	c3                   	ret    
  8027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802800:	0f bd fa             	bsr    %edx,%edi
  802803:	83 f7 1f             	xor    $0x1f,%edi
  802806:	75 48                	jne    802850 <__udivdi3+0xa0>
  802808:	39 f2                	cmp    %esi,%edx
  80280a:	72 06                	jb     802812 <__udivdi3+0x62>
  80280c:	31 c0                	xor    %eax,%eax
  80280e:	39 eb                	cmp    %ebp,%ebx
  802810:	77 de                	ja     8027f0 <__udivdi3+0x40>
  802812:	b8 01 00 00 00       	mov    $0x1,%eax
  802817:	eb d7                	jmp    8027f0 <__udivdi3+0x40>
  802819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802820:	89 d9                	mov    %ebx,%ecx
  802822:	85 db                	test   %ebx,%ebx
  802824:	75 0b                	jne    802831 <__udivdi3+0x81>
  802826:	b8 01 00 00 00       	mov    $0x1,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	f7 f3                	div    %ebx
  80282f:	89 c1                	mov    %eax,%ecx
  802831:	31 d2                	xor    %edx,%edx
  802833:	89 f0                	mov    %esi,%eax
  802835:	f7 f1                	div    %ecx
  802837:	89 c6                	mov    %eax,%esi
  802839:	89 e8                	mov    %ebp,%eax
  80283b:	89 f7                	mov    %esi,%edi
  80283d:	f7 f1                	div    %ecx
  80283f:	89 fa                	mov    %edi,%edx
  802841:	83 c4 1c             	add    $0x1c,%esp
  802844:	5b                   	pop    %ebx
  802845:	5e                   	pop    %esi
  802846:	5f                   	pop    %edi
  802847:	5d                   	pop    %ebp
  802848:	c3                   	ret    
  802849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802850:	89 f9                	mov    %edi,%ecx
  802852:	b8 20 00 00 00       	mov    $0x20,%eax
  802857:	29 f8                	sub    %edi,%eax
  802859:	d3 e2                	shl    %cl,%edx
  80285b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80285f:	89 c1                	mov    %eax,%ecx
  802861:	89 da                	mov    %ebx,%edx
  802863:	d3 ea                	shr    %cl,%edx
  802865:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802869:	09 d1                	or     %edx,%ecx
  80286b:	89 f2                	mov    %esi,%edx
  80286d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802871:	89 f9                	mov    %edi,%ecx
  802873:	d3 e3                	shl    %cl,%ebx
  802875:	89 c1                	mov    %eax,%ecx
  802877:	d3 ea                	shr    %cl,%edx
  802879:	89 f9                	mov    %edi,%ecx
  80287b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80287f:	89 eb                	mov    %ebp,%ebx
  802881:	d3 e6                	shl    %cl,%esi
  802883:	89 c1                	mov    %eax,%ecx
  802885:	d3 eb                	shr    %cl,%ebx
  802887:	09 de                	or     %ebx,%esi
  802889:	89 f0                	mov    %esi,%eax
  80288b:	f7 74 24 08          	divl   0x8(%esp)
  80288f:	89 d6                	mov    %edx,%esi
  802891:	89 c3                	mov    %eax,%ebx
  802893:	f7 64 24 0c          	mull   0xc(%esp)
  802897:	39 d6                	cmp    %edx,%esi
  802899:	72 15                	jb     8028b0 <__udivdi3+0x100>
  80289b:	89 f9                	mov    %edi,%ecx
  80289d:	d3 e5                	shl    %cl,%ebp
  80289f:	39 c5                	cmp    %eax,%ebp
  8028a1:	73 04                	jae    8028a7 <__udivdi3+0xf7>
  8028a3:	39 d6                	cmp    %edx,%esi
  8028a5:	74 09                	je     8028b0 <__udivdi3+0x100>
  8028a7:	89 d8                	mov    %ebx,%eax
  8028a9:	31 ff                	xor    %edi,%edi
  8028ab:	e9 40 ff ff ff       	jmp    8027f0 <__udivdi3+0x40>
  8028b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028b3:	31 ff                	xor    %edi,%edi
  8028b5:	e9 36 ff ff ff       	jmp    8027f0 <__udivdi3+0x40>
  8028ba:	66 90                	xchg   %ax,%ax
  8028bc:	66 90                	xchg   %ax,%ax
  8028be:	66 90                	xchg   %ax,%ax

008028c0 <__umoddi3>:
  8028c0:	f3 0f 1e fb          	endbr32 
  8028c4:	55                   	push   %ebp
  8028c5:	57                   	push   %edi
  8028c6:	56                   	push   %esi
  8028c7:	53                   	push   %ebx
  8028c8:	83 ec 1c             	sub    $0x1c,%esp
  8028cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028d3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	75 19                	jne    8028f8 <__umoddi3+0x38>
  8028df:	39 df                	cmp    %ebx,%edi
  8028e1:	76 5d                	jbe    802940 <__umoddi3+0x80>
  8028e3:	89 f0                	mov    %esi,%eax
  8028e5:	89 da                	mov    %ebx,%edx
  8028e7:	f7 f7                	div    %edi
  8028e9:	89 d0                	mov    %edx,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	83 c4 1c             	add    $0x1c,%esp
  8028f0:	5b                   	pop    %ebx
  8028f1:	5e                   	pop    %esi
  8028f2:	5f                   	pop    %edi
  8028f3:	5d                   	pop    %ebp
  8028f4:	c3                   	ret    
  8028f5:	8d 76 00             	lea    0x0(%esi),%esi
  8028f8:	89 f2                	mov    %esi,%edx
  8028fa:	39 d8                	cmp    %ebx,%eax
  8028fc:	76 12                	jbe    802910 <__umoddi3+0x50>
  8028fe:	89 f0                	mov    %esi,%eax
  802900:	89 da                	mov    %ebx,%edx
  802902:	83 c4 1c             	add    $0x1c,%esp
  802905:	5b                   	pop    %ebx
  802906:	5e                   	pop    %esi
  802907:	5f                   	pop    %edi
  802908:	5d                   	pop    %ebp
  802909:	c3                   	ret    
  80290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802910:	0f bd e8             	bsr    %eax,%ebp
  802913:	83 f5 1f             	xor    $0x1f,%ebp
  802916:	75 50                	jne    802968 <__umoddi3+0xa8>
  802918:	39 d8                	cmp    %ebx,%eax
  80291a:	0f 82 e0 00 00 00    	jb     802a00 <__umoddi3+0x140>
  802920:	89 d9                	mov    %ebx,%ecx
  802922:	39 f7                	cmp    %esi,%edi
  802924:	0f 86 d6 00 00 00    	jbe    802a00 <__umoddi3+0x140>
  80292a:	89 d0                	mov    %edx,%eax
  80292c:	89 ca                	mov    %ecx,%edx
  80292e:	83 c4 1c             	add    $0x1c,%esp
  802931:	5b                   	pop    %ebx
  802932:	5e                   	pop    %esi
  802933:	5f                   	pop    %edi
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    
  802936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80293d:	8d 76 00             	lea    0x0(%esi),%esi
  802940:	89 fd                	mov    %edi,%ebp
  802942:	85 ff                	test   %edi,%edi
  802944:	75 0b                	jne    802951 <__umoddi3+0x91>
  802946:	b8 01 00 00 00       	mov    $0x1,%eax
  80294b:	31 d2                	xor    %edx,%edx
  80294d:	f7 f7                	div    %edi
  80294f:	89 c5                	mov    %eax,%ebp
  802951:	89 d8                	mov    %ebx,%eax
  802953:	31 d2                	xor    %edx,%edx
  802955:	f7 f5                	div    %ebp
  802957:	89 f0                	mov    %esi,%eax
  802959:	f7 f5                	div    %ebp
  80295b:	89 d0                	mov    %edx,%eax
  80295d:	31 d2                	xor    %edx,%edx
  80295f:	eb 8c                	jmp    8028ed <__umoddi3+0x2d>
  802961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 e9                	mov    %ebp,%ecx
  80296a:	ba 20 00 00 00       	mov    $0x20,%edx
  80296f:	29 ea                	sub    %ebp,%edx
  802971:	d3 e0                	shl    %cl,%eax
  802973:	89 44 24 08          	mov    %eax,0x8(%esp)
  802977:	89 d1                	mov    %edx,%ecx
  802979:	89 f8                	mov    %edi,%eax
  80297b:	d3 e8                	shr    %cl,%eax
  80297d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802981:	89 54 24 04          	mov    %edx,0x4(%esp)
  802985:	8b 54 24 04          	mov    0x4(%esp),%edx
  802989:	09 c1                	or     %eax,%ecx
  80298b:	89 d8                	mov    %ebx,%eax
  80298d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802991:	89 e9                	mov    %ebp,%ecx
  802993:	d3 e7                	shl    %cl,%edi
  802995:	89 d1                	mov    %edx,%ecx
  802997:	d3 e8                	shr    %cl,%eax
  802999:	89 e9                	mov    %ebp,%ecx
  80299b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80299f:	d3 e3                	shl    %cl,%ebx
  8029a1:	89 c7                	mov    %eax,%edi
  8029a3:	89 d1                	mov    %edx,%ecx
  8029a5:	89 f0                	mov    %esi,%eax
  8029a7:	d3 e8                	shr    %cl,%eax
  8029a9:	89 e9                	mov    %ebp,%ecx
  8029ab:	89 fa                	mov    %edi,%edx
  8029ad:	d3 e6                	shl    %cl,%esi
  8029af:	09 d8                	or     %ebx,%eax
  8029b1:	f7 74 24 08          	divl   0x8(%esp)
  8029b5:	89 d1                	mov    %edx,%ecx
  8029b7:	89 f3                	mov    %esi,%ebx
  8029b9:	f7 64 24 0c          	mull   0xc(%esp)
  8029bd:	89 c6                	mov    %eax,%esi
  8029bf:	89 d7                	mov    %edx,%edi
  8029c1:	39 d1                	cmp    %edx,%ecx
  8029c3:	72 06                	jb     8029cb <__umoddi3+0x10b>
  8029c5:	75 10                	jne    8029d7 <__umoddi3+0x117>
  8029c7:	39 c3                	cmp    %eax,%ebx
  8029c9:	73 0c                	jae    8029d7 <__umoddi3+0x117>
  8029cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029d3:	89 d7                	mov    %edx,%edi
  8029d5:	89 c6                	mov    %eax,%esi
  8029d7:	89 ca                	mov    %ecx,%edx
  8029d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029de:	29 f3                	sub    %esi,%ebx
  8029e0:	19 fa                	sbb    %edi,%edx
  8029e2:	89 d0                	mov    %edx,%eax
  8029e4:	d3 e0                	shl    %cl,%eax
  8029e6:	89 e9                	mov    %ebp,%ecx
  8029e8:	d3 eb                	shr    %cl,%ebx
  8029ea:	d3 ea                	shr    %cl,%edx
  8029ec:	09 d8                	or     %ebx,%eax
  8029ee:	83 c4 1c             	add    $0x1c,%esp
  8029f1:	5b                   	pop    %ebx
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
  8029f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029fd:	8d 76 00             	lea    0x0(%esi),%esi
  802a00:	29 fe                	sub    %edi,%esi
  802a02:	19 c3                	sbb    %eax,%ebx
  802a04:	89 f2                	mov    %esi,%edx
  802a06:	89 d9                	mov    %ebx,%ecx
  802a08:	e9 1d ff ff ff       	jmp    80292a <__umoddi3+0x6a>
