module Trans exposing (transl)

import Dict

latIvrit = Dict.fromList [ ("'" , "\u{05D0}") -- alef
                         , ("b" , "\u{05D1}") , ("b." , "\u{FB31}")
                         , ("g" , "\u{05D2}") , ("g." , "\u{FB32}")
                         , ("d" , "\u{05D3}") , ("d." , "\u{FB33}")
                         , ("h" , "\u{05D4}") , ("h." , "\u{FB34}")
                         , ("w" , "\u{05D5}") , ("w." , "\u{FB35}") 
                         , ("z" , "\u{05D6}") , ("z." , "\u{FB36}")
                         , ("H" , "\u{05D7}") -- heth
                         , ("T" , "\u{05D8}") , ("T." , "\u{FB38}")
                         , ("y" , "\u{05D9}") , ("y." , "\u{FB39}")
                         , ("k" , "\u{05DB}") , ("k." , "\u{FB3B}") 
                         , ("l" , "\u{05DC}") , ("l." , "\u{FB3C}") 
                         , ("m" , "\u{05DE}") , ("m." , "\u{FB3E}") 
                         , ("n" , "\u{05E0}") , ("n." , "\u{FB40}") 
                         , ("c" , "\u{05E1}") , ("c." , "\u{FB41}") -- samekh
                         , ("A" , "\u{05E2}") -- ain
                         , ("p" , "\u{05E4}") , ("p." , "\u{FB44}") 
                         , ("S" , "\u{05E6}") , ("S." , "\u{FB46}") -- tsade
                         , ("q" , "\u{05E7}") , ("q." , "\u{FB47}") 
                         , ("r" , "\u{05E8}") , ("r." , "\u{FB48}") 
                         , ("s" , "\u{FB2B}") , ("s." , "\u{FB2D}") -- sin
                         , ("$" , "\u{FB2A}") , ("$." , "\u{FB2C}") -- shin
                         , ("t" , "\u{05EA}") , ("t." , "\u{FB4A}") 
                         , ("a" , "\u{05B7}")
                         , ("â" , "\u{05B8}")
                         , ("e" , "\u{05B6}")
                         , ("ê" , "\u{05B5}")
                         , ("i" , "\u{05B4}")
                         , ("o" , "\u{05B9}")
                         , ("ô" , "\u{FB4B}")
                         , ("u" , "\u{05BB}")
                         , ("û" , "\u{FB35}")
                         , ("x" , "\u{05B0}") , ("xà" , "\u{05B3}") , ("x&" , "\u{05B2}") , ("xé" , "\u{05B1}") -- shewa
                         , (":" , "\u{05C3}") -- sof pasukh
                         , ("," , "\u{0591}") -- athnah
                         , (";" , "\u{05BD}") -- silluk
                         , ("-" , "\u{05BE}") -- maqqef
                         , ("_" , "") -- filter _
                         ]

latIvrit_= Dict.fromList [ ("k" , "\u{05DA}") , ("k." , "\u{FB3A}") 
                         , ("m" , "\u{05DD}")  
                         , ("n" , "\u{05DF}") 
                         , ("p" , "\u{05E3}") , ("p." , "\u{FB43}") 
                         , ("S" , "\u{05E5}")
                         , ("_" , "") -- filter _
                         ]
finalforms : List String
finalforms =["k","m","n","p","S"]

diacritics : List String
diacritics = [".", "à","&","é"] -- dagesh,  hateph qamets, hateph pathah, hateph seghol

subst : String -> (Dict.Dict String String) -> String -- substitute one char (or char + diacritics) on the basis of dictionary
subst car dict =
  Maybe.withDefault car (Dict.get car dict)

subst_ : (String,String) -> String -- select dictionary on the basis of previous char : _ or not _, and substitute char
subst_ dble =
  let
     (carac, sub) = dble
  in
    if sub == "_" then subst carac latIvrit_ else subst carac latIvrit

szip : List String -> List (String,String) -- zip s with a right shift of itself
szip s =
  List.map2 Tuple.pair s ("&" :: s)

foldp : List String -> List String -> List String -- concatenate letters with their diacritics, if any
foldp acc list =
  case list of
    [] ->
      acc
    x::xs ->
      case xs of
        [] ->
          if List.member x finalforms then (subst x latIvrit_)::acc else x::acc
        y::ys ->
          if (y == " "|| y ==":") && List.member x finalforms then foldp ((subst x latIvrit_)::acc) xs
          else if List.member y diacritics then -- 1 diacritic
            case ys of
              [] ->
                (x++y)::acc
              z::zs ->
                if List.member z diacritics then -- 2 diacritics
                  case zs of
                    [] ->
                      (x++y++z)::acc
                    w::ws ->
                      if List.member w diacritics then -- 3 diacritics 
                        foldp ((x++y++z++w)::acc) ws
                      else
                        foldp ((x++y++z)::acc) zs
                else
                  foldp ((x++y)::acc) ys
          else
            foldp (x::acc) xs


transl : String -> String
transl chaine =
  chaine
    |> String.toList
    |> List.map String.fromChar
    |> foldp [] 
    |> List.reverse 
    |> szip
    |> List.map subst_
    |> List.foldr (++) ""
-- Examples:
-- וְאָהַבְתָּ אֵת יְהוָה אֶלֹהֶיךָ בְּכָל-לְבָבְךָ
-- Dt 5:6
-- wx'âhabt.â 'êt yxhwâh 'elohey_kâ b.xkâl-lxbâbx_kâ
-- With accents :
-- בְּרֵאשִׁית בָּרָ אֶלֹהִ֑ים אֵת הַשָּׁמַיִם וְאֵת הָאָֽרֶץ׃
-- Gen 1:1
-- b.xrê'$iyt b.ârâ 'elohi,ym 'êt ha$.âmayim wx'êt hâ'â;reS:
