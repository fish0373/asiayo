const fs = require("fs");

const args = process.argv

const filePath = args[2] || ""
const keywords = (args[3] || "").toLowerCase()
if(!fs.existsSync(filePath) || fs.lstatSync(filePath).isDirectory()){
    console.error('錯誤: 未傳入檔案路徑或檔案不存在')
    process.exit(1)
}
if(!keywords) {
    console.error('錯誤: 未傳入關鍵字')
    process.exit(1)
}

const fileContent = fs.readFileSync("./words.txt", {encoding:'utf-8'})
const reduceData = fileContent.split(new RegExp(",|\\.|\\s|\\!")).filter(e=>e);

const matches = reduceData.filter(e=>e.toLowerCase() === keywords)

console.log(`${matches.length} ${keywords}`)