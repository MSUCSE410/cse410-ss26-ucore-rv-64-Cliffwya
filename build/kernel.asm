
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00064117          	auipc	sp,0x64
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	666000ef          	jal	ra,8020066e <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00001097          	auipc	ra,0x1
    80200018:	12c080e7          	jalr	300(ra) # 80201140 <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
}
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <consgetc>:

int consgetc()
{
    80200030:	1141                	addi	sp,sp,-16
    80200032:	e406                	sd	ra,8(sp)
    80200034:	e022                	sd	s0,0(sp)
    80200036:	0800                	addi	s0,sp,16
	return console_getchar();
    80200038:	00001097          	auipc	ra,0x1
    8020003c:	11e080e7          	jalr	286(ra) # 80201156 <console_getchar>
    80200040:	60a2                	ld	ra,8(sp)
    80200042:	6402                	ld	s0,0(sp)
    80200044:	0141                	addi	sp,sp,16
    80200046:	8082                	ret

0000000080200048 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80200048:	1101                	addi	sp,sp,-32
    8020004a:	ec06                	sd	ra,24(sp)
    8020004c:	e822                	sd	s0,16(sp)
    8020004e:	e426                	sd	s1,8(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	84aa                	mv	s1,a0
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    80200054:	03451793          	slli	a5,a0,0x34
    80200058:	eb99                	bnez	a5,8020006e <kfree+0x26>
    8020005a:	0058e797          	auipc	a5,0x58e
    8020005e:	fa678793          	addi	a5,a5,-90 # 8078e000 <e_bss>
    80200062:	00f56663          	bltu	a0,a5,8020006e <kfree+0x26>
    80200066:	47c5                	li	a5,17
    80200068:	07ee                	slli	a5,a5,0x1b
    8020006a:	02f56e63          	bltu	a0,a5,802000a6 <kfree+0x5e>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
    8020006e:	00001097          	auipc	ra,0x1
    80200072:	8e2080e7          	jalr	-1822(ra) # 80200950 <threadid>
    80200076:	86aa                	mv	a3,a0
    80200078:	02500793          	li	a5,37
    8020007c:	00004717          	auipc	a4,0x4
    80200080:	f8470713          	addi	a4,a4,-124 # 80204000 <e_text>
    80200084:	00004617          	auipc	a2,0x4
    80200088:	f8c60613          	addi	a2,a2,-116 # 80204010 <e_text+0x10>
    8020008c:	45fd                	li	a1,31
    8020008e:	00004517          	auipc	a0,0x4
    80200092:	f8a50513          	addi	a0,a0,-118 # 80204018 <e_text+0x18>
    80200096:	00000097          	auipc	ra,0x0
    8020009a:	6e4080e7          	jalr	1764(ra) # 8020077a <printf>
    8020009e:	00001097          	auipc	ra,0x1
    802000a2:	0d2080e7          	jalr	210(ra) # 80201170 <shutdown>
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    802000a6:	6605                	lui	a2,0x1
    802000a8:	4585                	li	a1,1
    802000aa:	8526                	mv	a0,s1
    802000ac:	00001097          	auipc	ra,0x1
    802000b0:	0f2080e7          	jalr	242(ra) # 8020119e <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    802000b4:	0058d797          	auipc	a5,0x58d
    802000b8:	f4c78793          	addi	a5,a5,-180 # 8078d000 <kmem>
    802000bc:	6398                	ld	a4,0(a5)
    802000be:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    802000c0:	e384                	sd	s1,0(a5)
}
    802000c2:	60e2                	ld	ra,24(sp)
    802000c4:	6442                	ld	s0,16(sp)
    802000c6:	64a2                	ld	s1,8(sp)
    802000c8:	6105                	addi	sp,sp,32
    802000ca:	8082                	ret

00000000802000cc <freerange>:
{
    802000cc:	7179                	addi	sp,sp,-48
    802000ce:	f406                	sd	ra,40(sp)
    802000d0:	f022                	sd	s0,32(sp)
    802000d2:	ec26                	sd	s1,24(sp)
    802000d4:	e84a                	sd	s2,16(sp)
    802000d6:	e44e                	sd	s3,8(sp)
    802000d8:	e052                	sd	s4,0(sp)
    802000da:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    802000dc:	6785                	lui	a5,0x1
    802000de:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    802000e2:	94aa                	add	s1,s1,a0
    802000e4:	757d                	lui	a0,0xfffff
    802000e6:	8ce9                	and	s1,s1,a0
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000e8:	94be                	add	s1,s1,a5
    802000ea:	0095ee63          	bltu	a1,s1,80200106 <freerange+0x3a>
    802000ee:	892e                	mv	s2,a1
		kfree(p);
    802000f0:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000f2:	6985                	lui	s3,0x1
		kfree(p);
    802000f4:	01448533          	add	a0,s1,s4
    802000f8:	00000097          	auipc	ra,0x0
    802000fc:	f50080e7          	jalr	-176(ra) # 80200048 <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80200100:	94ce                	add	s1,s1,s3
    80200102:	fe9979e3          	bgeu	s2,s1,802000f4 <freerange+0x28>
}
    80200106:	70a2                	ld	ra,40(sp)
    80200108:	7402                	ld	s0,32(sp)
    8020010a:	64e2                	ld	s1,24(sp)
    8020010c:	6942                	ld	s2,16(sp)
    8020010e:	69a2                	ld	s3,8(sp)
    80200110:	6a02                	ld	s4,0(sp)
    80200112:	6145                	addi	sp,sp,48
    80200114:	8082                	ret

0000000080200116 <kinit>:
{
    80200116:	1141                	addi	sp,sp,-16
    80200118:	e406                	sd	ra,8(sp)
    8020011a:	e022                	sd	s0,0(sp)
    8020011c:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    8020011e:	45c5                	li	a1,17
    80200120:	05ee                	slli	a1,a1,0x1b
    80200122:	0058e517          	auipc	a0,0x58e
    80200126:	ede50513          	addi	a0,a0,-290 # 8078e000 <e_bss>
    8020012a:	00000097          	auipc	ra,0x0
    8020012e:	fa2080e7          	jalr	-94(ra) # 802000cc <freerange>
}
    80200132:	60a2                	ld	ra,8(sp)
    80200134:	6402                	ld	s0,0(sp)
    80200136:	0141                	addi	sp,sp,16
    80200138:	8082                	ret

000000008020013a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc()
{
    8020013a:	1101                	addi	sp,sp,-32
    8020013c:	ec06                	sd	ra,24(sp)
    8020013e:	e822                	sd	s0,16(sp)
    80200140:	e426                	sd	s1,8(sp)
    80200142:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    80200144:	0058d497          	auipc	s1,0x58d
    80200148:	ebc4b483          	ld	s1,-324(s1) # 8078d000 <kmem>
	if (l) {
    8020014c:	cc89                	beqz	s1,80200166 <kalloc+0x2c>
		kmem.freelist = l->next;
    8020014e:	609c                	ld	a5,0(s1)
    80200150:	0058d717          	auipc	a4,0x58d
    80200154:	eaf73823          	sd	a5,-336(a4) # 8078d000 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    80200158:	6605                	lui	a2,0x1
    8020015a:	4595                	li	a1,5
    8020015c:	8526                	mv	a0,s1
    8020015e:	00001097          	auipc	ra,0x1
    80200162:	040080e7          	jalr	64(ra) # 8020119e <memset>
	}
	return (void *)l;
    80200166:	8526                	mv	a0,s1
    80200168:	60e2                	ld	ra,24(sp)
    8020016a:	6442                	ld	s0,16(sp)
    8020016c:	64a2                	ld	s1,8(sp)
    8020016e:	6105                	addi	sp,sp,32
    80200170:	8082                	ret

0000000080200172 <loader_init>:
extern char _app_num[], _app_names[], INIT_PROC[];
char names[MAX_APP_NUM][MAX_STR_LEN];

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void loader_init()
{
    80200172:	7139                	addi	sp,sp,-64
    80200174:	fc06                	sd	ra,56(sp)
    80200176:	f822                	sd	s0,48(sp)
    80200178:	f426                	sd	s1,40(sp)
    8020017a:	f04a                	sd	s2,32(sp)
    8020017c:	ec4e                	sd	s3,24(sp)
    8020017e:	e852                	sd	s4,16(sp)
    80200180:	e456                	sd	s5,8(sp)
    80200182:	e05a                	sd	s6,0(sp)
    80200184:	0080                	addi	s0,sp,64
	char *s;
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    80200186:	0058d497          	auipc	s1,0x58d
    8020018a:	e8a48493          	addi	s1,s1,-374 # 8078d010 <app_num>
    8020018e:	00005697          	auipc	a3,0x5
    80200192:	e7268693          	addi	a3,a3,-398 # 80205000 <_app_num>
    80200196:	0006c783          	lbu	a5,0(a3)
    8020019a:	0016c703          	lbu	a4,1(a3)
    8020019e:	0722                	slli	a4,a4,0x8
    802001a0:	8f5d                	or	a4,a4,a5
    802001a2:	0026c783          	lbu	a5,2(a3)
    802001a6:	07c2                	slli	a5,a5,0x10
    802001a8:	8f5d                	or	a4,a4,a5
    802001aa:	0036c783          	lbu	a5,3(a3)
    802001ae:	07e2                	slli	a5,a5,0x18
    802001b0:	8fd9                	or	a5,a5,a4
    802001b2:	c09c                	sw	a5,0(s1)
	app_info_ptr++;
    802001b4:	00005797          	auipc	a5,0x5
    802001b8:	e5478793          	addi	a5,a5,-428 # 80205008 <_app_num+0x8>
    802001bc:	0058d717          	auipc	a4,0x58d
    802001c0:	e4f73623          	sd	a5,-436(a4) # 8078d008 <app_info_ptr>
	s = _app_names;
	printf("app list:\n");
    802001c4:	00004517          	auipc	a0,0x4
    802001c8:	e7450513          	addi	a0,a0,-396 # 80204038 <e_text+0x38>
    802001cc:	00000097          	auipc	ra,0x0
    802001d0:	5ae080e7          	jalr	1454(ra) # 8020077a <printf>
	for (int i = 0; i < app_num; ++i) {
    802001d4:	409c                	lw	a5,0(s1)
    802001d6:	04f05c63          	blez	a5,8020022e <loader_init+0xbc>
    802001da:	00064997          	auipc	s3,0x64
    802001de:	e2698993          	addi	s3,s3,-474 # 80264000 <names>
    802001e2:	4a01                	li	s4,0
	s = _app_names;
    802001e4:	00005917          	auipc	s2,0x5
    802001e8:	f5c90913          	addi	s2,s2,-164 # 80205140 <_app_names>
		int len = strlen(s);
		strncpy(names[i], (const char *)s, len);
		s += len + 1;
		printf("%s\n", names[i]);
    802001ec:	00004b17          	auipc	s6,0x4
    802001f0:	e5cb0b13          	addi	s6,s6,-420 # 80204048 <e_text+0x48>
	for (int i = 0; i < app_num; ++i) {
    802001f4:	8aa6                	mv	s5,s1
		int len = strlen(s);
    802001f6:	854a                	mv	a0,s2
    802001f8:	00001097          	auipc	ra,0x1
    802001fc:	12a080e7          	jalr	298(ra) # 80201322 <strlen>
    80200200:	84aa                	mv	s1,a0
		strncpy(names[i], (const char *)s, len);
    80200202:	862a                	mv	a2,a0
    80200204:	85ca                	mv	a1,s2
    80200206:	854e                	mv	a0,s3
    80200208:	00001097          	auipc	ra,0x1
    8020020c:	0aa080e7          	jalr	170(ra) # 802012b2 <strncpy>
		s += len + 1;
    80200210:	0485                	addi	s1,s1,1
    80200212:	9926                	add	s2,s2,s1
		printf("%s\n", names[i]);
    80200214:	85ce                	mv	a1,s3
    80200216:	855a                	mv	a0,s6
    80200218:	00000097          	auipc	ra,0x0
    8020021c:	562080e7          	jalr	1378(ra) # 8020077a <printf>
	for (int i = 0; i < app_num; ++i) {
    80200220:	2a05                	addiw	s4,s4,1
    80200222:	0c898993          	addi	s3,s3,200
    80200226:	000aa783          	lw	a5,0(s5)
    8020022a:	fcfa46e3          	blt	s4,a5,802001f6 <loader_init+0x84>
	}
}
    8020022e:	70e2                	ld	ra,56(sp)
    80200230:	7442                	ld	s0,48(sp)
    80200232:	74a2                	ld	s1,40(sp)
    80200234:	7902                	ld	s2,32(sp)
    80200236:	69e2                	ld	s3,24(sp)
    80200238:	6a42                	ld	s4,16(sp)
    8020023a:	6aa2                	ld	s5,8(sp)
    8020023c:	6b02                	ld	s6,0(sp)
    8020023e:	6121                	addi	sp,sp,64
    80200240:	8082                	ret

0000000080200242 <get_id_by_name>:

int get_id_by_name(char *name)
{
    80200242:	7179                	addi	sp,sp,-48
    80200244:	f406                	sd	ra,40(sp)
    80200246:	f022                	sd	s0,32(sp)
    80200248:	ec26                	sd	s1,24(sp)
    8020024a:	e84a                	sd	s2,16(sp)
    8020024c:	e44e                	sd	s3,8(sp)
    8020024e:	e052                	sd	s4,0(sp)
    80200250:	1800                	addi	s0,sp,48
    80200252:	89aa                	mv	s3,a0
	for (int i = 0; i < app_num; ++i) {
    80200254:	0058d797          	auipc	a5,0x58d
    80200258:	dbc7a783          	lw	a5,-580(a5) # 8078d010 <app_num>
    8020025c:	02f05b63          	blez	a5,80200292 <get_id_by_name+0x50>
    80200260:	00064917          	auipc	s2,0x64
    80200264:	da090913          	addi	s2,s2,-608 # 80264000 <names>
    80200268:	4481                	li	s1,0
    8020026a:	0058da17          	auipc	s4,0x58d
    8020026e:	da6a0a13          	addi	s4,s4,-602 # 8078d010 <app_num>
		if (strncmp(name, names[i], 100) == 0)
    80200272:	06400613          	li	a2,100
    80200276:	85ca                	mv	a1,s2
    80200278:	854e                	mv	a0,s3
    8020027a:	00001097          	auipc	ra,0x1
    8020027e:	ffc080e7          	jalr	-4(ra) # 80201276 <strncmp>
    80200282:	cd19                	beqz	a0,802002a0 <get_id_by_name+0x5e>
	for (int i = 0; i < app_num; ++i) {
    80200284:	2485                	addiw	s1,s1,1
    80200286:	0c890913          	addi	s2,s2,200
    8020028a:	000a2783          	lw	a5,0(s4)
    8020028e:	fef4c2e3          	blt	s1,a5,80200272 <get_id_by_name+0x30>
			return i;
	}
	warnf("Cannot find such app %s", name);
    80200292:	85ce                	mv	a1,s3
    80200294:	4501                	li	a0,0
    80200296:	00001097          	auipc	ra,0x1
    8020029a:	0b6080e7          	jalr	182(ra) # 8020134c <dummy>
	return -1;
    8020029e:	54fd                	li	s1,-1
}
    802002a0:	8526                	mv	a0,s1
    802002a2:	70a2                	ld	ra,40(sp)
    802002a4:	7402                	ld	s0,32(sp)
    802002a6:	64e2                	ld	s1,24(sp)
    802002a8:	6942                	ld	s2,16(sp)
    802002aa:	69a2                	ld	s3,8(sp)
    802002ac:	6a02                	ld	s4,0(sp)
    802002ae:	6145                	addi	sp,sp,48
    802002b0:	8082                	ret

00000000802002b2 <bin_loader>:

int bin_loader(uint64 start, uint64 end, struct proc *p)
{
    802002b2:	7119                	addi	sp,sp,-128
    802002b4:	fc86                	sd	ra,120(sp)
    802002b6:	f8a2                	sd	s0,112(sp)
    802002b8:	f4a6                	sd	s1,104(sp)
    802002ba:	f0ca                	sd	s2,96(sp)
    802002bc:	ecce                	sd	s3,88(sp)
    802002be:	e8d2                	sd	s4,80(sp)
    802002c0:	e4d6                	sd	s5,72(sp)
    802002c2:	e0da                	sd	s6,64(sp)
    802002c4:	fc5e                	sd	s7,56(sp)
    802002c6:	f862                	sd	s8,48(sp)
    802002c8:	f466                	sd	s9,40(sp)
    802002ca:	f06a                	sd	s10,32(sp)
    802002cc:	ec6e                	sd	s11,24(sp)
    802002ce:	0100                	addi	s0,sp,128
    802002d0:	8caa                	mv	s9,a0
    802002d2:	8c2e                	mv	s8,a1
    802002d4:	8a32                	mv	s4,a2
	if (p == NULL || p->state == UNUSED)
    802002d6:	c219                	beqz	a2,802002dc <bin_loader+0x2a>
    802002d8:	421c                	lw	a5,0(a2)
    802002da:	ef8d                	bnez	a5,80200314 <bin_loader+0x62>
		panic("...");
    802002dc:	00000097          	auipc	ra,0x0
    802002e0:	674080e7          	jalr	1652(ra) # 80200950 <threadid>
    802002e4:	86aa                	mv	a3,a0
    802002e6:	02800793          	li	a5,40
    802002ea:	00004717          	auipc	a4,0x4
    802002ee:	d6670713          	addi	a4,a4,-666 # 80204050 <e_text+0x50>
    802002f2:	00004617          	auipc	a2,0x4
    802002f6:	d1e60613          	addi	a2,a2,-738 # 80204010 <e_text+0x10>
    802002fa:	45fd                	li	a1,31
    802002fc:	00004517          	auipc	a0,0x4
    80200300:	d6450513          	addi	a0,a0,-668 # 80204060 <e_text+0x60>
    80200304:	00000097          	auipc	ra,0x0
    80200308:	476080e7          	jalr	1142(ra) # 8020077a <printf>
    8020030c:	00001097          	auipc	ra,0x1
    80200310:	e64080e7          	jalr	-412(ra) # 80201170 <shutdown>
	void *page;
	uint64 pa_start = PGROUNDDOWN(start);
    80200314:	77fd                	lui	a5,0xfffff
    80200316:	00fcf9b3          	and	s3,s9,a5
	uint64 pa_end = PGROUNDUP(end);
    8020031a:	6b05                	lui	s6,0x1
    8020031c:	1b7d                	addi	s6,s6,-1
    8020031e:	9b62                	add	s6,s6,s8
    80200320:	00fb7b33          	and	s6,s6,a5
	uint64 length = pa_end - pa_start;
    80200324:	6789                	lui	a5,0x2
    80200326:	97da                	add	a5,a5,s6
    80200328:	f8f43023          	sd	a5,-128(s0)
	uint64 va_start = BASE_ADDRESS;
	uint64 va_end = BASE_ADDRESS + length;
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    8020032c:	1169f563          	bgeu	s3,s6,80200436 <bin_loader+0x184>
    80200330:	84ce                	mv	s1,s3
    80200332:	6a85                	lui	s5,0x1
    80200334:	413a8d33          	sub	s10,s5,s3
	     va += PGSIZE, pa += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    80200338:	00004d97          	auipc	s11,0x4
    8020033c:	d18d8d93          	addi	s11,s11,-744 # 80204050 <e_text+0x50>
		}
		memmove(page, (const void *)pa, PGSIZE);
		if (pa < start) {
			memset(page, 0, start - va);
		} else if (pa + PAGE_SIZE > end) {
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    80200340:	6785                	lui	a5,0x1
    80200342:	418787bb          	subw	a5,a5,s8
    80200346:	f8f42623          	sw	a5,-116(s0)
			memset(page, 0, start - va);
    8020034a:	77fd                	lui	a5,0xfffff
    8020034c:	019787bb          	addw	a5,a5,s9
    80200350:	013787bb          	addw	a5,a5,s3
    80200354:	f8f42423          	sw	a5,-120(s0)
    80200358:	a09d                	j	802003be <bin_loader+0x10c>
			panic("...");
    8020035a:	00000097          	auipc	ra,0x0
    8020035e:	5f6080e7          	jalr	1526(ra) # 80200950 <threadid>
    80200362:	86aa                	mv	a3,a0
    80200364:	03300793          	li	a5,51
    80200368:	876e                	mv	a4,s11
    8020036a:	00004617          	auipc	a2,0x4
    8020036e:	ca660613          	addi	a2,a2,-858 # 80204010 <e_text+0x10>
    80200372:	45fd                	li	a1,31
    80200374:	00004517          	auipc	a0,0x4
    80200378:	cec50513          	addi	a0,a0,-788 # 80204060 <e_text+0x60>
    8020037c:	00000097          	auipc	ra,0x0
    80200380:	3fe080e7          	jalr	1022(ra) # 8020077a <printf>
    80200384:	00001097          	auipc	ra,0x1
    80200388:	dec080e7          	jalr	-532(ra) # 80201170 <shutdown>
    8020038c:	a089                	j	802003ce <bin_loader+0x11c>
			memset(page, 0, start - va);
    8020038e:	f8842783          	lw	a5,-120(s0)
    80200392:	4097863b          	subw	a2,a5,s1
    80200396:	4581                	li	a1,0
    80200398:	854a                	mv	a0,s2
    8020039a:	00001097          	auipc	ra,0x1
    8020039e:	e04080e7          	jalr	-508(ra) # 8020119e <memset>
		}
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802003a2:	4779                	li	a4,30
    802003a4:	86ca                	mv	a3,s2
    802003a6:	8656                	mv	a2,s5
    802003a8:	85de                	mv	a1,s7
    802003aa:	008a3503          	ld	a0,8(s4)
    802003ae:	00002097          	auipc	ra,0x2
    802003b2:	c74080e7          	jalr	-908(ra) # 80202022 <mappages>
    802003b6:	e531                	bnez	a0,80200402 <bin_loader+0x150>
	     va += PGSIZE, pa += PGSIZE) {
    802003b8:	94d6                	add	s1,s1,s5
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    802003ba:	0764fe63          	bgeu	s1,s6,80200436 <bin_loader+0x184>
    802003be:	009d0bb3          	add	s7,s10,s1
		page = kalloc();
    802003c2:	00000097          	auipc	ra,0x0
    802003c6:	d78080e7          	jalr	-648(ra) # 8020013a <kalloc>
    802003ca:	892a                	mv	s2,a0
		if (page == 0) {
    802003cc:	d559                	beqz	a0,8020035a <bin_loader+0xa8>
		memmove(page, (const void *)pa, PGSIZE);
    802003ce:	8656                	mv	a2,s5
    802003d0:	85a6                	mv	a1,s1
    802003d2:	854a                	mv	a0,s2
    802003d4:	00001097          	auipc	ra,0x1
    802003d8:	e26080e7          	jalr	-474(ra) # 802011fa <memmove>
		if (pa < start) {
    802003dc:	fb94e9e3          	bltu	s1,s9,8020038e <bin_loader+0xdc>
		} else if (pa + PAGE_SIZE > end) {
    802003e0:	015487b3          	add	a5,s1,s5
    802003e4:	fafc7fe3          	bgeu	s8,a5,802003a2 <bin_loader+0xf0>
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    802003e8:	409c0533          	sub	a0,s8,s1
    802003ec:	f8c42783          	lw	a5,-116(s0)
    802003f0:	0097863b          	addw	a2,a5,s1
    802003f4:	4581                	li	a1,0
    802003f6:	954a                	add	a0,a0,s2
    802003f8:	00001097          	auipc	ra,0x1
    802003fc:	da6080e7          	jalr	-602(ra) # 8020119e <memset>
    80200400:	b74d                	j	802003a2 <bin_loader+0xf0>
			     PTE_U | PTE_R | PTE_W | PTE_X) != 0)
			panic("...");
    80200402:	00000097          	auipc	ra,0x0
    80200406:	54e080e7          	jalr	1358(ra) # 80200950 <threadid>
    8020040a:	86aa                	mv	a3,a0
    8020040c:	03d00793          	li	a5,61
    80200410:	876e                	mv	a4,s11
    80200412:	00004617          	auipc	a2,0x4
    80200416:	bfe60613          	addi	a2,a2,-1026 # 80204010 <e_text+0x10>
    8020041a:	45fd                	li	a1,31
    8020041c:	00004517          	auipc	a0,0x4
    80200420:	c4450513          	addi	a0,a0,-956 # 80204060 <e_text+0x60>
    80200424:	00000097          	auipc	ra,0x0
    80200428:	356080e7          	jalr	854(ra) # 8020077a <printf>
    8020042c:	00001097          	auipc	ra,0x1
    80200430:	d44080e7          	jalr	-700(ra) # 80201170 <shutdown>
    80200434:	b751                	j	802003b8 <bin_loader+0x106>
	}
	// map ustack
	p->ustack = va_end + PAGE_SIZE;
    80200436:	f8043783          	ld	a5,-128(s0)
    8020043a:	413789b3          	sub	s3,a5,s3
    8020043e:	013a3823          	sd	s3,16(s4)
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200442:	6785                	lui	a5,0x1
    80200444:	97ce                	add	a5,a5,s3
    80200446:	0af9f663          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
	     va += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    8020044a:	00004b17          	auipc	s6,0x4
    8020044e:	c06b0b13          	addi	s6,s6,-1018 # 80204050 <e_text+0x50>
    80200452:	00004a97          	auipc	s5,0x4
    80200456:	bbea8a93          	addi	s5,s5,-1090 # 80204010 <e_text+0x10>
    8020045a:	00004917          	auipc	s2,0x4
    8020045e:	c0690913          	addi	s2,s2,-1018 # 80204060 <e_text+0x60>
    80200462:	a825                	j	8020049a <bin_loader+0x1e8>
    80200464:	00000097          	auipc	ra,0x0
    80200468:	4ec080e7          	jalr	1260(ra) # 80200950 <threadid>
    8020046c:	86aa                	mv	a3,a0
    8020046e:	04500793          	li	a5,69
    80200472:	875a                	mv	a4,s6
    80200474:	8656                	mv	a2,s5
    80200476:	45fd                	li	a1,31
    80200478:	854a                	mv	a0,s2
    8020047a:	00000097          	auipc	ra,0x0
    8020047e:	300080e7          	jalr	768(ra) # 8020077a <printf>
    80200482:	00001097          	auipc	ra,0x1
    80200486:	cee080e7          	jalr	-786(ra) # 80201170 <shutdown>
    8020048a:	a831                	j	802004a6 <bin_loader+0x1f4>
	     va += PGSIZE) {
    8020048c:	6785                	lui	a5,0x1
    8020048e:	99be                	add	s3,s3,a5
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200490:	010a3703          	ld	a4,16(s4)
    80200494:	97ba                	add	a5,a5,a4
    80200496:	04f9fe63          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
		page = kalloc();
    8020049a:	00000097          	auipc	ra,0x0
    8020049e:	ca0080e7          	jalr	-864(ra) # 8020013a <kalloc>
    802004a2:	84aa                	mv	s1,a0
		if (page == 0) {
    802004a4:	d161                	beqz	a0,80200464 <bin_loader+0x1b2>
		}
		memset(page, 0, PGSIZE);
    802004a6:	6605                	lui	a2,0x1
    802004a8:	4581                	li	a1,0
    802004aa:	8526                	mv	a0,s1
    802004ac:	00001097          	auipc	ra,0x1
    802004b0:	cf2080e7          	jalr	-782(ra) # 8020119e <memset>
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802004b4:	4759                	li	a4,22
    802004b6:	86a6                	mv	a3,s1
    802004b8:	6605                	lui	a2,0x1
    802004ba:	85ce                	mv	a1,s3
    802004bc:	008a3503          	ld	a0,8(s4)
    802004c0:	00002097          	auipc	ra,0x2
    802004c4:	b62080e7          	jalr	-1182(ra) # 80202022 <mappages>
    802004c8:	d171                	beqz	a0,8020048c <bin_loader+0x1da>
			     PTE_U | PTE_R | PTE_W) != 0)
			panic("...");
    802004ca:	00000097          	auipc	ra,0x0
    802004ce:	486080e7          	jalr	1158(ra) # 80200950 <threadid>
    802004d2:	86aa                	mv	a3,a0
    802004d4:	04a00793          	li	a5,74
    802004d8:	875a                	mv	a4,s6
    802004da:	8656                	mv	a2,s5
    802004dc:	45fd                	li	a1,31
    802004de:	854a                	mv	a0,s2
    802004e0:	00000097          	auipc	ra,0x0
    802004e4:	29a080e7          	jalr	666(ra) # 8020077a <printf>
    802004e8:	00001097          	auipc	ra,0x1
    802004ec:	c88080e7          	jalr	-888(ra) # 80201170 <shutdown>
    802004f0:	bf71                	j	8020048c <bin_loader+0x1da>
	}
	p->trapframe->sp = p->ustack + USTACK_SIZE;
    802004f2:	020a3703          	ld	a4,32(s4)
    802004f6:	fb1c                	sd	a5,48(a4)
	p->trapframe->epc = va_start;
    802004f8:	020a3783          	ld	a5,32(s4)
    802004fc:	6705                	lui	a4,0x1
    802004fe:	ef98                	sd	a4,24(a5)
	p->max_page = PGROUNDUP(p->ustack + USTACK_SIZE - 1) / PAGE_SIZE;
    80200500:	010a3783          	ld	a5,16(s4)
    80200504:	6709                	lui	a4,0x2
    80200506:	1779                	addi	a4,a4,-2
    80200508:	97ba                	add	a5,a5,a4
    8020050a:	83b1                	srli	a5,a5,0xc
    8020050c:	08fa3c23          	sd	a5,152(s4)
	p->state = RUNNABLE;
    80200510:	478d                	li	a5,3
    80200512:	00fa2023          	sw	a5,0(s4)
	return 0;
}
    80200516:	4501                	li	a0,0
    80200518:	70e6                	ld	ra,120(sp)
    8020051a:	7446                	ld	s0,112(sp)
    8020051c:	74a6                	ld	s1,104(sp)
    8020051e:	7906                	ld	s2,96(sp)
    80200520:	69e6                	ld	s3,88(sp)
    80200522:	6a46                	ld	s4,80(sp)
    80200524:	6aa6                	ld	s5,72(sp)
    80200526:	6b06                	ld	s6,64(sp)
    80200528:	7be2                	ld	s7,56(sp)
    8020052a:	7c42                	ld	s8,48(sp)
    8020052c:	7ca2                	ld	s9,40(sp)
    8020052e:	7d02                	ld	s10,32(sp)
    80200530:	6de2                	ld	s11,24(sp)
    80200532:	6109                	addi	sp,sp,128
    80200534:	8082                	ret

