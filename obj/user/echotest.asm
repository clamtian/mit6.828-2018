
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 b2 04 00 00       	call   8004e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 60 28 80 00       	push   $0x802860
  80003f:	e8 a4 05 00 00       	call   8005e8 <cprintf>
	exit();
  800044:	e8 e4 04 00 00       	call   80052d <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <umain>:

void umain(int argc, char **argv)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 58             	sub    $0x58,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  80005b:	68 64 28 80 00       	push   $0x802864
  800060:	e8 83 05 00 00       	call   8005e8 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800065:	c7 04 24 74 28 80 00 	movl   $0x802874,(%esp)
  80006c:	e8 35 04 00 00       	call   8004a6 <inet_addr>
  800071:	83 c4 0c             	add    $0xc,%esp
  800074:	50                   	push   %eax
  800075:	68 74 28 80 00       	push   $0x802874
  80007a:	68 7e 28 80 00       	push   $0x80287e
  80007f:	e8 64 05 00 00       	call   8005e8 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800084:	83 c4 0c             	add    $0xc,%esp
  800087:	6a 06                	push   $0x6
  800089:	6a 01                	push   $0x1
  80008b:	6a 02                	push   $0x2
  80008d:	e8 32 1c 00 00       	call   801cc4 <socket>
  800092:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 c0                	test   %eax,%eax
  80009a:	0f 88 b4 00 00 00    	js     800154 <umain+0x106>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 ab 28 80 00       	push   $0x8028ab
  8000a8:	e8 3b 05 00 00       	call   8005e8 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000ad:	83 c4 0c             	add    $0xc,%esp
  8000b0:	6a 10                	push   $0x10
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000b7:	53                   	push   %ebx
  8000b8:	e8 9f 0c 00 00       	call   800d5c <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000bd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000c1:	c7 04 24 74 28 80 00 	movl   $0x802874,(%esp)
  8000c8:	e8 d9 03 00 00       	call   8004a6 <inet_addr>
  8000cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000d0:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000d7:	e8 a1 01 00 00       	call   80027d <htons>
  8000dc:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  8000e0:	c7 04 24 ba 28 80 00 	movl   $0x8028ba,(%esp)
  8000e7:	e8 fc 04 00 00       	call   8005e8 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  8000ec:	83 c4 0c             	add    $0xc,%esp
  8000ef:	6a 10                	push   $0x10
  8000f1:	53                   	push   %ebx
  8000f2:	ff 75 b4             	pushl  -0x4c(%ebp)
  8000f5:	e8 79 1b 00 00       	call   801c73 <connect>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	85 c0                	test   %eax,%eax
  8000ff:	78 62                	js     800163 <umain+0x115>
		die("Failed to connect with server");

	cprintf("connected to server\n");
  800101:	83 ec 0c             	sub    $0xc,%esp
  800104:	68 f5 28 80 00       	push   $0x8028f5
  800109:	e8 da 04 00 00       	call   8005e8 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80010e:	83 c4 04             	add    $0x4,%esp
  800111:	ff 35 00 30 80 00    	pushl  0x803000
  800117:	e8 93 0a 00 00       	call   800baf <strlen>
  80011c:	89 c7                	mov    %eax,%edi
  80011e:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  800121:	83 c4 0c             	add    $0xc,%esp
  800124:	50                   	push   %eax
  800125:	ff 35 00 30 80 00    	pushl  0x803000
  80012b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80012e:	e8 18 15 00 00       	call   80164b <write>
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	39 c7                	cmp    %eax,%edi
  800138:	75 35                	jne    80016f <umain+0x121>
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 0a 29 80 00       	push   $0x80290a
  800142:	e8 a1 04 00 00       	call   8005e8 <cprintf>
	while (received < echolen) {
  800147:	83 c4 10             	add    $0x10,%esp
	int received = 0;
  80014a:	be 00 00 00 00       	mov    $0x0,%esi
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80014f:	8d 7d b8             	lea    -0x48(%ebp),%edi
	while (received < echolen) {
  800152:	eb 3a                	jmp    80018e <umain+0x140>
		die("Failed to create socket");
  800154:	b8 93 28 80 00       	mov    $0x802893,%eax
  800159:	e8 d5 fe ff ff       	call   800033 <die>
  80015e:	e9 3d ff ff ff       	jmp    8000a0 <umain+0x52>
		die("Failed to connect with server");
  800163:	b8 d7 28 80 00       	mov    $0x8028d7,%eax
  800168:	e8 c6 fe ff ff       	call   800033 <die>
  80016d:	eb 92                	jmp    800101 <umain+0xb3>
		die("Mismatch in number of sent bytes");
  80016f:	b8 24 29 80 00       	mov    $0x802924,%eax
  800174:	e8 ba fe ff ff       	call   800033 <die>
  800179:	eb bf                	jmp    80013a <umain+0xec>
			die("Failed to receive bytes from server");
		}
		received += bytes;
  80017b:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  80017d:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	57                   	push   %edi
  800186:	e8 5d 04 00 00       	call   8005e8 <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp
	while (received < echolen) {
  80018e:	3b 75 b0             	cmp    -0x50(%ebp),%esi
  800191:	73 23                	jae    8001b6 <umain+0x168>
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	6a 1f                	push   $0x1f
  800198:	57                   	push   %edi
  800199:	ff 75 b4             	pushl  -0x4c(%ebp)
  80019c:	e8 d4 13 00 00       	call   801575 <read>
  8001a1:	89 c3                	mov    %eax,%ebx
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	85 c0                	test   %eax,%eax
  8001a8:	7f d1                	jg     80017b <umain+0x12d>
			die("Failed to receive bytes from server");
  8001aa:	b8 48 29 80 00       	mov    $0x802948,%eax
  8001af:	e8 7f fe ff ff       	call   800033 <die>
  8001b4:	eb c5                	jmp    80017b <umain+0x12d>
	}
	cprintf("\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 14 29 80 00       	push   $0x802914
  8001be:	e8 25 04 00 00       	call   8005e8 <cprintf>

	close(sock);
  8001c3:	83 c4 04             	add    $0x4,%esp
  8001c6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8001c9:	e8 5d 12 00 00       	call   80142b <close>
}
  8001ce:	83 c4 10             	add    $0x10,%esp
  8001d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d4:	5b                   	pop    %ebx
  8001d5:	5e                   	pop    %esi
  8001d6:	5f                   	pop    %edi
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001d9:	f3 0f 1e fb          	endbr32 
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	57                   	push   %edi
  8001e1:	56                   	push   %esi
  8001e2:	53                   	push   %ebx
  8001e3:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001ec:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8001f0:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8001f3:	bf 00 40 80 00       	mov    $0x804000,%edi
  8001f8:	eb 2e                	jmp    800228 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8001fa:	0f b6 c8             	movzbl %al,%ecx
  8001fd:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800202:	88 0a                	mov    %cl,(%edx)
  800204:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800207:	83 e8 01             	sub    $0x1,%eax
  80020a:	3c ff                	cmp    $0xff,%al
  80020c:	75 ec                	jne    8001fa <inet_ntoa+0x21>
  80020e:	0f b6 db             	movzbl %bl,%ebx
  800211:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  800213:	8d 7b 01             	lea    0x1(%ebx),%edi
  800216:	c6 03 2e             	movb   $0x2e,(%ebx)
  800219:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80021c:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800220:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800224:	3c 04                	cmp    $0x4,%al
  800226:	74 45                	je     80026d <inet_ntoa+0x94>
  rp = str;
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  80022d:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  800230:	0f b6 ca             	movzbl %dl,%ecx
  800233:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800236:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800239:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80023c:	66 c1 e8 0b          	shr    $0xb,%ax
  800240:	88 06                	mov    %al,(%esi)
  800242:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  800244:	83 c3 01             	add    $0x1,%ebx
  800247:	0f b6 c9             	movzbl %cl,%ecx
  80024a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80024d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800250:	01 c0                	add    %eax,%eax
  800252:	89 d1                	mov    %edx,%ecx
  800254:	29 c1                	sub    %eax,%ecx
  800256:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800258:	83 c0 30             	add    $0x30,%eax
  80025b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80025e:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  800262:	80 fa 09             	cmp    $0x9,%dl
  800265:	77 c6                	ja     80022d <inet_ntoa+0x54>
  800267:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800269:	89 d8                	mov    %ebx,%eax
  80026b:	eb 9a                	jmp    800207 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  80026d:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800270:	b8 00 40 80 00       	mov    $0x804000,%eax
  800275:	83 c4 18             	add    $0x18,%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80027d:	f3 0f 1e fb          	endbr32 
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800284:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800288:	66 c1 c0 08          	rol    $0x8,%ax
}
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    

0080028e <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  80028e:	f3 0f 1e fb          	endbr32 
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800295:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800299:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80029f:	f3 0f 1e fb          	endbr32 
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002a9:	89 d0                	mov    %edx,%eax
  8002ab:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002ae:	89 d1                	mov    %edx,%ecx
  8002b0:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002b3:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002b5:	89 d1                	mov    %edx,%ecx
  8002b7:	c1 e1 08             	shl    $0x8,%ecx
  8002ba:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002c0:	09 c8                	or     %ecx,%eax
  8002c2:	c1 ea 08             	shr    $0x8,%edx
  8002c5:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002cb:	09 d0                	or     %edx,%eax
}
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <inet_aton>:
{
  8002cf:	f3 0f 1e fb          	endbr32 
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	57                   	push   %edi
  8002d7:	56                   	push   %esi
  8002d8:	53                   	push   %ebx
  8002d9:	83 ec 2c             	sub    $0x2c,%esp
  8002dc:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8002df:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  8002e2:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8002e5:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8002e8:	e9 a7 00 00 00       	jmp    800394 <inet_aton+0xc5>
      c = *++cp;
  8002ed:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  8002f1:	89 c1                	mov    %eax,%ecx
  8002f3:	83 e1 df             	and    $0xffffffdf,%ecx
  8002f6:	80 f9 58             	cmp    $0x58,%cl
  8002f9:	74 10                	je     80030b <inet_aton+0x3c>
      c = *++cp;
  8002fb:	83 c2 01             	add    $0x1,%edx
  8002fe:	0f be c0             	movsbl %al,%eax
        base = 8;
  800301:	be 08 00 00 00       	mov    $0x8,%esi
  800306:	e9 a3 00 00 00       	jmp    8003ae <inet_aton+0xdf>
        c = *++cp;
  80030b:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80030f:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800312:	be 10 00 00 00       	mov    $0x10,%esi
  800317:	e9 92 00 00 00       	jmp    8003ae <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80031c:	83 fe 10             	cmp    $0x10,%esi
  80031f:	75 4d                	jne    80036e <inet_aton+0x9f>
  800321:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800324:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800327:	89 c1                	mov    %eax,%ecx
  800329:	83 e1 df             	and    $0xffffffdf,%ecx
  80032c:	83 e9 41             	sub    $0x41,%ecx
  80032f:	80 f9 05             	cmp    $0x5,%cl
  800332:	77 3a                	ja     80036e <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800334:	c1 e3 04             	shl    $0x4,%ebx
  800337:	83 c0 0a             	add    $0xa,%eax
  80033a:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80033e:	19 c9                	sbb    %ecx,%ecx
  800340:	83 e1 20             	and    $0x20,%ecx
  800343:	83 c1 41             	add    $0x41,%ecx
  800346:	29 c8                	sub    %ecx,%eax
  800348:	09 c3                	or     %eax,%ebx
        c = *++cp;
  80034a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034d:	0f be 40 01          	movsbl 0x1(%eax),%eax
  800351:	83 c2 01             	add    $0x1,%edx
  800354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800357:	89 c7                	mov    %eax,%edi
  800359:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80035c:	80 f9 09             	cmp    $0x9,%cl
  80035f:	77 bb                	ja     80031c <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  800361:	0f af de             	imul   %esi,%ebx
  800364:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800368:	0f be 42 01          	movsbl 0x1(%edx),%eax
  80036c:	eb e3                	jmp    800351 <inet_aton+0x82>
    if (c == '.') {
  80036e:	83 f8 2e             	cmp    $0x2e,%eax
  800371:	75 42                	jne    8003b5 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800373:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800376:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800379:	39 c6                	cmp    %eax,%esi
  80037b:	0f 84 16 01 00 00    	je     800497 <inet_aton+0x1c8>
      *pp++ = val;
  800381:	83 c6 04             	add    $0x4,%esi
  800384:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800387:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  80038a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038d:	8d 50 01             	lea    0x1(%eax),%edx
  800390:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  800394:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800397:	80 f9 09             	cmp    $0x9,%cl
  80039a:	0f 87 f0 00 00 00    	ja     800490 <inet_aton+0x1c1>
    base = 10;
  8003a0:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003a5:	83 f8 30             	cmp    $0x30,%eax
  8003a8:	0f 84 3f ff ff ff    	je     8002ed <inet_aton+0x1e>
    base = 10;
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	eb 9f                	jmp    800354 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	74 29                	je     8003e2 <inet_aton+0x113>
    return (0);
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003be:	89 f9                	mov    %edi,%ecx
  8003c0:	80 f9 1f             	cmp    $0x1f,%cl
  8003c3:	0f 86 d3 00 00 00    	jbe    80049c <inet_aton+0x1cd>
  8003c9:	84 c0                	test   %al,%al
  8003cb:	0f 88 cb 00 00 00    	js     80049c <inet_aton+0x1cd>
  8003d1:	83 f8 20             	cmp    $0x20,%eax
  8003d4:	74 0c                	je     8003e2 <inet_aton+0x113>
  8003d6:	83 e8 09             	sub    $0x9,%eax
  8003d9:	83 f8 04             	cmp    $0x4,%eax
  8003dc:	0f 87 ba 00 00 00    	ja     80049c <inet_aton+0x1cd>
  n = pp - parts + 1;
  8003e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8003e5:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8003e8:	29 c6                	sub    %eax,%esi
  8003ea:	89 f0                	mov    %esi,%eax
  8003ec:	c1 f8 02             	sar    $0x2,%eax
  8003ef:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  8003f2:	83 f8 02             	cmp    $0x2,%eax
  8003f5:	74 7a                	je     800471 <inet_aton+0x1a2>
  8003f7:	83 fa 03             	cmp    $0x3,%edx
  8003fa:	7f 49                	jg     800445 <inet_aton+0x176>
  8003fc:	85 d2                	test   %edx,%edx
  8003fe:	0f 84 98 00 00 00    	je     80049c <inet_aton+0x1cd>
  800404:	83 fa 02             	cmp    $0x2,%edx
  800407:	75 19                	jne    800422 <inet_aton+0x153>
      return (0);
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80040e:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800414:	0f 87 82 00 00 00    	ja     80049c <inet_aton+0x1cd>
    val |= parts[0] << 24;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	c1 e0 18             	shl    $0x18,%eax
  800420:	09 c3                	or     %eax,%ebx
  return (1);
  800422:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042b:	74 6f                	je     80049c <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	53                   	push   %ebx
  800431:	e8 69 fe ff ff       	call   80029f <htonl>
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	8b 75 0c             	mov    0xc(%ebp),%esi
  80043c:	89 06                	mov    %eax,(%esi)
  return (1);
  80043e:	ba 01 00 00 00       	mov    $0x1,%edx
  800443:	eb 57                	jmp    80049c <inet_aton+0x1cd>
  switch (n) {
  800445:	83 fa 04             	cmp    $0x4,%edx
  800448:	75 d8                	jne    800422 <inet_aton+0x153>
      return (0);
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80044f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800455:	77 45                	ja     80049c <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800457:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045a:	c1 e0 18             	shl    $0x18,%eax
  80045d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800460:	c1 e2 10             	shl    $0x10,%edx
  800463:	09 d0                	or     %edx,%eax
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	c1 e2 08             	shl    $0x8,%edx
  80046b:	09 d0                	or     %edx,%eax
  80046d:	09 c3                	or     %eax,%ebx
    break;
  80046f:	eb b1                	jmp    800422 <inet_aton+0x153>
      return (0);
  800471:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800476:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80047c:	77 1e                	ja     80049c <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800481:	c1 e0 18             	shl    $0x18,%eax
  800484:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800487:	c1 e2 10             	shl    $0x10,%edx
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c3                	or     %eax,%ebx
    break;
  80048e:	eb 92                	jmp    800422 <inet_aton+0x153>
      return (0);
  800490:	ba 00 00 00 00       	mov    $0x0,%edx
  800495:	eb 05                	jmp    80049c <inet_aton+0x1cd>
        return (0);
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80049c:	89 d0                	mov    %edx,%eax
  80049e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <inet_addr>:
{
  8004a6:	f3 0f 1e fb          	endbr32 
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004b3:	50                   	push   %eax
  8004b4:	ff 75 08             	pushl  0x8(%ebp)
  8004b7:	e8 13 fe ff ff       	call   8002cf <inet_aton>
  8004bc:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004c6:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004ca:	c9                   	leave  
  8004cb:	c3                   	ret    

008004cc <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004cc:	f3 0f 1e fb          	endbr32 
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004d6:	ff 75 08             	pushl  0x8(%ebp)
  8004d9:	e8 c1 fd ff ff       	call   80029f <htonl>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004e3:	f3 0f 1e fb          	endbr32 
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004ef:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004f2:	e8 f7 0a 00 00       	call   800fee <sys_getenvid>
  8004f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004fc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8004ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800504:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800509:	85 db                	test   %ebx,%ebx
  80050b:	7e 07                	jle    800514 <libmain+0x31>
		binaryname = argv[0];
  80050d:	8b 06                	mov    (%esi),%eax
  80050f:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	56                   	push   %esi
  800518:	53                   	push   %ebx
  800519:	e8 30 fb ff ff       	call   80004e <umain>

	// exit gracefully
	exit();
  80051e:	e8 0a 00 00 00       	call   80052d <exit>
}
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800529:	5b                   	pop    %ebx
  80052a:	5e                   	pop    %esi
  80052b:	5d                   	pop    %ebp
  80052c:	c3                   	ret    

0080052d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80052d:	f3 0f 1e fb          	endbr32 
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800537:	e8 20 0f 00 00       	call   80145c <close_all>
	sys_env_destroy(0);
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	6a 00                	push   $0x0
  800541:	e8 63 0a 00 00       	call   800fa9 <sys_env_destroy>
}
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80054b:	f3 0f 1e fb          	endbr32 
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	53                   	push   %ebx
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800559:	8b 13                	mov    (%ebx),%edx
  80055b:	8d 42 01             	lea    0x1(%edx),%eax
  80055e:	89 03                	mov    %eax,(%ebx)
  800560:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800563:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800567:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056c:	74 09                	je     800577 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80056e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	68 ff 00 00 00       	push   $0xff
  80057f:	8d 43 08             	lea    0x8(%ebx),%eax
  800582:	50                   	push   %eax
  800583:	e8 dc 09 00 00       	call   800f64 <sys_cputs>
		b->idx = 0;
  800588:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	eb db                	jmp    80056e <putch+0x23>

00800593 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800593:	f3 0f 1e fb          	endbr32 
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005a0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005a7:	00 00 00 
	b.cnt = 0;
  8005aa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005b1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	ff 75 08             	pushl  0x8(%ebp)
  8005ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c0:	50                   	push   %eax
  8005c1:	68 4b 05 80 00       	push   $0x80054b
  8005c6:	e8 20 01 00 00       	call   8006eb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005cb:	83 c4 08             	add    $0x8,%esp
  8005ce:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005d4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005da:	50                   	push   %eax
  8005db:	e8 84 09 00 00       	call   800f64 <sys_cputs>

	return b.cnt;
}
  8005e0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8005e8:	f3 0f 1e fb          	endbr32 
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005f2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8005f5:	50                   	push   %eax
  8005f6:	ff 75 08             	pushl  0x8(%ebp)
  8005f9:	e8 95 ff ff ff       	call   800593 <vcprintf>
	va_end(ap);

	return cnt;
}
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	57                   	push   %edi
  800604:	56                   	push   %esi
  800605:	53                   	push   %ebx
  800606:	83 ec 1c             	sub    $0x1c,%esp
  800609:	89 c7                	mov    %eax,%edi
  80060b:	89 d6                	mov    %edx,%esi
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 55 0c             	mov    0xc(%ebp),%edx
  800613:	89 d1                	mov    %edx,%ecx
  800615:	89 c2                	mov    %eax,%edx
  800617:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80061d:	8b 45 10             	mov    0x10(%ebp),%eax
  800620:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800632:	72 3e                	jb     800672 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800634:	83 ec 0c             	sub    $0xc,%esp
  800637:	ff 75 18             	pushl  0x18(%ebp)
  80063a:	83 eb 01             	sub    $0x1,%ebx
  80063d:	53                   	push   %ebx
  80063e:	50                   	push   %eax
  80063f:	83 ec 08             	sub    $0x8,%esp
  800642:	ff 75 e4             	pushl  -0x1c(%ebp)
  800645:	ff 75 e0             	pushl  -0x20(%ebp)
  800648:	ff 75 dc             	pushl  -0x24(%ebp)
  80064b:	ff 75 d8             	pushl  -0x28(%ebp)
  80064e:	e8 ad 1f 00 00       	call   802600 <__udivdi3>
  800653:	83 c4 18             	add    $0x18,%esp
  800656:	52                   	push   %edx
  800657:	50                   	push   %eax
  800658:	89 f2                	mov    %esi,%edx
  80065a:	89 f8                	mov    %edi,%eax
  80065c:	e8 9f ff ff ff       	call   800600 <printnum>
  800661:	83 c4 20             	add    $0x20,%esp
  800664:	eb 13                	jmp    800679 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	56                   	push   %esi
  80066a:	ff 75 18             	pushl  0x18(%ebp)
  80066d:	ff d7                	call   *%edi
  80066f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800672:	83 eb 01             	sub    $0x1,%ebx
  800675:	85 db                	test   %ebx,%ebx
  800677:	7f ed                	jg     800666 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	56                   	push   %esi
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	ff 75 e4             	pushl  -0x1c(%ebp)
  800683:	ff 75 e0             	pushl  -0x20(%ebp)
  800686:	ff 75 dc             	pushl  -0x24(%ebp)
  800689:	ff 75 d8             	pushl  -0x28(%ebp)
  80068c:	e8 7f 20 00 00       	call   802710 <__umoddi3>
  800691:	83 c4 14             	add    $0x14,%esp
  800694:	0f be 80 76 29 80 00 	movsbl 0x802976(%eax),%eax
  80069b:	50                   	push   %eax
  80069c:	ff d7                	call   *%edi
}
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a4:	5b                   	pop    %ebx
  8006a5:	5e                   	pop    %esi
  8006a6:	5f                   	pop    %edi
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a9:	f3 0f 1e fb          	endbr32 
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006b3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	3b 50 04             	cmp    0x4(%eax),%edx
  8006bc:	73 0a                	jae    8006c8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8006be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006c1:	89 08                	mov    %ecx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	88 02                	mov    %al,(%edx)
}
  8006c8:	5d                   	pop    %ebp
  8006c9:	c3                   	ret    

