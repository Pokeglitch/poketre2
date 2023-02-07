    Array BattleMode, None, Pokemon, Trainer

MACRO SetBattleMode
    ld a, BattleMode\1
    ld [wBattleMode], a
ENDM

MACRO PrepareBattle
    DEF BATTLE_MODE = BattleModePokemon
    REDEF BYTE_2_DESTINATION EQUS "wCurEnemyLVL"
    DEF STORE_BYTE_2 = 1

    IF DEF(\1Table)
        IF STRCMP("{\1Table}","Trainer") == 0
            DEF BATTLE_MODE = BattleModeTrainer
            REDEF BYTE_2_DESTINATION EQUS "wTrainerNo"
        ENDC
    ENDC

    ; If there are two arguments, store the second one first if it is 'a'
    IF _NARG == 2
        IF STRCMP("\2", "a") == 0
            ld [BYTE_2_DESTINATION], a
            DEF STORE_BYTE_2 = 0
        ENDC
    ELSE
        DEF STORE_BYTE_2 = 0
    ENDC

    ; If the first argument isn't 'a', then load it into a
    IF STRCMP("\1", "a") != 0
        ld a, \1
    ENDC
    ld [wCurOpponent], a

    ; Load the second argument if still necessary
    IF STORE_BYTE_2
        ld a, \2
        ld [BYTE_2_DESTINATION], a
    ENDC

    ; Set the battle mode
    ld a, BATTLE_MODE
    ld [wBattleMode], a
ENDM