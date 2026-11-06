`timescale 1ns / 1ps
module tb_uart_fixes;
    reg clk = 0; always #5 clk = ~clk;
    reg reset = 1;
    integer errors = 0;

    // ---------- FIFO: fixed vs original ----------
    reg wr, rd; reg [7:0] din;
    wire [7:0] dout_n, dout_o; wire e_n, f_n, e_o, f_o;
    fifo      #(.ADDR_SPACE_EXP(2)) fn(.clk(clk),.reset(reset),.write_to_fifo(wr),.read_from_fifo(rd),.write_data_in(din),.read_data_out(dout_n),.empty(e_n),.full(f_n));
    fifo_orig #(.ADDR_SPACE_EXP(2)) fo(.clk(clk),.reset(reset),.write_to_fifo(wr),.read_from_fifo(rd),.write_data_in(din),.read_data_out(dout_o),.empty(e_o),.full(f_o));

    task push(input [7:0] d); begin wr=1; rd=0; din=d; @(posedge clk); #1 wr=0; end endtask
    task pop;                 begin rd=1; wr=0; @(posedge clk); #1 rd=0; end endtask
    task both(input [7:0] d); begin wr=1; rd=1; din=d; @(posedge clk); #1 wr=0; rd=0; end endtask
    task chk(input cond, input [8*64-1:0] name); begin
        if(!cond) begin errors=errors+1; $display("FAIL: %0s", name); end
        else $display("pass: %0s", name); end endtask

    // ---------- Debouncer (short count) ----------
    reg btn = 0; wire dbl, dbt; integer ticks = 0;
    debounce_explicit #(.N(4)) db(.clk_100MHz(clk),.reset(reset),.btn(btn),.db_level(dbl),.db_tick(dbt));
    always @(posedge clk) if(dbt) ticks <= ticks + 1;

    // ---------- UART top loopback ----------
    reg rx = 1; wire tx; reg rd_u = 0, wr_u = 0; wire [7:0] rdata; wire rfull, rempty;
    uart_top ut(.clk_100MHz(clk),.reset(reset),.read_uart(rd_u),.write_uart(wr_u),.rx(rx),
                .write_data(rdata),.rx_full(rfull),.rx_empty(rempty),.tx(tx),.read_data(rdata));
    localparam BIT = 104167;   // ns per bit at 9600 baud
    task send_byte(input [7:0] b); integer i; begin
        rx = 0; #BIT; for(i=0;i<8;i=i+1) begin rx = b[i]; #BIT; end rx = 1; #BIT; end endtask
    reg [7:0] cap; integer j;
    task recv_byte; begin
        @(negedge tx); #(BIT + BIT/2);
        for(j=0;j<8;j=j+1) begin cap[j] = tx; #BIT; end
    end endtask

    initial begin
        wr=0; rd=0; din=0; #53; reset=0; @(posedge clk);

        // FIFO: simultaneous r/w when empty
        both(8'hAA); #1;
        chk(e_n==0, "fixed FIFO: empty+rw -> not empty, byte kept");
        chk(dout_n==8'hAA, "fixed FIFO: empty+rw -> byte readable");
        $display("info: original FIFO after empty+rw: empty=%b dout=%h (lost byte if empty=1)", e_o, dout_o);
        pop; pop; // drain (second pop on empty is ignored)
        // FIFO: simultaneous r/w when full
        push(1); push(2); push(3); push(4); #1;
        chk(f_n==1, "fixed FIFO: full after 4 pushes");
        both(8'h99); #1;
        chk(dout_n==8'h02 && f_n==0, "fixed FIFO: full+rw -> read only, no corrupt entry");
        pop; pop; pop; #1;
        chk(e_n==1, "fixed FIFO: drains to empty with 4 total entries");
        $display("info: original FIFO after full+rw sequence: empty=%b (1 means a stale entry was duplicated if 0)", e_o);

        // Debounce: noisy press then noisy release
        repeat(3) @(posedge clk);
        btn=1; #20 btn=0; #20 btn=1; #30 btn=0; #10 btn=1;      // bounce
        #1000; chk(ticks==1 && dbl==1, "debounce: bouncing press -> exactly 1 tick, level high");
        btn=0; #30 btn=1; #20 btn=0;                            // release bounce
        #1000; chk(dbl==0 && ticks==1, "debounce: bouncing release -> level low, no extra tick");

        // UART loopback with start-edge offset not aligned to baud tick
        #12345;
        rd_u=0; wr_u=0;
        send_byte(8'h5A); #(BIT);
        chk(rempty==0 && rdata==8'h5A, "UART RX: 0x5A received into RX FIFO");
        fork
            begin @(posedge clk); rd_u=1; wr_u=~rempty; @(posedge clk); #1 rd_u=0; wr_u=0; end
            recv_byte;
        join
        chk(cap==8'h5A, "UART TX: 0x5A echoed on tx");
        // button on empty RX FIFO: write must be gated, nothing transmitted
        #(BIT*2);
        @(posedge clk); rd_u=1; wr_u=~rempty; @(posedge clk); #1 rd_u=0; wr_u=0;
        #(BIT*12);
        chk(tx==1 && ut.tx_empty==1, "empty-RX press: nothing queued for TX");

        if(errors==0) $display("ALL TESTS PASSED"); else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
    initial begin #50_000_000; $display("TIMEOUT"); $finish; end
endmodule
