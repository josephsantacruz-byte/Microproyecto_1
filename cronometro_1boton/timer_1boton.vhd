library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_1boton is
    Port (
        clk_1hz  : in  STD_LOGIC; -- Reloj de 1 Hz proveniente del divisor
        btn      : in  STD_LOGIC; -- Único botón (activo en bajo: '0' al presionarse)
        minutos  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end timer_1boton;

architecture arqui_timer_1boton of timer_1boton is
    
    signal corriendo          : STD_LOGIC := '0';
    signal s_min              : integer range 0 to 9 := 0;
    signal s_dsec             : integer range 0 to 5 := 0;
    signal s_usec             : integer range 0 to 9 := 0;
    
    -- Contador auxiliar para medir cuántos segundos lleva presionado el botón
    signal contador_presion   : integer range 0 to 3 := 0;

begin

    process(clk_1hz)
    begin
        if rising_edge(clk_1hz) then
            
            -- Lógica del botón único (activo en bajo en la tarjeta DE0)
            if btn = '0' then
                contador_presion <= contador_presion + 1;
                
                -- Si se mantiene presionado 2 segundos o más -> REINICIO GLOBAL
                if contador_presion >= 2 then
                    corriendo <= '0';
                    s_min     <= 0;
                    s_dsec    <= 0;
                    s_usec    <= 0;
                end if;
                
            else
                -- El usuario soltó el botón (vuelve a '1')
                if contador_presion > 0 and contador_presion < 2 then
                    -- Pulsación corta (< 2s): Alternar entre Start y Stop (Toggle)
                    corriendo <= not corriendo;
                end if;
                
                -- Limpiamos el medidor de presión al soltar el botón
                contador_presion <= 0;
            end if;

            -- Lógica de conteo normal cuando el cronómetro está habilitado
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

    -- Conversión final a vectores de 4 bits para los decodificadores de 7 segmentos
    minutos <= std_logic_vector(to_unsigned(s_min, 4));
    seg_dec <= std_logic_vector(to_unsigned(s_dsec, 4));
    seg_uni <= std_logic_vector(to_unsigned(s_usec, 4));

end architecture arqui_timer_1boton;