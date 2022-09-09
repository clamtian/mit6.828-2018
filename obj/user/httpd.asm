
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 8d 05 00 00       	call   8005be <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 e0 2b 80 00       	push   $0x802be0
  80003f:	e8 c9 06 00 00       	call   80070d <cprintf>
	exit();
  800044:	e8 bf 05 00 00       	call   800608 <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	68 00 02 00 00       	push   $0x200
  800061:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800067:	50                   	push   %eax
  800068:	53                   	push   %ebx
  800069:	e8 2c 16 00 00       	call   80169a <read>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	85 c0                	test   %eax,%eax
  800073:	78 44                	js     8000b9 <handle_client+0x6b>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  800075:	83 ec 04             	sub    $0x4,%esp
  800078:	6a 0c                	push   $0xc
  80007a:	6a 00                	push   $0x0
  80007c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80007f:	50                   	push   %eax
  800080:	e8 fc 0d 00 00       	call   800e81 <memset>

		req->sock = sock;
  800085:	89 5d dc             	mov    %ebx,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  800088:	83 c4 0c             	add    $0xc,%esp
  80008b:	6a 04                	push   $0x4
  80008d:	68 00 2c 80 00       	push   $0x802c00
  800092:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	e8 62 0d 00 00       	call   800e00 <strncmp>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 a7 00 00 00    	jne    800150 <handle_client+0x102>
	request += 4;
  8000a9:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
	while (*request && *request != ' ')
  8000af:	f6 03 df             	testb  $0xdf,(%ebx)
  8000b2:	74 1c                	je     8000d0 <handle_client+0x82>
		request++;
  8000b4:	83 c3 01             	add    $0x1,%ebx
  8000b7:	eb f6                	jmp    8000af <handle_client+0x61>
			panic("failed to read");
  8000b9:	83 ec 04             	sub    $0x4,%esp
  8000bc:	68 e4 2b 80 00       	push   $0x802be4
  8000c1:	68 04 01 00 00       	push   $0x104
  8000c6:	68 f3 2b 80 00       	push   $0x802bf3
  8000cb:	e8 56 05 00 00       	call   800626 <_panic>
	url_len = request - url;
  8000d0:	8d bd e0 fd ff ff    	lea    -0x220(%ebp),%edi
  8000d6:	89 de                	mov    %ebx,%esi
  8000d8:	29 fe                	sub    %edi,%esi
	req->url = malloc(url_len + 1);
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	8d 46 01             	lea    0x1(%esi),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 5e 20 00 00       	call   802144 <malloc>
  8000e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8000e9:	83 c4 0c             	add    $0xc,%esp
  8000ec:	56                   	push   %esi
  8000ed:	57                   	push   %edi
  8000ee:	50                   	push   %eax
  8000ef:	e8 d9 0d 00 00       	call   800ecd <memmove>
	req->url[url_len] = '\0';
  8000f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	request++;
  8000fb:	83 c3 01             	add    $0x1,%ebx
	while (*request && *request != '\n')
  8000fe:	83 c4 10             	add    $0x10,%esp
	request++;
  800101:	89 d8                	mov    %ebx,%eax
	while (*request && *request != '\n')
  800103:	0f b6 10             	movzbl (%eax),%edx
  800106:	84 d2                	test   %dl,%dl
  800108:	74 0a                	je     800114 <handle_client+0xc6>
  80010a:	80 fa 0a             	cmp    $0xa,%dl
  80010d:	74 05                	je     800114 <handle_client+0xc6>
		request++;
  80010f:	83 c0 01             	add    $0x1,%eax
  800112:	eb ef                	jmp    800103 <handle_client+0xb5>
	version_len = request - version;
  800114:	29 d8                	sub    %ebx,%eax
  800116:	89 c6                	mov    %eax,%esi
	req->version = malloc(version_len + 1);
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	8d 40 01             	lea    0x1(%eax),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 20 20 00 00       	call   802144 <malloc>
  800124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  800127:	83 c4 0c             	add    $0xc,%esp
  80012a:	56                   	push   %esi
  80012b:	53                   	push   %ebx
  80012c:	50                   	push   %eax
  80012d:	e8 9b 0d 00 00       	call   800ecd <memmove>
	req->version[version_len] = '\0';
  800132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800135:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
	panic("send_file not implemented");
  800139:	83 c4 0c             	add    $0xc,%esp
  80013c:	68 05 2c 80 00       	push   $0x802c05
  800141:	68 e2 00 00 00       	push   $0xe2
  800146:	68 f3 2b 80 00       	push   $0x802bf3
  80014b:	e8 d6 04 00 00       	call   800626 <_panic>
  800150:	b8 00 40 80 00       	mov    $0x804000,%eax
	while (e->code != 0 && e->msg != 0) {
  800155:	8b 10                	mov    (%eax),%edx
  800157:	85 d2                	test   %edx,%edx
  800159:	74 43                	je     80019e <handle_client+0x150>
		if (e->code == code)
  80015b:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80015f:	74 0d                	je     80016e <handle_client+0x120>
  800161:	81 fa 90 01 00 00    	cmp    $0x190,%edx
  800167:	74 05                	je     80016e <handle_client+0x120>
		e++;
  800169:	83 c0 08             	add    $0x8,%eax
  80016c:	eb e7                	jmp    800155 <handle_client+0x107>
	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80016e:	8b 40 04             	mov    0x4(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	50                   	push   %eax
  800175:	52                   	push   %edx
  800176:	50                   	push   %eax
  800177:	52                   	push   %edx
  800178:	68 54 2c 80 00       	push   $0x802c54
  80017d:	68 00 02 00 00       	push   $0x200
  800182:	8d b5 dc fb ff ff    	lea    -0x424(%ebp),%esi
  800188:	56                   	push   %esi
  800189:	e8 28 0b 00 00       	call   800cb6 <snprintf>
	if (write(req->sock, buf, r) != r)
  80018e:	83 c4 1c             	add    $0x1c,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	ff 75 dc             	pushl  -0x24(%ebp)
  800196:	e8 d5 15 00 00       	call   801770 <write>
  80019b:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a4:	e8 eb 1e 00 00       	call   802094 <free>
	free(req->version);
  8001a9:	83 c4 04             	add    $0x4,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	e8 e0 1e 00 00       	call   802094 <free>

		// no keep alive
		break;
	}

	close(sock);
  8001b4:	89 1c 24             	mov    %ebx,(%esp)
  8001b7:	e8 94 13 00 00       	call   801550 <close>
}
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <umain>:

void
umain(int argc, char **argv)
{
  8001c7:	f3 0f 1e fb          	endbr32 
  8001cb:	55                   	push   %ebp
  8001cc:	89 e5                	mov    %esp,%ebp
  8001ce:	57                   	push   %edi
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8001d4:	c7 05 20 40 80 00 1f 	movl   $0x802c1f,0x804020
  8001db:	2c 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8001de:	6a 06                	push   $0x6
  8001e0:	6a 01                	push   $0x1
  8001e2:	6a 02                	push   $0x2
  8001e4:	e8 00 1c 00 00       	call   801de9 <socket>
  8001e9:	89 c6                	mov    %eax,%esi
  8001eb:	83 c4 10             	add    $0x10,%esp
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	78 6d                	js     80025f <umain+0x98>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	6a 10                	push   $0x10
  8001f7:	6a 00                	push   $0x0
  8001f9:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8001fc:	53                   	push   %ebx
  8001fd:	e8 7f 0c 00 00       	call   800e81 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  800202:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800206:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80020d:	e8 68 01 00 00       	call   80037a <htonl>
  800212:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  800215:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  80021c:	e8 37 01 00 00       	call   800358 <htons>
  800221:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800225:	83 c4 0c             	add    $0xc,%esp
  800228:	6a 10                	push   $0x10
  80022a:	53                   	push   %ebx
  80022b:	56                   	push   %esi
  80022c:	e8 16 1b 00 00       	call   801d47 <bind>
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	85 c0                	test   %eax,%eax
  800236:	78 33                	js     80026b <umain+0xa4>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	6a 05                	push   $0x5
  80023d:	56                   	push   %esi
  80023e:	e8 7f 1b 00 00       	call   801dc2 <listen>
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	85 c0                	test   %eax,%eax
  800248:	78 2d                	js     800277 <umain+0xb0>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	68 18 2d 80 00       	push   $0x802d18
  800252:	e8 b6 04 00 00       	call   80070d <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80025a:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  80025d:	eb 35                	jmp    800294 <umain+0xcd>
		die("Failed to create socket");
  80025f:	b8 26 2c 80 00       	mov    $0x802c26,%eax
  800264:	e8 ca fd ff ff       	call   800033 <die>
  800269:	eb 87                	jmp    8001f2 <umain+0x2b>
		die("Failed to bind the server socket");
  80026b:	b8 d0 2c 80 00       	mov    $0x802cd0,%eax
  800270:	e8 be fd ff ff       	call   800033 <die>
  800275:	eb c1                	jmp    800238 <umain+0x71>
		die("Failed to listen on server socket");
  800277:	b8 f4 2c 80 00       	mov    $0x802cf4,%eax
  80027c:	e8 b2 fd ff ff       	call   800033 <die>
  800281:	eb c7                	jmp    80024a <umain+0x83>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800283:	b8 3c 2d 80 00       	mov    $0x802d3c,%eax
  800288:	e8 a6 fd ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  80028d:	89 d8                	mov    %ebx,%eax
  80028f:	e8 ba fd ff ff       	call   80004e <handle_client>
		unsigned int clientlen = sizeof(client);
  800294:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	57                   	push   %edi
  80029f:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8002a2:	50                   	push   %eax
  8002a3:	56                   	push   %esi
  8002a4:	e8 6b 1a 00 00       	call   801d14 <accept>
  8002a9:	89 c3                	mov    %eax,%ebx
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	78 d1                	js     800283 <umain+0xbc>
  8002b2:	eb d9                	jmp    80028d <umain+0xc6>

008002b4 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8002b4:	f3 0f 1e fb          	endbr32 
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	57                   	push   %edi
  8002bc:	56                   	push   %esi
  8002bd:	53                   	push   %ebx
  8002be:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002c7:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  8002cb:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  8002ce:	bf 00 50 80 00       	mov    $0x805000,%edi
  8002d3:	eb 2e                	jmp    800303 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  8002d5:	0f b6 c8             	movzbl %al,%ecx
  8002d8:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  8002dd:	88 0a                	mov    %cl,(%edx)
  8002df:	83 c2 01             	add    $0x1,%edx
    while(i--)
  8002e2:	83 e8 01             	sub    $0x1,%eax
  8002e5:	3c ff                	cmp    $0xff,%al
  8002e7:	75 ec                	jne    8002d5 <inet_ntoa+0x21>
  8002e9:	0f b6 db             	movzbl %bl,%ebx
  8002ec:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  8002ee:	8d 7b 01             	lea    0x1(%ebx),%edi
  8002f1:	c6 03 2e             	movb   $0x2e,(%ebx)
  8002f4:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  8002f7:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  8002fb:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  8002ff:	3c 04                	cmp    $0x4,%al
  800301:	74 45                	je     800348 <inet_ntoa+0x94>
  rp = str;
  800303:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  800308:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  80030b:	0f b6 ca             	movzbl %dl,%ecx
  80030e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800311:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800314:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800317:	66 c1 e8 0b          	shr    $0xb,%ax
  80031b:	88 06                	mov    %al,(%esi)
  80031d:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  80031f:	83 c3 01             	add    $0x1,%ebx
  800322:	0f b6 c9             	movzbl %cl,%ecx
  800325:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  800328:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032b:	01 c0                	add    %eax,%eax
  80032d:	89 d1                	mov    %edx,%ecx
  80032f:	29 c1                	sub    %eax,%ecx
  800331:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800333:	83 c0 30             	add    $0x30,%eax
  800336:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800339:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  80033d:	80 fa 09             	cmp    $0x9,%dl
  800340:	77 c6                	ja     800308 <inet_ntoa+0x54>
  800342:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800344:	89 d8                	mov    %ebx,%eax
  800346:	eb 9a                	jmp    8002e2 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  800348:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  80034b:	b8 00 50 80 00       	mov    $0x805000,%eax
  800350:	83 c4 18             	add    $0x18,%esp
  800353:	5b                   	pop    %ebx
  800354:	5e                   	pop    %esi
  800355:	5f                   	pop    %edi
  800356:	5d                   	pop    %ebp
  800357:	c3                   	ret    

00800358 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800358:	f3 0f 1e fb          	endbr32 
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  80035f:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800363:	66 c1 c0 08          	rol    $0x8,%ax
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800369:	f3 0f 1e fb          	endbr32 
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800370:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  800374:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  800378:	5d                   	pop    %ebp
  800379:	c3                   	ret    

0080037a <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80037a:	f3 0f 1e fb          	endbr32 
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  800384:	89 d0                	mov    %edx,%eax
  800386:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800389:	89 d1                	mov    %edx,%ecx
  80038b:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  80038e:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800390:	89 d1                	mov    %edx,%ecx
  800392:	c1 e1 08             	shl    $0x8,%ecx
  800395:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  80039b:	09 c8                	or     %ecx,%eax
  80039d:	c1 ea 08             	shr    $0x8,%edx
  8003a0:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8003a6:	09 d0                	or     %edx,%eax
}
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <inet_aton>:
{
  8003aa:	f3 0f 1e fb          	endbr32 
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	57                   	push   %edi
  8003b2:	56                   	push   %esi
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 2c             	sub    $0x2c,%esp
  8003b7:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8003ba:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  8003bd:	8d 75 d8             	lea    -0x28(%ebp),%esi
  8003c0:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8003c3:	e9 a7 00 00 00       	jmp    80046f <inet_aton+0xc5>
      c = *++cp;
  8003c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  8003cc:	89 c1                	mov    %eax,%ecx
  8003ce:	83 e1 df             	and    $0xffffffdf,%ecx
  8003d1:	80 f9 58             	cmp    $0x58,%cl
  8003d4:	74 10                	je     8003e6 <inet_aton+0x3c>
      c = *++cp;
  8003d6:	83 c2 01             	add    $0x1,%edx
  8003d9:	0f be c0             	movsbl %al,%eax
        base = 8;
  8003dc:	be 08 00 00 00       	mov    $0x8,%esi
  8003e1:	e9 a3 00 00 00       	jmp    800489 <inet_aton+0xdf>
        c = *++cp;
  8003e6:	0f be 42 02          	movsbl 0x2(%edx),%eax
  8003ea:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  8003ed:	be 10 00 00 00       	mov    $0x10,%esi
  8003f2:	e9 92 00 00 00       	jmp    800489 <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  8003f7:	83 fe 10             	cmp    $0x10,%esi
  8003fa:	75 4d                	jne    800449 <inet_aton+0x9f>
  8003fc:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  8003ff:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800402:	89 c1                	mov    %eax,%ecx
  800404:	83 e1 df             	and    $0xffffffdf,%ecx
  800407:	83 e9 41             	sub    $0x41,%ecx
  80040a:	80 f9 05             	cmp    $0x5,%cl
  80040d:	77 3a                	ja     800449 <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  80040f:	c1 e3 04             	shl    $0x4,%ebx
  800412:	83 c0 0a             	add    $0xa,%eax
  800415:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  800419:	19 c9                	sbb    %ecx,%ecx
  80041b:	83 e1 20             	and    $0x20,%ecx
  80041e:	83 c1 41             	add    $0x41,%ecx
  800421:	29 c8                	sub    %ecx,%eax
  800423:	09 c3                	or     %eax,%ebx
        c = *++cp;
  800425:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800428:	0f be 40 01          	movsbl 0x1(%eax),%eax
  80042c:	83 c2 01             	add    $0x1,%edx
  80042f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800432:	89 c7                	mov    %eax,%edi
  800434:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800437:	80 f9 09             	cmp    $0x9,%cl
  80043a:	77 bb                	ja     8003f7 <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  80043c:	0f af de             	imul   %esi,%ebx
  80043f:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800443:	0f be 42 01          	movsbl 0x1(%edx),%eax
  800447:	eb e3                	jmp    80042c <inet_aton+0x82>
    if (c == '.') {
  800449:	83 f8 2e             	cmp    $0x2e,%eax
  80044c:	75 42                	jne    800490 <inet_aton+0xe6>
      if (pp >= parts + 3)
  80044e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800451:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800454:	39 c6                	cmp    %eax,%esi
  800456:	0f 84 16 01 00 00    	je     800572 <inet_aton+0x1c8>
      *pp++ = val;
  80045c:	83 c6 04             	add    $0x4,%esi
  80045f:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800462:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	8d 50 01             	lea    0x1(%eax),%edx
  80046b:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  80046f:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800472:	80 f9 09             	cmp    $0x9,%cl
  800475:	0f 87 f0 00 00 00    	ja     80056b <inet_aton+0x1c1>
    base = 10;
  80047b:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  800480:	83 f8 30             	cmp    $0x30,%eax
  800483:	0f 84 3f ff ff ff    	je     8003c8 <inet_aton+0x1e>
    base = 10;
  800489:	bb 00 00 00 00       	mov    $0x0,%ebx
  80048e:	eb 9f                	jmp    80042f <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800490:	85 c0                	test   %eax,%eax
  800492:	74 29                	je     8004bd <inet_aton+0x113>
    return (0);
  800494:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800499:	89 f9                	mov    %edi,%ecx
  80049b:	80 f9 1f             	cmp    $0x1f,%cl
  80049e:	0f 86 d3 00 00 00    	jbe    800577 <inet_aton+0x1cd>
  8004a4:	84 c0                	test   %al,%al
  8004a6:	0f 88 cb 00 00 00    	js     800577 <inet_aton+0x1cd>
  8004ac:	83 f8 20             	cmp    $0x20,%eax
  8004af:	74 0c                	je     8004bd <inet_aton+0x113>
  8004b1:	83 e8 09             	sub    $0x9,%eax
  8004b4:	83 f8 04             	cmp    $0x4,%eax
  8004b7:	0f 87 ba 00 00 00    	ja     800577 <inet_aton+0x1cd>
  n = pp - parts + 1;
  8004bd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  8004c0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8004c3:	29 c6                	sub    %eax,%esi
  8004c5:	89 f0                	mov    %esi,%eax
  8004c7:	c1 f8 02             	sar    $0x2,%eax
  8004ca:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  8004cd:	83 f8 02             	cmp    $0x2,%eax
  8004d0:	74 7a                	je     80054c <inet_aton+0x1a2>
  8004d2:	83 fa 03             	cmp    $0x3,%edx
  8004d5:	7f 49                	jg     800520 <inet_aton+0x176>
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	0f 84 98 00 00 00    	je     800577 <inet_aton+0x1cd>
  8004df:	83 fa 02             	cmp    $0x2,%edx
  8004e2:	75 19                	jne    8004fd <inet_aton+0x153>
      return (0);
  8004e4:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  8004e9:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  8004ef:	0f 87 82 00 00 00    	ja     800577 <inet_aton+0x1cd>
    val |= parts[0] << 24;
  8004f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f8:	c1 e0 18             	shl    $0x18,%eax
  8004fb:	09 c3                	or     %eax,%ebx
  return (1);
  8004fd:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800506:	74 6f                	je     800577 <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	53                   	push   %ebx
  80050c:	e8 69 fe ff ff       	call   80037a <htonl>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	8b 75 0c             	mov    0xc(%ebp),%esi
  800517:	89 06                	mov    %eax,(%esi)
  return (1);
  800519:	ba 01 00 00 00       	mov    $0x1,%edx
  80051e:	eb 57                	jmp    800577 <inet_aton+0x1cd>
  switch (n) {
  800520:	83 fa 04             	cmp    $0x4,%edx
  800523:	75 d8                	jne    8004fd <inet_aton+0x153>
      return (0);
  800525:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80052a:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800530:	77 45                	ja     800577 <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800532:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800535:	c1 e0 18             	shl    $0x18,%eax
  800538:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80053b:	c1 e2 10             	shl    $0x10,%edx
  80053e:	09 d0                	or     %edx,%eax
  800540:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800543:	c1 e2 08             	shl    $0x8,%edx
  800546:	09 d0                	or     %edx,%eax
  800548:	09 c3                	or     %eax,%ebx
    break;
  80054a:	eb b1                	jmp    8004fd <inet_aton+0x153>
      return (0);
  80054c:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800551:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  800557:	77 1e                	ja     800577 <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  800559:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80055c:	c1 e0 18             	shl    $0x18,%eax
  80055f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800562:	c1 e2 10             	shl    $0x10,%edx
  800565:	09 d0                	or     %edx,%eax
  800567:	09 c3                	or     %eax,%ebx
    break;
  800569:	eb 92                	jmp    8004fd <inet_aton+0x153>
      return (0);
  80056b:	ba 00 00 00 00       	mov    $0x0,%edx
  800570:	eb 05                	jmp    800577 <inet_aton+0x1cd>
        return (0);
  800572:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800577:	89 d0                	mov    %edx,%eax
  800579:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80057c:	5b                   	pop    %ebx
  80057d:	5e                   	pop    %esi
  80057e:	5f                   	pop    %edi
  80057f:	5d                   	pop    %ebp
  800580:	c3                   	ret    

00800581 <inet_addr>:
{
  800581:	f3 0f 1e fb          	endbr32 
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  80058b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	e8 13 fe ff ff       	call   8003aa <inet_aton>
  800597:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  80059a:	85 c0                	test   %eax,%eax
  80059c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8005a1:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8005a7:	f3 0f 1e fb          	endbr32 
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8005b1:	ff 75 08             	pushl  0x8(%ebp)
  8005b4:	e8 c1 fd ff ff       	call   80037a <htonl>
  8005b9:	83 c4 10             	add    $0x10,%esp
}
  8005bc:	c9                   	leave  
  8005bd:	c3                   	ret    

008005be <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005be:	f3 0f 1e fb          	endbr32 
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	56                   	push   %esi
  8005c6:	53                   	push   %ebx
  8005c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005cd:	e8 41 0b 00 00       	call   801113 <sys_getenvid>
  8005d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005d7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005df:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e4:	85 db                	test   %ebx,%ebx
  8005e6:	7e 07                	jle    8005ef <libmain+0x31>
		binaryname = argv[0];
  8005e8:	8b 06                	mov    (%esi),%eax
  8005ea:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8005ef:	83 ec 08             	sub    $0x8,%esp
  8005f2:	56                   	push   %esi
  8005f3:	53                   	push   %ebx
  8005f4:	e8 ce fb ff ff       	call   8001c7 <umain>

	// exit gracefully
	exit();
  8005f9:	e8 0a 00 00 00       	call   800608 <exit>
}
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800604:	5b                   	pop    %ebx
  800605:	5e                   	pop    %esi
  800606:	5d                   	pop    %ebp
  800607:	c3                   	ret    

00800608 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800608:	f3 0f 1e fb          	endbr32 
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800612:	e8 6a 0f 00 00       	call   801581 <close_all>
	sys_env_destroy(0);
  800617:	83 ec 0c             	sub    $0xc,%esp
  80061a:	6a 00                	push   $0x0
  80061c:	e8 ad 0a 00 00       	call   8010ce <sys_env_destroy>
}
  800621:	83 c4 10             	add    $0x10,%esp
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800626:	f3 0f 1e fb          	endbr32 
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	56                   	push   %esi
  80062e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80062f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800632:	8b 35 20 40 80 00    	mov    0x804020,%esi
  800638:	e8 d6 0a 00 00       	call   801113 <sys_getenvid>
  80063d:	83 ec 0c             	sub    $0xc,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	ff 75 08             	pushl  0x8(%ebp)
  800646:	56                   	push   %esi
  800647:	50                   	push   %eax
  800648:	68 90 2d 80 00       	push   $0x802d90
  80064d:	e8 bb 00 00 00       	call   80070d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800652:	83 c4 18             	add    $0x18,%esp
  800655:	53                   	push   %ebx
  800656:	ff 75 10             	pushl  0x10(%ebp)
  800659:	e8 5a 00 00 00       	call   8006b8 <vcprintf>
	cprintf("\n");
  80065e:	c7 04 24 53 32 80 00 	movl   $0x803253,(%esp)
  800665:	e8 a3 00 00 00       	call   80070d <cprintf>
  80066a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80066d:	cc                   	int3   
  80066e:	eb fd                	jmp    80066d <_panic+0x47>

00800670 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800670:	f3 0f 1e fb          	endbr32 
  800674:	55                   	push   %ebp
  800675:	89 e5                	mov    %esp,%ebp
  800677:	53                   	push   %ebx
  800678:	83 ec 04             	sub    $0x4,%esp
  80067b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80067e:	8b 13                	mov    (%ebx),%edx
  800680:	8d 42 01             	lea    0x1(%edx),%eax
  800683:	89 03                	mov    %eax,(%ebx)
  800685:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800688:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80068c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800691:	74 09                	je     80069c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800693:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800697:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	68 ff 00 00 00       	push   $0xff
  8006a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8006a7:	50                   	push   %eax
  8006a8:	e8 dc 09 00 00       	call   801089 <sys_cputs>
		b->idx = 0;
  8006ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	eb db                	jmp    800693 <putch+0x23>

008006b8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006b8:	f3 0f 1e fb          	endbr32 
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006cc:	00 00 00 
	b.cnt = 0;
  8006cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e5:	50                   	push   %eax
  8006e6:	68 70 06 80 00       	push   $0x800670
  8006eb:	e8 20 01 00 00       	call   800810 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006f0:	83 c4 08             	add    $0x8,%esp
  8006f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8006f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006ff:	50                   	push   %eax
  800700:	e8 84 09 00 00       	call   801089 <sys_cputs>

	return b.cnt;
}
  800705:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80070d:	f3 0f 1e fb          	endbr32 
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800717:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80071a:	50                   	push   %eax
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 95 ff ff ff       	call   8006b8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	57                   	push   %edi
  800729:	56                   	push   %esi
  80072a:	53                   	push   %ebx
  80072b:	83 ec 1c             	sub    $0x1c,%esp
  80072e:	89 c7                	mov    %eax,%edi
  800730:	89 d6                	mov    %edx,%esi
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 55 0c             	mov    0xc(%ebp),%edx
  800738:	89 d1                	mov    %edx,%ecx
  80073a:	89 c2                	mov    %eax,%edx
  80073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800742:	8b 45 10             	mov    0x10(%ebp),%eax
  800745:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800748:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80074b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800752:	39 c2                	cmp    %eax,%edx
  800754:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800757:	72 3e                	jb     800797 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	83 eb 01             	sub    $0x1,%ebx
  800762:	53                   	push   %ebx
  800763:	50                   	push   %eax
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 e4             	pushl  -0x1c(%ebp)
  80076a:	ff 75 e0             	pushl  -0x20(%ebp)
  80076d:	ff 75 dc             	pushl  -0x24(%ebp)
  800770:	ff 75 d8             	pushl  -0x28(%ebp)
  800773:	e8 08 22 00 00       	call   802980 <__udivdi3>
  800778:	83 c4 18             	add    $0x18,%esp
  80077b:	52                   	push   %edx
  80077c:	50                   	push   %eax
  80077d:	89 f2                	mov    %esi,%edx
  80077f:	89 f8                	mov    %edi,%eax
  800781:	e8 9f ff ff ff       	call   800725 <printnum>
  800786:	83 c4 20             	add    $0x20,%esp
  800789:	eb 13                	jmp    80079e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	56                   	push   %esi
  80078f:	ff 75 18             	pushl  0x18(%ebp)
  800792:	ff d7                	call   *%edi
  800794:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800797:	83 eb 01             	sub    $0x1,%ebx
  80079a:	85 db                	test   %ebx,%ebx
  80079c:	7f ed                	jg     80078b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	56                   	push   %esi
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b1:	e8 da 22 00 00       	call   802a90 <__umoddi3>
  8007b6:	83 c4 14             	add    $0x14,%esp
  8007b9:	0f be 80 b3 2d 80 00 	movsbl 0x802db3(%eax),%eax
  8007c0:	50                   	push   %eax
  8007c1:	ff d7                	call   *%edi
}
  8007c3:	83 c4 10             	add    $0x10,%esp
  8007c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c9:	5b                   	pop    %ebx
  8007ca:	5e                   	pop    %esi
  8007cb:	5f                   	pop    %edi
  8007cc:	5d                   	pop    %ebp
  8007cd:	c3                   	ret    

