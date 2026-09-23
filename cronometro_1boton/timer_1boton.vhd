library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer_1boton is
    Port (
        clk_1s       : in  STD_LOGIC;                    -- Reloj de 1 Hz
        btn          : in  STD_LOGIC;                    -- Botón (Start / Stop / Reset)
        bin_minutos  : out STD_LOGIC_VECTOR(6 downto 0); -- Valor entero de minutos
        bin_segundos : out STD_LOGIC_VECTOR(6 downto 0)  -- Valor entero de segundos
    );
end entity timer_1boton;

architecture arqui_timer_1boton of timer_1boton is

    signal estado_corriendo : boolean := false;
    signal toggle_btn       : boolean := false;  -- Estado alternado de Start/Stop al presionar
    signal reset_manual     : boolean := false;  -- Bandera activada tras presionar 2 segundos
    
    signal cnt_segundos_btn : integer range 0 to 3 := 0;
    
    signal seg_cnt          : integer range 0 to 59 := 0;
    signal min_cnt          : integer range 0 to 9 := 0;

begin

    ------------------------------------------------------------------
    -- 1. CONTROL ASÍNCRONO DE START / STOP (INMEDIATO)
    --    Cambia el estado con un clic rápido sin esperar al reloj.
    --    Se asume que 'btn = 0' es el estado presionado (activo en bajo).
    ------------------------------------------------------------------
    process(btn, reset_manual)
    begin
        if reset_manual then
            toggle_btn <= false;
        elsif falling_edge(btn) then
            toggle_btn <= not toggle_btn;
        end if;
    end process;

    -- El estado de marcha se habilita si se presionó Start y no hay Reset
    estado_corriendo <= toggle_btn and not reset_manual;


    ------------------------------------------------------------------
    -- 2. CONTROL SÍNCRONO (CONTEO DE 2 SEGUNDOS Y CRONÓMETRO A 1 HZ)
    ------------------------------------------------------------------
    process(clk_1s)
    begin
        if rising_edge(clk_1s) then
            
            -- Medición de tiempo presionado (Asumiendo activo en bajo: btn = '0')
            if btn = '0' then
                if cnt_segundos_btn < 2 then
                    cnt_segundos_btn <= cnt_segundos_btn + 1;
                end if;
            else
                cnt_segundos_btn <= 0;
                reset_manual     <= false;
            end if;

            -- Si se mantiene presionado 2 segundos -> REINICIO
            if cnt_segundos_btn >= 2 then
                seg_cnt      <= 0;
                min_cnt      <= 0;
                reset_manual <= true; -- Limpia el estado toggle_btn
            
            -- Conteo regular de minutos y segundos si está corriendo
            elsif estado_corriendo then
                if seg_cnt = 59 then
                    seg_cnt <= 0;
                    if min_cnt = 9 then
                        min_cnt <= 0;
                    else
                        min_cnt <= min_cnt + 1;
                    end if;
                else
                    seg_cnt <= seg_cnt + 1;
                end if;
            end if;

        end if;
    end process;

    -- Asignación de salidas binarias de 7 bits
    bin_minutos  <= std_logic_vector(to_unsigned(min_cnt, 7));
    bin_segundos <= std_logic_vector(to_unsigned(seg_cnt, 7));

end architecture arqui_timer_1boton;