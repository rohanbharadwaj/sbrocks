/*
 * lapic.c
 *
 *  Created on: Apr 2, 2011
 *      Author: cds
 */

#include<arch/arch.h>
#include<lib/lib.h>
#include<mm/mm.h>


volatile struct local_apic_struct *lapic = 0;


void lapic_ipi_start(uint8_t lapic_id, void* address) {

//	HALT("");

	lapic_ipi_register reg;

	// INIT
	memset(&reg,0, sizeof reg);
	reg.bits.trigger_mode = LAPIC_IPI_TRIGGERMODE_LEVEL;
	reg.bits.message_type = LAPIC_IPI_MESSAGETYPE_INIT;
	reg.bits.destination_mode = LAPIC_DESTINATION_MODE_PHYSICAL;
	reg.bits.destination = lapic_id;
	lapic->interrupt_command[1]._register = (uint32_t)((reg._register) >> 32);
	lapic->interrupt_command[0]._register = (uint32_t)((reg._register) >>  0);

	hpet_wait_milliseconds(10);

	memset(&reg,0, sizeof reg);
	reg.bits.vector = (uint8_t)((((uint64_t)address) >> 12) & 0xff );
	reg.bits.trigger_mode = LAPIC_IPI_TRIGGERMODE_EDGE;
	reg.bits.message_type = LAPIC_IPI_MESSAGETYPE_STARTUP;
	reg.bits.destination_mode = LAPIC_DESTINATION_MODE_PHYSICAL;
	reg.bits.destination = lapic_id;

	// SIPI 1
	lapic->interrupt_command[1]._register = (uint32_t)((reg._register) >> 32);
	lapic->interrupt_command[0]._register = (uint32_t)((reg._register) >>  0);

	hpet_wait_microseconds(200);

	// SIPI 2
	lapic->interrupt_command[1]._register = (uint32_t)((reg._register) >> 32);
	lapic->interrupt_command[0]._register = (uint32_t)((reg._register) >>  0);

	hpet_wait_microseconds(200);
}

static void lapic_global_enable() {

	uint64_t msr = cpu_rdmsr64( IA32_APIC_BASE );

	msr |= APIC_GLOBAL_ENABLE_FLAG;

	cpu_wrmsr64(IA32_APIC_BASE, msr);
}

/*static void lapic_global_disable() {

	uint64_t msr = cpu_rdmsr64( IA32_APIC_BASE );

	msr &= ~APIC_GLOBAL_ENABLE_FLAG;

	cpu_wrmsr64(IA32_APIC_BASE, msr);
}
*/

void lapic_enable_stolen() {

	lapic->task_priority._register = 0x20;
	lapic->lvt_timer._register = 0x10000;
	lapic->lvt_performance_monitoring_counters._register = 0x10000;
	lapic->lvt_lint0._register = 0x8700;
	lapic->lvt_lint1._register = 0x400;
	lapic->lvt_error._register = 0x10000;
	lapic->spurious_interrupt_vector._register = 0x0010f;
	lapic->lvt_lint0._register = 0x8700;
	lapic->lvt_lint1._register = 0x400;
}


static uint64_t lapic_get_phy_address() {

	uint64_t msr = cpu_rdmsr64( IA32_APIC_BASE );

	return msr & 0xFFFFFF000;
}
/*
static uint64_t lapic_set_phy_address(uint64_t phy) {

	if(phy & 0xFFF)
		return 0; // can't relocate lapic to given address

	uint64_t msr = cpu_rdmsr64( IA32_APIC_BASE );

	msr &= 0xFFF;
	msr |= phy;

	cpu_wrmsr64( IA32_APIC_BASE, msr );

	return lapic_get_phy_address();
}
*/
static volatile struct local_apic_struct * lapic_mmap() {

	uint64_t phy = lapic_get_phy_address();
	//uint64_t off = phy & (PAGE_SIZE-1);

	uint64_t pages  = (sizeof(struct local_apic_struct) / PAGE_SIZE)
					+((sizeof(struct local_apic_struct) % PAGE_SIZE) ? 1 : 0);

	uint64_t virt = (uint64_t)vmm_alloc_hw(pages);

	for(uint64_t i=0; i<pages; i++)
		mmap((phy + i*PAGE_SIZE ) & ~(PAGE_SIZE-1), virt + PAGE_SIZE*i, 0);

	volatile struct local_apic_struct *s = (volatile struct local_apic_struct *)(virt + (phy & (PAGE_SIZE-1)));

	return s;
}

void lapic_eoi(uint32_t vector) {

	lapic->end_of_interrupt._register = vector;
}

uint64_t lapic_id()
{
	return lapic->id._register;
}

void lapic_configure() {

	if(!lapic)
		lapic = lapic_mmap();

//	kprintf("lapic @ 0x%lx\n", lapic);

	lapic_global_enable();
	lapic_enable_stolen(); // TODO: understand this ?
}


