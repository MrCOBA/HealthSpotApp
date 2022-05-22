import time
from typing import Dict

from bs4 import BeautifulSoup, Tag
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

from parser.base_parser import BaseParser


def try_int(s):
    try:
        return int(s)
    except ValueError:
        return s


class DrugInfoParser(BaseParser):
    def __get_text_from_a_or_p(self, p: Tag):
        if p is None:
            return ''
        a = p.find('a')
        if a is not None:
            return a.text.strip()
        return p.text.split(':', maxsplit=1)[-1].strip()

    def parse(self, soup: BeautifulSoup) -> Dict[str, str]:
        name = soup.find('meta', attrs={'itemprop': 'name'})['content'].strip()
        url = soup.find('meta', attrs={'itemprop': 'url'})['content'].strip()

        description_div = soup.find('div', {'class': 'description__item'})

        producer_p = self._find_by_text(description_div, "Производитель:", 'p')
        producer = self.__get_text_from_a_or_p(producer_p)
        if producer == '':
            print("\t\tProducer not found")

        active_component_p = self._find_by_text(description_div, "Действующее вещество:", 'p')
        active_component = self.__get_text_from_a_or_p(active_component_p)
        if active_component == '':
            print("\t\tActive component not found")

        qr = ''
        qr_p = self._find_by_text(soup, "Штрих-код:", 'div')
        if qr_p is not None:
            qr_str = qr_p.text.split(': ')[1]
            qr = list(map(try_int, qr_str.split(', ')))
        if qr == '':
            print("\t\tQR-code not found")

        return {
            'name': name,
            'producer': producer,
            'active_component': active_component,
            'qrcode': qr,
            'url': url
        }

    def load_page(self, driver: WebDriver, url: str):
        driver.get(url)
        try:
            WebDriverWait(driver, 3).until(EC.presence_of_element_located((By.CSS_SELECTOR, "meta[itemprop='name']")))
            time.sleep(0.25)
            print(f"Loaded {url}")
        except TimeoutException:
            print("Loading took too much time!")
            raise
