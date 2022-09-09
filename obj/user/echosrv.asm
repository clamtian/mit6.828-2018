
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 d0 04 00 00       	call   800501 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 d0 28 80 00       	push   $0x8028d0
  80003f:	e8 c2 05 00 00       	call   800606 <cprintf>
	exit();
  800044:	e8 02 05 00 00       	call   80054b <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:

void
handle_client(int sock)
{
  80004e:	f3 0f 1e fb          	endbr32 
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 30             	sub    $0x30,%esp
  80005b:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005e:	6a 20                	push   $0x20
  800060:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800063:	50                   	push   %eax
  800064:	56                   	push   %esi
  800065:	e8 29 15 00 00       	call   801593 <read>
  80006a:	89 c3                	mov    %eax,%ebx
  80006c:	83 c4 10             	add    $0x10,%esp
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80006f:	8d 7d c8             	lea    -0x38(%ebp),%edi
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800072:	85 c0                	test   %eax,%eax
  800074:	79 3d                	jns    8000b3 <handle_client+0x65>
		die("Failed to receive initial bytes from client");
  800076:	b8 d4 28 80 00       	mov    $0x8028d4,%eax
  80007b:	e8 b3 ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	56                   	push   %esi
  800084:	e8 c0 13 00 00       	call   801449 <close>
}
  800089:	83 c4 10             	add    $0x10,%esp
  80008c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5f                   	pop    %edi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    
			die("Failed to send bytes to client");
  800094:	b8 00 29 80 00       	mov    $0x802900,%eax
  800099:	e8 95 ff ff ff       	call   800033 <die>
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 20                	push   $0x20
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	e8 e9 14 00 00       	call   801593 <read>
  8000aa:	89 c3                	mov    %eax,%ebx
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	78 18                	js     8000cb <handle_client+0x7d>
	while (received > 0) {
  8000b3:	85 db                	test   %ebx,%ebx
  8000b5:	7e c9                	jle    800080 <handle_client+0x32>
		if (write(sock, buffer, received) != received)
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	53                   	push   %ebx
  8000bb:	57                   	push   %edi
  8000bc:	56                   	push   %esi
  8000bd:	e8 a7 15 00 00       	call   801669 <write>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	39 d8                	cmp    %ebx,%eax
  8000c7:	74 d5                	je     80009e <handle_client+0x50>
  8000c9:	eb c9                	jmp    800094 <handle_client+0x46>
			die("Failed to receive additional bytes from client");
  8000cb:	b8 20 29 80 00       	mov    $0x802920,%eax
  8000d0:	e8 5e ff ff ff       	call   800033 <die>
  8000d5:	eb dc                	jmp    8000b3 <handle_client+0x65>

008000d7 <umain>:

void
umain(int argc, char **argv)
{
  8000d7:	f3 0f 1e fb          	endbr32 
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 40             	sub    $0x40,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e4:	6a 06                	push   $0x6
  8000e6:	6a 01                	push   $0x1
  8000e8:	6a 02                	push   $0x2
  8000ea:	e8 f3 1b 00 00       	call   801ce2 <socket>
  8000ef:	89 c6                	mov    %eax,%esi
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	0f 88 86 00 00 00    	js     800182 <umain+0xab>
		die("Failed to create socket");

	cprintf("opened socket\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 98 28 80 00       	push   $0x802898
  800104:	e8 fd 04 00 00       	call   800606 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800109:	83 c4 0c             	add    $0xc,%esp
  80010c:	6a 10                	push   $0x10
  80010e:	6a 00                	push   $0x0
  800110:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800113:	53                   	push   %ebx
  800114:	e8 61 0c 00 00       	call   800d7a <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  800119:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  80011d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800124:	e8 94 01 00 00       	call   8002bd <htonl>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80012c:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800133:	e8 63 01 00 00       	call   80029b <htons>
  800138:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80013c:	c7 04 24 a7 28 80 00 	movl   $0x8028a7,(%esp)
  800143:	e8 be 04 00 00       	call   800606 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	6a 10                	push   $0x10
  80014d:	53                   	push   %ebx
  80014e:	56                   	push   %esi
  80014f:	e8 ec 1a 00 00       	call   801c40 <bind>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	85 c0                	test   %eax,%eax
  800159:	78 36                	js     800191 <umain+0xba>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	6a 05                	push   $0x5
  800160:	56                   	push   %esi
  800161:	e8 55 1b 00 00       	call   801cbb <listen>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	78 30                	js     80019d <umain+0xc6>
		die("Failed to listen on server socket");

	cprintf("bound\n");
  80016d:	83 ec 0c             	sub    $0xc,%esp
  800170:	68 b7 28 80 00       	push   $0x8028b7
  800175:	e8 8c 04 00 00       	call   800606 <cprintf>
  80017a:	83 c4 10             	add    $0x10,%esp
	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
		     accept(serversock, (struct sockaddr *) &echoclient,
  80017d:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  800180:	eb 55                	jmp    8001d7 <umain+0x100>
		die("Failed to create socket");
  800182:	b8 80 28 80 00       	mov    $0x802880,%eax
  800187:	e8 a7 fe ff ff       	call   800033 <die>
  80018c:	e9 6b ff ff ff       	jmp    8000fc <umain+0x25>
		die("Failed to bind the server socket");
  800191:	b8 50 29 80 00       	mov    $0x802950,%eax
  800196:	e8 98 fe ff ff       	call   800033 <die>
  80019b:	eb be                	jmp    80015b <umain+0x84>
		die("Failed to listen on server socket");
  80019d:	b8 74 29 80 00       	mov    $0x802974,%eax
  8001a2:	e8 8c fe ff ff       	call   800033 <die>
  8001a7:	eb c4                	jmp    80016d <umain+0x96>
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001a9:	b8 98 29 80 00       	mov    $0x802998,%eax
  8001ae:	e8 80 fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8001b9:	e8 39 00 00 00       	call   8001f7 <inet_ntoa>
  8001be:	83 c4 08             	add    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 be 28 80 00       	push   $0x8028be
  8001c7:	e8 3a 04 00 00       	call   800606 <cprintf>
		handle_client(clientsock);
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 7a fe ff ff       	call   80004e <handle_client>
	while (1) {
  8001d4:	83 c4 10             	add    $0x10,%esp
		unsigned int clientlen = sizeof(echoclient);
  8001d7:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		     accept(serversock, (struct sockaddr *) &echoclient,
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	57                   	push   %edi
  8001e2:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001e5:	50                   	push   %eax
  8001e6:	56                   	push   %esi
  8001e7:	e8 21 1a 00 00       	call   801c0d <accept>
  8001ec:	89 c3                	mov    %eax,%ebx
		if ((clientsock =
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	78 b4                	js     8001a9 <umain+0xd2>
  8001f5:	eb bc                	jmp    8001b3 <umain+0xdc>

008001f7 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f7:	f3 0f 1e fb          	endbr32 
  8001fb:	55                   	push   %ebp
  8001fc:	89 e5                	mov    %esp,%ebp
  8001fe:	57                   	push   %edi
  8001ff:	56                   	push   %esi
  800200:	53                   	push   %ebx
  800201:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80020a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  80020e:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800211:	bf 00 40 80 00       	mov    $0x804000,%edi
  800216:	eb 2e                	jmp    800246 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  800218:	0f b6 c8             	movzbl %al,%ecx
  80021b:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800220:	88 0a                	mov    %cl,(%edx)
  800222:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800225:	83 e8 01             	sub    $0x1,%eax
  800228:	3c ff                	cmp    $0xff,%al
  80022a:	75 ec                	jne    800218 <inet_ntoa+0x21>
  80022c:	0f b6 db             	movzbl %bl,%ebx
  80022f:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  800231:	8d 7b 01             	lea    0x1(%ebx),%edi
  800234:	c6 03 2e             	movb   $0x2e,(%ebx)
  800237:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80023a:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  80023e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800242:	3c 04                	cmp    $0x4,%al
  800244:	74 45                	je     80028b <inet_ntoa+0x94>
  rp = str;
  800246:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  80024b:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  80024e:	0f b6 ca             	movzbl %dl,%ecx
  800251:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800254:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800257:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80025a:	66 c1 e8 0b          	shr    $0xb,%ax
  80025e:	88 06                	mov    %al,(%esi)
  800260:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  800262:	83 c3 01             	add    $0x1,%ebx
  800265:	0f b6 c9             	movzbl %cl,%ecx
  800268:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80026b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80026e:	01 c0                	add    %eax,%eax
  800270:	89 d1                	mov    %edx,%ecx
  800272:	29 c1                	sub    %eax,%ecx
  800274:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800276:	83 c0 30             	add    $0x30,%eax
  800279:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80027c:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  800280:	80 fa 09             	cmp    $0x9,%dl
  800283:	77 c6                	ja     80024b <inet_ntoa+0x54>
  800285:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800287:	89 d8                	mov    %ebx,%eax
  800289:	eb 9a                	jmp    800225 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  80028b:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  80028e:	b8 00 40 80 00       	mov    $0x804000,%eax
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	5b                   	pop    %ebx
  800297:	5e                   	pop    %esi
  800298:	5f                   	pop    %edi
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80029b:	f3 0f 1e fb          	endbr32 
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002a2:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002a6:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002aa:	5d                   	pop    %ebp
  8002ab:	c3                   	ret    

008002ac <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002ac:	f3 0f 1e fb          	endbr32 
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002b3:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002b7:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8002bb:	5d                   	pop    %ebp
  8002bc:	c3                   	ret    

008002bd <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002bd:	f3 0f 1e fb          	endbr32 
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8002c7:	89 d0                	mov    %edx,%eax
  8002c9:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002cc:	89 d1                	mov    %edx,%ecx
  8002ce:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002d1:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	c1 e1 08             	shl    $0x8,%ecx
  8002d8:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8002de:	09 c8                	or     %ecx,%eax
  8002e0:	c1 ea 08             	shr    $0x8,%edx
  8002e3:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8002e9:	09 d0                	or     %edx,%eax
}
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <inet_aton>:
{
  8002ed:	f3 0f 1e fb          	endbr32 
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	57                   	push   %edi
  8002f5:	56                   	push   %esi
  8002f6:	53                   	push   %ebx
  8002f7:	83 ec 2c             	sub    $0x2c,%esp
  8002fa:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8002fd:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  800300:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800303:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800306:	e9 a7 00 00 00       	jmp    8003b2 <inet_aton+0xc5>
      c = *++cp;
  80030b:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  80030f:	89 c1                	mov    %eax,%ecx
  800311:	83 e1 df             	and    $0xffffffdf,%ecx
  800314:	80 f9 58             	cmp    $0x58,%cl
  800317:	74 10                	je     800329 <inet_aton+0x3c>
      c = *++cp;
  800319:	83 c2 01             	add    $0x1,%edx
  80031c:	0f be c0             	movsbl %al,%eax
        base = 8;
  80031f:	be 08 00 00 00       	mov    $0x8,%esi
  800324:	e9 a3 00 00 00       	jmp    8003cc <inet_aton+0xdf>
        c = *++cp;
  800329:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80032d:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800330:	be 10 00 00 00       	mov    $0x10,%esi
  800335:	e9 92 00 00 00       	jmp    8003cc <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80033a:	83 fe 10             	cmp    $0x10,%esi
  80033d:	75 4d                	jne    80038c <inet_aton+0x9f>
  80033f:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800342:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800345:	89 c1                	mov    %eax,%ecx
  800347:	83 e1 df             	and    $0xffffffdf,%ecx
  80034a:	83 e9 41             	sub    $0x41,%ecx
  80034d:	80 f9 05             	cmp    $0x5,%cl
  800350:	77 3a                	ja     80038c <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800352:	c1 e3 04             	shl    $0x4,%ebx
  800355:	83 c0 0a             	add    $0xa,%eax
  800358:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80035c:	19 c9                	sbb    %ecx,%ecx
  80035e:	83 e1 20             	and    $0x20,%ecx
  800361:	83 c1 41             	add    $0x41,%ecx
  800364:	29 c8                	sub    %ecx,%eax
  800366:	09 c3                	or     %eax,%ebx
        c = *++cp;
  800368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036b:	0f be 40 01          	movsbl 0x1(%eax),%eax
  80036f:	83 c2 01             	add    $0x1,%edx
  800372:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800375:	89 c7                	mov    %eax,%edi
  800377:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80037a:	80 f9 09             	cmp    $0x9,%cl
  80037d:	77 bb                	ja     80033a <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80037f:	0f af de             	imul   %esi,%ebx
  800382:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800386:	0f be 42 01          	movsbl 0x1(%edx),%eax
  80038a:	eb e3                	jmp    80036f <inet_aton+0x82>
    if (c == '.') {
  80038c:	83 f8 2e             	cmp    $0x2e,%eax
  80038f:	75 42                	jne    8003d3 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800394:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800397:	39 c6                	cmp    %eax,%esi
  800399:	0f 84 16 01 00 00    	je     8004b5 <inet_aton+0x1c8>
      *pp++ = val;
  80039f:	83 c6 04             	add    $0x4,%esi
  8003a2:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8003a5:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	8d 50 01             	lea    0x1(%eax),%edx
  8003ae:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  8003b2:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8003b5:	80 f9 09             	cmp    $0x9,%cl
  8003b8:	0f 87 f0 00 00 00    	ja     8004ae <inet_aton+0x1c1>
    base = 10;
  8003be:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8003c3:	83 f8 30             	cmp    $0x30,%eax
  8003c6:	0f 84 3f ff ff ff    	je     80030b <inet_aton+0x1e>
    base = 10;
  8003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d1:	eb 9f                	jmp    800372 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	74 29                	je     800400 <inet_aton+0x113>
    return (0);
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003dc:	89 f9                	mov    %edi,%ecx
  8003de:	80 f9 1f             	cmp    $0x1f,%cl
  8003e1:	0f 86 d3 00 00 00    	jbe    8004ba <inet_aton+0x1cd>
  8003e7:	84 c0                	test   %al,%al
  8003e9:	0f 88 cb 00 00 00    	js     8004ba <inet_aton+0x1cd>
  8003ef:	83 f8 20             	cmp    $0x20,%eax
  8003f2:	74 0c                	je     800400 <inet_aton+0x113>
  8003f4:	83 e8 09             	sub    $0x9,%eax
  8003f7:	83 f8 04             	cmp    $0x4,%eax
  8003fa:	0f 87 ba 00 00 00    	ja     8004ba <inet_aton+0x1cd>
  n = pp - parts + 1;
  800400:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800403:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800406:	29 c6                	sub    %eax,%esi
  800408:	89 f0                	mov    %esi,%eax
  80040a:	c1 f8 02             	sar    $0x2,%eax
  80040d:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  800410:	83 f8 02             	cmp    $0x2,%eax
  800413:	74 7a                	je     80048f <inet_aton+0x1a2>
  800415:	83 fa 03             	cmp    $0x3,%edx
  800418:	7f 49                	jg     800463 <inet_aton+0x176>
  80041a:	85 d2                	test   %edx,%edx
  80041c:	0f 84 98 00 00 00    	je     8004ba <inet_aton+0x1cd>
  800422:	83 fa 02             	cmp    $0x2,%edx
  800425:	75 19                	jne    800440 <inet_aton+0x153>
      return (0);
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80042c:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800432:	0f 87 82 00 00 00    	ja     8004ba <inet_aton+0x1cd>
    val |= parts[0] << 24;
  800438:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80043b:	c1 e0 18             	shl    $0x18,%eax
  80043e:	09 c3                	or     %eax,%ebx
  return (1);
  800440:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800445:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800449:	74 6f                	je     8004ba <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  80044b:	83 ec 0c             	sub    $0xc,%esp
  80044e:	53                   	push   %ebx
  80044f:	e8 69 fe ff ff       	call   8002bd <htonl>
  800454:	83 c4 10             	add    $0x10,%esp
  800457:	8b 75 0c             	mov    0xc(%ebp),%esi
  80045a:	89 06                	mov    %eax,(%esi)
  return (1);
  80045c:	ba 01 00 00 00       	mov    $0x1,%edx
  800461:	eb 57                	jmp    8004ba <inet_aton+0x1cd>
  switch (n) {
  800463:	83 fa 04             	cmp    $0x4,%edx
  800466:	75 d8                	jne    800440 <inet_aton+0x153>
      return (0);
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80046d:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800473:	77 45                	ja     8004ba <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800475:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800478:	c1 e0 18             	shl    $0x18,%eax
  80047b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80047e:	c1 e2 10             	shl    $0x10,%edx
  800481:	09 d0                	or     %edx,%eax
  800483:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800486:	c1 e2 08             	shl    $0x8,%edx
  800489:	09 d0                	or     %edx,%eax
  80048b:	09 c3                	or     %eax,%ebx
    break;
  80048d:	eb b1                	jmp    800440 <inet_aton+0x153>
      return (0);
  80048f:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800494:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80049a:	77 1e                	ja     8004ba <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80049c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049f:	c1 e0 18             	shl    $0x18,%eax
  8004a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004a5:	c1 e2 10             	shl    $0x10,%edx
  8004a8:	09 d0                	or     %edx,%eax
  8004aa:	09 c3                	or     %eax,%ebx
    break;
  8004ac:	eb 92                	jmp    800440 <inet_aton+0x153>
      return (0);
  8004ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b3:	eb 05                	jmp    8004ba <inet_aton+0x1cd>
        return (0);
  8004b5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ba:	89 d0                	mov    %edx,%eax
  8004bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004bf:	5b                   	pop    %ebx
  8004c0:	5e                   	pop    %esi
  8004c1:	5f                   	pop    %edi
  8004c2:	5d                   	pop    %ebp
  8004c3:	c3                   	ret    

008004c4 <inet_addr>:
{
  8004c4:	f3 0f 1e fb          	endbr32 
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8004ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 08             	pushl  0x8(%ebp)
  8004d5:	e8 13 fe ff ff       	call   8002ed <inet_aton>
  8004da:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004e4:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004ea:	f3 0f 1e fb          	endbr32 
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8004f4:	ff 75 08             	pushl  0x8(%ebp)
  8004f7:	e8 c1 fd ff ff       	call   8002bd <htonl>
  8004fc:	83 c4 10             	add    $0x10,%esp
}
  8004ff:	c9                   	leave  
  800500:	c3                   	ret    

00800501 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800501:	f3 0f 1e fb          	endbr32 
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80050d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800510:	e8 f7 0a 00 00       	call   80100c <sys_getenvid>
  800515:	25 ff 03 00 00       	and    $0x3ff,%eax
  80051a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80051d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800522:	a3 18 40 80 00       	mov    %eax,0x804018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800527:	85 db                	test   %ebx,%ebx
  800529:	7e 07                	jle    800532 <libmain+0x31>
		binaryname = argv[0];
  80052b:	8b 06                	mov    (%esi),%eax
  80052d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	56                   	push   %esi
  800536:	53                   	push   %ebx
  800537:	e8 9b fb ff ff       	call   8000d7 <umain>

	// exit gracefully
	exit();
  80053c:	e8 0a 00 00 00       	call   80054b <exit>
}
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800547:	5b                   	pop    %ebx
  800548:	5e                   	pop    %esi
  800549:	5d                   	pop    %ebp
  80054a:	c3                   	ret    

0080054b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80054b:	f3 0f 1e fb          	endbr32 
  80054f:	55                   	push   %ebp
  800550:	89 e5                	mov    %esp,%ebp
  800552:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800555:	e8 20 0f 00 00       	call   80147a <close_all>
	sys_env_destroy(0);
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	6a 00                	push   $0x0
  80055f:	e8 63 0a 00 00       	call   800fc7 <sys_env_destroy>
}
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800569:	f3 0f 1e fb          	endbr32 
  80056d:	55                   	push   %ebp
  80056e:	89 e5                	mov    %esp,%ebp
  800570:	53                   	push   %ebx
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800577:	8b 13                	mov    (%ebx),%edx
  800579:	8d 42 01             	lea    0x1(%edx),%eax
  80057c:	89 03                	mov    %eax,(%ebx)
  80057e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800581:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800585:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058a:	74 09                	je     800595 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80058c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800593:	c9                   	leave  
  800594:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	68 ff 00 00 00       	push   $0xff
  80059d:	8d 43 08             	lea    0x8(%ebx),%eax
  8005a0:	50                   	push   %eax
  8005a1:	e8 dc 09 00 00       	call   800f82 <sys_cputs>
		b->idx = 0;
  8005a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb db                	jmp    80058c <putch+0x23>

008005b1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b1:	f3 0f 1e fb          	endbr32 
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c5:	00 00 00 
	b.cnt = 0;
  8005c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005d2:	ff 75 0c             	pushl  0xc(%ebp)
  8005d5:	ff 75 08             	pushl  0x8(%ebp)
  8005d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	68 69 05 80 00       	push   $0x800569
  8005e4:	e8 20 01 00 00       	call   800709 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005e9:	83 c4 08             	add    $0x8,%esp
  8005ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8005f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8005f8:	50                   	push   %eax
  8005f9:	e8 84 09 00 00       	call   800f82 <sys_cputs>

	return b.cnt;
}
  8005fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800606:	f3 0f 1e fb          	endbr32 
  80060a:	55                   	push   %ebp
  80060b:	89 e5                	mov    %esp,%ebp
  80060d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800610:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800613:	50                   	push   %eax
  800614:	ff 75 08             	pushl  0x8(%ebp)
  800617:	e8 95 ff ff ff       	call   8005b1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	57                   	push   %edi
  800622:	56                   	push   %esi
  800623:	53                   	push   %ebx
  800624:	83 ec 1c             	sub    $0x1c,%esp
  800627:	89 c7                	mov    %eax,%edi
  800629:	89 d6                	mov    %edx,%esi
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800631:	89 d1                	mov    %edx,%ecx
  800633:	89 c2                	mov    %eax,%edx
  800635:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800638:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80063b:	8b 45 10             	mov    0x10(%ebp),%eax
  80063e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800641:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800650:	72 3e                	jb     800690 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	ff 75 18             	pushl  0x18(%ebp)
  800658:	83 eb 01             	sub    $0x1,%ebx
  80065b:	53                   	push   %ebx
  80065c:	50                   	push   %eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 e4             	pushl  -0x1c(%ebp)
  800663:	ff 75 e0             	pushl  -0x20(%ebp)
  800666:	ff 75 dc             	pushl  -0x24(%ebp)
  800669:	ff 75 d8             	pushl  -0x28(%ebp)
  80066c:	e8 af 1f 00 00       	call   802620 <__udivdi3>
  800671:	83 c4 18             	add    $0x18,%esp
  800674:	52                   	push   %edx
  800675:	50                   	push   %eax
  800676:	89 f2                	mov    %esi,%edx
  800678:	89 f8                	mov    %edi,%eax
  80067a:	e8 9f ff ff ff       	call   80061e <printnum>
  80067f:	83 c4 20             	add    $0x20,%esp
  800682:	eb 13                	jmp    800697 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	56                   	push   %esi
  800688:	ff 75 18             	pushl  0x18(%ebp)
  80068b:	ff d7                	call   *%edi
  80068d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800690:	83 eb 01             	sub    $0x1,%ebx
  800693:	85 db                	test   %ebx,%ebx
  800695:	7f ed                	jg     800684 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	56                   	push   %esi
  80069b:	83 ec 04             	sub    $0x4,%esp
  80069e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8006a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006aa:	e8 81 20 00 00       	call   802730 <__umoddi3>
  8006af:	83 c4 14             	add    $0x14,%esp
  8006b2:	0f be 80 c5 29 80 00 	movsbl 0x8029c5(%eax),%eax
  8006b9:	50                   	push   %eax
  8006ba:	ff d7                	call   *%edi
}
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006c2:	5b                   	pop    %ebx
  8006c3:	5e                   	pop    %esi
  8006c4:	5f                   	pop    %edi
  8006c5:	5d                   	pop    %ebp
  8006c6:	c3                   	ret    

008006c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006c7:	f3 0f 1e fb          	endbr32 
  8006cb:	55                   	push   %ebp
  8006cc:	89 e5                	mov    %esp,%ebp
  8006ce:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006d1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006d5:	8b 10                	mov    (%eax),%edx
  8006d7:	3b 50 04             	cmp    0x4(%eax),%edx
  8006da:	73 0a                	jae    8006e6 <sprintputch+0x1f>
		*b->buf++ = ch;
  8006dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006df:	89 08                	mov    %ecx,(%eax)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	88 02                	mov    %al,(%edx)
}
  8006e6:	5d                   	pop    %ebp
  8006e7:	c3                   	ret    

008006e8 <printfmt>:
{
  8006e8:	f3 0f 1e fb          	endbr32 
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006f5:	50                   	push   %eax
  8006f6:	ff 75 10             	pushl  0x10(%ebp)
  8006f9:	ff 75 0c             	pushl  0xc(%ebp)
  8006fc:	ff 75 08             	pushl  0x8(%ebp)
  8006ff:	e8 05 00 00 00       	call   800709 <vprintfmt>
}
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <vprintfmt>:
{
  800709:	f3 0f 1e fb          	endbr32 
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	57                   	push   %edi
  800711:	56                   	push   %esi
  800712:	53                   	push   %ebx
  800713:	83 ec 3c             	sub    $0x3c,%esp
  800716:	8b 75 08             	mov    0x8(%ebp),%esi
  800719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80071c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80071f:	e9 8e 03 00 00       	jmp    800ab2 <vprintfmt+0x3a9>
		padc = ' ';
  800724:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800728:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80072f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800736:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80073d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800742:	8d 47 01             	lea    0x1(%edi),%eax
  800745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800748:	0f b6 17             	movzbl (%edi),%edx
  80074b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80074e:	3c 55                	cmp    $0x55,%al
  800750:	0f 87 df 03 00 00    	ja     800b35 <vprintfmt+0x42c>
  800756:	0f b6 c0             	movzbl %al,%eax
  800759:	3e ff 24 85 00 2b 80 	notrack jmp *0x802b00(,%eax,4)
  800760:	00 
  800761:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800764:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800768:	eb d8                	jmp    800742 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80076a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80076d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800771:	eb cf                	jmp    800742 <vprintfmt+0x39>
  800773:	0f b6 d2             	movzbl %dl,%edx
  800776:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800779:	b8 00 00 00 00       	mov    $0x0,%eax
  80077e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800781:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800784:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800788:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80078b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80078e:	83 f9 09             	cmp    $0x9,%ecx
  800791:	77 55                	ja     8007e8 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800793:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800796:	eb e9                	jmp    800781 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a3:	8d 40 04             	lea    0x4(%eax),%eax
  8007a6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b0:	79 90                	jns    800742 <vprintfmt+0x39>
				width = precision, precision = -1;
  8007b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8007bf:	eb 81                	jmp    800742 <vprintfmt+0x39>
  8007c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cb:	0f 49 d0             	cmovns %eax,%edx
  8007ce:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007d4:	e9 69 ff ff ff       	jmp    800742 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8007d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007dc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8007e3:	e9 5a ff ff ff       	jmp    800742 <vprintfmt+0x39>
  8007e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ee:	eb bc                	jmp    8007ac <vprintfmt+0xa3>
			lflag++;
  8007f0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007f6:	e9 47 ff ff ff       	jmp    800742 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 78 04             	lea    0x4(%eax),%edi
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	53                   	push   %ebx
  800805:	ff 30                	pushl  (%eax)
  800807:	ff d6                	call   *%esi
			break;
  800809:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80080c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80080f:	e9 9b 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 78 04             	lea    0x4(%eax),%edi
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	99                   	cltd   
  80081d:	31 d0                	xor    %edx,%eax
  80081f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800821:	83 f8 0f             	cmp    $0xf,%eax
  800824:	7f 23                	jg     800849 <vprintfmt+0x140>
  800826:	8b 14 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edx
  80082d:	85 d2                	test   %edx,%edx
  80082f:	74 18                	je     800849 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800831:	52                   	push   %edx
  800832:	68 95 2d 80 00       	push   $0x802d95
  800837:	53                   	push   %ebx
  800838:	56                   	push   %esi
  800839:	e8 aa fe ff ff       	call   8006e8 <printfmt>
  80083e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800841:	89 7d 14             	mov    %edi,0x14(%ebp)
  800844:	e9 66 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800849:	50                   	push   %eax
  80084a:	68 dd 29 80 00       	push   $0x8029dd
  80084f:	53                   	push   %ebx
  800850:	56                   	push   %esi
  800851:	e8 92 fe ff ff       	call   8006e8 <printfmt>
  800856:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800859:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80085c:	e9 4e 02 00 00       	jmp    800aaf <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 c0 04             	add    $0x4,%eax
  800867:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80086f:	85 d2                	test   %edx,%edx
  800871:	b8 d6 29 80 00       	mov    $0x8029d6,%eax
  800876:	0f 45 c2             	cmovne %edx,%eax
  800879:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80087c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800880:	7e 06                	jle    800888 <vprintfmt+0x17f>
  800882:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800886:	75 0d                	jne    800895 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80088b:	89 c7                	mov    %eax,%edi
  80088d:	03 45 e0             	add    -0x20(%ebp),%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800893:	eb 55                	jmp    8008ea <vprintfmt+0x1e1>
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 d8             	pushl  -0x28(%ebp)
  80089b:	ff 75 cc             	pushl  -0x34(%ebp)
  80089e:	e8 46 03 00 00       	call   800be9 <strnlen>
  8008a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a6:	29 c2                	sub    %eax,%edx
  8008a8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8008ab:	83 c4 10             	add    $0x10,%esp
  8008ae:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8008b0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8008b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	85 ff                	test   %edi,%edi
  8008b9:	7e 11                	jle    8008cc <vprintfmt+0x1c3>
					putch(padc, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c4:	83 ef 01             	sub    $0x1,%edi
  8008c7:	83 c4 10             	add    $0x10,%esp
  8008ca:	eb eb                	jmp    8008b7 <vprintfmt+0x1ae>
  8008cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008cf:	85 d2                	test   %edx,%edx
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	0f 49 c2             	cmovns %edx,%eax
  8008d9:	29 c2                	sub    %eax,%edx
  8008db:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8008de:	eb a8                	jmp    800888 <vprintfmt+0x17f>
					putch(ch, putdat);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	53                   	push   %ebx
  8008e4:	52                   	push   %edx
  8008e5:	ff d6                	call   *%esi
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008ed:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ef:	83 c7 01             	add    $0x1,%edi
  8008f2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8008f6:	0f be d0             	movsbl %al,%edx
  8008f9:	85 d2                	test   %edx,%edx
  8008fb:	74 4b                	je     800948 <vprintfmt+0x23f>
  8008fd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800901:	78 06                	js     800909 <vprintfmt+0x200>
  800903:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800907:	78 1e                	js     800927 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800909:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80090d:	74 d1                	je     8008e0 <vprintfmt+0x1d7>
  80090f:	0f be c0             	movsbl %al,%eax
  800912:	83 e8 20             	sub    $0x20,%eax
  800915:	83 f8 5e             	cmp    $0x5e,%eax
  800918:	76 c6                	jbe    8008e0 <vprintfmt+0x1d7>
					putch('?', putdat);
  80091a:	83 ec 08             	sub    $0x8,%esp
  80091d:	53                   	push   %ebx
  80091e:	6a 3f                	push   $0x3f
  800920:	ff d6                	call   *%esi
  800922:	83 c4 10             	add    $0x10,%esp
  800925:	eb c3                	jmp    8008ea <vprintfmt+0x1e1>
  800927:	89 cf                	mov    %ecx,%edi
  800929:	eb 0e                	jmp    800939 <vprintfmt+0x230>
				putch(' ', putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	53                   	push   %ebx
  80092f:	6a 20                	push   $0x20
  800931:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800933:	83 ef 01             	sub    $0x1,%edi
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	85 ff                	test   %edi,%edi
  80093b:	7f ee                	jg     80092b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80093d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800940:	89 45 14             	mov    %eax,0x14(%ebp)
  800943:	e9 67 01 00 00       	jmp    800aaf <vprintfmt+0x3a6>
  800948:	89 cf                	mov    %ecx,%edi
  80094a:	eb ed                	jmp    800939 <vprintfmt+0x230>
	if (lflag >= 2)
  80094c:	83 f9 01             	cmp    $0x1,%ecx
  80094f:	7f 1b                	jg     80096c <vprintfmt+0x263>
	else if (lflag)
  800951:	85 c9                	test   %ecx,%ecx
  800953:	74 63                	je     8009b8 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	99                   	cltd   
  80095e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 40 04             	lea    0x4(%eax),%eax
  800967:	89 45 14             	mov    %eax,0x14(%ebp)
  80096a:	eb 17                	jmp    800983 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8b 50 04             	mov    0x4(%eax),%edx
  800972:	8b 00                	mov    (%eax),%eax
  800974:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800977:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80097a:	8b 45 14             	mov    0x14(%ebp),%eax
  80097d:	8d 40 08             	lea    0x8(%eax),%eax
  800980:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800983:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800986:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800989:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80098e:	85 c9                	test   %ecx,%ecx
  800990:	0f 89 ff 00 00 00    	jns    800a95 <vprintfmt+0x38c>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	53                   	push   %ebx
  80099a:	6a 2d                	push   $0x2d
  80099c:	ff d6                	call   *%esi
				num = -(long long) num;
  80099e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8009a4:	f7 da                	neg    %edx
  8009a6:	83 d1 00             	adc    $0x0,%ecx
  8009a9:	f7 d9                	neg    %ecx
  8009ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b3:	e9 dd 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	99                   	cltd   
  8009c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 40 04             	lea    0x4(%eax),%eax
  8009ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8009cd:	eb b4                	jmp    800983 <vprintfmt+0x27a>
	if (lflag >= 2)
  8009cf:	83 f9 01             	cmp    $0x1,%ecx
  8009d2:	7f 1e                	jg     8009f2 <vprintfmt+0x2e9>
	else if (lflag)
  8009d4:	85 c9                	test   %ecx,%ecx
  8009d6:	74 32                	je     800a0a <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	8b 10                	mov    (%eax),%edx
  8009dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009e2:	8d 40 04             	lea    0x4(%eax),%eax
  8009e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8009e8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8009ed:	e9 a3 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	8b 10                	mov    (%eax),%edx
  8009f7:	8b 48 04             	mov    0x4(%eax),%ecx
  8009fa:	8d 40 08             	lea    0x8(%eax),%eax
  8009fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a00:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800a05:	e9 8b 00 00 00       	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	8b 10                	mov    (%eax),%edx
  800a0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a14:	8d 40 04             	lea    0x4(%eax),%eax
  800a17:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a1a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800a1f:	eb 74                	jmp    800a95 <vprintfmt+0x38c>
	if (lflag >= 2)
  800a21:	83 f9 01             	cmp    $0x1,%ecx
  800a24:	7f 1b                	jg     800a41 <vprintfmt+0x338>
	else if (lflag)
  800a26:	85 c9                	test   %ecx,%ecx
  800a28:	74 2c                	je     800a56 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2d:	8b 10                	mov    (%eax),%edx
  800a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a34:	8d 40 04             	lea    0x4(%eax),%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a3a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800a3f:	eb 54                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800a41:	8b 45 14             	mov    0x14(%ebp),%eax
  800a44:	8b 10                	mov    (%eax),%edx
  800a46:	8b 48 04             	mov    0x4(%eax),%ecx
  800a49:	8d 40 08             	lea    0x8(%eax),%eax
  800a4c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a4f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800a54:	eb 3f                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	8b 10                	mov    (%eax),%edx
  800a5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a60:	8d 40 04             	lea    0x4(%eax),%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a66:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800a6b:	eb 28                	jmp    800a95 <vprintfmt+0x38c>
			putch('0', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	53                   	push   %ebx
  800a71:	6a 30                	push   $0x30
  800a73:	ff d6                	call   *%esi
			putch('x', putdat);
  800a75:	83 c4 08             	add    $0x8,%esp
  800a78:	53                   	push   %ebx
  800a79:	6a 78                	push   $0x78
  800a7b:	ff d6                	call   *%esi
			num = (unsigned long long)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8b 10                	mov    (%eax),%edx
  800a82:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800a87:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800a8a:	8d 40 04             	lea    0x4(%eax),%eax
  800a8d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a90:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800a95:	83 ec 0c             	sub    $0xc,%esp
  800a98:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800a9c:	57                   	push   %edi
  800a9d:	ff 75 e0             	pushl  -0x20(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	51                   	push   %ecx
  800aa2:	52                   	push   %edx
  800aa3:	89 da                	mov    %ebx,%edx
  800aa5:	89 f0                	mov    %esi,%eax
  800aa7:	e8 72 fb ff ff       	call   80061e <printnum>
			break;
  800aac:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800aaf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ab2:	83 c7 01             	add    $0x1,%edi
  800ab5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ab9:	83 f8 25             	cmp    $0x25,%eax
  800abc:	0f 84 62 fc ff ff    	je     800724 <vprintfmt+0x1b>
			if (ch == '\0')
  800ac2:	85 c0                	test   %eax,%eax
  800ac4:	0f 84 8b 00 00 00    	je     800b55 <vprintfmt+0x44c>
			putch(ch, putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	53                   	push   %ebx
  800ace:	50                   	push   %eax
  800acf:	ff d6                	call   *%esi
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	eb dc                	jmp    800ab2 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ad6:	83 f9 01             	cmp    $0x1,%ecx
  800ad9:	7f 1b                	jg     800af6 <vprintfmt+0x3ed>
	else if (lflag)
  800adb:	85 c9                	test   %ecx,%ecx
  800add:	74 2c                	je     800b0b <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8b 10                	mov    (%eax),%edx
  800ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae9:	8d 40 04             	lea    0x4(%eax),%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800aef:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800af4:	eb 9f                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	8b 10                	mov    (%eax),%edx
  800afb:	8b 48 04             	mov    0x4(%eax),%ecx
  800afe:	8d 40 08             	lea    0x8(%eax),%eax
  800b01:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b04:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800b09:	eb 8a                	jmp    800a95 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	8b 10                	mov    (%eax),%edx
  800b10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b15:	8d 40 04             	lea    0x4(%eax),%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b1b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800b20:	e9 70 ff ff ff       	jmp    800a95 <vprintfmt+0x38c>
			putch(ch, putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	53                   	push   %ebx
  800b29:	6a 25                	push   $0x25
  800b2b:	ff d6                	call   *%esi
			break;
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	e9 7a ff ff ff       	jmp    800aaf <vprintfmt+0x3a6>
			putch('%', putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	53                   	push   %ebx
  800b39:	6a 25                	push   $0x25
  800b3b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	89 f8                	mov    %edi,%eax
  800b42:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b46:	74 05                	je     800b4d <vprintfmt+0x444>
  800b48:	83 e8 01             	sub    $0x1,%eax
  800b4b:	eb f5                	jmp    800b42 <vprintfmt+0x439>
  800b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b50:	e9 5a ff ff ff       	jmp    800aaf <vprintfmt+0x3a6>
}
  800b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5f                   	pop    %edi
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b70:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b74:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b7e:	85 c0                	test   %eax,%eax
  800b80:	74 26                	je     800ba8 <vsnprintf+0x4b>
  800b82:	85 d2                	test   %edx,%edx
  800b84:	7e 22                	jle    800ba8 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b86:	ff 75 14             	pushl  0x14(%ebp)
  800b89:	ff 75 10             	pushl  0x10(%ebp)
  800b8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b8f:	50                   	push   %eax
  800b90:	68 c7 06 80 00       	push   $0x8006c7
  800b95:	e8 6f fb ff ff       	call   800709 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    
		return -E_INVAL;
  800ba8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bad:	eb f7                	jmp    800ba6 <vsnprintf+0x49>

00800baf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800baf:	f3 0f 1e fb          	endbr32 
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bbc:	50                   	push   %eax
  800bbd:	ff 75 10             	pushl  0x10(%ebp)
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	ff 75 08             	pushl  0x8(%ebp)
  800bc6:	e8 92 ff ff ff       	call   800b5d <vsnprintf>
	va_end(ap);

	return rc;
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800be0:	74 05                	je     800be7 <strlen+0x1a>
		n++;
  800be2:	83 c0 01             	add    $0x1,%eax
  800be5:	eb f5                	jmp    800bdc <strlen+0xf>
	return n;
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	39 d0                	cmp    %edx,%eax
  800bfd:	74 0d                	je     800c0c <strnlen+0x23>
  800bff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c03:	74 05                	je     800c0a <strnlen+0x21>
		n++;
  800c05:	83 c0 01             	add    $0x1,%eax
  800c08:	eb f1                	jmp    800bfb <strnlen+0x12>
  800c0a:	89 c2                	mov    %eax,%edx
	return n;
}
  800c0c:	89 d0                	mov    %edx,%eax
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c10:	f3 0f 1e fb          	endbr32 
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	53                   	push   %ebx
  800c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c23:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800c27:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	84 d2                	test   %dl,%dl
  800c2f:	75 f2                	jne    800c23 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800c31:	89 c8                	mov    %ecx,%eax
  800c33:	5b                   	pop    %ebx
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c36:	f3 0f 1e fb          	endbr32 
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	53                   	push   %ebx
  800c3e:	83 ec 10             	sub    $0x10,%esp
  800c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c44:	53                   	push   %ebx
  800c45:	e8 83 ff ff ff       	call   800bcd <strlen>
  800c4a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	01 d8                	add    %ebx,%eax
  800c52:	50                   	push   %eax
  800c53:	e8 b8 ff ff ff       	call   800c10 <strcpy>
	return dst;
}
  800c58:	89 d8                	mov    %ebx,%eax
  800c5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	8b 75 08             	mov    0x8(%ebp),%esi
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	89 f3                	mov    %esi,%ebx
  800c70:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c73:	89 f0                	mov    %esi,%eax
  800c75:	39 d8                	cmp    %ebx,%eax
  800c77:	74 11                	je     800c8a <strncpy+0x2b>
		*dst++ = *src;
  800c79:	83 c0 01             	add    $0x1,%eax
  800c7c:	0f b6 0a             	movzbl (%edx),%ecx
  800c7f:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c82:	80 f9 01             	cmp    $0x1,%cl
  800c85:	83 da ff             	sbb    $0xffffffff,%edx
  800c88:	eb eb                	jmp    800c75 <strncpy+0x16>
	}
	return ret;
}
  800c8a:	89 f0                	mov    %esi,%eax
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c90:	f3 0f 1e fb          	endbr32 
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9f:	8b 55 10             	mov    0x10(%ebp),%edx
  800ca2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ca4:	85 d2                	test   %edx,%edx
  800ca6:	74 21                	je     800cc9 <strlcpy+0x39>
  800ca8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800cac:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800cae:	39 c2                	cmp    %eax,%edx
  800cb0:	74 14                	je     800cc6 <strlcpy+0x36>
  800cb2:	0f b6 19             	movzbl (%ecx),%ebx
  800cb5:	84 db                	test   %bl,%bl
  800cb7:	74 0b                	je     800cc4 <strlcpy+0x34>
			*dst++ = *src++;
  800cb9:	83 c1 01             	add    $0x1,%ecx
  800cbc:	83 c2 01             	add    $0x1,%edx
  800cbf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cc2:	eb ea                	jmp    800cae <strlcpy+0x1e>
  800cc4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800cc6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc9:	29 f0                	sub    %esi,%eax
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ccf:	f3 0f 1e fb          	endbr32 
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cdc:	0f b6 01             	movzbl (%ecx),%eax
  800cdf:	84 c0                	test   %al,%al
  800ce1:	74 0c                	je     800cef <strcmp+0x20>
  800ce3:	3a 02                	cmp    (%edx),%al
  800ce5:	75 08                	jne    800cef <strcmp+0x20>
		p++, q++;
  800ce7:	83 c1 01             	add    $0x1,%ecx
  800cea:	83 c2 01             	add    $0x1,%edx
  800ced:	eb ed                	jmp    800cdc <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	0f b6 c0             	movzbl %al,%eax
  800cf2:	0f b6 12             	movzbl (%edx),%edx
  800cf5:	29 d0                	sub    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cf9:	f3 0f 1e fb          	endbr32 
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	53                   	push   %ebx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d0c:	eb 06                	jmp    800d14 <strncmp+0x1b>
		n--, p++, q++;
  800d0e:	83 c0 01             	add    $0x1,%eax
  800d11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800d14:	39 d8                	cmp    %ebx,%eax
  800d16:	74 16                	je     800d2e <strncmp+0x35>
  800d18:	0f b6 08             	movzbl (%eax),%ecx
  800d1b:	84 c9                	test   %cl,%cl
  800d1d:	74 04                	je     800d23 <strncmp+0x2a>
  800d1f:	3a 0a                	cmp    (%edx),%cl
  800d21:	74 eb                	je     800d0e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	0f b6 00             	movzbl (%eax),%eax
  800d26:	0f b6 12             	movzbl (%edx),%edx
  800d29:	29 d0                	sub    %edx,%eax
}
  800d2b:	5b                   	pop    %ebx
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		return 0;
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	eb f6                	jmp    800d2b <strncmp+0x32>

00800d35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d35:	f3 0f 1e fb          	endbr32 
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d43:	0f b6 10             	movzbl (%eax),%edx
  800d46:	84 d2                	test   %dl,%dl
  800d48:	74 09                	je     800d53 <strchr+0x1e>
		if (*s == c)
  800d4a:	38 ca                	cmp    %cl,%dl
  800d4c:	74 0a                	je     800d58 <strchr+0x23>
	for (; *s; s++)
  800d4e:	83 c0 01             	add    $0x1,%eax
  800d51:	eb f0                	jmp    800d43 <strchr+0xe>
			return (char *) s;
	return 0;
  800d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d5a:	f3 0f 1e fb          	endbr32 
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d68:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800d6b:	38 ca                	cmp    %cl,%dl
  800d6d:	74 09                	je     800d78 <strfind+0x1e>
  800d6f:	84 d2                	test   %dl,%dl
  800d71:	74 05                	je     800d78 <strfind+0x1e>
	for (; *s; s++)
  800d73:	83 c0 01             	add    $0x1,%eax
  800d76:	eb f0                	jmp    800d68 <strfind+0xe>
			break;
	return (char *) s;
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d7a:	f3 0f 1e fb          	endbr32 
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d87:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d8a:	85 c9                	test   %ecx,%ecx
  800d8c:	74 31                	je     800dbf <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8e:	89 f8                	mov    %edi,%eax
  800d90:	09 c8                	or     %ecx,%eax
  800d92:	a8 03                	test   $0x3,%al
  800d94:	75 23                	jne    800db9 <memset+0x3f>
		c &= 0xFF;
  800d96:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d9a:	89 d3                	mov    %edx,%ebx
  800d9c:	c1 e3 08             	shl    $0x8,%ebx
  800d9f:	89 d0                	mov    %edx,%eax
  800da1:	c1 e0 18             	shl    $0x18,%eax
  800da4:	89 d6                	mov    %edx,%esi
  800da6:	c1 e6 10             	shl    $0x10,%esi
  800da9:	09 f0                	or     %esi,%eax
  800dab:	09 c2                	or     %eax,%edx
  800dad:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800daf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800db2:	89 d0                	mov    %edx,%eax
  800db4:	fc                   	cld    
  800db5:	f3 ab                	rep stos %eax,%es:(%edi)
  800db7:	eb 06                	jmp    800dbf <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	fc                   	cld    
  800dbd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dbf:	89 f8                	mov    %edi,%eax
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd8:	39 c6                	cmp    %eax,%esi
  800dda:	73 32                	jae    800e0e <memmove+0x48>
  800ddc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ddf:	39 c2                	cmp    %eax,%edx
  800de1:	76 2b                	jbe    800e0e <memmove+0x48>
		s += n;
		d += n;
  800de3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de6:	89 fe                	mov    %edi,%esi
  800de8:	09 ce                	or     %ecx,%esi
  800dea:	09 d6                	or     %edx,%esi
  800dec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800df2:	75 0e                	jne    800e02 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800df4:	83 ef 04             	sub    $0x4,%edi
  800df7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dfa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dfd:	fd                   	std    
  800dfe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e00:	eb 09                	jmp    800e0b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e02:	83 ef 01             	sub    $0x1,%edi
  800e05:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800e08:	fd                   	std    
  800e09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e0b:	fc                   	cld    
  800e0c:	eb 1a                	jmp    800e28 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e0e:	89 c2                	mov    %eax,%edx
  800e10:	09 ca                	or     %ecx,%edx
  800e12:	09 f2                	or     %esi,%edx
  800e14:	f6 c2 03             	test   $0x3,%dl
  800e17:	75 0a                	jne    800e23 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800e1c:	89 c7                	mov    %eax,%edi
  800e1e:	fc                   	cld    
  800e1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e21:	eb 05                	jmp    800e28 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800e23:	89 c7                	mov    %eax,%edi
  800e25:	fc                   	cld    
  800e26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e2c:	f3 0f 1e fb          	endbr32 
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e36:	ff 75 10             	pushl  0x10(%ebp)
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	ff 75 08             	pushl  0x8(%ebp)
  800e3f:	e8 82 ff ff ff       	call   800dc6 <memmove>
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e46:	f3 0f 1e fb          	endbr32 
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e55:	89 c6                	mov    %eax,%esi
  800e57:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5a:	39 f0                	cmp    %esi,%eax
  800e5c:	74 1c                	je     800e7a <memcmp+0x34>
		if (*s1 != *s2)
  800e5e:	0f b6 08             	movzbl (%eax),%ecx
  800e61:	0f b6 1a             	movzbl (%edx),%ebx
  800e64:	38 d9                	cmp    %bl,%cl
  800e66:	75 08                	jne    800e70 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e68:	83 c0 01             	add    $0x1,%eax
  800e6b:	83 c2 01             	add    $0x1,%edx
  800e6e:	eb ea                	jmp    800e5a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800e70:	0f b6 c1             	movzbl %cl,%eax
  800e73:	0f b6 db             	movzbl %bl,%ebx
  800e76:	29 d8                	sub    %ebx,%eax
  800e78:	eb 05                	jmp    800e7f <memcmp+0x39>
	}

	return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7f:	5b                   	pop    %ebx
  800e80:	5e                   	pop    %esi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e83:	f3 0f 1e fb          	endbr32 
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e90:	89 c2                	mov    %eax,%edx
  800e92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e95:	39 d0                	cmp    %edx,%eax
  800e97:	73 09                	jae    800ea2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e99:	38 08                	cmp    %cl,(%eax)
  800e9b:	74 05                	je     800ea2 <memfind+0x1f>
	for (; s < ends; s++)
  800e9d:	83 c0 01             	add    $0x1,%eax
  800ea0:	eb f3                	jmp    800e95 <memfind+0x12>
			break;
	return (void *) s;
}
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ea4:	f3 0f 1e fb          	endbr32 
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb4:	eb 03                	jmp    800eb9 <strtol+0x15>
		s++;
  800eb6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800eb9:	0f b6 01             	movzbl (%ecx),%eax
  800ebc:	3c 20                	cmp    $0x20,%al
  800ebe:	74 f6                	je     800eb6 <strtol+0x12>
  800ec0:	3c 09                	cmp    $0x9,%al
  800ec2:	74 f2                	je     800eb6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ec4:	3c 2b                	cmp    $0x2b,%al
  800ec6:	74 2a                	je     800ef2 <strtol+0x4e>
	int neg = 0;
  800ec8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ecd:	3c 2d                	cmp    $0x2d,%al
  800ecf:	74 2b                	je     800efc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ed7:	75 0f                	jne    800ee8 <strtol+0x44>
  800ed9:	80 39 30             	cmpb   $0x30,(%ecx)
  800edc:	74 28                	je     800f06 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee5:	0f 44 d8             	cmove  %eax,%ebx
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ef0:	eb 46                	jmp    800f38 <strtol+0x94>
		s++;
  800ef2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ef5:	bf 00 00 00 00       	mov    $0x0,%edi
  800efa:	eb d5                	jmp    800ed1 <strtol+0x2d>
		s++, neg = 1;
  800efc:	83 c1 01             	add    $0x1,%ecx
  800eff:	bf 01 00 00 00       	mov    $0x1,%edi
  800f04:	eb cb                	jmp    800ed1 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f06:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800f0a:	74 0e                	je     800f1a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800f0c:	85 db                	test   %ebx,%ebx
  800f0e:	75 d8                	jne    800ee8 <strtol+0x44>
		s++, base = 8;
  800f10:	83 c1 01             	add    $0x1,%ecx
  800f13:	bb 08 00 00 00       	mov    $0x8,%ebx
  800f18:	eb ce                	jmp    800ee8 <strtol+0x44>
		s += 2, base = 16;
  800f1a:	83 c1 02             	add    $0x2,%ecx
  800f1d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800f22:	eb c4                	jmp    800ee8 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800f24:	0f be d2             	movsbl %dl,%edx
  800f27:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800f2a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800f2d:	7d 3a                	jge    800f69 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800f2f:	83 c1 01             	add    $0x1,%ecx
  800f32:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f36:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800f38:	0f b6 11             	movzbl (%ecx),%edx
  800f3b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800f3e:	89 f3                	mov    %esi,%ebx
  800f40:	80 fb 09             	cmp    $0x9,%bl
  800f43:	76 df                	jbe    800f24 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800f45:	8d 72 9f             	lea    -0x61(%edx),%esi
  800f48:	89 f3                	mov    %esi,%ebx
  800f4a:	80 fb 19             	cmp    $0x19,%bl
  800f4d:	77 08                	ja     800f57 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800f4f:	0f be d2             	movsbl %dl,%edx
  800f52:	83 ea 57             	sub    $0x57,%edx
  800f55:	eb d3                	jmp    800f2a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800f57:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f5a:	89 f3                	mov    %esi,%ebx
  800f5c:	80 fb 19             	cmp    $0x19,%bl
  800f5f:	77 08                	ja     800f69 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800f61:	0f be d2             	movsbl %dl,%edx
  800f64:	83 ea 37             	sub    $0x37,%edx
  800f67:	eb c1                	jmp    800f2a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6d:	74 05                	je     800f74 <strtol+0xd0>
		*endptr = (char *) s;
  800f6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f72:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	f7 da                	neg    %edx
  800f78:	85 ff                	test   %edi,%edi
  800f7a:	0f 45 c2             	cmovne %edx,%eax
}
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f82:	f3 0f 1e fb          	endbr32 
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	89 c3                	mov    %eax,%ebx
  800f99:	89 c7                	mov    %eax,%edi
  800f9b:	89 c6                	mov    %eax,%esi
  800f9d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fa4:	f3 0f 1e fb          	endbr32 
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb8:	89 d1                	mov    %edx,%ecx
  800fba:	89 d3                	mov    %edx,%ebx
  800fbc:	89 d7                	mov    %edx,%edi
  800fbe:	89 d6                	mov    %edx,%esi
  800fc0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc7:	f3 0f 1e fb          	endbr32 
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe1:	89 cb                	mov    %ecx,%ebx
  800fe3:	89 cf                	mov    %ecx,%edi
  800fe5:	89 ce                	mov    %ecx,%esi
  800fe7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7f 08                	jg     800ff5 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff0:	5b                   	pop    %ebx
  800ff1:	5e                   	pop    %esi
  800ff2:	5f                   	pop    %edi
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	50                   	push   %eax
  800ff9:	6a 03                	push   $0x3
  800ffb:	68 bf 2c 80 00       	push   $0x802cbf
  801000:	6a 23                	push   $0x23
  801002:	68 dc 2c 80 00       	push   $0x802cdc
  801007:	e8 7c 14 00 00       	call   802488 <_panic>

0080100c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80100c:	f3 0f 1e fb          	endbr32 
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
	asm volatile("int %1\n"
  801016:	ba 00 00 00 00       	mov    $0x0,%edx
  80101b:	b8 02 00 00 00       	mov    $0x2,%eax
  801020:	89 d1                	mov    %edx,%ecx
  801022:	89 d3                	mov    %edx,%ebx
  801024:	89 d7                	mov    %edx,%edi
  801026:	89 d6                	mov    %edx,%esi
  801028:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <sys_yield>:

void
sys_yield(void)
{
  80102f:	f3 0f 1e fb          	endbr32 
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
	asm volatile("int %1\n"
  801039:	ba 00 00 00 00       	mov    $0x0,%edx
  80103e:	b8 0b 00 00 00       	mov    $0xb,%eax
  801043:	89 d1                	mov    %edx,%ecx
  801045:	89 d3                	mov    %edx,%ebx
  801047:	89 d7                	mov    %edx,%edi
  801049:	89 d6                	mov    %edx,%esi
  80104b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801052:	f3 0f 1e fb          	endbr32 
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
  80105c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80105f:	be 00 00 00 00       	mov    $0x0,%esi
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	b8 04 00 00 00       	mov    $0x4,%eax
  80106f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801072:	89 f7                	mov    %esi,%edi
  801074:	cd 30                	int    $0x30
	if(check && ret > 0)
  801076:	85 c0                	test   %eax,%eax
  801078:	7f 08                	jg     801082 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80107a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	50                   	push   %eax
  801086:	6a 04                	push   $0x4
  801088:	68 bf 2c 80 00       	push   $0x802cbf
  80108d:	6a 23                	push   $0x23
  80108f:	68 dc 2c 80 00       	push   $0x802cdc
  801094:	e8 ef 13 00 00       	call   802488 <_panic>

00801099 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801099:	f3 0f 1e fb          	endbr32 
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ba:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7f 08                	jg     8010c8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	50                   	push   %eax
  8010cc:	6a 05                	push   $0x5
  8010ce:	68 bf 2c 80 00       	push   $0x802cbf
  8010d3:	6a 23                	push   $0x23
  8010d5:	68 dc 2c 80 00       	push   $0x802cdc
  8010da:	e8 a9 13 00 00       	call   802488 <_panic>

008010df <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010df:	f3 0f 1e fb          	endbr32 
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f7:	b8 06 00 00 00       	mov    $0x6,%eax
  8010fc:	89 df                	mov    %ebx,%edi
  8010fe:	89 de                	mov    %ebx,%esi
  801100:	cd 30                	int    $0x30
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7f 08                	jg     80110e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801106:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801109:	5b                   	pop    %ebx
  80110a:	5e                   	pop    %esi
  80110b:	5f                   	pop    %edi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	6a 06                	push   $0x6
  801114:	68 bf 2c 80 00       	push   $0x802cbf
  801119:	6a 23                	push   $0x23
  80111b:	68 dc 2c 80 00       	push   $0x802cdc
  801120:	e8 63 13 00 00       	call   802488 <_panic>

00801125 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801125:	f3 0f 1e fb          	endbr32 
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	57                   	push   %edi
  80112d:	56                   	push   %esi
  80112e:	53                   	push   %ebx
  80112f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
  801137:	8b 55 08             	mov    0x8(%ebp),%edx
  80113a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113d:	b8 08 00 00 00       	mov    $0x8,%eax
  801142:	89 df                	mov    %ebx,%edi
  801144:	89 de                	mov    %ebx,%esi
  801146:	cd 30                	int    $0x30
	if(check && ret > 0)
  801148:	85 c0                	test   %eax,%eax
  80114a:	7f 08                	jg     801154 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80114c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	50                   	push   %eax
  801158:	6a 08                	push   $0x8
  80115a:	68 bf 2c 80 00       	push   $0x802cbf
  80115f:	6a 23                	push   $0x23
  801161:	68 dc 2c 80 00       	push   $0x802cdc
  801166:	e8 1d 13 00 00       	call   802488 <_panic>

0080116b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117d:	8b 55 08             	mov    0x8(%ebp),%edx
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	b8 09 00 00 00       	mov    $0x9,%eax
  801188:	89 df                	mov    %ebx,%edi
  80118a:	89 de                	mov    %ebx,%esi
  80118c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	7f 08                	jg     80119a <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801192:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	50                   	push   %eax
  80119e:	6a 09                	push   $0x9
  8011a0:	68 bf 2c 80 00       	push   $0x802cbf
  8011a5:	6a 23                	push   $0x23
  8011a7:	68 dc 2c 80 00       	push   $0x802cdc
  8011ac:	e8 d7 12 00 00       	call   802488 <_panic>

008011b1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011b1:	f3 0f 1e fb          	endbr32 
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	57                   	push   %edi
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011ce:	89 df                	mov    %ebx,%edi
  8011d0:	89 de                	mov    %ebx,%esi
  8011d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	7f 08                	jg     8011e0 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011db:	5b                   	pop    %ebx
  8011dc:	5e                   	pop    %esi
  8011dd:	5f                   	pop    %edi
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	50                   	push   %eax
  8011e4:	6a 0a                	push   $0xa
  8011e6:	68 bf 2c 80 00       	push   $0x802cbf
  8011eb:	6a 23                	push   $0x23
  8011ed:	68 dc 2c 80 00       	push   $0x802cdc
  8011f2:	e8 91 12 00 00       	call   802488 <_panic>

008011f7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011f7:	f3 0f 1e fb          	endbr32 
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
	asm volatile("int %1\n"
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801207:	b8 0c 00 00 00       	mov    $0xc,%eax
  80120c:	be 00 00 00 00       	mov    $0x0,%esi
  801211:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801214:	8b 7d 14             	mov    0x14(%ebp),%edi
  801217:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80121e:	f3 0f 1e fb          	endbr32 
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	57                   	push   %edi
  801226:	56                   	push   %esi
  801227:	53                   	push   %ebx
  801228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801230:	8b 55 08             	mov    0x8(%ebp),%edx
  801233:	b8 0d 00 00 00       	mov    $0xd,%eax
  801238:	89 cb                	mov    %ecx,%ebx
  80123a:	89 cf                	mov    %ecx,%edi
  80123c:	89 ce                	mov    %ecx,%esi
  80123e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801240:	85 c0                	test   %eax,%eax
  801242:	7f 08                	jg     80124c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	50                   	push   %eax
  801250:	6a 0d                	push   $0xd
  801252:	68 bf 2c 80 00       	push   $0x802cbf
  801257:	6a 23                	push   $0x23
  801259:	68 dc 2c 80 00       	push   $0x802cdc
  80125e:	e8 25 12 00 00       	call   802488 <_panic>

00801263 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801263:	f3 0f 1e fb          	endbr32 
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126d:	ba 00 00 00 00       	mov    $0x0,%edx
  801272:	b8 0e 00 00 00       	mov    $0xe,%eax
  801277:	89 d1                	mov    %edx,%ecx
  801279:	89 d3                	mov    %edx,%ebx
  80127b:	89 d7                	mov    %edx,%edi
  80127d:	89 d6                	mov    %edx,%esi
  80127f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801281:	5b                   	pop    %ebx
  801282:	5e                   	pop    %esi
  801283:	5f                   	pop    %edi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801286:	f3 0f 1e fb          	endbr32 
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	05 00 00 00 30       	add    $0x30000000,%eax
  801295:	c1 e8 0c             	shr    $0xc,%eax
}
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    

0080129a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80129a:	f3 0f 1e fb          	endbr32 
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ae:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b3:	5d                   	pop    %ebp
  8012b4:	c3                   	ret    

008012b5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012b5:	f3 0f 1e fb          	endbr32 
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c1:	89 c2                	mov    %eax,%edx
  8012c3:	c1 ea 16             	shr    $0x16,%edx
  8012c6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cd:	f6 c2 01             	test   $0x1,%dl
  8012d0:	74 2d                	je     8012ff <fd_alloc+0x4a>
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	c1 ea 0c             	shr    $0xc,%edx
  8012d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	74 1c                	je     8012ff <fd_alloc+0x4a>
  8012e3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012e8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ed:	75 d2                	jne    8012c1 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8012f8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012fd:	eb 0a                	jmp    801309 <fd_alloc+0x54>
			*fd_store = fd;
  8012ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801302:	89 01                	mov    %eax,(%ecx)
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80130b:	f3 0f 1e fb          	endbr32 
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801315:	83 f8 1f             	cmp    $0x1f,%eax
  801318:	77 30                	ja     80134a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80131a:	c1 e0 0c             	shl    $0xc,%eax
  80131d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801322:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	74 24                	je     801351 <fd_lookup+0x46>
  80132d:	89 c2                	mov    %eax,%edx
  80132f:	c1 ea 0c             	shr    $0xc,%edx
  801332:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801339:	f6 c2 01             	test   $0x1,%dl
  80133c:	74 1a                	je     801358 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80133e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801341:	89 02                	mov    %eax,(%edx)
	return 0;
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    
		return -E_INVAL;
  80134a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134f:	eb f7                	jmp    801348 <fd_lookup+0x3d>
		return -E_INVAL;
  801351:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801356:	eb f0                	jmp    801348 <fd_lookup+0x3d>
  801358:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135d:	eb e9                	jmp    801348 <fd_lookup+0x3d>

0080135f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80135f:	f3 0f 1e fb          	endbr32 
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80136c:	ba 00 00 00 00       	mov    $0x0,%edx
  801371:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801376:	39 08                	cmp    %ecx,(%eax)
  801378:	74 38                	je     8013b2 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80137a:	83 c2 01             	add    $0x1,%edx
  80137d:	8b 04 95 68 2d 80 00 	mov    0x802d68(,%edx,4),%eax
  801384:	85 c0                	test   %eax,%eax
  801386:	75 ee                	jne    801376 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801388:	a1 18 40 80 00       	mov    0x804018,%eax
  80138d:	8b 40 48             	mov    0x48(%eax),%eax
  801390:	83 ec 04             	sub    $0x4,%esp
  801393:	51                   	push   %ecx
  801394:	50                   	push   %eax
  801395:	68 ec 2c 80 00       	push   $0x802cec
  80139a:	e8 67 f2 ff ff       	call   800606 <cprintf>
	*dev = 0;
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    
			*dev = devtab[i];
  8013b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb f2                	jmp    8013b0 <dev_lookup+0x51>

008013be <fd_close>:
{
  8013be:	f3 0f 1e fb          	endbr32 
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	57                   	push   %edi
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	83 ec 24             	sub    $0x24,%esp
  8013cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8013ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013de:	50                   	push   %eax
  8013df:	e8 27 ff ff ff       	call   80130b <fd_lookup>
  8013e4:	89 c3                	mov    %eax,%ebx
  8013e6:	83 c4 10             	add    $0x10,%esp
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	78 05                	js     8013f2 <fd_close+0x34>
	    || fd != fd2)
  8013ed:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013f0:	74 16                	je     801408 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013f2:	89 f8                	mov    %edi,%eax
  8013f4:	84 c0                	test   %al,%al
  8013f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fb:	0f 44 d8             	cmove  %eax,%ebx
}
  8013fe:	89 d8                	mov    %ebx,%eax
  801400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801403:	5b                   	pop    %ebx
  801404:	5e                   	pop    %esi
  801405:	5f                   	pop    %edi
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	ff 36                	pushl  (%esi)
  801411:	e8 49 ff ff ff       	call   80135f <dev_lookup>
  801416:	89 c3                	mov    %eax,%ebx
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 1a                	js     801439 <fd_close+0x7b>
		if (dev->dev_close)
  80141f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801422:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801425:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80142a:	85 c0                	test   %eax,%eax
  80142c:	74 0b                	je     801439 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80142e:	83 ec 0c             	sub    $0xc,%esp
  801431:	56                   	push   %esi
  801432:	ff d0                	call   *%eax
  801434:	89 c3                	mov    %eax,%ebx
  801436:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	56                   	push   %esi
  80143d:	6a 00                	push   $0x0
  80143f:	e8 9b fc ff ff       	call   8010df <sys_page_unmap>
	return r;
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	eb b5                	jmp    8013fe <fd_close+0x40>

00801449 <close>:

int
close(int fdnum)
{
  801449:	f3 0f 1e fb          	endbr32 
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801453:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801456:	50                   	push   %eax
  801457:	ff 75 08             	pushl  0x8(%ebp)
  80145a:	e8 ac fe ff ff       	call   80130b <fd_lookup>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	79 02                	jns    801468 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    
		return fd_close(fd, 1);
  801468:	83 ec 08             	sub    $0x8,%esp
  80146b:	6a 01                	push   $0x1
  80146d:	ff 75 f4             	pushl  -0xc(%ebp)
  801470:	e8 49 ff ff ff       	call   8013be <fd_close>
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	eb ec                	jmp    801466 <close+0x1d>

0080147a <close_all>:

void
close_all(void)
{
  80147a:	f3 0f 1e fb          	endbr32 
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801485:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80148a:	83 ec 0c             	sub    $0xc,%esp
  80148d:	53                   	push   %ebx
  80148e:	e8 b6 ff ff ff       	call   801449 <close>
	for (i = 0; i < MAXFD; i++)
  801493:	83 c3 01             	add    $0x1,%ebx
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	83 fb 20             	cmp    $0x20,%ebx
  80149c:	75 ec                	jne    80148a <close_all+0x10>
}
  80149e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014a3:	f3 0f 1e fb          	endbr32 
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014b3:	50                   	push   %eax
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 4f fe ff ff       	call   80130b <fd_lookup>
  8014bc:	89 c3                	mov    %eax,%ebx
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	0f 88 81 00 00 00    	js     80154a <dup+0xa7>
		return r;
	close(newfdnum);
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	e8 75 ff ff ff       	call   801449 <close>

	newfd = INDEX2FD(newfdnum);
  8014d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014d7:	c1 e6 0c             	shl    $0xc,%esi
  8014da:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014e0:	83 c4 04             	add    $0x4,%esp
  8014e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e6:	e8 af fd ff ff       	call   80129a <fd2data>
  8014eb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014ed:	89 34 24             	mov    %esi,(%esp)
  8014f0:	e8 a5 fd ff ff       	call   80129a <fd2data>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014fa:	89 d8                	mov    %ebx,%eax
  8014fc:	c1 e8 16             	shr    $0x16,%eax
  8014ff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801506:	a8 01                	test   $0x1,%al
  801508:	74 11                	je     80151b <dup+0x78>
  80150a:	89 d8                	mov    %ebx,%eax
  80150c:	c1 e8 0c             	shr    $0xc,%eax
  80150f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801516:	f6 c2 01             	test   $0x1,%dl
  801519:	75 39                	jne    801554 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80151b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80151e:	89 d0                	mov    %edx,%eax
  801520:	c1 e8 0c             	shr    $0xc,%eax
  801523:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80152a:	83 ec 0c             	sub    $0xc,%esp
  80152d:	25 07 0e 00 00       	and    $0xe07,%eax
  801532:	50                   	push   %eax
  801533:	56                   	push   %esi
  801534:	6a 00                	push   $0x0
  801536:	52                   	push   %edx
  801537:	6a 00                	push   $0x0
  801539:	e8 5b fb ff ff       	call   801099 <sys_page_map>
  80153e:	89 c3                	mov    %eax,%ebx
  801540:	83 c4 20             	add    $0x20,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 31                	js     801578 <dup+0xd5>
		goto err;

	return newfdnum;
  801547:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80154a:	89 d8                	mov    %ebx,%eax
  80154c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5f                   	pop    %edi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801554:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155b:	83 ec 0c             	sub    $0xc,%esp
  80155e:	25 07 0e 00 00       	and    $0xe07,%eax
  801563:	50                   	push   %eax
  801564:	57                   	push   %edi
  801565:	6a 00                	push   $0x0
  801567:	53                   	push   %ebx
  801568:	6a 00                	push   $0x0
  80156a:	e8 2a fb ff ff       	call   801099 <sys_page_map>
  80156f:	89 c3                	mov    %eax,%ebx
  801571:	83 c4 20             	add    $0x20,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	79 a3                	jns    80151b <dup+0x78>
	sys_page_unmap(0, newfd);
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	56                   	push   %esi
  80157c:	6a 00                	push   $0x0
  80157e:	e8 5c fb ff ff       	call   8010df <sys_page_unmap>
	sys_page_unmap(0, nva);
  801583:	83 c4 08             	add    $0x8,%esp
  801586:	57                   	push   %edi
  801587:	6a 00                	push   $0x0
  801589:	e8 51 fb ff ff       	call   8010df <sys_page_unmap>
	return r;
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	eb b7                	jmp    80154a <dup+0xa7>

00801593 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801593:	f3 0f 1e fb          	endbr32 
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	53                   	push   %ebx
  80159b:	83 ec 1c             	sub    $0x1c,%esp
  80159e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a4:	50                   	push   %eax
  8015a5:	53                   	push   %ebx
  8015a6:	e8 60 fd ff ff       	call   80130b <fd_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 3f                	js     8015f1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	ff 30                	pushl  (%eax)
  8015be:	e8 9c fd ff ff       	call   80135f <dev_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 27                	js     8015f1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cd:	8b 42 08             	mov    0x8(%edx),%eax
  8015d0:	83 e0 03             	and    $0x3,%eax
  8015d3:	83 f8 01             	cmp    $0x1,%eax
  8015d6:	74 1e                	je     8015f6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	8b 40 08             	mov    0x8(%eax),%eax
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	74 35                	je     801617 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	ff 75 10             	pushl  0x10(%ebp)
  8015e8:	ff 75 0c             	pushl  0xc(%ebp)
  8015eb:	52                   	push   %edx
  8015ec:	ff d0                	call   *%eax
  8015ee:	83 c4 10             	add    $0x10,%esp
}
  8015f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f6:	a1 18 40 80 00       	mov    0x804018,%eax
  8015fb:	8b 40 48             	mov    0x48(%eax),%eax
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	53                   	push   %ebx
  801602:	50                   	push   %eax
  801603:	68 2d 2d 80 00       	push   $0x802d2d
  801608:	e8 f9 ef ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801615:	eb da                	jmp    8015f1 <read+0x5e>
		return -E_NOT_SUPP;
  801617:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161c:	eb d3                	jmp    8015f1 <read+0x5e>

0080161e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80161e:	f3 0f 1e fb          	endbr32 
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	57                   	push   %edi
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 0c             	sub    $0xc,%esp
  80162b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80162e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801631:	bb 00 00 00 00       	mov    $0x0,%ebx
  801636:	eb 02                	jmp    80163a <readn+0x1c>
  801638:	01 c3                	add    %eax,%ebx
  80163a:	39 f3                	cmp    %esi,%ebx
  80163c:	73 21                	jae    80165f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	89 f0                	mov    %esi,%eax
  801643:	29 d8                	sub    %ebx,%eax
  801645:	50                   	push   %eax
  801646:	89 d8                	mov    %ebx,%eax
  801648:	03 45 0c             	add    0xc(%ebp),%eax
  80164b:	50                   	push   %eax
  80164c:	57                   	push   %edi
  80164d:	e8 41 ff ff ff       	call   801593 <read>
		if (m < 0)
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 04                	js     80165d <readn+0x3f>
			return m;
		if (m == 0)
  801659:	75 dd                	jne    801638 <readn+0x1a>
  80165b:	eb 02                	jmp    80165f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80165f:	89 d8                	mov    %ebx,%eax
  801661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801669:	f3 0f 1e fb          	endbr32 
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	53                   	push   %ebx
  801671:	83 ec 1c             	sub    $0x1c,%esp
  801674:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801677:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167a:	50                   	push   %eax
  80167b:	53                   	push   %ebx
  80167c:	e8 8a fc ff ff       	call   80130b <fd_lookup>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 3a                	js     8016c2 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	ff 30                	pushl  (%eax)
  801694:	e8 c6 fc ff ff       	call   80135f <dev_lookup>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 22                	js     8016c2 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016a7:	74 1e                	je     8016c7 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8016af:	85 d2                	test   %edx,%edx
  8016b1:	74 35                	je     8016e8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	ff 75 10             	pushl  0x10(%ebp)
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	50                   	push   %eax
  8016bd:	ff d2                	call   *%edx
  8016bf:	83 c4 10             	add    $0x10,%esp
}
  8016c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c7:	a1 18 40 80 00       	mov    0x804018,%eax
  8016cc:	8b 40 48             	mov    0x48(%eax),%eax
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	53                   	push   %ebx
  8016d3:	50                   	push   %eax
  8016d4:	68 49 2d 80 00       	push   $0x802d49
  8016d9:	e8 28 ef ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e6:	eb da                	jmp    8016c2 <write+0x59>
		return -E_NOT_SUPP;
  8016e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ed:	eb d3                	jmp    8016c2 <write+0x59>

008016ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8016ef:	f3 0f 1e fb          	endbr32 
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fc:	50                   	push   %eax
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	e8 06 fc ff ff       	call   80130b <fd_lookup>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	85 c0                	test   %eax,%eax
  80170a:	78 0e                	js     80171a <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80171c:	f3 0f 1e fb          	endbr32 
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	53                   	push   %ebx
  801724:	83 ec 1c             	sub    $0x1c,%esp
  801727:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80172a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80172d:	50                   	push   %eax
  80172e:	53                   	push   %ebx
  80172f:	e8 d7 fb ff ff       	call   80130b <fd_lookup>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 37                	js     801772 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801741:	50                   	push   %eax
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	ff 30                	pushl  (%eax)
  801747:	e8 13 fc ff ff       	call   80135f <dev_lookup>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 1f                	js     801772 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80175a:	74 1b                	je     801777 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80175c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175f:	8b 52 18             	mov    0x18(%edx),%edx
  801762:	85 d2                	test   %edx,%edx
  801764:	74 32                	je     801798 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	50                   	push   %eax
  80176d:	ff d2                	call   *%edx
  80176f:	83 c4 10             	add    $0x10,%esp
}
  801772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801775:	c9                   	leave  
  801776:	c3                   	ret    
			thisenv->env_id, fdnum);
  801777:	a1 18 40 80 00       	mov    0x804018,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80177c:	8b 40 48             	mov    0x48(%eax),%eax
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	53                   	push   %ebx
  801783:	50                   	push   %eax
  801784:	68 0c 2d 80 00       	push   $0x802d0c
  801789:	e8 78 ee ff ff       	call   800606 <cprintf>
		return -E_INVAL;
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801796:	eb da                	jmp    801772 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801798:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179d:	eb d3                	jmp    801772 <ftruncate+0x56>

0080179f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80179f:	f3 0f 1e fb          	endbr32 
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 1c             	sub    $0x1c,%esp
  8017aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b0:	50                   	push   %eax
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	e8 52 fb ff ff       	call   80130b <fd_lookup>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 4b                	js     80180b <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c0:	83 ec 08             	sub    $0x8,%esp
  8017c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c6:	50                   	push   %eax
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	ff 30                	pushl  (%eax)
  8017cc:	e8 8e fb ff ff       	call   80135f <dev_lookup>
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 33                	js     80180b <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017df:	74 2f                	je     801810 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017eb:	00 00 00 
	stat->st_isdir = 0;
  8017ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017f5:	00 00 00 
	stat->st_dev = dev;
  8017f8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	53                   	push   %ebx
  801802:	ff 75 f0             	pushl  -0x10(%ebp)
  801805:	ff 50 14             	call   *0x14(%eax)
  801808:	83 c4 10             	add    $0x10,%esp
}
  80180b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    
		return -E_NOT_SUPP;
  801810:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801815:	eb f4                	jmp    80180b <fstat+0x6c>

00801817 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801817:	f3 0f 1e fb          	endbr32 
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	6a 00                	push   $0x0
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 fb 01 00 00       	call   801a28 <open>
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	78 1b                	js     801851 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	50                   	push   %eax
  80183d:	e8 5d ff ff ff       	call   80179f <fstat>
  801842:	89 c6                	mov    %eax,%esi
	close(fd);
  801844:	89 1c 24             	mov    %ebx,(%esp)
  801847:	e8 fd fb ff ff       	call   801449 <close>
	return r;
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	89 f3                	mov    %esi,%ebx
}
  801851:	89 d8                	mov    %ebx,%eax
  801853:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	56                   	push   %esi
  80185e:	53                   	push   %ebx
  80185f:	89 c6                	mov    %eax,%esi
  801861:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801863:	83 3d 10 40 80 00 00 	cmpl   $0x0,0x804010
  80186a:	74 27                	je     801893 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80186c:	6a 07                	push   $0x7
  80186e:	68 00 50 80 00       	push   $0x805000
  801873:	56                   	push   %esi
  801874:	ff 35 10 40 80 00    	pushl  0x804010
  80187a:	e8 c7 0c 00 00       	call   802546 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80187f:	83 c4 0c             	add    $0xc,%esp
  801882:	6a 00                	push   $0x0
  801884:	53                   	push   %ebx
  801885:	6a 00                	push   $0x0
  801887:	e8 46 0c 00 00       	call   8024d2 <ipc_recv>
}
  80188c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5d                   	pop    %ebp
  801892:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801893:	83 ec 0c             	sub    $0xc,%esp
  801896:	6a 01                	push   $0x1
  801898:	e8 01 0d 00 00       	call   80259e <ipc_find_env>
  80189d:	a3 10 40 80 00       	mov    %eax,0x804010
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	eb c5                	jmp    80186c <fsipc+0x12>

