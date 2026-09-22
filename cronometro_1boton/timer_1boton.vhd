library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_1boton is
    Port (
        clk_1s   : in  STD_LOGIC;
        btn      : in  STD_LOGIC; -- Activo en bajo ('0' cuando se presiona)
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
    
    signal contador_presion   : integer range 0 to 3 := 0;
    signal btn_anterior       : STD_LOGIC := '1';

begin

    process(clk_1s)
    begin
        if rising_edge(clk_1s) then
            
            -- Detección de flanco del botón (activo en bajo)
            if btn = '0' then
                contador_presion <= contador_presion + 1;
                
                -- Si se mantiene presionado 2 segundos -> RESET
                if contador_presion >= 2 then
                    corriendo <= '0';
                    s_min     <= 0;
                    s_dsec    <= 0;
                    s_usec    <= 0;
                end if;
            else
                -- Si se soltó el botón y fue una pulsación corta (< 2s)
                if contador_presion > 0 and contador_presion < 2 then
                    corriendo <= not corriendo; -- Alterna entre Start y Stop
                end if;
                
                contador_presion <= 0;
            end if;

            -- Lógica de conteo cuando está corriendo
            if corriendo = '1' then
                if s_usec = 9 then
                    s_usec <= 0;
                    if s_dsec = 5 then
                        s_dsec <= 0;
                        if s_min = 9 then
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

    minutos <= std_logic_vector(to_unsigned(s_min, 4));
    seg_dec <= std_logic_vector(to_unsigned(s_dsec, 4));
    seg_uni <= std_logic_vector(to_unsigned(s_usec, 4));

end architecture arqui_timer_1boton;