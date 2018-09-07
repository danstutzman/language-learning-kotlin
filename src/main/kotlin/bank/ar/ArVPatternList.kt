package com.danstutzman.bank.ar

class ArVPatternList {
  val patterns = listOf(
    ArVPattern( -200, null,       1, 1, ArTense.PAST, null, "-otu"),
    ArVPattern( -201, ArGender.M, 1, 2, ArTense.PAST, null, "-ota"),
    ArVPattern( -202, ArGender.F, 1, 2, ArTense.PAST, null, "-oti"),
    ArVPattern( -203, ArGender.M, 1, 3, ArTense.PAST, null, "-a"),
    ArVPattern( -204, ArGender.F, 1, 3, ArTense.PAST, null, "-ato"),
    ArVPattern( -205, null,       3, 1, ArTense.PAST, null, "-onaA"),
    ArVPattern( -206, ArGender.M, 3, 2, ArTense.PAST, null, "-otumo"),
    ArVPattern( -207, ArGender.F, 3, 2, ArTense.PAST, null, "-otun~a"),
    ArVPattern( -208, ArGender.M, 3, 3, ArTense.PAST, null, "-uwA"),
    ArVPattern( -209, ArGender.F, 3, 3, ArTense.PAST, null, "-ona"),
    ArVPattern( -220, null,       1, 1, ArTense.PRES, ">a-", "-u"),
    ArVPattern( -221, ArGender.M, 1, 2, ArTense.PRES, "ta-", "-u"),
    ArVPattern( -222, ArGender.F, 1, 2, ArTense.PRES, "ta-", "-iyna"),
    ArVPattern( -223, ArGender.M, 1, 3, ArTense.PRES, "ya-", "-u"),
    ArVPattern( -224, ArGender.F, 1, 3, ArTense.PRES, "ta-", "-u"),
    ArVPattern( -225, null,       3, 1, ArTense.PRES, "na-", "-u"),
    ArVPattern( -226, ArGender.M, 3, 2, ArTense.PRES, "ta-", "-uwna"),
    ArVPattern( -227, ArGender.F, 3, 2, ArTense.PRES, "ta-", "-ona"),
    ArVPattern( -228, ArGender.M, 3, 3, ArTense.PRES, "ya-", "-uwna"),
    ArVPattern( -229, ArGender.F, 3, 3, ArTense.PRES, "ya-", "-ona")
  )
}