0000000080200536 <loader>:

int loader(int app_id, struct proc *p)
{
    80200536:	1141                	addi	sp,sp,-16
    80200538:	e406                	sd	ra,8(sp)
    8020053a:	e022                	sd	s0,0(sp)
    8020053c:	0800                	addi	s0,sp,16
    8020053e:	862e                	mv	a2,a1
	return bin_loader(app_info_ptr[app_id], app_info_ptr[app_id + 1], p);
    80200540:	00351793          	slli	a5,a0,0x3
    80200544:	0058d517          	auipc	a0,0x58d
    80200548:	ac453503          	ld	a0,-1340(a0) # 8078d008 <app_info_ptr>
    8020054c:	953e                	add	a0,a0,a5
    8020054e:	650c                	ld	a1,8(a0)
    80200550:	6108                	ld	a0,0(a0)
    80200552:	00000097          	auipc	ra,0x0
    80200556:	d60080e7          	jalr	-672(ra) # 802002b2 <bin_loader>
}
    8020055a:	60a2                	ld	ra,8(sp)
    8020055c:	6402                	ld	s0,0(sp)
    8020055e:	0141                	addi	sp,sp,16
    80200560:	8082                	ret

0000000080200562 <load_init_app>:

// load all apps and init the corresponding `proc` structure.
int load_init_app()
{
    80200562:	1101                	addi	sp,sp,-32
    80200564:	ec06                	sd	ra,24(sp)
    80200566:	e822                	sd	s0,16(sp)
    80200568:	e426                	sd	s1,8(sp)
    8020056a:	e04a                	sd	s2,0(sp)
    8020056c:	1000                	addi	s0,sp,32
	int id = get_id_by_name(INIT_PROC);
    8020056e:	00005517          	auipc	a0,0x5
    80200572:	da050513          	addi	a0,a0,-608 # 8020530e <INIT_PROC>
    80200576:	00000097          	auipc	ra,0x0
    8020057a:	ccc080e7          	jalr	-820(ra) # 80200242 <get_id_by_name>
    8020057e:	892a                	mv	s2,a0
	if (id < 0)
    80200580:	04054363          	bltz	a0,802005c6 <load_init_app+0x64>
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
	struct proc *p = allocproc();
    80200584:	00000097          	auipc	ra,0x0
    80200588:	584080e7          	jalr	1412(ra) # 80200b08 <allocproc>
    8020058c:	84aa                	mv	s1,a0
	if (p == NULL) {
    8020058e:	cd2d                	beqz	a0,80200608 <load_init_app+0xa6>
		panic("allocproc\n");
	}
	debugf("load init proc %s", INIT_PROC);
    80200590:	00005597          	auipc	a1,0x5
    80200594:	d7e58593          	addi	a1,a1,-642 # 8020530e <INIT_PROC>
    80200598:	4501                	li	a0,0
    8020059a:	00001097          	auipc	ra,0x1
    8020059e:	db2080e7          	jalr	-590(ra) # 8020134c <dummy>
	loader(id, p);
    802005a2:	85a6                	mv	a1,s1
    802005a4:	854a                	mv	a0,s2
    802005a6:	00000097          	auipc	ra,0x0
    802005aa:	f90080e7          	jalr	-112(ra) # 80200536 <loader>
	add_task(p);
    802005ae:	8526                	mv	a0,s1
    802005b0:	00000097          	auipc	ra,0x0
    802005b4:	500080e7          	jalr	1280(ra) # 80200ab0 <add_task>
	return 0;
    802005b8:	4501                	li	a0,0
    802005ba:	60e2                	ld	ra,24(sp)
    802005bc:	6442                	ld	s0,16(sp)
    802005be:	64a2                	ld	s1,8(sp)
    802005c0:	6902                	ld	s2,0(sp)
    802005c2:	6105                	addi	sp,sp,32
    802005c4:	8082                	ret
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
    802005c6:	00000097          	auipc	ra,0x0
    802005ca:	38a080e7          	jalr	906(ra) # 80200950 <threadid>
    802005ce:	86aa                	mv	a3,a0
    802005d0:	00005817          	auipc	a6,0x5
    802005d4:	d3e80813          	addi	a6,a6,-706 # 8020530e <INIT_PROC>
    802005d8:	05d00793          	li	a5,93
    802005dc:	00004717          	auipc	a4,0x4
    802005e0:	a7470713          	addi	a4,a4,-1420 # 80204050 <e_text+0x50>
    802005e4:	00004617          	auipc	a2,0x4
    802005e8:	a2c60613          	addi	a2,a2,-1492 # 80204010 <e_text+0x10>
    802005ec:	45fd                	li	a1,31
    802005ee:	00004517          	auipc	a0,0x4
    802005f2:	a9250513          	addi	a0,a0,-1390 # 80204080 <e_text+0x80>
    802005f6:	00000097          	auipc	ra,0x0
    802005fa:	184080e7          	jalr	388(ra) # 8020077a <printf>
    802005fe:	00001097          	auipc	ra,0x1
    80200602:	b72080e7          	jalr	-1166(ra) # 80201170 <shutdown>
    80200606:	bfbd                	j	80200584 <load_init_app+0x22>
		panic("allocproc\n");
    80200608:	00000097          	auipc	ra,0x0
    8020060c:	348080e7          	jalr	840(ra) # 80200950 <threadid>
    80200610:	86aa                	mv	a3,a0
    80200612:	06000793          	li	a5,96
    80200616:	00004717          	auipc	a4,0x4
    8020061a:	a3a70713          	addi	a4,a4,-1478 # 80204050 <e_text+0x50>
    8020061e:	00004617          	auipc	a2,0x4
    80200622:	9f260613          	addi	a2,a2,-1550 # 80204010 <e_text+0x10>
    80200626:	45fd                	li	a1,31
    80200628:	00004517          	auipc	a0,0x4
    8020062c:	a9050513          	addi	a0,a0,-1392 # 802040b8 <e_text+0xb8>
    80200630:	00000097          	auipc	ra,0x0
    80200634:	14a080e7          	jalr	330(ra) # 8020077a <printf>
    80200638:	00001097          	auipc	ra,0x1
    8020063c:	b38080e7          	jalr	-1224(ra) # 80201170 <shutdown>
    80200640:	bf81                	j	80200590 <load_init_app+0x2e>

0000000080200642 <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    80200642:	1141                	addi	sp,sp,-16
    80200644:	e406                	sd	ra,8(sp)
    80200646:	e022                	sd	s0,0(sp)
    80200648:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    8020064a:	00064517          	auipc	a0,0x64
    8020064e:	9b650513          	addi	a0,a0,-1610 # 80264000 <names>
    80200652:	0058e617          	auipc	a2,0x58e
    80200656:	9ae60613          	addi	a2,a2,-1618 # 8078e000 <e_bss>
    8020065a:	9e09                	subw	a2,a2,a0
    8020065c:	4581                	li	a1,0
    8020065e:	00001097          	auipc	ra,0x1
    80200662:	b40080e7          	jalr	-1216(ra) # 8020119e <memset>
}
    80200666:	60a2                	ld	ra,8(sp)
    80200668:	6402                	ld	s0,0(sp)
    8020066a:	0141                	addi	sp,sp,16
    8020066c:	8082                	ret

000000008020066e <main>:

void main()
{
    8020066e:	1141                	addi	sp,sp,-16
    80200670:	e406                	sd	ra,8(sp)
    80200672:	e022                	sd	s0,0(sp)
    80200674:	0800                	addi	s0,sp,16
	clean_bss();
    80200676:	00000097          	auipc	ra,0x0
    8020067a:	fcc080e7          	jalr	-52(ra) # 80200642 <clean_bss>
	printf("hello world!\n");
    8020067e:	00004517          	auipc	a0,0x4
    80200682:	a6250513          	addi	a0,a0,-1438 # 802040e0 <e_text+0xe0>
    80200686:	00000097          	auipc	ra,0x0
    8020068a:	0f4080e7          	jalr	244(ra) # 8020077a <printf>
	proc_init();
    8020068e:	00000097          	auipc	ra,0x0
    80200692:	2ec080e7          	jalr	748(ra) # 8020097a <proc_init>
	kinit();
    80200696:	00000097          	auipc	ra,0x0
    8020069a:	a80080e7          	jalr	-1408(ra) # 80200116 <kinit>
	kvm_init();
    8020069e:	00002097          	auipc	ra,0x2
    802006a2:	b34080e7          	jalr	-1228(ra) # 802021d2 <kvm_init>
	loader_init();
    802006a6:	00000097          	auipc	ra,0x0
    802006aa:	acc080e7          	jalr	-1332(ra) # 80200172 <loader_init>
	trap_init();
    802006ae:	00001097          	auipc	ra,0x1
    802006b2:	5a0080e7          	jalr	1440(ra) # 80201c4e <trap_init>
	timer_init();
    802006b6:	00001097          	auipc	ra,0x1
    802006ba:	4a4080e7          	jalr	1188(ra) # 80201b5a <timer_init>
	load_init_app();
    802006be:	00000097          	auipc	ra,0x0
    802006c2:	ea4080e7          	jalr	-348(ra) # 80200562 <load_init_app>
	infof("start scheduler!");
    802006c6:	4501                	li	a0,0
    802006c8:	00001097          	auipc	ra,0x1
    802006cc:	c84080e7          	jalr	-892(ra) # 8020134c <dummy>
	scheduler();
    802006d0:	00000097          	auipc	ra,0x0
    802006d4:	4d8080e7          	jalr	1240(ra) # 80200ba8 <scheduler>

00000000802006d8 <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802006d8:	7179                	addi	sp,sp,-48
    802006da:	f406                	sd	ra,40(sp)
    802006dc:	f022                	sd	s0,32(sp)
    802006de:	ec26                	sd	s1,24(sp)
    802006e0:	e84a                	sd	s2,16(sp)
    802006e2:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    802006e4:	c219                	beqz	a2,802006ea <printint+0x12>
    802006e6:	08054663          	bltz	a0,80200772 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    802006ea:	2501                	sext.w	a0,a0
    802006ec:	4881                	li	a7,0
    802006ee:	fd040693          	addi	a3,s0,-48

	i = 0;
    802006f2:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    802006f4:	2581                	sext.w	a1,a1
    802006f6:	00004617          	auipc	a2,0x4
    802006fa:	a3a60613          	addi	a2,a2,-1478 # 80204130 <digits>
    802006fe:	883a                	mv	a6,a4
    80200700:	2705                	addiw	a4,a4,1
    80200702:	02b577bb          	remuw	a5,a0,a1
    80200706:	1782                	slli	a5,a5,0x20
    80200708:	9381                	srli	a5,a5,0x20
    8020070a:	97b2                	add	a5,a5,a2
    8020070c:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x801ff000>
    80200710:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    80200714:	0005079b          	sext.w	a5,a0
    80200718:	02b5553b          	divuw	a0,a0,a1
    8020071c:	0685                	addi	a3,a3,1
    8020071e:	feb7f0e3          	bgeu	a5,a1,802006fe <printint+0x26>

	if (sign)
    80200722:	00088b63          	beqz	a7,80200738 <printint+0x60>
		buf[i++] = '-';
    80200726:	fe040793          	addi	a5,s0,-32
    8020072a:	973e                	add	a4,a4,a5
    8020072c:	02d00793          	li	a5,45
    80200730:	fef70823          	sb	a5,-16(a4)
    80200734:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    80200738:	02e05763          	blez	a4,80200766 <printint+0x8e>
    8020073c:	fd040793          	addi	a5,s0,-48
    80200740:	00e784b3          	add	s1,a5,a4
    80200744:	fff78913          	addi	s2,a5,-1
    80200748:	993a                	add	s2,s2,a4
    8020074a:	377d                	addiw	a4,a4,-1
    8020074c:	1702                	slli	a4,a4,0x20
    8020074e:	9301                	srli	a4,a4,0x20
    80200750:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    80200754:	fff4c503          	lbu	a0,-1(s1)
    80200758:	00000097          	auipc	ra,0x0
    8020075c:	8b4080e7          	jalr	-1868(ra) # 8020000c <consputc>
	while (--i >= 0)
    80200760:	14fd                	addi	s1,s1,-1
    80200762:	ff2499e3          	bne	s1,s2,80200754 <printint+0x7c>
}
    80200766:	70a2                	ld	ra,40(sp)
    80200768:	7402                	ld	s0,32(sp)
    8020076a:	64e2                	ld	s1,24(sp)
    8020076c:	6942                	ld	s2,16(sp)
    8020076e:	6145                	addi	sp,sp,48
    80200770:	8082                	ret
		x = -xx;
    80200772:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    80200776:	4885                	li	a7,1
		x = -xx;
    80200778:	bf9d                	j	802006ee <printint+0x16>

