library verilog;
use verilog.vl_types.all;
entity top_control_vlg_sample_tst is
    port(
        clk_50          : in     vl_logic;
        switch          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end top_control_vlg_sample_tst;
