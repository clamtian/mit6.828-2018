
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 58 06 00 00       	call   800689 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 60 80 00       	push   $0x806000
  800042:	e8 9b 0d 00 00       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 cb 14 00 00       	call   801524 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 60 80 00       	push   $0x806000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 64 14 00 00       	call   8014cc <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 df 13 00 00       	call   801458 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	f3 0f 1e fb          	endbr32 
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	57                   	push   %edi
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008e:	ba 00 00 00 00       	mov    $0x0,%edx
  800093:	b8 20 2a 80 00       	mov    $0x802a20,%eax
  800098:	e8 96 ff ff ff       	call   800033 <xopen>
  80009d:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000a0:	74 08                	je     8000aa <umain+0x2c>
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 88 e9 03 00 00    	js     800493 <umain+0x415>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	0f 89 f3 03 00 00    	jns    8004a5 <umain+0x427>
		panic("serve_open /not-found succeeded!");

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b7:	b8 55 2a 80 00       	mov    $0x802a55,%eax
  8000bc:	e8 72 ff ff ff       	call   800033 <xopen>
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	0f 88 f0 03 00 00    	js     8004b9 <umain+0x43b>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000c9:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000d0:	0f 85 f5 03 00 00    	jne    8004cb <umain+0x44d>
  8000d6:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000dd:	0f 85 e8 03 00 00    	jne    8004cb <umain+0x44d>
  8000e3:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000ea:	0f 85 db 03 00 00    	jne    8004cb <umain+0x44d>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	68 76 2a 80 00       	push   $0x802a76
  8000f8:	e8 db 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800106:	50                   	push   %eax
  800107:	68 00 c0 cc cc       	push   $0xccccc000
  80010c:	ff 15 1c 40 80 00    	call   *0x80401c
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	85 c0                	test   %eax,%eax
  800117:	0f 88 c2 03 00 00    	js     8004df <umain+0x461>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	ff 35 00 40 80 00    	pushl  0x804000
  800126:	e8 74 0c 00 00       	call   800d9f <strlen>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800131:	0f 85 ba 03 00 00    	jne    8004f1 <umain+0x473>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 98 2a 80 00       	push   $0x802a98
  80013f:	e8 94 06 00 00       	call   8007d8 <cprintf>

	memset(buf, 0, sizeof buf);
  800144:	83 c4 0c             	add    $0xc,%esp
  800147:	68 00 02 00 00       	push   $0x200
  80014c:	6a 00                	push   $0x0
  80014e:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800154:	53                   	push   %ebx
  800155:	e8 f2 0d 00 00       	call   800f4c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  80015a:	83 c4 0c             	add    $0xc,%esp
  80015d:	68 00 02 00 00       	push   $0x200
  800162:	53                   	push   %ebx
  800163:	68 00 c0 cc cc       	push   $0xccccc000
  800168:	ff 15 10 40 80 00    	call   *0x804010
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	85 c0                	test   %eax,%eax
  800173:	0f 88 9d 03 00 00    	js     800516 <umain+0x498>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 35 00 40 80 00    	pushl  0x804000
  800182:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 13 0d 00 00       	call   800ea1 <strcmp>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	85 c0                	test   %eax,%eax
  800193:	0f 85 8f 03 00 00    	jne    800528 <umain+0x4aa>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	68 d7 2a 80 00       	push   $0x802ad7
  8001a1:	e8 32 06 00 00       	call   8007d8 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001a6:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001ad:	ff 15 18 40 80 00    	call   *0x804018
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	85 c0                	test   %eax,%eax
  8001b8:	0f 88 7e 03 00 00    	js     80053c <umain+0x4be>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 f9 2a 80 00       	push   $0x802af9
  8001c6:	e8 0d 06 00 00       	call   8007d8 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001cb:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8001d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d3:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8001d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001db:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8001e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e3:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8001e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8001eb:	83 c4 08             	add    $0x8,%esp
  8001ee:	68 00 c0 cc cc       	push   $0xccccc000
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 b7 10 00 00       	call   8012b1 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001fa:	83 c4 0c             	add    $0xc,%esp
  8001fd:	68 00 02 00 00       	push   $0x200
  800202:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800208:	50                   	push   %eax
  800209:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	ff 15 10 40 80 00    	call   *0x804010
  800213:	83 c4 10             	add    $0x10,%esp
  800216:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800219:	0f 85 2f 03 00 00    	jne    80054e <umain+0x4d0>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	68 0d 2b 80 00       	push   $0x802b0d
  800227:	e8 ac 05 00 00       	call   8007d8 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  80022c:	ba 02 01 00 00       	mov    $0x102,%edx
  800231:	b8 23 2b 80 00       	mov    $0x802b23,%eax
  800236:	e8 f8 fd ff ff       	call   800033 <xopen>
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	85 c0                	test   %eax,%eax
  800240:	0f 88 1a 03 00 00    	js     800560 <umain+0x4e2>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800246:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80024c:	83 ec 0c             	sub    $0xc,%esp
  80024f:	ff 35 00 40 80 00    	pushl  0x804000
  800255:	e8 45 0b 00 00       	call   800d9f <strlen>
  80025a:	83 c4 0c             	add    $0xc,%esp
  80025d:	50                   	push   %eax
  80025e:	ff 35 00 40 80 00    	pushl  0x804000
  800264:	68 00 c0 cc cc       	push   $0xccccc000
  800269:	ff d3                	call   *%ebx
  80026b:	89 c3                	mov    %eax,%ebx
  80026d:	83 c4 04             	add    $0x4,%esp
  800270:	ff 35 00 40 80 00    	pushl  0x804000
  800276:	e8 24 0b 00 00       	call   800d9f <strlen>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	39 d8                	cmp    %ebx,%eax
  800280:	0f 85 ec 02 00 00    	jne    800572 <umain+0x4f4>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	68 55 2b 80 00       	push   $0x802b55
  80028e:	e8 45 05 00 00       	call   8007d8 <cprintf>

	FVA->fd_offset = 0;
  800293:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  80029a:	00 00 00 
	memset(buf, 0, sizeof buf);
  80029d:	83 c4 0c             	add    $0xc,%esp
  8002a0:	68 00 02 00 00       	push   $0x200
  8002a5:	6a 00                	push   $0x0
  8002a7:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002ad:	53                   	push   %ebx
  8002ae:	e8 99 0c 00 00       	call   800f4c <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002b3:	83 c4 0c             	add    $0xc,%esp
  8002b6:	68 00 02 00 00       	push   $0x200
  8002bb:	53                   	push   %ebx
  8002bc:	68 00 c0 cc cc       	push   $0xccccc000
  8002c1:	ff 15 10 40 80 00    	call   *0x804010
  8002c7:	89 c3                	mov    %eax,%ebx
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	0f 88 b0 02 00 00    	js     800584 <umain+0x506>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	ff 35 00 40 80 00    	pushl  0x804000
  8002dd:	e8 bd 0a 00 00       	call   800d9f <strlen>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	39 d8                	cmp    %ebx,%eax
  8002e7:	0f 85 a9 02 00 00    	jne    800596 <umain+0x518>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 35 00 40 80 00    	pushl  0x804000
  8002f6:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002fc:	50                   	push   %eax
  8002fd:	e8 9f 0b 00 00       	call   800ea1 <strcmp>
  800302:	83 c4 10             	add    $0x10,%esp
  800305:	85 c0                	test   %eax,%eax
  800307:	0f 85 9b 02 00 00    	jne    8005a8 <umain+0x52a>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	68 1c 2d 80 00       	push   $0x802d1c
  800315:	e8 be 04 00 00       	call   8007d8 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80031a:	83 c4 08             	add    $0x8,%esp
  80031d:	6a 00                	push   $0x0
  80031f:	68 20 2a 80 00       	push   $0x802a20
  800324:	e8 da 19 00 00       	call   801d03 <open>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80032f:	74 08                	je     800339 <umain+0x2bb>
  800331:	85 c0                	test   %eax,%eax
  800333:	0f 88 83 02 00 00    	js     8005bc <umain+0x53e>
		panic("open /not-found: %e", r);
	else if (r >= 0)
  800339:	85 c0                	test   %eax,%eax
  80033b:	0f 89 8d 02 00 00    	jns    8005ce <umain+0x550>
		panic("open /not-found succeeded!");

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	6a 00                	push   $0x0
  800346:	68 55 2a 80 00       	push   $0x802a55
  80034b:	e8 b3 19 00 00       	call   801d03 <open>
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	85 c0                	test   %eax,%eax
  800355:	0f 88 87 02 00 00    	js     8005e2 <umain+0x564>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  80035b:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80035e:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800365:	0f 85 89 02 00 00    	jne    8005f4 <umain+0x576>
  80036b:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  800372:	0f 85 7c 02 00 00    	jne    8005f4 <umain+0x576>
  800378:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80037e:	85 db                	test   %ebx,%ebx
  800380:	0f 85 6e 02 00 00    	jne    8005f4 <umain+0x576>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 7c 2a 80 00       	push   $0x802a7c
  80038e:	e8 45 04 00 00       	call   8007d8 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  800393:	83 c4 08             	add    $0x8,%esp
  800396:	68 01 01 00 00       	push   $0x101
  80039b:	68 84 2b 80 00       	push   $0x802b84
  8003a0:	e8 5e 19 00 00       	call   801d03 <open>
  8003a5:	89 c7                	mov    %eax,%edi
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	85 c0                	test   %eax,%eax
  8003ac:	0f 88 56 02 00 00    	js     800608 <umain+0x58a>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 00 02 00 00       	push   $0x200
  8003ba:	6a 00                	push   $0x0
  8003bc:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003c2:	50                   	push   %eax
  8003c3:	e8 84 0b 00 00       	call   800f4c <memset>
  8003c8:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003cb:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8003cd:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8003d3:	83 ec 04             	sub    $0x4,%esp
  8003d6:	68 00 02 00 00       	push   $0x200
  8003db:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8003e1:	50                   	push   %eax
  8003e2:	57                   	push   %edi
  8003e3:	e8 5c 15 00 00       	call   801944 <write>
  8003e8:	83 c4 10             	add    $0x10,%esp
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	0f 88 27 02 00 00    	js     80061a <umain+0x59c>
  8003f3:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8003f9:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  8003ff:	75 cc                	jne    8003cd <umain+0x34f>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800401:	83 ec 0c             	sub    $0xc,%esp
  800404:	57                   	push   %edi
  800405:	e8 1a 13 00 00       	call   801724 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80040a:	83 c4 08             	add    $0x8,%esp
  80040d:	6a 00                	push   $0x0
  80040f:	68 84 2b 80 00       	push   $0x802b84
  800414:	e8 ea 18 00 00       	call   801d03 <open>
  800419:	89 c6                	mov    %eax,%esi
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	85 c0                	test   %eax,%eax
  800420:	0f 88 0a 02 00 00    	js     800630 <umain+0x5b2>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800426:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  80042c:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	68 00 02 00 00       	push   $0x200
  80043a:	57                   	push   %edi
  80043b:	56                   	push   %esi
  80043c:	e8 b8 14 00 00       	call   8018f9 <readn>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	85 c0                	test   %eax,%eax
  800446:	0f 88 f6 01 00 00    	js     800642 <umain+0x5c4>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  80044c:	3d 00 02 00 00       	cmp    $0x200,%eax
  800451:	0f 85 01 02 00 00    	jne    800658 <umain+0x5da>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800457:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80045d:	39 d8                	cmp    %ebx,%eax
  80045f:	0f 85 0e 02 00 00    	jne    800673 <umain+0x5f5>
  800465:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80046b:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  800471:	75 b9                	jne    80042c <umain+0x3ae>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800473:	83 ec 0c             	sub    $0xc,%esp
  800476:	56                   	push   %esi
  800477:	e8 a8 12 00 00       	call   801724 <close>
	cprintf("large file is good\n");
  80047c:	c7 04 24 c9 2b 80 00 	movl   $0x802bc9,(%esp)
  800483:	e8 50 03 00 00       	call   8007d8 <cprintf>
}
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80048e:	5b                   	pop    %ebx
  80048f:	5e                   	pop    %esi
  800490:	5f                   	pop    %edi
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    
		panic("serve_open /not-found: %e", r);
  800493:	50                   	push   %eax
  800494:	68 2b 2a 80 00       	push   $0x802a2b
  800499:	6a 20                	push   $0x20
  80049b:	68 45 2a 80 00       	push   $0x802a45
  8004a0:	e8 4c 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /not-found succeeded!");
  8004a5:	83 ec 04             	sub    $0x4,%esp
  8004a8:	68 e0 2b 80 00       	push   $0x802be0
  8004ad:	6a 22                	push   $0x22
  8004af:	68 45 2a 80 00       	push   $0x802a45
  8004b4:	e8 38 02 00 00       	call   8006f1 <_panic>
		panic("serve_open /newmotd: %e", r);
  8004b9:	50                   	push   %eax
  8004ba:	68 5e 2a 80 00       	push   $0x802a5e
  8004bf:	6a 25                	push   $0x25
  8004c1:	68 45 2a 80 00       	push   $0x802a45
  8004c6:	e8 26 02 00 00       	call   8006f1 <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 04 2c 80 00       	push   $0x802c04
  8004d3:	6a 27                	push   $0x27
  8004d5:	68 45 2a 80 00       	push   $0x802a45
  8004da:	e8 12 02 00 00       	call   8006f1 <_panic>
		panic("file_stat: %e", r);
  8004df:	50                   	push   %eax
  8004e0:	68 8a 2a 80 00       	push   $0x802a8a
  8004e5:	6a 2b                	push   $0x2b
  8004e7:	68 45 2a 80 00       	push   $0x802a45
  8004ec:	e8 00 02 00 00       	call   8006f1 <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8004f1:	83 ec 0c             	sub    $0xc,%esp
  8004f4:	ff 35 00 40 80 00    	pushl  0x804000
  8004fa:	e8 a0 08 00 00       	call   800d9f <strlen>
  8004ff:	89 04 24             	mov    %eax,(%esp)
  800502:	ff 75 cc             	pushl  -0x34(%ebp)
  800505:	68 34 2c 80 00       	push   $0x802c34
  80050a:	6a 2d                	push   $0x2d
  80050c:	68 45 2a 80 00       	push   $0x802a45
  800511:	e8 db 01 00 00       	call   8006f1 <_panic>
		panic("file_read: %e", r);
  800516:	50                   	push   %eax
  800517:	68 ab 2a 80 00       	push   $0x802aab
  80051c:	6a 32                	push   $0x32
  80051e:	68 45 2a 80 00       	push   $0x802a45
  800523:	e8 c9 01 00 00       	call   8006f1 <_panic>
		panic("file_read returned wrong data");
  800528:	83 ec 04             	sub    $0x4,%esp
  80052b:	68 b9 2a 80 00       	push   $0x802ab9
  800530:	6a 34                	push   $0x34
  800532:	68 45 2a 80 00       	push   $0x802a45
  800537:	e8 b5 01 00 00       	call   8006f1 <_panic>
		panic("file_close: %e", r);
  80053c:	50                   	push   %eax
  80053d:	68 ea 2a 80 00       	push   $0x802aea
  800542:	6a 38                	push   $0x38
  800544:	68 45 2a 80 00       	push   $0x802a45
  800549:	e8 a3 01 00 00       	call   8006f1 <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  80054e:	50                   	push   %eax
  80054f:	68 5c 2c 80 00       	push   $0x802c5c
  800554:	6a 43                	push   $0x43
  800556:	68 45 2a 80 00       	push   $0x802a45
  80055b:	e8 91 01 00 00       	call   8006f1 <_panic>
		panic("serve_open /new-file: %e", r);
  800560:	50                   	push   %eax
  800561:	68 2d 2b 80 00       	push   $0x802b2d
  800566:	6a 48                	push   $0x48
  800568:	68 45 2a 80 00       	push   $0x802a45
  80056d:	e8 7f 01 00 00       	call   8006f1 <_panic>
		panic("file_write: %e", r);
  800572:	53                   	push   %ebx
  800573:	68 46 2b 80 00       	push   $0x802b46
  800578:	6a 4b                	push   $0x4b
  80057a:	68 45 2a 80 00       	push   $0x802a45
  80057f:	e8 6d 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write: %e", r);
  800584:	50                   	push   %eax
  800585:	68 94 2c 80 00       	push   $0x802c94
  80058a:	6a 51                	push   $0x51
  80058c:	68 45 2a 80 00       	push   $0x802a45
  800591:	e8 5b 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  800596:	53                   	push   %ebx
  800597:	68 b4 2c 80 00       	push   $0x802cb4
  80059c:	6a 53                	push   $0x53
  80059e:	68 45 2a 80 00       	push   $0x802a45
  8005a3:	e8 49 01 00 00       	call   8006f1 <_panic>
		panic("file_read after file_write returned wrong data");
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	68 ec 2c 80 00       	push   $0x802cec
  8005b0:	6a 55                	push   $0x55
  8005b2:	68 45 2a 80 00       	push   $0x802a45
  8005b7:	e8 35 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found: %e", r);
  8005bc:	50                   	push   %eax
  8005bd:	68 31 2a 80 00       	push   $0x802a31
  8005c2:	6a 5a                	push   $0x5a
  8005c4:	68 45 2a 80 00       	push   $0x802a45
  8005c9:	e8 23 01 00 00       	call   8006f1 <_panic>
		panic("open /not-found succeeded!");
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 69 2b 80 00       	push   $0x802b69
  8005d6:	6a 5c                	push   $0x5c
  8005d8:	68 45 2a 80 00       	push   $0x802a45
  8005dd:	e8 0f 01 00 00       	call   8006f1 <_panic>
		panic("open /newmotd: %e", r);
  8005e2:	50                   	push   %eax
  8005e3:	68 64 2a 80 00       	push   $0x802a64
  8005e8:	6a 5f                	push   $0x5f
  8005ea:	68 45 2a 80 00       	push   $0x802a45
  8005ef:	e8 fd 00 00 00       	call   8006f1 <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 40 2d 80 00       	push   $0x802d40
  8005fc:	6a 62                	push   $0x62
  8005fe:	68 45 2a 80 00       	push   $0x802a45
  800603:	e8 e9 00 00 00       	call   8006f1 <_panic>
		panic("creat /big: %e", f);
  800608:	50                   	push   %eax
  800609:	68 89 2b 80 00       	push   $0x802b89
  80060e:	6a 67                	push   $0x67
  800610:	68 45 2a 80 00       	push   $0x802a45
  800615:	e8 d7 00 00 00       	call   8006f1 <_panic>
			panic("write /big@%d: %e", i, r);
  80061a:	83 ec 0c             	sub    $0xc,%esp
  80061d:	50                   	push   %eax
  80061e:	56                   	push   %esi
  80061f:	68 98 2b 80 00       	push   $0x802b98
  800624:	6a 6c                	push   $0x6c
  800626:	68 45 2a 80 00       	push   $0x802a45
  80062b:	e8 c1 00 00 00       	call   8006f1 <_panic>
		panic("open /big: %e", f);
  800630:	50                   	push   %eax
  800631:	68 aa 2b 80 00       	push   $0x802baa
  800636:	6a 71                	push   $0x71
  800638:	68 45 2a 80 00       	push   $0x802a45
  80063d:	e8 af 00 00 00       	call   8006f1 <_panic>
			panic("read /big@%d: %e", i, r);
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	53                   	push   %ebx
  800647:	68 b8 2b 80 00       	push   $0x802bb8
  80064c:	6a 75                	push   $0x75
  80064e:	68 45 2a 80 00       	push   $0x802a45
  800653:	e8 99 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	68 00 02 00 00       	push   $0x200
  800660:	50                   	push   %eax
  800661:	53                   	push   %ebx
  800662:	68 68 2d 80 00       	push   $0x802d68
  800667:	6a 77                	push   $0x77
  800669:	68 45 2a 80 00       	push   $0x802a45
  80066e:	e8 7e 00 00 00       	call   8006f1 <_panic>
			panic("read /big from %d returned bad data %d",
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	50                   	push   %eax
  800677:	53                   	push   %ebx
  800678:	68 94 2d 80 00       	push   $0x802d94
  80067d:	6a 7a                	push   $0x7a
  80067f:	68 45 2a 80 00       	push   $0x802a45
  800684:	e8 68 00 00 00       	call   8006f1 <_panic>

00800689 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800689:	f3 0f 1e fb          	endbr32 
  80068d:	55                   	push   %ebp
  80068e:	89 e5                	mov    %esp,%ebp
  800690:	56                   	push   %esi
  800691:	53                   	push   %ebx
  800692:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800695:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800698:	e8 41 0b 00 00       	call   8011de <sys_getenvid>
  80069d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8006a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8006a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006aa:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	85 db                	test   %ebx,%ebx
  8006b1:	7e 07                	jle    8006ba <libmain+0x31>
		binaryname = argv[0];
  8006b3:	8b 06                	mov    (%esi),%eax
  8006b5:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	56                   	push   %esi
  8006be:	53                   	push   %ebx
  8006bf:	e8 ba f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006c4:	e8 0a 00 00 00       	call   8006d3 <exit>
}
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006cf:	5b                   	pop    %ebx
  8006d0:	5e                   	pop    %esi
  8006d1:	5d                   	pop    %ebp
  8006d2:	c3                   	ret    