008007ce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007ce:	f3 0f 1e fb          	endbr32 
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007dc:	8b 10                	mov    (%eax),%edx
  8007de:	3b 50 04             	cmp    0x4(%eax),%edx
  8007e1:	73 0a                	jae    8007ed <sprintputch+0x1f>
		*b->buf++ = ch;
  8007e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007e6:	89 08                	mov    %ecx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	88 02                	mov    %al,(%edx)
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <printfmt>:
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8007f9:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007fc:	50                   	push   %eax
  8007fd:	ff 75 10             	pushl  0x10(%ebp)
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	ff 75 08             	pushl  0x8(%ebp)
  800806:	e8 05 00 00 00       	call   800810 <vprintfmt>
}
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <vprintfmt>:
{
  800810:	f3 0f 1e fb          	endbr32 
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	57                   	push   %edi
  800818:	56                   	push   %esi
  800819:	53                   	push   %ebx
  80081a:	83 ec 3c             	sub    $0x3c,%esp
  80081d:	8b 75 08             	mov    0x8(%ebp),%esi
  800820:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800823:	8b 7d 10             	mov    0x10(%ebp),%edi
  800826:	e9 8e 03 00 00       	jmp    800bb9 <vprintfmt+0x3a9>
		padc = ' ';
  80082b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80082f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800836:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80083d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800844:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800849:	8d 47 01             	lea    0x1(%edi),%eax
  80084c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80084f:	0f b6 17             	movzbl (%edi),%edx
  800852:	8d 42 dd             	lea    -0x23(%edx),%eax
  800855:	3c 55                	cmp    $0x55,%al
  800857:	0f 87 df 03 00 00    	ja     800c3c <vprintfmt+0x42c>
  80085d:	0f b6 c0             	movzbl %al,%eax
  800860:	3e ff 24 85 00 2f 80 	notrack jmp *0x802f00(,%eax,4)
  800867:	00 
  800868:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80086b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80086f:	eb d8                	jmp    800849 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800871:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800874:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800878:	eb cf                	jmp    800849 <vprintfmt+0x39>
  80087a:	0f b6 d2             	movzbl %dl,%edx
  80087d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
  800885:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800888:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80088b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80088f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800892:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800895:	83 f9 09             	cmp    $0x9,%ecx
  800898:	77 55                	ja     8008ef <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80089a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80089d:	eb e9                	jmp    800888 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8d 40 04             	lea    0x4(%eax),%eax
  8008ad:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008b7:	79 90                	jns    800849 <vprintfmt+0x39>
				width = precision, precision = -1;
  8008b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008bf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8008c6:	eb 81                	jmp    800849 <vprintfmt+0x39>
  8008c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	0f 49 d0             	cmovns %eax,%edx
  8008d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008db:	e9 69 ff ff ff       	jmp    800849 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8008e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008e3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8008ea:	e9 5a ff ff ff       	jmp    800849 <vprintfmt+0x39>
  8008ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f5:	eb bc                	jmp    8008b3 <vprintfmt+0xa3>
			lflag++;
  8008f7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008fd:	e9 47 ff ff ff       	jmp    800849 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 78 04             	lea    0x4(%eax),%edi
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	ff 30                	pushl  (%eax)
  80090e:	ff d6                	call   *%esi
			break;
  800910:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800913:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800916:	e9 9b 02 00 00       	jmp    800bb6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8d 78 04             	lea    0x4(%eax),%edi
  800921:	8b 00                	mov    (%eax),%eax
  800923:	99                   	cltd   
  800924:	31 d0                	xor    %edx,%eax
  800926:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800928:	83 f8 0f             	cmp    $0xf,%eax
  80092b:	7f 23                	jg     800950 <vprintfmt+0x140>
  80092d:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  800934:	85 d2                	test   %edx,%edx
  800936:	74 18                	je     800950 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800938:	52                   	push   %edx
  800939:	68 95 31 80 00       	push   $0x803195
  80093e:	53                   	push   %ebx
  80093f:	56                   	push   %esi
  800940:	e8 aa fe ff ff       	call   8007ef <printfmt>
  800945:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800948:	89 7d 14             	mov    %edi,0x14(%ebp)
  80094b:	e9 66 02 00 00       	jmp    800bb6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800950:	50                   	push   %eax
  800951:	68 cb 2d 80 00       	push   $0x802dcb
  800956:	53                   	push   %ebx
  800957:	56                   	push   %esi
  800958:	e8 92 fe ff ff       	call   8007ef <printfmt>
  80095d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800960:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800963:	e9 4e 02 00 00       	jmp    800bb6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	83 c0 04             	add    $0x4,%eax
  80096e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800976:	85 d2                	test   %edx,%edx
  800978:	b8 c4 2d 80 00       	mov    $0x802dc4,%eax
  80097d:	0f 45 c2             	cmovne %edx,%eax
  800980:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	7e 06                	jle    80098f <vprintfmt+0x17f>
  800989:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80098d:	75 0d                	jne    80099c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80098f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800992:	89 c7                	mov    %eax,%edi
  800994:	03 45 e0             	add    -0x20(%ebp),%eax
  800997:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80099a:	eb 55                	jmp    8009f1 <vprintfmt+0x1e1>
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 d8             	pushl  -0x28(%ebp)
  8009a2:	ff 75 cc             	pushl  -0x34(%ebp)
  8009a5:	e8 46 03 00 00       	call   800cf0 <strnlen>
  8009aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ad:	29 c2                	sub    %eax,%edx
  8009af:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8009b7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8009bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	85 ff                	test   %edi,%edi
  8009c0:	7e 11                	jle    8009d3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	53                   	push   %ebx
  8009c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cb:	83 ef 01             	sub    $0x1,%edi
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	eb eb                	jmp    8009be <vprintfmt+0x1ae>
  8009d3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8009d6:	85 d2                	test   %edx,%edx
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dd:	0f 49 c2             	cmovns %edx,%eax
  8009e0:	29 c2                	sub    %eax,%edx
  8009e2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8009e5:	eb a8                	jmp    80098f <vprintfmt+0x17f>
					putch(ch, putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	53                   	push   %ebx
  8009eb:	52                   	push   %edx
  8009ec:	ff d6                	call   *%esi
  8009ee:	83 c4 10             	add    $0x10,%esp
  8009f1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009f4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f6:	83 c7 01             	add    $0x1,%edi
  8009f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009fd:	0f be d0             	movsbl %al,%edx
  800a00:	85 d2                	test   %edx,%edx
  800a02:	74 4b                	je     800a4f <vprintfmt+0x23f>
  800a04:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a08:	78 06                	js     800a10 <vprintfmt+0x200>
  800a0a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800a0e:	78 1e                	js     800a2e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800a14:	74 d1                	je     8009e7 <vprintfmt+0x1d7>
  800a16:	0f be c0             	movsbl %al,%eax
  800a19:	83 e8 20             	sub    $0x20,%eax
  800a1c:	83 f8 5e             	cmp    $0x5e,%eax
  800a1f:	76 c6                	jbe    8009e7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	53                   	push   %ebx
  800a25:	6a 3f                	push   $0x3f
  800a27:	ff d6                	call   *%esi
  800a29:	83 c4 10             	add    $0x10,%esp
  800a2c:	eb c3                	jmp    8009f1 <vprintfmt+0x1e1>
  800a2e:	89 cf                	mov    %ecx,%edi
  800a30:	eb 0e                	jmp    800a40 <vprintfmt+0x230>
				putch(' ', putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	53                   	push   %ebx
  800a36:	6a 20                	push   $0x20
  800a38:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a3a:	83 ef 01             	sub    $0x1,%edi
  800a3d:	83 c4 10             	add    $0x10,%esp
  800a40:	85 ff                	test   %edi,%edi
  800a42:	7f ee                	jg     800a32 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800a44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a47:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4a:	e9 67 01 00 00       	jmp    800bb6 <vprintfmt+0x3a6>
  800a4f:	89 cf                	mov    %ecx,%edi
  800a51:	eb ed                	jmp    800a40 <vprintfmt+0x230>
	if (lflag >= 2)
  800a53:	83 f9 01             	cmp    $0x1,%ecx
  800a56:	7f 1b                	jg     800a73 <vprintfmt+0x263>
	else if (lflag)
  800a58:	85 c9                	test   %ecx,%ecx
  800a5a:	74 63                	je     800abf <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a64:	99                   	cltd   
  800a65:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	8d 40 04             	lea    0x4(%eax),%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	eb 17                	jmp    800a8a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	8b 50 04             	mov    0x4(%eax),%edx
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	8d 40 08             	lea    0x8(%eax),%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800a8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a8d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800a90:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800a95:	85 c9                	test   %ecx,%ecx
  800a97:	0f 89 ff 00 00 00    	jns    800b9c <vprintfmt+0x38c>
				putch('-', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	53                   	push   %ebx
  800aa1:	6a 2d                	push   $0x2d
  800aa3:	ff d6                	call   *%esi
				num = -(long long) num;
  800aa5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aa8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800aab:	f7 da                	neg    %edx
  800aad:	83 d1 00             	adc    $0x0,%ecx
  800ab0:	f7 d9                	neg    %ecx
  800ab2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800ab5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aba:	e9 dd 00 00 00       	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800abf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac7:	99                   	cltd   
  800ac8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800acb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ace:	8d 40 04             	lea    0x4(%eax),%eax
  800ad1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad4:	eb b4                	jmp    800a8a <vprintfmt+0x27a>
	if (lflag >= 2)
  800ad6:	83 f9 01             	cmp    $0x1,%ecx
  800ad9:	7f 1e                	jg     800af9 <vprintfmt+0x2e9>
	else if (lflag)
  800adb:	85 c9                	test   %ecx,%ecx
  800add:	74 32                	je     800b11 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8b 10                	mov    (%eax),%edx
  800ae4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae9:	8d 40 04             	lea    0x4(%eax),%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800aef:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800af4:	e9 a3 00 00 00       	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	8b 10                	mov    (%eax),%edx
  800afe:	8b 48 04             	mov    0x4(%eax),%ecx
  800b01:	8d 40 08             	lea    0x8(%eax),%eax
  800b04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b07:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800b0c:	e9 8b 00 00 00       	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	8b 10                	mov    (%eax),%edx
  800b16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1b:	8d 40 04             	lea    0x4(%eax),%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b21:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800b26:	eb 74                	jmp    800b9c <vprintfmt+0x38c>
	if (lflag >= 2)
  800b28:	83 f9 01             	cmp    $0x1,%ecx
  800b2b:	7f 1b                	jg     800b48 <vprintfmt+0x338>
	else if (lflag)
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	74 2c                	je     800b5d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800b31:	8b 45 14             	mov    0x14(%ebp),%eax
  800b34:	8b 10                	mov    (%eax),%edx
  800b36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3b:	8d 40 04             	lea    0x4(%eax),%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b41:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800b46:	eb 54                	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800b48:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4b:	8b 10                	mov    (%eax),%edx
  800b4d:	8b 48 04             	mov    0x4(%eax),%ecx
  800b50:	8d 40 08             	lea    0x8(%eax),%eax
  800b53:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b56:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800b5b:	eb 3f                	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b60:	8b 10                	mov    (%eax),%edx
  800b62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b67:	8d 40 04             	lea    0x4(%eax),%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b6d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800b72:	eb 28                	jmp    800b9c <vprintfmt+0x38c>
			putch('0', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	53                   	push   %ebx
  800b78:	6a 30                	push   $0x30
  800b7a:	ff d6                	call   *%esi
			putch('x', putdat);
  800b7c:	83 c4 08             	add    $0x8,%esp
  800b7f:	53                   	push   %ebx
  800b80:	6a 78                	push   $0x78
  800b82:	ff d6                	call   *%esi
			num = (unsigned long long)
  800b84:	8b 45 14             	mov    0x14(%ebp),%eax
  800b87:	8b 10                	mov    (%eax),%edx
  800b89:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800b8e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800b91:	8d 40 04             	lea    0x4(%eax),%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b97:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800b9c:	83 ec 0c             	sub    $0xc,%esp
  800b9f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800ba3:	57                   	push   %edi
  800ba4:	ff 75 e0             	pushl  -0x20(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	51                   	push   %ecx
  800ba9:	52                   	push   %edx
  800baa:	89 da                	mov    %ebx,%edx
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	e8 72 fb ff ff       	call   800725 <printnum>
			break;
  800bb3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800bb6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb9:	83 c7 01             	add    $0x1,%edi
  800bbc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800bc0:	83 f8 25             	cmp    $0x25,%eax
  800bc3:	0f 84 62 fc ff ff    	je     80082b <vprintfmt+0x1b>
			if (ch == '\0')
  800bc9:	85 c0                	test   %eax,%eax
  800bcb:	0f 84 8b 00 00 00    	je     800c5c <vprintfmt+0x44c>
			putch(ch, putdat);
  800bd1:	83 ec 08             	sub    $0x8,%esp
  800bd4:	53                   	push   %ebx
  800bd5:	50                   	push   %eax
  800bd6:	ff d6                	call   *%esi
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	eb dc                	jmp    800bb9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800bdd:	83 f9 01             	cmp    $0x1,%ecx
  800be0:	7f 1b                	jg     800bfd <vprintfmt+0x3ed>
	else if (lflag)
  800be2:	85 c9                	test   %ecx,%ecx
  800be4:	74 2c                	je     800c12 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	8b 10                	mov    (%eax),%edx
  800beb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf0:	8d 40 04             	lea    0x4(%eax),%eax
  800bf3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bf6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800bfb:	eb 9f                	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800c00:	8b 10                	mov    (%eax),%edx
  800c02:	8b 48 04             	mov    0x4(%eax),%ecx
  800c05:	8d 40 08             	lea    0x8(%eax),%eax
  800c08:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c0b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800c10:	eb 8a                	jmp    800b9c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	8b 10                	mov    (%eax),%edx
  800c17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1c:	8d 40 04             	lea    0x4(%eax),%eax
  800c1f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c22:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800c27:	e9 70 ff ff ff       	jmp    800b9c <vprintfmt+0x38c>
			putch(ch, putdat);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	53                   	push   %ebx
  800c30:	6a 25                	push   $0x25
  800c32:	ff d6                	call   *%esi
			break;
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	e9 7a ff ff ff       	jmp    800bb6 <vprintfmt+0x3a6>
			putch('%', putdat);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	53                   	push   %ebx
  800c40:	6a 25                	push   $0x25
  800c42:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	89 f8                	mov    %edi,%eax
  800c49:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c4d:	74 05                	je     800c54 <vprintfmt+0x444>
  800c4f:	83 e8 01             	sub    $0x1,%eax
  800c52:	eb f5                	jmp    800c49 <vprintfmt+0x439>
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	e9 5a ff ff ff       	jmp    800bb6 <vprintfmt+0x3a6>
}
  800c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c64:	f3 0f 1e fb          	endbr32 
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	83 ec 18             	sub    $0x18,%esp
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c77:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c7b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c85:	85 c0                	test   %eax,%eax
  800c87:	74 26                	je     800caf <vsnprintf+0x4b>
  800c89:	85 d2                	test   %edx,%edx
  800c8b:	7e 22                	jle    800caf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c8d:	ff 75 14             	pushl  0x14(%ebp)
  800c90:	ff 75 10             	pushl  0x10(%ebp)
  800c93:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	68 ce 07 80 00       	push   $0x8007ce
  800c9c:	e8 6f fb ff ff       	call   800810 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800caa:	83 c4 10             	add    $0x10,%esp
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    
		return -E_INVAL;
  800caf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cb4:	eb f7                	jmp    800cad <vsnprintf+0x49>

00800cb6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb6:	f3 0f 1e fb          	endbr32 
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cc3:	50                   	push   %eax
  800cc4:	ff 75 10             	pushl  0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 92 ff ff ff       	call   800c64 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cd4:	f3 0f 1e fb          	endbr32 
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ce7:	74 05                	je     800cee <strlen+0x1a>
		n++;
  800ce9:	83 c0 01             	add    $0x1,%eax
  800cec:	eb f5                	jmp    800ce3 <strlen+0xf>
	return n;
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf0:	f3 0f 1e fb          	endbr32 
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  800d02:	39 d0                	cmp    %edx,%eax
  800d04:	74 0d                	je     800d13 <strnlen+0x23>
  800d06:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d0a:	74 05                	je     800d11 <strnlen+0x21>
		n++;
  800d0c:	83 c0 01             	add    $0x1,%eax
  800d0f:	eb f1                	jmp    800d02 <strnlen+0x12>
  800d11:	89 c2                	mov    %eax,%edx
	return n;
}
  800d13:	89 d0                	mov    %edx,%eax
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d17:	f3 0f 1e fb          	endbr32 
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	53                   	push   %ebx
  800d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d22:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d25:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800d2e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800d31:	83 c0 01             	add    $0x1,%eax
  800d34:	84 d2                	test   %dl,%dl
  800d36:	75 f2                	jne    800d2a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800d38:	89 c8                	mov    %ecx,%eax
  800d3a:	5b                   	pop    %ebx
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d3d:	f3 0f 1e fb          	endbr32 
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	53                   	push   %ebx
  800d45:	83 ec 10             	sub    $0x10,%esp
  800d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d4b:	53                   	push   %ebx
  800d4c:	e8 83 ff ff ff       	call   800cd4 <strlen>
  800d51:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	01 d8                	add    %ebx,%eax
  800d59:	50                   	push   %eax
  800d5a:	e8 b8 ff ff ff       	call   800d17 <strcpy>
	return dst;
}
  800d5f:	89 d8                	mov    %ebx,%eax
  800d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d66:	f3 0f 1e fb          	endbr32 
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	8b 75 08             	mov    0x8(%ebp),%esi
  800d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d75:	89 f3                	mov    %esi,%ebx
  800d77:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d7a:	89 f0                	mov    %esi,%eax
  800d7c:	39 d8                	cmp    %ebx,%eax
  800d7e:	74 11                	je     800d91 <strncpy+0x2b>
		*dst++ = *src;
  800d80:	83 c0 01             	add    $0x1,%eax
  800d83:	0f b6 0a             	movzbl (%edx),%ecx
  800d86:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d89:	80 f9 01             	cmp    $0x1,%cl
  800d8c:	83 da ff             	sbb    $0xffffffff,%edx
  800d8f:	eb eb                	jmp    800d7c <strncpy+0x16>
	}
	return ret;
}
  800d91:	89 f0                	mov    %esi,%eax
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d97:	f3 0f 1e fb          	endbr32 
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	8b 75 08             	mov    0x8(%ebp),%esi
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	8b 55 10             	mov    0x10(%ebp),%edx
  800da9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800dab:	85 d2                	test   %edx,%edx
  800dad:	74 21                	je     800dd0 <strlcpy+0x39>
  800daf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800db3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800db5:	39 c2                	cmp    %eax,%edx
  800db7:	74 14                	je     800dcd <strlcpy+0x36>
  800db9:	0f b6 19             	movzbl (%ecx),%ebx
  800dbc:	84 db                	test   %bl,%bl
  800dbe:	74 0b                	je     800dcb <strlcpy+0x34>
			*dst++ = *src++;
  800dc0:	83 c1 01             	add    $0x1,%ecx
  800dc3:	83 c2 01             	add    $0x1,%edx
  800dc6:	88 5a ff             	mov    %bl,-0x1(%edx)
  800dc9:	eb ea                	jmp    800db5 <strlcpy+0x1e>
  800dcb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800dcd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd0:	29 f0                	sub    %esi,%eax
}
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800de3:	0f b6 01             	movzbl (%ecx),%eax
  800de6:	84 c0                	test   %al,%al
  800de8:	74 0c                	je     800df6 <strcmp+0x20>
  800dea:	3a 02                	cmp    (%edx),%al
  800dec:	75 08                	jne    800df6 <strcmp+0x20>
		p++, q++;
  800dee:	83 c1 01             	add    $0x1,%ecx
  800df1:	83 c2 01             	add    $0x1,%edx
  800df4:	eb ed                	jmp    800de3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df6:	0f b6 c0             	movzbl %al,%eax
  800df9:	0f b6 12             	movzbl (%edx),%edx
  800dfc:	29 d0                	sub    %edx,%eax
}
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	53                   	push   %ebx
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0e:	89 c3                	mov    %eax,%ebx
  800e10:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e13:	eb 06                	jmp    800e1b <strncmp+0x1b>
		n--, p++, q++;
  800e15:	83 c0 01             	add    $0x1,%eax
  800e18:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800e1b:	39 d8                	cmp    %ebx,%eax
  800e1d:	74 16                	je     800e35 <strncmp+0x35>
  800e1f:	0f b6 08             	movzbl (%eax),%ecx
  800e22:	84 c9                	test   %cl,%cl
  800e24:	74 04                	je     800e2a <strncmp+0x2a>
  800e26:	3a 0a                	cmp    (%edx),%cl
  800e28:	74 eb                	je     800e15 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2a:	0f b6 00             	movzbl (%eax),%eax
  800e2d:	0f b6 12             	movzbl (%edx),%edx
  800e30:	29 d0                	sub    %edx,%eax
}
  800e32:	5b                   	pop    %ebx
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		return 0;
  800e35:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3a:	eb f6                	jmp    800e32 <strncmp+0x32>

