module TowerDefense exposing (..)

import Assets.Object
import Assets.Type.Enemy.Warrior
import Assets.Type.Tower.Default
import Assets.Type.Tower.Small


initTowerList : List.Empty (Assets.Object.Properties a)
initTowerList =
    [ Assets.Type.Tower.Small.init, Assets.Type.Tower.Default.init ]


initEnemyList : List.Empty (Assets.Object.Properties a)
initEnemyList =
    [ Assets.Type.Enemy.Warrior.init ]
