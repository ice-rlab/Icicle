from tma import TopDownMicroArchitecturalAnalysis

boom_definitions = [
    {
        "name": "Cycle",
        "formula": "Cycle",
        "temp": True
    },
    {
        "name": "IPC",
        "formula": "IntRet / Cycle",
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
        "formula": "IntRet / TotalSlots",
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







BOOM_TMA = TopDownMicroArchitecturalAnalysis(boom_definitions)


BOOM_TMA_INTRET = TopDownMicroArchitecturalAnalysis(boom_definitions)
BOOM_TMA_FETCH_APPROX = TopDownMicroArchitecturalAnalysis(boom_definitions)
BOOM_ISSUE_APPROX = TopDownMicroArchitecturalAnalysis(boom_definitions)
BOOM_RECOVER_APPROX = TopDownMicroArchitecturalAnalysis(boom_definitions)

BOOM_TMA_INTRET.replace_formula(
"Retiring", "IntRet / TotalSlots"
)
BOOM_TMA_FETCH_APPROX.replace_formula(
"Frontend", "FetchBubble1 * 3 / TotalSlots"
)

BOOM_ISSUE_APPROX.replace_formula(
"FlushedUops", "UopsIssued0 * 4 - UopsRetired"
)

BOOM_RECOVER_APPROX.replace_formula(
"BadSpeculation", "(FlushedUops * NonFenceRate + BranchMispredict * 5) / TotalSlots"
)
