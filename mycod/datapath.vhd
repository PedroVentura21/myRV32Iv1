library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        PC          : out std_logic_vector(31 downto 0);
        instr       : in std_logic_vector(31 downto 0);
        ALUResult   : out std_logic_vector(31 downto 0);
        we          : out std_logic_vector(31 downto 0);
        wd          : out std_logic_vector(31 downto 0);
        rd          : in std_logic_vector(31 downto 0);
        
        regwrite    : in std_logic; -- control (regwrite)
        immSrc      : in std_logic_vector(1 downto 0); -- control signal (immSrcs)
        memwrite    : in std_logic_vector(31 downto 0); -- write data
        op          : out std_logic_vector(6 downto 0); -- opcode
        funct3      : out std_logic_vector(2 downto 0); -- funct3
        funct7      : out std_logic_vector(6 downto 0); -- funct7
        zero        : out std_logic;
    );
end datapath;

architecture behavior of datapath is
    signal PCCurt   : std_logic_vector(31 downto 0);
    signal instr    : std_logic_vector(31 downto 0);
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal instr    : std_logic_vector(31 downto 0); -- instruction
    signal we       : std_logic; -- control signal (regwrite)
    signal immSrc   : std_logic_vector(1 downto 0); -- control signal (immSrcs)
    signal wd       : std_logic_vector(31 downto 0); -- write data
    signal op       : std_logic_vector(6 downto 0); -- opcode
    signal funct3   : std_logic_vector(2 downto 0); -- funct3
    signal funct7   : std_logic_vector(6 downto 0); -- funct7
    signal rd1      : std_logic_vector(31 downto 0); -- Read data 1
    signal rd2      : std_logic_vector(31 downto 0); -- Read data 2
    signal immExt   : std_logic_vector(31 downto 0) -- Immediate extend

begin
    ifetch : entity work.ifetch
    port map (
        clk => clk,
        rst => rst,
        PCsrc => PCsrc
    );

    ROM : entity work.rom
    port map(
        a => ;

    );