008006d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006d3:	f3 0f 1e fb          	endbr32 
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006dd:	e8 73 10 00 00       	call   801755 <close_all>
	sys_env_destroy(0);
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	6a 00                	push   $0x0
  8006e7:	e8 ad 0a 00 00       	call   801199 <sys_env_destroy>
}
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	c9                   	leave  
  8006f0:	c3                   	ret    

008006f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006f1:	f3 0f 1e fb          	endbr32 
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	56                   	push   %esi
  8006f9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8006fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006fd:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800703:	e8 d6 0a 00 00       	call   8011de <sys_getenvid>
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	ff 75 0c             	pushl  0xc(%ebp)
  80070e:	ff 75 08             	pushl  0x8(%ebp)
  800711:	56                   	push   %esi
  800712:	50                   	push   %eax
  800713:	68 ec 2d 80 00       	push   $0x802dec
  800718:	e8 bb 00 00 00       	call   8007d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80071d:	83 c4 18             	add    $0x18,%esp
  800720:	53                   	push   %ebx
  800721:	ff 75 10             	pushl  0x10(%ebp)
  800724:	e8 5a 00 00 00       	call   800783 <vcprintf>
	cprintf("\n");
  800729:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  800730:	e8 a3 00 00 00       	call   8007d8 <cprintf>
  800735:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800738:	cc                   	int3   
  800739:	eb fd                	jmp    800738 <_panic+0x47>

0080073b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80073b:	f3 0f 1e fb          	endbr32 
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
  800742:	53                   	push   %ebx
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800749:	8b 13                	mov    (%ebx),%edx
  80074b:	8d 42 01             	lea    0x1(%edx),%eax
  80074e:	89 03                	mov    %eax,(%ebx)
  800750:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800753:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800757:	3d ff 00 00 00       	cmp    $0xff,%eax
  80075c:	74 09                	je     800767 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80075e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800765:	c9                   	leave  
  800766:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	68 ff 00 00 00       	push   $0xff
  80076f:	8d 43 08             	lea    0x8(%ebx),%eax
  800772:	50                   	push   %eax
  800773:	e8 dc 09 00 00       	call   801154 <sys_cputs>
		b->idx = 0;
  800778:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb db                	jmp    80075e <putch+0x23>

00800783 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800783:	f3 0f 1e fb          	endbr32 
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800790:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800797:	00 00 00 
	b.cnt = 0;
  80079a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	68 3b 07 80 00       	push   $0x80073b
  8007b6:	e8 20 01 00 00       	call   8008db <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007bb:	83 c4 08             	add    $0x8,%esp
  8007be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007ca:	50                   	push   %eax
  8007cb:	e8 84 09 00 00       	call   801154 <sys_cputs>

	return b.cnt;
}
  8007d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	e8 95 ff ff ff       	call   800783 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	57                   	push   %edi
  8007f4:	56                   	push   %esi
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 1c             	sub    $0x1c,%esp
  8007f9:	89 c7                	mov    %eax,%edi
  8007fb:	89 d6                	mov    %edx,%esi
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	8b 55 0c             	mov    0xc(%ebp),%edx
  800803:	89 d1                	mov    %edx,%ecx
  800805:	89 c2                	mov    %eax,%edx
  800807:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800813:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800816:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80081d:	39 c2                	cmp    %eax,%edx
  80081f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800822:	72 3e                	jb     800862 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	ff 75 18             	pushl  0x18(%ebp)
  80082a:	83 eb 01             	sub    $0x1,%ebx
  80082d:	53                   	push   %ebx
  80082e:	50                   	push   %eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 e4             	pushl  -0x1c(%ebp)
  800835:	ff 75 e0             	pushl  -0x20(%ebp)
  800838:	ff 75 dc             	pushl  -0x24(%ebp)
  80083b:	ff 75 d8             	pushl  -0x28(%ebp)
  80083e:	e8 6d 1f 00 00       	call   8027b0 <__udivdi3>
  800843:	83 c4 18             	add    $0x18,%esp
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	89 f2                	mov    %esi,%edx
  80084a:	89 f8                	mov    %edi,%eax
  80084c:	e8 9f ff ff ff       	call   8007f0 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
  800854:	eb 13                	jmp    800869 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	56                   	push   %esi
  80085a:	ff 75 18             	pushl  0x18(%ebp)
  80085d:	ff d7                	call   *%edi
  80085f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800862:	83 eb 01             	sub    $0x1,%ebx
  800865:	85 db                	test   %ebx,%ebx
  800867:	7f ed                	jg     800856 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	56                   	push   %esi
  80086d:	83 ec 04             	sub    $0x4,%esp
  800870:	ff 75 e4             	pushl  -0x1c(%ebp)
  800873:	ff 75 e0             	pushl  -0x20(%ebp)
  800876:	ff 75 dc             	pushl  -0x24(%ebp)
  800879:	ff 75 d8             	pushl  -0x28(%ebp)
  80087c:	e8 3f 20 00 00       	call   8028c0 <__umoddi3>
  800881:	83 c4 14             	add    $0x14,%esp
  800884:	0f be 80 0f 2e 80 00 	movsbl 0x802e0f(%eax),%eax
  80088b:	50                   	push   %eax
  80088c:	ff d7                	call   *%edi
}
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800894:	5b                   	pop    %ebx
  800895:	5e                   	pop    %esi
  800896:	5f                   	pop    %edi
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800899:	f3 0f 1e fb          	endbr32 
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008a3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008a7:	8b 10                	mov    (%eax),%edx
  8008a9:	3b 50 04             	cmp    0x4(%eax),%edx
  8008ac:	73 0a                	jae    8008b8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8008ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008b1:	89 08                	mov    %ecx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	88 02                	mov    %al,(%edx)
}
  8008b8:	5d                   	pop    %ebp
  8008b9:	c3                   	ret    

