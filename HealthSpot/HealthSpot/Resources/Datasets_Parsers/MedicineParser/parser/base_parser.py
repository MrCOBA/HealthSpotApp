import re
from typing import Dict

from bs4 import BeautifulSoup
from selenium.webdriver.chrome.webdriver import WebDriver


class BaseParser:
    MATCH_ALL = r'.*'

    def __like(self, string):
        """
        Return a compiled regular expression that matches the given
        string with any prefix and postfix, e.g. if string = "hello",
        the returned regex matches r".*hello.*"
        """
        string_ = string
        if not isinstance(string_, str):
            string_ = str(string_)
        regex = self.MATCH_ALL + re.escape(string_) + self.MATCH_ALL
        return re.compile(regex, flags=re.DOTALL)

    def _find_by_text(self, soup, text, tag, **kwargs):
        """
        Find the tag in soup that matches all provided kwargs, and contains the
        text.

        If no match is found, return None.
        If more than one match is found, raise ValueError.
        """
        elements = soup.find_all(tag, **kwargs)
        matches = []
        for element in elements:
            if element.find(text=self.__like(text), recursive=False):
                matches.append(element)
        if len(matches) > 1:
            raise ValueError("Too many matches:\n" + "\n".join(matches))
        elif len(matches) == 0:
            return None
        else:
            return matches[0]

    def parse(self, soup: BeautifulSoup):
        '''
        Returns parsed info, different for each parser
        :param soup:
        :return:
        '''
        raise NotImplementedError

    def load_page(self, driver: WebDriver, url: str):
        raise NotImplementedError

