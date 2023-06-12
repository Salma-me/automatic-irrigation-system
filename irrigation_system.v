module irrigation_system(
  input clk, 
  input reset, 
  input [3:0] sensor, // soil moisture sensor input
  output reg pump // output control signal for pump
);

  localparam THRESHOLD = 4'b0100;
  localparam DELAY = 20;
  // Defining the states
  localparam IDLE = 2'b00;
  localparam PUMPING = 2'b01;
  localparam WAITING = 2'b10;

  reg [1:0] current_state, next_state;
  reg [7:0] counter;

  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      current_state <= IDLE;
      counter <= 0;
      pump <= 0;
    end
    else begin
      current_state <= next_state;
      counter <= (counter > 0) ? counter - 1 : counter;
    end
  end

  always @(*) begin

    case (current_state)
      IDLE:
        if (sensor < THRESHOLD) begin // if soil moisture is low
          next_state = PUMPING; // change state to PUMPING
          pump = 1; // turn on pump
          counter = DELAY; // set counter to delay value
        end

      PUMPING:
        if (sensor >= THRESHOLD) begin // if soil moisture is high enough
          next_state = IDLE; // change state to IDLE
          pump = 0; // turn off pump
          counter = 0; // reset counter
        end
        else if (counter == 0) begin // if delay is over
          next_state = WAITING; // change state to WAITING
          counter = DELAY; // set counter to delay value
          pump = 0;
        end

      WAITING:
        if (counter == 0) begin // if delay is over
          next_state = PUMPING; // change state to PUMPING
          pump = 1; // turn on pump
          counter = DELAY; // set counter to delay value
        end
      default:
        begin
          next_state = IDLE;
          pump = 0; // turn off pump
          counter = 0;
        end
    endcase
  end
endmodule
