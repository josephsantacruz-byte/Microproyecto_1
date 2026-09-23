library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Usamos el paquete de componentes
use work.cronometro_pkg.all;

entity top_cronometro_1boton is
    Port (
        clk_50MHz   : in  STD_LOGIC;                    -- Reloj principal de la tarjeta
        reset_sys   : in  STD_LOGIC;                    -- Reset maestro del divisor
        btn_action  : in  STD_LOGIC;                    -- Botón de control (Start/Stop/Reset)
        seg_min     : out STD_LOGIC_VECTOR(6 downto 0); -- Display para Minutos
        seg_sec_dec : out STD_LOGIC_VECTOR(6 downto 0); -- Display Decenas de Segundos
        seg_sec_uni : out STD_LOGIC_VECTOR(6 downto 0)  -- Display Unidades de Segundos
    );
end entity top_cronometro_1boton;

architecture arqui_top_cronometro_1boton of top_cronometro_1boton is

    -- Señales de interconexión interna
    signal wire_clk_1s    : STD_LOGIC;
    signal wire_minutos   : STD_LOGIC_VECTOR(6 downto 0);
    signal wire_segundos  : STD_LOGIC_VECTOR(6 downto 0);
    signal wire_dummy_dec : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- 1. Instancia del Divisor de Reloj
    U1_DIVISOR: divisor_reloj
        port map (
            clk_50 => clk_50MHz,
            reset  => reset_sys,
            clk_1s => wire_clk_1s
        );

    -- 2. Instancia del Temporizador
    U2_TIMER: timer_1boton
        port map (
            clk_1s       => wire_clk_1s,
            btn          => btn_action,
            bin_minutos  => wire_minutos,
            bin_segundos => wire_segundos
        );

    -- 3. Decodificador para los Segundos (Decenas y Unidades)
    U3_DEC_SEGUNDOS: hex_decoder
        port map (
            bin_in  => wire_segundos,
            seg_dec => seg_sec_dec,
            seg_uni => seg_sec_uni
        );

    -- 4. Decodificador para los Minutos (Solo Unidades)
    U4_DEC_MINUTOS: hex_decoder
        port map (
            bin_in  => wire_minutos,
            seg_dec => wire_dummy_dec, -- No utilizado
            seg_uni => seg_min
        );

end architecture arqui_top_cronometro_1boton;