00800e3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e4a:	0f b6 10             	movzbl (%eax),%edx
  800e4d:	84 d2                	test   %dl,%dl
  800e4f:	74 09                	je     800e5a <strchr+0x1e>
		if (*s == c)
  800e51:	38 ca                	cmp    %cl,%dl
  800e53:	74 0a                	je     800e5f <strchr+0x23>
	for (; *s; s++)
  800e55:	83 c0 01             	add    $0x1,%eax
  800e58:	eb f0                	jmp    800e4a <strchr+0xe>
			return (char *) s;
	return 0;
  800e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    

00800e61 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e61:	f3 0f 1e fb          	endbr32 
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e6f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800e72:	38 ca                	cmp    %cl,%dl
  800e74:	74 09                	je     800e7f <strfind+0x1e>
  800e76:	84 d2                	test   %dl,%dl
  800e78:	74 05                	je     800e7f <strfind+0x1e>
	for (; *s; s++)
  800e7a:	83 c0 01             	add    $0x1,%eax
  800e7d:	eb f0                	jmp    800e6f <strfind+0xe>
			break;
	return (char *) s;
}
  800e7f:	5d                   	pop    %ebp
  800e80:	c3                   	ret    

00800e81 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e81:	f3 0f 1e fb          	endbr32 
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e91:	85 c9                	test   %ecx,%ecx
  800e93:	74 31                	je     800ec6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e95:	89 f8                	mov    %edi,%eax
  800e97:	09 c8                	or     %ecx,%eax
  800e99:	a8 03                	test   $0x3,%al
  800e9b:	75 23                	jne    800ec0 <memset+0x3f>
		c &= 0xFF;
  800e9d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ea1:	89 d3                	mov    %edx,%ebx
  800ea3:	c1 e3 08             	shl    $0x8,%ebx
  800ea6:	89 d0                	mov    %edx,%eax
  800ea8:	c1 e0 18             	shl    $0x18,%eax
  800eab:	89 d6                	mov    %edx,%esi
  800ead:	c1 e6 10             	shl    $0x10,%esi
  800eb0:	09 f0                	or     %esi,%eax
  800eb2:	09 c2                	or     %eax,%edx
  800eb4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800eb6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800eb9:	89 d0                	mov    %edx,%eax
  800ebb:	fc                   	cld    
  800ebc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ebe:	eb 06                	jmp    800ec6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	fc                   	cld    
  800ec4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ec6:	89 f8                	mov    %edi,%eax
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ecd:	f3 0f 1e fb          	endbr32 
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800edc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800edf:	39 c6                	cmp    %eax,%esi
  800ee1:	73 32                	jae    800f15 <memmove+0x48>
  800ee3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ee6:	39 c2                	cmp    %eax,%edx
  800ee8:	76 2b                	jbe    800f15 <memmove+0x48>
		s += n;
		d += n;
  800eea:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eed:	89 fe                	mov    %edi,%esi
  800eef:	09 ce                	or     %ecx,%esi
  800ef1:	09 d6                	or     %edx,%esi
  800ef3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ef9:	75 0e                	jne    800f09 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800efb:	83 ef 04             	sub    $0x4,%edi
  800efe:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f01:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f04:	fd                   	std    
  800f05:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f07:	eb 09                	jmp    800f12 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f09:	83 ef 01             	sub    $0x1,%edi
  800f0c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f0f:	fd                   	std    
  800f10:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f12:	fc                   	cld    
  800f13:	eb 1a                	jmp    800f2f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	09 ca                	or     %ecx,%edx
  800f19:	09 f2                	or     %esi,%edx
  800f1b:	f6 c2 03             	test   $0x3,%dl
  800f1e:	75 0a                	jne    800f2a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f20:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800f23:	89 c7                	mov    %eax,%edi
  800f25:	fc                   	cld    
  800f26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f28:	eb 05                	jmp    800f2f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800f2a:	89 c7                	mov    %eax,%edi
  800f2c:	fc                   	cld    
  800f2d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f3d:	ff 75 10             	pushl  0x10(%ebp)
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	ff 75 08             	pushl  0x8(%ebp)
  800f46:	e8 82 ff ff ff       	call   800ecd <memmove>
}
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f4d:	f3 0f 1e fb          	endbr32 
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5c:	89 c6                	mov    %eax,%esi
  800f5e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f61:	39 f0                	cmp    %esi,%eax
  800f63:	74 1c                	je     800f81 <memcmp+0x34>
		if (*s1 != *s2)
  800f65:	0f b6 08             	movzbl (%eax),%ecx
  800f68:	0f b6 1a             	movzbl (%edx),%ebx
  800f6b:	38 d9                	cmp    %bl,%cl
  800f6d:	75 08                	jne    800f77 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f6f:	83 c0 01             	add    $0x1,%eax
  800f72:	83 c2 01             	add    $0x1,%edx
  800f75:	eb ea                	jmp    800f61 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800f77:	0f b6 c1             	movzbl %cl,%eax
  800f7a:	0f b6 db             	movzbl %bl,%ebx
  800f7d:	29 d8                	sub    %ebx,%eax
  800f7f:	eb 05                	jmp    800f86 <memcmp+0x39>
	}

	return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f8a:	f3 0f 1e fb          	endbr32 
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f97:	89 c2                	mov    %eax,%edx
  800f99:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f9c:	39 d0                	cmp    %edx,%eax
  800f9e:	73 09                	jae    800fa9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa0:	38 08                	cmp    %cl,(%eax)
  800fa2:	74 05                	je     800fa9 <memfind+0x1f>
	for (; s < ends; s++)
  800fa4:	83 c0 01             	add    $0x1,%eax
  800fa7:	eb f3                	jmp    800f9c <memfind+0x12>
			break;
	return (void *) s;
}
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
  800fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbb:	eb 03                	jmp    800fc0 <strtol+0x15>
		s++;
  800fbd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800fc0:	0f b6 01             	movzbl (%ecx),%eax
  800fc3:	3c 20                	cmp    $0x20,%al
  800fc5:	74 f6                	je     800fbd <strtol+0x12>
  800fc7:	3c 09                	cmp    $0x9,%al
  800fc9:	74 f2                	je     800fbd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800fcb:	3c 2b                	cmp    $0x2b,%al
  800fcd:	74 2a                	je     800ff9 <strtol+0x4e>
	int neg = 0;
  800fcf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800fd4:	3c 2d                	cmp    $0x2d,%al
  800fd6:	74 2b                	je     801003 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800fde:	75 0f                	jne    800fef <strtol+0x44>
  800fe0:	80 39 30             	cmpb   $0x30,(%ecx)
  800fe3:	74 28                	je     80100d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fe5:	85 db                	test   %ebx,%ebx
  800fe7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fec:	0f 44 d8             	cmove  %eax,%ebx
  800fef:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ff7:	eb 46                	jmp    80103f <strtol+0x94>
		s++;
  800ff9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ffc:	bf 00 00 00 00       	mov    $0x0,%edi
  801001:	eb d5                	jmp    800fd8 <strtol+0x2d>
		s++, neg = 1;
  801003:	83 c1 01             	add    $0x1,%ecx
  801006:	bf 01 00 00 00       	mov    $0x1,%edi
  80100b:	eb cb                	jmp    800fd8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801011:	74 0e                	je     801021 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801013:	85 db                	test   %ebx,%ebx
  801015:	75 d8                	jne    800fef <strtol+0x44>
		s++, base = 8;
  801017:	83 c1 01             	add    $0x1,%ecx
  80101a:	bb 08 00 00 00       	mov    $0x8,%ebx
  80101f:	eb ce                	jmp    800fef <strtol+0x44>
		s += 2, base = 16;
  801021:	83 c1 02             	add    $0x2,%ecx
  801024:	bb 10 00 00 00       	mov    $0x10,%ebx
  801029:	eb c4                	jmp    800fef <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  80102b:	0f be d2             	movsbl %dl,%edx
  80102e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801031:	3b 55 10             	cmp    0x10(%ebp),%edx
  801034:	7d 3a                	jge    801070 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801036:	83 c1 01             	add    $0x1,%ecx
  801039:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80103f:	0f b6 11             	movzbl (%ecx),%edx
  801042:	8d 72 d0             	lea    -0x30(%edx),%esi
  801045:	89 f3                	mov    %esi,%ebx
  801047:	80 fb 09             	cmp    $0x9,%bl
  80104a:	76 df                	jbe    80102b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  80104c:	8d 72 9f             	lea    -0x61(%edx),%esi
  80104f:	89 f3                	mov    %esi,%ebx
  801051:	80 fb 19             	cmp    $0x19,%bl
  801054:	77 08                	ja     80105e <strtol+0xb3>
			dig = *s - 'a' + 10;
  801056:	0f be d2             	movsbl %dl,%edx
  801059:	83 ea 57             	sub    $0x57,%edx
  80105c:	eb d3                	jmp    801031 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  80105e:	8d 72 bf             	lea    -0x41(%edx),%esi
  801061:	89 f3                	mov    %esi,%ebx
  801063:	80 fb 19             	cmp    $0x19,%bl
  801066:	77 08                	ja     801070 <strtol+0xc5>
			dig = *s - 'A' + 10;
  801068:	0f be d2             	movsbl %dl,%edx
  80106b:	83 ea 37             	sub    $0x37,%edx
  80106e:	eb c1                	jmp    801031 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  801070:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801074:	74 05                	je     80107b <strtol+0xd0>
		*endptr = (char *) s;
  801076:	8b 75 0c             	mov    0xc(%ebp),%esi
  801079:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	f7 da                	neg    %edx
  80107f:	85 ff                	test   %edi,%edi
  801081:	0f 45 c2             	cmovne %edx,%eax
}
  801084:	5b                   	pop    %ebx
  801085:	5e                   	pop    %esi
  801086:	5f                   	pop    %edi
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801089:	f3 0f 1e fb          	endbr32 
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	57                   	push   %edi
  801091:	56                   	push   %esi
  801092:	53                   	push   %ebx
	asm volatile("int %1\n"
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109e:	89 c3                	mov    %eax,%ebx
  8010a0:	89 c7                	mov    %eax,%edi
  8010a2:	89 c6                	mov    %eax,%esi
  8010a4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8010a6:	5b                   	pop    %ebx
  8010a7:	5e                   	pop    %esi
  8010a8:	5f                   	pop    %edi
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8010ab:	f3 0f 1e fb          	endbr32 
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	57                   	push   %edi
  8010b3:	56                   	push   %esi
  8010b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8010bf:	89 d1                	mov    %edx,%ecx
  8010c1:	89 d3                	mov    %edx,%ebx
  8010c3:	89 d7                	mov    %edx,%edi
  8010c5:	89 d6                	mov    %edx,%esi
  8010c7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8010c9:	5b                   	pop    %ebx
  8010ca:	5e                   	pop    %esi
  8010cb:	5f                   	pop    %edi
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010ce:	f3 0f 1e fb          	endbr32 
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010db:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e8:	89 cb                	mov    %ecx,%ebx
  8010ea:	89 cf                	mov    %ecx,%edi
  8010ec:	89 ce                	mov    %ecx,%esi
  8010ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	7f 08                	jg     8010fc <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fc:	83 ec 0c             	sub    $0xc,%esp
  8010ff:	50                   	push   %eax
  801100:	6a 03                	push   $0x3
  801102:	68 bf 30 80 00       	push   $0x8030bf
  801107:	6a 23                	push   $0x23
  801109:	68 dc 30 80 00       	push   $0x8030dc
  80110e:	e8 13 f5 ff ff       	call   800626 <_panic>

00801113 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801113:	f3 0f 1e fb          	endbr32 
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	57                   	push   %edi
  80111b:	56                   	push   %esi
  80111c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80111d:	ba 00 00 00 00       	mov    $0x0,%edx
  801122:	b8 02 00 00 00       	mov    $0x2,%eax
  801127:	89 d1                	mov    %edx,%ecx
  801129:	89 d3                	mov    %edx,%ebx
  80112b:	89 d7                	mov    %edx,%edi
  80112d:	89 d6                	mov    %edx,%esi
  80112f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <sys_yield>:

void
sys_yield(void)
{
  801136:	f3 0f 1e fb          	endbr32 
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801140:	ba 00 00 00 00       	mov    $0x0,%edx
  801145:	b8 0b 00 00 00       	mov    $0xb,%eax
  80114a:	89 d1                	mov    %edx,%ecx
  80114c:	89 d3                	mov    %edx,%ebx
  80114e:	89 d7                	mov    %edx,%edi
  801150:	89 d6                	mov    %edx,%esi
  801152:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5f                   	pop    %edi
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801159:	f3 0f 1e fb          	endbr32 
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801166:	be 00 00 00 00       	mov    $0x0,%esi
  80116b:	8b 55 08             	mov    0x8(%ebp),%edx
  80116e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801171:	b8 04 00 00 00       	mov    $0x4,%eax
  801176:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801179:	89 f7                	mov    %esi,%edi
  80117b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80117d:	85 c0                	test   %eax,%eax
  80117f:	7f 08                	jg     801189 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801181:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801184:	5b                   	pop    %ebx
  801185:	5e                   	pop    %esi
  801186:	5f                   	pop    %edi
  801187:	5d                   	pop    %ebp
  801188:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	50                   	push   %eax
  80118d:	6a 04                	push   $0x4
  80118f:	68 bf 30 80 00       	push   $0x8030bf
  801194:	6a 23                	push   $0x23
  801196:	68 dc 30 80 00       	push   $0x8030dc
  80119b:	e8 86 f4 ff ff       	call   800626 <_panic>

008011a0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011a0:	f3 0f 1e fb          	endbr32 
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	57                   	push   %edi
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
  8011aa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b3:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bb:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011be:	8b 75 18             	mov    0x18(%ebp),%esi
  8011c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	7f 08                	jg     8011cf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ca:	5b                   	pop    %ebx
  8011cb:	5e                   	pop    %esi
  8011cc:	5f                   	pop    %edi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011cf:	83 ec 0c             	sub    $0xc,%esp
  8011d2:	50                   	push   %eax
  8011d3:	6a 05                	push   $0x5
  8011d5:	68 bf 30 80 00       	push   $0x8030bf
  8011da:	6a 23                	push   $0x23
  8011dc:	68 dc 30 80 00       	push   $0x8030dc
  8011e1:	e8 40 f4 ff ff       	call   800626 <_panic>

008011e6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011e6:	f3 0f 1e fb          	endbr32 
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fe:	b8 06 00 00 00       	mov    $0x6,%eax
  801203:	89 df                	mov    %ebx,%edi
  801205:	89 de                	mov    %ebx,%esi
  801207:	cd 30                	int    $0x30
	if(check && ret > 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	7f 08                	jg     801215 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	50                   	push   %eax
  801219:	6a 06                	push   $0x6
  80121b:	68 bf 30 80 00       	push   $0x8030bf
  801220:	6a 23                	push   $0x23
  801222:	68 dc 30 80 00       	push   $0x8030dc
  801227:	e8 fa f3 ff ff       	call   800626 <_panic>

0080122c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122c:	f3 0f 1e fb          	endbr32 
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	8b 55 08             	mov    0x8(%ebp),%edx
  801241:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801244:	b8 08 00 00 00       	mov    $0x8,%eax
  801249:	89 df                	mov    %ebx,%edi
  80124b:	89 de                	mov    %ebx,%esi
  80124d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7f 08                	jg     80125b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801253:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801256:	5b                   	pop    %ebx
  801257:	5e                   	pop    %esi
  801258:	5f                   	pop    %edi
  801259:	5d                   	pop    %ebp
  80125a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	50                   	push   %eax
  80125f:	6a 08                	push   $0x8
  801261:	68 bf 30 80 00       	push   $0x8030bf
  801266:	6a 23                	push   $0x23
  801268:	68 dc 30 80 00       	push   $0x8030dc
  80126d:	e8 b4 f3 ff ff       	call   800626 <_panic>

00801272 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801272:	f3 0f 1e fb          	endbr32 
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	57                   	push   %edi
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
  80127c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80127f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801284:	8b 55 08             	mov    0x8(%ebp),%edx
  801287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128a:	b8 09 00 00 00       	mov    $0x9,%eax
  80128f:	89 df                	mov    %ebx,%edi
  801291:	89 de                	mov    %ebx,%esi
  801293:	cd 30                	int    $0x30
	if(check && ret > 0)
  801295:	85 c0                	test   %eax,%eax
  801297:	7f 08                	jg     8012a1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801299:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5f                   	pop    %edi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a1:	83 ec 0c             	sub    $0xc,%esp
  8012a4:	50                   	push   %eax
  8012a5:	6a 09                	push   $0x9
  8012a7:	68 bf 30 80 00       	push   $0x8030bf
  8012ac:	6a 23                	push   $0x23
  8012ae:	68 dc 30 80 00       	push   $0x8030dc
  8012b3:	e8 6e f3 ff ff       	call   800626 <_panic>

008012b8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012b8:	f3 0f 1e fb          	endbr32 
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012d5:	89 df                	mov    %ebx,%edi
  8012d7:	89 de                	mov    %ebx,%esi
  8012d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	7f 08                	jg     8012e7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	50                   	push   %eax
  8012eb:	6a 0a                	push   $0xa
  8012ed:	68 bf 30 80 00       	push   $0x8030bf
  8012f2:	6a 23                	push   $0x23
  8012f4:	68 dc 30 80 00       	push   $0x8030dc
  8012f9:	e8 28 f3 ff ff       	call   800626 <_panic>

008012fe <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012fe:	f3 0f 1e fb          	endbr32 
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	57                   	push   %edi
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
	asm volatile("int %1\n"
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801313:	be 00 00 00 00       	mov    $0x0,%esi
  801318:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80131e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801320:	5b                   	pop    %ebx
  801321:	5e                   	pop    %esi
  801322:	5f                   	pop    %edi
  801323:	5d                   	pop    %ebp
  801324:	c3                   	ret    

00801325 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801325:	f3 0f 1e fb          	endbr32 
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	57                   	push   %edi
  80132d:	56                   	push   %esi
  80132e:	53                   	push   %ebx
  80132f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801332:	b9 00 00 00 00       	mov    $0x0,%ecx
  801337:	8b 55 08             	mov    0x8(%ebp),%edx
  80133a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80133f:	89 cb                	mov    %ecx,%ebx
  801341:	89 cf                	mov    %ecx,%edi
  801343:	89 ce                	mov    %ecx,%esi
  801345:	cd 30                	int    $0x30
	if(check && ret > 0)
  801347:	85 c0                	test   %eax,%eax
  801349:	7f 08                	jg     801353 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80134b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5e                   	pop    %esi
  801350:	5f                   	pop    %edi
  801351:	5d                   	pop    %ebp
  801352:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	50                   	push   %eax
  801357:	6a 0d                	push   $0xd
  801359:	68 bf 30 80 00       	push   $0x8030bf
  80135e:	6a 23                	push   $0x23
  801360:	68 dc 30 80 00       	push   $0x8030dc
  801365:	e8 bc f2 ff ff       	call   800626 <_panic>

0080136a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80136a:	f3 0f 1e fb          	endbr32 
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	57                   	push   %edi
  801372:	56                   	push   %esi
  801373:	53                   	push   %ebx
	asm volatile("int %1\n"
  801374:	ba 00 00 00 00       	mov    $0x0,%edx
  801379:	b8 0e 00 00 00       	mov    $0xe,%eax
  80137e:	89 d1                	mov    %edx,%ecx
  801380:	89 d3                	mov    %edx,%ebx
  801382:	89 d7                	mov    %edx,%edi
  801384:	89 d6                	mov    %edx,%esi
  801386:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801388:	5b                   	pop    %ebx
  801389:	5e                   	pop    %esi
  80138a:	5f                   	pop    %edi
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80138d:	f3 0f 1e fb          	endbr32 
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	05 00 00 00 30       	add    $0x30000000,%eax
  80139c:	c1 e8 0c             	shr    $0xc,%eax
}
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a1:	f3 0f 1e fb          	endbr32 
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013bc:	f3 0f 1e fb          	endbr32 
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c8:	89 c2                	mov    %eax,%edx
  8013ca:	c1 ea 16             	shr    $0x16,%edx
  8013cd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d4:	f6 c2 01             	test   $0x1,%dl
  8013d7:	74 2d                	je     801406 <fd_alloc+0x4a>
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 ea 0c             	shr    $0xc,%edx
  8013de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e5:	f6 c2 01             	test   $0x1,%dl
  8013e8:	74 1c                	je     801406 <fd_alloc+0x4a>
  8013ea:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8013ef:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f4:	75 d2                	jne    8013c8 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8013ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801404:	eb 0a                	jmp    801410 <fd_alloc+0x54>
			*fd_store = fd;
  801406:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801409:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801412:	f3 0f 1e fb          	endbr32 
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80141c:	83 f8 1f             	cmp    $0x1f,%eax
  80141f:	77 30                	ja     801451 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801421:	c1 e0 0c             	shl    $0xc,%eax
  801424:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801429:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80142f:	f6 c2 01             	test   $0x1,%dl
  801432:	74 24                	je     801458 <fd_lookup+0x46>
  801434:	89 c2                	mov    %eax,%edx
  801436:	c1 ea 0c             	shr    $0xc,%edx
  801439:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801440:	f6 c2 01             	test   $0x1,%dl
  801443:	74 1a                	je     80145f <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	89 02                	mov    %eax,(%edx)
	return 0;
  80144a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144f:	5d                   	pop    %ebp
  801450:	c3                   	ret    
		return -E_INVAL;
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801456:	eb f7                	jmp    80144f <fd_lookup+0x3d>
		return -E_INVAL;
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb f0                	jmp    80144f <fd_lookup+0x3d>
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801464:	eb e9                	jmp    80144f <fd_lookup+0x3d>

00801466 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801466:	f3 0f 1e fb          	endbr32 
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  80147d:	39 08                	cmp    %ecx,(%eax)
  80147f:	74 38                	je     8014b9 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801481:	83 c2 01             	add    $0x1,%edx
  801484:	8b 04 95 68 31 80 00 	mov    0x803168(,%edx,4),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	75 ee                	jne    80147d <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	51                   	push   %ecx
  80149b:	50                   	push   %eax
  80149c:	68 ec 30 80 00       	push   $0x8030ec
  8014a1:	e8 67 f2 ff ff       	call   80070d <cprintf>
	*dev = 0;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    
			*dev = devtab[i];
  8014b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb f2                	jmp    8014b7 <dev_lookup+0x51>

008014c5 <fd_close>:
{
  8014c5:	f3 0f 1e fb          	endbr32 
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	57                   	push   %edi
  8014cd:	56                   	push   %esi
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 24             	sub    $0x24,%esp
  8014d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e5:	50                   	push   %eax
  8014e6:	e8 27 ff ff ff       	call   801412 <fd_lookup>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 05                	js     8014f9 <fd_close+0x34>
	    || fd != fd2)
  8014f4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8014f7:	74 16                	je     80150f <fd_close+0x4a>
		return (must_exist ? r : 0);
  8014f9:	89 f8                	mov    %edi,%eax
  8014fb:	84 c0                	test   %al,%al
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801502:	0f 44 d8             	cmove  %eax,%ebx
}
  801505:	89 d8                	mov    %ebx,%eax
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 36                	pushl  (%esi)
  801518:	e8 49 ff ff ff       	call   801466 <dev_lookup>
  80151d:	89 c3                	mov    %eax,%ebx
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 1a                	js     801540 <fd_close+0x7b>
		if (dev->dev_close)
  801526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801529:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80152c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801531:	85 c0                	test   %eax,%eax
  801533:	74 0b                	je     801540 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	56                   	push   %esi
  801539:	ff d0                	call   *%eax
  80153b:	89 c3                	mov    %eax,%ebx
  80153d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	56                   	push   %esi
  801544:	6a 00                	push   $0x0
  801546:	e8 9b fc ff ff       	call   8011e6 <sys_page_unmap>
	return r;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	eb b5                	jmp    801505 <fd_close+0x40>

00801550 <close>:

int
close(int fdnum)
{
  801550:	f3 0f 1e fb          	endbr32 
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155d:	50                   	push   %eax
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 ac fe ff ff       	call   801412 <fd_lookup>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 02                	jns    80156f <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    
		return fd_close(fd, 1);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	6a 01                	push   $0x1
  801574:	ff 75 f4             	pushl  -0xc(%ebp)
  801577:	e8 49 ff ff ff       	call   8014c5 <fd_close>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	eb ec                	jmp    80156d <close+0x1d>

00801581 <close_all>:

void
close_all(void)
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80158c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801591:	83 ec 0c             	sub    $0xc,%esp
  801594:	53                   	push   %ebx
  801595:	e8 b6 ff ff ff       	call   801550 <close>
	for (i = 0; i < MAXFD; i++)
  80159a:	83 c3 01             	add    $0x1,%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	83 fb 20             	cmp    $0x20,%ebx
  8015a3:	75 ec                	jne    801591 <close_all+0x10>
}
  8015a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015aa:	f3 0f 1e fb          	endbr32 
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	57                   	push   %edi
  8015b2:	56                   	push   %esi
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 4f fe ff ff       	call   801412 <fd_lookup>
  8015c3:	89 c3                	mov    %eax,%ebx
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	0f 88 81 00 00 00    	js     801651 <dup+0xa7>
		return r;
	close(newfdnum);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	e8 75 ff ff ff       	call   801550 <close>

	newfd = INDEX2FD(newfdnum);
  8015db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015de:	c1 e6 0c             	shl    $0xc,%esi
  8015e1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015e7:	83 c4 04             	add    $0x4,%esp
  8015ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015ed:	e8 af fd ff ff       	call   8013a1 <fd2data>
  8015f2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015f4:	89 34 24             	mov    %esi,(%esp)
  8015f7:	e8 a5 fd ff ff       	call   8013a1 <fd2data>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801601:	89 d8                	mov    %ebx,%eax
  801603:	c1 e8 16             	shr    $0x16,%eax
  801606:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80160d:	a8 01                	test   $0x1,%al
  80160f:	74 11                	je     801622 <dup+0x78>
  801611:	89 d8                	mov    %ebx,%eax
  801613:	c1 e8 0c             	shr    $0xc,%eax
  801616:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80161d:	f6 c2 01             	test   $0x1,%dl
  801620:	75 39                	jne    80165b <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801625:	89 d0                	mov    %edx,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	25 07 0e 00 00       	and    $0xe07,%eax
  801639:	50                   	push   %eax
  80163a:	56                   	push   %esi
  80163b:	6a 00                	push   $0x0
  80163d:	52                   	push   %edx
  80163e:	6a 00                	push   $0x0
  801640:	e8 5b fb ff ff       	call   8011a0 <sys_page_map>
  801645:	89 c3                	mov    %eax,%ebx
  801647:	83 c4 20             	add    $0x20,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 31                	js     80167f <dup+0xd5>
		goto err;

	return newfdnum;
  80164e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801651:	89 d8                	mov    %ebx,%eax
  801653:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5f                   	pop    %edi
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80165b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801662:	83 ec 0c             	sub    $0xc,%esp
  801665:	25 07 0e 00 00       	and    $0xe07,%eax
  80166a:	50                   	push   %eax
  80166b:	57                   	push   %edi
  80166c:	6a 00                	push   $0x0
  80166e:	53                   	push   %ebx
  80166f:	6a 00                	push   $0x0
  801671:	e8 2a fb ff ff       	call   8011a0 <sys_page_map>
  801676:	89 c3                	mov    %eax,%ebx
  801678:	83 c4 20             	add    $0x20,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	79 a3                	jns    801622 <dup+0x78>
	sys_page_unmap(0, newfd);
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	56                   	push   %esi
  801683:	6a 00                	push   $0x0
  801685:	e8 5c fb ff ff       	call   8011e6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80168a:	83 c4 08             	add    $0x8,%esp
  80168d:	57                   	push   %edi
  80168e:	6a 00                	push   $0x0
  801690:	e8 51 fb ff ff       	call   8011e6 <sys_page_unmap>
	return r;
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	eb b7                	jmp    801651 <dup+0xa7>

0080169a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80169a:	f3 0f 1e fb          	endbr32 
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 1c             	sub    $0x1c,%esp
  8016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ab:	50                   	push   %eax
  8016ac:	53                   	push   %ebx
  8016ad:	e8 60 fd ff ff       	call   801412 <fd_lookup>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 3f                	js     8016f8 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b9:	83 ec 08             	sub    $0x8,%esp
  8016bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	ff 30                	pushl  (%eax)
  8016c5:	e8 9c fd ff ff       	call   801466 <dev_lookup>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 27                	js     8016f8 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 42 08             	mov    0x8(%edx),%eax
  8016d7:	83 e0 03             	and    $0x3,%eax
  8016da:	83 f8 01             	cmp    $0x1,%eax
  8016dd:	74 1e                	je     8016fd <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	8b 40 08             	mov    0x8(%eax),%eax
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 35                	je     80171e <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	ff 75 10             	pushl  0x10(%ebp)
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	52                   	push   %edx
  8016f3:	ff d0                	call   *%eax
  8016f5:	83 c4 10             	add    $0x10,%esp
}
  8016f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016fd:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801702:	8b 40 48             	mov    0x48(%eax),%eax
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	53                   	push   %ebx
  801709:	50                   	push   %eax
  80170a:	68 2d 31 80 00       	push   $0x80312d
  80170f:	e8 f9 ef ff ff       	call   80070d <cprintf>
		return -E_INVAL;
  801714:	83 c4 10             	add    $0x10,%esp
  801717:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80171c:	eb da                	jmp    8016f8 <read+0x5e>
		return -E_NOT_SUPP;
  80171e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801723:	eb d3                	jmp    8016f8 <read+0x5e>

00801725 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801725:	f3 0f 1e fb          	endbr32 
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	57                   	push   %edi
  80172d:	56                   	push   %esi
  80172e:	53                   	push   %ebx
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	8b 7d 08             	mov    0x8(%ebp),%edi
  801735:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801738:	bb 00 00 00 00       	mov    $0x0,%ebx
  80173d:	eb 02                	jmp    801741 <readn+0x1c>
  80173f:	01 c3                	add    %eax,%ebx
  801741:	39 f3                	cmp    %esi,%ebx
  801743:	73 21                	jae    801766 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	89 f0                	mov    %esi,%eax
  80174a:	29 d8                	sub    %ebx,%eax
  80174c:	50                   	push   %eax
  80174d:	89 d8                	mov    %ebx,%eax
  80174f:	03 45 0c             	add    0xc(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	57                   	push   %edi
  801754:	e8 41 ff ff ff       	call   80169a <read>
		if (m < 0)
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 04                	js     801764 <readn+0x3f>
			return m;
		if (m == 0)
  801760:	75 dd                	jne    80173f <readn+0x1a>
  801762:	eb 02                	jmp    801766 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801764:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801766:	89 d8                	mov    %ebx,%eax
  801768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176b:	5b                   	pop    %ebx
  80176c:	5e                   	pop    %esi
  80176d:	5f                   	pop    %edi
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	53                   	push   %ebx
  801778:	83 ec 1c             	sub    $0x1c,%esp
  80177b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801781:	50                   	push   %eax
  801782:	53                   	push   %ebx
  801783:	e8 8a fc ff ff       	call   801412 <fd_lookup>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 3a                	js     8017c9 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801795:	50                   	push   %eax
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	ff 30                	pushl  (%eax)
  80179b:	e8 c6 fc ff ff       	call   801466 <dev_lookup>
  8017a0:	83 c4 10             	add    $0x10,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 22                	js     8017c9 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ae:	74 1e                	je     8017ce <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b3:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b6:	85 d2                	test   %edx,%edx
  8017b8:	74 35                	je     8017ef <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	ff 75 10             	pushl  0x10(%ebp)
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	50                   	push   %eax
  8017c4:	ff d2                	call   *%edx
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ce:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8017d3:	8b 40 48             	mov    0x48(%eax),%eax
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	53                   	push   %ebx
  8017da:	50                   	push   %eax
  8017db:	68 49 31 80 00       	push   $0x803149
  8017e0:	e8 28 ef ff ff       	call   80070d <cprintf>
		return -E_INVAL;
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ed:	eb da                	jmp    8017c9 <write+0x59>
		return -E_NOT_SUPP;
  8017ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f4:	eb d3                	jmp    8017c9 <write+0x59>

008017f6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017f6:	f3 0f 1e fb          	endbr32 
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	e8 06 fc ff ff       	call   801412 <fd_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 0e                	js     801821 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80181c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801823:	f3 0f 1e fb          	endbr32 
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	53                   	push   %ebx
  80182b:	83 ec 1c             	sub    $0x1c,%esp
  80182e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801831:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801834:	50                   	push   %eax
  801835:	53                   	push   %ebx
  801836:	e8 d7 fb ff ff       	call   801412 <fd_lookup>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 37                	js     801879 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801848:	50                   	push   %eax
  801849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184c:	ff 30                	pushl  (%eax)
  80184e:	e8 13 fc ff ff       	call   801466 <dev_lookup>
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	85 c0                	test   %eax,%eax
  801858:	78 1f                	js     801879 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801861:	74 1b                	je     80187e <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801866:	8b 52 18             	mov    0x18(%edx),%edx
  801869:	85 d2                	test   %edx,%edx
  80186b:	74 32                	je     80189f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	50                   	push   %eax
  801874:	ff d2                	call   *%edx
  801876:	83 c4 10             	add    $0x10,%esp
}
  801879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80187e:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801883:	8b 40 48             	mov    0x48(%eax),%eax
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	53                   	push   %ebx
  80188a:	50                   	push   %eax
  80188b:	68 0c 31 80 00       	push   $0x80310c
  801890:	e8 78 ee ff ff       	call   80070d <cprintf>
		return -E_INVAL;
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80189d:	eb da                	jmp    801879 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80189f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a4:	eb d3                	jmp    801879 <ftruncate+0x56>

008018a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a6:	f3 0f 1e fb          	endbr32 
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 1c             	sub    $0x1c,%esp
  8018b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	50                   	push   %eax
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	e8 52 fb ff ff       	call   801412 <fd_lookup>
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 4b                	js     801912 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d1:	ff 30                	pushl  (%eax)
  8018d3:	e8 8e fb ff ff       	call   801466 <dev_lookup>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 33                	js     801912 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018e6:	74 2f                	je     801917 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018e8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018eb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018f2:	00 00 00 
	stat->st_isdir = 0;
  8018f5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018fc:	00 00 00 
	stat->st_dev = dev;
  8018ff:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801905:	83 ec 08             	sub    $0x8,%esp
  801908:	53                   	push   %ebx
  801909:	ff 75 f0             	pushl  -0x10(%ebp)
  80190c:	ff 50 14             	call   *0x14(%eax)
  80190f:	83 c4 10             	add    $0x10,%esp
}
  801912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801915:	c9                   	leave  
  801916:	c3                   	ret    
		return -E_NOT_SUPP;
  801917:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191c:	eb f4                	jmp    801912 <fstat+0x6c>

0080191e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80191e:	f3 0f 1e fb          	endbr32 
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	6a 00                	push   $0x0
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 fb 01 00 00       	call   801b2f <open>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	85 c0                	test   %eax,%eax
  80193b:	78 1b                	js     801958 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80193d:	83 ec 08             	sub    $0x8,%esp
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	50                   	push   %eax
  801944:	e8 5d ff ff ff       	call   8018a6 <fstat>
  801949:	89 c6                	mov    %eax,%esi
	close(fd);
  80194b:	89 1c 24             	mov    %ebx,(%esp)
  80194e:	e8 fd fb ff ff       	call   801550 <close>
	return r;
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	89 f3                	mov    %esi,%ebx
}
  801958:	89 d8                	mov    %ebx,%eax
  80195a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5e                   	pop    %esi
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    

