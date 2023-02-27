from bs4 import BeautifulSoup

html = "<h1>sayhello</h1>,<h1>saysay</h1>,<h2>say</h2>"
#第一引数に、実際に解析したいものをおき、第二引数にパーサを指定
soup = BeautifulSoup(html, "html.parser")

print(soup.select("h1"))
