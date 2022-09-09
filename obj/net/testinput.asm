
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 40 07 00 00       	call   800771 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 7c             	sub    $0x7c,%esp
	envid_t ns_envid = sys_getenvid();
  800040:	e8 81 12 00 00       	call   8012c6 <sys_getenvid>
  800045:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800047:	c7 05 00 40 80 00 e0 	movl   $0x802ee0,0x804000
  80004e:	2e 80 00 

	output_envid = fork();
  800051:	e8 ea 16 00 00       	call   801740 <fork>
  800056:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  80005b:	85 c0                	test   %eax,%eax
  80005d:	0f 88 7b 01 00 00    	js     8001de <umain+0x1ab>
		panic("error forking");
	else if (output_envid == 0) {
  800063:	0f 84 89 01 00 00    	je     8001f2 <umain+0x1bf>
		output(ns_envid);
		return;
	}

	input_envid = fork();
  800069:	e8 d2 16 00 00       	call   801740 <fork>
  80006e:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	0f 88 8b 01 00 00    	js     800206 <umain+0x1d3>
		panic("error forking");
	else if (input_envid == 0) {
  80007b:	0f 84 99 01 00 00    	je     80021a <umain+0x1e7>
		input(ns_envid);
		return;
	}

	cprintf("Sending ARP announcement...\n");
  800081:	83 ec 0c             	sub    $0xc,%esp
  800084:	68 08 2f 80 00       	push   $0x802f08
  800089:	e8 32 08 00 00       	call   8008c0 <cprintf>
	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80008e:	c7 45 98 52 54 00 12 	movl   $0x12005452,-0x68(%ebp)
  800095:	66 c7 45 9c 34 56    	movw   $0x5634,-0x64(%ebp)
	uint32_t myip = inet_addr(IP);
  80009b:	c7 04 24 25 2f 80 00 	movl   $0x802f25,(%esp)
  8000a2:	e8 8d 06 00 00       	call   800734 <inet_addr>
  8000a7:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  8000aa:	c7 04 24 2f 2f 80 00 	movl   $0x802f2f,(%esp)
  8000b1:	e8 7e 06 00 00       	call   800734 <inet_addr>
  8000b6:	89 45 94             	mov    %eax,-0x6c(%ebp)
	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000b9:	83 c4 0c             	add    $0xc,%esp
  8000bc:	6a 07                	push   $0x7
  8000be:	68 00 b0 fe 0f       	push   $0xffeb000
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 42 12 00 00       	call   80130c <sys_page_alloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	0f 88 53 01 00 00    	js     800228 <umain+0x1f5>
	pkt->jp_len = sizeof(*arp);
  8000d5:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  8000dc:	00 00 00 
	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	6a 06                	push   $0x6
  8000e4:	68 ff 00 00 00       	push   $0xff
  8000e9:	68 04 b0 fe 0f       	push   $0xffeb004
  8000ee:	e8 41 0f 00 00       	call   801034 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  8000f3:	83 c4 0c             	add    $0xc,%esp
  8000f6:	6a 06                	push   $0x6
  8000f8:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  8000fb:	53                   	push   %ebx
  8000fc:	68 0a b0 fe 0f       	push   $0xffeb00a
  800101:	e8 e0 0f 00 00       	call   8010e6 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800106:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80010d:	e8 f9 03 00 00       	call   80050b <htons>
  800112:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  800118:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80011f:	e8 e7 03 00 00       	call   80050b <htons>
  800124:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  80012a:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  800131:	e8 d5 03 00 00       	call   80050b <htons>
  800136:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  80013c:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  800143:	e8 c3 03 00 00       	call   80050b <htons>
  800148:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  80014e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800155:	e8 b1 03 00 00       	call   80050b <htons>
  80015a:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  800160:	83 c4 0c             	add    $0xc,%esp
  800163:	6a 06                	push   $0x6
  800165:	53                   	push   %ebx
  800166:	68 1a b0 fe 0f       	push   $0xffeb01a
  80016b:	e8 76 0f 00 00       	call   8010e6 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800170:	83 c4 0c             	add    $0xc,%esp
  800173:	6a 04                	push   $0x4
  800175:	8d 45 90             	lea    -0x70(%ebp),%eax
  800178:	50                   	push   %eax
  800179:	68 20 b0 fe 0f       	push   $0xffeb020
  80017e:	e8 63 0f 00 00       	call   8010e6 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800183:	83 c4 0c             	add    $0xc,%esp
  800186:	6a 06                	push   $0x6
  800188:	6a 00                	push   $0x0
  80018a:	68 24 b0 fe 0f       	push   $0xffeb024
  80018f:	e8 a0 0e 00 00       	call   801034 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800194:	83 c4 0c             	add    $0xc,%esp
  800197:	6a 04                	push   $0x4
  800199:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	68 2a b0 fe 0f       	push   $0xffeb02a
  8001a2:	e8 3f 0f 00 00       	call   8010e6 <memcpy>
	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001a7:	6a 07                	push   $0x7
  8001a9:	68 00 b0 fe 0f       	push   $0xffeb000
  8001ae:	6a 0b                	push   $0xb
  8001b0:	ff 35 04 50 80 00    	pushl  0x805004
  8001b6:	e8 37 17 00 00       	call   8018f2 <ipc_send>
	sys_page_unmap(0, pkt);
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	68 00 b0 fe 0f       	push   $0xffeb000
  8001c3:	6a 00                	push   $0x0
  8001c5:	e8 cf 11 00 00       	call   801399 <sys_page_unmap>
}
  8001ca:	83 c4 10             	add    $0x10,%esp
	int i, r, first = 1;
  8001cd:	c7 85 78 ff ff ff 01 	movl   $0x1,-0x88(%ebp)
  8001d4:	00 00 00 
			out = buf + snprintf(buf, end - buf,
  8001d7:	89 df                	mov    %ebx,%edi
}
  8001d9:	e9 6a 01 00 00       	jmp    800348 <umain+0x315>
		panic("error forking");
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 ea 2e 80 00       	push   $0x802eea
  8001e6:	6a 4d                	push   $0x4d
  8001e8:	68 f8 2e 80 00       	push   $0x802ef8
  8001ed:	e8 e7 05 00 00       	call   8007d9 <_panic>
		output(ns_envid);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	53                   	push   %ebx
  8001f6:	e8 5d 02 00 00       	call   800458 <output>
		return;
  8001fb:	83 c4 10             	add    $0x10,%esp
		// we've received the ARP reply
		if (first)
			cprintf("Waiting for packets...\n");
		first = 0;
	}
}
  8001fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800201:	5b                   	pop    %ebx
  800202:	5e                   	pop    %esi
  800203:	5f                   	pop    %edi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    
		panic("error forking");
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 ea 2e 80 00       	push   $0x802eea
  80020e:	6a 55                	push   $0x55
  800210:	68 f8 2e 80 00       	push   $0x802ef8
  800215:	e8 bf 05 00 00       	call   8007d9 <_panic>
		input(ns_envid);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	53                   	push   %ebx
  80021e:	e8 26 02 00 00       	call   800449 <input>
		return;
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb d6                	jmp    8001fe <umain+0x1cb>
		panic("sys_page_map: %e", r);
  800228:	50                   	push   %eax
  800229:	68 38 2f 80 00       	push   $0x802f38
  80022e:	6a 19                	push   $0x19
  800230:	68 f8 2e 80 00       	push   $0x802ef8
  800235:	e8 9f 05 00 00       	call   8007d9 <_panic>
			panic("ipc_recv: %e", req);
  80023a:	50                   	push   %eax
  80023b:	68 49 2f 80 00       	push   $0x802f49
  800240:	6a 64                	push   $0x64
  800242:	68 f8 2e 80 00       	push   $0x802ef8
  800247:	e8 8d 05 00 00       	call   8007d9 <_panic>
			panic("IPC from unexpected environment %08x", whom);
  80024c:	52                   	push   %edx
  80024d:	68 a0 2f 80 00       	push   $0x802fa0
  800252:	6a 66                	push   $0x66
  800254:	68 f8 2e 80 00       	push   $0x802ef8
  800259:	e8 7b 05 00 00       	call   8007d9 <_panic>
			panic("Unexpected IPC %d", req);
  80025e:	50                   	push   %eax
  80025f:	68 56 2f 80 00       	push   $0x802f56
  800264:	6a 68                	push   $0x68
  800266:	68 f8 2e 80 00       	push   $0x802ef8
  80026b:	e8 69 05 00 00       	call   8007d9 <_panic>
			out = buf + snprintf(buf, end - buf,
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	56                   	push   %esi
  800274:	68 68 2f 80 00       	push   $0x802f68
  800279:	68 70 2f 80 00       	push   $0x802f70
  80027e:	6a 50                	push   $0x50
  800280:	57                   	push   %edi
  800281:	e8 e3 0b 00 00       	call   800e69 <snprintf>
  800286:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
  800289:	83 c4 20             	add    $0x20,%esp
  80028c:	eb 41                	jmp    8002cf <umain+0x29c>
			cprintf("%.*s\n", out - buf, buf);
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	57                   	push   %edi
  800292:	89 d8                	mov    %ebx,%eax
  800294:	29 f8                	sub    %edi,%eax
  800296:	50                   	push   %eax
  800297:	68 7f 2f 80 00       	push   $0x802f7f
  80029c:	e8 1f 06 00 00       	call   8008c0 <cprintf>
  8002a1:	83 c4 10             	add    $0x10,%esp
		if (i % 2 == 1)
  8002a4:	89 f2                	mov    %esi,%edx
  8002a6:	c1 ea 1f             	shr    $0x1f,%edx
  8002a9:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8002ac:	83 e0 01             	and    $0x1,%eax
  8002af:	29 d0                	sub    %edx,%eax
  8002b1:	83 f8 01             	cmp    $0x1,%eax
  8002b4:	74 5f                	je     800315 <umain+0x2e2>
		if (i % 16 == 7)
  8002b6:	83 7d 84 07          	cmpl   $0x7,-0x7c(%ebp)
  8002ba:	74 61                	je     80031d <umain+0x2ea>
	for (i = 0; i < len; i++) {
  8002bc:	83 c6 01             	add    $0x1,%esi
  8002bf:	39 75 80             	cmp    %esi,-0x80(%ebp)
  8002c2:	7e 61                	jle    800325 <umain+0x2f2>
  8002c4:	89 75 84             	mov    %esi,-0x7c(%ebp)
		if (i % 16 == 0)
  8002c7:	f7 c6 0f 00 00 00    	test   $0xf,%esi
  8002cd:	74 a1                	je     800270 <umain+0x23d>
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  8002cf:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002d2:	0f b6 80 04 b0 fe 0f 	movzbl 0xffeb004(%eax),%eax
  8002d9:	50                   	push   %eax
  8002da:	68 7a 2f 80 00       	push   $0x802f7a
  8002df:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002e2:	29 d8                	sub    %ebx,%eax
  8002e4:	50                   	push   %eax
  8002e5:	53                   	push   %ebx
  8002e6:	e8 7e 0b 00 00       	call   800e69 <snprintf>
  8002eb:	01 c3                	add    %eax,%ebx
		if (i % 16 == 15 || i == len - 1)
  8002ed:	89 f0                	mov    %esi,%eax
  8002ef:	c1 f8 1f             	sar    $0x1f,%eax
  8002f2:	c1 e8 1c             	shr    $0x1c,%eax
  8002f5:	8d 14 06             	lea    (%esi,%eax,1),%edx
  8002f8:	83 e2 0f             	and    $0xf,%edx
  8002fb:	29 c2                	sub    %eax,%edx
  8002fd:	89 55 84             	mov    %edx,-0x7c(%ebp)
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	83 fa 0f             	cmp    $0xf,%edx
  800306:	74 86                	je     80028e <umain+0x25b>
  800308:	3b b5 7c ff ff ff    	cmp    -0x84(%ebp),%esi
  80030e:	75 94                	jne    8002a4 <umain+0x271>
  800310:	e9 79 ff ff ff       	jmp    80028e <umain+0x25b>
			*(out++) = ' ';
  800315:	c6 03 20             	movb   $0x20,(%ebx)
  800318:	8d 5b 01             	lea    0x1(%ebx),%ebx
  80031b:	eb 99                	jmp    8002b6 <umain+0x283>
			*(out++) = ' ';
  80031d:	c6 03 20             	movb   $0x20,(%ebx)
  800320:	8d 5b 01             	lea    0x1(%ebx),%ebx
  800323:	eb 97                	jmp    8002bc <umain+0x289>
		cprintf("\n");
  800325:	83 ec 0c             	sub    $0xc,%esp
  800328:	68 9b 2f 80 00       	push   $0x802f9b
  80032d:	e8 8e 05 00 00       	call   8008c0 <cprintf>
		if (first)
  800332:	83 c4 10             	add    $0x10,%esp
  800335:	83 bd 78 ff ff ff 00 	cmpl   $0x0,-0x88(%ebp)
  80033c:	75 62                	jne    8003a0 <umain+0x36d>
		first = 0;
  80033e:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  800345:	00 00 00 
		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  800348:	83 ec 04             	sub    $0x4,%esp
  80034b:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80034e:	50                   	push   %eax
  80034f:	68 00 b0 fe 0f       	push   $0xffeb000
  800354:	8d 45 90             	lea    -0x70(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	e8 21 15 00 00       	call   80187e <ipc_recv>
		if (req < 0)
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	85 c0                	test   %eax,%eax
  800362:	0f 88 d2 fe ff ff    	js     80023a <umain+0x207>
		if (whom != input_envid)
  800368:	8b 55 90             	mov    -0x70(%ebp),%edx
  80036b:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  800371:	0f 85 d5 fe ff ff    	jne    80024c <umain+0x219>
		if (req != NSREQ_INPUT)
  800377:	83 f8 0a             	cmp    $0xa,%eax
  80037a:	0f 85 de fe ff ff    	jne    80025e <umain+0x22b>
		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800380:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800385:	89 45 80             	mov    %eax,-0x80(%ebp)
	char *out = NULL;
  800388:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < len; i++) {
  80038d:	be 00 00 00 00       	mov    $0x0,%esi
		if (i % 16 == 15 || i == len - 1)
  800392:	83 e8 01             	sub    $0x1,%eax
  800395:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	for (i = 0; i < len; i++) {
  80039b:	e9 1f ff ff ff       	jmp    8002bf <umain+0x28c>
			cprintf("Waiting for packets...\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 85 2f 80 00       	push   $0x802f85
  8003a8:	e8 13 05 00 00       	call   8008c0 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb 8c                	jmp    80033e <umain+0x30b>

008003b2 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  8003b2:	f3 0f 1e fb          	endbr32 
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	57                   	push   %edi
  8003ba:	56                   	push   %esi
  8003bb:	53                   	push   %ebx
  8003bc:	83 ec 1c             	sub    $0x1c,%esp
  8003bf:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  8003c2:	e8 56 11 00 00       	call   80151d <sys_time_msec>
  8003c7:	03 45 0c             	add    0xc(%ebp),%eax
  8003ca:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  8003cc:	c7 05 00 40 80 00 c5 	movl   $0x802fc5,0x804000
  8003d3:	2f 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003d6:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8003d9:	eb 33                	jmp    80040e <timer+0x5c>
		if (r < 0)
  8003db:	85 c0                	test   %eax,%eax
  8003dd:	78 45                	js     800424 <timer+0x72>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8003df:	6a 00                	push   $0x0
  8003e1:	6a 00                	push   $0x0
  8003e3:	6a 0c                	push   $0xc
  8003e5:	56                   	push   %esi
  8003e6:	e8 07 15 00 00       	call   8018f2 <ipc_send>
  8003eb:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	6a 00                	push   $0x0
  8003f3:	6a 00                	push   $0x0
  8003f5:	57                   	push   %edi
  8003f6:	e8 83 14 00 00       	call   80187e <ipc_recv>
  8003fb:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8003fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800400:	83 c4 10             	add    $0x10,%esp
  800403:	39 f0                	cmp    %esi,%eax
  800405:	75 2f                	jne    800436 <timer+0x84>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  800407:	e8 11 11 00 00       	call   80151d <sys_time_msec>
  80040c:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  80040e:	e8 0a 11 00 00       	call   80151d <sys_time_msec>
  800413:	89 c2                	mov    %eax,%edx
  800415:	85 c0                	test   %eax,%eax
  800417:	78 c2                	js     8003db <timer+0x29>
  800419:	39 d8                	cmp    %ebx,%eax
  80041b:	73 be                	jae    8003db <timer+0x29>
			sys_yield();
  80041d:	e8 c7 0e 00 00       	call   8012e9 <sys_yield>
  800422:	eb ea                	jmp    80040e <timer+0x5c>
			panic("sys_time_msec: %e", r);
  800424:	52                   	push   %edx
  800425:	68 ce 2f 80 00       	push   $0x802fce
  80042a:	6a 0f                	push   $0xf
  80042c:	68 e0 2f 80 00       	push   $0x802fe0
  800431:	e8 a3 03 00 00       	call   8007d9 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	50                   	push   %eax
  80043a:	68 ec 2f 80 00       	push   $0x802fec
  80043f:	e8 7c 04 00 00       	call   8008c0 <cprintf>
				continue;
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	eb a5                	jmp    8003ee <timer+0x3c>

00800449 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800449:	f3 0f 1e fb          	endbr32 
	binaryname = "ns_input";
  80044d:	c7 05 00 40 80 00 27 	movl   $0x803027,0x804000
  800454:	30 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  800457:	c3                   	ret    

00800458 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  800458:	f3 0f 1e fb          	endbr32 
	binaryname = "ns_output";
  80045c:	c7 05 00 40 80 00 30 	movl   $0x803030,0x804000
  800463:	30 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  800466:	c3                   	ret    

00800467 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800467:	f3 0f 1e fb          	endbr32 
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	57                   	push   %edi
  80046f:	56                   	push   %esi
  800470:	53                   	push   %ebx
  800471:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80047a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80047e:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800481:	bf 08 50 80 00       	mov    $0x805008,%edi
  800486:	eb 2e                	jmp    8004b6 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  800488:	0f b6 c8             	movzbl %al,%ecx
  80048b:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800490:	88 0a                	mov    %cl,(%edx)
  800492:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800495:	83 e8 01             	sub    $0x1,%eax
  800498:	3c ff                	cmp    $0xff,%al
  80049a:	75 ec                	jne    800488 <inet_ntoa+0x21>
  80049c:	0f b6 db             	movzbl %bl,%ebx
  80049f:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  8004a1:	8d 7b 01             	lea    0x1(%ebx),%edi
  8004a4:	c6 03 2e             	movb   $0x2e,(%ebx)
  8004a7:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  8004aa:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8004ae:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8004b2:	3c 04                	cmp    $0x4,%al
  8004b4:	74 45                	je     8004fb <inet_ntoa+0x94>
  rp = str;
  8004b6:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  8004bb:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  8004be:	0f b6 ca             	movzbl %dl,%ecx
  8004c1:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8004c4:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  8004c7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004ca:	66 c1 e8 0b          	shr    $0xb,%ax
  8004ce:	88 06                	mov    %al,(%esi)
  8004d0:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  8004d2:	83 c3 01             	add    $0x1,%ebx
  8004d5:	0f b6 c9             	movzbl %cl,%ecx
  8004d8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  8004db:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004de:	01 c0                	add    %eax,%eax
  8004e0:	89 d1                	mov    %edx,%ecx
  8004e2:	29 c1                	sub    %eax,%ecx
  8004e4:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  8004e6:	83 c0 30             	add    $0x30,%eax
  8004e9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ec:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  8004f0:	80 fa 09             	cmp    $0x9,%dl
  8004f3:	77 c6                	ja     8004bb <inet_ntoa+0x54>
  8004f5:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  8004f7:	89 d8                	mov    %ebx,%eax
  8004f9:	eb 9a                	jmp    800495 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  8004fb:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  8004fe:	b8 08 50 80 00       	mov    $0x805008,%eax
  800503:	83 c4 18             	add    $0x18,%esp
  800506:	5b                   	pop    %ebx
  800507:	5e                   	pop    %esi
  800508:	5f                   	pop    %edi
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80050b:	f3 0f 1e fb          	endbr32 
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800512:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800516:	66 c1 c0 08          	rol    $0x8,%ax
}
  80051a:	5d                   	pop    %ebp
  80051b:	c3                   	ret    

0080051c <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80051c:	f3 0f 1e fb          	endbr32 
  800520:	55                   	push   %ebp
  800521:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800523:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800527:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80052b:	5d                   	pop    %ebp
  80052c:	c3                   	ret    

0080052d <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80052d:	f3 0f 1e fb          	endbr32 
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800537:	89 d0                	mov    %edx,%eax
  800539:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80053c:	89 d1                	mov    %edx,%ecx
  80053e:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  800541:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800543:	89 d1                	mov    %edx,%ecx
  800545:	c1 e1 08             	shl    $0x8,%ecx
  800548:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80054e:	09 c8                	or     %ecx,%eax
  800550:	c1 ea 08             	shr    $0x8,%edx
  800553:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  800559:	09 d0                	or     %edx,%eax
}
  80055b:	5d                   	pop    %ebp
  80055c:	c3                   	ret    

0080055d <inet_aton>:
{
  80055d:	f3 0f 1e fb          	endbr32 
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	57                   	push   %edi
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 2c             	sub    $0x2c,%esp
  80056a:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  80056d:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  800570:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800573:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800576:	e9 a7 00 00 00       	jmp    800622 <inet_aton+0xc5>
      c = *++cp;
  80057b:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  80057f:	89 c1                	mov    %eax,%ecx
  800581:	83 e1 df             	and    $0xffffffdf,%ecx
  800584:	80 f9 58             	cmp    $0x58,%cl
  800587:	74 10                	je     800599 <inet_aton+0x3c>
      c = *++cp;
  800589:	83 c2 01             	add    $0x1,%edx
  80058c:	0f be c0             	movsbl %al,%eax
        base = 8;
  80058f:	be 08 00 00 00       	mov    $0x8,%esi
  800594:	e9 a3 00 00 00       	jmp    80063c <inet_aton+0xdf>
        c = *++cp;
  800599:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80059d:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  8005a0:	be 10 00 00 00       	mov    $0x10,%esi
  8005a5:	e9 92 00 00 00       	jmp    80063c <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8005aa:	83 fe 10             	cmp    $0x10,%esi
  8005ad:	75 4d                	jne    8005fc <inet_aton+0x9f>
  8005af:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  8005b2:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  8005b5:	89 c1                	mov    %eax,%ecx
  8005b7:	83 e1 df             	and    $0xffffffdf,%ecx
  8005ba:	83 e9 41             	sub    $0x41,%ecx
  8005bd:	80 f9 05             	cmp    $0x5,%cl
  8005c0:	77 3a                	ja     8005fc <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8005c2:	c1 e3 04             	shl    $0x4,%ebx
  8005c5:	83 c0 0a             	add    $0xa,%eax
  8005c8:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8005cc:	19 c9                	sbb    %ecx,%ecx
  8005ce:	83 e1 20             	and    $0x20,%ecx
  8005d1:	83 c1 41             	add    $0x41,%ecx
  8005d4:	29 c8                	sub    %ecx,%eax
  8005d6:	09 c3                	or     %eax,%ebx
        c = *++cp;
  8005d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005db:	0f be 40 01          	movsbl 0x1(%eax),%eax
  8005df:	83 c2 01             	add    $0x1,%edx
  8005e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  8005e5:	89 c7                	mov    %eax,%edi
  8005e7:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8005ea:	80 f9 09             	cmp    $0x9,%cl
  8005ed:	77 bb                	ja     8005aa <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  8005ef:	0f af de             	imul   %esi,%ebx
  8005f2:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  8005f6:	0f be 42 01          	movsbl 0x1(%edx),%eax
  8005fa:	eb e3                	jmp    8005df <inet_aton+0x82>
    if (c == '.') {
  8005fc:	83 f8 2e             	cmp    $0x2e,%eax
  8005ff:	75 42                	jne    800643 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800601:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800604:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800607:	39 c6                	cmp    %eax,%esi
  800609:	0f 84 16 01 00 00    	je     800725 <inet_aton+0x1c8>
      *pp++ = val;
  80060f:	83 c6 04             	add    $0x4,%esi
  800612:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800615:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800618:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061b:	8d 50 01             	lea    0x1(%eax),%edx
  80061e:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  800622:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800625:	80 f9 09             	cmp    $0x9,%cl
  800628:	0f 87 f0 00 00 00    	ja     80071e <inet_aton+0x1c1>
    base = 10;
  80062e:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800633:	83 f8 30             	cmp    $0x30,%eax
  800636:	0f 84 3f ff ff ff    	je     80057b <inet_aton+0x1e>
    base = 10;
  80063c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800641:	eb 9f                	jmp    8005e2 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800643:	85 c0                	test   %eax,%eax
  800645:	74 29                	je     800670 <inet_aton+0x113>
    return (0);
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80064c:	89 f9                	mov    %edi,%ecx
  80064e:	80 f9 1f             	cmp    $0x1f,%cl
  800651:	0f 86 d3 00 00 00    	jbe    80072a <inet_aton+0x1cd>
  800657:	84 c0                	test   %al,%al
  800659:	0f 88 cb 00 00 00    	js     80072a <inet_aton+0x1cd>
  80065f:	83 f8 20             	cmp    $0x20,%eax
  800662:	74 0c                	je     800670 <inet_aton+0x113>
  800664:	83 e8 09             	sub    $0x9,%eax
  800667:	83 f8 04             	cmp    $0x4,%eax
  80066a:	0f 87 ba 00 00 00    	ja     80072a <inet_aton+0x1cd>
  n = pp - parts + 1;
  800670:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800673:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800676:	29 c6                	sub    %eax,%esi
  800678:	89 f0                	mov    %esi,%eax
  80067a:	c1 f8 02             	sar    $0x2,%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  800680:	83 f8 02             	cmp    $0x2,%eax
  800683:	74 7a                	je     8006ff <inet_aton+0x1a2>
  800685:	83 fa 03             	cmp    $0x3,%edx
  800688:	7f 49                	jg     8006d3 <inet_aton+0x176>
  80068a:	85 d2                	test   %edx,%edx
  80068c:	0f 84 98 00 00 00    	je     80072a <inet_aton+0x1cd>
  800692:	83 fa 02             	cmp    $0x2,%edx
  800695:	75 19                	jne    8006b0 <inet_aton+0x153>
      return (0);
  800697:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80069c:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8006a2:	0f 87 82 00 00 00    	ja     80072a <inet_aton+0x1cd>
    val |= parts[0] << 24;
  8006a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006ab:	c1 e0 18             	shl    $0x18,%eax
  8006ae:	09 c3                	or     %eax,%ebx
  return (1);
  8006b0:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  8006b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b9:	74 6f                	je     80072a <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	53                   	push   %ebx
  8006bf:	e8 69 fe ff ff       	call   80052d <htonl>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8006cc:	ba 01 00 00 00       	mov    $0x1,%edx
  8006d1:	eb 57                	jmp    80072a <inet_aton+0x1cd>
  switch (n) {
  8006d3:	83 fa 04             	cmp    $0x4,%edx
  8006d6:	75 d8                	jne    8006b0 <inet_aton+0x153>
      return (0);
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  8006dd:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  8006e3:	77 45                	ja     80072a <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	c1 e0 18             	shl    $0x18,%eax
  8006eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006ee:	c1 e2 10             	shl    $0x10,%edx
  8006f1:	09 d0                	or     %edx,%eax
  8006f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f6:	c1 e2 08             	shl    $0x8,%edx
  8006f9:	09 d0                	or     %edx,%eax
  8006fb:	09 c3                	or     %eax,%ebx
    break;
  8006fd:	eb b1                	jmp    8006b0 <inet_aton+0x153>
      return (0);
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800704:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80070a:	77 1e                	ja     80072a <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80070c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80070f:	c1 e0 18             	shl    $0x18,%eax
  800712:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800715:	c1 e2 10             	shl    $0x10,%edx
  800718:	09 d0                	or     %edx,%eax
  80071a:	09 c3                	or     %eax,%ebx
    break;
  80071c:	eb 92                	jmp    8006b0 <inet_aton+0x153>
      return (0);
  80071e:	ba 00 00 00 00       	mov    $0x0,%edx
  800723:	eb 05                	jmp    80072a <inet_aton+0x1cd>
        return (0);
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80072f:	5b                   	pop    %ebx
  800730:	5e                   	pop    %esi
  800731:	5f                   	pop    %edi
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <inet_addr>:
{
  800734:	f3 0f 1e fb          	endbr32 
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80073e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800741:	50                   	push   %eax
  800742:	ff 75 08             	pushl  0x8(%ebp)
  800745:	e8 13 fe ff ff       	call   80055d <inet_aton>
  80074a:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  80074d:	85 c0                	test   %eax,%eax
  80074f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800754:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80075a:	f3 0f 1e fb          	endbr32 
  80075e:	55                   	push   %ebp
  80075f:	89 e5                	mov    %esp,%ebp
  800761:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 c1 fd ff ff       	call   80052d <htonl>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	56                   	push   %esi
  800779:	53                   	push   %ebx
  80077a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80077d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800780:	e8 41 0b 00 00       	call   8012c6 <sys_getenvid>
  800785:	25 ff 03 00 00       	and    $0x3ff,%eax
  80078a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80078d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800792:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800797:	85 db                	test   %ebx,%ebx
  800799:	7e 07                	jle    8007a2 <libmain+0x31>
		binaryname = argv[0];
  80079b:	8b 06                	mov    (%esi),%eax
  80079d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	56                   	push   %esi
  8007a6:	53                   	push   %ebx
  8007a7:	e8 87 f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8007ac:	e8 0a 00 00 00       	call   8007bb <exit>
}
  8007b1:	83 c4 10             	add    $0x10,%esp
  8007b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8007b7:	5b                   	pop    %ebx
  8007b8:	5e                   	pop    %esi
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8007c5:	e8 b1 13 00 00       	call   801b7b <close_all>
	sys_env_destroy(0);
  8007ca:	83 ec 0c             	sub    $0xc,%esp
  8007cd:	6a 00                	push   $0x0
  8007cf:	e8 ad 0a 00 00       	call   801281 <sys_env_destroy>
}
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	c9                   	leave  
  8007d8:	c3                   	ret    

008007d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007d9:	f3 0f 1e fb          	endbr32 
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
  8007e0:	56                   	push   %esi
  8007e1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8007e2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007e5:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8007eb:	e8 d6 0a 00 00       	call   8012c6 <sys_getenvid>
  8007f0:	83 ec 0c             	sub    $0xc,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	56                   	push   %esi
  8007fa:	50                   	push   %eax
  8007fb:	68 44 30 80 00       	push   $0x803044
  800800:	e8 bb 00 00 00       	call   8008c0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800805:	83 c4 18             	add    $0x18,%esp
  800808:	53                   	push   %ebx
  800809:	ff 75 10             	pushl  0x10(%ebp)
  80080c:	e8 5a 00 00 00       	call   80086b <vcprintf>
	cprintf("\n");
  800811:	c7 04 24 9b 2f 80 00 	movl   $0x802f9b,(%esp)
  800818:	e8 a3 00 00 00       	call   8008c0 <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800820:	cc                   	int3   
  800821:	eb fd                	jmp    800820 <_panic+0x47>

00800823 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800823:	f3 0f 1e fb          	endbr32 
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800831:	8b 13                	mov    (%ebx),%edx
  800833:	8d 42 01             	lea    0x1(%edx),%eax
  800836:	89 03                	mov    %eax,(%ebx)
  800838:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80083f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800844:	74 09                	je     80084f <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800846:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80084a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	68 ff 00 00 00       	push   $0xff
  800857:	8d 43 08             	lea    0x8(%ebx),%eax
  80085a:	50                   	push   %eax
  80085b:	e8 dc 09 00 00       	call   80123c <sys_cputs>
		b->idx = 0;
  800860:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	eb db                	jmp    800846 <putch+0x23>

0080086b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800878:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80087f:	00 00 00 
	b.cnt = 0;
  800882:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800889:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	ff 75 08             	pushl  0x8(%ebp)
  800892:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800898:	50                   	push   %eax
  800899:	68 23 08 80 00       	push   $0x800823
  80089e:	e8 20 01 00 00       	call   8009c3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008a3:	83 c4 08             	add    $0x8,%esp
  8008a6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8008ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008b2:	50                   	push   %eax
  8008b3:	e8 84 09 00 00       	call   80123c <sys_cputs>

	return b.cnt;
}
  8008b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008c0:	f3 0f 1e fb          	endbr32 
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008ca:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008cd:	50                   	push   %eax
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 95 ff ff ff       	call   80086b <vcprintf>
	va_end(ap);

	return cnt;
}
  8008d6:	c9                   	leave  
  8008d7:	c3                   	ret    

008008d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	57                   	push   %edi
  8008dc:	56                   	push   %esi
  8008dd:	53                   	push   %ebx
  8008de:	83 ec 1c             	sub    $0x1c,%esp
  8008e1:	89 c7                	mov    %eax,%edi
  8008e3:	89 d6                	mov    %edx,%esi
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008eb:	89 d1                	mov    %edx,%ecx
  8008ed:	89 c2                	mov    %eax,%edx
  8008ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800905:	39 c2                	cmp    %eax,%edx
  800907:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80090a:	72 3e                	jb     80094a <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80090c:	83 ec 0c             	sub    $0xc,%esp
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	83 eb 01             	sub    $0x1,%ebx
  800915:	53                   	push   %ebx
  800916:	50                   	push   %eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80091d:	ff 75 e0             	pushl  -0x20(%ebp)
  800920:	ff 75 dc             	pushl  -0x24(%ebp)
  800923:	ff 75 d8             	pushl  -0x28(%ebp)
  800926:	e8 45 23 00 00       	call   802c70 <__udivdi3>
  80092b:	83 c4 18             	add    $0x18,%esp
  80092e:	52                   	push   %edx
  80092f:	50                   	push   %eax
  800930:	89 f2                	mov    %esi,%edx
  800932:	89 f8                	mov    %edi,%eax
  800934:	e8 9f ff ff ff       	call   8008d8 <printnum>
  800939:	83 c4 20             	add    $0x20,%esp
  80093c:	eb 13                	jmp    800951 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	56                   	push   %esi
  800942:	ff 75 18             	pushl  0x18(%ebp)
  800945:	ff d7                	call   *%edi
  800947:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80094a:	83 eb 01             	sub    $0x1,%ebx
  80094d:	85 db                	test   %ebx,%ebx
  80094f:	7f ed                	jg     80093e <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	56                   	push   %esi
  800955:	83 ec 04             	sub    $0x4,%esp
  800958:	ff 75 e4             	pushl  -0x1c(%ebp)
  80095b:	ff 75 e0             	pushl  -0x20(%ebp)
  80095e:	ff 75 dc             	pushl  -0x24(%ebp)
  800961:	ff 75 d8             	pushl  -0x28(%ebp)
  800964:	e8 17 24 00 00       	call   802d80 <__umoddi3>
  800969:	83 c4 14             	add    $0x14,%esp
  80096c:	0f be 80 67 30 80 00 	movsbl 0x803067(%eax),%eax
  800973:	50                   	push   %eax
  800974:	ff d7                	call   *%edi
}
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80097c:	5b                   	pop    %ebx
  80097d:	5e                   	pop    %esi
  80097e:	5f                   	pop    %edi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800981:	f3 0f 1e fb          	endbr32 
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80098b:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80098f:	8b 10                	mov    (%eax),%edx
  800991:	3b 50 04             	cmp    0x4(%eax),%edx
  800994:	73 0a                	jae    8009a0 <sprintputch+0x1f>
		*b->buf++ = ch;
  800996:	8d 4a 01             	lea    0x1(%edx),%ecx
  800999:	89 08                	mov    %ecx,(%eax)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	88 02                	mov    %al,(%edx)
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <printfmt>:
{
  8009a2:	f3 0f 1e fb          	endbr32 
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8009af:	50                   	push   %eax
  8009b0:	ff 75 10             	pushl  0x10(%ebp)
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	ff 75 08             	pushl  0x8(%ebp)
  8009b9:	e8 05 00 00 00       	call   8009c3 <vprintfmt>
}
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <vprintfmt>:
{
  8009c3:	f3 0f 1e fb          	endbr32 
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	83 ec 3c             	sub    $0x3c,%esp
  8009d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8009d9:	e9 8e 03 00 00       	jmp    800d6c <vprintfmt+0x3a9>
		padc = ' ';
  8009de:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8009e2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8009e9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8009f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009f7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009fc:	8d 47 01             	lea    0x1(%edi),%eax
  8009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a02:	0f b6 17             	movzbl (%edi),%edx
  800a05:	8d 42 dd             	lea    -0x23(%edx),%eax
  800a08:	3c 55                	cmp    $0x55,%al
  800a0a:	0f 87 df 03 00 00    	ja     800def <vprintfmt+0x42c>
  800a10:	0f b6 c0             	movzbl %al,%eax
  800a13:	3e ff 24 85 a0 31 80 	notrack jmp *0x8031a0(,%eax,4)
  800a1a:	00 
  800a1b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800a1e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800a22:	eb d8                	jmp    8009fc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800a24:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a27:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800a2b:	eb cf                	jmp    8009fc <vprintfmt+0x39>
  800a2d:	0f b6 d2             	movzbl %dl,%edx
  800a30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800a33:	b8 00 00 00 00       	mov    $0x0,%eax
  800a38:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800a3b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800a3e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800a42:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a45:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800a48:	83 f9 09             	cmp    $0x9,%ecx
  800a4b:	77 55                	ja     800aa2 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800a4d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800a50:	eb e9                	jmp    800a3b <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	8d 40 04             	lea    0x4(%eax),%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a63:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a6a:	79 90                	jns    8009fc <vprintfmt+0x39>
				width = precision, precision = -1;
  800a6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a72:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800a79:	eb 81                	jmp    8009fc <vprintfmt+0x39>
  800a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	0f 49 d0             	cmovns %eax,%edx
  800a88:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a8b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a8e:	e9 69 ff ff ff       	jmp    8009fc <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800a93:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a96:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800a9d:	e9 5a ff ff ff       	jmp    8009fc <vprintfmt+0x39>
  800aa2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800aa5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa8:	eb bc                	jmp    800a66 <vprintfmt+0xa3>
			lflag++;
  800aaa:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800aad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800ab0:	e9 47 ff ff ff       	jmp    8009fc <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800ab5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab8:	8d 78 04             	lea    0x4(%eax),%edi
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	53                   	push   %ebx
  800abf:	ff 30                	pushl  (%eax)
  800ac1:	ff d6                	call   *%esi
			break;
  800ac3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800ac6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800ac9:	e9 9b 02 00 00       	jmp    800d69 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	8d 78 04             	lea    0x4(%eax),%edi
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	99                   	cltd   
  800ad7:	31 d0                	xor    %edx,%eax
  800ad9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800adb:	83 f8 0f             	cmp    $0xf,%eax
  800ade:	7f 23                	jg     800b03 <vprintfmt+0x140>
  800ae0:	8b 14 85 00 33 80 00 	mov    0x803300(,%eax,4),%edx
  800ae7:	85 d2                	test   %edx,%edx
  800ae9:	74 18                	je     800b03 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800aeb:	52                   	push   %edx
  800aec:	68 71 35 80 00       	push   $0x803571
  800af1:	53                   	push   %ebx
  800af2:	56                   	push   %esi
  800af3:	e8 aa fe ff ff       	call   8009a2 <printfmt>
  800af8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800afb:	89 7d 14             	mov    %edi,0x14(%ebp)
  800afe:	e9 66 02 00 00       	jmp    800d69 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800b03:	50                   	push   %eax
  800b04:	68 7f 30 80 00       	push   $0x80307f
  800b09:	53                   	push   %ebx
  800b0a:	56                   	push   %esi
  800b0b:	e8 92 fe ff ff       	call   8009a2 <printfmt>
  800b10:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b13:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800b16:	e9 4e 02 00 00       	jmp    800d69 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1e:	83 c0 04             	add    $0x4,%eax
  800b21:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b24:	8b 45 14             	mov    0x14(%ebp),%eax
  800b27:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800b29:	85 d2                	test   %edx,%edx
  800b2b:	b8 78 30 80 00       	mov    $0x803078,%eax
  800b30:	0f 45 c2             	cmovne %edx,%eax
  800b33:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800b36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b3a:	7e 06                	jle    800b42 <vprintfmt+0x17f>
  800b3c:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800b40:	75 0d                	jne    800b4f <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b45:	89 c7                	mov    %eax,%edi
  800b47:	03 45 e0             	add    -0x20(%ebp),%eax
  800b4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b4d:	eb 55                	jmp    800ba4 <vprintfmt+0x1e1>
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 d8             	pushl  -0x28(%ebp)
  800b55:	ff 75 cc             	pushl  -0x34(%ebp)
  800b58:	e8 46 03 00 00       	call   800ea3 <strnlen>
  800b5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b60:	29 c2                	sub    %eax,%edx
  800b62:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800b6a:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800b6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800b71:	85 ff                	test   %edi,%edi
  800b73:	7e 11                	jle    800b86 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	53                   	push   %ebx
  800b79:	ff 75 e0             	pushl  -0x20(%ebp)
  800b7c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7e:	83 ef 01             	sub    $0x1,%edi
  800b81:	83 c4 10             	add    $0x10,%esp
  800b84:	eb eb                	jmp    800b71 <vprintfmt+0x1ae>
  800b86:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b89:	85 d2                	test   %edx,%edx
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b90:	0f 49 c2             	cmovns %edx,%eax
  800b93:	29 c2                	sub    %eax,%edx
  800b95:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800b98:	eb a8                	jmp    800b42 <vprintfmt+0x17f>
					putch(ch, putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	53                   	push   %ebx
  800b9e:	52                   	push   %edx
  800b9f:	ff d6                	call   *%esi
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800ba7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba9:	83 c7 01             	add    $0x1,%edi
  800bac:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bb0:	0f be d0             	movsbl %al,%edx
  800bb3:	85 d2                	test   %edx,%edx
  800bb5:	74 4b                	je     800c02 <vprintfmt+0x23f>
  800bb7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800bbb:	78 06                	js     800bc3 <vprintfmt+0x200>
  800bbd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800bc1:	78 1e                	js     800be1 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bc7:	74 d1                	je     800b9a <vprintfmt+0x1d7>
  800bc9:	0f be c0             	movsbl %al,%eax
  800bcc:	83 e8 20             	sub    $0x20,%eax
  800bcf:	83 f8 5e             	cmp    $0x5e,%eax
  800bd2:	76 c6                	jbe    800b9a <vprintfmt+0x1d7>
					putch('?', putdat);
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	53                   	push   %ebx
  800bd8:	6a 3f                	push   $0x3f
  800bda:	ff d6                	call   *%esi
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	eb c3                	jmp    800ba4 <vprintfmt+0x1e1>
  800be1:	89 cf                	mov    %ecx,%edi
  800be3:	eb 0e                	jmp    800bf3 <vprintfmt+0x230>
				putch(' ', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	53                   	push   %ebx
  800be9:	6a 20                	push   $0x20
  800beb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bed:	83 ef 01             	sub    $0x1,%edi
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	85 ff                	test   %edi,%edi
  800bf5:	7f ee                	jg     800be5 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800bf7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bfa:	89 45 14             	mov    %eax,0x14(%ebp)
  800bfd:	e9 67 01 00 00       	jmp    800d69 <vprintfmt+0x3a6>
  800c02:	89 cf                	mov    %ecx,%edi
  800c04:	eb ed                	jmp    800bf3 <vprintfmt+0x230>
	if (lflag >= 2)
  800c06:	83 f9 01             	cmp    $0x1,%ecx
  800c09:	7f 1b                	jg     800c26 <vprintfmt+0x263>
	else if (lflag)
  800c0b:	85 c9                	test   %ecx,%ecx
  800c0d:	74 63                	je     800c72 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c17:	99                   	cltd   
  800c18:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	8d 40 04             	lea    0x4(%eax),%eax
  800c21:	89 45 14             	mov    %eax,0x14(%ebp)
  800c24:	eb 17                	jmp    800c3d <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800c26:	8b 45 14             	mov    0x14(%ebp),%eax
  800c29:	8b 50 04             	mov    0x4(%eax),%edx
  800c2c:	8b 00                	mov    (%eax),%eax
  800c2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c31:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c34:	8b 45 14             	mov    0x14(%ebp),%eax
  800c37:	8d 40 08             	lea    0x8(%eax),%eax
  800c3a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800c3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c40:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800c43:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800c48:	85 c9                	test   %ecx,%ecx
  800c4a:	0f 89 ff 00 00 00    	jns    800d4f <vprintfmt+0x38c>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	53                   	push   %ebx
  800c54:	6a 2d                	push   $0x2d
  800c56:	ff d6                	call   *%esi
				num = -(long long) num;
  800c58:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c5b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c5e:	f7 da                	neg    %edx
  800c60:	83 d1 00             	adc    $0x0,%ecx
  800c63:	f7 d9                	neg    %ecx
  800c65:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c68:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6d:	e9 dd 00 00 00       	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c7a:	99                   	cltd   
  800c7b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c81:	8d 40 04             	lea    0x4(%eax),%eax
  800c84:	89 45 14             	mov    %eax,0x14(%ebp)
  800c87:	eb b4                	jmp    800c3d <vprintfmt+0x27a>
	if (lflag >= 2)
  800c89:	83 f9 01             	cmp    $0x1,%ecx
  800c8c:	7f 1e                	jg     800cac <vprintfmt+0x2e9>
	else if (lflag)
  800c8e:	85 c9                	test   %ecx,%ecx
  800c90:	74 32                	je     800cc4 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	8b 10                	mov    (%eax),%edx
  800c97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c9c:	8d 40 04             	lea    0x4(%eax),%eax
  800c9f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800ca2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800ca7:	e9 a3 00 00 00       	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800cac:	8b 45 14             	mov    0x14(%ebp),%eax
  800caf:	8b 10                	mov    (%eax),%edx
  800cb1:	8b 48 04             	mov    0x4(%eax),%ecx
  800cb4:	8d 40 08             	lea    0x8(%eax),%eax
  800cb7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800cbf:	e9 8b 00 00 00       	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	8b 10                	mov    (%eax),%edx
  800cc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cce:	8d 40 04             	lea    0x4(%eax),%eax
  800cd1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800cd4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800cd9:	eb 74                	jmp    800d4f <vprintfmt+0x38c>
	if (lflag >= 2)
  800cdb:	83 f9 01             	cmp    $0x1,%ecx
  800cde:	7f 1b                	jg     800cfb <vprintfmt+0x338>
	else if (lflag)
  800ce0:	85 c9                	test   %ecx,%ecx
  800ce2:	74 2c                	je     800d10 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	8b 10                	mov    (%eax),%edx
  800ce9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cee:	8d 40 04             	lea    0x4(%eax),%eax
  800cf1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cf4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800cf9:	eb 54                	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	8b 10                	mov    (%eax),%edx
  800d00:	8b 48 04             	mov    0x4(%eax),%ecx
  800d03:	8d 40 08             	lea    0x8(%eax),%eax
  800d06:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d09:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800d0e:	eb 3f                	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800d10:	8b 45 14             	mov    0x14(%ebp),%eax
  800d13:	8b 10                	mov    (%eax),%edx
  800d15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1a:	8d 40 04             	lea    0x4(%eax),%eax
  800d1d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d20:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800d25:	eb 28                	jmp    800d4f <vprintfmt+0x38c>
			putch('0', putdat);
  800d27:	83 ec 08             	sub    $0x8,%esp
  800d2a:	53                   	push   %ebx
  800d2b:	6a 30                	push   $0x30
  800d2d:	ff d6                	call   *%esi
			putch('x', putdat);
  800d2f:	83 c4 08             	add    $0x8,%esp
  800d32:	53                   	push   %ebx
  800d33:	6a 78                	push   $0x78
  800d35:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800d41:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d44:	8d 40 04             	lea    0x4(%eax),%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d4a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800d56:	57                   	push   %edi
  800d57:	ff 75 e0             	pushl  -0x20(%ebp)
  800d5a:	50                   	push   %eax
  800d5b:	51                   	push   %ecx
  800d5c:	52                   	push   %edx
  800d5d:	89 da                	mov    %ebx,%edx
  800d5f:	89 f0                	mov    %esi,%eax
  800d61:	e8 72 fb ff ff       	call   8008d8 <printnum>
			break;
  800d66:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800d69:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6c:	83 c7 01             	add    $0x1,%edi
  800d6f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d73:	83 f8 25             	cmp    $0x25,%eax
  800d76:	0f 84 62 fc ff ff    	je     8009de <vprintfmt+0x1b>
			if (ch == '\0')
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	0f 84 8b 00 00 00    	je     800e0f <vprintfmt+0x44c>
			putch(ch, putdat);
  800d84:	83 ec 08             	sub    $0x8,%esp
  800d87:	53                   	push   %ebx
  800d88:	50                   	push   %eax
  800d89:	ff d6                	call   *%esi
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	eb dc                	jmp    800d6c <vprintfmt+0x3a9>
	if (lflag >= 2)
  800d90:	83 f9 01             	cmp    $0x1,%ecx
  800d93:	7f 1b                	jg     800db0 <vprintfmt+0x3ed>
	else if (lflag)
  800d95:	85 c9                	test   %ecx,%ecx
  800d97:	74 2c                	je     800dc5 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800d99:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9c:	8b 10                	mov    (%eax),%edx
  800d9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da3:	8d 40 04             	lea    0x4(%eax),%eax
  800da6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800da9:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800dae:	eb 9f                	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800db0:	8b 45 14             	mov    0x14(%ebp),%eax
  800db3:	8b 10                	mov    (%eax),%edx
  800db5:	8b 48 04             	mov    0x4(%eax),%ecx
  800db8:	8d 40 08             	lea    0x8(%eax),%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dbe:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800dc3:	eb 8a                	jmp    800d4f <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc8:	8b 10                	mov    (%eax),%edx
  800dca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcf:	8d 40 04             	lea    0x4(%eax),%eax
  800dd2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dd5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800dda:	e9 70 ff ff ff       	jmp    800d4f <vprintfmt+0x38c>
			putch(ch, putdat);
  800ddf:	83 ec 08             	sub    $0x8,%esp
  800de2:	53                   	push   %ebx
  800de3:	6a 25                	push   $0x25
  800de5:	ff d6                	call   *%esi
			break;
  800de7:	83 c4 10             	add    $0x10,%esp
  800dea:	e9 7a ff ff ff       	jmp    800d69 <vprintfmt+0x3a6>
			putch('%', putdat);
  800def:	83 ec 08             	sub    $0x8,%esp
  800df2:	53                   	push   %ebx
  800df3:	6a 25                	push   $0x25
  800df5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 f8                	mov    %edi,%eax
  800dfc:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e00:	74 05                	je     800e07 <vprintfmt+0x444>
  800e02:	83 e8 01             	sub    $0x1,%eax
  800e05:	eb f5                	jmp    800dfc <vprintfmt+0x439>
  800e07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e0a:	e9 5a ff ff ff       	jmp    800d69 <vprintfmt+0x3a6>
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e17:	f3 0f 1e fb          	endbr32 
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 18             	sub    $0x18,%esp
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e2a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e2e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	74 26                	je     800e62 <vsnprintf+0x4b>
  800e3c:	85 d2                	test   %edx,%edx
  800e3e:	7e 22                	jle    800e62 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e40:	ff 75 14             	pushl  0x14(%ebp)
  800e43:	ff 75 10             	pushl  0x10(%ebp)
  800e46:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e49:	50                   	push   %eax
  800e4a:	68 81 09 80 00       	push   $0x800981
  800e4f:	e8 6f fb ff ff       	call   8009c3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e57:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    
		return -E_INVAL;
  800e62:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e67:	eb f7                	jmp    800e60 <vsnprintf+0x49>

00800e69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e73:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e76:	50                   	push   %eax
  800e77:	ff 75 10             	pushl  0x10(%ebp)
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	ff 75 08             	pushl  0x8(%ebp)
  800e80:	e8 92 ff ff ff       	call   800e17 <vsnprintf>
	va_end(ap);

	return rc;
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e87:	f3 0f 1e fb          	endbr32 
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e91:	b8 00 00 00 00       	mov    $0x0,%eax
  800e96:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e9a:	74 05                	je     800ea1 <strlen+0x1a>
		n++;
  800e9c:	83 c0 01             	add    $0x1,%eax
  800e9f:	eb f5                	jmp    800e96 <strlen+0xf>
	return n;
}
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ea3:	f3 0f 1e fb          	endbr32 
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb5:	39 d0                	cmp    %edx,%eax
  800eb7:	74 0d                	je     800ec6 <strnlen+0x23>
  800eb9:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ebd:	74 05                	je     800ec4 <strnlen+0x21>
		n++;
  800ebf:	83 c0 01             	add    $0x1,%eax
  800ec2:	eb f1                	jmp    800eb5 <strnlen+0x12>
  800ec4:	89 c2                	mov    %eax,%edx
	return n;
}
  800ec6:	89 d0                	mov    %edx,%eax
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eca:	f3 0f 1e fb          	endbr32 
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	53                   	push   %ebx
  800ed2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ed8:	b8 00 00 00 00       	mov    $0x0,%eax
  800edd:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800ee1:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800ee4:	83 c0 01             	add    $0x1,%eax
  800ee7:	84 d2                	test   %dl,%dl
  800ee9:	75 f2                	jne    800edd <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800eeb:	89 c8                	mov    %ecx,%eax
  800eed:	5b                   	pop    %ebx
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ef0:	f3 0f 1e fb          	endbr32 
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	53                   	push   %ebx
  800ef8:	83 ec 10             	sub    $0x10,%esp
  800efb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800efe:	53                   	push   %ebx
  800eff:	e8 83 ff ff ff       	call   800e87 <strlen>
  800f04:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	01 d8                	add    %ebx,%eax
  800f0c:	50                   	push   %eax
  800f0d:	e8 b8 ff ff ff       	call   800eca <strcpy>
	return dst;
}
  800f12:	89 d8                	mov    %ebx,%eax
  800f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f19:	f3 0f 1e fb          	endbr32 
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	8b 75 08             	mov    0x8(%ebp),%esi
  800f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f28:	89 f3                	mov    %esi,%ebx
  800f2a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2d:	89 f0                	mov    %esi,%eax
  800f2f:	39 d8                	cmp    %ebx,%eax
  800f31:	74 11                	je     800f44 <strncpy+0x2b>
		*dst++ = *src;
  800f33:	83 c0 01             	add    $0x1,%eax
  800f36:	0f b6 0a             	movzbl (%edx),%ecx
  800f39:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f3c:	80 f9 01             	cmp    $0x1,%cl
  800f3f:	83 da ff             	sbb    $0xffffffff,%edx
  800f42:	eb eb                	jmp    800f2f <strncpy+0x16>
	}
	return ret;
}
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f4a:	f3 0f 1e fb          	endbr32 
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	56                   	push   %esi
  800f52:	53                   	push   %ebx
  800f53:	8b 75 08             	mov    0x8(%ebp),%esi
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 10             	mov    0x10(%ebp),%edx
  800f5c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f5e:	85 d2                	test   %edx,%edx
  800f60:	74 21                	je     800f83 <strlcpy+0x39>
  800f62:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800f66:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 14                	je     800f80 <strlcpy+0x36>
  800f6c:	0f b6 19             	movzbl (%ecx),%ebx
  800f6f:	84 db                	test   %bl,%bl
  800f71:	74 0b                	je     800f7e <strlcpy+0x34>
			*dst++ = *src++;
  800f73:	83 c1 01             	add    $0x1,%ecx
  800f76:	83 c2 01             	add    $0x1,%edx
  800f79:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f7c:	eb ea                	jmp    800f68 <strlcpy+0x1e>
  800f7e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800f80:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f83:	29 f0                	sub    %esi,%eax
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f89:	f3 0f 1e fb          	endbr32 
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f93:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f96:	0f b6 01             	movzbl (%ecx),%eax
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 0c                	je     800fa9 <strcmp+0x20>
  800f9d:	3a 02                	cmp    (%edx),%al
  800f9f:	75 08                	jne    800fa9 <strcmp+0x20>
		p++, q++;
  800fa1:	83 c1 01             	add    $0x1,%ecx
  800fa4:	83 c2 01             	add    $0x1,%edx
  800fa7:	eb ed                	jmp    800f96 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	0f b6 12             	movzbl (%edx),%edx
  800faf:	29 d0                	sub    %edx,%eax
}
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fb3:	f3 0f 1e fb          	endbr32 
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	53                   	push   %ebx
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc1:	89 c3                	mov    %eax,%ebx
  800fc3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800fc6:	eb 06                	jmp    800fce <strncmp+0x1b>
		n--, p++, q++;
  800fc8:	83 c0 01             	add    $0x1,%eax
  800fcb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800fce:	39 d8                	cmp    %ebx,%eax
  800fd0:	74 16                	je     800fe8 <strncmp+0x35>
  800fd2:	0f b6 08             	movzbl (%eax),%ecx
  800fd5:	84 c9                	test   %cl,%cl
  800fd7:	74 04                	je     800fdd <strncmp+0x2a>
  800fd9:	3a 0a                	cmp    (%edx),%cl
  800fdb:	74 eb                	je     800fc8 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdd:	0f b6 00             	movzbl (%eax),%eax
  800fe0:	0f b6 12             	movzbl (%edx),%edx
  800fe3:	29 d0                	sub    %edx,%eax
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    
		return 0;
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	eb f6                	jmp    800fe5 <strncmp+0x32>

