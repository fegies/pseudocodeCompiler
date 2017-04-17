module Typecheck.Typecheck(typecheck,Context) where

import qualified Data.Map.Strict as Map
import Ast.Type
import Ast.Expression
import Ast.ExprTree
import Parser.Tokens

type Context = Map.Map String ExprType

type ContextStack = [Context]

type ContextfulExpression = (ExprType,ExpressionBase,LexerPosition,Context)

typecheck = fst . statefulTreeApplyTopDownBottomUp typecheckDown typecheckUp []

typecheckDown :: ExprTree ParserExpression -> ContextStack -> (ContextfulExpression,[ExprTree ParserExpression],ContextStack)
typecheckDown a s = undefined

typecheckUp :: ExprTree ContextfulExpression -> ContextStack -> (ExprTree ContextfulExpression,ContextStack)
typecheckUp a s = undefined

unifyContexts :: Context -> Context -> Maybe Context
unifyContexts = undefined

unifyTypes :: ExprType -> ExprType -> Maybe ExprType
unifyTypes UnknownType b = Just b
unifyTypes a UnknownType = Just a
unifyTypes a b
    | a == b = Just a
    | otherwise = Nothing
