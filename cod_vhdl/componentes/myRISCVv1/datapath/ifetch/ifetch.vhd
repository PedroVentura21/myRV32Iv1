library IEEE;
use IEEE.std_logic_1164.all;

entity ifetch is
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        PCsrc   : in std_logic_vector(1 downto 0);
        imm     : in std_logic_vector(31 downto 0);
        PCjalr  : in std_logic_vector(31 downto 0);
        PCcurt  : out std_logic_vector(31 downto 0);
        PCplus4 : out std_logic_vector(31 downto 0)
    );
end entity ifetch;

architecture behavior of ifetch is
    constant num4   : std_logic_vector(31 downto 0) := x"00000004";
    signal PCnext   : std_logic_vector(31 downto 0);
    signal PCnew    : std_logic_vector(31 downto 0);
    signal PCplus4_s  : std_logic_vector(31 downto 0);
    signal PCtarget : std_logic_vector(31 downto 0);

begin
    MUX_1 : entity work.mux332 
        port map(
            d0 => PCplus4_s,
            d1 => PCtarget,
            -- Existe um componente que deixa o LSB como 0 para garantir
            -- que o novo PC retornado pela instr. 'jalr' seja múltiplo de 2
            d2 => (PCjalr(31 downto 1) & '0'), 
            s => PCsrc,
            y => PCnext
        );

    PC : entity work.rreg32
        port map(
            clk => clk,
            rst => rst,
            d   => PCnext,
            q	=> PCnew
        );

    PLUS4 : entity work.adder32
        port map(
            a => PCnew,
            b => num4,
            s => PCplus4_s
        );

    target : entity work.adder32
        port map(
            a => PCnew,
            b => imm,
            s => PCtarget
        );

    -- saidas
    PCcurt <= PCnew;
    PCplus4 <= PCplus4_s;
end architecture behavior;