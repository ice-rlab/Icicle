import argparse

def parse(file_path, n_lines):
    with open(file_path, 'rb') as f:
        header_line = b''
        while True:
            char = f.read(1)
            if not char or char == b'\n':
                break
            header_line += char
        
        value = f.read(32)
        for i in range(15):
            value = f.read(24)
            value = f.read(24)
            value = f.read(24)
            
            
        i = 0
        while True:
            if n_lines and i >= n_lines:
                break
            value = f.read(24)
            for j, b in enumerate(reversed(value)):
                if(j >= 6 and j < 22):
                    print(f"{b:02x}", end="")
            print("")
            i += 1

def main():
    parser = argparse.ArgumentParser(description="Multithreaded 192-byte file reader.")
    parser.add_argument("file", help="Path to the file to read.")
    parser.add_argument("-n", type=int, default=None, help="Maximum number of lines (192-byte chunks) to read.")

    args = parser.parse_args()
    parse(args.file, args.n)

if __name__ == "__main__":
   main()
