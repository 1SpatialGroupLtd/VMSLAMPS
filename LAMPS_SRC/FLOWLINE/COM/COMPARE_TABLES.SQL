select * from o.t_element t where not exists (
   select * from o.element p where (
      p.ELEMENT_ID = t.ELEMENT_ID and
      p.FLOWLINE_ID = t.FLOWLINE_ID and
      p.PROCEDURE_ID = t.PROCEDURE_ID and
      p.COMMAND_PROC = t.COMMAND_PROC and
      p.CONDITIONS = t.CONDITIONS and
      p.PRIORITY = t.PRIORITY
   )
);

select * from o.t_flowline t where not exists (
   select * from o.flowline p where (
      p.FLOWLINE_ID = t.FLOWLINE_ID and
      p.START_ELEMENT = t.START_ELEMENT and
      p.END_ELEMENT = t.END_ELEMENT and
      p.COMMAND_PROC = t.COMMAND_PROC and
      p.PRIORITY = t.PRIORITY
   )
);

select * from o.t_OUTCOME t where not exists (
   select * from o.OUTCOME p where (
      p.FLOWLINE_ID = t.FLOWLINE_ID and
      p.ELEMENT_ID = t.ELEMENT_ID and
      p.OUTCOME_VALUE = t.OUTCOME_VALUE and
      p.WIRE_ID = t.WIRE_ID
   )
);

select * from o.t_PROCEDURE t where not exists (
   select * from o.PROCEDURE p where (
      p.PROCEDURE_ID = t.PROCEDURE_ID and
      p.COMMAND_PROC = t.COMMAND_PROC and
      p.PRIORITY = t.PRIORITY
   )
);

select * from o.t_WIRE t where not exists (
   select * from o.WIRE p where (
      p.FLOWLINE_ID = t.FLOWLINE_ID and
      p.WIRE_ID = t.WIRE_ID and
      p.WIRE_END = t.WIRE_END
   )
);

