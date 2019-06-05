{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cadastro where

import Import
import Database.Persist.Postgresql

formCadastro :: Form (Text,Text, Text)
formCadastro = renderBootstrap $ (,,) 
    <$> areq textField "Nome: " Nothing
    <*> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing


getCadastroR :: Handler Html
getCadastroR = do
    msg <- getMessage
    (widget,enctype) <- generateFormPost formCadastro
    defaultLayout $ do
        addStylesheet $ StaticR css_bootstrap_css
        [whamlet|
            $maybe mensagem <- msg
                ^{mensagem}
            <form action=@{CadastroR} method=post enctype=#{enctype}>
                ^{widget}
                <input type="submit" value="Cadastro">
        |]

-- Autenticacao
-- Entity id tabela -> Representa um registro vindo do BD
postCadastroR :: Handler Html
postCadastroR = do 
    ((res,_),_) <- runFormPost formCadastro
    case res of 
        FormSuccess (nome,email,senha) -> do 
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
