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
    <$> areq textField (FieldSettings{
        fsLabel = "Nome: ",	 
        fsTooltip = Nothing, 
        fsId = Nothing,	 
        fsName = Nothing,	 
        fsAttrs = [("class", "form-control")]
        
        }) Nothing
    <*> areq emailField (FieldSettings{
        fsLabel = "Email: ",	 
        fsTooltip = Nothing, 
        fsId = Nothing,	 
        fsName = Nothing,	 
        fsAttrs = [("class", "form-control")]
        
        }) Nothing
    <*> areq passwordField (FieldSettings{
        fsLabel = "Senha: ",	 
        fsTooltip = Nothing, 
        fsId = Nothing,	 
        fsName = Nothing,	 
        fsAttrs = [("class", "form-control")]
        
        }) Nothing


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
