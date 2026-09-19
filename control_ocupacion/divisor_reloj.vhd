library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisor_reloj is
    Port (
        clk_50 : in  STD_LOGIC; -- Reloj de entrada de 50 MHz de la tarjeta
        reset  : in  STD_LOGIC; -- Señal de reset (activo en bajo)
        clk_1s : out STD_LOGIC  -- Reloj de salida de 1 Hz (un ciclo por segundo)
    );
end entity divisor_reloj;

architecture arqui_divisor_reloj of divisor_reloj is
    -- 50,000,000 ciclos / 2 = 25,000,000 para alternar el estado cada medio segundo
    constant MAX_CNT : integer := 24999999;
    signal contador  : integer range 0 to MAX_CNT := 0;
    signal r_clk     : STD_LOGIC := '0';
begin

    process(clk_50, reset)
    begin
        if reset = '0' then
            contador <= 0;
            r_clk    <= '0';
        elsif rising_edge(clk_50) then
            if contador = MAX_CNT then
                contador <= 0;
                r_clk    <= not r_clk; -- Cambia de estado para generar la onda cuadrada de 1 Hz
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

    clk_1s <= r_clk;

end architecture arqui_divisor_reloj;