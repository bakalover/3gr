package functions

import kotlin.math.pow

class Ln(private val errorMargin: Double) : SomeFuncition {
    override fun eval(x: Double): Double {
        require(x > 0) { "Input must be greater than 0 for ln(x)" }

        var result = 0.0
        var term = x - 1.0
        var n = 1
        var sign = 1.0

        while (Math.abs(term) > errorMargin) {
            result += sign * term
            ++n
            sign *= -1
            term = (x - 1.0).pow(n) / n
        }

        return result
    }

}