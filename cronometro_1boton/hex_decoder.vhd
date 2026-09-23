library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hex_decoder is
    Port (
        bin_in     : in  STD_LOGIC_VECTOR(6 downto 0); -- Número de entrada (0 a 99)
        seg_dec    : out STD_LOGIC_VECTOR(6 downto 0); -- Display para las Decenas (abcdefg)
        seg_uni    : out STD_LOGIC_VECTOR(6 downto 0)  -- Display para las Unidades (abcdefg)
    );
end entity hex_decoder;

architecture arqui_hex_decoder of hex_decoder is
    -- Función auxiliar para convertir un dígito de 0 a 9 al código de 7 segmentos
    -- (Asume displays de Cátodo Común: un '0' enciende el segmento)
    function convertir_7seg(digito : integer) return STD_LOGIC_VECTOR is
    begin
        case digito is
            when 0 => return "1000000"; -- '0'
            when 1 => return "1111001"; -- '1'
            when 2 => return "0100100"; -- '2'
            when 3 => return "0110000"; -- '3'
            when 4 => return "0011001"; -- '4'
            when 5 => return "0010010"; -- '5'
            when 6 => return "0000010"; -- '6'
            when 7 => return "1111000"; -- '7'
            when 8 => return "0000000"; -- '8'
            when 9 => return "0010000"; -- '9'
            when others => return "1111111"; -- Apagado por seguridad
        end case;
    end function;

begin

    process(bin_in)
        variable valor_int : integer;
        variable decenas   : integer;
        variable unidades  : integer;
    begin
        valor_int := to_integer(unsigned(bin_in));
        
        -- Separamos en decenas y unidades matemáticamente
        decenas   := valor_int / 10;
        unidades  := valor_int mod 10;
        
        -- Mapeamos a los segmentos de los displays
        seg_dec <= convertir_7seg(decenas);
        seg_uni <= convertir_7seg(unidades);
    end process;

end architecture arqui_hex_decoder;