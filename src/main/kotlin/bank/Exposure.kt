package bank

data class Exposure(
    val cardId: Int,
    val type: ExposureType,
    val time: Int // seconds past epoch UTC
) {}