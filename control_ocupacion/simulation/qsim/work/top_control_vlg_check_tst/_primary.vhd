library verilog;
use verilog.vl_types.all;
entity top_control_vlg_check_tst is
    port(
        alarma_led      : in     vl_logic;
        seg_35_dec      : in     vl_logic_vector(6 downto 0);
        seg_35_uni      : in     vl_logic_vector(6 downto 0);
        seg_ex_dec      : in     vl_logic_vector(6 downto 0);
        seg_ex_uni      : in     vl_logic_vector(6 downto 0);
        sampler_rx      : in     vl_logic
    );
end top_control_vlg_check_tst;
