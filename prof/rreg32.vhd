--------------------------------------------------------------------------------------
-- 32 bits Resettable Register                                                      --
-- myRISCVv1  											                            --
--														                            --
-- Prof. Max Santana  (2025)                                                        --
-- CEComp/Univasf                                                                   --
--------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity rreg32 is
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    d     : in std_logic_vector(31 downto 0);
    q	  : out std_logic_vector(31 downto 0)
  );
end rreg32;

architecture behavior of rreg32 is
begin
  process(clk, rst)
  begin
    if (falling_edge(rst)) then
      q <= (q'range => '0');      
	elsif (falling_edge(clk)) then
	  q <= d;
	end if;
  end process;
end behavior;