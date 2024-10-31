module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      Shape(..),
      BST(Empty),
      volume,
      surfaceArea,
      is_approx,
      size,
      contains,
      insert,
      inorder
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List (isPrefixOf, find)
import Data.Char (isSpace, toLower)  

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

firstThenApply :: [element] -> (element -> Bool) -> (element -> result) -> Maybe result
firstThenApply [] _ _ = Nothing
firstThenApply (currentElement:remainingElements) condition transform
  | condition currentElement = Just (transform currentElement)
  | otherwise = firstThenApply remainingElements condition transform

powers :: Integer -> [Integer]
powers base = map (base^) [0..]

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
    content <- readFile path  
    let linesCount = length $ filter isMeaningfulLine (map trim (lines content)) 
    return linesCount 

isMeaningfulLine :: String -> Bool
isMeaningfulLine line = not (isEmpty line || isComment line)

isEmpty :: String -> Bool
isEmpty [] = True
isEmpty _  = False

isComment :: String -> Bool
isComment ('#':_) = True
isComment _       = False

trim :: String -> String
trim = f . f
   where f = reverse . dropWhile isSpace

data Shape = Sphere { sphereRadius :: Double }
           | Box { boxWidth :: Double, boxLength :: Double, boxDepth :: Double }
           deriving (Eq)

instance Show Shape where
    show (Sphere r) = "Sphere " ++ show r
    show (Box w l d) = "Box " ++ show w ++ " " ++ show l ++ " " ++ show d

volume :: Shape -> Double
volume (Sphere radius) = (4 / 3) * pi * radius^3
volume (Box width length depth) = width * length * depth

surfaceArea :: Shape -> Double
surfaceArea (Sphere radius) = 4 * pi * radius^2
surfaceArea (Box width length depth) = 2 * (width * length + length * depth + width * depth)

is_approx :: Double -> Double -> Bool
is_approx x y = abs (x - y) < 1e-6

data BST a
    = Empty
    | Node a (BST a) (BST a)
    deriving (Eq)

instance (Show a) => Show (BST a) where
  show :: Show a => BST a -> String
  show Empty = "()"
  show (Node nodeValue leftSubtree rightSubtree) =
      let full = "(" ++ show leftSubtree ++ show nodeValue ++ show rightSubtree ++ ")" in
        unpack $ replace (pack"()") (pack "") (pack full)

insert :: (Ord a) => a -> BST a -> BST a
insert newValue Empty = Node newValue Empty Empty
insert newValue (Node nodeValue leftSubtree rightSubtree)
    | newValue < nodeValue = Node nodeValue (insert newValue leftSubtree) rightSubtree
    | newValue > nodeValue = Node nodeValue leftSubtree (insert newValue rightSubtree)
    | otherwise = Node nodeValue leftSubtree rightSubtree 

size :: BST a -> Int
size Empty = 0
size (Node _ leftSubtree rightSubtree) = 1 + size leftSubtree + size rightSubtree

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node nodeValue leftSubtree rightSubtree) = inorder leftSubtree ++ [nodeValue] ++ inorder rightSubtree

contains :: (Ord a) => a -> BST a -> Bool
contains _ Empty = False
contains searchValue (Node nodeValue leftSubtree rightSubtree)
    | searchValue < nodeValue = contains searchValue leftSubtree
    | searchValue > nodeValue = contains searchValue rightSubtree
    | otherwise = True