008008ba <printfmt>:
{
  8008ba:	f3 0f 1e fb          	endbr32 
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 05 00 00 00       	call   8008db <vprintfmt>
}
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <vprintfmt>:
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	83 ec 3c             	sub    $0x3c,%esp
  8008e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8008eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008f1:	e9 8e 03 00 00       	jmp    800c84 <vprintfmt+0x3a9>
		padc = ' ';
  8008f6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8008fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800901:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800908:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80090f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800914:	8d 47 01             	lea    0x1(%edi),%eax
  800917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091a:	0f b6 17             	movzbl (%edi),%edx
  80091d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800920:	3c 55                	cmp    $0x55,%al
  800922:	0f 87 df 03 00 00    	ja     800d07 <vprintfmt+0x42c>
  800928:	0f b6 c0             	movzbl %al,%eax
  80092b:	3e ff 24 85 60 2f 80 	notrack jmp *0x802f60(,%eax,4)
  800932:	00 
  800933:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800936:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80093a:	eb d8                	jmp    800914 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80093c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80093f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800943:	eb cf                	jmp    800914 <vprintfmt+0x39>
  800945:	0f b6 d2             	movzbl %dl,%edx
  800948:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800953:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800956:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80095a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80095d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800960:	83 f9 09             	cmp    $0x9,%ecx
  800963:	77 55                	ja     8009ba <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800965:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800968:	eb e9                	jmp    800953 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80096a:	8b 45 14             	mov    0x14(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800972:	8b 45 14             	mov    0x14(%ebp),%eax
  800975:	8d 40 04             	lea    0x4(%eax),%eax
  800978:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80097e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800982:	79 90                	jns    800914 <vprintfmt+0x39>
				width = precision, precision = -1;
  800984:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800987:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80098a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800991:	eb 81                	jmp    800914 <vprintfmt+0x39>
  800993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	ba 00 00 00 00       	mov    $0x0,%edx
  80099d:	0f 49 d0             	cmovns %eax,%edx
  8009a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009a6:	e9 69 ff ff ff       	jmp    800914 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8009ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8009b5:	e9 5a ff ff ff       	jmp    800914 <vprintfmt+0x39>
  8009ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	eb bc                	jmp    80097e <vprintfmt+0xa3>
			lflag++;
  8009c2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009c8:	e9 47 ff ff ff       	jmp    800914 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	8d 78 04             	lea    0x4(%eax),%edi
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	ff 30                	pushl  (%eax)
  8009d9:	ff d6                	call   *%esi
			break;
  8009db:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009de:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009e1:	e9 9b 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8009e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e9:	8d 78 04             	lea    0x4(%eax),%edi
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	99                   	cltd   
  8009ef:	31 d0                	xor    %edx,%eax
  8009f1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009f3:	83 f8 0f             	cmp    $0xf,%eax
  8009f6:	7f 23                	jg     800a1b <vprintfmt+0x140>
  8009f8:	8b 14 85 c0 30 80 00 	mov    0x8030c0(,%eax,4),%edx
  8009ff:	85 d2                	test   %edx,%edx
  800a01:	74 18                	je     800a1b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800a03:	52                   	push   %edx
  800a04:	68 11 32 80 00       	push   $0x803211
  800a09:	53                   	push   %ebx
  800a0a:	56                   	push   %esi
  800a0b:	e8 aa fe ff ff       	call   8008ba <printfmt>
  800a10:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a13:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a16:	e9 66 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800a1b:	50                   	push   %eax
  800a1c:	68 27 2e 80 00       	push   $0x802e27
  800a21:	53                   	push   %ebx
  800a22:	56                   	push   %esi
  800a23:	e8 92 fe ff ff       	call   8008ba <printfmt>
  800a28:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a2b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a2e:	e9 4e 02 00 00       	jmp    800c81 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800a33:	8b 45 14             	mov    0x14(%ebp),%eax
  800a36:	83 c0 04             	add    $0x4,%eax
  800a39:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800a41:	85 d2                	test   %edx,%edx
  800a43:	b8 20 2e 80 00       	mov    $0x802e20,%eax
  800a48:	0f 45 c2             	cmovne %edx,%eax
  800a4b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	7e 06                	jle    800a5a <vprintfmt+0x17f>
  800a54:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800a58:	75 0d                	jne    800a67 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a5d:	89 c7                	mov    %eax,%edi
  800a5f:	03 45 e0             	add    -0x20(%ebp),%eax
  800a62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a65:	eb 55                	jmp    800abc <vprintfmt+0x1e1>
  800a67:	83 ec 08             	sub    $0x8,%esp
  800a6a:	ff 75 d8             	pushl  -0x28(%ebp)
  800a6d:	ff 75 cc             	pushl  -0x34(%ebp)
  800a70:	e8 46 03 00 00       	call   800dbb <strnlen>
  800a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a78:	29 c2                	sub    %eax,%edx
  800a7a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800a7d:	83 c4 10             	add    $0x10,%esp
  800a80:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800a82:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	7e 11                	jle    800a9e <vprintfmt+0x1c3>
					putch(padc, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	53                   	push   %ebx
  800a91:	ff 75 e0             	pushl  -0x20(%ebp)
  800a94:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a96:	83 ef 01             	sub    $0x1,%edi
  800a99:	83 c4 10             	add    $0x10,%esp
  800a9c:	eb eb                	jmp    800a89 <vprintfmt+0x1ae>
  800a9e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800aa1:	85 d2                	test   %edx,%edx
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	0f 49 c2             	cmovns %edx,%eax
  800aab:	29 c2                	sub    %eax,%edx
  800aad:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800ab0:	eb a8                	jmp    800a5a <vprintfmt+0x17f>
					putch(ch, putdat);
  800ab2:	83 ec 08             	sub    $0x8,%esp
  800ab5:	53                   	push   %ebx
  800ab6:	52                   	push   %edx
  800ab7:	ff d6                	call   *%esi
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800abf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac1:	83 c7 01             	add    $0x1,%edi
  800ac4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ac8:	0f be d0             	movsbl %al,%edx
  800acb:	85 d2                	test   %edx,%edx
  800acd:	74 4b                	je     800b1a <vprintfmt+0x23f>
  800acf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ad3:	78 06                	js     800adb <vprintfmt+0x200>
  800ad5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800ad9:	78 1e                	js     800af9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800adb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800adf:	74 d1                	je     800ab2 <vprintfmt+0x1d7>
  800ae1:	0f be c0             	movsbl %al,%eax
  800ae4:	83 e8 20             	sub    $0x20,%eax
  800ae7:	83 f8 5e             	cmp    $0x5e,%eax
  800aea:	76 c6                	jbe    800ab2 <vprintfmt+0x1d7>
					putch('?', putdat);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	53                   	push   %ebx
  800af0:	6a 3f                	push   $0x3f
  800af2:	ff d6                	call   *%esi
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	eb c3                	jmp    800abc <vprintfmt+0x1e1>
  800af9:	89 cf                	mov    %ecx,%edi
  800afb:	eb 0e                	jmp    800b0b <vprintfmt+0x230>
				putch(' ', putdat);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	53                   	push   %ebx
  800b01:	6a 20                	push   $0x20
  800b03:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b05:	83 ef 01             	sub    $0x1,%edi
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	85 ff                	test   %edi,%edi
  800b0d:	7f ee                	jg     800afd <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	e9 67 01 00 00       	jmp    800c81 <vprintfmt+0x3a6>
  800b1a:	89 cf                	mov    %ecx,%edi
  800b1c:	eb ed                	jmp    800b0b <vprintfmt+0x230>
	if (lflag >= 2)
  800b1e:	83 f9 01             	cmp    $0x1,%ecx
  800b21:	7f 1b                	jg     800b3e <vprintfmt+0x263>
	else if (lflag)
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	74 63                	je     800b8a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b2f:	99                   	cltd   
  800b30:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b33:	8b 45 14             	mov    0x14(%ebp),%eax
  800b36:	8d 40 04             	lea    0x4(%eax),%eax
  800b39:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	8b 50 04             	mov    0x4(%eax),%edx
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b49:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	8d 40 08             	lea    0x8(%eax),%eax
  800b52:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800b55:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b58:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800b5b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b60:	85 c9                	test   %ecx,%ecx
  800b62:	0f 89 ff 00 00 00    	jns    800c67 <vprintfmt+0x38c>
				putch('-', putdat);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	53                   	push   %ebx
  800b6c:	6a 2d                	push   $0x2d
  800b6e:	ff d6                	call   *%esi
				num = -(long long) num;
  800b70:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b73:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b76:	f7 da                	neg    %edx
  800b78:	83 d1 00             	adc    $0x0,%ecx
  800b7b:	f7 d9                	neg    %ecx
  800b7d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800b80:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b85:	e9 dd 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800b8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b92:	99                   	cltd   
  800b93:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b96:	8b 45 14             	mov    0x14(%ebp),%eax
  800b99:	8d 40 04             	lea    0x4(%eax),%eax
  800b9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b9f:	eb b4                	jmp    800b55 <vprintfmt+0x27a>
	if (lflag >= 2)
  800ba1:	83 f9 01             	cmp    $0x1,%ecx
  800ba4:	7f 1e                	jg     800bc4 <vprintfmt+0x2e9>
	else if (lflag)
  800ba6:	85 c9                	test   %ecx,%ecx
  800ba8:	74 32                	je     800bdc <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	8b 10                	mov    (%eax),%edx
  800baf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb4:	8d 40 04             	lea    0x4(%eax),%eax
  800bb7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800bbf:	e9 a3 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc7:	8b 10                	mov    (%eax),%edx
  800bc9:	8b 48 04             	mov    0x4(%eax),%ecx
  800bcc:	8d 40 08             	lea    0x8(%eax),%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bd2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800bd7:	e9 8b 00 00 00       	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdf:	8b 10                	mov    (%eax),%edx
  800be1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800be6:	8d 40 04             	lea    0x4(%eax),%eax
  800be9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bec:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800bf1:	eb 74                	jmp    800c67 <vprintfmt+0x38c>
	if (lflag >= 2)
  800bf3:	83 f9 01             	cmp    $0x1,%ecx
  800bf6:	7f 1b                	jg     800c13 <vprintfmt+0x338>
	else if (lflag)
  800bf8:	85 c9                	test   %ecx,%ecx
  800bfa:	74 2c                	je     800c28 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	8b 10                	mov    (%eax),%edx
  800c01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c06:	8d 40 04             	lea    0x4(%eax),%eax
  800c09:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c0c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800c11:	eb 54                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800c13:	8b 45 14             	mov    0x14(%ebp),%eax
  800c16:	8b 10                	mov    (%eax),%edx
  800c18:	8b 48 04             	mov    0x4(%eax),%ecx
  800c1b:	8d 40 08             	lea    0x8(%eax),%eax
  800c1e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c21:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800c26:	eb 3f                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800c28:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2b:	8b 10                	mov    (%eax),%edx
  800c2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c32:	8d 40 04             	lea    0x4(%eax),%eax
  800c35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c38:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800c3d:	eb 28                	jmp    800c67 <vprintfmt+0x38c>
			putch('0', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	53                   	push   %ebx
  800c43:	6a 30                	push   $0x30
  800c45:	ff d6                	call   *%esi
			putch('x', putdat);
  800c47:	83 c4 08             	add    $0x8,%esp
  800c4a:	53                   	push   %ebx
  800c4b:	6a 78                	push   $0x78
  800c4d:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	8b 10                	mov    (%eax),%edx
  800c54:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c59:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c5c:	8d 40 04             	lea    0x4(%eax),%eax
  800c5f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c62:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800c6e:	57                   	push   %edi
  800c6f:	ff 75 e0             	pushl  -0x20(%ebp)
  800c72:	50                   	push   %eax
  800c73:	51                   	push   %ecx
  800c74:	52                   	push   %edx
  800c75:	89 da                	mov    %ebx,%edx
  800c77:	89 f0                	mov    %esi,%eax
  800c79:	e8 72 fb ff ff       	call   8007f0 <printnum>
			break;
  800c7e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800c81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c84:	83 c7 01             	add    $0x1,%edi
  800c87:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c8b:	83 f8 25             	cmp    $0x25,%eax
  800c8e:	0f 84 62 fc ff ff    	je     8008f6 <vprintfmt+0x1b>
			if (ch == '\0')
  800c94:	85 c0                	test   %eax,%eax
  800c96:	0f 84 8b 00 00 00    	je     800d27 <vprintfmt+0x44c>
			putch(ch, putdat);
  800c9c:	83 ec 08             	sub    $0x8,%esp
  800c9f:	53                   	push   %ebx
  800ca0:	50                   	push   %eax
  800ca1:	ff d6                	call   *%esi
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	eb dc                	jmp    800c84 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800ca8:	83 f9 01             	cmp    $0x1,%ecx
  800cab:	7f 1b                	jg     800cc8 <vprintfmt+0x3ed>
	else if (lflag)
  800cad:	85 c9                	test   %ecx,%ecx
  800caf:	74 2c                	je     800cdd <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800cb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb4:	8b 10                	mov    (%eax),%edx
  800cb6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbb:	8d 40 04             	lea    0x4(%eax),%eax
  800cbe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cc1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800cc6:	eb 9f                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccb:	8b 10                	mov    (%eax),%edx
  800ccd:	8b 48 04             	mov    0x4(%eax),%ecx
  800cd0:	8d 40 08             	lea    0x8(%eax),%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cd6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800cdb:	eb 8a                	jmp    800c67 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	8b 10                	mov    (%eax),%edx
  800ce2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce7:	8d 40 04             	lea    0x4(%eax),%eax
  800cea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ced:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800cf2:	e9 70 ff ff ff       	jmp    800c67 <vprintfmt+0x38c>
			putch(ch, putdat);
  800cf7:	83 ec 08             	sub    $0x8,%esp
  800cfa:	53                   	push   %ebx
  800cfb:	6a 25                	push   $0x25
  800cfd:	ff d6                	call   *%esi
			break;
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	e9 7a ff ff ff       	jmp    800c81 <vprintfmt+0x3a6>
			putch('%', putdat);
  800d07:	83 ec 08             	sub    $0x8,%esp
  800d0a:	53                   	push   %ebx
  800d0b:	6a 25                	push   $0x25
  800d0d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0f:	83 c4 10             	add    $0x10,%esp
  800d12:	89 f8                	mov    %edi,%eax
  800d14:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d18:	74 05                	je     800d1f <vprintfmt+0x444>
  800d1a:	83 e8 01             	sub    $0x1,%eax
  800d1d:	eb f5                	jmp    800d14 <vprintfmt+0x439>
  800d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d22:	e9 5a ff ff ff       	jmp    800c81 <vprintfmt+0x3a6>
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d2f:	f3 0f 1e fb          	endbr32 
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 18             	sub    $0x18,%esp
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d42:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d46:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	74 26                	je     800d7a <vsnprintf+0x4b>
  800d54:	85 d2                	test   %edx,%edx
  800d56:	7e 22                	jle    800d7a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d58:	ff 75 14             	pushl  0x14(%ebp)
  800d5b:	ff 75 10             	pushl  0x10(%ebp)
  800d5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d61:	50                   	push   %eax
  800d62:	68 99 08 80 00       	push   $0x800899
  800d67:	e8 6f fb ff ff       	call   8008db <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d75:	83 c4 10             	add    $0x10,%esp
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    
		return -E_INVAL;
  800d7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d7f:	eb f7                	jmp    800d78 <vsnprintf+0x49>

00800d81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d81:	f3 0f 1e fb          	endbr32 
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800d8e:	50                   	push   %eax
  800d8f:	ff 75 10             	pushl  0x10(%ebp)
  800d92:	ff 75 0c             	pushl  0xc(%ebp)
  800d95:	ff 75 08             	pushl  0x8(%ebp)
  800d98:	e8 92 ff ff ff       	call   800d2f <vsnprintf>
	va_end(ap);

	return rc;
}
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800db2:	74 05                	je     800db9 <strlen+0x1a>
		n++;
  800db4:	83 c0 01             	add    $0x1,%eax
  800db7:	eb f5                	jmp    800dae <strlen+0xf>
	return n;
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dbb:	f3 0f 1e fb          	endbr32 
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800dcd:	39 d0                	cmp    %edx,%eax
  800dcf:	74 0d                	je     800dde <strnlen+0x23>
  800dd1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800dd5:	74 05                	je     800ddc <strnlen+0x21>
		n++;
  800dd7:	83 c0 01             	add    $0x1,%eax
  800dda:	eb f1                	jmp    800dcd <strnlen+0x12>
  800ddc:	89 c2                	mov    %eax,%edx
	return n;
}
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    

00800de2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de2:	f3 0f 1e fb          	endbr32 
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	53                   	push   %ebx
  800dea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ded:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800df9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800dfc:	83 c0 01             	add    $0x1,%eax
  800dff:	84 d2                	test   %dl,%dl
  800e01:	75 f2                	jne    800df5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800e03:	89 c8                	mov    %ecx,%eax
  800e05:	5b                   	pop    %ebx
  800e06:	5d                   	pop    %ebp
  800e07:	c3                   	ret    

00800e08 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e08:	f3 0f 1e fb          	endbr32 
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 10             	sub    $0x10,%esp
  800e13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e16:	53                   	push   %ebx
  800e17:	e8 83 ff ff ff       	call   800d9f <strlen>
  800e1c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	01 d8                	add    %ebx,%eax
  800e24:	50                   	push   %eax
  800e25:	e8 b8 ff ff ff       	call   800de2 <strcpy>
	return dst;
}
  800e2a:	89 d8                	mov    %ebx,%eax
  800e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e31:	f3 0f 1e fb          	endbr32 
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	8b 75 08             	mov    0x8(%ebp),%esi
  800e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e40:	89 f3                	mov    %esi,%ebx
  800e42:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e45:	89 f0                	mov    %esi,%eax
  800e47:	39 d8                	cmp    %ebx,%eax
  800e49:	74 11                	je     800e5c <strncpy+0x2b>
		*dst++ = *src;
  800e4b:	83 c0 01             	add    $0x1,%eax
  800e4e:	0f b6 0a             	movzbl (%edx),%ecx
  800e51:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e54:	80 f9 01             	cmp    $0x1,%cl
  800e57:	83 da ff             	sbb    $0xffffffff,%edx
  800e5a:	eb eb                	jmp    800e47 <strncpy+0x16>
	}
	return ret;
}
  800e5c:	89 f0                	mov    %esi,%eax
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e62:	f3 0f 1e fb          	endbr32 
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	8b 55 10             	mov    0x10(%ebp),%edx
  800e74:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e76:	85 d2                	test   %edx,%edx
  800e78:	74 21                	je     800e9b <strlcpy+0x39>
  800e7a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800e7e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800e80:	39 c2                	cmp    %eax,%edx
  800e82:	74 14                	je     800e98 <strlcpy+0x36>
  800e84:	0f b6 19             	movzbl (%ecx),%ebx
  800e87:	84 db                	test   %bl,%bl
  800e89:	74 0b                	je     800e96 <strlcpy+0x34>
			*dst++ = *src++;
  800e8b:	83 c1 01             	add    $0x1,%ecx
  800e8e:	83 c2 01             	add    $0x1,%edx
  800e91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800e94:	eb ea                	jmp    800e80 <strlcpy+0x1e>
  800e96:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800e98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e9b:	29 f0                	sub    %esi,%eax
}
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea1:	f3 0f 1e fb          	endbr32 
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800eae:	0f b6 01             	movzbl (%ecx),%eax
  800eb1:	84 c0                	test   %al,%al
  800eb3:	74 0c                	je     800ec1 <strcmp+0x20>
  800eb5:	3a 02                	cmp    (%edx),%al
  800eb7:	75 08                	jne    800ec1 <strcmp+0x20>
		p++, q++;
  800eb9:	83 c1 01             	add    $0x1,%ecx
  800ebc:	83 c2 01             	add    $0x1,%edx
  800ebf:	eb ed                	jmp    800eae <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec1:	0f b6 c0             	movzbl %al,%eax
  800ec4:	0f b6 12             	movzbl (%edx),%edx
  800ec7:	29 d0                	sub    %edx,%eax
}
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ecb:	f3 0f 1e fb          	endbr32 
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	53                   	push   %ebx
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed9:	89 c3                	mov    %eax,%ebx
  800edb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strncmp+0x1b>
		n--, p++, q++;
  800ee0:	83 c0 01             	add    $0x1,%eax
  800ee3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ee6:	39 d8                	cmp    %ebx,%eax
  800ee8:	74 16                	je     800f00 <strncmp+0x35>
  800eea:	0f b6 08             	movzbl (%eax),%ecx
  800eed:	84 c9                	test   %cl,%cl
  800eef:	74 04                	je     800ef5 <strncmp+0x2a>
  800ef1:	3a 0a                	cmp    (%edx),%cl
  800ef3:	74 eb                	je     800ee0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef5:	0f b6 00             	movzbl (%eax),%eax
  800ef8:	0f b6 12             	movzbl (%edx),%edx
  800efb:	29 d0                	sub    %edx,%eax
}
  800efd:	5b                   	pop    %ebx
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    
		return 0;
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
  800f05:	eb f6                	jmp    800efd <strncmp+0x32>

