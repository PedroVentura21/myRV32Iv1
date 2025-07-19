-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end entity testbench;

architecture behavior of testbench is
	signal clock, reset		: std_logic := '0';
    constant clock_period	: time := 10 ns;
    
begin
	myRISCVv1: entity work.design port map (
    	clk => clock,
        rst => reset
    );
        
	clockGenerator : process
    begin
    	for i in 0 to 58 loop
        	clock <= '0';
            wait for clock_period/2;
            clock <= '1';
            wait for clock_period/2;
        end loop;
        wait;
    end process;
    
    process
    begin
    	reset <= '1';
        wait for 10 ns;
        reset <= '0';
    wait;
    end process;
end behavior;
