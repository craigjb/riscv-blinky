package blinky

import spinal.core._

class Blinky extends Component {
    val io = new Bundle {
        val led = out Bool
    }

    io.led := True

    noIoPrefix()
}

object BlinkySpinalConfig extends SpinalConfig(mode = Verilog)

object BlinkyVerilog {
    def main(args: Array[String]) {
        BlinkySpinalConfig.generateVerilog(new Blinky())
    }
}