00800f07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f07:	f3 0f 1e fb          	endbr32 
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f15:	0f b6 10             	movzbl (%eax),%edx
  800f18:	84 d2                	test   %dl,%dl
  800f1a:	74 09                	je     800f25 <strchr+0x1e>
		if (*s == c)
  800f1c:	38 ca                	cmp    %cl,%dl
  800f1e:	74 0a                	je     800f2a <strchr+0x23>
	for (; *s; s++)
  800f20:	83 c0 01             	add    $0x1,%eax
  800f23:	eb f0                	jmp    800f15 <strchr+0xe>
			return (char *) s;
	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f2c:	f3 0f 1e fb          	endbr32 
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f3a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800f3d:	38 ca                	cmp    %cl,%dl
  800f3f:	74 09                	je     800f4a <strfind+0x1e>
  800f41:	84 d2                	test   %dl,%dl
  800f43:	74 05                	je     800f4a <strfind+0x1e>
	for (; *s; s++)
  800f45:	83 c0 01             	add    $0x1,%eax
  800f48:	eb f0                	jmp    800f3a <strfind+0xe>
			break;
	return (char *) s;
}
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f4c:	f3 0f 1e fb          	endbr32 
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f5c:	85 c9                	test   %ecx,%ecx
  800f5e:	74 31                	je     800f91 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f60:	89 f8                	mov    %edi,%eax
  800f62:	09 c8                	or     %ecx,%eax
  800f64:	a8 03                	test   $0x3,%al
  800f66:	75 23                	jne    800f8b <memset+0x3f>
		c &= 0xFF;
  800f68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f6c:	89 d3                	mov    %edx,%ebx
  800f6e:	c1 e3 08             	shl    $0x8,%ebx
  800f71:	89 d0                	mov    %edx,%eax
  800f73:	c1 e0 18             	shl    $0x18,%eax
  800f76:	89 d6                	mov    %edx,%esi
  800f78:	c1 e6 10             	shl    $0x10,%esi
  800f7b:	09 f0                	or     %esi,%eax
  800f7d:	09 c2                	or     %eax,%edx
  800f7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f84:	89 d0                	mov    %edx,%eax
  800f86:	fc                   	cld    
  800f87:	f3 ab                	rep stos %eax,%es:(%edi)
  800f89:	eb 06                	jmp    800f91 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	fc                   	cld    
  800f8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f91:	89 f8                	mov    %edi,%eax
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f98:	f3 0f 1e fb          	endbr32 
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800faa:	39 c6                	cmp    %eax,%esi
  800fac:	73 32                	jae    800fe0 <memmove+0x48>
  800fae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800fb1:	39 c2                	cmp    %eax,%edx
  800fb3:	76 2b                	jbe    800fe0 <memmove+0x48>
		s += n;
		d += n;
  800fb5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fb8:	89 fe                	mov    %edi,%esi
  800fba:	09 ce                	or     %ecx,%esi
  800fbc:	09 d6                	or     %edx,%esi
  800fbe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fc4:	75 0e                	jne    800fd4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fc6:	83 ef 04             	sub    $0x4,%edi
  800fc9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fcc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800fcf:	fd                   	std    
  800fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fd2:	eb 09                	jmp    800fdd <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fd4:	83 ef 01             	sub    $0x1,%edi
  800fd7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800fda:	fd                   	std    
  800fdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fdd:	fc                   	cld    
  800fde:	eb 1a                	jmp    800ffa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	09 ca                	or     %ecx,%edx
  800fe4:	09 f2                	or     %esi,%edx
  800fe6:	f6 c2 03             	test   $0x3,%dl
  800fe9:	75 0a                	jne    800ff5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800feb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fee:	89 c7                	mov    %eax,%edi
  800ff0:	fc                   	cld    
  800ff1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ff3:	eb 05                	jmp    800ffa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800ff5:	89 c7                	mov    %eax,%edi
  800ff7:	fc                   	cld    
  800ff8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ffa:	5e                   	pop    %esi
  800ffb:	5f                   	pop    %edi
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ffe:	f3 0f 1e fb          	endbr32 
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801008:	ff 75 10             	pushl  0x10(%ebp)
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	ff 75 08             	pushl  0x8(%ebp)
  801011:	e8 82 ff ff ff       	call   800f98 <memmove>
}
  801016:	c9                   	leave  
  801017:	c3                   	ret    

00801018 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801018:	f3 0f 1e fb          	endbr32 
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8b 55 0c             	mov    0xc(%ebp),%edx
  801027:	89 c6                	mov    %eax,%esi
  801029:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80102c:	39 f0                	cmp    %esi,%eax
  80102e:	74 1c                	je     80104c <memcmp+0x34>
		if (*s1 != *s2)
  801030:	0f b6 08             	movzbl (%eax),%ecx
  801033:	0f b6 1a             	movzbl (%edx),%ebx
  801036:	38 d9                	cmp    %bl,%cl
  801038:	75 08                	jne    801042 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80103a:	83 c0 01             	add    $0x1,%eax
  80103d:	83 c2 01             	add    $0x1,%edx
  801040:	eb ea                	jmp    80102c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  801042:	0f b6 c1             	movzbl %cl,%eax
  801045:	0f b6 db             	movzbl %bl,%ebx
  801048:	29 d8                	sub    %ebx,%eax
  80104a:	eb 05                	jmp    801051 <memcmp+0x39>
	}

	return 0;
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801055:	f3 0f 1e fb          	endbr32 
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801062:	89 c2                	mov    %eax,%edx
  801064:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801067:	39 d0                	cmp    %edx,%eax
  801069:	73 09                	jae    801074 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106b:	38 08                	cmp    %cl,(%eax)
  80106d:	74 05                	je     801074 <memfind+0x1f>
	for (; s < ends; s++)
  80106f:	83 c0 01             	add    $0x1,%eax
  801072:	eb f3                	jmp    801067 <memfind+0x12>
			break;
	return (void *) s;
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801083:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801086:	eb 03                	jmp    80108b <strtol+0x15>
		s++;
  801088:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80108b:	0f b6 01             	movzbl (%ecx),%eax
  80108e:	3c 20                	cmp    $0x20,%al
  801090:	74 f6                	je     801088 <strtol+0x12>
  801092:	3c 09                	cmp    $0x9,%al
  801094:	74 f2                	je     801088 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801096:	3c 2b                	cmp    $0x2b,%al
  801098:	74 2a                	je     8010c4 <strtol+0x4e>
	int neg = 0;
  80109a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  80109f:	3c 2d                	cmp    $0x2d,%al
  8010a1:	74 2b                	je     8010ce <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8010a9:	75 0f                	jne    8010ba <strtol+0x44>
  8010ab:	80 39 30             	cmpb   $0x30,(%ecx)
  8010ae:	74 28                	je     8010d8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010b0:	85 db                	test   %ebx,%ebx
  8010b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010b7:	0f 44 d8             	cmove  %eax,%ebx
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010c2:	eb 46                	jmp    80110a <strtol+0x94>
		s++;
  8010c4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  8010c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8010cc:	eb d5                	jmp    8010a3 <strtol+0x2d>
		s++, neg = 1;
  8010ce:	83 c1 01             	add    $0x1,%ecx
  8010d1:	bf 01 00 00 00       	mov    $0x1,%edi
  8010d6:	eb cb                	jmp    8010a3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8010dc:	74 0e                	je     8010ec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  8010de:	85 db                	test   %ebx,%ebx
  8010e0:	75 d8                	jne    8010ba <strtol+0x44>
		s++, base = 8;
  8010e2:	83 c1 01             	add    $0x1,%ecx
  8010e5:	bb 08 00 00 00       	mov    $0x8,%ebx
  8010ea:	eb ce                	jmp    8010ba <strtol+0x44>
		s += 2, base = 16;
  8010ec:	83 c1 02             	add    $0x2,%ecx
  8010ef:	bb 10 00 00 00       	mov    $0x10,%ebx
  8010f4:	eb c4                	jmp    8010ba <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8010f6:	0f be d2             	movsbl %dl,%edx
  8010f9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010fc:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010ff:	7d 3a                	jge    80113b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801101:	83 c1 01             	add    $0x1,%ecx
  801104:	0f af 45 10          	imul   0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80110a:	0f b6 11             	movzbl (%ecx),%edx
  80110d:	8d 72 d0             	lea    -0x30(%edx),%esi
  801110:	89 f3                	mov    %esi,%ebx
  801112:	80 fb 09             	cmp    $0x9,%bl
  801115:	76 df                	jbe    8010f6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801117:	8d 72 9f             	lea    -0x61(%edx),%esi
  80111a:	89 f3                	mov    %esi,%ebx
  80111c:	80 fb 19             	cmp    $0x19,%bl
  80111f:	77 08                	ja     801129 <strtol+0xb3>
			dig = *s - 'a' + 10;
  801121:	0f be d2             	movsbl %dl,%edx
  801124:	83 ea 57             	sub    $0x57,%edx
  801127:	eb d3                	jmp    8010fc <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  801129:	8d 72 bf             	lea    -0x41(%edx),%esi
  80112c:	89 f3                	mov    %esi,%ebx
  80112e:	80 fb 19             	cmp    $0x19,%bl
  801131:	77 08                	ja     80113b <strtol+0xc5>
			dig = *s - 'A' + 10;
  801133:	0f be d2             	movsbl %dl,%edx
  801136:	83 ea 37             	sub    $0x37,%edx
  801139:	eb c1                	jmp    8010fc <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  80113b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113f:	74 05                	je     801146 <strtol+0xd0>
		*endptr = (char *) s;
  801141:	8b 75 0c             	mov    0xc(%ebp),%esi
  801144:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801146:	89 c2                	mov    %eax,%edx
  801148:	f7 da                	neg    %edx
  80114a:	85 ff                	test   %edi,%edi
  80114c:	0f 45 c2             	cmovne %edx,%eax
}
  80114f:	5b                   	pop    %ebx
  801150:	5e                   	pop    %esi
  801151:	5f                   	pop    %edi
  801152:	5d                   	pop    %ebp
  801153:	c3                   	ret    

00801154 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801154:	f3 0f 1e fb          	endbr32 
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	57                   	push   %edi
  80115c:	56                   	push   %esi
  80115d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	89 c3                	mov    %eax,%ebx
  80116b:	89 c7                	mov    %eax,%edi
  80116d:	89 c6                	mov    %eax,%esi
  80116f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801171:	5b                   	pop    %ebx
  801172:	5e                   	pop    %esi
  801173:	5f                   	pop    %edi
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <sys_cgetc>:

int
sys_cgetc(void)
{
  801176:	f3 0f 1e fb          	endbr32 
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	57                   	push   %edi
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801180:	ba 00 00 00 00       	mov    $0x0,%edx
  801185:	b8 01 00 00 00       	mov    $0x1,%eax
  80118a:	89 d1                	mov    %edx,%ecx
  80118c:	89 d3                	mov    %edx,%ebx
  80118e:	89 d7                	mov    %edx,%edi
  801190:	89 d6                	mov    %edx,%esi
  801192:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801199:	f3 0f 1e fb          	endbr32 
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b3:	89 cb                	mov    %ecx,%ebx
  8011b5:	89 cf                	mov    %ecx,%edi
  8011b7:	89 ce                	mov    %ecx,%esi
  8011b9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	7f 08                	jg     8011c7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5f                   	pop    %edi
  8011c5:	5d                   	pop    %ebp
  8011c6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	50                   	push   %eax
  8011cb:	6a 03                	push   $0x3
  8011cd:	68 1f 31 80 00       	push   $0x80311f
  8011d2:	6a 23                	push   $0x23
  8011d4:	68 3c 31 80 00       	push   $0x80313c
  8011d9:	e8 13 f5 ff ff       	call   8006f1 <_panic>

008011de <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011de:	f3 0f 1e fb          	endbr32 
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
  8011e5:	57                   	push   %edi
  8011e6:	56                   	push   %esi
  8011e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ed:	b8 02 00 00 00       	mov    $0x2,%eax
  8011f2:	89 d1                	mov    %edx,%ecx
  8011f4:	89 d3                	mov    %edx,%ebx
  8011f6:	89 d7                	mov    %edx,%edi
  8011f8:	89 d6                	mov    %edx,%esi
  8011fa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <sys_yield>:

void
sys_yield(void)
{
  801201:	f3 0f 1e fb          	endbr32 
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
  801210:	b8 0b 00 00 00       	mov    $0xb,%eax
  801215:	89 d1                	mov    %edx,%ecx
  801217:	89 d3                	mov    %edx,%ebx
  801219:	89 d7                	mov    %edx,%edi
  80121b:	89 d6                	mov    %edx,%esi
  80121d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80121f:	5b                   	pop    %ebx
  801220:	5e                   	pop    %esi
  801221:	5f                   	pop    %edi
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    

00801224 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801224:	f3 0f 1e fb          	endbr32 
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	57                   	push   %edi
  80122c:	56                   	push   %esi
  80122d:	53                   	push   %ebx
  80122e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801231:	be 00 00 00 00       	mov    $0x0,%esi
  801236:	8b 55 08             	mov    0x8(%ebp),%edx
  801239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123c:	b8 04 00 00 00       	mov    $0x4,%eax
  801241:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801244:	89 f7                	mov    %esi,%edi
  801246:	cd 30                	int    $0x30
	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7f 08                	jg     801254 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124f:	5b                   	pop    %ebx
  801250:	5e                   	pop    %esi
  801251:	5f                   	pop    %edi
  801252:	5d                   	pop    %ebp
  801253:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	50                   	push   %eax
  801258:	6a 04                	push   $0x4
  80125a:	68 1f 31 80 00       	push   $0x80311f
  80125f:	6a 23                	push   $0x23
  801261:	68 3c 31 80 00       	push   $0x80313c
  801266:	e8 86 f4 ff ff       	call   8006f1 <_panic>

0080126b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80126b:	f3 0f 1e fb          	endbr32 
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	57                   	push   %edi
  801273:	56                   	push   %esi
  801274:	53                   	push   %ebx
  801275:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127e:	b8 05 00 00 00       	mov    $0x5,%eax
  801283:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801286:	8b 7d 14             	mov    0x14(%ebp),%edi
  801289:	8b 75 18             	mov    0x18(%ebp),%esi
  80128c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80128e:	85 c0                	test   %eax,%eax
  801290:	7f 08                	jg     80129a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	50                   	push   %eax
  80129e:	6a 05                	push   $0x5
  8012a0:	68 1f 31 80 00       	push   $0x80311f
  8012a5:	6a 23                	push   $0x23
  8012a7:	68 3c 31 80 00       	push   $0x80313c
  8012ac:	e8 40 f4 ff ff       	call   8006f1 <_panic>

008012b1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012b1:	f3 0f 1e fb          	endbr32 
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	57                   	push   %edi
  8012b9:	56                   	push   %esi
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8012ce:	89 df                	mov    %ebx,%edi
  8012d0:	89 de                	mov    %ebx,%esi
  8012d2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	7f 08                	jg     8012e0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	50                   	push   %eax
  8012e4:	6a 06                	push   $0x6
  8012e6:	68 1f 31 80 00       	push   $0x80311f
  8012eb:	6a 23                	push   $0x23
  8012ed:	68 3c 31 80 00       	push   $0x80313c
  8012f2:	e8 fa f3 ff ff       	call   8006f1 <_panic>

008012f7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012f7:	f3 0f 1e fb          	endbr32 
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
  801301:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
  801309:	8b 55 08             	mov    0x8(%ebp),%edx
  80130c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130f:	b8 08 00 00 00       	mov    $0x8,%eax
  801314:	89 df                	mov    %ebx,%edi
  801316:	89 de                	mov    %ebx,%esi
  801318:	cd 30                	int    $0x30
	if(check && ret > 0)
  80131a:	85 c0                	test   %eax,%eax
  80131c:	7f 08                	jg     801326 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80131e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801321:	5b                   	pop    %ebx
  801322:	5e                   	pop    %esi
  801323:	5f                   	pop    %edi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801326:	83 ec 0c             	sub    $0xc,%esp
  801329:	50                   	push   %eax
  80132a:	6a 08                	push   $0x8
  80132c:	68 1f 31 80 00       	push   $0x80311f
  801331:	6a 23                	push   $0x23
  801333:	68 3c 31 80 00       	push   $0x80313c
  801338:	e8 b4 f3 ff ff       	call   8006f1 <_panic>

0080133d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80133d:	f3 0f 1e fb          	endbr32 
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	57                   	push   %edi
  801345:	56                   	push   %esi
  801346:	53                   	push   %ebx
  801347:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80134a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80134f:	8b 55 08             	mov    0x8(%ebp),%edx
  801352:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801355:	b8 09 00 00 00       	mov    $0x9,%eax
  80135a:	89 df                	mov    %ebx,%edi
  80135c:	89 de                	mov    %ebx,%esi
  80135e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801360:	85 c0                	test   %eax,%eax
  801362:	7f 08                	jg     80136c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5f                   	pop    %edi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	50                   	push   %eax
  801370:	6a 09                	push   $0x9
  801372:	68 1f 31 80 00       	push   $0x80311f
  801377:	6a 23                	push   $0x23
  801379:	68 3c 31 80 00       	push   $0x80313c
  80137e:	e8 6e f3 ff ff       	call   8006f1 <_panic>

00801383 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801383:	f3 0f 1e fb          	endbr32 
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	57                   	push   %edi
  80138b:	56                   	push   %esi
  80138c:	53                   	push   %ebx
  80138d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801390:	bb 00 00 00 00       	mov    $0x0,%ebx
  801395:	8b 55 08             	mov    0x8(%ebp),%edx
  801398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013a0:	89 df                	mov    %ebx,%edi
  8013a2:	89 de                	mov    %ebx,%esi
  8013a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	7f 08                	jg     8013b2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	50                   	push   %eax
  8013b6:	6a 0a                	push   $0xa
  8013b8:	68 1f 31 80 00       	push   $0x80311f
  8013bd:	6a 23                	push   $0x23
  8013bf:	68 3c 31 80 00       	push   $0x80313c
  8013c4:	e8 28 f3 ff ff       	call   8006f1 <_panic>

008013c9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8013c9:	f3 0f 1e fb          	endbr32 
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d9:	b8 0c 00 00 00       	mov    $0xc,%eax
  8013de:	be 00 00 00 00       	mov    $0x0,%esi
  8013e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013e6:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013e9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013eb:	5b                   	pop    %ebx
  8013ec:	5e                   	pop    %esi
  8013ed:	5f                   	pop    %edi
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013f0:	f3 0f 1e fb          	endbr32 
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	57                   	push   %edi
  8013f8:	56                   	push   %esi
  8013f9:	53                   	push   %ebx
  8013fa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801402:	8b 55 08             	mov    0x8(%ebp),%edx
  801405:	b8 0d 00 00 00       	mov    $0xd,%eax
  80140a:	89 cb                	mov    %ecx,%ebx
  80140c:	89 cf                	mov    %ecx,%edi
  80140e:	89 ce                	mov    %ecx,%esi
  801410:	cd 30                	int    $0x30
	if(check && ret > 0)
  801412:	85 c0                	test   %eax,%eax
  801414:	7f 08                	jg     80141e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801416:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5f                   	pop    %edi
  80141c:	5d                   	pop    %ebp
  80141d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	50                   	push   %eax
  801422:	6a 0d                	push   $0xd
  801424:	68 1f 31 80 00       	push   $0x80311f
  801429:	6a 23                	push   $0x23
  80142b:	68 3c 31 80 00       	push   $0x80313c
  801430:	e8 bc f2 ff ff       	call   8006f1 <_panic>

00801435 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801435:	f3 0f 1e fb          	endbr32 
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	57                   	push   %edi
  80143d:	56                   	push   %esi
  80143e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80143f:	ba 00 00 00 00       	mov    $0x0,%edx
  801444:	b8 0e 00 00 00       	mov    $0xe,%eax
  801449:	89 d1                	mov    %edx,%ecx
  80144b:	89 d3                	mov    %edx,%ebx
  80144d:	89 d7                	mov    %edx,%edi
  80144f:	89 d6                	mov    %edx,%esi
  801451:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801453:	5b                   	pop    %ebx
  801454:	5e                   	pop    %esi
  801455:	5f                   	pop    %edi
  801456:	5d                   	pop    %ebp
  801457:	c3                   	ret    

00801458 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801458:	f3 0f 1e fb          	endbr32 
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	56                   	push   %esi
  801460:	53                   	push   %ebx
  801461:	8b 75 08             	mov    0x8(%ebp),%esi
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80146a:	83 e8 01             	sub    $0x1,%eax
  80146d:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801472:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801477:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	50                   	push   %eax
  80147f:	e8 6c ff ff ff       	call   8013f0 <sys_ipc_recv>
	if (!t) {
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	75 2b                	jne    8014b6 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80148b:	85 f6                	test   %esi,%esi
  80148d:	74 0a                	je     801499 <ipc_recv+0x41>
  80148f:	a1 08 50 80 00       	mov    0x805008,%eax
  801494:	8b 40 74             	mov    0x74(%eax),%eax
  801497:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  801499:	85 db                	test   %ebx,%ebx
  80149b:	74 0a                	je     8014a7 <ipc_recv+0x4f>
  80149d:	a1 08 50 80 00       	mov    0x805008,%eax
  8014a2:	8b 40 78             	mov    0x78(%eax),%eax
  8014a5:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8014a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ac:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8014af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5d                   	pop    %ebp
  8014b5:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8014b6:	85 f6                	test   %esi,%esi
  8014b8:	74 06                	je     8014c0 <ipc_recv+0x68>
  8014ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8014c0:	85 db                	test   %ebx,%ebx
  8014c2:	74 eb                	je     8014af <ipc_recv+0x57>
  8014c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014ca:	eb e3                	jmp    8014af <ipc_recv+0x57>

008014cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014cc:	f3 0f 1e fb          	endbr32 
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	57                   	push   %edi
  8014d4:	56                   	push   %esi
  8014d5:	53                   	push   %ebx
  8014d6:	83 ec 0c             	sub    $0xc,%esp
  8014d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8014e2:	85 db                	test   %ebx,%ebx
  8014e4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8014e9:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8014ec:	ff 75 14             	pushl  0x14(%ebp)
  8014ef:	53                   	push   %ebx
  8014f0:	56                   	push   %esi
  8014f1:	57                   	push   %edi
  8014f2:	e8 d2 fe ff ff       	call   8013c9 <sys_ipc_try_send>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 1e                	je     80151c <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8014fe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801501:	75 07                	jne    80150a <ipc_send+0x3e>
		sys_yield();
  801503:	e8 f9 fc ff ff       	call   801201 <sys_yield>
  801508:	eb e2                	jmp    8014ec <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80150a:	50                   	push   %eax
  80150b:	68 4a 31 80 00       	push   $0x80314a
  801510:	6a 39                	push   $0x39
  801512:	68 5c 31 80 00       	push   $0x80315c
  801517:	e8 d5 f1 ff ff       	call   8006f1 <_panic>
	}
	//panic("ipc_send not implemented");
}
  80151c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5f                   	pop    %edi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801533:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801536:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80153c:	8b 52 50             	mov    0x50(%edx),%edx
  80153f:	39 ca                	cmp    %ecx,%edx
  801541:	74 11                	je     801554 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801543:	83 c0 01             	add    $0x1,%eax
  801546:	3d 00 04 00 00       	cmp    $0x400,%eax
  80154b:	75 e6                	jne    801533 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 0b                	jmp    80155f <ipc_find_env+0x3b>
			return envs[i].env_id;
  801554:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801557:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80155c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    

00801561 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801561:	f3 0f 1e fb          	endbr32 
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	05 00 00 00 30       	add    $0x30000000,%eax
  801570:	c1 e8 0c             	shr    $0xc,%eax
}
  801573:	5d                   	pop    %ebp
  801574:	c3                   	ret    

00801575 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801575:	f3 0f 1e fb          	endbr32 
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801589:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801590:	f3 0f 1e fb          	endbr32 
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80159c:	89 c2                	mov    %eax,%edx
  80159e:	c1 ea 16             	shr    $0x16,%edx
  8015a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a8:	f6 c2 01             	test   $0x1,%dl
  8015ab:	74 2d                	je     8015da <fd_alloc+0x4a>
  8015ad:	89 c2                	mov    %eax,%edx
  8015af:	c1 ea 0c             	shr    $0xc,%edx
  8015b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b9:	f6 c2 01             	test   $0x1,%dl
  8015bc:	74 1c                	je     8015da <fd_alloc+0x4a>
  8015be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c8:	75 d2                	jne    80159c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015d8:	eb 0a                	jmp    8015e4 <fd_alloc+0x54>
			*fd_store = fd;
  8015da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e4:	5d                   	pop    %ebp
  8015e5:	c3                   	ret    

008015e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015e6:	f3 0f 1e fb          	endbr32 
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015f0:	83 f8 1f             	cmp    $0x1f,%eax
  8015f3:	77 30                	ja     801625 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f5:	c1 e0 0c             	shl    $0xc,%eax
  8015f8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015fd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801603:	f6 c2 01             	test   $0x1,%dl
  801606:	74 24                	je     80162c <fd_lookup+0x46>
  801608:	89 c2                	mov    %eax,%edx
  80160a:	c1 ea 0c             	shr    $0xc,%edx
  80160d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801614:	f6 c2 01             	test   $0x1,%dl
  801617:	74 1a                	je     801633 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	89 02                	mov    %eax,(%edx)
	return 0;
  80161e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    
		return -E_INVAL;
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80162a:	eb f7                	jmp    801623 <fd_lookup+0x3d>
		return -E_INVAL;
  80162c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801631:	eb f0                	jmp    801623 <fd_lookup+0x3d>
  801633:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801638:	eb e9                	jmp    801623 <fd_lookup+0x3d>

0080163a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80163a:	f3 0f 1e fb          	endbr32 
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	b8 08 40 80 00       	mov    $0x804008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801651:	39 08                	cmp    %ecx,(%eax)
  801653:	74 38                	je     80168d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801655:	83 c2 01             	add    $0x1,%edx
  801658:	8b 04 95 e4 31 80 00 	mov    0x8031e4(,%edx,4),%eax
  80165f:	85 c0                	test   %eax,%eax
  801661:	75 ee                	jne    801651 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801663:	a1 08 50 80 00       	mov    0x805008,%eax
  801668:	8b 40 48             	mov    0x48(%eax),%eax
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	51                   	push   %ecx
  80166f:	50                   	push   %eax
  801670:	68 68 31 80 00       	push   $0x803168
  801675:	e8 5e f1 ff ff       	call   8007d8 <cprintf>
	*dev = 0;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    
			*dev = devtab[i];
  80168d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801690:	89 01                	mov    %eax,(%ecx)
			return 0;
  801692:	b8 00 00 00 00       	mov    $0x0,%eax
  801697:	eb f2                	jmp    80168b <dev_lookup+0x51>

00801699 <fd_close>:
{
  801699:	f3 0f 1e fb          	endbr32 
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	57                   	push   %edi
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 24             	sub    $0x24,%esp
  8016a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016af:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016b6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016b9:	50                   	push   %eax
  8016ba:	e8 27 ff ff ff       	call   8015e6 <fd_lookup>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 05                	js     8016cd <fd_close+0x34>
	    || fd != fd2)
  8016c8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8016cb:	74 16                	je     8016e3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8016cd:	89 f8                	mov    %edi,%eax
  8016cf:	84 c0                	test   %al,%al
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	0f 44 d8             	cmove  %eax,%ebx
}
  8016d9:	89 d8                	mov    %ebx,%eax
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	ff 36                	pushl  (%esi)
  8016ec:	e8 49 ff ff ff       	call   80163a <dev_lookup>
  8016f1:	89 c3                	mov    %eax,%ebx
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 1a                	js     801714 <fd_close+0x7b>
		if (dev->dev_close)
  8016fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801700:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801705:	85 c0                	test   %eax,%eax
  801707:	74 0b                	je     801714 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801709:	83 ec 0c             	sub    $0xc,%esp
  80170c:	56                   	push   %esi
  80170d:	ff d0                	call   *%eax
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801714:	83 ec 08             	sub    $0x8,%esp
  801717:	56                   	push   %esi
  801718:	6a 00                	push   $0x0
  80171a:	e8 92 fb ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	eb b5                	jmp    8016d9 <fd_close+0x40>

00801724 <close>:

