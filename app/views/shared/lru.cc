#include "debug/CacheRepl.hh"
#include "mem/cache/tags/lru.hh"
#include "mem/cache/base.hh"

LRU::LRU(const Params *p)
	: BaseSetAssoc(p)
{
}

CacheBlk*
LRU::accessBlock(Addr addr, bool is_secure, Cycles &lat, int master_id)
{
	CacheBlk *blk = BaseSetAssoc::accessBlock(addr, is_secure, lat, master_id);

	if (blk != NULL) {
		//move this block to head of the MRU list
		sets[blk->set].moveToHead(blk);
		DPRINTF(CacheRepl, "set %x: moving blk %x (%s) to MRU\n",
				blk->set, regenerateBlkAddr(blk->tag, blk->set),
				is_secure ? "s" : "ns");
	}

	return blk;
}

CacheBlk*

// 1) Access 혹은 Insert된 블록을 해당 set 리스트 맨 앞으로 이동
// 2) Invalidate된 블록을 해당 set 리스트의 맨 뒤로 이동
// 3) Victim을 고를 때 set 리스트의 맨 뒤를 선택

LRU::findVictim(Addr addr)
{
	int set = extractSet(addr);
	//grab a replacement candidate
	BlkType *blk = sets[set].blks[assoc - 1];

	if (blk->isValid()) {
		DPRINTF(CacheRepl, "set %x: selecting blk %x for replacement\n",
				set, regenerateBlkAddr(blk->tag, set));
	}

	return blk;
}

void
LRU::insertBlock(PacketPtr pkt, BlkType *blk)
{
	BaseSetAssoc::insertBlock(pkt, blk);

	int set = extractSet(pkt->getAddr());
	sets[set].moveToHead(blk);
}

void
LRU::invalidate(CacheBlk *blk)
{
	BaseSetAssoc::invalidate(blk);

	// should be evicted before valid blocks
	int set = blk -> set;
	sets[set].moveToTail(blk);
}

LRU*
LRUParams::create()
{
	return new LRU(this);
}
