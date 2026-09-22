library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_1boton is
    Port (
        clk_50   : in  STD_LOGIC; -- Reloj principal de la tarjeta (50 MHz)
        clk_1s   : in  STD_LOGIC; -- Pulso de habilitación de 1 Hz (o se puede generar internamente)
        btn      : in  STD_LOGIC; -- Botón proveniente del top
        minutos  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_dec  : out STD_LOGIC_VECTOR (3 downto 0);
        seg_uni  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end timer_1boton;

architecture Behavioral of timer_1boton is
    
    signal corriendo          : STD_LOGIC := '0';
    signal s_min              : integer range 0 to 9 := 0;
    signal s_dsec             : integer range 0 to 5 := 0;
    signal s_usec             : integer range 0 to 9 := 0;
    
    -- Señales para la detección de flanco del botón y sincronización de clk_1s
    signal btn_s1, btn_s2     : STD_LOGIC := '0';
    signal clk_1s_s1, clk_1s_s2 : STD_LOGIC := '0';

begin

    -- Proceso único sincronizado a 50 MHz (Evita problemas de múltiples relojes)
    process(clk_50)
    begin
        if rising_edge(clk_50) then
            -- 1. Sincronización del botón para evitar metaestabilidad y antirrebote básico
            btn_s1 <= btn;
            btn_s2 <= btn_s1;
            
            -- Detección de flanco de subida del botón
            if btn_s1 = '1' and btn_s2 = '0' then
                corriendo <= not corriendo;
            end if;

            -- 2. Sincronización del pulso de 1 segundo para detectarlo limpiamente a 50 MHz
            clk_1s_s1 <= clk_1s;
            clk_1s_s2 <= clk_1s_s1;

            -- 3. Lógica del cronómetro gobernada por el flanco de subida del tick de 1s
            if (clk_1s_s1 = '1' and clk_1s_s2 = '0') then -- Detecta el inicio de cada segundo
                if corriendo = '1' then
                    if s_usec = 9 then
                        s_usec <= 0;
                        if s_dsec = 5 then
                            s_dsec <= 0;
                            if s_min = 9 then
                                s_min <= 0;
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

        end if;
    end process;

    -- Conversión a vectores de 4 bits
    minutos <= std_logic_vector(to_unsigned(s_min, 4));
    seg_dec <= std_logic_vector(to_unsigned(s_dsec, 4));
    seg_uni <= std_logic_vector(to_unsigned(s_usec, 4));

end architecture Behavioral;