int
close(int fdnum)
{
  801724:	f3 0f 1e fb          	endbr32 
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801731:	50                   	push   %eax
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 ac fe ff ff       	call   8015e6 <fd_lookup>
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	85 c0                	test   %eax,%eax
  80173f:	79 02                	jns    801743 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    
		return fd_close(fd, 1);
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	6a 01                	push   $0x1
  801748:	ff 75 f4             	pushl  -0xc(%ebp)
  80174b:	e8 49 ff ff ff       	call   801699 <fd_close>
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	eb ec                	jmp    801741 <close+0x1d>

00801755 <close_all>:

void
close_all(void)
{
  801755:	f3 0f 1e fb          	endbr32 
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	53                   	push   %ebx
  80175d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801760:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	53                   	push   %ebx
  801769:	e8 b6 ff ff ff       	call   801724 <close>
	for (i = 0; i < MAXFD; i++)
  80176e:	83 c3 01             	add    $0x1,%ebx
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	83 fb 20             	cmp    $0x20,%ebx
  801777:	75 ec                	jne    801765 <close_all+0x10>
}
  801779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80177e:	f3 0f 1e fb          	endbr32 
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	57                   	push   %edi
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80178b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	ff 75 08             	pushl  0x8(%ebp)
  801792:	e8 4f fe ff ff       	call   8015e6 <fd_lookup>
  801797:	89 c3                	mov    %eax,%ebx
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	0f 88 81 00 00 00    	js     801825 <dup+0xa7>
		return r;
	close(newfdnum);
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	e8 75 ff ff ff       	call   801724 <close>

	newfd = INDEX2FD(newfdnum);
  8017af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017b2:	c1 e6 0c             	shl    $0xc,%esi
  8017b5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017bb:	83 c4 04             	add    $0x4,%esp
  8017be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c1:	e8 af fd ff ff       	call   801575 <fd2data>
  8017c6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017c8:	89 34 24             	mov    %esi,(%esp)
  8017cb:	e8 a5 fd ff ff       	call   801575 <fd2data>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017d5:	89 d8                	mov    %ebx,%eax
  8017d7:	c1 e8 16             	shr    $0x16,%eax
  8017da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e1:	a8 01                	test   $0x1,%al
  8017e3:	74 11                	je     8017f6 <dup+0x78>
  8017e5:	89 d8                	mov    %ebx,%eax
  8017e7:	c1 e8 0c             	shr    $0xc,%eax
  8017ea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017f1:	f6 c2 01             	test   $0x1,%dl
  8017f4:	75 39                	jne    80182f <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017f9:	89 d0                	mov    %edx,%eax
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
  8017fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	25 07 0e 00 00       	and    $0xe07,%eax
  80180d:	50                   	push   %eax
  80180e:	56                   	push   %esi
  80180f:	6a 00                	push   $0x0
  801811:	52                   	push   %edx
  801812:	6a 00                	push   $0x0
  801814:	e8 52 fa ff ff       	call   80126b <sys_page_map>
  801819:	89 c3                	mov    %eax,%ebx
  80181b:	83 c4 20             	add    $0x20,%esp
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 31                	js     801853 <dup+0xd5>
		goto err;

	return newfdnum;
  801822:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801825:	89 d8                	mov    %ebx,%eax
  801827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80182f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801836:	83 ec 0c             	sub    $0xc,%esp
  801839:	25 07 0e 00 00       	and    $0xe07,%eax
  80183e:	50                   	push   %eax
  80183f:	57                   	push   %edi
  801840:	6a 00                	push   $0x0
  801842:	53                   	push   %ebx
  801843:	6a 00                	push   $0x0
  801845:	e8 21 fa ff ff       	call   80126b <sys_page_map>
  80184a:	89 c3                	mov    %eax,%ebx
  80184c:	83 c4 20             	add    $0x20,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	79 a3                	jns    8017f6 <dup+0x78>
	sys_page_unmap(0, newfd);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	56                   	push   %esi
  801857:	6a 00                	push   $0x0
  801859:	e8 53 fa ff ff       	call   8012b1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80185e:	83 c4 08             	add    $0x8,%esp
  801861:	57                   	push   %edi
  801862:	6a 00                	push   $0x0
  801864:	e8 48 fa ff ff       	call   8012b1 <sys_page_unmap>
	return r;
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	eb b7                	jmp    801825 <dup+0xa7>

0080186e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186e:	f3 0f 1e fb          	endbr32 
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	53                   	push   %ebx
  801876:	83 ec 1c             	sub    $0x1c,%esp
  801879:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80187f:	50                   	push   %eax
  801880:	53                   	push   %ebx
  801881:	e8 60 fd ff ff       	call   8015e6 <fd_lookup>
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 3f                	js     8018cc <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188d:	83 ec 08             	sub    $0x8,%esp
  801890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801897:	ff 30                	pushl  (%eax)
  801899:	e8 9c fd ff ff       	call   80163a <dev_lookup>
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 27                	js     8018cc <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a8:	8b 42 08             	mov    0x8(%edx),%eax
  8018ab:	83 e0 03             	and    $0x3,%eax
  8018ae:	83 f8 01             	cmp    $0x1,%eax
  8018b1:	74 1e                	je     8018d1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b6:	8b 40 08             	mov    0x8(%eax),%eax
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	74 35                	je     8018f2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	ff 75 10             	pushl  0x10(%ebp)
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	52                   	push   %edx
  8018c7:	ff d0                	call   *%eax
  8018c9:	83 c4 10             	add    $0x10,%esp
}
  8018cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8018d6:	8b 40 48             	mov    0x48(%eax),%eax
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	53                   	push   %ebx
  8018dd:	50                   	push   %eax
  8018de:	68 a9 31 80 00       	push   $0x8031a9
  8018e3:	e8 f0 ee ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f0:	eb da                	jmp    8018cc <read+0x5e>
		return -E_NOT_SUPP;
  8018f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f7:	eb d3                	jmp    8018cc <read+0x5e>

008018f9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018f9:	f3 0f 1e fb          	endbr32 
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	57                   	push   %edi
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 0c             	sub    $0xc,%esp
  801906:	8b 7d 08             	mov    0x8(%ebp),%edi
  801909:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801911:	eb 02                	jmp    801915 <readn+0x1c>
  801913:	01 c3                	add    %eax,%ebx
  801915:	39 f3                	cmp    %esi,%ebx
  801917:	73 21                	jae    80193a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	89 f0                	mov    %esi,%eax
  80191e:	29 d8                	sub    %ebx,%eax
  801920:	50                   	push   %eax
  801921:	89 d8                	mov    %ebx,%eax
  801923:	03 45 0c             	add    0xc(%ebp),%eax
  801926:	50                   	push   %eax
  801927:	57                   	push   %edi
  801928:	e8 41 ff ff ff       	call   80186e <read>
		if (m < 0)
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 04                	js     801938 <readn+0x3f>
			return m;
		if (m == 0)
  801934:	75 dd                	jne    801913 <readn+0x1a>
  801936:	eb 02                	jmp    80193a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801938:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80193a:	89 d8                	mov    %ebx,%eax
  80193c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801944:	f3 0f 1e fb          	endbr32 
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	53                   	push   %ebx
  80194c:	83 ec 1c             	sub    $0x1c,%esp
  80194f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801952:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801955:	50                   	push   %eax
  801956:	53                   	push   %ebx
  801957:	e8 8a fc ff ff       	call   8015e6 <fd_lookup>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 3a                	js     80199d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801963:	83 ec 08             	sub    $0x8,%esp
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	50                   	push   %eax
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196d:	ff 30                	pushl  (%eax)
  80196f:	e8 c6 fc ff ff       	call   80163a <dev_lookup>
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 22                	js     80199d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801982:	74 1e                	je     8019a2 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801984:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801987:	8b 52 0c             	mov    0xc(%edx),%edx
  80198a:	85 d2                	test   %edx,%edx
  80198c:	74 35                	je     8019c3 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	ff d2                	call   *%edx
  80199a:	83 c4 10             	add    $0x10,%esp
}
  80199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019a2:	a1 08 50 80 00       	mov    0x805008,%eax
  8019a7:	8b 40 48             	mov    0x48(%eax),%eax
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	53                   	push   %ebx
  8019ae:	50                   	push   %eax
  8019af:	68 c5 31 80 00       	push   $0x8031c5
  8019b4:	e8 1f ee ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c1:	eb da                	jmp    80199d <write+0x59>
		return -E_NOT_SUPP;
  8019c3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c8:	eb d3                	jmp    80199d <write+0x59>

008019ca <seek>:

int
seek(int fdnum, off_t offset)
{
  8019ca:	f3 0f 1e fb          	endbr32 
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d7:	50                   	push   %eax
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	e8 06 fc ff ff       	call   8015e6 <fd_lookup>
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 0e                	js     8019f5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8019e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019f7:	f3 0f 1e fb          	endbr32 
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 1c             	sub    $0x1c,%esp
  801a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a05:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a08:	50                   	push   %eax
  801a09:	53                   	push   %ebx
  801a0a:	e8 d7 fb ff ff       	call   8015e6 <fd_lookup>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 37                	js     801a4d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1c:	50                   	push   %eax
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	ff 30                	pushl  (%eax)
  801a22:	e8 13 fc ff ff       	call   80163a <dev_lookup>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 1f                	js     801a4d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a31:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a35:	74 1b                	je     801a52 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3a:	8b 52 18             	mov    0x18(%edx),%edx
  801a3d:	85 d2                	test   %edx,%edx
  801a3f:	74 32                	je     801a73 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	ff d2                	call   *%edx
  801a4a:	83 c4 10             	add    $0x10,%esp
}
  801a4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a52:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a57:	8b 40 48             	mov    0x48(%eax),%eax
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	53                   	push   %ebx
  801a5e:	50                   	push   %eax
  801a5f:	68 88 31 80 00       	push   $0x803188
  801a64:	e8 6f ed ff ff       	call   8007d8 <cprintf>
		return -E_INVAL;
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a71:	eb da                	jmp    801a4d <ftruncate+0x56>
		return -E_NOT_SUPP;
  801a73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a78:	eb d3                	jmp    801a4d <ftruncate+0x56>

00801a7a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a7a:	f3 0f 1e fb          	endbr32 
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a88:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a8b:	50                   	push   %eax
  801a8c:	ff 75 08             	pushl  0x8(%ebp)
  801a8f:	e8 52 fb ff ff       	call   8015e6 <fd_lookup>
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	85 c0                	test   %eax,%eax
  801a99:	78 4b                	js     801ae6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	ff 30                	pushl  (%eax)
  801aa7:	e8 8e fb ff ff       	call   80163a <dev_lookup>
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 33                	js     801ae6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801aba:	74 2f                	je     801aeb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801abc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac6:	00 00 00 
	stat->st_isdir = 0;
  801ac9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ad0:	00 00 00 
	stat->st_dev = dev;
  801ad3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad9:	83 ec 08             	sub    $0x8,%esp
  801adc:	53                   	push   %ebx
  801add:	ff 75 f0             	pushl  -0x10(%ebp)
  801ae0:	ff 50 14             	call   *0x14(%eax)
  801ae3:	83 c4 10             	add    $0x10,%esp
}
  801ae6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    
		return -E_NOT_SUPP;
  801aeb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af0:	eb f4                	jmp    801ae6 <fstat+0x6c>

00801af2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af2:	f3 0f 1e fb          	endbr32 
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	56                   	push   %esi
  801afa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801afb:	83 ec 08             	sub    $0x8,%esp
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	e8 fb 01 00 00       	call   801d03 <open>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 1b                	js     801b2c <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	e8 5d ff ff ff       	call   801a7a <fstat>
  801b1d:	89 c6                	mov    %eax,%esi
	close(fd);
  801b1f:	89 1c 24             	mov    %ebx,(%esp)
  801b22:	e8 fd fb ff ff       	call   801724 <close>
	return r;
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	89 f3                	mov    %esi,%ebx
}
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	89 c6                	mov    %eax,%esi
  801b3c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b3e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b45:	74 27                	je     801b6e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b47:	6a 07                	push   $0x7
  801b49:	68 00 60 80 00       	push   $0x806000
  801b4e:	56                   	push   %esi
  801b4f:	ff 35 00 50 80 00    	pushl  0x805000
  801b55:	e8 72 f9 ff ff       	call   8014cc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b5a:	83 c4 0c             	add    $0xc,%esp
  801b5d:	6a 00                	push   $0x0
  801b5f:	53                   	push   %ebx
  801b60:	6a 00                	push   $0x0
  801b62:	e8 f1 f8 ff ff       	call   801458 <ipc_recv>
}
  801b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	6a 01                	push   $0x1
  801b73:	e8 ac f9 ff ff       	call   801524 <ipc_find_env>
  801b78:	a3 00 50 80 00       	mov    %eax,0x805000
  801b7d:	83 c4 10             	add    $0x10,%esp
  801b80:	eb c5                	jmp    801b47 <fsipc+0x12>

