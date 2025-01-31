- node.js版本  
    此版本會先將空白和符號的部分移除  
    把所有單字變成陣列，只會辨認單字，且要完全一致  
    例如 keyowrd: apple  
    ✔apple  
    ✘pineapple  
    使用方法  
    `node main.js $filepath $keyword`

- shell版本  
    此版本不管是否為單字，只要符合都會計算一次  
    使用方法  
    `sh ./shell.sh $filepath`