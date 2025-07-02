--------------------------------------------------------------------------------------
-- Controller unit                                                                  --
-- myRISCVv1  											                            --
--														                            --
-- Prof. Max Santana  (2025)                                                        --
-- CEComp/Univasf                                                                   --
--------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity controller is
  port(
    op        : in std_logic_vector(6 downto 0);
    funct3    : in std_logic_vector(2 downto 0);
    funct7    : in std_logic_vector(6 downto 0);
    zero      : in std_logic;
    resultSrc : out std_logic_vector(1 downto 0);
    memWrite  : out std_logic;
    PCSrc     : out std_logic;
    aluSrc    : out std_logic;
    regWrite  : out std_logic;
    immSrc    : out std_logic_vector(1 downto 0);
    aluControl: out std_logic_vector(2 downto 0)
  );
end;
architecture behavior of controller is
  signal aluOp   : std_logic_vector(1 downto 0);
  signal branch  : std_logic;
  signal jump    : std_logic;
  signal bne     : std_logic;
  signal beq     : std_logic;
  signal RtypeSub: std_logic;
begin
  --PCSrc <= zero and branch;
  PCSrc <= (zero and beq) or ((not zero) and bne) or jump;
  
  mainDecoder: process(op)
  begin
    case op is
      when "0000011" =>  -- lw
        branch    <= '0';
        jump      <= '0';
        beq       <= '0';
        bne       <= '0';
        resultSrc <= "01";
        memWrite  <= '0';
        aluSrc    <= '1';
        regWrite  <= '1';
        immSrc    <= "00";
        aluop     <= "00";      
      when "0100011" =>  -- sw
        branch    <= '0';
        jump      <= '0';
        beq       <= '0';
        bne       <= '0';
        resultSrc <= "XX";
        memWrite  <= '1';
        aluSrc    <= '1';
        regWrite  <= '0';
        immSrc    <= "01";
        aluop     <= "00";
      when "0110011" =>  -- R-type
        branch    <= '0';
        jump      <= '0';
        beq       <= '0';
        bne       <= '0';
        resultSrc <= "00";
        memWrite  <= '0';
        aluSrc    <= '0';
        regWrite  <= '1';
        immSrc    <= "XX";
        aluop     <= "10";
      when "1100011" =>  -- beq or bne
        branch    <= '1';
        jump      <= '0';
        if funct3 = "000" then
          beq       <= '1';
          bne       <= '0';
        else
          beq       <= '0';
          bne       <= '1';
        end if;
        resultSrc <= "XX";
        memWrite  <= '0';
        aluSrc    <= '0';
        regWrite  <= '0';
        immSrc    <= "10";
        aluOp     <= "01";
      when "0010011" =>  -- I-type (ALU)
        branch    <= '0';
        jump      <= '0';
        beq       <= '0';
        bne       <= '0';
        resultSrc <= "00";
        memWrite  <= '0';
        aluSrc    <= '1';
        regWrite  <= '1';
        immSrc    <= "00";
        aluop     <= "10";
      when "1101111" =>  -- Jal
        branch    <= '0';
        jump      <= '1';
        beq       <= '0';
        bne       <= '0';
        resultSrc <= "10";
        memWrite  <= '0';
        aluSrc    <= 'X';
        regWrite  <= '1';
        immSrc    <= "11";
        aluop     <= "XX";
      when others =>
        branch    <= 'X';
        jump      <= 'X';
        beq       <= 'X';
        bne       <= 'X';
        resultSrc <= "XX";
        memWrite  <= 'X';
        aluSrc    <= 'X';
        regWrite  <= 'X';
        immSrc    <= "XX";
        aluOp     <= "XX";
    end case;
  end process;
  
  aluDecoder: process (op, funct3, funct7, aluOp)  
  begin
    RtypeSub <= funct7(5) and op(5); -- True for R-type subtract    
    case aluOP is
      when "00" => -- addition (lw, sw)
        aluControl <= "000";
      when "01" => -- substration (beq or bne)
        aluControl <= "001";
      when others =>
        case funct3 is   -- R-type or I-type ALU
          when "000" =>  -- add, addi, sub
            if RtypeSub = '1' then
              alucontrol <= "001"; -- subtration (sub)
            else
              aluControl <= "000"; -- addition (add, addi)
            end if;
          when "010" =>  -- slt, slti
            aluControl <= "101";
          when "100" =>  -- xor, xori
            alucontrol <= "100";
          when "110" =>  -- or, ori
            alucontrol <= "011";
          when "111" =>  -- and, andi
            aluControl <= "010";
          when others => -- unknown
            aluControl <= "---";
      end case;
    end case;
  end process;  
end behavior;
