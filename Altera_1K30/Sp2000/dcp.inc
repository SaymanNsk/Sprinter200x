-- Copyright (C) 1988-2000 Altera Corporation
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.

-- MAX+plus II Include File
-- Version 10.0 9/14/2000
-- Created: Thu Feb 07 21:14:23 2002

FUNCTION dcp (clk42, /reset, ct[2..0], continue, a[15..0], di[7..0], turbo_hand, /io, /rd, /wr, /mr, /rf, /m1, md[7..0], dos, refresh, g_line[9..0], test_r, acc_on, double_cas, blk_mem)
    WITH (UPDATE)
    RETURNS (/res, ras, cas, mc_end, mc_begin, mc_type, mc_write, do[7..0], ma[11..0], mca[1..0], clk_z80, turbo, /wait, /iom, /iomm, ra[17..14], page[11..0], type[3..0], cs_rom, cs_ram, v_ram, port, wr_dwg, wr_tm9, wr_awg, rd_kp11, kp11_mix, ga[9..0], graf, sp_scr, sp_sa, scr128, hdd_data, hdd_flip, ram, blk_r, pn4q, dcpp[7..0]);
