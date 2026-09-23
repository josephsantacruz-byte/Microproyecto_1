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
        clk_1s       : in  STD_LOGIC;                    -- Reloj de 1 Hz
        btn          : in  STD_LOGIC;                    -- Botón (Start / Stop / Reset)
        bin_minutos  : out STD_LOGIC_VECTOR(6 downto 0); -- Valor entero de minutos
        bin_segundos : out STD_LOGIC_VECTOR(6 downto 0)  -- Valor entero de segundos
    );
    end component;

    component hex_decoder is
        Port (
        bin_in     : in  STD_LOGIC_VECTOR(6 downto 0); -- Número de entrada (0 a 99)
        seg_dec    : out STD_LOGIC_VECTOR(6 downto 0); -- Display para las Decenas (abcdefg)
        seg_uni    : out STD_LOGIC_VECTOR(6 downto 0)  -- Display para las Unidades (abcdefg)
    );
    end component;

end package cronometro_pkg;