00801961 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
  801966:	89 c6                	mov    %eax,%esi
  801968:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80196a:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801971:	74 27                	je     80199a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801973:	6a 07                	push   $0x7
  801975:	68 00 60 80 00       	push   $0x806000
  80197a:	56                   	push   %esi
  80197b:	ff 35 10 50 80 00    	pushl  0x805010
  801981:	e8 22 0f 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801986:	83 c4 0c             	add    $0xc,%esp
  801989:	6a 00                	push   $0x0
  80198b:	53                   	push   %ebx
  80198c:	6a 00                	push   $0x0
  80198e:	e8 a1 0e 00 00       	call   802834 <ipc_recv>
}
  801993:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	6a 01                	push   $0x1
  80199f:	e8 5c 0f 00 00       	call   802900 <ipc_find_env>
  8019a4:	a3 10 50 80 00       	mov    %eax,0x805010
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	eb c5                	jmp    801973 <fsipc+0x12>

008019ae <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019ae:	f3 0f 1e fb          	endbr32 
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019be:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8019d5:	e8 87 ff ff ff       	call   801961 <fsipc>
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <devfile_flush>:
{
  8019dc:	f3 0f 1e fb          	endbr32 
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ec:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8019fb:	e8 61 ff ff ff       	call   801961 <fsipc>
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <devfile_stat>:
{
  801a02:	f3 0f 1e fb          	endbr32 
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	53                   	push   %ebx
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 40 0c             	mov    0xc(%eax),%eax
  801a16:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	b8 05 00 00 00       	mov    $0x5,%eax
  801a25:	e8 37 ff ff ff       	call   801961 <fsipc>
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 2c                	js     801a5a <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	68 00 60 80 00       	push   $0x806000
  801a36:	53                   	push   %ebx
  801a37:	e8 db f2 ff ff       	call   800d17 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a3c:	a1 80 60 80 00       	mov    0x806080,%eax
  801a41:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a47:	a1 84 60 80 00       	mov    0x806084,%eax
  801a4c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <devfile_write>:
{
  801a5f:	f3 0f 1e fb          	endbr32 
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a6f:	8b 52 0c             	mov    0xc(%edx),%edx
  801a72:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801a78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7d:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a82:	0f 47 c2             	cmova  %edx,%eax
  801a85:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a8a:	50                   	push   %eax
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	68 08 60 80 00       	push   $0x806008
  801a93:	e8 35 f4 ff ff       	call   800ecd <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801a98:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9d:	b8 04 00 00 00       	mov    $0x4,%eax
  801aa2:	e8 ba fe ff ff       	call   801961 <fsipc>
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <devfile_read>:
{
  801aa9:	f3 0f 1e fb          	endbr32 
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  801abb:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ac0:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ac6:	ba 00 00 00 00       	mov    $0x0,%edx
  801acb:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad0:	e8 8c fe ff ff       	call   801961 <fsipc>
  801ad5:	89 c3                	mov    %eax,%ebx
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	78 1f                	js     801afa <devfile_read+0x51>
	assert(r <= n);
  801adb:	39 f0                	cmp    %esi,%eax
  801add:	77 24                	ja     801b03 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801adf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae4:	7f 33                	jg     801b19 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	50                   	push   %eax
  801aea:	68 00 60 80 00       	push   $0x806000
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	e8 d6 f3 ff ff       	call   800ecd <memmove>
	return r;
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    
	assert(r <= n);
  801b03:	68 7c 31 80 00       	push   $0x80317c
  801b08:	68 83 31 80 00       	push   $0x803183
  801b0d:	6a 7c                	push   $0x7c
  801b0f:	68 98 31 80 00       	push   $0x803198
  801b14:	e8 0d eb ff ff       	call   800626 <_panic>
	assert(r <= PGSIZE);
  801b19:	68 a3 31 80 00       	push   $0x8031a3
  801b1e:	68 83 31 80 00       	push   $0x803183
  801b23:	6a 7d                	push   $0x7d
  801b25:	68 98 31 80 00       	push   $0x803198
  801b2a:	e8 f7 ea ff ff       	call   800626 <_panic>

00801b2f <open>:
{
  801b2f:	f3 0f 1e fb          	endbr32 
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	83 ec 1c             	sub    $0x1c,%esp
  801b3b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b3e:	56                   	push   %esi
  801b3f:	e8 90 f1 ff ff       	call   800cd4 <strlen>
  801b44:	83 c4 10             	add    $0x10,%esp
  801b47:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b4c:	7f 6c                	jg     801bba <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b54:	50                   	push   %eax
  801b55:	e8 62 f8 ff ff       	call   8013bc <fd_alloc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 3c                	js     801b9f <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801b63:	83 ec 08             	sub    $0x8,%esp
  801b66:	56                   	push   %esi
  801b67:	68 00 60 80 00       	push   $0x806000
  801b6c:	e8 a6 f1 ff ff       	call   800d17 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b81:	e8 db fd ff ff       	call   801961 <fsipc>
  801b86:	89 c3                	mov    %eax,%ebx
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	78 19                	js     801ba8 <open+0x79>
	return fd2num(fd);
  801b8f:	83 ec 0c             	sub    $0xc,%esp
  801b92:	ff 75 f4             	pushl  -0xc(%ebp)
  801b95:	e8 f3 f7 ff ff       	call   80138d <fd2num>
  801b9a:	89 c3                	mov    %eax,%ebx
  801b9c:	83 c4 10             	add    $0x10,%esp
}
  801b9f:	89 d8                	mov    %ebx,%eax
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
		fd_close(fd, 0);
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb0:	e8 10 f9 ff ff       	call   8014c5 <fd_close>
		return r;
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	eb e5                	jmp    801b9f <open+0x70>
		return -E_BAD_PATH;
  801bba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bbf:	eb de                	jmp    801b9f <open+0x70>

00801bc1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bc1:	f3 0f 1e fb          	endbr32 
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	b8 08 00 00 00       	mov    $0x8,%eax
  801bd5:	e8 87 fd ff ff       	call   801961 <fsipc>
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bdc:	f3 0f 1e fb          	endbr32 
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801be6:	68 af 31 80 00       	push   $0x8031af
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	e8 24 f1 ff ff       	call   800d17 <strcpy>
	return 0;
}
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <devsock_close>:
{
  801bfa:	f3 0f 1e fb          	endbr32 
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 10             	sub    $0x10,%esp
  801c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c08:	53                   	push   %ebx
  801c09:	e8 2f 0d 00 00       	call   80293d <pageref>
  801c0e:	89 c2                	mov    %eax,%edx
  801c10:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c18:	83 fa 01             	cmp    $0x1,%edx
  801c1b:	74 05                	je     801c22 <devsock_close+0x28>
}
  801c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c22:	83 ec 0c             	sub    $0xc,%esp
  801c25:	ff 73 0c             	pushl  0xc(%ebx)
  801c28:	e8 e3 02 00 00       	call   801f10 <nsipc_close>
  801c2d:	83 c4 10             	add    $0x10,%esp
  801c30:	eb eb                	jmp    801c1d <devsock_close+0x23>

00801c32 <devsock_write>:
{
  801c32:	f3 0f 1e fb          	endbr32 
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	ff 75 10             	pushl  0x10(%ebp)
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	ff 70 0c             	pushl  0xc(%eax)
  801c4a:	e8 b5 03 00 00       	call   802004 <nsipc_send>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <devsock_read>:
{
  801c51:	f3 0f 1e fb          	endbr32 
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	ff 75 10             	pushl  0x10(%ebp)
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	ff 70 0c             	pushl  0xc(%eax)
  801c69:	e8 1f 03 00 00       	call   801f8d <nsipc_recv>
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <fd2sockid>:
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c76:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	e8 92 f7 ff ff       	call   801412 <fd_lookup>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	85 c0                	test   %eax,%eax
  801c85:	78 10                	js     801c97 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8a:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  801c90:	39 08                	cmp    %ecx,(%eax)
  801c92:	75 05                	jne    801c99 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c94:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    
		return -E_NOT_SUPP;
  801c99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c9e:	eb f7                	jmp    801c97 <fd2sockid+0x27>

00801ca0 <alloc_sockfd>:
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 1c             	sub    $0x1c,%esp
  801ca8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cad:	50                   	push   %eax
  801cae:	e8 09 f7 ff ff       	call   8013bc <fd_alloc>
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 43                	js     801cff <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	68 07 04 00 00       	push   $0x407
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 8b f4 ff ff       	call   801159 <sys_page_alloc>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 28                	js     801cff <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cda:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801ce0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801cef:	83 ec 0c             	sub    $0xc,%esp
  801cf2:	50                   	push   %eax
  801cf3:	e8 95 f6 ff ff       	call   80138d <fd2num>
  801cf8:	89 c3                	mov    %eax,%ebx
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	eb 0c                	jmp    801d0b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	56                   	push   %esi
  801d03:	e8 08 02 00 00       	call   801f10 <nsipc_close>
		return r;
  801d08:	83 c4 10             	add    $0x10,%esp
}
  801d0b:	89 d8                	mov    %ebx,%eax
  801d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    

00801d14 <accept>:
{
  801d14:	f3 0f 1e fb          	endbr32 
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	e8 4a ff ff ff       	call   801c70 <fd2sockid>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 1b                	js     801d45 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	50                   	push   %eax
  801d34:	e8 22 01 00 00       	call   801e5b <nsipc_accept>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 05                	js     801d45 <accept+0x31>
	return alloc_sockfd(r);
  801d40:	e8 5b ff ff ff       	call   801ca0 <alloc_sockfd>
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <bind>:
{
  801d47:	f3 0f 1e fb          	endbr32 
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	e8 17 ff ff ff       	call   801c70 <fd2sockid>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 12                	js     801d6f <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	ff 75 10             	pushl  0x10(%ebp)
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	50                   	push   %eax
  801d67:	e8 45 01 00 00       	call   801eb1 <nsipc_bind>
  801d6c:	83 c4 10             	add    $0x10,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <shutdown>:
{
  801d71:	f3 0f 1e fb          	endbr32 
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	e8 ed fe ff ff       	call   801c70 <fd2sockid>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	78 0f                	js     801d96 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d87:	83 ec 08             	sub    $0x8,%esp
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	50                   	push   %eax
  801d8e:	e8 57 01 00 00       	call   801eea <nsipc_shutdown>
  801d93:	83 c4 10             	add    $0x10,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <connect>:
{
  801d98:	f3 0f 1e fb          	endbr32 
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	e8 c6 fe ff ff       	call   801c70 <fd2sockid>
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 12                	js     801dc0 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	ff 75 10             	pushl  0x10(%ebp)
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	50                   	push   %eax
  801db8:	e8 71 01 00 00       	call   801f2e <nsipc_connect>
  801dbd:	83 c4 10             	add    $0x10,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <listen>:
{
  801dc2:	f3 0f 1e fb          	endbr32 
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	e8 9c fe ff ff       	call   801c70 <fd2sockid>
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 0f                	js     801de7 <listen+0x25>
	return nsipc_listen(r, backlog);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	50                   	push   %eax
  801ddf:	e8 83 01 00 00       	call   801f67 <nsipc_listen>
  801de4:	83 c4 10             	add    $0x10,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801de9:	f3 0f 1e fb          	endbr32 
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	e8 65 02 00 00       	call   802066 <nsipc_socket>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 05                	js     801e0d <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e08:	e8 93 fe ff ff       	call   801ca0 <alloc_sockfd>
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	53                   	push   %ebx
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e18:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801e1f:	74 26                	je     801e47 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e21:	6a 07                	push   $0x7
  801e23:	68 00 70 80 00       	push   $0x807000
  801e28:	53                   	push   %ebx
  801e29:	ff 35 14 50 80 00    	pushl  0x805014
  801e2f:	e8 74 0a 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e34:	83 c4 0c             	add    $0xc,%esp
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	e8 f2 09 00 00       	call   802834 <ipc_recv>
}
  801e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	6a 02                	push   $0x2
  801e4c:	e8 af 0a 00 00       	call   802900 <ipc_find_env>
  801e51:	a3 14 50 80 00       	mov    %eax,0x805014
  801e56:	83 c4 10             	add    $0x10,%esp
  801e59:	eb c6                	jmp    801e21 <nsipc+0x12>

00801e5b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e5b:	f3 0f 1e fb          	endbr32 
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e6f:	8b 06                	mov    (%esi),%eax
  801e71:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	e8 8f ff ff ff       	call   801e0f <nsipc>
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	85 c0                	test   %eax,%eax
  801e84:	79 09                	jns    801e8f <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e86:	89 d8                	mov    %ebx,%eax
  801e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5e                   	pop    %esi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	ff 35 10 70 80 00    	pushl  0x807010
  801e98:	68 00 70 80 00       	push   $0x807000
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	e8 28 f0 ff ff       	call   800ecd <memmove>
		*addrlen = ret->ret_addrlen;
  801ea5:	a1 10 70 80 00       	mov    0x807010,%eax
  801eaa:	89 06                	mov    %eax,(%esi)
  801eac:	83 c4 10             	add    $0x10,%esp
	return r;
  801eaf:	eb d5                	jmp    801e86 <nsipc_accept+0x2b>

00801eb1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801eb1:	f3 0f 1e fb          	endbr32 
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ec7:	53                   	push   %ebx
  801ec8:	ff 75 0c             	pushl  0xc(%ebp)
  801ecb:	68 04 70 80 00       	push   $0x807004
  801ed0:	e8 f8 ef ff ff       	call   800ecd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ed5:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801edb:	b8 02 00 00 00       	mov    $0x2,%eax
  801ee0:	e8 2a ff ff ff       	call   801e0f <nsipc>
}
  801ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801eea:	f3 0f 1e fb          	endbr32 
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f04:	b8 03 00 00 00       	mov    $0x3,%eax
  801f09:	e8 01 ff ff ff       	call   801e0f <nsipc>
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <nsipc_close>:

int
nsipc_close(int s)
{
  801f10:	f3 0f 1e fb          	endbr32 
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f22:	b8 04 00 00 00       	mov    $0x4,%eax
  801f27:	e8 e3 fe ff ff       	call   801e0f <nsipc>
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f2e:	f3 0f 1e fb          	endbr32 
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	53                   	push   %ebx
  801f36:	83 ec 08             	sub    $0x8,%esp
  801f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f44:	53                   	push   %ebx
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	68 04 70 80 00       	push   $0x807004
  801f4d:	e8 7b ef ff ff       	call   800ecd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f52:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f58:	b8 05 00 00 00       	mov    $0x5,%eax
  801f5d:	e8 ad fe ff ff       	call   801e0f <nsipc>
}
  801f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f67:	f3 0f 1e fb          	endbr32 
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7c:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f81:	b8 06 00 00 00       	mov    $0x6,%eax
  801f86:	e8 84 fe ff ff       	call   801e0f <nsipc>
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f8d:	f3 0f 1e fb          	endbr32 
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	56                   	push   %esi
  801f95:	53                   	push   %ebx
  801f96:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801fa1:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801fa7:	8b 45 14             	mov    0x14(%ebp),%eax
  801faa:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801faf:	b8 07 00 00 00       	mov    $0x7,%eax
  801fb4:	e8 56 fe ff ff       	call   801e0f <nsipc>
  801fb9:	89 c3                	mov    %eax,%ebx
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 26                	js     801fe5 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801fbf:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801fc5:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801fca:	0f 4e c6             	cmovle %esi,%eax
  801fcd:	39 c3                	cmp    %eax,%ebx
  801fcf:	7f 1d                	jg     801fee <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	53                   	push   %ebx
  801fd5:	68 00 70 80 00       	push   $0x807000
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	e8 eb ee ff ff       	call   800ecd <memmove>
  801fe2:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801fe5:	89 d8                	mov    %ebx,%eax
  801fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fea:	5b                   	pop    %ebx
  801feb:	5e                   	pop    %esi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801fee:	68 bb 31 80 00       	push   $0x8031bb
  801ff3:	68 83 31 80 00       	push   $0x803183
  801ff8:	6a 62                	push   $0x62
  801ffa:	68 d0 31 80 00       	push   $0x8031d0
  801fff:	e8 22 e6 ff ff       	call   800626 <_panic>

00802004 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802004:	f3 0f 1e fb          	endbr32 
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	53                   	push   %ebx
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80201a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802020:	7f 2e                	jg     802050 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	53                   	push   %ebx
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	68 0c 70 80 00       	push   $0x80700c
  80202e:	e8 9a ee ff ff       	call   800ecd <memmove>
	nsipcbuf.send.req_size = size;
  802033:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802039:	8b 45 14             	mov    0x14(%ebp),%eax
  80203c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802041:	b8 08 00 00 00       	mov    $0x8,%eax
  802046:	e8 c4 fd ff ff       	call   801e0f <nsipc>
}
  80204b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    
	assert(size < 1600);
  802050:	68 dc 31 80 00       	push   $0x8031dc
  802055:	68 83 31 80 00       	push   $0x803183
  80205a:	6a 6d                	push   $0x6d
  80205c:	68 d0 31 80 00       	push   $0x8031d0
  802061:	e8 c0 e5 ff ff       	call   800626 <_panic>

00802066 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802066:	f3 0f 1e fb          	endbr32 
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207b:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802080:	8b 45 10             	mov    0x10(%ebp),%eax
  802083:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802088:	b8 09 00 00 00       	mov    $0x9,%eax
  80208d:	e8 7d fd ff ff       	call   801e0f <nsipc>
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <free>:
	return v;
}

void
free(void *v)
{
  802094:	f3 0f 1e fb          	endbr32 
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	53                   	push   %ebx
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8020a2:	85 db                	test   %ebx,%ebx
  8020a4:	0f 84 85 00 00 00    	je     80212f <free+0x9b>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8020aa:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8020b0:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8020b5:	77 51                	ja     802108 <free+0x74>

	c = ROUNDDOWN(v, PGSIZE);
  8020b7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8020bd:	89 d8                	mov    %ebx,%eax
  8020bf:	c1 e8 0c             	shr    $0xc,%eax
  8020c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8020c9:	f6 c4 02             	test   $0x2,%ah
  8020cc:	74 50                	je     80211e <free+0x8a>
		sys_page_unmap(0, c);
  8020ce:	83 ec 08             	sub    $0x8,%esp
  8020d1:	53                   	push   %ebx
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 0d f1 ff ff       	call   8011e6 <sys_page_unmap>
		c += PGSIZE;
  8020d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8020df:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8020ed:	76 ce                	jbe    8020bd <free+0x29>
  8020ef:	68 23 32 80 00       	push   $0x803223
  8020f4:	68 83 31 80 00       	push   $0x803183
  8020f9:	68 81 00 00 00       	push   $0x81
  8020fe:	68 16 32 80 00       	push   $0x803216
  802103:	e8 1e e5 ff ff       	call   800626 <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802108:	68 e8 31 80 00       	push   $0x8031e8
  80210d:	68 83 31 80 00       	push   $0x803183
  802112:	6a 7a                	push   $0x7a
  802114:	68 16 32 80 00       	push   $0x803216
  802119:	e8 08 e5 ff ff       	call   800626 <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  80211e:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  802124:	83 e8 01             	sub    $0x1,%eax
  802127:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  80212d:	74 05                	je     802134 <free+0xa0>
		sys_page_unmap(0, c);
}
  80212f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802132:	c9                   	leave  
  802133:	c3                   	ret    
		sys_page_unmap(0, c);
  802134:	83 ec 08             	sub    $0x8,%esp
  802137:	53                   	push   %ebx
  802138:	6a 00                	push   $0x0
  80213a:	e8 a7 f0 ff ff       	call   8011e6 <sys_page_unmap>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	eb eb                	jmp    80212f <free+0x9b>

00802144 <malloc>:
{
  802144:	f3 0f 1e fb          	endbr32 
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	57                   	push   %edi
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802151:	a1 18 50 80 00       	mov    0x805018,%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	74 74                	je     8021ce <malloc+0x8a>
	n = ROUNDUP(n, 4);
  80215a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215d:	8d 51 03             	lea    0x3(%ecx),%edx
  802160:	83 e2 fc             	and    $0xfffffffc,%edx
  802163:	89 d6                	mov    %edx,%esi
  802165:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802168:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80216e:	0f 87 12 01 00 00    	ja     802286 <malloc+0x142>
	if ((uintptr_t) mptr % PGSIZE){
  802174:	89 c1                	mov    %eax,%ecx
  802176:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80217b:	74 30                	je     8021ad <malloc+0x69>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  80217d:	89 c3                	mov    %eax,%ebx
  80217f:	c1 eb 0c             	shr    $0xc,%ebx
  802182:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  802186:	c1 ea 0c             	shr    $0xc,%edx
  802189:	39 d3                	cmp    %edx,%ebx
  80218b:	74 64                	je     8021f1 <malloc+0xad>
		free(mptr);	/* drop reference to this page */
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	50                   	push   %eax
  802191:	e8 fe fe ff ff       	call   802094 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802196:	a1 18 50 80 00       	mov    0x805018,%eax
  80219b:	05 00 10 00 00       	add    $0x1000,%eax
  8021a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8021a5:	a3 18 50 80 00       	mov    %eax,0x805018
  8021aa:	83 c4 10             	add    $0x10,%esp
  8021ad:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  8021b3:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  8021ba:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  8021bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021c2:	8d 78 04             	lea    0x4(%eax),%edi
  8021c5:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  8021c9:	e9 86 00 00 00       	jmp    802254 <malloc+0x110>
		mptr = mbegin;
  8021ce:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8021d5:	00 00 08 
	n = ROUNDUP(n, 4);
  8021d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021db:	8d 51 03             	lea    0x3(%ecx),%edx
  8021de:	83 e2 fc             	and    $0xfffffffc,%edx
  8021e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8021e4:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8021ea:	76 c1                	jbe    8021ad <malloc+0x69>
  8021ec:	e9 fb 00 00 00       	jmp    8022ec <malloc+0x1a8>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8021f1:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  8021f7:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  8021fd:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  802201:	89 f2                	mov    %esi,%edx
  802203:	01 c2                	add    %eax,%edx
  802205:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  80220b:	e9 dc 00 00 00       	jmp    8022ec <malloc+0x1a8>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802210:	05 00 10 00 00       	add    $0x1000,%eax
  802215:	39 c1                	cmp    %eax,%ecx
  802217:	76 74                	jbe    80228d <malloc+0x149>
		if (va >= (uintptr_t) mend
  802219:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  80221e:	77 22                	ja     802242 <malloc+0xfe>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  802220:	89 c3                	mov    %eax,%ebx
  802222:	c1 eb 16             	shr    $0x16,%ebx
  802225:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  80222c:	f6 c3 01             	test   $0x1,%bl
  80222f:	74 df                	je     802210 <malloc+0xcc>
  802231:	89 c3                	mov    %eax,%ebx
  802233:	c1 eb 0c             	shr    $0xc,%ebx
  802236:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80223d:	f6 c3 01             	test   $0x1,%bl
  802240:	74 ce                	je     802210 <malloc+0xcc>
  802242:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802248:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80224c:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802252:	74 0a                	je     80225e <malloc+0x11a>
  802254:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802257:	89 d0                	mov    %edx,%eax
  802259:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  80225c:	eb b7                	jmp    802215 <malloc+0xd1>
			mptr = mbegin;
  80225e:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802263:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  802268:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80226c:	75 e6                	jne    802254 <malloc+0x110>
  80226e:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802275:	00 00 08 
				return 0;	/* out of address space */
  802278:	b8 00 00 00 00       	mov    $0x0,%eax
  80227d:	eb 6d                	jmp    8022ec <malloc+0x1a8>
			return 0;	/* out of physical memory */
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	eb 66                	jmp    8022ec <malloc+0x1a8>
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	eb 5f                	jmp    8022ec <malloc+0x1a8>
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	84 c0                	test   %al,%al
  802291:	74 08                	je     80229b <malloc+0x157>
  802293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802296:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  80229b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022a0:	89 de                	mov    %ebx,%esi
  8022a2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8022a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022ab:	39 df                	cmp    %ebx,%edi
  8022ad:	76 45                	jbe    8022f4 <malloc+0x1b0>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 07 02 00 00       	push   $0x207
  8022b7:	03 35 18 50 80 00    	add    0x805018,%esi
  8022bd:	56                   	push   %esi
  8022be:	6a 00                	push   $0x0
  8022c0:	e8 94 ee ff ff       	call   801159 <sys_page_alloc>
  8022c5:	83 c4 10             	add    $0x10,%esp
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	79 d4                	jns    8022a0 <malloc+0x15c>
  8022cc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8022cf:	eb 42                	jmp    802313 <malloc+0x1cf>
	ref = (uint32_t*) (mptr + i - 4);
  8022d1:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8022d6:	c7 84 30 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%esi,1)
  8022dd:	02 00 00 00 
	mptr += n;
  8022e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022e4:	01 c2                	add    %eax,%edx
  8022e6:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8022ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8022f4:	83 ec 04             	sub    $0x4,%esp
  8022f7:	6a 07                	push   $0x7
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	03 05 18 50 80 00    	add    0x805018,%eax
  802301:	50                   	push   %eax
  802302:	6a 00                	push   $0x0
  802304:	e8 50 ee ff ff       	call   801159 <sys_page_alloc>
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80230f:	85 c0                	test   %eax,%eax
  802311:	79 be                	jns    8022d1 <malloc+0x18d>
			for (; i >= 0; i -= PGSIZE)
  802313:	85 db                	test   %ebx,%ebx
  802315:	0f 88 64 ff ff ff    	js     80227f <malloc+0x13b>
				sys_page_unmap(0, mptr + i);
  80231b:	83 ec 08             	sub    $0x8,%esp
  80231e:	89 d8                	mov    %ebx,%eax
  802320:	03 05 18 50 80 00    	add    0x805018,%eax
  802326:	50                   	push   %eax
  802327:	6a 00                	push   $0x0
  802329:	e8 b8 ee ff ff       	call   8011e6 <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  80232e:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	eb da                	jmp    802313 <malloc+0x1cf>

00802339 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802339:	f3 0f 1e fb          	endbr32 
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	56                   	push   %esi
  802341:	53                   	push   %ebx
  802342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802345:	83 ec 0c             	sub    $0xc,%esp
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	e8 51 f0 ff ff       	call   8013a1 <fd2data>
  802350:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802352:	83 c4 08             	add    $0x8,%esp
  802355:	68 3b 32 80 00       	push   $0x80323b
  80235a:	53                   	push   %ebx
  80235b:	e8 b7 e9 ff ff       	call   800d17 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802360:	8b 46 04             	mov    0x4(%esi),%eax
  802363:	2b 06                	sub    (%esi),%eax
  802365:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80236b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802372:	00 00 00 
	stat->st_dev = &devpipe;
  802375:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  80237c:	40 80 00 
	return 0;
}
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802387:	5b                   	pop    %ebx
  802388:	5e                   	pop    %esi
  802389:	5d                   	pop    %ebp
  80238a:	c3                   	ret    

0080238b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80238b:	f3 0f 1e fb          	endbr32 
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	53                   	push   %ebx
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802399:	53                   	push   %ebx
  80239a:	6a 00                	push   $0x0
  80239c:	e8 45 ee ff ff       	call   8011e6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023a1:	89 1c 24             	mov    %ebx,(%esp)
  8023a4:	e8 f8 ef ff ff       	call   8013a1 <fd2data>
  8023a9:	83 c4 08             	add    $0x8,%esp
  8023ac:	50                   	push   %eax
  8023ad:	6a 00                	push   $0x0
  8023af:	e8 32 ee ff ff       	call   8011e6 <sys_page_unmap>
}
  8023b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <_pipeisclosed>:
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	57                   	push   %edi
  8023bd:	56                   	push   %esi
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 1c             	sub    $0x1c,%esp
  8023c2:	89 c7                	mov    %eax,%edi
  8023c4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023c6:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8023cb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	57                   	push   %edi
  8023d2:	e8 66 05 00 00       	call   80293d <pageref>
  8023d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023da:	89 34 24             	mov    %esi,(%esp)
  8023dd:	e8 5b 05 00 00       	call   80293d <pageref>
		nn = thisenv->env_runs;
  8023e2:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8023e8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	39 cb                	cmp    %ecx,%ebx
  8023f0:	74 1b                	je     80240d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023f2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023f5:	75 cf                	jne    8023c6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023f7:	8b 42 58             	mov    0x58(%edx),%eax
  8023fa:	6a 01                	push   $0x1
  8023fc:	50                   	push   %eax
  8023fd:	53                   	push   %ebx
  8023fe:	68 42 32 80 00       	push   $0x803242
  802403:	e8 05 e3 ff ff       	call   80070d <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp
  80240b:	eb b9                	jmp    8023c6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80240d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802410:	0f 94 c0             	sete   %al
  802413:	0f b6 c0             	movzbl %al,%eax
}
  802416:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802419:	5b                   	pop    %ebx
  80241a:	5e                   	pop    %esi
  80241b:	5f                   	pop    %edi
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <devpipe_write>:
{
  80241e:	f3 0f 1e fb          	endbr32 
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	57                   	push   %edi
  802426:	56                   	push   %esi
  802427:	53                   	push   %ebx
  802428:	83 ec 28             	sub    $0x28,%esp
  80242b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80242e:	56                   	push   %esi
  80242f:	e8 6d ef ff ff       	call   8013a1 <fd2data>
  802434:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802436:	83 c4 10             	add    $0x10,%esp
  802439:	bf 00 00 00 00       	mov    $0x0,%edi
  80243e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802441:	74 4f                	je     802492 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802443:	8b 43 04             	mov    0x4(%ebx),%eax
  802446:	8b 0b                	mov    (%ebx),%ecx
  802448:	8d 51 20             	lea    0x20(%ecx),%edx
  80244b:	39 d0                	cmp    %edx,%eax
  80244d:	72 14                	jb     802463 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80244f:	89 da                	mov    %ebx,%edx
  802451:	89 f0                	mov    %esi,%eax
  802453:	e8 61 ff ff ff       	call   8023b9 <_pipeisclosed>
  802458:	85 c0                	test   %eax,%eax
  80245a:	75 3b                	jne    802497 <devpipe_write+0x79>
			sys_yield();
  80245c:	e8 d5 ec ff ff       	call   801136 <sys_yield>
  802461:	eb e0                	jmp    802443 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802463:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802466:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80246a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80246d:	89 c2                	mov    %eax,%edx
  80246f:	c1 fa 1f             	sar    $0x1f,%edx
  802472:	89 d1                	mov    %edx,%ecx
  802474:	c1 e9 1b             	shr    $0x1b,%ecx
  802477:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80247a:	83 e2 1f             	and    $0x1f,%edx
  80247d:	29 ca                	sub    %ecx,%edx
  80247f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802483:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802487:	83 c0 01             	add    $0x1,%eax
  80248a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80248d:	83 c7 01             	add    $0x1,%edi
  802490:	eb ac                	jmp    80243e <devpipe_write+0x20>
	return i;
  802492:	8b 45 10             	mov    0x10(%ebp),%eax
  802495:	eb 05                	jmp    80249c <devpipe_write+0x7e>
				return 0;
  802497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80249f:	5b                   	pop    %ebx
  8024a0:	5e                   	pop    %esi
  8024a1:	5f                   	pop    %edi
  8024a2:	5d                   	pop    %ebp
  8024a3:	c3                   	ret    

008024a4 <devpipe_read>:
{
  8024a4:	f3 0f 1e fb          	endbr32 
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	57                   	push   %edi
  8024ac:	56                   	push   %esi
  8024ad:	53                   	push   %ebx
  8024ae:	83 ec 18             	sub    $0x18,%esp
  8024b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024b4:	57                   	push   %edi
  8024b5:	e8 e7 ee ff ff       	call   8013a1 <fd2data>
  8024ba:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024bc:	83 c4 10             	add    $0x10,%esp
  8024bf:	be 00 00 00 00       	mov    $0x0,%esi
  8024c4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c7:	75 14                	jne    8024dd <devpipe_read+0x39>
	return i;
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	eb 02                	jmp    8024d0 <devpipe_read+0x2c>
				return i;
  8024ce:	89 f0                	mov    %esi,%eax
}
  8024d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d3:	5b                   	pop    %ebx
  8024d4:	5e                   	pop    %esi
  8024d5:	5f                   	pop    %edi
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    
			sys_yield();
  8024d8:	e8 59 ec ff ff       	call   801136 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024dd:	8b 03                	mov    (%ebx),%eax
  8024df:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024e2:	75 18                	jne    8024fc <devpipe_read+0x58>
			if (i > 0)
  8024e4:	85 f6                	test   %esi,%esi
  8024e6:	75 e6                	jne    8024ce <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8024e8:	89 da                	mov    %ebx,%edx
  8024ea:	89 f8                	mov    %edi,%eax
  8024ec:	e8 c8 fe ff ff       	call   8023b9 <_pipeisclosed>
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 e3                	je     8024d8 <devpipe_read+0x34>
				return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fa:	eb d4                	jmp    8024d0 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024fc:	99                   	cltd   
  8024fd:	c1 ea 1b             	shr    $0x1b,%edx
  802500:	01 d0                	add    %edx,%eax
  802502:	83 e0 1f             	and    $0x1f,%eax
  802505:	29 d0                	sub    %edx,%eax
  802507:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80250c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80250f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802512:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802515:	83 c6 01             	add    $0x1,%esi
  802518:	eb aa                	jmp    8024c4 <devpipe_read+0x20>

0080251a <pipe>:
{
  80251a:	f3 0f 1e fb          	endbr32 
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	56                   	push   %esi
  802522:	53                   	push   %ebx
  802523:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802526:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802529:	50                   	push   %eax
  80252a:	e8 8d ee ff ff       	call   8013bc <fd_alloc>
  80252f:	89 c3                	mov    %eax,%ebx
  802531:	83 c4 10             	add    $0x10,%esp
  802534:	85 c0                	test   %eax,%eax
  802536:	0f 88 23 01 00 00    	js     80265f <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80253c:	83 ec 04             	sub    $0x4,%esp
  80253f:	68 07 04 00 00       	push   $0x407
  802544:	ff 75 f4             	pushl  -0xc(%ebp)
  802547:	6a 00                	push   $0x0
  802549:	e8 0b ec ff ff       	call   801159 <sys_page_alloc>
  80254e:	89 c3                	mov    %eax,%ebx
  802550:	83 c4 10             	add    $0x10,%esp
  802553:	85 c0                	test   %eax,%eax
  802555:	0f 88 04 01 00 00    	js     80265f <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802561:	50                   	push   %eax
  802562:	e8 55 ee ff ff       	call   8013bc <fd_alloc>
  802567:	89 c3                	mov    %eax,%ebx
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	85 c0                	test   %eax,%eax
  80256e:	0f 88 db 00 00 00    	js     80264f <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 07 04 00 00       	push   $0x407
  80257c:	ff 75 f0             	pushl  -0x10(%ebp)
  80257f:	6a 00                	push   $0x0
  802581:	e8 d3 eb ff ff       	call   801159 <sys_page_alloc>
  802586:	89 c3                	mov    %eax,%ebx
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	85 c0                	test   %eax,%eax
  80258d:	0f 88 bc 00 00 00    	js     80264f <pipe+0x135>
	va = fd2data(fd0);
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	ff 75 f4             	pushl  -0xc(%ebp)
  802599:	e8 03 ee ff ff       	call   8013a1 <fd2data>
  80259e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a0:	83 c4 0c             	add    $0xc,%esp
  8025a3:	68 07 04 00 00       	push   $0x407
  8025a8:	50                   	push   %eax
  8025a9:	6a 00                	push   $0x0
  8025ab:	e8 a9 eb ff ff       	call   801159 <sys_page_alloc>
  8025b0:	89 c3                	mov    %eax,%ebx
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	0f 88 82 00 00 00    	js     80263f <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c3:	e8 d9 ed ff ff       	call   8013a1 <fd2data>
  8025c8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025cf:	50                   	push   %eax
  8025d0:	6a 00                	push   $0x0
  8025d2:	56                   	push   %esi
  8025d3:	6a 00                	push   $0x0
  8025d5:	e8 c6 eb ff ff       	call   8011a0 <sys_page_map>
  8025da:	89 c3                	mov    %eax,%ebx
  8025dc:	83 c4 20             	add    $0x20,%esp
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 4e                	js     802631 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8025e3:	a1 5c 40 80 00       	mov    0x80405c,%eax
  8025e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025eb:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fa:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	ff 75 f4             	pushl  -0xc(%ebp)
  80260c:	e8 7c ed ff ff       	call   80138d <fd2num>
  802611:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802614:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802616:	83 c4 04             	add    $0x4,%esp
  802619:	ff 75 f0             	pushl  -0x10(%ebp)
  80261c:	e8 6c ed ff ff       	call   80138d <fd2num>
  802621:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802624:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80262f:	eb 2e                	jmp    80265f <pipe+0x145>
	sys_page_unmap(0, va);
  802631:	83 ec 08             	sub    $0x8,%esp
  802634:	56                   	push   %esi
  802635:	6a 00                	push   $0x0
  802637:	e8 aa eb ff ff       	call   8011e6 <sys_page_unmap>
  80263c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80263f:	83 ec 08             	sub    $0x8,%esp
  802642:	ff 75 f0             	pushl  -0x10(%ebp)
  802645:	6a 00                	push   $0x0
  802647:	e8 9a eb ff ff       	call   8011e6 <sys_page_unmap>
  80264c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80264f:	83 ec 08             	sub    $0x8,%esp
  802652:	ff 75 f4             	pushl  -0xc(%ebp)
  802655:	6a 00                	push   $0x0
  802657:	e8 8a eb ff ff       	call   8011e6 <sys_page_unmap>
  80265c:	83 c4 10             	add    $0x10,%esp
}
  80265f:	89 d8                	mov    %ebx,%eax
  802661:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802664:	5b                   	pop    %ebx
  802665:	5e                   	pop    %esi
  802666:	5d                   	pop    %ebp
  802667:	c3                   	ret    

00802668 <pipeisclosed>:
{
  802668:	f3 0f 1e fb          	endbr32 
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802672:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802675:	50                   	push   %eax
  802676:	ff 75 08             	pushl  0x8(%ebp)
  802679:	e8 94 ed ff ff       	call   801412 <fd_lookup>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	85 c0                	test   %eax,%eax
  802683:	78 18                	js     80269d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802685:	83 ec 0c             	sub    $0xc,%esp
  802688:	ff 75 f4             	pushl  -0xc(%ebp)
  80268b:	e8 11 ed ff ff       	call   8013a1 <fd2data>
  802690:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	e8 1f fd ff ff       	call   8023b9 <_pipeisclosed>
  80269a:	83 c4 10             	add    $0x10,%esp
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80269f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	c3                   	ret    

008026a9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a9:	f3 0f 1e fb          	endbr32 
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026b3:	68 5a 32 80 00       	push   $0x80325a
  8026b8:	ff 75 0c             	pushl  0xc(%ebp)
  8026bb:	e8 57 e6 ff ff       	call   800d17 <strcpy>
	return 0;
}
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <devcons_write>:
{
  8026c7:	f3 0f 1e fb          	endbr32 
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	57                   	push   %edi
  8026cf:	56                   	push   %esi
  8026d0:	53                   	push   %ebx
  8026d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026e5:	73 31                	jae    802718 <devcons_write+0x51>
		m = n - tot;
  8026e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026ea:	29 f3                	sub    %esi,%ebx
  8026ec:	83 fb 7f             	cmp    $0x7f,%ebx
  8026ef:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026f4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	53                   	push   %ebx
  8026fb:	89 f0                	mov    %esi,%eax
  8026fd:	03 45 0c             	add    0xc(%ebp),%eax
  802700:	50                   	push   %eax
  802701:	57                   	push   %edi
  802702:	e8 c6 e7 ff ff       	call   800ecd <memmove>
		sys_cputs(buf, m);
  802707:	83 c4 08             	add    $0x8,%esp
  80270a:	53                   	push   %ebx
  80270b:	57                   	push   %edi
  80270c:	e8 78 e9 ff ff       	call   801089 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802711:	01 de                	add    %ebx,%esi
  802713:	83 c4 10             	add    $0x10,%esp
  802716:	eb ca                	jmp    8026e2 <devcons_write+0x1b>
}
  802718:	89 f0                	mov    %esi,%eax
  80271a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80271d:	5b                   	pop    %ebx
  80271e:	5e                   	pop    %esi
  80271f:	5f                   	pop    %edi
  802720:	5d                   	pop    %ebp
  802721:	c3                   	ret    

00802722 <devcons_read>:
{
  802722:	f3 0f 1e fb          	endbr32 
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 08             	sub    $0x8,%esp
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802735:	74 21                	je     802758 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802737:	e8 6f e9 ff ff       	call   8010ab <sys_cgetc>
  80273c:	85 c0                	test   %eax,%eax
  80273e:	75 07                	jne    802747 <devcons_read+0x25>
		sys_yield();
  802740:	e8 f1 e9 ff ff       	call   801136 <sys_yield>
  802745:	eb f0                	jmp    802737 <devcons_read+0x15>
	if (c < 0)
  802747:	78 0f                	js     802758 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802749:	83 f8 04             	cmp    $0x4,%eax
  80274c:	74 0c                	je     80275a <devcons_read+0x38>
	*(char*)vbuf = c;
  80274e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802751:	88 02                	mov    %al,(%edx)
	return 1;
  802753:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    
		return 0;
  80275a:	b8 00 00 00 00       	mov    $0x0,%eax
  80275f:	eb f7                	jmp    802758 <devcons_read+0x36>

00802761 <cputchar>:
{
  802761:	f3 0f 1e fb          	endbr32 
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802771:	6a 01                	push   $0x1
  802773:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802776:	50                   	push   %eax
  802777:	e8 0d e9 ff ff       	call   801089 <sys_cputs>
}
  80277c:	83 c4 10             	add    $0x10,%esp
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <getchar>:
{
  802781:	f3 0f 1e fb          	endbr32 
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80278b:	6a 01                	push   $0x1
  80278d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802790:	50                   	push   %eax
  802791:	6a 00                	push   $0x0
  802793:	e8 02 ef ff ff       	call   80169a <read>
	if (r < 0)
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	85 c0                	test   %eax,%eax
  80279d:	78 06                	js     8027a5 <getchar+0x24>
	if (r < 1)
  80279f:	74 06                	je     8027a7 <getchar+0x26>
	return c;
  8027a1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    
		return -E_EOF;
  8027a7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027ac:	eb f7                	jmp    8027a5 <getchar+0x24>

008027ae <iscons>:
{
  8027ae:	f3 0f 1e fb          	endbr32 
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
  8027b5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027bb:	50                   	push   %eax
  8027bc:	ff 75 08             	pushl  0x8(%ebp)
  8027bf:	e8 4e ec ff ff       	call   801412 <fd_lookup>
  8027c4:	83 c4 10             	add    $0x10,%esp
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	78 11                	js     8027dc <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 15 78 40 80 00    	mov    0x804078,%edx
  8027d4:	39 10                	cmp    %edx,(%eax)
  8027d6:	0f 94 c0             	sete   %al
  8027d9:	0f b6 c0             	movzbl %al,%eax
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <opencons>:
{
  8027de:	f3 0f 1e fb          	endbr32 
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027eb:	50                   	push   %eax
  8027ec:	e8 cb eb ff ff       	call   8013bc <fd_alloc>
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	78 3a                	js     802832 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 07 04 00 00       	push   $0x407
  802800:	ff 75 f4             	pushl  -0xc(%ebp)
  802803:	6a 00                	push   $0x0
  802805:	e8 4f e9 ff ff       	call   801159 <sys_page_alloc>
  80280a:	83 c4 10             	add    $0x10,%esp
  80280d:	85 c0                	test   %eax,%eax
  80280f:	78 21                	js     802832 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 15 78 40 80 00    	mov    0x804078,%edx
  80281a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802826:	83 ec 0c             	sub    $0xc,%esp
  802829:	50                   	push   %eax
  80282a:	e8 5e eb ff ff       	call   80138d <fd2num>
  80282f:	83 c4 10             	add    $0x10,%esp
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802834:	f3 0f 1e fb          	endbr32 
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	56                   	push   %esi
  80283c:	53                   	push   %ebx
  80283d:	8b 75 08             	mov    0x8(%ebp),%esi
  802840:	8b 45 0c             	mov    0xc(%ebp),%eax
  802843:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802846:	83 e8 01             	sub    $0x1,%eax
  802849:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80284e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802853:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	50                   	push   %eax
  80285b:	e8 c5 ea ff ff       	call   801325 <sys_ipc_recv>
	if (!t) {
  802860:	83 c4 10             	add    $0x10,%esp
  802863:	85 c0                	test   %eax,%eax
  802865:	75 2b                	jne    802892 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802867:	85 f6                	test   %esi,%esi
  802869:	74 0a                	je     802875 <ipc_recv+0x41>
  80286b:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802870:	8b 40 74             	mov    0x74(%eax),%eax
  802873:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802875:	85 db                	test   %ebx,%ebx
  802877:	74 0a                	je     802883 <ipc_recv+0x4f>
  802879:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80287e:	8b 40 78             	mov    0x78(%eax),%eax
  802881:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802883:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802888:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80288b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80288e:	5b                   	pop    %ebx
  80288f:	5e                   	pop    %esi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802892:	85 f6                	test   %esi,%esi
  802894:	74 06                	je     80289c <ipc_recv+0x68>
  802896:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80289c:	85 db                	test   %ebx,%ebx
  80289e:	74 eb                	je     80288b <ipc_recv+0x57>
  8028a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028a6:	eb e3                	jmp    80288b <ipc_recv+0x57>

008028a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a8:	f3 0f 1e fb          	endbr32 
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	57                   	push   %edi
  8028b0:	56                   	push   %esi
  8028b1:	53                   	push   %ebx
  8028b2:	83 ec 0c             	sub    $0xc,%esp
  8028b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8028be:	85 db                	test   %ebx,%ebx
  8028c0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028c5:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8028c8:	ff 75 14             	pushl  0x14(%ebp)
  8028cb:	53                   	push   %ebx
  8028cc:	56                   	push   %esi
  8028cd:	57                   	push   %edi
  8028ce:	e8 2b ea ff ff       	call   8012fe <sys_ipc_try_send>
  8028d3:	83 c4 10             	add    $0x10,%esp
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 1e                	je     8028f8 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8028da:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028dd:	75 07                	jne    8028e6 <ipc_send+0x3e>
		sys_yield();
  8028df:	e8 52 e8 ff ff       	call   801136 <sys_yield>
  8028e4:	eb e2                	jmp    8028c8 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8028e6:	50                   	push   %eax
  8028e7:	68 66 32 80 00       	push   $0x803266
  8028ec:	6a 39                	push   $0x39
  8028ee:	68 78 32 80 00       	push   $0x803278
  8028f3:	e8 2e dd ff ff       	call   800626 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8028f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028fb:	5b                   	pop    %ebx
  8028fc:	5e                   	pop    %esi
  8028fd:	5f                   	pop    %edi
  8028fe:	5d                   	pop    %ebp
  8028ff:	c3                   	ret    

00802900 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802900:	f3 0f 1e fb          	endbr32 
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80290f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802912:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802918:	8b 52 50             	mov    0x50(%edx),%edx
  80291b:	39 ca                	cmp    %ecx,%edx
  80291d:	74 11                	je     802930 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80291f:	83 c0 01             	add    $0x1,%eax
  802922:	3d 00 04 00 00       	cmp    $0x400,%eax
  802927:	75 e6                	jne    80290f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	eb 0b                	jmp    80293b <ipc_find_env+0x3b>
			return envs[i].env_id;
  802930:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802933:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802938:	8b 40 48             	mov    0x48(%eax),%eax
}
  80293b:	5d                   	pop    %ebp
  80293c:	c3                   	ret    

0080293d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80293d:	f3 0f 1e fb          	endbr32 
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802947:	89 c2                	mov    %eax,%edx
  802949:	c1 ea 16             	shr    $0x16,%edx
  80294c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802953:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802958:	f6 c1 01             	test   $0x1,%cl
  80295b:	74 1c                	je     802979 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80295d:	c1 e8 0c             	shr    $0xc,%eax
  802960:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802967:	a8 01                	test   $0x1,%al
  802969:	74 0e                	je     802979 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80296b:	c1 e8 0c             	shr    $0xc,%eax
  80296e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802975:	ef 
  802976:	0f b7 d2             	movzwl %dx,%edx
}
  802979:	89 d0                	mov    %edx,%eax
  80297b:	5d                   	pop    %ebp
  80297c:	c3                   	ret    
  80297d:	66 90                	xchg   %ax,%ax
  80297f:	90                   	nop

00802980 <__udivdi3>:
  802980:	f3 0f 1e fb          	endbr32 
  802984:	55                   	push   %ebp
  802985:	57                   	push   %edi
  802986:	56                   	push   %esi
  802987:	53                   	push   %ebx
  802988:	83 ec 1c             	sub    $0x1c,%esp
  80298b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80298f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802993:	8b 74 24 34          	mov    0x34(%esp),%esi
  802997:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80299b:	85 d2                	test   %edx,%edx
  80299d:	75 19                	jne    8029b8 <__udivdi3+0x38>
  80299f:	39 f3                	cmp    %esi,%ebx
  8029a1:	76 4d                	jbe    8029f0 <__udivdi3+0x70>
  8029a3:	31 ff                	xor    %edi,%edi
  8029a5:	89 e8                	mov    %ebp,%eax
  8029a7:	89 f2                	mov    %esi,%edx
  8029a9:	f7 f3                	div    %ebx
  8029ab:	89 fa                	mov    %edi,%edx
  8029ad:	83 c4 1c             	add    $0x1c,%esp
  8029b0:	5b                   	pop    %ebx
  8029b1:	5e                   	pop    %esi
  8029b2:	5f                   	pop    %edi
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	76 14                	jbe    8029d0 <__udivdi3+0x50>
  8029bc:	31 ff                	xor    %edi,%edi
  8029be:	31 c0                	xor    %eax,%eax
  8029c0:	89 fa                	mov    %edi,%edx
  8029c2:	83 c4 1c             	add    $0x1c,%esp
  8029c5:	5b                   	pop    %ebx
  8029c6:	5e                   	pop    %esi
  8029c7:	5f                   	pop    %edi
  8029c8:	5d                   	pop    %ebp
  8029c9:	c3                   	ret    
  8029ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029d0:	0f bd fa             	bsr    %edx,%edi
  8029d3:	83 f7 1f             	xor    $0x1f,%edi
  8029d6:	75 48                	jne    802a20 <__udivdi3+0xa0>
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	72 06                	jb     8029e2 <__udivdi3+0x62>
  8029dc:	31 c0                	xor    %eax,%eax
  8029de:	39 eb                	cmp    %ebp,%ebx
  8029e0:	77 de                	ja     8029c0 <__udivdi3+0x40>
  8029e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e7:	eb d7                	jmp    8029c0 <__udivdi3+0x40>
  8029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	89 d9                	mov    %ebx,%ecx
  8029f2:	85 db                	test   %ebx,%ebx
  8029f4:	75 0b                	jne    802a01 <__udivdi3+0x81>
  8029f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	f7 f3                	div    %ebx
  8029ff:	89 c1                	mov    %eax,%ecx
  802a01:	31 d2                	xor    %edx,%edx
  802a03:	89 f0                	mov    %esi,%eax
  802a05:	f7 f1                	div    %ecx
  802a07:	89 c6                	mov    %eax,%esi
  802a09:	89 e8                	mov    %ebp,%eax
  802a0b:	89 f7                	mov    %esi,%edi
  802a0d:	f7 f1                	div    %ecx
  802a0f:	89 fa                	mov    %edi,%edx
  802a11:	83 c4 1c             	add    $0x1c,%esp
  802a14:	5b                   	pop    %ebx
  802a15:	5e                   	pop    %esi
  802a16:	5f                   	pop    %edi
  802a17:	5d                   	pop    %ebp
  802a18:	c3                   	ret    
  802a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a20:	89 f9                	mov    %edi,%ecx
  802a22:	b8 20 00 00 00       	mov    $0x20,%eax
  802a27:	29 f8                	sub    %edi,%eax
  802a29:	d3 e2                	shl    %cl,%edx
  802a2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a2f:	89 c1                	mov    %eax,%ecx
  802a31:	89 da                	mov    %ebx,%edx
  802a33:	d3 ea                	shr    %cl,%edx
  802a35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a39:	09 d1                	or     %edx,%ecx
  802a3b:	89 f2                	mov    %esi,%edx
  802a3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a41:	89 f9                	mov    %edi,%ecx
  802a43:	d3 e3                	shl    %cl,%ebx
  802a45:	89 c1                	mov    %eax,%ecx
  802a47:	d3 ea                	shr    %cl,%edx
  802a49:	89 f9                	mov    %edi,%ecx
  802a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a4f:	89 eb                	mov    %ebp,%ebx
  802a51:	d3 e6                	shl    %cl,%esi
  802a53:	89 c1                	mov    %eax,%ecx
  802a55:	d3 eb                	shr    %cl,%ebx
  802a57:	09 de                	or     %ebx,%esi
  802a59:	89 f0                	mov    %esi,%eax
  802a5b:	f7 74 24 08          	divl   0x8(%esp)
  802a5f:	89 d6                	mov    %edx,%esi
  802a61:	89 c3                	mov    %eax,%ebx
  802a63:	f7 64 24 0c          	mull   0xc(%esp)
  802a67:	39 d6                	cmp    %edx,%esi
  802a69:	72 15                	jb     802a80 <__udivdi3+0x100>
  802a6b:	89 f9                	mov    %edi,%ecx
  802a6d:	d3 e5                	shl    %cl,%ebp
  802a6f:	39 c5                	cmp    %eax,%ebp
  802a71:	73 04                	jae    802a77 <__udivdi3+0xf7>
  802a73:	39 d6                	cmp    %edx,%esi
  802a75:	74 09                	je     802a80 <__udivdi3+0x100>
  802a77:	89 d8                	mov    %ebx,%eax
  802a79:	31 ff                	xor    %edi,%edi
  802a7b:	e9 40 ff ff ff       	jmp    8029c0 <__udivdi3+0x40>
  802a80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a83:	31 ff                	xor    %edi,%edi
  802a85:	e9 36 ff ff ff       	jmp    8029c0 <__udivdi3+0x40>
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__umoddi3>:
  802a90:	f3 0f 1e fb          	endbr32 
  802a94:	55                   	push   %ebp
  802a95:	57                   	push   %edi
  802a96:	56                   	push   %esi
  802a97:	53                   	push   %ebx
  802a98:	83 ec 1c             	sub    $0x1c,%esp
  802a9b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a9f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802aa3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802aa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802aab:	85 c0                	test   %eax,%eax
  802aad:	75 19                	jne    802ac8 <__umoddi3+0x38>
  802aaf:	39 df                	cmp    %ebx,%edi
  802ab1:	76 5d                	jbe    802b10 <__umoddi3+0x80>
  802ab3:	89 f0                	mov    %esi,%eax
  802ab5:	89 da                	mov    %ebx,%edx
  802ab7:	f7 f7                	div    %edi
  802ab9:	89 d0                	mov    %edx,%eax
  802abb:	31 d2                	xor    %edx,%edx
  802abd:	83 c4 1c             	add    $0x1c,%esp
  802ac0:	5b                   	pop    %ebx
  802ac1:	5e                   	pop    %esi
  802ac2:	5f                   	pop    %edi
  802ac3:	5d                   	pop    %ebp
  802ac4:	c3                   	ret    
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	89 f2                	mov    %esi,%edx
  802aca:	39 d8                	cmp    %ebx,%eax
  802acc:	76 12                	jbe    802ae0 <__umoddi3+0x50>
  802ace:	89 f0                	mov    %esi,%eax
  802ad0:	89 da                	mov    %ebx,%edx
  802ad2:	83 c4 1c             	add    $0x1c,%esp
  802ad5:	5b                   	pop    %ebx
  802ad6:	5e                   	pop    %esi
  802ad7:	5f                   	pop    %edi
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    
  802ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ae0:	0f bd e8             	bsr    %eax,%ebp
  802ae3:	83 f5 1f             	xor    $0x1f,%ebp
  802ae6:	75 50                	jne    802b38 <__umoddi3+0xa8>
  802ae8:	39 d8                	cmp    %ebx,%eax
  802aea:	0f 82 e0 00 00 00    	jb     802bd0 <__umoddi3+0x140>
  802af0:	89 d9                	mov    %ebx,%ecx
  802af2:	39 f7                	cmp    %esi,%edi
  802af4:	0f 86 d6 00 00 00    	jbe    802bd0 <__umoddi3+0x140>
  802afa:	89 d0                	mov    %edx,%eax
  802afc:	89 ca                	mov    %ecx,%edx
  802afe:	83 c4 1c             	add    $0x1c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b0d:	8d 76 00             	lea    0x0(%esi),%esi
  802b10:	89 fd                	mov    %edi,%ebp
  802b12:	85 ff                	test   %edi,%edi
  802b14:	75 0b                	jne    802b21 <__umoddi3+0x91>
  802b16:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f7                	div    %edi
  802b1f:	89 c5                	mov    %eax,%ebp
  802b21:	89 d8                	mov    %ebx,%eax
  802b23:	31 d2                	xor    %edx,%edx
  802b25:	f7 f5                	div    %ebp
  802b27:	89 f0                	mov    %esi,%eax
  802b29:	f7 f5                	div    %ebp
  802b2b:	89 d0                	mov    %edx,%eax
  802b2d:	31 d2                	xor    %edx,%edx
  802b2f:	eb 8c                	jmp    802abd <__umoddi3+0x2d>
  802b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b3f:	29 ea                	sub    %ebp,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b47:	89 d1                	mov    %edx,%ecx
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	d3 e8                	shr    %cl,%eax
  802b4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b59:	09 c1                	or     %eax,%ecx
  802b5b:	89 d8                	mov    %ebx,%eax
  802b5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b61:	89 e9                	mov    %ebp,%ecx
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	d3 e8                	shr    %cl,%eax
  802b69:	89 e9                	mov    %ebp,%ecx
  802b6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b6f:	d3 e3                	shl    %cl,%ebx
  802b71:	89 c7                	mov    %eax,%edi
  802b73:	89 d1                	mov    %edx,%ecx
  802b75:	89 f0                	mov    %esi,%eax
  802b77:	d3 e8                	shr    %cl,%eax
  802b79:	89 e9                	mov    %ebp,%ecx
  802b7b:	89 fa                	mov    %edi,%edx
  802b7d:	d3 e6                	shl    %cl,%esi
  802b7f:	09 d8                	or     %ebx,%eax
  802b81:	f7 74 24 08          	divl   0x8(%esp)
  802b85:	89 d1                	mov    %edx,%ecx
  802b87:	89 f3                	mov    %esi,%ebx
  802b89:	f7 64 24 0c          	mull   0xc(%esp)
  802b8d:	89 c6                	mov    %eax,%esi
  802b8f:	89 d7                	mov    %edx,%edi
  802b91:	39 d1                	cmp    %edx,%ecx
  802b93:	72 06                	jb     802b9b <__umoddi3+0x10b>
  802b95:	75 10                	jne    802ba7 <__umoddi3+0x117>
  802b97:	39 c3                	cmp    %eax,%ebx
  802b99:	73 0c                	jae    802ba7 <__umoddi3+0x117>
  802b9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802ba3:	89 d7                	mov    %edx,%edi
  802ba5:	89 c6                	mov    %eax,%esi
  802ba7:	89 ca                	mov    %ecx,%edx
  802ba9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802bae:	29 f3                	sub    %esi,%ebx
  802bb0:	19 fa                	sbb    %edi,%edx
  802bb2:	89 d0                	mov    %edx,%eax
  802bb4:	d3 e0                	shl    %cl,%eax
  802bb6:	89 e9                	mov    %ebp,%ecx
  802bb8:	d3 eb                	shr    %cl,%ebx
  802bba:	d3 ea                	shr    %cl,%edx
  802bbc:	09 d8                	or     %ebx,%eax
  802bbe:	83 c4 1c             	add    $0x1c,%esp
  802bc1:	5b                   	pop    %ebx
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bcd:	8d 76 00             	lea    0x0(%esi),%esi
  802bd0:	29 fe                	sub    %edi,%esi
  802bd2:	19 c3                	sbb    %eax,%ebx
  802bd4:	89 f2                	mov    %esi,%edx
  802bd6:	89 d9                	mov    %ebx,%ecx
  802bd8:	e9 1d ff ff ff       	jmp    802afa <__umoddi3+0x6a>
