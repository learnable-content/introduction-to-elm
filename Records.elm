module Records exposing (..)


type alias Account =
    { email : String
    , name : String
    , rewardPoints : Int
    }


account : Account
account =
    Account "luke@email.com" "Luke" 100


updatedAccount : Account
updatedAccount =
    { account | rewardPoints = 150 }


currentPoints : Int
currentPoints =
    .rewardPoints updatedAccount


rewardPoints : { a | rewardPoints : Int } -> Int
rewardPoints value =
    value.rewardPoints