008006ca <printfmt>:
{
  8006ca:	f3 0f 1e fb          	endbr32 
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006d4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006d7:	50                   	push   %eax
  8006d8:	ff 75 10             	pushl  0x10(%ebp)
  8006db:	ff 75 0c             	pushl  0xc(%ebp)
  8006de:	ff 75 08             	pushl  0x8(%ebp)
  8006e1:	e8 05 00 00 00       	call   8006eb <vprintfmt>
}
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	c9                   	leave  
  8006ea:	c3                   	ret    

008006eb <vprintfmt>:
{
  8006eb:	f3 0f 1e fb          	endbr32 
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	57                   	push   %edi
  8006f3:	56                   	push   %esi
  8006f4:	53                   	push   %ebx
  8006f5:	83 ec 3c             	sub    $0x3c,%esp
  8006f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006fe:	8b 7d 10             	mov    0x10(%ebp),%edi
  800701:	e9 8e 03 00 00       	jmp    800a94 <vprintfmt+0x3a9>
		padc = ' ';
  800706:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80070a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800711:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800718:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800724:	8d 47 01             	lea    0x1(%edi),%eax
  800727:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072a:	0f b6 17             	movzbl (%edi),%edx
  80072d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800730:	3c 55                	cmp    $0x55,%al
  800732:	0f 87 df 03 00 00    	ja     800b17 <vprintfmt+0x42c>
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	3e ff 24 85 c0 2a 80 	notrack jmp *0x802ac0(,%eax,4)
  800742:	00 
  800743:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800746:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80074a:	eb d8                	jmp    800724 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80074c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80074f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800753:	eb cf                	jmp    800724 <vprintfmt+0x39>
  800755:	0f b6 d2             	movzbl %dl,%edx
  800758:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80075b:	b8 00 00 00 00       	mov    $0x0,%eax
  800760:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800763:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800766:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80076a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80076d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800770:	83 f9 09             	cmp    $0x9,%ecx
  800773:	77 55                	ja     8007ca <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800775:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800778:	eb e9                	jmp    800763 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 04             	lea    0x4(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80078e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800792:	79 90                	jns    800724 <vprintfmt+0x39>
				width = precision, precision = -1;
  800794:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80079a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007a1:	eb 81                	jmp    800724 <vprintfmt+0x39>
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ad:	0f 49 d0             	cmovns %eax,%edx
  8007b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007b6:	e9 69 ff ff ff       	jmp    800724 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007be:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007c5:	e9 5a ff ff ff       	jmp    800724 <vprintfmt+0x39>
  8007ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	eb bc                	jmp    80078e <vprintfmt+0xa3>
			lflag++;
  8007d2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007d8:	e9 47 ff ff ff       	jmp    800724 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 78 04             	lea    0x4(%eax),%edi
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	53                   	push   %ebx
  8007e7:	ff 30                	pushl  (%eax)
  8007e9:	ff d6                	call   *%esi
			break;
  8007eb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8007ee:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8007f1:	e9 9b 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8d 78 04             	lea    0x4(%eax),%edi
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	99                   	cltd   
  8007ff:	31 d0                	xor    %edx,%eax
  800801:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800803:	83 f8 0f             	cmp    $0xf,%eax
  800806:	7f 23                	jg     80082b <vprintfmt+0x140>
  800808:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  80080f:	85 d2                	test   %edx,%edx
  800811:	74 18                	je     80082b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800813:	52                   	push   %edx
  800814:	68 55 2d 80 00       	push   $0x802d55
  800819:	53                   	push   %ebx
  80081a:	56                   	push   %esi
  80081b:	e8 aa fe ff ff       	call   8006ca <printfmt>
  800820:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800823:	89 7d 14             	mov    %edi,0x14(%ebp)
  800826:	e9 66 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80082b:	50                   	push   %eax
  80082c:	68 8e 29 80 00       	push   $0x80298e
  800831:	53                   	push   %ebx
  800832:	56                   	push   %esi
  800833:	e8 92 fe ff ff       	call   8006ca <printfmt>
  800838:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80083b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80083e:	e9 4e 02 00 00       	jmp    800a91 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800851:	85 d2                	test   %edx,%edx
  800853:	b8 87 29 80 00       	mov    $0x802987,%eax
  800858:	0f 45 c2             	cmovne %edx,%eax
  80085b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80085e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800862:	7e 06                	jle    80086a <vprintfmt+0x17f>
  800864:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800868:	75 0d                	jne    800877 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80086a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80086d:	89 c7                	mov    %eax,%edi
  80086f:	03 45 e0             	add    -0x20(%ebp),%eax
  800872:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800875:	eb 55                	jmp    8008cc <vprintfmt+0x1e1>
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 d8             	pushl  -0x28(%ebp)
  80087d:	ff 75 cc             	pushl  -0x34(%ebp)
  800880:	e8 46 03 00 00       	call   800bcb <strnlen>
  800885:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800888:	29 c2                	sub    %eax,%edx
  80088a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800892:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800896:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800899:	85 ff                	test   %edi,%edi
  80089b:	7e 11                	jle    8008ae <vprintfmt+0x1c3>
					putch(padc, putdat);
  80089d:	83 ec 08             	sub    $0x8,%esp
  8008a0:	53                   	push   %ebx
  8008a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8008a4:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a6:	83 ef 01             	sub    $0x1,%edi
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	eb eb                	jmp    800899 <vprintfmt+0x1ae>
  8008ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	0f 49 c2             	cmovns %edx,%eax
  8008bb:	29 c2                	sub    %eax,%edx
  8008bd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008c0:	eb a8                	jmp    80086a <vprintfmt+0x17f>
					putch(ch, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	52                   	push   %edx
  8008c7:	ff d6                	call   *%esi
  8008c9:	83 c4 10             	add    $0x10,%esp
  8008cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008cf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d1:	83 c7 01             	add    $0x1,%edi
  8008d4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008d8:	0f be d0             	movsbl %al,%edx
  8008db:	85 d2                	test   %edx,%edx
  8008dd:	74 4b                	je     80092a <vprintfmt+0x23f>
  8008df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008e3:	78 06                	js     8008eb <vprintfmt+0x200>
  8008e5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8008e9:	78 1e                	js     800909 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8008eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008ef:	74 d1                	je     8008c2 <vprintfmt+0x1d7>
  8008f1:	0f be c0             	movsbl %al,%eax
  8008f4:	83 e8 20             	sub    $0x20,%eax
  8008f7:	83 f8 5e             	cmp    $0x5e,%eax
  8008fa:	76 c6                	jbe    8008c2 <vprintfmt+0x1d7>
					putch('?', putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 3f                	push   $0x3f
  800902:	ff d6                	call   *%esi
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	eb c3                	jmp    8008cc <vprintfmt+0x1e1>
  800909:	89 cf                	mov    %ecx,%edi
  80090b:	eb 0e                	jmp    80091b <vprintfmt+0x230>
				putch(' ', putdat);
  80090d:	83 ec 08             	sub    $0x8,%esp
  800910:	53                   	push   %ebx
  800911:	6a 20                	push   $0x20
  800913:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800915:	83 ef 01             	sub    $0x1,%edi
  800918:	83 c4 10             	add    $0x10,%esp
  80091b:	85 ff                	test   %edi,%edi
  80091d:	7f ee                	jg     80090d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80091f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800922:	89 45 14             	mov    %eax,0x14(%ebp)
  800925:	e9 67 01 00 00       	jmp    800a91 <vprintfmt+0x3a6>
  80092a:	89 cf                	mov    %ecx,%edi
  80092c:	eb ed                	jmp    80091b <vprintfmt+0x230>
	if (lflag >= 2)
  80092e:	83 f9 01             	cmp    $0x1,%ecx
  800931:	7f 1b                	jg     80094e <vprintfmt+0x263>
	else if (lflag)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 63                	je     80099a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80093f:	99                   	cltd   
  800940:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	8d 40 04             	lea    0x4(%eax),%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	eb 17                	jmp    800965 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8b 50 04             	mov    0x4(%eax),%edx
  800954:	8b 00                	mov    (%eax),%eax
  800956:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800959:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80095c:	8b 45 14             	mov    0x14(%ebp),%eax
  80095f:	8d 40 08             	lea    0x8(%eax),%eax
  800962:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800965:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800968:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80096b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800970:	85 c9                	test   %ecx,%ecx
  800972:	0f 89 ff 00 00 00    	jns    800a77 <vprintfmt+0x38c>
				putch('-', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	53                   	push   %ebx
  80097c:	6a 2d                	push   $0x2d
  80097e:	ff d6                	call   *%esi
				num = -(long long) num;
  800980:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800983:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800986:	f7 da                	neg    %edx
  800988:	83 d1 00             	adc    $0x0,%ecx
  80098b:	f7 d9                	neg    %ecx
  80098d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800990:	b8 0a 00 00 00       	mov    $0xa,%eax
  800995:	e9 dd 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009a2:	99                   	cltd   
  8009a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a9:	8d 40 04             	lea    0x4(%eax),%eax
  8009ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8009af:	eb b4                	jmp    800965 <vprintfmt+0x27a>
	if (lflag >= 2)
  8009b1:	83 f9 01             	cmp    $0x1,%ecx
  8009b4:	7f 1e                	jg     8009d4 <vprintfmt+0x2e9>
	else if (lflag)
  8009b6:	85 c9                	test   %ecx,%ecx
  8009b8:	74 32                	je     8009ec <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	8b 10                	mov    (%eax),%edx
  8009bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009c4:	8d 40 04             	lea    0x4(%eax),%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009ca:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009cf:	e9 a3 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d7:	8b 10                	mov    (%eax),%edx
  8009d9:	8b 48 04             	mov    0x4(%eax),%ecx
  8009dc:	8d 40 08             	lea    0x8(%eax),%eax
  8009df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8009e7:	e9 8b 00 00 00       	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8009ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ef:	8b 10                	mov    (%eax),%edx
  8009f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009f6:	8d 40 04             	lea    0x4(%eax),%eax
  8009f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009fc:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a01:	eb 74                	jmp    800a77 <vprintfmt+0x38c>
	if (lflag >= 2)
  800a03:	83 f9 01             	cmp    $0x1,%ecx
  800a06:	7f 1b                	jg     800a23 <vprintfmt+0x338>
	else if (lflag)
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 2c                	je     800a38 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	8b 10                	mov    (%eax),%edx
  800a11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a1c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a21:	eb 54                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	8b 10                	mov    (%eax),%edx
  800a28:	8b 48 04             	mov    0x4(%eax),%ecx
  800a2b:	8d 40 08             	lea    0x8(%eax),%eax
  800a2e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a31:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a36:	eb 3f                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 10                	mov    (%eax),%edx
  800a3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a42:	8d 40 04             	lea    0x4(%eax),%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a48:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a4d:	eb 28                	jmp    800a77 <vprintfmt+0x38c>
			putch('0', putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	53                   	push   %ebx
  800a53:	6a 30                	push   $0x30
  800a55:	ff d6                	call   *%esi
			putch('x', putdat);
  800a57:	83 c4 08             	add    $0x8,%esp
  800a5a:	53                   	push   %ebx
  800a5b:	6a 78                	push   $0x78
  800a5d:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	8b 10                	mov    (%eax),%edx
  800a64:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a69:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a6c:	8d 40 04             	lea    0x4(%eax),%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a72:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a77:	83 ec 0c             	sub    $0xc,%esp
  800a7a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a7e:	57                   	push   %edi
  800a7f:	ff 75 e0             	pushl  -0x20(%ebp)
  800a82:	50                   	push   %eax
  800a83:	51                   	push   %ecx
  800a84:	52                   	push   %edx
  800a85:	89 da                	mov    %ebx,%edx
  800a87:	89 f0                	mov    %esi,%eax
  800a89:	e8 72 fb ff ff       	call   800600 <printnum>
			break;
  800a8e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800a91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a94:	83 c7 01             	add    $0x1,%edi
  800a97:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800a9b:	83 f8 25             	cmp    $0x25,%eax
  800a9e:	0f 84 62 fc ff ff    	je     800706 <vprintfmt+0x1b>
			if (ch == '\0')
  800aa4:	85 c0                	test   %eax,%eax
  800aa6:	0f 84 8b 00 00 00    	je     800b37 <vprintfmt+0x44c>
			putch(ch, putdat);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	53                   	push   %ebx
  800ab0:	50                   	push   %eax
  800ab1:	ff d6                	call   *%esi
  800ab3:	83 c4 10             	add    $0x10,%esp
  800ab6:	eb dc                	jmp    800a94 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ab8:	83 f9 01             	cmp    $0x1,%ecx
  800abb:	7f 1b                	jg     800ad8 <vprintfmt+0x3ed>
	else if (lflag)
  800abd:	85 c9                	test   %ecx,%ecx
  800abf:	74 2c                	je     800aed <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	8b 10                	mov    (%eax),%edx
  800ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800acb:	8d 40 04             	lea    0x4(%eax),%eax
  800ace:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ad1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800ad6:	eb 9f                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	8b 10                	mov    (%eax),%edx
  800add:	8b 48 04             	mov    0x4(%eax),%ecx
  800ae0:	8d 40 08             	lea    0x8(%eax),%eax
  800ae3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800aeb:	eb 8a                	jmp    800a77 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	8b 10                	mov    (%eax),%edx
  800af2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af7:	8d 40 04             	lea    0x4(%eax),%eax
  800afa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800afd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b02:	e9 70 ff ff ff       	jmp    800a77 <vprintfmt+0x38c>
			putch(ch, putdat);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	53                   	push   %ebx
  800b0b:	6a 25                	push   $0x25
  800b0d:	ff d6                	call   *%esi
			break;
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	e9 7a ff ff ff       	jmp    800a91 <vprintfmt+0x3a6>
			putch('%', putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	53                   	push   %ebx
  800b1b:	6a 25                	push   $0x25
  800b1d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	89 f8                	mov    %edi,%eax
  800b24:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b28:	74 05                	je     800b2f <vprintfmt+0x444>
  800b2a:	83 e8 01             	sub    $0x1,%eax
  800b2d:	eb f5                	jmp    800b24 <vprintfmt+0x439>
  800b2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b32:	e9 5a ff ff ff       	jmp    800a91 <vprintfmt+0x3a6>
}
  800b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3a:	5b                   	pop    %ebx
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3f:	f3 0f 1e fb          	endbr32 
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b52:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b56:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b60:	85 c0                	test   %eax,%eax
  800b62:	74 26                	je     800b8a <vsnprintf+0x4b>
  800b64:	85 d2                	test   %edx,%edx
  800b66:	7e 22                	jle    800b8a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b68:	ff 75 14             	pushl  0x14(%ebp)
  800b6b:	ff 75 10             	pushl  0x10(%ebp)
  800b6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b71:	50                   	push   %eax
  800b72:	68 a9 06 80 00       	push   $0x8006a9
  800b77:	e8 6f fb ff ff       	call   8006eb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b7f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b85:	83 c4 10             	add    $0x10,%esp
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    
		return -E_INVAL;
  800b8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b8f:	eb f7                	jmp    800b88 <vsnprintf+0x49>

00800b91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b91:	f3 0f 1e fb          	endbr32 
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 10             	pushl  0x10(%ebp)
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 92 ff ff ff       	call   800b3f <vsnprintf>
	va_end(ap);

	return rc;
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bc2:	74 05                	je     800bc9 <strlen+0x1a>
		n++;
  800bc4:	83 c0 01             	add    $0x1,%eax
  800bc7:	eb f5                	jmp    800bbe <strlen+0xf>
	return n;
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bcb:	f3 0f 1e fb          	endbr32 
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	39 d0                	cmp    %edx,%eax
  800bdf:	74 0d                	je     800bee <strnlen+0x23>
  800be1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800be5:	74 05                	je     800bec <strnlen+0x21>
		n++;
  800be7:	83 c0 01             	add    $0x1,%eax
  800bea:	eb f1                	jmp    800bdd <strnlen+0x12>
  800bec:	89 c2                	mov    %eax,%edx
	return n;
}
  800bee:	89 d0                	mov    %edx,%eax
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	53                   	push   %ebx
  800bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c00:	b8 00 00 00 00       	mov    $0x0,%eax
  800c05:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c09:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c0c:	83 c0 01             	add    $0x1,%eax
  800c0f:	84 d2                	test   %dl,%dl
  800c11:	75 f2                	jne    800c05 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c13:	89 c8                	mov    %ecx,%eax
  800c15:	5b                   	pop    %ebx
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c18:	f3 0f 1e fb          	endbr32 
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 10             	sub    $0x10,%esp
  800c23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c26:	53                   	push   %ebx
  800c27:	e8 83 ff ff ff       	call   800baf <strlen>
  800c2c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	01 d8                	add    %ebx,%eax
  800c34:	50                   	push   %eax
  800c35:	e8 b8 ff ff ff       	call   800bf2 <strcpy>
	return dst;
}
  800c3a:	89 d8                	mov    %ebx,%eax
  800c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c3f:	c9                   	leave  
  800c40:	c3                   	ret    

00800c41 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c41:	f3 0f 1e fb          	endbr32 
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	8b 75 08             	mov    0x8(%ebp),%esi
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	89 f3                	mov    %esi,%ebx
  800c52:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	89 f0                	mov    %esi,%eax
  800c57:	39 d8                	cmp    %ebx,%eax
  800c59:	74 11                	je     800c6c <strncpy+0x2b>
		*dst++ = *src;
  800c5b:	83 c0 01             	add    $0x1,%eax
  800c5e:	0f b6 0a             	movzbl (%edx),%ecx
  800c61:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c64:	80 f9 01             	cmp    $0x1,%cl
  800c67:	83 da ff             	sbb    $0xffffffff,%edx
  800c6a:	eb eb                	jmp    800c57 <strncpy+0x16>
	}
	return ret;
}
  800c6c:	89 f0                	mov    %esi,%eax
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c72:	f3 0f 1e fb          	endbr32 
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 55 10             	mov    0x10(%ebp),%edx
  800c84:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c86:	85 d2                	test   %edx,%edx
  800c88:	74 21                	je     800cab <strlcpy+0x39>
  800c8a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800c8e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800c90:	39 c2                	cmp    %eax,%edx
  800c92:	74 14                	je     800ca8 <strlcpy+0x36>
  800c94:	0f b6 19             	movzbl (%ecx),%ebx
  800c97:	84 db                	test   %bl,%bl
  800c99:	74 0b                	je     800ca6 <strlcpy+0x34>
			*dst++ = *src++;
  800c9b:	83 c1 01             	add    $0x1,%ecx
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ca4:	eb ea                	jmp    800c90 <strlcpy+0x1e>
  800ca6:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ca8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cab:	29 f0                	sub    %esi,%eax
}
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb1:	f3 0f 1e fb          	endbr32 
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cbe:	0f b6 01             	movzbl (%ecx),%eax
  800cc1:	84 c0                	test   %al,%al
  800cc3:	74 0c                	je     800cd1 <strcmp+0x20>
  800cc5:	3a 02                	cmp    (%edx),%al
  800cc7:	75 08                	jne    800cd1 <strcmp+0x20>
		p++, q++;
  800cc9:	83 c1 01             	add    $0x1,%ecx
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	eb ed                	jmp    800cbe <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd1:	0f b6 c0             	movzbl %al,%eax
  800cd4:	0f b6 12             	movzbl (%edx),%edx
  800cd7:	29 d0                	sub    %edx,%eax
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cdb:	f3 0f 1e fb          	endbr32 
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	53                   	push   %ebx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cee:	eb 06                	jmp    800cf6 <strncmp+0x1b>
		n--, p++, q++;
  800cf0:	83 c0 01             	add    $0x1,%eax
  800cf3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800cf6:	39 d8                	cmp    %ebx,%eax
  800cf8:	74 16                	je     800d10 <strncmp+0x35>
  800cfa:	0f b6 08             	movzbl (%eax),%ecx
  800cfd:	84 c9                	test   %cl,%cl
  800cff:	74 04                	je     800d05 <strncmp+0x2a>
  800d01:	3a 0a                	cmp    (%edx),%cl
  800d03:	74 eb                	je     800cf0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d05:	0f b6 00             	movzbl (%eax),%eax
  800d08:	0f b6 12             	movzbl (%edx),%edx
  800d0b:	29 d0                	sub    %edx,%eax
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    
		return 0;
  800d10:	b8 00 00 00 00       	mov    $0x0,%eax
  800d15:	eb f6                	jmp    800d0d <strncmp+0x32>

00800d17 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d17:	f3 0f 1e fb          	endbr32 
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d25:	0f b6 10             	movzbl (%eax),%edx
  800d28:	84 d2                	test   %dl,%dl
  800d2a:	74 09                	je     800d35 <strchr+0x1e>
		if (*s == c)
  800d2c:	38 ca                	cmp    %cl,%dl
  800d2e:	74 0a                	je     800d3a <strchr+0x23>
	for (; *s; s++)
  800d30:	83 c0 01             	add    $0x1,%eax
  800d33:	eb f0                	jmp    800d25 <strchr+0xe>
			return (char *) s;
	return 0;
  800d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d3c:	f3 0f 1e fb          	endbr32 
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d4a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d4d:	38 ca                	cmp    %cl,%dl
  800d4f:	74 09                	je     800d5a <strfind+0x1e>
  800d51:	84 d2                	test   %dl,%dl
  800d53:	74 05                	je     800d5a <strfind+0x1e>
	for (; *s; s++)
  800d55:	83 c0 01             	add    $0x1,%eax
  800d58:	eb f0                	jmp    800d4a <strfind+0xe>
			break;
	return (char *) s;
}
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d5c:	f3 0f 1e fb          	endbr32 
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d6c:	85 c9                	test   %ecx,%ecx
  800d6e:	74 31                	je     800da1 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d70:	89 f8                	mov    %edi,%eax
  800d72:	09 c8                	or     %ecx,%eax
  800d74:	a8 03                	test   $0x3,%al
  800d76:	75 23                	jne    800d9b <memset+0x3f>
		c &= 0xFF;
  800d78:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d7c:	89 d3                	mov    %edx,%ebx
  800d7e:	c1 e3 08             	shl    $0x8,%ebx
  800d81:	89 d0                	mov    %edx,%eax
  800d83:	c1 e0 18             	shl    $0x18,%eax
  800d86:	89 d6                	mov    %edx,%esi
  800d88:	c1 e6 10             	shl    $0x10,%esi
  800d8b:	09 f0                	or     %esi,%eax
  800d8d:	09 c2                	or     %eax,%edx
  800d8f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d91:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d94:	89 d0                	mov    %edx,%eax
  800d96:	fc                   	cld    
  800d97:	f3 ab                	rep stos %eax,%es:(%edi)
  800d99:	eb 06                	jmp    800da1 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	fc                   	cld    
  800d9f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800da1:	89 f8                	mov    %edi,%eax
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800da8:	f3 0f 1e fb          	endbr32 
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dba:	39 c6                	cmp    %eax,%esi
  800dbc:	73 32                	jae    800df0 <memmove+0x48>
  800dbe:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc1:	39 c2                	cmp    %eax,%edx
  800dc3:	76 2b                	jbe    800df0 <memmove+0x48>
		s += n;
		d += n;
  800dc5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc8:	89 fe                	mov    %edi,%esi
  800dca:	09 ce                	or     %ecx,%esi
  800dcc:	09 d6                	or     %edx,%esi
  800dce:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dd4:	75 0e                	jne    800de4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dd6:	83 ef 04             	sub    $0x4,%edi
  800dd9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ddc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ddf:	fd                   	std    
  800de0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800de2:	eb 09                	jmp    800ded <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800de4:	83 ef 01             	sub    $0x1,%edi
  800de7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dea:	fd                   	std    
  800deb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ded:	fc                   	cld    
  800dee:	eb 1a                	jmp    800e0a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df0:	89 c2                	mov    %eax,%edx
  800df2:	09 ca                	or     %ecx,%edx
  800df4:	09 f2                	or     %esi,%edx
  800df6:	f6 c2 03             	test   $0x3,%dl
  800df9:	75 0a                	jne    800e05 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800dfb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	fc                   	cld    
  800e01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e03:	eb 05                	jmp    800e0a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e05:	89 c7                	mov    %eax,%edi
  800e07:	fc                   	cld    
  800e08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e0e:	f3 0f 1e fb          	endbr32 
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e18:	ff 75 10             	pushl  0x10(%ebp)
  800e1b:	ff 75 0c             	pushl  0xc(%ebp)
  800e1e:	ff 75 08             	pushl  0x8(%ebp)
  800e21:	e8 82 ff ff ff       	call   800da8 <memmove>
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e28:	f3 0f 1e fb          	endbr32 
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	89 c6                	mov    %eax,%esi
  800e39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3c:	39 f0                	cmp    %esi,%eax
  800e3e:	74 1c                	je     800e5c <memcmp+0x34>
		if (*s1 != *s2)
  800e40:	0f b6 08             	movzbl (%eax),%ecx
  800e43:	0f b6 1a             	movzbl (%edx),%ebx
  800e46:	38 d9                	cmp    %bl,%cl
  800e48:	75 08                	jne    800e52 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e4a:	83 c0 01             	add    $0x1,%eax
  800e4d:	83 c2 01             	add    $0x1,%edx
  800e50:	eb ea                	jmp    800e3c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e52:	0f b6 c1             	movzbl %cl,%eax
  800e55:	0f b6 db             	movzbl %bl,%ebx
  800e58:	29 d8                	sub    %ebx,%eax
  800e5a:	eb 05                	jmp    800e61 <memcmp+0x39>
	}

	return 0;
  800e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e65:	f3 0f 1e fb          	endbr32 
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e72:	89 c2                	mov    %eax,%edx
  800e74:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e77:	39 d0                	cmp    %edx,%eax
  800e79:	73 09                	jae    800e84 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e7b:	38 08                	cmp    %cl,(%eax)
  800e7d:	74 05                	je     800e84 <memfind+0x1f>
	for (; s < ends; s++)
  800e7f:	83 c0 01             	add    $0x1,%eax
  800e82:	eb f3                	jmp    800e77 <memfind+0x12>
			break;
	return (void *) s;
}
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e86:	f3 0f 1e fb          	endbr32 
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
  800e90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e96:	eb 03                	jmp    800e9b <strtol+0x15>
		s++;
  800e98:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800e9b:	0f b6 01             	movzbl (%ecx),%eax
  800e9e:	3c 20                	cmp    $0x20,%al
  800ea0:	74 f6                	je     800e98 <strtol+0x12>
  800ea2:	3c 09                	cmp    $0x9,%al
  800ea4:	74 f2                	je     800e98 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ea6:	3c 2b                	cmp    $0x2b,%al
  800ea8:	74 2a                	je     800ed4 <strtol+0x4e>
	int neg = 0;
  800eaa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800eaf:	3c 2d                	cmp    $0x2d,%al
  800eb1:	74 2b                	je     800ede <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800eb9:	75 0f                	jne    800eca <strtol+0x44>
  800ebb:	80 39 30             	cmpb   $0x30,(%ecx)
  800ebe:	74 28                	je     800ee8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ec0:	85 db                	test   %ebx,%ebx
  800ec2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec7:	0f 44 d8             	cmove  %eax,%ebx
  800eca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ecf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ed2:	eb 46                	jmp    800f1a <strtol+0x94>
		s++;
  800ed4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ed7:	bf 00 00 00 00       	mov    $0x0,%edi
  800edc:	eb d5                	jmp    800eb3 <strtol+0x2d>
		s++, neg = 1;
  800ede:	83 c1 01             	add    $0x1,%ecx
  800ee1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ee6:	eb cb                	jmp    800eb3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eec:	74 0e                	je     800efc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800eee:	85 db                	test   %ebx,%ebx
  800ef0:	75 d8                	jne    800eca <strtol+0x44>
		s++, base = 8;
  800ef2:	83 c1 01             	add    $0x1,%ecx
  800ef5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800efa:	eb ce                	jmp    800eca <strtol+0x44>
		s += 2, base = 16;
  800efc:	83 c1 02             	add    $0x2,%ecx
  800eff:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f04:	eb c4                	jmp    800eca <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f06:	0f be d2             	movsbl %dl,%edx
  800f09:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f0c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f0f:	7d 3a                	jge    800f4b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f11:	83 c1 01             	add    $0x1,%ecx
  800f14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f1a:	0f b6 11             	movzbl (%ecx),%edx
  800f1d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f20:	89 f3                	mov    %esi,%ebx
  800f22:	80 fb 09             	cmp    $0x9,%bl
  800f25:	76 df                	jbe    800f06 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f27:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f2a:	89 f3                	mov    %esi,%ebx
  800f2c:	80 fb 19             	cmp    $0x19,%bl
  800f2f:	77 08                	ja     800f39 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f31:	0f be d2             	movsbl %dl,%edx
  800f34:	83 ea 57             	sub    $0x57,%edx
  800f37:	eb d3                	jmp    800f0c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f3c:	89 f3                	mov    %esi,%ebx
  800f3e:	80 fb 19             	cmp    $0x19,%bl
  800f41:	77 08                	ja     800f4b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f43:	0f be d2             	movsbl %dl,%edx
  800f46:	83 ea 37             	sub    $0x37,%edx
  800f49:	eb c1                	jmp    800f0c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f4f:	74 05                	je     800f56 <strtol+0xd0>
		*endptr = (char *) s;
  800f51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	f7 da                	neg    %edx
  800f5a:	85 ff                	test   %edi,%edi
  800f5c:	0f 45 c2             	cmovne %edx,%eax
}
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    

