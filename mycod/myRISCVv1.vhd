library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity myRISCVv1 is
    port(
        -- sistema
        clk : in std_logic;
        rst : in std_logic;
        -- rom
        PC : out std_logic_vector(31 downto 0);
        Instr: in std_logic_vector(31 downto 0);
        -- ram
        ALUResult : out std_logic_vector(31 downto 0);
        MemWrite : out std_logic;
        WriteData : out std_logic_vector(31 downto 0);
        ReadData : in std_logic_vector(31 downto 0)
    );
end entity myRISCVv1;

architecture behavior of myRISCVv1 is
    signal op, funct7 : std_logic_vector(6 downto 0);
    signal funct3, aluControl : std_logic_vector(2 downto 0);
    signal zero, PCsrc, aluSrc, we, RegWrite: std_logic;
    signal ResultSrc, immSrc: std_logic_vector(1 downto 0);
    signal ALUResult_s : std_logic_vector(31 downto 0);
begin

    DATAPATH : entity work.datapath
    port map(
        -- sistema
        clk => clk, -- myRV_in
        rst => rst, -- myRV_in
        -- rom
        PC => PC, -- myRV_out
        instr => Instr, -- myRV_in
        -- ram
        ALUResult => ALUResult_s, -- myRV_out
        MemWrite_out => MemWrite, -- myRV_out
        WriteData => WriteData, -- myRV_out
        ReadData => ReadData, -- myRV_in
        -- controller (tudo signal)
        op => op,
        funct3 => funct3,
        funct7 => funct7,
        zero => zero,
        PCSrc => PCsrc,
        ResultSrc => ResultSrc,
        MemWrite_in => we,
        ALUSrc => aluSrc,
        immSrc => immSrc,
        regWrite => regWrite,
        ALUControl => ALUControl
    );

    CONTROLLER : entity work.controller
    port map(
        -- datapath (tudo signal)
        op => op,
        funct3 => funct3,
        funct7 => funct7,
        zero => zero,
        PCSrc => PCsrc,
        resultSrc => ResultSrc,
        MemWrite => we,
        aluSrc => aluSrc,
        immSrc => immSrc,
        regWrite => regWrite,
        aluControl => ALUControl
    );

    -- gabiarra temporaria:
    -- o 'to_integer(unsigned(a))' da ram esta lendo 'signed' e dando erro...
    ALUResult <=
        ALUResult_s 
            when to_integer(signed(ALUResult_s)) > 0 else
        (others => '0');
end architecture behavior;