declare O schema for filename FLOWLINE_OLD;
declare N schema for filename FLOWLINE;
declare transaction on O using (read write) and on N using (read only);
