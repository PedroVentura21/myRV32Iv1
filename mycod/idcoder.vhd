library ieee;
use ieee.std_logic_1164.all;

entity idecoder is
    port(
        clk: in std_logic;
        rst: in std_logic;
        instr : in std_logic_vector(31 downto 0); -- instruction
        we: in std_logic; -- control signal (regwrite)
        immSrc: in std_logic_vector(1 downto 0); -- control signal (immSrcs)
        wd: in std_logic_vector(31 downto 0); -- write data
        op: out std_logic_vector(6 downto 0); -- opcode
        funct3: out std_logic_vector(2 downto 0); -- funct3
        funct7: out std_logic_vector(6 downto 0); -- funct7
        rd1: out std_logic_vector(31 downto 0); -- Read data 1
        rd2: out std_logic_vector(31 downto 0); -- Read data 2
        immExt: out std_logic_vector(31 downto 0) -- Immediate extend
    );
end idecoder ;

architecture behavior of idecoder is
    signal imm          : std_logic_vector(24 downto 0);
    signal rs1, rs2, rd : std_logic_vector(4 downto 0);

    component registers
        port(
            clk, we         : in std_logic;
            a1, a2, a3      : in std_logic_vector(4 downto 0);
            wd              : in std_logic_vector(31 downto 0);
            rd1, rd2        : out std_logic_vector(31 downto 0)
        );
    end component;

    component extend
        port(
            imm   : in std_logic_vector(24 downto 0);  -- imm
            immSrc: in std_logic_vector(1 downto 0);   -- control signal (immSrcs)
            immExt: out std_logic_vector(31 downto 0) -- Immediate extend    
        );
    end component;
begin
    op <= instr(6 downto 0);
    imm <= instr(31 downto 7);
    rd <= instr(11 downto 7);
    rs1 <= instr(19 downto 15);
    rs2 <= instr(24 downto 20);
    funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);
    
    extend : extend
    port map(
        imm => imm,
        immSrc => immSrc,
        immExt => immExt
    );

    reg_file : registers
    port map(
        clk => clk,
        we => we,
        wd => wd,
        a1 => rs1,
        a2 => rs2,
        a3 => rd,
        rd1 => rd1,
        rd2 => rd2

    );
end;