{-# LANGUAGE OverloadedStrings #-}

module Shortener where

import Control.Monad.IO.Class (MonadIO(liftIO))
import Data.Foldable (for_)
import Data.IORef (modifyIORef, newIORef, readIORef)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Text (Text)
import qualified Data.Text.Lazy as LT
import Network.HTTP.Types (status404)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Web.Scotty

shortener :: IO ()
shortener = do
  -- create a Map and initialize it to urlsR variable
  urlsR <- newIORef (1 :: Int, mempty :: Map Int Text)

  -- scotty package creates the local server that runs on port 3000
  scotty 3000 $ do

    --initially when user's hit the / route this page should be loaded
    get "/" $ do
      (_, urls) <- liftIO $ readIORef urlsR
      html $ renderHtml $
        H.html $
          H.body $ do
            H.title "URL Shortener"
            H.h1 "ez" H.! A.style "text-align: center;font-family: Arial, Helvetica, sans-serif;font-size:100px"
            H.h2 "URL Shortener" H.! A.style "text-align: center;"

            -- form to take in user data and send a post request to /
            H.form H.! A.method "post" H.! A.action "/" H.! A.style "display: flex;justify-content: center;" $ do
              H.input H.! A.type_ "text" H.! A.name "url" H.! A.autofocus "text"
              H.input H.! A.type_ "submit"
            
            --table to display all the generated links along with original link
            H.table H.! A.style "display: flex;justify-content: center;border-collapse: collapse;" $ do
              H.tr $ do
                H.th "index" H.! A.style "border: 1px solid;"
                H.th "Original Link" H.! A.style "border: 1px solid;"
                H.th "Generated Link" H.! A.style "border: 1px solid;" 
              for_ (M.toList urls) $ \(i, url) -> 
                H.tr H.! A.style "border: 1px solid;" $ do
                  H.td (H.toHtml i) H.! A.style "border: 1px solid;"
                  H.td (H.text url) H.! A.style "border: 1px solid;"
                  H.td $ do
                    let x="http://localhost:3000/"++ show i
                    let key= H.toValue(x)
                    H.a (H.toHtml x) H.! A.href key H.! A.target "_blank"
            H.p "*You can access this Generated link from any where*" H.! A.style "text-align: center;"
    
    -- inserting the url into map and save in files 
    post "/" $ do
      url <- param "url"
      liftIO $ modifyIORef urlsR $
        \(i, urls) ->
          (i + 1, M.insert i url urls)
      redirect "/"
    
    -- retrieving the generated url based on the original url
    get "/:n" $ do
      n <- param "n"
      (_, urls) <- liftIO $ readIORef urlsR
      case M.lookup n urls of
        Just url ->
          redirect (LT.fromStrict url)
        Nothing ->
          raiseStatus status404 "not found"