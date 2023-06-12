module irrigation_system_tb;
  reg tb_clk;
  reg tb_reset;
  reg [3:0] tb_sensor;
  wire tb_pump;
  parameter THRESHOLD = 4'b0100;
  parameter DELAY = 20;  
  reg [7:0] counter;
  
  // Instantiate the module under test
  irrigation_system dut (
    .clk(tb_clk),
    .reset(tb_reset),
    .sensor(tb_sensor),
    .pump(tb_pump)
  );

  // Clock generation
  always begin
    tb_clk = 0;
    #5;
    tb_clk = 1;
    #5;
  end

  initial begin
    // Initialize inputs
    #10 tb_reset = 0;

    // Test case 1: Soil moisture is low initially
    #20 begin
      tb_reset = 1;
      tb_sensor = 4'b0010; // Set soil moisture below the threshold

      if (tb_sensor < THRESHOLD) begin
        #50;
        tb_sensor = 4'b0101; // Set soil moisture above the threshold
        #20;
        if (tb_pump == 0)
          $display("Test case 1 passed");
        else
          $display("Test case 1 failed");
      end
    end

    // Test case 2: Soil moisture is high initially
    #20 begin
      tb_sensor = 4'b1100; // Set soil moisture above the threshold

      if (tb_sensor >= THRESHOLD) begin
        #50;
        tb_sensor = 4'b0001; // Set soil moisture below the threshold

        if (tb_pump == 0 && counter == 0)
          $display("Test case 2 failed");
        else
          $display("Test case 2 passed");
      end
    end

    // Test case 3
    #20 begin
      tb_sensor = 4'b0001;
      #200;
      tb_sensor = 4'b0010; //waiting
      if (tb_pump == 0)
        $display("Test case 3 passed");
      else begin
        $display("Test case 3 failed");
      end
    end

    #100;
    $finish; // End the simulation
  end
endmodule