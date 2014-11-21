

module Render where

import Graphics.Gloss (display, makeColor, Display (..), Picture (..))

import Types


displayGrid :: Grid -> IO ()
displayGrid g = display d color picture
    where color = makeColor 0.9 0.2 0.5 1
          picture = Blank
          d = InWindow "game of life" (300, 300) (0, 0)