00800fef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fef:	f3 0f 1e fb          	endbr32 
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ffd:	0f b6 10             	movzbl (%eax),%edx
  801000:	84 d2                	test   %dl,%dl
  801002:	74 09                	je     80100d <strchr+0x1e>
		if (*s == c)
  801004:	38 ca                	cmp    %cl,%dl
  801006:	74 0a                	je     801012 <strchr+0x23>
	for (; *s; s++)
  801008:	83 c0 01             	add    $0x1,%eax
  80100b:	eb f0                	jmp    800ffd <strchr+0xe>
			return (char *) s;
	return 0;
  80100d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801012:	5d                   	pop    %ebp
  801013:	c3                   	ret    

00801014 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801014:	f3 0f 1e fb          	endbr32 
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801022:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  801025:	38 ca                	cmp    %cl,%dl
  801027:	74 09                	je     801032 <strfind+0x1e>
  801029:	84 d2                	test   %dl,%dl
  80102b:	74 05                	je     801032 <strfind+0x1e>
	for (; *s; s++)
  80102d:	83 c0 01             	add    $0x1,%eax
  801030:	eb f0                	jmp    801022 <strfind+0xe>
			break;
	return (char *) s;
}
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801034:	f3 0f 1e fb          	endbr32 
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801041:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801044:	85 c9                	test   %ecx,%ecx
  801046:	74 31                	je     801079 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801048:	89 f8                	mov    %edi,%eax
  80104a:	09 c8                	or     %ecx,%eax
  80104c:	a8 03                	test   $0x3,%al
  80104e:	75 23                	jne    801073 <memset+0x3f>
		c &= 0xFF;
  801050:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801054:	89 d3                	mov    %edx,%ebx
  801056:	c1 e3 08             	shl    $0x8,%ebx
  801059:	89 d0                	mov    %edx,%eax
  80105b:	c1 e0 18             	shl    $0x18,%eax
  80105e:	89 d6                	mov    %edx,%esi
  801060:	c1 e6 10             	shl    $0x10,%esi
  801063:	09 f0                	or     %esi,%eax
  801065:	09 c2                	or     %eax,%edx
  801067:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801069:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80106c:	89 d0                	mov    %edx,%eax
  80106e:	fc                   	cld    
  80106f:	f3 ab                	rep stos %eax,%es:(%edi)
  801071:	eb 06                	jmp    801079 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801073:	8b 45 0c             	mov    0xc(%ebp),%eax
  801076:	fc                   	cld    
  801077:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801079:	89 f8                	mov    %edi,%eax
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5f                   	pop    %edi
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801080:	f3 0f 1e fb          	endbr32 
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80108f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801092:	39 c6                	cmp    %eax,%esi
  801094:	73 32                	jae    8010c8 <memmove+0x48>
  801096:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	76 2b                	jbe    8010c8 <memmove+0x48>
		s += n;
		d += n;
  80109d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010a0:	89 fe                	mov    %edi,%esi
  8010a2:	09 ce                	or     %ecx,%esi
  8010a4:	09 d6                	or     %edx,%esi
  8010a6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010ac:	75 0e                	jne    8010bc <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010ae:	83 ef 04             	sub    $0x4,%edi
  8010b1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010b4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8010b7:	fd                   	std    
  8010b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010ba:	eb 09                	jmp    8010c5 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010bc:	83 ef 01             	sub    $0x1,%edi
  8010bf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8010c2:	fd                   	std    
  8010c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010c5:	fc                   	cld    
  8010c6:	eb 1a                	jmp    8010e2 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c8:	89 c2                	mov    %eax,%edx
  8010ca:	09 ca                	or     %ecx,%edx
  8010cc:	09 f2                	or     %esi,%edx
  8010ce:	f6 c2 03             	test   $0x3,%dl
  8010d1:	75 0a                	jne    8010dd <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010d3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8010d6:	89 c7                	mov    %eax,%edi
  8010d8:	fc                   	cld    
  8010d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010db:	eb 05                	jmp    8010e2 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8010dd:	89 c7                	mov    %eax,%edi
  8010df:	fc                   	cld    
  8010e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8010e6:	f3 0f 1e fb          	endbr32 
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8010f0:	ff 75 10             	pushl  0x10(%ebp)
  8010f3:	ff 75 0c             	pushl  0xc(%ebp)
  8010f6:	ff 75 08             	pushl  0x8(%ebp)
  8010f9:	e8 82 ff ff ff       	call   801080 <memmove>
}
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801100:	f3 0f 1e fb          	endbr32 
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110f:	89 c6                	mov    %eax,%esi
  801111:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801114:	39 f0                	cmp    %esi,%eax
  801116:	74 1c                	je     801134 <memcmp+0x34>
		if (*s1 != *s2)
  801118:	0f b6 08             	movzbl (%eax),%ecx
  80111b:	0f b6 1a             	movzbl (%edx),%ebx
  80111e:	38 d9                	cmp    %bl,%cl
  801120:	75 08                	jne    80112a <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801122:	83 c0 01             	add    $0x1,%eax
  801125:	83 c2 01             	add    $0x1,%edx
  801128:	eb ea                	jmp    801114 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  80112a:	0f b6 c1             	movzbl %cl,%eax
  80112d:	0f b6 db             	movzbl %bl,%ebx
  801130:	29 d8                	sub    %ebx,%eax
  801132:	eb 05                	jmp    801139 <memcmp+0x39>
	}

	return 0;
  801134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801139:	5b                   	pop    %ebx
  80113a:	5e                   	pop    %esi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80113d:	f3 0f 1e fb          	endbr32 
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80114a:	89 c2                	mov    %eax,%edx
  80114c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80114f:	39 d0                	cmp    %edx,%eax
  801151:	73 09                	jae    80115c <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  801153:	38 08                	cmp    %cl,(%eax)
  801155:	74 05                	je     80115c <memfind+0x1f>
	for (; s < ends; s++)
  801157:	83 c0 01             	add    $0x1,%eax
  80115a:	eb f3                	jmp    80114f <memfind+0x12>
			break;
	return (void *) s;
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80115e:	f3 0f 1e fb          	endbr32 
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	57                   	push   %edi
  801166:	56                   	push   %esi
  801167:	53                   	push   %ebx
  801168:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116e:	eb 03                	jmp    801173 <strtol+0x15>
		s++;
  801170:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801173:	0f b6 01             	movzbl (%ecx),%eax
  801176:	3c 20                	cmp    $0x20,%al
  801178:	74 f6                	je     801170 <strtol+0x12>
  80117a:	3c 09                	cmp    $0x9,%al
  80117c:	74 f2                	je     801170 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  80117e:	3c 2b                	cmp    $0x2b,%al
  801180:	74 2a                	je     8011ac <strtol+0x4e>
	int neg = 0;
  801182:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801187:	3c 2d                	cmp    $0x2d,%al
  801189:	74 2b                	je     8011b6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80118b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801191:	75 0f                	jne    8011a2 <strtol+0x44>
  801193:	80 39 30             	cmpb   $0x30,(%ecx)
  801196:	74 28                	je     8011c0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801198:	85 db                	test   %ebx,%ebx
  80119a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80119f:	0f 44 d8             	cmove  %eax,%ebx
  8011a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011aa:	eb 46                	jmp    8011f2 <strtol+0x94>
		s++;
  8011ac:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8011af:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b4:	eb d5                	jmp    80118b <strtol+0x2d>
		s++, neg = 1;
  8011b6:	83 c1 01             	add    $0x1,%ecx
  8011b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8011be:	eb cb                	jmp    80118b <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8011c4:	74 0e                	je     8011d4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8011c6:	85 db                	test   %ebx,%ebx
  8011c8:	75 d8                	jne    8011a2 <strtol+0x44>
		s++, base = 8;
  8011ca:	83 c1 01             	add    $0x1,%ecx
  8011cd:	bb 08 00 00 00       	mov    $0x8,%ebx
  8011d2:	eb ce                	jmp    8011a2 <strtol+0x44>
		s += 2, base = 16;
  8011d4:	83 c1 02             	add    $0x2,%ecx
  8011d7:	bb 10 00 00 00       	mov    $0x10,%ebx
  8011dc:	eb c4                	jmp    8011a2 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8011de:	0f be d2             	movsbl %dl,%edx
  8011e1:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8011e4:	3b 55 10             	cmp    0x10(%ebp),%edx
  8011e7:	7d 3a                	jge    801223 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8011e9:	83 c1 01             	add    $0x1,%ecx
  8011ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8011f2:	0f b6 11             	movzbl (%ecx),%edx
  8011f5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8011f8:	89 f3                	mov    %esi,%ebx
  8011fa:	80 fb 09             	cmp    $0x9,%bl
  8011fd:	76 df                	jbe    8011de <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8d 72 9f             	lea    -0x61(%edx),%esi
  801202:	89 f3                	mov    %esi,%ebx
  801204:	80 fb 19             	cmp    $0x19,%bl
  801207:	77 08                	ja     801211 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801209:	0f be d2             	movsbl %dl,%edx
  80120c:	83 ea 57             	sub    $0x57,%edx
  80120f:	eb d3                	jmp    8011e4 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801211:	8d 72 bf             	lea    -0x41(%edx),%esi
  801214:	89 f3                	mov    %esi,%ebx
  801216:	80 fb 19             	cmp    $0x19,%bl
  801219:	77 08                	ja     801223 <strtol+0xc5>
			dig = *s - 'A' + 10;
  80121b:	0f be d2             	movsbl %dl,%edx
  80121e:	83 ea 37             	sub    $0x37,%edx
  801221:	eb c1                	jmp    8011e4 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801223:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801227:	74 05                	je     80122e <strtol+0xd0>
		*endptr = (char *) s;
  801229:	8b 75 0c             	mov    0xc(%ebp),%esi
  80122c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80122e:	89 c2                	mov    %eax,%edx
  801230:	f7 da                	neg    %edx
  801232:	85 ff                	test   %edi,%edi
  801234:	0f 45 c2             	cmovne %edx,%eax
}
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80123c:	f3 0f 1e fb          	endbr32 
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	53                   	push   %ebx
	asm volatile("int %1\n"
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	8b 55 08             	mov    0x8(%ebp),%edx
  80124e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801251:	89 c3                	mov    %eax,%ebx
  801253:	89 c7                	mov    %eax,%edi
  801255:	89 c6                	mov    %eax,%esi
  801257:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801259:	5b                   	pop    %ebx
  80125a:	5e                   	pop    %esi
  80125b:	5f                   	pop    %edi
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <sys_cgetc>:

int
sys_cgetc(void)
{
  80125e:	f3 0f 1e fb          	endbr32 
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
	asm volatile("int %1\n"
  801268:	ba 00 00 00 00       	mov    $0x0,%edx
  80126d:	b8 01 00 00 00       	mov    $0x1,%eax
  801272:	89 d1                	mov    %edx,%ecx
  801274:	89 d3                	mov    %edx,%ebx
  801276:	89 d7                	mov    %edx,%edi
  801278:	89 d6                	mov    %edx,%esi
  80127a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80127c:	5b                   	pop    %ebx
  80127d:	5e                   	pop    %esi
  80127e:	5f                   	pop    %edi
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801281:	f3 0f 1e fb          	endbr32 
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	57                   	push   %edi
  801289:	56                   	push   %esi
  80128a:	53                   	push   %ebx
  80128b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80128e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	b8 03 00 00 00       	mov    $0x3,%eax
  80129b:	89 cb                	mov    %ecx,%ebx
  80129d:	89 cf                	mov    %ecx,%edi
  80129f:	89 ce                	mov    %ecx,%esi
  8012a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	7f 08                	jg     8012af <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5f                   	pop    %edi
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	50                   	push   %eax
  8012b3:	6a 03                	push   $0x3
  8012b5:	68 5f 33 80 00       	push   $0x80335f
  8012ba:	6a 23                	push   $0x23
  8012bc:	68 7c 33 80 00       	push   $0x80337c
  8012c1:	e8 13 f5 ff ff       	call   8007d9 <_panic>

008012c6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012c6:	f3 0f 1e fb          	endbr32 
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	57                   	push   %edi
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8012da:	89 d1                	mov    %edx,%ecx
  8012dc:	89 d3                	mov    %edx,%ebx
  8012de:	89 d7                	mov    %edx,%edi
  8012e0:	89 d6                	mov    %edx,%esi
  8012e2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012e4:	5b                   	pop    %ebx
  8012e5:	5e                   	pop    %esi
  8012e6:	5f                   	pop    %edi
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <sys_yield>:

void
sys_yield(void)
{
  8012e9:	f3 0f 1e fb          	endbr32 
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	57                   	push   %edi
  8012f1:	56                   	push   %esi
  8012f2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012fd:	89 d1                	mov    %edx,%ecx
  8012ff:	89 d3                	mov    %edx,%ebx
  801301:	89 d7                	mov    %edx,%edi
  801303:	89 d6                	mov    %edx,%esi
  801305:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80130c:	f3 0f 1e fb          	endbr32 
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	53                   	push   %ebx
  801316:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801319:	be 00 00 00 00       	mov    $0x0,%esi
  80131e:	8b 55 08             	mov    0x8(%ebp),%edx
  801321:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801324:	b8 04 00 00 00       	mov    $0x4,%eax
  801329:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80132c:	89 f7                	mov    %esi,%edi
  80132e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801330:	85 c0                	test   %eax,%eax
  801332:	7f 08                	jg     80133c <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80133c:	83 ec 0c             	sub    $0xc,%esp
  80133f:	50                   	push   %eax
  801340:	6a 04                	push   $0x4
  801342:	68 5f 33 80 00       	push   $0x80335f
  801347:	6a 23                	push   $0x23
  801349:	68 7c 33 80 00       	push   $0x80337c
  80134e:	e8 86 f4 ff ff       	call   8007d9 <_panic>

00801353 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801353:	f3 0f 1e fb          	endbr32 
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	57                   	push   %edi
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801360:	8b 55 08             	mov    0x8(%ebp),%edx
  801363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801366:	b8 05 00 00 00       	mov    $0x5,%eax
  80136b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80136e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801371:	8b 75 18             	mov    0x18(%ebp),%esi
  801374:	cd 30                	int    $0x30
	if(check && ret > 0)
  801376:	85 c0                	test   %eax,%eax
  801378:	7f 08                	jg     801382 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5f                   	pop    %edi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	50                   	push   %eax
  801386:	6a 05                	push   $0x5
  801388:	68 5f 33 80 00       	push   $0x80335f
  80138d:	6a 23                	push   $0x23
  80138f:	68 7c 33 80 00       	push   $0x80337c
  801394:	e8 40 f4 ff ff       	call   8007d9 <_panic>

00801399 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801399:	f3 0f 1e fb          	endbr32 
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
  8013a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8013b6:	89 df                	mov    %ebx,%edi
  8013b8:	89 de                	mov    %ebx,%esi
  8013ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	7f 08                	jg     8013c8 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8013c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c3:	5b                   	pop    %ebx
  8013c4:	5e                   	pop    %esi
  8013c5:	5f                   	pop    %edi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	50                   	push   %eax
  8013cc:	6a 06                	push   $0x6
  8013ce:	68 5f 33 80 00       	push   $0x80335f
  8013d3:	6a 23                	push   $0x23
  8013d5:	68 7c 33 80 00       	push   $0x80337c
  8013da:	e8 fa f3 ff ff       	call   8007d9 <_panic>

008013df <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013df:	f3 0f 1e fb          	endbr32 
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f7:	b8 08 00 00 00       	mov    $0x8,%eax
  8013fc:	89 df                	mov    %ebx,%edi
  8013fe:	89 de                	mov    %ebx,%esi
  801400:	cd 30                	int    $0x30
	if(check && ret > 0)
  801402:	85 c0                	test   %eax,%eax
  801404:	7f 08                	jg     80140e <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801406:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801409:	5b                   	pop    %ebx
  80140a:	5e                   	pop    %esi
  80140b:	5f                   	pop    %edi
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80140e:	83 ec 0c             	sub    $0xc,%esp
  801411:	50                   	push   %eax
  801412:	6a 08                	push   $0x8
  801414:	68 5f 33 80 00       	push   $0x80335f
  801419:	6a 23                	push   $0x23
  80141b:	68 7c 33 80 00       	push   $0x80337c
  801420:	e8 b4 f3 ff ff       	call   8007d9 <_panic>

00801425 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801425:	f3 0f 1e fb          	endbr32 
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	57                   	push   %edi
  80142d:	56                   	push   %esi
  80142e:	53                   	push   %ebx
  80142f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801432:	bb 00 00 00 00       	mov    $0x0,%ebx
  801437:	8b 55 08             	mov    0x8(%ebp),%edx
  80143a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80143d:	b8 09 00 00 00       	mov    $0x9,%eax
  801442:	89 df                	mov    %ebx,%edi
  801444:	89 de                	mov    %ebx,%esi
  801446:	cd 30                	int    $0x30
	if(check && ret > 0)
  801448:	85 c0                	test   %eax,%eax
  80144a:	7f 08                	jg     801454 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	50                   	push   %eax
  801458:	6a 09                	push   $0x9
  80145a:	68 5f 33 80 00       	push   $0x80335f
  80145f:	6a 23                	push   $0x23
  801461:	68 7c 33 80 00       	push   $0x80337c
  801466:	e8 6e f3 ff ff       	call   8007d9 <_panic>

0080146b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80146b:	f3 0f 1e fb          	endbr32 
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	57                   	push   %edi
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801478:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147d:	8b 55 08             	mov    0x8(%ebp),%edx
  801480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801483:	b8 0a 00 00 00       	mov    $0xa,%eax
  801488:	89 df                	mov    %ebx,%edi
  80148a:	89 de                	mov    %ebx,%esi
  80148c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80148e:	85 c0                	test   %eax,%eax
  801490:	7f 08                	jg     80149a <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801492:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801495:	5b                   	pop    %ebx
  801496:	5e                   	pop    %esi
  801497:	5f                   	pop    %edi
  801498:	5d                   	pop    %ebp
  801499:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	6a 0a                	push   $0xa
  8014a0:	68 5f 33 80 00       	push   $0x80335f
  8014a5:	6a 23                	push   $0x23
  8014a7:	68 7c 33 80 00       	push   $0x80337c
  8014ac:	e8 28 f3 ff ff       	call   8007d9 <_panic>

008014b1 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8014b1:	f3 0f 1e fb          	endbr32 
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	57                   	push   %edi
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8014c6:	be 00 00 00 00       	mov    $0x0,%esi
  8014cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014ce:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014d1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8014d3:	5b                   	pop    %ebx
  8014d4:	5e                   	pop    %esi
  8014d5:	5f                   	pop    %edi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    

008014d8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8014d8:	f3 0f 1e fb          	endbr32 
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ed:	b8 0d 00 00 00       	mov    $0xd,%eax
  8014f2:	89 cb                	mov    %ecx,%ebx
  8014f4:	89 cf                	mov    %ecx,%edi
  8014f6:	89 ce                	mov    %ecx,%esi
  8014f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	7f 08                	jg     801506 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5f                   	pop    %edi
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	50                   	push   %eax
  80150a:	6a 0d                	push   $0xd
  80150c:	68 5f 33 80 00       	push   $0x80335f
  801511:	6a 23                	push   $0x23
  801513:	68 7c 33 80 00       	push   $0x80337c
  801518:	e8 bc f2 ff ff       	call   8007d9 <_panic>

0080151d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80151d:	f3 0f 1e fb          	endbr32 
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	57                   	push   %edi
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
	asm volatile("int %1\n"
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	b8 0e 00 00 00       	mov    $0xe,%eax
  801531:	89 d1                	mov    %edx,%ecx
  801533:	89 d3                	mov    %edx,%ebx
  801535:	89 d7                	mov    %edx,%edi
  801537:	89 d6                	mov    %edx,%esi
  801539:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5f                   	pop    %edi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801540:	f3 0f 1e fb          	endbr32 
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	56                   	push   %esi
  801548:	53                   	push   %ebx
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  80154c:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  80154e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801552:	75 11                	jne    801565 <pgfault+0x25>
  801554:	89 f0                	mov    %esi,%eax
  801556:	c1 e8 0c             	shr    $0xc,%eax
  801559:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801560:	f6 c4 08             	test   $0x8,%ah
  801563:	74 7d                	je     8015e2 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  801565:	e8 5c fd ff ff       	call   8012c6 <sys_getenvid>
  80156a:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	6a 07                	push   $0x7
  801571:	68 00 f0 7f 00       	push   $0x7ff000
  801576:	50                   	push   %eax
  801577:	e8 90 fd ff ff       	call   80130c <sys_page_alloc>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	85 c0                	test   %eax,%eax
  801581:	78 7a                	js     8015fd <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  801583:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	68 00 10 00 00       	push   $0x1000
  801591:	56                   	push   %esi
  801592:	68 00 f0 7f 00       	push   $0x7ff000
  801597:	e8 e4 fa ff ff       	call   801080 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  80159c:	83 c4 08             	add    $0x8,%esp
  80159f:	56                   	push   %esi
  8015a0:	53                   	push   %ebx
  8015a1:	e8 f3 fd ff ff       	call   801399 <sys_page_unmap>
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 62                	js     80160f <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  8015ad:	83 ec 0c             	sub    $0xc,%esp
  8015b0:	6a 07                	push   $0x7
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
  8015b4:	68 00 f0 7f 00       	push   $0x7ff000
  8015b9:	53                   	push   %ebx
  8015ba:	e8 94 fd ff ff       	call   801353 <sys_page_map>
  8015bf:	83 c4 20             	add    $0x20,%esp
  8015c2:	85 c0                	test   %eax,%eax
  8015c4:	78 5b                	js     801621 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	68 00 f0 7f 00       	push   $0x7ff000
  8015ce:	53                   	push   %ebx
  8015cf:	e8 c5 fd ff ff       	call   801399 <sys_page_unmap>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 58                	js     801633 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  8015db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015de:	5b                   	pop    %ebx
  8015df:	5e                   	pop    %esi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  8015e2:	e8 df fc ff ff       	call   8012c6 <sys_getenvid>
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	56                   	push   %esi
  8015eb:	50                   	push   %eax
  8015ec:	68 8c 33 80 00       	push   $0x80338c
  8015f1:	6a 16                	push   $0x16
  8015f3:	68 1a 34 80 00       	push   $0x80341a
  8015f8:	e8 dc f1 ff ff       	call   8007d9 <_panic>
        panic("pgfault: page allocation failed %e", r);
  8015fd:	50                   	push   %eax
  8015fe:	68 d4 33 80 00       	push   $0x8033d4
  801603:	6a 1f                	push   $0x1f
  801605:	68 1a 34 80 00       	push   $0x80341a
  80160a:	e8 ca f1 ff ff       	call   8007d9 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80160f:	50                   	push   %eax
  801610:	68 25 34 80 00       	push   $0x803425
  801615:	6a 24                	push   $0x24
  801617:	68 1a 34 80 00       	push   $0x80341a
  80161c:	e8 b8 f1 ff ff       	call   8007d9 <_panic>
        panic("pgfault: page map failed %e", r);
  801621:	50                   	push   %eax
  801622:	68 43 34 80 00       	push   $0x803443
  801627:	6a 26                	push   $0x26
  801629:	68 1a 34 80 00       	push   $0x80341a
  80162e:	e8 a6 f1 ff ff       	call   8007d9 <_panic>
        panic("pgfault: page unmap failed %e", r);
  801633:	50                   	push   %eax
  801634:	68 25 34 80 00       	push   $0x803425
  801639:	6a 28                	push   $0x28
  80163b:	68 1a 34 80 00       	push   $0x80341a
  801640:	e8 94 f1 ff ff       	call   8007d9 <_panic>

00801645 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  80164c:	89 d3                	mov    %edx,%ebx
  80164e:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  801651:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801658:	f6 c6 04             	test   $0x4,%dh
  80165b:	75 62                	jne    8016bf <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  80165d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801663:	0f 84 9d 00 00 00    	je     801706 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  801669:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80166f:	8b 52 48             	mov    0x48(%edx),%edx
  801672:	83 ec 0c             	sub    $0xc,%esp
  801675:	68 05 08 00 00       	push   $0x805
  80167a:	53                   	push   %ebx
  80167b:	50                   	push   %eax
  80167c:	53                   	push   %ebx
  80167d:	52                   	push   %edx
  80167e:	e8 d0 fc ff ff       	call   801353 <sys_page_map>
  801683:	83 c4 20             	add    $0x20,%esp
  801686:	85 c0                	test   %eax,%eax
  801688:	78 6a                	js     8016f4 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  80168a:	a1 20 50 80 00       	mov    0x805020,%eax
  80168f:	8b 50 48             	mov    0x48(%eax),%edx
  801692:	8b 40 48             	mov    0x48(%eax),%eax
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	68 05 08 00 00       	push   $0x805
  80169d:	53                   	push   %ebx
  80169e:	52                   	push   %edx
  80169f:	53                   	push   %ebx
  8016a0:	50                   	push   %eax
  8016a1:	e8 ad fc ff ff       	call   801353 <sys_page_map>
  8016a6:	83 c4 20             	add    $0x20,%esp
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	79 77                	jns    801724 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8016ad:	50                   	push   %eax
  8016ae:	68 f8 33 80 00       	push   $0x8033f8
  8016b3:	6a 49                	push   $0x49
  8016b5:	68 1a 34 80 00       	push   $0x80341a
  8016ba:	e8 1a f1 ff ff       	call   8007d9 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  8016bf:	8b 0d 20 50 80 00    	mov    0x805020,%ecx
  8016c5:	8b 49 48             	mov    0x48(%ecx),%ecx
  8016c8:	83 ec 0c             	sub    $0xc,%esp
  8016cb:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016d1:	52                   	push   %edx
  8016d2:	53                   	push   %ebx
  8016d3:	50                   	push   %eax
  8016d4:	53                   	push   %ebx
  8016d5:	51                   	push   %ecx
  8016d6:	e8 78 fc ff ff       	call   801353 <sys_page_map>
  8016db:	83 c4 20             	add    $0x20,%esp
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	79 42                	jns    801724 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8016e2:	50                   	push   %eax
  8016e3:	68 f8 33 80 00       	push   $0x8033f8
  8016e8:	6a 43                	push   $0x43
  8016ea:	68 1a 34 80 00       	push   $0x80341a
  8016ef:	e8 e5 f0 ff ff       	call   8007d9 <_panic>
            panic("duppage: page remapping failed %e", r);
  8016f4:	50                   	push   %eax
  8016f5:	68 f8 33 80 00       	push   $0x8033f8
  8016fa:	6a 47                	push   $0x47
  8016fc:	68 1a 34 80 00       	push   $0x80341a
  801701:	e8 d3 f0 ff ff       	call   8007d9 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801706:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80170c:	8b 52 48             	mov    0x48(%edx),%edx
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	6a 05                	push   $0x5
  801714:	53                   	push   %ebx
  801715:	50                   	push   %eax
  801716:	53                   	push   %ebx
  801717:	52                   	push   %edx
  801718:	e8 36 fc ff ff       	call   801353 <sys_page_map>
  80171d:	83 c4 20             	add    $0x20,%esp
  801720:	85 c0                	test   %eax,%eax
  801722:	78 0a                	js     80172e <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
  801729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80172e:	50                   	push   %eax
  80172f:	68 f8 33 80 00       	push   $0x8033f8
  801734:	6a 4c                	push   $0x4c
  801736:	68 1a 34 80 00       	push   $0x80341a
  80173b:	e8 99 f0 ff ff       	call   8007d9 <_panic>

00801740 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801740:	f3 0f 1e fb          	endbr32 
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80174c:	68 40 15 80 00       	push   $0x801540
  801751:	e8 33 14 00 00       	call   802b89 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801756:	b8 07 00 00 00       	mov    $0x7,%eax
  80175b:	cd 30                	int    $0x30
  80175d:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 12                	js     801778 <fork+0x38>
  801766:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801768:	74 20                	je     80178a <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  80176a:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  801771:	ba 00 00 80 00       	mov    $0x800000,%edx
  801776:	eb 42                	jmp    8017ba <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801778:	50                   	push   %eax
  801779:	68 5f 34 80 00       	push   $0x80345f
  80177e:	6a 6a                	push   $0x6a
  801780:	68 1a 34 80 00       	push   $0x80341a
  801785:	e8 4f f0 ff ff       	call   8007d9 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80178a:	e8 37 fb ff ff       	call   8012c6 <sys_getenvid>
  80178f:	25 ff 03 00 00       	and    $0x3ff,%eax
  801794:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801797:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80179c:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  8017a1:	e9 8a 00 00 00       	jmp    801830 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a9:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8017af:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8017b2:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8017b8:	77 32                	ja     8017ec <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8017ba:	89 d0                	mov    %edx,%eax
  8017bc:	c1 e8 16             	shr    $0x16,%eax
  8017bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c6:	a8 01                	test   $0x1,%al
  8017c8:	74 dc                	je     8017a6 <fork+0x66>
  8017ca:	c1 ea 0c             	shr    $0xc,%edx
  8017cd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017d4:	a8 01                	test   $0x1,%al
  8017d6:	74 ce                	je     8017a6 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8017d8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017df:	a8 04                	test   $0x4,%al
  8017e1:	74 c3                	je     8017a6 <fork+0x66>
			duppage(envid, PGNUM(addr));
  8017e3:	89 f0                	mov    %esi,%eax
  8017e5:	e8 5b fe ff ff       	call   801645 <duppage>
  8017ea:	eb ba                	jmp    8017a6 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  8017ec:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8017ef:	c1 ea 0c             	shr    $0xc,%edx
  8017f2:	89 d8                	mov    %ebx,%eax
  8017f4:	e8 4c fe ff ff       	call   801645 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	6a 07                	push   $0x7
  8017fe:	68 00 f0 bf ee       	push   $0xeebff000
  801803:	53                   	push   %ebx
  801804:	e8 03 fb ff ff       	call   80130c <sys_page_alloc>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	75 29                	jne    801839 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	68 0a 2c 80 00       	push   $0x802c0a
  801818:	53                   	push   %ebx
  801819:	e8 4d fc ff ff       	call   80146b <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80181e:	83 c4 08             	add    $0x8,%esp
  801821:	6a 02                	push   $0x2
  801823:	53                   	push   %ebx
  801824:	e8 b6 fb ff ff       	call   8013df <sys_env_set_status>
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	85 c0                	test   %eax,%eax
  80182e:	75 1b                	jne    80184b <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801830:	89 d8                	mov    %ebx,%eax
  801832:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801839:	50                   	push   %eax
  80183a:	68 6e 34 80 00       	push   $0x80346e
  80183f:	6a 7b                	push   $0x7b
  801841:	68 1a 34 80 00       	push   $0x80341a
  801846:	e8 8e ef ff ff       	call   8007d9 <_panic>
		panic("sys_env_set_status:%e", r);
  80184b:	50                   	push   %eax
  80184c:	68 80 34 80 00       	push   $0x803480
  801851:	68 81 00 00 00       	push   $0x81
  801856:	68 1a 34 80 00       	push   $0x80341a
  80185b:	e8 79 ef ff ff       	call   8007d9 <_panic>

00801860 <sfork>:

// Challenge!
int
sfork(void)
{
  801860:	f3 0f 1e fb          	endbr32 
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80186a:	68 96 34 80 00       	push   $0x803496
  80186f:	68 8b 00 00 00       	push   $0x8b
  801874:	68 1a 34 80 00       	push   $0x80341a
  801879:	e8 5b ef ff ff       	call   8007d9 <_panic>

0080187e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80187e:	f3 0f 1e fb          	endbr32 
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	56                   	push   %esi
  801886:	53                   	push   %ebx
  801887:	8b 75 08             	mov    0x8(%ebp),%esi
  80188a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  801890:	83 e8 01             	sub    $0x1,%eax
  801893:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801898:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80189d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	50                   	push   %eax
  8018a5:	e8 2e fc ff ff       	call   8014d8 <sys_ipc_recv>
	if (!t) {
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 2b                	jne    8018dc <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8018b1:	85 f6                	test   %esi,%esi
  8018b3:	74 0a                	je     8018bf <ipc_recv+0x41>
  8018b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8018ba:	8b 40 74             	mov    0x74(%eax),%eax
  8018bd:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8018bf:	85 db                	test   %ebx,%ebx
  8018c1:	74 0a                	je     8018cd <ipc_recv+0x4f>
  8018c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c8:	8b 40 78             	mov    0x78(%eax),%eax
  8018cb:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8018cd:	a1 20 50 80 00       	mov    0x805020,%eax
  8018d2:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8018d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8018dc:	85 f6                	test   %esi,%esi
  8018de:	74 06                	je     8018e6 <ipc_recv+0x68>
  8018e0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8018e6:	85 db                	test   %ebx,%ebx
  8018e8:	74 eb                	je     8018d5 <ipc_recv+0x57>
  8018ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8018f0:	eb e3                	jmp    8018d5 <ipc_recv+0x57>

008018f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8018f2:	f3 0f 1e fb          	endbr32 
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	57                   	push   %edi
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 0c             	sub    $0xc,%esp
  8018ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801902:	8b 75 0c             	mov    0xc(%ebp),%esi
  801905:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801908:	85 db                	test   %ebx,%ebx
  80190a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80190f:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  801912:	ff 75 14             	pushl  0x14(%ebp)
  801915:	53                   	push   %ebx
  801916:	56                   	push   %esi
  801917:	57                   	push   %edi
  801918:	e8 94 fb ff ff       	call   8014b1 <sys_ipc_try_send>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	74 1e                	je     801942 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  801924:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801927:	75 07                	jne    801930 <ipc_send+0x3e>
		sys_yield();
  801929:	e8 bb f9 ff ff       	call   8012e9 <sys_yield>
  80192e:	eb e2                	jmp    801912 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  801930:	50                   	push   %eax
  801931:	68 ac 34 80 00       	push   $0x8034ac
  801936:	6a 39                	push   $0x39
  801938:	68 be 34 80 00       	push   $0x8034be
  80193d:	e8 97 ee ff ff       	call   8007d9 <_panic>
	}
	//panic("ipc_send not implemented");
}
  801942:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5f                   	pop    %edi
  801948:	5d                   	pop    %ebp
  801949:	c3                   	ret    

0080194a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80194a:	f3 0f 1e fb          	endbr32 
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801959:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80195c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801962:	8b 52 50             	mov    0x50(%edx),%edx
  801965:	39 ca                	cmp    %ecx,%edx
  801967:	74 11                	je     80197a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801969:	83 c0 01             	add    $0x1,%eax
  80196c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801971:	75 e6                	jne    801959 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
  801978:	eb 0b                	jmp    801985 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80197a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80197d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801982:	8b 40 48             	mov    0x48(%eax),%eax
}
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801987:	f3 0f 1e fb          	endbr32 
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	05 00 00 00 30       	add    $0x30000000,%eax
  801996:	c1 e8 0c             	shr    $0xc,%eax
}
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80199b:	f3 0f 1e fb          	endbr32 
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8019aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019af:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    

008019b6 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019b6:	f3 0f 1e fb          	endbr32 
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8019c2:	89 c2                	mov    %eax,%edx
  8019c4:	c1 ea 16             	shr    $0x16,%edx
  8019c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019ce:	f6 c2 01             	test   $0x1,%dl
  8019d1:	74 2d                	je     801a00 <fd_alloc+0x4a>
  8019d3:	89 c2                	mov    %eax,%edx
  8019d5:	c1 ea 0c             	shr    $0xc,%edx
  8019d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019df:	f6 c2 01             	test   $0x1,%dl
  8019e2:	74 1c                	je     801a00 <fd_alloc+0x4a>
  8019e4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8019e9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8019ee:	75 d2                	jne    8019c2 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8019f9:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8019fe:	eb 0a                	jmp    801a0a <fd_alloc+0x54>
			*fd_store = fd;
  801a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a03:	89 01                	mov    %eax,(%ecx)
			return 0;
  801a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a16:	83 f8 1f             	cmp    $0x1f,%eax
  801a19:	77 30                	ja     801a4b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a1b:	c1 e0 0c             	shl    $0xc,%eax
  801a1e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801a23:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801a29:	f6 c2 01             	test   $0x1,%dl
  801a2c:	74 24                	je     801a52 <fd_lookup+0x46>
  801a2e:	89 c2                	mov    %eax,%edx
  801a30:	c1 ea 0c             	shr    $0xc,%edx
  801a33:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a3a:	f6 c2 01             	test   $0x1,%dl
  801a3d:	74 1a                	je     801a59 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a42:	89 02                	mov    %eax,(%edx)
	return 0;
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    
		return -E_INVAL;
  801a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a50:	eb f7                	jmp    801a49 <fd_lookup+0x3d>
		return -E_INVAL;
  801a52:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a57:	eb f0                	jmp    801a49 <fd_lookup+0x3d>
  801a59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a5e:	eb e9                	jmp    801a49 <fd_lookup+0x3d>

00801a60 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a60:	f3 0f 1e fb          	endbr32 
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801a77:	39 08                	cmp    %ecx,(%eax)
  801a79:	74 38                	je     801ab3 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801a7b:	83 c2 01             	add    $0x1,%edx
  801a7e:	8b 04 95 44 35 80 00 	mov    0x803544(,%edx,4),%eax
  801a85:	85 c0                	test   %eax,%eax
  801a87:	75 ee                	jne    801a77 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801a89:	a1 20 50 80 00       	mov    0x805020,%eax
  801a8e:	8b 40 48             	mov    0x48(%eax),%eax
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	51                   	push   %ecx
  801a95:	50                   	push   %eax
  801a96:	68 c8 34 80 00       	push   $0x8034c8
  801a9b:	e8 20 ee ff ff       	call   8008c0 <cprintf>
	*dev = 0;
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    
			*dev = devtab[i];
  801ab3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab6:	89 01                	mov    %eax,(%ecx)
			return 0;
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  801abd:	eb f2                	jmp    801ab1 <dev_lookup+0x51>

00801abf <fd_close>:
{
  801abf:	f3 0f 1e fb          	endbr32 
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	57                   	push   %edi
  801ac7:	56                   	push   %esi
  801ac8:	53                   	push   %ebx
  801ac9:	83 ec 24             	sub    $0x24,%esp
  801acc:	8b 75 08             	mov    0x8(%ebp),%esi
  801acf:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ad2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ad5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ad6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801adc:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801adf:	50                   	push   %eax
  801ae0:	e8 27 ff ff ff       	call   801a0c <fd_lookup>
  801ae5:	89 c3                	mov    %eax,%ebx
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 05                	js     801af3 <fd_close+0x34>
	    || fd != fd2)
  801aee:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801af1:	74 16                	je     801b09 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801af3:	89 f8                	mov    %edi,%eax
  801af5:	84 c0                	test   %al,%al
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	0f 44 d8             	cmove  %eax,%ebx
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5f                   	pop    %edi
  801b07:	5d                   	pop    %ebp
  801b08:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b09:	83 ec 08             	sub    $0x8,%esp
  801b0c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b0f:	50                   	push   %eax
  801b10:	ff 36                	pushl  (%esi)
  801b12:	e8 49 ff ff ff       	call   801a60 <dev_lookup>
  801b17:	89 c3                	mov    %eax,%ebx
  801b19:	83 c4 10             	add    $0x10,%esp
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 1a                	js     801b3a <fd_close+0x7b>
		if (dev->dev_close)
  801b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b23:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801b26:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	74 0b                	je     801b3a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	56                   	push   %esi
  801b33:	ff d0                	call   *%eax
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801b3a:	83 ec 08             	sub    $0x8,%esp
  801b3d:	56                   	push   %esi
  801b3e:	6a 00                	push   $0x0
  801b40:	e8 54 f8 ff ff       	call   801399 <sys_page_unmap>
	return r;
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	eb b5                	jmp    801aff <fd_close+0x40>

00801b4a <close>:

int
close(int fdnum)
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b57:	50                   	push   %eax
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 ac fe ff ff       	call   801a0c <fd_lookup>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	79 02                	jns    801b69 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    
		return fd_close(fd, 1);
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	6a 01                	push   $0x1
  801b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b71:	e8 49 ff ff ff       	call   801abf <fd_close>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	eb ec                	jmp    801b67 <close+0x1d>

00801b7b <close_all>:

void
close_all(void)
{
  801b7b:	f3 0f 1e fb          	endbr32 
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	53                   	push   %ebx
  801b83:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801b86:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801b8b:	83 ec 0c             	sub    $0xc,%esp
  801b8e:	53                   	push   %ebx
  801b8f:	e8 b6 ff ff ff       	call   801b4a <close>
	for (i = 0; i < MAXFD; i++)
  801b94:	83 c3 01             	add    $0x1,%ebx
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	83 fb 20             	cmp    $0x20,%ebx
  801b9d:	75 ec                	jne    801b8b <close_all+0x10>
}
  801b9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ba4:	f3 0f 1e fb          	endbr32 
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	57                   	push   %edi
  801bac:	56                   	push   %esi
  801bad:	53                   	push   %ebx
  801bae:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bb1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bb4:	50                   	push   %eax
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	e8 4f fe ff ff       	call   801a0c <fd_lookup>
  801bbd:	89 c3                	mov    %eax,%ebx
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	0f 88 81 00 00 00    	js     801c4b <dup+0xa7>
		return r;
	close(newfdnum);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	e8 75 ff ff ff       	call   801b4a <close>

	newfd = INDEX2FD(newfdnum);
  801bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd8:	c1 e6 0c             	shl    $0xc,%esi
  801bdb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801be1:	83 c4 04             	add    $0x4,%esp
  801be4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801be7:	e8 af fd ff ff       	call   80199b <fd2data>
  801bec:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bee:	89 34 24             	mov    %esi,(%esp)
  801bf1:	e8 a5 fd ff ff       	call   80199b <fd2data>
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	c1 e8 16             	shr    $0x16,%eax
  801c00:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c07:	a8 01                	test   $0x1,%al
  801c09:	74 11                	je     801c1c <dup+0x78>
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	c1 e8 0c             	shr    $0xc,%eax
  801c10:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c17:	f6 c2 01             	test   $0x1,%dl
  801c1a:	75 39                	jne    801c55 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801c1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c1f:	89 d0                	mov    %edx,%eax
  801c21:	c1 e8 0c             	shr    $0xc,%eax
  801c24:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c2b:	83 ec 0c             	sub    $0xc,%esp
  801c2e:	25 07 0e 00 00       	and    $0xe07,%eax
  801c33:	50                   	push   %eax
  801c34:	56                   	push   %esi
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	6a 00                	push   $0x0
  801c3a:	e8 14 f7 ff ff       	call   801353 <sys_page_map>
  801c3f:	89 c3                	mov    %eax,%ebx
  801c41:	83 c4 20             	add    $0x20,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	78 31                	js     801c79 <dup+0xd5>
		goto err;

	return newfdnum;
  801c48:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801c4b:	89 d8                	mov    %ebx,%eax
  801c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5f                   	pop    %edi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801c55:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	25 07 0e 00 00       	and    $0xe07,%eax
  801c64:	50                   	push   %eax
  801c65:	57                   	push   %edi
  801c66:	6a 00                	push   $0x0
  801c68:	53                   	push   %ebx
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 e3 f6 ff ff       	call   801353 <sys_page_map>
  801c70:	89 c3                	mov    %eax,%ebx
  801c72:	83 c4 20             	add    $0x20,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	79 a3                	jns    801c1c <dup+0x78>
	sys_page_unmap(0, newfd);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	56                   	push   %esi
  801c7d:	6a 00                	push   $0x0
  801c7f:	e8 15 f7 ff ff       	call   801399 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c84:	83 c4 08             	add    $0x8,%esp
  801c87:	57                   	push   %edi
  801c88:	6a 00                	push   $0x0
  801c8a:	e8 0a f7 ff ff       	call   801399 <sys_page_unmap>
	return r;
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	eb b7                	jmp    801c4b <dup+0xa7>

00801c94 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801c94:	f3 0f 1e fb          	endbr32 
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 1c             	sub    $0x1c,%esp
  801c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ca2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca5:	50                   	push   %eax
  801ca6:	53                   	push   %ebx
  801ca7:	e8 60 fd ff ff       	call   801a0c <fd_lookup>
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 3f                	js     801cf2 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb9:	50                   	push   %eax
  801cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbd:	ff 30                	pushl  (%eax)
  801cbf:	e8 9c fd ff ff       	call   801a60 <dev_lookup>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	78 27                	js     801cf2 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ccb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cce:	8b 42 08             	mov    0x8(%edx),%eax
  801cd1:	83 e0 03             	and    $0x3,%eax
  801cd4:	83 f8 01             	cmp    $0x1,%eax
  801cd7:	74 1e                	je     801cf7 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cdc:	8b 40 08             	mov    0x8(%eax),%eax
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	74 35                	je     801d18 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	ff 75 10             	pushl  0x10(%ebp)
  801ce9:	ff 75 0c             	pushl  0xc(%ebp)
  801cec:	52                   	push   %edx
  801ced:	ff d0                	call   *%eax
  801cef:	83 c4 10             	add    $0x10,%esp
}
  801cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801cf7:	a1 20 50 80 00       	mov    0x805020,%eax
  801cfc:	8b 40 48             	mov    0x48(%eax),%eax
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	53                   	push   %ebx
  801d03:	50                   	push   %eax
  801d04:	68 09 35 80 00       	push   $0x803509
  801d09:	e8 b2 eb ff ff       	call   8008c0 <cprintf>
		return -E_INVAL;
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d16:	eb da                	jmp    801cf2 <read+0x5e>
		return -E_NOT_SUPP;
  801d18:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d1d:	eb d3                	jmp    801cf2 <read+0x5e>

00801d1f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d1f:	f3 0f 1e fb          	endbr32 
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	57                   	push   %edi
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	83 ec 0c             	sub    $0xc,%esp
  801d2c:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d2f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d32:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d37:	eb 02                	jmp    801d3b <readn+0x1c>
  801d39:	01 c3                	add    %eax,%ebx
  801d3b:	39 f3                	cmp    %esi,%ebx
  801d3d:	73 21                	jae    801d60 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	89 f0                	mov    %esi,%eax
  801d44:	29 d8                	sub    %ebx,%eax
  801d46:	50                   	push   %eax
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	03 45 0c             	add    0xc(%ebp),%eax
  801d4c:	50                   	push   %eax
  801d4d:	57                   	push   %edi
  801d4e:	e8 41 ff ff ff       	call   801c94 <read>
		if (m < 0)
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	85 c0                	test   %eax,%eax
  801d58:	78 04                	js     801d5e <readn+0x3f>
			return m;
		if (m == 0)
  801d5a:	75 dd                	jne    801d39 <readn+0x1a>
  801d5c:	eb 02                	jmp    801d60 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d5e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d6a:	f3 0f 1e fb          	endbr32 
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	53                   	push   %ebx
  801d72:	83 ec 1c             	sub    $0x1c,%esp
  801d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d7b:	50                   	push   %eax
  801d7c:	53                   	push   %ebx
  801d7d:	e8 8a fc ff ff       	call   801a0c <fd_lookup>
  801d82:	83 c4 10             	add    $0x10,%esp
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 3a                	js     801dc3 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8f:	50                   	push   %eax
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	ff 30                	pushl  (%eax)
  801d95:	e8 c6 fc ff ff       	call   801a60 <dev_lookup>
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	78 22                	js     801dc3 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801da8:	74 1e                	je     801dc8 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dad:	8b 52 0c             	mov    0xc(%edx),%edx
  801db0:	85 d2                	test   %edx,%edx
  801db2:	74 35                	je     801de9 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	ff d2                	call   *%edx
  801dc0:	83 c4 10             	add    $0x10,%esp
}
  801dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801dc8:	a1 20 50 80 00       	mov    0x805020,%eax
  801dcd:	8b 40 48             	mov    0x48(%eax),%eax
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	53                   	push   %ebx
  801dd4:	50                   	push   %eax
  801dd5:	68 25 35 80 00       	push   $0x803525
  801dda:	e8 e1 ea ff ff       	call   8008c0 <cprintf>
		return -E_INVAL;
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801de7:	eb da                	jmp    801dc3 <write+0x59>
		return -E_NOT_SUPP;
  801de9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dee:	eb d3                	jmp    801dc3 <write+0x59>

00801df0 <seek>:

int
seek(int fdnum, off_t offset)
{
  801df0:	f3 0f 1e fb          	endbr32 
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	e8 06 fc ff ff       	call   801a0c <fd_lookup>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	78 0e                	js     801e1b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801e1d:	f3 0f 1e fb          	endbr32 
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	53                   	push   %ebx
  801e25:	83 ec 1c             	sub    $0x1c,%esp
  801e28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2e:	50                   	push   %eax
  801e2f:	53                   	push   %ebx
  801e30:	e8 d7 fb ff ff       	call   801a0c <fd_lookup>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 37                	js     801e73 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e42:	50                   	push   %eax
  801e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e46:	ff 30                	pushl  (%eax)
  801e48:	e8 13 fc ff ff       	call   801a60 <dev_lookup>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 1f                	js     801e73 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e57:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801e5b:	74 1b                	je     801e78 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e60:	8b 52 18             	mov    0x18(%edx),%edx
  801e63:	85 d2                	test   %edx,%edx
  801e65:	74 32                	je     801e99 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	50                   	push   %eax
  801e6e:	ff d2                	call   *%edx
  801e70:	83 c4 10             	add    $0x10,%esp
}
  801e73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    
			thisenv->env_id, fdnum);
  801e78:	a1 20 50 80 00       	mov    0x805020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e7d:	8b 40 48             	mov    0x48(%eax),%eax
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	53                   	push   %ebx
  801e84:	50                   	push   %eax
  801e85:	68 e8 34 80 00       	push   $0x8034e8
  801e8a:	e8 31 ea ff ff       	call   8008c0 <cprintf>
		return -E_INVAL;
  801e8f:	83 c4 10             	add    $0x10,%esp
  801e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e97:	eb da                	jmp    801e73 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801e99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e9e:	eb d3                	jmp    801e73 <ftruncate+0x56>

