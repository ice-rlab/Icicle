#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <cstring>

void parse(const std::string& file_path, int n_lines) {
    std::ifstream in(file_path, std::ios::binary);
    if (!in) {
        std::cerr << "Error: Could not open input file.\n";
        return;
    }

    std::string out_file_path = file_path + ".decoded";
    std::ofstream out(out_file_path, std::ios::binary);
    if (!out) {
        std::cerr << "Error: Could not open output file: " << out_file_path << "\n";
        return;
    }

    // Read header line until newline
    char ch;
    std::vector<char> header_line;
    while (in.get(ch)) {
        if (ch == '\n') break;
        header_line.push_back(ch);
    }

    // // Skip 32 bytes
    // in.ignore(32);

    // Skip 3×24 bytes, 15 times
    for (int i = 0; i < 15; ++i) {
        in.ignore(24);
        in.ignore(24);
        in.ignore(24);
    }

    // Read and process 24-byte chunks
    int i = 0;
    while (true) {
        if (n_lines > 0 && i >= n_lines) break;

        char buffer[24];
        in.read(buffer, 24);
        if (in.gcount() < 24) break; // EOF or short read

        std::reverse(buffer, buffer + 24);
        out.write(buffer + 6, 8); // Top half of trace
        out.write(buffer + 14, 2); // Not sure what is going on here?
        out.write(buffer, 6); // First six bytes
        // out.write(buffer + 14, 22);  // Write bytes 13–21
        // out.write(buffer + 6, 13);  // Write bytes 6–21
        ++i;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <file> [-n N_LINES]\n";
        return 1;
    }

    std::string file_path = argv[1];
    int n_lines = -1;

    if (argc >= 4 && std::string(argv[2]) == "-n") {
        n_lines = std::stoi(argv[3]);
    }

    parse(file_path, n_lines);
    return 0;
}
