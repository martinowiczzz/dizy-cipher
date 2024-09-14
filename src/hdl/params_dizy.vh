`ifndef __dizy_vh__
`define __dizy_vh__

//`define DIZY_80 // Uncomment to switch from DIZY_128 to DIZY_80

`ifdef DIZY_80
   // DIZY-80 Parameters
   `define SIZE_STATE 120
   `define PERM_SIZE 30
   `define SIZE_KEY 80
`else
   // DIZY-128 Parameters
   `define SIZE_STATE 160
   `define PERM_SIZE 40
   `define SIZE_KEY 128
`endif

`endif