00800f64 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f64:	f3 0f 1e fb          	endbr32 
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	89 c3                	mov    %eax,%ebx
  800f7b:	89 c7                	mov    %eax,%edi
  800f7d:	89 c6                	mov    %eax,%esi
  800f7f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f86:	f3 0f 1e fb          	endbr32 
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	ba 00 00 00 00       	mov    $0x0,%edx
  800f95:	b8 01 00 00 00       	mov    $0x1,%eax
  800f9a:	89 d1                	mov    %edx,%ecx
  800f9c:	89 d3                	mov    %edx,%ebx
  800f9e:	89 d7                	mov    %edx,%edi
  800fa0:	89 d6                	mov    %edx,%esi
  800fa2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fa9:	f3 0f 1e fb          	endbr32 
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbe:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc3:	89 cb                	mov    %ecx,%ebx
  800fc5:	89 cf                	mov    %ecx,%edi
  800fc7:	89 ce                	mov    %ecx,%esi
  800fc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	7f 08                	jg     800fd7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd2:	5b                   	pop    %ebx
  800fd3:	5e                   	pop    %esi
  800fd4:	5f                   	pop    %edi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	83 ec 0c             	sub    $0xc,%esp
  800fda:	50                   	push   %eax
  800fdb:	6a 03                	push   $0x3
  800fdd:	68 7f 2c 80 00       	push   $0x802c7f
  800fe2:	6a 23                	push   $0x23
  800fe4:	68 9c 2c 80 00       	push   $0x802c9c
  800fe9:	e8 7c 14 00 00       	call   80246a <_panic>

