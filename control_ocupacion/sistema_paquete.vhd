library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package sistema_paquete is

    -- Declaramos todos los componentes del sistema aquí adentro
    component divisor_reloj is
        Port (
            clk_50 : in  STD_LOGIC;
            clk_1s : out STD_LOGIC
        );
    end component;

    component contador_35s is
        Port (
            clk_1s     : in  STD_LOGIC;
            switch     : in  STD_LOGIC;
            segundos   : out STD_LOGIC_VECTOR(5 downto 0);
            limite_35s : out STD_LOGIC
        );
    end component;

    component tiempo_extra is
        Port (
            clk_1s     : in  STD_LOGIC;
            switch     : in  STD_LOGIC;
            limite_35s : in  STD_LOGIC;
            extra_seg  : out STD_LOGIC_VECTOR(6 downto 0);
            alarma     : out STD_LOGIC
        );
    end component;

    component hex_decoder is
        Port (
            bin_in     : in  STD_LOGIC_VECTOR(6 downto 0);
            seg_dec    : out STD_LOGIC_VECTOR(6 downto 0);
            seg_uni    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

end package sistema_paquete;