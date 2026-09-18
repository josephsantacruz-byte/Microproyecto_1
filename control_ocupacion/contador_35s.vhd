library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_35s is
    Port (
        clk_1s         : in  STD_LOGIC; -- Pulso de 1 segundo
        reset          : in  STD_LOGIC; -- Reset general (activo en bajo)
        enable         : in  STD_LOGIC; -- Interruptor de ocupación (1 = ocupado, 0 = libre/congelar)
        segundos       : out STD_LOGIC_VECTOR(5 downto 0); -- Valor actual del conteo (hasta 35 en binario)
        limite_35s     : out STD_LOGIC  -- Bandera que indica si se llegó a los 35 segundos
    );
end entity contador_35s;

architecture Behavioral of contador_35s is
    signal cuenta_reg : integer range 0 to 63 := 0;
begin

    process(clk_1s, reset)
    begin
        if reset = '0' then
            cuenta_reg <= 0;
        elsif rising_edge(clk_1s) then
            if enable = '1' then
                -- Si no hemos llegado al límite de 35, seguimos contando
                if cuenta_reg < 35 then
                    cuenta_reg <= cuenta_reg + 1;
                end if;
            else
                -- Si el enable pasa a '0', la palanca bajó: se congela el valor
                cuenta_reg <= cuenta_reg; 
            end if;
        end if;
    end process;

    -- Salida del valor en binario/vector para los displays o decodificadores
    segundos <= std_logic_vector(to_unsigned(cuenta_reg, 6));

    -- Activamos la bandera si el conteo llegó a 35
    limite_35s <= '1' when cuenta_reg = 35 else '0';

end architecture Behavioral;