{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Registro where

import Import
import Yesod

import Database.Persist.Postgresql

getRegistroR :: Handler Html
getRegistroR = do
    defaultLayout $ do 
        addStylesheet $ StaticR css_style_css
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/registro.hamlet")
        
        
