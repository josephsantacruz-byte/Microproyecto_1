library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package paquete_cronometro is

    -- Definimos nuestro tipo de dato personalizado para la FSM
    type estado_t is (REPOSO, CONTANDO, PAUSA);

    -- 1. Divisor con sus nombres y puertos reales
    component divisor_reloj is
        Port (
            clk_50 : in  STD_LOGIC;
            reset  : in  STD_LOGIC;
            clk_1s : out STD_LOGIC
        );
    end component;

    -- 2. Control del temporizador
    component timer_control is
        Port (
            clk_1hz  : in  STD_LOGIC;
            start    : in  STD_LOGIC;
            stop     : in  STD_LOGIC;
            reinicio : in  STD_LOGIC;
            minutos  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- 3. Decodificador doble para los segundos (con sus puertos reales)
    component hex_decoder is
        Port (
            bin_in  : in  STD_LOGIC_VECTOR (6 downto 0);
            seg_dec : out STD_LOGIC_VECTOR (6 downto 0);
            seg_uni : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

end package paquete_cronometro;