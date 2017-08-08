package bank

data class Exposure(
    val cardId: Int,
    val type: ExposureType,

    // Times are measured in milliseconds past epoch UTC
    val presentedAt: Long,
    val firstRespondedAt: Long,

    val wasRecalled: Boolean?
) {}