library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        ALUControl : in std_logic_vector(2 downto 0);
        A, B: in std_logic_vector(31 downto 0);
        Zero: out std_logic;
        ALUResult: out std_logic_vector(31 downto 0)
    );
end entity ALU;

architecture behavior of ALU is
    signal result : std_logic_vector(31 downto 0);
begin
    process(ALUControl, A, B)
    begin
        case ALUControl is
            -- 000: A + B (Soma)
            when "000" =>
                result <= std_logic_vector(signed(A) + signed(B));

            -- 001: A - B (Subtração)
            when "001" =>
                result <= std_logic_vector(signed(A) - signed(B));

            -- 010: A AND B
            when "010" =>
                result <= A and B;

            -- 011: A OR B
            when "011" =>
                result <= A or B;

            -- 100: XOR
            when "100" =>
                result <= A xor B;
                
            -- 101: SLT (Set on Less Than, com sinal)
            when "101" =>
                if signed(A) < signed(B) then
                    result <= x"00000001";
                else
                    result <= x"00000000";
                end if;
            -- Caso o ALUControl seja um valor inesperado
            when others =>
                result <= (others => 'X');
        end case;
    end process;
    
    zero <= '1' when result = x"00000000" else '0';
    ALUResult <= result;
end architecture behavior;