00801ea0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ea0:	f3 0f 1e fb          	endbr32 
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 1c             	sub    $0x1c,%esp
  801eab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801eae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eb1:	50                   	push   %eax
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	e8 52 fb ff ff       	call   801a0c <fd_lookup>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	78 4b                	js     801f0c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec7:	50                   	push   %eax
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecb:	ff 30                	pushl  (%eax)
  801ecd:	e8 8e fb ff ff       	call   801a60 <dev_lookup>
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	78 33                	js     801f0c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ee0:	74 2f                	je     801f11 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ee2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ee5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801eec:	00 00 00 
	stat->st_isdir = 0;
  801eef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ef6:	00 00 00 
	stat->st_dev = dev;
  801ef9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801eff:	83 ec 08             	sub    $0x8,%esp
  801f02:	53                   	push   %ebx
  801f03:	ff 75 f0             	pushl  -0x10(%ebp)
  801f06:	ff 50 14             	call   *0x14(%eax)
  801f09:	83 c4 10             	add    $0x10,%esp
}
  801f0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    
		return -E_NOT_SUPP;
  801f11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f16:	eb f4                	jmp    801f0c <fstat+0x6c>

00801f18 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801f18:	f3 0f 1e fb          	endbr32 
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	56                   	push   %esi
  801f20:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	e8 fb 01 00 00       	call   802129 <open>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	78 1b                	js     801f52 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801f37:	83 ec 08             	sub    $0x8,%esp
  801f3a:	ff 75 0c             	pushl  0xc(%ebp)
  801f3d:	50                   	push   %eax
  801f3e:	e8 5d ff ff ff       	call   801ea0 <fstat>
  801f43:	89 c6                	mov    %eax,%esi
	close(fd);
  801f45:	89 1c 24             	mov    %ebx,(%esp)
  801f48:	e8 fd fb ff ff       	call   801b4a <close>
	return r;
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 f3                	mov    %esi,%ebx
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	89 c6                	mov    %eax,%esi
  801f62:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801f64:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  801f6b:	74 27                	je     801f94 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f6d:	6a 07                	push   $0x7
  801f6f:	68 00 60 80 00       	push   $0x806000
  801f74:	56                   	push   %esi
  801f75:	ff 35 18 50 80 00    	pushl  0x805018
  801f7b:	e8 72 f9 ff ff       	call   8018f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f80:	83 c4 0c             	add    $0xc,%esp
  801f83:	6a 00                	push   $0x0
  801f85:	53                   	push   %ebx
  801f86:	6a 00                	push   $0x0
  801f88:	e8 f1 f8 ff ff       	call   80187e <ipc_recv>
}
  801f8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5e                   	pop    %esi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	6a 01                	push   $0x1
  801f99:	e8 ac f9 ff ff       	call   80194a <ipc_find_env>
  801f9e:	a3 18 50 80 00       	mov    %eax,0x805018
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	eb c5                	jmp    801f6d <fsipc+0x12>

