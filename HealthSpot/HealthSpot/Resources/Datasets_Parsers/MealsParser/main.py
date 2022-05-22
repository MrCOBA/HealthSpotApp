from bs4 import BeautifulSoup
import requests
import json

URL = 'https://tvoirecepty.ru'
FIRST_DISHES_URL = URL + '/pervye-blyuda'
SECOND_DISHES_URL = URL + '/vtorye-blyuda'
SALADS_URL = URL + '/salaty'
PAGE_PARAM = '?page='

OUTPUT_FILENAME = 'dishes.json'

DISH_TYPES = ['первые блюда', 'вторые блюда', 'салаты']
MEAL_TYPES = ['завтрак', 'обед', 'ужин']

# URLS = [FIRST_DISHES_URL]
URLS = [FIRST_DISHES_URL, SECOND_DISHES_URL, SALADS_URL]

def read_dish(dish):
    dish_dic = {}

    dish_dic['title'] = dish.find('div', class_='recipe-title').text.strip()
    dish_dic['image'] = dish.find(class_='product-img').find('img')['data-href']

    link = dish.find('a', class_='recipes-link')['href']
    new_page = requests.get(URL + link)
    dish_dic['dish_url'] = URL + link

    soup = BeautifulSoup(new_page.text, "html.parser")
    time_cooking = soup.find(class_='cook-time').find(class_='bor').text.split()
    dish_dic['time_cooking'] = {}
    dish_dic['time_cooking']['duration'] = time_cooking[0]
    dish_dic['time_cooking']['unit'] = time_cooking[1]

    dish_dic['calorie'] = soup.find(class_='doughnutSummaryNumber').text
    dish_dic['protein'] = soup.find(class_='protein').text.split()[0]
    dish_dic['fat'] = soup.find(class_='fat').text.split()[0]
    dish_dic['carbohydrate'] = soup.find(class_='carbohydrates').text.split()[0]

    tags = soup.find(class_='tags-block').text.lower()
    dish_dic['dish_type'] = []
    for dish_type in DISH_TYPES:
        if dish_type in tags:
            dish_dic['dish_type'].append(dish_type)

    dish_dic['meal_type'] = []
    for meal_type in MEAL_TYPES:
        if meal_type in tags:
            dish_dic['meal_type'].append(meal_type)

    ingredients = soup.find(class_='ingredients-block')
    ingredients_lst = ingredients.find_all(class_='ingredient')
    dish_dic['ingredients'] = []
    for ingredient in ingredients_lst:
        dish_dic['ingredients'].append({})
        dish_dic['ingredients'][-1]['name'] = ingredient.find(class_='name').text.strip()

        amount = ingredient.find(class_='pull-right').text.strip().split('\n')
        if len(amount) == 2:
            dish_dic['ingredients'][-1]['amount'] = amount[0]
            dish_dic['ingredients'][-1]['units'] = amount[1]
        elif len(amount) == 1:
            dish_dic['ingredients'][-1]['units'] = amount[0]


    instructions = soup.find(class_='instructions')
    instructions_lst = instructions.find_all(class_='instruction')
    dish_dic['instructions'] = []
    for instruction in instructions_lst:
        skip_count = 0
        for i in instruction.text:
            if i.isdigit() or i == ' ' or i == '\n':
                skip_count += 1
            else:
                break
        dish_dic['instructions'].append(instruction.text[skip_count:].strip())

    return dish_dic


def read_dishes(url):
    first_dish = None
    stop = False
    page_num = 0
    dish_dic = []

    while not stop:
        page = requests.get(url + PAGE_PARAM + str(page_num))

        soup = BeautifulSoup(page.text, "html.parser")

        dishes = soup.find_all('div', class_='product-description-brd')

        for dish in dishes:
            result = read_dish(dish)
            if first_dish is None:
                first_dish = result['dish_url']
            elif first_dish == result['dish_url']:
                stop = True
                break
            dish_dic.append(result)
        page_num += 1
    print(page_num)
    return dish_dic


if __name__ == '__main__':

    dish_dic = []
    
    for url in URLS:
        dish_dic.extend(read_dishes(url))

    with open(OUTPUT_FILENAME, 'w', encoding='utf-8') as f:
        f.write(json.dumps(dish_dic, ensure_ascii=False))

