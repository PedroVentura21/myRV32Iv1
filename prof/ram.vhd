--------------------------------------------------------------------------------------
-- A simple Random Access Memory de 64KBx8bits			                            --
-- myRISCVv1  											                            --
--														                            --
-- Prof. Max Santana  (2025)                                                        --
-- CEComp/Univasf                                                                   --
--------------------------------------------------------------------------------------

------------- $sp (0x0000FFFF)
-- dynamic --
-- data    --
-------------     (0x00008000)
-- Global  --
-- data    --
------------- $gp (0x00000000)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity ram is
  generic(	
    DATA_WIDTH		: integer := 8;
    ADDRESS_WIDTH	: integer := 16;
    DEPTH			: integer := 65535;
  );
  port (
       clk: in std_logic;
       a  : in std_logic_vector(31 downto 0);
       wd : in std_logic_vector(31 downto 0);
       we : in std_logic; -- write when 1, read when 0
       rd : out std_logic_vector(31 downto 0)
       );
end entity;

architecture behavior of ram is
  type ram_type is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal dmem : ram_type;
begin
  process(clk, a, we)
  begin
    if (falling_edge(clk) and we = '1') then
     	dmem(to_integer(unsigned(a))) <= wd(7 downto 0);
     	dmem(to_integer(unsigned(a))+1) <= wd(15 downto 8);
    	dmem(to_integer(unsigned(a))+2) <= wd(23 downto 16);
    	dmem(to_integer(unsigned(a))+3) <= wd(31 downto 24);
    elsif (falling_edge(clk) and we = '0') then
    	rd(7 downto 0)   <= dmem(to_integer(unsigned(a)));
      	rd(15 downto 8)  <= dmem(to_integer(unsigned(a))+1);
      	rd(23 downto 16) <= dmem(to_integer(unsigned(a))+2);
      	rd(31 downto 24) <= dmem(to_integer(unsigned(a))+3);
    end if;
  end process;
end behavior;
