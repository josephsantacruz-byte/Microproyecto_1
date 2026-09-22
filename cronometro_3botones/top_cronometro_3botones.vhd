library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

use work.paquete_cronometro.all;

entity top_cronometro_3botones is
    Port (
        clk_50      : in  STD_LOGIC; -- Reloj de la tarjeta DE0 (50 MHz)
        btn_start   : in  STD_LOGIC;
        btn_stop    : in  STD_LOGIC;
        btn_reset   : in  STD_LOGIC;
        min_out_dec : out STD_LOGIC_VECTOR(6 downto 0);
        min_out_uni : out STD_LOGIC_VECTOR(6 downto 0);
        seg_dec     : out STD_LOGIC_VECTOR(6 downto 0);
        seg_uni     : out STD_LOGIC_VECTOR(6 downto 0)
    );
end entity top_cronometro_3botones;

architecture arqui_top_cronometro_3botones of top_cronometro_3botones is

    -- Señales internas de interconexión
    signal w_clk_1s     : STD_LOGIC;
    signal w_minutos    : STD_LOGIC_VECTOR(3 downto 0);
    signal w_seg_dec    : STD_LOGIC_VECTOR(3 downto 0);
    signal w_seg_uni    : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- 1. Instancia del Divisor de Reloj (Nunca se para, reset fijo en '1')
    U1_DIV: divisor_reloj
        port map (
            clk_50 => clk_50,
            reset  => '1',      -- Fijo en '1' para que el reloj no se detenga nunca
            clk_1s => w_clk_1s
        );

    -- 2. Instancia del Control del Temporizador
    U2_CTRL: timer_control
        port map (
            clk_1hz  => w_clk_1s,
            start    => btn_start,
            stop     => btn_stop,
            reinicio => btn_reset,   -- Conectado al botón físico de la tarjeta
            minutos  => w_minutos,
            seg_dec  => w_seg_dec,
            seg_uni  => w_seg_uni
        );

    -- 3. Decodificador para las unidades de segundo
    U3_DEC_SEG_UNI: hex_decoder
        port map (
            bin_in  => "000" & w_seg_uni,
            seg_dec => open,
            seg_uni => seg_uni
        );

    -- 4. Decodificador para las decenas de segundo
    U4_DEC_SEG_DEC: hex_decoder
        port map (
            bin_in  => "000" & w_seg_dec,
            seg_dec => open,
            seg_uni => seg_dec
        );

    -- 5. Decodificador para los minutos (unidades y decenas mapeadas a las salidas del top)
    U5_DEC_MINUTOS: hex_decoder
        port map (
            bin_in  => "000" & w_minutos,
            seg_dec => min_out_dec,
            seg_uni => min_out_uni
        );

end architecture arqui_top_cronometro_3botones;