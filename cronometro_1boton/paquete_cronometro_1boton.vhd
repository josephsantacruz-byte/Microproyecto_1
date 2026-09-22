library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package cronometro_pkg is

    component divisor_reloj is
        Port (
            clk_50 : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            clk_1s : out STD_LOGIC
        );
    end component;

    component timer_1boton is
        Port (
            clk_50   : in  STD_LOGIC;
            clk_1s   : in  STD_LOGIC;
            btn      : in  STD_LOGIC;
            minutos  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component hex_decoder is
        Port (
            bin_in  : in  STD_LOGIC_VECTOR (3 downto 0);
            seg_out : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

end package cronometro_pkg;