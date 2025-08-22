from typing import List, Dict, Optional, Tuple
from abc import ABC, abstractmethod
import yaml
from pathlib import Path
import re
import pandas as pd


class Parser(ABC):
    def __init__(self, file_path: Path) -> None:
        self.file_path: Path = file_path
        self.counters: Dict[str, int] = {}

        
    def get_counter(self, name: str) -> int:
        return self.counters[name]

        
        
class TraceParser(Parser):
    def __init__(self, file_path: Path, trace_dict: Dict[str, int], definitions: List[Dict[str,str]], n) -> None:
        self.trace_dict = trace_dict
        self.trace: pd.DataFrame = pd.DataFrame()
        super().__init__(file_path)
        self._parse_file(n)
        self._add_derived_columns(definitions)
        self._compute_counters()
        


    def _parse_file(self, n) -> None:
        rows = []
        record_size = 16

        with self.file_path.open("rb") as f:
            count = 0
            while True:
                if count >= n:
                    break
                chunk = f.read(record_size)
                if len(chunk) < record_size:
                    break
                bits = bin(int.from_bytes(chunk[::-1], "little"))[2:].zfill(128)
                pos = 0
                row = {}
                for field, width in self.trace_dict.items():
                    row[field] = bits[pos:pos + width]
                    pos += width
                rows.append(row)
                count += 1

        
        self.trace = pd.DataFrame(rows)
        self.trace.columns = self.trace.columns.str.strip("'\"")

        self.trace.columns = self.trace.columns.str.strip()
        self.trace.drop(columns=['test_data', 'padding', 'danger'], inplace=True, errors='ignore')
        self.trace = self.trace.astype(int).astype(bool)

    def _add_derived_columns(self, definitions: List[Dict[str,str]]) -> None:
        """
        definitions: list of dicts with keys "name" and "formula".
        """
        df = self.trace
        for d in definitions:
            newcol = d["name"]
            expr   = d["formula"]
            df[newcol] = df.eval(expr).astype(bool)
        self.trace = df
    

    
    def _compute_counters(self) -> None:
        import re
        counters: Dict[str, int] = {}
        counters["Cycle"] = self.trace.shape[0]
        try:
            counters["CoreWidth"] = max(self.trace["UopsRetired0"].astype(int) + self.trace["UopsRetired1"].astype(int) + self.trace["UopsRetired2"].astype(int) + self.trace["UopsRetired3"].astype(int)) 
        except: 
            counters["CoreWidth"] = 1
        
        for col in self.trace.columns:
            total_ones = self.trace[col].sum()
            # strip trailing digits
            m = re.match(r"^(.*?)(\d+)$", col)
            base = m.group(1) if m else col
            counters[base] = counters.get(base, 0) + int(total_ones)
        self.counters = counters
        

    def get_counters(self) -> Dict[str, int]:
        return self.counters
        
        




    def count_field_ones(self, n: int = None) -> Dict[str, int]:
        """
        Scan up to `n` records (or all, if n is None), beginning at record index `start`,
        and return a dict mapping each field name to the total count of '1' bits seen.

        :param n: maximum number of records to process (None = all)
        """
        counts: Dict[str, int] = {field: 0 for field in self.trace_dict}
        record_size = 16

        with self.file_path.open("rb") as f:
            idx = 0
            while True:
                chunk = f.read(record_size)
                if len(chunk) < record_size:
                    break
                if idx >= start:
                    bits = bin(int.from_bytes(chunk[::-1], "little"))[2:].zfill(128)
                    bit_pos = 0
                    for field, width in self.trace_dict.items():
                        segment = bits[bit_pos : bit_pos + width]
                        counts[field] += segment.count("1")
                        bit_pos += width
                    if n is not None and idx >=  n - 1:
                        break
                idx += 1

        return counts
    

class PMUCounterParser(Parser):
    def __init__(self, file_path: Path) -> None:
        super().__init__(file_path)
        
            
        def _parse_file(self) -> None:
            with self.file_path.open("r", encoding="utf-8") as f:
                for line_num, line in enumerate(f, start=1):
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        key, value_str = line.split(":", 1)
                        key = key.strip().replace(" ", "").replace("$", "")
                        value = int(value_str.strip())
                    except ValueError:
                        continue
                    if key in self.counters:
                        pass
                    self.counters[key] = value
            if "Core" not in self.counters:
                self.counters["Core"] = "Rocket"
            if "Corewidth" not in self.counters:
                self.counters["Corewidth"] = 1
                
        # Do this to naturally deadl with using one counter per event, as in SCALAR config
        def post_process(counters: Dict[str, int]) -> Dict[str, int]:
            collapsed: Dict[str, int] = {}
            to_delete = []

            for key in list(counters.keys()):
                match = re.match(r"^([A-Za-z$]+)(\d+)$", key)
                if match:
                    base = match.group(1)
                    collapsed[base] = collapsed.get(base, 0) + counters[key]
                    to_delete.append(key)

            for key, val in collapsed.items():
                counters[key] = val

            return counters
        _parse_file(self)
        self.counters = post_process(self.counters)

    def __str__(self) -> str:
        return "\n".join(f"{key}: {value}" for key, value in self.counters.items())