00801b82 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b82:	f3 0f 1e fb          	endbr32 
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b92:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba4:	b8 02 00 00 00       	mov    $0x2,%eax
  801ba9:	e8 87 ff ff ff       	call   801b35 <fsipc>
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <devfile_flush>:
{
  801bb0:	f3 0f 1e fb          	endbr32 
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc0:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bca:	b8 06 00 00 00       	mov    $0x6,%eax
  801bcf:	e8 61 ff ff ff       	call   801b35 <fsipc>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <devfile_stat>:
{
  801bd6:	f3 0f 1e fb          	endbr32 
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	53                   	push   %ebx
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	8b 40 0c             	mov    0xc(%eax),%eax
  801bea:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bef:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf4:	b8 05 00 00 00       	mov    $0x5,%eax
  801bf9:	e8 37 ff ff ff       	call   801b35 <fsipc>
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 2c                	js     801c2e <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	68 00 60 80 00       	push   $0x806000
  801c0a:	53                   	push   %ebx
  801c0b:	e8 d2 f1 ff ff       	call   800de2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c10:	a1 80 60 80 00       	mov    0x806080,%eax
  801c15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c1b:	a1 84 60 80 00       	mov    0x806084,%eax
  801c20:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <devfile_write>:
{
  801c33:	f3 0f 1e fb          	endbr32 
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c40:	8b 55 08             	mov    0x8(%ebp),%edx
  801c43:	8b 52 0c             	mov    0xc(%edx),%edx
  801c46:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801c4c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c51:	ba 00 10 00 00       	mov    $0x1000,%edx
  801c56:	0f 47 c2             	cmova  %edx,%eax
  801c59:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801c5e:	50                   	push   %eax
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	68 08 60 80 00       	push   $0x806008
  801c67:	e8 2c f3 ff ff       	call   800f98 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801c6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c71:	b8 04 00 00 00       	mov    $0x4,%eax
  801c76:	e8 ba fe ff ff       	call   801b35 <fsipc>
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <devfile_read>:
{
  801c7d:	f3 0f 1e fb          	endbr32 
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	56                   	push   %esi
  801c85:	53                   	push   %ebx
  801c86:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c94:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9f:	b8 03 00 00 00       	mov    $0x3,%eax
  801ca4:	e8 8c fe ff ff       	call   801b35 <fsipc>
  801ca9:	89 c3                	mov    %eax,%ebx
  801cab:	85 c0                	test   %eax,%eax
  801cad:	78 1f                	js     801cce <devfile_read+0x51>
	assert(r <= n);
  801caf:	39 f0                	cmp    %esi,%eax
  801cb1:	77 24                	ja     801cd7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801cb3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cb8:	7f 33                	jg     801ced <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	50                   	push   %eax
  801cbe:	68 00 60 80 00       	push   $0x806000
  801cc3:	ff 75 0c             	pushl  0xc(%ebp)
  801cc6:	e8 cd f2 ff ff       	call   800f98 <memmove>
	return r;
  801ccb:	83 c4 10             	add    $0x10,%esp
}
  801cce:	89 d8                	mov    %ebx,%eax
  801cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    
	assert(r <= n);
  801cd7:	68 f8 31 80 00       	push   $0x8031f8
  801cdc:	68 ff 31 80 00       	push   $0x8031ff
  801ce1:	6a 7c                	push   $0x7c
  801ce3:	68 14 32 80 00       	push   $0x803214
  801ce8:	e8 04 ea ff ff       	call   8006f1 <_panic>
	assert(r <= PGSIZE);
  801ced:	68 1f 32 80 00       	push   $0x80321f
  801cf2:	68 ff 31 80 00       	push   $0x8031ff
  801cf7:	6a 7d                	push   $0x7d
  801cf9:	68 14 32 80 00       	push   $0x803214
  801cfe:	e8 ee e9 ff ff       	call   8006f1 <_panic>

00801d03 <open>:
{
  801d03:	f3 0f 1e fb          	endbr32 
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	56                   	push   %esi
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 1c             	sub    $0x1c,%esp
  801d0f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d12:	56                   	push   %esi
  801d13:	e8 87 f0 ff ff       	call   800d9f <strlen>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d20:	7f 6c                	jg     801d8e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d28:	50                   	push   %eax
  801d29:	e8 62 f8 ff ff       	call   801590 <fd_alloc>
  801d2e:	89 c3                	mov    %eax,%ebx
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	85 c0                	test   %eax,%eax
  801d35:	78 3c                	js     801d73 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801d37:	83 ec 08             	sub    $0x8,%esp
  801d3a:	56                   	push   %esi
  801d3b:	68 00 60 80 00       	push   $0x806000
  801d40:	e8 9d f0 ff ff       	call   800de2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d48:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d50:	b8 01 00 00 00       	mov    $0x1,%eax
  801d55:	e8 db fd ff ff       	call   801b35 <fsipc>
  801d5a:	89 c3                	mov    %eax,%ebx
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 19                	js     801d7c <open+0x79>
	return fd2num(fd);
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	ff 75 f4             	pushl  -0xc(%ebp)
  801d69:	e8 f3 f7 ff ff       	call   801561 <fd2num>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	83 c4 10             	add    $0x10,%esp
}
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    
		fd_close(fd, 0);
  801d7c:	83 ec 08             	sub    $0x8,%esp
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 f4             	pushl  -0xc(%ebp)
  801d84:	e8 10 f9 ff ff       	call   801699 <fd_close>
		return r;
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	eb e5                	jmp    801d73 <open+0x70>
		return -E_BAD_PATH;
  801d8e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d93:	eb de                	jmp    801d73 <open+0x70>

00801d95 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d95:	f3 0f 1e fb          	endbr32 
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801da4:	b8 08 00 00 00       	mov    $0x8,%eax
  801da9:	e8 87 fd ff ff       	call   801b35 <fsipc>
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801db0:	f3 0f 1e fb          	endbr32 
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801dba:	68 2b 32 80 00       	push   $0x80322b
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	e8 1b f0 ff ff       	call   800de2 <strcpy>
	return 0;
}
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <devsock_close>:
{
  801dce:	f3 0f 1e fb          	endbr32 
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	53                   	push   %ebx
  801dd6:	83 ec 10             	sub    $0x10,%esp
  801dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ddc:	53                   	push   %ebx
  801ddd:	e8 81 09 00 00       	call   802763 <pageref>
  801de2:	89 c2                	mov    %eax,%edx
  801de4:	83 c4 10             	add    $0x10,%esp
		return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801dec:	83 fa 01             	cmp    $0x1,%edx
  801def:	74 05                	je     801df6 <devsock_close+0x28>
}
  801df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801df6:	83 ec 0c             	sub    $0xc,%esp
  801df9:	ff 73 0c             	pushl  0xc(%ebx)
  801dfc:	e8 e3 02 00 00       	call   8020e4 <nsipc_close>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	eb eb                	jmp    801df1 <devsock_close+0x23>

00801e06 <devsock_write>:
{
  801e06:	f3 0f 1e fb          	endbr32 
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 10             	pushl  0x10(%ebp)
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	ff 70 0c             	pushl  0xc(%eax)
  801e1e:	e8 b5 03 00 00       	call   8021d8 <nsipc_send>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <devsock_read>:
{
  801e25:	f3 0f 1e fb          	endbr32 
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	ff 75 10             	pushl  0x10(%ebp)
  801e34:	ff 75 0c             	pushl  0xc(%ebp)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	ff 70 0c             	pushl  0xc(%eax)
  801e3d:	e8 1f 03 00 00       	call   802161 <nsipc_recv>
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <fd2sockid>:
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	e8 92 f7 ff ff       	call   8015e6 <fd_lookup>
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	78 10                	js     801e6b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801e64:	39 08                	cmp    %ecx,(%eax)
  801e66:	75 05                	jne    801e6d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e68:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    
		return -E_NOT_SUPP;
  801e6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e72:	eb f7                	jmp    801e6b <fd2sockid+0x27>

00801e74 <alloc_sockfd>:
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	83 ec 1c             	sub    $0x1c,%esp
  801e7c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e81:	50                   	push   %eax
  801e82:	e8 09 f7 ff ff       	call   801590 <fd_alloc>
  801e87:	89 c3                	mov    %eax,%ebx
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	78 43                	js     801ed3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 07 04 00 00       	push   $0x407
  801e98:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9b:	6a 00                	push   $0x0
  801e9d:	e8 82 f3 ff ff       	call   801224 <sys_page_alloc>
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	78 28                	js     801ed3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801eb4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ec0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	50                   	push   %eax
  801ec7:	e8 95 f6 ff ff       	call   801561 <fd2num>
  801ecc:	89 c3                	mov    %eax,%ebx
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	eb 0c                	jmp    801edf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	56                   	push   %esi
  801ed7:	e8 08 02 00 00       	call   8020e4 <nsipc_close>
		return r;
  801edc:	83 c4 10             	add    $0x10,%esp
}
  801edf:	89 d8                	mov    %ebx,%eax
  801ee1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee4:	5b                   	pop    %ebx
  801ee5:	5e                   	pop    %esi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <accept>:
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	e8 4a ff ff ff       	call   801e44 <fd2sockid>
  801efa:	85 c0                	test   %eax,%eax
  801efc:	78 1b                	js     801f19 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	ff 75 10             	pushl  0x10(%ebp)
  801f04:	ff 75 0c             	pushl  0xc(%ebp)
  801f07:	50                   	push   %eax
  801f08:	e8 22 01 00 00       	call   80202f <nsipc_accept>
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 05                	js     801f19 <accept+0x31>
	return alloc_sockfd(r);
  801f14:	e8 5b ff ff ff       	call   801e74 <alloc_sockfd>
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <bind>:
{
  801f1b:	f3 0f 1e fb          	endbr32 
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	e8 17 ff ff ff       	call   801e44 <fd2sockid>
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	78 12                	js     801f43 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	ff 75 10             	pushl  0x10(%ebp)
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	50                   	push   %eax
  801f3b:	e8 45 01 00 00       	call   802085 <nsipc_bind>
  801f40:	83 c4 10             	add    $0x10,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <shutdown>:
{
  801f45:	f3 0f 1e fb          	endbr32 
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	e8 ed fe ff ff       	call   801e44 <fd2sockid>
  801f57:	85 c0                	test   %eax,%eax
  801f59:	78 0f                	js     801f6a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801f5b:	83 ec 08             	sub    $0x8,%esp
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	50                   	push   %eax
  801f62:	e8 57 01 00 00       	call   8020be <nsipc_shutdown>
  801f67:	83 c4 10             	add    $0x10,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <connect>:
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	e8 c6 fe ff ff       	call   801e44 <fd2sockid>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 12                	js     801f94 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	ff 75 10             	pushl  0x10(%ebp)
  801f88:	ff 75 0c             	pushl  0xc(%ebp)
  801f8b:	50                   	push   %eax
  801f8c:	e8 71 01 00 00       	call   802102 <nsipc_connect>
  801f91:	83 c4 10             	add    $0x10,%esp
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <listen>:
{
  801f96:	f3 0f 1e fb          	endbr32 
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	e8 9c fe ff ff       	call   801e44 <fd2sockid>
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	78 0f                	js     801fbb <listen+0x25>
	return nsipc_listen(r, backlog);
  801fac:	83 ec 08             	sub    $0x8,%esp
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	50                   	push   %eax
  801fb3:	e8 83 01 00 00       	call   80213b <nsipc_listen>
  801fb8:	83 c4 10             	add    $0x10,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <socket>:

int
socket(int domain, int type, int protocol)
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fc7:	ff 75 10             	pushl  0x10(%ebp)
  801fca:	ff 75 0c             	pushl  0xc(%ebp)
  801fcd:	ff 75 08             	pushl  0x8(%ebp)
  801fd0:	e8 65 02 00 00       	call   80223a <nsipc_socket>
  801fd5:	83 c4 10             	add    $0x10,%esp
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	78 05                	js     801fe1 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801fdc:	e8 93 fe ff ff       	call   801e74 <alloc_sockfd>
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	53                   	push   %ebx
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fec:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ff3:	74 26                	je     80201b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ff5:	6a 07                	push   $0x7
  801ff7:	68 00 70 80 00       	push   $0x807000
  801ffc:	53                   	push   %ebx
  801ffd:	ff 35 04 50 80 00    	pushl  0x805004
  802003:	e8 c4 f4 ff ff       	call   8014cc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802008:	83 c4 0c             	add    $0xc,%esp
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	e8 42 f4 ff ff       	call   801458 <ipc_recv>
}
  802016:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802019:	c9                   	leave  
  80201a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	6a 02                	push   $0x2
  802020:	e8 ff f4 ff ff       	call   801524 <ipc_find_env>
  802025:	a3 04 50 80 00       	mov    %eax,0x805004
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	eb c6                	jmp    801ff5 <nsipc+0x12>

0080202f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80202f:	f3 0f 1e fb          	endbr32 
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802043:	8b 06                	mov    (%esi),%eax
  802045:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80204a:	b8 01 00 00 00       	mov    $0x1,%eax
  80204f:	e8 8f ff ff ff       	call   801fe3 <nsipc>
  802054:	89 c3                	mov    %eax,%ebx
  802056:	85 c0                	test   %eax,%eax
  802058:	79 09                	jns    802063 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80205a:	89 d8                	mov    %ebx,%eax
  80205c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	ff 35 10 70 80 00    	pushl  0x807010
  80206c:	68 00 70 80 00       	push   $0x807000
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	e8 1f ef ff ff       	call   800f98 <memmove>
		*addrlen = ret->ret_addrlen;
  802079:	a1 10 70 80 00       	mov    0x807010,%eax
  80207e:	89 06                	mov    %eax,(%esi)
  802080:	83 c4 10             	add    $0x10,%esp
	return r;
  802083:	eb d5                	jmp    80205a <nsipc_accept+0x2b>

00802085 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802085:	f3 0f 1e fb          	endbr32 
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	53                   	push   %ebx
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80209b:	53                   	push   %ebx
  80209c:	ff 75 0c             	pushl  0xc(%ebp)
  80209f:	68 04 70 80 00       	push   $0x807004
  8020a4:	e8 ef ee ff ff       	call   800f98 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020a9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020af:	b8 02 00 00 00       	mov    $0x2,%eax
  8020b4:	e8 2a ff ff ff       	call   801fe3 <nsipc>
}
  8020b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020be:	f3 0f 1e fb          	endbr32 
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d3:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020d8:	b8 03 00 00 00       	mov    $0x3,%eax
  8020dd:	e8 01 ff ff ff       	call   801fe3 <nsipc>
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e4:	f3 0f 1e fb          	endbr32 
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020f6:	b8 04 00 00 00       	mov    $0x4,%eax
  8020fb:	e8 e3 fe ff ff       	call   801fe3 <nsipc>
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802102:	f3 0f 1e fb          	endbr32 
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	53                   	push   %ebx
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802118:	53                   	push   %ebx
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	68 04 70 80 00       	push   $0x807004
  802121:	e8 72 ee ff ff       	call   800f98 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802126:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80212c:	b8 05 00 00 00       	mov    $0x5,%eax
  802131:	e8 ad fe ff ff       	call   801fe3 <nsipc>
}
  802136:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80213b:	f3 0f 1e fb          	endbr32 
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802155:	b8 06 00 00 00       	mov    $0x6,%eax
  80215a:	e8 84 fe ff ff       	call   801fe3 <nsipc>
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802161:	f3 0f 1e fb          	endbr32 
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	56                   	push   %esi
  802169:	53                   	push   %ebx
  80216a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802175:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80217b:	8b 45 14             	mov    0x14(%ebp),%eax
  80217e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802183:	b8 07 00 00 00       	mov    $0x7,%eax
  802188:	e8 56 fe ff ff       	call   801fe3 <nsipc>
  80218d:	89 c3                	mov    %eax,%ebx
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 26                	js     8021b9 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802193:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802199:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80219e:	0f 4e c6             	cmovle %esi,%eax
  8021a1:	39 c3                	cmp    %eax,%ebx
  8021a3:	7f 1d                	jg     8021c2 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	53                   	push   %ebx
  8021a9:	68 00 70 80 00       	push   $0x807000
  8021ae:	ff 75 0c             	pushl  0xc(%ebp)
  8021b1:	e8 e2 ed ff ff       	call   800f98 <memmove>
  8021b6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8021b9:	89 d8                	mov    %ebx,%eax
  8021bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021be:	5b                   	pop    %ebx
  8021bf:	5e                   	pop    %esi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8021c2:	68 37 32 80 00       	push   $0x803237
  8021c7:	68 ff 31 80 00       	push   $0x8031ff
  8021cc:	6a 62                	push   $0x62
  8021ce:	68 4c 32 80 00       	push   $0x80324c
  8021d3:	e8 19 e5 ff ff       	call   8006f1 <_panic>

008021d8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021d8:	f3 0f 1e fb          	endbr32 
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021ee:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021f4:	7f 2e                	jg     802224 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	53                   	push   %ebx
  8021fa:	ff 75 0c             	pushl  0xc(%ebp)
  8021fd:	68 0c 70 80 00       	push   $0x80700c
  802202:	e8 91 ed ff ff       	call   800f98 <memmove>
	nsipcbuf.send.req_size = size;
  802207:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80220d:	8b 45 14             	mov    0x14(%ebp),%eax
  802210:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802215:	b8 08 00 00 00       	mov    $0x8,%eax
  80221a:	e8 c4 fd ff ff       	call   801fe3 <nsipc>
}
  80221f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802222:	c9                   	leave  
  802223:	c3                   	ret    
	assert(size < 1600);
  802224:	68 58 32 80 00       	push   $0x803258
  802229:	68 ff 31 80 00       	push   $0x8031ff
  80222e:	6a 6d                	push   $0x6d
  802230:	68 4c 32 80 00       	push   $0x80324c
  802235:	e8 b7 e4 ff ff       	call   8006f1 <_panic>

0080223a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80223a:	f3 0f 1e fb          	endbr32 
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802254:	8b 45 10             	mov    0x10(%ebp),%eax
  802257:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80225c:	b8 09 00 00 00       	mov    $0x9,%eax
  802261:	e8 7d fd ff ff       	call   801fe3 <nsipc>
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802268:	f3 0f 1e fb          	endbr32 
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	56                   	push   %esi
  802270:	53                   	push   %ebx
  802271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802274:	83 ec 0c             	sub    $0xc,%esp
  802277:	ff 75 08             	pushl  0x8(%ebp)
  80227a:	e8 f6 f2 ff ff       	call   801575 <fd2data>
  80227f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802281:	83 c4 08             	add    $0x8,%esp
  802284:	68 64 32 80 00       	push   $0x803264
  802289:	53                   	push   %ebx
  80228a:	e8 53 eb ff ff       	call   800de2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80228f:	8b 46 04             	mov    0x4(%esi),%eax
  802292:	2b 06                	sub    (%esi),%eax
  802294:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80229a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022a1:	00 00 00 
	stat->st_dev = &devpipe;
  8022a4:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8022ab:	40 80 00 
	return 0;
}
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b6:	5b                   	pop    %ebx
  8022b7:	5e                   	pop    %esi
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ba:	f3 0f 1e fb          	endbr32 
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 0c             	sub    $0xc,%esp
  8022c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022c8:	53                   	push   %ebx
  8022c9:	6a 00                	push   $0x0
  8022cb:	e8 e1 ef ff ff       	call   8012b1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022d0:	89 1c 24             	mov    %ebx,(%esp)
  8022d3:	e8 9d f2 ff ff       	call   801575 <fd2data>
  8022d8:	83 c4 08             	add    $0x8,%esp
  8022db:	50                   	push   %eax
  8022dc:	6a 00                	push   $0x0
  8022de:	e8 ce ef ff ff       	call   8012b1 <sys_page_unmap>
}
  8022e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <_pipeisclosed>:
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	57                   	push   %edi
  8022ec:	56                   	push   %esi
  8022ed:	53                   	push   %ebx
  8022ee:	83 ec 1c             	sub    $0x1c,%esp
  8022f1:	89 c7                	mov    %eax,%edi
  8022f3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8022fa:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022fd:	83 ec 0c             	sub    $0xc,%esp
  802300:	57                   	push   %edi
  802301:	e8 5d 04 00 00       	call   802763 <pageref>
  802306:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802309:	89 34 24             	mov    %esi,(%esp)
  80230c:	e8 52 04 00 00       	call   802763 <pageref>
		nn = thisenv->env_runs;
  802311:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802317:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	39 cb                	cmp    %ecx,%ebx
  80231f:	74 1b                	je     80233c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802321:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802324:	75 cf                	jne    8022f5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802326:	8b 42 58             	mov    0x58(%edx),%eax
  802329:	6a 01                	push   $0x1
  80232b:	50                   	push   %eax
  80232c:	53                   	push   %ebx
  80232d:	68 6b 32 80 00       	push   $0x80326b
  802332:	e8 a1 e4 ff ff       	call   8007d8 <cprintf>
  802337:	83 c4 10             	add    $0x10,%esp
  80233a:	eb b9                	jmp    8022f5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80233c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80233f:	0f 94 c0             	sete   %al
  802342:	0f b6 c0             	movzbl %al,%eax
}
  802345:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802348:	5b                   	pop    %ebx
  802349:	5e                   	pop    %esi
  80234a:	5f                   	pop    %edi
  80234b:	5d                   	pop    %ebp
  80234c:	c3                   	ret    

