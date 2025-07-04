library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
    port(
        -- sistema
        clk         : in std_logic;
        rst         : in std_logic;
        -- ROM
        PC          : out std_logic_vector(31 downto 0);
        instr       : in std_logic_vector(31 downto 0);
        -- RAM
        ALUResult   : out std_logic_vector(31 downto 0);
        memWrite_out: out std_logic;
        writeData   : out std_logic_vector(31 downto 0);
        readData    : in std_logic_vector(31 downto 0);
        -- Controller
        op          : out std_logic_vector(6 downto 0); -- opcode
        funct3      : out std_logic_vector(2 downto 0); -- funct3
        funct7      : out std_logic_vector(6 downto 0); -- funct7
        zero        : out std_logic;
        PCSrc,
        ALUSrc,
        memWrite_in,
        RegWrite    : in std_logic;
        ResultSrc,
        ImmSrc      : in std_logic_vector(1 downto 0);
        ALUControl  : in std_logic_vector(2 downto 0)
    );
end entity datapath;

architecture behavior of datapath is
    signal immExt   : std_logic_vector(31 downto 0);
    signal Result   : std_logic_vector(31 downto 0);
    signal ulaResult: std_logic_vector(31 downto 0);
    signal A, B     : std_logic_vector(31 downto 0);
    signal PCplus4  : std_logic_vector(31 downto 0);
begin
    IFE : entity work.ifetch
    port map (
        clk => clk, -- in_dp
        rst => rst, -- in_dp
        PCsrc => PCSrc, -- in_dp
        imm => immExt, -- signal
        PCcurt => PC, -- out_dp
        PCplus4 => PCplus4
    );

    ID : entity work.idecoder
    port map(
        clk => clk, -- in_dp
        rst => rst, -- in_dp
        -- ROM
        instr => instr, -- in_dp
        -- Controller
        op => op, -- out_dp
        funct3 => funct3, -- out_dp
        funct7 => funct7, -- out_dp
        we => RegWrite, -- in_dp
        immSrc => immSrc, -- in_dp
        -- DATAPATH
        rd1 => A, -- signal
        rd2 => B, -- signal
        immExt => immExt, -- signal
        wd => Result -- signal
    );

    EX : entity work.execute
    port map(
        -- Controller
        aluSrc => ALUSrc, -- in_dp
        aluControl => ALUControl, -- in_dp
        zero => Zero, -- out_dp
        -- DATAPATH
        a => A, -- signal
        b => B, -- signal
        c => immExt, -- signal
        result => ulaResult -- signal
    );

    MUX_3 : entity work.mux332
    port map(
        d0 => ulaResult, -- signal
        d1 => readData, -- in_dp
        d2 => PCplus4, -- signal
        s => ResultSrc, -- in_dp
        y => Result -- signal
    );

    -- saidas para a RAM
    memWrite_out <= memWrite_in;
    writeData <= B;
    ALUResult <= ulaResult;
end architecture behavior;