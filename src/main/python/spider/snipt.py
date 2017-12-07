# INITIALIZE DRIVER
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait


# CATCH EXCEPTIONS
from selenium.common.exceptions import TimeoutException,ElementNotVisibleException

driver = webdriver.Chrome()
driver.wait = WebDriverWait(driver, 5)


# WAIT FOR ELEMENTS
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC

element = driver.wait.until(
        EC.presence_of_element_located(
                EC.element_to_be_clickable(
                        EC.visibility_of_element_located(
                                (By.NAME, "name"),
                                (By.ID, "id"),
                                (By.LINK_TEXT, "link text"),
                                (By.PARTIAL_LINK_TEXT, "partial link text"),
                                (By.TAG_NAME, "tag name"),
                                (By.CLASS_NAME, "class name"),
                                (By.CSS_SELECTOR, "css selector"),
                                (By.XPATH, "xpath"),
                        )
                )
        )
)