00800fee <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fee:	f3 0f 1e fb          	endbr32 
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	57                   	push   %edi
  800ff6:	56                   	push   %esi
  800ff7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffd:	b8 02 00 00 00       	mov    $0x2,%eax
  801002:	89 d1                	mov    %edx,%ecx
  801004:	89 d3                	mov    %edx,%ebx
  801006:	89 d7                	mov    %edx,%edi
  801008:	89 d6                	mov    %edx,%esi
  80100a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_yield>:

void
sys_yield(void)
{
  801011:	f3 0f 1e fb          	endbr32 
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101b:	ba 00 00 00 00       	mov    $0x0,%edx
  801020:	b8 0b 00 00 00       	mov    $0xb,%eax
  801025:	89 d1                	mov    %edx,%ecx
  801027:	89 d3                	mov    %edx,%ebx
  801029:	89 d7                	mov    %edx,%edi
  80102b:	89 d6                	mov    %edx,%esi
  80102d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801034:	f3 0f 1e fb          	endbr32 
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
  80103e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801041:	be 00 00 00 00       	mov    $0x0,%esi
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	b8 04 00 00 00       	mov    $0x4,%eax
  801051:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801054:	89 f7                	mov    %esi,%edi
  801056:	cd 30                	int    $0x30
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7f 08                	jg     801064 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801064:	83 ec 0c             	sub    $0xc,%esp
  801067:	50                   	push   %eax
  801068:	6a 04                	push   $0x4
  80106a:	68 7f 2c 80 00       	push   $0x802c7f
  80106f:	6a 23                	push   $0x23
  801071:	68 9c 2c 80 00       	push   $0x802c9c
  801076:	e8 ef 13 00 00       	call   80246a <_panic>

0080107b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80107b:	f3 0f 1e fb          	endbr32 
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	57                   	push   %edi
  801083:	56                   	push   %esi
  801084:	53                   	push   %ebx
  801085:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108e:	b8 05 00 00 00       	mov    $0x5,%eax
  801093:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801096:	8b 7d 14             	mov    0x14(%ebp),%edi
  801099:	8b 75 18             	mov    0x18(%ebp),%esi
  80109c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	7f 08                	jg     8010aa <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	50                   	push   %eax
  8010ae:	6a 05                	push   $0x5
  8010b0:	68 7f 2c 80 00       	push   $0x802c7f
  8010b5:	6a 23                	push   $0x23
  8010b7:	68 9c 2c 80 00       	push   $0x802c9c
  8010bc:	e8 a9 13 00 00       	call   80246a <_panic>

008010c1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010c1:	f3 0f 1e fb          	endbr32 
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7f 08                	jg     8010f0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	50                   	push   %eax
  8010f4:	6a 06                	push   $0x6
  8010f6:	68 7f 2c 80 00       	push   $0x802c7f
  8010fb:	6a 23                	push   $0x23
  8010fd:	68 9c 2c 80 00       	push   $0x802c9c
  801102:	e8 63 13 00 00       	call   80246a <_panic>

00801107 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801107:	f3 0f 1e fb          	endbr32 
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
  801111:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111f:	b8 08 00 00 00       	mov    $0x8,%eax
  801124:	89 df                	mov    %ebx,%edi
  801126:	89 de                	mov    %ebx,%esi
  801128:	cd 30                	int    $0x30
	if(check && ret > 0)
  80112a:	85 c0                	test   %eax,%eax
  80112c:	7f 08                	jg     801136 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	50                   	push   %eax
  80113a:	6a 08                	push   $0x8
  80113c:	68 7f 2c 80 00       	push   $0x802c7f
  801141:	6a 23                	push   $0x23
  801143:	68 9c 2c 80 00       	push   $0x802c9c
  801148:	e8 1d 13 00 00       	call   80246a <_panic>

0080114d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80114d:	f3 0f 1e fb          	endbr32 
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	57                   	push   %edi
  801155:	56                   	push   %esi
  801156:	53                   	push   %ebx
  801157:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115f:	8b 55 08             	mov    0x8(%ebp),%edx
  801162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801165:	b8 09 00 00 00       	mov    $0x9,%eax
  80116a:	89 df                	mov    %ebx,%edi
  80116c:	89 de                	mov    %ebx,%esi
  80116e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801170:	85 c0                	test   %eax,%eax
  801172:	7f 08                	jg     80117c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	50                   	push   %eax
  801180:	6a 09                	push   $0x9
  801182:	68 7f 2c 80 00       	push   $0x802c7f
  801187:	6a 23                	push   $0x23
  801189:	68 9c 2c 80 00       	push   $0x802c9c
  80118e:	e8 d7 12 00 00       	call   80246a <_panic>

00801193 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801193:	f3 0f 1e fb          	endbr32 
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
  80119d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011b0:	89 df                	mov    %ebx,%edi
  8011b2:	89 de                	mov    %ebx,%esi
  8011b4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7f 08                	jg     8011c2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5f                   	pop    %edi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c2:	83 ec 0c             	sub    $0xc,%esp
  8011c5:	50                   	push   %eax
  8011c6:	6a 0a                	push   $0xa
  8011c8:	68 7f 2c 80 00       	push   $0x802c7f
  8011cd:	6a 23                	push   $0x23
  8011cf:	68 9c 2c 80 00       	push   $0x802c9c
  8011d4:	e8 91 12 00 00       	call   80246a <_panic>

008011d9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011d9:	f3 0f 1e fb          	endbr32 
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011ee:	be 00 00 00 00       	mov    $0x0,%esi
  8011f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801200:	f3 0f 1e fb          	endbr32 
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	57                   	push   %edi
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80120d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801212:	8b 55 08             	mov    0x8(%ebp),%edx
  801215:	b8 0d 00 00 00       	mov    $0xd,%eax
  80121a:	89 cb                	mov    %ecx,%ebx
  80121c:	89 cf                	mov    %ecx,%edi
  80121e:	89 ce                	mov    %ecx,%esi
  801220:	cd 30                	int    $0x30
	if(check && ret > 0)
  801222:	85 c0                	test   %eax,%eax
  801224:	7f 08                	jg     80122e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	50                   	push   %eax
  801232:	6a 0d                	push   $0xd
  801234:	68 7f 2c 80 00       	push   $0x802c7f
  801239:	6a 23                	push   $0x23
  80123b:	68 9c 2c 80 00       	push   $0x802c9c
  801240:	e8 25 12 00 00       	call   80246a <_panic>

00801245 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801245:	f3 0f 1e fb          	endbr32 
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 0e 00 00 00       	mov    $0xe,%eax
  801259:	89 d1                	mov    %edx,%ecx
  80125b:	89 d3                	mov    %edx,%ebx
  80125d:	89 d7                	mov    %edx,%edi
  80125f:	89 d6                	mov    %edx,%esi
  801261:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    

00801268 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801268:	f3 0f 1e fb          	endbr32 
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	05 00 00 00 30       	add    $0x30000000,%eax
  801277:	c1 e8 0c             	shr    $0xc,%eax
}
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80127c:	f3 0f 1e fb          	endbr32 
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80128b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801290:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801297:	f3 0f 1e fb          	endbr32 
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	c1 ea 16             	shr    $0x16,%edx
  8012a8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012af:	f6 c2 01             	test   $0x1,%dl
  8012b2:	74 2d                	je     8012e1 <fd_alloc+0x4a>
  8012b4:	89 c2                	mov    %eax,%edx
  8012b6:	c1 ea 0c             	shr    $0xc,%edx
  8012b9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012c0:	f6 c2 01             	test   $0x1,%dl
  8012c3:	74 1c                	je     8012e1 <fd_alloc+0x4a>
  8012c5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012ca:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012cf:	75 d2                	jne    8012a3 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012da:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012df:	eb 0a                	jmp    8012eb <fd_alloc+0x54>
			*fd_store = fd;
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012ed:	f3 0f 1e fb          	endbr32 
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012f7:	83 f8 1f             	cmp    $0x1f,%eax
  8012fa:	77 30                	ja     80132c <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012fc:	c1 e0 0c             	shl    $0xc,%eax
  8012ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801304:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80130a:	f6 c2 01             	test   $0x1,%dl
  80130d:	74 24                	je     801333 <fd_lookup+0x46>
  80130f:	89 c2                	mov    %eax,%edx
  801311:	c1 ea 0c             	shr    $0xc,%edx
  801314:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	74 1a                	je     80133a <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801320:	8b 55 0c             	mov    0xc(%ebp),%edx
  801323:	89 02                	mov    %eax,(%edx)
	return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    
		return -E_INVAL;
  80132c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801331:	eb f7                	jmp    80132a <fd_lookup+0x3d>
		return -E_INVAL;
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb f0                	jmp    80132a <fd_lookup+0x3d>
  80133a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80133f:	eb e9                	jmp    80132a <fd_lookup+0x3d>

00801341 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801341:	f3 0f 1e fb          	endbr32 
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80134e:	ba 00 00 00 00       	mov    $0x0,%edx
  801353:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801358:	39 08                	cmp    %ecx,(%eax)
  80135a:	74 38                	je     801394 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80135c:	83 c2 01             	add    $0x1,%edx
  80135f:	8b 04 95 28 2d 80 00 	mov    0x802d28(,%edx,4),%eax
  801366:	85 c0                	test   %eax,%eax
  801368:	75 ee                	jne    801358 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80136a:	a1 18 40 80 00       	mov    0x804018,%eax
  80136f:	8b 40 48             	mov    0x48(%eax),%eax
  801372:	83 ec 04             	sub    $0x4,%esp
  801375:	51                   	push   %ecx
  801376:	50                   	push   %eax
  801377:	68 ac 2c 80 00       	push   $0x802cac
  80137c:	e8 67 f2 ff ff       	call   8005e8 <cprintf>
	*dev = 0;
  801381:	8b 45 0c             	mov    0xc(%ebp),%eax
  801384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80138a:	83 c4 10             	add    $0x10,%esp
  80138d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    
			*dev = devtab[i];
  801394:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801397:	89 01                	mov    %eax,(%ecx)
			return 0;
  801399:	b8 00 00 00 00       	mov    $0x0,%eax
  80139e:	eb f2                	jmp    801392 <dev_lookup+0x51>