00801fa8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801fa8:	f3 0f 1e fb          	endbr32 
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb8:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc0:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fca:	b8 02 00 00 00       	mov    $0x2,%eax
  801fcf:	e8 87 ff ff ff       	call   801f5b <fsipc>
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <devfile_flush>:
{
  801fd6:	f3 0f 1e fb          	endbr32 
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	b8 06 00 00 00       	mov    $0x6,%eax
  801ff5:	e8 61 ff ff ff       	call   801f5b <fsipc>
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <devfile_stat>:
{
  801ffc:	f3 0f 1e fb          	endbr32 
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	53                   	push   %ebx
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	8b 40 0c             	mov    0xc(%eax),%eax
  802010:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802015:	ba 00 00 00 00       	mov    $0x0,%edx
  80201a:	b8 05 00 00 00       	mov    $0x5,%eax
  80201f:	e8 37 ff ff ff       	call   801f5b <fsipc>
  802024:	85 c0                	test   %eax,%eax
  802026:	78 2c                	js     802054 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	68 00 60 80 00       	push   $0x806000
  802030:	53                   	push   %ebx
  802031:	e8 94 ee ff ff       	call   800eca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802036:	a1 80 60 80 00       	mov    0x806080,%eax
  80203b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802041:	a1 84 60 80 00       	mov    0x806084,%eax
  802046:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802054:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <devfile_write>:
{
  802059:	f3 0f 1e fb          	endbr32 
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802066:	8b 55 08             	mov    0x8(%ebp),%edx
  802069:	8b 52 0c             	mov    0xc(%edx),%edx
  80206c:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  802072:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802077:	ba 00 10 00 00       	mov    $0x1000,%edx
  80207c:	0f 47 c2             	cmova  %edx,%eax
  80207f:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802084:	50                   	push   %eax
  802085:	ff 75 0c             	pushl  0xc(%ebp)
  802088:	68 08 60 80 00       	push   $0x806008
  80208d:	e8 ee ef ff ff       	call   801080 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  802092:	ba 00 00 00 00       	mov    $0x0,%edx
  802097:	b8 04 00 00 00       	mov    $0x4,%eax
  80209c:	e8 ba fe ff ff       	call   801f5b <fsipc>
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <devfile_read>:
{
  8020a3:	f3 0f 1e fb          	endbr32 
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	56                   	push   %esi
  8020ab:	53                   	push   %ebx
  8020ac:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8020ba:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8020c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8020ca:	e8 8c fe ff ff       	call   801f5b <fsipc>
  8020cf:	89 c3                	mov    %eax,%ebx
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 1f                	js     8020f4 <devfile_read+0x51>
	assert(r <= n);
  8020d5:	39 f0                	cmp    %esi,%eax
  8020d7:	77 24                	ja     8020fd <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8020d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8020de:	7f 33                	jg     802113 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	50                   	push   %eax
  8020e4:	68 00 60 80 00       	push   $0x806000
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	e8 8f ef ff ff       	call   801080 <memmove>
	return r;
  8020f1:	83 c4 10             	add    $0x10,%esp
}
  8020f4:	89 d8                	mov    %ebx,%eax
  8020f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f9:	5b                   	pop    %ebx
  8020fa:	5e                   	pop    %esi
  8020fb:	5d                   	pop    %ebp
  8020fc:	c3                   	ret    
	assert(r <= n);
  8020fd:	68 58 35 80 00       	push   $0x803558
  802102:	68 5f 35 80 00       	push   $0x80355f
  802107:	6a 7c                	push   $0x7c
  802109:	68 74 35 80 00       	push   $0x803574
  80210e:	e8 c6 e6 ff ff       	call   8007d9 <_panic>
	assert(r <= PGSIZE);
  802113:	68 7f 35 80 00       	push   $0x80357f
  802118:	68 5f 35 80 00       	push   $0x80355f
  80211d:	6a 7d                	push   $0x7d
  80211f:	68 74 35 80 00       	push   $0x803574
  802124:	e8 b0 e6 ff ff       	call   8007d9 <_panic>

00802129 <open>:
{
  802129:	f3 0f 1e fb          	endbr32 
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	56                   	push   %esi
  802131:	53                   	push   %ebx
  802132:	83 ec 1c             	sub    $0x1c,%esp
  802135:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802138:	56                   	push   %esi
  802139:	e8 49 ed ff ff       	call   800e87 <strlen>
  80213e:	83 c4 10             	add    $0x10,%esp
  802141:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802146:	7f 6c                	jg     8021b4 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  802148:	83 ec 0c             	sub    $0xc,%esp
  80214b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	e8 62 f8 ff ff       	call   8019b6 <fd_alloc>
  802154:	89 c3                	mov    %eax,%ebx
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	85 c0                	test   %eax,%eax
  80215b:	78 3c                	js     802199 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80215d:	83 ec 08             	sub    $0x8,%esp
  802160:	56                   	push   %esi
  802161:	68 00 60 80 00       	push   $0x806000
  802166:	e8 5f ed ff ff       	call   800eca <strcpy>
	fsipcbuf.open.req_omode = mode;
  80216b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216e:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	e8 db fd ff ff       	call   801f5b <fsipc>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	85 c0                	test   %eax,%eax
  802187:	78 19                	js     8021a2 <open+0x79>
	return fd2num(fd);
  802189:	83 ec 0c             	sub    $0xc,%esp
  80218c:	ff 75 f4             	pushl  -0xc(%ebp)
  80218f:	e8 f3 f7 ff ff       	call   801987 <fd2num>
  802194:	89 c3                	mov    %eax,%ebx
  802196:	83 c4 10             	add    $0x10,%esp
}
  802199:	89 d8                	mov    %ebx,%eax
  80219b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219e:	5b                   	pop    %ebx
  80219f:	5e                   	pop    %esi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
		fd_close(fd, 0);
  8021a2:	83 ec 08             	sub    $0x8,%esp
  8021a5:	6a 00                	push   $0x0
  8021a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021aa:	e8 10 f9 ff ff       	call   801abf <fd_close>
		return r;
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	eb e5                	jmp    802199 <open+0x70>
		return -E_BAD_PATH;
  8021b4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8021b9:	eb de                	jmp    802199 <open+0x70>

008021bb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8021bb:	f3 0f 1e fb          	endbr32 
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8021c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8021cf:	e8 87 fd ff ff       	call   801f5b <fsipc>
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8021d6:	f3 0f 1e fb          	endbr32 
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8021e0:	68 8b 35 80 00       	push   $0x80358b
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	e8 dd ec ff ff       	call   800eca <strcpy>
	return 0;
}
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <devsock_close>:
{
  8021f4:	f3 0f 1e fb          	endbr32 
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	53                   	push   %ebx
  8021fc:	83 ec 10             	sub    $0x10,%esp
  8021ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802202:	53                   	push   %ebx
  802203:	e8 26 0a 00 00       	call   802c2e <pageref>
  802208:	89 c2                	mov    %eax,%edx
  80220a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802212:	83 fa 01             	cmp    $0x1,%edx
  802215:	74 05                	je     80221c <devsock_close+0x28>
}
  802217:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	ff 73 0c             	pushl  0xc(%ebx)
  802222:	e8 e3 02 00 00       	call   80250a <nsipc_close>
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	eb eb                	jmp    802217 <devsock_close+0x23>

0080222c <devsock_write>:
{
  80222c:	f3 0f 1e fb          	endbr32 
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802236:	6a 00                	push   $0x0
  802238:	ff 75 10             	pushl  0x10(%ebp)
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	ff 70 0c             	pushl  0xc(%eax)
  802244:	e8 b5 03 00 00       	call   8025fe <nsipc_send>
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <devsock_read>:
{
  80224b:	f3 0f 1e fb          	endbr32 
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802255:	6a 00                	push   $0x0
  802257:	ff 75 10             	pushl  0x10(%ebp)
  80225a:	ff 75 0c             	pushl  0xc(%ebp)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	ff 70 0c             	pushl  0xc(%eax)
  802263:	e8 1f 03 00 00       	call   802587 <nsipc_recv>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <fd2sockid>:
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  802270:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802273:	52                   	push   %edx
  802274:	50                   	push   %eax
  802275:	e8 92 f7 ff ff       	call   801a0c <fd_lookup>
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 10                	js     802291 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80228a:	39 08                	cmp    %ecx,(%eax)
  80228c:	75 05                	jne    802293 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80228e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    
		return -E_NOT_SUPP;
  802293:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802298:	eb f7                	jmp    802291 <fd2sockid+0x27>

0080229a <alloc_sockfd>:
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	56                   	push   %esi
  80229e:	53                   	push   %ebx
  80229f:	83 ec 1c             	sub    $0x1c,%esp
  8022a2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8022a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a7:	50                   	push   %eax
  8022a8:	e8 09 f7 ff ff       	call   8019b6 <fd_alloc>
  8022ad:	89 c3                	mov    %eax,%ebx
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	78 43                	js     8022f9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8022b6:	83 ec 04             	sub    $0x4,%esp
  8022b9:	68 07 04 00 00       	push   $0x407
  8022be:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c1:	6a 00                	push   $0x0
  8022c3:	e8 44 f0 ff ff       	call   80130c <sys_page_alloc>
  8022c8:	89 c3                	mov    %eax,%ebx
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 28                	js     8022f9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8022da:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8022e6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	50                   	push   %eax
  8022ed:	e8 95 f6 ff ff       	call   801987 <fd2num>
  8022f2:	89 c3                	mov    %eax,%ebx
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	eb 0c                	jmp    802305 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	56                   	push   %esi
  8022fd:	e8 08 02 00 00       	call   80250a <nsipc_close>
		return r;
  802302:	83 c4 10             	add    $0x10,%esp
}
  802305:	89 d8                	mov    %ebx,%eax
  802307:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230a:	5b                   	pop    %ebx
  80230b:	5e                   	pop    %esi
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    

0080230e <accept>:
{
  80230e:	f3 0f 1e fb          	endbr32 
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	e8 4a ff ff ff       	call   80226a <fd2sockid>
  802320:	85 c0                	test   %eax,%eax
  802322:	78 1b                	js     80233f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	ff 75 10             	pushl  0x10(%ebp)
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	50                   	push   %eax
  80232e:	e8 22 01 00 00       	call   802455 <nsipc_accept>
  802333:	83 c4 10             	add    $0x10,%esp
  802336:	85 c0                	test   %eax,%eax
  802338:	78 05                	js     80233f <accept+0x31>
	return alloc_sockfd(r);
  80233a:	e8 5b ff ff ff       	call   80229a <alloc_sockfd>
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <bind>:
{
  802341:	f3 0f 1e fb          	endbr32 
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	e8 17 ff ff ff       	call   80226a <fd2sockid>
  802353:	85 c0                	test   %eax,%eax
  802355:	78 12                	js     802369 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	ff 75 10             	pushl  0x10(%ebp)
  80235d:	ff 75 0c             	pushl  0xc(%ebp)
  802360:	50                   	push   %eax
  802361:	e8 45 01 00 00       	call   8024ab <nsipc_bind>
  802366:	83 c4 10             	add    $0x10,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <shutdown>:
{
  80236b:	f3 0f 1e fb          	endbr32 
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	e8 ed fe ff ff       	call   80226a <fd2sockid>
  80237d:	85 c0                	test   %eax,%eax
  80237f:	78 0f                	js     802390 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  802381:	83 ec 08             	sub    $0x8,%esp
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	50                   	push   %eax
  802388:	e8 57 01 00 00       	call   8024e4 <nsipc_shutdown>
  80238d:	83 c4 10             	add    $0x10,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <connect>:
{
  802392:	f3 0f 1e fb          	endbr32 
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	e8 c6 fe ff ff       	call   80226a <fd2sockid>
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	78 12                	js     8023ba <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	ff 75 10             	pushl  0x10(%ebp)
  8023ae:	ff 75 0c             	pushl  0xc(%ebp)
  8023b1:	50                   	push   %eax
  8023b2:	e8 71 01 00 00       	call   802528 <nsipc_connect>
  8023b7:	83 c4 10             	add    $0x10,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <listen>:
{
  8023bc:	f3 0f 1e fb          	endbr32 
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	e8 9c fe ff ff       	call   80226a <fd2sockid>
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 0f                	js     8023e1 <listen+0x25>
	return nsipc_listen(r, backlog);
  8023d2:	83 ec 08             	sub    $0x8,%esp
  8023d5:	ff 75 0c             	pushl  0xc(%ebp)
  8023d8:	50                   	push   %eax
  8023d9:	e8 83 01 00 00       	call   802561 <nsipc_listen>
  8023de:	83 c4 10             	add    $0x10,%esp
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <socket>:

int
socket(int domain, int type, int protocol)
{
  8023e3:	f3 0f 1e fb          	endbr32 
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023ed:	ff 75 10             	pushl  0x10(%ebp)
  8023f0:	ff 75 0c             	pushl  0xc(%ebp)
  8023f3:	ff 75 08             	pushl  0x8(%ebp)
  8023f6:	e8 65 02 00 00       	call   802660 <nsipc_socket>
  8023fb:	83 c4 10             	add    $0x10,%esp
  8023fe:	85 c0                	test   %eax,%eax
  802400:	78 05                	js     802407 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802402:	e8 93 fe ff ff       	call   80229a <alloc_sockfd>
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	53                   	push   %ebx
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802412:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  802419:	74 26                	je     802441 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80241b:	6a 07                	push   $0x7
  80241d:	68 00 70 80 00       	push   $0x807000
  802422:	53                   	push   %ebx
  802423:	ff 35 1c 50 80 00    	pushl  0x80501c
  802429:	e8 c4 f4 ff ff       	call   8018f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80242e:	83 c4 0c             	add    $0xc,%esp
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	e8 42 f4 ff ff       	call   80187e <ipc_recv>
}
  80243c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80243f:	c9                   	leave  
  802440:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802441:	83 ec 0c             	sub    $0xc,%esp
  802444:	6a 02                	push   $0x2
  802446:	e8 ff f4 ff ff       	call   80194a <ipc_find_env>
  80244b:	a3 1c 50 80 00       	mov    %eax,0x80501c
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	eb c6                	jmp    80241b <nsipc+0x12>

00802455 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802455:	f3 0f 1e fb          	endbr32 
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	56                   	push   %esi
  80245d:	53                   	push   %ebx
  80245e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802469:	8b 06                	mov    (%esi),%eax
  80246b:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802470:	b8 01 00 00 00       	mov    $0x1,%eax
  802475:	e8 8f ff ff ff       	call   802409 <nsipc>
  80247a:	89 c3                	mov    %eax,%ebx
  80247c:	85 c0                	test   %eax,%eax
  80247e:	79 09                	jns    802489 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802480:	89 d8                	mov    %ebx,%eax
  802482:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802485:	5b                   	pop    %ebx
  802486:	5e                   	pop    %esi
  802487:	5d                   	pop    %ebp
  802488:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	ff 35 10 70 80 00    	pushl  0x807010
  802492:	68 00 70 80 00       	push   $0x807000
  802497:	ff 75 0c             	pushl  0xc(%ebp)
  80249a:	e8 e1 eb ff ff       	call   801080 <memmove>
		*addrlen = ret->ret_addrlen;
  80249f:	a1 10 70 80 00       	mov    0x807010,%eax
  8024a4:	89 06                	mov    %eax,(%esi)
  8024a6:	83 c4 10             	add    $0x10,%esp
	return r;
  8024a9:	eb d5                	jmp    802480 <nsipc_accept+0x2b>

008024ab <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024ab:	f3 0f 1e fb          	endbr32 
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	53                   	push   %ebx
  8024b3:	83 ec 08             	sub    $0x8,%esp
  8024b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024c1:	53                   	push   %ebx
  8024c2:	ff 75 0c             	pushl  0xc(%ebp)
  8024c5:	68 04 70 80 00       	push   $0x807004
  8024ca:	e8 b1 eb ff ff       	call   801080 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024cf:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8024d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8024da:	e8 2a ff ff ff       	call   802409 <nsipc>
}
  8024df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8024e4:	f3 0f 1e fb          	endbr32 
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8024f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f9:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8024fe:	b8 03 00 00 00       	mov    $0x3,%eax
  802503:	e8 01 ff ff ff       	call   802409 <nsipc>
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <nsipc_close>:

int
nsipc_close(int s)
{
  80250a:	f3 0f 1e fb          	endbr32 
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80251c:	b8 04 00 00 00       	mov    $0x4,%eax
  802521:	e8 e3 fe ff ff       	call   802409 <nsipc>
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802528:	f3 0f 1e fb          	endbr32 
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	53                   	push   %ebx
  802530:	83 ec 08             	sub    $0x8,%esp
  802533:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80253e:	53                   	push   %ebx
  80253f:	ff 75 0c             	pushl  0xc(%ebp)
  802542:	68 04 70 80 00       	push   $0x807004
  802547:	e8 34 eb ff ff       	call   801080 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80254c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802552:	b8 05 00 00 00       	mov    $0x5,%eax
  802557:	e8 ad fe ff ff       	call   802409 <nsipc>
}
  80255c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802561:	f3 0f 1e fb          	endbr32 
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802573:	8b 45 0c             	mov    0xc(%ebp),%eax
  802576:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80257b:	b8 06 00 00 00       	mov    $0x6,%eax
  802580:	e8 84 fe ff ff       	call   802409 <nsipc>
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802587:	f3 0f 1e fb          	endbr32 
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	56                   	push   %esi
  80258f:	53                   	push   %ebx
  802590:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80259b:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8025a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8025a4:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8025a9:	b8 07 00 00 00       	mov    $0x7,%eax
  8025ae:	e8 56 fe ff ff       	call   802409 <nsipc>
  8025b3:	89 c3                	mov    %eax,%ebx
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	78 26                	js     8025df <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8025b9:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8025bf:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8025c4:	0f 4e c6             	cmovle %esi,%eax
  8025c7:	39 c3                	cmp    %eax,%ebx
  8025c9:	7f 1d                	jg     8025e8 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	53                   	push   %ebx
  8025cf:	68 00 70 80 00       	push   $0x807000
  8025d4:	ff 75 0c             	pushl  0xc(%ebp)
  8025d7:	e8 a4 ea ff ff       	call   801080 <memmove>
  8025dc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8025df:	89 d8                	mov    %ebx,%eax
  8025e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025e4:	5b                   	pop    %ebx
  8025e5:	5e                   	pop    %esi
  8025e6:	5d                   	pop    %ebp
  8025e7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8025e8:	68 97 35 80 00       	push   $0x803597
  8025ed:	68 5f 35 80 00       	push   $0x80355f
  8025f2:	6a 62                	push   $0x62
  8025f4:	68 ac 35 80 00       	push   $0x8035ac
  8025f9:	e8 db e1 ff ff       	call   8007d9 <_panic>

008025fe <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025fe:	f3 0f 1e fb          	endbr32 
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	53                   	push   %ebx
  802606:	83 ec 04             	sub    $0x4,%esp
  802609:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802614:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80261a:	7f 2e                	jg     80264a <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	53                   	push   %ebx
  802620:	ff 75 0c             	pushl  0xc(%ebp)
  802623:	68 0c 70 80 00       	push   $0x80700c
  802628:	e8 53 ea ff ff       	call   801080 <memmove>
	nsipcbuf.send.req_size = size;
  80262d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802633:	8b 45 14             	mov    0x14(%ebp),%eax
  802636:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80263b:	b8 08 00 00 00       	mov    $0x8,%eax
  802640:	e8 c4 fd ff ff       	call   802409 <nsipc>
}
  802645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802648:	c9                   	leave  
  802649:	c3                   	ret    
	assert(size < 1600);
  80264a:	68 b8 35 80 00       	push   $0x8035b8
  80264f:	68 5f 35 80 00       	push   $0x80355f
  802654:	6a 6d                	push   $0x6d
  802656:	68 ac 35 80 00       	push   $0x8035ac
  80265b:	e8 79 e1 ff ff       	call   8007d9 <_panic>

00802660 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802660:	f3 0f 1e fb          	endbr32 
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802672:	8b 45 0c             	mov    0xc(%ebp),%eax
  802675:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80267a:	8b 45 10             	mov    0x10(%ebp),%eax
  80267d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802682:	b8 09 00 00 00       	mov    $0x9,%eax
  802687:	e8 7d fd ff ff       	call   802409 <nsipc>
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80268e:	f3 0f 1e fb          	endbr32 
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	56                   	push   %esi
  802696:	53                   	push   %ebx
  802697:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 f6 f2 ff ff       	call   80199b <fd2data>
  8026a5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026a7:	83 c4 08             	add    $0x8,%esp
  8026aa:	68 c4 35 80 00       	push   $0x8035c4
  8026af:	53                   	push   %ebx
  8026b0:	e8 15 e8 ff ff       	call   800eca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026b5:	8b 46 04             	mov    0x4(%esi),%eax
  8026b8:	2b 06                	sub    (%esi),%eax
  8026ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8026c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026c7:	00 00 00 
	stat->st_dev = &devpipe;
  8026ca:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8026d1:	40 80 00 
	return 0;
}
  8026d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026dc:	5b                   	pop    %ebx
  8026dd:	5e                   	pop    %esi
  8026de:	5d                   	pop    %ebp
  8026df:	c3                   	ret    

008026e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026e0:	f3 0f 1e fb          	endbr32 
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	53                   	push   %ebx
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026ee:	53                   	push   %ebx
  8026ef:	6a 00                	push   $0x0
  8026f1:	e8 a3 ec ff ff       	call   801399 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026f6:	89 1c 24             	mov    %ebx,(%esp)
  8026f9:	e8 9d f2 ff ff       	call   80199b <fd2data>
  8026fe:	83 c4 08             	add    $0x8,%esp
  802701:	50                   	push   %eax
  802702:	6a 00                	push   $0x0
  802704:	e8 90 ec ff ff       	call   801399 <sys_page_unmap>
}
  802709:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <_pipeisclosed>:
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	57                   	push   %edi
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	83 ec 1c             	sub    $0x1c,%esp
  802717:	89 c7                	mov    %eax,%edi
  802719:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80271b:	a1 20 50 80 00       	mov    0x805020,%eax
  802720:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	57                   	push   %edi
  802727:	e8 02 05 00 00       	call   802c2e <pageref>
  80272c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80272f:	89 34 24             	mov    %esi,(%esp)
  802732:	e8 f7 04 00 00       	call   802c2e <pageref>
		nn = thisenv->env_runs;
  802737:	8b 15 20 50 80 00    	mov    0x805020,%edx
  80273d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802740:	83 c4 10             	add    $0x10,%esp
  802743:	39 cb                	cmp    %ecx,%ebx
  802745:	74 1b                	je     802762 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802747:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80274a:	75 cf                	jne    80271b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80274c:	8b 42 58             	mov    0x58(%edx),%eax
  80274f:	6a 01                	push   $0x1
  802751:	50                   	push   %eax
  802752:	53                   	push   %ebx
  802753:	68 cb 35 80 00       	push   $0x8035cb
  802758:	e8 63 e1 ff ff       	call   8008c0 <cprintf>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	eb b9                	jmp    80271b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802762:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802765:	0f 94 c0             	sete   %al
  802768:	0f b6 c0             	movzbl %al,%eax
}
  80276b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80276e:	5b                   	pop    %ebx
  80276f:	5e                   	pop    %esi
  802770:	5f                   	pop    %edi
  802771:	5d                   	pop    %ebp
  802772:	c3                   	ret    

00802773 <devpipe_write>:
{
  802773:	f3 0f 1e fb          	endbr32 
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
  80277a:	57                   	push   %edi
  80277b:	56                   	push   %esi
  80277c:	53                   	push   %ebx
  80277d:	83 ec 28             	sub    $0x28,%esp
  802780:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802783:	56                   	push   %esi
  802784:	e8 12 f2 ff ff       	call   80199b <fd2data>
  802789:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80278b:	83 c4 10             	add    $0x10,%esp
  80278e:	bf 00 00 00 00       	mov    $0x0,%edi
  802793:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802796:	74 4f                	je     8027e7 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802798:	8b 43 04             	mov    0x4(%ebx),%eax
  80279b:	8b 0b                	mov    (%ebx),%ecx
  80279d:	8d 51 20             	lea    0x20(%ecx),%edx
  8027a0:	39 d0                	cmp    %edx,%eax
  8027a2:	72 14                	jb     8027b8 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8027a4:	89 da                	mov    %ebx,%edx
  8027a6:	89 f0                	mov    %esi,%eax
  8027a8:	e8 61 ff ff ff       	call   80270e <_pipeisclosed>
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	75 3b                	jne    8027ec <devpipe_write+0x79>
			sys_yield();
  8027b1:	e8 33 eb ff ff       	call   8012e9 <sys_yield>
  8027b6:	eb e0                	jmp    802798 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027bb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8027bf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8027c2:	89 c2                	mov    %eax,%edx
  8027c4:	c1 fa 1f             	sar    $0x1f,%edx
  8027c7:	89 d1                	mov    %edx,%ecx
  8027c9:	c1 e9 1b             	shr    $0x1b,%ecx
  8027cc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8027cf:	83 e2 1f             	and    $0x1f,%edx
  8027d2:	29 ca                	sub    %ecx,%edx
  8027d4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8027d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027dc:	83 c0 01             	add    $0x1,%eax
  8027df:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8027e2:	83 c7 01             	add    $0x1,%edi
  8027e5:	eb ac                	jmp    802793 <devpipe_write+0x20>
	return i;
  8027e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ea:	eb 05                	jmp    8027f1 <devpipe_write+0x7e>
				return 0;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f4:	5b                   	pop    %ebx
  8027f5:	5e                   	pop    %esi
  8027f6:	5f                   	pop    %edi
  8027f7:	5d                   	pop    %ebp
  8027f8:	c3                   	ret    

008027f9 <devpipe_read>:
{
  8027f9:	f3 0f 1e fb          	endbr32 
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	57                   	push   %edi
  802801:	56                   	push   %esi
  802802:	53                   	push   %ebx
  802803:	83 ec 18             	sub    $0x18,%esp
  802806:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802809:	57                   	push   %edi
  80280a:	e8 8c f1 ff ff       	call   80199b <fd2data>
  80280f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	be 00 00 00 00       	mov    $0x0,%esi
  802819:	3b 75 10             	cmp    0x10(%ebp),%esi
  80281c:	75 14                	jne    802832 <devpipe_read+0x39>
	return i;
  80281e:	8b 45 10             	mov    0x10(%ebp),%eax
  802821:	eb 02                	jmp    802825 <devpipe_read+0x2c>
				return i;
  802823:	89 f0                	mov    %esi,%eax
}
  802825:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802828:	5b                   	pop    %ebx
  802829:	5e                   	pop    %esi
  80282a:	5f                   	pop    %edi
  80282b:	5d                   	pop    %ebp
  80282c:	c3                   	ret    
			sys_yield();
  80282d:	e8 b7 ea ff ff       	call   8012e9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802832:	8b 03                	mov    (%ebx),%eax
  802834:	3b 43 04             	cmp    0x4(%ebx),%eax
  802837:	75 18                	jne    802851 <devpipe_read+0x58>
			if (i > 0)
  802839:	85 f6                	test   %esi,%esi
  80283b:	75 e6                	jne    802823 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80283d:	89 da                	mov    %ebx,%edx
  80283f:	89 f8                	mov    %edi,%eax
  802841:	e8 c8 fe ff ff       	call   80270e <_pipeisclosed>
  802846:	85 c0                	test   %eax,%eax
  802848:	74 e3                	je     80282d <devpipe_read+0x34>
				return 0;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
  80284f:	eb d4                	jmp    802825 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802851:	99                   	cltd   
  802852:	c1 ea 1b             	shr    $0x1b,%edx
  802855:	01 d0                	add    %edx,%eax
  802857:	83 e0 1f             	and    $0x1f,%eax
  80285a:	29 d0                	sub    %edx,%eax
  80285c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802864:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802867:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80286a:	83 c6 01             	add    $0x1,%esi
  80286d:	eb aa                	jmp    802819 <devpipe_read+0x20>

0080286f <pipe>:
{
  80286f:	f3 0f 1e fb          	endbr32 
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	56                   	push   %esi
  802877:	53                   	push   %ebx
  802878:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80287b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287e:	50                   	push   %eax
  80287f:	e8 32 f1 ff ff       	call   8019b6 <fd_alloc>
  802884:	89 c3                	mov    %eax,%ebx
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	85 c0                	test   %eax,%eax
  80288b:	0f 88 23 01 00 00    	js     8029b4 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 07 04 00 00       	push   $0x407
  802899:	ff 75 f4             	pushl  -0xc(%ebp)
  80289c:	6a 00                	push   $0x0
  80289e:	e8 69 ea ff ff       	call   80130c <sys_page_alloc>
  8028a3:	89 c3                	mov    %eax,%ebx
  8028a5:	83 c4 10             	add    $0x10,%esp
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 88 04 01 00 00    	js     8029b4 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8028b0:	83 ec 0c             	sub    $0xc,%esp
  8028b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028b6:	50                   	push   %eax
  8028b7:	e8 fa f0 ff ff       	call   8019b6 <fd_alloc>
  8028bc:	89 c3                	mov    %eax,%ebx
  8028be:	83 c4 10             	add    $0x10,%esp
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	0f 88 db 00 00 00    	js     8029a4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 07 04 00 00       	push   $0x407
  8028d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8028d4:	6a 00                	push   $0x0
  8028d6:	e8 31 ea ff ff       	call   80130c <sys_page_alloc>
  8028db:	89 c3                	mov    %eax,%ebx
  8028dd:	83 c4 10             	add    $0x10,%esp
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	0f 88 bc 00 00 00    	js     8029a4 <pipe+0x135>
	va = fd2data(fd0);
  8028e8:	83 ec 0c             	sub    $0xc,%esp
  8028eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8028ee:	e8 a8 f0 ff ff       	call   80199b <fd2data>
  8028f3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028f5:	83 c4 0c             	add    $0xc,%esp
  8028f8:	68 07 04 00 00       	push   $0x407
  8028fd:	50                   	push   %eax
  8028fe:	6a 00                	push   $0x0
  802900:	e8 07 ea ff ff       	call   80130c <sys_page_alloc>
  802905:	89 c3                	mov    %eax,%ebx
  802907:	83 c4 10             	add    $0x10,%esp
  80290a:	85 c0                	test   %eax,%eax
  80290c:	0f 88 82 00 00 00    	js     802994 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802912:	83 ec 0c             	sub    $0xc,%esp
  802915:	ff 75 f0             	pushl  -0x10(%ebp)
  802918:	e8 7e f0 ff ff       	call   80199b <fd2data>
  80291d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802924:	50                   	push   %eax
  802925:	6a 00                	push   $0x0
  802927:	56                   	push   %esi
  802928:	6a 00                	push   $0x0
  80292a:	e8 24 ea ff ff       	call   801353 <sys_page_map>
  80292f:	89 c3                	mov    %eax,%ebx
  802931:	83 c4 20             	add    $0x20,%esp
  802934:	85 c0                	test   %eax,%eax
  802936:	78 4e                	js     802986 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802938:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80293d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802940:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802942:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802945:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80294c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80295b:	83 ec 0c             	sub    $0xc,%esp
  80295e:	ff 75 f4             	pushl  -0xc(%ebp)
  802961:	e8 21 f0 ff ff       	call   801987 <fd2num>
  802966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802969:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80296b:	83 c4 04             	add    $0x4,%esp
  80296e:	ff 75 f0             	pushl  -0x10(%ebp)
  802971:	e8 11 f0 ff ff       	call   801987 <fd2num>
  802976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802979:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80297c:	83 c4 10             	add    $0x10,%esp
  80297f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802984:	eb 2e                	jmp    8029b4 <pipe+0x145>
	sys_page_unmap(0, va);
  802986:	83 ec 08             	sub    $0x8,%esp
  802989:	56                   	push   %esi
  80298a:	6a 00                	push   $0x0
  80298c:	e8 08 ea ff ff       	call   801399 <sys_page_unmap>
  802991:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802994:	83 ec 08             	sub    $0x8,%esp
  802997:	ff 75 f0             	pushl  -0x10(%ebp)
  80299a:	6a 00                	push   $0x0
  80299c:	e8 f8 e9 ff ff       	call   801399 <sys_page_unmap>
  8029a1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8029a4:	83 ec 08             	sub    $0x8,%esp
  8029a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8029aa:	6a 00                	push   $0x0
  8029ac:	e8 e8 e9 ff ff       	call   801399 <sys_page_unmap>
  8029b1:	83 c4 10             	add    $0x10,%esp
}
  8029b4:	89 d8                	mov    %ebx,%eax
  8029b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029b9:	5b                   	pop    %ebx
  8029ba:	5e                   	pop    %esi
  8029bb:	5d                   	pop    %ebp
  8029bc:	c3                   	ret    

008029bd <pipeisclosed>:
{
  8029bd:	f3 0f 1e fb          	endbr32 
  8029c1:	55                   	push   %ebp
  8029c2:	89 e5                	mov    %esp,%ebp
  8029c4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ca:	50                   	push   %eax
  8029cb:	ff 75 08             	pushl  0x8(%ebp)
  8029ce:	e8 39 f0 ff ff       	call   801a0c <fd_lookup>
  8029d3:	83 c4 10             	add    $0x10,%esp
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	78 18                	js     8029f2 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8029e0:	e8 b6 ef ff ff       	call   80199b <fd2data>
  8029e5:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	e8 1f fd ff ff       	call   80270e <_pipeisclosed>
  8029ef:	83 c4 10             	add    $0x10,%esp
}
  8029f2:	c9                   	leave  
  8029f3:	c3                   	ret    

008029f4 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029f4:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fd:	c3                   	ret    

008029fe <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029fe:	f3 0f 1e fb          	endbr32 
  802a02:	55                   	push   %ebp
  802a03:	89 e5                	mov    %esp,%ebp
  802a05:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802a08:	68 e3 35 80 00       	push   $0x8035e3
  802a0d:	ff 75 0c             	pushl  0xc(%ebp)
  802a10:	e8 b5 e4 ff ff       	call   800eca <strcpy>
	return 0;
}
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <devcons_write>:
{
  802a1c:	f3 0f 1e fb          	endbr32 
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	57                   	push   %edi
  802a24:	56                   	push   %esi
  802a25:	53                   	push   %ebx
  802a26:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802a2c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802a31:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802a37:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a3a:	73 31                	jae    802a6d <devcons_write+0x51>
		m = n - tot;
  802a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a3f:	29 f3                	sub    %esi,%ebx
  802a41:	83 fb 7f             	cmp    $0x7f,%ebx
  802a44:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802a49:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	53                   	push   %ebx
  802a50:	89 f0                	mov    %esi,%eax
  802a52:	03 45 0c             	add    0xc(%ebp),%eax
  802a55:	50                   	push   %eax
  802a56:	57                   	push   %edi
  802a57:	e8 24 e6 ff ff       	call   801080 <memmove>
		sys_cputs(buf, m);
  802a5c:	83 c4 08             	add    $0x8,%esp
  802a5f:	53                   	push   %ebx
  802a60:	57                   	push   %edi
  802a61:	e8 d6 e7 ff ff       	call   80123c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802a66:	01 de                	add    %ebx,%esi
  802a68:	83 c4 10             	add    $0x10,%esp
  802a6b:	eb ca                	jmp    802a37 <devcons_write+0x1b>
}
  802a6d:	89 f0                	mov    %esi,%eax
  802a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a72:	5b                   	pop    %ebx
  802a73:	5e                   	pop    %esi
  802a74:	5f                   	pop    %edi
  802a75:	5d                   	pop    %ebp
  802a76:	c3                   	ret    

00802a77 <devcons_read>:
{
  802a77:	f3 0f 1e fb          	endbr32 
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	83 ec 08             	sub    $0x8,%esp
  802a81:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802a86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a8a:	74 21                	je     802aad <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802a8c:	e8 cd e7 ff ff       	call   80125e <sys_cgetc>
  802a91:	85 c0                	test   %eax,%eax
  802a93:	75 07                	jne    802a9c <devcons_read+0x25>
		sys_yield();
  802a95:	e8 4f e8 ff ff       	call   8012e9 <sys_yield>
  802a9a:	eb f0                	jmp    802a8c <devcons_read+0x15>
	if (c < 0)
  802a9c:	78 0f                	js     802aad <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802a9e:	83 f8 04             	cmp    $0x4,%eax
  802aa1:	74 0c                	je     802aaf <devcons_read+0x38>
	*(char*)vbuf = c;
  802aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa6:	88 02                	mov    %al,(%edx)
	return 1;
  802aa8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    
		return 0;
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab4:	eb f7                	jmp    802aad <devcons_read+0x36>

00802ab6 <cputchar>:
{
  802ab6:	f3 0f 1e fb          	endbr32 
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
  802abd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802ac6:	6a 01                	push   $0x1
  802ac8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802acb:	50                   	push   %eax
  802acc:	e8 6b e7 ff ff       	call   80123c <sys_cputs>
}
  802ad1:	83 c4 10             	add    $0x10,%esp
  802ad4:	c9                   	leave  
  802ad5:	c3                   	ret    

00802ad6 <getchar>:
{
  802ad6:	f3 0f 1e fb          	endbr32 
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
  802add:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802ae0:	6a 01                	push   $0x1
  802ae2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ae5:	50                   	push   %eax
  802ae6:	6a 00                	push   $0x0
  802ae8:	e8 a7 f1 ff ff       	call   801c94 <read>
	if (r < 0)
  802aed:	83 c4 10             	add    $0x10,%esp
  802af0:	85 c0                	test   %eax,%eax
  802af2:	78 06                	js     802afa <getchar+0x24>
	if (r < 1)
  802af4:	74 06                	je     802afc <getchar+0x26>
	return c;
  802af6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    
		return -E_EOF;
  802afc:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b01:	eb f7                	jmp    802afa <getchar+0x24>

00802b03 <iscons>:
{
  802b03:	f3 0f 1e fb          	endbr32 
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b10:	50                   	push   %eax
  802b11:	ff 75 08             	pushl  0x8(%ebp)
  802b14:	e8 f3 ee ff ff       	call   801a0c <fd_lookup>
  802b19:	83 c4 10             	add    $0x10,%esp
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	78 11                	js     802b31 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802b29:	39 10                	cmp    %edx,(%eax)
  802b2b:	0f 94 c0             	sete   %al
  802b2e:	0f b6 c0             	movzbl %al,%eax
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <opencons>:
{
  802b33:	f3 0f 1e fb          	endbr32 
  802b37:	55                   	push   %ebp
  802b38:	89 e5                	mov    %esp,%ebp
  802b3a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802b3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b40:	50                   	push   %eax
  802b41:	e8 70 ee ff ff       	call   8019b6 <fd_alloc>
  802b46:	83 c4 10             	add    $0x10,%esp
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	78 3a                	js     802b87 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	68 07 04 00 00       	push   $0x407
  802b55:	ff 75 f4             	pushl  -0xc(%ebp)
  802b58:	6a 00                	push   $0x0
  802b5a:	e8 ad e7 ff ff       	call   80130c <sys_page_alloc>
  802b5f:	83 c4 10             	add    $0x10,%esp
  802b62:	85 c0                	test   %eax,%eax
  802b64:	78 21                	js     802b87 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802b6f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b7b:	83 ec 0c             	sub    $0xc,%esp
  802b7e:	50                   	push   %eax
  802b7f:	e8 03 ee ff ff       	call   801987 <fd2num>
  802b84:	83 c4 10             	add    $0x10,%esp
}
  802b87:	c9                   	leave  
  802b88:	c3                   	ret    

00802b89 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b89:	f3 0f 1e fb          	endbr32 
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
  802b90:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b93:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b9a:	74 0a                	je     802ba6 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802ba6:	a1 20 50 80 00       	mov    0x805020,%eax
  802bab:	8b 40 48             	mov    0x48(%eax),%eax
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	6a 07                	push   $0x7
  802bb3:	68 00 f0 bf ee       	push   $0xeebff000
  802bb8:	50                   	push   %eax
  802bb9:	e8 4e e7 ff ff       	call   80130c <sys_page_alloc>
  802bbe:	83 c4 10             	add    $0x10,%esp
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	75 31                	jne    802bf6 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802bc5:	a1 20 50 80 00       	mov    0x805020,%eax
  802bca:	8b 40 48             	mov    0x48(%eax),%eax
  802bcd:	83 ec 08             	sub    $0x8,%esp
  802bd0:	68 0a 2c 80 00       	push   $0x802c0a
  802bd5:	50                   	push   %eax
  802bd6:	e8 90 e8 ff ff       	call   80146b <sys_env_set_pgfault_upcall>
  802bdb:	83 c4 10             	add    $0x10,%esp
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 ba                	je     802b9c <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802be2:	83 ec 04             	sub    $0x4,%esp
  802be5:	68 18 36 80 00       	push   $0x803618
  802bea:	6a 24                	push   $0x24
  802bec:	68 46 36 80 00       	push   $0x803646
  802bf1:	e8 e3 db ff ff       	call   8007d9 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802bf6:	83 ec 04             	sub    $0x4,%esp
  802bf9:	68 f0 35 80 00       	push   $0x8035f0
  802bfe:	6a 21                	push   $0x21
  802c00:	68 46 36 80 00       	push   $0x803646
  802c05:	e8 cf db ff ff       	call   8007d9 <_panic>

00802c0a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c0a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c0b:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802c10:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c12:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802c15:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802c19:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802c1e:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802c22:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802c24:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802c27:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802c28:	83 c4 04             	add    $0x4,%esp
    popfl
  802c2b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802c2c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802c2d:	c3                   	ret    

00802c2e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c2e:	f3 0f 1e fb          	endbr32 
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c38:	89 c2                	mov    %eax,%edx
  802c3a:	c1 ea 16             	shr    $0x16,%edx
  802c3d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802c44:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802c49:	f6 c1 01             	test   $0x1,%cl
  802c4c:	74 1c                	je     802c6a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802c4e:	c1 e8 0c             	shr    $0xc,%eax
  802c51:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c58:	a8 01                	test   $0x1,%al
  802c5a:	74 0e                	je     802c6a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c5c:	c1 e8 0c             	shr    $0xc,%eax
  802c5f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802c66:	ef 
  802c67:	0f b7 d2             	movzwl %dx,%edx
}
  802c6a:	89 d0                	mov    %edx,%eax
  802c6c:	5d                   	pop    %ebp
  802c6d:	c3                   	ret    
  802c6e:	66 90                	xchg   %ax,%ax

00802c70 <__udivdi3>:
  802c70:	f3 0f 1e fb          	endbr32 
  802c74:	55                   	push   %ebp
  802c75:	57                   	push   %edi
  802c76:	56                   	push   %esi
  802c77:	53                   	push   %ebx
  802c78:	83 ec 1c             	sub    $0x1c,%esp
  802c7b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802c7f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802c83:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c87:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c8b:	85 d2                	test   %edx,%edx
  802c8d:	75 19                	jne    802ca8 <__udivdi3+0x38>
  802c8f:	39 f3                	cmp    %esi,%ebx
  802c91:	76 4d                	jbe    802ce0 <__udivdi3+0x70>
  802c93:	31 ff                	xor    %edi,%edi
  802c95:	89 e8                	mov    %ebp,%eax
  802c97:	89 f2                	mov    %esi,%edx
  802c99:	f7 f3                	div    %ebx
  802c9b:	89 fa                	mov    %edi,%edx
  802c9d:	83 c4 1c             	add    $0x1c,%esp
  802ca0:	5b                   	pop    %ebx
  802ca1:	5e                   	pop    %esi
  802ca2:	5f                   	pop    %edi
  802ca3:	5d                   	pop    %ebp
  802ca4:	c3                   	ret    
  802ca5:	8d 76 00             	lea    0x0(%esi),%esi
  802ca8:	39 f2                	cmp    %esi,%edx
  802caa:	76 14                	jbe    802cc0 <__udivdi3+0x50>
  802cac:	31 ff                	xor    %edi,%edi
  802cae:	31 c0                	xor    %eax,%eax
  802cb0:	89 fa                	mov    %edi,%edx
  802cb2:	83 c4 1c             	add    $0x1c,%esp
  802cb5:	5b                   	pop    %ebx
  802cb6:	5e                   	pop    %esi
  802cb7:	5f                   	pop    %edi
  802cb8:	5d                   	pop    %ebp
  802cb9:	c3                   	ret    
  802cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cc0:	0f bd fa             	bsr    %edx,%edi
  802cc3:	83 f7 1f             	xor    $0x1f,%edi
  802cc6:	75 48                	jne    802d10 <__udivdi3+0xa0>
  802cc8:	39 f2                	cmp    %esi,%edx
  802cca:	72 06                	jb     802cd2 <__udivdi3+0x62>
  802ccc:	31 c0                	xor    %eax,%eax
  802cce:	39 eb                	cmp    %ebp,%ebx
  802cd0:	77 de                	ja     802cb0 <__udivdi3+0x40>
  802cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  802cd7:	eb d7                	jmp    802cb0 <__udivdi3+0x40>
  802cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ce0:	89 d9                	mov    %ebx,%ecx
  802ce2:	85 db                	test   %ebx,%ebx
  802ce4:	75 0b                	jne    802cf1 <__udivdi3+0x81>
  802ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ceb:	31 d2                	xor    %edx,%edx
  802ced:	f7 f3                	div    %ebx
  802cef:	89 c1                	mov    %eax,%ecx
  802cf1:	31 d2                	xor    %edx,%edx
  802cf3:	89 f0                	mov    %esi,%eax
  802cf5:	f7 f1                	div    %ecx
  802cf7:	89 c6                	mov    %eax,%esi
  802cf9:	89 e8                	mov    %ebp,%eax
  802cfb:	89 f7                	mov    %esi,%edi
  802cfd:	f7 f1                	div    %ecx
  802cff:	89 fa                	mov    %edi,%edx
  802d01:	83 c4 1c             	add    $0x1c,%esp
  802d04:	5b                   	pop    %ebx
  802d05:	5e                   	pop    %esi
  802d06:	5f                   	pop    %edi
  802d07:	5d                   	pop    %ebp
  802d08:	c3                   	ret    
  802d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d10:	89 f9                	mov    %edi,%ecx
  802d12:	b8 20 00 00 00       	mov    $0x20,%eax
  802d17:	29 f8                	sub    %edi,%eax
  802d19:	d3 e2                	shl    %cl,%edx
  802d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d1f:	89 c1                	mov    %eax,%ecx
  802d21:	89 da                	mov    %ebx,%edx
  802d23:	d3 ea                	shr    %cl,%edx
  802d25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d29:	09 d1                	or     %edx,%ecx
  802d2b:	89 f2                	mov    %esi,%edx
  802d2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d31:	89 f9                	mov    %edi,%ecx
  802d33:	d3 e3                	shl    %cl,%ebx
  802d35:	89 c1                	mov    %eax,%ecx
  802d37:	d3 ea                	shr    %cl,%edx
  802d39:	89 f9                	mov    %edi,%ecx
  802d3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802d3f:	89 eb                	mov    %ebp,%ebx
  802d41:	d3 e6                	shl    %cl,%esi
  802d43:	89 c1                	mov    %eax,%ecx
  802d45:	d3 eb                	shr    %cl,%ebx
  802d47:	09 de                	or     %ebx,%esi
  802d49:	89 f0                	mov    %esi,%eax
  802d4b:	f7 74 24 08          	divl   0x8(%esp)
  802d4f:	89 d6                	mov    %edx,%esi
  802d51:	89 c3                	mov    %eax,%ebx
  802d53:	f7 64 24 0c          	mull   0xc(%esp)
  802d57:	39 d6                	cmp    %edx,%esi
  802d59:	72 15                	jb     802d70 <__udivdi3+0x100>
  802d5b:	89 f9                	mov    %edi,%ecx
  802d5d:	d3 e5                	shl    %cl,%ebp
  802d5f:	39 c5                	cmp    %eax,%ebp
  802d61:	73 04                	jae    802d67 <__udivdi3+0xf7>
  802d63:	39 d6                	cmp    %edx,%esi
  802d65:	74 09                	je     802d70 <__udivdi3+0x100>
  802d67:	89 d8                	mov    %ebx,%eax
  802d69:	31 ff                	xor    %edi,%edi
  802d6b:	e9 40 ff ff ff       	jmp    802cb0 <__udivdi3+0x40>
  802d70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d73:	31 ff                	xor    %edi,%edi
  802d75:	e9 36 ff ff ff       	jmp    802cb0 <__udivdi3+0x40>
  802d7a:	66 90                	xchg   %ax,%ax
  802d7c:	66 90                	xchg   %ax,%ax
  802d7e:	66 90                	xchg   %ax,%ax

00802d80 <__umoddi3>:
  802d80:	f3 0f 1e fb          	endbr32 
  802d84:	55                   	push   %ebp
  802d85:	57                   	push   %edi
  802d86:	56                   	push   %esi
  802d87:	53                   	push   %ebx
  802d88:	83 ec 1c             	sub    $0x1c,%esp
  802d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d93:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	75 19                	jne    802db8 <__umoddi3+0x38>
  802d9f:	39 df                	cmp    %ebx,%edi
  802da1:	76 5d                	jbe    802e00 <__umoddi3+0x80>
  802da3:	89 f0                	mov    %esi,%eax
  802da5:	89 da                	mov    %ebx,%edx
  802da7:	f7 f7                	div    %edi
  802da9:	89 d0                	mov    %edx,%eax
  802dab:	31 d2                	xor    %edx,%edx
  802dad:	83 c4 1c             	add    $0x1c,%esp
  802db0:	5b                   	pop    %ebx
  802db1:	5e                   	pop    %esi
  802db2:	5f                   	pop    %edi
  802db3:	5d                   	pop    %ebp
  802db4:	c3                   	ret    
  802db5:	8d 76 00             	lea    0x0(%esi),%esi
  802db8:	89 f2                	mov    %esi,%edx
  802dba:	39 d8                	cmp    %ebx,%eax
  802dbc:	76 12                	jbe    802dd0 <__umoddi3+0x50>
  802dbe:	89 f0                	mov    %esi,%eax
  802dc0:	89 da                	mov    %ebx,%edx
  802dc2:	83 c4 1c             	add    $0x1c,%esp
  802dc5:	5b                   	pop    %ebx
  802dc6:	5e                   	pop    %esi
  802dc7:	5f                   	pop    %edi
  802dc8:	5d                   	pop    %ebp
  802dc9:	c3                   	ret    
  802dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dd0:	0f bd e8             	bsr    %eax,%ebp
  802dd3:	83 f5 1f             	xor    $0x1f,%ebp
  802dd6:	75 50                	jne    802e28 <__umoddi3+0xa8>
  802dd8:	39 d8                	cmp    %ebx,%eax
  802dda:	0f 82 e0 00 00 00    	jb     802ec0 <__umoddi3+0x140>
  802de0:	89 d9                	mov    %ebx,%ecx
  802de2:	39 f7                	cmp    %esi,%edi
  802de4:	0f 86 d6 00 00 00    	jbe    802ec0 <__umoddi3+0x140>
  802dea:	89 d0                	mov    %edx,%eax
  802dec:	89 ca                	mov    %ecx,%edx
  802dee:	83 c4 1c             	add    $0x1c,%esp
  802df1:	5b                   	pop    %ebx
  802df2:	5e                   	pop    %esi
  802df3:	5f                   	pop    %edi
  802df4:	5d                   	pop    %ebp
  802df5:	c3                   	ret    
  802df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dfd:	8d 76 00             	lea    0x0(%esi),%esi
  802e00:	89 fd                	mov    %edi,%ebp
  802e02:	85 ff                	test   %edi,%edi
  802e04:	75 0b                	jne    802e11 <__umoddi3+0x91>
  802e06:	b8 01 00 00 00       	mov    $0x1,%eax
  802e0b:	31 d2                	xor    %edx,%edx
  802e0d:	f7 f7                	div    %edi
  802e0f:	89 c5                	mov    %eax,%ebp
  802e11:	89 d8                	mov    %ebx,%eax
  802e13:	31 d2                	xor    %edx,%edx
  802e15:	f7 f5                	div    %ebp
  802e17:	89 f0                	mov    %esi,%eax
  802e19:	f7 f5                	div    %ebp
  802e1b:	89 d0                	mov    %edx,%eax
  802e1d:	31 d2                	xor    %edx,%edx
  802e1f:	eb 8c                	jmp    802dad <__umoddi3+0x2d>
  802e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e28:	89 e9                	mov    %ebp,%ecx
  802e2a:	ba 20 00 00 00       	mov    $0x20,%edx
  802e2f:	29 ea                	sub    %ebp,%edx
  802e31:	d3 e0                	shl    %cl,%eax
  802e33:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e37:	89 d1                	mov    %edx,%ecx
  802e39:	89 f8                	mov    %edi,%eax
  802e3b:	d3 e8                	shr    %cl,%eax
  802e3d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e41:	89 54 24 04          	mov    %edx,0x4(%esp)
  802e45:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e49:	09 c1                	or     %eax,%ecx
  802e4b:	89 d8                	mov    %ebx,%eax
  802e4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e51:	89 e9                	mov    %ebp,%ecx
  802e53:	d3 e7                	shl    %cl,%edi
  802e55:	89 d1                	mov    %edx,%ecx
  802e57:	d3 e8                	shr    %cl,%eax
  802e59:	89 e9                	mov    %ebp,%ecx
  802e5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e5f:	d3 e3                	shl    %cl,%ebx
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	89 d1                	mov    %edx,%ecx
  802e65:	89 f0                	mov    %esi,%eax
  802e67:	d3 e8                	shr    %cl,%eax
  802e69:	89 e9                	mov    %ebp,%ecx
  802e6b:	89 fa                	mov    %edi,%edx
  802e6d:	d3 e6                	shl    %cl,%esi
  802e6f:	09 d8                	or     %ebx,%eax
  802e71:	f7 74 24 08          	divl   0x8(%esp)
  802e75:	89 d1                	mov    %edx,%ecx
  802e77:	89 f3                	mov    %esi,%ebx
  802e79:	f7 64 24 0c          	mull   0xc(%esp)
  802e7d:	89 c6                	mov    %eax,%esi
  802e7f:	89 d7                	mov    %edx,%edi
  802e81:	39 d1                	cmp    %edx,%ecx
  802e83:	72 06                	jb     802e8b <__umoddi3+0x10b>
  802e85:	75 10                	jne    802e97 <__umoddi3+0x117>
  802e87:	39 c3                	cmp    %eax,%ebx
  802e89:	73 0c                	jae    802e97 <__umoddi3+0x117>
  802e8b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802e8f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802e93:	89 d7                	mov    %edx,%edi
  802e95:	89 c6                	mov    %eax,%esi
  802e97:	89 ca                	mov    %ecx,%edx
  802e99:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e9e:	29 f3                	sub    %esi,%ebx
  802ea0:	19 fa                	sbb    %edi,%edx
  802ea2:	89 d0                	mov    %edx,%eax
  802ea4:	d3 e0                	shl    %cl,%eax
  802ea6:	89 e9                	mov    %ebp,%ecx
  802ea8:	d3 eb                	shr    %cl,%ebx
  802eaa:	d3 ea                	shr    %cl,%edx
  802eac:	09 d8                	or     %ebx,%eax
  802eae:	83 c4 1c             	add    $0x1c,%esp
  802eb1:	5b                   	pop    %ebx
  802eb2:	5e                   	pop    %esi
  802eb3:	5f                   	pop    %edi
  802eb4:	5d                   	pop    %ebp
  802eb5:	c3                   	ret    
  802eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ebd:	8d 76 00             	lea    0x0(%esi),%esi
  802ec0:	29 fe                	sub    %edi,%esi
  802ec2:	19 c3                	sbb    %eax,%ebx
  802ec4:	89 f2                	mov    %esi,%edx
  802ec6:	89 d9                	mov    %ebx,%ecx
  802ec8:	e9 1d ff ff ff       	jmp    802dea <__umoddi3+0x6a>
