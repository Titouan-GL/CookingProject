class_name Enum

enum Order { NONE, USE , STORE, UNSTORE, PICKUP, MIX}
enum TaskType {NONE, CUT, COOK, STORE, PICKUP, EMPTY, GENERATE, MIX, CLEAN,
GENERATE_TOMATO, GENERATE_BURGER, GENERATE_STEAK, GENERATE_SALAD, GENERATE_PLATE,
INITAL_MIXER}

enum RecipeNames {Empty, EmptyPot, EmptyPan, #2
Tom, CutTom, PotCutTom, PotCutTomCutTom, PotCutTomCutTomCutTom, TomatoSoup, #8
Ste, CutSte, PanCutSte, PanCookCutSte, Sal, CutSal, Bur, BurSal, BurSte, BurSteSal, #18
BurSteSalTom, BurSalTom, BurTom, BurSteTom, CutTomCutSal, EmptyPlate, PotTomatoSoup, #25
SteSal, SteTom, SteSalTom}

enum CustomizationNames {
	None,
	GlassesRound, GlassesRectangle, GlassesCat, PiercingMiddle, PiercingSide,
	MoustacheChevron, MoustachePencil, MoustacheEnglish, MoustacheHorseshoe
}
