library ieee;
use ieee.std_logic_1164.all;

entity design is
    port(
        clk: in std_logic;
        rst: in std_logic
    );
end entity design;

architecture behavior of design is
    -- rom
    signal pc, instr : std_logic_vector(31 downto 0);
    -- ram
    signal a, wd, rd : std_logic_vector(31 downto 0);
    signal we : std_logic;
begin

    IM : entity work.rom
    port map(
        -- RV
        a => pc,
        rd => instr
    );

    DM : entity work.ram
    port map(
        -- sistema
        clk => clk,
        -- RV
        a => a,
        wd => wd,
        we => we,
        rd => rd
    );

    myRV : entity work.myRISCVv1
    port map(
        -- sistema
        clk => clk,
        rst => rst,
        -- IM
        PC => pc,
        Instr => instr,
        -- DM
        ALUResult => a,
        MemWrite => we,
        WriteData => wd,
        ReadData => rd
    );
end architecture behavior;