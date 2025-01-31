
if [ -z $1 ]; then
    echo "錯誤: 請填寫要檢查的文件"
    exit 1
fi
if [ ! -e "$1" ]; then
    echo "錯誤: 請要檢查的文件不存在"
    exit 1
fi
read -p "關鍵字: " keyword
if [ -z $keyword ]; then
    echo "錯誤: 未設定關鍵字"
    exit 1
fi
result=$(grep -oi "$keyword" $1 | wc -l)

echo $result $keyword