000000008020077a <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    8020077a:	7131                	addi	sp,sp,-192
    8020077c:	fc86                	sd	ra,120(sp)
    8020077e:	f8a2                	sd	s0,112(sp)
    80200780:	f4a6                	sd	s1,104(sp)
    80200782:	f0ca                	sd	s2,96(sp)
    80200784:	ecce                	sd	s3,88(sp)
    80200786:	e8d2                	sd	s4,80(sp)
    80200788:	e4d6                	sd	s5,72(sp)
    8020078a:	e0da                	sd	s6,64(sp)
    8020078c:	fc5e                	sd	s7,56(sp)
    8020078e:	f862                	sd	s8,48(sp)
    80200790:	f466                	sd	s9,40(sp)
    80200792:	f06a                	sd	s10,32(sp)
    80200794:	ec6e                	sd	s11,24(sp)
    80200796:	0100                	addi	s0,sp,128
    80200798:	8a2a                	mv	s4,a0
    8020079a:	e40c                	sd	a1,8(s0)
    8020079c:	e810                	sd	a2,16(s0)
    8020079e:	ec14                	sd	a3,24(s0)
    802007a0:	f018                	sd	a4,32(s0)
    802007a2:	f41c                	sd	a5,40(s0)
    802007a4:	03043823          	sd	a6,48(s0)
    802007a8:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802007ac:	c915                	beqz	a0,802007e0 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    802007ae:	00840793          	addi	a5,s0,8
    802007b2:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802007b6:	000a4503          	lbu	a0,0(s4)
    802007ba:	16050c63          	beqz	a0,80200932 <printf+0x1b8>
    802007be:	4981                	li	s3,0
		if (c != '%') {
    802007c0:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    802007c4:	07000b93          	li	s7,112
	consputc('x');
    802007c8:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802007ca:	00004b17          	auipc	s6,0x4
    802007ce:	966b0b13          	addi	s6,s6,-1690 # 80204130 <digits>
		switch (c) {
    802007d2:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802007d6:	02800d93          	li	s11,40
		switch (c) {
    802007da:	06400c13          	li	s8,100
    802007de:	a889                	j	80200830 <printf+0xb6>
		panic("null fmt");
    802007e0:	00000097          	auipc	ra,0x0
    802007e4:	170080e7          	jalr	368(ra) # 80200950 <threadid>
    802007e8:	86aa                	mv	a3,a0
    802007ea:	02e00793          	li	a5,46
    802007ee:	00004717          	auipc	a4,0x4
    802007f2:	90a70713          	addi	a4,a4,-1782 # 802040f8 <e_text+0xf8>
    802007f6:	00004617          	auipc	a2,0x4
    802007fa:	81a60613          	addi	a2,a2,-2022 # 80204010 <e_text+0x10>
    802007fe:	45fd                	li	a1,31
    80200800:	00004517          	auipc	a0,0x4
    80200804:	90850513          	addi	a0,a0,-1784 # 80204108 <e_text+0x108>
    80200808:	00000097          	auipc	ra,0x0
    8020080c:	f72080e7          	jalr	-142(ra) # 8020077a <printf>
    80200810:	00001097          	auipc	ra,0x1
    80200814:	960080e7          	jalr	-1696(ra) # 80201170 <shutdown>
    80200818:	bf59                	j	802007ae <printf+0x34>
			consputc(c);
    8020081a:	fffff097          	auipc	ra,0xfffff
    8020081e:	7f2080e7          	jalr	2034(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200822:	2985                	addiw	s3,s3,1
    80200824:	013a07b3          	add	a5,s4,s3
    80200828:	0007c503          	lbu	a0,0(a5)
    8020082c:	10050363          	beqz	a0,80200932 <printf+0x1b8>
		if (c != '%') {
    80200830:	ff5515e3          	bne	a0,s5,8020081a <printf+0xa0>
		c = fmt[++i] & 0xff;
    80200834:	2985                	addiw	s3,s3,1
    80200836:	013a07b3          	add	a5,s4,s3
    8020083a:	0007c783          	lbu	a5,0(a5)
    8020083e:	0007849b          	sext.w	s1,a5
		if (c == 0)
    80200842:	cbe5                	beqz	a5,80200932 <printf+0x1b8>
		switch (c) {
    80200844:	05778a63          	beq	a5,s7,80200898 <printf+0x11e>
    80200848:	02fbf663          	bgeu	s7,a5,80200874 <printf+0xfa>
    8020084c:	09978863          	beq	a5,s9,802008dc <printf+0x162>
    80200850:	07800713          	li	a4,120
    80200854:	0ce79463          	bne	a5,a4,8020091c <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    80200858:	f8843783          	ld	a5,-120(s0)
    8020085c:	00878713          	addi	a4,a5,8
    80200860:	f8e43423          	sd	a4,-120(s0)
    80200864:	4605                	li	a2,1
    80200866:	85ea                	mv	a1,s10
    80200868:	4388                	lw	a0,0(a5)
    8020086a:	00000097          	auipc	ra,0x0
    8020086e:	e6e080e7          	jalr	-402(ra) # 802006d8 <printint>
			break;
    80200872:	bf45                	j	80200822 <printf+0xa8>
		switch (c) {
    80200874:	09578e63          	beq	a5,s5,80200910 <printf+0x196>
    80200878:	0b879263          	bne	a5,s8,8020091c <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    8020087c:	f8843783          	ld	a5,-120(s0)
    80200880:	00878713          	addi	a4,a5,8
    80200884:	f8e43423          	sd	a4,-120(s0)
    80200888:	4605                	li	a2,1
    8020088a:	45a9                	li	a1,10
    8020088c:	4388                	lw	a0,0(a5)
    8020088e:	00000097          	auipc	ra,0x0
    80200892:	e4a080e7          	jalr	-438(ra) # 802006d8 <printint>
			break;
    80200896:	b771                	j	80200822 <printf+0xa8>
			printptr(va_arg(ap, uint64));
    80200898:	f8843783          	ld	a5,-120(s0)
    8020089c:	00878713          	addi	a4,a5,8
    802008a0:	f8e43423          	sd	a4,-120(s0)
    802008a4:	0007b903          	ld	s2,0(a5)
	consputc('0');
    802008a8:	03000513          	li	a0,48
    802008ac:	fffff097          	auipc	ra,0xfffff
    802008b0:	760080e7          	jalr	1888(ra) # 8020000c <consputc>
	consputc('x');
    802008b4:	07800513          	li	a0,120
    802008b8:	fffff097          	auipc	ra,0xfffff
    802008bc:	754080e7          	jalr	1876(ra) # 8020000c <consputc>
    802008c0:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802008c2:	03c95793          	srli	a5,s2,0x3c
    802008c6:	97da                	add	a5,a5,s6
    802008c8:	0007c503          	lbu	a0,0(a5)
    802008cc:	fffff097          	auipc	ra,0xfffff
    802008d0:	740080e7          	jalr	1856(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    802008d4:	0912                	slli	s2,s2,0x4
    802008d6:	34fd                	addiw	s1,s1,-1
    802008d8:	f4ed                	bnez	s1,802008c2 <printf+0x148>
    802008da:	b7a1                	j	80200822 <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    802008dc:	f8843783          	ld	a5,-120(s0)
    802008e0:	00878713          	addi	a4,a5,8
    802008e4:	f8e43423          	sd	a4,-120(s0)
    802008e8:	6384                	ld	s1,0(a5)
    802008ea:	cc89                	beqz	s1,80200904 <printf+0x18a>
			for (; *s; s++)
    802008ec:	0004c503          	lbu	a0,0(s1)
    802008f0:	d90d                	beqz	a0,80200822 <printf+0xa8>
				consputc(*s);
    802008f2:	fffff097          	auipc	ra,0xfffff
    802008f6:	71a080e7          	jalr	1818(ra) # 8020000c <consputc>
			for (; *s; s++)
    802008fa:	0485                	addi	s1,s1,1
    802008fc:	0004c503          	lbu	a0,0(s1)
    80200900:	f96d                	bnez	a0,802008f2 <printf+0x178>
    80200902:	b705                	j	80200822 <printf+0xa8>
				s = "(null)";
    80200904:	00003497          	auipc	s1,0x3
    80200908:	7ec48493          	addi	s1,s1,2028 # 802040f0 <e_text+0xf0>
			for (; *s; s++)
    8020090c:	856e                	mv	a0,s11
    8020090e:	b7d5                	j	802008f2 <printf+0x178>
			break;
		case '%':
			consputc('%');
    80200910:	8556                	mv	a0,s5
    80200912:	fffff097          	auipc	ra,0xfffff
    80200916:	6fa080e7          	jalr	1786(ra) # 8020000c <consputc>
			break;
    8020091a:	b721                	j	80200822 <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020091c:	8556                	mv	a0,s5
    8020091e:	fffff097          	auipc	ra,0xfffff
    80200922:	6ee080e7          	jalr	1774(ra) # 8020000c <consputc>
			consputc(c);
    80200926:	8526                	mv	a0,s1
    80200928:	fffff097          	auipc	ra,0xfffff
    8020092c:	6e4080e7          	jalr	1764(ra) # 8020000c <consputc>
			break;
    80200930:	bdcd                	j	80200822 <printf+0xa8>
		}
	}
    80200932:	70e6                	ld	ra,120(sp)
    80200934:	7446                	ld	s0,112(sp)
    80200936:	74a6                	ld	s1,104(sp)
    80200938:	7906                	ld	s2,96(sp)
    8020093a:	69e6                	ld	s3,88(sp)
    8020093c:	6a46                	ld	s4,80(sp)
    8020093e:	6aa6                	ld	s5,72(sp)
    80200940:	6b06                	ld	s6,64(sp)
    80200942:	7be2                	ld	s7,56(sp)
    80200944:	7c42                	ld	s8,48(sp)
    80200946:	7ca2                	ld	s9,40(sp)
    80200948:	7d02                	ld	s10,32(sp)
    8020094a:	6de2                	ld	s11,24(sp)
    8020094c:	6129                	addi	sp,sp,192
    8020094e:	8082                	ret

0000000080200950 <threadid>:
struct proc *current_proc;
struct proc idle;
struct queue task_queue;

int threadid()
{
    80200950:	1141                	addi	sp,sp,-16
    80200952:	e422                	sd	s0,8(sp)
    80200954:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    80200956:	0058c797          	auipc	a5,0x58c
    8020095a:	6c27b783          	ld	a5,1730(a5) # 8078d018 <current_proc>
    8020095e:	43c8                	lw	a0,4(a5)
    80200960:	6422                	ld	s0,8(sp)
    80200962:	0141                	addi	sp,sp,16
    80200964:	8082                	ret

0000000080200966 <curr_proc>:

struct proc *curr_proc()
{
    80200966:	1141                	addi	sp,sp,-16
    80200968:	e422                	sd	s0,8(sp)
    8020096a:	0800                	addi	s0,sp,16
	return current_proc;
}
    8020096c:	0058c517          	auipc	a0,0x58c
    80200970:	6ac53503          	ld	a0,1708(a0) # 8078d018 <current_proc>
    80200974:	6422                	ld	s0,8(sp)
    80200976:	0141                	addi	sp,sp,16
    80200978:	8082                	ret

000000008020097a <proc_init>:

// initialize the proc table at boot time.
void proc_init()
{
    8020097a:	1141                	addi	sp,sp,-16
    8020097c:	e406                	sd	ra,8(sp)
    8020097e:	e022                	sd	s0,0(sp)
    80200980:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200982:	00562617          	auipc	a2,0x562
    80200986:	67e60613          	addi	a2,a2,1662 # 80763000 <pool>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    8020098a:	8fb2                	mv	t6,a2
    8020098c:	00004f17          	auipc	t5,0x4
    80200990:	cecf3f03          	ld	t5,-788(t5) # 80204678 <digits+0x548>
    80200994:	00362e97          	auipc	t4,0x362
    80200998:	66ce8e93          	addi	t4,t4,1644 # 80563000 <kstack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    8020099c:	00162e17          	auipc	t3,0x162
    802009a0:	664e0e13          	addi	t3,t3,1636 # 80363000 <trapframe>
		p->ti = &task_infos[p - pool];
    802009a4:	7d800313          	li	t1,2008
    802009a8:	00066897          	auipc	a7,0x66
    802009ac:	7b888893          	addi	a7,a7,1976 # 80267160 <task_infos>
		p->ti->status = UnInit;
		for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    802009b0:	4801                	li	a6,0
    802009b2:	1f400593          	li	a1,500
	for (p = pool; p < &pool[NPROC]; p++) {
    802009b6:	0058c517          	auipc	a0,0x58c
    802009ba:	64a50513          	addi	a0,a0,1610 # 8078d000 <kmem>
		p->state = UNUSED;
    802009be:	00062023          	sw	zero,0(a2)
		p->kstack = (uint64)kstack[p - pool];
    802009c2:	41f607b3          	sub	a5,a2,t6
    802009c6:	8791                	srai	a5,a5,0x4
    802009c8:	03e787b3          	mul	a5,a5,t5
    802009cc:	00c79713          	slli	a4,a5,0xc
    802009d0:	01d706b3          	add	a3,a4,t4
    802009d4:	ee14                	sd	a3,24(a2)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802009d6:	9772                	add	a4,a4,t3
    802009d8:	f218                	sd	a4,32(a2)
		p->ti = &task_infos[p - pool];
    802009da:	026787b3          	mul	a5,a5,t1
    802009de:	97c6                	add	a5,a5,a7
    802009e0:	12f63823          	sd	a5,304(a2)
		p->ti->status = UnInit;
    802009e4:	0007a023          	sw	zero,0(a5)
		for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    802009e8:	87c2                	mv	a5,a6
			p->ti->syscall_times[i] = 0;
    802009ea:	13063703          	ld	a4,304(a2)
    802009ee:	00279693          	slli	a3,a5,0x2
    802009f2:	9736                	add	a4,a4,a3
    802009f4:	00072223          	sw	zero,4(a4)
		for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
    802009f8:	2785                	addiw	a5,a5,1
    802009fa:	feb798e3          	bne	a5,a1,802009ea <proc_init+0x70>
	for (p = pool; p < &pool[NPROC]; p++) {
    802009fe:	15060613          	addi	a2,a2,336
    80200a02:	faa61ee3          	bne	a2,a0,802009be <proc_init+0x44>
		}
	}
	idle.kstack = (uint64)boot_stack_top;
    80200a06:	00065797          	auipc	a5,0x65
    80200a0a:	5fa78793          	addi	a5,a5,1530 # 80266000 <idle>
    80200a0e:	00063717          	auipc	a4,0x63
    80200a12:	5f270713          	addi	a4,a4,1522 # 80264000 <names>
    80200a16:	ef98                	sd	a4,24(a5)
	idle.pid = IDLE_PID;
    80200a18:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    80200a1c:	0058c717          	auipc	a4,0x58c
    80200a20:	5ef73e23          	sd	a5,1532(a4) # 8078d018 <current_proc>
	init_queue(&task_queue);
    80200a24:	00065517          	auipc	a0,0x65
    80200a28:	72c50513          	addi	a0,a0,1836 # 80266150 <task_queue>
    80200a2c:	00000097          	auipc	ra,0x0
    80200a30:	61c080e7          	jalr	1564(ra) # 80201048 <init_queue>
}
    80200a34:	60a2                	ld	ra,8(sp)
    80200a36:	6402                	ld	s0,0(sp)
    80200a38:	0141                	addi	sp,sp,16
    80200a3a:	8082                	ret

0000000080200a3c <allocpid>:

int allocpid()
{
    80200a3c:	1141                	addi	sp,sp,-16
    80200a3e:	e422                	sd	s0,8(sp)
    80200a40:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    80200a42:	00052797          	auipc	a5,0x52
    80200a46:	5be78793          	addi	a5,a5,1470 # 80253000 <PID.0>
    80200a4a:	4388                	lw	a0,0(a5)
    80200a4c:	0015071b          	addiw	a4,a0,1
    80200a50:	c398                	sw	a4,0(a5)
}
    80200a52:	6422                	ld	s0,8(sp)
    80200a54:	0141                	addi	sp,sp,16
    80200a56:	8082                	ret

0000000080200a58 <fetch_task>:

struct proc *fetch_task()
{
    80200a58:	1101                	addi	sp,sp,-32
    80200a5a:	ec06                	sd	ra,24(sp)
    80200a5c:	e822                	sd	s0,16(sp)
    80200a5e:	e426                	sd	s1,8(sp)
    80200a60:	1000                	addi	s0,sp,32
	int index = pop_queue(&task_queue);
    80200a62:	00065517          	auipc	a0,0x65
    80200a66:	6ee50513          	addi	a0,a0,1774 # 80266150 <task_queue>
    80200a6a:	00000097          	auipc	ra,0x0
    80200a6e:	68a080e7          	jalr	1674(ra) # 802010f4 <pop_queue>
	if (index < 0) {
    80200a72:	02054863          	bltz	a0,80200aa2 <fetch_task+0x4a>
    80200a76:	85aa                	mv	a1,a0
		debugf("No task to fetch\n");
		return NULL;
	}
	debugf("fetch task %d(pid=%d) to task queue\n", index, pool[index].pid);
    80200a78:	15000493          	li	s1,336
    80200a7c:	02950533          	mul	a0,a0,s1
    80200a80:	00562497          	auipc	s1,0x562
    80200a84:	58048493          	addi	s1,s1,1408 # 80763000 <pool>
    80200a88:	94aa                	add	s1,s1,a0
    80200a8a:	40d0                	lw	a2,4(s1)
    80200a8c:	4501                	li	a0,0
    80200a8e:	00001097          	auipc	ra,0x1
    80200a92:	8be080e7          	jalr	-1858(ra) # 8020134c <dummy>
	return pool + index;
    80200a96:	8526                	mv	a0,s1
}
    80200a98:	60e2                	ld	ra,24(sp)
    80200a9a:	6442                	ld	s0,16(sp)
    80200a9c:	64a2                	ld	s1,8(sp)
    80200a9e:	6105                	addi	sp,sp,32
    80200aa0:	8082                	ret
		debugf("No task to fetch\n");
    80200aa2:	4501                	li	a0,0
    80200aa4:	00001097          	auipc	ra,0x1
    80200aa8:	8a8080e7          	jalr	-1880(ra) # 8020134c <dummy>
		return NULL;
    80200aac:	4501                	li	a0,0
    80200aae:	b7ed                	j	80200a98 <fetch_task+0x40>

0000000080200ab0 <add_task>:

void add_task(struct proc *p)
{
    80200ab0:	1101                	addi	sp,sp,-32
    80200ab2:	ec06                	sd	ra,24(sp)
    80200ab4:	e822                	sd	s0,16(sp)
    80200ab6:	e426                	sd	s1,8(sp)
    80200ab8:	e04a                	sd	s2,0(sp)
    80200aba:	1000                	addi	s0,sp,32
    80200abc:	892a                	mv	s2,a0
	push_queue(&task_queue, p - pool);
    80200abe:	00562497          	auipc	s1,0x562
    80200ac2:	54248493          	addi	s1,s1,1346 # 80763000 <pool>
    80200ac6:	409504b3          	sub	s1,a0,s1
    80200aca:	8491                	srai	s1,s1,0x4
    80200acc:	00004797          	auipc	a5,0x4
    80200ad0:	bac7b783          	ld	a5,-1108(a5) # 80204678 <digits+0x548>
    80200ad4:	02f484b3          	mul	s1,s1,a5
    80200ad8:	0004859b          	sext.w	a1,s1
    80200adc:	00065517          	auipc	a0,0x65
    80200ae0:	67450513          	addi	a0,a0,1652 # 80266150 <task_queue>
    80200ae4:	00000097          	auipc	ra,0x0
    80200ae8:	580080e7          	jalr	1408(ra) # 80201064 <push_queue>
	debugf("add task %d(pid=%d) to task queue\n", p - pool, p->pid);
    80200aec:	00492603          	lw	a2,4(s2)
    80200af0:	85a6                	mv	a1,s1
    80200af2:	4501                	li	a0,0
    80200af4:	00001097          	auipc	ra,0x1
    80200af8:	858080e7          	jalr	-1960(ra) # 8020134c <dummy>
}
    80200afc:	60e2                	ld	ra,24(sp)
    80200afe:	6442                	ld	s0,16(sp)
    80200b00:	64a2                	ld	s1,8(sp)
    80200b02:	6902                	ld	s2,0(sp)
    80200b04:	6105                	addi	sp,sp,32
    80200b06:	8082                	ret

0000000080200b08 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc()
{
    80200b08:	1101                	addi	sp,sp,-32
    80200b0a:	ec06                	sd	ra,24(sp)
    80200b0c:	e822                	sd	s0,16(sp)
    80200b0e:	e426                	sd	s1,8(sp)
    80200b10:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200b12:	00562497          	auipc	s1,0x562
    80200b16:	4ee48493          	addi	s1,s1,1262 # 80763000 <pool>
    80200b1a:	0058c717          	auipc	a4,0x58c
    80200b1e:	4e670713          	addi	a4,a4,1254 # 8078d000 <kmem>
		if (p->state == UNUSED) {
    80200b22:	409c                	lw	a5,0(s1)
    80200b24:	c799                	beqz	a5,80200b32 <allocproc+0x2a>
	for (p = pool; p < &pool[NPROC]; p++) {
    80200b26:	15048493          	addi	s1,s1,336
    80200b2a:	fee49ce3          	bne	s1,a4,80200b22 <allocproc+0x1a>
			goto found;
		}
	}
	return 0;
    80200b2e:	4481                	li	s1,0
    80200b30:	a0b5                	j	80200b9c <allocproc+0x94>

found:
	// init proc
	p->pid = allocpid();
    80200b32:	00000097          	auipc	ra,0x0
    80200b36:	f0a080e7          	jalr	-246(ra) # 80200a3c <allocpid>
    80200b3a:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    80200b3c:	4785                	li	a5,1
    80200b3e:	c09c                	sw	a5,0(s1)
	p->ustack = 0;
    80200b40:	0004b823          	sd	zero,16(s1)
	p->max_page = 0;
    80200b44:	0804bc23          	sd	zero,152(s1)
	p->parent = NULL;
    80200b48:	0a04b023          	sd	zero,160(s1)
	p->exit_code = 0;
    80200b4c:	0a04b423          	sd	zero,168(s1)
	p->pagetable = uvmcreate((uint64)p->trapframe);
    80200b50:	7088                	ld	a0,32(s1)
    80200b52:	00001097          	auipc	ra,0x1
    80200b56:	7cc080e7          	jalr	1996(ra) # 8020231e <uvmcreate>
    80200b5a:	e488                	sd	a0,8(s1)
	memset(&p->context, 0, sizeof(p->context));
    80200b5c:	07000613          	li	a2,112
    80200b60:	4581                	li	a1,0
    80200b62:	02848513          	addi	a0,s1,40
    80200b66:	00000097          	auipc	ra,0x0
    80200b6a:	638080e7          	jalr	1592(ra) # 8020119e <memset>
	memset((void *)p->kstack, 0, KSTACK_SIZE);
    80200b6e:	6605                	lui	a2,0x1
    80200b70:	4581                	li	a1,0
    80200b72:	6c88                	ld	a0,24(s1)
    80200b74:	00000097          	auipc	ra,0x0
    80200b78:	62a080e7          	jalr	1578(ra) # 8020119e <memset>
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
    80200b7c:	6605                	lui	a2,0x1
    80200b7e:	4581                	li	a1,0
    80200b80:	7088                	ld	a0,32(s1)
    80200b82:	00000097          	auipc	ra,0x0
    80200b86:	61c080e7          	jalr	1564(ra) # 8020119e <memset>
	p->context.ra = (uint64)usertrapret;
    80200b8a:	00001797          	auipc	a5,0x1
    80200b8e:	12478793          	addi	a5,a5,292 # 80201cae <usertrapret>
    80200b92:	f49c                	sd	a5,40(s1)
	p->context.sp = p->kstack + KSTACK_SIZE;
    80200b94:	6c9c                	ld	a5,24(s1)
    80200b96:	6705                	lui	a4,0x1
    80200b98:	97ba                	add	a5,a5,a4
    80200b9a:	f89c                	sd	a5,48(s1)
	return p;
}
    80200b9c:	8526                	mv	a0,s1
    80200b9e:	60e2                	ld	ra,24(sp)
    80200ba0:	6442                	ld	s0,16(sp)
    80200ba2:	64a2                	ld	s1,8(sp)
    80200ba4:	6105                	addi	sp,sp,32
    80200ba6:	8082                	ret

0000000080200ba8 <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler()
{
    80200ba8:	711d                	addi	sp,sp,-96
    80200baa:	ec86                	sd	ra,88(sp)
    80200bac:	e8a2                	sd	s0,80(sp)
    80200bae:	e4a6                	sd	s1,72(sp)
    80200bb0:	e0ca                	sd	s2,64(sp)
    80200bb2:	fc4e                	sd	s3,56(sp)
    80200bb4:	f852                	sd	s4,48(sp)
    80200bb6:	f456                	sd	s5,40(sp)
    80200bb8:	f05a                	sd	s6,32(sp)
    80200bba:	ec5e                	sd	s7,24(sp)
    80200bbc:	e862                	sd	s8,16(sp)
    80200bbe:	e466                	sd	s9,8(sp)
    80200bc0:	1080                	addi	s0,sp,96
	struct proc *p;
	for(;;)
	{
		struct proc *best = NULL;
    80200bc2:	4981                	li	s3,0
		for (p = pool; p < &pool[NPROC]; p++)
		{
			if (p->state == RUNNABLE)
    80200bc4:	490d                	li	s2,3
		for (p = pool; p < &pool[NPROC]; p++)
    80200bc6:	0058c497          	auipc	s1,0x58c
    80200bca:	43a48493          	addi	s1,s1,1082 # 8078d000 <kmem>
	return curr_proc()->pid;
    80200bce:	0058ca17          	auipc	s4,0x58c
    80200bd2:	44aa0a13          	addi	s4,s4,1098 # 8078d018 <current_proc>
				}
			}
		}
		if (best == NULL)
		{
			panic("No RUNNABLE process, scheduler is idle\n");
    80200bd6:	00003c17          	auipc	s8,0x3
    80200bda:	572c0c13          	addi	s8,s8,1394 # 80204148 <digits+0x18>
		
		p = fetch_task();
		if (p == NULL) {
			panic("all app are over!\n");
		}
		tracef("swtich to proc %d", p - pool);
    80200bde:	00562b97          	auipc	s7,0x562
    80200be2:	422b8b93          	addi	s7,s7,1058 # 80763000 <pool>
    80200be6:	00004b17          	auipc	s6,0x4
    80200bea:	a92b0b13          	addi	s6,s6,-1390 # 80204678 <digits+0x548>
		p->state = RUNNING;
		current_proc = p;
		swtch(&idle.context, &p->context);
    80200bee:	00065a97          	auipc	s5,0x65
    80200bf2:	43aa8a93          	addi	s5,s5,1082 # 80266028 <idle+0x28>
    80200bf6:	a08d                	j	80200c58 <scheduler+0xb0>
    80200bf8:	86be                	mv	a3,a5
		for (p = pool; p < &pool[NPROC]; p++)
    80200bfa:	15078793          	addi	a5,a5,336
    80200bfe:	00978e63          	beq	a5,s1,80200c1a <scheduler+0x72>
			if (p->state == RUNNABLE)
    80200c02:	4398                	lw	a4,0(a5)
    80200c04:	ff271be3          	bne	a4,s2,80200bfa <scheduler+0x52>
				if (best == NULL || p->pass < best->pass)
    80200c08:	dae5                	beqz	a3,80200bf8 <scheduler+0x50>
    80200c0a:	1407b603          	ld	a2,320(a5)
    80200c0e:	1406b703          	ld	a4,320(a3)
    80200c12:	fee654e3          	bge	a2,a4,80200bfa <scheduler+0x52>
    80200c16:	86be                	mv	a3,a5
    80200c18:	b7cd                	j	80200bfa <scheduler+0x52>
		if (best == NULL)
    80200c1a:	c6a9                	beqz	a3,80200c64 <scheduler+0xbc>
		p = fetch_task();
    80200c1c:	00000097          	auipc	ra,0x0
    80200c20:	e3c080e7          	jalr	-452(ra) # 80200a58 <fetch_task>
    80200c24:	8caa                	mv	s9,a0
		if (p == NULL) {
    80200c26:	c53d                	beqz	a0,80200c94 <scheduler+0xec>
		tracef("swtich to proc %d", p - pool);
    80200c28:	417c87b3          	sub	a5,s9,s7
    80200c2c:	8791                	srai	a5,a5,0x4
    80200c2e:	000b3583          	ld	a1,0(s6)
    80200c32:	02b785b3          	mul	a1,a5,a1
    80200c36:	854e                	mv	a0,s3
    80200c38:	00000097          	auipc	ra,0x0
    80200c3c:	714080e7          	jalr	1812(ra) # 8020134c <dummy>
		p->state = RUNNING;
    80200c40:	4791                	li	a5,4
    80200c42:	00fca023          	sw	a5,0(s9)
		current_proc = p;
    80200c46:	019a3023          	sd	s9,0(s4)
		swtch(&idle.context, &p->context);
    80200c4a:	028c8593          	addi	a1,s9,40
    80200c4e:	8556                	mv	a0,s5
    80200c50:	00002097          	auipc	ra,0x2
    80200c54:	ae2080e7          	jalr	-1310(ra) # 80202732 <swtch>
		struct proc *best = NULL;
    80200c58:	86ce                	mv	a3,s3
		for (p = pool; p < &pool[NPROC]; p++)
    80200c5a:	00562797          	auipc	a5,0x562
    80200c5e:	3a678793          	addi	a5,a5,934 # 80763000 <pool>
    80200c62:	b745                	j	80200c02 <scheduler+0x5a>
	return curr_proc()->pid;
    80200c64:	000a3683          	ld	a3,0(s4)
			panic("No RUNNABLE process, scheduler is idle\n");
    80200c68:	07c00793          	li	a5,124
    80200c6c:	8762                	mv	a4,s8
    80200c6e:	42d4                	lw	a3,4(a3)
    80200c70:	00003617          	auipc	a2,0x3
    80200c74:	3a060613          	addi	a2,a2,928 # 80204010 <e_text+0x10>
    80200c78:	45fd                	li	a1,31
    80200c7a:	00003517          	auipc	a0,0x3
    80200c7e:	4de50513          	addi	a0,a0,1246 # 80204158 <digits+0x28>
    80200c82:	00000097          	auipc	ra,0x0
    80200c86:	af8080e7          	jalr	-1288(ra) # 8020077a <printf>
    80200c8a:	00000097          	auipc	ra,0x0
    80200c8e:	4e6080e7          	jalr	1254(ra) # 80201170 <shutdown>
    80200c92:	b769                	j	80200c1c <scheduler+0x74>
	return curr_proc()->pid;
    80200c94:	000a3683          	ld	a3,0(s4)
			panic("all app are over!\n");
    80200c98:	08100793          	li	a5,129
    80200c9c:	8762                	mv	a4,s8
    80200c9e:	42d4                	lw	a3,4(a3)
    80200ca0:	00003617          	auipc	a2,0x3
    80200ca4:	37060613          	addi	a2,a2,880 # 80204010 <e_text+0x10>
    80200ca8:	45fd                	li	a1,31
    80200caa:	00003517          	auipc	a0,0x3
    80200cae:	4f650513          	addi	a0,a0,1270 # 802041a0 <digits+0x70>
    80200cb2:	00000097          	auipc	ra,0x0
    80200cb6:	ac8080e7          	jalr	-1336(ra) # 8020077a <printf>
    80200cba:	00000097          	auipc	ra,0x0
    80200cbe:	4b6080e7          	jalr	1206(ra) # 80201170 <shutdown>
    80200cc2:	b79d                	j	80200c28 <scheduler+0x80>

0000000080200cc4 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched()
{
    80200cc4:	1101                	addi	sp,sp,-32
    80200cc6:	ec06                	sd	ra,24(sp)
    80200cc8:	e822                	sd	s0,16(sp)
    80200cca:	e426                	sd	s1,8(sp)
    80200ccc:	1000                	addi	s0,sp,32
	return current_proc;
    80200cce:	0058c497          	auipc	s1,0x58c
    80200cd2:	34a4b483          	ld	s1,842(s1) # 8078d018 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    80200cd6:	4098                	lw	a4,0(s1)
    80200cd8:	4791                	li	a5,4
    80200cda:	02f70163          	beq	a4,a5,80200cfc <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    80200cde:	00065597          	auipc	a1,0x65
    80200ce2:	34a58593          	addi	a1,a1,842 # 80266028 <idle+0x28>
    80200ce6:	02848513          	addi	a0,s1,40
    80200cea:	00002097          	auipc	ra,0x2
    80200cee:	a48080e7          	jalr	-1464(ra) # 80202732 <swtch>
}
    80200cf2:	60e2                	ld	ra,24(sp)
    80200cf4:	6442                	ld	s0,16(sp)
    80200cf6:	64a2                	ld	s1,8(sp)
    80200cf8:	6105                	addi	sp,sp,32
    80200cfa:	8082                	ret
		panic("sched running");
    80200cfc:	09500793          	li	a5,149
    80200d00:	00003717          	auipc	a4,0x3
    80200d04:	44870713          	addi	a4,a4,1096 # 80204148 <digits+0x18>
    80200d08:	40d4                	lw	a3,4(s1)
    80200d0a:	00003617          	auipc	a2,0x3
    80200d0e:	30660613          	addi	a2,a2,774 # 80204010 <e_text+0x10>
    80200d12:	45fd                	li	a1,31
    80200d14:	00003517          	auipc	a0,0x3
    80200d18:	4bc50513          	addi	a0,a0,1212 # 802041d0 <digits+0xa0>
    80200d1c:	00000097          	auipc	ra,0x0
    80200d20:	a5e080e7          	jalr	-1442(ra) # 8020077a <printf>
    80200d24:	00000097          	auipc	ra,0x0
    80200d28:	44c080e7          	jalr	1100(ra) # 80201170 <shutdown>
    80200d2c:	bf4d                	j	80200cde <sched+0x1a>

0000000080200d2e <yield>:

// Give up the CPU for one scheduling round.
void yield()
{
    80200d2e:	1141                	addi	sp,sp,-16
    80200d30:	e406                	sd	ra,8(sp)
    80200d32:	e022                	sd	s0,0(sp)
    80200d34:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    80200d36:	0058c797          	auipc	a5,0x58c
    80200d3a:	2e278793          	addi	a5,a5,738 # 8078d018 <current_proc>
    80200d3e:	6398                	ld	a4,0(a5)
    80200d40:	468d                	li	a3,3
    80200d42:	c314                	sw	a3,0(a4)
	add_task(current_proc);
    80200d44:	6388                	ld	a0,0(a5)
    80200d46:	00000097          	auipc	ra,0x0
    80200d4a:	d6a080e7          	jalr	-662(ra) # 80200ab0 <add_task>
	sched();
    80200d4e:	00000097          	auipc	ra,0x0
    80200d52:	f76080e7          	jalr	-138(ra) # 80200cc4 <sched>
}
    80200d56:	60a2                	ld	ra,8(sp)
    80200d58:	6402                	ld	s0,0(sp)
    80200d5a:	0141                	addi	sp,sp,16
    80200d5c:	8082                	ret

0000000080200d5e <freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void freepagetable(pagetable_t pagetable, uint64 max_page)
{
    80200d5e:	1101                	addi	sp,sp,-32
    80200d60:	ec06                	sd	ra,24(sp)
    80200d62:	e822                	sd	s0,16(sp)
    80200d64:	e426                	sd	s1,8(sp)
    80200d66:	e04a                	sd	s2,0(sp)
    80200d68:	1000                	addi	s0,sp,32
    80200d6a:	84aa                	mv	s1,a0
    80200d6c:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80200d6e:	4681                	li	a3,0
    80200d70:	4605                	li	a2,1
    80200d72:	040005b7          	lui	a1,0x4000
    80200d76:	15fd                	addi	a1,a1,-1
    80200d78:	05b2                	slli	a1,a1,0xc
    80200d7a:	00001097          	auipc	ra,0x1
    80200d7e:	496080e7          	jalr	1174(ra) # 80202210 <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80200d82:	4681                	li	a3,0
    80200d84:	4605                	li	a2,1
    80200d86:	020005b7          	lui	a1,0x2000
    80200d8a:	15fd                	addi	a1,a1,-1
    80200d8c:	05b6                	slli	a1,a1,0xd
    80200d8e:	8526                	mv	a0,s1
    80200d90:	00001097          	auipc	ra,0x1
    80200d94:	480080e7          	jalr	1152(ra) # 80202210 <uvmunmap>
	uvmfree(pagetable, max_page);
    80200d98:	85ca                	mv	a1,s2
    80200d9a:	8526                	mv	a0,s1
    80200d9c:	00001097          	auipc	ra,0x1
    80200da0:	6e6080e7          	jalr	1766(ra) # 80202482 <uvmfree>
}
    80200da4:	60e2                	ld	ra,24(sp)
    80200da6:	6442                	ld	s0,16(sp)
    80200da8:	64a2                	ld	s1,8(sp)
    80200daa:	6902                	ld	s2,0(sp)
    80200dac:	6105                	addi	sp,sp,32
    80200dae:	8082                	ret

0000000080200db0 <freeproc>:

void freeproc(struct proc *p)
{
    80200db0:	1101                	addi	sp,sp,-32
    80200db2:	ec06                	sd	ra,24(sp)
    80200db4:	e822                	sd	s0,16(sp)
    80200db6:	e426                	sd	s1,8(sp)
    80200db8:	1000                	addi	s0,sp,32
    80200dba:	84aa                	mv	s1,a0
	if (p->pagetable)
    80200dbc:	6508                	ld	a0,8(a0)
    80200dbe:	c511                	beqz	a0,80200dca <freeproc+0x1a>
		freepagetable(p->pagetable, p->max_page);
    80200dc0:	6ccc                	ld	a1,152(s1)
    80200dc2:	00000097          	auipc	ra,0x0
    80200dc6:	f9c080e7          	jalr	-100(ra) # 80200d5e <freepagetable>
	p->pagetable = 0;
    80200dca:	0004b423          	sd	zero,8(s1)
	p->state = UNUSED;
    80200dce:	0004a023          	sw	zero,0(s1)
}
    80200dd2:	60e2                	ld	ra,24(sp)
    80200dd4:	6442                	ld	s0,16(sp)
    80200dd6:	64a2                	ld	s1,8(sp)
    80200dd8:	6105                	addi	sp,sp,32
    80200dda:	8082                	ret

0000000080200ddc <fork>:

int fork()
{
    80200ddc:	1101                	addi	sp,sp,-32
    80200dde:	ec06                	sd	ra,24(sp)
    80200de0:	e822                	sd	s0,16(sp)
    80200de2:	e426                	sd	s1,8(sp)
    80200de4:	e04a                	sd	s2,0(sp)
    80200de6:	1000                	addi	s0,sp,32
	return current_proc;
    80200de8:	0058c917          	auipc	s2,0x58c
    80200dec:	23093903          	ld	s2,560(s2) # 8078d018 <current_proc>
	struct proc *np;
	struct proc *p = curr_proc();
	// Allocate process.
	if ((np = allocproc()) == 0) {
    80200df0:	00000097          	auipc	ra,0x0
    80200df4:	d18080e7          	jalr	-744(ra) # 80200b08 <allocproc>
    80200df8:	84aa                	mv	s1,a0
    80200dfa:	c925                	beqz	a0,80200e6a <fork+0x8e>
		panic("allocproc\n");
	}
	// Copy user memory from parent to child.
	if (uvmcopy(p->pagetable, np->pagetable, p->max_page) < 0) {
    80200dfc:	09893603          	ld	a2,152(s2)
    80200e00:	648c                	ld	a1,8(s1)
    80200e02:	00893503          	ld	a0,8(s2)
    80200e06:	00001097          	auipc	ra,0x1
    80200e0a:	6ae080e7          	jalr	1710(ra) # 802024b4 <uvmcopy>
    80200e0e:	08054b63          	bltz	a0,80200ea4 <fork+0xc8>
		panic("uvmcopy\n");
	}
	np->max_page = p->max_page;
    80200e12:	09893783          	ld	a5,152(s2)
    80200e16:	ecdc                	sd	a5,152(s1)
	// copy saved user registers.
	*(np->trapframe) = *(p->trapframe);
    80200e18:	02093683          	ld	a3,32(s2)
    80200e1c:	87b6                	mv	a5,a3
    80200e1e:	7098                	ld	a4,32(s1)
    80200e20:	12068693          	addi	a3,a3,288
    80200e24:	0007b803          	ld	a6,0(a5)
    80200e28:	6788                	ld	a0,8(a5)
    80200e2a:	6b8c                	ld	a1,16(a5)
    80200e2c:	6f90                	ld	a2,24(a5)
    80200e2e:	01073023          	sd	a6,0(a4)
    80200e32:	e708                	sd	a0,8(a4)
    80200e34:	eb0c                	sd	a1,16(a4)
    80200e36:	ef10                	sd	a2,24(a4)
    80200e38:	02078793          	addi	a5,a5,32
    80200e3c:	02070713          	addi	a4,a4,32
    80200e40:	fed792e3          	bne	a5,a3,80200e24 <fork+0x48>
	// Cause fork to return 0 in the child.
	np->trapframe->a0 = 0;
    80200e44:	709c                	ld	a5,32(s1)
    80200e46:	0607b823          	sd	zero,112(a5)
	np->parent = p;
    80200e4a:	0b24b023          	sd	s2,160(s1)
	np->state = RUNNABLE;
    80200e4e:	478d                	li	a5,3
    80200e50:	c09c                	sw	a5,0(s1)
	add_task(np);
    80200e52:	8526                	mv	a0,s1
    80200e54:	00000097          	auipc	ra,0x0
    80200e58:	c5c080e7          	jalr	-932(ra) # 80200ab0 <add_task>
	return np->pid;
}
    80200e5c:	40c8                	lw	a0,4(s1)
    80200e5e:	60e2                	ld	ra,24(sp)
    80200e60:	6442                	ld	s0,16(sp)
    80200e62:	64a2                	ld	s1,8(sp)
    80200e64:	6902                	ld	s2,0(sp)
    80200e66:	6105                	addi	sp,sp,32
    80200e68:	8082                	ret
		panic("allocproc\n");
    80200e6a:	0b800793          	li	a5,184
    80200e6e:	00003717          	auipc	a4,0x3
    80200e72:	2da70713          	addi	a4,a4,730 # 80204148 <digits+0x18>
    80200e76:	0058c697          	auipc	a3,0x58c
    80200e7a:	1a26b683          	ld	a3,418(a3) # 8078d018 <current_proc>
    80200e7e:	42d4                	lw	a3,4(a3)
    80200e80:	00003617          	auipc	a2,0x3
    80200e84:	19060613          	addi	a2,a2,400 # 80204010 <e_text+0x10>
    80200e88:	45fd                	li	a1,31
    80200e8a:	00003517          	auipc	a0,0x3
    80200e8e:	22e50513          	addi	a0,a0,558 # 802040b8 <e_text+0xb8>
    80200e92:	00000097          	auipc	ra,0x0
    80200e96:	8e8080e7          	jalr	-1816(ra) # 8020077a <printf>
    80200e9a:	00000097          	auipc	ra,0x0
    80200e9e:	2d6080e7          	jalr	726(ra) # 80201170 <shutdown>
    80200ea2:	bfa9                	j	80200dfc <fork+0x20>
		panic("uvmcopy\n");
    80200ea4:	0bc00793          	li	a5,188
    80200ea8:	00003717          	auipc	a4,0x3
    80200eac:	2a070713          	addi	a4,a4,672 # 80204148 <digits+0x18>
    80200eb0:	0058c697          	auipc	a3,0x58c
    80200eb4:	1686b683          	ld	a3,360(a3) # 8078d018 <current_proc>
    80200eb8:	42d4                	lw	a3,4(a3)
    80200eba:	00003617          	auipc	a2,0x3
    80200ebe:	15660613          	addi	a2,a2,342 # 80204010 <e_text+0x10>
    80200ec2:	45fd                	li	a1,31
    80200ec4:	00003517          	auipc	a0,0x3
    80200ec8:	33450513          	addi	a0,a0,820 # 802041f8 <digits+0xc8>
    80200ecc:	00000097          	auipc	ra,0x0
    80200ed0:	8ae080e7          	jalr	-1874(ra) # 8020077a <printf>
    80200ed4:	00000097          	auipc	ra,0x0
    80200ed8:	29c080e7          	jalr	668(ra) # 80201170 <shutdown>
    80200edc:	bf1d                	j	80200e12 <fork+0x36>

0000000080200ede <exec>:

int exec(char *name)
{
    80200ede:	1101                	addi	sp,sp,-32
    80200ee0:	ec06                	sd	ra,24(sp)
    80200ee2:	e822                	sd	s0,16(sp)
    80200ee4:	e426                	sd	s1,8(sp)
    80200ee6:	e04a                	sd	s2,0(sp)
    80200ee8:	1000                	addi	s0,sp,32
	int id = get_id_by_name(name);
    80200eea:	fffff097          	auipc	ra,0xfffff
    80200eee:	358080e7          	jalr	856(ra) # 80200242 <get_id_by_name>
	if (id < 0)
    80200ef2:	04054063          	bltz	a0,80200f32 <exec+0x54>
    80200ef6:	84aa                	mv	s1,a0
	return current_proc;
    80200ef8:	0058c917          	auipc	s2,0x58c
    80200efc:	12093903          	ld	s2,288(s2) # 8078d018 <current_proc>
		return -1;
	struct proc *p = curr_proc();
	uvmunmap(p->pagetable, 0, p->max_page, 1);
    80200f00:	4685                	li	a3,1
    80200f02:	09893603          	ld	a2,152(s2)
    80200f06:	4581                	li	a1,0
    80200f08:	00893503          	ld	a0,8(s2)
    80200f0c:	00001097          	auipc	ra,0x1
    80200f10:	304080e7          	jalr	772(ra) # 80202210 <uvmunmap>
	p->max_page = 0;
    80200f14:	08093c23          	sd	zero,152(s2)
	loader(id, p);
    80200f18:	85ca                	mv	a1,s2
    80200f1a:	8526                	mv	a0,s1
    80200f1c:	fffff097          	auipc	ra,0xfffff
    80200f20:	61a080e7          	jalr	1562(ra) # 80200536 <loader>
	return 0;
    80200f24:	4501                	li	a0,0
}
    80200f26:	60e2                	ld	ra,24(sp)
    80200f28:	6442                	ld	s0,16(sp)
    80200f2a:	64a2                	ld	s1,8(sp)
    80200f2c:	6902                	ld	s2,0(sp)
    80200f2e:	6105                	addi	sp,sp,32
    80200f30:	8082                	ret
		return -1;
    80200f32:	557d                	li	a0,-1
    80200f34:	bfcd                	j	80200f26 <exec+0x48>

0000000080200f36 <wait>:

int wait(int pid, int *code)
{
    80200f36:	715d                	addi	sp,sp,-80
    80200f38:	e486                	sd	ra,72(sp)
    80200f3a:	e0a2                	sd	s0,64(sp)
    80200f3c:	fc26                	sd	s1,56(sp)
    80200f3e:	f84a                	sd	s2,48(sp)
    80200f40:	f44e                	sd	s3,40(sp)
    80200f42:	f052                	sd	s4,32(sp)
    80200f44:	ec56                	sd	s5,24(sp)
    80200f46:	e85a                	sd	s6,16(sp)
    80200f48:	e45e                	sd	s7,8(sp)
    80200f4a:	e062                	sd	s8,0(sp)
    80200f4c:	0880                	addi	s0,sp,80
    80200f4e:	89aa                	mv	s3,a0
    80200f50:	8b2e                	mv	s6,a1
	return current_proc;
    80200f52:	0058c917          	auipc	s2,0x58c
    80200f56:	0c693903          	ld	s2,198(s2) # 8078d018 <current_proc>
	int havekids;
	struct proc *p = curr_proc();

	for (;;) {
		// Scan through table looking for exited children.
		havekids = 0;
    80200f5a:	4b81                	li	s7,0
		for (np = pool; np < &pool[NPROC]; np++) {
			if (np->state != UNUSED && np->parent == p &&
			    (pid <= 0 || np->pid == pid)) {
				havekids = 1;
				if (np->state == ZOMBIE) {
    80200f5c:	4a15                	li	s4,5
				havekids = 1;
    80200f5e:	4a85                	li	s5,1
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f60:	0058c497          	auipc	s1,0x58c
    80200f64:	0a048493          	addi	s1,s1,160 # 8078d000 <kmem>
			}
		}
		if (!havekids) {
			return -1;
		}
		p->state = RUNNABLE;
    80200f68:	4c0d                	li	s8,3
		havekids = 0;
    80200f6a:	865e                	mv	a2,s7
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f6c:	00562797          	auipc	a5,0x562
    80200f70:	09478793          	addi	a5,a5,148 # 80763000 <pool>
    80200f74:	a801                	j	80200f84 <wait+0x4e>
				if (np->state == ZOMBIE) {
    80200f76:	03470263          	beq	a4,s4,80200f9a <wait+0x64>
				havekids = 1;
    80200f7a:	8656                	mv	a2,s5
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f7c:	15078793          	addi	a5,a5,336
    80200f80:	02978463          	beq	a5,s1,80200fa8 <wait+0x72>
			if (np->state != UNUSED && np->parent == p &&
    80200f84:	4398                	lw	a4,0(a5)
    80200f86:	db7d                	beqz	a4,80200f7c <wait+0x46>
    80200f88:	73d4                	ld	a3,160(a5)
    80200f8a:	ff2699e3          	bne	a3,s2,80200f7c <wait+0x46>
    80200f8e:	ff3054e3          	blez	s3,80200f76 <wait+0x40>
			    (pid <= 0 || np->pid == pid)) {
    80200f92:	43d4                	lw	a3,4(a5)
    80200f94:	ff3694e3          	bne	a3,s3,80200f7c <wait+0x46>
    80200f98:	bff9                	j	80200f76 <wait+0x40>
					np->state = UNUSED;
    80200f9a:	0007a023          	sw	zero,0(a5)
					pid = np->pid;
    80200f9e:	43c8                	lw	a0,4(a5)
					*code = np->exit_code;
    80200fa0:	77dc                	ld	a5,168(a5)
    80200fa2:	00fb2023          	sw	a5,0(s6)
					return pid;
    80200fa6:	a019                	j	80200fac <wait+0x76>
		if (!havekids) {
    80200fa8:	ee11                	bnez	a2,80200fc4 <wait+0x8e>
			return -1;
    80200faa:	557d                	li	a0,-1
		add_task(p);
		sched();
	}
}
    80200fac:	60a6                	ld	ra,72(sp)
    80200fae:	6406                	ld	s0,64(sp)
    80200fb0:	74e2                	ld	s1,56(sp)
    80200fb2:	7942                	ld	s2,48(sp)
    80200fb4:	79a2                	ld	s3,40(sp)
    80200fb6:	7a02                	ld	s4,32(sp)
    80200fb8:	6ae2                	ld	s5,24(sp)
    80200fba:	6b42                	ld	s6,16(sp)
    80200fbc:	6ba2                	ld	s7,8(sp)
    80200fbe:	6c02                	ld	s8,0(sp)
    80200fc0:	6161                	addi	sp,sp,80
    80200fc2:	8082                	ret
		p->state = RUNNABLE;
    80200fc4:	01892023          	sw	s8,0(s2)
		add_task(p);
    80200fc8:	854a                	mv	a0,s2
    80200fca:	00000097          	auipc	ra,0x0
    80200fce:	ae6080e7          	jalr	-1306(ra) # 80200ab0 <add_task>
		sched();
    80200fd2:	00000097          	auipc	ra,0x0
    80200fd6:	cf2080e7          	jalr	-782(ra) # 80200cc4 <sched>
		havekids = 0;
    80200fda:	bf41                	j	80200f6a <wait+0x34>

0000000080200fdc <exit>:

// Exit the current process.
void exit(int code)
{
    80200fdc:	1101                	addi	sp,sp,-32
    80200fde:	ec06                	sd	ra,24(sp)
    80200fe0:	e822                	sd	s0,16(sp)
    80200fe2:	e426                	sd	s1,8(sp)
    80200fe4:	1000                	addi	s0,sp,32
    80200fe6:	862a                	mv	a2,a0
	return current_proc;
    80200fe8:	0058c497          	auipc	s1,0x58c
    80200fec:	0304b483          	ld	s1,48(s1) # 8078d018 <current_proc>
	struct proc *p = curr_proc();
	p->exit_code = code;
    80200ff0:	f4c8                	sd	a0,168(s1)
	debugf("proc %d exit with %d\n", p->pid, code);
    80200ff2:	40cc                	lw	a1,4(s1)
    80200ff4:	4501                	li	a0,0
    80200ff6:	00000097          	auipc	ra,0x0
    80200ffa:	356080e7          	jalr	854(ra) # 8020134c <dummy>
	freeproc(p);
    80200ffe:	8526                	mv	a0,s1
    80201000:	00000097          	auipc	ra,0x0
    80201004:	db0080e7          	jalr	-592(ra) # 80200db0 <freeproc>
	if (p->parent != NULL) {
    80201008:	70dc                	ld	a5,160(s1)
    8020100a:	c399                	beqz	a5,80201010 <exit+0x34>
		// Parent should `wait`
		p->state = ZOMBIE;
    8020100c:	4795                	li	a5,5
    8020100e:	c09c                	sw	a5,0(s1)
{
    80201010:	00562797          	auipc	a5,0x562
    80201014:	ff078793          	addi	a5,a5,-16 # 80763000 <pool>
	}
	// Set the `parent` of all children to NULL
	struct proc *np;
	for (np = pool; np < &pool[NPROC]; np++) {
    80201018:	0058c697          	auipc	a3,0x58c
    8020101c:	fe868693          	addi	a3,a3,-24 # 8078d000 <kmem>
    80201020:	a029                	j	8020102a <exit+0x4e>
    80201022:	15078793          	addi	a5,a5,336
    80201026:	00d78863          	beq	a5,a3,80201036 <exit+0x5a>
		if (np->parent == p) {
    8020102a:	73d8                	ld	a4,160(a5)
    8020102c:	fe971be3          	bne	a4,s1,80201022 <exit+0x46>
			np->parent = NULL;
    80201030:	0a07b023          	sd	zero,160(a5)
    80201034:	b7fd                	j	80201022 <exit+0x46>
		}
	}
	sched();
    80201036:	00000097          	auipc	ra,0x0
    8020103a:	c8e080e7          	jalr	-882(ra) # 80200cc4 <sched>
    8020103e:	60e2                	ld	ra,24(sp)
    80201040:	6442                	ld	s0,16(sp)
    80201042:	64a2                	ld	s1,8(sp)
    80201044:	6105                	addi	sp,sp,32
    80201046:	8082                	ret

0000000080201048 <init_queue>:
#include "queue.h"
#include "defs.h"

void init_queue(struct queue *q)
{
    80201048:	1141                	addi	sp,sp,-16
    8020104a:	e422                	sd	s0,8(sp)
    8020104c:	0800                	addi	s0,sp,16
	q->front = q->tail = 0;
    8020104e:	6785                	lui	a5,0x1
    80201050:	953e                	add	a0,a0,a5
    80201052:	00052223          	sw	zero,4(a0)
    80201056:	00052023          	sw	zero,0(a0)
	q->empty = 1;
    8020105a:	4785                	li	a5,1
    8020105c:	c51c                	sw	a5,8(a0)
}
    8020105e:	6422                	ld	s0,8(sp)
    80201060:	0141                	addi	sp,sp,16
    80201062:	8082                	ret

0000000080201064 <push_queue>:

void push_queue(struct queue *q, int value)
{
    80201064:	1101                	addi	sp,sp,-32
    80201066:	ec06                	sd	ra,24(sp)
    80201068:	e822                	sd	s0,16(sp)
    8020106a:	e426                	sd	s1,8(sp)
    8020106c:	e04a                	sd	s2,0(sp)
    8020106e:	1000                	addi	s0,sp,32
    80201070:	84aa                	mv	s1,a0
    80201072:	892e                	mv	s2,a1
	if (!q->empty && q->front == q->tail) {
    80201074:	6785                	lui	a5,0x1
    80201076:	97aa                	add	a5,a5,a0
    80201078:	479c                	lw	a5,8(a5)
    8020107a:	e799                	bnez	a5,80201088 <push_queue+0x24>
    8020107c:	6785                	lui	a5,0x1
    8020107e:	97aa                	add	a5,a5,a0
    80201080:	4398                	lw	a4,0(a5)
    80201082:	43dc                	lw	a5,4(a5)
    80201084:	02f70c63          	beq	a4,a5,802010bc <push_queue+0x58>
		panic("queue shouldn't be overflow");
	}
	q->empty = 0;
    80201088:	6705                	lui	a4,0x1
    8020108a:	9726                	add	a4,a4,s1
    8020108c:	00072423          	sw	zero,8(a4) # 1008 <_entry-0x801feff8>
	q->data[q->tail] = value;
    80201090:	435c                	lw	a5,4(a4)
    80201092:	00279513          	slli	a0,a5,0x2
    80201096:	94aa                	add	s1,s1,a0
    80201098:	0124a023          	sw	s2,0(s1)
	q->tail = (q->tail + 1) % NPROC;
    8020109c:	2785                	addiw	a5,a5,1
    8020109e:	41f7d69b          	sraiw	a3,a5,0x1f
    802010a2:	0176d69b          	srliw	a3,a3,0x17
    802010a6:	9fb5                	addw	a5,a5,a3
    802010a8:	1ff7f793          	andi	a5,a5,511
    802010ac:	9f95                	subw	a5,a5,a3
    802010ae:	c35c                	sw	a5,4(a4)
}
    802010b0:	60e2                	ld	ra,24(sp)
    802010b2:	6442                	ld	s0,16(sp)
    802010b4:	64a2                	ld	s1,8(sp)
    802010b6:	6902                	ld	s2,0(sp)
    802010b8:	6105                	addi	sp,sp,32
    802010ba:	8082                	ret
		panic("queue shouldn't be overflow");
    802010bc:	00000097          	auipc	ra,0x0
    802010c0:	894080e7          	jalr	-1900(ra) # 80200950 <threadid>
    802010c4:	86aa                	mv	a3,a0
    802010c6:	47b5                	li	a5,13
    802010c8:	00003717          	auipc	a4,0x3
    802010cc:	15870713          	addi	a4,a4,344 # 80204220 <digits+0xf0>
    802010d0:	00003617          	auipc	a2,0x3
    802010d4:	f4060613          	addi	a2,a2,-192 # 80204010 <e_text+0x10>
    802010d8:	45fd                	li	a1,31
    802010da:	00003517          	auipc	a0,0x3
    802010de:	15650513          	addi	a0,a0,342 # 80204230 <digits+0x100>
    802010e2:	fffff097          	auipc	ra,0xfffff
    802010e6:	698080e7          	jalr	1688(ra) # 8020077a <printf>
    802010ea:	00000097          	auipc	ra,0x0
    802010ee:	086080e7          	jalr	134(ra) # 80201170 <shutdown>
    802010f2:	bf59                	j	80201088 <push_queue+0x24>

00000000802010f4 <pop_queue>:

int pop_queue(struct queue *q)
{
    802010f4:	1141                	addi	sp,sp,-16
    802010f6:	e422                	sd	s0,8(sp)
    802010f8:	0800                	addi	s0,sp,16
	if (q->empty)
    802010fa:	6785                	lui	a5,0x1
    802010fc:	97aa                	add	a5,a5,a0
    802010fe:	479c                	lw	a5,8(a5)
    80201100:	ef95                	bnez	a5,8020113c <pop_queue+0x48>
		return -1;
	int value = q->data[q->front];
    80201102:	6605                	lui	a2,0x1
    80201104:	962a                	add	a2,a2,a0
    80201106:	4218                	lw	a4,0(a2)
    80201108:	00271793          	slli	a5,a4,0x2
    8020110c:	97aa                	add	a5,a5,a0
    8020110e:	4388                	lw	a0,0(a5)
	q->front = (q->front + 1) % NPROC;
    80201110:	2705                	addiw	a4,a4,1
    80201112:	41f7579b          	sraiw	a5,a4,0x1f
    80201116:	0177d59b          	srliw	a1,a5,0x17
    8020111a:	00b707bb          	addw	a5,a4,a1
    8020111e:	1ff7f793          	andi	a5,a5,511
    80201122:	9f8d                	subw	a5,a5,a1
    80201124:	0007871b          	sext.w	a4,a5
    80201128:	c21c                	sw	a5,0(a2)
	if (q->front == q->tail)
    8020112a:	425c                	lw	a5,4(a2)
    8020112c:	00e78563          	beq	a5,a4,80201136 <pop_queue+0x42>
		q->empty = 1;
	return value;
}
    80201130:	6422                	ld	s0,8(sp)
    80201132:	0141                	addi	sp,sp,16
    80201134:	8082                	ret
		q->empty = 1;
    80201136:	4785                	li	a5,1
    80201138:	c61c                	sw	a5,8(a2)
    8020113a:	bfdd                	j	80201130 <pop_queue+0x3c>
		return -1;
    8020113c:	557d                	li	a0,-1
    8020113e:	bfcd                	j	80201130 <pop_queue+0x3c>

0000000080201140 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    80201140:	1141                	addi	sp,sp,-16
    80201142:	e422                	sd	s0,8(sp)
    80201144:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80201146:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80201148:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    8020114a:	4885                	li	a7,1
	asm volatile("ecall"
    8020114c:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80201150:	6422                	ld	s0,8(sp)
    80201152:	0141                	addi	sp,sp,16
    80201154:	8082                	ret

0000000080201156 <console_getchar>:

int console_getchar()
{
    80201156:	1141                	addi	sp,sp,-16
    80201158:	e422                	sd	s0,8(sp)
    8020115a:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    8020115c:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    8020115e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80201160:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80201162:	4889                	li	a7,2
	asm volatile("ecall"
    80201164:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    80201168:	2501                	sext.w	a0,a0
    8020116a:	6422                	ld	s0,8(sp)
    8020116c:	0141                	addi	sp,sp,16
    8020116e:	8082                	ret

0000000080201170 <shutdown>:

void shutdown()
{
    80201170:	1141                	addi	sp,sp,-16
    80201172:	e422                	sd	s0,8(sp)
    80201174:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    80201176:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    80201178:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    8020117a:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    8020117c:	48a1                	li	a7,8
	asm volatile("ecall"
    8020117e:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    80201182:	6422                	ld	s0,8(sp)
    80201184:	0141                	addi	sp,sp,16
    80201186:	8082                	ret

0000000080201188 <set_timer>:

void set_timer(uint64 stime)
{
    80201188:	1141                	addi	sp,sp,-16
    8020118a:	e422                	sd	s0,8(sp)
    8020118c:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    8020118e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80201190:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80201192:	4881                	li	a7,0
	asm volatile("ecall"
    80201194:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    80201198:	6422                	ld	s0,8(sp)
    8020119a:	0141                	addi	sp,sp,16
    8020119c:	8082                	ret

000000008020119e <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    8020119e:	1141                	addi	sp,sp,-16
    802011a0:	e422                	sd	s0,8(sp)
    802011a2:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    802011a4:	ca19                	beqz	a2,802011ba <memset+0x1c>
    802011a6:	87aa                	mv	a5,a0
    802011a8:	1602                	slli	a2,a2,0x20
    802011aa:	9201                	srli	a2,a2,0x20
    802011ac:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    802011b0:	00b78023          	sb	a1,0(a5) # 1000 <_entry-0x801ff000>
	for (i = 0; i < n; i++) {
    802011b4:	0785                	addi	a5,a5,1
    802011b6:	fee79de3          	bne	a5,a4,802011b0 <memset+0x12>
	}
	return dst;
}
    802011ba:	6422                	ld	s0,8(sp)
    802011bc:	0141                	addi	sp,sp,16
    802011be:	8082                	ret

00000000802011c0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    802011c0:	1141                	addi	sp,sp,-16
    802011c2:	e422                	sd	s0,8(sp)
    802011c4:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    802011c6:	ca05                	beqz	a2,802011f6 <memcmp+0x36>
    802011c8:	fff6069b          	addiw	a3,a2,-1
    802011cc:	1682                	slli	a3,a3,0x20
    802011ce:	9281                	srli	a3,a3,0x20
    802011d0:	0685                	addi	a3,a3,1
    802011d2:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    802011d4:	00054783          	lbu	a5,0(a0)
    802011d8:	0005c703          	lbu	a4,0(a1) # 2000000 <_entry-0x7e200000>
    802011dc:	00e79863          	bne	a5,a4,802011ec <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    802011e0:	0505                	addi	a0,a0,1
    802011e2:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    802011e4:	fed518e3          	bne	a0,a3,802011d4 <memcmp+0x14>
	}

	return 0;
    802011e8:	4501                	li	a0,0
    802011ea:	a019                	j	802011f0 <memcmp+0x30>
			return *s1 - *s2;
    802011ec:	40e7853b          	subw	a0,a5,a4
}
    802011f0:	6422                	ld	s0,8(sp)
    802011f2:	0141                	addi	sp,sp,16
    802011f4:	8082                	ret
	return 0;
    802011f6:	4501                	li	a0,0
    802011f8:	bfe5                	j	802011f0 <memcmp+0x30>

00000000802011fa <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    802011fa:	1141                	addi	sp,sp,-16
    802011fc:	e422                	sd	s0,8(sp)
    802011fe:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    80201200:	02a5e563          	bltu	a1,a0,8020122a <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    80201204:	fff6069b          	addiw	a3,a2,-1
    80201208:	ce11                	beqz	a2,80201224 <memmove+0x2a>
    8020120a:	1682                	slli	a3,a3,0x20
    8020120c:	9281                	srli	a3,a3,0x20
    8020120e:	0685                	addi	a3,a3,1
    80201210:	96ae                	add	a3,a3,a1
    80201212:	87aa                	mv	a5,a0
			*d++ = *s++;
    80201214:	0585                	addi	a1,a1,1
    80201216:	0785                	addi	a5,a5,1
    80201218:	fff5c703          	lbu	a4,-1(a1)
    8020121c:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    80201220:	fed59ae3          	bne	a1,a3,80201214 <memmove+0x1a>

	return dst;
}
    80201224:	6422                	ld	s0,8(sp)
    80201226:	0141                	addi	sp,sp,16
    80201228:	8082                	ret
	if (s < d && s + n > d) {
    8020122a:	02061713          	slli	a4,a2,0x20
    8020122e:	9301                	srli	a4,a4,0x20
    80201230:	00e587b3          	add	a5,a1,a4
    80201234:	fcf578e3          	bgeu	a0,a5,80201204 <memmove+0xa>
		d += n;
    80201238:	972a                	add	a4,a4,a0
		while (n-- > 0)
    8020123a:	fff6069b          	addiw	a3,a2,-1
    8020123e:	d27d                	beqz	a2,80201224 <memmove+0x2a>
    80201240:	02069613          	slli	a2,a3,0x20
    80201244:	9201                	srli	a2,a2,0x20
    80201246:	fff64613          	not	a2,a2
    8020124a:	963e                	add	a2,a2,a5
			*--d = *--s;
    8020124c:	17fd                	addi	a5,a5,-1
    8020124e:	177d                	addi	a4,a4,-1
    80201250:	0007c683          	lbu	a3,0(a5)
    80201254:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    80201258:	fef61ae3          	bne	a2,a5,8020124c <memmove+0x52>
    8020125c:	b7e1                	j	80201224 <memmove+0x2a>

000000008020125e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    8020125e:	1141                	addi	sp,sp,-16
    80201260:	e406                	sd	ra,8(sp)
    80201262:	e022                	sd	s0,0(sp)
    80201264:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    80201266:	00000097          	auipc	ra,0x0
    8020126a:	f94080e7          	jalr	-108(ra) # 802011fa <memmove>
}
    8020126e:	60a2                	ld	ra,8(sp)
    80201270:	6402                	ld	s0,0(sp)
    80201272:	0141                	addi	sp,sp,16
    80201274:	8082                	ret

0000000080201276 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80201276:	1141                	addi	sp,sp,-16
    80201278:	e422                	sd	s0,8(sp)
    8020127a:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    8020127c:	ce11                	beqz	a2,80201298 <strncmp+0x22>
    8020127e:	00054783          	lbu	a5,0(a0)
    80201282:	cf89                	beqz	a5,8020129c <strncmp+0x26>
    80201284:	0005c703          	lbu	a4,0(a1)
    80201288:	00f71a63          	bne	a4,a5,8020129c <strncmp+0x26>
		n--, p++, q++;
    8020128c:	367d                	addiw	a2,a2,-1
    8020128e:	0505                	addi	a0,a0,1
    80201290:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    80201292:	f675                	bnez	a2,8020127e <strncmp+0x8>
	if (n == 0)
		return 0;
    80201294:	4501                	li	a0,0
    80201296:	a809                	j	802012a8 <strncmp+0x32>
    80201298:	4501                	li	a0,0
    8020129a:	a039                	j	802012a8 <strncmp+0x32>
	if (n == 0)
    8020129c:	ca09                	beqz	a2,802012ae <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    8020129e:	00054503          	lbu	a0,0(a0)
    802012a2:	0005c783          	lbu	a5,0(a1)
    802012a6:	9d1d                	subw	a0,a0,a5
}
    802012a8:	6422                	ld	s0,8(sp)
    802012aa:	0141                	addi	sp,sp,16
    802012ac:	8082                	ret
		return 0;
    802012ae:	4501                	li	a0,0
    802012b0:	bfe5                	j	802012a8 <strncmp+0x32>

00000000802012b2 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    802012b2:	1141                	addi	sp,sp,-16
    802012b4:	e422                	sd	s0,8(sp)
    802012b6:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    802012b8:	872a                	mv	a4,a0
    802012ba:	8832                	mv	a6,a2
    802012bc:	367d                	addiw	a2,a2,-1
    802012be:	01005963          	blez	a6,802012d0 <strncpy+0x1e>
    802012c2:	0705                	addi	a4,a4,1
    802012c4:	0005c783          	lbu	a5,0(a1)
    802012c8:	fef70fa3          	sb	a5,-1(a4)
    802012cc:	0585                	addi	a1,a1,1
    802012ce:	f7f5                	bnez	a5,802012ba <strncpy+0x8>
		;
	while (n-- > 0)
    802012d0:	86ba                	mv	a3,a4
    802012d2:	00c05c63          	blez	a2,802012ea <strncpy+0x38>
		*s++ = 0;
    802012d6:	0685                	addi	a3,a3,1
    802012d8:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    802012dc:	fff6c793          	not	a5,a3
    802012e0:	9fb9                	addw	a5,a5,a4
    802012e2:	010787bb          	addw	a5,a5,a6
    802012e6:	fef048e3          	bgtz	a5,802012d6 <strncpy+0x24>
	return os;
}
    802012ea:	6422                	ld	s0,8(sp)
    802012ec:	0141                	addi	sp,sp,16
    802012ee:	8082                	ret

00000000802012f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    802012f0:	1141                	addi	sp,sp,-16
    802012f2:	e422                	sd	s0,8(sp)
    802012f4:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    802012f6:	02c05363          	blez	a2,8020131c <safestrcpy+0x2c>
    802012fa:	fff6069b          	addiw	a3,a2,-1
    802012fe:	1682                	slli	a3,a3,0x20
    80201300:	9281                	srli	a3,a3,0x20
    80201302:	96ae                	add	a3,a3,a1
    80201304:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    80201306:	00d58963          	beq	a1,a3,80201318 <safestrcpy+0x28>
    8020130a:	0585                	addi	a1,a1,1
    8020130c:	0785                	addi	a5,a5,1
    8020130e:	fff5c703          	lbu	a4,-1(a1)
    80201312:	fee78fa3          	sb	a4,-1(a5)
    80201316:	fb65                	bnez	a4,80201306 <safestrcpy+0x16>
		;
	*s = 0;
    80201318:	00078023          	sb	zero,0(a5)
	return os;
}
    8020131c:	6422                	ld	s0,8(sp)
    8020131e:	0141                	addi	sp,sp,16
    80201320:	8082                	ret

0000000080201322 <strlen>:

int strlen(const char *s)
{
    80201322:	1141                	addi	sp,sp,-16
    80201324:	e422                	sd	s0,8(sp)
    80201326:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    80201328:	00054783          	lbu	a5,0(a0)
    8020132c:	cf91                	beqz	a5,80201348 <strlen+0x26>
    8020132e:	0505                	addi	a0,a0,1
    80201330:	87aa                	mv	a5,a0
    80201332:	4685                	li	a3,1
    80201334:	9e89                	subw	a3,a3,a0
    80201336:	00f6853b          	addw	a0,a3,a5
    8020133a:	0785                	addi	a5,a5,1
    8020133c:	fff7c703          	lbu	a4,-1(a5)
    80201340:	fb7d                	bnez	a4,80201336 <strlen+0x14>
		;
	return n;
}
    80201342:	6422                	ld	s0,8(sp)
    80201344:	0141                	addi	sp,sp,16
    80201346:	8082                	ret
	for (n = 0; s[n]; n++)
    80201348:	4501                	li	a0,0
    8020134a:	bfe5                	j	80201342 <strlen+0x20>

000000008020134c <dummy>:

void dummy(int _, ...)
{
    8020134c:	715d                	addi	sp,sp,-80
    8020134e:	e422                	sd	s0,8(sp)
    80201350:	0800                	addi	s0,sp,16
    80201352:	e40c                	sd	a1,8(s0)
    80201354:	e810                	sd	a2,16(s0)
    80201356:	ec14                	sd	a3,24(s0)
    80201358:	f018                	sd	a4,32(s0)
    8020135a:	f41c                	sd	a5,40(s0)
    8020135c:	03043823          	sd	a6,48(s0)
    80201360:	03143c23          	sd	a7,56(s0)
    80201364:	6422                	ld	s0,8(sp)
    80201366:	6161                	addi	sp,sp,80
    80201368:	8082                	ret

000000008020136a <sys_write>:
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

uint64 sys_write(int fd, uint64 va, uint len)
{
    8020136a:	7111                	addi	sp,sp,-256
    8020136c:	fd86                	sd	ra,248(sp)
    8020136e:	f9a2                	sd	s0,240(sp)
    80201370:	f5a6                	sd	s1,232(sp)
    80201372:	f1ca                	sd	s2,224(sp)
    80201374:	edce                	sd	s3,216(sp)
    80201376:	0200                	addi	s0,sp,256
    80201378:	84aa                	mv	s1,a0
    8020137a:	89ae                	mv	s3,a1
    8020137c:	8932                	mv	s2,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
    8020137e:	86b2                	mv	a3,a2
    80201380:	862e                	mv	a2,a1
    80201382:	85aa                	mv	a1,a0
    80201384:	4501                	li	a0,0
    80201386:	00000097          	auipc	ra,0x0
    8020138a:	fc6080e7          	jalr	-58(ra) # 8020134c <dummy>
	if (fd != STDOUT)
    8020138e:	4785                	li	a5,1
		return -1;
    80201390:	557d                	li	a0,-1
	if (fd != STDOUT)
    80201392:	00f48963          	beq	s1,a5,802013a4 <sys_write+0x3a>
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}
    80201396:	70ee                	ld	ra,248(sp)
    80201398:	744e                	ld	s0,240(sp)
    8020139a:	74ae                	ld	s1,232(sp)
    8020139c:	790e                	ld	s2,224(sp)
    8020139e:	69ee                	ld	s3,216(sp)
    802013a0:	6111                	addi	sp,sp,256
    802013a2:	8082                	ret
	struct proc *p = curr_proc();
    802013a4:	fffff097          	auipc	ra,0xfffff
    802013a8:	5c2080e7          	jalr	1474(ra) # 80200966 <curr_proc>
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    802013ac:	86ca                	mv	a3,s2
    802013ae:	0c800793          	li	a5,200
    802013b2:	0127f463          	bgeu	a5,s2,802013ba <sys_write+0x50>
    802013b6:	0c800693          	li	a3,200
    802013ba:	1682                	slli	a3,a3,0x20
    802013bc:	9281                	srli	a3,a3,0x20
    802013be:	864e                	mv	a2,s3
    802013c0:	f0840593          	addi	a1,s0,-248
    802013c4:	6508                	ld	a0,8(a0)
    802013c6:	00001097          	auipc	ra,0x1
    802013ca:	2c2080e7          	jalr	706(ra) # 80202688 <copyinstr>
    802013ce:	892a                	mv	s2,a0
	debugf("size = %d", size);
    802013d0:	85aa                	mv	a1,a0
    802013d2:	4501                	li	a0,0
    802013d4:	00000097          	auipc	ra,0x0
    802013d8:	f78080e7          	jalr	-136(ra) # 8020134c <dummy>
	for (int i = 0; i < size; ++i) {
    802013dc:	03205563          	blez	s2,80201406 <sys_write+0x9c>
    802013e0:	f0840493          	addi	s1,s0,-248
    802013e4:	fff9099b          	addiw	s3,s2,-1
    802013e8:	1982                	slli	s3,s3,0x20
    802013ea:	0209d993          	srli	s3,s3,0x20
    802013ee:	f0940793          	addi	a5,s0,-247
    802013f2:	99be                	add	s3,s3,a5
		console_putchar(str[i]);
    802013f4:	0004c503          	lbu	a0,0(s1)
    802013f8:	00000097          	auipc	ra,0x0
    802013fc:	d48080e7          	jalr	-696(ra) # 80201140 <console_putchar>
	for (int i = 0; i < size; ++i) {
    80201400:	0485                	addi	s1,s1,1
    80201402:	ff3499e3          	bne	s1,s3,802013f4 <sys_write+0x8a>
	return size;
    80201406:	854a                	mv	a0,s2
    80201408:	b779                	j	80201396 <sys_write+0x2c>

000000008020140a <sys_read>:

uint64 sys_read(int fd, uint64 va, uint64 len)
{
    8020140a:	716d                	addi	sp,sp,-272
    8020140c:	e606                	sd	ra,264(sp)
    8020140e:	e222                	sd	s0,256(sp)
    80201410:	fda6                	sd	s1,248(sp)
    80201412:	f9ca                	sd	s2,240(sp)
    80201414:	f5ce                	sd	s3,232(sp)
    80201416:	f1d2                	sd	s4,224(sp)
    80201418:	edd6                	sd	s5,216(sp)
    8020141a:	0a00                	addi	s0,sp,272
    8020141c:	84aa                	mv	s1,a0
    8020141e:	8a2e                	mv	s4,a1
    80201420:	8932                	mv	s2,a2
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
    80201422:	86b2                	mv	a3,a2
    80201424:	862e                	mv	a2,a1
    80201426:	85aa                	mv	a1,a0
    80201428:	4501                	li	a0,0
    8020142a:	00000097          	auipc	ra,0x0
    8020142e:	f22080e7          	jalr	-222(ra) # 8020134c <dummy>
	if (fd != STDIN)
		return -1;
    80201432:	557d                	li	a0,-1
	if (fd != STDIN)
    80201434:	e0a1                	bnez	s1,80201474 <sys_read+0x6a>
	struct proc *p = curr_proc();
    80201436:	fffff097          	auipc	ra,0xfffff
    8020143a:	530080e7          	jalr	1328(ra) # 80200966 <curr_proc>
    8020143e:	8aaa                	mv	s5,a0
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
    80201440:	00090f63          	beqz	s2,8020145e <sys_read+0x54>
    80201444:	ef840493          	addi	s1,s0,-264
    80201448:	009909b3          	add	s3,s2,s1
		int c = consgetc();
    8020144c:	fffff097          	auipc	ra,0xfffff
    80201450:	be4080e7          	jalr	-1052(ra) # 80200030 <consgetc>
		str[i] = c;
    80201454:	00a48023          	sb	a0,0(s1)
	for (int i = 0; i < len; ++i) {
    80201458:	0485                	addi	s1,s1,1
    8020145a:	ff3499e3          	bne	s1,s3,8020144c <sys_read+0x42>
	}
	copyout(p->pagetable, va, str, len);
    8020145e:	86ca                	mv	a3,s2
    80201460:	ef840613          	addi	a2,s0,-264
    80201464:	85d2                	mv	a1,s4
    80201466:	008ab503          	ld	a0,8(s5)
    8020146a:	00001097          	auipc	ra,0x1
    8020146e:	104080e7          	jalr	260(ra) # 8020256e <copyout>
	return len;
    80201472:	854a                	mv	a0,s2
}
    80201474:	60b2                	ld	ra,264(sp)
    80201476:	6412                	ld	s0,256(sp)
    80201478:	74ee                	ld	s1,248(sp)
    8020147a:	794e                	ld	s2,240(sp)
    8020147c:	79ae                	ld	s3,232(sp)
    8020147e:	7a0e                	ld	s4,224(sp)
    80201480:	6aee                	ld	s5,216(sp)
    80201482:	6151                	addi	sp,sp,272
    80201484:	8082                	ret

0000000080201486 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80201486:	1141                	addi	sp,sp,-16
    80201488:	e406                	sd	ra,8(sp)
    8020148a:	e022                	sd	s0,0(sp)
    8020148c:	0800                	addi	s0,sp,16
	exit(code);
    8020148e:	00000097          	auipc	ra,0x0
    80201492:	b4e080e7          	jalr	-1202(ra) # 80200fdc <exit>

0000000080201496 <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    80201496:	1141                	addi	sp,sp,-16
    80201498:	e406                	sd	ra,8(sp)
    8020149a:	e022                	sd	s0,0(sp)
    8020149c:	0800                	addi	s0,sp,16
	yield();
    8020149e:	00000097          	auipc	ra,0x0
    802014a2:	890080e7          	jalr	-1904(ra) # 80200d2e <yield>
	return 0;
}
    802014a6:	4501                	li	a0,0
    802014a8:	60a2                	ld	ra,8(sp)
    802014aa:	6402                	ld	s0,0(sp)
    802014ac:	0141                	addi	sp,sp,16
    802014ae:	8082                	ret

00000000802014b0 <sys_gettimeofday>:

uint64 sys_gettimeofday(uint64 val, int _tz)
{
    802014b0:	7179                	addi	sp,sp,-48
    802014b2:	f406                	sd	ra,40(sp)
    802014b4:	f022                	sd	s0,32(sp)
    802014b6:	ec26                	sd	s1,24(sp)
    802014b8:	e84a                	sd	s2,16(sp)
    802014ba:	1800                	addi	s0,sp,48
    802014bc:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    802014be:	fffff097          	auipc	ra,0xfffff
    802014c2:	4a8080e7          	jalr	1192(ra) # 80200966 <curr_proc>
    802014c6:	84aa                	mv	s1,a0
	uint64 cycle = get_cycle();
    802014c8:	00000097          	auipc	ra,0x0
    802014cc:	65e080e7          	jalr	1630(ra) # 80201b26 <get_cycle>
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
    802014d0:	00bec737          	lui	a4,0xbec
    802014d4:	c2070713          	addi	a4,a4,-992 # bebc20 <_entry-0x7f6143e0>
    802014d8:	02e556b3          	divu	a3,a0,a4
    802014dc:	fcd43823          	sd	a3,-48(s0)
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    802014e0:	02e577b3          	remu	a5,a0,a4
    802014e4:	000f4537          	lui	a0,0xf4
    802014e8:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    802014ec:	02a787b3          	mul	a5,a5,a0
    802014f0:	02e7d7b3          	divu	a5,a5,a4
    802014f4:	fcf43c23          	sd	a5,-40(s0)
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
    802014f8:	46c1                	li	a3,16
    802014fa:	fd040613          	addi	a2,s0,-48
    802014fe:	85ca                	mv	a1,s2
    80201500:	6488                	ld	a0,8(s1)
    80201502:	00001097          	auipc	ra,0x1
    80201506:	06c080e7          	jalr	108(ra) # 8020256e <copyout>
	return 0;
}
    8020150a:	4501                	li	a0,0
    8020150c:	70a2                	ld	ra,40(sp)
    8020150e:	7402                	ld	s0,32(sp)
    80201510:	64e2                	ld	s1,24(sp)
    80201512:	6942                	ld	s2,16(sp)
    80201514:	6145                	addi	sp,sp,48
    80201516:	8082                	ret

0000000080201518 <sys_task_info>:

int sys_task_info(uint64 ti)
{
    80201518:	1101                	addi	sp,sp,-32
    8020151a:	ec06                	sd	ra,24(sp)
    8020151c:	e822                	sd	s0,16(sp)
    8020151e:	e426                	sd	s1,8(sp)
    80201520:	e04a                	sd	s2,0(sp)
    80201522:	1000                	addi	s0,sp,32
    80201524:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    80201526:	fffff097          	auipc	ra,0xfffff
    8020152a:	440080e7          	jalr	1088(ra) # 80200966 <curr_proc>

	if (ti == 0)
    8020152e:	c0bd                	beqz	s1,80201594 <sys_task_info+0x7c>
    80201530:	892a                	mv	s2,a0
	{
		return -1;
	}

	uint64 pa = useraddr(p->pagetable, ti);
    80201532:	85a6                	mv	a1,s1
    80201534:	6508                	ld	a0,8(a0)
    80201536:	00001097          	auipc	ra,0x1
    8020153a:	ac4080e7          	jalr	-1340(ra) # 80201ffa <useraddr>
    8020153e:	84aa                	mv	s1,a0
	if (pa == 0)
    80201540:	cd21                	beqz	a0,80201598 <sys_task_info+0x80>
	{
		return -1;
	}

	TaskInfo *pti = (TaskInfo *)pa;
	pti->status = Running;
    80201542:	4789                	li	a5,2
    80201544:	c11c                	sw	a5,0(a0)
	pti->time = (get_cycle() / (CPU_FREQ / 1000)) - p->ti->time;
    80201546:	00000097          	auipc	ra,0x0
    8020154a:	5e0080e7          	jalr	1504(ra) # 80201b26 <get_cycle>
    8020154e:	678d                	lui	a5,0x3
    80201550:	0d478793          	addi	a5,a5,212 # 30d4 <_entry-0x801fcf2c>
    80201554:	02f557b3          	divu	a5,a0,a5
    80201558:	13093703          	ld	a4,304(s2)
    8020155c:	7d472703          	lw	a4,2004(a4)
    80201560:	9f99                	subw	a5,a5,a4
    80201562:	7cf4aa23          	sw	a5,2004(s1)

	for (int i = 0; i < MAX_SYSCALL_NUM; i++)
    80201566:	00448693          	addi	a3,s1,4
    8020156a:	4781                	li	a5,0
    8020156c:	1f400593          	li	a1,500
	{
		pti->syscall_times[i] = p->ti->syscall_times[i];
    80201570:	13093703          	ld	a4,304(s2)
    80201574:	00279613          	slli	a2,a5,0x2
    80201578:	9732                	add	a4,a4,a2
    8020157a:	4358                	lw	a4,4(a4)
    8020157c:	c298                	sw	a4,0(a3)
	for (int i = 0; i < MAX_SYSCALL_NUM; i++)
    8020157e:	2785                	addiw	a5,a5,1
    80201580:	0691                	addi	a3,a3,4
    80201582:	feb797e3          	bne	a5,a1,80201570 <sys_task_info+0x58>
	}

	return 0;
    80201586:	4501                	li	a0,0
}
    80201588:	60e2                	ld	ra,24(sp)
    8020158a:	6442                	ld	s0,16(sp)
    8020158c:	64a2                	ld	s1,8(sp)
    8020158e:	6902                	ld	s2,0(sp)
    80201590:	6105                	addi	sp,sp,32
    80201592:	8082                	ret
		return -1;
    80201594:	557d                	li	a0,-1
    80201596:	bfcd                	j	80201588 <sys_task_info+0x70>
		return -1;
    80201598:	557d                	li	a0,-1
    8020159a:	b7fd                	j	80201588 <sys_task_info+0x70>

000000008020159c <sys_mmap>:

uint64 sys_mmap(uint64 start, uint64_t len, int port, int flag, int fd)
{
    8020159c:	715d                	addi	sp,sp,-80
    8020159e:	e486                	sd	ra,72(sp)
    802015a0:	e0a2                	sd	s0,64(sp)
    802015a2:	fc26                	sd	s1,56(sp)
    802015a4:	f84a                	sd	s2,48(sp)
    802015a6:	f44e                	sd	s3,40(sp)
    802015a8:	f052                	sd	s4,32(sp)
    802015aa:	ec56                	sd	s5,24(sp)
    802015ac:	e85a                	sd	s6,16(sp)
    802015ae:	e45e                	sd	s7,8(sp)
    802015b0:	0880                	addi	s0,sp,80
	/// Check if the allocated size is greater than 1GB, or the port is not page-aligned, or the port is 0, or the start address is page-aligned. If any of these conditions are true, return -1. If the length is 0, return 0.
	/// Check if the port 0x7 is not set
	/// Check if the port is not page-aligned
	/// Check if the port is 0
	/// Check if the start address is page-aligned
	if(len > 1073741824 || (port & ~0x7) != 0 || (port & 0x7) == 0 || !PGALIGNED(start))
    802015b2:	400007b7          	lui	a5,0x40000
	{
		return -1;
    802015b6:	5a7d                	li	s4,-1
	if(len > 1073741824 || (port & ~0x7) != 0 || (port & 0x7) == 0 || !PGALIGNED(start))
    802015b8:	02b7e363          	bltu	a5,a1,802015de <sys_mmap+0x42>
    802015bc:	84aa                	mv	s1,a0
    802015be:	892e                	mv	s2,a1
    802015c0:	89b2                	mv	s3,a2
    802015c2:	ff867793          	andi	a5,a2,-8
		return -1;
    802015c6:	5a7d                	li	s4,-1
	if(len > 1073741824 || (port & ~0x7) != 0 || (port & 0x7) == 0 || !PGALIGNED(start))
    802015c8:	eb99                	bnez	a5,802015de <sys_mmap+0x42>
    802015ca:	00767793          	andi	a5,a2,7
    802015ce:	cb81                	beqz	a5,802015de <sys_mmap+0x42>
    802015d0:	03451793          	slli	a5,a0,0x34
    802015d4:	0347da13          	srli	s4,a5,0x34
    802015d8:	ebc5                	bnez	a5,80201688 <sys_mmap+0xec>
	}
	else if ( len == 0 )
    802015da:	ed91                	bnez	a1,802015f6 <sys_mmap+0x5a>
	{
		return 0;
    802015dc:	8a2e                	mv	s4,a1
			return -1;
		}
	}

	return 0;
}
    802015de:	8552                	mv	a0,s4
    802015e0:	60a6                	ld	ra,72(sp)
    802015e2:	6406                	ld	s0,64(sp)
    802015e4:	74e2                	ld	s1,56(sp)
    802015e6:	7942                	ld	s2,48(sp)
    802015e8:	79a2                	ld	s3,40(sp)
    802015ea:	7a02                	ld	s4,32(sp)
    802015ec:	6ae2                	ld	s5,24(sp)
    802015ee:	6b42                	ld	s6,16(sp)
    802015f0:	6ba2                	ld	s7,8(sp)
    802015f2:	6161                	addi	sp,sp,80
    802015f4:	8082                	ret
	struct proc *p = curr_proc();
    802015f6:	fffff097          	auipc	ra,0xfffff
    802015fa:	370080e7          	jalr	880(ra) # 80200966 <curr_proc>
    802015fe:	8aaa                	mv	s5,a0
	uint64_t round = PGROUNDUP(len);
    80201600:	6b05                	lui	s6,0x1
    80201602:	1b7d                	addi	s6,s6,-1
    80201604:	9b4a                	add	s6,s6,s2
    80201606:	797d                	lui	s2,0xfffff
    80201608:	012b7b33          	and	s6,s6,s2
	for (uint64_t i = start_addr; i < start_addr + round; i += PGSIZE)
    8020160c:	9b26                	add	s6,s6,s1
    8020160e:	0364f663          	bgeu	s1,s6,8020163a <sys_mmap+0x9e>
    80201612:	8926                	mv	s2,s1
    80201614:	6b85                	lui	s7,0x1
    80201616:	a021                	j	8020161e <sys_mmap+0x82>
    80201618:	995e                	add	s2,s2,s7
    8020161a:	03697063          	bgeu	s2,s6,8020163a <sys_mmap+0x9e>
		pte_t *pte = walk(p->pagetable, i, 0);
    8020161e:	4601                	li	a2,0
    80201620:	85ca                	mv	a1,s2
    80201622:	008ab503          	ld	a0,8(s5)
    80201626:	00001097          	auipc	ra,0x1
    8020162a:	8c0080e7          	jalr	-1856(ra) # 80201ee6 <walk>
		if (pte == 0)
    8020162e:	d56d                	beqz	a0,80201618 <sys_mmap+0x7c>
		 else if (*pte & PTE_V)
    80201630:	611c                	ld	a5,0(a0)
    80201632:	8b85                	andi	a5,a5,1
    80201634:	d3f5                	beqz	a5,80201618 <sys_mmap+0x7c>
			return -1;
    80201636:	5a7d                	li	s4,-1
    80201638:	b75d                	j	802015de <sys_mmap+0x42>
	if (port & 0x1)
    8020163a:	0019f793          	andi	a5,s3,1
	int flags = PTE_U;
    8020163e:	4941                	li	s2,16
	if (port & 0x1)
    80201640:	c391                	beqz	a5,80201644 <sys_mmap+0xa8>
		flags |= PTE_R;
    80201642:	4949                	li	s2,18
	if (port & 0x2)
    80201644:	0029f793          	andi	a5,s3,2
    80201648:	c399                	beqz	a5,8020164e <sys_mmap+0xb2>
		flags |= PTE_W;
    8020164a:	00496913          	ori	s2,s2,4
	if (port & 0x4)
    8020164e:	0049f993          	andi	s3,s3,4
    80201652:	00098463          	beqz	s3,8020165a <sys_mmap+0xbe>
		flags |= PTE_X;
    80201656:	00896913          	ori	s2,s2,8
	for(uint64_t i = start_addr; i < start_addr + round; i += PGSIZE)
    8020165a:	f964f2e3          	bgeu	s1,s6,802015de <sys_mmap+0x42>
		void *pa = kalloc();
    8020165e:	fffff097          	auipc	ra,0xfffff
    80201662:	adc080e7          	jalr	-1316(ra) # 8020013a <kalloc>
    80201666:	86aa                	mv	a3,a0
		if (pa == 0)
    80201668:	c115                	beqz	a0,8020168c <sys_mmap+0xf0>
		if (mappages(p->pagetable, i, PGSIZE, (uint64)pa, flags) != 0)
    8020166a:	874a                	mv	a4,s2
    8020166c:	6605                	lui	a2,0x1
    8020166e:	85a6                	mv	a1,s1
    80201670:	008ab503          	ld	a0,8(s5)
    80201674:	00001097          	auipc	ra,0x1
    80201678:	9ae080e7          	jalr	-1618(ra) # 80202022 <mappages>
    8020167c:	e911                	bnez	a0,80201690 <sys_mmap+0xf4>
	for(uint64_t i = start_addr; i < start_addr + round; i += PGSIZE)
    8020167e:	6785                	lui	a5,0x1
    80201680:	94be                	add	s1,s1,a5
    80201682:	fd64eee3          	bltu	s1,s6,8020165e <sys_mmap+0xc2>
    80201686:	bfa1                	j	802015de <sys_mmap+0x42>
		return -1;
    80201688:	5a7d                	li	s4,-1
    8020168a:	bf91                	j	802015de <sys_mmap+0x42>
			return -1;
    8020168c:	5a7d                	li	s4,-1
    8020168e:	bf81                	j	802015de <sys_mmap+0x42>
			return -1;
    80201690:	5a7d                	li	s4,-1
    80201692:	b7b1                	j	802015de <sys_mmap+0x42>

0000000080201694 <sys_munmap>:

uint64 sys_munmap(uint64 start, uint64 len)
{
    80201694:	715d                	addi	sp,sp,-80
    80201696:	e486                	sd	ra,72(sp)
    80201698:	e0a2                	sd	s0,64(sp)
    8020169a:	fc26                	sd	s1,56(sp)
    8020169c:	f84a                	sd	s2,48(sp)
    8020169e:	f44e                	sd	s3,40(sp)
    802016a0:	f052                	sd	s4,32(sp)
    802016a2:	ec56                	sd	s5,24(sp)
    802016a4:	e85a                	sd	s6,16(sp)
    802016a6:	e45e                	sd	s7,8(sp)
    802016a8:	0880                	addi	s0,sp,80
	if(!PGALIGNED(start))
    802016aa:	03451793          	slli	a5,a0,0x34
	{
		return -1;
    802016ae:	5b7d                	li	s6,-1
	if(!PGALIGNED(start))
    802016b0:	efa9                	bnez	a5,8020170a <sys_munmap+0x76>
    802016b2:	8a2a                	mv	s4,a0
    802016b4:	8aae                	mv	s5,a1
    802016b6:	0347db13          	srli	s6,a5,0x34
	}
	struct proc *p = curr_proc();
    802016ba:	fffff097          	auipc	ra,0xfffff
    802016be:	2ac080e7          	jalr	684(ra) # 80200966 <curr_proc>
    802016c2:	89aa                	mv	s3,a0
	uint64 round = PGROUNDUP(len);
    802016c4:	6585                	lui	a1,0x1
    802016c6:	15fd                	addi	a1,a1,-1
    802016c8:	9aae                	add	s5,s5,a1
    802016ca:	797d                	lui	s2,0xfffff
    802016cc:	012af933          	and	s2,s5,s2

	for(uint64_t i = start; i < (uint64_t)(start + round); i += PGSIZE)
    802016d0:	9952                	add	s2,s2,s4
    802016d2:	032a7263          	bgeu	s4,s2,802016f6 <sys_munmap+0x62>
    802016d6:	84d2                	mv	s1,s4
    802016d8:	6b85                	lui	s7,0x1
	{
		pte_t *pte = walk(p->pagetable, i, 0);
    802016da:	4601                	li	a2,0
    802016dc:	85a6                	mv	a1,s1
    802016de:	0089b503          	ld	a0,8(s3)
    802016e2:	00001097          	auipc	ra,0x1
    802016e6:	804080e7          	jalr	-2044(ra) # 80201ee6 <walk>
		if (!(*pte & PTE_V))
    802016ea:	611c                	ld	a5,0(a0)
    802016ec:	8b85                	andi	a5,a5,1
    802016ee:	cb95                	beqz	a5,80201722 <sys_munmap+0x8e>
	for(uint64_t i = start; i < (uint64_t)(start + round); i += PGSIZE)
    802016f0:	94de                	add	s1,s1,s7
    802016f2:	ff24e4e3          	bltu	s1,s2,802016da <sys_munmap+0x46>
		{
			return -1;
		}
	}

	uvmunmap(p->pagetable, start, round/PGSIZE, 1);
    802016f6:	4685                	li	a3,1
    802016f8:	00cad613          	srli	a2,s5,0xc
    802016fc:	85d2                	mv	a1,s4
    802016fe:	0089b503          	ld	a0,8(s3)
    80201702:	00001097          	auipc	ra,0x1
    80201706:	b0e080e7          	jalr	-1266(ra) # 80202210 <uvmunmap>

	return 0;
}
    8020170a:	855a                	mv	a0,s6
    8020170c:	60a6                	ld	ra,72(sp)
    8020170e:	6406                	ld	s0,64(sp)
    80201710:	74e2                	ld	s1,56(sp)
    80201712:	7942                	ld	s2,48(sp)
    80201714:	79a2                	ld	s3,40(sp)
    80201716:	7a02                	ld	s4,32(sp)
    80201718:	6ae2                	ld	s5,24(sp)
    8020171a:	6b42                	ld	s6,16(sp)
    8020171c:	6ba2                	ld	s7,8(sp)
    8020171e:	6161                	addi	sp,sp,80
    80201720:	8082                	ret
			return -1;
    80201722:	5b7d                	li	s6,-1
    80201724:	b7dd                	j	8020170a <sys_munmap+0x76>

0000000080201726 <sys_getpid>:

uint64 sys_getpid()
{
    80201726:	1141                	addi	sp,sp,-16
    80201728:	e406                	sd	ra,8(sp)
    8020172a:	e022                	sd	s0,0(sp)
    8020172c:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
    8020172e:	fffff097          	auipc	ra,0xfffff
    80201732:	238080e7          	jalr	568(ra) # 80200966 <curr_proc>
}
    80201736:	4148                	lw	a0,4(a0)
    80201738:	60a2                	ld	ra,8(sp)
    8020173a:	6402                	ld	s0,0(sp)
    8020173c:	0141                	addi	sp,sp,16
    8020173e:	8082                	ret

0000000080201740 <sys_getppid>:

uint64 sys_getppid()
{
    80201740:	1141                	addi	sp,sp,-16
    80201742:	e406                	sd	ra,8(sp)
    80201744:	e022                	sd	s0,0(sp)
    80201746:	0800                	addi	s0,sp,16
	struct proc *p = curr_proc();
    80201748:	fffff097          	auipc	ra,0xfffff
    8020174c:	21e080e7          	jalr	542(ra) # 80200966 <curr_proc>
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
    80201750:	715c                	ld	a5,160(a0)
    80201752:	4501                	li	a0,0
    80201754:	c391                	beqz	a5,80201758 <sys_getppid+0x18>
    80201756:	43c8                	lw	a0,4(a5)
}
    80201758:	60a2                	ld	ra,8(sp)
    8020175a:	6402                	ld	s0,0(sp)
    8020175c:	0141                	addi	sp,sp,16
    8020175e:	8082                	ret

0000000080201760 <sys_clone>:

uint64 sys_clone()
{
    80201760:	1141                	addi	sp,sp,-16
    80201762:	e406                	sd	ra,8(sp)
    80201764:	e022                	sd	s0,0(sp)
    80201766:	0800                	addi	s0,sp,16
	debugf("fork!\n");
    80201768:	4501                	li	a0,0
    8020176a:	00000097          	auipc	ra,0x0
    8020176e:	be2080e7          	jalr	-1054(ra) # 8020134c <dummy>
	return fork();
    80201772:	fffff097          	auipc	ra,0xfffff
    80201776:	66a080e7          	jalr	1642(ra) # 80200ddc <fork>
}
    8020177a:	60a2                	ld	ra,8(sp)
    8020177c:	6402                	ld	s0,0(sp)
    8020177e:	0141                	addi	sp,sp,16
    80201780:	8082                	ret

0000000080201782 <sys_exec>:

uint64 sys_exec(uint64 va)
{
    80201782:	7151                	addi	sp,sp,-240
    80201784:	f586                	sd	ra,232(sp)
    80201786:	f1a2                	sd	s0,224(sp)
    80201788:	eda6                	sd	s1,216(sp)
    8020178a:	1980                	addi	s0,sp,240
    8020178c:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    8020178e:	fffff097          	auipc	ra,0xfffff
    80201792:	1d8080e7          	jalr	472(ra) # 80200966 <curr_proc>
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201796:	0c800693          	li	a3,200
    8020179a:	8626                	mv	a2,s1
    8020179c:	f1840593          	addi	a1,s0,-232
    802017a0:	6508                	ld	a0,8(a0)
    802017a2:	00001097          	auipc	ra,0x1
    802017a6:	ee6080e7          	jalr	-282(ra) # 80202688 <copyinstr>
	debugf("sys_exec %s\n", name);
    802017aa:	f1840593          	addi	a1,s0,-232
    802017ae:	4501                	li	a0,0
    802017b0:	00000097          	auipc	ra,0x0
    802017b4:	b9c080e7          	jalr	-1124(ra) # 8020134c <dummy>
	return exec(name);
    802017b8:	f1840513          	addi	a0,s0,-232
    802017bc:	fffff097          	auipc	ra,0xfffff
    802017c0:	722080e7          	jalr	1826(ra) # 80200ede <exec>
}
    802017c4:	70ae                	ld	ra,232(sp)
    802017c6:	740e                	ld	s0,224(sp)
    802017c8:	64ee                	ld	s1,216(sp)
    802017ca:	616d                	addi	sp,sp,240
    802017cc:	8082                	ret

00000000802017ce <sys_wait>:

uint64 sys_wait(int pid, uint64 va)
{
    802017ce:	1101                	addi	sp,sp,-32
    802017d0:	ec06                	sd	ra,24(sp)
    802017d2:	e822                	sd	s0,16(sp)
    802017d4:	e426                	sd	s1,8(sp)
    802017d6:	e04a                	sd	s2,0(sp)
    802017d8:	1000                	addi	s0,sp,32
    802017da:	84aa                	mv	s1,a0
    802017dc:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    802017de:	fffff097          	auipc	ra,0xfffff
    802017e2:	188080e7          	jalr	392(ra) # 80200966 <curr_proc>
	int *code = (int *)useraddr(p->pagetable, va);
    802017e6:	85ca                	mv	a1,s2
    802017e8:	6508                	ld	a0,8(a0)
    802017ea:	00001097          	auipc	ra,0x1
    802017ee:	810080e7          	jalr	-2032(ra) # 80201ffa <useraddr>
    802017f2:	85aa                	mv	a1,a0
	return wait(pid, code);
    802017f4:	8526                	mv	a0,s1
    802017f6:	fffff097          	auipc	ra,0xfffff
    802017fa:	740080e7          	jalr	1856(ra) # 80200f36 <wait>
}
    802017fe:	60e2                	ld	ra,24(sp)
    80201800:	6442                	ld	s0,16(sp)
    80201802:	64a2                	ld	s1,8(sp)
    80201804:	6902                	ld	s2,0(sp)
    80201806:	6105                	addi	sp,sp,32
    80201808:	8082                	ret

000000008020180a <sys_spawn>:

uint64 sys_spawn(uint64 va)
{
    8020180a:	7111                	addi	sp,sp,-256
    8020180c:	fd86                	sd	ra,248(sp)
    8020180e:	f9a2                	sd	s0,240(sp)
    80201810:	f5a6                	sd	s1,232(sp)
    80201812:	f1ca                	sd	s2,224(sp)
    80201814:	edce                	sd	s3,216(sp)
    80201816:	0200                	addi	s0,sp,256
    80201818:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    8020181a:	fffff097          	auipc	ra,0xfffff
    8020181e:	14c080e7          	jalr	332(ra) # 80200966 <curr_proc>
    80201822:	89aa                	mv	s3,a0
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201824:	0c800693          	li	a3,200
    80201828:	8626                	mv	a2,s1
    8020182a:	f0840593          	addi	a1,s0,-248
    8020182e:	6508                	ld	a0,8(a0)
    80201830:	00001097          	auipc	ra,0x1
    80201834:	e58080e7          	jalr	-424(ra) # 80202688 <copyinstr>

	int id = get_id_by_name(name);
    80201838:	f0840513          	addi	a0,s0,-248
    8020183c:	fffff097          	auipc	ra,0xfffff
    80201840:	a06080e7          	jalr	-1530(ra) # 80200242 <get_id_by_name>
	if (id < 0)
    80201844:	04054d63          	bltz	a0,8020189e <sys_spawn+0x94>
    80201848:	892a                	mv	s2,a0
	{
		return -1;
	}

	struct proc *np = allocproc();
    8020184a:	fffff097          	auipc	ra,0xfffff
    8020184e:	2be080e7          	jalr	702(ra) # 80200b08 <allocproc>
	if ((np = allocproc()) == 0)
    80201852:	fffff097          	auipc	ra,0xfffff
    80201856:	2b6080e7          	jalr	694(ra) # 80200b08 <allocproc>
    8020185a:	84aa                	mv	s1,a0
    8020185c:	c139                	beqz	a0,802018a2 <sys_spawn+0x98>
	{
		return -1;
	}

	if (loader(id, np) < 0)
    8020185e:	85aa                	mv	a1,a0
    80201860:	854a                	mv	a0,s2
    80201862:	fffff097          	auipc	ra,0xfffff
    80201866:	cd4080e7          	jalr	-812(ra) # 80200536 <loader>
    8020186a:	02054363          	bltz	a0,80201890 <sys_spawn+0x86>
	{
		freeproc(np);
		return -1;
	}

	np->parent = p;
    8020186e:	0b34b023          	sd	s3,160(s1)
	np->state = RUNNABLE;
    80201872:	478d                	li	a5,3
    80201874:	c09c                	sw	a5,0(s1)
	add_task(np);
    80201876:	8526                	mv	a0,s1
    80201878:	fffff097          	auipc	ra,0xfffff
    8020187c:	238080e7          	jalr	568(ra) # 80200ab0 <add_task>
	return np->pid;
    80201880:	40c8                	lw	a0,4(s1)
}
    80201882:	70ee                	ld	ra,248(sp)
    80201884:	744e                	ld	s0,240(sp)
    80201886:	74ae                	ld	s1,232(sp)
    80201888:	790e                	ld	s2,224(sp)
    8020188a:	69ee                	ld	s3,216(sp)
    8020188c:	6111                	addi	sp,sp,256
    8020188e:	8082                	ret
		freeproc(np);
    80201890:	8526                	mv	a0,s1
    80201892:	fffff097          	auipc	ra,0xfffff
    80201896:	51e080e7          	jalr	1310(ra) # 80200db0 <freeproc>
		return -1;
    8020189a:	557d                	li	a0,-1
    8020189c:	b7dd                	j	80201882 <sys_spawn+0x78>
		return -1;
    8020189e:	557d                	li	a0,-1
    802018a0:	b7cd                	j	80201882 <sys_spawn+0x78>
		return -1;
    802018a2:	557d                	li	a0,-1
    802018a4:	bff9                	j	80201882 <sys_spawn+0x78>

00000000802018a6 <sys_set_priority>:

uint64 sys_set_priority(long long prio){
    if(prio < 2) 
    802018a6:	4785                	li	a5,1
    802018a8:	02a7dc63          	bge	a5,a0,802018e0 <sys_set_priority+0x3a>
uint64 sys_set_priority(long long prio){
    802018ac:	1101                	addi	sp,sp,-32
    802018ae:	ec06                	sd	ra,24(sp)
    802018b0:	e822                	sd	s0,16(sp)
    802018b2:	e426                	sd	s1,8(sp)
    802018b4:	1000                	addi	s0,sp,32
    802018b6:	84aa                	mv	s1,a0
	{
		return -1;
	}

	struct proc *p = curr_proc();
    802018b8:	fffff097          	auipc	ra,0xfffff
    802018bc:	0ae080e7          	jalr	174(ra) # 80200966 <curr_proc>
	p->priority = prio;
    802018c0:	14953423          	sd	s1,328(a0)
	p->pass = BIG_STRIDE / prio;
    802018c4:	000f47b7          	lui	a5,0xf4
    802018c8:	24078793          	addi	a5,a5,576 # f4240 <_entry-0x8010bdc0>
    802018cc:	0297c7b3          	div	a5,a5,s1
    802018d0:	14f53023          	sd	a5,320(a0)
	return (uint64)prio;
    802018d4:	8526                	mv	a0,s1
}
    802018d6:	60e2                	ld	ra,24(sp)
    802018d8:	6442                	ld	s0,16(sp)
    802018da:	64a2                	ld	s1,8(sp)
    802018dc:	6105                	addi	sp,sp,32
    802018de:	8082                	ret
		return -1;
    802018e0:	557d                	li	a0,-1
}
    802018e2:	8082                	ret

00000000802018e4 <syscall>:


extern char trap_page[];

void syscall()
{
    802018e4:	715d                	addi	sp,sp,-80
    802018e6:	e486                	sd	ra,72(sp)
    802018e8:	e0a2                	sd	s0,64(sp)
    802018ea:	fc26                	sd	s1,56(sp)
    802018ec:	f84a                	sd	s2,48(sp)
    802018ee:	f44e                	sd	s3,40(sp)
    802018f0:	f052                	sd	s4,32(sp)
    802018f2:	ec56                	sd	s5,24(sp)
    802018f4:	e85a                	sd	s6,16(sp)
    802018f6:	e45e                	sd	s7,8(sp)
    802018f8:	0880                	addi	s0,sp,80
	struct trapframe *trapframe = curr_proc()->trapframe;
    802018fa:	fffff097          	auipc	ra,0xfffff
    802018fe:	06c080e7          	jalr	108(ra) # 80200966 <curr_proc>
    80201902:	02053903          	ld	s2,32(a0)
	int id = trapframe->a7, ret;
    80201906:	0a892483          	lw	s1,168(s2) # fffffffffffff0a8 <e_bss+0xffffffff7f8710a8>
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    8020190a:	07093983          	ld	s3,112(s2)
    8020190e:	07893a03          	ld	s4,120(s2)
    80201912:	08093a83          	ld	s5,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    80201916:	08893b03          	ld	s6,136(s2)
    8020191a:	09093b83          	ld	s7,144(s2)
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    8020191e:	09893883          	ld	a7,152(s2)
    80201922:	885e                	mv	a6,s7
    80201924:	87da                	mv	a5,s6
    80201926:	8756                	mv	a4,s5
    80201928:	86d2                	mv	a3,s4
    8020192a:	864e                	mv	a2,s3
    8020192c:	85a6                	mv	a1,s1
    8020192e:	4501                	li	a0,0
    80201930:	00000097          	auipc	ra,0x0
    80201934:	a1c080e7          	jalr	-1508(ra) # 8020134c <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	
	struct proc *p = curr_proc();
    80201938:	fffff097          	auipc	ra,0xfffff
    8020193c:	02e080e7          	jalr	46(ra) # 80200966 <curr_proc>
	if (id >= 0 && id < MAX_SYSCALL_NUM) 
    80201940:	1f300793          	li	a5,499
    80201944:	0097ea63          	bltu	a5,s1,80201958 <syscall+0x74>
	{
		p->ti->syscall_times[id]++;
    80201948:	00249793          	slli	a5,s1,0x2
    8020194c:	13053703          	ld	a4,304(a0)
    80201950:	97ba                	add	a5,a5,a4
    80201952:	43d8                	lw	a4,4(a5)
    80201954:	2705                	addiw	a4,a4,1
    80201956:	c3d8                	sw	a4,4(a5)
	}

	switch (id) {
    80201958:	0de00793          	li	a5,222
    8020195c:	0a97c563          	blt	a5,s1,80201a06 <syscall+0x122>
    80201960:	0a800793          	li	a5,168
    80201964:	0697cd63          	blt	a5,s1,802019de <syscall+0xfa>
    80201968:	05d00793          	li	a5,93
    8020196c:	0ef48563          	beq	s1,a5,80201a56 <syscall+0x172>
    80201970:	0297d263          	bge	a5,s1,80201994 <syscall+0xb0>
    80201974:	07c00793          	li	a5,124
    80201978:	0ef48563          	beq	s1,a5,80201a62 <syscall+0x17e>
    8020197c:	08c00793          	li	a5,140
    80201980:	16f49e63          	bne	s1,a5,80201afc <syscall+0x218>
		break;
	case SYS_spawn:
		ret = sys_spawn(args[0]);
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
    80201984:	854e                	mv	a0,s3
    80201986:	00000097          	auipc	ra,0x0
    8020198a:	f20080e7          	jalr	-224(ra) # 802018a6 <sys_set_priority>
    8020198e:	0005059b          	sext.w	a1,a0
		break;
    80201992:	a025                	j	802019ba <syscall+0xd6>
	switch (id) {
    80201994:	03f00793          	li	a5,63
    80201998:	0af48463          	beq	s1,a5,80201a40 <syscall+0x15c>
    8020199c:	04000793          	li	a5,64
    802019a0:	14f49e63          	bne	s1,a5,80201afc <syscall+0x218>
		ret = sys_write(args[0], args[1], args[2]);
    802019a4:	000a861b          	sext.w	a2,s5
    802019a8:	85d2                	mv	a1,s4
    802019aa:	0009851b          	sext.w	a0,s3
    802019ae:	00000097          	auipc	ra,0x0
    802019b2:	9bc080e7          	jalr	-1604(ra) # 8020136a <sys_write>
    802019b6:	0005059b          	sext.w	a1,a0
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
    802019ba:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    802019be:	4501                	li	a0,0
    802019c0:	00000097          	auipc	ra,0x0
    802019c4:	98c080e7          	jalr	-1652(ra) # 8020134c <dummy>
}
    802019c8:	60a6                	ld	ra,72(sp)
    802019ca:	6406                	ld	s0,64(sp)
    802019cc:	74e2                	ld	s1,56(sp)
    802019ce:	7942                	ld	s2,48(sp)
    802019d0:	79a2                	ld	s3,40(sp)
    802019d2:	7a02                	ld	s4,32(sp)
    802019d4:	6ae2                	ld	s5,24(sp)
    802019d6:	6b42                	ld	s6,16(sp)
    802019d8:	6ba2                	ld	s7,8(sp)
    802019da:	6161                	addi	sp,sp,80
    802019dc:	8082                	ret
    802019de:	f574879b          	addiw	a5,s1,-169
    802019e2:	0007869b          	sext.w	a3,a5
    802019e6:	03500713          	li	a4,53
    802019ea:	10d76963          	bltu	a4,a3,80201afc <syscall+0x218>
    802019ee:	02079713          	slli	a4,a5,0x20
    802019f2:	01e75793          	srli	a5,a4,0x1e
    802019f6:	00003717          	auipc	a4,0x3
    802019fa:	89e70713          	addi	a4,a4,-1890 # 80204294 <digits+0x164>
    802019fe:	97ba                	add	a5,a5,a4
    80201a00:	439c                	lw	a5,0(a5)
    80201a02:	97ba                	add	a5,a5,a4
    80201a04:	8782                	jr	a5
	switch (id) {
    80201a06:	19000793          	li	a5,400
    80201a0a:	0ef48163          	beq	s1,a5,80201aec <syscall+0x208>
    80201a0e:	19a00793          	li	a5,410
    80201a12:	00f49963          	bne	s1,a5,80201a24 <syscall+0x140>
		ret = sys_task_info(args[0]);
    80201a16:	854e                	mv	a0,s3
    80201a18:	00000097          	auipc	ra,0x0
    80201a1c:	b00080e7          	jalr	-1280(ra) # 80201518 <sys_task_info>
    80201a20:	85aa                	mv	a1,a0
		break;
    80201a22:	bf61                	j	802019ba <syscall+0xd6>
	switch (id) {
    80201a24:	10400793          	li	a5,260
    80201a28:	0cf49a63          	bne	s1,a5,80201afc <syscall+0x218>
		ret = sys_wait(args[0], args[1]);
    80201a2c:	85d2                	mv	a1,s4
    80201a2e:	0009851b          	sext.w	a0,s3
    80201a32:	00000097          	auipc	ra,0x0
    80201a36:	d9c080e7          	jalr	-612(ra) # 802017ce <sys_wait>
    80201a3a:	0005059b          	sext.w	a1,a0
		break;
    80201a3e:	bfb5                	j	802019ba <syscall+0xd6>
		ret = sys_read(args[0], args[1], args[2]);
    80201a40:	8656                	mv	a2,s5
    80201a42:	85d2                	mv	a1,s4
    80201a44:	0009851b          	sext.w	a0,s3
    80201a48:	00000097          	auipc	ra,0x0
    80201a4c:	9c2080e7          	jalr	-1598(ra) # 8020140a <sys_read>
    80201a50:	0005059b          	sext.w	a1,a0
		break;
    80201a54:	b79d                	j	802019ba <syscall+0xd6>
	exit(code);
    80201a56:	0009851b          	sext.w	a0,s3
    80201a5a:	fffff097          	auipc	ra,0xfffff
    80201a5e:	582080e7          	jalr	1410(ra) # 80200fdc <exit>
	yield();
    80201a62:	fffff097          	auipc	ra,0xfffff
    80201a66:	2cc080e7          	jalr	716(ra) # 80200d2e <yield>
		ret = sys_sched_yield();
    80201a6a:	4581                	li	a1,0
		break;
    80201a6c:	b7b9                	j	802019ba <syscall+0xd6>
		ret = sys_gettimeofday(args[0], args[1]);
    80201a6e:	000a059b          	sext.w	a1,s4
    80201a72:	854e                	mv	a0,s3
    80201a74:	00000097          	auipc	ra,0x0
    80201a78:	a3c080e7          	jalr	-1476(ra) # 802014b0 <sys_gettimeofday>
    80201a7c:	0005059b          	sext.w	a1,a0
		break;
    80201a80:	bf2d                	j	802019ba <syscall+0xd6>
		ret = sys_munmap(args[0], args[1]);
    80201a82:	85d2                	mv	a1,s4
    80201a84:	854e                	mv	a0,s3
    80201a86:	00000097          	auipc	ra,0x0
    80201a8a:	c0e080e7          	jalr	-1010(ra) # 80201694 <sys_munmap>
    80201a8e:	0005059b          	sext.w	a1,a0
		break;
    80201a92:	b725                	j	802019ba <syscall+0xd6>
		ret = sys_mmap(args[0], args[1], args[2], args[3], args[4]);
    80201a94:	000b871b          	sext.w	a4,s7
    80201a98:	000b069b          	sext.w	a3,s6
    80201a9c:	000a861b          	sext.w	a2,s5
    80201aa0:	85d2                	mv	a1,s4
    80201aa2:	854e                	mv	a0,s3
    80201aa4:	00000097          	auipc	ra,0x0
    80201aa8:	af8080e7          	jalr	-1288(ra) # 8020159c <sys_mmap>
    80201aac:	0005059b          	sext.w	a1,a0
		break;
    80201ab0:	b729                	j	802019ba <syscall+0xd6>
		ret = sys_getpid();
    80201ab2:	00000097          	auipc	ra,0x0
    80201ab6:	c74080e7          	jalr	-908(ra) # 80201726 <sys_getpid>
    80201aba:	0005059b          	sext.w	a1,a0
		break;
    80201abe:	bdf5                	j	802019ba <syscall+0xd6>
		ret = sys_getppid();
    80201ac0:	00000097          	auipc	ra,0x0
    80201ac4:	c80080e7          	jalr	-896(ra) # 80201740 <sys_getppid>
    80201ac8:	0005059b          	sext.w	a1,a0
		break;
    80201acc:	b5fd                	j	802019ba <syscall+0xd6>
		ret = sys_clone();
    80201ace:	00000097          	auipc	ra,0x0
    80201ad2:	c92080e7          	jalr	-878(ra) # 80201760 <sys_clone>
    80201ad6:	0005059b          	sext.w	a1,a0
		break;
    80201ada:	b5c5                	j	802019ba <syscall+0xd6>
		ret = sys_exec(args[0]);
    80201adc:	854e                	mv	a0,s3
    80201ade:	00000097          	auipc	ra,0x0
    80201ae2:	ca4080e7          	jalr	-860(ra) # 80201782 <sys_exec>
    80201ae6:	0005059b          	sext.w	a1,a0
		break;
    80201aea:	bdc1                	j	802019ba <syscall+0xd6>
		ret = sys_spawn(args[0]);
    80201aec:	854e                	mv	a0,s3
    80201aee:	00000097          	auipc	ra,0x0
    80201af2:	d1c080e7          	jalr	-740(ra) # 8020180a <sys_spawn>
    80201af6:	0005059b          	sext.w	a1,a0
		break;
    80201afa:	b5c1                	j	802019ba <syscall+0xd6>
		errorf("unknown syscall %d", id);
    80201afc:	fffff097          	auipc	ra,0xfffff
    80201b00:	e54080e7          	jalr	-428(ra) # 80200950 <threadid>
    80201b04:	86aa                	mv	a3,a0
    80201b06:	8726                	mv	a4,s1
    80201b08:	00002617          	auipc	a2,0x2
    80201b0c:	76060613          	addi	a2,a2,1888 # 80204268 <digits+0x138>
    80201b10:	45fd                	li	a1,31
    80201b12:	00002517          	auipc	a0,0x2
    80201b16:	75e50513          	addi	a0,a0,1886 # 80204270 <digits+0x140>
    80201b1a:	fffff097          	auipc	ra,0xfffff
    80201b1e:	c60080e7          	jalr	-928(ra) # 8020077a <printf>
		ret = -1;
    80201b22:	55fd                	li	a1,-1
    80201b24:	bd59                	j	802019ba <syscall+0xd6>

0000000080201b26 <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    80201b26:	1141                	addi	sp,sp,-16
    80201b28:	e422                	sd	s0,8(sp)
    80201b2a:	0800                	addi	s0,sp,16

// machine-mode cycle counter
static inline uint64 r_time()
{
	uint64 x;
	asm volatile("csrr %0, time" : "=r"(x));
    80201b2c:	c0102573          	rdtime	a0
	return r_time();
}
    80201b30:	6422                	ld	s0,8(sp)
    80201b32:	0141                	addi	sp,sp,16
    80201b34:	8082                	ret

0000000080201b36 <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    80201b36:	1141                	addi	sp,sp,-16
    80201b38:	e406                	sd	ra,8(sp)
    80201b3a:	e022                	sd	s0,0(sp)
    80201b3c:	0800                	addi	s0,sp,16
    80201b3e:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80201b42:	67fd                	lui	a5,0x1f
    80201b44:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    80201b48:	953e                	add	a0,a0,a5
    80201b4a:	fffff097          	auipc	ra,0xfffff
    80201b4e:	63e080e7          	jalr	1598(ra) # 80201188 <set_timer>
    80201b52:	60a2                	ld	ra,8(sp)
    80201b54:	6402                	ld	s0,0(sp)
    80201b56:	0141                	addi	sp,sp,16
    80201b58:	8082                	ret

0000000080201b5a <timer_init>:
{
    80201b5a:	1141                	addi	sp,sp,-16
    80201b5c:	e406                	sd	ra,8(sp)
    80201b5e:	e022                	sd	s0,0(sp)
    80201b60:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80201b62:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    80201b66:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80201b6a:	10479073          	csrw	sie,a5
	set_next_timer();
    80201b6e:	00000097          	auipc	ra,0x0
    80201b72:	fc8080e7          	jalr	-56(ra) # 80201b36 <set_next_timer>
}
    80201b76:	60a2                	ld	ra,8(sp)
    80201b78:	6402                	ld	s0,0(sp)
    80201b7a:	0141                	addi	sp,sp,16
    80201b7c:	8082                	ret

0000000080201b7e <kerneltrap>:

extern char trampoline[], uservec[];
extern char userret[];

void kerneltrap()
{
    80201b7e:	1141                	addi	sp,sp,-16
    80201b80:	e406                	sd	ra,8(sp)
    80201b82:	e022                	sd	s0,0(sp)
    80201b84:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201b86:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    80201b8a:	1007f793          	andi	a5,a5,256
    80201b8e:	c3a1                	beqz	a5,80201bce <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kerne");
    80201b90:	fffff097          	auipc	ra,0xfffff
    80201b94:	dc0080e7          	jalr	-576(ra) # 80200950 <threadid>
    80201b98:	86aa                	mv	a3,a0
    80201b9a:	47b9                	li	a5,14
    80201b9c:	00002717          	auipc	a4,0x2
    80201ba0:	7d470713          	addi	a4,a4,2004 # 80204370 <digits+0x240>
    80201ba4:	00002617          	auipc	a2,0x2
    80201ba8:	46c60613          	addi	a2,a2,1132 # 80204010 <e_text+0x10>
    80201bac:	45fd                	li	a1,31
    80201bae:	00003517          	auipc	a0,0x3
    80201bb2:	81250513          	addi	a0,a0,-2030 # 802043c0 <digits+0x290>
    80201bb6:	fffff097          	auipc	ra,0xfffff
    80201bba:	bc4080e7          	jalr	-1084(ra) # 8020077a <printf>
    80201bbe:	fffff097          	auipc	ra,0xfffff
    80201bc2:	5b2080e7          	jalr	1458(ra) # 80201170 <shutdown>
}
    80201bc6:	60a2                	ld	ra,8(sp)
    80201bc8:	6402                	ld	s0,0(sp)
    80201bca:	0141                	addi	sp,sp,16
    80201bcc:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80201bce:	fffff097          	auipc	ra,0xfffff
    80201bd2:	d82080e7          	jalr	-638(ra) # 80200950 <threadid>
    80201bd6:	86aa                	mv	a3,a0
    80201bd8:	47b5                	li	a5,13
    80201bda:	00002717          	auipc	a4,0x2
    80201bde:	79670713          	addi	a4,a4,1942 # 80204370 <digits+0x240>
    80201be2:	00002617          	auipc	a2,0x2
    80201be6:	42e60613          	addi	a2,a2,1070 # 80204010 <e_text+0x10>
    80201bea:	45fd                	li	a1,31
    80201bec:	00002517          	auipc	a0,0x2
    80201bf0:	79450513          	addi	a0,a0,1940 # 80204380 <digits+0x250>
    80201bf4:	fffff097          	auipc	ra,0xfffff
    80201bf8:	b86080e7          	jalr	-1146(ra) # 8020077a <printf>
    80201bfc:	fffff097          	auipc	ra,0xfffff
    80201c00:	574080e7          	jalr	1396(ra) # 80201170 <shutdown>
    80201c04:	b771                	j	80201b90 <kerneltrap+0x12>

0000000080201c06 <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void set_usertrap()
{
    80201c06:	1141                	addi	sp,sp,-16
    80201c08:	e422                	sd	s0,8(sp)
    80201c0a:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201c0c:	04000737          	lui	a4,0x4000
    80201c10:	00001797          	auipc	a5,0x1
    80201c14:	3f078793          	addi	a5,a5,1008 # 80203000 <trampoline>
    80201c18:	00001697          	auipc	a3,0x1
    80201c1c:	3e868693          	addi	a3,a3,1000 # 80203000 <trampoline>
    80201c20:	8f95                	sub	a5,a5,a3
    80201c22:	177d                	addi	a4,a4,-1
    80201c24:	0732                	slli	a4,a4,0xc
    80201c26:	97ba                	add	a5,a5,a4
    80201c28:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201c2a:	10579073          	csrw	stvec,a5
}
    80201c2e:	6422                	ld	s0,8(sp)
    80201c30:	0141                	addi	sp,sp,16
    80201c32:	8082                	ret

0000000080201c34 <set_kerneltrap>:

void set_kerneltrap()
{
    80201c34:	1141                	addi	sp,sp,-16
    80201c36:	e422                	sd	s0,8(sp)
    80201c38:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201c3a:	00000797          	auipc	a5,0x0
    80201c3e:	f4478793          	addi	a5,a5,-188 # 80201b7e <kerneltrap>
    80201c42:	9bf1                	andi	a5,a5,-4
    80201c44:	10579073          	csrw	stvec,a5
}
    80201c48:	6422                	ld	s0,8(sp)
    80201c4a:	0141                	addi	sp,sp,16
    80201c4c:	8082                	ret

0000000080201c4e <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init()
{
    80201c4e:	1141                	addi	sp,sp,-16
    80201c50:	e422                	sd	s0,8(sp)
    80201c52:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201c54:	00000797          	auipc	a5,0x0
    80201c58:	f2a78793          	addi	a5,a5,-214 # 80201b7e <kerneltrap>
    80201c5c:	9bf1                	andi	a5,a5,-4
    80201c5e:	10579073          	csrw	stvec,a5
	// intr_on();
	set_kerneltrap();
}
    80201c62:	6422                	ld	s0,8(sp)
    80201c64:	0141                	addi	sp,sp,16
    80201c66:	8082                	ret

0000000080201c68 <unknown_trap>:

void unknown_trap()
{
    80201c68:	1141                	addi	sp,sp,-16
    80201c6a:	e406                	sd	ra,8(sp)
    80201c6c:	e022                	sd	s0,0(sp)
    80201c6e:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    80201c70:	fffff097          	auipc	ra,0xfffff
    80201c74:	ce0080e7          	jalr	-800(ra) # 80200950 <threadid>
    80201c78:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80201c7a:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80201c7e:	143027f3          	csrr	a5,stval
    80201c82:	00002617          	auipc	a2,0x2
    80201c86:	5e660613          	addi	a2,a2,1510 # 80204268 <digits+0x138>
    80201c8a:	45fd                	li	a1,31
    80201c8c:	00002517          	auipc	a0,0x2
    80201c90:	76450513          	addi	a0,a0,1892 # 802043f0 <digits+0x2c0>
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	ae6080e7          	jalr	-1306(ra) # 8020077a <printf>
	exit(-1);
    80201c9c:	557d                	li	a0,-1
    80201c9e:	fffff097          	auipc	ra,0xfffff
    80201ca2:	33e080e7          	jalr	830(ra) # 80200fdc <exit>
}
    80201ca6:	60a2                	ld	ra,8(sp)
    80201ca8:	6402                	ld	s0,0(sp)
    80201caa:	0141                	addi	sp,sp,16
    80201cac:	8082                	ret

0000000080201cae <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    80201cae:	7179                	addi	sp,sp,-48
    80201cb0:	f406                	sd	ra,40(sp)
    80201cb2:	f022                	sd	s0,32(sp)
    80201cb4:	ec26                	sd	s1,24(sp)
    80201cb6:	e84a                	sd	s2,16(sp)
    80201cb8:	e44e                	sd	s3,8(sp)
    80201cba:	e052                	sd	s4,0(sp)
    80201cbc:	1800                	addi	s0,sp,48
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201cbe:	00001a17          	auipc	s4,0x1
    80201cc2:	342a0a13          	addi	s4,s4,834 # 80203000 <trampoline>
    80201cc6:	00001797          	auipc	a5,0x1
    80201cca:	33a78793          	addi	a5,a5,826 # 80203000 <trampoline>
    80201cce:	414787b3          	sub	a5,a5,s4
    80201cd2:	040004b7          	lui	s1,0x4000
    80201cd6:	14fd                	addi	s1,s1,-1
    80201cd8:	04b2                	slli	s1,s1,0xc
    80201cda:	97a6                	add	a5,a5,s1
    80201cdc:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201cde:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201ce2:	fffff097          	auipc	ra,0xfffff
    80201ce6:	c84080e7          	jalr	-892(ra) # 80200966 <curr_proc>
    80201cea:	02053903          	ld	s2,32(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    80201cee:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80201cf2:	00f93023          	sd	a5,0(s2)
	trapframe->kernel_sp =
		curr_proc()->kstack + KSTACK_SIZE; // process's kernel stack
    80201cf6:	fffff097          	auipc	ra,0xfffff
    80201cfa:	c70080e7          	jalr	-912(ra) # 80200966 <curr_proc>
    80201cfe:	6d1c                	ld	a5,24(a0)
    80201d00:	6705                	lui	a4,0x1
    80201d02:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80201d04:	00f93423          	sd	a5,8(s2)
	trapframe->kernel_trap = (uint64)usertrap;
    80201d08:	00000797          	auipc	a5,0x0
    80201d0c:	07a78793          	addi	a5,a5,122 # 80201d82 <usertrap>
    80201d10:	00f93823          	sd	a5,16(s2)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80201d14:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    80201d16:	02f93023          	sd	a5,32(s2)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80201d1a:	01893783          	ld	a5,24(s2)
    80201d1e:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201d22:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80201d26:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80201d2a:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80201d2e:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80201d32:	fffff097          	auipc	ra,0xfffff
    80201d36:	c34080e7          	jalr	-972(ra) # 80200966 <curr_proc>
    80201d3a:	00853983          	ld	s3,8(a0)
    80201d3e:	00c9d993          	srli	s3,s3,0xc
    80201d42:	57fd                	li	a5,-1
    80201d44:	17fe                	slli	a5,a5,0x3f
    80201d46:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	tracef("return to user @ %p", trapframe->epc);
    80201d4a:	01893583          	ld	a1,24(s2)
    80201d4e:	4501                	li	a0,0
    80201d50:	fffff097          	auipc	ra,0xfffff
    80201d54:	5fc080e7          	jalr	1532(ra) # 8020134c <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    80201d58:	00001797          	auipc	a5,0x1
    80201d5c:	34078793          	addi	a5,a5,832 # 80203098 <userret>
    80201d60:	414787b3          	sub	a5,a5,s4
    80201d64:	94be                	add	s1,s1,a5
	((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80201d66:	85ce                	mv	a1,s3
    80201d68:	02000537          	lui	a0,0x2000
    80201d6c:	157d                	addi	a0,a0,-1
    80201d6e:	0536                	slli	a0,a0,0xd
    80201d70:	9482                	jalr	s1
    80201d72:	70a2                	ld	ra,40(sp)
    80201d74:	7402                	ld	s0,32(sp)
    80201d76:	64e2                	ld	s1,24(sp)
    80201d78:	6942                	ld	s2,16(sp)
    80201d7a:	69a2                	ld	s3,8(sp)
    80201d7c:	6a02                	ld	s4,0(sp)
    80201d7e:	6145                	addi	sp,sp,48
    80201d80:	8082                	ret

0000000080201d82 <usertrap>:
{
    80201d82:	1101                	addi	sp,sp,-32
    80201d84:	ec06                	sd	ra,24(sp)
    80201d86:	e822                	sd	s0,16(sp)
    80201d88:	e426                	sd	s1,8(sp)
    80201d8a:	e04a                	sd	s2,0(sp)
    80201d8c:	1000                	addi	s0,sp,32
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201d8e:	00000797          	auipc	a5,0x0
    80201d92:	df078793          	addi	a5,a5,-528 # 80201b7e <kerneltrap>
    80201d96:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201d98:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201d9c:	fffff097          	auipc	ra,0xfffff
    80201da0:	bca080e7          	jalr	-1078(ra) # 80200966 <curr_proc>
    80201da4:	02053903          	ld	s2,32(a0) # 2000020 <_entry-0x7e1fffe0>
	tracef("trap from user epc = %p", trapframe->epc);
    80201da8:	01893583          	ld	a1,24(s2)
    80201dac:	4501                	li	a0,0
    80201dae:	fffff097          	auipc	ra,0xfffff
    80201db2:	59e080e7          	jalr	1438(ra) # 8020134c <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201db6:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80201dba:	1007f793          	andi	a5,a5,256
    80201dbe:	e395                	bnez	a5,80201de2 <usertrap+0x60>
	asm volatile("csrr %0, scause" : "=r"(x));
    80201dc0:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    80201dc4:	0404cc63          	bltz	s1,80201e1c <usertrap+0x9a>
		switch (cause) {
    80201dc8:	47bd                	li	a5,15
    80201dca:	1097e963          	bltu	a5,s1,80201edc <usertrap+0x15a>
    80201dce:	00249713          	slli	a4,s1,0x2
    80201dd2:	00002697          	auipc	a3,0x2
    80201dd6:	72268693          	addi	a3,a3,1826 # 802044f4 <digits+0x3c4>
    80201dda:	9736                	add	a4,a4,a3
    80201ddc:	431c                	lw	a5,0(a4)
    80201dde:	97b6                	add	a5,a5,a3
    80201de0:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80201de2:	fffff097          	auipc	ra,0xfffff
    80201de6:	b6e080e7          	jalr	-1170(ra) # 80200950 <threadid>
    80201dea:	86aa                	mv	a3,a0
    80201dec:	03300793          	li	a5,51
    80201df0:	00002717          	auipc	a4,0x2
    80201df4:	58070713          	addi	a4,a4,1408 # 80204370 <digits+0x240>
    80201df8:	00002617          	auipc	a2,0x2
    80201dfc:	21860613          	addi	a2,a2,536 # 80204010 <e_text+0x10>
    80201e00:	45fd                	li	a1,31
    80201e02:	00002517          	auipc	a0,0x2
    80201e06:	61e50513          	addi	a0,a0,1566 # 80204420 <digits+0x2f0>
    80201e0a:	fffff097          	auipc	ra,0xfffff
    80201e0e:	970080e7          	jalr	-1680(ra) # 8020077a <printf>
    80201e12:	fffff097          	auipc	ra,0xfffff
    80201e16:	35e080e7          	jalr	862(ra) # 80201170 <shutdown>
    80201e1a:	b75d                	j	80201dc0 <usertrap+0x3e>
		cause &= ~(1ULL << 63);
    80201e1c:	0486                	slli	s1,s1,0x1
    80201e1e:	8085                	srli	s1,s1,0x1
		switch (cause) {
    80201e20:	4795                	li	a5,5
    80201e22:	02f48063          	beq	s1,a5,80201e42 <usertrap+0xc0>
			unknown_trap();
    80201e26:	00000097          	auipc	ra,0x0
    80201e2a:	e42080e7          	jalr	-446(ra) # 80201c68 <unknown_trap>
	usertrapret();
    80201e2e:	00000097          	auipc	ra,0x0
    80201e32:	e80080e7          	jalr	-384(ra) # 80201cae <usertrapret>
}
    80201e36:	60e2                	ld	ra,24(sp)
    80201e38:	6442                	ld	s0,16(sp)
    80201e3a:	64a2                	ld	s1,8(sp)
    80201e3c:	6902                	ld	s2,0(sp)
    80201e3e:	6105                	addi	sp,sp,32
    80201e40:	8082                	ret
			tracef("time interrupt!");
    80201e42:	4501                	li	a0,0
    80201e44:	fffff097          	auipc	ra,0xfffff
    80201e48:	508080e7          	jalr	1288(ra) # 8020134c <dummy>
			set_next_timer();
    80201e4c:	00000097          	auipc	ra,0x0
    80201e50:	cea080e7          	jalr	-790(ra) # 80201b36 <set_next_timer>
			yield();
    80201e54:	fffff097          	auipc	ra,0xfffff
    80201e58:	eda080e7          	jalr	-294(ra) # 80200d2e <yield>
			break;
    80201e5c:	bfc9                	j	80201e2e <usertrap+0xac>
			trapframe->epc += 4;
    80201e5e:	01893783          	ld	a5,24(s2)
    80201e62:	0791                	addi	a5,a5,4
    80201e64:	00f93c23          	sd	a5,24(s2)
			syscall();
    80201e68:	00000097          	auipc	ra,0x0
    80201e6c:	a7c080e7          	jalr	-1412(ra) # 802018e4 <syscall>
			break;
    80201e70:	bf7d                	j	80201e2e <usertrap+0xac>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    80201e72:	fffff097          	auipc	ra,0xfffff
    80201e76:	ade080e7          	jalr	-1314(ra) # 80200950 <threadid>
    80201e7a:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80201e7c:	143027f3          	csrr	a5,stval
    80201e80:	01893803          	ld	a6,24(s2)
    80201e84:	8726                	mv	a4,s1
    80201e86:	00002617          	auipc	a2,0x2
    80201e8a:	3e260613          	addi	a2,a2,994 # 80204268 <digits+0x138>
    80201e8e:	45fd                	li	a1,31
    80201e90:	00002517          	auipc	a0,0x2
    80201e94:	5c850513          	addi	a0,a0,1480 # 80204458 <digits+0x328>
    80201e98:	fffff097          	auipc	ra,0xfffff
    80201e9c:	8e2080e7          	jalr	-1822(ra) # 8020077a <printf>
			exit(-2);
    80201ea0:	5579                	li	a0,-2
    80201ea2:	fffff097          	auipc	ra,0xfffff
    80201ea6:	13a080e7          	jalr	314(ra) # 80200fdc <exit>
			break;
    80201eaa:	b751                	j	80201e2e <usertrap+0xac>
			errorf("IllegalInstruction in application, core dumped.");
    80201eac:	fffff097          	auipc	ra,0xfffff
    80201eb0:	aa4080e7          	jalr	-1372(ra) # 80200950 <threadid>
    80201eb4:	86aa                	mv	a3,a0
    80201eb6:	00002617          	auipc	a2,0x2
    80201eba:	3b260613          	addi	a2,a2,946 # 80204268 <digits+0x138>
    80201ebe:	45fd                	li	a1,31
    80201ec0:	00002517          	auipc	a0,0x2
    80201ec4:	5f050513          	addi	a0,a0,1520 # 802044b0 <digits+0x380>
    80201ec8:	fffff097          	auipc	ra,0xfffff
    80201ecc:	8b2080e7          	jalr	-1870(ra) # 8020077a <printf>
			exit(-3);
    80201ed0:	5575                	li	a0,-3
    80201ed2:	fffff097          	auipc	ra,0xfffff
    80201ed6:	10a080e7          	jalr	266(ra) # 80200fdc <exit>
			break;
    80201eda:	bf91                	j	80201e2e <usertrap+0xac>
			unknown_trap();
    80201edc:	00000097          	auipc	ra,0x0
    80201ee0:	d8c080e7          	jalr	-628(ra) # 80201c68 <unknown_trap>
			break;
    80201ee4:	b7a9                	j	80201e2e <usertrap+0xac>

0000000080201ee6 <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80201ee6:	7139                	addi	sp,sp,-64
    80201ee8:	fc06                	sd	ra,56(sp)
    80201eea:	f822                	sd	s0,48(sp)
    80201eec:	f426                	sd	s1,40(sp)
    80201eee:	f04a                	sd	s2,32(sp)
    80201ef0:	ec4e                	sd	s3,24(sp)
    80201ef2:	e852                	sd	s4,16(sp)
    80201ef4:	e456                	sd	s5,8(sp)
    80201ef6:	e05a                	sd	s6,0(sp)
    80201ef8:	0080                	addi	s0,sp,64
    80201efa:	84aa                	mv	s1,a0
    80201efc:	89ae                	mv	s3,a1
    80201efe:	8ab2                	mv	s5,a2
	if (va >= MAXVA)
    80201f00:	57fd                	li	a5,-1
    80201f02:	83e9                	srli	a5,a5,0x1a
    80201f04:	00b7e563          	bltu	a5,a1,80201f0e <walk+0x28>
{
    80201f08:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    80201f0a:	4b31                	li	s6,12
    80201f0c:	a0b5                	j	80201f78 <walk+0x92>
		panic("walk");
    80201f0e:	fffff097          	auipc	ra,0xfffff
    80201f12:	a42080e7          	jalr	-1470(ra) # 80200950 <threadid>
    80201f16:	86aa                	mv	a3,a0
    80201f18:	03400793          	li	a5,52
    80201f1c:	00002717          	auipc	a4,0x2
    80201f20:	61c70713          	addi	a4,a4,1564 # 80204538 <digits+0x408>
    80201f24:	00002617          	auipc	a2,0x2
    80201f28:	0ec60613          	addi	a2,a2,236 # 80204010 <e_text+0x10>
    80201f2c:	45fd                	li	a1,31
    80201f2e:	00002517          	auipc	a0,0x2
    80201f32:	61250513          	addi	a0,a0,1554 # 80204540 <digits+0x410>
    80201f36:	fffff097          	auipc	ra,0xfffff
    80201f3a:	844080e7          	jalr	-1980(ra) # 8020077a <printf>
    80201f3e:	fffff097          	auipc	ra,0xfffff
    80201f42:	232080e7          	jalr	562(ra) # 80201170 <shutdown>
    80201f46:	b7c9                	j	80201f08 <walk+0x22>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80201f48:	060a8663          	beqz	s5,80201fb4 <walk+0xce>
    80201f4c:	ffffe097          	auipc	ra,0xffffe
    80201f50:	1ee080e7          	jalr	494(ra) # 8020013a <kalloc>
    80201f54:	84aa                	mv	s1,a0
    80201f56:	c529                	beqz	a0,80201fa0 <walk+0xba>
				return 0;
			memset(pagetable, 0, PGSIZE);
    80201f58:	6605                	lui	a2,0x1
    80201f5a:	4581                	li	a1,0
    80201f5c:	fffff097          	auipc	ra,0xfffff
    80201f60:	242080e7          	jalr	578(ra) # 8020119e <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    80201f64:	00c4d793          	srli	a5,s1,0xc
    80201f68:	07aa                	slli	a5,a5,0xa
    80201f6a:	0017e793          	ori	a5,a5,1
    80201f6e:	00f93023          	sd	a5,0(s2)
	for (int level = 2; level > 0; level--) {
    80201f72:	3a5d                	addiw	s4,s4,-9
    80201f74:	036a0063          	beq	s4,s6,80201f94 <walk+0xae>
		pte_t *pte = &pagetable[PX(level, va)];
    80201f78:	0149d933          	srl	s2,s3,s4
    80201f7c:	1ff97913          	andi	s2,s2,511
    80201f80:	090e                	slli	s2,s2,0x3
    80201f82:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    80201f84:	00093483          	ld	s1,0(s2)
    80201f88:	0014f793          	andi	a5,s1,1
    80201f8c:	dfd5                	beqz	a5,80201f48 <walk+0x62>
			pagetable = (pagetable_t)PTE2PA(*pte);
    80201f8e:	80a9                	srli	s1,s1,0xa
    80201f90:	04b2                	slli	s1,s1,0xc
    80201f92:	b7c5                	j	80201f72 <walk+0x8c>
		}
	}
	return &pagetable[PX(0, va)];
    80201f94:	00c9d513          	srli	a0,s3,0xc
    80201f98:	1ff57513          	andi	a0,a0,511
    80201f9c:	050e                	slli	a0,a0,0x3
    80201f9e:	9526                	add	a0,a0,s1
}
    80201fa0:	70e2                	ld	ra,56(sp)
    80201fa2:	7442                	ld	s0,48(sp)
    80201fa4:	74a2                	ld	s1,40(sp)
    80201fa6:	7902                	ld	s2,32(sp)
    80201fa8:	69e2                	ld	s3,24(sp)
    80201faa:	6a42                	ld	s4,16(sp)
    80201fac:	6aa2                	ld	s5,8(sp)
    80201fae:	6b02                	ld	s6,0(sp)
    80201fb0:	6121                	addi	sp,sp,64
    80201fb2:	8082                	ret
				return 0;
    80201fb4:	4501                	li	a0,0
    80201fb6:	b7ed                	j	80201fa0 <walk+0xba>

0000000080201fb8 <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    80201fb8:	57fd                	li	a5,-1
    80201fba:	83e9                	srli	a5,a5,0x1a
    80201fbc:	00b7f463          	bgeu	a5,a1,80201fc4 <walkaddr+0xc>
		return 0;
    80201fc0:	4501                	li	a0,0
		return 0;
	if ((*pte & PTE_U) == 0)
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}
    80201fc2:	8082                	ret
{
    80201fc4:	1141                	addi	sp,sp,-16
    80201fc6:	e406                	sd	ra,8(sp)
    80201fc8:	e022                	sd	s0,0(sp)
    80201fca:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    80201fcc:	4601                	li	a2,0
    80201fce:	00000097          	auipc	ra,0x0
    80201fd2:	f18080e7          	jalr	-232(ra) # 80201ee6 <walk>
	if (pte == 0)
    80201fd6:	c105                	beqz	a0,80201ff6 <walkaddr+0x3e>
	if ((*pte & PTE_V) == 0)
    80201fd8:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    80201fda:	0117f693          	andi	a3,a5,17
    80201fde:	4745                	li	a4,17
		return 0;
    80201fe0:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    80201fe2:	00e68663          	beq	a3,a4,80201fee <walkaddr+0x36>
}
    80201fe6:	60a2                	ld	ra,8(sp)
    80201fe8:	6402                	ld	s0,0(sp)
    80201fea:	0141                	addi	sp,sp,16
    80201fec:	8082                	ret
	pa = PTE2PA(*pte);
    80201fee:	00a7d513          	srli	a0,a5,0xa
    80201ff2:	0532                	slli	a0,a0,0xc
	return pa;
    80201ff4:	bfcd                	j	80201fe6 <walkaddr+0x2e>
		return 0;
    80201ff6:	4501                	li	a0,0
    80201ff8:	b7fd                	j	80201fe6 <walkaddr+0x2e>

0000000080201ffa <useraddr>:

// Look up a virtual address, return the physical address,
uint64 useraddr(pagetable_t pagetable, uint64 va)
{
    80201ffa:	1101                	addi	sp,sp,-32
    80201ffc:	ec06                	sd	ra,24(sp)
    80201ffe:	e822                	sd	s0,16(sp)
    80202000:	e426                	sd	s1,8(sp)
    80202002:	1000                	addi	s0,sp,32
    80202004:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    80202006:	00000097          	auipc	ra,0x0
    8020200a:	fb2080e7          	jalr	-78(ra) # 80201fb8 <walkaddr>
	if (page == 0)
    8020200e:	c509                	beqz	a0,80202018 <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    80202010:	03449593          	slli	a1,s1,0x34
    80202014:	91d1                	srli	a1,a1,0x34
    80202016:	8d4d                	or	a0,a0,a1
}
    80202018:	60e2                	ld	ra,24(sp)
    8020201a:	6442                	ld	s0,16(sp)
    8020201c:	64a2                	ld	s1,8(sp)
    8020201e:	6105                	addi	sp,sp,32
    80202020:	8082                	ret

0000000080202022 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80202022:	715d                	addi	sp,sp,-80
    80202024:	e486                	sd	ra,72(sp)
    80202026:	e0a2                	sd	s0,64(sp)
    80202028:	fc26                	sd	s1,56(sp)
    8020202a:	f84a                	sd	s2,48(sp)
    8020202c:	f44e                	sd	s3,40(sp)
    8020202e:	f052                	sd	s4,32(sp)
    80202030:	ec56                	sd	s5,24(sp)
    80202032:	e85a                	sd	s6,16(sp)
    80202034:	e45e                	sd	s7,8(sp)
    80202036:	0880                	addi	s0,sp,80
    80202038:	8aaa                	mv	s5,a0
    8020203a:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    8020203c:	777d                	lui	a4,0xfffff
    8020203e:	00e5f7b3          	and	a5,a1,a4
	last = PGROUNDDOWN(va + size - 1);
    80202042:	167d                	addi	a2,a2,-1
    80202044:	00b609b3          	add	s3,a2,a1
    80202048:	00e9f9b3          	and	s3,s3,a4
	a = PGROUNDDOWN(va);
    8020204c:	893e                	mv	s2,a5
    8020204e:	40f68a33          	sub	s4,a3,a5
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    80202052:	6b85                	lui	s7,0x1
    80202054:	a0ad                	j	802020be <mappages+0x9c>
			errorf("pte invalid, va = %p", a);
    80202056:	fffff097          	auipc	ra,0xfffff
    8020205a:	8fa080e7          	jalr	-1798(ra) # 80200950 <threadid>
    8020205e:	86aa                	mv	a3,a0
    80202060:	874a                	mv	a4,s2
    80202062:	00002617          	auipc	a2,0x2
    80202066:	20660613          	addi	a2,a2,518 # 80204268 <digits+0x138>
    8020206a:	45fd                	li	a1,31
    8020206c:	00002517          	auipc	a0,0x2
    80202070:	4f450513          	addi	a0,a0,1268 # 80204560 <digits+0x430>
    80202074:	ffffe097          	auipc	ra,0xffffe
    80202078:	706080e7          	jalr	1798(ra) # 8020077a <printf>
			return -1;
    8020207c:	557d                	li	a0,-1
		pa += PGSIZE;
	}
	return 0;
}
    8020207e:	60a6                	ld	ra,72(sp)
    80202080:	6406                	ld	s0,64(sp)
    80202082:	74e2                	ld	s1,56(sp)
    80202084:	7942                	ld	s2,48(sp)
    80202086:	79a2                	ld	s3,40(sp)
    80202088:	7a02                	ld	s4,32(sp)
    8020208a:	6ae2                	ld	s5,24(sp)
    8020208c:	6b42                	ld	s6,16(sp)
    8020208e:	6ba2                	ld	s7,8(sp)
    80202090:	6161                	addi	sp,sp,80
    80202092:	8082                	ret
			errorf("remap");
    80202094:	fffff097          	auipc	ra,0xfffff
    80202098:	8bc080e7          	jalr	-1860(ra) # 80200950 <threadid>
    8020209c:	86aa                	mv	a3,a0
    8020209e:	00002617          	auipc	a2,0x2
    802020a2:	1ca60613          	addi	a2,a2,458 # 80204268 <digits+0x138>
    802020a6:	45fd                	li	a1,31
    802020a8:	00002517          	auipc	a0,0x2
    802020ac:	4e050513          	addi	a0,a0,1248 # 80204588 <digits+0x458>
    802020b0:	ffffe097          	auipc	ra,0xffffe
    802020b4:	6ca080e7          	jalr	1738(ra) # 8020077a <printf>
			return -1;
    802020b8:	557d                	li	a0,-1
    802020ba:	b7d1                	j	8020207e <mappages+0x5c>
		a += PGSIZE;
    802020bc:	995e                	add	s2,s2,s7
	for (;;) {
    802020be:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0) {
    802020c2:	4605                	li	a2,1
    802020c4:	85ca                	mv	a1,s2
    802020c6:	8556                	mv	a0,s5
    802020c8:	00000097          	auipc	ra,0x0
    802020cc:	e1e080e7          	jalr	-482(ra) # 80201ee6 <walk>
    802020d0:	d159                	beqz	a0,80202056 <mappages+0x34>
		if (*pte & PTE_V) {
    802020d2:	611c                	ld	a5,0(a0)
    802020d4:	8b85                	andi	a5,a5,1
    802020d6:	ffdd                	bnez	a5,80202094 <mappages+0x72>
		*pte = PA2PTE(pa) | perm | PTE_V;
    802020d8:	80b1                	srli	s1,s1,0xc
    802020da:	04aa                	slli	s1,s1,0xa
    802020dc:	0164e4b3          	or	s1,s1,s6
    802020e0:	0014e493          	ori	s1,s1,1
    802020e4:	e104                	sd	s1,0(a0)
		if (a == last)
    802020e6:	fd391be3          	bne	s2,s3,802020bc <mappages+0x9a>
	return 0;
    802020ea:	4501                	li	a0,0
    802020ec:	bf49                	j	8020207e <mappages+0x5c>

00000000802020ee <kvmmap>:
{
    802020ee:	1141                	addi	sp,sp,-16
    802020f0:	e406                	sd	ra,8(sp)
    802020f2:	e022                	sd	s0,0(sp)
    802020f4:	0800                	addi	s0,sp,16
    802020f6:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    802020f8:	86b2                	mv	a3,a2
    802020fa:	863e                	mv	a2,a5
    802020fc:	00000097          	auipc	ra,0x0
    80202100:	f26080e7          	jalr	-218(ra) # 80202022 <mappages>
    80202104:	e509                	bnez	a0,8020210e <kvmmap+0x20>
}
    80202106:	60a2                	ld	ra,8(sp)
    80202108:	6402                	ld	s0,0(sp)
    8020210a:	0141                	addi	sp,sp,16
    8020210c:	8082                	ret
		panic("kvmmap");
    8020210e:	fffff097          	auipc	ra,0xfffff
    80202112:	842080e7          	jalr	-1982(ra) # 80200950 <threadid>
    80202116:	86aa                	mv	a3,a0
    80202118:	06900793          	li	a5,105
    8020211c:	00002717          	auipc	a4,0x2
    80202120:	41c70713          	addi	a4,a4,1052 # 80204538 <digits+0x408>
    80202124:	00002617          	auipc	a2,0x2
    80202128:	eec60613          	addi	a2,a2,-276 # 80204010 <e_text+0x10>
    8020212c:	45fd                	li	a1,31
    8020212e:	00002517          	auipc	a0,0x2
    80202132:	47250513          	addi	a0,a0,1138 # 802045a0 <digits+0x470>
    80202136:	ffffe097          	auipc	ra,0xffffe
    8020213a:	644080e7          	jalr	1604(ra) # 8020077a <printf>
    8020213e:	fffff097          	auipc	ra,0xfffff
    80202142:	032080e7          	jalr	50(ra) # 80201170 <shutdown>
}
    80202146:	b7c1                	j	80202106 <kvmmap+0x18>

0000000080202148 <kvmmake>:
{
    80202148:	1101                	addi	sp,sp,-32
    8020214a:	ec06                	sd	ra,24(sp)
    8020214c:	e822                	sd	s0,16(sp)
    8020214e:	e426                	sd	s1,8(sp)
    80202150:	e04a                	sd	s2,0(sp)
    80202152:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    80202154:	ffffe097          	auipc	ra,0xffffe
    80202158:	fe6080e7          	jalr	-26(ra) # 8020013a <kalloc>
    8020215c:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    8020215e:	6605                	lui	a2,0x1
    80202160:	4581                	li	a1,0
    80202162:	fffff097          	auipc	ra,0xfffff
    80202166:	03c080e7          	jalr	60(ra) # 8020119e <memset>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    8020216a:	00002917          	auipc	s2,0x2
    8020216e:	e9690913          	addi	s2,s2,-362 # 80204000 <e_text>
    80202172:	4729                	li	a4,10
    80202174:	bff00693          	li	a3,-1025
    80202178:	06d6                	slli	a3,a3,0x15
    8020217a:	96ca                	add	a3,a3,s2
    8020217c:	40100613          	li	a2,1025
    80202180:	0656                	slli	a2,a2,0x15
    80202182:	85b2                	mv	a1,a2
    80202184:	8526                	mv	a0,s1
    80202186:	00000097          	auipc	ra,0x0
    8020218a:	f68080e7          	jalr	-152(ra) # 802020ee <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    8020218e:	4719                	li	a4,6
    80202190:	46c5                	li	a3,17
    80202192:	06ee                	slli	a3,a3,0x1b
    80202194:	412686b3          	sub	a3,a3,s2
    80202198:	864a                	mv	a2,s2
    8020219a:	85ca                	mv	a1,s2
    8020219c:	8526                	mv	a0,s1
    8020219e:	00000097          	auipc	ra,0x0
    802021a2:	f50080e7          	jalr	-176(ra) # 802020ee <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    802021a6:	4729                	li	a4,10
    802021a8:	6685                	lui	a3,0x1
    802021aa:	00001617          	auipc	a2,0x1
    802021ae:	e5660613          	addi	a2,a2,-426 # 80203000 <trampoline>
    802021b2:	040005b7          	lui	a1,0x4000
    802021b6:	15fd                	addi	a1,a1,-1
    802021b8:	05b2                	slli	a1,a1,0xc
    802021ba:	8526                	mv	a0,s1
    802021bc:	00000097          	auipc	ra,0x0
    802021c0:	f32080e7          	jalr	-206(ra) # 802020ee <kvmmap>
}
    802021c4:	8526                	mv	a0,s1
    802021c6:	60e2                	ld	ra,24(sp)
    802021c8:	6442                	ld	s0,16(sp)
    802021ca:	64a2                	ld	s1,8(sp)
    802021cc:	6902                	ld	s2,0(sp)
    802021ce:	6105                	addi	sp,sp,32
    802021d0:	8082                	ret

00000000802021d2 <kvm_init>:
{
    802021d2:	1141                	addi	sp,sp,-16
    802021d4:	e406                	sd	ra,8(sp)
    802021d6:	e022                	sd	s0,0(sp)
    802021d8:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    802021da:	00000097          	auipc	ra,0x0
    802021de:	f6e080e7          	jalr	-146(ra) # 80202148 <kvmmake>
    802021e2:	0058b797          	auipc	a5,0x58b
    802021e6:	e2a7bf23          	sd	a0,-450(a5) # 8078d020 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    802021ea:	8131                	srli	a0,a0,0xc
    802021ec:	57fd                	li	a5,-1
    802021ee:	17fe                	slli	a5,a5,0x3f
    802021f0:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    802021f2:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    802021f6:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    802021fa:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    802021fe:	4501                	li	a0,0
    80202200:	fffff097          	auipc	ra,0xfffff
    80202204:	14c080e7          	jalr	332(ra) # 8020134c <dummy>
}
    80202208:	60a2                	ld	ra,8(sp)
    8020220a:	6402                	ld	s0,0(sp)
    8020220c:	0141                	addi	sp,sp,16
    8020220e:	8082                	ret

0000000080202210 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80202210:	711d                	addi	sp,sp,-96
    80202212:	ec86                	sd	ra,88(sp)
    80202214:	e8a2                	sd	s0,80(sp)
    80202216:	e4a6                	sd	s1,72(sp)
    80202218:	e0ca                	sd	s2,64(sp)
    8020221a:	fc4e                	sd	s3,56(sp)
    8020221c:	f852                	sd	s4,48(sp)
    8020221e:	f456                	sd	s5,40(sp)
    80202220:	f05a                	sd	s6,32(sp)
    80202222:	ec5e                	sd	s7,24(sp)
    80202224:	e862                	sd	s8,16(sp)
    80202226:	e466                	sd	s9,8(sp)
    80202228:	e06a                	sd	s10,0(sp)
    8020222a:	1080                	addi	s0,sp,96
    8020222c:	8a2a                	mv	s4,a0
    8020222e:	892e                	mv	s2,a1
    80202230:	89b2                	mv	s3,a2
    80202232:	8b36                	mv	s6,a3
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    80202234:	03459793          	slli	a5,a1,0x34
    80202238:	e785                	bnez	a5,80202260 <uvmunmap+0x50>
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020223a:	09b2                	slli	s3,s3,0xc
    8020223c:	99ca                	add	s3,s3,s2
    8020223e:	0d397263          	bgeu	s2,s3,80202302 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    80202242:	4b85                	li	s7,1
				panic("uvmunmap: not a leaf");
    80202244:	00002d17          	auipc	s10,0x2
    80202248:	2f4d0d13          	addi	s10,s10,756 # 80204538 <digits+0x408>
    8020224c:	00002c97          	auipc	s9,0x2
    80202250:	dc4c8c93          	addi	s9,s9,-572 # 80204010 <e_text+0x10>
    80202254:	00002c17          	auipc	s8,0x2
    80202258:	39cc0c13          	addi	s8,s8,924 # 802045f0 <digits+0x4c0>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020225c:	6a85                	lui	s5,0x1
    8020225e:	a0bd                	j	802022cc <uvmunmap+0xbc>
		panic("uvmunmap: not aligned");
    80202260:	ffffe097          	auipc	ra,0xffffe
    80202264:	6f0080e7          	jalr	1776(ra) # 80200950 <threadid>
    80202268:	86aa                	mv	a3,a0
    8020226a:	09200793          	li	a5,146
    8020226e:	00002717          	auipc	a4,0x2
    80202272:	2ca70713          	addi	a4,a4,714 # 80204538 <digits+0x408>
    80202276:	00002617          	auipc	a2,0x2
    8020227a:	d9a60613          	addi	a2,a2,-614 # 80204010 <e_text+0x10>
    8020227e:	45fd                	li	a1,31
    80202280:	00002517          	auipc	a0,0x2
    80202284:	34050513          	addi	a0,a0,832 # 802045c0 <digits+0x490>
    80202288:	ffffe097          	auipc	ra,0xffffe
    8020228c:	4f2080e7          	jalr	1266(ra) # 8020077a <printf>
    80202290:	fffff097          	auipc	ra,0xfffff
    80202294:	ee0080e7          	jalr	-288(ra) # 80201170 <shutdown>
    80202298:	b74d                	j	8020223a <uvmunmap+0x2a>
				panic("uvmunmap: not a leaf");
    8020229a:	ffffe097          	auipc	ra,0xffffe
    8020229e:	6b6080e7          	jalr	1718(ra) # 80200950 <threadid>
    802022a2:	86aa                	mv	a3,a0
    802022a4:	09900793          	li	a5,153
    802022a8:	876a                	mv	a4,s10
    802022aa:	8666                	mv	a2,s9
    802022ac:	45fd                	li	a1,31
    802022ae:	8562                	mv	a0,s8
    802022b0:	ffffe097          	auipc	ra,0xffffe
    802022b4:	4ca080e7          	jalr	1226(ra) # 8020077a <printf>
    802022b8:	fffff097          	auipc	ra,0xfffff
    802022bc:	eb8080e7          	jalr	-328(ra) # 80201170 <shutdown>
    802022c0:	a03d                	j	802022ee <uvmunmap+0xde>
			if (do_free) {
				uint64 pa = PTE2PA(*pte);
				kfree((void *)pa);
			}
		}
		*pte = 0;
    802022c2:	0004b023          	sd	zero,0(s1) # 4000000 <_entry-0x7c200000>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    802022c6:	9956                	add	s2,s2,s5
    802022c8:	03397d63          	bgeu	s2,s3,80202302 <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
    802022cc:	4601                	li	a2,0
    802022ce:	85ca                	mv	a1,s2
    802022d0:	8552                	mv	a0,s4
    802022d2:	00000097          	auipc	ra,0x0
    802022d6:	c14080e7          	jalr	-1004(ra) # 80201ee6 <walk>
    802022da:	84aa                	mv	s1,a0
    802022dc:	d56d                	beqz	a0,802022c6 <uvmunmap+0xb6>
		if ((*pte & PTE_V) != 0) {
    802022de:	611c                	ld	a5,0(a0)
    802022e0:	0017f713          	andi	a4,a5,1
    802022e4:	df79                	beqz	a4,802022c2 <uvmunmap+0xb2>
			if (PTE_FLAGS(*pte) == PTE_V)
    802022e6:	3ff7f793          	andi	a5,a5,1023
    802022ea:	fb7788e3          	beq	a5,s7,8020229a <uvmunmap+0x8a>
			if (do_free) {
    802022ee:	fc0b0ae3          	beqz	s6,802022c2 <uvmunmap+0xb2>
				uint64 pa = PTE2PA(*pte);
    802022f2:	6088                	ld	a0,0(s1)
    802022f4:	8129                	srli	a0,a0,0xa
				kfree((void *)pa);
    802022f6:	0532                	slli	a0,a0,0xc
    802022f8:	ffffe097          	auipc	ra,0xffffe
    802022fc:	d50080e7          	jalr	-688(ra) # 80200048 <kfree>
    80202300:	b7c9                	j	802022c2 <uvmunmap+0xb2>
	}
}
    80202302:	60e6                	ld	ra,88(sp)
    80202304:	6446                	ld	s0,80(sp)
    80202306:	64a6                	ld	s1,72(sp)
    80202308:	6906                	ld	s2,64(sp)
    8020230a:	79e2                	ld	s3,56(sp)
    8020230c:	7a42                	ld	s4,48(sp)
    8020230e:	7aa2                	ld	s5,40(sp)
    80202310:	7b02                	ld	s6,32(sp)
    80202312:	6be2                	ld	s7,24(sp)
    80202314:	6c42                	ld	s8,16(sp)
    80202316:	6ca2                	ld	s9,8(sp)
    80202318:	6d02                	ld	s10,0(sp)
    8020231a:	6125                	addi	sp,sp,96
    8020231c:	8082                	ret

000000008020231e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate(uint64 trapframe)
{
    8020231e:	1101                	addi	sp,sp,-32
    80202320:	ec06                	sd	ra,24(sp)
    80202322:	e822                	sd	s0,16(sp)
    80202324:	e426                	sd	s1,8(sp)
    80202326:	e04a                	sd	s2,0(sp)
    80202328:	1000                	addi	s0,sp,32
    8020232a:	892a                	mv	s2,a0
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    8020232c:	ffffe097          	auipc	ra,0xffffe
    80202330:	e0e080e7          	jalr	-498(ra) # 8020013a <kalloc>
    80202334:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    80202336:	cd29                	beqz	a0,80202390 <uvmcreate+0x72>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    80202338:	6605                	lui	a2,0x1
    8020233a:	4581                	li	a1,0
    8020233c:	fffff097          	auipc	ra,0xfffff
    80202340:	e62080e7          	jalr	-414(ra) # 8020119e <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    80202344:	4729                	li	a4,10
    80202346:	00001697          	auipc	a3,0x1
    8020234a:	cba68693          	addi	a3,a3,-838 # 80203000 <trampoline>
    8020234e:	6605                	lui	a2,0x1
    80202350:	040005b7          	lui	a1,0x4000
    80202354:	15fd                	addi	a1,a1,-1
    80202356:	05b2                	slli	a1,a1,0xc
    80202358:	8526                	mv	a0,s1
    8020235a:	00000097          	auipc	ra,0x0
    8020235e:	cc8080e7          	jalr	-824(ra) # 80202022 <mappages>
    80202362:	04054a63          	bltz	a0,802023b6 <uvmcreate+0x98>
		     PTE_R | PTE_X) < 0) {
		panic("mappages fail");
	}
	if (mappages(pagetable, TRAPFRAME, PGSIZE, trapframe, PTE_R | PTE_W) <
    80202366:	4719                	li	a4,6
    80202368:	86ca                	mv	a3,s2
    8020236a:	6605                	lui	a2,0x1
    8020236c:	020005b7          	lui	a1,0x2000
    80202370:	15fd                	addi	a1,a1,-1
    80202372:	05b6                	slli	a1,a1,0xd
    80202374:	8526                	mv	a0,s1
    80202376:	00000097          	auipc	ra,0x0
    8020237a:	cac080e7          	jalr	-852(ra) # 80202022 <mappages>
    8020237e:	06054963          	bltz	a0,802023f0 <uvmcreate+0xd2>
	    0) {
		panic("mappages fail");
	}
	return pagetable;
}
    80202382:	8526                	mv	a0,s1
    80202384:	60e2                	ld	ra,24(sp)
    80202386:	6442                	ld	s0,16(sp)
    80202388:	64a2                	ld	s1,8(sp)
    8020238a:	6902                	ld	s2,0(sp)
    8020238c:	6105                	addi	sp,sp,32
    8020238e:	8082                	ret
		errorf("uvmcreate: kalloc error");
    80202390:	ffffe097          	auipc	ra,0xffffe
    80202394:	5c0080e7          	jalr	1472(ra) # 80200950 <threadid>
    80202398:	86aa                	mv	a3,a0
    8020239a:	00002617          	auipc	a2,0x2
    8020239e:	ece60613          	addi	a2,a2,-306 # 80204268 <digits+0x138>
    802023a2:	45fd                	li	a1,31
    802023a4:	00002517          	auipc	a0,0x2
    802023a8:	27c50513          	addi	a0,a0,636 # 80204620 <digits+0x4f0>
    802023ac:	ffffe097          	auipc	ra,0xffffe
    802023b0:	3ce080e7          	jalr	974(ra) # 8020077a <printf>
		return 0;
    802023b4:	b7f9                	j	80202382 <uvmcreate+0x64>
		panic("mappages fail");
    802023b6:	ffffe097          	auipc	ra,0xffffe
    802023ba:	59a080e7          	jalr	1434(ra) # 80200950 <threadid>
    802023be:	86aa                	mv	a3,a0
    802023c0:	0b000793          	li	a5,176
    802023c4:	00002717          	auipc	a4,0x2
    802023c8:	17470713          	addi	a4,a4,372 # 80204538 <digits+0x408>
    802023cc:	00002617          	auipc	a2,0x2
    802023d0:	c4460613          	addi	a2,a2,-956 # 80204010 <e_text+0x10>
    802023d4:	45fd                	li	a1,31
    802023d6:	00002517          	auipc	a0,0x2
    802023da:	27a50513          	addi	a0,a0,634 # 80204650 <digits+0x520>
    802023de:	ffffe097          	auipc	ra,0xffffe
    802023e2:	39c080e7          	jalr	924(ra) # 8020077a <printf>
    802023e6:	fffff097          	auipc	ra,0xfffff
    802023ea:	d8a080e7          	jalr	-630(ra) # 80201170 <shutdown>
    802023ee:	bfa5                	j	80202366 <uvmcreate+0x48>
		panic("mappages fail");
    802023f0:	ffffe097          	auipc	ra,0xffffe
    802023f4:	560080e7          	jalr	1376(ra) # 80200950 <threadid>
    802023f8:	86aa                	mv	a3,a0
    802023fa:	0b400793          	li	a5,180
    802023fe:	00002717          	auipc	a4,0x2
    80202402:	13a70713          	addi	a4,a4,314 # 80204538 <digits+0x408>
    80202406:	00002617          	auipc	a2,0x2
    8020240a:	c0a60613          	addi	a2,a2,-1014 # 80204010 <e_text+0x10>
    8020240e:	45fd                	li	a1,31
    80202410:	00002517          	auipc	a0,0x2
    80202414:	24050513          	addi	a0,a0,576 # 80204650 <digits+0x520>
    80202418:	ffffe097          	auipc	ra,0xffffe
    8020241c:	362080e7          	jalr	866(ra) # 8020077a <printf>
    80202420:	fffff097          	auipc	ra,0xfffff
    80202424:	d50080e7          	jalr	-688(ra) # 80201170 <shutdown>
    80202428:	bfa9                	j	80202382 <uvmcreate+0x64>

000000008020242a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    8020242a:	7179                	addi	sp,sp,-48
    8020242c:	f406                	sd	ra,40(sp)
    8020242e:	f022                	sd	s0,32(sp)
    80202430:	ec26                	sd	s1,24(sp)
    80202432:	e84a                	sd	s2,16(sp)
    80202434:	e44e                	sd	s3,8(sp)
    80202436:	e052                	sd	s4,0(sp)
    80202438:	1800                	addi	s0,sp,48
    8020243a:	8a2a                	mv	s4,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    8020243c:	84aa                	mv	s1,a0
    8020243e:	6905                	lui	s2,0x1
    80202440:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80202442:	4985                	li	s3,1
    80202444:	a021                	j	8020244c <freewalk+0x22>
	for (int i = 0; i < 512; i++) {
    80202446:	04a1                	addi	s1,s1,8
    80202448:	03248063          	beq	s1,s2,80202468 <freewalk+0x3e>
		pte_t pte = pagetable[i];
    8020244c:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8020244e:	00f57793          	andi	a5,a0,15
    80202452:	ff379ae3          	bne	a5,s3,80202446 <freewalk+0x1c>
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
    80202456:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    80202458:	0532                	slli	a0,a0,0xc
    8020245a:	00000097          	auipc	ra,0x0
    8020245e:	fd0080e7          	jalr	-48(ra) # 8020242a <freewalk>
			pagetable[i] = 0;
    80202462:	0004b023          	sd	zero,0(s1)
    80202466:	b7c5                	j	80202446 <freewalk+0x1c>
		} else if (pte & PTE_V) {
			//panic("freewalk: leaf");
		}
	}
	kfree((void *)pagetable);
    80202468:	8552                	mv	a0,s4
    8020246a:	ffffe097          	auipc	ra,0xffffe
    8020246e:	bde080e7          	jalr	-1058(ra) # 80200048 <kfree>
}
    80202472:	70a2                	ld	ra,40(sp)
    80202474:	7402                	ld	s0,32(sp)
    80202476:	64e2                	ld	s1,24(sp)
    80202478:	6942                	ld	s2,16(sp)
    8020247a:	69a2                	ld	s3,8(sp)
    8020247c:	6a02                	ld	s4,0(sp)
    8020247e:	6145                	addi	sp,sp,48
    80202480:	8082                	ret

0000000080202482 <uvmfree>:
 * @brief Free user memory pages, then free page-table pages.
 *
 * @param max_page The max vaddr of user-space.
 */
void uvmfree(pagetable_t pagetable, uint64 max_page)
{
    80202482:	1101                	addi	sp,sp,-32
    80202484:	ec06                	sd	ra,24(sp)
    80202486:	e822                	sd	s0,16(sp)
    80202488:	e426                	sd	s1,8(sp)
    8020248a:	1000                	addi	s0,sp,32
    8020248c:	84aa                	mv	s1,a0
	if (max_page > 0)
    8020248e:	e999                	bnez	a1,802024a4 <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80202490:	8526                	mv	a0,s1
    80202492:	00000097          	auipc	ra,0x0
    80202496:	f98080e7          	jalr	-104(ra) # 8020242a <freewalk>
}
    8020249a:	60e2                	ld	ra,24(sp)
    8020249c:	6442                	ld	s0,16(sp)
    8020249e:	64a2                	ld	s1,8(sp)
    802024a0:	6105                	addi	sp,sp,32
    802024a2:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    802024a4:	4685                	li	a3,1
    802024a6:	862e                	mv	a2,a1
    802024a8:	4581                	li	a1,0
    802024aa:	00000097          	auipc	ra,0x0
    802024ae:	d66080e7          	jalr	-666(ra) # 80202210 <uvmunmap>
    802024b2:	bff9                	j	80202490 <uvmfree+0xe>

00000000802024b4 <uvmcopy>:

// Used in fork.
// Copy the pagetable page and all the user pages.
// Return 0 on success, -1 on error.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 max_page)
{
    802024b4:	715d                	addi	sp,sp,-80
    802024b6:	e486                	sd	ra,72(sp)
    802024b8:	e0a2                	sd	s0,64(sp)
    802024ba:	fc26                	sd	s1,56(sp)
    802024bc:	f84a                	sd	s2,48(sp)
    802024be:	f44e                	sd	s3,40(sp)
    802024c0:	f052                	sd	s4,32(sp)
    802024c2:	ec56                	sd	s5,24(sp)
    802024c4:	e85a                	sd	s6,16(sp)
    802024c6:	e45e                	sd	s7,8(sp)
    802024c8:	0880                	addi	s0,sp,80
	pte_t *pte;
	uint64 pa, i;
	uint flags;
	char *mem;

	for (i = 0; i < max_page * PAGE_SIZE; i += PGSIZE) {
    802024ca:	00c61a13          	slli	s4,a2,0xc
    802024ce:	080a0e63          	beqz	s4,8020256a <uvmcopy+0xb6>
    802024d2:	8aaa                	mv	s5,a0
    802024d4:	8b2e                	mv	s6,a1
    802024d6:	4481                	li	s1,0
    802024d8:	a029                	j	802024e2 <uvmcopy+0x2e>
    802024da:	6785                	lui	a5,0x1
    802024dc:	94be                	add	s1,s1,a5
    802024de:	0744fa63          	bgeu	s1,s4,80202552 <uvmcopy+0x9e>
		if ((pte = walk(old, i, 0)) == 0)
    802024e2:	4601                	li	a2,0
    802024e4:	85a6                	mv	a1,s1
    802024e6:	8556                	mv	a0,s5
    802024e8:	00000097          	auipc	ra,0x0
    802024ec:	9fe080e7          	jalr	-1538(ra) # 80201ee6 <walk>
    802024f0:	d56d                	beqz	a0,802024da <uvmcopy+0x26>
			continue;
		if ((*pte & PTE_V) == 0)
    802024f2:	6118                	ld	a4,0(a0)
    802024f4:	00177793          	andi	a5,a4,1
    802024f8:	d3ed                	beqz	a5,802024da <uvmcopy+0x26>
			continue;
		pa = PTE2PA(*pte);
    802024fa:	00a75593          	srli	a1,a4,0xa
    802024fe:	00c59b93          	slli	s7,a1,0xc
		flags = PTE_FLAGS(*pte);
    80202502:	3ff77913          	andi	s2,a4,1023
		if ((mem = kalloc()) == 0)
    80202506:	ffffe097          	auipc	ra,0xffffe
    8020250a:	c34080e7          	jalr	-972(ra) # 8020013a <kalloc>
    8020250e:	89aa                	mv	s3,a0
    80202510:	c515                	beqz	a0,8020253c <uvmcopy+0x88>
			goto err;
		memmove(mem, (char *)pa, PGSIZE);
    80202512:	6605                	lui	a2,0x1
    80202514:	85de                	mv	a1,s7
    80202516:	fffff097          	auipc	ra,0xfffff
    8020251a:	ce4080e7          	jalr	-796(ra) # 802011fa <memmove>
		if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8020251e:	874a                	mv	a4,s2
    80202520:	86ce                	mv	a3,s3
    80202522:	6605                	lui	a2,0x1
    80202524:	85a6                	mv	a1,s1
    80202526:	855a                	mv	a0,s6
    80202528:	00000097          	auipc	ra,0x0
    8020252c:	afa080e7          	jalr	-1286(ra) # 80202022 <mappages>
    80202530:	d54d                	beqz	a0,802024da <uvmcopy+0x26>
			kfree(mem);
    80202532:	854e                	mv	a0,s3
    80202534:	ffffe097          	auipc	ra,0xffffe
    80202538:	b14080e7          	jalr	-1260(ra) # 80200048 <kfree>
		}
	}
	return 0;

err:
	uvmunmap(new, 0, i / PGSIZE, 1);
    8020253c:	4685                	li	a3,1
    8020253e:	00c4d613          	srli	a2,s1,0xc
    80202542:	4581                	li	a1,0
    80202544:	855a                	mv	a0,s6
    80202546:	00000097          	auipc	ra,0x0
    8020254a:	cca080e7          	jalr	-822(ra) # 80202210 <uvmunmap>
	return -1;
    8020254e:	557d                	li	a0,-1
    80202550:	a011                	j	80202554 <uvmcopy+0xa0>
	return 0;
    80202552:	4501                	li	a0,0
}
    80202554:	60a6                	ld	ra,72(sp)
    80202556:	6406                	ld	s0,64(sp)
    80202558:	74e2                	ld	s1,56(sp)
    8020255a:	7942                	ld	s2,48(sp)
    8020255c:	79a2                	ld	s3,40(sp)
    8020255e:	7a02                	ld	s4,32(sp)
    80202560:	6ae2                	ld	s5,24(sp)
    80202562:	6b42                	ld	s6,16(sp)
    80202564:	6ba2                	ld	s7,8(sp)
    80202566:	6161                	addi	sp,sp,80
    80202568:	8082                	ret
	return 0;
    8020256a:	4501                	li	a0,0
    8020256c:	b7e5                	j	80202554 <uvmcopy+0xa0>

000000008020256e <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    8020256e:	c6bd                	beqz	a3,802025dc <copyout+0x6e>
{
    80202570:	715d                	addi	sp,sp,-80
    80202572:	e486                	sd	ra,72(sp)
    80202574:	e0a2                	sd	s0,64(sp)
    80202576:	fc26                	sd	s1,56(sp)
    80202578:	f84a                	sd	s2,48(sp)
    8020257a:	f44e                	sd	s3,40(sp)
    8020257c:	f052                	sd	s4,32(sp)
    8020257e:	ec56                	sd	s5,24(sp)
    80202580:	e85a                	sd	s6,16(sp)
    80202582:	e45e                	sd	s7,8(sp)
    80202584:	e062                	sd	s8,0(sp)
    80202586:	0880                	addi	s0,sp,80
    80202588:	8b2a                	mv	s6,a0
    8020258a:	8c2e                	mv	s8,a1
    8020258c:	8a32                	mv	s4,a2
    8020258e:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80202590:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    80202592:	6a85                	lui	s5,0x1
    80202594:	a015                	j	802025b8 <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    80202596:	9562                	add	a0,a0,s8
    80202598:	0004861b          	sext.w	a2,s1
    8020259c:	85d2                	mv	a1,s4
    8020259e:	41250533          	sub	a0,a0,s2
    802025a2:	fffff097          	auipc	ra,0xfffff
    802025a6:	c58080e7          	jalr	-936(ra) # 802011fa <memmove>

		len -= n;
    802025aa:	409989b3          	sub	s3,s3,s1
		src += n;
    802025ae:	9a26                	add	s4,s4,s1
		dstva = va0 + PGSIZE;
    802025b0:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    802025b4:	02098263          	beqz	s3,802025d8 <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    802025b8:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    802025bc:	85ca                	mv	a1,s2
    802025be:	855a                	mv	a0,s6
    802025c0:	00000097          	auipc	ra,0x0
    802025c4:	9f8080e7          	jalr	-1544(ra) # 80201fb8 <walkaddr>
		if (pa0 == 0)
    802025c8:	cd01                	beqz	a0,802025e0 <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    802025ca:	418904b3          	sub	s1,s2,s8
    802025ce:	94d6                	add	s1,s1,s5
		if (n > len)
    802025d0:	fc99f3e3          	bgeu	s3,s1,80202596 <copyout+0x28>
    802025d4:	84ce                	mv	s1,s3
    802025d6:	b7c1                	j	80202596 <copyout+0x28>
	}
	return 0;
    802025d8:	4501                	li	a0,0
    802025da:	a021                	j	802025e2 <copyout+0x74>
    802025dc:	4501                	li	a0,0
}
    802025de:	8082                	ret
			return -1;
    802025e0:	557d                	li	a0,-1
}
    802025e2:	60a6                	ld	ra,72(sp)
    802025e4:	6406                	ld	s0,64(sp)
    802025e6:	74e2                	ld	s1,56(sp)
    802025e8:	7942                	ld	s2,48(sp)
    802025ea:	79a2                	ld	s3,40(sp)
    802025ec:	7a02                	ld	s4,32(sp)
    802025ee:	6ae2                	ld	s5,24(sp)
    802025f0:	6b42                	ld	s6,16(sp)
    802025f2:	6ba2                	ld	s7,8(sp)
    802025f4:	6c02                	ld	s8,0(sp)
    802025f6:	6161                	addi	sp,sp,80
    802025f8:	8082                	ret

00000000802025fa <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    802025fa:	caa5                	beqz	a3,8020266a <copyin+0x70>
{
    802025fc:	715d                	addi	sp,sp,-80
    802025fe:	e486                	sd	ra,72(sp)
    80202600:	e0a2                	sd	s0,64(sp)
    80202602:	fc26                	sd	s1,56(sp)
    80202604:	f84a                	sd	s2,48(sp)
    80202606:	f44e                	sd	s3,40(sp)
    80202608:	f052                	sd	s4,32(sp)
    8020260a:	ec56                	sd	s5,24(sp)
    8020260c:	e85a                	sd	s6,16(sp)
    8020260e:	e45e                	sd	s7,8(sp)
    80202610:	e062                	sd	s8,0(sp)
    80202612:	0880                	addi	s0,sp,80
    80202614:	8b2a                	mv	s6,a0
    80202616:	8a2e                	mv	s4,a1
    80202618:	8c32                	mv	s8,a2
    8020261a:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    8020261c:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    8020261e:	6a85                	lui	s5,0x1
    80202620:	a01d                	j	80202646 <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80202622:	018505b3          	add	a1,a0,s8
    80202626:	0004861b          	sext.w	a2,s1
    8020262a:	412585b3          	sub	a1,a1,s2
    8020262e:	8552                	mv	a0,s4
    80202630:	fffff097          	auipc	ra,0xfffff
    80202634:	bca080e7          	jalr	-1078(ra) # 802011fa <memmove>

		len -= n;
    80202638:	409989b3          	sub	s3,s3,s1
		dst += n;
    8020263c:	9a26                	add	s4,s4,s1
		srcva = va0 + PGSIZE;
    8020263e:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80202642:	02098263          	beqz	s3,80202666 <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    80202646:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    8020264a:	85ca                	mv	a1,s2
    8020264c:	855a                	mv	a0,s6
    8020264e:	00000097          	auipc	ra,0x0
    80202652:	96a080e7          	jalr	-1686(ra) # 80201fb8 <walkaddr>
		if (pa0 == 0)
    80202656:	cd01                	beqz	a0,8020266e <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    80202658:	418904b3          	sub	s1,s2,s8
    8020265c:	94d6                	add	s1,s1,s5
		if (n > len)
    8020265e:	fc99f2e3          	bgeu	s3,s1,80202622 <copyin+0x28>
    80202662:	84ce                	mv	s1,s3
    80202664:	bf7d                	j	80202622 <copyin+0x28>
	}
	return 0;
    80202666:	4501                	li	a0,0
    80202668:	a021                	j	80202670 <copyin+0x76>
    8020266a:	4501                	li	a0,0
}
    8020266c:	8082                	ret
			return -1;
    8020266e:	557d                	li	a0,-1
}
    80202670:	60a6                	ld	ra,72(sp)
    80202672:	6406                	ld	s0,64(sp)
    80202674:	74e2                	ld	s1,56(sp)
    80202676:	7942                	ld	s2,48(sp)
    80202678:	79a2                	ld	s3,40(sp)
    8020267a:	7a02                	ld	s4,32(sp)
    8020267c:	6ae2                	ld	s5,24(sp)
    8020267e:	6b42                	ld	s6,16(sp)
    80202680:	6ba2                	ld	s7,8(sp)
    80202682:	6c02                	ld	s8,0(sp)
    80202684:	6161                	addi	sp,sp,80
    80202686:	8082                	ret

0000000080202688 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80202688:	715d                	addi	sp,sp,-80
    8020268a:	e486                	sd	ra,72(sp)
    8020268c:	e0a2                	sd	s0,64(sp)
    8020268e:	fc26                	sd	s1,56(sp)
    80202690:	f84a                	sd	s2,48(sp)
    80202692:	f44e                	sd	s3,40(sp)
    80202694:	f052                	sd	s4,32(sp)
    80202696:	ec56                	sd	s5,24(sp)
    80202698:	e85a                	sd	s6,16(sp)
    8020269a:	e45e                	sd	s7,8(sp)
    8020269c:	e062                	sd	s8,0(sp)
    8020269e:	0880                	addi	s0,sp,80
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    802026a0:	c6c9                	beqz	a3,8020272a <copyinstr+0xa2>
    802026a2:	8aaa                	mv	s5,a0
    802026a4:	8bae                	mv	s7,a1
    802026a6:	8c32                	mv	s8,a2
    802026a8:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    802026aa:	4481                	li	s1,0
		va0 = PGROUNDDOWN(srcva);
    802026ac:	7b7d                	lui	s6,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    802026ae:	6a05                	lui	s4,0x1
    802026b0:	a025                	j	802026d8 <copyinstr+0x50>
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
				*dst = '\0';
    802026b2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x801ff000>
		}

		srcva = va0 + PGSIZE;
	}
	return len;
}
    802026b6:	8526                	mv	a0,s1
    802026b8:	60a6                	ld	ra,72(sp)
    802026ba:	6406                	ld	s0,64(sp)
    802026bc:	74e2                	ld	s1,56(sp)
    802026be:	7942                	ld	s2,48(sp)
    802026c0:	79a2                	ld	s3,40(sp)
    802026c2:	7a02                	ld	s4,32(sp)
    802026c4:	6ae2                	ld	s5,24(sp)
    802026c6:	6b42                	ld	s6,16(sp)
    802026c8:	6ba2                	ld	s7,8(sp)
    802026ca:	6c02                	ld	s8,0(sp)
    802026cc:	6161                	addi	sp,sp,80
    802026ce:	8082                	ret
		srcva = va0 + PGSIZE;
    802026d0:	01498c33          	add	s8,s3,s4
	while (got_null == 0 && max > 0) {
    802026d4:	fe0901e3          	beqz	s2,802026b6 <copyinstr+0x2e>
		va0 = PGROUNDDOWN(srcva);
    802026d8:	016c79b3          	and	s3,s8,s6
		pa0 = walkaddr(pagetable, va0);
    802026dc:	85ce                	mv	a1,s3
    802026de:	8556                	mv	a0,s5
    802026e0:	00000097          	auipc	ra,0x0
    802026e4:	8d8080e7          	jalr	-1832(ra) # 80201fb8 <walkaddr>
		if (pa0 == 0)
    802026e8:	c139                	beqz	a0,8020272e <copyinstr+0xa6>
		n = PGSIZE - (srcva - va0);
    802026ea:	41898833          	sub	a6,s3,s8
    802026ee:	9852                	add	a6,a6,s4
		if (n > max)
    802026f0:	01097363          	bgeu	s2,a6,802026f6 <copyinstr+0x6e>
    802026f4:	884a                	mv	a6,s2
		char *p = (char *)(pa0 + (srcva - va0));
    802026f6:	9562                	add	a0,a0,s8
    802026f8:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    802026fc:	fc080ae3          	beqz	a6,802026d0 <copyinstr+0x48>
    80202700:	985e                	add	a6,a6,s7
    80202702:	87de                	mv	a5,s7
			if (*p == '\0') {
    80202704:	41750633          	sub	a2,a0,s7
    80202708:	197d                	addi	s2,s2,-1
    8020270a:	9bca                	add	s7,s7,s2
    8020270c:	00f60733          	add	a4,a2,a5
    80202710:	00074703          	lbu	a4,0(a4)
    80202714:	df59                	beqz	a4,802026b2 <copyinstr+0x2a>
				*dst = *p;
    80202716:	00e78023          	sb	a4,0(a5)
			--max;
    8020271a:	40fb8933          	sub	s2,s7,a5
			dst++;
    8020271e:	0785                	addi	a5,a5,1
			len++;
    80202720:	2485                	addiw	s1,s1,1
		while (n > 0) {
    80202722:	ff0795e3          	bne	a5,a6,8020270c <copyinstr+0x84>
			dst++;
    80202726:	8bc2                	mv	s7,a6
    80202728:	b765                	j	802026d0 <copyinstr+0x48>
	int got_null = 0, len = 0;
    8020272a:	4481                	li	s1,0
    8020272c:	b769                	j	802026b6 <copyinstr+0x2e>
			return -1;
    8020272e:	54fd                	li	s1,-1
    80202730:	b759                	j	802026b6 <copyinstr+0x2e>

0000000080202732 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    80202732:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80202736:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8020273a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8020273c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8020273e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80202742:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80202746:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8020274a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8020274e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80202752:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80202756:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8020275a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8020275e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80202762:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80202766:	0005b083          	ld	ra,0(a1) # 2000000 <_entry-0x7e200000>
        ld sp, 8(a1)
    8020276a:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8020276e:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80202770:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80202772:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80202776:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8020277a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8020277e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80202782:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80202786:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8020278a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8020278e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80202792:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80202796:	0685bd83          	ld	s11,104(a1)

    8020279a:	8082                	ret
	...

0000000080203000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80203000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80203004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80203008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020300c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80203010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80203014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80203018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020301c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80203020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80203022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80203024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80203026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80203028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020302a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020302c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020302e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80203032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80203036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020303a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020303e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80203042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80203046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020304a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020304e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80203052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80203056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020305a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020305e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80203062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80203066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020306a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020306e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80203072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80203076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020307a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020307e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80203082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80203086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020308a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020308e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80203092:	12000073          	sfence.vma
        jr t0
    80203096:	8282                	jr	t0

0000000080203098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80203098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020309c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802030a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802030a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802030a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802030ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802030b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802030b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802030b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802030bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802030c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802030c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802030c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802030c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802030ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802030cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802030ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802030d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802030d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802030d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802030da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802030de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802030e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802030e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802030ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802030ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802030f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802030f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802030fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802030fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80203102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80203106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020310a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020310e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80203112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80203116:	10200073          	sret
	...
