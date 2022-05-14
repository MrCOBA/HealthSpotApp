import time
from dataclasses import dataclass
from typing import Dict, List
from urllib.parse import urljoin

from bs4 import BeautifulSoup
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

from parser.base_parser import BaseParser

BASE_URL = 'https://eapteka.ru/'


@dataclass
class DrugLink:
    name: str
    link: str
    relative_link: str


class DrugsListParser(BaseParser):
    def parse(self, soup: BeautifulSoup) -> List[DrugLink]:
        links = []
        drugs_a = soup.find_all('a', attrs={'class': 'cc-item--title'})
        for a in drugs_a:
            name = a.text.strip().replace('&nbsp', ' ').replace('\xa0', ' ')
            href = urljoin(BASE_URL, a['href'])
            relative_href = a['href']
            links.append(DrugLink(name, href, relative_href))
        return links

    def load_page(self, driver: WebDriver, url: str):
        driver.get(url)
        try:
            WebDriverWait(driver, 3).until(EC.presence_of_element_located((By.CSS_SELECTOR, "div.categories-sort")))
            time.sleep(0.25)
            print(f"Loaded {url}")
        except TimeoutException:
            print("Loading took too much time!")
            raise
