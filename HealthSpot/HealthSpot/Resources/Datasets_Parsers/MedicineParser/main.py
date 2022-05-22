import glob
import json
import ntpath
import sys
import time
from os import path

from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.by import By

from parser.drug_page_parser import DrugInfoParser
from parser.drugs_list_parser import DrugsListParser


def find_last_successful_page(p):
    files = glob.glob(path.join(p, '*.json'))
    files = [int(ntpath.basename(f).split('.')[0]) for f in files]
    return max(files)


# URL = "https://eapteka.ru/goods/drugs/?sort=price&order=asc&PAGEN_1={page}"  # drugs
URL = "https://eapteka.ru/goods/vitaminy_i_bad/?sort=price&order=asc&PAGEN_1={page}"  # vitamins

# START_PAGE = 1
# LAST_PAGE = 1
# START_PAGE = int(sys.argv[1])
# LAST_PAGE = int(sys.argv[2])
# PAGES = range(START_PAGE, LAST_PAGE + 1)  # run like 'python main.py <start_page> <finish_page>'

# PAGES = [105, 106, 129, 131, 135, 138, 140, 141, 145, 148, 152, 157]  # manual setup
PAGES = map(int, sys.argv[1:])  # run like 'python main.py 1 2 3'

ALLOWED_ATTEMPTS = 4
FILES_FOLDER = 'parsed/vitamins/'


def get_driver() -> WebDriver:
    options = Options()
    options.add_argument("options.add_argument('--ignore-certificate-errors-spki-list')")
    driver = webdriver.Chrome(chrome_options=options, executable_path="chromedriver.exe")
    return driver


def main():
    drug_parser = DrugInfoParser()
    page_parser = DrugsListParser()

    driver = get_driver()

    for page in PAGES:
        for a in range(ALLOWED_ATTEMPTS):
            if a != 0:
                print(f"==================== RETRYING PAGE {page}. ATTEMPT: {a + 1}")
            try:
                url = URL.format(page=page)
                print(f"Started parsing {page=}, {url=}")

                page_parser.load_page(driver, url)
                soup = BeautifulSoup(driver.page_source, 'lxml')
                parsed = page_parser.parse(soup)
                print(f"Drugs found on page {page}: {len(parsed)}")

                results = []
                for ind, drug in enumerate(parsed):
                    print(f"Parsing {drug=}")
                    drug_parser.load_page(driver, drug.link)
                    soup = BeautifulSoup(driver.page_source, 'lxml')
                    if drug.name == 'Долак, таблетки покрыт.об.10 мг 20 шт':
                        pass
                    res = drug_parser.parse(soup)
                    results.append(res)
                    driver.back()
                    time.sleep(1)
                    loc = driver.find_element(By.CSS_SELECTOR, f"a[href='{drug.relative_link}']").location
                    driver.execute_script(f"window.scrollTo({loc['x']}, {loc['y']});")

                with open(f'{FILES_FOLDER}/{page}.json', 'w', encoding='utf-8') as out:
                    json.dump(results, out, indent=2, ensure_ascii=False)

                print(f"Finished parsing {page=}")
                time.sleep(4)
                break
            except:
                import traceback
                print(traceback.format_exc())

    driver.close()


main()
