library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
    type estado_t is (REPOSO, CONTANDO, PAUSA);
    signal estado_actual : estado_t := REPOSO;

    -- Señales internas de conteo
    signal s_min  : integer range 0 to 9 := 0;
    signal s_dsec : integer range 0 to 5 := 0;
    signal s_usec : integer range 0 to 9 := 0;
begin

    process(clk_1hz, reinicio)
    begin
        if reinicio = '1' then
            estado_actual <= REPOSO;
            s_min  <= 0;
            s_dsec <= 0;
            s_usec <= 0;
        elsif rising_edge(clk_1hz) then
            -- Máquina de estados con protección contra re-pulsado del mismo botón
            case estado_actual is
                when REPOSO =>
                    s_min  <= 0;
                    s_dsec <= 0;
                    s_usec <= 0;
                    if start = '1' then
                        estado_actual <= CONTANDO;
                    end if;

                when CONTANDO =>
                    if stop = '1' then
                        estado_actual <= PAUSA;
                    else
                        -- Lógica de incremento del temporizador (0:00 hasta 9:59)
                        if s_usec = 9 then
                            s_usec <= 0;
                            if s_dsec = 5 then
                                s_dsec <= 0;
                                if s_min = 9 then
                                    -- Límite máximo alcanzado (9:59), se congela
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

                when PAUSA =>
                    if start = '1' then
                        estado_actual <= CONTANDO;
                    end if;
            end case;
        end if;
    end process;

    -- Conversión a vectores de 4 bits para los displays
    minutos <= conv_std_logic_vector(s_min, 4);
    seg_dec <= conv_std_logic_vector(s_dsec, 4);
    seg_uni <= conv_std_logic_vector(s_usec, 4);

end arqui_timer_control;