#include "base/random.hh"
#include "debug/CacheRepl.hh"
#include "mem/cache/tags/random_repl.hh"
#include "mem/cache/basse.hh"

RandomRepl::RandomRepl(const Params *p)
	: BaseSetAssoc(p)

{
}

CacheBlk*
RandomRepl::accessBlock(Addr addr, bool is_secure, Cycles &lat, int master_id)
{
	return BaseSetAssoc::accessBlock(addr, is_secure, lat, master_id)
}

CacheBlk*

// 1) set내에 invalid한 블록이 있는지 검사
// 2) set내에 invalid한 블록이 있다면 이를 교체
// 3) set내에 invalid한 블록이 없다면 랜덤한 블록을 교체

RandomRepl::findVictim(Addr addr)
{
	CacheBlk *blk = BaseSetAssoc::findVictim(addr);

	//if all blocks are valid, pick a replacemnet at random
	if (blk->isValid()) {
		//find a random index within the bounds of the set
		int idx = random_mt.random<int>(0, assoc - 1);
		assert(idx < assoc);
		assert(idx >= 0);
		blk = sets[extractSet(addr)].blks[idx];

		DPRINTF(CacheRepl, "set %x: selecting blk %x for replacement\n",
			blk->set, regenerateBlkAddr(blk->tag, blk->set));
	}
	return blk;
}

void
RandomRepl::insertBlock(PacketPtr pkt, BlkType *blk)
{
	BaseSetAssoc::insertBlock(pkt, blk);
}

void
RandomRepl::invalidate(CacheBlk *blk)
{
	BaseSetAssoc::invalidate(blk);
}

RandomRepl*
RandomReplParams::create()
{
	return new RandomRepl(this);
}
