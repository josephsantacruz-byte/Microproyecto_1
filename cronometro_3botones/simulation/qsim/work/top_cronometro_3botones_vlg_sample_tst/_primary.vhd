library verilog;
use verilog.vl_types.all;
entity top_cronometro_3botones_vlg_sample_tst is
    port(
        btn_reset       : in     vl_logic;
        btn_start       : in     vl_logic;
        btn_stop        : in     vl_logic;
        clk_50mhz       : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end top_cronometro_3botones_vlg_sample_tst;
