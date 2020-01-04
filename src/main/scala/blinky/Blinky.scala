package blinky

import spinal.core._
import spinal.lib._

class Blinky extends Component {
    val io = new Bundle {
        val led = out Bool
    }

    val externalClockDomain = ClockDomain.external(
        "",
        ClockDomainConfig(resetKind=BOOT)
    )

    new ClockingArea(externalClockDomain) {
        val toggle = RegInit(False)
        when (Counter(8 * 1000 * 1000, inc=True).willOverflow) {
            toggle := !toggle
        }

        io.led := toggle
    }

    noIoPrefix()
}

object BlinkySpinalConfig extends SpinalConfig(mode = Verilog)

object BlinkyVerilog {
    def main(args: Array[String]) {
        BlinkySpinalConfig.generateVerilog(new Blinky())
    }
}