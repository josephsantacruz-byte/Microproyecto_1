library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_35s is
    Port (
        clk_1s     : in  STD_LOGIC; -- Pulso de 1 segundo proveniente del divisor
        switch     : in  STD_LOGIC; -- El único switch de control
        segundos   : out STD_LOGIC_VECTOR(5 downto 0); -- Valor actual para los displays
        limite_35s : out STD_LOGIC  -- Bandera que avisa si llegó a 35 segundos
    );
end entity contador_35s;

architecture arqui_contador_35s of contador_35s is
    signal cuenta_reg      : integer range 0 to 63 := 0;
    signal switch_anterior : STD_LOGIC := '0';
begin

    process(clk_1s)
    begin
        if rising_edge(clk_1s) then
            -- Guardamos el estado anterior del switch para detectar el cambio
            switch_anterior <= switch;

            -- Detección de flanco de subida (el switch pasa de 0 a 1)
            if (switch = '1' and switch_anterior = '0') then
                cuenta_reg <= 0; -- Se reinicia y arranca un nuevo conteo
                
            -- Si el switch se mantiene arriba ('1'), sigue contando hasta 35
            elsif switch = '1' then
                if cuenta_reg < 35 then
                    cuenta_reg <= cuenta_reg + 1;
                end if;
                
            -- Si el switch está abajo ('0'), se congela el valor actual
            else
                cuenta_reg <= cuenta_reg; 
            end if;
        end if;
    end process;

    -- Salidas del módulo
    segundos   <= std_logic_vector(to_unsigned(cuenta_reg, 6));
    limite_35s <= '1' when cuenta_reg = 35 else '0';

end architecture arqui_contador_35s;