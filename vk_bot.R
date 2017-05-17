selenium <- function(){
  require(RSelenium)
  require(dplyr)
  require(RJSONIO)
  require(httr)
  require(RCurl)
  rD <- rsDriver(port = as.integer(round(runif(1, 1000,9999))),browser = "chrome")
  remDr <- rD[["client"]]
  assign("remDr", remDr, envir = .GlobalEnv)
}

postvk <- function(login,pass,page){ 
  remDr$navigate("https://m.vk.com/login")
  login <- remDr$findElement(using = "xpath", value = '//*[@id="mcont"]/div/div[2]/form/dl[1]/dd/div/input')
  login$sendKeysToElement(list(login))
  pass <- remDr$findElement(using = "xpath", value = '//*[@id="mcont"]/div/div[2]/form/dl[2]/dd/div/input')
  pass$sendKeysToElement(list(pass))
  cl <- remDr$findElement(using = "xpath", value = '//*[@id="mcont"]/div/div[2]/form/div[1]/div[1]/input')
  cl$clickElement()
  Sys.sleep(1)
  remDr$navigate(page)
  Sys.sleep(2)
  post <- remDr$findElement(using = "xpath", value = '//*[@id="mcont"]/div/div[1]/div[2]/table/tbody/tr/td[1]/a')
  post$clickElement()
  Sys.sleep(2)
  rs <- remDr$findElement(using = "xpath", value = '//*[@id="write_form"]/div[1]/textarea')
  Sys.sleep(2)
  rs$sendKeysToElement(list("Це тестове повідомлення. Не звертайте на нього уваги"))
  send <- remDr$findElement(using = "xpath", value = '//*[@id="write_submit"]')
  send$clickElement()
  exit <- remDr$findElement(using = "xpath", value = '//*[@id="lm_cont"]/div[2]/ul/li[4]/a/span/span')
  if (is.null(exit)) break
  exit$clickElement()
  print("Message send")
}

library(tcltk)
library(tcltk2)

win1 <- tktoplevel()
win1$env$ok <- tk2button(win1,text="Run script", command=postvk)
win1$env$sel <- tk2button(win1,text="Start remote driver", command=selenium)
tkgrid(win1$env$ok, padx = 20, pady = 15)
tkgrid(win1$env$sel, padx = 50, pady = 35)