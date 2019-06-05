{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Jogo where

import Import
import Text.Lucius
import Text.Julius
import Database.Persist.Sql
import Prelude (read)
import Data.Maybe(fromJust)

getListarJogosR :: Handler Html
getListarJogosR = do
    jogos <- runDB $ selectList [] [Asc JogoDia]
    timesa <- mapM (fmap timeNome . runDB . get404 . jogoTimea . entityVal) jogos
    timesb <- mapM (fmap timeNome . runDB . get404 . jogoTimeb . entityVal) jogos
    let jt = zip3 jogos timesa timesb
    defaultLayout $ do 
        addStylesheet $ StaticR css_style_css
        addStylesheet $ StaticR css_bootstrap_css
        $(whamletFile "templates/jogos.hamlet")

