module vidor_s_top
(
  // system signals
  input         iCLK,
  input         iRESETn,
  input         iSAM_INT,
  output        oSAM_INT,
  
  // SDRAM
  output        oSDRAM_CLK,
  output [11:0] oSDRAM_ADDR,
  output [1:0]  oSDRAM_BA,
  output        oSDRAM_CASn,
  output        oSDRAM_CKE,
  output        oSDRAM_CSn,
  inout  [15:0] bSDRAM_DQ,
  output [1:0]  oSDRAM_DQM,
  output        oSDRAM_RASn,
  output        oSDRAM_WEn,

  // SAM D21 PINS
  inout         bMKR_AREF,
  inout  [6:0]  bMKR_A,
  inout  [14:0] bMKR_D,
  
  // Mini PCIe
  inout         bPEX_RST,
  inout         bPEX_PIN6,
  inout         bPEX_PIN8,
  inout         bPEX_PIN10,
  input         iPEX_PIN11,
  inout         bPEX_PIN12,
  input         iPEX_PIN13,
  inout         bPEX_PIN14,
  inout         bPEX_PIN16,
  inout         bPEX_PIN20,
  input         iPEX_PIN23,
  input         iPEX_PIN25,
  inout         bPEX_PIN28,
  inout         bPEX_PIN30,
  input         iPEX_PIN31,
  inout         bPEX_PIN32,
  input         iPEX_PIN33,
  inout         bPEX_PIN42,
  inout         bPEX_PIN44,
  inout         bPEX_PIN45,
  inout         bPEX_PIN46,
  inout         bPEX_PIN47,
  inout         bPEX_PIN48,
  inout         bPEX_PIN49,
  inout         bPEX_PIN51,

  // NINA interface
  inout         bWM_PIO1,
  inout         bWM_PIO2,
  inout         bWM_PIO3,
  inout         bWM_PIO4,
  inout         bWM_PIO5,
  inout         bWM_PIO7,
  inout         bWM_PIO8,
  inout         bWM_PIO18,
  inout         bWM_PIO20,
  inout         bWM_PIO21,
  inout         bWM_PIO24,
  inout         bWM_PIO25,
  inout         bWM_PIO27,
  inout         bWM_PIO28,
  inout         bWM_PIO29,
  inout         bWM_PIO31,
  input         iWM_PIO32,
  inout         bWM_PIO34,
  inout         bWM_PIO35,
  inout         bWM_PIO36,
  input         iWM_TX,
  inout         oWM_RX,
  inout         oWM_RESET,

  // HDMI output
  output [2:0]  oHDMI_TX,
  output        oHDMI_CLK,

  inout         bHDMI_SDA,
  inout         bHDMI_SCL,
  
  input         iHDMI_HPD,
  
  // MIPI input
  input  [1:0]  iMIPI_D,
  input         iMIPI_CLK,
  inout         bMIPI_SDA,
  inout         bMIPI_SCL,
  inout  [1:0]  bMIPI_GP,

  // Flash interface
  output        oFLASH_MOSI,
  input         iFLASH_MISO,
  output        oFLASH_SCK,
  output        oFLASH_CS
  
);

// signal declaration

wire        wOSC_CLK;

wire        wCLK8,wCLK24, wCLK64, wCLK120;

wire [31:0] wJTAG_ADDRESS, wJTAG_READ_DATA, wJTAG_WRITE_DATA, wDPRAM_READ_DATA;
wire        wJTAG_READ, wJTAG_WRITE, wJTAG_WAIT_REQUEST, wJTAG_READ_DATAVALID;
wire [4:0]  wJTAG_BURST_COUNT;
wire        wDPRAM_CS;

wire [7:0]  wTPG_RED,wTPG_GRN,wTPG_BLU;
wire        wTPG_HS,wTPG_VS,wTPG_DE;

wire        wVID_CLK, wVID_CLKx5;
wire        wMEM_CLK;

assign wVID_CLK   = wCLK24;
assign wVID_CLKx5 = wCLK120;
assign wCLK8      = iCLK;

// NINA Bypass
                                            // SAM       NINA
//assign oWM_RX     = bMKR_D[14];             // TX     => RX
//assign bMKR_D[14] = iWM_TX;                 // RX     <= TX
//assign oWM_RESET  = bMKR_D[7] ? 1'bZ : 0;   // IO     => RESET
//assign bWM_PIO27  = bMKR_D[6];              // IO     => BOOT
//assign bMKR_D[10] = bWM_PIO1;               // MISO   => MOSI
//assign bWM_PIO28  = bMKR_D[9];              // SCK    => SCK
//assign bWM_PIO21  = bMKR_D[8];              // MOSI   => MISO
//assign bWM_PIO29  = bMKR_D[5];              // CS     => CS

