#include <inc/x86.h>
#include <inc/lib.h>

#define VA	((char *) 0xA0000000)
const char *msg = "hello, world\n";
const char *msg2 = "goodbye, world\n";

void childofspawn(void);

void
umain(int argc, char **argv)
{
	//if(thisenv->env_id == 0x2004) exit(); 
	int r;

	if (argc != 0)
		childofspawn();

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		panic("sys_page_alloc: %e", r);

	// check fork
	//cprintf("test fork\n");
	
	if ((r = fork()) < 0)
		panic("fork: %e", r);
	//if(thisenv->env_id == 0x2004) exit(); 
	if (r == 0) {
		strcpy(VA, msg);
		exit();
	}
	wait(r);
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");

	
	// check spawn
	//cprintf("test spawn\n");
	//if(thisenv->env_id == 0x2004) exit(); 
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
		panic("spawn: %e", r);
	wait(r);
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) != 0 ? "right" : "wrong");

	breakpoint();
}

void
childofspawn(void)
{
	strcpy(VA, msg2);
	exit();
}