008013a0 <fd_close>:
{
  8013a0:	f3 0f 1e fb          	endbr32 
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	57                   	push   %edi
  8013a8:	56                   	push   %esi
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 24             	sub    $0x24,%esp
  8013ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8013b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013bd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c0:	50                   	push   %eax
  8013c1:	e8 27 ff ff ff       	call   8012ed <fd_lookup>
  8013c6:	89 c3                	mov    %eax,%ebx
  8013c8:	83 c4 10             	add    $0x10,%esp
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 05                	js     8013d4 <fd_close+0x34>
	    || fd != fd2)
  8013cf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013d2:	74 16                	je     8013ea <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013d4:	89 f8                	mov    %edi,%eax
  8013d6:	84 c0                	test   %al,%al
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dd:	0f 44 d8             	cmove  %eax,%ebx
}
  8013e0:	89 d8                	mov    %ebx,%eax
  8013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5f                   	pop    %edi
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	ff 36                	pushl  (%esi)
  8013f3:	e8 49 ff ff ff       	call   801341 <dev_lookup>
  8013f8:	89 c3                	mov    %eax,%ebx
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 1a                	js     80141b <fd_close+0x7b>
		if (dev->dev_close)
  801401:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801404:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801407:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80140c:	85 c0                	test   %eax,%eax
  80140e:	74 0b                	je     80141b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801410:	83 ec 0c             	sub    $0xc,%esp
  801413:	56                   	push   %esi
  801414:	ff d0                	call   *%eax
  801416:	89 c3                	mov    %eax,%ebx
  801418:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	56                   	push   %esi
  80141f:	6a 00                	push   $0x0
  801421:	e8 9b fc ff ff       	call   8010c1 <sys_page_unmap>
	return r;
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb b5                	jmp    8013e0 <fd_close+0x40>

0080142b <close>:

int
close(int fdnum)
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	ff 75 08             	pushl  0x8(%ebp)
  80143c:	e8 ac fe ff ff       	call   8012ed <fd_lookup>
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	79 02                	jns    80144a <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    
		return fd_close(fd, 1);
  80144a:	83 ec 08             	sub    $0x8,%esp
  80144d:	6a 01                	push   $0x1
  80144f:	ff 75 f4             	pushl  -0xc(%ebp)
  801452:	e8 49 ff ff ff       	call   8013a0 <fd_close>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	eb ec                	jmp    801448 <close+0x1d>

0080145c <close_all>:

void
close_all(void)
{
  80145c:	f3 0f 1e fb          	endbr32 
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801467:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	53                   	push   %ebx
  801470:	e8 b6 ff ff ff       	call   80142b <close>
	for (i = 0; i < MAXFD; i++)
  801475:	83 c3 01             	add    $0x1,%ebx
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	83 fb 20             	cmp    $0x20,%ebx
  80147e:	75 ec                	jne    80146c <close_all+0x10>
}
  801480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801485:	f3 0f 1e fb          	endbr32 
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	57                   	push   %edi
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
  80148f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801492:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	ff 75 08             	pushl  0x8(%ebp)
  801499:	e8 4f fe ff ff       	call   8012ed <fd_lookup>
  80149e:	89 c3                	mov    %eax,%ebx
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	0f 88 81 00 00 00    	js     80152c <dup+0xa7>
		return r;
	close(newfdnum);
  8014ab:	83 ec 0c             	sub    $0xc,%esp
  8014ae:	ff 75 0c             	pushl  0xc(%ebp)
  8014b1:	e8 75 ff ff ff       	call   80142b <close>

	newfd = INDEX2FD(newfdnum);
  8014b6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014b9:	c1 e6 0c             	shl    $0xc,%esi
  8014bc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014c2:	83 c4 04             	add    $0x4,%esp
  8014c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014c8:	e8 af fd ff ff       	call   80127c <fd2data>
  8014cd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014cf:	89 34 24             	mov    %esi,(%esp)
  8014d2:	e8 a5 fd ff ff       	call   80127c <fd2data>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014dc:	89 d8                	mov    %ebx,%eax
  8014de:	c1 e8 16             	shr    $0x16,%eax
  8014e1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014e8:	a8 01                	test   $0x1,%al
  8014ea:	74 11                	je     8014fd <dup+0x78>
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	c1 e8 0c             	shr    $0xc,%eax
  8014f1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014f8:	f6 c2 01             	test   $0x1,%dl
  8014fb:	75 39                	jne    801536 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801500:	89 d0                	mov    %edx,%eax
  801502:	c1 e8 0c             	shr    $0xc,%eax
  801505:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	25 07 0e 00 00       	and    $0xe07,%eax
  801514:	50                   	push   %eax
  801515:	56                   	push   %esi
  801516:	6a 00                	push   $0x0
  801518:	52                   	push   %edx
  801519:	6a 00                	push   $0x0
  80151b:	e8 5b fb ff ff       	call   80107b <sys_page_map>
  801520:	89 c3                	mov    %eax,%ebx
  801522:	83 c4 20             	add    $0x20,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 31                	js     80155a <dup+0xd5>
		goto err;

	return newfdnum;
  801529:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801536:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80153d:	83 ec 0c             	sub    $0xc,%esp
  801540:	25 07 0e 00 00       	and    $0xe07,%eax
  801545:	50                   	push   %eax
  801546:	57                   	push   %edi
  801547:	6a 00                	push   $0x0
  801549:	53                   	push   %ebx
  80154a:	6a 00                	push   $0x0
  80154c:	e8 2a fb ff ff       	call   80107b <sys_page_map>
  801551:	89 c3                	mov    %eax,%ebx
  801553:	83 c4 20             	add    $0x20,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	79 a3                	jns    8014fd <dup+0x78>
	sys_page_unmap(0, newfd);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	56                   	push   %esi
  80155e:	6a 00                	push   $0x0
  801560:	e8 5c fb ff ff       	call   8010c1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801565:	83 c4 08             	add    $0x8,%esp
  801568:	57                   	push   %edi
  801569:	6a 00                	push   $0x0
  80156b:	e8 51 fb ff ff       	call   8010c1 <sys_page_unmap>
	return r;
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	eb b7                	jmp    80152c <dup+0xa7>

00801575 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801575:	f3 0f 1e fb          	endbr32 
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	53                   	push   %ebx
  80157d:	83 ec 1c             	sub    $0x1c,%esp
  801580:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801583:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	53                   	push   %ebx
  801588:	e8 60 fd ff ff       	call   8012ed <fd_lookup>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 3f                	js     8015d3 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159a:	50                   	push   %eax
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	ff 30                	pushl  (%eax)
  8015a0:	e8 9c fd ff ff       	call   801341 <dev_lookup>
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	78 27                	js     8015d3 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015af:	8b 42 08             	mov    0x8(%edx),%eax
  8015b2:	83 e0 03             	and    $0x3,%eax
  8015b5:	83 f8 01             	cmp    $0x1,%eax
  8015b8:	74 1e                	je     8015d8 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	8b 40 08             	mov    0x8(%eax),%eax
  8015c0:	85 c0                	test   %eax,%eax
  8015c2:	74 35                	je     8015f9 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	ff 75 10             	pushl  0x10(%ebp)
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	52                   	push   %edx
  8015ce:	ff d0                	call   *%eax
  8015d0:	83 c4 10             	add    $0x10,%esp
}
  8015d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d8:	a1 18 40 80 00       	mov    0x804018,%eax
  8015dd:	8b 40 48             	mov    0x48(%eax),%eax
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	53                   	push   %ebx
  8015e4:	50                   	push   %eax
  8015e5:	68 ed 2c 80 00       	push   $0x802ced
  8015ea:	e8 f9 ef ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015f7:	eb da                	jmp    8015d3 <read+0x5e>
		return -E_NOT_SUPP;
  8015f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015fe:	eb d3                	jmp    8015d3 <read+0x5e>

00801600 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801600:	f3 0f 1e fb          	endbr32 
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	57                   	push   %edi
  801608:	56                   	push   %esi
  801609:	53                   	push   %ebx
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801610:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801613:	bb 00 00 00 00       	mov    $0x0,%ebx
  801618:	eb 02                	jmp    80161c <readn+0x1c>
  80161a:	01 c3                	add    %eax,%ebx
  80161c:	39 f3                	cmp    %esi,%ebx
  80161e:	73 21                	jae    801641 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	89 f0                	mov    %esi,%eax
  801625:	29 d8                	sub    %ebx,%eax
  801627:	50                   	push   %eax
  801628:	89 d8                	mov    %ebx,%eax
  80162a:	03 45 0c             	add    0xc(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	57                   	push   %edi
  80162f:	e8 41 ff ff ff       	call   801575 <read>
		if (m < 0)
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 04                	js     80163f <readn+0x3f>
			return m;
		if (m == 0)
  80163b:	75 dd                	jne    80161a <readn+0x1a>
  80163d:	eb 02                	jmp    801641 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801641:	89 d8                	mov    %ebx,%eax
  801643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5f                   	pop    %edi
  801649:	5d                   	pop    %ebp
  80164a:	c3                   	ret    

0080164b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80164b:	f3 0f 1e fb          	endbr32 
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	53                   	push   %ebx
  801653:	83 ec 1c             	sub    $0x1c,%esp
  801656:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801659:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165c:	50                   	push   %eax
  80165d:	53                   	push   %ebx
  80165e:	e8 8a fc ff ff       	call   8012ed <fd_lookup>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 3a                	js     8016a4 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801670:	50                   	push   %eax
  801671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801674:	ff 30                	pushl  (%eax)
  801676:	e8 c6 fc ff ff       	call   801341 <dev_lookup>
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 22                	js     8016a4 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801689:	74 1e                	je     8016a9 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80168b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168e:	8b 52 0c             	mov    0xc(%edx),%edx
  801691:	85 d2                	test   %edx,%edx
  801693:	74 35                	je     8016ca <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	ff 75 10             	pushl  0x10(%ebp)
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	50                   	push   %eax
  80169f:	ff d2                	call   *%edx
  8016a1:	83 c4 10             	add    $0x10,%esp
}
  8016a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016a9:	a1 18 40 80 00       	mov    0x804018,%eax
  8016ae:	8b 40 48             	mov    0x48(%eax),%eax
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	53                   	push   %ebx
  8016b5:	50                   	push   %eax
  8016b6:	68 09 2d 80 00       	push   $0x802d09
  8016bb:	e8 28 ef ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c8:	eb da                	jmp    8016a4 <write+0x59>
		return -E_NOT_SUPP;
  8016ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cf:	eb d3                	jmp    8016a4 <write+0x59>

008016d1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016d1:	f3 0f 1e fb          	endbr32 
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016de:	50                   	push   %eax
  8016df:	ff 75 08             	pushl  0x8(%ebp)
  8016e2:	e8 06 fc ff ff       	call   8012ed <fd_lookup>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	78 0e                	js     8016fc <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	53                   	push   %ebx
  801706:	83 ec 1c             	sub    $0x1c,%esp
  801709:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170f:	50                   	push   %eax
  801710:	53                   	push   %ebx
  801711:	e8 d7 fb ff ff       	call   8012ed <fd_lookup>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 37                	js     801754 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801723:	50                   	push   %eax
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	ff 30                	pushl  (%eax)
  801729:	e8 13 fc ff ff       	call   801341 <dev_lookup>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 1f                	js     801754 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801738:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80173c:	74 1b                	je     801759 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80173e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801741:	8b 52 18             	mov    0x18(%edx),%edx
  801744:	85 d2                	test   %edx,%edx
  801746:	74 32                	je     80177a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	50                   	push   %eax
  80174f:	ff d2                	call   *%edx
  801751:	83 c4 10             	add    $0x10,%esp
}
  801754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801757:	c9                   	leave  
  801758:	c3                   	ret    
			thisenv->env_id, fdnum);
  801759:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80175e:	8b 40 48             	mov    0x48(%eax),%eax
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	53                   	push   %ebx
  801765:	50                   	push   %eax
  801766:	68 cc 2c 80 00       	push   $0x802ccc
  80176b:	e8 78 ee ff ff       	call   8005e8 <cprintf>
		return -E_INVAL;
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801778:	eb da                	jmp    801754 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80177a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177f:	eb d3                	jmp    801754 <ftruncate+0x56>

00801781 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801781:	f3 0f 1e fb          	endbr32 
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	53                   	push   %ebx
  801789:	83 ec 1c             	sub    $0x1c,%esp
  80178c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801792:	50                   	push   %eax
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	e8 52 fb ff ff       	call   8012ed <fd_lookup>
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 4b                	js     8017ed <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a2:	83 ec 08             	sub    $0x8,%esp
  8017a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a8:	50                   	push   %eax
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	ff 30                	pushl  (%eax)
  8017ae:	e8 8e fb ff ff       	call   801341 <dev_lookup>
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 33                	js     8017ed <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017c1:	74 2f                	je     8017f2 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017c3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017c6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017cd:	00 00 00 
	stat->st_isdir = 0;
  8017d0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017d7:	00 00 00 
	stat->st_dev = dev;
  8017da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	53                   	push   %ebx
  8017e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e7:	ff 50 14             	call   *0x14(%eax)
  8017ea:	83 c4 10             	add    $0x10,%esp
}
  8017ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    
		return -E_NOT_SUPP;
  8017f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f7:	eb f4                	jmp    8017ed <fstat+0x6c>

008017f9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017f9:	f3 0f 1e fb          	endbr32 
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	6a 00                	push   $0x0
  801807:	ff 75 08             	pushl  0x8(%ebp)
  80180a:	e8 fb 01 00 00       	call   801a0a <open>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	78 1b                	js     801833 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	e8 5d ff ff ff       	call   801781 <fstat>
  801824:	89 c6                	mov    %eax,%esi
	close(fd);
  801826:	89 1c 24             	mov    %ebx,(%esp)
  801829:	e8 fd fb ff ff       	call   80142b <close>
	return r;
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	89 f3                	mov    %esi,%ebx
}
  801833:	89 d8                	mov    %ebx,%eax
  801835:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801838:	5b                   	pop    %ebx
  801839:	5e                   	pop    %esi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	89 c6                	mov    %eax,%esi
  801843:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801845:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  80184c:	74 27                	je     801875 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80184e:	6a 07                	push   $0x7
  801850:	68 00 50 80 00       	push   $0x805000
  801855:	56                   	push   %esi
  801856:	ff 35 10 40 80 00    	pushl  0x804010
  80185c:	e8 c7 0c 00 00       	call   802528 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801861:	83 c4 0c             	add    $0xc,%esp
  801864:	6a 00                	push   $0x0
  801866:	53                   	push   %ebx
  801867:	6a 00                	push   $0x0
  801869:	e8 46 0c 00 00       	call   8024b4 <ipc_recv>
}
  80186e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801871:	5b                   	pop    %ebx
  801872:	5e                   	pop    %esi
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	6a 01                	push   $0x1
  80187a:	e8 01 0d 00 00       	call   802580 <ipc_find_env>
  80187f:	a3 10 40 80 00       	mov    %eax,0x804010
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	eb c5                	jmp    80184e <fsipc+0x12>

