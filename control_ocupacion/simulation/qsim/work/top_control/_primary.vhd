library verilog;
use verilog.vl_types.all;
entity top_control is
    port(
        clk_50          : in     vl_logic;
        switch          : in     vl_logic;
        alarma_led      : out    vl_logic;
        seg_35_dec      : out    vl_logic_vector(6 downto 0);
        seg_35_uni      : out    vl_logic_vector(6 downto 0);
        seg_ex_dec      : out    vl_logic_vector(6 downto 0);
        seg_ex_uni      : out    vl_logic_vector(6 downto 0)
    );
end top_control;
