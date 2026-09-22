library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Importamos el paquete del cronómetro
library work;
use work.cronometro_pkg.all;

entity top_cronometro_1boton is
    Port (
        clk_50mhz   : in  STD_LOGIC;                    -- Reloj principal de la tarjeta (PIN_G21)
        btn_control : in  STD_LOGIC;                  -- Botón multifunción 
        
        -- Salidas hacia los displays de 7 segmentos físicos de la tarjeta
        HEX2_min    : out STD_LOGIC_VECTOR (6 downto 0); -- Display para los minutos (HEX2)
        HEX1_dsec   : out STD_LOGIC_VECTOR (6 downto 0); -- Display para las decenas de segundo (HEX1)
        HEX0_usec   : out STD_LOGIC_VECTOR (6 downto 0)  -- Display para las unidades de segundo (HEX0)
    );
end top_cronometro_1boton;

architecture arqui_top_cronometro_1boton of top_cronometro_1boton is

    -- Señales internas de interconexión
    signal w_clk_1s  : STD_LOGIC;
    signal w_minutos : STD_LOGIC_VECTOR (3 downto 0);
    signal w_seg_dec : STD_LOGIC_VECTOR (3 downto 0);
    signal w_seg_uni : STD_LOGIC_VECTOR (3 downto 0);

begin

    -- 1. Instancia del Divisor de Reloj (reduce de 50 MHz a 1 Hz)
    U1_divisor: divisor_reloj
        port map (
            clk_50 => clk_50mhz,
            reset  => '1',      -- Activo en bajo, se deja en '1' para habilitarlo
            clk_1s => w_clk_1s
        );

    -- 2. Instancia del Cronómetro de 1 Botón
    U2_timer: timer_1boton
        port map (
            clk_1s  => w_clk_1s,
            btn     => not btn_control, 
            minutos => w_minutos,
            seg_dec => w_seg_dec,
            seg_uni => w_seg_uni
        );

    -- 3. Decodificador para minutos (HEX2) - Completando 7 bits
    U3_dec_min: hex_decoder
        port map (
            bin_in  => "000" & w_minutos,    -- 3 ceros + 4 bits de minutos = 7 bits exactos
            seg_dec => open,                 
            seg_uni => HEX2_min
        );

    -- 4. Decodificador para las decenas y unidades de segundo (HEX1 y HEX0)
    U4_dec_seg: hex_decoder
        port map (
            bin_in  => "000" & w_seg_dec,    -- Ajusta aquí si tu decodificador combina o maneja ambos
            seg_dec => HEX1_dsec,
            seg_uni => HEX0_usec
        );

end architecture arqui_top_cronometro_1boton;