00801889 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801889:	f3 0f 1e fb          	endbr32 
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8b 40 0c             	mov    0xc(%eax),%eax
  801899:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80189e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ab:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b0:	e8 87 ff ff ff       	call   80183c <fsipc>
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <devfile_flush>:
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d6:	e8 61 ff ff ff       	call   80183c <fsipc>
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <devfile_stat>:
{
  8018dd:	f3 0f 1e fb          	endbr32 
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	53                   	push   %ebx
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fb:	b8 05 00 00 00       	mov    $0x5,%eax
  801900:	e8 37 ff ff ff       	call   80183c <fsipc>
  801905:	85 c0                	test   %eax,%eax
  801907:	78 2c                	js     801935 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801909:	83 ec 08             	sub    $0x8,%esp
  80190c:	68 00 50 80 00       	push   $0x805000
  801911:	53                   	push   %ebx
  801912:	e8 db f2 ff ff       	call   800bf2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801917:	a1 80 50 80 00       	mov    0x805080,%eax
  80191c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801922:	a1 84 50 80 00       	mov    0x805084,%eax
  801927:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801935:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <devfile_write>:
{
  80193a:	f3 0f 1e fb          	endbr32 
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 0c             	sub    $0xc,%esp
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801947:	8b 55 08             	mov    0x8(%ebp),%edx
  80194a:	8b 52 0c             	mov    0xc(%edx),%edx
  80194d:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801953:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801958:	ba 00 10 00 00       	mov    $0x1000,%edx
  80195d:	0f 47 c2             	cmova  %edx,%eax
  801960:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801965:	50                   	push   %eax
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	68 08 50 80 00       	push   $0x805008
  80196e:	e8 35 f4 ff ff       	call   800da8 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801973:	ba 00 00 00 00       	mov    $0x0,%edx
  801978:	b8 04 00 00 00       	mov    $0x4,%eax
  80197d:	e8 ba fe ff ff       	call   80183c <fsipc>
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <devfile_read>:
{
  801984:	f3 0f 1e fb          	endbr32 
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8b 40 0c             	mov    0xc(%eax),%eax
  801996:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80199b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ab:	e8 8c fe ff ff       	call   80183c <fsipc>
  8019b0:	89 c3                	mov    %eax,%ebx
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 1f                	js     8019d5 <devfile_read+0x51>
	assert(r <= n);
  8019b6:	39 f0                	cmp    %esi,%eax
  8019b8:	77 24                	ja     8019de <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019ba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019bf:	7f 33                	jg     8019f4 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019c1:	83 ec 04             	sub    $0x4,%esp
  8019c4:	50                   	push   %eax
  8019c5:	68 00 50 80 00       	push   $0x805000
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	e8 d6 f3 ff ff       	call   800da8 <memmove>
	return r;
  8019d2:	83 c4 10             	add    $0x10,%esp
}
  8019d5:	89 d8                	mov    %ebx,%eax
  8019d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5e                   	pop    %esi
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    
	assert(r <= n);
  8019de:	68 3c 2d 80 00       	push   $0x802d3c
  8019e3:	68 43 2d 80 00       	push   $0x802d43
  8019e8:	6a 7c                	push   $0x7c
  8019ea:	68 58 2d 80 00       	push   $0x802d58
  8019ef:	e8 76 0a 00 00       	call   80246a <_panic>
	assert(r <= PGSIZE);
  8019f4:	68 63 2d 80 00       	push   $0x802d63
  8019f9:	68 43 2d 80 00       	push   $0x802d43
  8019fe:	6a 7d                	push   $0x7d
  801a00:	68 58 2d 80 00       	push   $0x802d58
  801a05:	e8 60 0a 00 00       	call   80246a <_panic>

00801a0a <open>:
{
  801a0a:	f3 0f 1e fb          	endbr32 
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	83 ec 1c             	sub    $0x1c,%esp
  801a16:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a19:	56                   	push   %esi
  801a1a:	e8 90 f1 ff ff       	call   800baf <strlen>
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a27:	7f 6c                	jg     801a95 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2f:	50                   	push   %eax
  801a30:	e8 62 f8 ff ff       	call   801297 <fd_alloc>
  801a35:	89 c3                	mov    %eax,%ebx
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 3c                	js     801a7a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a3e:	83 ec 08             	sub    $0x8,%esp
  801a41:	56                   	push   %esi
  801a42:	68 00 50 80 00       	push   $0x805000
  801a47:	e8 a6 f1 ff ff       	call   800bf2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a57:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5c:	e8 db fd ff ff       	call   80183c <fsipc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 19                	js     801a83 <open+0x79>
	return fd2num(fd);
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a70:	e8 f3 f7 ff ff       	call   801268 <fd2num>
  801a75:	89 c3                	mov    %eax,%ebx
  801a77:	83 c4 10             	add    $0x10,%esp
}
  801a7a:	89 d8                	mov    %ebx,%eax
  801a7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    
		fd_close(fd, 0);
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8b:	e8 10 f9 ff ff       	call   8013a0 <fd_close>
		return r;
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	eb e5                	jmp    801a7a <open+0x70>
		return -E_BAD_PATH;
  801a95:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a9a:	eb de                	jmp    801a7a <open+0x70>

00801a9c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a9c:	f3 0f 1e fb          	endbr32 
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aab:	b8 08 00 00 00       	mov    $0x8,%eax
  801ab0:	e8 87 fd ff ff       	call   80183c <fsipc>
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ab7:	f3 0f 1e fb          	endbr32 
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ac1:	68 6f 2d 80 00       	push   $0x802d6f
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	e8 24 f1 ff ff       	call   800bf2 <strcpy>
	return 0;
}
  801ace:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <devsock_close>:
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 10             	sub    $0x10,%esp
  801ae0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ae3:	53                   	push   %ebx
  801ae4:	e8 d4 0a 00 00       	call   8025bd <pageref>
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	83 c4 10             	add    $0x10,%esp
		return 0;
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801af3:	83 fa 01             	cmp    $0x1,%edx
  801af6:	74 05                	je     801afd <devsock_close+0x28>
}
  801af8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801afd:	83 ec 0c             	sub    $0xc,%esp
  801b00:	ff 73 0c             	pushl  0xc(%ebx)
  801b03:	e8 e3 02 00 00       	call   801deb <nsipc_close>
  801b08:	83 c4 10             	add    $0x10,%esp
  801b0b:	eb eb                	jmp    801af8 <devsock_close+0x23>

