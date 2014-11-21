import qualified Data.Array as A
import           Data.Array ((!))
import qualified Data.Ix as I
import           Control.Monad (guard, replicateM_)
import qualified System.Random as R
import qualified Control.Concurrent as C

type Grid = A.Array (Int, Int) Bool

update :: Grid -> Grid
update old = A.array bounds $ do
  x <- [lx..ux]
  y <- [ly..uy]
  
  return ((x,y), newState (x,y) old)
    where bounds = A.bounds old
          ((lx, ly), (ux, uy)) = bounds

newState :: (Int, Int) -> Grid -> Bool
newState i grid = if grid ! i
                  then nLiveNeighbours `elem` [2, 3]
                  else nLiveNeighbours == 3
  where nLiveNeighbours = length (liveNeighbours i grid)

liveNeighbours :: (Int, Int) -> Grid -> [(Int, Int)]
liveNeighbours (x, y) grid = do
  dx <- [-1..1]
  dy <- [-1..1]
  guard (not ((dx == 0) && (dy == 0)))
  let r = (x + dx, y + dy)
  guard (I.inRange (A.bounds grid) r)
  guard (grid ! r)
  return r

initial :: Int -> IO Grid
initial n = A.listArray ((1,1), (n,n)) `fmap` 
            sequence (replicate (n*n) R.randomIO)

printState :: Bool -> IO ()
printState True = putStr "X"
printState False = putStr " "

printGrid :: (Int, Int) -> Grid -> IO ()
printGrid (x, y) grid | y > uy = return ()
                      | y < ly = printGrid (x, ly) grid
                      | x > ux = do putStrLn ""
                                    printGrid (lx, y+1) grid
                      | x < lx = printGrid (lx, y) grid
                      | otherwise = do printState (grid ! (x, y))
                                       printGrid (x+1, y) grid

  where ((lx, ly), (ux, uy)) = A.bounds grid

main :: IO ()
main = do
  start <- initial 30

  let times = take 100 (iterate update start)
  
  mapM_ (\g -> printGrid (0,0) g
               >> C.threadDelay 100000
        ) times
