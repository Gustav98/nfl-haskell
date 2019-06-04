{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import

import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    defaultLayout $ do 
        addStylesheet $ StaticR css_style_css
        addStylesheet $ StaticR css_bootstrap_css
        addStylesheetRemote "https://use.fontawesome.com/releases/v5.8.2/css/all.css"
        $(whamletFile "templates/home.hamlet")
        
        
