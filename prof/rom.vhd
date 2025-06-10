--------------------------------------------------------------------------------------
-- A simple read only memory de 64KBx8bits			                                --
-- myRISCVv1  											                            --
--														                            --
-- Prof. Max Santana  (2025)                                                        --
-- CEComp/Univasf                                                                   --
--------------------------------------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity rom is
  generic(	
    DATA_WIDTH   : integer := 8;
    ADDRESS_WIDTH: integer := 16;
    DEPTH        : integer := 65535
  );
  port(	
    a : in std_logic_vector(31 downto 0);
    rd: out std_logic_vector(31 downto 0)
  );
end entity rom;

architecture behavior of rom is
  -- use array to define the bunch of internal temporary signals
  type rom_type is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal imem : rom_type;
begin
  InitMem: process
    use std.textio.all;
    file f: text open read_mode is "myRISCV_example1.bin";
    variable l: line;
    variable value: std_logic_vector(DATA_WIDTH-1 downto 0);
    variable i: integer := 0;
  begin
    while not endfile(f) loop
      readline(f, l);
      read(l, value);
      imem(i) <= value;
      i:= i+1;
    end loop;
    wait;
  end process InitMem;
  
  process(a)
  begin
    rd(7 downto 0)   <= imem(to_integer(signed(a)));
    rd(15 downto 8)  <= imem(to_integer(signed(a))+1);
    rd(23 downto 16) <= imem(to_integer(signed(a))+2);
    rd(31 downto 24) <= imem(to_integer(signed(a))+3);
  end process;
end behavior;