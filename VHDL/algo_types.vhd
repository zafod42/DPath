library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package algo_types is
	type memory_type is array(natural range<>) of std_logic_vector(7 downto 0);
	type graph_type is array(natural range<>, natural range<>) of std_logic_vector(7 downto 0);
	type bool_array_type is array(natural range<>) of std_logic;
end package algo_types;