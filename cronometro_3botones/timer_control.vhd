library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_control is
    Port (
        clk_1hz  : in  STD_LOGIC; -- Señal de 1 Hz proveniente del divisor
        start    : in  STD_LOGIC;
        stop     : in  STD_LOGIC;
        reinicio : in  STD_LOGIC;
        minutos  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end timer_control;

architecture arqui_timer_control of timer_control is
    
	 signal corriendo : STD_LOGIC := '0'; --señal de control(remplaza la maquina de estado)
	 
	 signal s_min     : integer range 0 to 9 := 0;
    signal s_dsec    : integer range 0 to 5 := 0;
    signal s_usec    : integer range 0 to 9 := 0;
	 
begin 

    process(clk_1hz, reinicio)
    begin
        -- El reinicio es activo en bajo (si se presiona el botón, vale '0')
        if reinicio = '0' then
            corriendo <= '0';
            s_min     <= 0;
            s_dsec    <= 0;
            s_usec    <= 0;
        elsif rising_edge(clk_1hz) then
            
            -- Control independiente para Start y Stop
            if start = '0' then
                corriendo <= '1';
            end if;

            if stop = '0' then
                corriendo <= '0';
            end if;

            -- Lógica de conteo cuando el cronómetro está habilitado
            if corriendo = '1' then
                if s_usec = 9 then
                    s_usec <= 0;
                    if s_dsec = 5 then
                        s_dsec <= 0;
                        if s_min = 9 then
                            -- Tope máximo del cronómetro (9:59)
                            s_min  <= 9;
                            s_dsec <= 5;
                            s_usec <= 9;
                        else
                            s_min <= s_min + 1;
                        end if;
                    else
                        s_dsec <= s_dsec + 1;
                    end if;
                else
                    s_usec <= s_usec + 1;
                end if;
            end if;
            
        end if;
    end process;

    -- Conversión de enteros a vectores de 4 bits para los displays de 7 segmentos
    minutos <= std_logic_vector(to_unsigned(s_min, 4));
    seg_dec <= std_logic_vector(to_unsigned(s_dsec, 4));
    seg_uni <= std_logic_vector(to_unsigned(s_usec, 4));

end architecture arqui_timer_control;