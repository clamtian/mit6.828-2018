// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
    int r;
    void *addr = (void *) utf->utf_fault_va;
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
    
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
    memmove(PFTEMP, addr, PGSIZE);
    if ((r = sys_page_unmap(envid, addr)) < 0)
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
        panic("pgfault: page unmap failed %e", r);
}
//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
    int r;

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
    pte = uvpt[pn];
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
			duppage(envid, PGNUM(addr));
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
