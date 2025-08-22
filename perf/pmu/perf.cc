/**
 * perf - Performance monitoring for a program.
*/

#include <iostream>
#include <vector>
#include <string>
#include <unistd.h>
#include <fstream>
#include <sys/wait.h>
#include <cstring>
#include <cassert>
#include <cstdint>


#include "trigger.h"
#include "encoding.h"
#include "tma_defs.h"

void read_counters(std::vector<uint64_t>& counters){
    counters[0] = read_csr_safe(cycle);
    counters[1] = read_csr_safe(instret);
    counters[2] = read_csr_safe(hpmcounter3);
    counters[3] = read_csr_safe(hpmcounter4);
    counters[4] = read_csr_safe(hpmcounter5);
    counters[5] = read_csr_safe(hpmcounter6);
    counters[6] = read_csr_safe(hpmcounter7);
    counters[7] = read_csr_safe(hpmcounter8);
    counters[8] = read_csr_safe(hpmcounter9);
    counters[9] = read_csr_safe(hpmcounter10);
    counters[10] = read_csr_safe(hpmcounter11);
    counters[11] = read_csr_safe(hpmcounter12);
    counters[12] = read_csr_safe(hpmcounter13);
    counters[13] = read_csr_safe(hpmcounter14);
    counters[14] = read_csr_safe(hpmcounter15);
    counters[15] = read_csr_safe(hpmcounter16);
    counters[16] = read_csr_safe(hpmcounter17);
    counters[17] = read_csr_safe(hpmcounter18);
    counters[18] = read_csr_safe(hpmcounter19);
    counters[19] = read_csr_safe(hpmcounter20);
    counters[20] = read_csr_safe(hpmcounter21);
    counters[21] = read_csr_safe(hpmcounter22);
    counters[22] = read_csr_safe(hpmcounter23);
    counters[23] = read_csr_safe(hpmcounter24);
    counters[24] = read_csr_safe(hpmcounter25);
    counters[25] = read_csr_safe(hpmcounter26);
    counters[26] = read_csr_safe(hpmcounter27);
    counters[27] = read_csr_safe(hpmcounter28);
    counters[28] = read_csr_safe(hpmcounter29);
    counters[29] = read_csr_safe(hpmcounter30);
    counters[30] = read_csr_safe(hpmcounter31);
}

void compare(std::vector<uint64_t>& start, std::vector<uint64_t>& end, std::ofstream &outfile){
    assert(start.size() == end.size() && "Size mismatch in counters\n"); 
#ifdef ROCKET
    outfile << "Core: Rocket\n";
#else
    outfile << "Core: Boom\n";
    outfile << "CoreWidth: " << COREWIDTH << "\n";
    outfile << "IssueWidth: " << ISSUEWIDTH << "\n";
#endif
    for(int i = 0; i < MAX_PMU_COUNT;++i){
        if(!strcmp(counter_names[i], UNUSED)){
            continue;
        }
        uint64_t diff = end[i] - start[i];
        outfile << std::string( counter_names[i]) << ": " << diff << "\n";
    }
}

std::string stripAllWhitespace(const std::string& str) {
    std::string result = "";
    for (char c : str) {
        if (!std::isspace(c)) {
            result += c;
        }
    }
    return result;
}


int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <program> [arguments...]" << std::endl;
        return 1;
    }
    
    std::string command_to_run;
    std::vector<char*> exec_args;
    command_to_run = argv[1];
    exec_args.push_back(argv[1]);
    
    for (int i = 2; i < argc; ++i) {
        command_to_run += " ";
        command_to_run += argv[i];
        exec_args.push_back(argv[i]);
    }
    for (auto & arg : exec_args) {
        std::cout << arg << " ";
    }
    std::cout << std::endl;
    std::ofstream outfile("/cpi/" + stripAllWhitespace(command_to_run) + ".cpi");
    exec_args.push_back(nullptr);

    if (outfile.is_open()) {
        outfile << command_to_run << ":" << std::endl;
    } else {
        std::cerr << "Error opening file for writing command." << std::endl;
    }
    std::vector<uint64_t> start(MAX_PMU_COUNT), end(MAX_PMU_COUNT);
    pid_t pid = fork();
    
    
    if (pid == -1) {
        perror("fork");
        return 1;
    } else if (pid == 0) {
        execvp(exec_args[0], exec_args.data());
        perror("execvp");
        _exit(127);
    } else {
        int status;
        read_counters(start);
        FIRESIM_START_TRIGGER();
        waitpid(pid, &status, 0);
        FIRESIM_END_TRIGGER();
        read_counters(end);
        compare(start, end, outfile);
        outfile.close();
    }
    return 0;
}