008018a7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018a7:	f3 0f 1e fb          	endbr32 
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8018ce:	e8 87 ff ff ff       	call   80185a <fsipc>
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <devfile_flush>:
{
  8018d5:	f3 0f 1e fb          	endbr32 
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8018f4:	e8 61 ff ff ff       	call   80185a <fsipc>
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <devfile_stat>:
{
  8018fb:	f3 0f 1e fb          	endbr32 
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	53                   	push   %ebx
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8b 40 0c             	mov    0xc(%eax),%eax
  80190f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801914:	ba 00 00 00 00       	mov    $0x0,%edx
  801919:	b8 05 00 00 00       	mov    $0x5,%eax
  80191e:	e8 37 ff ff ff       	call   80185a <fsipc>
  801923:	85 c0                	test   %eax,%eax
  801925:	78 2c                	js     801953 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	68 00 50 80 00       	push   $0x805000
  80192f:	53                   	push   %ebx
  801930:	e8 db f2 ff ff       	call   800c10 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801935:	a1 80 50 80 00       	mov    0x805080,%eax
  80193a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801940:	a1 84 50 80 00       	mov    0x805084,%eax
  801945:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <devfile_write>:
{
  801958:	f3 0f 1e fb          	endbr32 
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801965:	8b 55 08             	mov    0x8(%ebp),%edx
  801968:	8b 52 0c             	mov    0xc(%edx),%edx
  80196b:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801971:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801976:	ba 00 10 00 00       	mov    $0x1000,%edx
  80197b:	0f 47 c2             	cmova  %edx,%eax
  80197e:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801983:	50                   	push   %eax
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	68 08 50 80 00       	push   $0x805008
  80198c:	e8 35 f4 ff ff       	call   800dc6 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801991:	ba 00 00 00 00       	mov    $0x0,%edx
  801996:	b8 04 00 00 00       	mov    $0x4,%eax
  80199b:	e8 ba fe ff ff       	call   80185a <fsipc>
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <devfile_read>:
{
  8019a2:	f3 0f 1e fb          	endbr32 
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
  8019ab:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019b9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8019c9:	e8 8c fe ff ff       	call   80185a <fsipc>
  8019ce:	89 c3                	mov    %eax,%ebx
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	78 1f                	js     8019f3 <devfile_read+0x51>
	assert(r <= n);
  8019d4:	39 f0                	cmp    %esi,%eax
  8019d6:	77 24                	ja     8019fc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019dd:	7f 33                	jg     801a12 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019df:	83 ec 04             	sub    $0x4,%esp
  8019e2:	50                   	push   %eax
  8019e3:	68 00 50 80 00       	push   $0x805000
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	e8 d6 f3 ff ff       	call   800dc6 <memmove>
	return r;
  8019f0:	83 c4 10             	add    $0x10,%esp
}
  8019f3:	89 d8                	mov    %ebx,%eax
  8019f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
	assert(r <= n);
  8019fc:	68 7c 2d 80 00       	push   $0x802d7c
  801a01:	68 83 2d 80 00       	push   $0x802d83
  801a06:	6a 7c                	push   $0x7c
  801a08:	68 98 2d 80 00       	push   $0x802d98
  801a0d:	e8 76 0a 00 00       	call   802488 <_panic>
	assert(r <= PGSIZE);
  801a12:	68 a3 2d 80 00       	push   $0x802da3
  801a17:	68 83 2d 80 00       	push   $0x802d83
  801a1c:	6a 7d                	push   $0x7d
  801a1e:	68 98 2d 80 00       	push   $0x802d98
  801a23:	e8 60 0a 00 00       	call   802488 <_panic>

00801a28 <open>:
{
  801a28:	f3 0f 1e fb          	endbr32 
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
  801a31:	83 ec 1c             	sub    $0x1c,%esp
  801a34:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a37:	56                   	push   %esi
  801a38:	e8 90 f1 ff ff       	call   800bcd <strlen>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a45:	7f 6c                	jg     801ab3 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4d:	50                   	push   %eax
  801a4e:	e8 62 f8 ff ff       	call   8012b5 <fd_alloc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	83 c4 10             	add    $0x10,%esp
  801a58:	85 c0                	test   %eax,%eax
  801a5a:	78 3c                	js     801a98 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	56                   	push   %esi
  801a60:	68 00 50 80 00       	push   $0x805000
  801a65:	e8 a6 f1 ff ff       	call   800c10 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a75:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7a:	e8 db fd ff ff       	call   80185a <fsipc>
  801a7f:	89 c3                	mov    %eax,%ebx
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	85 c0                	test   %eax,%eax
  801a86:	78 19                	js     801aa1 <open+0x79>
	return fd2num(fd);
  801a88:	83 ec 0c             	sub    $0xc,%esp
  801a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8e:	e8 f3 f7 ff ff       	call   801286 <fd2num>
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    
		fd_close(fd, 0);
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa9:	e8 10 f9 ff ff       	call   8013be <fd_close>
		return r;
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	eb e5                	jmp    801a98 <open+0x70>
		return -E_BAD_PATH;
  801ab3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ab8:	eb de                	jmp    801a98 <open+0x70>

00801aba <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801aba:	f3 0f 1e fb          	endbr32 
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac9:	b8 08 00 00 00       	mov    $0x8,%eax
  801ace:	e8 87 fd ff ff       	call   80185a <fsipc>
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ad5:	f3 0f 1e fb          	endbr32 
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801adf:	68 af 2d 80 00       	push   $0x802daf
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	e8 24 f1 ff ff       	call   800c10 <strcpy>
	return 0;
}
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <devsock_close>:
{
  801af3:	f3 0f 1e fb          	endbr32 
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	53                   	push   %ebx
  801afb:	83 ec 10             	sub    $0x10,%esp
  801afe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b01:	53                   	push   %ebx
  801b02:	e8 d4 0a 00 00       	call   8025db <pageref>
  801b07:	89 c2                	mov    %eax,%edx
  801b09:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b0c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b11:	83 fa 01             	cmp    $0x1,%edx
  801b14:	74 05                	je     801b1b <devsock_close+0x28>
}
  801b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	ff 73 0c             	pushl  0xc(%ebx)
  801b21:	e8 e3 02 00 00       	call   801e09 <nsipc_close>
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	eb eb                	jmp    801b16 <devsock_close+0x23>

00801b2b <devsock_write>:
{
  801b2b:	f3 0f 1e fb          	endbr32 
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	ff 75 10             	pushl  0x10(%ebp)
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	ff 70 0c             	pushl  0xc(%eax)
  801b43:	e8 b5 03 00 00       	call   801efd <nsipc_send>
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <devsock_read>:
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	ff 75 10             	pushl  0x10(%ebp)
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	ff 70 0c             	pushl  0xc(%eax)
  801b62:	e8 1f 03 00 00       	call   801e86 <nsipc_recv>
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <fd2sockid>:
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	e8 92 f7 ff ff       	call   80130b <fd_lookup>
  801b79:	83 c4 10             	add    $0x10,%esp
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	78 10                	js     801b90 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b83:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b89:	39 08                	cmp    %ecx,(%eax)
  801b8b:	75 05                	jne    801b92 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b8d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    
		return -E_NOT_SUPP;
  801b92:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b97:	eb f7                	jmp    801b90 <fd2sockid+0x27>

00801b99 <alloc_sockfd>:
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 1c             	sub    $0x1c,%esp
  801ba1:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ba3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba6:	50                   	push   %eax
  801ba7:	e8 09 f7 ff ff       	call   8012b5 <fd_alloc>
  801bac:	89 c3                	mov    %eax,%ebx
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	78 43                	js     801bf8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 07 04 00 00       	push   $0x407
  801bbd:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc0:	6a 00                	push   $0x0
  801bc2:	e8 8b f4 ff ff       	call   801052 <sys_page_alloc>
  801bc7:	89 c3                	mov    %eax,%ebx
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 28                	js     801bf8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bd9:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801be5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	50                   	push   %eax
  801bec:	e8 95 f6 ff ff       	call   801286 <fd2num>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	83 c4 10             	add    $0x10,%esp
  801bf6:	eb 0c                	jmp    801c04 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	56                   	push   %esi
  801bfc:	e8 08 02 00 00       	call   801e09 <nsipc_close>
		return r;
  801c01:	83 c4 10             	add    $0x10,%esp
}
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    

00801c0d <accept>:
{
  801c0d:	f3 0f 1e fb          	endbr32 
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	e8 4a ff ff ff       	call   801b69 <fd2sockid>
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 1b                	js     801c3e <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	50                   	push   %eax
  801c2d:	e8 22 01 00 00       	call   801d54 <nsipc_accept>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	85 c0                	test   %eax,%eax
  801c37:	78 05                	js     801c3e <accept+0x31>
	return alloc_sockfd(r);
  801c39:	e8 5b ff ff ff       	call   801b99 <alloc_sockfd>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <bind>:
{
  801c40:	f3 0f 1e fb          	endbr32 
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	e8 17 ff ff ff       	call   801b69 <fd2sockid>
  801c52:	85 c0                	test   %eax,%eax
  801c54:	78 12                	js     801c68 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	ff 75 10             	pushl  0x10(%ebp)
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	50                   	push   %eax
  801c60:	e8 45 01 00 00       	call   801daa <nsipc_bind>
  801c65:	83 c4 10             	add    $0x10,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <shutdown>:
{
  801c6a:	f3 0f 1e fb          	endbr32 
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	e8 ed fe ff ff       	call   801b69 <fd2sockid>
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 0f                	js     801c8f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801c80:	83 ec 08             	sub    $0x8,%esp
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	50                   	push   %eax
  801c87:	e8 57 01 00 00       	call   801de3 <nsipc_shutdown>
  801c8c:	83 c4 10             	add    $0x10,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <connect>:
{
  801c91:	f3 0f 1e fb          	endbr32 
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	e8 c6 fe ff ff       	call   801b69 <fd2sockid>
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 12                	js     801cb9 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	ff 75 10             	pushl  0x10(%ebp)
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	50                   	push   %eax
  801cb1:	e8 71 01 00 00       	call   801e27 <nsipc_connect>
  801cb6:	83 c4 10             	add    $0x10,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <listen>:
{
  801cbb:	f3 0f 1e fb          	endbr32 
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	e8 9c fe ff ff       	call   801b69 <fd2sockid>
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	78 0f                	js     801ce0 <listen+0x25>
	return nsipc_listen(r, backlog);
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	50                   	push   %eax
  801cd8:	e8 83 01 00 00       	call   801e60 <nsipc_listen>
  801cdd:	83 c4 10             	add    $0x10,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ce2:	f3 0f 1e fb          	endbr32 
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	e8 65 02 00 00       	call   801f5f <nsipc_socket>
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	78 05                	js     801d06 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d01:	e8 93 fe ff ff       	call   801b99 <alloc_sockfd>
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 04             	sub    $0x4,%esp
  801d0f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d11:	83 3d 14 40 80 00 00 	cmpl   $0x0,0x804014
  801d18:	74 26                	je     801d40 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d1a:	6a 07                	push   $0x7
  801d1c:	68 00 60 80 00       	push   $0x806000
  801d21:	53                   	push   %ebx
  801d22:	ff 35 14 40 80 00    	pushl  0x804014
  801d28:	e8 19 08 00 00       	call   802546 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d2d:	83 c4 0c             	add    $0xc,%esp
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	e8 97 07 00 00       	call   8024d2 <ipc_recv>
}
  801d3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	6a 02                	push   $0x2
  801d45:	e8 54 08 00 00       	call   80259e <ipc_find_env>
  801d4a:	a3 14 40 80 00       	mov    %eax,0x804014
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	eb c6                	jmp    801d1a <nsipc+0x12>

00801d54 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d54:	f3 0f 1e fb          	endbr32 
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d68:	8b 06                	mov    (%esi),%eax
  801d6a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	e8 8f ff ff ff       	call   801d08 <nsipc>
  801d79:	89 c3                	mov    %eax,%ebx
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	79 09                	jns    801d88 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d7f:	89 d8                	mov    %ebx,%eax
  801d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	ff 35 10 60 80 00    	pushl  0x806010
  801d91:	68 00 60 80 00       	push   $0x806000
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	e8 28 f0 ff ff       	call   800dc6 <memmove>
		*addrlen = ret->ret_addrlen;
  801d9e:	a1 10 60 80 00       	mov    0x806010,%eax
  801da3:	89 06                	mov    %eax,(%esi)
  801da5:	83 c4 10             	add    $0x10,%esp
	return r;
  801da8:	eb d5                	jmp    801d7f <nsipc_accept+0x2b>

00801daa <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801daa:	f3 0f 1e fb          	endbr32 
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	53                   	push   %ebx
  801db2:	83 ec 08             	sub    $0x8,%esp
  801db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dc0:	53                   	push   %ebx
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	68 04 60 80 00       	push   $0x806004
  801dc9:	e8 f8 ef ff ff       	call   800dc6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dce:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801dd4:	b8 02 00 00 00       	mov    $0x2,%eax
  801dd9:	e8 2a ff ff ff       	call   801d08 <nsipc>
}
  801dde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801de3:	f3 0f 1e fb          	endbr32 
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801dfd:	b8 03 00 00 00       	mov    $0x3,%eax
  801e02:	e8 01 ff ff ff       	call   801d08 <nsipc>
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <nsipc_close>:

int
nsipc_close(int s)
{
  801e09:	f3 0f 1e fb          	endbr32 
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e1b:	b8 04 00 00 00       	mov    $0x4,%eax
  801e20:	e8 e3 fe ff ff       	call   801d08 <nsipc>
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e27:	f3 0f 1e fb          	endbr32 
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 08             	sub    $0x8,%esp
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e3d:	53                   	push   %ebx
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	68 04 60 80 00       	push   $0x806004
  801e46:	e8 7b ef ff ff       	call   800dc6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e4b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e51:	b8 05 00 00 00       	mov    $0x5,%eax
  801e56:	e8 ad fe ff ff       	call   801d08 <nsipc>
}
  801e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e60:	f3 0f 1e fb          	endbr32 
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e75:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e7a:	b8 06 00 00 00       	mov    $0x6,%eax
  801e7f:	e8 84 fe ff ff       	call   801d08 <nsipc>
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e86:	f3 0f 1e fb          	endbr32 
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	56                   	push   %esi
  801e8e:	53                   	push   %ebx
  801e8f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e9a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ea0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ea8:	b8 07 00 00 00       	mov    $0x7,%eax
  801ead:	e8 56 fe ff ff       	call   801d08 <nsipc>
  801eb2:	89 c3                	mov    %eax,%ebx
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	78 26                	js     801ede <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801eb8:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ebe:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ec3:	0f 4e c6             	cmovle %esi,%eax
  801ec6:	39 c3                	cmp    %eax,%ebx
  801ec8:	7f 1d                	jg     801ee7 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	53                   	push   %ebx
  801ece:	68 00 60 80 00       	push   $0x806000
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	e8 eb ee ff ff       	call   800dc6 <memmove>
  801edb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ede:	89 d8                	mov    %ebx,%eax
  801ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ee7:	68 bb 2d 80 00       	push   $0x802dbb
  801eec:	68 83 2d 80 00       	push   $0x802d83
  801ef1:	6a 62                	push   $0x62
  801ef3:	68 d0 2d 80 00       	push   $0x802dd0
  801ef8:	e8 8b 05 00 00       	call   802488 <_panic>

00801efd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801efd:	f3 0f 1e fb          	endbr32 
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	53                   	push   %ebx
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f13:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f19:	7f 2e                	jg     801f49 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	53                   	push   %ebx
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	68 0c 60 80 00       	push   $0x80600c
  801f27:	e8 9a ee ff ff       	call   800dc6 <memmove>
	nsipcbuf.send.req_size = size;
  801f2c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f32:	8b 45 14             	mov    0x14(%ebp),%eax
  801f35:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f3a:	b8 08 00 00 00       	mov    $0x8,%eax
  801f3f:	e8 c4 fd ff ff       	call   801d08 <nsipc>
}
  801f44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    
	assert(size < 1600);
  801f49:	68 dc 2d 80 00       	push   $0x802ddc
  801f4e:	68 83 2d 80 00       	push   $0x802d83
  801f53:	6a 6d                	push   $0x6d
  801f55:	68 d0 2d 80 00       	push   $0x802dd0
  801f5a:	e8 29 05 00 00       	call   802488 <_panic>

00801f5f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f5f:	f3 0f 1e fb          	endbr32 
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f74:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f81:	b8 09 00 00 00       	mov    $0x9,%eax
  801f86:	e8 7d fd ff ff       	call   801d08 <nsipc>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f8d:	f3 0f 1e fb          	endbr32 
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	56                   	push   %esi
  801f95:	53                   	push   %ebx
  801f96:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	e8 f6 f2 ff ff       	call   80129a <fd2data>
  801fa4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fa6:	83 c4 08             	add    $0x8,%esp
  801fa9:	68 e8 2d 80 00       	push   $0x802de8
  801fae:	53                   	push   %ebx
  801faf:	e8 5c ec ff ff       	call   800c10 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fb4:	8b 46 04             	mov    0x4(%esi),%eax
  801fb7:	2b 06                	sub    (%esi),%eax
  801fb9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fbf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fc6:	00 00 00 
	stat->st_dev = &devpipe;
  801fc9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801fd0:	30 80 00 
	return 0;
}
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fdf:	f3 0f 1e fb          	endbr32 
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	53                   	push   %ebx
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fed:	53                   	push   %ebx
  801fee:	6a 00                	push   $0x0
  801ff0:	e8 ea f0 ff ff       	call   8010df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ff5:	89 1c 24             	mov    %ebx,(%esp)
  801ff8:	e8 9d f2 ff ff       	call   80129a <fd2data>
  801ffd:	83 c4 08             	add    $0x8,%esp
  802000:	50                   	push   %eax
  802001:	6a 00                	push   $0x0
  802003:	e8 d7 f0 ff ff       	call   8010df <sys_page_unmap>
}
  802008:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <_pipeisclosed>:
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	57                   	push   %edi
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	83 ec 1c             	sub    $0x1c,%esp
  802016:	89 c7                	mov    %eax,%edi
  802018:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80201a:	a1 18 40 80 00       	mov    0x804018,%eax
  80201f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802022:	83 ec 0c             	sub    $0xc,%esp
  802025:	57                   	push   %edi
  802026:	e8 b0 05 00 00       	call   8025db <pageref>
  80202b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80202e:	89 34 24             	mov    %esi,(%esp)
  802031:	e8 a5 05 00 00       	call   8025db <pageref>
		nn = thisenv->env_runs;
  802036:	8b 15 18 40 80 00    	mov    0x804018,%edx
  80203c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	39 cb                	cmp    %ecx,%ebx
  802044:	74 1b                	je     802061 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802046:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802049:	75 cf                	jne    80201a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80204b:	8b 42 58             	mov    0x58(%edx),%eax
  80204e:	6a 01                	push   $0x1
  802050:	50                   	push   %eax
  802051:	53                   	push   %ebx
  802052:	68 ef 2d 80 00       	push   $0x802def
  802057:	e8 aa e5 ff ff       	call   800606 <cprintf>
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	eb b9                	jmp    80201a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802061:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802064:	0f 94 c0             	sete   %al
  802067:	0f b6 c0             	movzbl %al,%eax
}
  80206a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5f                   	pop    %edi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    

00802072 <devpipe_write>:
{
  802072:	f3 0f 1e fb          	endbr32 
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	57                   	push   %edi
  80207a:	56                   	push   %esi
  80207b:	53                   	push   %ebx
  80207c:	83 ec 28             	sub    $0x28,%esp
  80207f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802082:	56                   	push   %esi
  802083:	e8 12 f2 ff ff       	call   80129a <fd2data>
  802088:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	bf 00 00 00 00       	mov    $0x0,%edi
  802092:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802095:	74 4f                	je     8020e6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802097:	8b 43 04             	mov    0x4(%ebx),%eax
  80209a:	8b 0b                	mov    (%ebx),%ecx
  80209c:	8d 51 20             	lea    0x20(%ecx),%edx
  80209f:	39 d0                	cmp    %edx,%eax
  8020a1:	72 14                	jb     8020b7 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020a3:	89 da                	mov    %ebx,%edx
  8020a5:	89 f0                	mov    %esi,%eax
  8020a7:	e8 61 ff ff ff       	call   80200d <_pipeisclosed>
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	75 3b                	jne    8020eb <devpipe_write+0x79>
			sys_yield();
  8020b0:	e8 7a ef ff ff       	call   80102f <sys_yield>
  8020b5:	eb e0                	jmp    802097 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020c1:	89 c2                	mov    %eax,%edx
  8020c3:	c1 fa 1f             	sar    $0x1f,%edx
  8020c6:	89 d1                	mov    %edx,%ecx
  8020c8:	c1 e9 1b             	shr    $0x1b,%ecx
  8020cb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020ce:	83 e2 1f             	and    $0x1f,%edx
  8020d1:	29 ca                	sub    %ecx,%edx
  8020d3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020d7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020db:	83 c0 01             	add    $0x1,%eax
  8020de:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020e1:	83 c7 01             	add    $0x1,%edi
  8020e4:	eb ac                	jmp    802092 <devpipe_write+0x20>
	return i;
  8020e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e9:	eb 05                	jmp    8020f0 <devpipe_write+0x7e>
				return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5f                   	pop    %edi
  8020f6:	5d                   	pop    %ebp
  8020f7:	c3                   	ret    

008020f8 <devpipe_read>:
{
  8020f8:	f3 0f 1e fb          	endbr32 
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	57                   	push   %edi
  802100:	56                   	push   %esi
  802101:	53                   	push   %ebx
  802102:	83 ec 18             	sub    $0x18,%esp
  802105:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802108:	57                   	push   %edi
  802109:	e8 8c f1 ff ff       	call   80129a <fd2data>
  80210e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	be 00 00 00 00       	mov    $0x0,%esi
  802118:	3b 75 10             	cmp    0x10(%ebp),%esi
  80211b:	75 14                	jne    802131 <devpipe_read+0x39>
	return i;
  80211d:	8b 45 10             	mov    0x10(%ebp),%eax
  802120:	eb 02                	jmp    802124 <devpipe_read+0x2c>
				return i;
  802122:	89 f0                	mov    %esi,%eax
}
  802124:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    
			sys_yield();
  80212c:	e8 fe ee ff ff       	call   80102f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802131:	8b 03                	mov    (%ebx),%eax
  802133:	3b 43 04             	cmp    0x4(%ebx),%eax
  802136:	75 18                	jne    802150 <devpipe_read+0x58>
			if (i > 0)
  802138:	85 f6                	test   %esi,%esi
  80213a:	75 e6                	jne    802122 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80213c:	89 da                	mov    %ebx,%edx
  80213e:	89 f8                	mov    %edi,%eax
  802140:	e8 c8 fe ff ff       	call   80200d <_pipeisclosed>
  802145:	85 c0                	test   %eax,%eax
  802147:	74 e3                	je     80212c <devpipe_read+0x34>
				return 0;
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	eb d4                	jmp    802124 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802150:	99                   	cltd   
  802151:	c1 ea 1b             	shr    $0x1b,%edx
  802154:	01 d0                	add    %edx,%eax
  802156:	83 e0 1f             	and    $0x1f,%eax
  802159:	29 d0                	sub    %edx,%eax
  80215b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802163:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802166:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802169:	83 c6 01             	add    $0x1,%esi
  80216c:	eb aa                	jmp    802118 <devpipe_read+0x20>

0080216e <pipe>:
{
  80216e:	f3 0f 1e fb          	endbr32 
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	56                   	push   %esi
  802176:	53                   	push   %ebx
  802177:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80217a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80217d:	50                   	push   %eax
  80217e:	e8 32 f1 ff ff       	call   8012b5 <fd_alloc>
  802183:	89 c3                	mov    %eax,%ebx
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	85 c0                	test   %eax,%eax
  80218a:	0f 88 23 01 00 00    	js     8022b3 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 07 04 00 00       	push   $0x407
  802198:	ff 75 f4             	pushl  -0xc(%ebp)
  80219b:	6a 00                	push   $0x0
  80219d:	e8 b0 ee ff ff       	call   801052 <sys_page_alloc>
  8021a2:	89 c3                	mov    %eax,%ebx
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 88 04 01 00 00    	js     8022b3 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8021af:	83 ec 0c             	sub    $0xc,%esp
  8021b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021b5:	50                   	push   %eax
  8021b6:	e8 fa f0 ff ff       	call   8012b5 <fd_alloc>
  8021bb:	89 c3                	mov    %eax,%ebx
  8021bd:	83 c4 10             	add    $0x10,%esp
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	0f 88 db 00 00 00    	js     8022a3 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 07 04 00 00       	push   $0x407
  8021d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d3:	6a 00                	push   $0x0
  8021d5:	e8 78 ee ff ff       	call   801052 <sys_page_alloc>
  8021da:	89 c3                	mov    %eax,%ebx
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	0f 88 bc 00 00 00    	js     8022a3 <pipe+0x135>
	va = fd2data(fd0);
  8021e7:	83 ec 0c             	sub    $0xc,%esp
  8021ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ed:	e8 a8 f0 ff ff       	call   80129a <fd2data>
  8021f2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f4:	83 c4 0c             	add    $0xc,%esp
  8021f7:	68 07 04 00 00       	push   $0x407
  8021fc:	50                   	push   %eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	e8 4e ee ff ff       	call   801052 <sys_page_alloc>
  802204:	89 c3                	mov    %eax,%ebx
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	85 c0                	test   %eax,%eax
  80220b:	0f 88 82 00 00 00    	js     802293 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	ff 75 f0             	pushl  -0x10(%ebp)
  802217:	e8 7e f0 ff ff       	call   80129a <fd2data>
  80221c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802223:	50                   	push   %eax
  802224:	6a 00                	push   $0x0
  802226:	56                   	push   %esi
  802227:	6a 00                	push   $0x0
  802229:	e8 6b ee ff ff       	call   801099 <sys_page_map>
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	83 c4 20             	add    $0x20,%esp
  802233:	85 c0                	test   %eax,%eax
  802235:	78 4e                	js     802285 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802237:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80223c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223f:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802241:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802244:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80224b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	ff 75 f4             	pushl  -0xc(%ebp)
  802260:	e8 21 f0 ff ff       	call   801286 <fd2num>
  802265:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802268:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80226a:	83 c4 04             	add    $0x4,%esp
  80226d:	ff 75 f0             	pushl  -0x10(%ebp)
  802270:	e8 11 f0 ff ff       	call   801286 <fd2num>
  802275:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802278:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802283:	eb 2e                	jmp    8022b3 <pipe+0x145>
	sys_page_unmap(0, va);
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	56                   	push   %esi
  802289:	6a 00                	push   $0x0
  80228b:	e8 4f ee ff ff       	call   8010df <sys_page_unmap>
  802290:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802293:	83 ec 08             	sub    $0x8,%esp
  802296:	ff 75 f0             	pushl  -0x10(%ebp)
  802299:	6a 00                	push   $0x0
  80229b:	e8 3f ee ff ff       	call   8010df <sys_page_unmap>
  8022a0:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022a3:	83 ec 08             	sub    $0x8,%esp
  8022a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a9:	6a 00                	push   $0x0
  8022ab:	e8 2f ee ff ff       	call   8010df <sys_page_unmap>
  8022b0:	83 c4 10             	add    $0x10,%esp
}
  8022b3:	89 d8                	mov    %ebx,%eax
  8022b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b8:	5b                   	pop    %ebx
  8022b9:	5e                   	pop    %esi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    

008022bc <pipeisclosed>:
{
  8022bc:	f3 0f 1e fb          	endbr32 
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c9:	50                   	push   %eax
  8022ca:	ff 75 08             	pushl  0x8(%ebp)
  8022cd:	e8 39 f0 ff ff       	call   80130b <fd_lookup>
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	78 18                	js     8022f1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8022d9:	83 ec 0c             	sub    $0xc,%esp
  8022dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8022df:	e8 b6 ef ff ff       	call   80129a <fd2data>
  8022e4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	e8 1f fd ff ff       	call   80200d <_pipeisclosed>
  8022ee:	83 c4 10             	add    $0x10,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022f3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	c3                   	ret    

008022fd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022fd:	f3 0f 1e fb          	endbr32 
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802307:	68 07 2e 80 00       	push   $0x802e07
  80230c:	ff 75 0c             	pushl  0xc(%ebp)
  80230f:	e8 fc e8 ff ff       	call   800c10 <strcpy>
	return 0;
}
  802314:	b8 00 00 00 00       	mov    $0x0,%eax
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <devcons_write>:
{
  80231b:	f3 0f 1e fb          	endbr32 
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	57                   	push   %edi
  802323:	56                   	push   %esi
  802324:	53                   	push   %ebx
  802325:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80232b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802330:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802336:	3b 75 10             	cmp    0x10(%ebp),%esi
  802339:	73 31                	jae    80236c <devcons_write+0x51>
		m = n - tot;
  80233b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80233e:	29 f3                	sub    %esi,%ebx
  802340:	83 fb 7f             	cmp    $0x7f,%ebx
  802343:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802348:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80234b:	83 ec 04             	sub    $0x4,%esp
  80234e:	53                   	push   %ebx
  80234f:	89 f0                	mov    %esi,%eax
  802351:	03 45 0c             	add    0xc(%ebp),%eax
  802354:	50                   	push   %eax
  802355:	57                   	push   %edi
  802356:	e8 6b ea ff ff       	call   800dc6 <memmove>
		sys_cputs(buf, m);
  80235b:	83 c4 08             	add    $0x8,%esp
  80235e:	53                   	push   %ebx
  80235f:	57                   	push   %edi
  802360:	e8 1d ec ff ff       	call   800f82 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802365:	01 de                	add    %ebx,%esi
  802367:	83 c4 10             	add    $0x10,%esp
  80236a:	eb ca                	jmp    802336 <devcons_write+0x1b>
}
  80236c:	89 f0                	mov    %esi,%eax
  80236e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    

00802376 <devcons_read>:
{
  802376:	f3 0f 1e fb          	endbr32 
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 08             	sub    $0x8,%esp
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802385:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802389:	74 21                	je     8023ac <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80238b:	e8 14 ec ff ff       	call   800fa4 <sys_cgetc>
  802390:	85 c0                	test   %eax,%eax
  802392:	75 07                	jne    80239b <devcons_read+0x25>
		sys_yield();
  802394:	e8 96 ec ff ff       	call   80102f <sys_yield>
  802399:	eb f0                	jmp    80238b <devcons_read+0x15>
	if (c < 0)
  80239b:	78 0f                	js     8023ac <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80239d:	83 f8 04             	cmp    $0x4,%eax
  8023a0:	74 0c                	je     8023ae <devcons_read+0x38>
	*(char*)vbuf = c;
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	88 02                	mov    %al,(%edx)
	return 1;
  8023a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    
		return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	eb f7                	jmp    8023ac <devcons_read+0x36>

008023b5 <cputchar>:
{
  8023b5:	f3 0f 1e fb          	endbr32 
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023c5:	6a 01                	push   $0x1
  8023c7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ca:	50                   	push   %eax
  8023cb:	e8 b2 eb ff ff       	call   800f82 <sys_cputs>
}
  8023d0:	83 c4 10             	add    $0x10,%esp
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <getchar>:
{
  8023d5:	f3 0f 1e fb          	endbr32 
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023df:	6a 01                	push   $0x1
  8023e1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023e4:	50                   	push   %eax
  8023e5:	6a 00                	push   $0x0
  8023e7:	e8 a7 f1 ff ff       	call   801593 <read>
	if (r < 0)
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 06                	js     8023f9 <getchar+0x24>
	if (r < 1)
  8023f3:	74 06                	je     8023fb <getchar+0x26>
	return c;
  8023f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    
		return -E_EOF;
  8023fb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802400:	eb f7                	jmp    8023f9 <getchar+0x24>

00802402 <iscons>:
{
  802402:	f3 0f 1e fb          	endbr32 
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	50                   	push   %eax
  802410:	ff 75 08             	pushl  0x8(%ebp)
  802413:	e8 f3 ee ff ff       	call   80130b <fd_lookup>
  802418:	83 c4 10             	add    $0x10,%esp
  80241b:	85 c0                	test   %eax,%eax
  80241d:	78 11                	js     802430 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802428:	39 10                	cmp    %edx,(%eax)
  80242a:	0f 94 c0             	sete   %al
  80242d:	0f b6 c0             	movzbl %al,%eax
}
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <opencons>:
{
  802432:	f3 0f 1e fb          	endbr32 
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80243c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243f:	50                   	push   %eax
  802440:	e8 70 ee ff ff       	call   8012b5 <fd_alloc>
  802445:	83 c4 10             	add    $0x10,%esp
  802448:	85 c0                	test   %eax,%eax
  80244a:	78 3a                	js     802486 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 07 04 00 00       	push   $0x407
  802454:	ff 75 f4             	pushl  -0xc(%ebp)
  802457:	6a 00                	push   $0x0
  802459:	e8 f4 eb ff ff       	call   801052 <sys_page_alloc>
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	85 c0                	test   %eax,%eax
  802463:	78 21                	js     802486 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80246e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80247a:	83 ec 0c             	sub    $0xc,%esp
  80247d:	50                   	push   %eax
  80247e:	e8 03 ee ff ff       	call   801286 <fd2num>
  802483:	83 c4 10             	add    $0x10,%esp
}
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802488:	f3 0f 1e fb          	endbr32 
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	56                   	push   %esi
  802490:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802491:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802494:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80249a:	e8 6d eb ff ff       	call   80100c <sys_getenvid>
  80249f:	83 ec 0c             	sub    $0xc,%esp
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	ff 75 08             	pushl  0x8(%ebp)
  8024a8:	56                   	push   %esi
  8024a9:	50                   	push   %eax
  8024aa:	68 14 2e 80 00       	push   $0x802e14
  8024af:	e8 52 e1 ff ff       	call   800606 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024b4:	83 c4 18             	add    $0x18,%esp
  8024b7:	53                   	push   %ebx
  8024b8:	ff 75 10             	pushl  0x10(%ebp)
  8024bb:	e8 f1 e0 ff ff       	call   8005b1 <vcprintf>
	cprintf("\n");
  8024c0:	c7 04 24 00 2e 80 00 	movl   $0x802e00,(%esp)
  8024c7:	e8 3a e1 ff ff       	call   800606 <cprintf>
  8024cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024cf:	cc                   	int3   
  8024d0:	eb fd                	jmp    8024cf <_panic+0x47>

008024d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024d2:	f3 0f 1e fb          	endbr32 
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	56                   	push   %esi
  8024da:	53                   	push   %ebx
  8024db:	8b 75 08             	mov    0x8(%ebp),%esi
  8024de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8024e4:	83 e8 01             	sub    $0x1,%eax
  8024e7:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8024ec:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024f1:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	50                   	push   %eax
  8024f9:	e8 20 ed ff ff       	call   80121e <sys_ipc_recv>
	if (!t) {
  8024fe:	83 c4 10             	add    $0x10,%esp
  802501:	85 c0                	test   %eax,%eax
  802503:	75 2b                	jne    802530 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802505:	85 f6                	test   %esi,%esi
  802507:	74 0a                	je     802513 <ipc_recv+0x41>
  802509:	a1 18 40 80 00       	mov    0x804018,%eax
  80250e:	8b 40 74             	mov    0x74(%eax),%eax
  802511:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802513:	85 db                	test   %ebx,%ebx
  802515:	74 0a                	je     802521 <ipc_recv+0x4f>
  802517:	a1 18 40 80 00       	mov    0x804018,%eax
  80251c:	8b 40 78             	mov    0x78(%eax),%eax
  80251f:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802521:	a1 18 40 80 00       	mov    0x804018,%eax
  802526:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802529:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802530:	85 f6                	test   %esi,%esi
  802532:	74 06                	je     80253a <ipc_recv+0x68>
  802534:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80253a:	85 db                	test   %ebx,%ebx
  80253c:	74 eb                	je     802529 <ipc_recv+0x57>
  80253e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802544:	eb e3                	jmp    802529 <ipc_recv+0x57>

00802546 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802546:	f3 0f 1e fb          	endbr32 
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	57                   	push   %edi
  80254e:	56                   	push   %esi
  80254f:	53                   	push   %ebx
  802550:	83 ec 0c             	sub    $0xc,%esp
  802553:	8b 7d 08             	mov    0x8(%ebp),%edi
  802556:	8b 75 0c             	mov    0xc(%ebp),%esi
  802559:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80255c:	85 db                	test   %ebx,%ebx
  80255e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802563:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802566:	ff 75 14             	pushl  0x14(%ebp)
  802569:	53                   	push   %ebx
  80256a:	56                   	push   %esi
  80256b:	57                   	push   %edi
  80256c:	e8 86 ec ff ff       	call   8011f7 <sys_ipc_try_send>
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	85 c0                	test   %eax,%eax
  802576:	74 1e                	je     802596 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802578:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80257b:	75 07                	jne    802584 <ipc_send+0x3e>
		sys_yield();
  80257d:	e8 ad ea ff ff       	call   80102f <sys_yield>
  802582:	eb e2                	jmp    802566 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802584:	50                   	push   %eax
  802585:	68 37 2e 80 00       	push   $0x802e37
  80258a:	6a 39                	push   $0x39
  80258c:	68 49 2e 80 00       	push   $0x802e49
  802591:	e8 f2 fe ff ff       	call   802488 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802596:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802599:	5b                   	pop    %ebx
  80259a:	5e                   	pop    %esi
  80259b:	5f                   	pop    %edi
  80259c:	5d                   	pop    %ebp
  80259d:	c3                   	ret    

0080259e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80259e:	f3 0f 1e fb          	endbr32 
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025ad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025b6:	8b 52 50             	mov    0x50(%edx),%edx
  8025b9:	39 ca                	cmp    %ecx,%edx
  8025bb:	74 11                	je     8025ce <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8025bd:	83 c0 01             	add    $0x1,%eax
  8025c0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025c5:	75 e6                	jne    8025ad <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	eb 0b                	jmp    8025d9 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8025ce:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025d1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025d6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    

008025db <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025db:	f3 0f 1e fb          	endbr32 
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e5:	89 c2                	mov    %eax,%edx
  8025e7:	c1 ea 16             	shr    $0x16,%edx
  8025ea:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025f1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025f6:	f6 c1 01             	test   $0x1,%cl
  8025f9:	74 1c                	je     802617 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025fb:	c1 e8 0c             	shr    $0xc,%eax
  8025fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802605:	a8 01                	test   $0x1,%al
  802607:	74 0e                	je     802617 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802609:	c1 e8 0c             	shr    $0xc,%eax
  80260c:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802613:	ef 
  802614:	0f b7 d2             	movzwl %dx,%edx
}
  802617:	89 d0                	mov    %edx,%eax
  802619:	5d                   	pop    %ebp
  80261a:	c3                   	ret    
  80261b:	66 90                	xchg   %ax,%ax
  80261d:	66 90                	xchg   %ax,%ax
  80261f:	90                   	nop

00802620 <__udivdi3>:
  802620:	f3 0f 1e fb          	endbr32 
  802624:	55                   	push   %ebp
  802625:	57                   	push   %edi
  802626:	56                   	push   %esi
  802627:	53                   	push   %ebx
  802628:	83 ec 1c             	sub    $0x1c,%esp
  80262b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80262f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802633:	8b 74 24 34          	mov    0x34(%esp),%esi
  802637:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80263b:	85 d2                	test   %edx,%edx
  80263d:	75 19                	jne    802658 <__udivdi3+0x38>
  80263f:	39 f3                	cmp    %esi,%ebx
  802641:	76 4d                	jbe    802690 <__udivdi3+0x70>
  802643:	31 ff                	xor    %edi,%edi
  802645:	89 e8                	mov    %ebp,%eax
  802647:	89 f2                	mov    %esi,%edx
  802649:	f7 f3                	div    %ebx
  80264b:	89 fa                	mov    %edi,%edx
  80264d:	83 c4 1c             	add    $0x1c,%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	39 f2                	cmp    %esi,%edx
  80265a:	76 14                	jbe    802670 <__udivdi3+0x50>
  80265c:	31 ff                	xor    %edi,%edi
  80265e:	31 c0                	xor    %eax,%eax
  802660:	89 fa                	mov    %edi,%edx
  802662:	83 c4 1c             	add    $0x1c,%esp
  802665:	5b                   	pop    %ebx
  802666:	5e                   	pop    %esi
  802667:	5f                   	pop    %edi
  802668:	5d                   	pop    %ebp
  802669:	c3                   	ret    
  80266a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802670:	0f bd fa             	bsr    %edx,%edi
  802673:	83 f7 1f             	xor    $0x1f,%edi
  802676:	75 48                	jne    8026c0 <__udivdi3+0xa0>
  802678:	39 f2                	cmp    %esi,%edx
  80267a:	72 06                	jb     802682 <__udivdi3+0x62>
  80267c:	31 c0                	xor    %eax,%eax
  80267e:	39 eb                	cmp    %ebp,%ebx
  802680:	77 de                	ja     802660 <__udivdi3+0x40>
  802682:	b8 01 00 00 00       	mov    $0x1,%eax
  802687:	eb d7                	jmp    802660 <__udivdi3+0x40>
  802689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802690:	89 d9                	mov    %ebx,%ecx
  802692:	85 db                	test   %ebx,%ebx
  802694:	75 0b                	jne    8026a1 <__udivdi3+0x81>
  802696:	b8 01 00 00 00       	mov    $0x1,%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	f7 f3                	div    %ebx
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	31 d2                	xor    %edx,%edx
  8026a3:	89 f0                	mov    %esi,%eax
  8026a5:	f7 f1                	div    %ecx
  8026a7:	89 c6                	mov    %eax,%esi
  8026a9:	89 e8                	mov    %ebp,%eax
  8026ab:	89 f7                	mov    %esi,%edi
  8026ad:	f7 f1                	div    %ecx
  8026af:	89 fa                	mov    %edi,%edx
  8026b1:	83 c4 1c             	add    $0x1c,%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5f                   	pop    %edi
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    
  8026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026c0:	89 f9                	mov    %edi,%ecx
  8026c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c7:	29 f8                	sub    %edi,%eax
  8026c9:	d3 e2                	shl    %cl,%edx
  8026cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026cf:	89 c1                	mov    %eax,%ecx
  8026d1:	89 da                	mov    %ebx,%edx
  8026d3:	d3 ea                	shr    %cl,%edx
  8026d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026d9:	09 d1                	or     %edx,%ecx
  8026db:	89 f2                	mov    %esi,%edx
  8026dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e1:	89 f9                	mov    %edi,%ecx
  8026e3:	d3 e3                	shl    %cl,%ebx
  8026e5:	89 c1                	mov    %eax,%ecx
  8026e7:	d3 ea                	shr    %cl,%edx
  8026e9:	89 f9                	mov    %edi,%ecx
  8026eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026ef:	89 eb                	mov    %ebp,%ebx
  8026f1:	d3 e6                	shl    %cl,%esi
  8026f3:	89 c1                	mov    %eax,%ecx
  8026f5:	d3 eb                	shr    %cl,%ebx
  8026f7:	09 de                	or     %ebx,%esi
  8026f9:	89 f0                	mov    %esi,%eax
  8026fb:	f7 74 24 08          	divl   0x8(%esp)
  8026ff:	89 d6                	mov    %edx,%esi
  802701:	89 c3                	mov    %eax,%ebx
  802703:	f7 64 24 0c          	mull   0xc(%esp)
  802707:	39 d6                	cmp    %edx,%esi
  802709:	72 15                	jb     802720 <__udivdi3+0x100>
  80270b:	89 f9                	mov    %edi,%ecx
  80270d:	d3 e5                	shl    %cl,%ebp
  80270f:	39 c5                	cmp    %eax,%ebp
  802711:	73 04                	jae    802717 <__udivdi3+0xf7>
  802713:	39 d6                	cmp    %edx,%esi
  802715:	74 09                	je     802720 <__udivdi3+0x100>
  802717:	89 d8                	mov    %ebx,%eax
  802719:	31 ff                	xor    %edi,%edi
  80271b:	e9 40 ff ff ff       	jmp    802660 <__udivdi3+0x40>
  802720:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802723:	31 ff                	xor    %edi,%edi
  802725:	e9 36 ff ff ff       	jmp    802660 <__udivdi3+0x40>
  80272a:	66 90                	xchg   %ax,%ax
  80272c:	66 90                	xchg   %ax,%ax
  80272e:	66 90                	xchg   %ax,%ax

00802730 <__umoddi3>:
  802730:	f3 0f 1e fb          	endbr32 
  802734:	55                   	push   %ebp
  802735:	57                   	push   %edi
  802736:	56                   	push   %esi
  802737:	53                   	push   %ebx
  802738:	83 ec 1c             	sub    $0x1c,%esp
  80273b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80273f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802743:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802747:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80274b:	85 c0                	test   %eax,%eax
  80274d:	75 19                	jne    802768 <__umoddi3+0x38>
  80274f:	39 df                	cmp    %ebx,%edi
  802751:	76 5d                	jbe    8027b0 <__umoddi3+0x80>
  802753:	89 f0                	mov    %esi,%eax
  802755:	89 da                	mov    %ebx,%edx
  802757:	f7 f7                	div    %edi
  802759:	89 d0                	mov    %edx,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	83 c4 1c             	add    $0x1c,%esp
  802760:	5b                   	pop    %ebx
  802761:	5e                   	pop    %esi
  802762:	5f                   	pop    %edi
  802763:	5d                   	pop    %ebp
  802764:	c3                   	ret    
  802765:	8d 76 00             	lea    0x0(%esi),%esi
  802768:	89 f2                	mov    %esi,%edx
  80276a:	39 d8                	cmp    %ebx,%eax
  80276c:	76 12                	jbe    802780 <__umoddi3+0x50>
  80276e:	89 f0                	mov    %esi,%eax
  802770:	89 da                	mov    %ebx,%edx
  802772:	83 c4 1c             	add    $0x1c,%esp
  802775:	5b                   	pop    %ebx
  802776:	5e                   	pop    %esi
  802777:	5f                   	pop    %edi
  802778:	5d                   	pop    %ebp
  802779:	c3                   	ret    
  80277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802780:	0f bd e8             	bsr    %eax,%ebp
  802783:	83 f5 1f             	xor    $0x1f,%ebp
  802786:	75 50                	jne    8027d8 <__umoddi3+0xa8>
  802788:	39 d8                	cmp    %ebx,%eax
  80278a:	0f 82 e0 00 00 00    	jb     802870 <__umoddi3+0x140>
  802790:	89 d9                	mov    %ebx,%ecx
  802792:	39 f7                	cmp    %esi,%edi
  802794:	0f 86 d6 00 00 00    	jbe    802870 <__umoddi3+0x140>
  80279a:	89 d0                	mov    %edx,%eax
  80279c:	89 ca                	mov    %ecx,%edx
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027ad:	8d 76 00             	lea    0x0(%esi),%esi
  8027b0:	89 fd                	mov    %edi,%ebp
  8027b2:	85 ff                	test   %edi,%edi
  8027b4:	75 0b                	jne    8027c1 <__umoddi3+0x91>
  8027b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	f7 f7                	div    %edi
  8027bf:	89 c5                	mov    %eax,%ebp
  8027c1:	89 d8                	mov    %ebx,%eax
  8027c3:	31 d2                	xor    %edx,%edx
  8027c5:	f7 f5                	div    %ebp
  8027c7:	89 f0                	mov    %esi,%eax
  8027c9:	f7 f5                	div    %ebp
  8027cb:	89 d0                	mov    %edx,%eax
  8027cd:	31 d2                	xor    %edx,%edx
  8027cf:	eb 8c                	jmp    80275d <__umoddi3+0x2d>
  8027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	89 e9                	mov    %ebp,%ecx
  8027da:	ba 20 00 00 00       	mov    $0x20,%edx
  8027df:	29 ea                	sub    %ebp,%edx
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e7:	89 d1                	mov    %edx,%ecx
  8027e9:	89 f8                	mov    %edi,%eax
  8027eb:	d3 e8                	shr    %cl,%eax
  8027ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027f9:	09 c1                	or     %eax,%ecx
  8027fb:	89 d8                	mov    %ebx,%eax
  8027fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802801:	89 e9                	mov    %ebp,%ecx
  802803:	d3 e7                	shl    %cl,%edi
  802805:	89 d1                	mov    %edx,%ecx
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80280f:	d3 e3                	shl    %cl,%ebx
  802811:	89 c7                	mov    %eax,%edi
  802813:	89 d1                	mov    %edx,%ecx
  802815:	89 f0                	mov    %esi,%eax
  802817:	d3 e8                	shr    %cl,%eax
  802819:	89 e9                	mov    %ebp,%ecx
  80281b:	89 fa                	mov    %edi,%edx
  80281d:	d3 e6                	shl    %cl,%esi
  80281f:	09 d8                	or     %ebx,%eax
  802821:	f7 74 24 08          	divl   0x8(%esp)
  802825:	89 d1                	mov    %edx,%ecx
  802827:	89 f3                	mov    %esi,%ebx
  802829:	f7 64 24 0c          	mull   0xc(%esp)
  80282d:	89 c6                	mov    %eax,%esi
  80282f:	89 d7                	mov    %edx,%edi
  802831:	39 d1                	cmp    %edx,%ecx
  802833:	72 06                	jb     80283b <__umoddi3+0x10b>
  802835:	75 10                	jne    802847 <__umoddi3+0x117>
  802837:	39 c3                	cmp    %eax,%ebx
  802839:	73 0c                	jae    802847 <__umoddi3+0x117>
  80283b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80283f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802843:	89 d7                	mov    %edx,%edi
  802845:	89 c6                	mov    %eax,%esi
  802847:	89 ca                	mov    %ecx,%edx
  802849:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80284e:	29 f3                	sub    %esi,%ebx
  802850:	19 fa                	sbb    %edi,%edx
  802852:	89 d0                	mov    %edx,%eax
  802854:	d3 e0                	shl    %cl,%eax
  802856:	89 e9                	mov    %ebp,%ecx
  802858:	d3 eb                	shr    %cl,%ebx
  80285a:	d3 ea                	shr    %cl,%edx
  80285c:	09 d8                	or     %ebx,%eax
  80285e:	83 c4 1c             	add    $0x1c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	29 fe                	sub    %edi,%esi
  802872:	19 c3                	sbb    %eax,%ebx
  802874:	89 f2                	mov    %esi,%edx
  802876:	89 d9                	mov    %ebx,%ecx
  802878:	e9 1d ff ff ff       	jmp    80279a <__umoddi3+0x6a>
