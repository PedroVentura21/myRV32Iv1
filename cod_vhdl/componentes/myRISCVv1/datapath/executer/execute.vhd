library ieee;
use ieee.std_logic_1164.all;

entity execute is
    port(
        aluSrc : in std_logic;
        aluControl : in std_logic_vector(2 downto 0);
        a, b, c : in std_logic_vector(31 downto 0);
        zero : out std_logic;
        result : out std_logic_vector(31 downto 0)
    );
end entity execute;

architecture behavior of execute is
    signal srcB : std_logic_vector(31 downto 0);
begin
        MUX_2 : entity work.mux232
        port map(
            d0 => b,
            d1 => c,
            s => aluSrc,
            y => srcB
        );

        ULA : entity work.ALU
        port map(
            ALUControl => aluControl,
            A => a,
            B => srcB,
            Zero => zero,
            ALUResult => result
        );
end architecture behavior;