class Category:
    def __init__(self, name: str, formula: str, temp: bool = False):
        self.name = name.replace(" ", "")
        self.formula = formula
        self.temp = temp
        self.subcategories: List["Category"] = []
        self.value: Optional[float] = None

    def resolve_formula(
        self,
        counters: Parser,
        categories: Dict[str, "Category"],
        visited: Optional[set] = None
    ) -> str:
        if visited is None:
            visited = set()
        if self.name in visited:
            raise ValueError(f"Cyclic dependency detected in category: {self.name}")
        visited.add(self.name)

        def replace_var(match: re.Match) -> str:
            var = match.group(0)
            if var in counters.counters:
                return str(counters.get_counter(var))
            elif var in categories:
                return f"({categories[var].resolve_formula(counters, categories, visited.copy())})"
            else:
                raise ValueError(f"Unknown variable in formula: {var}")

        resolved = re.sub(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', replace_var, self.formula)
        return resolved

    def apply(self, counters: Parser, categories: Dict[str, "Category"]) -> float:
        resolved_formula = self.resolve_formula(counters, categories)
        try:
            self.value = max(0.0, eval(resolved_formula, {"__builtins__": {}}, {}))
            return self.value
        except Exception as e:
            raise ValueError(f"Error evaluating formula '{resolved_formula}': {e}")

    def __repr__(self) -> str:
        return f"Category(name='{self.name}', value={self.value}, formula='{self.formula}')"


class TopDownMicroArchitecturalAnalysis:
    def __init__(self, category_list: List[dict]):
        self.categories: Dict[str, Category] = {}
        self.root_categories: List[Category] = []
        for entry in category_list:
            self.root_categories.append(self._add_category(entry))

    def _add_category(self, entry: dict) -> Category:
        name = entry["name"].replace(" ", "")
        formula = entry["formula"]
        temp = entry.get("temp", False)
        if name in self.categories:
            pass
        category = Category(name, formula, temp)
        self.categories[name] = category
        for sub in entry.get("subcategories", []):
            subcat = self._add_category(sub)
            category.subcategories.append(subcat)
        return category

    def apply(self, counters: Parser):
        results = {}
        for name, category in self.categories.items():
                category.apply(counters, self.categories)

    def to_yaml_string(self, counters: Optional[Parser] = None, values : bool = False) -> str:
        resolved = {
            name: category.resolve_formula(counters, self.categories) if values else category.value if counters else category.formula
            for name, category in self.categories.items()
        }
        return yaml.dump(resolved, default_flow_style=False, sort_keys=False)
    
    def print_values(self) -> None:
        def print_tree(category: Category, indent: int = 0) -> None:
            if not category.temp:
                prefix = "  " * indent
                val_str = f"{category.value:.4f}" if category.value is not None else "N/A"
                print(f"{prefix}{category.name}: {val_str}")
                for sub in category.subcategories:
                    print_tree(sub, indent + 1)
        for root in self.root_categories:
            print_tree(root)
    
    def replace_formula(self, name: str, formula: str) -> None:
            try:
                cat = self.categories[name]
            except KeyError:
                raise ValueError(f"Category '{name}' not found")
            cat.formula = formula
    
    def get_corewidth(self) -> int:
        return self.categories.get("CoreWidth").value
    
    def get_ipc(self) -> int:
        return self.categories.get("IPC").value
    
    def get_cycle(self) -> int:
        return self.categories.get("Cycle").value
    
    def print_cycle(self) -> int:
        print(f"Cycle: {self.get_cycle():.4f}")
        
    def print_ipc(self) -> None:
            print(f"IPC: {self.get_ipc():.4f}")
    
    def to_plot(self, category: str = "") -> Tuple[List[str], List[float], float]:
        result = []
        if category == "":
            root_categories = self.root_categories
        else:
            root_categories = self.categories.get(category).subcategories
        for cat in root_categories:
            if not cat.temp:
                result.append((cat.name, cat.value or 0.0))
        ipc_category = self.categories.get("IPC")
        names, values = zip(*result) if result else ([], [])
        return list(names), list(values), ipc_category.value
    
        
    def __str__(self) -> str:
        return self.to_yaml_string()
