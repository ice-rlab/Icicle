from tma import TopDownMicroArchitecturalAnalysis

rocket_definitions = [

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
        "name": "CoreWidth",
        "formula": "CoreWidth",
        "temp": True
    },
    {
        "name": "Allflush",
        "formula": "Flush + BrDirMiss",
        "temp": True
    },
    {
        "name": "BMissrate",
        "formula": "BrDirMiss / Allflush",
        "temp": True
    },
    {
        "name": "NonFenceRate",
        "formula": "(BrDirMiss + Flush) / Allflush",
        "temp": True
    },
    {
        "name": "MachineClearRate",
        "formula": "(Flush) / Allflush",
        "temp": True
    },
    {
        "name": "Retiring",
        "formula": "IntRet / Cycle",
    },
    {
        "name": "BadSpeculation",
        "formula": "(((SlotsIssued - IntRet) * NonFenceRate) + Recovering)  / Cycle",
        "subcategories": [
            {
                "name": "MachineClears",
                "formula": "(((SlotsIssued - IntRet) * MachineClearRate))  / Cycle"
            },
            {
                "name": "BranchMispredictions",
                "formula": "(((SlotsIssued - IntRet) * BMissrate) + Recovering) / Cycle",
                "subcategories": [
                    {
                        "name": "Flush",
                        "formula": "((SlotsIssued - IntRet) * BMissrate)  / Cycle"
                    },
                    {
                        "name": "RecoveryBubbles",
                        "formula": "Recovering / Cycle"
                    }
                ]
            }
        ]
    },
    {
        "name": "Frontend",
        "formula": "Fetchbubbles / Cycle",
        "subcategories": [
            {
                "name": "FetchLatency",
                "formula": "ICacheBlocked / Cycle"
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
                "formula": "DCacheBlocked / Cycle"
            }
        ]
    }
]

ROCKET_TMA = TopDownMicroArchitecturalAnalysis(rocket_definitions)