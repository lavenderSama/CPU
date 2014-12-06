def gen(inputFile, port):
	p = '%s: %s std_logic%s;\n'
	if (not port):
		p = 'signal %s: std_logic%s;\n'
	pv = "_vector(%d downto 0)"
	input = open(inputFile, 'r')
	sig_in = []
	sig_out = []
	for line in input:
		if (line == '\n'):
			sig_in.append('\n')
			sig_out.append('\n')
			continue
		if (line[0] == ':'):
			line = line[1:]
			[name, bits] = line.split(' ')
			bits = int(bits)
			type_append = ''
			if (bits != 1):
				type_append = pv % (bits-1)
			if (port):
				sig_in.append(p % (name, 'in', type_append))
			else: 
				sig_in.append(p % (name, type_append))
			continue
		[name, bits] = line.split(' ')
		bits = int(bits)
		type_append = ''
		if (bits != 1):
			type_append = pv % (bits-1)
		if (port):
			sig_in.append(p % (name+'_in', 'in', type_append))
			sig_out.append(p % (name+'_out', 'out', type_append))
		else: 
			sig_in.append(p % (name+'_in', type_append))
			sig_out.append(p % (name+'_out', type_append))
	input.close()
	[name, type] = inputFile.split('.')
	post = 'port'
	if (not port):
		post = 'signal'
	output = open('%s_%s.%s' % (name, post, type), 'w')
	output.writelines(sig_in)
	output.write('\n\n')
	output.writelines(sig_out)
	output.close()

def gen2(bitList):
	p = """LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity QReg_%d is
	port(
				clk: in std_logic;
				rst: in std_logic; --0 for reset, others for normal function
				D_in: in std_logic_vector(%d downto 0); --input data
				D_out: out std_logic_vector(%d downto 0) --output data
			);
end entity;

architecture Behavioral of QReg_%d is
	signal data: std_logic_vector(%d downto 0):= (others => '0');
begin
	D_out <= data;
	
	process (clk, rst)
	begin
		if (rst = '0') then
			data <= (others => '0');
		elsif (clk'event and clk = '1') then
			data <= D_in;
		end if;
	end process;
end architecture;
"""
	for bit in bitList:
		output = open("QReg_%d.vhd" % bit, 'w')
		output.write(p % (bit,bit-1,bit-1,bit,bit-1))
		output.close()