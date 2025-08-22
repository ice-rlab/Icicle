ROCKET_FRONTEND_FILTER = [
    "icache_miss",
    "ICacheBlocked",
    "ibuf_valid",
    "ibuf_ready",
    "Recovering",
    "Fetchbubble",
]


FRONTEND_FILTER = [
    "i_cache_miss",
    "itlb_miss",
    "BranchMispredict",
    "icache_refill_valid",
    "Recovering",
    "Flush",
    "flush_frontend",
    "DecFbundle0",
    "DecFbundle1",
    "DecFbundle2",
    "FetchBubble0",
    "FetchBubble1",
    "FetchBubble2",
]


BACKEND_FILTER = [
    "d_cache_miss",
    "dtlb_miss",
    "outstanding",
    "UopsDispatched0",
    "UopsDispatched0",
    "UopsDispatched1",
    "UopsDispatched2",
    "UopsDispatched3",
    "UopsIssued0",
    "UopsIssued1",
    "UopsIssued2",
    "UopsIssued3",
    "UopsIssued4",
    "UopsIssued5",
    "DBlocked0",
    "DBlocked1",
    "DBlocked2",
    "DBlocked3",
    "rob_empty",
    "issue_units_empty0",
    "issue_units_empty1",
    "issue_units_empty2",
]
MEMBOUND_FILTER = [
    "d_cache_miss",
    "dtlb_miss",
    "outstanding",
    "UopsIssued0",
    "UopsIssued1",
    "UopsIssued2",
    "UopsIssued3",
    "UopsIssued4",
    "UopsIssued5",
    "DBlocked0",
    "DBlocked1",
    "DBlocked2",
    "DBlocked3",
    "issue_units_empty0",
    "issue_units_empty1",
    "issue_units_empty2",
]

FILTERS_MAP = {
    "Backend" : BACKEND_FILTER,
    "Frontend" : FRONTEND_FILTER,
    "Membound" : MEMBOUND_FILTER,
    "RocketFrontend" : ROCKET_FRONTEND_FILTER,
}

def get_filter(cat: str = "Frontend"):
    print(FILTERS_MAP)
    return FILTERS_MAP[cat]