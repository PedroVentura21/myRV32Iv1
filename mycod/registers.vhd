library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
    port(
        clk, rst, we    : in std_logic;
        a1, a2, a3      : in std_logic_vector(4 downto 0);
        wd              : in std_logic_vector(31 downto 0);
        rd1, rd2        : out std_logic_vector(31 downto 0)
    );

end entity registers;

architecture behavior of registers is
    type Vreg is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : Vreg;
begin

    rd1 <= reg_file(to_integer(unsigned(a1)));
    rd2 <= reg_file(to_integer(unsigned(a2)));

    process(clk, rst)
    begin
        if (falling_edge(rst)) then
            reg_file <= (others => (others => '0'));
        
        elsif falling_edge(clk) then
            if(we = '1' and a3 /= "00000") then
                reg_file(to_integer(unsigned(a3))) <= wd;
            end if;
        end if;
    end process;
end architecture behavior;