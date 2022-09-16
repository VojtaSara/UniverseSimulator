--  _    _ _   _ _______      ________ _____   _____ ______      
-- | |  | | \ | |_   _\ \    / /  ____|  __ \ / ____|  ____|     
-- | |  | |  \| | | |  \ \  / /| |__  | |__) | (___ | |__        
-- | |  | | . ` | | |   \ \/ / |  __| |  _  / \___ \|  __|       
-- | |__| | |\  |_| |_   \  /  | |____| | \ \ ____) | |____      
--  \____/|_|_\_|_____| _ \/ _ |______|_|  \_\_____/|______|___  
--  / ____|_   _|  \/  | |  | | |        /\|__   __/ __ \|  __ \ 
-- | (___   | | | \  / | |  | | |       /  \  | | | |  | | |__) |
--  \___ \  | | | |\/| | |  | | |      / /\ \ | | | |  | |  _  / 
--  ____) |_| |_| |  | | |__| | |____ / ____ \| | | |__| | | \ \ 
-- |_____/|_____|_|  |_|\____/|______/_/    \_\_|  \____/|_|  \_\

import Data.List
-- first a function that gives all unique n-sized subsets of a given set
ntets x n = flatten (map permutate (filter (\e -> length e == n) (ntets' x) ))

flatten [] = []
flatten (x:xs) = x ++ flatten xs

ntets' [] = [[]]
ntets' (x:xs) = ntets' xs ++ map (x:) (ntets' xs)

permutate :: (Eq a) => [a] -> [[a]]
permutate [] = [[]]
permutate l = [a:x | a <- l, x <- (permutate $ filter (\x -> x /= a) l)]

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x : xs) = x : rmdups (filter (/= x) xs)

rulerank = 2
rule1 [[a,b],[x,y]] = if a == y then [[a,y],[b,x],[a,x]] else []

universe_singularity1 = [[1,2],[4,1],[7,6],[3,7]]

filterByArray all applied = map (\(_,b) -> b) (filter (\(e,_) -> e /= []) (zip all applied))
-- postupně projít dvojice a když se najde dvojice dvojic matchující pravidlu, aplikujeme pravidlo, dvojici smažeme a výsledek dáme do bufferu
--  oneStep [[1,2], [1,3], [5,6]] 

oneStep original =
    let nonapplied = ntets original rulerank
        applied = map rule1 (ntets original rulerank)
        applied_original = flatten (filterByArray applied nonapplied)
        afterStep = rmdups ((original \\ applied_original) ++ flatten (filter (\e -> e /= []) applied))
    in afterStep

nSteps original n = foldr (.) id (replicate 3 oneStep) original

-- TODO: add vertex adding rules - for that the list of all existing vertices have to be passed 
-- to the rule. Hmm maybe thats wrong though as one new vertex might be added multiple times.
-- This goes to show that maybe we will need to apply the rules more lazily in the end
-- [edges not applied yet] <RULE> []
-- |||///
-- THE FUNCTION APPLYRULEONCE
-- |||\\\
-- [edges not applied yet - the one that just got applied] <RULE> [what_was_just_applied:_]

-- The main loop: applyruleonce while possible - return accumulated result in the end.
