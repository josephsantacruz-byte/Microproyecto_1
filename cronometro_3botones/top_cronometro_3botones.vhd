library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Importamos el nuevo paquete actualizado
library work;
use work.paquete_cronometro.all;

entity top_cronometro_3botones is
    Port (
        clk_50mhz : in  STD_LOGIC; -- Reloj de la tarjeta DE0 (50 MHz)
        btn_start : in  STD_LOGIC;
        btn_stop  : in  STD_LOGIC;
        btn_reset : in  STD_LOGIC;
        HEX2      : out STD_LOGIC_VECTOR (6 downto 0); -- Display de Minutos
        HEX1      : out STD_LOGIC_VECTOR (6 downto 0); -- Display de Segundos (Decenas)
        HEX0      : out STD_LOGIC_VECTOR (6 downto 0)  -- Display de Segundos (Unidades)
    );
end top_cronometro_3botones;

architecture arqui_top_cronometro_3botones of top_cronometro_3botones is

    -- Señales internas de conexión entre bloques
    signal w_clk_1hz : STD_LOGIC;
    signal w_min     : STD_LOGIC_VECTOR (3 downto 0);
    signal w_dsec    : STD_LOGIC_VECTOR (3 downto 0);
    signal w_usec    : STD_LOGIC_VECTOR (3 downto 0);

begin

    -- 1. Instanciar el Divisor de Frecuencia
    U1: divisor_frecuencia 
        port map (
            clk_in  => clk_50mhz,
            clk_out => w_clk_1hz
        );

    -- 2. Instanciar el Control del Temporizador
    U2: timer_control 
        port map (
            clk_1hz  => w_clk_1hz,
            start    => btn_start,
            stop     => btn_stop,
            reset    => btn_reset,
            minutos  => w_min,
            seg_dec  => w_dsec,
            seg_uni  => w_usec
        );

    -- 3. Instanciar los Decodificadores de 7 Segmentos para cada Display HEX
    U3: bin_to_7seg 
        port map (
            bin => w_min,
            seg => HEX2
        );

    U4: bin_to_7seg 
        port map (
            bin => w_dsec,
            seg => HEX1
        );

    U5: bin_to_7seg 
        port map (
            bin => w_usec,
            seg => HEX0
        );

end arqui_top_cronometro_3botones;