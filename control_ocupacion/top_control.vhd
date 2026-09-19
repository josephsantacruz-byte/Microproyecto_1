library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sistema_paquete.all;

entity top_control is
    Port (
        clk_50     : in  STD_LOGIC;                      
        switch     : in  STD_LOGIC;                      
        alarma_led : out STD_LOGIC;                      
        seg_dec    : out STD_LOGIC_VECTOR(6 downto 0);     
        seg_uni    : out STD_LOGIC_VECTOR(6 downto 0)      
    );
end entity top_control;

architecture arqui_top_control of top_control is

    -- Señales internas de interconexión
    signal w_clk_1s    : STD_LOGIC;
    signal w_segundos  : STD_LOGIC_VECTOR(5 downto 0);
    signal w_extra_seg : STD_LOGIC_VECTOR(6 downto 0);
    signal w_limite_35s: STD_LOGIC;
    signal w_bin_mux   : STD_LOGIC_VECTOR(6 downto 0);


begin

    -- 1. Instancia del Divisor de Reloj
    U1_DIV: divisor_reloj
        port map (
            clk_50 => clk_50,
            clk_1s => w_clk_1s
        );

    -- 2. Instancia del Contador de 35s
    U2_CNT35: contador_35s
        port map (
            clk_1s     => w_clk_1s,
            switch     => switch,
            segundos   => w_segundos,
            limite_35s => w_limite_35s
        );

    -- 3. Instancia del Tiempo Extra
    U3_CNTEXT: tiempo_extra
        port map (
            clk_1s     => w_clk_1s,
            switch     => switch,
            limite_35s => w_limite_35s,
            extra_seg  => w_extra_seg,
            alarma     => alarma_led
        );

    -- 4. Multiplexor para el display
    w_bin_mux <= w_extra_seg when (w_limite_35s = '1') else ('0' & w_segundos);

    -- 5. Instancia del Decodificador
    U4_DEC: hex_decoder
        port map (
            bin_in     => w_bin_mux,
            seg_dec    => seg_dec,
            seg_uni    => seg_uni
        );

end architecture arqui_top_control;