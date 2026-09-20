library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package paquete_cronometro is

    -- Definimos nuestro tipo de dato personalizado para los estados de la FSM
    type estado_t is (REPOSO, CONTANDO, PAUSA);

    -- Declaramos todos los componentes del sistema
    component divisor_frecuencia is
        Port (
            clk_in  : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

    component timer_control is
        Port (
            clk_1hz  : in  STD_LOGIC;
            start    : in  STD_LOGIC;
            stop     : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            minutos  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
            seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component bin_to_7seg is
        Port (
            bin : in  STD_LOGIC_VECTOR (3 downto 0);
            seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

end package paquete_cronometro;