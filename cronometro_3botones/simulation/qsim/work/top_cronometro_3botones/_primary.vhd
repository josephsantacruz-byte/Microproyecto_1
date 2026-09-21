library verilog;
use verilog.vl_types.all;
entity top_cronometro_3botones is
    port(
        clk_50mhz       : in     vl_logic;
        btn_start       : in     vl_logic;
        btn_stop        : in     vl_logic;
        btn_reset       : in     vl_logic;
        reset           : in     vl_logic;
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0)
    );
end top_cronometro_3botones;
