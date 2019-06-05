{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Registro where

import Import
import Yesod

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
        
        
formLogin :: Form (Text,Text)
formLogin = renderBootstrap $ (,) 
    <$> areq emailField (FieldSettings{
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
    

getRegistroR :: Handler Html
getRegistroR = do
    (widget,enctype) <- generateFormPost formCadastro
    (widgetLogin,enctypeLogin) <- generateFormPost formLogin
    defaultLayout $ do 
        addStylesheet $ StaticR css_style_css
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/registro.hamlet")
        
        
        

