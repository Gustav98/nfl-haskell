{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Login where

import Import
import Database.Persist.Postgresql

formLogin :: Form (Text,Text)
formLogin = renderBootstrap $ (,) 
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing

getLoginR :: Handler Html
getLoginR = do
    msg <- getMessage
    (widget,enctype) <- generateFormPost formLogin
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            $maybe mensagem <- msg
                ^{mensagem}
            <form action=@{LoginR} method=post enctype=#{enctype}>
                ^{widget}
                <input type="submit" value="Log in">
        |]

-- Autenticacao
-- Entity id tabela -> Representa um registro vindo do BD
postLoginR :: Handler Html
postLoginR = do 
    ((res,_),_) <- runFormPost formLogin
    case res of 
        FormSuccess (email,senha) -> do 
            usu <- runDB $ getBy (UniqueEmail email)
            case usu of
                Just (Entity _ usuario) -> do 
                    if (senha == usuarioSenha usuario) then do
                        setSession "_ID" email
                        redirect HomeR
                    else do
                        setMessage [shamlet| Senha invalida |]
                        redirect RegistroR
                Nothing -> do
                    setMessage [shamlet| E-mail inexistente |]
                    redirect RegistroR
        _ -> redirect RegistroR

postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_ID"
    redirect HomeR