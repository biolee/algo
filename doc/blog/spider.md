爬虫一般需要四大组件

- downloader
- target_extractor
- link_extractor
- work_manager

根据不同场景这里有2类4种方法：
1. 直接下载网页，使用css或者xpath提取数据
	1. 直接使用python requests + xpath进行
	```python
    import requests
    from scrapy.selector import Selector
    
    resp = requests.get("https://baidu.com").text
    t = Selector(text=resp).xpath('//*[@id="su"]/@value').extract()
    print(t)
    ```
	2. scrapy, 比较重的爬虫框架应该都和scrapy大同小异
2. 在一些反爬虫策略比较复杂的时候操作浏览器，然后从浏览器的API提取数据
	1. python -> selenium -> ChromeDriver -> chrome
	2. js -> puppeteer -> chrome

# python selenium

[doc](http://selenium-python.readthedocs.io/api.html)

## 开发环境

1. Ensure Chromium/Google Chrome is installed in a recognized location
2. download [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)
3. ChromeDriver location in PATH env

## start

python + selenium的基本流程是：

1. 让浏览器获取网页
2. 使用`selector`选中element
3. 做一些反反爬虫的`action`
4. 用`extractor`提取信息

```python
import time
from selenium import webdriver

driver = webdriver.Chrome('/path/to/chromedriver')
driver.get('http://www.google.com/xhtml');
time.sleep(5) # Let the user actually see something!
search_box = driver.find_element_by_name('q')
search_box.send_keys('ChromeDriver')
search_box.submit()
time.sleep(5) # Let the user actually see something!
driver.quit()
```

## selector

```python
# one
driver.find_element_by_id()
driver.find_element_by_name()
driver.find_element_by_xpath()
driver.find_element_by_link_text()
driver.find_element_by_partial_link_text()
driver.find_element_by_tag_name()
driver.find_element_by_class_name()
driver.find_element_by_css_selector()
# return list
driver.find_elements_by_name()
driver.find_elements_by_xpath()
driver.find_elements_by_link_text()
driver.find_elements_by_partial_link_text()
driver.find_elements_by_tag_name()
driver.find_elements_by_class_name()
driver.find_elements_by_css_selector()

from selenium.webdriver.common.by import By
driver.find_element(By.XPATH, '//button[text()="Some text"]')
driver.find_elements(By.XPATH, '//button')
```

## action

```python
driver.forward()
driver.back()

element.send_keys("some text")
element.send_keys(" and some", Keys.ARROW_DOWN)
element.clear()
ele.click()
element.submit()


cookie = {‘name’ : ‘foo’, ‘value’ : ‘bar’}
driver.add_cookie(cookie)
```

## extractor

```python
element.text
element.get_attribute()
element.get_property()
driver.get_cookies()
driver.get_screenshot_as_base64()
```
## js + puppeteer + chrome

chrome最近推出了[puppeteer](https://github.com/GoogleChrome/puppeteer)项目，让js操作`chrome headless`，方便做js的集成测试，同时也可以用于写爬虫. puppeteer后面是调用chrome dev api的websocket.

基本流程和python + selenium类似，不过接口更友好，使用`async/await`能够减轻写异步的心智成本

[try-puppeteer](https://try-puppeteer.appspot.com/)
[puppeteer src](https://github.com/GoogleChrome/puppeteer)
[puppeteer api](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md)

```js
const puppeteer = require('puppeteer');

const browser = await puppeteer.launch({headless:false});
const page = await browser.newPage();
console.log(Date.now())
await page.goto('https://baidu.com', {
timeout: 0,
waitUntil: ["domcontentloaded"]
});
await page.pdf({
  path: 'hn.pdf',
  format: 'letter'
});

await browser.close();
```

# 反反爬虫

1. 模拟浏览器的useragent
2. 获取并返回cookies
3. 模拟所有header
4. IP 池
4. 验证码识别
5. 上面的操作浏览器

## 验证码识别
TODO