// internal oscillator
cyclone10lp_oscillator   osc
	( 
	.clkout(wOSC_CLK),
	.oscena(1'b1));

// system PLL
SYSTEM_PLL (
	.areset(1'b0),
	.inclk0(wCLK8),
	.c0(wCLK24),
	.c1(wCLK120),
	.c2(wMEM_CLK),
  //.c3(oSDRAM_CLK),
	.locked());

  // DVI output
DVI_OUT
(
  .iPCLK(wVID_CLK),
  .iSCLK(wVID_CLKx5),

  .iRED(wTPG_RED),
  .iGRN(wTPG_GRN),
  .iBLU(wTPG_BLU),
  .iHS(wTPG_HS),
  .iVS(wTPG_VS),
  .iDE(wTPG_DE),

  .oDVI_DATA(oHDMI_TX),
  .oDVI_CLK(oHDMI_CLK)
);

//audio generator

reg   [9:0] rAUDIO_ADDRESS;
wire [23:0] wAUDIO_DATA;
wire        wAUDIO_STROBE;

sinerom sine_inst(
	.address(rAUDIO_ADDRESS),
	.clock(wCLK24),
	.q(wAUDIO_DATA)
);

SD_MODULATOR #(
  .pBITS(24),
  .pINTERP_BITS(9)
) mod_inst
(
  .iCLK(wCLK24),
  .iDATA(wAUDIO_DATA),
  .oSTROBE(wAUDIO_STROBE),
  .oDAC(wDAC)
);
  
always @(posedge wCLK24)
begin
  if (wAUDIO_STROBE)
    rAUDIO_ADDRESS<=rAUDIO_ADDRESS+15;
  
end
/*

// SDRAM controller

  assign oSDRAM_CLK=wMEM_CLK;
  /*
	memory_sdram sdram (
		.clk            (wMEM_CLK),                         //   clk.clk
		.reset_n        (rINITCNT[7]|rINITCNT[6]), // reset.reset_n
		.az_addr        (rFR_ADDR),                //    s1.address
		.az_be_n        (2'b0),           //      .byteenable_n
		.az_cs          (1'b1),             //      .chipselect
		.az_data        (rFR_WRADDR),              //      .writedata
		.az_rd_n        (!rFR_READ),                 //      .read_n
		.az_wr_n        (!rFR_WRITE),                //      .write_n
		.za_data        (wFR_DATA),               //      .readdata
		.za_valid       (wFR_DATAVALID),          //      .readdatavalid
		.za_waitrequest (wFR_WAIT),            //      .waitrequest

		.zs_addr        (oSDRAM_ADDR),                      //  wire.export
		.zs_ba          (oSDRAM_BA),                        //      .export
		.zs_cas_n       (oSDRAM_CASn),                     //      .export
		.zs_cke         (oSDRAM_CKE),                       //      .export
		.zs_cs_n        (oSDRAM_CSn),                      //      .export
		.zs_dq          (bSDRAM_DQ),                        //      .export
		.zs_dqm         (oSDRAM_DQM),                       //      .export
		.zs_ras_n       (oSDRAM_RASn),                     //      .export
		.zs_we_n        (oSDRAM_WEn)                       //      .export
	);
  */
assign oSDRAM_CLK=wMEM_CLK;

wire fb_st_start,fb_st_dv,fb_st_ready;
wire [30:0] fb_st_data;

wire [23:0] mipi_st_data;
wire mipi_st_start,mipi_st_dv;

wire [31:0] wSAM_PIO_IN;  
wire [31:0] wSAM_PIO_OUT; 
wire [31:0] wSAM_PIO_DIR; 
wire [63:0] wSAM_PIO_MSEL;
wire [31:0] wWM_PIO_IN;   
wire [31:0] wWM_PIO_OUT;  
wire [31:0] wWM_PIO_DIR; 
wire [63:0] wWM_PIO_MSEL;
wire [31:0] wPEX_PIO_IN;  
wire [31:0] wPEX_PIO_OUT;
wire [31:0] wPEX_PIO_DIR;
wire [63:0] wPEX_PIO_MSEL; 

memory u0(
		.clk_clk                (wMEM_CLK),               //      clk.clk
		.reset_reset_n          (1'b1), // reset.reset_n
		.vid_clk                (wVID_CLK),        //   vid.clk

		.sdram_addr             (oSDRAM_ADDR), //    sdram.addr
		.sdram_ba               (oSDRAM_BA),   //         .ba
		.sdram_cas_n            (oSDRAM_CASn), //         .cas_n
		.sdram_cke              (oSDRAM_CKE),  //         .cke
		.sdram_cs_n             (oSDRAM_CSn),  //         .cs_n
		.sdram_dq               (bSDRAM_DQ),   //         .dq
		.sdram_dqm              (oSDRAM_DQM),  //         .dqm
		.sdram_ras_n            (oSDRAM_RASn), //         .ras_n
		.sdram_we_n             (oSDRAM_WEn),   //         .we_n
 		.fb_vport_blu              (wTPG_BLU),     // vport.blu
		.fb_vport_de               (wTPG_DE),      //      .de
		.fb_vport_grn              (wTPG_GRN),     //      .grn
		.fb_vport_hs               (wTPG_HS),      //      .hs
		.fb_vport_vs               (wTPG_VS),      //      .vs
		.fb_vport_red              (wTPG_RED),     //      .red

		.flash_spi_MISO         (iFLASH_MISO),   // flash_spi.MISO
		.flash_spi_MOSI         (oFLASH_MOSI),   //          .MOSI
		.flash_spi_SCLK         (oFLASH_SCK),   //          .SCLK
		.flash_spi_SS_n         (oFLASH_CS),   //          .SS_n

		.csi_i2c_scl            (bMIPI_SCL),      //   csi_i2c.scl
		.csi_i2c_sda            (bMIPI_SDA),      //          .sda

    .mipi_rx_clk               (iMIPI_CLK),
    .mipi_rx_data              (iMIPI_D),

		.arb_fb_clk       (wVID_CLK),       //    arb_fb.clk
		.arb_fb_rdy       (fb_st_ready),       //          .rdy
		.arb_fb_data      (fb_st_data),      //          .data
		.arb_fb_dv        (fb_st_dv),        //          .dv
		.arb_fb_start     (fb_st_start),     //          .start

		.fb_st_start      (fb_st_start),      //     fb_st.start
		.fb_st_data       (fb_st_data),       //          .data
		.fb_st_dv         (fb_st_dv),         //          .dv
		.fb_st_ready      (fb_st_ready),       //          .ready

		.arb_mipi_clk     (iMIPI_CLK),     //  arb_mipi.clk
		.arb_mipi_data    ({mipi_st_data[23-:5],mipi_st_data[15-:5],mipi_st_data[7-:5]}),    //          .data
		.arb_mipi_start   (mipi_st_start),    //          .data
		.arb_mipi_dv      (mipi_st_dv),      //          .dv

		.mipi_st_data     (mipi_st_data),     //   mipi_st.data
		.mipi_st_start    (mipi_st_start),    //          .start
		.mipi_st_dv       (mipi_st_dv),       //          .dv

		.nina_uart_RXD    (iWM_TX),    // nina_uart.RXD
		.nina_uart_TXD    (wNINA_RX),    //          .TXD

		.nina_spi_MISO    (bWM_PIO1),    //  nina_spi.MISO
		.nina_spi_MOSI    (wNINA_MOSI),    //          .MOSI
		.nina_spi_SCLK    (wNINA_SCLK),    //          .SCLK
		.nina_spi_SS_n    (wNINA_SS),     //          .SS_n

		.sam_pio_in       (wSAM_PIO_IN),       //   sam_pio.in
		.sam_pio_out      (wSAM_PIO_OUT),      //          .out
		.sam_pio_dir      (wSAM_PIO_DIR),      //          .dir
		.sam_pio_msel     (wSAM_PIO_MSEL),     //          .msel

		.wm_pio_in        (wWM_PIO_IN),        //    wm_pio.in
		.wm_pio_out       (wWM_PIO_OUT),       //          .out
		.wm_pio_dir       (wWM_PIO_DIR),       //          .dir
		.wm_pio_msel      (wWM_PIO_MSEL),       //          .msel

		.pex_pio_in       (wPEX_PIO_IN),       //   pex_pio.in
		.pex_pio_out      (wPEX_PIO_OUT),      //          .out
		.pex_pio_dir      (wPEX_PIO_DIR),      //          .dir
		.pex_pio_msel     (wPEX_PIO_MSEL),     //          .msel
    
      .sam_pwm_pwm      (wSAM_OUT1)
    
	);
  
wire [31:0] wSAM_PIN_OUT,wSAM_OUT1,wSAM_OUT2,wSAM_OUT3;
wire [31:0] wWM_PIN_OUT,wWM_OUT1,wWM_OUT2,wWM_OUT3;
wire [31:0] wPEX_PIN_OUT,wPEX_OUT1,wPEX_OUT2,wPEX_OUT3;

assign wSAM_PIO_IN = {bMKR_D,bMKR_A,bMKR_AREF};
assign wWM_PIO_IN = {iWM_PIO32,iWM_TX,oWM_RX,bWM_PIO36,bWM_PIO35,bWM_PIO34,bWM_PIO31,bWM_PIO29,bWM_PIO28,bWM_PIO27,bWM_PIO25,bWM_PIO24,bWM_PIO21,bWM_PIO20,bWM_PIO18,bWM_PIO8,bWM_PIO7,bWM_PIO5,bWM_PIO4,bWM_PIO3,bWM_PIO2,bWM_PIO1,oWM_RESET};
assign wPEX_PIO_IN = {iPEX_PIN33,iPEX_PIN31,iPEX_PIN25,iPEX_PIN23,iPEX_PIN13,iPEX_PIN11,bPEX_PIN51,bPEX_PIN49,bPEX_PIN48,bPEX_PIN47,bPEX_PIN46,bPEX_PIN45,bPEX_PIN44,bPEX_PIN42,bPEX_PIN32,bPEX_PIN30,bPEX_PIN28,bPEX_PIN20,bPEX_PIN16,bPEX_PIN14,bPEX_PIN12,bPEX_PIN10,bPEX_PIN8,bPEX_PIN6,bPEX_RST};

assign {bMKR_D,bMKR_A,bMKR_AREF}= wSAM_PIN_OUT;
assign {oWM_RX,bWM_PIO36,bWM_PIO35,bWM_PIO34,bWM_PIO31,bWM_PIO29,bWM_PIO28,bWM_PIO27,bWM_PIO25,bWM_PIO24,bWM_PIO21,bWM_PIO20,bWM_PIO18,bWM_PIO8,bWM_PIO7,bWM_PIO5,bWM_PIO4,bWM_PIO3,bWM_PIO2,bWM_PIO1,oWM_RESET} = wWM_PIN_OUT;
assign {bPEX_PIN51,bPEX_PIN49,bPEX_PIN48,bPEX_PIN47,bPEX_PIN46,bPEX_PIN45,bPEX_PIN44,bPEX_PIN42,bPEX_PIN32,bPEX_PIN30,bPEX_PIN28,bPEX_PIN20,bPEX_PIN16,bPEX_PIN14,bPEX_PIN12,bPEX_PIN10,bPEX_PIN8,bPEX_PIN6,bPEX_RST} = wPEX_PIN_OUT;
genvar i;
generate

for (i=0;i<31;i++) begin : genloop
assign wSAM_PIN_OUT[i] =  (wSAM_PIO_MSEL[i*2+1-:2] ==0) ? !wSAM_PIO_DIR[i] ? 1'bZ :wSAM_PIO_OUT[i] : 
                          (wSAM_PIO_MSEL[i*2+1-:2] ==1) ? wSAM_OUT1[i] : 
                          (wSAM_PIO_MSEL[i*2+1-:2] ==2) ? wSAM_OUT2[i] : 
                          (wSAM_PIO_MSEL[i*2+1-:2] ==3) ? wSAM_OUT3[i] : 0;
assign wWM_PIN_OUT[i] =   
                          (wWM_PIO_MSEL[i*2+1-:2] ==0) ? !wWM_PIO_DIR[i] ? 1'bZ : wWM_PIO_OUT[i] : 
                          (wWM_PIO_MSEL[i*2+1-:2] ==1) ? wWM_OUT1[i] : 
                          (wWM_PIO_MSEL[i*2+1-:2] ==2) ? wWM_OUT2[i] : 
                          (wWM_PIO_MSEL[i*2+1-:2] ==3) ? wWM_OUT3[i] : 0;
assign wPEX_PIN_OUT[i] =  
                          (wPEX_PIO_MSEL[i*2+1-:2] ==0) ? !wPEX_PIO_DIR[i] ? 1'bZ : wPEX_PIO_OUT[i] : 
                          (wPEX_PIO_MSEL[i*2+1-:2] ==1) ? wPEX_OUT1[i] : 
                          (wPEX_PIO_MSEL[i*2+1-:2] ==2) ? wPEX_OUT2[i] : 
                          (wPEX_PIO_MSEL[i*2+1-:2] ==3) ? wPEX_OUT3[i] : 0;

end

assign wWM_OUT2[21]=wNINA_RX;
assign wWM_OUT2[12]= wNINA_MOSI;
assign wWM_OUT2[9] =wNINA_SCLK;
assign wWM_OUT2[17]=wNINA_SS;

assign wSAM_OUT3[0] = wDAC;

endgenerate

  
  // Mini PCIe




















  // NINA interface
  
  
  
  
  
  
  
  
// Quadrature DECODER

/*
parameter pENCODERS=2;
wire [pENCODERS-1:0] wENCODER_A,wENCODER_B;

assign wENCODER_A[0] = bMKR_A[1];
assign wENCODER_B[0] = bMKR_A[2];

assign wENCODER_A[1] = bMKR_A[5];
assign wENCODER_B[1] = bMKR_A[6];

reg [3:0][pENCODERS-1:0] rRESYNC_ENCODER_A,rRESYNC_ENCODER_B;
reg [5:0] rENC_PRESCALER;
reg [15:0][pENCODERS-1:0] rSTEPS;
wire [pENCODERS-1:0] wINCREMENT =  rRESYNC_ENCODER_A[2]&!rRESYNC_ENCODER_A[3]& rRESYNC_ENCODER_B[3] | !rRESYNC_ENCODER_A[2]& rRESYNC_ENCODER_A[3]& !rRESYNC_ENCODER_B[3];
wire [pENCODERS-1:0] wDECREMENT = !rRESYNC_ENCODER_A[2]& rRESYNC_ENCODER_A[3]& rRESYNC_ENCODER_B[3] |  rRESYNC_ENCODER_A[2]&!rRESYNC_ENCODER_A[3]& !rRESYNC_ENCODER_B[3];
integer i;

always @(posedge iCLK)
begin
  rENC_PRESCALER<= rENC_PRESCALER+1;
  if (rENC_PRESCALER==0)
  begin
    rRESYNC_ENCODER_A<={rRESYNC_ENCODER_A,wENCODER_A};
    rRESYNC_ENCODER_B<={rRESYNC_ENCODER_B,wENCODER_B};
    for (i=0;i<pENCODERS;i++)
    begin
      if (wINCREMENT[i])
        rSTEPS[i] <= rSTEPS[i]+1;
      if (wDECREMENT[i])
        rSTEPS[i] <= rSTEPS[i]-1;
    end
  end
end
*/
// JTAG Bridge
/*
assign wDPRAM_CS=wJTAG_ADDRESS[8];

JTAG_BRIDGE (
  .iCLK(wOSC_CLK),
  .iRESET(1'b0),
  .oADDRESS(wJTAG_ADDRESS),
  .oWRITE(wJTAG_WRITE),
  .oREAD(wJTAG_READ),
  .oWRITE_DATA(wJTAG_WRITE_DATA),
  .iREAD_DATA(wJTAG_READ_DATA),
  .oBURST_COUNT(wJTAG_BURST_COUNT),
  .iWAIT_REQUEST(wJTAG_WAIT_REQUEST),
  .iREAD_DATAVALID(wJTAG_READ_DATAVALID)
);

reg rJTAG_DATAVALID;
reg [31:0] rJTAG_READ_DATA;
assign wJTAG_READ_DATA = rCLIENTID ? wDPRAM_READ_DATA : rJTAG_READ_DATA;
assign wJTAG_READ_DATAVALID = rJTAG_DATAVALID;
reg rCLIENTID;

always @(posedge wOSC_CLK)
begin
  rJTAG_DATAVALID<=wJTAG_READ;
  case (wJTAG_ADDRESS)
    0: rJTAG_READ_DATA<= 32'hbac1beef;
    1: rJTAG_READ_DATA<= 32'haaaa5555;
    2: rJTAG_READ_DATA<= 32'h5555aaaa;
    3: rJTAG_READ_DATA<= 32'h01234567;
    4: rJTAG_READ_DATA<= rSTEPS[0];
    5: rJTAG_READ_DATA<= rSTEPS[1];
  endcase;
  if (wJTAG_READ)
  begin
    rCLIENTID <= wDPRAM_CS;
  end
end

*/
// MIPI input
assign bMIPI_GP[0]=1'b1;
assign bMIPI_GP[1]=1'b1;





endmodule
