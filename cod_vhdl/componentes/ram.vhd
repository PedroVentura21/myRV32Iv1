library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    generic(
        DATA_WIDTH    : integer := 8;
        ADDRESS_WIDTH : integer := 16;
        DEPTH         : integer := 65536
    );
    port (
        clk: in  std_logic;
        a  : in  std_logic_vector(31 downto 0);
        wd : in  std_logic_vector(31 downto 0);
        we : in  std_logic; -- write when 1, read when 0
        rd : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavior of ram is
    type ram_type is array (0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal dmem : ram_type := (others => (others => '0'));
begin
    process(clk)
        variable base_addr : integer;
    begin
        if falling_edge(clk) then
            -- pegando o valor do endereço contido nos 16 primeiros bits de 'a'
            base_addr := to_integer(unsigned(a(ADDRESS_WIDTH-1 downto 0)));

            -- Apenas executa a operação se o endereço base permitir que
            -- uma palavra inteira de 32 bits (4 bytes) caiba na memória.
            if base_addr < (DEPTH - 3) then
                if we = '1' then
                    -- Escrita síncrona
                    dmem(base_addr)   <= wd(7 downto 0);
                    dmem(base_addr+1) <= wd(15 downto 8);
                    dmem(base_addr+2) <= wd(23 downto 16);
                    dmem(base_addr+3) <= wd(31 downto 24);

                    rd <= wd;
                else
                    -- Leitura síncrona
                    rd(7 downto 0)   <= dmem(base_addr);
                    rd(15 downto 8)  <= dmem(base_addr+1);
                    rd(23 downto 16) <= dmem(base_addr+2);
                    rd(31 downto 24) <= dmem(base_addr+3);
                end if;
            else
                -- endereço inválido
                rd <= (others => '0');
            end if;
        end if;
    end process;
end behavior;