00801b0d <devsock_write>:
{
  801b0d:	f3 0f 1e fb          	endbr32 
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 10             	pushl  0x10(%ebp)
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	ff 70 0c             	pushl  0xc(%eax)
  801b25:	e8 b5 03 00 00       	call   801edf <nsipc_send>
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <devsock_read>:
{
  801b2c:	f3 0f 1e fb          	endbr32 
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 10             	pushl  0x10(%ebp)
  801b3b:	ff 75 0c             	pushl  0xc(%ebp)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	ff 70 0c             	pushl  0xc(%eax)
  801b44:	e8 1f 03 00 00       	call   801e68 <nsipc_recv>
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <fd2sockid>:
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b51:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	e8 92 f7 ff ff       	call   8012ed <fd_lookup>
  801b5b:	83 c4 10             	add    $0x10,%esp
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 10                	js     801b72 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b65:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b6b:	39 08                	cmp    %ecx,(%eax)
  801b6d:	75 05                	jne    801b74 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b6f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    
		return -E_NOT_SUPP;
  801b74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b79:	eb f7                	jmp    801b72 <fd2sockid+0x27>

00801b7b <alloc_sockfd>:
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	56                   	push   %esi
  801b7f:	53                   	push   %ebx
  801b80:	83 ec 1c             	sub    $0x1c,%esp
  801b83:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	e8 09 f7 ff ff       	call   801297 <fd_alloc>
  801b8e:	89 c3                	mov    %eax,%ebx
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 43                	js     801bda <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	68 07 04 00 00       	push   $0x407
  801b9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba2:	6a 00                	push   $0x0
  801ba4:	e8 8b f4 ff ff       	call   801034 <sys_page_alloc>
  801ba9:	89 c3                	mov    %eax,%ebx
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	78 28                	js     801bda <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bc7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bca:	83 ec 0c             	sub    $0xc,%esp
  801bcd:	50                   	push   %eax
  801bce:	e8 95 f6 ff ff       	call   801268 <fd2num>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	eb 0c                	jmp    801be6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bda:	83 ec 0c             	sub    $0xc,%esp
  801bdd:	56                   	push   %esi
  801bde:	e8 08 02 00 00       	call   801deb <nsipc_close>
		return r;
  801be3:	83 c4 10             	add    $0x10,%esp
}
  801be6:	89 d8                	mov    %ebx,%eax
  801be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <accept>:
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	e8 4a ff ff ff       	call   801b4b <fd2sockid>
  801c01:	85 c0                	test   %eax,%eax
  801c03:	78 1b                	js     801c20 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	ff 75 10             	pushl  0x10(%ebp)
  801c0b:	ff 75 0c             	pushl  0xc(%ebp)
  801c0e:	50                   	push   %eax
  801c0f:	e8 22 01 00 00       	call   801d36 <nsipc_accept>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	85 c0                	test   %eax,%eax
  801c19:	78 05                	js     801c20 <accept+0x31>
	return alloc_sockfd(r);
  801c1b:	e8 5b ff ff ff       	call   801b7b <alloc_sockfd>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <bind>:
{
  801c22:	f3 0f 1e fb          	endbr32 
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	e8 17 ff ff ff       	call   801b4b <fd2sockid>
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 12                	js     801c4a <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	ff 75 10             	pushl  0x10(%ebp)
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	50                   	push   %eax
  801c42:	e8 45 01 00 00       	call   801d8c <nsipc_bind>
  801c47:	83 c4 10             	add    $0x10,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <shutdown>:
{
  801c4c:	f3 0f 1e fb          	endbr32 
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	e8 ed fe ff ff       	call   801b4b <fd2sockid>
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 0f                	js     801c71 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801c62:	83 ec 08             	sub    $0x8,%esp
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	50                   	push   %eax
  801c69:	e8 57 01 00 00       	call   801dc5 <nsipc_shutdown>
  801c6e:	83 c4 10             	add    $0x10,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <connect>:
{
  801c73:	f3 0f 1e fb          	endbr32 
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	e8 c6 fe ff ff       	call   801b4b <fd2sockid>
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 12                	js     801c9b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	ff 75 10             	pushl  0x10(%ebp)
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	50                   	push   %eax
  801c93:	e8 71 01 00 00       	call   801e09 <nsipc_connect>
  801c98:	83 c4 10             	add    $0x10,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <listen>:
{
  801c9d:	f3 0f 1e fb          	endbr32 
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	e8 9c fe ff ff       	call   801b4b <fd2sockid>
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 0f                	js     801cc2 <listen+0x25>
	return nsipc_listen(r, backlog);
  801cb3:	83 ec 08             	sub    $0x8,%esp
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	50                   	push   %eax
  801cba:	e8 83 01 00 00       	call   801e42 <nsipc_listen>
  801cbf:	83 c4 10             	add    $0x10,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801cc4:	f3 0f 1e fb          	endbr32 
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cce:	ff 75 10             	pushl  0x10(%ebp)
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	e8 65 02 00 00       	call   801f41 <nsipc_socket>
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 05                	js     801ce8 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ce3:	e8 93 fe ff ff       	call   801b7b <alloc_sockfd>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cf3:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801cfa:	74 26                	je     801d22 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cfc:	6a 07                	push   $0x7
  801cfe:	68 00 60 80 00       	push   $0x806000
  801d03:	53                   	push   %ebx
  801d04:	ff 35 14 40 80 00    	pushl  0x804014
  801d0a:	e8 19 08 00 00       	call   802528 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d0f:	83 c4 0c             	add    $0xc,%esp
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	e8 97 07 00 00       	call   8024b4 <ipc_recv>
}
  801d1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	6a 02                	push   $0x2
  801d27:	e8 54 08 00 00       	call   802580 <ipc_find_env>
  801d2c:	a3 14 40 80 00       	mov    %eax,0x804014
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	eb c6                	jmp    801cfc <nsipc+0x12>

00801d36 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d36:	f3 0f 1e fb          	endbr32 
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	56                   	push   %esi
  801d3e:	53                   	push   %ebx
  801d3f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d4a:	8b 06                	mov    (%esi),%eax
  801d4c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d51:	b8 01 00 00 00       	mov    $0x1,%eax
  801d56:	e8 8f ff ff ff       	call   801cea <nsipc>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	79 09                	jns    801d6a <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d6a:	83 ec 04             	sub    $0x4,%esp
  801d6d:	ff 35 10 60 80 00    	pushl  0x806010
  801d73:	68 00 60 80 00       	push   $0x806000
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	e8 28 f0 ff ff       	call   800da8 <memmove>
		*addrlen = ret->ret_addrlen;
  801d80:	a1 10 60 80 00       	mov    0x806010,%eax
  801d85:	89 06                	mov    %eax,(%esi)
  801d87:	83 c4 10             	add    $0x10,%esp
	return r;
  801d8a:	eb d5                	jmp    801d61 <nsipc_accept+0x2b>

00801d8c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d8c:	f3 0f 1e fb          	endbr32 
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
  801d94:	83 ec 08             	sub    $0x8,%esp
  801d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801da2:	53                   	push   %ebx
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	68 04 60 80 00       	push   $0x806004
  801dab:	e8 f8 ef ff ff       	call   800da8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801db0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801db6:	b8 02 00 00 00       	mov    $0x2,%eax
  801dbb:	e8 2a ff ff ff       	call   801cea <nsipc>
}
  801dc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dc5:	f3 0f 1e fb          	endbr32 
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dda:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ddf:	b8 03 00 00 00       	mov    $0x3,%eax
  801de4:	e8 01 ff ff ff       	call   801cea <nsipc>
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <nsipc_close>:

int
nsipc_close(int s)
{
  801deb:	f3 0f 1e fb          	endbr32 
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dfd:	b8 04 00 00 00       	mov    $0x4,%eax
  801e02:	e8 e3 fe ff ff       	call   801cea <nsipc>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e09:	f3 0f 1e fb          	endbr32 
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	53                   	push   %ebx
  801e11:	83 ec 08             	sub    $0x8,%esp
  801e14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e1f:	53                   	push   %ebx
  801e20:	ff 75 0c             	pushl  0xc(%ebp)
  801e23:	68 04 60 80 00       	push   $0x806004
  801e28:	e8 7b ef ff ff       	call   800da8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e2d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e33:	b8 05 00 00 00       	mov    $0x5,%eax
  801e38:	e8 ad fe ff ff       	call   801cea <nsipc>
}
  801e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e42:	f3 0f 1e fb          	endbr32 
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e5c:	b8 06 00 00 00       	mov    $0x6,%eax
  801e61:	e8 84 fe ff ff       	call   801cea <nsipc>
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e68:	f3 0f 1e fb          	endbr32 
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	56                   	push   %esi
  801e70:	53                   	push   %ebx
  801e71:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e7c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e82:	8b 45 14             	mov    0x14(%ebp),%eax
  801e85:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e8a:	b8 07 00 00 00       	mov    $0x7,%eax
  801e8f:	e8 56 fe ff ff       	call   801cea <nsipc>
  801e94:	89 c3                	mov    %eax,%ebx
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 26                	js     801ec0 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801e9a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ea0:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ea5:	0f 4e c6             	cmovle %esi,%eax
  801ea8:	39 c3                	cmp    %eax,%ebx
  801eaa:	7f 1d                	jg     801ec9 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	68 00 60 80 00       	push   $0x806000
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	e8 eb ee ff ff       	call   800da8 <memmove>
  801ebd:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ec9:	68 7b 2d 80 00       	push   $0x802d7b
  801ece:	68 43 2d 80 00       	push   $0x802d43
  801ed3:	6a 62                	push   $0x62
  801ed5:	68 90 2d 80 00       	push   $0x802d90
  801eda:	e8 8b 05 00 00       	call   80246a <_panic>

00801edf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801edf:	f3 0f 1e fb          	endbr32 
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	53                   	push   %ebx
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ef5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801efb:	7f 2e                	jg     801f2b <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	53                   	push   %ebx
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	68 0c 60 80 00       	push   $0x80600c
  801f09:	e8 9a ee ff ff       	call   800da8 <memmove>
	nsipcbuf.send.req_size = size;
  801f0e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f14:	8b 45 14             	mov    0x14(%ebp),%eax
  801f17:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f1c:	b8 08 00 00 00       	mov    $0x8,%eax
  801f21:	e8 c4 fd ff ff       	call   801cea <nsipc>
}
  801f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    
	assert(size < 1600);
  801f2b:	68 9c 2d 80 00       	push   $0x802d9c
  801f30:	68 43 2d 80 00       	push   $0x802d43
  801f35:	6a 6d                	push   $0x6d
  801f37:	68 90 2d 80 00       	push   $0x802d90
  801f3c:	e8 29 05 00 00       	call   80246a <_panic>

00801f41 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f41:	f3 0f 1e fb          	endbr32 
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f56:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f63:	b8 09 00 00 00       	mov    $0x9,%eax
  801f68:	e8 7d fd ff ff       	call   801cea <nsipc>
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f6f:	f3 0f 1e fb          	endbr32 
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	ff 75 08             	pushl  0x8(%ebp)
  801f81:	e8 f6 f2 ff ff       	call   80127c <fd2data>
  801f86:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f88:	83 c4 08             	add    $0x8,%esp
  801f8b:	68 a8 2d 80 00       	push   $0x802da8
  801f90:	53                   	push   %ebx
  801f91:	e8 5c ec ff ff       	call   800bf2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f96:	8b 46 04             	mov    0x4(%esi),%eax
  801f99:	2b 06                	sub    (%esi),%eax
  801f9b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fa1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fa8:	00 00 00 
	stat->st_dev = &devpipe;
  801fab:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801fb2:	30 80 00 
	return 0;
}
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fc1:	f3 0f 1e fb          	endbr32 
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	53                   	push   %ebx
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fcf:	53                   	push   %ebx
  801fd0:	6a 00                	push   $0x0
  801fd2:	e8 ea f0 ff ff       	call   8010c1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd7:	89 1c 24             	mov    %ebx,(%esp)
  801fda:	e8 9d f2 ff ff       	call   80127c <fd2data>
  801fdf:	83 c4 08             	add    $0x8,%esp
  801fe2:	50                   	push   %eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 d7 f0 ff ff       	call   8010c1 <sys_page_unmap>
}
  801fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <_pipeisclosed>:
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	57                   	push   %edi
  801ff3:	56                   	push   %esi
  801ff4:	53                   	push   %ebx
  801ff5:	83 ec 1c             	sub    $0x1c,%esp
  801ff8:	89 c7                	mov    %eax,%edi
  801ffa:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ffc:	a1 18 40 80 00       	mov    0x804018,%eax
  802001:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	57                   	push   %edi
  802008:	e8 b0 05 00 00       	call   8025bd <pageref>
  80200d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802010:	89 34 24             	mov    %esi,(%esp)
  802013:	e8 a5 05 00 00       	call   8025bd <pageref>
		nn = thisenv->env_runs;
  802018:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80201e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	39 cb                	cmp    %ecx,%ebx
  802026:	74 1b                	je     802043 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802028:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80202b:	75 cf                	jne    801ffc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80202d:	8b 42 58             	mov    0x58(%edx),%eax
  802030:	6a 01                	push   $0x1
  802032:	50                   	push   %eax
  802033:	53                   	push   %ebx
  802034:	68 af 2d 80 00       	push   $0x802daf
  802039:	e8 aa e5 ff ff       	call   8005e8 <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	eb b9                	jmp    801ffc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802043:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802046:	0f 94 c0             	sete   %al
  802049:	0f b6 c0             	movzbl %al,%eax
}
  80204c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <devpipe_write>:
{
  802054:	f3 0f 1e fb          	endbr32 
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	57                   	push   %edi
  80205c:	56                   	push   %esi
  80205d:	53                   	push   %ebx
  80205e:	83 ec 28             	sub    $0x28,%esp
  802061:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802064:	56                   	push   %esi
  802065:	e8 12 f2 ff ff       	call   80127c <fd2data>
  80206a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	bf 00 00 00 00       	mov    $0x0,%edi
  802074:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802077:	74 4f                	je     8020c8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802079:	8b 43 04             	mov    0x4(%ebx),%eax
  80207c:	8b 0b                	mov    (%ebx),%ecx
  80207e:	8d 51 20             	lea    0x20(%ecx),%edx
  802081:	39 d0                	cmp    %edx,%eax
  802083:	72 14                	jb     802099 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802085:	89 da                	mov    %ebx,%edx
  802087:	89 f0                	mov    %esi,%eax
  802089:	e8 61 ff ff ff       	call   801fef <_pipeisclosed>
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 3b                	jne    8020cd <devpipe_write+0x79>
			sys_yield();
  802092:	e8 7a ef ff ff       	call   801011 <sys_yield>
  802097:	eb e0                	jmp    802079 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80209c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020a0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020a3:	89 c2                	mov    %eax,%edx
  8020a5:	c1 fa 1f             	sar    $0x1f,%edx
  8020a8:	89 d1                	mov    %edx,%ecx
  8020aa:	c1 e9 1b             	shr    $0x1b,%ecx
  8020ad:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020b0:	83 e2 1f             	and    $0x1f,%edx
  8020b3:	29 ca                	sub    %ecx,%edx
  8020b5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020b9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020bd:	83 c0 01             	add    $0x1,%eax
  8020c0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020c3:	83 c7 01             	add    $0x1,%edi
  8020c6:	eb ac                	jmp    802074 <devpipe_write+0x20>
	return i;
  8020c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cb:	eb 05                	jmp    8020d2 <devpipe_write+0x7e>
				return 0;
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5f                   	pop    %edi
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <devpipe_read>:
{
  8020da:	f3 0f 1e fb          	endbr32 
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	57                   	push   %edi
  8020e2:	56                   	push   %esi
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 18             	sub    $0x18,%esp
  8020e7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020ea:	57                   	push   %edi
  8020eb:	e8 8c f1 ff ff       	call   80127c <fd2data>
  8020f0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	be 00 00 00 00       	mov    $0x0,%esi
  8020fa:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020fd:	75 14                	jne    802113 <devpipe_read+0x39>
	return i;
  8020ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802102:	eb 02                	jmp    802106 <devpipe_read+0x2c>
				return i;
  802104:	89 f0                	mov    %esi,%eax
}
  802106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5f                   	pop    %edi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    
			sys_yield();
  80210e:	e8 fe ee ff ff       	call   801011 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802113:	8b 03                	mov    (%ebx),%eax
  802115:	3b 43 04             	cmp    0x4(%ebx),%eax
  802118:	75 18                	jne    802132 <devpipe_read+0x58>
			if (i > 0)
  80211a:	85 f6                	test   %esi,%esi
  80211c:	75 e6                	jne    802104 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80211e:	89 da                	mov    %ebx,%edx
  802120:	89 f8                	mov    %edi,%eax
  802122:	e8 c8 fe ff ff       	call   801fef <_pipeisclosed>
  802127:	85 c0                	test   %eax,%eax
  802129:	74 e3                	je     80210e <devpipe_read+0x34>
				return 0;
  80212b:	b8 00 00 00 00       	mov    $0x0,%eax
  802130:	eb d4                	jmp    802106 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802132:	99                   	cltd   
  802133:	c1 ea 1b             	shr    $0x1b,%edx
  802136:	01 d0                	add    %edx,%eax
  802138:	83 e0 1f             	and    $0x1f,%eax
  80213b:	29 d0                	sub    %edx,%eax
  80213d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802145:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802148:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80214b:	83 c6 01             	add    $0x1,%esi
  80214e:	eb aa                	jmp    8020fa <devpipe_read+0x20>

00802150 <pipe>:
{
  802150:	f3 0f 1e fb          	endbr32 
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
  802159:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80215c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	e8 32 f1 ff ff       	call   801297 <fd_alloc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	85 c0                	test   %eax,%eax
  80216c:	0f 88 23 01 00 00    	js     802295 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 07 04 00 00       	push   $0x407
  80217a:	ff 75 f4             	pushl  -0xc(%ebp)
  80217d:	6a 00                	push   $0x0
  80217f:	e8 b0 ee ff ff       	call   801034 <sys_page_alloc>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	0f 88 04 01 00 00    	js     802295 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802197:	50                   	push   %eax
  802198:	e8 fa f0 ff ff       	call   801297 <fd_alloc>
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 88 db 00 00 00    	js     802285 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	68 07 04 00 00       	push   $0x407
  8021b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021b5:	6a 00                	push   $0x0
  8021b7:	e8 78 ee ff ff       	call   801034 <sys_page_alloc>
  8021bc:	89 c3                	mov    %eax,%ebx
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	0f 88 bc 00 00 00    	js     802285 <pipe+0x135>
	va = fd2data(fd0);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8021cf:	e8 a8 f0 ff ff       	call   80127c <fd2data>
  8021d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d6:	83 c4 0c             	add    $0xc,%esp
  8021d9:	68 07 04 00 00       	push   $0x407
  8021de:	50                   	push   %eax
  8021df:	6a 00                	push   $0x0
  8021e1:	e8 4e ee ff ff       	call   801034 <sys_page_alloc>
  8021e6:	89 c3                	mov    %eax,%ebx
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	0f 88 82 00 00 00    	js     802275 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f9:	e8 7e f0 ff ff       	call   80127c <fd2data>
  8021fe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802205:	50                   	push   %eax
  802206:	6a 00                	push   $0x0
  802208:	56                   	push   %esi
  802209:	6a 00                	push   $0x0
  80220b:	e8 6b ee ff ff       	call   80107b <sys_page_map>
  802210:	89 c3                	mov    %eax,%ebx
  802212:	83 c4 20             	add    $0x20,%esp
  802215:	85 c0                	test   %eax,%eax
  802217:	78 4e                	js     802267 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802219:	a1 40 30 80 00       	mov    0x803040,%eax
  80221e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802221:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802226:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80222d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802230:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802235:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	ff 75 f4             	pushl  -0xc(%ebp)
  802242:	e8 21 f0 ff ff       	call   801268 <fd2num>
  802247:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80224a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80224c:	83 c4 04             	add    $0x4,%esp
  80224f:	ff 75 f0             	pushl  -0x10(%ebp)
  802252:	e8 11 f0 ff ff       	call   801268 <fd2num>
  802257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	bb 00 00 00 00       	mov    $0x0,%ebx
  802265:	eb 2e                	jmp    802295 <pipe+0x145>
	sys_page_unmap(0, va);
  802267:	83 ec 08             	sub    $0x8,%esp
  80226a:	56                   	push   %esi
  80226b:	6a 00                	push   $0x0
  80226d:	e8 4f ee ff ff       	call   8010c1 <sys_page_unmap>
  802272:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802275:	83 ec 08             	sub    $0x8,%esp
  802278:	ff 75 f0             	pushl  -0x10(%ebp)
  80227b:	6a 00                	push   $0x0
  80227d:	e8 3f ee ff ff       	call   8010c1 <sys_page_unmap>
  802282:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	ff 75 f4             	pushl  -0xc(%ebp)
  80228b:	6a 00                	push   $0x0
  80228d:	e8 2f ee ff ff       	call   8010c1 <sys_page_unmap>
  802292:	83 c4 10             	add    $0x10,%esp
}
  802295:	89 d8                	mov    %ebx,%eax
  802297:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229a:	5b                   	pop    %ebx
  80229b:	5e                   	pop    %esi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <pipeisclosed>:
{
  80229e:	f3 0f 1e fb          	endbr32 
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ab:	50                   	push   %eax
  8022ac:	ff 75 08             	pushl  0x8(%ebp)
  8022af:	e8 39 f0 ff ff       	call   8012ed <fd_lookup>
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 18                	js     8022d3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8022bb:	83 ec 0c             	sub    $0xc,%esp
  8022be:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c1:	e8 b6 ef ff ff       	call   80127c <fd2data>
  8022c6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	e8 1f fd ff ff       	call   801fef <_pipeisclosed>
  8022d0:	83 c4 10             	add    $0x10,%esp
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022d5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8022d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022de:	c3                   	ret    

008022df <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022df:	f3 0f 1e fb          	endbr32 
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022e9:	68 c7 2d 80 00       	push   $0x802dc7
  8022ee:	ff 75 0c             	pushl  0xc(%ebp)
  8022f1:	e8 fc e8 ff ff       	call   800bf2 <strcpy>
	return 0;
}
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <devcons_write>:
{
  8022fd:	f3 0f 1e fb          	endbr32 
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	57                   	push   %edi
  802305:	56                   	push   %esi
  802306:	53                   	push   %ebx
  802307:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80230d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802312:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802318:	3b 75 10             	cmp    0x10(%ebp),%esi
  80231b:	73 31                	jae    80234e <devcons_write+0x51>
		m = n - tot;
  80231d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802320:	29 f3                	sub    %esi,%ebx
  802322:	83 fb 7f             	cmp    $0x7f,%ebx
  802325:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80232a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	53                   	push   %ebx
  802331:	89 f0                	mov    %esi,%eax
  802333:	03 45 0c             	add    0xc(%ebp),%eax
  802336:	50                   	push   %eax
  802337:	57                   	push   %edi
  802338:	e8 6b ea ff ff       	call   800da8 <memmove>
		sys_cputs(buf, m);
  80233d:	83 c4 08             	add    $0x8,%esp
  802340:	53                   	push   %ebx
  802341:	57                   	push   %edi
  802342:	e8 1d ec ff ff       	call   800f64 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802347:	01 de                	add    %ebx,%esi
  802349:	83 c4 10             	add    $0x10,%esp
  80234c:	eb ca                	jmp    802318 <devcons_write+0x1b>
}
  80234e:	89 f0                	mov    %esi,%eax
  802350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5f                   	pop    %edi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    

00802358 <devcons_read>:
{
  802358:	f3 0f 1e fb          	endbr32 
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 08             	sub    $0x8,%esp
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802367:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80236b:	74 21                	je     80238e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80236d:	e8 14 ec ff ff       	call   800f86 <sys_cgetc>
  802372:	85 c0                	test   %eax,%eax
  802374:	75 07                	jne    80237d <devcons_read+0x25>
		sys_yield();
  802376:	e8 96 ec ff ff       	call   801011 <sys_yield>
  80237b:	eb f0                	jmp    80236d <devcons_read+0x15>
	if (c < 0)
  80237d:	78 0f                	js     80238e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80237f:	83 f8 04             	cmp    $0x4,%eax
  802382:	74 0c                	je     802390 <devcons_read+0x38>
	*(char*)vbuf = c;
  802384:	8b 55 0c             	mov    0xc(%ebp),%edx
  802387:	88 02                	mov    %al,(%edx)
	return 1;
  802389:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    
		return 0;
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
  802395:	eb f7                	jmp    80238e <devcons_read+0x36>

00802397 <cputchar>:
{
  802397:	f3 0f 1e fb          	endbr32 
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023a7:	6a 01                	push   $0x1
  8023a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ac:	50                   	push   %eax
  8023ad:	e8 b2 eb ff ff       	call   800f64 <sys_cputs>
}
  8023b2:	83 c4 10             	add    $0x10,%esp
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <getchar>:
{
  8023b7:	f3 0f 1e fb          	endbr32 
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023c1:	6a 01                	push   $0x1
  8023c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023c6:	50                   	push   %eax
  8023c7:	6a 00                	push   $0x0
  8023c9:	e8 a7 f1 ff ff       	call   801575 <read>
	if (r < 0)
  8023ce:	83 c4 10             	add    $0x10,%esp
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	78 06                	js     8023db <getchar+0x24>
	if (r < 1)
  8023d5:	74 06                	je     8023dd <getchar+0x26>
	return c;
  8023d7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    
		return -E_EOF;
  8023dd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023e2:	eb f7                	jmp    8023db <getchar+0x24>

008023e4 <iscons>:
{
  8023e4:	f3 0f 1e fb          	endbr32 
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f1:	50                   	push   %eax
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	e8 f3 ee ff ff       	call   8012ed <fd_lookup>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	85 c0                	test   %eax,%eax
  8023ff:	78 11                	js     802412 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80240a:	39 10                	cmp    %edx,(%eax)
  80240c:	0f 94 c0             	sete   %al
  80240f:	0f b6 c0             	movzbl %al,%eax
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <opencons>:
{
  802414:	f3 0f 1e fb          	endbr32 
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80241e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802421:	50                   	push   %eax
  802422:	e8 70 ee ff ff       	call   801297 <fd_alloc>
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	85 c0                	test   %eax,%eax
  80242c:	78 3a                	js     802468 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80242e:	83 ec 04             	sub    $0x4,%esp
  802431:	68 07 04 00 00       	push   $0x407
  802436:	ff 75 f4             	pushl  -0xc(%ebp)
  802439:	6a 00                	push   $0x0
  80243b:	e8 f4 eb ff ff       	call   801034 <sys_page_alloc>
  802440:	83 c4 10             	add    $0x10,%esp
  802443:	85 c0                	test   %eax,%eax
  802445:	78 21                	js     802468 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802450:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80245c:	83 ec 0c             	sub    $0xc,%esp
  80245f:	50                   	push   %eax
  802460:	e8 03 ee ff ff       	call   801268 <fd2num>
  802465:	83 c4 10             	add    $0x10,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80246a:	f3 0f 1e fb          	endbr32 
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	56                   	push   %esi
  802472:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802473:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802476:	8b 35 04 30 80 00    	mov    0x803004,%esi
  80247c:	e8 6d eb ff ff       	call   800fee <sys_getenvid>
  802481:	83 ec 0c             	sub    $0xc,%esp
  802484:	ff 75 0c             	pushl  0xc(%ebp)
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	56                   	push   %esi
  80248b:	50                   	push   %eax
  80248c:	68 d4 2d 80 00       	push   $0x802dd4
  802491:	e8 52 e1 ff ff       	call   8005e8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802496:	83 c4 18             	add    $0x18,%esp
  802499:	53                   	push   %ebx
  80249a:	ff 75 10             	pushl  0x10(%ebp)
  80249d:	e8 f1 e0 ff ff       	call   800593 <vcprintf>
	cprintf("\n");
  8024a2:	c7 04 24 14 29 80 00 	movl   $0x802914,(%esp)
  8024a9:	e8 3a e1 ff ff       	call   8005e8 <cprintf>
  8024ae:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024b1:	cc                   	int3   
  8024b2:	eb fd                	jmp    8024b1 <_panic+0x47>

008024b4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024b4:	f3 0f 1e fb          	endbr32 
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
  8024bb:	56                   	push   %esi
  8024bc:	53                   	push   %ebx
  8024bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8024c6:	83 e8 01             	sub    $0x1,%eax
  8024c9:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8024ce:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024d3:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	50                   	push   %eax
  8024db:	e8 20 ed ff ff       	call   801200 <sys_ipc_recv>
	if (!t) {
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	75 2b                	jne    802512 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8024e7:	85 f6                	test   %esi,%esi
  8024e9:	74 0a                	je     8024f5 <ipc_recv+0x41>
  8024eb:	a1 18 40 80 00       	mov    0x804018,%eax
  8024f0:	8b 40 74             	mov    0x74(%eax),%eax
  8024f3:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8024f5:	85 db                	test   %ebx,%ebx
  8024f7:	74 0a                	je     802503 <ipc_recv+0x4f>
  8024f9:	a1 18 40 80 00       	mov    0x804018,%eax
  8024fe:	8b 40 78             	mov    0x78(%eax),%eax
  802501:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802503:	a1 18 40 80 00       	mov    0x804018,%eax
  802508:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80250b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80250e:	5b                   	pop    %ebx
  80250f:	5e                   	pop    %esi
  802510:	5d                   	pop    %ebp
  802511:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802512:	85 f6                	test   %esi,%esi
  802514:	74 06                	je     80251c <ipc_recv+0x68>
  802516:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80251c:	85 db                	test   %ebx,%ebx
  80251e:	74 eb                	je     80250b <ipc_recv+0x57>
  802520:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802526:	eb e3                	jmp    80250b <ipc_recv+0x57>

00802528 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802528:	f3 0f 1e fb          	endbr32 
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	57                   	push   %edi
  802530:	56                   	push   %esi
  802531:	53                   	push   %ebx
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	8b 7d 08             	mov    0x8(%ebp),%edi
  802538:	8b 75 0c             	mov    0xc(%ebp),%esi
  80253b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80253e:	85 db                	test   %ebx,%ebx
  802540:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802545:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802548:	ff 75 14             	pushl  0x14(%ebp)
  80254b:	53                   	push   %ebx
  80254c:	56                   	push   %esi
  80254d:	57                   	push   %edi
  80254e:	e8 86 ec ff ff       	call   8011d9 <sys_ipc_try_send>
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	85 c0                	test   %eax,%eax
  802558:	74 1e                	je     802578 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80255a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80255d:	75 07                	jne    802566 <ipc_send+0x3e>
		sys_yield();
  80255f:	e8 ad ea ff ff       	call   801011 <sys_yield>
  802564:	eb e2                	jmp    802548 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802566:	50                   	push   %eax
  802567:	68 f7 2d 80 00       	push   $0x802df7
  80256c:	6a 39                	push   $0x39
  80256e:	68 09 2e 80 00       	push   $0x802e09
  802573:	e8 f2 fe ff ff       	call   80246a <_panic>
	}
	//panic("ipc_send not implemented");
}
  802578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    

00802580 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802580:	f3 0f 1e fb          	endbr32 
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80258f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802592:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802598:	8b 52 50             	mov    0x50(%edx),%edx
  80259b:	39 ca                	cmp    %ecx,%edx
  80259d:	74 11                	je     8025b0 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80259f:	83 c0 01             	add    $0x1,%eax
  8025a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025a7:	75 e6                	jne    80258f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	eb 0b                	jmp    8025bb <ipc_find_env+0x3b>
			return envs[i].env_id;
  8025b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025b8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025bb:	5d                   	pop    %ebp
  8025bc:	c3                   	ret    

008025bd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025bd:	f3 0f 1e fb          	endbr32 
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	c1 ea 16             	shr    $0x16,%edx
  8025cc:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025d3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025d8:	f6 c1 01             	test   $0x1,%cl
  8025db:	74 1c                	je     8025f9 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025dd:	c1 e8 0c             	shr    $0xc,%eax
  8025e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025e7:	a8 01                	test   $0x1,%al
  8025e9:	74 0e                	je     8025f9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025eb:	c1 e8 0c             	shr    $0xc,%eax
  8025ee:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025f5:	ef 
  8025f6:	0f b7 d2             	movzwl %dx,%edx
}
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	5d                   	pop    %ebp
  8025fc:	c3                   	ret    
  8025fd:	66 90                	xchg   %ax,%ax
  8025ff:	90                   	nop

00802600 <__udivdi3>:
  802600:	f3 0f 1e fb          	endbr32 
  802604:	55                   	push   %ebp
  802605:	57                   	push   %edi
  802606:	56                   	push   %esi
  802607:	53                   	push   %ebx
  802608:	83 ec 1c             	sub    $0x1c,%esp
  80260b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80260f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802613:	8b 74 24 34          	mov    0x34(%esp),%esi
  802617:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80261b:	85 d2                	test   %edx,%edx
  80261d:	75 19                	jne    802638 <__udivdi3+0x38>
  80261f:	39 f3                	cmp    %esi,%ebx
  802621:	76 4d                	jbe    802670 <__udivdi3+0x70>
  802623:	31 ff                	xor    %edi,%edi
  802625:	89 e8                	mov    %ebp,%eax
  802627:	89 f2                	mov    %esi,%edx
  802629:	f7 f3                	div    %ebx
  80262b:	89 fa                	mov    %edi,%edx
  80262d:	83 c4 1c             	add    $0x1c,%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
  802635:	8d 76 00             	lea    0x0(%esi),%esi
  802638:	39 f2                	cmp    %esi,%edx
  80263a:	76 14                	jbe    802650 <__udivdi3+0x50>
  80263c:	31 ff                	xor    %edi,%edi
  80263e:	31 c0                	xor    %eax,%eax
  802640:	89 fa                	mov    %edi,%edx
  802642:	83 c4 1c             	add    $0x1c,%esp
  802645:	5b                   	pop    %ebx
  802646:	5e                   	pop    %esi
  802647:	5f                   	pop    %edi
  802648:	5d                   	pop    %ebp
  802649:	c3                   	ret    
  80264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802650:	0f bd fa             	bsr    %edx,%edi
  802653:	83 f7 1f             	xor    $0x1f,%edi
  802656:	75 48                	jne    8026a0 <__udivdi3+0xa0>
  802658:	39 f2                	cmp    %esi,%edx
  80265a:	72 06                	jb     802662 <__udivdi3+0x62>
  80265c:	31 c0                	xor    %eax,%eax
  80265e:	39 eb                	cmp    %ebp,%ebx
  802660:	77 de                	ja     802640 <__udivdi3+0x40>
  802662:	b8 01 00 00 00       	mov    $0x1,%eax
  802667:	eb d7                	jmp    802640 <__udivdi3+0x40>
  802669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802670:	89 d9                	mov    %ebx,%ecx
  802672:	85 db                	test   %ebx,%ebx
  802674:	75 0b                	jne    802681 <__udivdi3+0x81>
  802676:	b8 01 00 00 00       	mov    $0x1,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f3                	div    %ebx
  80267f:	89 c1                	mov    %eax,%ecx
  802681:	31 d2                	xor    %edx,%edx
  802683:	89 f0                	mov    %esi,%eax
  802685:	f7 f1                	div    %ecx
  802687:	89 c6                	mov    %eax,%esi
  802689:	89 e8                	mov    %ebp,%eax
  80268b:	89 f7                	mov    %esi,%edi
  80268d:	f7 f1                	div    %ecx
  80268f:	89 fa                	mov    %edi,%edx
  802691:	83 c4 1c             	add    $0x1c,%esp
  802694:	5b                   	pop    %ebx
  802695:	5e                   	pop    %esi
  802696:	5f                   	pop    %edi
  802697:	5d                   	pop    %ebp
  802698:	c3                   	ret    
  802699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 f9                	mov    %edi,%ecx
  8026a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a7:	29 f8                	sub    %edi,%eax
  8026a9:	d3 e2                	shl    %cl,%edx
  8026ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026af:	89 c1                	mov    %eax,%ecx
  8026b1:	89 da                	mov    %ebx,%edx
  8026b3:	d3 ea                	shr    %cl,%edx
  8026b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026b9:	09 d1                	or     %edx,%ecx
  8026bb:	89 f2                	mov    %esi,%edx
  8026bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c1:	89 f9                	mov    %edi,%ecx
  8026c3:	d3 e3                	shl    %cl,%ebx
  8026c5:	89 c1                	mov    %eax,%ecx
  8026c7:	d3 ea                	shr    %cl,%edx
  8026c9:	89 f9                	mov    %edi,%ecx
  8026cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026cf:	89 eb                	mov    %ebp,%ebx
  8026d1:	d3 e6                	shl    %cl,%esi
  8026d3:	89 c1                	mov    %eax,%ecx
  8026d5:	d3 eb                	shr    %cl,%ebx
  8026d7:	09 de                	or     %ebx,%esi
  8026d9:	89 f0                	mov    %esi,%eax
  8026db:	f7 74 24 08          	divl   0x8(%esp)
  8026df:	89 d6                	mov    %edx,%esi
  8026e1:	89 c3                	mov    %eax,%ebx
  8026e3:	f7 64 24 0c          	mull   0xc(%esp)
  8026e7:	39 d6                	cmp    %edx,%esi
  8026e9:	72 15                	jb     802700 <__udivdi3+0x100>
  8026eb:	89 f9                	mov    %edi,%ecx
  8026ed:	d3 e5                	shl    %cl,%ebp
  8026ef:	39 c5                	cmp    %eax,%ebp
  8026f1:	73 04                	jae    8026f7 <__udivdi3+0xf7>
  8026f3:	39 d6                	cmp    %edx,%esi
  8026f5:	74 09                	je     802700 <__udivdi3+0x100>
  8026f7:	89 d8                	mov    %ebx,%eax
  8026f9:	31 ff                	xor    %edi,%edi
  8026fb:	e9 40 ff ff ff       	jmp    802640 <__udivdi3+0x40>
  802700:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802703:	31 ff                	xor    %edi,%edi
  802705:	e9 36 ff ff ff       	jmp    802640 <__udivdi3+0x40>
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__umoddi3>:
  802710:	f3 0f 1e fb          	endbr32 
  802714:	55                   	push   %ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 1c             	sub    $0x1c,%esp
  80271b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80271f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802723:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80272b:	85 c0                	test   %eax,%eax
  80272d:	75 19                	jne    802748 <__umoddi3+0x38>
  80272f:	39 df                	cmp    %ebx,%edi
  802731:	76 5d                	jbe    802790 <__umoddi3+0x80>
  802733:	89 f0                	mov    %esi,%eax
  802735:	89 da                	mov    %ebx,%edx
  802737:	f7 f7                	div    %edi
  802739:	89 d0                	mov    %edx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	83 c4 1c             	add    $0x1c,%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5f                   	pop    %edi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
  802745:	8d 76 00             	lea    0x0(%esi),%esi
  802748:	89 f2                	mov    %esi,%edx
  80274a:	39 d8                	cmp    %ebx,%eax
  80274c:	76 12                	jbe    802760 <__umoddi3+0x50>
  80274e:	89 f0                	mov    %esi,%eax
  802750:	89 da                	mov    %ebx,%edx
  802752:	83 c4 1c             	add    $0x1c,%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    
  80275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802760:	0f bd e8             	bsr    %eax,%ebp
  802763:	83 f5 1f             	xor    $0x1f,%ebp
  802766:	75 50                	jne    8027b8 <__umoddi3+0xa8>
  802768:	39 d8                	cmp    %ebx,%eax
  80276a:	0f 82 e0 00 00 00    	jb     802850 <__umoddi3+0x140>
  802770:	89 d9                	mov    %ebx,%ecx
  802772:	39 f7                	cmp    %esi,%edi
  802774:	0f 86 d6 00 00 00    	jbe    802850 <__umoddi3+0x140>
  80277a:	89 d0                	mov    %edx,%eax
  80277c:	89 ca                	mov    %ecx,%edx
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	89 fd                	mov    %edi,%ebp
  802792:	85 ff                	test   %edi,%edi
  802794:	75 0b                	jne    8027a1 <__umoddi3+0x91>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f7                	div    %edi
  80279f:	89 c5                	mov    %eax,%ebp
  8027a1:	89 d8                	mov    %ebx,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f5                	div    %ebp
  8027a7:	89 f0                	mov    %esi,%eax
  8027a9:	f7 f5                	div    %ebp
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	31 d2                	xor    %edx,%edx
  8027af:	eb 8c                	jmp    80273d <__umoddi3+0x2d>
  8027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	89 e9                	mov    %ebp,%ecx
  8027ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8027bf:	29 ea                	sub    %ebp,%edx
  8027c1:	d3 e0                	shl    %cl,%eax
  8027c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c7:	89 d1                	mov    %edx,%ecx
  8027c9:	89 f8                	mov    %edi,%eax
  8027cb:	d3 e8                	shr    %cl,%eax
  8027cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027d9:	09 c1                	or     %eax,%ecx
  8027db:	89 d8                	mov    %ebx,%eax
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 e9                	mov    %ebp,%ecx
  8027e3:	d3 e7                	shl    %cl,%edi
  8027e5:	89 d1                	mov    %edx,%ecx
  8027e7:	d3 e8                	shr    %cl,%eax
  8027e9:	89 e9                	mov    %ebp,%ecx
  8027eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ef:	d3 e3                	shl    %cl,%ebx
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	89 d1                	mov    %edx,%ecx
  8027f5:	89 f0                	mov    %esi,%eax
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 fa                	mov    %edi,%edx
  8027fd:	d3 e6                	shl    %cl,%esi
  8027ff:	09 d8                	or     %ebx,%eax
  802801:	f7 74 24 08          	divl   0x8(%esp)
  802805:	89 d1                	mov    %edx,%ecx
  802807:	89 f3                	mov    %esi,%ebx
  802809:	f7 64 24 0c          	mull   0xc(%esp)
  80280d:	89 c6                	mov    %eax,%esi
  80280f:	89 d7                	mov    %edx,%edi
  802811:	39 d1                	cmp    %edx,%ecx
  802813:	72 06                	jb     80281b <__umoddi3+0x10b>
  802815:	75 10                	jne    802827 <__umoddi3+0x117>
  802817:	39 c3                	cmp    %eax,%ebx
  802819:	73 0c                	jae    802827 <__umoddi3+0x117>
  80281b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80281f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802823:	89 d7                	mov    %edx,%edi
  802825:	89 c6                	mov    %eax,%esi
  802827:	89 ca                	mov    %ecx,%edx
  802829:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80282e:	29 f3                	sub    %esi,%ebx
  802830:	19 fa                	sbb    %edi,%edx
  802832:	89 d0                	mov    %edx,%eax
  802834:	d3 e0                	shl    %cl,%eax
  802836:	89 e9                	mov    %ebp,%ecx
  802838:	d3 eb                	shr    %cl,%ebx
  80283a:	d3 ea                	shr    %cl,%edx
  80283c:	09 d8                	or     %ebx,%eax
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	29 fe                	sub    %edi,%esi
  802852:	19 c3                	sbb    %eax,%ebx
  802854:	89 f2                	mov    %esi,%edx
  802856:	89 d9                	mov    %ebx,%ecx
  802858:	e9 1d ff ff ff       	jmp    80277a <__umoddi3+0x6a>
