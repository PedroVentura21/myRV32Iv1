library IEEE;
use IEEE.std_logic_1164.all;

entity design is
    port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        PCsrc   : in  std_logic;
        imm     : in  std_logic_vector(31 downto 0);
        instr   : out std_logic_vector(31 downto 0)
    );
end entity design;

architecture behavior of design is
    signal pc : std_logic_vector(31 downto 0);
begin
    ifetch_inst : entity work.ifetch
    port map (
        clk    => clk,
        rst    => rst,
        PCsrc  => PCsrc,
        imm    => imm,
        PCcurt => pc
    );

    rom_inst : entity work.rom
    port map(
        a  => pc,
        rd => instr
    );
end architecture behavior;