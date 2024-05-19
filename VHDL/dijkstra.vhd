-- Library
library ieee;

-- Uses
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.algo_types.all;

-- Top entity
entity dijkstra is
	port(
		clk: in std_logic;
		--reset: in std_logic;
		--read: in std_logic;
		--graph_in: in graph_type(0 to 4, 0 to 4);
		
		graph_in_0: in memory_type(0 to 4);
		graph_in_1: in memory_type(0 to 4);
		graph_in_2: in memory_type(0 to 4);
		graph_in_3: in memory_type(0 to 4);
		graph_in_4: in memory_type(0 to 4);
		start_node: in std_logic_vector(7 downto 0);
		
		
		distances: out memory_type(0 to 4)
		
	);
end entity dijkstra;

-- Behavorial architecture
architecture rtl of dijkstra is

	procedure find_min(
		dist: inout memory_type(0 to 4);
		used: in bool_array_type(0 to 4);
		current: inout integer
		)
	is
		variable idx: integer;
	begin
		idx := 0;
		find_loop: for i in 1 to 5 loop
			if (used(i-1)='0') and (idx = 0 or unsigned(dist(idx-1)) > unsigned(dist(i-1))) then
				idx := i;	
			end if;
		end loop find_loop;
		current := idx-1;
	end procedure find_min;

	procedure Algorithm(
		gr : in graph_type(0 to 4, 0 to 4);
		dist: inout memory_type(0 to 4);
		start : in integer
		)
	is 
		-- uses std_logic inside
		variable used : bool_array_type(0 to 4);
		variable current : integer;
		variable parent : integer;
	begin 
		-- prepare
		clear_loop: for k in 0 to 4 loop
			dist(k) := x"FF";
			used(k) := '0';
		end loop clear_loop;
		dist(start) := x"00";
		parent := 0;
		current := 0;
		external_loop: for i in 0 to 4 loop
			current := 0;
			-- loop to find base node
			find_min(dist, used, current);			
			used(current) := '1';
			if dist(current) /= x"FF" then
				calculate_dist: for j in 0 to 4 loop
					if gr(current, j) /= x"00" then
						if unsigned(dist(current)) + unsigned(gr(current, j)) < unsigned(dist(j)) then
							dist(j) := std_logic_vector(unsigned(dist(current)) + unsigned(gr(current, j)));
						end if;
					end if;
				end loop calculate_dist;
			end if;
		end loop external_loop;
		
	end procedure Algorithm;

	shared variable paths : memory_type(0 to 4);
	shared variable graph : graph_type(0 to 4, 0 to 4);
	shared variable start : integer;
begin
	main: process(clk) 
	begin
		if clk'event and clk='1' then
			read_graph_loop: for k in 0 to 4 loop
				graph(0, k) := graph_in_0(k);
				graph(1, k) := graph_in_1(k);
				graph(2, k) := graph_in_2(k);
				graph(3, k) := graph_in_3(k);
				graph(4, k) := graph_in_4(k);
			end loop read_graph_loop;
			start := to_integer(unsigned(start_node));
			Algorithm(graph, paths, start);
			distances <= paths;
		end if;
	end process main;
end architecture rtl;