ROCKET_TRACE_COLUMNS = [
    {
        "name": "Fetchbubble",
        "formula": "(~ Recovering) & (~ ibuf_valid | ibuf_ready)",
    },
]
BOOM_TRACE_COLUMNS = [
        {
        "name": "FetchBubble0",
        "formula": "(~ Recovering) & (~ fetch_packet | ~ DecFbundle0)",
        },
        {
        "name": "FetchBubble1",
        "formula": "~ Recovering  & (~ fetch_packet | ~ DecFbundle1)",
        },
        {
        "name": "FetchBubble2",
        "formula": "~ Recovering  & (~ fetch_packet | ~ DecFbundle2)",
        },
        {
        "name": "ICacheBlocked",
        "formula": "~fetch_packet & icache_refill_valid",
        },
        {
        "name": "ICacheBlockedIMem",
        "formula": "imem_empty & icache_refill_valid",
        }
    ]