library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.cronometro_pkg.all;

entity top_cronometro_1boton is
    Port (
        clk_50mhz   : in  STD_LOGIC;
        btn_control : in  STD_LOGIC;
        HEX2_min    : out STD_LOGIC_VECTOR (6 downto 0);
        HEX1_dsec   : out STD_LOGIC_VECTOR (6 downto 0);
        HEX0_usec   : out STD_LOGIC_VECTOR (6 downto 0)
    );
end top_cronometro_1boton;

architecture arqui_top_cronometro_1boton of top_cronometro_1boton is

    signal w_clk_1s  : STD_LOGIC;
    signal w_minutos : STD_LOGIC_VECTOR (3 downto 0);
    signal w_seg_dec : STD_LOGIC_VECTOR (3 downto 0);
    signal w_seg_uni : STD_LOGIC_VECTOR (3 downto 0);

begin

    -- 1. Divisor de Reloj
    U1_divisor: divisor_reloj
        port map (
            clk_50 => clk_50mhz,
            reset  => '1',      
            clk_1s => w_clk_1s
        );

    -- 2. Cronómetro de 1 Botón
    U2_timer: timer_1boton
        port map (
            clk_50  => clk_50mhz,
            clk_1s  => w_clk_1s,
            btn     => not btn_control, 
            minutos => w_minutos,
            seg_dec => w_seg_dec,
            seg_uni => w_seg_uni
        );

    -- 3. Decodificador para Minutos (HEX2)
    U3_dec_min: hex_decoder
        port map (
            bin_in  => w_minutos,    
            seg_out => HEX2_min
        );

    -- 4. Decodificador para Decenas de Segundo (HEX1)
    U4_dec_dsec: hex_decoder
        port map (
            bin_in  => w_seg_dec,    
            seg_out => HEX1_dsec
        );

    -- 5. Decodificador para Unidades de Segundo (HEX0)
    U5_dec_usec: hex_decoder
        port map (
            bin_in  => w_seg_uni,    
            seg_out => HEX0_usec
        );

end architecture arqui_top_cronometro_1boton;