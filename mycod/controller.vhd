library ieee;
use ieee.std_logic_1164.all;

entity controller is
  port(
    op          : in std_logic_vector(6 downto 0);
    funct3      : in std_logic_vector(2 downto 0);
    funct7      : in std_logic_vector(6 downto 0);
    zero        : in std_logic;
    resultSrc   : out std_logic_vector(1 downto 0);
    memWrite    : out std_logic;
    PCSrc       : out std_logic_vector(1 downto 0);
    aluSrc      : out std_logic;
    regWrite    : out std_logic;
    immSrc      : out std_logic_vector(1 downto 0);
    aluControl  : out std_logic_vector(2 downto 0)
  );
end;
architecture behavior of controller is
  signal aluOp   : std_logic_vector(1 downto 0);
  signal RtypeSub: std_logic;
  signal comandos: std_logic_vector(10 downto 0);
  -- composição dos bits de 'comandos':
  -- (regWrite, immSrc(1), immSrc(0), aluSrc, memWrite, resultSrc(1), resultSrc(0), PCSrc(1), PCSrc(0), aluOp(1), aluOp(0))
begin

  mainDecoder: process(op, funct3)
  begin    
    case op is
      when "0000011" =>   -- lw
        comandos <= "10010010000";
        
      when "0100011" =>   -- sw
        comandos <= "00111000000"; -- resultSrc era 'xx'
        
      when "0110011" =>   -- R-type
        comandos <= "10000000010"; -- immSrc era 'xx'
        
      when "1100011" =>   -- beq or bne
        comandos <= "01000000001"; -- resultSrc era 'xx'

        if funct3 = "000" then
          comandos(2) <= zero; -- beq
        else
          comandos(2) <= (not zero); -- bne
        end if;
        
      when "0010011" =>   -- I-type (ALU)
        comandos <= "10010000010";

      when "1101111" =>   -- Jal
        comandos <= "11110100100"; -- aluSrc era 'x', aluOp era 'xx'

      when "1100111" =>   -- Jalr
        comandos <= "10010101000";

      when others =>
        comandos <= (others => '0'); -- Todos os campos eram 'x'
    end case;
  end process;
  
  (regWrite, immSrc(1), immSrc(0), aluSrc, memWrite, resultSrc(1), 
  resultSrc(0), PCsrc(1), PCsrc(0), aluOp(1), aluOp(0)) <= comandos;

  RtypeSub <= funct7(5) and op(5);
  
  aluDecoder: process (funct3, RtypeSub, aluOp)   
  begin
    aluControl <= "000"; -- Definido um valor padrão para aluControl

    case aluOP is
      when "00" => -- addition (lw, sw, jalr)
        aluControl <= "000";
      when "01" => -- substration (beq or bne)
        aluControl <= "001";
      when others =>
        case funct3 is   -- R-type or I-type ALU
          when "000" =>   -- add, addi, sub
            if RtypeSub = '1' then
              alucontrol <= "001"; -- subtration (sub)
            else
              aluControl <= "000"; -- addition (add, addi)
            end if;
          when "010" =>   -- slt, slti
            aluControl <= "101";
          when "100" =>   -- xor, xori
            alucontrol <= "100";
          when "110" =>   -- or, ori
            alucontrol <= "011";
          when "111" =>   -- and, andi
            aluControl <= "010";
          when others => -- unknown
            aluControl <= "000"; -- Era '---'
        end case;
    end case;
  end process;   
end behavior;