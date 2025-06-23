library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity registers is
    port(
        clk, we    : in std_logic;
        a1, a2, a3      : in std_logic_vector(4 downto 0);
        wd              : in std_logic_vector(31 downto 0);
        rd1, rd2        : out std_logic_vector(31 downto 0)
    );

end registers;

architecture behavior of registers is
    type reg is std_logic_vector(31 downto 0);
    type Vreg is array (0 to 31) of reg;

    signal reg_file : Vreg;
begin
    InitBank: process
        variable i : integer := 0;
    begin
        while i < 32 loop
            reg_file(i) <= x"00000000";
            i := i+1;
        end loop;
        wait;
    end process InitBank;

    rd1 <= reg_file(to_integer(unsigned(a1)));
    rd2 <= reg_file(to_integer(unsigned(a2)));

    process(clk)
    begin
        if (falling_edge(clk) and we = '1' end a3 /= "00000") then
            reg_file(to_integer(unsigned(a3))) <= wd;
        end if;
    end process;