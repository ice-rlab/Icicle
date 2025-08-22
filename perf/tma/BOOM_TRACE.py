from tma import TopDownMicroArchitecturalAnalysis

boom_trace_definitions = [
    {
        "name": "IPC",
        "formula": "UopsRetired / Cycle",
        "temp": True
    },
    {
        "name": "TotalSlots",
        "formula": "Cycle * CoreWidth",
        "temp": True
    },
    {
        "name": "CoreWidth",
        "formula": "CoreWidth",
        "temp": True
    },
    {
        "name": "Allflush",
        "formula": "Flush + BranchMispredict + FenceRetired",
        "temp": True
    },
    {
        "name": "BMissrate",
        "formula": "BranchMispredict / Allflush",
        "temp": True
    },
    {
        "name": "NonFenceRate",
        "formula": "(BranchMispredict + FenceRetired) / Allflush",
        "temp": True
    },
    {
        "name": "MachineClearRate",
        "formula": "Flush/ Allflush",
        "temp": True
    },
    {
        "name": "Retiring",
        "formula": "UopsRetired / TotalSlots",
    },
    {
        "name": "RecoveryBubbles",
        "formula": "Recovering * CoreWidth + BranchMispredict * 2 * CoreWidth",
        "temp": True
    },
    
    {
        "name": "FlushedUops",
        "formula": "UopsIssued - UopsRetired",
        "temp": True
    },
    {
        "name": "BadSpeculation",
        "formula": "(FlushedUops * NonFenceRate + RecoveryBubbles) / TotalSlots",
        "subcategories": [
            {
                "name": "MachineClears",
                "formula": "(FlushedUops * MachineClearRate) / TotalSlots"
            },
            {
                "name": "BranchMispredictions",
                "formula": "(FlushedUops * BMissrate + Recovering) / TotalSlots",
                "subcategories": [
                    {
                        "name": "Flush",
                        "formula": "FlushedUops * BMissrate  / TotalSlots"
                    },
                    {
                        "name": "RecoveryBubbles",
                        "formula": "Recovering / TotalSlots"
                    }
                ]
            }
        ]
    },
    {
        "name": "Frontend",
        "formula": "FetchBubble / TotalSlots",
        "subcategories": [
            {
                "name": "FetchLatency",
                "formula": "IBlocked * CoreWidth / TotalSlots"
            },
            {
                "name": "PCResolution",
                "formula": "Frontend - FetchLatency",
            }
        ]
    },
    {
        "name": "Backend",
        "formula": "1 - Retiring - Frontend - BadSpeculation",
        "subcategories": [
            {
                "name": "CoreBound",
                "formula": "Backend - MemBound"
            },
            {
                "name": "MemBound",
                "formula": "DBlocked / TotalSlots"
            }
        ]
    }
]

BOOM_TRACE_TMA = TopDownMicroArchitecturalAnalysis(boom_trace_definitions)
{
    "name": "TotalSlots",
},