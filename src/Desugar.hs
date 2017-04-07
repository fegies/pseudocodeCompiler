module Desugar(desugar,foldConstants,optimiseAst) where

import Ast
import Debug.Trace

optimiseAst = foldConstants . desugar

desugar :: Expression -> Expression
desugar (ExpressionInc (ExpressionLookup i)) =
    ExpressionAssign i (ExpressionArithPlus (ExpressionLookup i) (ExpressionConstant $ ConstantInt 1))
desugar (ExpressionInc _) = error "only Identifiers allowed in increment."
desugar (ExpressionDec (ExpressionLookup i)) =
    ExpressionAssign i (ExpressionArithMinus (ExpressionLookup i) (ExpressionConstant $ ConstantInt 1))
desugar (ExpressionDec _) = error "only Identifiers allowed in decrement."
desugar e = astApply e desugar

foldConstFInt :: Expression -> Expression -> (Integer -> Integer -> Integer) -> (Bool, Expression, Expression)
foldConstFInt e1 e2 f =
    let le = foldConstants e1
        re = foldConstants e2
    in case le of
        (ExpressionConstant (ConstantInt li)) ->
            case re of
                (ExpressionConstant (ConstantInt ri) )->
                    (True, ExpressionConstant $ ConstantInt (f li ri), EmptyExpression)
                a -> (False, le, re)
        a -> (False, le, re)

foldConstFBool :: Expression -> Expression -> (Bool -> Bool -> Bool) -> (Bool,Expression,Expression)
foldConstFBool e1 e2 f =
    let le = foldConstants e1
        re = foldConstants e2
    in case le of
        (ExpressionConstant (ConstantBool li)) ->
            case re of
                (ExpressionConstant (ConstantBool ri) )->
                    (True, ExpressionConstant $ ConstantBool (f li ri), EmptyExpression)
                a -> (False, le, re)
        a -> (False, le, re)

foldConstants :: Expression -> Expression
foldConstants (ExpressionArithPlus p1 p2)
    = case foldConstFInt p1 p2 (+) of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionArithPlus e1 e2
foldConstants (ExpressionArithMinus p1 p2)
    = case foldConstFInt p1 p2 (-) of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionArithMinus e1 e2
foldConstants (ExpressionArithMul p1 p2)
    = case foldConstFInt p1 p2 (*) of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionArithMul e1 e2
foldConstants (ExpressionArithDiv p1 p2)
    = case foldConstFInt p1 p2 div of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionArithDiv e1 e2
foldConstants (ExpressionArithMod p1 p2)
    = case foldConstFInt p1 p2 mod of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionArithMod e1 e2
foldConstants (ExpressionAnd p1 p2)
    = case foldConstFBool p1 p2 (&&) of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionAnd e1 e2
foldConstants (ExpressionOr p1 p2)
    = case foldConstFBool p1 p2 (||) of
        (True, e1, _) -> e1
        (False, e1, e2) -> ExpressionOr e1 e2
foldConstants e = astApply e foldConstants
