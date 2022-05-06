module TowerDefense exposing (..)

import Assets.Object
import Assets.Type.Tower.Small


initTowerList : List.Empty Assets.Object.Properties
initTowerList =
    [ Assets.Type.Tower.Small.init ]
