library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

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
    signal w_clk_1hz     : STD_LOGIC;
    signal w_min         : STD_LOGIC_VECTOR (3 downto 0);
    signal w_dsec        : STD_LOGIC_VECTOR (3 downto 0);
    signal w_usec        : STD_LOGIC_VECTOR (3 downto 0);
    signal w_seg_totales : STD_LOGIC_VECTOR (6 downto 0);

begin

    -- 1. Instanciar el Divisor de Reloj
    U1: divisor_reloj 
        port map (
            clk_50  => clk_50mhz,
            reset   => '1',
            clk_1s  => w_clk_1hz
        );

    -- 2. Instanciar el Control del Temporizador
    U2: timer_control 
        port map (
            clk_1hz  => w_clk_1hz,
            start    => btn_start,
            stop     => btn_stop,
            reinicio => btn_reset,
            minutos  => w_min,
            seg_dec  => w_dsec,
            seg_uni  => w_usec
        );

    -- Lógica combinacional auxiliar con resize para ajustar a exactamente 7 bits
    w_seg_totales <= std_logic_vector(resize(unsigned(w_dsec) * 10 + unsigned(w_usec), 7));

    -- 3. Instanciar el Decodificador Doble para los Segundos (HEX1 y HEX0)
    U3_hex_decoder: hex_decoder 
        port map (
            bin_in  => w_seg_totales,
            seg_dec => HEX1,
            seg_uni => HEX0
        );

    -- 4. Para los Minutos (HEX2), reutilizamos el hex_decoder rellenando con ceros a la izquierda
    U4_min_decoder: hex_decoder 
        port map (
            bin_in  => "000" & w_min,
            seg_dec => open,          
            seg_uni => HEX2           
        );

end arqui_top_cronometro_3botones;