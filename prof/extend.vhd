--------------------------------------------------------------------------------------
-- Extend unit                                                                      --
-- myRISCVv1  											                            --
--														                            --
-- Prof. Max Santana  (2025)                                                        --
-- CEComp/Univasf                                                                   --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity extend is
  port(
    imm   : in std_logic_vector(24 downto 0);  -- imm
    immSrc: in std_logic_vector(1 downto 0);   -- control signal (immSrcs)
    immExt: out std_logic_vector(31 downto 0); -- Immediate extend    
  );
end extend;

architecture behavior of extend is
begin
  process(imm, immSrc) begin
    case immSrc is
      --I–type
      when "00" =>
        immExt <= (31 downto 12 => imm(24)) & imm(24 downto 13);
      --S–types (stores)
      when "01" =>
        immExt <= (31 downto 12 => imm(24)) & imm(24 downto 18) & imm(4 downto 0);
      --B–type (branches)
      when "10" =>
        immExt <= (31 downto 12 => imm(24)) & imm(0) & imm(23 downto 18) & imm(4 downto 1) & '0';
      --J–type (jal)
      when "11" =>
        immExt <= (31 downto 20 => imm(24)) & imm(12 downto 5) & imm(13) & imm(23 downto 14) & '0';
      when others =>
        immExt <= (31 downto 0 => '-');
    end case;
  end process;
end;