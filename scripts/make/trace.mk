.PHONY:
trace_decoder:
	$(QUIET)echo "Building trace decoder"
	g++ -O3 $(TD_DIR)/trace_decoder.cpp -o $(TD_DIR)/bin/trace_decoder

.PHONY:
trace_decoder_clean:
	rm -f $(TD_DIR)/bin/trace_decoder
