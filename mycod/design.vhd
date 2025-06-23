library IEEE;
use IEEE.std_logic_1164.all;

entity design is
    port(
        clk : std_logic;
        rst : std_logic
    );
end entity design;

architecture behavior of design is
    signal pc       : std_logic_vector(31 downto 0);
    signal instr    : std_logic_vector(31 downto 0);
    signal PCsrc    : std_logic := '1';
    signal imm      : std_logic_vector(31 downto 0);
    -- signal we       : std_logic; -- control signal (regwrite)
    -- signal immSrc   : std_logic_vector(1 downto 0); -- control signal (immSrcs)
    -- signal wd       : std_logic_vector(31 downto 0); -- write data
    -- signal op       : std_logic_vector(6 downto 0); -- opcode
    -- signal funct3   : std_logic_vector(2 downto 0); -- funct3
    -- signal funct7   : std_logic_vector(6 downto 0); -- funct7
    -- signal rd1      : std_logic_vector(31 downto 0); -- Read data 1
    -- signal rd2      : std_logic_vector(31 downto 0); -- Read data 2
    -- signal immExt   : std_logic_vector(31 downto 0) -- Immediate extend

begin
        ifetch : entity work.ifetch
        port map (
            clk => clk,
            rst => rst,
            PCsrc => PCsrc,
            imm => imm,
            PCcurt => pc
        );

        ROM : entity work.rom
        port map(
            a => pc,
            rd => instr
        );
end architecture behavior;