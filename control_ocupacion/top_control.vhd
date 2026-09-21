library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sistema_paquete.all;

entity top_control is
    Port (
        clk_50     : in  STD_LOGIC;                      
        switch     : in  STD_LOGIC;
		  reset      : in  STD_LOGIC;
        alarma_led : out STD_LOGIC;  
		  felicitacion_led  : out STD_LOGIC;
        -- Primer par de displays (Contador 0-35s)
        seg_35_dec : out STD_LOGIC_VECTOR(6 downto 0);     
        seg_35_uni : out STD_LOGIC_VECTOR(6 downto 0);
        -- Segundo par de displays (Tiempo extra 0-99s)
        seg_ex_dec : out STD_LOGIC_VECTOR(6 downto 0);     
        seg_ex_uni : out STD_LOGIC_VECTOR(6 downto 0)      
    );
end entity top_control;

architecture Behavioral of top_control is

    -- Señales internas de interconexión
    signal w_clk_1s    : STD_LOGIC;
    signal w_segundos  : STD_LOGIC_VECTOR(5 downto 0);
    signal w_extra_seg : STD_LOGIC_VECTOR(6 downto 0);
    signal w_limite_35s: STD_LOGIC;

begin
    felicitacion_led <= '1' when (switch = '0' and unsigned(w_segundos) > 0 and unsigned(w_segundos) < 35) else '0';

    -- 1. Instancia del Divisor de Reloj
    U1_DIV: divisor_reloj

        port map (
            clk_50 => clk_50,
				reset  => reset,
            clk_1s => w_clk_1s
        );

    -- 2. Instancia del Contador de 35s (Primer par)
    U2_CNT35: contador_35s
        port map (
            clk_1s     => w_clk_1s,
            switch     => switch,
            segundos   => w_segundos,
            limite_35s => w_limite_35s
        );

    -- 3. Instancia del Tiempo Extra y Alarma (Segundo par)
    U3_CNTEXT: tiempo_extra
        port map (
            clk_1s     => w_clk_1s,
            switch     => switch,
            limite_35s => w_limite_35s,
            extra_seg  => w_extra_seg,
            alarma     => alarma_led
        );

    -- 4. Decodificador para el primer par (0 a 35s)
    U4_DEC35: hex_decoder
        port map (
            bin_in     => "0" & w_segundos, -- Convertimos de 6 bits a 7 bits para el decodificador
            seg_dec    => seg_35_dec,
            seg_uni    => seg_35_uni
        );

    -- 5. Decodificador para el segundo par (Tiempo extra 0 a 99s)
    U5_DECEX: hex_decoder
        port map (
            bin_in     => w_extra_seg,
            seg_dec    => seg_ex_dec,
            seg_uni    => seg_ex_uni
        );

end architecture Behavioral;