0080234d <devpipe_write>:
{
  80234d:	f3 0f 1e fb          	endbr32 
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	57                   	push   %edi
  802355:	56                   	push   %esi
  802356:	53                   	push   %ebx
  802357:	83 ec 28             	sub    $0x28,%esp
  80235a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80235d:	56                   	push   %esi
  80235e:	e8 12 f2 ff ff       	call   801575 <fd2data>
  802363:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802365:	83 c4 10             	add    $0x10,%esp
  802368:	bf 00 00 00 00       	mov    $0x0,%edi
  80236d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802370:	74 4f                	je     8023c1 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802372:	8b 43 04             	mov    0x4(%ebx),%eax
  802375:	8b 0b                	mov    (%ebx),%ecx
  802377:	8d 51 20             	lea    0x20(%ecx),%edx
  80237a:	39 d0                	cmp    %edx,%eax
  80237c:	72 14                	jb     802392 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80237e:	89 da                	mov    %ebx,%edx
  802380:	89 f0                	mov    %esi,%eax
  802382:	e8 61 ff ff ff       	call   8022e8 <_pipeisclosed>
  802387:	85 c0                	test   %eax,%eax
  802389:	75 3b                	jne    8023c6 <devpipe_write+0x79>
			sys_yield();
  80238b:	e8 71 ee ff ff       	call   801201 <sys_yield>
  802390:	eb e0                	jmp    802372 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802392:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802395:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802399:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80239c:	89 c2                	mov    %eax,%edx
  80239e:	c1 fa 1f             	sar    $0x1f,%edx
  8023a1:	89 d1                	mov    %edx,%ecx
  8023a3:	c1 e9 1b             	shr    $0x1b,%ecx
  8023a6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8023a9:	83 e2 1f             	and    $0x1f,%edx
  8023ac:	29 ca                	sub    %ecx,%edx
  8023ae:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8023b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023b6:	83 c0 01             	add    $0x1,%eax
  8023b9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8023bc:	83 c7 01             	add    $0x1,%edi
  8023bf:	eb ac                	jmp    80236d <devpipe_write+0x20>
	return i;
  8023c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c4:	eb 05                	jmp    8023cb <devpipe_write+0x7e>
				return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ce:	5b                   	pop    %ebx
  8023cf:	5e                   	pop    %esi
  8023d0:	5f                   	pop    %edi
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    

008023d3 <devpipe_read>:
{
  8023d3:	f3 0f 1e fb          	endbr32 
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	57                   	push   %edi
  8023db:	56                   	push   %esi
  8023dc:	53                   	push   %ebx
  8023dd:	83 ec 18             	sub    $0x18,%esp
  8023e0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023e3:	57                   	push   %edi
  8023e4:	e8 8c f1 ff ff       	call   801575 <fd2data>
  8023e9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023eb:	83 c4 10             	add    $0x10,%esp
  8023ee:	be 00 00 00 00       	mov    $0x0,%esi
  8023f3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f6:	75 14                	jne    80240c <devpipe_read+0x39>
	return i;
  8023f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fb:	eb 02                	jmp    8023ff <devpipe_read+0x2c>
				return i;
  8023fd:	89 f0                	mov    %esi,%eax
}
  8023ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802402:	5b                   	pop    %ebx
  802403:	5e                   	pop    %esi
  802404:	5f                   	pop    %edi
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    
			sys_yield();
  802407:	e8 f5 ed ff ff       	call   801201 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80240c:	8b 03                	mov    (%ebx),%eax
  80240e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802411:	75 18                	jne    80242b <devpipe_read+0x58>
			if (i > 0)
  802413:	85 f6                	test   %esi,%esi
  802415:	75 e6                	jne    8023fd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802417:	89 da                	mov    %ebx,%edx
  802419:	89 f8                	mov    %edi,%eax
  80241b:	e8 c8 fe ff ff       	call   8022e8 <_pipeisclosed>
  802420:	85 c0                	test   %eax,%eax
  802422:	74 e3                	je     802407 <devpipe_read+0x34>
				return 0;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
  802429:	eb d4                	jmp    8023ff <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80242b:	99                   	cltd   
  80242c:	c1 ea 1b             	shr    $0x1b,%edx
  80242f:	01 d0                	add    %edx,%eax
  802431:	83 e0 1f             	and    $0x1f,%eax
  802434:	29 d0                	sub    %edx,%eax
  802436:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80243b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802441:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802444:	83 c6 01             	add    $0x1,%esi
  802447:	eb aa                	jmp    8023f3 <devpipe_read+0x20>

00802449 <pipe>:
{
  802449:	f3 0f 1e fb          	endbr32 
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
  802450:	56                   	push   %esi
  802451:	53                   	push   %ebx
  802452:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802455:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802458:	50                   	push   %eax
  802459:	e8 32 f1 ff ff       	call   801590 <fd_alloc>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	85 c0                	test   %eax,%eax
  802465:	0f 88 23 01 00 00    	js     80258e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	68 07 04 00 00       	push   $0x407
  802473:	ff 75 f4             	pushl  -0xc(%ebp)
  802476:	6a 00                	push   $0x0
  802478:	e8 a7 ed ff ff       	call   801224 <sys_page_alloc>
  80247d:	89 c3                	mov    %eax,%ebx
  80247f:	83 c4 10             	add    $0x10,%esp
  802482:	85 c0                	test   %eax,%eax
  802484:	0f 88 04 01 00 00    	js     80258e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802490:	50                   	push   %eax
  802491:	e8 fa f0 ff ff       	call   801590 <fd_alloc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	83 c4 10             	add    $0x10,%esp
  80249b:	85 c0                	test   %eax,%eax
  80249d:	0f 88 db 00 00 00    	js     80257e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	68 07 04 00 00       	push   $0x407
  8024ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8024ae:	6a 00                	push   $0x0
  8024b0:	e8 6f ed ff ff       	call   801224 <sys_page_alloc>
  8024b5:	89 c3                	mov    %eax,%ebx
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	0f 88 bc 00 00 00    	js     80257e <pipe+0x135>
	va = fd2data(fd0);
  8024c2:	83 ec 0c             	sub    $0xc,%esp
  8024c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c8:	e8 a8 f0 ff ff       	call   801575 <fd2data>
  8024cd:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024cf:	83 c4 0c             	add    $0xc,%esp
  8024d2:	68 07 04 00 00       	push   $0x407
  8024d7:	50                   	push   %eax
  8024d8:	6a 00                	push   $0x0
  8024da:	e8 45 ed ff ff       	call   801224 <sys_page_alloc>
  8024df:	89 c3                	mov    %eax,%ebx
  8024e1:	83 c4 10             	add    $0x10,%esp
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	0f 88 82 00 00 00    	js     80256e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8024f2:	e8 7e f0 ff ff       	call   801575 <fd2data>
  8024f7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024fe:	50                   	push   %eax
  8024ff:	6a 00                	push   $0x0
  802501:	56                   	push   %esi
  802502:	6a 00                	push   $0x0
  802504:	e8 62 ed ff ff       	call   80126b <sys_page_map>
  802509:	89 c3                	mov    %eax,%ebx
  80250b:	83 c4 20             	add    $0x20,%esp
  80250e:	85 c0                	test   %eax,%eax
  802510:	78 4e                	js     802560 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802512:	a1 40 40 80 00       	mov    0x804040,%eax
  802517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80251c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802526:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802529:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80252b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802535:	83 ec 0c             	sub    $0xc,%esp
  802538:	ff 75 f4             	pushl  -0xc(%ebp)
  80253b:	e8 21 f0 ff ff       	call   801561 <fd2num>
  802540:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802543:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802545:	83 c4 04             	add    $0x4,%esp
  802548:	ff 75 f0             	pushl  -0x10(%ebp)
  80254b:	e8 11 f0 ff ff       	call   801561 <fd2num>
  802550:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802553:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	bb 00 00 00 00       	mov    $0x0,%ebx
  80255e:	eb 2e                	jmp    80258e <pipe+0x145>
	sys_page_unmap(0, va);
  802560:	83 ec 08             	sub    $0x8,%esp
  802563:	56                   	push   %esi
  802564:	6a 00                	push   $0x0
  802566:	e8 46 ed ff ff       	call   8012b1 <sys_page_unmap>
  80256b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80256e:	83 ec 08             	sub    $0x8,%esp
  802571:	ff 75 f0             	pushl  -0x10(%ebp)
  802574:	6a 00                	push   $0x0
  802576:	e8 36 ed ff ff       	call   8012b1 <sys_page_unmap>
  80257b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80257e:	83 ec 08             	sub    $0x8,%esp
  802581:	ff 75 f4             	pushl  -0xc(%ebp)
  802584:	6a 00                	push   $0x0
  802586:	e8 26 ed ff ff       	call   8012b1 <sys_page_unmap>
  80258b:	83 c4 10             	add    $0x10,%esp
}
  80258e:	89 d8                	mov    %ebx,%eax
  802590:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <pipeisclosed>:
{
  802597:	f3 0f 1e fb          	endbr32 
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a4:	50                   	push   %eax
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	e8 39 f0 ff ff       	call   8015e6 <fd_lookup>
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 18                	js     8025cc <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ba:	e8 b6 ef ff ff       	call   801575 <fd2data>
  8025bf:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	e8 1f fd ff ff       	call   8022e8 <_pipeisclosed>
  8025c9:	83 c4 10             	add    $0x10,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025ce:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	c3                   	ret    

008025d8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025d8:	f3 0f 1e fb          	endbr32 
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025e2:	68 83 32 80 00       	push   $0x803283
  8025e7:	ff 75 0c             	pushl  0xc(%ebp)
  8025ea:	e8 f3 e7 ff ff       	call   800de2 <strcpy>
	return 0;
}
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <devcons_write>:
{
  8025f6:	f3 0f 1e fb          	endbr32 
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	57                   	push   %edi
  8025fe:	56                   	push   %esi
  8025ff:	53                   	push   %ebx
  802600:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802606:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80260b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802611:	3b 75 10             	cmp    0x10(%ebp),%esi
  802614:	73 31                	jae    802647 <devcons_write+0x51>
		m = n - tot;
  802616:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802619:	29 f3                	sub    %esi,%ebx
  80261b:	83 fb 7f             	cmp    $0x7f,%ebx
  80261e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802623:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	53                   	push   %ebx
  80262a:	89 f0                	mov    %esi,%eax
  80262c:	03 45 0c             	add    0xc(%ebp),%eax
  80262f:	50                   	push   %eax
  802630:	57                   	push   %edi
  802631:	e8 62 e9 ff ff       	call   800f98 <memmove>
		sys_cputs(buf, m);
  802636:	83 c4 08             	add    $0x8,%esp
  802639:	53                   	push   %ebx
  80263a:	57                   	push   %edi
  80263b:	e8 14 eb ff ff       	call   801154 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802640:	01 de                	add    %ebx,%esi
  802642:	83 c4 10             	add    $0x10,%esp
  802645:	eb ca                	jmp    802611 <devcons_write+0x1b>
}
  802647:	89 f0                	mov    %esi,%eax
  802649:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80264c:	5b                   	pop    %ebx
  80264d:	5e                   	pop    %esi
  80264e:	5f                   	pop    %edi
  80264f:	5d                   	pop    %ebp
  802650:	c3                   	ret    

00802651 <devcons_read>:
{
  802651:	f3 0f 1e fb          	endbr32 
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 08             	sub    $0x8,%esp
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802660:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802664:	74 21                	je     802687 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802666:	e8 0b eb ff ff       	call   801176 <sys_cgetc>
  80266b:	85 c0                	test   %eax,%eax
  80266d:	75 07                	jne    802676 <devcons_read+0x25>
		sys_yield();
  80266f:	e8 8d eb ff ff       	call   801201 <sys_yield>
  802674:	eb f0                	jmp    802666 <devcons_read+0x15>
	if (c < 0)
  802676:	78 0f                	js     802687 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802678:	83 f8 04             	cmp    $0x4,%eax
  80267b:	74 0c                	je     802689 <devcons_read+0x38>
	*(char*)vbuf = c;
  80267d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802680:	88 02                	mov    %al,(%edx)
	return 1;
  802682:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    
		return 0;
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	eb f7                	jmp    802687 <devcons_read+0x36>

00802690 <cputchar>:
{
  802690:	f3 0f 1e fb          	endbr32 
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8026a0:	6a 01                	push   $0x1
  8026a2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026a5:	50                   	push   %eax
  8026a6:	e8 a9 ea ff ff       	call   801154 <sys_cputs>
}
  8026ab:	83 c4 10             	add    $0x10,%esp
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <getchar>:
{
  8026b0:	f3 0f 1e fb          	endbr32 
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8026ba:	6a 01                	push   $0x1
  8026bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026bf:	50                   	push   %eax
  8026c0:	6a 00                	push   $0x0
  8026c2:	e8 a7 f1 ff ff       	call   80186e <read>
	if (r < 0)
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	78 06                	js     8026d4 <getchar+0x24>
	if (r < 1)
  8026ce:	74 06                	je     8026d6 <getchar+0x26>
	return c;
  8026d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    
		return -E_EOF;
  8026d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026db:	eb f7                	jmp    8026d4 <getchar+0x24>

008026dd <iscons>:
{
  8026dd:	f3 0f 1e fb          	endbr32 
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ea:	50                   	push   %eax
  8026eb:	ff 75 08             	pushl  0x8(%ebp)
  8026ee:	e8 f3 ee ff ff       	call   8015e6 <fd_lookup>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	78 11                	js     80270b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802703:	39 10                	cmp    %edx,(%eax)
  802705:	0f 94 c0             	sete   %al
  802708:	0f b6 c0             	movzbl %al,%eax
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <opencons>:
{
  80270d:	f3 0f 1e fb          	endbr32 
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802717:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80271a:	50                   	push   %eax
  80271b:	e8 70 ee ff ff       	call   801590 <fd_alloc>
  802720:	83 c4 10             	add    $0x10,%esp
  802723:	85 c0                	test   %eax,%eax
  802725:	78 3a                	js     802761 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802727:	83 ec 04             	sub    $0x4,%esp
  80272a:	68 07 04 00 00       	push   $0x407
  80272f:	ff 75 f4             	pushl  -0xc(%ebp)
  802732:	6a 00                	push   $0x0
  802734:	e8 eb ea ff ff       	call   801224 <sys_page_alloc>
  802739:	83 c4 10             	add    $0x10,%esp
  80273c:	85 c0                	test   %eax,%eax
  80273e:	78 21                	js     802761 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802749:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	50                   	push   %eax
  802759:	e8 03 ee ff ff       	call   801561 <fd2num>
  80275e:	83 c4 10             	add    $0x10,%esp
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802763:	f3 0f 1e fb          	endbr32 
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80276d:	89 c2                	mov    %eax,%edx
  80276f:	c1 ea 16             	shr    $0x16,%edx
  802772:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802779:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80277e:	f6 c1 01             	test   $0x1,%cl
  802781:	74 1c                	je     80279f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802783:	c1 e8 0c             	shr    $0xc,%eax
  802786:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80278d:	a8 01                	test   $0x1,%al
  80278f:	74 0e                	je     80279f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802791:	c1 e8 0c             	shr    $0xc,%eax
  802794:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80279b:	ef 
  80279c:	0f b7 d2             	movzwl %dx,%edx
}
  80279f:	89 d0                	mov    %edx,%eax
  8027a1:	5d                   	pop    %ebp
  8027a2:	c3                   	ret    
  8027a3:	66 90                	xchg   %ax,%ax
  8027a5:	66 90                	xchg   %ax,%ax
  8027a7:	66 90                	xchg   %ax,%ax
  8027a9:	66 90                	xchg   %ax,%ax
  8027ab:	66 90                	xchg   %ax,%ax
  8027ad:	66 90                	xchg   %ax,%ax
  8027af:	90                   	nop

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
