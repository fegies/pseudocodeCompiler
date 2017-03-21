{
module Lexer (lexer) where

import Tokens
import HexMod
}

%wrapper "posn"

$digit = 0-9      -- digits
$alpha = [a-zA-Z]   -- alphabetic characters

tokens :-

  $white+         ;
  if              { \p s -> ( toPos p , TokenIf ) }
  then            { \p s -> ( toPos p , TokenThen ) }
  else            { \p s -> ( toPos p , TokenElse ) }
  fi              { \p s -> ( toPos p , TokenFi ) }
  while           { \p s -> ( toPos p , TokenWhile ) }
  do              { \p s -> ( toPos p , TokenDo ) }
  od              { \p s -> ( toPos p , TokenOd ) }
  repeat          { \p s -> ( toPos p , TokenRepeat ) }
  until           { \p s -> ( toPos p , TokenUntil ) }
  for             { \p s -> ( toPos p , TokenFor ) }
  to              { \p s -> ( toPos p , TokenTo ) }
  downto          { \p s -> ( toPos p , TokenDownto ) }
  return          { \p s -> ( toPos p , TokenReturn ) }
  function        { \p s -> ( toPos p , TokenFunction ) }
  "class"         { \p s -> ( toPos p , TokenClass ) }
  new             { \p s -> ( toPos p , TokenNew ) }
  load            { \p s -> ( toPos p , TokenLoad ) }
  \;              { \p s -> ( toPos p , TokenSemicolon ) }
  \(              { \p s -> ( toPos p , TokenRBOpen ) }
  \)              { \p s -> ( toPos p , TokenRBClose ) }
  \{              { \p s -> ( toPos p , TokenCBOpen ) }
  \}              { \p s -> ( toPos p , TokenCBClose ) }
  \[              { \p s -> ( toPos p , TokenSBOpen ) }
  \]              { \p s -> ( toPos p , TokenSBClose ) }
  "<-"            { \p s -> ( toPos p , TokenLeftarrow ) }
  ==              { \p s -> ( toPos p , TokenCompEq ) }
  "!="            { \p s -> ( toPos p , TokenCompNeq ) }
  ">="            { \p s -> ( toPos p , TokenCompGeq ) }
  "<="            { \p s -> ( toPos p , TokenCompLeq ) }
  "&&"            { \p s -> ( toPos p , TokenLogicAnd ) }
  "||"            { \p s -> ( toPos p , TokenLogicOr ) }
  \>              { \p s -> ( toPos p , TokenCompGt ) }
  \<              { \p s -> ( toPos p , TokenCompLt ) }
  \+              { \p s -> ( toPos p , TokenArithPlus ) }
  \-              { \p s -> ( toPos p , TokenArithMinus ) }
  \*              { \p s -> ( toPos p , TokenArithMul ) }
  \/              { \p s -> ( toPos p , TokenArithDiv ) }
  \%              { \p s -> ( toPos p , TokenArithMod ) }
  "++"            { \p s -> ( toPos p , TokenArithInc ) }
  "--"            { \p s -> ( toPos p , TokenArithDec ) }
  \,              { \p s -> ( toPos p , TokenComma ) }
  \.              { \p s -> ( toPos p , TokenDot ) }
  \$              { \p s -> ( toPos p , TokenDollar )}
  \".+\"          { \p s -> ( toPos p , TokenStringLit $ reverse . tail . reverse . tail $ s ) }
  '!'             { \p s -> ( toPos p , TokenLogicNot ) }
  $digit+         { \p s -> ( toPos p , TokenInt $ read s ) }
  $alpha+         { \p s -> ( toPos p , TokenWord s ) }
  @[0-9a-fA-F]+   { \p s -> ( toPos p , TokenInstr $ readHex . tail $ s)}
  :[0-9a-fA-F]+   { \p s -> ( toPos p , TokenAdditionalData $ readHex . tail $ s)}

{
-- Each action has type :: AlexPosn String -> LexToken

toPos :: AlexPosn -> LexerPosition
toPos (AlexPn off line column ) = (off, line, column)

lexer = alexScanTokens
}
