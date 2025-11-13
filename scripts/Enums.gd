class_name Enum

enum IngState { RAW, CUT , COOKED}
enum Order { NONE, USE , STORE, UNSTORE, PICKUP, MIX}
enum TaskType {NONE, CUT, COOK, STORE, PICKUP, EMPTY, GENERATE, MIX,
GENERATE_TOMATO, GENERATE_BURGER, GENERATE_STEAK, GENERATE_SALAD,
INITAL_MIXER}

enum RecipeNames {Empty, EmptyPot, EmptyPan,
Tom, CutTom, PotCutTom, PotCutTomCutTom, PotCutTomCutTomCutTom, TomatoSoup,
Ste, CutSte, PanCutSte, PanCookCutSte, Sal, CutSal, Bur, BurSal, BurSte, BurSteSal,
BurSteSalTom, BurSalTom, BurTom, BurSteTom, CutTomCutSal}
